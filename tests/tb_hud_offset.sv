`timescale 1ns/1ps
module tb_hud_offset;
  logic clk=0,reset=1,enable=0,up=0,down=0,frame=0;
  wire signed [8:0] offset;
  logic [9:0] y=240;
  logic video_on=1;
  wire [9:0] flight_y;
  wire flight_on;
  always #20 clk=~clk;
  hud_vertical_adjust #(.DEBOUNCE_CYCLES(3),.REPEAT_START_CYCLES(120),
    .REPEAT_CYCLES(30),.STEP(1),.LIMIT(4)) dut(
     .clk(clk),.reset(reset),.align_enable(enable),.up_button(up),.down_button(down),
     .frame_boundary(frame),.offset_y(offset));
  hud_flight_coords coords(.screen_y(y),.screen_video_on(video_on),
     .active_offset_y(offset),.flight_y(flight_y),.flight_video_on(flight_on));
  task automatic cycles(input integer n); repeat(n) @(negedge clk); endtask
  task automatic commit; frame=1; cycles(2); frame=0; cycles(2); endtask
  initial begin
    cycles(4);reset=0;cycles(7);
    enable=1;cycles(7);
    up=1;cycles(10);
    if(offset!=0) $fatal(1,"Offset changed before frame boundary");
    commit();
    if(offset!=1 || flight_y!=241) $fatal(1,"Up offset or transformed Y incorrect");
    up=0;cycles(9);
    down=1;cycles(10); commit();
    if(offset!=0) $fatal(1,"Down must return to zero");
    down=0;cycles(9);
    up=1;cycles(300);commit();
    if(offset!=4) $fatal(1,"Positive saturation failed: %0d",offset);
    up=0;cycles(9);
    down=1;cycles(550);commit();
    if(offset!=-4) $fatal(1,"Negative saturation failed: %0d",offset);
    y=0; #1;
    if(flight_on) $fatal(1,"Underflow must clip (no wraparound)");
    y=479; #1;
    if(!flight_on || flight_y!=475) $fatal(1,"Expected visible bottom when offset negative");
    enable=0;down=0;cycles(20);
    commit();
    if(offset!=-4) $fatal(1,"Offset must persist on ALIGN exit");
    $display("PASS 1px step, frame commit, saturation, clipping, persistence");$finish;
  end
  initial begin #1000000; $fatal(1,"timeout"); end
endmodule
