`timescale 1ns/1ps

module tb_controle_manche;

    logic clk = 0;
    always #5 clk = ~clk;

    logic [11:0] x_raw = 12'd2000;
    logic [11:0] y_raw = 12'd2000;

    wire calibrado;
    wire signed [10:0] pitch_cmd;
    wire signed [9:0]  roll_cmd;

    controle_manche #(
        .DEADZONE(100),
        .CALIB_BITS(2)
    ) dut (
        .clk(clk),
        .x_raw(x_raw),
        .y_raw(y_raw),
        .calibrado(calibrado),
        .pitch_cmd(pitch_cmd),
        .roll_cmd(roll_cmd)
    );

    task automatic espera_pipeline;
        repeat (6) @(posedge clk);
        #1;
    endtask

    initial begin

        // Mantem o manche parado durante calibracao.
        repeat (6) @(posedge clk);
        espera_pipeline();

        if (!calibrado)
            $fatal(1, "Manche nao calibrou");

        if (pitch_cmd != 0 || roll_cmd != 0)
            $fatal(
                1,
                "Centro deveria ser zero: pitch=%0d roll=%0d",
                pitch_cmd,
                roll_cmd
            );

        // -----------------------------------------------
        // Deadzone
        // -----------------------------------------------

        x_raw = 12'd2100;
        y_raw = 12'd1900;

        espera_pipeline();

        if (pitch_cmd != 0 || roll_cmd != 0)
            $fatal(
                1,
                "Falha deadzone: pitch=%0d roll=%0d",
                pitch_cmd,
                roll_cmd
            );

        // -----------------------------------------------
        // Deflexao positiva proporcional
        // -----------------------------------------------

        x_raw = 12'd3024;
        y_raw = 12'd3024;

        espera_pipeline();

        if (pitch_cmd < 18 || pitch_cmd > 21)
            $fatal(
                1,
                "Pitch proporcional incorreto: %0d",
                pitch_cmd
            );

        if (roll_cmd < 30 || roll_cmd > 33)
            $fatal(
                1,
                "Roll proporcional incorreto: %0d",
                roll_cmd
            );

        // -----------------------------------------------
        // Deflexao negativa proporcional
        // -----------------------------------------------

        x_raw = 12'd976;
        y_raw = 12'd976;

        espera_pipeline();

        if (pitch_cmd > -18 || pitch_cmd < -21)
            $fatal(
                1,
                "Pitch negativo incorreto: %0d",
                pitch_cmd
            );

        if (roll_cmd > -30 || roll_cmd < -33)
            $fatal(
                1,
                "Roll negativo incorreto: %0d",
                roll_cmd
            );

        // -----------------------------------------------
        // Saturacao
        // -----------------------------------------------

        x_raw = 12'd4095;
        y_raw = 12'd4095;

        espera_pipeline();

        if (pitch_cmd != 40)
            $fatal(
                1,
                "Pitch deveria saturar +40: %0d",
                pitch_cmd
            );

        if (roll_cmd != 64)
            $fatal(
                1,
                "Roll deveria saturar +64: %0d",
                roll_cmd
            );

        $display(
            "PASS manche pipeline: calibracao, deadzone, proporcionalidade e saturacao"
        );

        $finish;
    end

endmodule
