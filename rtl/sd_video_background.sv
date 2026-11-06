// Busca dois pixels adiante para absorver a BRAM sem deslocar HS/VS ou o HUD.
module sd_video_background #(
    parameter integer WIDTH = 320, HEIGHT = 240,
    parameter integer ADDRESS_BITS = $clog2(WIDTH*HEIGHT)
)(
    input wire pixel_clk, rst, toggle_button,
    input wire [9:0] pixel_x, pixel_y,
    input wire video_on, hsync, vsync,
    input wire [11:0] hud_rgb,
    input wire hud_opaque, frame_valid, byte_valid,
    input wire [7:0] pixel_byte,
    output wire read_enable,
    output wire [ADDRESS_BITS-1:0] read_address,
    output wire [11:0] rgb,
    output wire hs, vs,
    output reg enabled = 1
);
    // toggle_button ja vem sincronizado e filtrado a 100 MHz.
    (* ASYNC_REG="TRUE" *) reg mode_meta=1, mode_sync=1;
    always @(posedge pixel_clk) begin
        mode_meta <= toggle_button; mode_sync <= mode_meta;
        if (rst) enabled <= 1;
        else if (pixel_x == 0 && pixel_y == 480) enabled <= mode_sync;
    end
    wire [9:0] future_x = pixel_x >= 798 ? pixel_x-798 : pixel_x+2;
    wire [9:0] future_y = pixel_x >= 798 ? (pixel_y == 524 ? 10'd0 : pixel_y+1'b1) : pixel_y;
    assign read_enable = frame_valid && future_x < 640 && future_y < 480;
    assign read_address = (future_y/(480/HEIGHT))*WIDTH + future_x/(640/WIDTH);
    wire [11:0] video_rgb = {pixel_byte[7:5],pixel_byte[7],
                                  pixel_byte[4:2],pixel_byte[4],
                                  pixel_byte[1:0],pixel_byte[1:0]};
    assign rgb = !video_on ? 12'h000 :
        hud_opaque || !enabled || !frame_valid || !byte_valid ? hud_rgb : video_rgb;
    assign hs=hsync;
    assign vs=vsync;
    initial if (!((WIDTH==320 && HEIGHT==240) || (WIDTH==160 && HEIGHT==120)))
        $error("Escala inteira suportada: 320x240 ou 160x120");
endmodule
