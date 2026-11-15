// =========================================================
// simbologia_vga.sv
// Simbologia básica do display de avião.
// Geração procedural por coordenadas.
// =========================================================

module simbologia_vga #(parameter bit FULL_ATTITUDE=0,
                       parameter bit SEPARATE_FLIGHT_X=0,
                          parameter bit SEPARATE_FLIGHT_COORDS=0,
                          parameter bit HIGH_BANK_PITCH_DECLUTTER=1'b1) (
    input  logic [9:0] pixel_x,
    input  logic [9:0] pixel_y,
    input  logic       video_on,
    // Optional moving flight-layer coordinates; original testbenches use defaults.
    input wire [9:0] flight_pixel_y,
    input wire [9:0] flight_pixel_x=10'd0,
    input wire flight_video_on,
    input wire signed [15:0] attitude_sine,attitude_cosine,
    input wire signed [10:0] attitude_pitch_px,
    input  logic [9:0] horizonte_y, // Centro limitado a 160..320.
    input  logic signed [9:0] roll_q8, // Inclinação: pixels por 256 pixels em X.
    input  logic [8:0] heading_deg,
    input  logic [9:0] alvo_x,
    input  logic [8:0] alvo_y,
    output logic       horizonte_on,
    output logic       altitude_on,
    output logic       direcao_on,
    output logic       alvo_on,
    output logic       velocidade_on,
    output logic       horizonte_borda_on
);

    logic horizonte_esq;
    logic horizonte_dir;
    logic marcas_superiores;
    logic marcas_inferiores;

    logic faixa_longa;
    logic faixa_media;
    logic faixa_curta;

    logic tracos_longo;
    logic tracos_medio;
    logic tracos_curto;
    logic signed [21:0] delta_x;
    logic signed [21:0] delta_y;
    logic signed [21:0] pitch_x_local;
    logic signed [21:0] pitch_y_local;
    // Números da escada de pitch.
    logic pitch_numeros;
    logic pitch_campo;
    logic pitch_minus, pitch_zero, pitch_zero_halo, pitch_ladder_halo;
    logic signed [21:0] pitch_abs_x;
    integer pitch_extent;
    localparam logic [14:0] ZERO_GLYPH = 15'b111_101_101_101_111;
    logic [14:0] pitch_bitmap;

    integer pitch_coluna;
    integer pitch_linha;
    integer pitch_nivel;
    integer pitch_codigo;

    logic altitude_barra;
    logic altitude_marcas;
    logic graduacao_y_altitude;
    logic graduacao_y_velocidade;
    logic velocidade_barra;
    logic velocidade_marcas;

    logic direcao_barra;
    logic direcao_marcas;
    logic direcao_centro;

    logic direcao_cardinal;
    logic [24:0] cardinal_bitmap;

    // Heading tape: aritmetica com largura limitada.
    // Evita divisao/modulo integer de 32 bits no caminho pixel -> RGB.
    logic signed [10:0] direcao_offset_grau;
    logic signed [10:0] direcao_grau;
    logic               direcao_alinhado;
    logic               direcao_marca_10;
    logic               direcao_marca_30;

    integer card_x_n;
    integer card_x_e;
    integer card_x_s;
    integer card_x_w;

    integer card_coluna;
    integer card_linha;
    integer card_codigo;

    logic alvo_sup_esq;
    logic alvo_sup_dir;
    logic alvo_inf_esq;
    logic alvo_inf_dir;

    localparam int ALVO_M = 24;
    localparam int CANTO  = 10;
    function automatic logic [14:0] glifo_pitch(input integer codigo);
        case (codigo)
            0: glifo_pitch = 15'b111_101_101_101_111;
            1: glifo_pitch = 15'b010_110_010_010_111;
            2: glifo_pitch = 15'b111_001_111_100_111;
            3: glifo_pitch = 15'b111_001_111_001_111;
            4: glifo_pitch = 15'b101_101_111_001_001;
            5: glifo_pitch = 15'b111_100_111_001_111;
            6: glifo_pitch = 15'b111_100_111_101_111;
            7: glifo_pitch = 15'b111_001_010_010_010;
            8: glifo_pitch = 15'b111_101_111_101_111;
            9: glifo_pitch = 15'b111_101_111_001_111;
            default: glifo_pitch = '0;
        endcase
    endfunction

    function automatic logic [24:0] glifo_cardinal(input integer codigo);
    case (codigo)
            // N
            0: glifo_cardinal = 25'b10001_11001_10101_10011_10001;

            // E
            1: glifo_cardinal = 25'b11111_10000_11110_10000_11111;

            // S
            2: glifo_cardinal = 25'b11111_10000_11111_00001_11111;

            // W
            3: glifo_cardinal = 25'b10001_10001_10101_11111_10001;

            default: glifo_cardinal = '0;
        endcase
    endfunction

    function automatic integer posicao_cardinal(
        input integer alvo,
        input integer atual
    );
        integer diferenca;
        begin
            diferenca = alvo - atual;

            if (diferenca > 180)
                diferenca = diferenca - 360;
            else if (diferenca < -180)
                diferenca = diferenca + 360;

            // 4 pixels por grau.
            posicao_cardinal = 320 + diferenca * 4;
        end
    endfunction

    // Simplifica apenas os numeros da ladder perto de bank vertical.
    // cos(60 graus) = 0.5 em Q14. Inclui ambos os sentidos.
    // O sinal vem do pacote de atitude aplicado no blanking VGA.
    // Nao modifica horizonte, marcas ou instrumentos fixos.
    wire sideways_bank =
        FULL_ATTITUDE && HIGH_BANK_PITCH_DECLUTTER &&
        attitude_cosine >= -16'sd8192 &&
        attitude_cosine <=  16'sd8192;

    // The heading tape, altitude/speed bars and numeric instruments use
    // unmodified pixel_y/video_on. Only horizon, pitch and target use flight_y.
    wire [9:0] render_flight_x = SEPARATE_FLIGHT_X ? flight_pixel_x : pixel_x;
    wire [9:0] render_flight_y =
        SEPARATE_FLIGHT_COORDS ? flight_pixel_y : pixel_y;
    wire render_flight_on =
        SEPARATE_FLIGHT_COORDS ? flight_video_on : video_on;
    wire signed [21:0] attitude_x,attitude_y;
    wire signed [21:0] attitude_screen_y = attitude_y +
        $signed({{11{attitude_pitch_px[10]}},attitude_pitch_px});
    horizonte_atitude u_geometry(.pixel_x(render_flight_x),.pixel_y(render_flight_y),
        .sine(attitude_sine),.cosine(attitude_cosine),.pitch_px(attitude_pitch_px),
        .local_x(attitude_x),.local_y(attitude_y));
    always_comb begin
            direcao_cardinal = 1'b0;
            cardinal_bitmap = '0;

            direcao_offset_grau = '0;
            direcao_grau        = '0;
            direcao_alinhado    = 1'b0;
            direcao_marca_10    = 1'b0;
            direcao_marca_30    = 1'b0;

            card_x_n = 0;
            card_x_e = 0;
            card_x_s = 0;
            card_x_w = 0;

            card_coluna = 0;
            card_linha = 0;
            card_codigo = 4;
            pitch_numeros = 1'b0;
            pitch_campo   = 1'b0;
            pitch_minus = 1'b0;
            pitch_zero = 1'b0;
            pitch_zero_halo = 1'b0;
            pitch_ladder_halo = 1'b0;
            pitch_extent = 0;
            pitch_abs_x = 0;
            pitch_bitmap  = '0;

            pitch_coluna = 0;
            pitch_linha  = 0;
            pitch_nivel  = 0;
            pitch_codigo = 0;
        // -------------------------------------------------
        // Horizonte artificial
        // -------------------------------------------------

        // roll_q8 representa o banco da aeronave:
        //   positivo = banco para a direita.
        //
        // O horizonte representa uma referencia estabilizada no mundo.
        // Por isso sua inclinacao visual ocorre no sentido oposto ao
        // roll da aeronave, como em um horizonte artificial convencional.
        delta_x = $signed({12'b0, render_flight_x}) - 22'sd320;
        delta_y = $signed({12'b0, render_flight_y}) -
                  $signed({12'b0, horizonte_y});

        // Coordenadas locais Q8: rotação aproximada com escala uniforme.
        pitch_x_local = FULL_ATTITUDE ? attitude_x : delta_x - ((delta_y * 22'(roll_q8)) >>> 8);
        pitch_y_local = FULL_ATTITUDE ? attitude_y : delta_y + ((delta_x * 22'(roll_q8)) >>> 8);

            // -------------------------------------------------
            // Números da escada de pitch
            // 10..90 em atitude completa; legado10..40 nos dois lados.
            // Os dois eixos usam a mesma transformação do horizonte.
            // -------------------------------------------------

        if (
            ((pitch_x_local >= -22'sd94) && (pitch_x_local < -22'sd78)) ||
            ((pitch_x_local >= 22'sd78) && (pitch_x_local < 22'sd94))
        ) begin

            if ((pitch_x_local >= -22'sd94) && (pitch_x_local < -22'sd78))
                pitch_coluna = int'(pitch_x_local) + 94;
            else
                pitch_coluna = int'(pitch_x_local) - 78;

            // +10°
            if (
                (pitch_y_local >= -22'sd45) &&
                (pitch_y_local <= -22'sd36)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 1;
                pitch_linha = int'(pitch_y_local + 22'sd45) / 2;
            end

            // +20°
            else if (
                (pitch_y_local >= -22'sd85) &&
                (pitch_y_local <= -22'sd76)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 2;
                pitch_linha = int'(pitch_y_local + 22'sd85) / 2;
            end

            // +30°
            else if (
                (pitch_y_local >= -22'sd125) &&
                (pitch_y_local <= -22'sd116)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 3;
                pitch_linha = int'(pitch_y_local + 22'sd125) / 2;
            end

            // +40°
            else if (
                (pitch_y_local >= -22'sd165) &&
                (pitch_y_local <= -22'sd156)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 4;
                pitch_linha = int'(pitch_y_local + 22'sd165) / 2;
            end

            // -10°
            else if (
                (pitch_y_local >= 22'sd35) &&
                (pitch_y_local <= 22'sd44)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 1;
                pitch_linha = int'(pitch_y_local - 22'sd35) / 2;
            end

            // -20°
            else if (
                (pitch_y_local >= 22'sd75) &&
                (pitch_y_local <= 22'sd84)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 2;
                pitch_linha = int'(pitch_y_local - 22'sd75) / 2;
            end

            // -30°
            else if (
                (pitch_y_local >= 22'sd115) &&
                (pitch_y_local <= 22'sd124)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 3;
                pitch_linha = int'(pitch_y_local - 22'sd115) / 2;
            end

            // -40°
            else if (
                (pitch_y_local >= 22'sd155) &&
                (pitch_y_local <= 22'sd164)
            ) begin
                pitch_campo = 1'b1;
                pitch_nivel = 4;
                pitch_linha = int'(pitch_y_local - 22'sd155) / 2;
            end

            // Escada completa so no renderizador de atitude vetorial.
            // Os limites constantes sao desenrolados na sintese, sem divisor variavel.
            if (FULL_ATTITUDE) begin
                for (integer nivel=5; nivel<=9; nivel=nivel+1) begin
                    if (pitch_y_local >= -22'(nivel*40+5) &&
                        pitch_y_local <= -22'(nivel*40-4)) begin
                        pitch_campo = 1'b1;
                        pitch_nivel = nivel;
                        pitch_linha = int'(pitch_y_local + 22'(nivel*40+5)) / 2;
                    end
                    if (pitch_y_local >= 22'(nivel*40-5) &&
                        pitch_y_local <= 22'(nivel*40+4)) begin
                        pitch_campo = 1'b1;
                        pitch_nivel = nivel;
                        pitch_linha = int'(pitch_y_local - 22'(nivel*40-5)) / 2;
                    end
                end
            end

            // Bank proximo da vertical: mantem numeros multiplos de20 graus.
            // Oculta o numero inteiro antes de sua caixa de glifo tocar a borda da janela.
            if (pitch_campo && (!FULL_ATTITUDE ||
                (pitch_x_local >= 0 &&
                 int'($signed(attitude_pitch_px)) + (pitch_y_local < 0 ? -pitch_nivel*40 : pitch_nivel*40) >= -75 &&
                 int'($signed(attitude_pitch_px)) + (pitch_y_local < 0 ? -pitch_nivel*40 : pitch_nivel*40) <= 75)) &&
                !(sideways_bank &&
                  (pitch_nivel[0] == 1'b1))) begin

                // Primeiro digito: dezenas de10 a90; segundo digito: zero.
                // Segundo dígito: 0
                if (pitch_coluna < 8)
                    pitch_codigo = pitch_nivel;
                else
                    pitch_codigo = 0;

                pitch_bitmap = glifo_pitch(pitch_codigo);

                if ((pitch_coluna % 8) < 6)
                    pitch_numeros =
                        pitch_bitmap[
                            14 -
                            (
                                pitch_linha * 3 +
                                ((pitch_coluna % 8) / 2)
                            )
                        ];
            end
        end

        horizonte_esq =
            (pitch_y_local >= -22'sd1) &&
            (pitch_y_local <= 22'sd1) &&
            (pitch_x_local >= -22'sd220) &&
            (pitch_x_local <= -22'sd20);

        horizonte_dir =
            (pitch_y_local >= -22'sd1) &&
            (pitch_y_local <= 22'sd1) &&
            (pitch_x_local >= 22'sd20) &&
            (pitch_x_local <= 22'sd220);

        // -------------------------------------------------
// Escada de pitch
//
// Convenção visual temporária:
// 40 pixels = 10 graus.
//
// Acima do horizonte: linhas contínuas.
// Abaixo do horizonte: linhas tracejadas.
// -------------------------------------------------

// ±10° e ±20°
faixa_longa =
    ((pitch_x_local >= -22'sd70) && (pitch_x_local <= -22'sd20)) ||
    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd70));

// ±30°
faixa_media =
    ((pitch_x_local >= -22'sd55) && (pitch_x_local <= -22'sd20)) ||
    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd55));

// ±40°
faixa_curta =
    ((pitch_x_local >= -22'sd42) && (pitch_x_local <= -22'sd20)) ||
    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd42));


// Tracejado longo
tracos_longo =
    ((pitch_x_local >= -22'sd70) && (pitch_x_local <= -22'sd60)) ||
    ((pitch_x_local >= -22'sd50) && (pitch_x_local <= -22'sd40)) ||
    ((pitch_x_local >= -22'sd30) && (pitch_x_local <= -22'sd20)) ||

    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd30)) ||
    ((pitch_x_local >= 22'sd40) && (pitch_x_local <= 22'sd50)) ||
    ((pitch_x_local >= 22'sd60) && (pitch_x_local <= 22'sd70));

// Tracejado médio
tracos_medio =
    ((pitch_x_local >= -22'sd55) && (pitch_x_local <= -22'sd47)) ||
    ((pitch_x_local >= -22'sd37) && (pitch_x_local <= -22'sd29)) ||
    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd28)) ||
    ((pitch_x_local >= 22'sd38) && (pitch_x_local <= 22'sd46));

// Tracejado curto
tracos_curto =
    ((pitch_x_local >= -22'sd42) && (pitch_x_local <= -22'sd36)) ||
    ((pitch_x_local >= -22'sd26) && (pitch_x_local <= -22'sd20)) ||
    ((pitch_x_local >= 22'sd20) && (pitch_x_local <= 22'sd26)) ||
    ((pitch_x_local >= 22'sd36) && (pitch_x_local <= 22'sd42));


// Pitch positivo
marcas_superiores =

    // +10°
    (faixa_longa &&
        (pitch_y_local >= -22'sd40) &&
        (pitch_y_local <= -22'sd39))

    ||

    // +20°
    (faixa_longa &&
        (pitch_y_local >= -22'sd80) &&
        (pitch_y_local <= -22'sd79))

    ||

    // +30°
    (faixa_media &&
        (pitch_y_local >= -22'sd120) &&
        (pitch_y_local <= -22'sd119))

    ||

    // +40°
    (faixa_curta &&
        (pitch_y_local >= -22'sd160) &&
        (pitch_y_local <= -22'sd159));


// Pitch negativo
marcas_inferiores =

    // -10°
    (tracos_longo &&
        (pitch_y_local >= 22'sd40) &&
        (pitch_y_local <= 22'sd41))

    ||

    // -20°
    (tracos_longo &&
        (pitch_y_local >= 22'sd80) &&
        (pitch_y_local <= 22'sd81))

    ||

    // -30°
    (tracos_medio &&
        (pitch_y_local >= 22'sd120) &&
        (pitch_y_local <= 22'sd121))

    ||

    // -40°
    (tracos_curto &&
        (pitch_y_local >= 22'sd160) &&
        (pitch_y_local <= 22'sd161));

        // Horizonte destacado; graduacoes curtas na janela central.
        // Apenas esta geometria muda. O angulo e as amostras permanecem iguais.
        if (FULL_ATTITUDE) begin
            pitch_abs_x = pitch_x_local < 0 ? -pitch_x_local : pitch_x_local;
            horizonte_esq = pitch_y_local >= -22'sd1 && pitch_y_local <= 22'sd1 &&
                pitch_x_local >= -22'sd156 && pitch_x_local <= -22'sd20;
            horizonte_dir = pitch_y_local >= -22'sd1 && pitch_y_local <= 22'sd1 &&
                pitch_x_local >= 22'sd20 && pitch_x_local <= 22'sd156;
            pitch_zero_halo = (pitch_abs_x >= 19 && pitch_abs_x <= 157 &&
                              pitch_y_local >= -2 && pitch_y_local <= 2);
            if (pitch_x_local >= 166 && pitch_x_local <= 171 &&
                pitch_y_local >= -5 && pitch_y_local <= 4)
                pitch_zero = ZERO_GLYPH[14-((int'(pitch_y_local)+5)/2)*3-
                                           ((int'(pitch_x_local)-166)/2)];
            marcas_superiores = 1'b0;
            marcas_inferiores = 1'b0;
            for (integer nivel=1; nivel<=9; nivel=nivel+1) begin
                pitch_extent = nivel == 1 ? 64 : nivel == 2 ? 52 : 42;
                marcas_superiores = marcas_superiores ||
                    (pitch_abs_x >= 20 && pitch_abs_x <= pitch_extent &&
                     pitch_y_local >= -22'(nivel*40) && pitch_y_local <= -22'(nivel*40-1));
                marcas_inferiores = marcas_inferiores ||
                    (pitch_abs_x <= pitch_extent &&
                     ((pitch_abs_x >= 20 && pitch_abs_x <= 28) ||
                      (pitch_abs_x >= 38 && pitch_abs_x <= 46) ||
                      (pitch_abs_x >= 56 && pitch_abs_x <= 64)) &&
                     pitch_y_local >= 22'(nivel*40) && pitch_y_local <= 22'(nivel*40+1));
                // Um pixel de contorno em torno das linhas, com as lacunas do tracejado.
                pitch_ladder_halo = pitch_ladder_halo ||
                    (pitch_abs_x >= 19 && pitch_abs_x <= pitch_extent+1 &&
                     pitch_y_local >= -22'(nivel*40+1) && pitch_y_local <= -22'(nivel*40-2)) ||
                    (pitch_abs_x <= pitch_extent+1 &&
                     ((pitch_abs_x >= 19 && pitch_abs_x <= 29) ||
                      (pitch_abs_x >= 37 && pitch_abs_x <= 47) ||
                      (pitch_abs_x >= 55 && pitch_abs_x <= 65)) &&
                     pitch_y_local >= 22'(nivel*40-1) && pitch_y_local <= 22'(nivel*40+2));
                if (!(sideways_bank && nivel%2 == 1)) begin
                    if (int'($signed(attitude_pitch_px))+nivel*40 >= -75 &&
                        int'($signed(attitude_pitch_px))+nivel*40 <= 75) begin
                        pitch_minus = pitch_minus ||
                            (pitch_x_local >= 68 && pitch_x_local <= 74 &&
                             pitch_y_local >= 22'(nivel*40-1) && pitch_y_local <= 22'(nivel*40));
                    end
                end
            end
        end

        // A referencia zero pode continuar visivel fora da janela compacta.
        // Nunca a prendemos a borda nem inventamos um horizonte substituto.
        horizonte_on = render_flight_on &&
            (horizonte_esq || horizonte_dir || pitch_zero ||
             ((marcas_superiores || marcas_inferiores || pitch_numeros || pitch_minus) &&
              (!FULL_ATTITUDE || (attitude_screen_y >= -84 && attitude_screen_y <= 84))));
        horizonte_borda_on = FULL_ATTITUDE && render_flight_on && !horizonte_on &&
            (pitch_zero_halo || (pitch_ladder_halo &&
             attitude_screen_y >= -84 && attitude_screen_y <= 84));

        // -------------------------------------------------
        // Escala de altitude
        // -------------------------------------------------

        // Altitude:
        // 50 pixels representam 200 ft.
        // A regiao central fica livre para a janela do valor atual.
        altitude_barra =
            (pixel_x >= 559) &&
            (pixel_x <= 561) &&
            (pixel_y >= 90) &&
            (pixel_y <= 390);

        graduacao_y_altitude =
            (
                ((pixel_y >=  89) && (pixel_y <=  91)) ||
                ((pixel_y >= 139) && (pixel_y <= 141)) ||
                ((pixel_y >= 189) && (pixel_y <= 191)) ||
                ((pixel_y >= 289) && (pixel_y <= 291)) ||
                ((pixel_y >= 339) && (pixel_y <= 341)) ||
                ((pixel_y >= 389) && (pixel_y <= 391))
            );

        altitude_marcas =
            (pixel_x >= 548) &&
            (pixel_x <= 561) &&
            graduacao_y_altitude;

        altitude_on =
            video_on &&
            (altitude_barra || altitude_marcas);


        // Velocidade permanece exatamente com a geometria anterior.
        velocidade_barra =
            (pixel_x >= 79) &&
            (pixel_x <= 81) &&
            (pixel_y >= 100) &&
            (pixel_y <= 380);

        graduacao_y_velocidade =
            (
                ((pixel_y >=  99) && (pixel_y <= 101)) ||
                ((pixel_y >= 139) && (pixel_y <= 141)) ||
                ((pixel_y >= 179) && (pixel_y <= 181)) ||
                ((pixel_y >= 219) && (pixel_y <= 221)) ||
                ((pixel_y >= 259) && (pixel_y <= 261)) ||
                ((pixel_y >= 299) && (pixel_y <= 301)) ||
                ((pixel_y >= 339) && (pixel_y <= 341)) ||
                ((pixel_y >= 379) && (pixel_y <= 381))
            );

        velocidade_marcas =
            (pixel_x >= 79) &&
            (pixel_x <= 92) &&
            graduacao_y_velocidade;

        velocidade_on =
            video_on &&
            (velocidade_barra || velocidade_marcas);

        // -------------------------------------------------
        // Indicador de direção
        // -------------------------------------------------
        // -------------------------------------------------
        // Heading tape / indicador de direção
        //
        // 4 pixels = 1 grau.
        // Marcas a cada 10 graus.
        // Marcas maiores a cada 30 graus.
        // N/E/S/W acompanham o heading.
        // O indicador central permanece fixo.
        // -------------------------------------------------

        direcao_barra =
    (pixel_y >= 59) &&
    (pixel_y <= 61) &&
    (pixel_x >= 160) &&
    (pixel_x <= 480);

// Somente pixels alinhados na grade de 4 pixels podem ser
// marcas de grau. Como 320 tambem e multiplo de quatro,
// pixel_x[1:0] substitui exatamente (pixel_x - 320) % 4.
direcao_alinhado =
    (pixel_x >= 160) &&
    (pixel_x <= 480) &&
    (pixel_x[1:0] == 2'b00);

// Para os pixels alinhados, a divisao por quatro e exata.
// O shift elimina o divisor integer de 32 bits do caminho VGA.
direcao_offset_grau =
    ($signed({1'b0, pixel_x}) - 11'sd320) >>> 2;

direcao_grau =
    $signed({2'b00, heading_deg}) +
    direcao_offset_grau;

// A janela visivel representa somente +/-40 graus,
// portanto um unico ajuste resolve o wrap 0/359.
if (direcao_grau < 0)
    direcao_grau = direcao_grau + 11'sd360;
else if (direcao_grau >= 11'sd360)
    direcao_grau = direcao_grau - 11'sd360;

// Decodificador exato das marcas.
// Remove %10 e %30 do caminho combinacional por pixel.
if (direcao_alinhado) begin
    case (direcao_grau)

        // Marcas principais: multiplos de 30 graus.
        11'sd0,
        11'sd30,
        11'sd60,
        11'sd90,
        11'sd120,
        11'sd150,
        11'sd180,
        11'sd210,
        11'sd240,
        11'sd270,
        11'sd300,
        11'sd330: begin
            direcao_marca_10 = 1'b1;
            direcao_marca_30 = 1'b1;
        end

        // Demais marcas de 10 graus.
        11'sd10,
        11'sd20,
        11'sd40,
        11'sd50,
        11'sd70,
        11'sd80,
        11'sd100,
        11'sd110,
        11'sd130,
        11'sd140,
        11'sd160,
        11'sd170,
        11'sd190,
        11'sd200,
        11'sd220,
        11'sd230,
        11'sd250,
        11'sd260,
        11'sd280,
        11'sd290,
        11'sd310,
        11'sd320,
        11'sd340,
        11'sd350:
            direcao_marca_10 = 1'b1;

        default: begin
            direcao_marca_10 = 1'b0;
            direcao_marca_30 = 1'b0;
        end
    endcase
end

direcao_marcas =
    direcao_alinhado &&
    direcao_marca_10 &&
    (
        (
            direcao_marca_30 &&
            (pixel_y >= 48) &&
            (pixel_y <= 61)
        )
        ||
        (
            !direcao_marca_30 &&
            (pixel_y >= 53) &&
            (pixel_y <= 61)
        )
    );

// Indicador fixo no centro da tela.
direcao_centro =
    (pixel_y >= 62) &&
    (pixel_y <= 68) &&
    (
        (
            (pixel_x >= 316) &&
            (pixel_x <= 324) &&
            (pixel_y == 62)
        )
        ||
        (
            (pixel_x >= 318) &&
            (pixel_x <= 322) &&
            (pixel_y >= 63) &&
            (pixel_y <= 65)
        )
        ||
        (
            (pixel_x == 320) &&
            (pixel_y >= 66) &&
            (pixel_y <= 68)
        )
    );

// Posição horizontal dos quatro pontos cardeais.
card_x_n = posicao_cardinal(0,   int'(heading_deg));
card_x_e = posicao_cardinal(90,  int'(heading_deg));
card_x_s = posicao_cardinal(180, int'(heading_deg));
card_x_w = posicao_cardinal(270, int'(heading_deg));

// Letras 5x5 ampliadas 2x.
    if ((pixel_x >= 160) && (pixel_x <= 480) &&
        (pixel_y >= 36) && (pixel_y < 46)) begin

        if (
            (int'(pixel_x) >= card_x_n - 5) &&
            (int'(pixel_x) <  card_x_n + 5)
        ) begin
            card_codigo = 0;
            card_coluna = (int'(pixel_x) - (card_x_n - 5)) / 2;
        end
        else if (
            (int'(pixel_x) >= card_x_e - 5) &&
            (int'(pixel_x) <  card_x_e + 5)
        ) begin
            card_codigo = 1;
            card_coluna = (int'(pixel_x) - (card_x_e - 5)) / 2;
        end
        else if (
            (int'(pixel_x) >= card_x_s - 5) &&
            (int'(pixel_x) <  card_x_s + 5)
        ) begin
            card_codigo = 2;
            card_coluna = (int'(pixel_x) - (card_x_s - 5)) / 2;
        end
        else if (
            (int'(pixel_x) >= card_x_w - 5) &&
            (int'(pixel_x) <  card_x_w + 5)
        ) begin
            card_codigo = 3;
            card_coluna = (int'(pixel_x) - (card_x_w - 5)) / 2;
        end

        if (card_codigo < 4) begin
            card_linha = (int'(pixel_y) - 36) / 2;
            cardinal_bitmap = glifo_cardinal(card_codigo);

            direcao_cardinal =
                cardinal_bitmap[
                    24 - (card_linha * 5 + card_coluna)
                ];
        end
    end

        direcao_on =
            video_on &&
    (
        direcao_barra ||
        direcao_marcas ||
        direcao_centro ||
        direcao_cardinal
    );

        // -------------------------------------------------
        // Marcador de alvo
        // -------------------------------------------------

        alvo_sup_esq =
            (
                (
                    (render_flight_x >= alvo_x - ALVO_M) &&
                    (render_flight_x <= alvo_x - ALVO_M + CANTO) &&
                    (render_flight_y >= alvo_y - ALVO_M) &&
                    (render_flight_y <= alvo_y - ALVO_M + 1)
                )
                ||
                (
                    (render_flight_x >= alvo_x - ALVO_M) &&
                    (render_flight_x <= alvo_x - ALVO_M + 1) &&
                    (render_flight_y >= alvo_y - ALVO_M) &&
                    (render_flight_y <= alvo_y - ALVO_M + CANTO)
                )
            );

        alvo_sup_dir =
            (
                (
                    (render_flight_x >= alvo_x + ALVO_M - CANTO) &&
                    (render_flight_x <= alvo_x + ALVO_M) &&
                    (render_flight_y >= alvo_y - ALVO_M) &&
                    (render_flight_y <= alvo_y - ALVO_M + 1)
                )
                ||
                (
                    (render_flight_x >= alvo_x + ALVO_M - 1) &&
                    (render_flight_x <= alvo_x + ALVO_M) &&
                    (render_flight_y >= alvo_y - ALVO_M) &&
                    (render_flight_y <= alvo_y - ALVO_M + CANTO)
                )
            );

        alvo_inf_esq =
            (
                (
                    (render_flight_x >= alvo_x - ALVO_M) &&
                    (render_flight_x <= alvo_x - ALVO_M + CANTO) &&
                    (render_flight_y >= alvo_y + ALVO_M - 1) &&
                    (render_flight_y <= alvo_y + ALVO_M)
                )
                ||
                (
                    (render_flight_x >= alvo_x - ALVO_M) &&
                    (render_flight_x <= alvo_x - ALVO_M + 1) &&
                    (render_flight_y >= alvo_y + ALVO_M - CANTO) &&
                    (render_flight_y <= alvo_y + ALVO_M)
                )
            );

        alvo_inf_dir =
            (
                (
                    (render_flight_x >= alvo_x + ALVO_M - CANTO) &&
                    (render_flight_x <= alvo_x + ALVO_M) &&
                    (render_flight_y >= alvo_y + ALVO_M - 1) &&
                    (render_flight_y <= alvo_y + ALVO_M)
                )
                ||
                (
                    (render_flight_x >= alvo_x + ALVO_M - 1) &&
                    (render_flight_x <= alvo_x + ALVO_M) &&
                    (render_flight_y >= alvo_y + ALVO_M - CANTO) &&
                    (render_flight_y <= alvo_y + ALVO_M)
                )
            );

        alvo_on =
            render_flight_on &&
            (
                alvo_sup_esq ||
                alvo_sup_dir ||
                alvo_inf_esq ||
                alvo_inf_dir
            );

    end

endmodule
