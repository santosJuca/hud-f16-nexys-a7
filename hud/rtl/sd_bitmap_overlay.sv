// Bitmap 64x64, MSB a esquerda. Antecipa a BRAM em dois pixels; preserva RGB/HS/VS.
module sd_bitmap_overlay #(
    parameter integer X = 540,
    parameter integer Y = 40,
    parameter logic [11:0] COLOR = 12'hFF0
)(
    input wire pixel_clk, rst,
    input wire [9:0] pixel_x, pixel_y,
    input wire video_on, hsync, vsync,
    input wire [11:0] base_rgb,
    input wire sector_valid, byte_valid,
    input wire [7:0] bitmap_byte,
    output wire read_enable,
    output wire [8:0] read_address,
    output wire [11:0] rgb,
    output wire hs, vs, de,
    output wire overlay_pixel
);
    initial if(X<2 || X+64>640 || Y<0 || Y+64>480)
        $error("Bitmap deve ficar dentro da area visivel, com X >= 2");
    // A borda N registra o endereco; N+1 entrega o byte, ja no pixel x+2.
    wire [9:0] local_x = pixel_x - (X-2);
    wire [9:0] local_y = pixel_y - Y;
    assign read_enable = sector_valid && video_on &&
                         pixel_x >= X-2 && pixel_x < X+62 &&
                         pixel_y >= Y && pixel_y < Y+64;
    assign read_address = {local_y[5:0], local_x[5:3]};
    logic [2:0] bit_1=0, bit_2=0;
    logic mask_1=0, mask_2=0;
    always_ff @(posedge pixel_clk) begin
        if(rst) begin
            bit_1<=0; bit_2<=0; mask_1<=0; mask_2<=0;
        end else begin
            bit_1<=3'd7-local_x[2:0]; bit_2<=bit_1;
            mask_1<=read_enable; mask_2<=mask_1;
        end
    end
    assign overlay_pixel = mask_2 && byte_valid && bitmap_byte[bit_2];
    assign rgb = overlay_pixel ? COLOR : base_rgb;
    assign hs=hsync;
    assign vs=vsync;
    assign de=video_on;
endmodule
