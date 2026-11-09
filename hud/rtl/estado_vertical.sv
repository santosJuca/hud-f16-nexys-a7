// Altitude Q8 ft, velocidade Q16 ft/s. Referencia lenta: BMP085.
// Modelo limitado a +/-30 graus; calibrar imovel e aproximadamente plano.
module estado_vertical #(
    parameter integer CAL_LOG2 = 6,
    parameter integer DEADZONE = 100
)(
    input logic clk,
    input logic sensor_ok, atitude_valida,
    input logic signed [15:0] accel_x, accel_y, accel_z,
    input logic signed [31:0] pitch_q10, roll_q10,
    input logic dt_valid,
    input logic [31:0] dt_cycles,
    input logic baro_ok, baro_nova,
    input logic [16:0] altitude_baro_ft,
    output wire [16:0] altitude_ft,
    output logic signed [13:0] vel_vertical_fpm = 0,
    output wire valido,
    output logic altitude_disponivel = 0,
    output logic calibrado = 0,
    output logic atualizado = 0
);
    logic [16:0] referencia_baro=0;
    logic referencia_valida=0;
    logic signed [31:0] altitude_q8=0;
    logic signed [31:0] velocidade_q16=0;
    assign altitude_ft = altitude_q8[24:8];
    wire faixa = pitch_q10 >= -30720 && pitch_q10 <= 30720 &&
                 roll_q10 >= -30720 && roll_q10 <= 30720;
    wire pronto = sensor_ok && atitude_valida && faixa && baro_ok && referencia_valida;
    assign valido = pronto && calibrado;
    typedef enum logic [3:0] {IDLE, PROJECAO, ACEL, MULT, DELTA, VELOCIDADE, POS_MULT, POSICAO, PUBLICA} estado_t;
    estado_t estado=IDLE;
    wire iniciar = estado == IDLE && pronto && dt_valid &&
                   dt_cycles > 0 && dt_cycles <= 10000000;
    wire signed [18:0] vertical_counts;
    wire proj_valido;
    projecao_vertical u_projecao (
        .clk(clk), .sensor_ok(pronto), .atualizar(iniciar),
        .accel_x(accel_x), .accel_y(accel_y), .accel_z(accel_z),
        .pitch_q10(pitch_q10), .roll_q10(roll_q10),
        .vertical_counts(vertical_counts), .valido(proj_valido)
    );
    logic [CAL_LOG2-1:0] contagem=0;
    logic signed [31:0] soma=0;
    logic signed [18:0] gravidade_bias=16384;
    logic plano=0;
    logic [53:0] tempo_produto=0;
    logic signed [16:0] tempo_q16=0;
    logic signed [19:0] linear_counts=0;
    logic signed [31:0] acel_q16=0, erro_q8=0;
    logic signed [48:0] produto_dv=0, produto_correcao=0, produto_pos=0;
    logic signed [31:0] dv=0, corr_v=0, corr_h=0;
    wire signed [31:0] erro_novo = $signed({1'b0,altitude_baro_ft,8'b0}) - altitude_q8;
    wire signed [31:0] erro_novo_limitado = erro_novo > 8192 ? 8192 : erro_novo < -8192 ? -8192 : erro_novo;
    wire signed [31:0] erro_baro = $signed({1'b0,referencia_baro,8'b0}) - altitude_q8;
    wire signed [31:0] erro_limitado = erro_baro > 8192 ? 8192 : erro_baro < -8192 ? -8192 : erro_baro;
    wire signed [33:0] v_proxima = $signed(velocidade_q16) + $signed(dv) + $signed(corr_v);
    wire signed [33:0] h_proxima = $signed(altitude_q8) + (produto_pos >>> 24) + $signed(corr_h);
    wire signed [19:0] sem_gravidade = $signed(vertical_counts) - $signed(gravidade_bias);
    wire signed [47:0] acel_produto = linear_counts * 17'sd32947;
    wire signed [37:0] fpm_produto = velocidade_q16 * 6'sd30; // metade; shift 15 equivale a *60/65536
    always_ff @(posedge clk) begin
        atualizado <= 0;
        vel_vertical_fpm <= fpm_produto >>> 15;
        if (!baro_ok) referencia_valida <= 0;
        else if (baro_nova && altitude_baro_ft <= 99999) begin
            referencia_baro <= altitude_baro_ft;
            referencia_valida <= 1;
        end
        if (baro_ok && baro_nova && altitude_baro_ft <= 99999 && !altitude_disponivel) begin
            altitude_q8 <= $signed({1'b0,altitude_baro_ft,8'b0});
            altitude_disponivel <= 1;
        end
        if ((!pronto || !calibrado) && baro_ok && baro_nova &&
            altitude_baro_ft <= 99999 && altitude_disponivel)
            altitude_q8 <= altitude_q8 + (erro_novo_limitado >>> 4);
        if (!pronto) begin
            estado <= IDLE;
            velocidade_q16 <= 0;
            vel_vertical_fpm <= 0;
            // Recalibrar apos perda de MPU/atitude; sem integrar lacunas.
            calibrado <= 0;
            soma <= 0; contagem <= 0;
        end else begin
            case (estado)
                IDLE: if (iniciar) begin
                    // dt em segundos Q16, erro da constante < 0,00001%.
                    tempo_produto <= dt_cycles * 22'd2814750;
                    plano <= pitch_q10 >= -2048 && pitch_q10 <= 2048 &&
                             roll_q10 >= -2048 && roll_q10 <= 2048 &&
                             accel_x > -1000 && accel_x < 1000 &&
                             accel_y > -1000 && accel_y < 1000;
                    estado <= PROJECAO;
                end
                PROJECAO: if (proj_valido) begin
                    tempo_q16 <= $signed({1'b0,tempo_produto[47:32]});
                    if (!calibrado) begin
                        if (plano && vertical_counts >= 14000 && vertical_counts <= 18000) begin
                            if (&contagem) begin
                                gravidade_bias <= (soma + vertical_counts) >>> CAL_LOG2;
                                calibrado <= 1; soma <= 0; contagem <= 0;
                            end else begin soma <= soma + vertical_counts; contagem <= contagem + 1'b1; end
                        end else begin soma <= 0; contagem <= 0; end
                        estado <= IDLE;
                    end else begin
                        linear_counts <= sem_gravidade > -DEADZONE && sem_gravidade < DEADZONE ? 20'sd0 : sem_gravidade;
                        erro_q8 <= erro_limitado;
                        estado <= ACEL;
                    end
                end
                ACEL: begin
                    // 9,80665 m/s2 * 3,28084 ft/m * 65536 / 16384.
                    acel_q16 <= acel_produto >>> 8;
                    estado <= MULT;
                end
                MULT: begin
                    produto_dv <= acel_q16 * tempo_q16;
                    produto_correcao <= erro_q8 * tempo_q16;
                    estado <= DELTA;
                end
                DELTA: begin
                    dv <= produto_dv >>> 16;
                    corr_v <= produto_correcao >>> 10; // k_v=0,25/s2, Q8 -> Q16
                    corr_h <= produto_correcao >>> 16; // k_h=1/s
                    estado <= VELOCIDADE;
                end
                VELOCIDADE: begin
                    if (v_proxima > 6553600) velocidade_q16 <= 6553600;
                    else if (v_proxima < -6553600) velocidade_q16 <= -6553600;
                    else velocidade_q16 <= v_proxima[31:0];
                    estado <= POS_MULT;
                end
                POS_MULT: begin
                    produto_pos <= velocidade_q16 * tempo_q16;
                    estado <= POSICAO;
                end
                POSICAO: begin
                    if (h_proxima < 0) begin altitude_q8 <= 0; velocidade_q16 <= 0; end
                    else if (h_proxima > 25599744) begin altitude_q8 <= 25599744; velocidade_q16 <= 0; end
                    else altitude_q8 <= h_proxima[31:0];
                    estado <= PUBLICA;
                end
                PUBLICA: begin atualizado <= 1; estado <= IDLE; end
                default: estado <= IDLE;
            endcase
        end
    end
endmodule
