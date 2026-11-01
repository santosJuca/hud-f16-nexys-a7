// Inverse mapping for the moving flight layer. The VGA/video XY remains unchanged.
module hud_flight_coords(
    input wire [9:0] screen_y,
    input wire screen_video_on,
    input wire signed [8:0] active_offset_y,
    output wire [9:0] flight_y,
    output wire flight_video_on
);
    wire signed [12:0] virtual_y =
        $signed({3'b000,screen_y}) + $signed({{4{active_offset_y[8]}},active_offset_y});
    wire within_bounds=(virtual_y>=13'sd0 && virtual_y<13'sd480);
    assign flight_y=within_bounds ? virtual_y[9:0] : 10'd0;
    assign flight_video_on=screen_video_on && within_bounds;
endmodule
