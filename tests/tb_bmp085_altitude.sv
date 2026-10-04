`timescale 1ns/1ps

module tb_bmp085_altitude;

    logic clk = 1'b0;

    logic [31:0] pressao_pa;
    logic        pressao_valid;

    logic [16:0] altitude_ft;
    logic        calculo_ok;

    always #5 clk = ~clk;

    bmp085_altitude dut (
        .clk           (clk),
        .pressao_pa    (pressao_pa),
        .pressao_valid (pressao_valid),
        .altitude_ft   (altitude_ft),
        .calculo_ok    (calculo_ok)
    );

    task automatic verificar_valido(
        input logic [31:0] pressao,
        input integer altitude_esperada
    );
        integer timeout;
        begin
            pressao_pa    = pressao;
            pressao_valid = 1'b1;

            timeout = 0;

            while (!calculo_ok && timeout < 40) begin
                @(posedge clk);
                #1;
                timeout = timeout + 1;
            end

            if (!calculo_ok) begin
                $display("FAIL TIMEOUT: P=%0d Pa", pressao);
                $fatal(1);
            end

            if (altitude_ft !== altitude_esperada[16:0]) begin
                $display(
                    "FAIL ALT: P=%0d esperado=%0d obtido=%0d",
                    pressao,
                    altitude_esperada,
                    altitude_ft
                );
                $fatal(1);
            end

            $display(
                "PASS: P=%0d Pa -> altitude=%0d ft",
                pressao,
                altitude_ft
            );

            @(posedge clk);
            #1;
        end
    endtask

    task automatic verificar_invalido(
        input logic [31:0] pressao,
        input logic valido
    );
        integer i;
        begin
            pressao_valid = 1'b0;

            @(posedge clk);
            #1;

            pressao_pa    = pressao;
            pressao_valid = valido;

            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                #1;

                if (calculo_ok) begin
                    $display(
                        "FAIL INVALIDO: P=%0d gerou calculo_ok",
                        pressao
                    );
                    $fatal(1);
                end
            end

            if (altitude_ft !== 17'd0) begin
                $display(
                    "FAIL INVALIDO: P=%0d altitude=%0d",
                    pressao,
                    altitude_ft
                );
                $fatal(1);
            end

            $display(
                "PASS INVALIDO: P=%0d valid=%0b",
                pressao,
                valido
            );
        end
    endtask

    initial begin

        pressao_pa    = 32'd0;
        pressao_valid = 1'b0;

        repeat (2) @(posedge clk);
        #1;

        verificar_invalido(32'd101325, 1'b0);

        verificar_valido(32'd101325, 0);
        verificar_valido(32'd100000, 364);
        verificar_valido(32'd95000, 1773);
        verificar_valido(32'd90000, 3244);
        verificar_valido(32'd80000, 6395);
        verificar_valido(32'd70000, 9884);
        verificar_valido(32'd60000, 13803);
        verificar_valido(32'd50000, 18291);
        verificar_valido(32'd40000, 23577);
        verificar_valido(32'd30000, 30069);

        verificar_valido(32'd69964, 9897);

        verificar_valido(32'd110000, 0);
        verificar_valido(32'd120000, 0);

        verificar_invalido(32'd29999, 1'b1);
        verificar_invalido(32'd120001, 1'b1);

        $display("");
        $display("PASS: tb_bmp085_altitude sequencial");
        $finish;
    end

endmodule
