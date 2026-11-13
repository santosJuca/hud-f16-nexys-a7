`timescale 1ns/1ps
module tb_modo_operacao;
    logic clk=0; always #5 clk=~clk;
    logic reset=1; logic [1:0] switches=0;
    wire [1:0] modo; wire modo_invalido;
    controle_modo_operacao #(.DEBOUNCE_CYCLES(4)) dut(.*);
    task automatic seleciona(input logic [1:0] valor);
        @(negedge clk); switches=valor;
        repeat(10) @(negedge clk);
        if(modo !== (valor==3 ? 2'd0 : valor) || modo_invalido !== (valor==3))
            $fatal(1,"SW=%b: modo=%b invalido=%b esperado=%b/%b",valor,modo,modo_invalido,valor==3?2'd0:valor,valor==3);
    endtask
    initial begin
        repeat(2) @(negedge clk); reset=0;
        seleciona(0); seleciona(1);
        switches=2; repeat(2) @(negedge clk); switches=1;
        repeat(10) @(negedge clk);
        if(modo!==1) $fatal(1,"Repique: modo=%d esperado=1",modo);
        seleciona(2); seleciona(3); seleciona(0);
        reset=1; @(negedge clk);
        if(modo!==0 || modo_invalido) $fatal(1,"Reset: esperado SOLO valido");
        $display("PASS modo operacional: 00/01/10/11, repique e reset"); $finish;
    end
endmodule
