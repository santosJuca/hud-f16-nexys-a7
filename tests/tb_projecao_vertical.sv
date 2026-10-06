`timescale 1ns/1ps
module tb_projecao_vertical;
    logic clk=0; always #5 clk=~clk;
    logic sensor_ok=1, atualizar=0;
    logic signed [15:0] accel_x=0,accel_y=0,accel_z=16384;
    logic signed [31:0] pitch_q10=0,roll_q10=0;
    wire signed [18:0] vertical_counts;
    wire valido;
    integer checks=0;
    projecao_vertical dut(.*);
    task automatic sample(input integer p,r,x,y,z,expected);
        @(negedge clk); pitch_q10=p*1024; roll_q10=r*1024;
        accel_x=x; accel_y=y; accel_z=z; atualizar=1;
        @(negedge clk); atualizar=0;
        wait(valido); #1;
        checks++;
        if(vertical_counts < expected-8 || vertical_counts > expected+8)
            $fatal(1,"projecao p=%0d r=%0d xyz=%0d,%0d,%0d obtido=%0d esperado=%0d",p,r,x,y,z,vertical_counts,expected);
        repeat(3) @(negedge clk);
    endtask
    initial begin
        sample(0,0,0,0,16384,16384);
        sample(30,0,0,8192,14189,16384);
        sample(-30,0,0,-8192,14189,16384);
        sample(0,30,-8192,0,14189,16384);
        sample(0,-30,8192,0,14189,16384);
        sample(30,30,-7094,8192,12288,16384);
        sample(-30,-30,7094,-8192,12288,16384);
        sample(0,0,12000,-12000,18000,18000);
        sample(0,0,0,0,-16384,-16384);
        @(negedge clk); pitch_q10=31*1024; atualizar=1;
        repeat(8) begin @(negedge clk); if(valido) $fatal(1,"atitude fora da faixa aceita"); end
        atualizar=0; sensor_ok=0;
        repeat(8) begin @(negedge clk); if(valido) $fatal(1,"sensor invalido aceito"); end
        $display("PASS projecao_vertical: %0d vetores e bloqueios",checks); $finish;
    end
    initial begin #100000; $fatal(1,"timeout projecao"); end
endmodule
