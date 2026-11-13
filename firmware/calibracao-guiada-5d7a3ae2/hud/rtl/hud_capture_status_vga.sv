// HUD v1.1: indicador CAP discreto no canto inferior direito.
// Utiliza exclusivamente estado ja recebido no dominio pixel.
// Nao altera horizonte, sincronismo VGA, video ou sensores.
module hud_capture_status_vga (
    input wire [9:0] pixel_x, pixel_y,
    input wire video_on,
    input wire capture_active,
    input wire [1:0] view,
    output wire on
);
    // Fonte 5x7: C, A, P.
    function automatic [34:0] glyph(input logic [1:0] code);
        case (code)
            2'd0: glyph =
                35'b01111_10000_10000_10000_10000_10000_01111;
            2'd1: glyph =
                35'b01110_10001_10001_11111_10001_10001_10001;
            2'd2: glyph =
                35'b11110_10001_10001_11110_10000_10000_10000;
            default: glyph = 35'b0;
        endcase
    endfunction

    // Tres caracteres de 10x14 pixels, espacamento de 4 pixels.
    wire in_region =
        pixel_x >= 10'd560 && pixel_x < 10'd602 &&
        pixel_y >= 10'd440 && pixel_y < 10'd454;

    wire [5:0] dx = 6'(pixel_x - 10'd560);
    wire [3:0] dy = 4'(pixel_y - 10'd440);

    wire [1:0] character = 2'(dx / 6'd14);
    wire [2:0] col = 3'((dx % 6'd14) >> 1);
    wire [2:0] row = 3'(dy >> 1);
    wire [34:0] bitmap = glyph(character);

    // view=0 deve continuar sendo exclusivamente video.
    assign on =
        video_on && capture_active && (view != 2'b00) &&
        in_region && col < 3'd5 && row < 3'd7 &&
        bitmap[34 - (row*5 + col)];
endmodule
