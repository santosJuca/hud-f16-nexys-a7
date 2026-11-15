`timescale 1ns/1ps

module tb_hud_auto_zero;

    logic clk = 0;
    always #5 clk = ~clk;

    logic reset = 1;
    logic enabled = 1;
    logic calibrated = 0;
    logic valid = 0;
    logic stationary = 0;
    logic updated = 0;
    logic already_zeroed = 0;
    logic signed [31:0] raw_roll = 0;
    logic signed [31:0] raw_pitch = 0;

    wire zero_pulse, done;
    integer pulses = 0;

    hud_auto_zero dut(.*);

    always @(posedge clk)
        if (zero_pulse) pulses = pulses + 1;

    task automatic measurement;
        @(negedge clk);
        updated = 1;
        @(negedge clk);
        updated = 0;
        repeat(2) @(negedge clk);
    endtask

    initial begin
        repeat(3) @(negedge clk);
        reset = 0;

        calibrated = 1;
        valid = 1;
        stationary = 1;

        raw_roll = 6000;
        repeat(12) measurement();

        if(done || pulses)
            $fatal(1,"Zero aceito fora da referencia");

        raw_roll = 1000;
        stationary = 0;
        repeat(12) measurement();

        if(done || pulses)
            $fatal(1,"Zero aceito durante movimento");

        stationary = 1;

        repeat(7) measurement();

        if(done || pulses)
            $fatal(1,"Zero antecipado");

        measurement();

        if(!done || pulses != 1)
            $fatal(1,"Zero automatico nao ocorreu exatamente uma vez");

        repeat(20) measurement();

        if(pulses != 1)
            $fatal(1,"Zeragem repetida indevidamente");

        reset = 1;
        repeat(3) @(negedge clk);
        reset = 0;
        already_zeroed = 1;

        repeat(12) measurement();

        if(!done || pulses != 1)
            $fatal(1,"Zeragem manual nao foi respeitada");

        $display("PASS: zero automatico unico, seguro e sem conflito manual");
        $finish;
    end
endmodule
