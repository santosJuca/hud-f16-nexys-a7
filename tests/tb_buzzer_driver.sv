`timescale 1ns/1ps
module tb_buzzer_driver;
    logic clk=0; always #5 clk=~clk;
    logic reset=1,ack=0,enable=1; logic [1:0] severity=0;
    wire buzzer_out,reconhecido;
    buzzer_driver #(.DEBOUNCE_CYCLES(2),.INFO_ON(2),.INFO_OFF(8),
        .CAUTION_ON(3),.CAUTION_OFF(7),.WARNING_ON(2),.WARNING_OFF(2)) dut(.*);
    task automatic cadencia(input logic [1:0] sev,input integer periodo,on_cycles);
        severity=sev; @(negedge clk);
        for(int k=0;k<periodo*3;k++) begin
            if(buzzer_out !== (k%periodo<on_cycles))
                $fatal(1,"Severity=%0d ciclo=%0d: saida=%b esperado=%b",sev,k,buzzer_out,k%periodo<on_cycles);
            @(negedge clk);
        end
    endtask
    initial begin
        repeat(2) @(negedge clk); reset=0;
        if(buzzer_out) $fatal(1,"NONE deve estar OFF");
        cadencia(1,10,2); cadencia(2,10,3); cadencia(3,4,2);
        severity=2; repeat(3) @(negedge clk);
        ack=1; @(negedge clk); ack=0; repeat(8) @(negedge clk);
        if(reconhecido) $fatal(1,"Repique reconheceu alerta");
        ack=1; repeat(8) @(negedge clk);
        if(!reconhecido || buzzer_out) $fatal(1,"ACK nao silenciou");
        severity=3; @(negedge clk);
        if(reconhecido || !buzzer_out) $fatal(1,"Escalada nao reativou audio");
        repeat(10) @(negedge clk);
        if(reconhecido) $fatal(1,"ACK mantido reconheceu alerta novo");
        ack=0; repeat(8) @(negedge clk); ack=1; repeat(8) @(negedge clk);
        if(!reconhecido || buzzer_out) $fatal(1,"Segundo ACK falhou");
        severity=0; @(negedge clk);
        if(reconhecido || buzzer_out) $fatal(1,"Fim do alerta nao limpou ACK");
        severity=2; @(negedge clk); enable=0; #1;
        if(buzzer_out) $fatal(1,"Enable=0 nao silenciou");
        @(negedge clk); enable=1; reset=1; @(negedge clk);
        if(buzzer_out || reconhecido) $fatal(1,"Reset incorreto");
        $display("PASS buzzer: cadencias, debounce, ACK, escalada, fim, enable e reset"); $finish;
    end
endmodule
