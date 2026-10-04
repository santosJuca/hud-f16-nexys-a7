`timescale 1ns/1ps
module tb_bmp085_aritmetica_seq;
    logic clk=0, iniciar=0, dividir=0;
    always #5 clk=~clk;
    logic signed [63:0] a=0, b=1;
    wire signed [63:0] resultado;
    wire ocupado, pronto;
    logic signed [63:0] esperado, entrada_a, entrada_b;
    integer ciclos, casos=0;
    bmp085_aritmetica_seq dut (.*);
    task automatic verificar(input logic div, input logic signed [63:0] aa, bb);
        begin
            @(negedge clk); a=aa; b=bb; dividir=div; iniciar=1;
            esperado=div ? (aa/bb) : (aa*bb);
            @(negedge clk); iniciar=0; a=0; b=0;
            ciclos=0;
            while (!pronto && ciclos<140) begin @(negedge clk); ciclos=ciclos+1; end
            if (!pronto || ocupado || resultado!==esperado)
                $fatal(1,"ARIT div=%b a=%h b=%h obtido=%h esperado=%h",div,aa,bb,resultado,esperado);
            @(negedge clk);
            if (pronto) $fatal(1,"ARIT pronto deve durar um ciclo");
            casos=casos+1;
        end
    endtask
    initial begin
        verificar(1,64'sh8000000000000000,-64'sd1);
        verificar(1,64'sh8000000000000000,64'sh8000000000000000);
        verificar(1,64'sh7fffffffffffffff,-64'sd3);
        verificar(1,-64'sd17,64'sd3);
        verificar(1,64'sd17,-64'sd3);
        verificar(1,-64'sd17,-64'sd3);
        verificar(1,64'sd0,64'sd1);
        verificar(0,64'sh7fffffffffffffff,64'sh7fffffffffffffff);
        repeat (100) begin
            entrada_a={$random,$random}; entrada_b={$random,$random};
            verificar(0,entrada_a,entrada_b);
            if (entrada_b!=0) verificar(1,entrada_a,entrada_b);
        end
        $display("PASS aritmetica BMP085: %0d produtos/divisoes signed, limites e truncamento",casos);
        $finish;
    end
endmodule
