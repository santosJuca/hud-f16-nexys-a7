`timescale 1ns/1ps
module tb_alignment_routing;
 reg clk=0,reset=1,sw4=0,capture_active=0,left=0;
 reg [1:0] buttons=0;
 wire align_mode,grid,video,capture,step_toggle,zero;
 wire [1:0] heading,align_buttons,view;
 wire cap_grid;
 always #5 clk=~clk;
 hud_command_dispatch #(.DEBOUNCE_CYCLES(2),.SWITCH_DEBOUNCE_CYCLES(2)) route(
 .clk(clk),.reset(reset),.align_switch(sw4),.capture_active(capture_active),.buttons(buttons),
 .align_mode(align_mode),.heading_buttons(heading),.align_buttons(align_buttons),.capture_grid_pulse(grid));
 captura_controle #(.DEBOUNCE(2),.LONG_PRESS(30)) cap(
 .clk(clk),.reset(reset),.button(left),.inhibit(sw4),.page(4'd0),.video_mode(video),.capture(capture),.step_toggle(step_toggle),.zero_request(zero),.view(view),.grid(cap_grid));
 task automatic waitc(input integer n);repeat(n)@(negedge clk);endtask
 initial begin
 waitc(4);reset=0;waitc(10);buttons=1;waitc(10);
 if(heading!=1 || align_buttons!=0)$fatal(1,"normal heading route");
 buttons=0;sw4=1;capture_active=1;waitc(12);buttons=1;waitc(10);
 if(!align_mode || align_buttons!=1 || heading!=0 || grid)$fatal(1,"SW4 must own U/D even in capture");
 buttons=0;left=1;waitc(60);if(!video || capture || step_toggle)$fatal(1,"align press leaked into capture");
 sw4=0;waitc(60);left=0;waitc(12);if(!video || capture)$fatal(1,"held L on exit caused event");
 capture_active=0;buttons=1;waitc(10);if(heading!=1)$fatal(1,"heading did not recover");buttons=0;
 left=1;waitc(12);sw4=1;waitc(60);left=0;waitc(10);sw4=0;waitc(12);
 if(!video || capture)$fatal(1,"entering ALIGN mid-press caused event");
 $display("PASS SW4 route priority, heading recovery and held-L entry/exit isolation");$finish;
 end
 initial begin #100000;$fatal(1,"timeout");end
endmodule
