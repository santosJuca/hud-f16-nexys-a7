`timescale 1ns/1ps
// Mesmo prazo de parede em frequencias diferentes; sem modelo de dados artificial.
module tb_sd_spi_token_timeout;
    parameter integer HALF = 2;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, start=0, sd_miso=1;
    wire sck, cs, busy, error;
    wire [2:0] code;
    wire [3:0] state;
    integer bits=0, response_bit=0, begin_cycle, cycles=0;
    sd_spi_read_block #(.HALF_PERIOD_CYCLES(HALF), .TOKEN_TIMEOUT_MS(1)) dut(
        .clk(clk), .rst(rst), .start(start), .lba(32'd0), .sd_miso(sd_miso),
        .sd_sck(sck), .sd_cs_n(cs), .busy(busy), .error(error),
        .error_code(code), .current_state(state)
    );
    always @(posedge clk) cycles <= cycles+1;
    always @(posedge sck) if(!cs && bits<48) bits=bits+1;
    always @(negedge sck) begin
        if (!cs && bits==48 && response_bit<8) begin
            sd_miso=0; response_bit=response_bit+1;
        end else sd_miso=1;
    end
    initial begin
        repeat(3) @(negedge clk); rst=0;
        start=1; @(negedge clk); start=0;
        wait(state==4); begin_cycle=cycles;
        wait(state==8);
        if (cycles-begin_cycle < 100000 || cycles-begin_cycle > 100000+16*HALF)
            $fatal(1,"Prazo incorreto HALF=%0d ciclos=%0d",HALF,cycles-begin_cycle);
        wait(error);
        if(code!=3 || busy || !cs) $fatal(1,"Recuperacao de timeout incorreta");
        $display("PASS token timeout: HALF=%0d, prazo=%0d ciclos de 100MHz",HALF,cycles-begin_cycle);
        $finish;
    end
    initial begin #2000000; $fatal(1,"Watchdog testbench"); end
endmodule
