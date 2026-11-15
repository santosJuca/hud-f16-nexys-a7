`timescale 1ns/1ps
module tb_hud_dispatch;
  logic clk=0,reset=1,sw4=0,capture=0;
  logic [1:0] buttons=0;
  wire align;
  wire [1:0] heading_btn,align_btn;
  wire grid_pulse;
  integer grid_count=0;
  always @(posedge clk) if(grid_pulse) grid_count=grid_count+1;
  always #5 clk=~clk;
  hud_command_dispatch #(.DEBOUNCE_CYCLES(3),.SWITCH_DEBOUNCE_CYCLES(3)) dut(
    .clk(clk),.reset(reset),.align_switch(sw4),.capture_active(capture),
    .buttons(buttons),.align_mode(align),.heading_buttons(heading_btn),
    .align_buttons(align_btn),.capture_grid_pulse(grid_pulse));
  task automatic settle; repeat(14) @(negedge clk); endtask
  initial begin
    settle(); reset=0; settle();
    if(align || heading_btn || align_btn) $fatal(1,"Default routing bad");
    buttons=2'b01; settle();
    if(heading_btn!=2'b01 || align_btn!=0) $fatal(1,"Heading must own button");
    // Enter ALIGN with button held: must not emit a ghost movement.
    sw4=1; settle();
    if(!align || heading_btn || align_btn) $fatal(1,"Route switch leaked held button");
    buttons=0; settle();
    buttons=2'b01; settle();
    if(heading_btn || align_btn!=2'b01) $fatal(1,"ALIGN must own button");
    buttons=2'b11; settle();
    if(heading_btn || align_btn) $fatal(1,"Both buttons must be ignored");
    capture=1; settle();
    if(heading_btn || align_btn || align) $fatal(1,"CAPTURE must hide align and own no heading/align button");
    if(grid_count!=0) $fatal(1,"Held chord must not leak into capture");
    buttons=0; settle();
    buttons=2'b11; settle();
    if(grid_count!=1) $fatal(1,"Capture grid must toggle once on chord");
    settle();
    if(grid_count!=1) $fatal(1,"Holding chord must not retrigger");
    buttons=0; settle();
    buttons=2'b11; settle();
    if(grid_count!=2) $fatal(1,"Second chord must toggle again");
    capture=0; settle();
    if(heading_btn || align_btn || grid_pulse) $fatal(1,"No ghost button after CAPTURE");
    buttons=0; settle();
    sw4=0; settle();
    buttons=2'b10; settle();
    if(heading_btn!=2'b10 || align_btn) $fatal(1,"Heading not restored");
    $display("PASS dispatcher SW4 / heading / capture isolation"); $finish;
  end
  initial begin #100000; $fatal(1,"timeout"); end
endmodule
