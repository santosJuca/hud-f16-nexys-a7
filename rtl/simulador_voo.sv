// Dinamica didatica de voo atualizada pelo tick de operacao (20 Hz por padrao).
// Pitch e roll sao angulos Q10; heading e mantido em graus Q8 para evitar saltos.
module simulador_voo #(
    parameter integer VELOCIDADE_CRUZEIRO = 280,
    parameter integer VELOCIDADE_MIN = 100,
    parameter integer VELOCIDADE_MAX = 600,
    parameter integer ALTITUDE_INICIAL = 36000,
    parameter integer ALTITUDE_MIN = 0,
    parameter integer ALTITUDE_MAX = 60000
) (
    input logic clk, reset, enable, tick,
    input logic attitude_valid,
    input logic signed [31:0] pitch_q10,
    input logic signed [31:0] roll_q10,
    input logic [8:0] heading_ref_deg,
    input logic heading_ref_valid,
    output logic [9:0] velocidade_kt = 10'(VELOCIDADE_CRUZEIRO),
    output logic [16:0] altitude_ft = 17'(ALTITUDE_INICIAL),
    output logic [8:0] heading_deg = 0
);
    localparam integer ALT_MIN_Q8 = ALTITUDE_MIN * 256;
    localparam integer ALT_MAX_Q8 = ALTITUDE_MAX * 256;
    localparam logic signed [17:0] HDG_TURN_Q8 = 18'sd92160;

    logic signed [31:0] altitude_q8 = ALTITUDE_INICIAL * 256;
    logic signed [31:0] velocidade_q8 = VELOCIDADE_CRUZEIRO * 256;
    logic signed [17:0] heading_q8 = 18'sd0;
    logic heading_iniciado = 0;
    logic signed [31:0] pitch_limit_q10, roll_limit_q10;
    logic signed [31:0] altitude_delta_q8;
    logic [15:0] roll_abs_q10;
    logic [15:0] roll_abs_reg = 16'd0;
    logic roll_neg_reg = 1'b0;
    logic [10:0] roll_div32;
    logic [26:0] roll_div5_mult;
    logic signed [9:0] heading_delta_q8 = 10'sd0;
    logic signed [17:0] heading_next_q8;

    function automatic signed [17:0] wrap_heading(input logic signed [17:0] value);
        if (value >= HDG_TURN_Q8) wrap_heading = value - HDG_TURN_Q8;
        else if (value < 0) wrap_heading = value + HDG_TURN_Q8;
        else wrap_heading = value;
    endfunction

    always_comb begin
        pitch_limit_q10 = pitch_q10;
        if (pitch_limit_q10 > 32'sd15360) pitch_limit_q10 = 32'sd15360;
        else if (pitch_limit_q10 < -32'sd15360) pitch_limit_q10 = -32'sd15360;

        roll_limit_q10 = roll_q10;
        if (roll_limit_q10 > 32'sd46080) roll_limit_q10 = 32'sd46080;
        else if (roll_limit_q10 < -32'sd46080) roll_limit_q10 = -32'sd46080;

        // Aproximacao em Q8: 150 fpm/grau a 20 Hz.
        // Diferenca maxima da quantizacao anterior: 1 unidade Q8.
        altitude_delta_q8 = pitch_limit_q10 / 32'sd32;
        // 0,5 grau/s por grau de inclinacao; em Q8, a cada tick de 50 ms.
        // Divisao exata por 160 no intervalo limitado do roll.
        // 160 = 32 * 5; 52429/2^18 implementa /5.
        roll_abs_q10 = (roll_limit_q10 < 0)
            ? 16'(-roll_limit_q10) : 16'(roll_limit_q10);
        roll_div32 = roll_abs_reg >> 5;
        roll_div5_mult = roll_div32 * 16'd52429;
        heading_next_q8 = wrap_heading(heading_q8 +
            ((attitude_valid) ? heading_delta_q8 : 18'sd0));
    end

    // Pipeline independente do tick de 20 Hz.
    // Estagio 1: magnitude e sinal do roll.
    // Estagio 2: incremento angular em Q8.
    always_ff @(posedge clk) begin
        if (reset || !enable) begin
            roll_abs_reg <= 16'd0;
            roll_neg_reg <= 1'b0;
            heading_delta_q8 <= 10'sd0;
        end else begin
            roll_abs_reg <= roll_abs_q10;
            roll_neg_reg <= (roll_limit_q10 < 0);
            heading_delta_q8 <= roll_neg_reg
                ? -$signed({1'b0, roll_div5_mult[26:18]})
                :  $signed({1'b0, roll_div5_mult[26:18]});
        end
    end

    always_ff @(posedge clk) begin
        if (reset || !enable) begin
            velocidade_q8 <= VELOCIDADE_CRUZEIRO * 256;
            altitude_q8 <= ALTITUDE_INICIAL * 256;
            heading_q8 <= 0;
            heading_iniciado <= 0;
            velocidade_kt <= 10'(VELOCIDADE_CRUZEIRO);
            altitude_ft <= 17'(ALTITUDE_INICIAL);
            heading_deg <= 0;
        end else if (tick) begin
            if (!heading_iniciado) begin
                if (heading_ref_valid && heading_ref_deg < 360) begin
                    heading_q8 <= $signed({1'b0, heading_ref_deg, 8'b0});
                    heading_deg <= heading_ref_deg;
                    heading_iniciado <= 1;
                end else begin
                    heading_q8 <= 0;
                    heading_deg <= 0;
                end
            end else if (attitude_valid) begin
                heading_q8 <= heading_next_q8;
            end

            if (attitude_valid) begin
                if (altitude_delta_q8 != 0) begin
                    altitude_q8 <= altitude_q8 + altitude_delta_q8;
                    if (altitude_delta_q8 > 0 && velocidade_q8 > VELOCIDADE_MIN * 256)
                        velocidade_q8 <= velocidade_q8 - 1;
                    else if (altitude_delta_q8 < 0 && velocidade_q8 < VELOCIDADE_MAX * 256)
                        velocidade_q8 <= velocidade_q8 + 1;
                end else if (velocidade_q8 < VELOCIDADE_CRUZEIRO * 256) begin
                    velocidade_q8 <= velocidade_q8 + 1;
                end else if (velocidade_q8 > VELOCIDADE_CRUZEIRO * 256) begin
                    velocidade_q8 <= velocidade_q8 - 1;
                end
            end

            if (altitude_q8 < ALT_MIN_Q8) altitude_q8 <= ALT_MIN_Q8;
            else if (altitude_q8 > ALT_MAX_Q8) altitude_q8 <= ALT_MAX_Q8;
            if (velocidade_q8 < VELOCIDADE_MIN * 256) velocidade_q8 <= VELOCIDADE_MIN * 256;
            else if (velocidade_q8 > VELOCIDADE_MAX * 256) velocidade_q8 <= VELOCIDADE_MAX * 256;

            altitude_ft <= 17'(altitude_q8 >>> 8);
            velocidade_kt <= 10'(velocidade_q8 >>> 8);
            if (heading_iniciado)
                heading_deg <= (heading_next_q8 + 18'sd128 >= HDG_TURN_Q8) ?
                    9'd0 : 9'((heading_next_q8 + 18'sd128) >>> 8);
        end
    end
endmodule
