// Display anchored status: small ALIGN + signed Y in lower panel.
// Purely visual. No sensor, SD, or capture connection.
module hud_align_status_vga (
    input wire pixel_clk,
    input wire [9:0] pixel_x,pixel_y,
    input wire video_on,align_mode,
    input wire signed [8:0] offset_y,
    output wire on
);
    function automatic [34:0] glyph(input integer code);
        case(code)
             0: glyph=35'b01110_10001_10001_11111_10001_10001_10001; // A
             1: glyph=35'b10000_10000_10000_10000_10000_10000_11111; // L
             2: glyph=35'b11111_00100_00100_00100_00100_00100_11111; // I
             3: glyph=35'b01111_10000_10000_10111_10001_10001_01111; // G
             4: glyph=35'b10001_11001_10101_10011_10001_10001_10001; // N
             5: glyph=35'b10001_01010_00100_00100_00100_00100_00100; // Y
             6: glyph=35'b00000_00000_00100_00100_11111_00100_00100; // +
             7: glyph=35'b00000_00000_00000_11111_00000_00000_00000; // -
             8: glyph=35'b00000_00000_00000_00000_00000_00000_00000; // space
             9: glyph=35'b01110_10001_10011_10101_11001_10001_01110; // 0
            10: glyph=35'b00100_01100_00100_00100_00100_00100_01110; // 1
            11: glyph=35'b01110_10001_00001_00010_00100_01000_11111; // 2
            12: glyph=35'b11110_00001_00001_01110_00001_00001_11110; // 3
            13: glyph=35'b00010_00110_01010_10010_11111_00010_00010; // 4
            14: glyph=35'b11111_10000_10000_11110_00001_00001_11110; // 5
            15: glyph=35'b01110_10000_10000_11110_10001_10001_01110; // 6
            16: glyph=35'b11111_00001_00010_00100_01000_01000_01000; // 7
            17: glyph=35'b01110_10001_10001_01110_10001_10001_01110; // 8
            18: glyph=35'b01110_10001_10001_01111_00001_00001_01110; // 9
            default: glyph=35'b0;
        endcase
    endfunction
    (* ASYNC_REG="TRUE" *) logic mode_meta=0,mode_sync=0;
    // Pixel-domain CDC for a single-bit mode flag.
    // The offset is already committed in the pixel domain.
    always_ff @(posedge pixel_clk) begin mode_meta<=align_mode; mode_sync<=mode_meta; end
    wire [8:0] absolute_offset=offset_y<0 ? -offset_y : offset_y;
    wire [3:0] tens=4'(absolute_offset / 9'd10);
    wire [3:0] ones=4'(absolute_offset % 9'd10);
    // Each 5x7 character is 10x14 pixels (2x), separated by 4 pixels.
    wire in_box=pixel_x>=10'd208 && pixel_x<10'd362 &&
                pixel_y>=10'd440 && pixel_y<10'd454;
    wire [7:0] local_x=8'(pixel_x-10'd208);
    wire [3:0] slot=4'(local_x/8'd14);
    wire [3:0] col=4'((local_x%8'd14)>>1);
    wire [2:0] row=(pixel_y-10'd440)>>1;
    logic [4:0] glyph_number;
    always_comb begin
        case(slot)
            0: glyph_number=0;
            1: glyph_number=1;
            2: glyph_number=2;
            3: glyph_number=3;
            4: glyph_number=4;
            5: glyph_number=8;
            6: glyph_number=5;
            7: glyph_number=offset_y<0 ? 7 : 6;
            8: glyph_number=5'(9+tens);
            9: glyph_number=5'(9+ones);
            default: glyph_number=8;
        endcase
    end
    wire [34:0] symbol_bitmap=glyph(glyph_number);
    assign on=video_on && mode_sync && in_box && col<5 &&
              symbol_bitmap[34-(row*5+col)];
endmodule
