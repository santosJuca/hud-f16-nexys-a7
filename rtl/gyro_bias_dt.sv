// =========================================================
// gyro_bias_dt.sv
//
// Calibracao do offset do giroscopio e medicao do intervalo
// real entre amostras validas.
//
// Esta etapa NAO integra angulo e NAO realiza fusao.
// =========================================================

module gyro_bias_dt #(
    parameter integer CAL_LOG2 = 6
)(
    input  logic clk,
    input  logic sensor_ok,
    input  logic amostra_nova,

    input  logic signed [15:0] gyro_x,
    input  logic signed [15:0] gyro_y,

    output logic calibrado = 1'b0,

    output logic signed [15:0] bias_x = 16'sd0,
    output logic signed [15:0] bias_y = 16'sd0,

    output logic signed [16:0] gyro_x_corr = 17'sd0,
    output logic signed [16:0] gyro_y_corr = 17'sd0,

    output logic [31:0] dt_cycles = 32'd0,
    output logic        dt_valid  = 1'b0
);

    localparam integer CAL_SAMPLES = (1 << CAL_LOG2);

    logic [CAL_LOG2-1:0] cal_count = '0;

    logic signed [23:0] sum_x = 24'sd0;
    logic signed [23:0] sum_y = 24'sd0;

    logic [31:0] ciclos_desde_amostra = 32'd0;
    logic referencia_temporal = 1'b0;

    wire signed [23:0] gyro_x_ext =
        {{8{gyro_x[15]}}, gyro_x};

    wire signed [23:0] gyro_y_ext =
        {{8{gyro_y[15]}}, gyro_y};

    wire signed [23:0] soma_x_proxima =
        sum_x + gyro_x_ext;

    wire signed [23:0] soma_y_proxima =
        sum_y + gyro_y_ext;

    wire signed [23:0] media_x =
        soma_x_proxima >>> CAL_LOG2;

    wire signed [23:0] media_y =
        soma_y_proxima >>> CAL_LOG2;

    always_comb begin
        if (calibrado) begin
            gyro_x_corr =
                $signed({gyro_x[15], gyro_x}) -
                $signed({bias_x[15], bias_x});

            gyro_y_corr =
                $signed({gyro_y[15], gyro_y}) -
                $signed({bias_y[15], bias_y});
        end
        else begin
            gyro_x_corr = 17'sd0;
            gyro_y_corr = 17'sd0;
        end
    end

    always_ff @(posedge clk) begin
        dt_valid <= 1'b0;

        if (!sensor_ok) begin
            calibrado <= 1'b0;
            cal_count <= '0;

            sum_x <= 24'sd0;
            sum_y <= 24'sd0;

            bias_x <= 16'sd0;
            bias_y <= 16'sd0;

            ciclos_desde_amostra <= 32'd0;
            referencia_temporal <= 1'b0;

            dt_cycles <= 32'd0;
        end
        else begin
            if (ciclos_desde_amostra != 32'hFFFF_FFFF)
                ciclos_desde_amostra <= ciclos_desde_amostra + 1'b1;

            if (amostra_nova) begin
                if (!calibrado) begin
                    if (cal_count == CAL_SAMPLES - 1) begin
                        bias_x <= media_x[15:0];
                        bias_y <= media_y[15:0];

                        sum_x <= 24'sd0;
                        sum_y <= 24'sd0;
                        cal_count <= '0;

                        calibrado <= 1'b1;

                        // A primeira amostra apos a calibracao
                        // estabelece uma nova referencia de tempo.
                        referencia_temporal <= 1'b0;
                        ciclos_desde_amostra <= 32'd0;
                    end
                    else begin
                        sum_x <= soma_x_proxima;
                        sum_y <= soma_y_proxima;
                        cal_count <= cal_count + 1'b1;
                    end
                end
                else begin
                    if (referencia_temporal) begin
                        dt_cycles <= ciclos_desde_amostra;
                        dt_valid <= 1'b1;
                    end
                    else begin
                        referencia_temporal <= 1'b1;
                    end

                    ciclos_desde_amostra <= 32'd0;
                end
            end
        end
    end

endmodule
