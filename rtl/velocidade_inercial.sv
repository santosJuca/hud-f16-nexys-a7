// =========================================================
// velocidade_inercial.sv
//
// Estimativa demonstrativa de velocidade pelo MPU6050.
//
// NAO representa airspeed real.
// A saida deve ser descrita como:
//   "velocidade inercial estimada"
//
// MPU6050:
//   accel configurado em +/-2 g -> 16384 LSB/g
//
// O eixo longitudinal usado neste projeto e accel_y.
//
// Compensacao aproximada da gravidade:
//
//   pitch do HUD = 4 px/grau
//
// Para pequenos angulos:
//   g*sin(theta) ~= g*theta
//
// Isso resulta em aproximadamente 72 counts por pixel
// de pitch.
//
// Integracao:
//
//   v[n+1] = v[n] + a*dt
//
// A acumulacao interna usa Q16 em knots.
// =========================================================

module velocidade_inercial #(
    parameter integer CAL_LOG2 = 6,
    parameter integer DEADZONE = 300
)(
    input logic clk,

    input logic sensor_ok,
    input logic amostra_nova,

    input logic signed [15:0] accel_forward,

    // Pitch vindo da fusao MPU:
    // 4 pixels = 1 grau.
    input logic signed [10:0] pitch_px,
    input logic atitude_valida,

    // Intervalo real entre amostras medido a 100 MHz.
    input logic        dt_valid,
    input logic [31:0] dt_cycles,

    output logic calibrado = 1'b0,
    output logic valido,

    output logic [9:0] velocidade_kt
);

    localparam integer CAL_SAMPLES =
        (1 << CAL_LOG2);

    localparam logic [18:0] DEADZONE_U =
        DEADZONE;

    // 500 knots em Q16.
    localparam logic signed [55:0] MAX_Q16 =
        56'sd32768000;

    // -----------------------------------------------------
    // Calibracao do zero longitudinal
    // -----------------------------------------------------

    logic [CAL_LOG2-1:0] cal_count = '0;

    logic signed [23:0] soma_accel = 24'sd0;
    logic signed [15:0] bias_accel = 16'sd0;

    wire signed [23:0] accel_ext =
        {{8{accel_forward[15]}}, accel_forward};

    wire signed [23:0] soma_proxima =
        soma_accel + accel_ext;

    wire signed [23:0] media_accel =
        soma_proxima >>> CAL_LOG2;


    // -----------------------------------------------------
    // Remove bias
    // -----------------------------------------------------

    wire signed [16:0] accel_sem_bias =
        $signed({accel_forward[15], accel_forward}) -
        $signed({bias_accel[15], bias_accel});


    // -----------------------------------------------------
    // Compensacao aproximada de gravidade longitudinal
    //
    // 72 = 64 + 8
    // -----------------------------------------------------

    wire signed [18:0] pitch_ext =
        {{8{pitch_px[10]}}, pitch_px};

    wire signed [18:0] gravidade_pitch =
        (pitch_ext <<< 6) +
        (pitch_ext <<< 3);

    wire signed [18:0] accel_linear =
        $signed({
            {2{accel_sem_bias[16]}},
            accel_sem_bias
        }) -
        gravidade_pitch;


    // -----------------------------------------------------
    // Deadzone
    // -----------------------------------------------------

    // O deadzone NAO e aplicado aqui.
    //
    // accel_linear primeiro atravessa um registrador.
    // Isso quebra o caminho combinacional longo:
    // fusao/pitch -> compensacao -> deadzone -> DSP.


    // -----------------------------------------------------
    // Pipeline da integracao
    // -----------------------------------------------------

    logic signed [18:0] accel_s1 = 19'sd0;
    logic        [31:0] dt_s1    = 32'd0;

    // Deadzone calculado somente depois do corte de pipeline.
    wire [18:0] accel_s1_abs =
        accel_s1[18]
            ? $unsigned(-accel_s1)
            : $unsigned(accel_s1);

    wire movimento_s1 =
        (accel_s1_abs > DEADZONE_U);

    logic valido_s1 = 1'b0;
    logic valido_s2 = 1'b0;
    logic valido_s3 = 1'b0;

    logic movimento_s2 = 1'b0;
    logic movimento_s3 = 1'b0;
    logic signed [55:0] delta_s3 = 56'sd0;

    // 19 bits * 33 bits = 52 bits.
    logic signed [51:0] produto_s2 = 52'sd0;

    wire signed [32:0] dt_s1_signed =
        $signed({1'b0, dt_s1});


    // -----------------------------------------------------
    // Conversao para knots Q16
    //
    // dv_Q16 aproximado:
    //
    // accel_counts * dt_cycles * 13 / 2^24
    //
    // Erro da constante ~1,6%, aceitavel para demonstracao.
    //
    // Multiplicacao por 13:
    //   x*8 + x*4 + x
    // -----------------------------------------------------

    wire signed [55:0] produto_ext =
        {{4{produto_s2[51]}}, produto_s2};

    wire signed [55:0] produto_x13 =
        (produto_ext <<< 3) +
        (produto_ext <<< 2) +
         produto_ext;

    wire signed [55:0] delta_v_q16 =
        produto_x13 >>> 24;


    // -----------------------------------------------------
    // Acumulador de velocidade
    // -----------------------------------------------------

    logic signed [31:0] velocidade_q16 = 32'sd0;

    wire signed [55:0] velocidade_ext =
        {{24{velocidade_q16[31]}},
          velocidade_q16};

    wire signed [55:0] velocidade_proxima =
        velocidade_ext + delta_s3;


    assign valido =
        calibrado &&
        atitude_valida &&
        sensor_ok;

    assign velocidade_kt =
        velocidade_q16[25:16];


    always_ff @(posedge clk) begin

        if (!sensor_ok) begin

            calibrado <= 1'b0;
            cal_count <= '0;

            soma_accel <= 24'sd0;
            bias_accel <= 16'sd0;

            velocidade_q16 <= 32'sd0;

            accel_s1 <= 19'sd0;
            dt_s1 <= 32'd0;

            produto_s2 <= 52'sd0;

            valido_s1 <= 1'b0;
            valido_s2 <= 1'b0;
            movimento_s2 <= 1'b0;
            movimento_s3 <= 1'b0;
            valido_s3 <= 1'b0;
            delta_s3 <= 56'sd0;

        end
        else begin

            valido_s1 <= 1'b0;
            valido_s2 <= valido_s1;
            valido_s3 <= valido_s2;

            // ---------------------------------------------
            // Calibracao
            // ---------------------------------------------

            if (!calibrado) begin

                velocidade_q16 <= 32'sd0;

                valido_s1 <= 1'b0;
                valido_s2 <= 1'b0;
                movimento_s2 <= 1'b0;
                movimento_s3 <= 1'b0;
                valido_s3 <= 1'b0;

                if (amostra_nova) begin

                    if (cal_count == CAL_SAMPLES - 1) begin

                        bias_accel <= media_accel[15:0];

                        soma_accel <= 24'sd0;
                        cal_count <= '0;

                        calibrado <= 1'b1;

                    end
                    else begin

                        soma_accel <= soma_proxima;
                        cal_count <= cal_count + 1'b1;

                    end
                end

            end
            else begin

                // -----------------------------------------
                // Estagio 1
                // -----------------------------------------

                // dt_valid chega apos a publicacao da amostra
                // do MPU. accel_forward permanece estavel, portanto
                // a integracao deve ser disparada pelo dt valido.
                if (
                    dt_valid &&
                    atitude_valida
                ) begin

                    // Corte real do caminho critico.
                    accel_s1 <= accel_linear;
                    dt_s1 <= dt_cycles;

                    valido_s1 <= 1'b1;
                end


                // -----------------------------------------
                // Estagio 2
                // -----------------------------------------

                if (valido_s1) begin

                    produto_s2 <=
                        accel_s1 *
                        dt_s1_signed;

                    // Deadzone baseado em accel_s1 ja registrado.
                    movimento_s2 <= movimento_s1;

                end


                // -----------------------------------------
                // Estagio 3: separa conversao por 13 da soma/saturacao.
                // Preserva o disparo por dt_valid e a deadzone registrada.
                // -----------------------------------------

                if (valido_s2) begin
                    delta_s3 <= delta_v_q16;
                    movimento_s3 <= movimento_s2;
                end

                // -----------------------------------------
                // Estagio 4
                // Saturacao 0 .. 500 kt
                // -----------------------------------------

                if (valido_s3 && movimento_s3) begin

                    if (velocidade_proxima <= 0)
                        velocidade_q16 <= 32'sd0;

                    else if (velocidade_proxima >= MAX_Q16)
                        velocidade_q16 <= 32'sd32768000;

                    else
                        velocidade_q16 <=
                            velocidade_proxima[31:0];

                end
            end
        end
    end

endmodule
