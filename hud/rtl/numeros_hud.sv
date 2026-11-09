// =========================================================
// numeros_hud.sv
//
// Fitas numericas do HUD NORMAL.
//
// O valor atual permanece fixo no centro da fita:
//   velocidade -> janela esquerda
//   altitude   -> janela direita
//
// As graduacoes ficam arredondadas para facilitar leitura:
//   velocidade: passos de 20 kt
//   altitude:   passos de 200 ft
//
// Este modulo nao participa do estilo CACA.
// =========================================================

module numeros_hud (
    input  logic [9:0]  pixel_x,
    input  logic [9:0]  pixel_y,
    input  logic        video_on,
    input  logic [9:0]  velocidade_kt,
    input  logic [16:0] altitude_ft,
    output logic        numeros_on
);

    function automatic logic [14:0] glifo(
        input integer codigo
    );
        case (codigo)
            0:  glifo = 15'b111_101_101_101_111;
            1:  glifo = 15'b010_110_010_010_111;
            2:  glifo = 15'b111_001_111_100_111;
            3:  glifo = 15'b111_001_111_001_111;
            4:  glifo = 15'b101_101_111_001_001;
            5:  glifo = 15'b111_100_111_001_111;
            6:  glifo = 15'b111_100_111_101_111;
            7:  glifo = 15'b111_001_010_010_010;
            8:  glifo = 15'b111_101_111_101_111;
            9:  glifo = 15'b111_101_111_001_111;

            // K
            10: glifo = 15'b101_101_110_101_101;

            // T
            11: glifo = 15'b111_010_010_010_010;

            // F
            12: glifo = 15'b111_100_110_100_100;

            default:
                glifo = '0;
        endcase
    endfunction


    // Binario -> BCD sem divisor variavel em hardware.
    function automatic logic [19:0] decimal(
        input logic [16:0] binario
    );
        logic [19:0] bcd;

        begin
            bcd = '0;

            for (
                integer bit_atual = 16;
                bit_atual >= 0;
                bit_atual = bit_atual - 1
            ) begin

                for (
                    integer d = 0;
                    d < 5;
                    d = d + 1
                )
                    if (bcd[d*4 +: 4] >= 5)
                        bcd[d*4 +: 4] =
                            bcd[d*4 +: 4] + 4'd3;

                bcd = {
                    bcd[18:0],
                    binario[bit_atual]
                };
            end

            return bcd;
        end
    endfunction


    integer coluna;
    integer linha;
    integer valor;
    integer digitos;
    integer caractere;
    integer divisor;
    integer codigo;

    integer marca;
    integer deslocamento;

    integer vel_base;
    integer alt_base;

    logic campo;
    logic unidade;

    logic caixa_velocidade;
    logic caixa_altitude;

    logic [14:0] bitmap;
    logic [19:0] bcd;


    always_comb begin

        coluna      = 0;
        linha       = 0;
        valor       = 0;
        digitos     = 0;
        caractere   = 0;
        divisor     = 1;
        codigo      = 15;

        marca       = 0;
        deslocamento = 0;

        campo       = 1'b0;
        unidade     = 1'b0;

        bitmap      = '0;
        bcd         = '0;

        numeros_on  = 1'b0;


        // -------------------------------------------------
        // Bases arredondadas das fitas.
        //
        // Exemplo:
        // altitude 11220 -> base 11200
        // velocidade 280 -> base 280
        // -------------------------------------------------

        vel_base =
            ((int'(velocidade_kt) + 10) / 20) * 20;

        alt_base =
            ((int'(altitude_ft) + 100) / 200) * 200;


        // -------------------------------------------------
        // Janelas dos valores atuais.
        //
        // A barra vertical continua imediatamente ao lado.
        // Portanto nao precisamos alterar simbologia_vga.
        // -------------------------------------------------

        caixa_velocidade =
            video_on &&
            (
                // corpo
                (
                    (pixel_x >= 42) &&
                    (pixel_x <= 74) &&
                    (
                        (pixel_y == 228) ||
                        (pixel_y == 252)
                    )
                )

                ||

                (
                    (pixel_y >= 228) &&
                    (pixel_y <= 252) &&
                    (
                        (pixel_x == 42) ||
                        (pixel_x == 74)
                    )
                )

                ||

                // seta apontando para a fita
                (
                    (pixel_x >= 75) &&
                    (pixel_x <= 79) &&
                    (
                        (
                            pixel_y ==
                            235 + (int'(pixel_x) - 75)
                        )
                        ||
                        (
                            pixel_y ==
                            245 - (int'(pixel_x) - 75)
                        )
                    )
                )
            );


        caixa_altitude =
            video_on &&
            (
                // corpo
                (
                    (pixel_x >= 568) &&
                    (pixel_x <= 616) &&
                    (
                        (pixel_y == 228) ||
                        (pixel_y == 252)
                    )
                )

                ||

                (
                    (pixel_y >= 228) &&
                    (pixel_y <= 252) &&
                    (
                        (pixel_x == 568) ||
                        (pixel_x == 616)
                    )
                )

                ||

                // seta apontando para a fita
                (
                    (pixel_x >= 561) &&
                    (pixel_x <= 567) &&
                    (
                        (
                            pixel_y ==
                            240 - (int'(pixel_x) - 560)
                        )
                        ||
                        (
                            pixel_y ==
                            240 + (int'(pixel_x) - 560)
                        )
                    )
                )
            );


        // -------------------------------------------------
        // FITA DE VELOCIDADE
        //
        // Marcas existentes:
        // y = 100, 140, 180, 220,
        //     260, 300, 340, 380
        //
        // A janela atual fica fixa em y ~= 240.
        // -------------------------------------------------

        if (
            (pixel_x >= 46) &&
            (pixel_x < 70)
        ) begin

            coluna  = int'(pixel_x) - 46;
            digitos = 3;

            for (
                integer m = 0;
                m < 8;
                m = m + 1
            ) begin

                if (
                    (int'(pixel_y) >= 95 + 40*m) &&
                    (int'(pixel_y) <  105 + 40*m)
                ) begin

                    campo = 1'b1;
                    linha =
                        (int'(pixel_y) - 95 - 40*m) / 2;

                    case (m)
                        0: deslocamento =  4;
                        1: deslocamento =  3;
                        2: deslocamento =  2;
                        3: deslocamento =  1;
                        4: deslocamento = -1;
                        5: deslocamento = -2;
                        6: deslocamento = -3;
                        default:
                           deslocamento = -4;
                    endcase

                    valor =
                        vel_base +
                        deslocamento * 20;
                end
            end


            // Valor atual dentro da janela.
            if (
                (pixel_y >= 235) &&
                (pixel_y < 245)
            ) begin

                campo   = 1'b1;
                linha   = (int'(pixel_y) - 235) / 2;
                valor   = int'(velocidade_kt);
                digitos = 3;
            end
        end


        // -------------------------------------------------
        // FITA DE ALTITUDE
        //
        // 200 ft por graduacao.
        //
        // A regiao central fica livre para o valor atual.
        // Graduacoes:
        //
        //   y= 90 -> base + 600 ft
        //   y=140 -> base + 400 ft
        //   y=190 -> base + 200 ft
        //
        //   y=240 -> valor atual
        //
        //   y=290 -> base - 200 ft
        //   y=340 -> base - 400 ft
        //   y=390 -> base - 600 ft
        //
        // Assim a escala mantém proporcao constante:
        // 50 pixels = 200 ft.
        // -------------------------------------------------

        else if (
            (pixel_x >= 572) &&
            (pixel_x < 612)
        ) begin

            coluna  = int'(pixel_x) - 572;
            digitos = 5;

            for (
                integer m = 0;
                m < 6;
                m = m + 1
            ) begin

                marca = 0;
                deslocamento = 0;

                case (m)

                    0: begin
                        marca = 85;
                        deslocamento = 3;
                    end

                    1: begin
                        marca = 135;
                        deslocamento = 2;
                    end

                    2: begin
                        marca = 185;
                        deslocamento = 1;
                    end

                    3: begin
                        marca = 285;
                        deslocamento = -1;
                    end

                    4: begin
                        marca = 335;
                        deslocamento = -2;
                    end

                    default: begin
                        marca = 385;
                        deslocamento = -3;
                    end

                endcase


                if (
                    (int'(pixel_y) >= marca) &&
                    (int'(pixel_y) < marca + 10)
                ) begin

                    campo = 1'b1;

                    linha =
                        (int'(pixel_y) - marca) / 2;

                    valor =
                        alt_base +
                        deslocamento * 200;

                end
            end


            // Valor exato do BMP085 permanece fixo no centro.
            if (
                (pixel_y >= 235) &&
                (pixel_y < 245)
            ) begin

                campo   = 1'b1;
                linha   = (int'(pixel_y) - 235) / 2;
                valor   = int'(altitude_ft);
                digitos = 5;

            end
        end


        // -------------------------------------------------
        // Unidades discretas na parte inferior.
        // -------------------------------------------------

        if (
            (pixel_x >= 50) &&
            (pixel_x < 66) &&
            (pixel_y >= 402) &&
            (pixel_y < 412)
        ) begin

            campo     = 1'b1;
            unidade   = 1'b1;
            coluna    = int'(pixel_x) - 50;
            linha     = (int'(pixel_y) - 402) / 2;
            caractere = coluna / 8;

            if (caractere == 0)
                codigo = 10; // K
            else
                codigo = 11; // T
        end

        else if (
            (pixel_x >= 584) &&
            (pixel_x < 600) &&
            (pixel_y >= 424) &&
            (pixel_y < 434)
        ) begin

            campo     = 1'b1;
            unidade   = 1'b1;
            coluna    = int'(pixel_x) - 584;
            linha     = (int'(pixel_y) - 424) / 2;
            caractere = coluna / 8;

            if (caractere == 0)
                codigo = 12; // F
            else
                codigo = 11; // T
        end


        // -------------------------------------------------
        // Renderizacao dos números.
        // -------------------------------------------------

        if (
            campo &&
            !unidade
        ) begin

            if (
                (valor < 0) ||
                (valor > ((digitos == 5) ? 99999 : 999))
            ) begin

                campo = 1'b0;

            end
            else begin

                caractere = coluna / 8;

                bcd = decimal(17'(valor));

                case (digitos - 1 - caractere)

                    4: begin
                        divisor = 10000;
                        codigo  = int'(bcd[19:16]);
                    end

                    3: begin
                        divisor = 1000;
                        codigo  = int'(bcd[15:12]);
                    end

                    2: begin
                        divisor = 100;
                        codigo  = int'(bcd[11:8]);
                    end

                    1: begin
                        divisor = 10;
                        codigo  = int'(bcd[7:4]);
                    end

                    default: begin
                        divisor = 1;
                        codigo  = int'(bcd[3:0]);
                    end

                endcase


                // Sem zeros desnecessários à esquerda.
                if (
                    (caractere < digitos - 1) &&
                    (valor < divisor)
                )
                    codigo = 15;
            end
        end


        bitmap = glifo(codigo);


        if (
            video_on &&
            campo &&
            ((coluna % 8) < 6)
        )
            numeros_on =
                bitmap[
                    14 -
                    (
                        linha * 3 +
                        ((coluna % 8) / 2)
                    )
                ];


        // Moldura da janela sempre tem prioridade visual.
        if (
            caixa_velocidade ||
            caixa_altitude
        )
            numeros_on = 1'b1;

    end

endmodule
