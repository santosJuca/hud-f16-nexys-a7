`timescale 1ns/1ps
module tb_bmp085_compensacao_seq;
    logic clk = 0, amostra_valid = 0;
    always #5 clk = ~clk;
    logic [15:0] ut_raw=27898, ac4=32741, ac5=32757, ac6=23153;
    logic [18:0] up_raw=23843;
    logic signed [15:0] ac1=408, ac2=-72, ac3=-14383, b1=6190, b2=4, mc=-8711, md=2868;
    wire signed [31:0] x1, x2, b5, b6, b3, ref_b5;
    wire signed [15:0] temperatura_decic;
    wire [31:0] b4, b7, pressao_base_pa, pressao_pa, ref_p;
    wire temp_calculo_ok, calculo_ok, pronto, ocupado, ref_temp_ok, ref_press_ok;
    wire [16:0] altitude_ft, ref_altitude;
    wire alt_ok, ref_alt_ok;
    logic [16:0] altitude_hold = 36000;
    logic [31:0] ref_p_capturada = 0;
    logic ref_valid_capturada = 0;
    logic [31:0] esperado[0:5];
    logic ok_esperado[0:5];
    integer recebidos = 0, enviados = 0, ciclos;
    logic [31:0] ultima_pressao = 0;
    logic ultimo_ok = 0;
    logic [16:0] altitude_anterior;
    bmp085_compensacao_seq dut (.*);
    bmp085_compensacao_temp ref_temp (
        .ut_raw(ut_raw), .ac5(ac5), .ac6(ac6), .mc(mc), .md(md),
        .x1(), .x2(), .b5(ref_b5), .temperatura_decic(), .calculo_ok(ref_temp_ok)
    );
    bmp085_compensacao_pressao ref_press (
        .up_raw(up_raw), .b5(ref_b5), .ac1(ac1), .ac2(ac2), .ac3(ac3), .ac4(ac4),
        .b1(b1), .b2(b2), .b6(), .b3(), .b4(), .b7(), .pressao_base_pa(),
        .pressao_pa(ref_p), .calculo_ok(ref_press_ok)
    );
    bmp085_altitude alt (.clk(clk), .pressao_pa(pressao_pa), .pressao_valid(calculo_ok),
        .altitude_ft(altitude_ft), .calculo_ok(alt_ok));
    bmp085_altitude ref_alt (.clk(clk), .pressao_pa(ref_p_capturada), .pressao_valid(ref_valid_capturada),
        .altitude_ft(ref_altitude), .calculo_ok(ref_alt_ok));
    always @(posedge clk) if (alt_ok) altitude_hold <= altitude_ft;
    always @(negedge clk) begin
        if (pronto) begin
            if (recebidos >= enviados || pressao_pa !== esperado[recebidos] || calculo_ok !== ok_esperado[recebidos])
                $fatal(1,"CADEIA amostra=%0d pressao=%0d esperada=%0d ok=%b esperado=%b",
                    recebidos,pressao_pa,esperado[recebidos],calculo_ok,ok_esperado[recebidos]);
            recebidos = recebidos + 1;
            ultima_pressao = pressao_pa;
            ultimo_ok = calculo_ok;
        end else if (pressao_pa !== ultima_pressao || calculo_ok !== ultimo_ok)
            $fatal(1,"CADEIA resultado mudou antes da conclusao");
    end
    task automatic enviar(input logic [18:0] up);
        begin
            @(negedge clk); amostra_valid=0; up_raw=up;
            @(negedge clk);
            esperado[enviados] = ref_temp_ok ? ref_p : 0;
            ok_esperado[enviados] = ref_temp_ok && ref_press_ok;
            enviados = enviados + 1;
            amostra_valid=1;
            @(negedge clk);
            amostra_valid=0;
        end
    endtask
    task automatic aguardar(input integer n);
        begin
            ciclos=0;
            while (recebidos<n && ciclos<2500) begin @(negedge clk); ciclos=ciclos+1; end
            if (recebidos!=n) $fatal(1,"CADEIA conclusoes=%0d esperadas=%0d",recebidos,n);
            repeat (40) @(negedge clk);
        end
    endtask
    initial begin
        repeat (5) @(negedge clk);
        if (altitude_hold!==36000) $fatal(1,"CADEIA fallback=%0d esperado=36000",altitude_hold);
        enviar(23843);
        repeat (15) @(negedge clk);
        enviar(30000);
        // Mudar todos os campos apos a captura nao deve contaminar a leitura pendente.
        ut_raw=0; ac4=0; ac5=0; ac6=0; ac1=0; ac2=0; ac3=0; b1=0; b2=0; mc=0; md=0;
        aguardar(2);
        ref_p_capturada=esperado[1]; ref_valid_capturada=1;
        repeat (40) @(negedge clk);
        if (altitude_hold!==ref_altitude) $fatal(1,"CADEIA altitude=%0d esperada=%0d",altitude_hold,ref_altitude);
        altitude_anterior=altitude_hold;
        enviar(23843); // Denominador zero.
        aguardar(3);
        if (altitude_hold!==altitude_anterior) $fatal(1,"CADEIA leitura invalida alterou altitude");
        ut_raw=27898; ac4=32741; ac5=32757; ac6=23153;
        ac1=408; ac2=-72; ac3=-14383; b1=6190; b2=4; mc=-8711; md=2868;
        enviar(23843);
        aguardar(4);
        // Nivel valid alto representa uma unica amostra, mesmo por varios calculos.
        @(negedge clk); amostra_valid=1;
        esperado[enviados]=ref_p; ok_esperado[enviados]=1; enviados=enviados+1;
        aguardar(5);
        repeat (1300) @(negedge clk);
        if (recebidos!=5 || ocupado) $fatal(1,"CADEIA repetiu amostra com valid alto");
        $display("PASS cadeia sequencial: captura, pendente, validade, recuperacao e retencao de altitude");
        $finish;
    end
endmodule
