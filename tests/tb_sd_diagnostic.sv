`timescale 1ns/1ps
module tb_sd_diagnostic;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, read_switch=1, ready=0, busy=0, failed=0;
    reg data_valid=0, block_valid=0, read_error=0;
    reg [2:0] read_error_code=0;
    reg [7:0] data_byte=0;
    reg [8:0] byte_index=0;
    wire request, diagnostic_error, crc_ok, data_ok;
    wire [9:0] byte_count;
    wire [8:0] first_mismatch;
    wire [7:0] expected_byte, received_byte;
    wire [31:0] attempts, timeout_count, good_reads, failed_reads;
    integer requests=0, i;
    sd_diagnostic #(.DEBOUNCE_CYCLES(4), .REFERENCE_FILE("tests/sd_reference.hex")) dut(.*);
    always @(negedge clk) if(request) requests=requests+1;
    task automatic cycles(input integer n);
        repeat(n) @(negedge clk);
    endtask
    task automatic launch;
        read_switch=0; cycles(12); read_switch=1; cycles(12);
        busy=1; read_error=0;
    endtask
    task automatic sector(input integer bad_index);
        for(i=0;i<512;i=i+1) begin
            byte_index=i; data_byte=(i&255)^8'hA5^(i==bad_index);
            data_valid=1; cycles(1); data_valid=0; cycles(2);
        end
    endtask
    initial begin
        cycles(3); rst=0; cycles(12); ready=1; cycles(12);
        if(requests) $fatal(1,"Switch alto na partida iniciou leitura");
        read_switch=0; cycles(12);
        read_switch=1; cycles(1); read_switch=0; cycles(12);
        if(requests) $fatal(1,"Bounce iniciou leitura");
        launch(); sector(511);
        if(diagnostic_error || data_ok || crc_ok) $fatal(1,"Dados provisórios publicados");
        read_error_code=5; read_error=1; busy=0; cycles(3);
        if(data_ok || crc_ok || timeout_count) $fatal(1,"CRC invalido aceito ou contado como timeout");
        launch(); sector(511);
        block_valid=1; cycles(1); block_valid=0; busy=0; cycles(2);
        if(!diagnostic_error || !crc_ok || data_ok || first_mismatch!=511 ||
           expected_byte!=8'h5A || received_byte!=8'h5B || byte_count!=512)
            $fatal(1,"Ultimo byte divergente nao identificado");
        launch(); sector(-1);
        block_valid=1; cycles(1); block_valid=0; busy=0; cycles(2);
        if(diagnostic_error || !data_ok || !crc_ok) $fatal(1,"Referencia correta rejeitada");
        cycles(20);
        if(requests!=3 || attempts!=3) $fatal(1,"Switch mantido repetiu pedido");
        launch(); read_error_code=3; read_error=1; busy=0; cycles(20);
        if(timeout_count!=1 || data_ok || crc_ok) $fatal(1,"Timeout sticky contado incorretamente");
        launch(); sector(-1);
        block_valid=1; cycles(1); block_valid=0; busy=0; cycles(2);
        if(!data_ok || attempts!=5 || timeout_count!=1 || good_reads!=2 || failed_reads!=3) $fatal(1,"Recuperacao falhou");
        $display("PASS sd_diagnostic: debounce, 512 bytes, primeiro erro, CRC, repeticao e timeout");
        $finish;
    end
    initial begin #1000000; $fatal(1,"timeout"); end
endmodule
