// =========================================================
// controle_manche.sv
//
// KY-023 -> comandos proporcionais de pitch e roll.
//
// Pipeline:
//   1. delta em relacao ao centro
//   2. deadzone + magnitude
//   3. escala proporcional
//   4. saturacao + saida
//
// A pipeline evita caminho combinacional longo entre XADC
// e entrada_hud.
//
// Limites:
//   pitch = -40 ... +40 pixels
//   roll  = -64 ... +64 q8
// =========================================================

module controle_manche #(
    parameter integer DEADZONE   = 180,
    parameter integer CALIB_BITS = 25
)(
    input  logic clk,
    input  logic [11:0] x_raw,
    input  logic [11:0] y_raw,

    output logic calibrado = 1'b0,
    output logic signed [10:0] pitch_cmd = 11'sd0,
    output logic signed [9:0]  roll_cmd  = 10'sd0
);

    localparam logic [12:0] DEADZONE_U = DEADZONE;

    logic [11:0] centro_x = 12'd2048;
    logic [11:0] centro_y = 12'd2048;

    logic [CALIB_BITS-1:0] calib_count = '0;

    // Estagio 1
    logic signed [12:0] delta_x_reg = '0;
    logic signed [12:0] delta_y_reg = '0;

    // Estagio 2
    logic [12:0] mag_x_reg = '0;
    logic [12:0] mag_y_reg = '0;
    logic sign_x_reg = 1'b0;
    logic sign_y_reg = 1'b0;

    // Estagio 3
    logic [15:0] pitch_num_reg = '0;
    logic [17:0] roll_num_reg  = '0;

    logic sign_x_prod = 1'b0;
    logic sign_y_prod = 1'b0;

    wire [6:0] pitch_mag_scaled = pitch_num_reg[15:9];
    wire [7:0] roll_mag_scaled  = roll_num_reg[17:10];

    always_ff @(posedge clk) begin

        // -------------------------------------------------
        // CALIBRACAO
        // -------------------------------------------------

        if (!calibrado) begin
            centro_x <= x_raw;
            centro_y <= y_raw;

            calib_count <= calib_count + 1'b1;

            if (&calib_count)
                calibrado <= 1'b1;

            delta_x_reg <= '0;
            delta_y_reg <= '0;

            mag_x_reg <= '0;
            mag_y_reg <= '0;

            sign_x_reg <= 1'b0;
            sign_y_reg <= 1'b0;

            pitch_num_reg <= '0;
            roll_num_reg  <= '0;

            sign_x_prod <= 1'b0;
            sign_y_prod <= 1'b0;

            pitch_cmd <= 11'sd0;
            roll_cmd  <= 10'sd0;
        end
        else begin

            // =============================================
            // ESTAGIO 1
            // Delta em relacao ao centro calibrado.
            // =============================================

            delta_x_reg <=
                $signed({1'b0, x_raw}) -
                $signed({1'b0, centro_x});

            delta_y_reg <=
                $signed({1'b0, y_raw}) -
                $signed({1'b0, centro_y});


            // =============================================
            // ESTAGIO 2
            // Deadzone, sinal e magnitude.
            // =============================================

            if (delta_x_reg[12]) begin
                sign_x_reg <= 1'b1;

                if ($unsigned(-delta_x_reg) > DEADZONE_U)
                    mag_x_reg <=
                        $unsigned(-delta_x_reg) - DEADZONE_U;
                else
                    mag_x_reg <= '0;
            end
            else begin
                sign_x_reg <= 1'b0;

                if ($unsigned(delta_x_reg) > DEADZONE_U)
                    mag_x_reg <=
                        $unsigned(delta_x_reg) - DEADZONE_U;
                else
                    mag_x_reg <= '0;
            end

            if (delta_y_reg[12]) begin
                sign_y_reg <= 1'b1;

                if ($unsigned(-delta_y_reg) > DEADZONE_U)
                    mag_y_reg <=
                        $unsigned(-delta_y_reg) - DEADZONE_U;
                else
                    mag_y_reg <= '0;
            end
            else begin
                sign_y_reg <= 1'b0;

                if ($unsigned(delta_y_reg) > DEADZONE_U)
                    mag_y_reg <=
                        $unsigned(delta_y_reg) - DEADZONE_U;
                else
                    mag_y_reg <= '0;
            end


            // =============================================
            // ESTAGIO 3
            //
            // Pitch:
            // magnitude * 11 / 512
            //
            // Roll:
            // magnitude * 35 / 1024
            //
            // Apenas shifts + somas com largura limitada.
            // =============================================

            pitch_num_reg <=
                ({3'b000, mag_x_reg} << 3) +
                ({3'b000, mag_x_reg} << 1) +
                 {3'b000, mag_x_reg};

            roll_num_reg <=
                ({5'b00000, mag_y_reg} << 5) +
                ({5'b00000, mag_y_reg} << 1) +
                 {5'b00000, mag_y_reg};

            sign_x_prod <= sign_x_reg;
            sign_y_prod <= sign_y_reg;


            // =============================================
            // ESTAGIO 4
            // Saturacao e sinal.
            // =============================================

            if (pitch_mag_scaled >= 7'd40) begin
                if (sign_x_prod)
                    pitch_cmd <= -11'sd40;
                else
                    pitch_cmd <= 11'sd40;
            end
            else begin
                if (sign_x_prod)
                    pitch_cmd <=
                        -$signed({4'b0000, pitch_mag_scaled});
                else
                    pitch_cmd <=
                         $signed({4'b0000, pitch_mag_scaled});
            end

            if (roll_mag_scaled >= 8'd64) begin
                if (sign_y_prod)
                    roll_cmd <= -10'sd64;
                else
                    roll_cmd <= 10'sd64;
            end
            else begin
                if (sign_y_prod)
                    roll_cmd <=
                        -$signed({2'b00, roll_mag_scaled});
                else
                    roll_cmd <=
                         $signed({2'b00, roll_mag_scaled});
            end
        end
    end

endmodule
