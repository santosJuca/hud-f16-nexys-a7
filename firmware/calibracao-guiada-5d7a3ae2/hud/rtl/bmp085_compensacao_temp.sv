module bmp085_compensacao_temp (
    input  logic        [15:0] ut_raw,

    input  logic        [15:0] ac5,
    input  logic        [15:0] ac6,

    input  logic signed [15:0] mc,
    input  logic signed [15:0] md,

    output logic signed [31:0] x1,
    output logic signed [31:0] x2,
    output logic signed [31:0] b5,

    // Temperatura em decimos de grau Celsius.
    // Exemplo: 150 = 15,0 C.
    output logic signed [15:0] temperatura_decic,

    output logic calculo_ok
);

    logic signed [63:0] ut_64;
    logic signed [63:0] ac5_64;
    logic signed [63:0] ac6_64;
    logic signed [63:0] mc_64;
    logic signed [63:0] md_64;

    logic signed [63:0] x1_64;
    logic signed [63:0] x2_64;
    logic signed [63:0] b5_64;
    logic signed [63:0] denominador;


    always_comb begin

        ut_64  = $signed({1'b0, ut_raw});
        ac5_64 = $signed({1'b0, ac5});
        ac6_64 = $signed({1'b0, ac6});

        mc_64 = $signed(mc);
        md_64 = $signed(md);


        // Formula oficial BMP085:
        //
        // X1 = ((UT - AC6) * AC5) >> 15
        // X2 = (MC << 11) / (X1 + MD)
        // B5 = X1 + X2
        // T  = (B5 + 8) >> 4
        //
        // T fica em 0,1 grau Celsius.

        x1_64 =
            ((ut_64 - ac6_64) * ac5_64)
            >>> 15;

        denominador =
            x1_64 + md_64;


        if (denominador != 0) begin

            x2_64 =
                (mc_64 <<< 11)
                / denominador;

            b5_64 =
                x1_64 + x2_64;

            temperatura_decic =
                $signed(
                    (b5_64 + 64'sd8)
                    >>> 4
                );

            calculo_ok = 1'b1;

        end
        else begin

            x2_64 = 64'sd0;
            b5_64 = 64'sd0;

            temperatura_decic = 16'sd0;

            calculo_ok = 1'b0;

        end


        x1 = x1_64;
        x2 = x2_64;
        b5 = b5_64;

    end

endmodule
