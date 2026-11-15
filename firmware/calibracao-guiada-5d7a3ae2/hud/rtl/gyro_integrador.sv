// =========================================================
// gyro_integrador.sv
//
// Integra a velocidade angular corrigida do giroscopio
// usando o intervalo real entre amostras.
//
// Configuracao:
//   clk        = 100 MHz
//   giroscopio = 131 LSB/(grau/s)
//   angulo_q10 = 1024 unidades/grau
//
// Conversao:
//
//   delta_q10 = gyro_corr * dt_cycles * 1024
//               ----------------------------
//                  131 * 100000000
//
// A divisao constante e aproximada em Q36:
//
//   1024 * 2^36 / (131 * 100000000) ~= 5372
//
//   5372 = 2^12 + 2^10 + 2^8 - 2^2
//
// A operacao foi dividida em pipeline para fechar timing
// a 100 MHz no Artix-7.
//
// Latencia:
//   estagio 1: gyro * dt
//   estagio 2: magnitude
//   estagio 3: escala Q36
//   estagio 4: acumulacao angular
//
// angulo_valid pulsa quando angulo_q10 recebe uma nova
// amostra integrada.
// =========================================================

module gyro_integrador (
    input  logic clk,
    input  logic sensor_ok,
    input  logic dt_valid,

    input  logic signed [16:0] gyro_corr,
    input  logic        [31:0] dt_cycles,

    output logic signed [31:0] angulo_q10 = 32'sd0,
    output logic               angulo_valid = 1'b0
);

    // -----------------------------------------------------
    // Pipeline
    // -----------------------------------------------------

    logic signed [63:0] produto_reg = 64'sd0;

    logic [63:0] magnitude_reg = 64'd0;
    logic        sinal_reg2 = 1'b0;

    logic [63:0] escalado_q36_reg = 64'd0;
    logic        sinal_reg3 = 1'b0;

    logic valid1 = 1'b0;
    logic valid2 = 1'b0;
    logic valid3 = 1'b0;

    // Mantem exatamente o mesmo truncamento da versao
    // anterior: bits acima de Q36 formam o incremento Q10.
    wire signed [31:0] incremento_mag =
        $signed({4'd0, escalado_q36_reg[63:36]});

    always_ff @(posedge clk) begin
        if (!sensor_ok) begin
            produto_reg      <= 64'sd0;
            magnitude_reg    <= 64'd0;
            escalado_q36_reg <= 64'd0;

            sinal_reg2 <= 1'b0;
            sinal_reg3 <= 1'b0;

            valid1 <= 1'b0;
            valid2 <= 1'b0;
            valid3 <= 1'b0;

            angulo_q10   <= 32'sd0;
            angulo_valid <= 1'b0;
        end
        else begin
            // Por padrao nao ha nova saida neste ciclo.
            angulo_valid <= 1'b0;

            // Propagacao do token valido pelo pipeline.
            valid1 <= dt_valid;
            valid2 <= valid1;
            valid3 <= valid2;

            // -------------------------------------------------
            // Estagio 1
            // gyro_corr * dt_cycles
            // -------------------------------------------------

            if (dt_valid) begin
                produto_reg <=
                    $signed(gyro_corr) *
                    $signed({1'b0, dt_cycles});
            end

            // -------------------------------------------------
            // Estagio 2
            // Valor absoluto do produto.
            // -------------------------------------------------

            if (valid1) begin
                sinal_reg2 <= produto_reg[63];

                if (produto_reg[63])
                    magnitude_reg <= (~produto_reg) + 64'd1;
                else
                    magnitude_reg <= produto_reg;
            end

            // -------------------------------------------------
            // Estagio 3
            // magnitude * 5372
            //
            // 5372 = 4096 + 1024 + 256 - 4
            // -------------------------------------------------

            if (valid2) begin
                sinal_reg3 <= sinal_reg2;

                escalado_q36_reg <=
                    (magnitude_reg << 12) +
                    (magnitude_reg << 10) +
                    (magnitude_reg << 8)  -
                    (magnitude_reg << 2);
            end

            // -------------------------------------------------
            // Estagio 4
            // Aplica sinal e acumula o incremento.
            // -------------------------------------------------

            if (valid3) begin
                if (sinal_reg3)
                    angulo_q10 <=
                        angulo_q10 - incremento_mag;
                else
                    angulo_q10 <=
                        angulo_q10 + incremento_mag;

                angulo_valid <= 1'b1;
            end
        end
    end

endmodule
