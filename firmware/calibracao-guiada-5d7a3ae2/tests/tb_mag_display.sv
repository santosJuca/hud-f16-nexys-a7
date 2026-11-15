`timescale 1ns/1ps
module tb_mag_display;
 reg clk=0;always #5 clk=~clk;
 reg reset=1,healthy=1,level=1,active=0;reg[3:0]state=0,reason=0;
 wire[6:0]segments;wire[7:0]anodes;wire dp;wire[63:0]text_value;
 mag_calibration_display #(.SCAN_BITS(0)) dut(.*);
 function automatic[6:0] expected(input[7:0]c);
 case(c)
 " ":expected=7'b1111111;"O":expected=7'b1000000;"I","1":expected=7'b1111001;
 "2":expected=7'b0100100;"3":expected=7'b0110000;"A":expected=7'b0001000;
 "B":expected=7'b0000011;"C":expected=7'b1000110;"d":expected=7'b0100001;
 "E":expected=7'b0000110;"G":expected=7'b0000010;"L":expected=7'b1000111;
 "n":expected=7'b0101011;"P":expected=7'b0001100;"r":expected=7'b0101111;
 "M":expected=7'b0001001; // Aproximacao H declarada no driver sete segmentos.
 "S":expected=7'b0010010;"t":expected=7'b0000111;"U":expected=7'b1000001;"V":expected=7'b1100011;
 default:$fatal(1,"Mensagem nao representavel: %c",c);
 endcase
 endfunction
 integer checks=0;reg[7:0]c;
 initial begin
 repeat(3)@(negedge clk);reset=0;
 for(integer s=0;s<10;s++)for(integer rr=0;rr<11;rr++)for(integer flags=0;flags<8;flags++)begin
  state=4'(s);reason=4'(rr);{healthy,level,active}=3'(flags);
  for(integer digit=0;digit<8;digit++)begin
   @(negedge clk);#1;c=8'(text_value>>(dut.digit*8));
   if(segments!==expected(c) || anodes!==(8'hff^(8'b1<<dut.digit)) || !dp)$fatal(1,"Segmentos/anodos");checks++;
  end
 end
 $display("PASS display: %0d verificacoes de mensagens, glifos e oito anodos",checks);$finish;
 end
endmodule
