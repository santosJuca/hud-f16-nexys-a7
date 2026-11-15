// Dois bancos de 512 bytes: so publica um setor completo apos wr_commit (CRC valido).
// rst e comum aos dois dominios; sua liberacao e sincronizada em cada clock.
module sd_sector_buffer #(
    parameter integer BYTES = 512,
    parameter integer ADDRESS_BITS = $clog2(BYTES)
) (
    input wire wr_clk, rd_clk, rst,
    input wire wr_start, wr_abort, wr_valid, wr_commit,
    input wire [7:0] wr_byte,
    input wire [ADDRESS_BITS-1:0] wr_index,
    output wire wr_ready,
    output logic wr_active = 0, wr_pending = 0, wr_error = 0, wr_published = 0,
    input wire rd_frame_start, rd_enable,
    input wire [ADDRESS_BITS-1:0] rd_address,
    output logic [7:0] rd_byte,
    output logic rd_valid = 0, rd_sector_valid = 0, rd_updated = 0
);
    (* ram_style = "block" *) logic [7:0] sectors [0:(2 << ADDRESS_BITS)-1];
    (* ASYNC_REG = "TRUE" *) logic [1:0] wr_reset_pipe = 2'b11;
    (* ASYNC_REG = "TRUE" *) logic [1:0] rd_reset_pipe = 2'b11;
    wire wr_reset = wr_reset_pipe[1];
    wire rd_reset = rd_reset_pipe[1];
    always_ff @(posedge wr_clk or posedge rst)
        if (rst) wr_reset_pipe <= 2'b11;
        else wr_reset_pipe <= {wr_reset_pipe[0], 1'b0};
    always_ff @(posedge rd_clk or posedge rst)
        if (rst) rd_reset_pipe <= 2'b11;
        else rd_reset_pipe <= {rd_reset_pipe[0], 1'b0};

    logic request = 0, acknowledged = 0, read_bank = 0;
    (* ASYNC_REG = "TRUE" *) logic ack_meta = 0, ack_sync = 0;
    (* ASYNC_REG = "TRUE" *) logic request_meta = 0, request_sync = 0;
    logic [ADDRESS_BITS:0] count = 0;
    logic sequence_error = 0;
    logic [1:0] drain_reads = 0;
    assign wr_ready = !wr_reset && !wr_active && !wr_pending;

    // Registros de entrada mantem todos os controles da BRAM sincronos.
    (* DONT_TOUCH = "TRUE" *) logic ram_write_enable = 0;
    (* DONT_TOUCH = "TRUE" *) logic [ADDRESS_BITS:0] ram_write_address;
    logic [7:0] ram_write_byte;
    (* DONT_TOUCH = "TRUE" *) logic ram_read_enable = 0;
    (* DONT_TOUCH = "TRUE" *) logic [ADDRESS_BITS:0] ram_read_address;
    wire accept_byte = !wr_reset && wr_active && !wr_abort && wr_valid &&
                       !sequence_error && count < BYTES && wr_index == count[ADDRESS_BITS-1:0];
    always_ff @(posedge wr_clk) begin
        ram_write_enable <= accept_byte;
        if (accept_byte) begin
            ram_write_address <= {~request, count[ADDRESS_BITS-1:0]};
            ram_write_byte <= wr_byte;
        end
    end
    always_ff @(posedge wr_clk)
        if (ram_write_enable) sectors[ram_write_address] <= ram_write_byte;

    always_ff @(posedge rd_clk) begin
        ram_read_enable <= rd_enable && rd_sector_valid && !rd_reset;
        ram_read_address <= {read_bank, rd_address};
        rd_valid <= ram_read_enable && !rd_reset;
    end
    always_ff @(posedge rd_clk)
        if (ram_read_enable) rd_byte <= sectors[ram_read_address];

    // O bit de pedido tambem identifica o banco publicado; nao cruza um barramento.
    always_ff @(posedge wr_clk) begin
        wr_published <= 0;
        if (wr_reset) begin
            request <= 0; ack_meta <= 0; ack_sync <= 0;
            wr_active <= 0; wr_pending <= 0; wr_error <= 0;
            count <= 0; sequence_error <= 0;
        end else begin
            ack_meta <= acknowledged;
            ack_sync <= ack_meta;
            if (wr_pending && ack_sync == request) begin
                wr_pending <= 0;
                wr_published <= 1;
            end
            if (wr_start && wr_ready) begin
                wr_active <= 1; wr_error <= 0;
                count <= 0; sequence_error <= 0;
            end else if (wr_active) begin
                if (wr_abort) begin
                    wr_active <= 0; wr_error <= 1;
                end else begin
                    if (wr_valid) begin
                        if (count < BYTES) count <= count + 1'b1;
                        if (count >= BYTES || wr_index != count[ADDRESS_BITS-1:0]) sequence_error <= 1;
                    end
                    // O controlador emite commit apos os dados e os dois bytes CRC.
                    if (wr_commit) begin
                        wr_active <= 0;
                        if (count == BYTES && !sequence_error && !wr_valid) begin
                            request <= ~request;
                            wr_pending <= 1;
                        end else wr_error <= 1;
                    end
                end
            end
        end
    end

    always_ff @(posedge rd_clk) begin
        rd_updated <= 0;
        if (rd_reset) begin
            request_meta <= 0; request_sync <= 0; acknowledged <= 0;
            read_bank <= 0; rd_sector_valid <= 0; drain_reads <= 0;
        end else begin
            request_meta <= request;
            request_sync <= request_meta;
            if (drain_reads != 0) begin
                drain_reads <= drain_reads - 1'b1;
                if (drain_reads == 1) acknowledged <= read_bank;
            end else if (request_sync != acknowledged && rd_frame_start) begin
                read_bank <= request_sync;
                rd_sector_valid <= 1;
                rd_updated <= 1;
                // Drena a leitura anterior antes de liberar seu banco para escrita.
                drain_reads <= 2;
            end
        end
    end
endmodule
