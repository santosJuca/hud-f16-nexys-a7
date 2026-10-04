`timescale 1ns/1ps

module tb_bmp085_altitude_monotonia;

    logic clk = 1'b0;

    logic [31:0] pressao_pa;
    logic        pressao_valid;

    logic [16:0] altitude_ft;
    logic        calculo_ok;

    integer p;
    integer timeout;
    integer amostras;

    logic [16:0] altitude_anterior;

    always #5 clk = ~clk;

    bmp085_altitude dut (
        .clk           (clk),
        .pressao_pa    (pressao_pa),
        .pressao_valid (pressao_valid),
        .altitude_ft   (altitude_ft),
        .calculo_ok    (calculo_ok)
    );

    initial begin

        pressao_pa    = 32'd0;
        pressao_valid = 1'b0;

        repeat (2) @(posedge clk);
        #1;

        pressao_valid = 1'b1;

        altitude_anterior = 17'd0;
        amostras = 0;

        for (p = 101325; p >= 30000; p = p - 1) begin

            pressao_pa = p;

            timeout = 0;

            while (!calculo_ok && timeout < 40) begin
                @(posedge clk);
                #1;
                timeout = timeout + 1;
            end

            if (!calculo_ok) begin
                $display("FAIL TIMEOUT: P=%0d", p);
                $fatal(1);
            end

            if (
                (amostras != 0) &&
                (altitude_ft < altitude_anterior)
            ) begin
                $display(
                    "FAIL MONOTONIA: P=%0d anterior=%0d atual=%0d",
                    p,
                    altitude_anterior,
                    altitude_ft
                );
                $fatal(1);
            end

            altitude_anterior = altitude_ft;
            amostras = amostras + 1;

            @(posedge clk);
            #1;
        end

        $display(
            "PASS: monotonicidade verificada em %0d pressoes",
            amostras
        );

        $display(
            "PASS: tb_bmp085_altitude_monotonia sequencial"
        );

        $finish;
    end

endmodule
