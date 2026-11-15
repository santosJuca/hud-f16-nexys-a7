`timescale 1ns/1ps

// data_valid bytes are provisional; block_valid confirms the full CRC-checked block.
module sd_spi_controller #(
    parameter integer POWERUP_CYCLES = 200_000,
    parameter integer HALF_PERIOD_CYCLES = 125,
    parameter integer MAX_ACMD41_TRIES = 4096,
    parameter integer MAX_READ_WAIT_R1_CLOCKS = 64,
    parameter integer INIT_HALF_PERIOD_CYCLES = HALF_PERIOD_CYCLES,
    parameter integer READ_HALF_PERIOD_CYCLES = HALF_PERIOD_CYCLES,
    parameter integer CLK_HZ = 100_000_000,
    parameter integer READ_TOKEN_TIMEOUT_MS = 250,
    parameter integer MAX_READ_WAIT_TOKEN_CLOCKS =
        8 * ((64'(CLK_HZ) * READ_TOKEN_TIMEOUT_MS + 16000 * READ_HALF_PERIOD_CYCLES - 1) /
             (16000 * READ_HALF_PERIOD_CYCLES))
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        read_start,
    input  wire [31:0] read_lba,
    input  wire        sd_miso,
    output wire        sd_reset,
    output wire        sd_sck,
    output wire        sd_mosi,
    output wire        sd_cs_n,
    output wire        init_ready,
    output wire        init_failed,
    output wire [2:0]  init_error_code,
    output wire        read_busy,
    output wire        read_done,
    output wire        read_error,
    output wire [2:0]  read_error_code,
    output wire        block_valid,
    output wire        data_valid,
    output wire [7:0]  data_byte,
    output wire [8:0]  byte_index,
    output wire [3:0]  current_state,
    output wire [5:0]  current_command,
    output wire [7:0]  r1_response,
    output wire [7:0]  data_token,
    output wire [9:0]  bytes_received,
    output wire [15:0] crc_received,
    output wire [15:0] crc_calculated
);

    wire init_sck;
    wire init_mosi;
    wire init_cs_n;
    wire init_sd_reset;
    wire read_sck;
    wire read_mosi;
    wire read_cs_n;
    reg read_start_pulse;
    reg [31:0] accepted_lba;
    wire read_done_int;
    wire read_error_int;
    reg read_owner;
    reg read_start_d;
    reg read_busy_seen;
    wire [2:0] init_command;

    assign current_command = read_owner ? 6'd17 :
        init_command == 0 ? 6'd0 : init_command == 1 ? 6'd8 :
        init_command == 2 ? 6'd55 : init_command == 3 ? 6'd41 : 6'd58;

    assign sd_reset = init_sd_reset;
    assign sd_sck = read_owner ? read_sck : init_sck;
    assign sd_mosi = read_owner ? read_mosi : init_mosi;
    assign sd_cs_n = read_owner ? read_cs_n : init_cs_n;
    sd_spi_init #(
        .POWERUP_CYCLES(POWERUP_CYCLES),
        .HALF_PERIOD_CYCLES(INIT_HALF_PERIOD_CYCLES),
        .MAX_ACMD41_TRIES(MAX_ACMD41_TRIES)
    ) init (
        .clk(clk),
        .rst(rst),
        .sd_miso(sd_miso),
        .sd_reset(init_sd_reset),
        .sd_sck(init_sck),
        .sd_mosi(init_mosi),
        .sd_cs_n(init_cs_n),
        .ready(init_ready),
        .failed(init_failed),
        .error_code(init_error_code),
        .current_command(init_command),
        .ocr()
    );

    sd_spi_read_block #(
        .HALF_PERIOD_CYCLES(READ_HALF_PERIOD_CYCLES),
        .MAX_WAIT_R1_CLOCKS(MAX_READ_WAIT_R1_CLOCKS),
        .MAX_WAIT_TOKEN_CLOCKS(MAX_READ_WAIT_TOKEN_CLOCKS)
    ) read_block (
        .clk(clk),
        .rst(rst),
        .start(read_start_pulse),
        .lba(accepted_lba),
        .sd_miso(sd_miso),
        .sd_sck(read_sck),
        .sd_mosi(read_mosi),
        .sd_cs_n(read_cs_n),
        .busy(read_busy),
        .done(read_done_int),
        .error(read_error_int),
        .error_code(read_error_code),
        .data_valid(data_valid),
        .data_byte(data_byte),
        .byte_index(byte_index),
        .block_valid(block_valid),
        .current_state(current_state), .r1_response(r1_response),
        .data_token(data_token), .bytes_received(bytes_received),
        .crc_received(crc_received), .crc_calculated(crc_calculated)
    );

    assign read_done = read_done_int;
    assign read_error = read_error_int;

    // A request edge is consumed even before init_ready; it is never queued.
    // busy_seen prevents a sticky prior read_error from releasing a new transaction.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accepted_lba <= 0;
            read_owner <= 0;
            read_start_d <= 0;
            read_busy_seen <= 0;
            read_start_pulse <= 0;
        end else begin
            read_start_d <= read_start;
            read_start_pulse <= 0;

            if (init_ready && !init_failed && read_start && !read_start_d &&
                !read_busy &&
                (!read_owner || read_done_int || read_error_int)) begin
                // O chamador pode liberar o endereco apos aceitar a requisicao.
                accepted_lba <= read_lba;
                read_owner <= 1;
                read_busy_seen <= 0;
                read_start_pulse <= 1;
            end else if (read_owner && read_busy) begin
                read_busy_seen <= 1;
            end else if (read_owner && read_busy_seen && !read_busy &&
                         (read_done_int || read_error_int)) begin
                read_owner <= 0;
                read_busy_seen <= 0;
            end
        end
    end
endmodule
