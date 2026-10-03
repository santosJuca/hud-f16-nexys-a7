// =========================================================
// atitude_accel_fixa.sv
//
// Estimativa inicial de pitch e roll usando somente
// o acelerometro do GY-521.
//
// Mapeamento validado fisicamente:
//   pitch <- accel_y
//   roll  <- -accel_x
//
// A posicao inicial deve permanecer aproximadamente plana
// durante a calibracao.
//
// Filtro:
//   y[n] = y[n-1] + (x[n] - y[n-1]) / 4
//
// Esta etapa NAO integra o giroscopio.
// =========================================================

module atitude_accel_fixa #(
    parameter integer CAL_LOG2 = 6,
    parameter integer FILTER_SHIFT = 2
)(
    input  logic clk,
    input  logic sensor_ok,
    input  logic amostra_nova,

    input  logic signed [15:0] accel_x,
    input  logic signed [15:0] accel_y,
    input  logic signed [15:0] accel_z,

    output logic calibrado = 1'b0,
    output logic signed [10:0] pitch_px = 11'sd0,
    output logic signed [9:0]  roll_q8  = 10'sd0
);

    localparam integer CAL_SAMPLES = (1 << CAL_LOG2);

    logic [CAL_LOG2-1:0] cal_count = '0;

    logic signed [23:0] sum_x = 24'sd0;
    logic signed [23:0] sum_y = 24'sd0;

    logic signed [15:0] referencia_x = 16'sd0;
    logic signed [15:0] referencia_y = 16'sd0;

    logic signed [15:0] filtrado_x = 16'sd0;
    logic signed [15:0] filtrado_y = 16'sd0;

    wire signed [23:0] accel_x_ext =
        {{8{accel_x[15]}}, accel_x};

    wire signed [23:0] accel_y_ext =
        {{8{accel_y[15]}}, accel_y};

    wire signed [23:0] soma_x_proxima =
        sum_x + accel_x_ext;

    wire signed [23:0] soma_y_proxima =
        sum_y + accel_y_ext;

    wire signed [23:0] media_x =
        soma_x_proxima >>> CAL_LOG2;

    wire signed [23:0] media_y =
        soma_y_proxima >>> CAL_LOG2;

    // -----------------------------------------------------
    // Filtro IIR
    // -----------------------------------------------------

    wire signed [16:0] erro_filtro_x =
        $signed({accel_x[15], accel_x}) -
        $signed({filtrado_x[15], filtrado_x});

    wire signed [16:0] erro_filtro_y =
        $signed({accel_y[15], accel_y}) -
        $signed({filtrado_y[15], filtrado_y});

    wire signed [16:0] filtrado_x_proximo =
        $signed({filtrado_x[15], filtrado_x}) +
        (erro_filtro_x >>> FILTER_SHIFT);

    wire signed [16:0] filtrado_y_proximo =
        $signed({filtrado_y[15], filtrado_y}) +
        (erro_filtro_y >>> FILTER_SHIFT);

    // -----------------------------------------------------
    // Conversao para unidades usadas pelo HUD
    //
    // Pitch:
    //   accel_y positivo  -> pitch positivo
    //   accel_y negativo  -> pitch negativo
    //
    // Roll:
    //   accel_x negativo  -> roll positivo
    //   accel_x positivo  -> roll negativo
    // -----------------------------------------------------

    wire signed [17:0] pitch_delta =
        $signed({filtrado_y_proximo[16],
                 filtrado_y_proximo}) -
        $signed({{2{referencia_y[15]}},
                 referencia_y});

    wire signed [17:0] roll_delta =
        $signed({{2{referencia_x[15]}},
                 referencia_x}) -
        $signed({filtrado_x_proximo[16],
                 filtrado_x_proximo});

    // Aproximacao linear inicial.
    //
    // 8192 counts -> 64 px de pitch.
    // 8192 counts -> 128 unidades de roll.
    wire signed [17:0] pitch_scaled =
        pitch_delta >>> 7;

    wire signed [17:0] roll_scaled =
        roll_delta >>> 6;

    // accel_z permanece disponivel para a futura etapa
    // de validacao de gravidade/fusao com giroscopio.
    wire accel_z_usado = ^accel_z;

    always_ff @(posedge clk) begin
        if (!sensor_ok) begin
            calibrado <= 1'b0;
            cal_count <= '0;

            sum_x <= 24'sd0;
            sum_y <= 24'sd0;

            referencia_x <= 16'sd0;
            referencia_y <= 16'sd0;

            filtrado_x <= 16'sd0;
            filtrado_y <= 16'sd0;

            pitch_px <= 11'sd0;
            roll_q8 <= 10'sd0;
        end
        else if (amostra_nova) begin
            if (!calibrado) begin
                pitch_px <= 11'sd0;
                roll_q8 <= 10'sd0;

                if (cal_count == CAL_SAMPLES - 1) begin
                    referencia_x <= media_x[15:0];
                    referencia_y <= media_y[15:0];

                    filtrado_x <= media_x[15:0];
                    filtrado_y <= media_y[15:0];

                    sum_x <= 24'sd0;
                    sum_y <= 24'sd0;
                    cal_count <= '0;

                    calibrado <= 1'b1;
                end
                else begin
                    sum_x <= soma_x_proxima;
                    sum_y <= soma_y_proxima;
                    cal_count <= cal_count + 1'b1;
                end
            end
            else begin
                filtrado_x <= filtrado_x_proximo[15:0];
                filtrado_y <= filtrado_y_proximo[15:0];

                if (pitch_scaled > 18'sd80)
                    pitch_px <= 11'sd80;
                else if (pitch_scaled < -18'sd80)
                    pitch_px <= -11'sd80;
                else
                    pitch_px <= pitch_scaled[10:0];

                if (roll_scaled > 18'sd128)
                    roll_q8 <= 10'sd128;
                else if (roll_scaled < -18'sd128)
                    roll_q8 <= -10'sd128;
                else
                    roll_q8 <= roll_scaled[9:0];
            end
        end
    end

endmodule
