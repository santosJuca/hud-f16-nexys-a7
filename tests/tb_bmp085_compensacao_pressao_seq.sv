`timescale 1ns/1ps
module tb_bmp085_compensacao_pressao_seq;
    logic clk = 0, iniciar = 0;
    always #5 clk = ~clk;
    logic [18:0] up_raw;
    logic signed [31:0] b5;
    logic signed [15:0] ac1, ac2, ac3, b1, b2;
    logic [15:0] ac4;
    wire signed [31:0] b6, b3, ref_b6, ref_b3;
    wire [31:0] b4, b7, pressao_base_pa, pressao_pa, ref_b4, ref_b7, ref_base, ref_p;
    wire calculo_ok, ocupado, pronto, ref_ok;
    logic [192:0] esperado;
    integer ciclos, caso = 0;
    integer ramo_baixo = 0, ramo_alto = 0, invalidos = 0;
    bmp085_compensacao_pressao ref_dut (
        .up_raw(up_raw), .b5(b5), .ac1(ac1), .ac2(ac2), .ac3(ac3), .ac4(ac4), .b1(b1), .b2(b2),
        .b6(ref_b6), .b3(ref_b3), .b4(ref_b4), .b7(ref_b7),
        .pressao_base_pa(ref_base), .pressao_pa(ref_p), .calculo_ok(ref_ok)
    );
    bmp085_compensacao_pressao_seq dut (.*);
    task automatic verificar;
        begin
            #1;
            esperado = {ref_b6, ref_b3, ref_b4, ref_b7, ref_base, ref_p, ref_ok};
            if (!ref_ok) invalidos = invalidos + 1;
            else if (ref_dut.b7_64 < 64'sh80000000) ramo_baixo = ramo_baixo + 1;
            else ramo_alto = ramo_alto + 1;
            @(negedge clk); iniciar = 1;
            @(negedge clk); iniciar = 0;
            up_raw=0; b5=0; ac1=0; ac2=0; ac3=0; ac4=0; b1=0; b2=0;
            ciclos = 0;
            while (!pronto && ciclos < 1200) begin
                @(negedge clk); ciclos = ciclos + 1;
            end
            if (!pronto || ocupado || {b6,b3,b4,b7,pressao_base_pa,pressao_pa,calculo_ok} !== esperado)
                $fatal(1,"PRESS caso=%0d obtido=%h esperado=%h ciclos=%0d",caso,
                    {b6,b3,b4,b7,pressao_base_pa,pressao_pa,calculo_ok},esperado,ciclos);
            @(negedge clk);
            if (pronto) $fatal(1,"PRESS pronto deve durar um ciclo");
            caso = caso + 1;
        end
    endtask
    task automatic referencia(input logic [18:0] up);
        begin
            up_raw=up; b5=2400; ac1=408; ac2=-72; ac3=-14383; ac4=32741; b1=6190; b2=4;
        end
    endtask
    initial begin
        referencia(23843); verificar();
        referencia(60000); verificar();
        referencia(0); verificar();
        referencia(23843); ac4=0; verificar();
        repeat (100) begin
            referencia($urandom_range(10000,70000));
            b5=$urandom_range(0,8000);
            verificar();
        end
        repeat (200) begin
            up_raw=$random; b5=$random; ac1=$random; ac2=$random;
            ac3=$random; ac4=$random; b1=$random; b2=$random;
            verificar();
        end
        if (!ramo_baixo || !ramo_alto || !invalidos) $fatal(1,"PRESS cobertura incompleta");
        $display("PASS pressao sequencial: %0d amostras, B7 baixo=%0d alto=%0d invalidas=%0d",
            caso,ramo_baixo,ramo_alto,invalidos);
        $finish;
    end
endmodule
