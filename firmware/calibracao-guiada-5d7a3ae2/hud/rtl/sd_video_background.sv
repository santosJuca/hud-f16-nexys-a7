// Busca dois pixels adiante para absorver a BRAM sem deslocar HS/VS ou o HUD.
// BPP=8: RGB332 escalado (320x240 ou 160x120), caminho historico inalterado.
// BPP=2: 640x480 nativo, 4 pixels por byte (bits 7:6 = x%4==0) e paleta RGB332 de
//        4 entradas; PALETTE = {idx3,idx2,idx1,idx0}. Mesma expansao RGB332->RGB444.
module sd_video_background #(
    parameter integer WIDTH = 320, HEIGHT = 240,
    parameter integer BPP = 8,
    parameter logic [31:0] PALETTE = 32'h100C0400,
    parameter integer ADDRESS_BITS = $clog2(WIDTH*HEIGHT*BPP/8)
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
    wire [7:0] source_rgb332;
    generate if (BPP == 2) begin : g_indexed2
        // 160 bytes por linha; o byte lido em future_x chega quando pixel_x == future_x,
        // portanto pixel_x[1:0] seleciona o par de bits do pixel exibido.
        assign read_address = ADDRESS_BITS'(future_y*(WIDTH/4) + {24'd0, future_x[9:2]});
        wire [7:0] shifted = pixel_byte >> {~pixel_x[1:0], 1'b0};
        wire [1:0] index = shifted[1:0];
        assign source_rgb332 = PALETTE[{index, 3'b000} +: 8];
    end else begin : g_rgb332
        assign read_address = (future_y/(480/HEIGHT))*WIDTH + future_x/(640/WIDTH);
        assign source_rgb332 = pixel_byte;
    end endgenerate
    wire [11:0] video_rgb = {source_rgb332[7:5],source_rgb332[7],
                             source_rgb332[4:2],source_rgb332[4],
                             source_rgb332[1:0],source_rgb332[1:0]};
    assign rgb = !video_on ? 12'h000 :
        hud_opaque || !enabled || !frame_valid || !byte_valid ? hud_rgb : video_rgb;
    assign hs=hsync;
    assign vs=vsync;
    initial if (!((BPP==8 && ((WIDTH==320 && HEIGHT==240) || (WIDTH==160 && HEIGHT==120))) ||
                  (BPP==2 && WIDTH==640 && HEIGHT==480)))
        $error("Perfis suportados: RGB332 320x240/160x120 ou 2 bpp 640x480");
endmodule
