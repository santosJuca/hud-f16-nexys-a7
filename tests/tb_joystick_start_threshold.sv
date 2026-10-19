`timescale 1ns/1ps
module tb_joystick_start_threshold;
logic clk=0;always #5 clk=~clk;
logic [11:0] x_raw=2048,y_raw=2048;
wire [9:0] x;wire [8:0] y;wire locked;
mira_joystick #(.CALIB_BITS(3),.TICK_CYCLES(1),.FIXED_STEP(4)) dut(
.clk(clk),.x_raw(x_raw),.y_raw(y_raw),.sw_n(1'b1),.enable(1'b1),.reset(1'b0),.x(x),.y(y),.locked(locked));
initial begin
 repeat(12) @(negedge clk);
 x_raw=2300;y_raw=1796;
 repeat(12) @(negedge clk);
 if(x!=320 || y!=240) $fatal(1,"Sensibilidade mudou: desvio 252 produziu movimento %0d,%0d; esperado 320,240",x,y);
 x_raw=2483;y_raw=1613;
 repeat(12) @(negedge clk);
 if(x!=320 || y!=240) $fatal(1,"Limiar 435 moveu a mira");
 x_raw=2484;y_raw=1612;
 repeat(4) @(negedge clk);
 if(x<=320 || y>=240 || x-320!=240-y) $fatal(1,"Limiar 436 nao iniciou passo simetrico");
 $display("PASS limiar: 252 e 435 parados, 436 inicia passo simetrico");$finish;
end
endmodule
