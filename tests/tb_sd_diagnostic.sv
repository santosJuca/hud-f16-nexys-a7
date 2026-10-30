`timescale 1ns/1ps
module tb_sd_diagnostic;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, read_switch=1, ready=0, busy=0, failed=0;
    reg data_valid=0, block_valid=0, read_error=0;
    reg [7:0] data_byte=0;
    reg [8:0] byte_index=0;
    wire request, diagnostic_error;
    integer requests=0;
    sd_diagnostic #(.DEBOUNCE_CYCLES(4)) dut(.*);
    always @(negedge clk) if(request) requests=requests+1;
    task automatic cycles(input integer n);
        repeat(n) @(negedge clk);
    endtask
    initial begin
        cycles(3); rst=0; cycles(12); ready=1; cycles(12);
        if(requests) $fatal(1,"Switch alto na partida iniciou leitura");
        read_switch=0; cycles(12);
        read_switch=1; cycles(1); read_switch=0; cycles(12);
        if(requests) $fatal(1,"Bounce iniciou leitura");
        read_switch=1; cycles(12);
        if(requests != 1) $fatal(1,"Solicitacao ausente");
        busy=1; data_valid=1; data_byte=0; cycles(1); data_valid=0;
        cycles(4);
        if(diagnostic_error) $fatal(1,"Dado provisório publicado antes do CRC");
        read_error=1; cycles(3); read_error=0;
        if(diagnostic_error) $fatal(1,"Bloco sem CRC foi publicado");
        busy=0; read_switch=0; cycles(12); read_switch=1; cycles(12);
        if(requests!=2) $fatal(1,"Nova solicitacao ausente");
        data_valid=1; data_byte=0; cycles(1); data_valid=0;
        block_valid=1; cycles(1); block_valid=0; cycles(2);
        if(!diagnostic_error) $fatal(1,"Formato incorreto com CRC valido não sinalizado");
        read_switch=0; cycles(12); read_switch=1; cycles(12);
        data_valid=1; data_byte=8'hA5; cycles(1); data_valid=0;
        block_valid=1; cycles(1); block_valid=0; cycles(2);
        if(diagnostic_error) $fatal(1,"Diagnostico correto rejeitado");
        cycles(20);
        if(requests!=3) $fatal(1,"Switch mantido repetiu pedido");
        $display("PASS sd_diagnostic: debounce, armamento, CRC e publicacao atomica");
        $finish;
    end
    initial begin #100000; $fatal(1,"timeout"); end
endmodule
