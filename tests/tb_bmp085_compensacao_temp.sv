`timescale 1ns/1ps

module tb_bmp085_compensacao_temp;

    logic [15:0] ut_raw;

    logic [15:0] ac5;
    logic [15:0] ac6;

    logic signed [15:0] mc;
    logic signed [15:0] md;

    wire signed [31:0] x1;
    wire signed [31:0] x2;
    wire signed [31:0] b5;

    wire signed [15:0] temperatura_decic;

    wire calculo_ok;


    bmp085_compensacao_temp dut (
        .ut_raw            (ut_raw),

        .ac5               (ac5),
        .ac6               (ac6),

        .mc                (mc),
        .md                (md),

        .x1                (x1),
        .x2                (x2),
        .b5                (b5),

        .temperatura_decic (temperatura_decic),

        .calculo_ok        (calculo_ok)
    );


    task automatic falha(input string msg);
        begin
            $display(
                "FAIL BMP085 TEMP COMP: %s",
                msg
            );

            $fatal(1);
        end
    endtask


    initial begin

        $display(
            "===== TESTE BMP085 COMPENSACAO TEMPERATURA ====="
        );


        // Vetor de referencia utilizado no datasheet.
        //
        // UT  = 27898
        // AC5 = 32757
        // AC6 = 23153
        // MC  = -8711
        // MD  = 2868
        //
        // Resultado esperado:
        // X1 = 4743
        // X2 = -2343
        // B5 = 2400
        // T  = 150 = 15,0 C.

        ut_raw = 16'd27898;

        ac5 = 16'd32757;
        ac6 = 16'd23153;

        mc = -16'sd8711;
        md =  16'sd2868;

        #10;


        if (calculo_ok !== 1'b1)
            falha(
                "calculo_ok deveria estar ativo"
            );


        if (x1 !== 32'sd4743) begin
            $display(
                "X1 esperado=4743 recebido=%0d",
                $signed(x1)
            );

            falha("X1 incorreto");
        end


        if (x2 !== -32'sd2343) begin
            $display(
                "X2 esperado=-2343 recebido=%0d",
                $signed(x2)
            );

            falha("X2 incorreto");
        end


        if (b5 !== 32'sd2400) begin
            $display(
                "B5 esperado=2400 recebido=%0d",
                $signed(b5)
            );

            falha("B5 incorreto");
        end


        if (temperatura_decic !== 16'sd150) begin
            $display(
                "T esperado=150 recebido=%0d",
                $signed(temperatura_decic)
            );

            falha(
                "temperatura compensada incorreta"
            );
        end


        $display(
            "PASS X1=%0d X2=%0d B5=%0d",
            $signed(x1),
            $signed(x2),
            $signed(b5)
        );

        $display(
            "PASS temperatura=%0d deciC = 15,0 C",
            $signed(temperatura_decic)
        );

        $display(
            "PASS todos os testes BMP085 compensacao temperatura"
        );

        $finish;

    end

endmodule
