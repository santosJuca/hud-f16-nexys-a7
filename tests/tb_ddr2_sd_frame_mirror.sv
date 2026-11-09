`timescale 1ns/1ps
// Modelo do lado UI do MIG, nao e simulacao eletrica da memoria DDR2.
// Cenários: quadro realista (stream de bytes), corrupcao, commit curto, abort.
module tb_ddr2_sd_frame_mirror;
    parameter integer TB_BYTES = 256;
    parameter integer CORRUPT = 0;
    parameter integer SHORT_COMMIT = 0;
    parameter integer ABORT_FRAME = 0;
    parameter integer STALL = 0;
    parameter integer RESET_CASE = 0;
    parameter integer RESET_PHASE = 0;
    parameter integer RESET_PULSE_NS = 0;
    parameter integer PAUSE_UI_RESET = 0;
    parameter integer STREAM = 0;
    parameter integer TB_FRAMES = 1;
    parameter integer HOLD_OUTPUT = 0;
    parameter integer CORRUPT_ON_SECOND = 0;
    parameter integer BAD_RD_END = 0;
    parameter integer DROP_READ = 0;
    parameter integer FIFO_BITS = 4;
    parameter integer TIMEOUT_CYCLES = STALL ? 600 : DROP_READ ? 2000 : 2000000;
    integer epoch=0;
    localparam integer WORDS = TB_BYTES / 16;
    localparam integer ADDR_BITS = $clog2(TB_BYTES);

    wire corrupt_now = CORRUPT || (CORRUPT_ON_SECOND && epoch != 0);
    reg src_clk = 0, ui_clk = 0, ui_clock_running = 1;
    always #5 src_clk = ~src_clk;        // 100 MHz
    always #6.154 if (ui_clock_running) ui_clk = ~ui_clk; // ~81.25 MHz
    reg src_rst = 1, ui_rst = 1, calib = 0;
    reg frame_start = 0, frame_abort = 0, frame_commit = 0, frame_write = 0;
    reg [ADDR_BITS-1:0] frame_address = 0;
    reg [7:0] data_byte = 0;
    wire src_ready;

    reg app_rdy = 0, app_wdf_rdy = 0;
    reg [127:0] app_rd_data = 0;
    reg app_rd_data_valid = 0, app_rd_data_end = 0;
    wire [26:0] app_addr;
    wire [2:0] app_cmd;
    wire app_en;
    wire [127:0] app_wdf_data;
    wire [15:0] app_wdf_mask;
    wire app_wdf_wren, app_wdf_end;
    wire test_done, test_pass, test_error;
    wire [12:0] words_compared;

    wire out_start,out_abort,out_commit,out_valid;
    wire [ADDR_BITS-1:0] out_address;
    wire [7:0] out_byte;
    wire buffer_ready;
    integer cycles=0;
    reg saw_fifo_full=0, saw_overflow_abort=0;
    always @(posedge src_clk) begin
        if(dut.fifo_full && !dut.src_local_rst) saw_fifo_full=1;
        if(dut.abort_pending) saw_overflow_abort=1;
    end
    reg pixel_clk=0;
    always #20 pixel_clk=~pixel_clk;
    reg display_boundary=0, display_enable=0;
    reg [ADDR_BITS-1:0] display_address=0;
    wire [7:0] display_byte;
    wire display_valid,display_updated;

    reg output_finished=0;
    integer output_count=0, output_mismatches=0;
    wire buffer_pending,buffer_error;
    sd_sector_buffer #(.BYTES(TB_BYTES)) display_buffer (
        .wr_clk(src_clk),.rd_clk(pixel_clk),.rst(src_rst),
        .wr_start(out_start),.wr_abort(out_abort),.wr_commit(out_commit),
        .wr_valid(out_valid),.wr_index(out_address),.wr_byte(out_byte),
        .wr_ready(buffer_ready),.wr_pending(buffer_pending),.wr_error(buffer_error),
        .rd_frame_start(display_boundary),.rd_enable(display_enable),
        .rd_address(display_address),.rd_byte(display_byte),
        .rd_valid(display_valid),.rd_updated(display_updated));
    always @(posedge src_clk) begin
        if (frame_start) output_finished=0;
        if (out_start) begin output_count=0; output_mismatches=0; output_finished=0; end
        if (out_valid) begin
            if (out_address != output_count) $fatal(1,"Endereco de saida DDR2 fora de ordem");
            if (out_byte != pixel_byte(output_count)) output_mismatches=output_mismatches+1;
            output_count=output_count+1;
        end
        if (out_commit) begin
            if (output_count != TB_BYTES || output_mismatches != 0)
                $fatal(1,"DDR2 publicou dados incorretos: count=%0d mismatches=%0d",output_count,output_mismatches);
            output_finished=1;
        end
        if (out_abort) output_finished=1;
    end

    ddr2_sd_frame_mirror #(
        .FRAME_BYTES(TB_BYTES),.OUTPUT_STREAM(STREAM), .FIFO_ADDR_BITS(FIFO_BITS),
        .MAX_ACTIVE_CYCLES(TIMEOUT_CYCLES)
    ) dut (
        .src_clk(src_clk), .src_rst(src_rst),
        .src_frame_start(frame_start), .src_frame_abort(frame_abort),
        .src_frame_commit(frame_commit), .src_frame_write(frame_write),
        .src_frame_address(frame_address), .src_data_byte(data_byte),
        .src_ready(src_ready),
        .out_ready(buffer_ready && cycles >= HOLD_OUTPUT),.out_start(out_start),.out_abort(out_abort),
        .out_commit(out_commit),.out_valid(out_valid),.out_address(out_address),.out_byte(out_byte),
        .ui_clk(ui_clk), .ui_rst(ui_rst), .init_calib_complete(calib),
        .app_rdy(app_rdy), .app_wdf_rdy(app_wdf_rdy),
        .app_rd_data(app_rd_data), .app_rd_data_valid(app_rd_data_valid),
        .app_rd_data_end(app_rd_data_end),
        .app_addr(app_addr), .app_cmd(app_cmd), .app_en(app_en),
        .app_wdf_data(app_wdf_data), .app_wdf_mask(app_wdf_mask),
        .app_wdf_wren(app_wdf_wren), .app_wdf_end(app_wdf_end),
        .test_done(test_done), .test_pass(test_pass),
        .test_error(test_error), .words_compared(words_compared)
    );

    reg [127:0] memory [0:WORDS-1];
    integer writes=0, reads=0, pending=0, read_delay=0, pending_idx=0;
    integer index;
    always @(*) begin
        app_rdy = !STALL && ((cycles % 7) >= 2);
        app_wdf_rdy = !STALL && ((cycles % 5) != 0);
    end
    always @(posedge ui_clk) begin
        cycles <= cycles + 1;
        app_rd_data_valid <= 0;
        app_rd_data_end <= 0;
        if (!ui_rst) begin
            if (app_en && app_rdy) begin
                if (app_addr[2:0] != 0)
                    $fatal(1,"Endereco DDR2 desalinhado: %d", app_addr);
                index = app_addr >> 3;
                if (index < 0 || index >= WORDS)
                    $fatal(1,"Endereco DDR2 fora do quadro: %d", index);
                if (app_cmd == 0) begin
                    if (!app_wdf_wren || !app_wdf_end || !app_wdf_rdy || app_wdf_mask != 0)
                        $fatal(1,"Write sem handshake MIG correto");
                    memory[index] <= app_wdf_data;
                    writes <= writes+1;
                end else if (app_cmd == 1) begin
                    if (app_wdf_wren || pending != 0)
                        $fatal(1,"Read com escrita ou leitura pendente");
                    pending_idx <= index;
                    read_delay <= 2;
                    pending <= 1;
                    reads <= reads+1;
                end else $fatal(1,"Comando desconhecido");
            end
            if (pending != 0) begin
                if (read_delay > 0) read_delay <= read_delay-1;
                else begin
                    app_rd_data <= memory[pending_idx] ^
                        ((corrupt_now && pending_idx == 4) ? 128'h1 : 128'h0);
                    app_rd_data_valid <= !DROP_READ;
                    app_rd_data_end <= !BAD_RD_END;
                    pending <= 0;
                end
            end
        end
    end

    function [7:0] pixel_byte;
        input integer i;
        begin
            pixel_byte = ((i * 37) ^ (i >> 5) ^ (i >> 11) ^ 8'hA5 ^ (epoch*17));
        end
    endfunction

    task send_byte;
        input integer i;
        begin
            @(negedge src_clk);
            frame_address = i;
            data_byte = pixel_byte(i);
            frame_write = 1;
            @(negedge src_clk);
            frame_write = 0;
            // Simula espacamento entre bytes da SPI.
            repeat (2) @(negedge src_clk);
        end
    endtask

    integer j, limit_bytes;
    initial begin
        repeat (7) @(negedge src_clk);
        src_rst = 0;
        ui_rst = 0;
        repeat (7) @(negedge ui_clk);
        calib = 1;
        for (epoch=0;epoch<TB_FRAMES;epoch=epoch+1) begin
        wait (src_ready);
        @(negedge src_clk);
        frame_start = 1;
        @(negedge src_clk);
        frame_start = 0;
        if (RESET_CASE != 0) begin
            for (j=0; j<TB_BYTES/2; j=j+1) send_byte(j);
            if (PAUSE_UI_RESET) begin
                @(negedge ui_clk); ui_clock_running=0;
            end
            @(negedge src_clk);
            if (RESET_CASE == 1) ui_rst = 1;
            if (RESET_CASE == 2) src_rst = 1;
            if (RESET_CASE == 3) calib = 0;
            if (RESET_PULSE_NS != 0) #(RESET_PULSE_NS);
            else repeat (12) @(negedge src_clk);
            #0.001;
            if (!dut.src_local_rst || !dut.ui_local_rst)
                $fatal(1,"Reset nao afirmou nos dois dominios");
            ui_rst = 0; src_rst = 0; calib = 1;
            if (PAUSE_UI_RESET) begin
                repeat (20) @(negedge src_clk);
                if (!dut.ui_local_rst || src_ready || buffer_pending)
                    $fatal(1,"Transacao liberada com clock UI parado");
                ui_clock_running=1;
            end
            begin : recovery_wait
                integer retries;
                for (retries=0; retries<1000; retries=retries+1) begin
                    @(negedge src_clk);
                    if (src_ready) disable recovery_wait;
                end
                $fatal(1,"Nao recuperou apos reset/perda de calibracao case=%0d",RESET_CASE);
            end
            @(negedge ui_clk);
            writes=0; reads=0; pending=0;
            @(negedge src_clk); frame_start=1;
            @(negedge src_clk); frame_start=0;
        end
        limit_bytes = (SHORT_COMMIT || ABORT_FRAME) ? TB_BYTES/2 : TB_BYTES;
        for (j=0; j<limit_bytes; j=j+1) send_byte(j);
        @(negedge src_clk);
        if (ABORT_FRAME) frame_abort = 1;
        else frame_commit = 1;
        @(negedge src_clk);
        frame_abort = 0;
        frame_commit = 0;

        if (RESET_PHASE != 0) begin
            // Interrompe a transacao em releitura ou ja no retorno ao BRAM.
            if (RESET_PHASE == 1) wait(reads >= 2);
            else wait(output_count >= 32);
            @(negedge src_clk); calib=0;
            repeat (12) @(negedge src_clk);
            if (buffer_pending) $fatal(1,"Reset publicou quadro parcial");
            @(negedge ui_clk); pending=0; writes=0; reads=0;
            @(negedge src_clk); calib=1;
            wait(src_ready);
            @(negedge src_clk); frame_start=1;
            @(negedge src_clk); frame_start=0;
            for (j=0;j<TB_BYTES;j=j+1) send_byte(j);
            @(negedge src_clk); frame_commit=1;
            @(negedge src_clk); frame_commit=0;
        end
        if (epoch != 0) wait(!test_done);
        wait(test_done);
        if (STREAM) begin
            wait(output_finished);
            repeat (4) @(negedge src_clk);
            if (corrupt_now || SHORT_COMMIT || ABORT_FRAME || STALL || BAD_RD_END || DROP_READ) begin
                if (buffer_pending) $fatal(1,"Quadro invalido publicado pelo buffer");
            end else if (!buffer_pending || buffer_error)
                $fatal(1,"Releitura DDR2 nao chegou ao buffer de exibicao");
        end
        if (STREAM && !(corrupt_now || SHORT_COMMIT || ABORT_FRAME || STALL || BAD_RD_END || DROP_READ)) begin
            @(negedge pixel_clk); display_boundary=1;
            wait(display_updated);
            @(negedge pixel_clk); display_boundary=0;
            for (j=0; j<TB_BYTES; j=j+1) begin
                @(negedge pixel_clk); display_enable=1; display_address=j;
                repeat (3) @(negedge pixel_clk);
                if (!display_valid || display_byte !== pixel_byte(j))
                    $fatal(1,"Pixel vindo da DDR2 incorreto no buffer de saida: %0d",j);
            end
            $display("DDR2_DISPLAY_PIXELS_PASS bytes=%0d",TB_BYTES);
        end
        if (STREAM && CORRUPT_ON_SECOND && epoch != 0) begin
            // Um quadro corrompido nao pode substituir o banco ja exibido.
            for (j=0;j<TB_BYTES;j=j+1) begin
                @(negedge pixel_clk); display_enable=1; display_address=j;
                repeat (3) @(negedge pixel_clk);
                if (!display_valid || display_byte !== 8'(pixel_byte(j) ^ (epoch*17) ^ ((epoch-1)*17)))
                    $fatal(1,"Ultima imagem integra foi perdida apos corrupcao");
            end
            $display("DDR2_LAST_GOOD_FRAME_PRESERVED");
        end
        @(negedge ui_clk);
        if (corrupt_now || SHORT_COMMIT || ABORT_FRAME || STALL || BAD_RD_END || DROP_READ) begin
            if (test_pass || !test_error)
                $fatal(1,"Erro de quadro nao detectado");
            if(STALL && TB_BYTES==1024) begin
                if(!saw_fifo_full || !saw_overflow_abort) $fatal(1,"Overflow nao foi exercitado");
                $display("FIFO_OVERFLOW_ABORT_OBSERVED");
            end
            $display("P4B_EXPECTED_ERROR_PASS bytes=%0d writes=%0d reads=%0d",
                     TB_BYTES, writes, reads);
        end else begin
            if (!test_pass || test_error || writes != (epoch+1)*WORDS ||
                reads != (epoch+1)*WORDS || words_compared != WORDS)
                $fatal(1,"Frame incorreto: pass=%b err=%b writes=%0d reads=%0d compared=%0d",
                       test_pass,test_error,writes,reads,words_compared);
            if (epoch == 0 && TB_BYTES == 256 && dut.expected_crc !== 32'hD2BE52CC)
                $fatal(1,"CRC32 diverge da referencia zlib de 256 bytes");
            if (epoch == 0 && TB_BYTES == 76800 && dut.expected_crc !== 32'h2F622165)
                $fatal(1,"CRC32 diverge da referencia zlib do quadro integral");
            $display("P4B_FRAME_PASS bytes=%0d words=%0d", TB_BYTES, WORDS);
        end
        if (STREAM && !(corrupt_now || SHORT_COMMIT || ABORT_FRAME || STALL || BAD_RD_END || DROP_READ)) wait(buffer_ready);
        end
        $finish;
    end

    initial begin
        #100000000;
        $fatal(1, "Timeout global do testbench P4B");
    end
endmodule
