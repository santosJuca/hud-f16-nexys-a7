`timescale 1ns/1ps
module tb_xadc_cadence;
 parameter integer FAST_CLOCK=1;
 reg clk=0,ui_clk=0;
 always #(FAST_CLOCK ? 4.875 : 5.0) clk=~clk;
 always #6.154 ui_clk=~ui_clk;
 wire [11:0] temp,dest;
 wire valid,request,ack;
 joystick_xadc dut(.clk(clk),.vauxp3(1'b0),.vauxn3(1'b0),
   .vauxp10(1'b0),.vauxn10(1'b0),.temperature_raw(temp),
   .temperature_valid(valid),.temperature_toggle(request),.temperature_ack(ack));
 xadc_temperature_cdc cdc(.dst_clk(ui_clk),.dst_reset(1'b0),
   .source_data(temp),.source_toggle(request),.destination_ack(ack),
   .destination_data(dest));
 realtime previous=0,interval,max_interval=0;
 integer samples=0;
 reg seen=0;
 always @(posedge ui_clk) if(ack!=seen) begin
   seen=ack;
   if(previous!=0) begin
     interval=$realtime-previous;
     if(interval>116000) $fatal(1,"XADC excedeu 116us: %0f ns",interval);
     if(interval>max_interval) max_interval=interval;
   end
   previous=$realtime;
   samples=samples+1;
   if(samples==20) begin
     $display("XADC_CADENCE_PASS samples=%0d max_interval_ns=%0f",samples,max_interval);
     $finish;
   end
 end
 initial begin #5000000; $fatal(1,"XADC nao produziu 20 amostras"); end
endmodule
