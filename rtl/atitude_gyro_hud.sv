// =========================================================
// atitude_gyro_hud.sv
//
// Converte angulos do giroscopio em Q10 para as unidades
// visuais atualmente usadas pelo HUD.
//
// Entrada:
//   1 grau = 1024 unidades.
//
// Pitch:
//   HUD usa 4 pixels por grau.
//   pitch_px = angulo_q10 / 256.
//
// Roll:
//   roll_q8 representa a inclinacao da reta em Q8:
//       slope = roll_q8 / 256
//
// Para pequenos angulos:
//       tan(theta) ~= theta_rad
//
// Logo:
//       roll_q8 ~= 256 * theta_rad
//
// Em funcao de angulo_q10:
//       roll_q8 ~= angulo_q10 * 1144 / 2^18
//
// 1144 = 1024 + 128 - 8.
// =========================================================

module atitude_gyro_hud (
    input  logic signed [31:0] pitch_q10,
    input  logic signed [31:0] roll_q10,

    output logic signed [10:0] pitch_px,
    output logic signed [9:0]  roll_q8
);

    logic signed [31:0] pitch_calc;

    logic signed [47:0] roll_ext;
    logic signed [47:0] roll_scaled;
    logic signed [31:0] roll_calc;

    always_comb begin
        // 4 px/grau:
        // Q10 -> pixels = / 256.
        pitch_calc = pitch_q10 >>> 8;

        if (pitch_calc > 32'sd80)
            pitch_px = 11'sd80;
        else if (pitch_calc < -32'sd80)
            pitch_px = -11'sd80;
        else
            pitch_px = pitch_calc[10:0];

        // Aproximacao de pequeno angulo.
        roll_ext = {{16{roll_q10[31]}}, roll_q10};

        roll_scaled =
            (roll_ext <<< 10) +
            (roll_ext <<< 7)  -
            (roll_ext <<< 3);

        roll_calc = roll_scaled >>> 18;

        if (roll_calc > 32'sd128)
            roll_q8 = 10'sd128;
        else if (roll_calc < -32'sd128)
            roll_q8 = -10'sd128;
        else
            roll_q8 = roll_calc[9:0];
    end

endmodule
