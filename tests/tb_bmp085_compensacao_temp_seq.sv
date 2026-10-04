`timescale 1ns/1ps
module tb_bmp085_compensacao_temp_seq;
    logic clk = 0, iniciar = 0;
    always #5 clk = ~clk;
    logic [15:0] ut_raw, ac5, ac6;
    logic signed [15:0] mc, md;
    wire signed [31:0] x1, x2, b5, ref_x1, ref_x2, ref_b5;
    wire signed [15:0] temperatura_decic, ref_temp;
    wire calculo_ok, ocupado, pronto, ref_ok;
    logic [112:0] esperado;
    integer ciclos, caso = 0;
    bmp085_compensacao_temp ref_dut (
        .ut_raw(ut_raw), .ac5(ac5), .ac6(ac6), .mc(mc), .md(md),
        .x1(ref_x1), .x2(ref_x2), .b5(ref_b5), .temperatura_decic(ref_temp), .calculo_ok(ref_ok)
    );
    bmp085_compensacao_temp_seq dut (.*);
    task automatic verificar;
        begin
            #1;
            esperado = {ref_x1, ref_x2, ref_b5, ref_temp, ref_ok};
            @(negedge clk); iniciar = 1;
            @(negedge clk); iniciar = 0;
            // Entradas mudam durante o calculo; a amostra capturada deve permanecer.
            ut_raw = 0; ac5 = 0; ac6 = 0; mc = 0; md = 0;
            ciclos = 0;
            while (!pronto && ciclos < 250) begin
                @(negedge clk); ciclos = ciclos + 1;
            end
            if (!pronto || ocupado || {x1, x2, b5, temperatura_decic, calculo_ok} !== esperado)
                $fatal(1, "TEMP caso=%0d obtido=%h esperado=%h ciclos=%0d", caso,
                    {x1, x2, b5, temperatura_decic, calculo_ok}, esperado, ciclos);
            @(negedge clk);
            if (pronto) $fatal(1, "TEMP pronto deve durar um ciclo");
            caso = caso + 1;
        end
    endtask
    initial begin
        ut_raw=27898; ac5=32757; ac6=23153; mc=-8711; md=2868;
        verificar();
        ut_raw=0; ac5=0; ac6=0; mc=-32768; md=0;
        verificar();
        ut_raw=0; ac5=0; ac6=0; mc=-32768; md=-1;
        verificar();
        repeat (200) begin
            ut_raw=$random; ac5=$random; ac6=$random; mc=$random; md=$random;
            verificar();
        end
        $display("PASS temperatura sequencial: %0d amostras equivalentes e captura estavel", caso);
        $finish;
    end
endmodule
