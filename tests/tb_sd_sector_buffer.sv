`timescale 1ns/1ps
module tb_sd_sector_buffer;
    reg wr_clk=0; always #5 wr_clk=~wr_clk;
    reg rd_clk=0; initial begin #3; forever #20 rd_clk=~rd_clk; end
    reg rst=1, wr_start=0, wr_abort=0, wr_valid=0, wr_commit=0;
    reg [7:0] wr_byte=0;
    reg [8:0] wr_index=0;
    wire wr_ready, wr_active, wr_pending, wr_error, wr_published;
    reg rd_frame_start=0, rd_enable=0;
    reg [8:0] rd_address=0;
    wire [7:0] rd_byte;
    wire rd_valid, rd_sector_valid, rd_updated;
    sd_sector_buffer dut(.*);
    integer i, publications=0, updates=0;
    integer expected_seed=-1;
    reg allow_update=0;
    reg [7:0] expected_pipe;
    reg expected_valid=0;
    // Scoreboard independente: enderecos arbitrarios e latencia de duas bordas.
    always @(posedge rd_clk) begin
        #1;
        if(rst || dut.rd_reset) begin
            expected_valid=0;
        end else begin
            if(rd_valid !== expected_valid) $fatal(1,"Latencia rd_valid incorreta");
            if(rd_valid && rd_byte !== expected_pipe) $fatal(1,"Pixel recebeu byte %h esperado %h",rd_byte,expected_pipe);
            expected_valid=rd_enable && rd_sector_valid;
            expected_pipe=(expected_seed+rd_address)&255;
        end
        if(rd_updated) begin
            updates=updates+1;
            if(!allow_update) $fatal(1,"Publicacao fora do blanking");
        end
    end
    always @(negedge wr_clk) if(wr_published) publications=publications+1;
    task begin_sector;
        begin
            wait(wr_ready); @(negedge wr_clk); wr_start=1;
            @(negedge wr_clk); wr_start=0;
            if(!wr_active) $fatal(1,"Inicio de recepcao ignorado");
        end
    endtask
    task send_bytes(input integer seed, input integer amount, input integer bad_index);
        begin
            for(i=0;i<amount;i=i+1) begin
                wr_valid=1; wr_byte=(seed+i)&255; wr_index=(i==bad_index ? i+1 : i);
                @(negedge wr_clk);
            end
            wr_valid=0;
        end
    endtask
    task commit_sector;
        begin
            @(negedge wr_clk); wr_commit=1;
            @(negedge wr_clk); wr_commit=0;
        end
    endtask
    task abort_sector;
        begin
            @(negedge wr_clk); wr_abort=1;
            @(negedge wr_clk); wr_abort=0;
            if(!wr_ready || !wr_error) $fatal(1,"Abort nao recuperou o escritor");
        end
    endtask
    task frame_boundary(input integer new_seed);
        begin
            // Leituras de pixels estao desabilitadas no blanking.
            rd_enable=0;
            repeat(3) @(negedge rd_clk);
            allow_update=1; expected_seed=new_seed; rd_frame_start=1;
            @(negedge rd_clk); rd_frame_start=0;
            wait(wr_ready);
            repeat(3) @(negedge rd_clk);
            allow_update=0;
        end
    endtask
    task read_sector(input integer seed);
        integer n;
        begin
            if(!rd_sector_valid) $fatal(1,"Setor publicado ausente");
            expected_seed=seed;
            for(n=0;n<512;n=n+1) begin
                rd_enable=1; rd_address=(n*37)&511;
                @(negedge rd_clk);
            end
            rd_enable=0; repeat(3) @(negedge rd_clk);
        end
    endtask
    initial begin
        repeat(10) @(negedge rd_clk); rst=0; wait(wr_ready);
        repeat(3) @(negedge rd_clk);
        rd_enable=1; repeat(3) @(negedge rd_clk);
        if(rd_sector_valid || rd_valid) $fatal(1,"Memoria parcial valida na partida");
        rd_enable=0;
        begin_sector(); send_bytes(7,512,-1);
        repeat(10) @(negedge rd_clk);
        if(rd_sector_valid) $fatal(1,"Setor sem CRC foi publicado");
        commit_sector();
        repeat(10) @(negedge rd_clk);
        if(rd_sector_valid || wr_ready || !wr_pending) $fatal(1,"Commit nao aguardou blanking/ACK");
        // Uma tentativa de sobrescrita enquanto espera o ACK deve ser ignorada.
        @(negedge wr_clk); wr_start=1; wr_valid=1; wr_byte=8'hEE; wr_index=0;
        @(negedge wr_clk); wr_start=0; wr_valid=0;
        if(wr_active || !wr_pending || wr_ready) $fatal(1,"Escritor desbloqueou antes do ACK");
        frame_boundary(7); read_sector(7);
        $display("PASS buffer: 512 bytes, CRC externo/commit e publicacao no blanking");

        // Escrita parcial e falha de CRC preservam o banco visivel.
        begin_sector(); send_bytes(93,211,-1); read_sector(7); abort_sector(); read_sector(7);
        begin_sector(); send_bytes(101,512,-1); abort_sector(); read_sector(7);
        $display("PASS buffer: abort parcial e CRC ruim preservam setor anterior");

        // Protocolo incorreto nao pode publicar, mesmo com commit.
        begin_sector(); send_bytes(55,511,-1); commit_sector();
        if(!wr_error || !wr_ready) $fatal(1,"Setor incompleto aceito");
        begin_sector(); send_bytes(66,512,511); commit_sector();
        if(!wr_error || !wr_ready) $fatal(1,"Indice errado aceito");
        begin_sector(); send_bytes(77,513,-1); commit_sector();
        if(!wr_error || !wr_ready) $fatal(1,"Byte excedente aceito");
        read_sector(7);
        $display("PASS buffer: rejeita contagem incompleta, indice errado e byte excedente");

        begin_sector();
        fork
            send_bytes(42,512,-1);
            read_sector(7);
        join
        commit_sector();
        read_sector(7);
        frame_boundary(42); read_sector(42);
        begin_sector(); send_bytes(133,512,-1); commit_sector();
        frame_boundary(133); read_sector(133);
        if(publications!=3 || updates!=3) $fatal(1,"Handshake duplicou/perdeu publicacao");
        $display("PASS buffer: bancos alternados, dados antigos estaveis e duas fases de ACK");

        begin_sector(); send_bytes(44,16,-1);
        rst=1; repeat(5) @(negedge rd_clk);
        if(rd_sector_valid || rd_valid) $fatal(1,"Reset nao invalidou dados");
        rst=0; wait(wr_ready);
        begin_sector(); send_bytes(211,512,-1); commit_sector();
        frame_boundary(211); read_sector(211);
        $display("PASS buffer: reset durante recepcao e nova transferencia completa");
        $finish;
    end
    initial begin #2000000; $fatal(1,"Watchdog buffer"); end
endmodule
