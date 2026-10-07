`timescale 1ns/1ps
module tb_simulador_pouso;
    logic clk=0; always #5 clk=~clk;
    logic reset=1,enable=1,tick=0;
    wire [2:0] fase; wire [9:0] velocidade_kt; wire [16:0] altitude_ft;
    wire signed [13:0] vertical_fpm;
    integer v,h,f; logic [4:0] vistos=0;
    simulador_pouso dut(.*);
    initial begin
        repeat(2) @(negedge clk); reset=0;
        v=160; h=1500; f=0;
        for(int i=0;i<3000;i++) begin
            tick=1; @(negedge clk); tick=0;
            if(fase>4 || fase<f || fase>f+1) $fatal(1,"Fase=%0d anterior=%0d",fase,f);
            vistos[fase]=1;
            if(velocidade_kt>v || altitude_ft>h || int'(velocidade_kt)<v-1 || int'(altitude_ft)<h-1)
                $fatal(1,"Tick=%0d: v=%0d h=%0d anterior=%0d/%0d",i,velocidade_kt,altitude_ft,v,h);
            if(fase>=3 && (altitude_ft!=0 || vertical_fpm!=0)) $fatal(1,"Solo: altitude/VSI nao zero");
            if(fase==0 && vertical_fpm!=-1200) $fatal(1,"VSI approach incorreto");
            if(fase==1 && vertical_fpm!=-600) $fatal(1,"VSI final incorreto");
            if(fase==2 && vertical_fpm!=-300) $fatal(1,"VSI flare incorreto");
            v=velocidade_kt; h=altitude_ft; f=fase;
            @(negedge clk);
            if(velocidade_kt!=v || altitude_ft!=h) $fatal(1,"Sem tick: dados mudaram");
        end
        if(vistos!==5'b11111 || velocidade_kt!=0 || altitude_ft!=0) $fatal(1,"Pouso incompleto");
        enable=0; @(negedge clk);
        if(fase!=0 || altitude_ft!=1500 || velocidade_kt!=160) $fatal(1,"Reentrada incorreta");
        enable=1; tick=1; repeat(10) @(negedge clk); reset=1; @(negedge clk);
        if(fase!=0 || altitude_ft!=1500 || velocidade_kt!=160) $fatal(1,"Reset incorreto");
        $display("PASS pouso: cinco fases, monotonia, VSI, parada, reentrada e reset"); $finish;
    end
endmodule
