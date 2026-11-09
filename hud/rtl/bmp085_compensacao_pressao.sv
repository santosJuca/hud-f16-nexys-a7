module bmp085_compensacao_pressao (
    input  logic        [18:0] up_raw,
    input  logic signed [31:0] b5,

    input  logic signed [15:0] ac1,
    input  logic signed [15:0] ac2,
    input  logic signed [15:0] ac3,
    input  logic        [15:0] ac4,

    input  logic signed [15:0] b1,
    input  logic signed [15:0] b2,

    output logic signed [31:0] b6,
    output logic signed [31:0] b3,
    output logic        [31:0] b4,
    output logic        [31:0] b7,

    output logic        [31:0] pressao_base_pa,
    output logic        [31:0] pressao_pa,

    output logic calculo_ok
);

    logic signed [63:0] up_64;
    logic signed [63:0] b5_64;

    logic signed [63:0] ac1_64;
    logic signed [63:0] ac2_64;
    logic signed [63:0] ac3_64;
    logic signed [63:0] ac4_64;

    logic signed [63:0] b1_64;
    logic signed [63:0] b2_64;

    logic signed [63:0] b6_64;
    logic signed [63:0] b6_sq_64;

    logic signed [63:0] x1_64;
    logic signed [63:0] x2_64;
    logic signed [63:0] x3_64;

    logic signed [63:0] b3_64;
    logic signed [63:0] b4_64;
    logic signed [63:0] b7_64;

    logic signed [63:0] p_base_64;
    logic signed [63:0] p_final_64;

    logic signed [63:0] corr_x1_64;
    logic signed [63:0] corr_x2_64;


    always_comb begin

        up_64  = $signed({1'b0, up_raw});
        b5_64  = $signed(b5);

        ac1_64 = $signed(ac1);
        ac2_64 = $signed(ac2);
        ac3_64 = $signed(ac3);
        ac4_64 = $signed({1'b0, ac4});

        b1_64  = $signed(b1);
        b2_64  = $signed(b2);


        // =================================================
        // Formula oficial BMP085 para OSS=0.
        // =================================================

        b6_64 =
            b5_64 - 64'sd4000;

        b6_sq_64 =
            b6_64 * b6_64;


        // X1 = (B2 * (B6*B6 >> 12)) >> 11
        x1_64 =
            (b2_64 * (b6_sq_64 >>> 12))
            >>> 11;

        // X2 = (AC2 * B6) >> 11
        x2_64 =
            (ac2_64 * b6_64)
            >>> 11;

        x3_64 =
            x1_64 + x2_64;

        // OSS=0:
        // B3 = (((AC1*4 + X3) + 2) >> 2)
        b3_64 =
            ((ac1_64 * 64'sd4 +
              x3_64 +
              64'sd2)
             >>> 2);


        // X1 = (AC3 * B6) >> 13
        x1_64 =
            (ac3_64 * b6_64)
            >>> 13;

        // X2 = (B1 * (B6*B6 >> 12)) >> 16
        x2_64 =
            (b1_64 * (b6_sq_64 >>> 12))
            >>> 16;

        x3_64 =
            (x1_64 +
             x2_64 +
             64'sd2)
            >>> 2;


        // B4 = AC4 * (X3 + 32768) >> 15
        b4_64 =
            (ac4_64 *
             (x3_64 + 64'sd32768))
            >>> 15;


        // OSS=0:
        // B7 = (UP - B3) * 50000
        b7_64 =
            (up_64 - b3_64)
            * 64'sd50000;


        p_base_64 = 64'sd0;
        p_final_64 = 64'sd0;

        corr_x1_64 = 64'sd0;
        corr_x2_64 = 64'sd0;

        calculo_ok = 1'b0;


        if (
            (b4_64 > 0) &&
            (b7_64 >= 0)
        ) begin

            if (
                b7_64 <
                64'sh0000000080000000
            )
                p_base_64 =
                    (b7_64 * 64'sd2)
                    / b4_64;
            else
                p_base_64 =
                    (b7_64 / b4_64)
                    * 64'sd2;


            // Correcao final da pressao.

            corr_x1_64 =
                (p_base_64 >>> 8)
                * (p_base_64 >>> 8);

            corr_x1_64 =
                (corr_x1_64 * 64'sd3038)
                >>> 16;

            corr_x2_64 =
                (-64'sd7357 * p_base_64)
                >>> 16;

            p_final_64 =
                p_base_64 +
                (
                    (
                        corr_x1_64 +
                        corr_x2_64 +
                        64'sd3791
                    ) >>> 4
                );

            calculo_ok = 1'b1;

        end


        b6 = b6_64;
        b3 = b3_64;

        b4 = b4_64[31:0];
        b7 = b7_64[31:0];

        if (calculo_ok) begin

            pressao_base_pa =
                p_base_64[31:0];

            pressao_pa =
                p_final_64[31:0];

        end
        else begin

            pressao_base_pa = 32'd0;
            pressao_pa = 32'd0;

        end

    end

endmodule
