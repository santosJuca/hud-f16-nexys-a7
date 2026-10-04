`timescale 1ns/1ps

module tb_bmp085_compensacao_pressao;

    logic [18:0] up_raw;

    logic signed [31:0] b5;

    logic signed [15:0] ac1;
    logic signed [15:0] ac2;
    logic signed [15:0] ac3;

    logic [15:0] ac4;

    logic signed [15:0] b1;
    logic signed [15:0] b2;


    wire signed [31:0] b6;
    wire signed [31:0] b3;

    wire [31:0] b4;
    wire [31:0] b7;

    wire [31:0] pressao_base_pa;
    wire [31:0] pressao_pa;

    wire calculo_ok;


    bmp085_compensacao_pressao dut (
        .up_raw         (up_raw),
        .b5             (b5),

        .ac1            (ac1),
        .ac2            (ac2),
        .ac3            (ac3),
        .ac4            (ac4),

        .b1             (b1),
        .b2             (b2),

        .b6             (b6),
        .b3             (b3),
        .b4             (b4),
        .b7             (b7),

        .pressao_base_pa(pressao_base_pa),
        .pressao_pa     (pressao_pa),

        .calculo_ok     (calculo_ok)
    );


    task automatic falha(input string msg);
        begin

            $display(
                "FAIL BMP085 PRESS COMP: %s",
                msg
            );

            $fatal(1);

        end
    endtask


    initial begin

        $display(
            "===== TESTE BMP085 COMPENSACAO PRESSAO ====="
        );


        // Vetor de referencia BMP085.
        //
        // AC1 = 408
        // AC2 = -72
        // AC3 = -14383
        // AC4 = 32741
        // B1  = 6190
        // B2  = 4
        // B5  = 2400
        // UP  = 23843
        // OSS = 0
        //
        // Esperado:
        //
        // B6   = -1600
        // B3   = 422
        // B4   = 33457
        // B7   = 1171050000
        // P0   = 70003 Pa
        // P    = 69964 Pa

        up_raw = 19'd23843;

        b5 = 32'sd2400;

        ac1 =  16'sd408;
        ac2 = -16'sd72;
        ac3 = -16'sd14383;

        ac4 = 16'd32741;

        b1 = 16'sd6190;
        b2 = 16'sd4;


        #10;


        if (calculo_ok !== 1'b1)
            falha(
                "calculo_ok deveria estar ativo"
            );


        if (b6 !== -32'sd1600) begin

            $display(
                "B6 esperado=-1600 recebido=%0d",
                $signed(b6)
            );

            falha("B6 incorreto");

        end


        if (b3 !== 32'sd422) begin

            $display(
                "B3 esperado=422 recebido=%0d",
                $signed(b3)
            );

            falha("B3 incorreto");

        end


        if (b4 !== 32'd33457) begin

            $display(
                "B4 esperado=33457 recebido=%0d",
                b4
            );

            falha("B4 incorreto");

        end


        if (b7 !== 32'd1171050000) begin

            $display(
                "B7 esperado=1171050000 recebido=%0d",
                b7
            );

            falha("B7 incorreto");

        end


        if (pressao_base_pa !== 32'd70003) begin

            $display(
                "P0 esperado=70003 recebido=%0d",
                pressao_base_pa
            );

            falha(
                "pressao antes da correcao incorreta"
            );

        end


        if (pressao_pa !== 32'd69964) begin

            $display(
                "P esperado=69964 recebido=%0d",
                pressao_pa
            );

            falha(
                "pressao compensada incorreta"
            );

        end


        $display(
            "PASS B6=%0d B3=%0d B4=%0d B7=%0d",
            $signed(b6),
            $signed(b3),
            b4,
            b7
        );

        $display(
            "PASS pressao base=%0d Pa",
            pressao_base_pa
        );

        $display(
            "PASS pressao compensada=%0d Pa",
            pressao_pa
        );

        $display(
            "PASS todos os testes BMP085 compensacao pressao"
        );

        $finish;

    end

endmodule
