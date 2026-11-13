// Rotacao ortonormal inversa. A projecao e uma escala angular de 4 px/grau.
// O pitch desloca ao longo da normal do horizonte, inclusive em bank=90 graus.
module horizonte_atitude(
    input wire [9:0] pixel_x,pixel_y,
    input wire signed [15:0] sine,cosine,
    input wire signed [10:0] pitch_px,
    output wire signed [21:0] local_x,local_y
);
    wire signed [10:0] x=$signed({1'b0,pixel_x})-11'sd320;
    wire signed [10:0] y=$signed({1'b0,pixel_y})-11'sd240;
    wire signed [26:0] xc=x*cosine,ys=y*sine,xs=x*sine,yc=y*cosine;
    wire signed [27:0] u=$signed(xc)-$signed(ys);
    wire signed [27:0] v=$signed(xs)+$signed(yc);
    assign local_x=22'(u>>>14);
    assign local_y=22'(v>>>14)-{{11{pitch_px[10]}},pitch_px};
endmodule
