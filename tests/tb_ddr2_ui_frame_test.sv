`timescale 1ns/1ps
// Modelo de UI MIG para validar FSM, enderecamento, backpressure e comparacao.
// NAO e simulacao da PHY DDR2 nem comprova temporizacao eletrica da placa.
module tb_ddr2_ui_frame_test;
    parameter integer TB_WORDS = 4800;
    parameter integer INJECT_ERROR = 0;
    parameter integer FORCE_TIMEOUT = 0;

    reg clk = 1'b0;
    always #6 clk = ~clk;
    reg rst = 1'b1;
    reg calib = 1'b0;
    reg app_rdy = 1'b0;
    reg wdf_rdy = 1'b0;
    reg [127:0] rd_data = 0;
    reg rd_valid = 1'b0;
    reg rd_end = 1'b0;
    wire [26:0] addr;
    wire [2:0] cmd;
    wire en;
    wire [127:0] wr_data;
    wire [15:0] wr_mask;
    wire wr_en, wr_end;
    wire done, pass, error;
    wire [12:0] compared;

    reg [127:0] mem [0:TB_WORDS-1];
    integer cycles = 0;
    integer writes = 0;
    integer reads = 0;
    integer read_pending = 0;
    integer read_delay = 0;
    integer pending_index = 0;
    integer idx;

    ddr2_ui_frame_test #(
        .WORDS(TB_WORDS),
        .MAX_ACTIVE_CYCLES(FORCE_TIMEOUT ? 200 : 1000000)
    ) dut (
        .ui_clk(clk), .ui_rst(rst), .init_calib_complete(calib),
        .app_rdy(app_rdy), .app_wdf_rdy(wdf_rdy),
        .app_rd_data(rd_data), .app_rd_data_valid(rd_valid),
        .app_rd_data_end(rd_end),
        .app_addr(addr), .app_cmd(cmd), .app_en(en),
        .app_wdf_data(wr_data), .app_wdf_mask(wr_mask),
        .app_wdf_wren(wr_en), .app_wdf_end(wr_end),
        .test_done(done), .test_pass(pass), .test_error(error),
        .words_compared(compared)
    );

    always @(*) begin
        app_rdy = !FORCE_TIMEOUT && ((cycles % 7) > 1);
        wdf_rdy = ((cycles % 5) != 0);
    end

    always @(posedge clk) begin
        cycles <= cycles + 1;
        rd_valid <= 1'b0;
        rd_end <= 1'b0;
        if (!rst) begin
            if (en && app_rdy) begin
                if (addr[2:0] != 3'd0) $fatal(1, "Endereco nao alinhado: %d", addr);
                idx = addr >> 3;
                if (idx < 0 || idx >= TB_WORDS) $fatal(1, "Endereco invalido: %d", idx);
                if (cmd == 3'b000) begin
                    if (!wr_en || !wr_end || !wdf_rdy || wr_mask != 0)
                        $fatal(1, "Write MIG sem handshake ou mascara invalida");
                    mem[idx] <= wr_data;
                    writes <= writes + 1;
                end else if (cmd == 3'b001) begin
                    if (wr_en || read_pending) $fatal(1, "Read MIG com transacao indevida");
                    pending_index <= idx;
                    read_pending <= 1;
                    read_delay <= 2;
                    reads <= reads + 1;
                end else $fatal(1, "Comando MIG invalido");
            end
            if (read_pending != 0) begin
                if (read_delay > 0)
                    read_delay <= read_delay - 1;
                else begin
                    rd_data <= mem[pending_index] ^
                        ((INJECT_ERROR && pending_index == 42) ? 128'h1 : 128'h0);
                    rd_valid <= 1'b1;
                    rd_end <= 1'b1;
                    read_pending <= 0;
                end
            end
        end
    end

    initial begin
        repeat (6) @(negedge clk);
        rst = 1'b0;
        repeat (6) @(negedge clk);
        calib = 1'b1;
        wait (done);
        @(negedge clk);
        if (FORCE_TIMEOUT) begin
            if (pass || !error || writes != 0)
                $fatal(1, "Timeout nao detectado corretamente");
            $display("P4A_TIMEOUT_PASS");
        end else if (INJECT_ERROR) begin
            if (pass || !error || compared != 42 || writes != TB_WORDS)
                $fatal(1, "Corrupcao nao detectada corretamente: compared=%d", compared);
            $display("P4A_CORRUPTION_PASS");
        end else begin
            if (!pass || error || compared != TB_WORDS ||
                writes != TB_WORDS || reads != TB_WORDS)
                $fatal(1, "Teste completo falhou: compared=%d writes=%d reads=%d", compared, writes, reads);
            $display("P4A_FRAME_PASS words=%0d bytes=%0d", TB_WORDS, TB_WORDS*16);
        end
        $finish;
    end

    initial begin
        #10000000;
        $fatal(1, "Timeout global do testbench");
    end
endmodule
