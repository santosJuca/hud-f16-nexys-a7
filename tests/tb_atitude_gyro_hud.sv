`timescale 1ns/1ps

module tb_atitude_gyro_hud;

    logic signed [31:0] pitch_q10 = 0;
    logic signed [31:0] roll_q10 = 0;

    wire signed [10:0] pitch_px;
    wire signed [9:0] roll_q8;

    atitude_gyro_hud dut (
        .pitch_q10(pitch_q10),
        .roll_q10(roll_q10),
        .pitch_px(pitch_px),
        .roll_q8(roll_q8)
    );

    initial begin
        // +10 graus pitch -> +40 px.
        pitch_q10 = 32'sd10240;
        roll_q10 = 32'sd0;
        #1;

        if ($signed(pitch_px) !== 40)
            $fatal(1, "pitch +10 graus incorreto: %0d", $signed(pitch_px));

        $display("PASS pitch +10 graus -> %0d px", $signed(pitch_px));

        // -10 graus pitch -> -40 px.
        pitch_q10 = -32'sd10240;
        #1;

        if ($signed(pitch_px) !== -40)
            $fatal(1, "pitch -10 graus incorreto: %0d", $signed(pitch_px));

        // +10 graus roll -> aproximadamente +44.
        pitch_q10 = 0;
        roll_q10 = 32'sd10240;
        #1;

        if ($signed(roll_q8) < 44 ||
            $signed(roll_q8) > 45)
            $fatal(1, "roll +10 graus incorreto: %0d", $signed(roll_q8));

        $display("PASS roll +10 graus -> %0d q8", $signed(roll_q8));

        // Simetria.
        roll_q10 = -32'sd10240;
        #1;

        if ($signed(roll_q8) > -44 ||
            $signed(roll_q8) < -45)
            $fatal(1, "roll -10 graus incorreto: %0d", $signed(roll_q8));

        // Saturacao de pitch.
        pitch_q10 = 32'sd30720; // +30 graus
        roll_q10 = 0;
        #1;

        if ($signed(pitch_px) !== 80)
            $fatal(1, "pitch deveria saturar em +80");

        // Saturacao de roll.
        pitch_q10 = 0;
        roll_q10 = 32'sd40960; // +40 graus
        #1;

        if ($signed(roll_q8) !== 128)
            $fatal(1, "roll deveria saturar em +128");

        $display("PASS saturacoes");
        $display("PASS todos os testes atitude_gyro_hud");

        $finish;
    end

endmodule
