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
    localparam integer WORDS = TB_BYTES / 16;
    localparam integer ADDR_BITS = $clog2(TB_BYTES);

    reg src_clk = 0, ui_clk = 0;
    always #5 src_clk = ~src_clk;        // 100 MHz
    always #6.154 ui_clk = ~ui_clk;      // ~81.25 MHz, assincrono
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

    ddr2_sd_frame_mirror #(
        .FRAME_BYTES(TB_BYTES), .FIFO_ADDR_BITS(4),
        .MAX_ACTIVE_CYCLES(STALL ? 600 : 2000000)
    ) dut (
        .src_clk(src_clk), .src_rst(src_rst),
        .src_frame_start(frame_start), .src_frame_abort(frame_abort),
        .src_frame_commit(frame_commit), .src_frame_write(frame_write),
        .src_frame_address(frame_address), .src_data_byte(data_byte),
        .src_ready(src_ready),
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
    integer cycles=0, writes=0, reads=0, pending=0, read_delay=0, pending_idx=0;
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
                        ((CORRUPT && pending_idx == 4) ? 128'h1 : 128'h0);
                    app_rd_data_valid <= 1;
                    app_rd_data_end <= 1;
                    pending <= 0;
                end
            end
        end
    end

    function [7:0] pixel_byte;
        input integer i;
        begin
            pixel_byte = ((i * 37) ^ (i >> 5) ^ (i >> 11) ^ 8'hA5);
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
        wait (src_ready);
        @(negedge src_clk);
        frame_start = 1;
        @(negedge src_clk);
        frame_start = 0;
        if (RESET_CASE != 0) begin
            for (j=0; j<TB_BYTES/2; j=j+1) send_byte(j);
            @(negedge src_clk);
            if (RESET_CASE == 1) ui_rst = 1;
            if (RESET_CASE == 2) src_rst = 1;
            if (RESET_CASE == 3) calib = 0;
            repeat (12) @(negedge src_clk);
            ui_rst = 0; src_rst = 0; calib = 1;
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

        wait(test_done);
        @(negedge ui_clk);
        if (CORRUPT || SHORT_COMMIT || ABORT_FRAME || STALL) begin
            if (test_pass || !test_error)
                $fatal(1,"Erro de quadro nao detectado");
            $display("P4B_EXPECTED_ERROR_PASS bytes=%0d writes=%0d reads=%0d",
                     TB_BYTES, writes, reads);
        end else begin
            if (!test_pass || test_error || writes != WORDS ||
                reads != WORDS || words_compared != WORDS)
                $fatal(1,"Frame incorreto: pass=%b err=%b writes=%0d reads=%0d compared=%0d",
                       test_pass,test_error,writes,reads,words_compared);
            $display("P4B_FRAME_PASS bytes=%0d words=%0d", TB_BYTES, WORDS);
        end
        $finish;
    end

    initial begin
        #100000000;
        $fatal(1, "Timeout global do testbench P4B");
    end
endmodule
