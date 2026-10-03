// =========================================================
// gyro_integrador.sv
//
// Integra a velocidade angular corrigida do giroscopio
// usando o intervalo real entre amostras.
//
// Configuracao do projeto:
//   clk              = 100 MHz
//   giroscopio       = 131 LSB/(grau/s)
//   angulo_q10       = 1024 unidades/grau
//
// Conversao:
//
//   delta_q10 = gyro_corr * dt_cycles * 1024
//               --------------------------------
//                       131 * 100000000
//
// A divisao constante e aproximada em Q36:
//
//   1024 * 2^36 / (131 * 100000000) ~= 5372
//
//   5372 = 2^12 + 2^10 + 2^8 - 2^2
//
// Assim a conversao usa shifts/somas, sem divisor.
//
// Esta etapa NAO realiza fusao com o acelerometro.
// =========================================================

module gyro_integrador (
    input  logic clk,
    input  logic sensor_ok,
    input  logic dt_valid,

    input  logic signed [16:0] gyro_corr,
    input  logic        [31:0] dt_cycles,

    output logic signed [31:0] angulo_q10 = 32'sd0
);

    // Produto gyro * tempo.
    //
    // dt_cycles recebe um bit zero adicional para permanecer
    // positivo durante a multiplicacao signed.
    wire signed [63:0] produto =
        $signed(gyro_corr) *
        $signed({1'b0, dt_cycles});

    wire [63:0] produto_bits = produto;

    // Usa magnitude para que o truncamento seja simetrico
    // para velocidades positivas e negativas.
    wire [63:0] magnitude =
        produto[63]
            ? (~produto_bits + 64'd1)
            : produto_bits;

    // magnitude * 5372:
    //
    // 5372 = 4096 + 1024 + 256 - 4
    wire [63:0] escalado_q36 =
        (magnitude << 12) +
        (magnitude << 10) +
        (magnitude << 8)  -
        (magnitude << 2);

    // Divisao por 2^36.
    wire [31:0] incremento_mag =
        {4'd0, escalado_q36[63:36]};

    wire signed [31:0] incremento_q10 =
        produto[63]
            ? -$signed(incremento_mag)
            :  $signed(incremento_mag);

    always_ff @(posedge clk) begin
        if (!sensor_ok)
            angulo_q10 <= 32'sd0;
        else if (dt_valid)
            angulo_q10 <= angulo_q10 + incremento_q10;
    end

endmodule
