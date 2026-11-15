`timescale 1ns/1ps
module tb_hud_layers;
  logic [9:0] x=350,y=60,flight_y=60;
  logic flight_on=1;
  wire hor,alt,dir,alvo,spd;
  // Heading tape at y=60 is FIXED while the flight Y is moved/clipped.
  simbologia_vga #(.FULL_ATTITUDE(1'b1),.SEPARATE_FLIGHT_COORDS(1'b1)) dut(
     .pixel_x(x),.pixel_y(y),.video_on(1'b1),
     .flight_pixel_y(flight_y),.flight_video_on(flight_on),
     .attitude_sine(16'sd0),.attitude_cosine(16'sd16384),
     .attitude_pitch_px(11'sd0),.horizonte_y(10'd240),
     .roll_q8(10'sd0),.heading_deg(9'd0),.alvo_x(10'd400),.alvo_y(9'd240),
     .horizonte_on(hor),.altitude_on(alt),.direcao_on(dir),.alvo_on(alvo),.velocidade_on(spd));
  logic original_heading;
  initial begin
    #20;
    original_heading=dir;
    if(!original_heading) $fatal(1,"Heading tape control pixel missing");
    flight_y=10'd0;flight_on=0;#20;
    if(dir!==original_heading) $fatal(1,"Heading tape moved with flight layer");
    if(hor || alvo) $fatal(1,"Flight layer not clipped");
    // Test horizon follows the translated flight coordinate, while screen remains y=240.
    x=500;y=240;flight_y=240;flight_on=1;#20;
    if(!hor) $fatal(1,"Flight horizon reference should render near center");
    flight_y=200;#20;
    if(hor) $fatal(1,"Flight horizon must move independently from screen Y");
    y=200;flight_y=240;#20;
    if(!hor) $fatal(1,"Translated horizon missing at shifted screen Y");
    $display("PASS compass screen anchored, flight horizon translated/clipped");$finish;
  end
endmodule
