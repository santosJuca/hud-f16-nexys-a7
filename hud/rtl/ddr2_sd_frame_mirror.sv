// P4B: espelhamento opcional de um quadro recebido do microSD na DDR2.
// O caminho BRAM/VGA nao depende deste modulo.
// Dados provisórios (antes do CRC do setor) sao escritos numa area DDR2 de
// teste, mas somente COMMIT do loader + readback CRC32 permitem PASS.
// O barramento de dados atravessa clk_hud -> ui_clk via FIFO Gray.
module ddr2_sd_frame_mirror #(
    parameter integer FRAME_BYTES = 76800,
    parameter integer OUTPUT_STREAM = 0,
    parameter integer FIFO_ADDR_BITS = 5,
    parameter integer MAX_ACTIVE_CYCLES = 400000000,
    parameter integer ADDRESS_BITS = $clog2(FRAME_BYTES)
) (
    input wire src_clk,
    input wire src_rst,
    input wire src_frame_start,
    input wire src_frame_abort,
    input wire src_frame_commit,
    input wire src_frame_write,
    input wire [ADDRESS_BITS-1:0] src_frame_address,
    input wire [7:0] src_data_byte,
    output wire src_ready,
    input wire out_ready,
    output wire out_start, out_abort, out_commit, out_valid,
    output wire [ADDRESS_BITS-1:0] out_address,
    output wire [7:0] out_byte,
    input wire ui_clk,
    input wire ui_rst,
    input wire init_calib_complete,
    input wire app_rdy,
    input wire app_wdf_rdy,
    input wire [127:0] app_rd_data,
    input wire app_rd_data_valid,
    input wire app_rd_data_end,
    output wire [26:0] app_addr,
    output wire [2:0] app_cmd,
    output wire app_en,
    output wire [127:0] app_wdf_data,
    output wire [15:0] app_wdf_mask,
    output wire app_wdf_wren,
    output wire app_wdf_end,
    output reg test_done = 1'b0,
    output reg test_pass = 1'b0,
    output reg test_error = 1'b0,
    output reg [12:0] words_compared = 0
);
    localparam integer WORDS = FRAME_BYTES / 16;
    localparam [1:0] EV_START=2'd0, EV_WORD=2'd1, EV_COMMIT=2'd2, EV_ABORT=2'd3;
    localparam [2:0] WAIT_START=3'd0, WRITING=3'd1,
                     READ_CMD=3'd2, WAIT_DATA=3'd3, CHECK_BYTE=3'd4,
                     FAILED=3'd5, OUTPUT_END=3'd6;

    function automatic [31:0] crc32_byte;
        input [31:0] crc;
        input [7:0] data;
        reg [31:0] value;
        integer i;
        begin
            value = crc ^ {24'd0, data};
            for (i=0; i<8; i=i+1)
                value = value[0] ? ((value >> 1) ^ 32'hEDB88320) : (value >> 1);
            crc32_byte = value;
        end
    endfunction

    // Um reset parcial invalida toda a transacao, incluindo os dois ponteiros.
    wire reset_request = src_rst || ui_rst || !init_calib_complete;
    (* ASYNC_REG = "TRUE" *) reg [4:0] src_reset_pipe = 5'b11111;
    (* ASYNC_REG = "TRUE" *) reg [4:0] ui_reset_pipe = 5'b11111;
    always @(posedge src_clk or posedge reset_request)
        if (reset_request) src_reset_pipe <= 5'b11111;
        else src_reset_pipe <= {src_reset_pipe[3:0], 1'b0};
    always @(posedge ui_clk or posedge reset_request)
        if (reset_request) ui_reset_pipe <= 5'b11111;
        else ui_reset_pipe <= {ui_reset_pipe[3:0], 1'b0};
    wire src_local_rst = src_reset_pipe[4];
    wire ui_local_rst = ui_reset_pipe[4];

    wire fifo_full, fifo_empty;
    wire [129:0] event_front;
    wire [1:0] event_kind = event_front[129:128];
    wire [127:0] event_payload = event_front[127:0];
    wire event_push, event_pop;
    reg [129:0] event_in;

    ddr2_p4b_async_fifo #(.WIDTH(130), .ADDR_BITS(FIFO_ADDR_BITS)) u_fifo (
        .wr_clk(src_clk), .wr_rst(src_local_rst),
        .wr_en(event_push), .wr_data(event_in), .full(fifo_full),
        .rd_clk(ui_clk), .rd_rst(ui_local_rst),
        .rd_en(event_pop), .rd_data(event_front), .empty(fifo_empty)
    );

    reg src_busy = 0, src_terminal = 0, abort_pending = 0, commit_pending = 0;
    reg [31:0] src_count = 0, src_crc = 32'hFFFFFFFF;
    reg [3:0] src_byte_pos = 0;
    reg [127:0] src_shift = 0;
    reg [31:0] commit_crc = 0;

    reg [2:0] ui_state = WAIT_START;
    reg [12:0] ui_index = 0;
    reg [31:0] ui_elapsed = 0, expected_crc = 0, actual_crc = 32'hFFFFFFFF;
    reg [127:0] read_word = 0;
    reg [3:0] read_byte_pos = 0;
    reg ui_done_toggle = 0;

    (* ASYNC_REG = "TRUE" *) reg ui_ready_meta = 0, ui_ready_sync = 0;
    (* ASYNC_REG = "TRUE" *) reg ui_done_meta = 0, ui_done_sync = 0;
    reg ui_done_seen = 0;
    // Registra a combinacao no dominio MIG antes do sincronizador de origem.
    reg ui_ready = 0;
    always @(posedge ui_clk) begin
        if (ui_local_rst) ui_ready <= 0;
        else ui_ready <= ui_state == WAIT_START && init_calib_complete;
    end
    assign src_ready = !src_local_rst && !src_busy && !fifo_full && ui_ready_sync;

    // Eventos têm prioridade fixa. Cada pulso de origem produz no maximo um
    // token; se a FIFO encher, aborta a tentativa, jamais publica quadro parcial.
    reg push;
    reg [1:0] push_kind;
    reg [127:0] push_payload;
    wire bad_byte = src_frame_write &&
                    (src_count >= FRAME_BYTES || src_frame_address != src_count[ADDRESS_BITS-1:0]);
    wire bad_commit = src_count != FRAME_BYTES || src_byte_pos != 0;
    always @* begin
        push = 0;
        push_kind = EV_ABORT;
        push_payload = 0;
        if (!src_busy) begin
            if (src_frame_start && src_ready) begin
                push = 1;
                push_kind = EV_START;
            end
        end else if (!src_terminal) begin
            if (abort_pending || src_frame_abort || bad_byte ||
                (src_frame_commit && bad_commit)) begin
                if (!fifo_full) begin
                    push = 1;
                    push_kind = EV_ABORT;
                end
            end else if (commit_pending || src_frame_commit) begin
                if (!fifo_full) begin
                    push = 1;
                    push_kind = EV_COMMIT;
                    push_payload[31:0] = commit_pending ? commit_crc : ~src_crc;
                end
            end else if (src_frame_write && src_byte_pos == 15 && !fifo_full) begin
                push = 1;
                push_kind = EV_WORD;
                push_payload = {src_data_byte, src_shift[127:8]};
            end
        end
        event_in = {push_kind, push_payload};
    end
    assign event_push = push && !fifo_full && !src_local_rst;

    always @(posedge src_clk) begin
        if (src_local_rst) begin
            src_busy <= 0;
            src_terminal <= 0;
            abort_pending <= 0;
            commit_pending <= 0;
            src_count <= 0;
            src_byte_pos <= 0;
            src_shift <= 0;
            src_crc <= 32'hFFFFFFFF;
            commit_crc <= 0;
            ui_ready_meta <= 0;
            ui_ready_sync <= 0;
            ui_done_meta <= 0;
            ui_done_sync <= 0;
            ui_done_seen <= 0;
        end else begin
            ui_ready_meta <= ui_ready;
            ui_ready_sync <= ui_ready_meta;
            ui_done_meta <= ui_done_toggle;
            ui_done_sync <= ui_done_meta;
            if (ui_done_sync != ui_done_seen) begin
                ui_done_seen <= ui_done_sync;
                src_busy <= 0;
            end
            if (event_push && !src_busy) begin
                src_busy <= 1;
                src_terminal <= 0;
                abort_pending <= 0;
                commit_pending <= 0;
                src_count <= 0;
                src_byte_pos <= 0;
                src_crc <= 32'hFFFFFFFF;
                src_shift <= 0;
            end else if (src_busy && !src_terminal) begin
                if (event_push && (push_kind == EV_ABORT || push_kind == EV_COMMIT)) begin
                    src_terminal <= 1;
                    abort_pending <= 0;
                    commit_pending <= 0;
                end else if (!abort_pending && !commit_pending) begin
                    if (src_frame_abort || bad_byte ||
                        (src_frame_commit && bad_commit)) begin
                        abort_pending <= 1;
                    end else if (src_frame_commit) begin
                        if (fifo_full) begin
                            commit_pending <= 1;
                            commit_crc <= ~src_crc;
                        end
                    end else if (src_frame_write) begin
                        if (src_byte_pos == 15 && fifo_full)
                            abort_pending <= 1;
                        else begin
                            src_count <= src_count + 1'b1;
                            src_crc <= crc32_byte(src_crc, src_data_byte);
                            src_shift <= {src_data_byte, src_shift[127:8]};
                            src_byte_pos <= src_byte_pos + 1'b1;
                        end
                    end
                end
            end
        end
    end

    (* ASYNC_REG = "TRUE" *) reg src_busy_meta = 0, src_busy_sync = 0;
    always @(posedge ui_clk) begin
        if (ui_local_rst) begin src_busy_meta <= 0; src_busy_sync <= 0; end
        else begin src_busy_meta <= src_busy; src_busy_sync <= src_busy_meta; end
    end
    wire output_push;
    reg output_abort_sent = 0;
    always @(posedge ui_clk) begin
        if (ui_local_rst || (ui_state == WAIT_START && event_pop)) output_abort_sent <= 0;
        else if (ui_state == FAILED && output_push) output_abort_sent <= 1;
    end
    wire output_full, output_empty;
    wire [9:0] output_front;
    assign output_push = OUTPUT_STREAM && !ui_local_rst &&
        !output_full && ((ui_state == WRITING && event_pop && event_kind == EV_COMMIT && ui_index == WORDS) ||
                         ui_state == CHECK_BYTE || ui_state == OUTPUT_END ||
                         (ui_state == FAILED && !output_abort_sent));
    wire [9:0] output_token = ui_state == WRITING ? {EV_START,8'd0} :
        (ui_state == OUTPUT_END || ui_state == FAILED) ?
        {ui_state == OUTPUT_END && test_pass ? EV_COMMIT : EV_ABORT,8'd0} :
        {EV_WORD,read_word[read_byte_pos*8 +: 8]};
    wire output_pop = OUTPUT_STREAM && !src_local_rst &&
        !output_empty && (output_front[9:8] != EV_START || out_ready);
    generate if (OUTPUT_STREAM != 0) begin : g_output
        ddr2_p4b_async_fifo #(.WIDTH(10),.ADDR_BITS(FIFO_ADDR_BITS)) u_output_fifo (
            .wr_clk(ui_clk),.wr_rst(ui_local_rst),.wr_en(output_push),
            .wr_data(output_token),.full(output_full),
            .rd_clk(src_clk),.rd_rst(src_local_rst),.rd_en(output_pop),
            .rd_data(output_front),.empty(output_empty));
    end else begin : g_no_output
        assign output_full=0;
        assign output_empty=1;
        assign output_front=0;
    end endgenerate
    reg [ADDRESS_BITS-1:0] output_index = 0;
    always @(posedge src_clk) begin
        if (src_local_rst || out_start) output_index <= 0;
        else if (out_valid) output_index <= output_index + 1'b1;
    end
    assign out_start = output_pop && output_front[9:8] == EV_START;
    assign out_valid = output_pop && output_front[9:8] == EV_WORD;
    assign out_commit = output_pop && output_front[9:8] == EV_COMMIT;
    assign out_abort = OUTPUT_STREAM && (src_local_rst ||
        (output_pop && output_front[9:8] == EV_ABORT));
    assign out_byte = output_front[7:0];
    assign out_address = output_index;

    wire write_accept = ui_state == WRITING && !fifo_empty &&
                        event_kind == EV_WORD && app_rdy && app_wdf_rdy &&
                        ui_index < WORDS;
    wire read_accept = ui_state == READ_CMD && app_rdy;
    assign app_addr = {11'd0, ui_index, 3'd0};
    assign app_cmd = ui_state == READ_CMD ? 3'b001 : 3'b000;
    assign app_en = !ui_local_rst && (write_accept || read_accept);
    assign app_wdf_data = event_payload;
    assign app_wdf_mask = 16'd0;
    assign app_wdf_wren = !ui_local_rst && write_accept;
    assign app_wdf_end = app_wdf_wren;
    assign event_pop = !fifo_empty &&
                       ((ui_state == FAILED) ||
                        (ui_state == WAIT_START && event_kind == EV_START && ui_ready) ||
                        (ui_state == WRITING &&
                         (write_accept || (event_kind == EV_COMMIT && !output_full) ||
                          event_kind == EV_ABORT)));
    wire [31:0] crc_next = crc32_byte(actual_crc, read_word[read_byte_pos*8 +: 8]);

    always @(posedge ui_clk) begin
        if (ui_local_rst) begin
            ui_state <= WAIT_START;
            ui_index <= 0;
            ui_elapsed <= 0;
            expected_crc <= 0;
            actual_crc <= 32'hFFFFFFFF;
            read_word <= 0;
            read_byte_pos <= 0;
            ui_done_toggle <= 0;
            test_done <= 0;
            test_pass <= 0;
            test_error <= 0;
            words_compared <= 0;
        end else begin
            if (ui_state != WAIT_START && ui_state != FAILED)
                ui_elapsed <= ui_elapsed + 1'b1;
            if (ui_state != WAIT_START && ui_state != FAILED &&
                ui_elapsed >= MAX_ACTIVE_CYCLES) begin
                ui_state <= FAILED;
                test_done <= 1;
                test_error <= 1;
                ui_done_toggle <= ~ui_done_toggle;
            end else case (ui_state)
                WAIT_START: if (event_pop) begin
                    ui_state <= WRITING;
                    ui_index <= 0;
                    ui_elapsed <= 0;
                    words_compared <= 0;
                    test_done <= 0;
                    test_pass <= 0;
                    test_error <= 0;
                end
                WRITING: if (!fifo_empty) begin
                    if (event_kind == EV_ABORT ||
                        (event_kind == EV_COMMIT && ui_index != WORDS) ||
                        (event_kind == EV_WORD && ui_index >= WORDS) ||
                        event_kind == EV_START) begin
                        ui_state <= FAILED;
                        test_done <= 1;
                        test_error <= 1;
                        ui_done_toggle <= ~ui_done_toggle;
                    end else if (event_kind == EV_COMMIT && event_pop) begin
                        expected_crc <= event_payload[31:0];
                        actual_crc <= 32'hFFFFFFFF;
                        ui_index <= 0;
                        ui_state <= READ_CMD;
                    end else if (write_accept)
                        ui_index <= ui_index + 1'b1;
                end
                READ_CMD: if (read_accept)
                    ui_state <= WAIT_DATA;
                WAIT_DATA: if (app_rd_data_valid) begin
                    if (!app_rd_data_end) begin
                        ui_state <= FAILED;
                        test_done <= 1;
                        test_error <= 1;
                        ui_done_toggle <= ~ui_done_toggle;
                    end else begin
                        read_word <= app_rd_data;
                        read_byte_pos <= 0;
                        ui_state <= CHECK_BYTE;
                    end
                end
                CHECK_BYTE: if (!output_full) begin
                    actual_crc <= crc_next;
                    if (read_byte_pos == 15) begin
                        words_compared <= words_compared + 1'b1;
                        if (ui_index == WORDS-1) begin
                            test_done <= 1;
                            ui_done_toggle <= ~ui_done_toggle;
                            if (~crc_next == expected_crc)
                                test_pass <= 1;
                            else
                                test_error <= 1;
                            // Readback concluido. Proximo frame pode iniciar.
                            ui_state <= OUTPUT_STREAM ? OUTPUT_END : WAIT_START;
                        end else begin
                            ui_index <= ui_index + 1'b1;
                            ui_state <= READ_CMD;
                        end
                    end else read_byte_pos <= read_byte_pos + 1'b1;
                end
                FAILED: if (fifo_empty && !src_busy_sync &&
                            (!OUTPUT_STREAM || output_abort_sent)) ui_state <= WAIT_START;
                OUTPUT_END: if (output_push) ui_state <= WAIT_START;
                default: ;
            endcase
        end
    end

    initial begin
        if (FRAME_BYTES < 16 || (FRAME_BYTES % 16) != 0 || WORDS > 8191 ||
            MAX_ACTIVE_CYCLES < 1 || FIFO_ADDR_BITS < 4)
            $error("P4B: FRAME_BYTES invalido (multiplo de 16, max 131056)");
    end
endmodule
