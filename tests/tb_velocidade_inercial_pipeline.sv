`timescale 1ns/1ps
module tb_velocidade_inercial_pipeline;
    logic clk=0,ok=0,nova=0,dt_valid=0,atitude=1;
    always #5 clk=~clk;
    logic signed [15:0] accel=100;
    logic signed [10:0] pitch=0;
    logic [31:0] dt=0;
    wire calibrado,valido;
    wire [9:0] velocidade;
    velocidade_inercial #(.CAL_LOG2(2)) dut(clk,ok,nova,accel,pitch,atitude,
        dt_valid,dt,calibrado,valido,velocidade);
    longint signed esperado=0,linear,delta;
    task automatic calibra;
        @(negedge clk); ok=1; accel=100; nova=1;
        repeat(4) @(negedge clk);
        nova=0;
        if(!calibrado) $fatal(1,"pipeline: calibracao nao concluiu");
    endtask
    task automatic entrada(input integer a,p, input logic [31:0] intervalo, input bit usar);
        accel=16'(a); pitch=11'(p); dt=intervalo; dt_valid=usar;
        linear=a-100-p*72;
        if(usar && (linear>300 || linear< -300)) begin
            delta=(linear*$signed({1'b0,intervalo})*13) >>> 24;
            esperado=esperado+delta;
            if(esperado<0) esperado=0;
            if(esperado>32768000) esperado=32768000;
        end
        @(negedge clk);
    endtask
    task automatic confere;
        dt_valid=0;
        repeat(5) @(negedge clk);
        if(dut.velocidade_q16 !== 32'(esperado) || velocidade !== 10'(esperado >>>16))
            $fatal(1,"pipeline: Q16=%0d esperado=%0d KT=%0d",dut.velocidade_q16,esperado,velocidade);
    endtask
    initial begin
        repeat(2) @(negedge clk); calibra();
        // Amostras consecutivas, saturacao superior/inferior e deadzone.
        repeat(10) entrada(32767,0,32'hffffffff,1);
        confere(); if(velocidade!=500) $fatal(1,"saturacao superior !=500");
        repeat(10) entrada(-32768,0,32'hffffffff,1);
        confere(); if(velocidade!=0) $fatal(1,"saturacao inferior !=0");
        for(integer i=0;i<300;i=i+1) begin
            entrada($signed(16'($urandom)), $signed(8'($urandom)), $urandom, (i%4)!=0);
            if(i%17==0) confere();
        end
        entrada(400,0,32'hffffffff,1); entrada(-200,0,32'hffffffff,1);
        confere();
        // Perda com operacoes pendentes nao pode publicar depois do reset.
        entrada(32767,0,32'hffffffff,1);
        ok=0;dt_valid=0; esperado=0;
        repeat(5) @(negedge clk); confere();
        if(calibrado || valido) $fatal(1,"pipeline: perda nao invalidou");
        calibra(); confere();
        $display("PASS velocidade pipeline: amostras consecutivas, modelo Q16, dt invalido, deadzone, limites 0/500 e perda em voo");
        $finish;
    end
endmodule
