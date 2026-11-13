// =========================================================
// reticula_caca_vga.sv
//
// Referencia fixa da aeronave para o estilo CAÇA.
//
// Geometria:
//   largura total  = 49 px
//   altura total   = 33 px
//   espessura      = 2 px
//   vao central    = 11 x 11 px
//
// O simbolo permanece FIXO no centro da tela.
// Nao representa Flight Path Marker.
//
// clearance_on cria uma pequena zona de exclusao da
// attitude grid ao redor do datum, evitando que barras de
// pitch parecam fazer parte do reticulo.
// =========================================================

module reticula_caca_vga #(
    parameter int H_RES      = 640,
    parameter int V_RES      = 480,
    parameter int ESPESSURA  = 2,
    parameter int CLEARANCE  = 3
)(
    input  logic [9:0] pixel_x,
    input  logic [9:0] pixel_y,
    input  logic       video_on,

    output logic       reticula_on,
    output logic       clearance_on
);

    localparam int CX = H_RES / 2;
    localparam int CY = V_RES / 2;

    // 49 px: CX-24 .. CX+24
    localparam int HALF_W = 24;

    // 33 px: CY-16 .. CY+16
    localparam int HALF_H = 16;

    // Gap de 11 px:
    // CX-5 .. CX+5
    // CY-5 .. CY+5
    localparam int GAP_HALF = 5;

    logic horizontal_esq;
    logic horizontal_dir;
    logic vertical_sup;
    logic vertical_inf;

    logic clear_horizontal_esq;
    logic clear_horizontal_dir;
    logic clear_vertical_sup;
    logic clear_vertical_inf;


    always_comb begin

        // -------------------------------------------------
        // RETICULO
        // -------------------------------------------------

        horizontal_esq =
            (pixel_y >= CY - ESPESSURA/2) &&
            (pixel_y <  CY - ESPESSURA/2 + ESPESSURA) &&
            (pixel_x >= CX - HALF_W) &&
            (pixel_x <= CX - GAP_HALF - 1);

        horizontal_dir =
            (pixel_y >= CY - ESPESSURA/2) &&
            (pixel_y <  CY - ESPESSURA/2 + ESPESSURA) &&
            (pixel_x >= CX + GAP_HALF + 1) &&
            (pixel_x <= CX + HALF_W);

        vertical_sup =
            (pixel_x >= CX - ESPESSURA/2) &&
            (pixel_x <  CX - ESPESSURA/2 + ESPESSURA) &&
            (pixel_y >= CY - HALF_H) &&
            (pixel_y <= CY - GAP_HALF - 1);

        vertical_inf =
            (pixel_x >= CX - ESPESSURA/2) &&
            (pixel_x <  CX - ESPESSURA/2 + ESPESSURA) &&
            (pixel_y >= CY + GAP_HALF + 1) &&
            (pixel_y <= CY + HALF_H);


        reticula_on =
            video_on &&
            (
                horizontal_esq ||
                horizontal_dir ||
                vertical_sup ||
                vertical_inf
            );


        // -------------------------------------------------
        // CLEARANCE DA ATTITUDE GRID
        //
        // Expansao de apenas 3 px ao redor dos quatro
        // bracos do datum.
        // -------------------------------------------------

        clear_horizontal_esq =
            (pixel_y >=
                CY - ESPESSURA/2 - CLEARANCE) &&
            (pixel_y <
                CY - ESPESSURA/2 +
                ESPESSURA + CLEARANCE) &&

            (pixel_x >=
                CX - HALF_W - CLEARANCE) &&
            (pixel_x <=
                CX - GAP_HALF - 1 + CLEARANCE);


        clear_horizontal_dir =
            (pixel_y >=
                CY - ESPESSURA/2 - CLEARANCE) &&
            (pixel_y <
                CY - ESPESSURA/2 +
                ESPESSURA + CLEARANCE) &&

            (pixel_x >=
                CX + GAP_HALF + 1 - CLEARANCE) &&
            (pixel_x <=
                CX + HALF_W + CLEARANCE);


        clear_vertical_sup =
            (pixel_x >=
                CX - ESPESSURA/2 - CLEARANCE) &&
            (pixel_x <
                CX - ESPESSURA/2 +
                ESPESSURA + CLEARANCE) &&

            (pixel_y >=
                CY - HALF_H - CLEARANCE) &&
            (pixel_y <=
                CY - GAP_HALF - 1 + CLEARANCE);


        clear_vertical_inf =
            (pixel_x >=
                CX - ESPESSURA/2 - CLEARANCE) &&
            (pixel_x <
                CX - ESPESSURA/2 +
                ESPESSURA + CLEARANCE) &&

            (pixel_y >=
                CY + GAP_HALF + 1 - CLEARANCE) &&
            (pixel_y <=
                CY + HALF_H + CLEARANCE);


        clearance_on =
            video_on &&
            (
                clear_horizontal_esq ||
                clear_horizontal_dir ||
                clear_vertical_sup ||
                clear_vertical_inf
            );

    end

endmodule
