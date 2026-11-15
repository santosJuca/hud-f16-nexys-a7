// =========================================================
// simbologia_caca_vga.sv
// Estilo visual alternativo do HUD.
// Nao altera attitude grid, sensores ou cadeia de dados.
// =========================================================

module simbologia_caca_vga (
    input  logic [9:0]  pixel_x,
    input  logic [9:0]  pixel_y,
    input  logic        video_on,

    input  logic [9:0]  velocidade_kt,
    input  logic [16:0] altitude_ft,
    input  logic [8:0]  heading_deg,

    output logic velocidade_on,
    output logic altitude_on,
    output logic heading_on,
    output logic sim_on
);

    function automatic logic [34:0] glifo5x7(
        input integer codigo
    );
        case (codigo)
            0: glifo5x7 =
                35'b01110_10001_10011_10101_11001_10001_01110;
            1: glifo5x7 =
                35'b00100_01100_00100_00100_00100_00100_01110;
            2: glifo5x7 =
                35'b01110_10001_00001_00010_00100_01000_11111;
            3: glifo5x7 =
                35'b11110_00001_00001_01110_00001_00001_11110;
            4: glifo5x7 =
                35'b00010_00110_01010_10010_11111_00010_00010;
            5: glifo5x7 =
                35'b11111_10000_10000_11110_00001_00001_11110;
            6: glifo5x7 =
                35'b01110_10000_10000_11110_10001_10001_01110;
            7: glifo5x7 =
                35'b11111_00001_00010_00100_01000_01000_01000;
            8: glifo5x7 =
                35'b01110_10001_10001_01110_10001_10001_01110;
            9: glifo5x7 =
                35'b01110_10001_10001_01111_00001_00001_01110;

            // S
            10: glifo5x7 =
                35'b01111_10000_10000_01110_00001_00001_11110;

            // I
            11: glifo5x7 =
                35'b11111_00100_00100_00100_00100_00100_11111;

            // M
            12: glifo5x7 =
                35'b10001_11011_10101_10101_10001_10001_10001;

            default:
                glifo5x7 = '0;
        endcase
    endfunction


    function automatic logic glyph_on(
        input integer codigo,
        input integer origem_x,
        input integer origem_y,
        input integer escala,
        input integer px,
        input integer py
    );
        integer coluna;
        integer linha;
        logic [34:0] bitmap;

        begin
            glyph_on = 1'b0;

            if (
                (px >= origem_x) &&
                (px < origem_x + 5 * escala) &&
                (py >= origem_y) &&
                (py < origem_y + 7 * escala)
            ) begin
                coluna = (px - origem_x) / escala;
                linha  = (py - origem_y) / escala;

                bitmap = glifo5x7(codigo);

                glyph_on =
                    bitmap[34 - (linha * 5 + coluna)];
            end
        end
    endfunction


    integer vel100;
    integer vel10;
    integer vel1;

    integer alt10000;
    integer alt1000;
    integer alt100;
    integer alt10;
    integer alt1;

    integer hdg100;
    integer hdg10;
    integer hdg1;


    always_comb begin

        velocidade_on = 1'b0;
        altitude_on   = 1'b0;
        heading_on    = 1'b0;
        sim_on        = 1'b0;


        // -------------------------------------------------
        // Dígitos
        // -------------------------------------------------

        vel100 = velocidade_kt / 100;
        vel10  = (velocidade_kt / 10) % 10;
        vel1   = velocidade_kt % 10;

        alt10000 = (altitude_ft / 10000) % 10;
        alt1000  = (altitude_ft / 1000)  % 10;
        alt100   = (altitude_ft / 100)   % 10;
        alt10    = (altitude_ft / 10)    % 10;
        alt1     = altitude_ft % 10;

        hdg100 = heading_deg / 100;
        hdg10  = (heading_deg / 10) % 10;
        hdg1   = heading_deg % 10;


        // -------------------------------------------------
        // VELOCIDADE
        // -------------------------------------------------

        velocidade_on =
            video_on &&
            (
                // fita vertical
                (
                    (pixel_x >= 72) &&
                    (pixel_x <= 74) &&
                    (pixel_y >= 110) &&
                    (pixel_y <= 370)
                )

                ||

                // graduações
                (
                    (pixel_x >= 72) &&
                    (pixel_x <= 82) &&
                    (
                        ((pixel_y >= 119) &&
                         (pixel_y <= 121)) ||

                        ((pixel_y >= 159) &&
                         (pixel_y <= 161)) ||

                        ((pixel_y >= 199) &&
                         (pixel_y <= 201)) ||

                        ((pixel_y >= 239) &&
                         (pixel_y <= 241)) ||

                        ((pixel_y >= 279) &&
                         (pixel_y <= 281)) ||

                        ((pixel_y >= 319) &&
                         (pixel_y <= 321)) ||

                        ((pixel_y >= 359) &&
                         (pixel_y <= 361))
                    )
                )

                ||

                // ponteiro
                (
                    (pixel_x >= 75) &&
                    (pixel_x <= 88) &&
                    (pixel_y >= 236) &&
                    (pixel_y <= 244)
                )

                ||

                // 3 dígitos
                glyph_on(
                    vel100,
                    92,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    vel10,
                    104,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    vel1,
                    116,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )
            );


        // -------------------------------------------------
        // ALTITUDE
        // -------------------------------------------------

        altitude_on =
            video_on &&
            (
                // fita vertical
                (
                    (pixel_x >= 565) &&
                    (pixel_x <= 567) &&
                    (pixel_y >= 110) &&
                    (pixel_y <= 370)
                )

                ||

                // graduações
                (
                    (pixel_x >= 555) &&
                    (pixel_x <= 567) &&
                    (
                        ((pixel_y >= 119) &&
                         (pixel_y <= 121)) ||

                        ((pixel_y >= 159) &&
                         (pixel_y <= 161)) ||

                        ((pixel_y >= 199) &&
                         (pixel_y <= 201)) ||

                        ((pixel_y >= 239) &&
                         (pixel_y <= 241)) ||

                        ((pixel_y >= 279) &&
                         (pixel_y <= 281)) ||

                        ((pixel_y >= 319) &&
                         (pixel_y <= 321)) ||

                        ((pixel_y >= 359) &&
                         (pixel_y <= 361))
                    )
                )

                ||

                // ponteiro
                (
                    (pixel_x >= 548) &&
                    (pixel_x <= 564) &&
                    (pixel_y >= 236) &&
                    (pixel_y <= 244)
                )

                ||

                // 5 dígitos
                glyph_on(
                    alt10000,
                    484,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    alt1000,
                    496,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    alt100,
                    508,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    alt10,
                    520,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    alt1,
                    532,
                    226,
                    2,
                    pixel_x,
                    pixel_y
                )
            );


        // -------------------------------------------------
        // HEADING NUMÉRICO - 3 DÍGITOS
        // -------------------------------------------------

        heading_on =
            video_on &&
            (
                glyph_on(
                    hdg100,
                    302,
                    26,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    hdg10,
                    314,
                    26,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    hdg1,
                    326,
                    26,
                    2,
                    pixel_x,
                    pixel_y
                )

                ||

                // pequeno caret central
                (
                    (pixel_y >= 43) &&
                    (pixel_y <= 47) &&
                    (
                        (
                            pixel_x ==
                            318 + (pixel_y - 43)
                        )
                        ||
                        (
                            pixel_x ==
                            322 - (pixel_y - 43)
                        )
                    )
                )
            );


        // -------------------------------------------------
        // SIM = velocidade/altitude simuladas
        // -------------------------------------------------

        sim_on =
            video_on &&
            (
                glyph_on(
                    10,
                    18,
                    452,
                    1,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    11,
                    25,
                    452,
                    1,
                    pixel_x,
                    pixel_y
                )

                ||

                glyph_on(
                    12,
                    32,
                    452,
                    1,
                    pixel_x,
                    pixel_y
                )
            );

    end

endmodule
