`timescale 1ns/1ps
module tb_simulador_voo;
    logic clk=0; always #5 clk=~clk;
    logic reset=1,enable=1,tick=0;
    wire [9:0] velocidade_kt; wire [16:0] altitude_ft;
    integer v,h,minv=999,maxv=0,minh=99999,maxh=0;
    simulador_voo dut(.*);
    initial begin
        repeat(2) @(negedge clk); reset=0;
        if(velocidade_kt !== 10'd280 || altitude_ft !== 17'd36000)
            $fatal(1,"Inicial: velocidade=%0d altitude=%0d esperado=280/36000",velocidade_kt,altitude_ft);
        v=velocidade_kt; h=altitude_ft;
        for(int i=0;i<2000;i++) begin
            tick=1; @(negedge clk); tick=0;
            if((^{velocidade_kt,altitude_ft}) === 1'bx) $fatal(1,"Tick=%0d: saida indefinida",i);
            if(velocidade_kt<275 || velocidade_kt>285 || altitude_ft<35950 || altitude_ft>36050)
                $fatal(1,"Tick=%0d: velocidade=%0d altitude=%0d fora da faixa",i,velocidade_kt,altitude_ft);
            if(velocidade_kt>v+1 || velocidade_kt<v-1 || altitude_ft>h+1 || altitude_ft<h-1)
                $fatal(1,"Tick=%0d: salto maior que 1 kt/ft",i);
            v=velocidade_kt; h=altitude_ft;
            if(v<minv) minv=v; if(v>maxv) maxv=v;
            if(h<minh) minh=h; if(h>maxh) maxh=h;
            repeat(2) @(negedge clk);
            if(velocidade_kt!=v || altitude_ft!=h) $fatal(1,"Sem tick: dados mudaram");
        end
        if(minv!=275 || maxv!=285 || minh!=35950 || maxh!=36050) $fatal(1,"Oscilacao incompleta");
        enable=0; @(negedge clk);
        if(velocidade_kt!=280 || altitude_ft!=36000) $fatal(1,"Disable: esperado 280/36000");
        enable=1; reset=1; @(negedge clk);
        if(velocidade_kt!=280 || altitude_ft!=36000) $fatal(1,"Reset: esperado 280/36000");
        $display("PASS voo: 2000 ticks, faixas, continuidade, retencao e reset"); $finish;
    end
endmodule
