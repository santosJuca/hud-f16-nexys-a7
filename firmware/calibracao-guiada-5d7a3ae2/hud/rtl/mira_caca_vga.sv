// Simbolo de mira independente, usado somente no estilo CAÇA.
module mira_caca_vga (
    input logic [9:0] pixel_x,
    input logic [9:0] pixel_y,
    input logic video_on,
    input logic [9:0] mira_x,
    input logic [8:0] mira_y,
    input logic locked,
    output logic on,
    output logic [11:0] rgb
);
    logic horizontal, vertical, cantos;
    integer dx, dy;
    always_comb begin
        dx = integer'(pixel_x) - integer'(mira_x);
        dy = integer'(pixel_y) - integer'(mira_y);
        horizontal = (dy == 0 && dx >= -9 && dx <= 9);
        vertical = (dx == 0 && dy >= -9 && dy <= 9);
        cantos = ((dx == -7 || dx == 7) && (dy == -7 || dy == 7));
        on = video_on && (horizontal || vertical || cantos);
        rgb = locked ? 12'hFA0 : 12'h0FF;
    end
endmodule
