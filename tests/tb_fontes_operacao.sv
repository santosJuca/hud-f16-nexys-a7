`timescale 1ns/1ps
module tb_fontes_operacao;
    logic clk=0; always #5 clk=~clk;
    logic reset=1,ack=0; logic [1:0] switches=0;
    logic [2:0] fontes_validas=7,novas_amostras=0;
    logic signed [31:0] pitch_real_q10=0,roll_real_q10=0;
    logic signed [10:0] pitch_real_px=0,pitch_fallback_px=40;
    logic signed [9:0] roll_real_q8=0,roll_fallback_q8=64;
    logic [16:0] altitude_real_ft=1234;
    logic [8:0] heading_real_deg=123,heading_manual_deg=270;
    logic signed [13:0] vertical_real_fpm=60;
    logic vertical_real_valido=1;
    wire [56:0] dados; wire [31:0] metadados; wire buzzer_out;
    operacao_hud #(.TICK_CYCLES(4),.DEBOUNCE_CYCLES(2),.ACK_CYCLES(2),
        .ATT_TIMEOUT(12),.ALT_TIMEOUT(16),.HDG_TIMEOUT(20)) dut(.*);
    task automatic confere(input logic [2:0] validos);
        if(metadados[5:3]!=={validos[2],validos[1],validos[0]})
            $fatal(1,"Validades=%b esperado=%b",metadados[5:3],validos);
    endtask
    initial begin
        repeat(2) @(negedge clk); reset=0;
        repeat(3) @(negedge clk); confere(0);
        if(dados[56:30]!=0) $fatal(1,"SOLO antes da primeira amostra deve zerar V/ALT");
        novas_amostras=7; repeat(3) @(negedge clk); confere(7);
        novas_amostras=0;
        repeat(13) @(negedge clk); confere(6);
        repeat(4) @(negedge clk); confere(4);
        repeat(4) @(negedge clk); confere(0);
        novas_amostras=7; repeat(3) @(negedge clk); confere(7);
        fontes_validas=0; @(negedge clk); confere(0);
        fontes_validas=7; novas_amostras=0; repeat(3) @(negedge clk); confere(0);
        switches=1; repeat(10) @(negedge clk);
        if(!metadados[7] || !metadados[24] || metadados[1:0]!=1 || dados[8:0]!=270)
            $fatal(1,"VOO sem sensor: fallback deve ser explicito");
        novas_amostras=7; repeat(3) @(negedge clk);
        if(metadados[7] || metadados[24]) $fatal(1,"Recuperacao nao removeu fallback/falha");
        reset=1; @(negedge clk);
        if(dados!=0 || buzzer_out) $fatal(1,"Reset incorreto");
        $display("PASS fontes: primeira amostra, expiracao individual, perda, recuperacao e fallback"); $finish;
    end
endmodule
