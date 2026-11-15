`timescale 1ns/1ps

module tb_sd_spi_preamble;
    reg clk = 0;
    reg rst = 1;
    wire sd_reset, sd_sck, sd_cmd, sd_cs_n, ready;

    integer rising_edges = 0;

    always #5 clk = ~clk;
    always @(posedge sd_sck)
        rising_edges = rising_edges + 1;

    sd_spi_preamble #(
        .POWERUP_CYCLES(20),
        .HALF_PERIOD_CYCLES(3)
    ) dut (
        .clk(clk),
        .rst(rst),
        .sd_reset(sd_reset),
        .sd_sck(sd_sck),
        .sd_cmd(sd_cmd),
        .sd_cs_n(sd_cs_n),
        .ready(ready)
    );

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        rst = 0;

        wait (ready == 1'b1);
        #1;

        if (rising_edges != 80)
            $fatal(1, "Quantidade de clocks incorreta");

        if (sd_reset !== 0 || sd_sck !== 0 ||
            sd_cmd !== 1 || sd_cs_n !== 1)
            $fatal(1, "Estado final incorreto");

        $display("PASS: 80 clocks SPI, CS alto, alimentacao habilitada");
        $finish;
    end

    initial begin
        #50000;
        $fatal(1, "TIMEOUT");
    end
endmodule
