`timescale 1ns/1ps

// Dedicated CMD17 transaction keeps CS active through R1, data, and CRC.
// data_valid bytes are provisional; block_valid confirms the complete CRC-checked sector.
module sd_spi_read_block #(
    parameter integer HALF_PERIOD_CYCLES = 2,
    parameter integer MAX_WAIT_R1_CLOCKS = 64,
    parameter integer MAX_WAIT_TOKEN_CLOCKS = 65535
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [31:0] lba,
    input  wire        sd_miso,
    output reg         sd_sck,
    output reg         sd_mosi,
    output reg         sd_cs_n,
    output reg         busy,
    output reg         done,
    output reg         error,
    output reg  [2:0]  error_code,
    output reg         data_valid,
    output reg  [7:0]  data_byte,
    output reg  [8:0]  byte_index,
    output reg         block_valid
);

    localparam [3:0]
        IDLE       = 0,
        TX_CMD     = 1,
        WAIT_R1    = 2,
        READ_R1    = 3,
        WAIT_TOKEN = 4,
        READ_DATA  = 5,
        READ_CRC   = 6,
        END_BLOCK  = 7,
        END_ERROR  = 8,
        TRAIL_OK   = 9,
        TRAIL_ERR  = 10,
        TRAIL_DONE_OK = 11,
        TRAIL_DONE_ERR = 12;

    localparam [2:0]
        ERR_R1          = 1,
        ERR_R1_TIMEOUT  = 2,
        ERR_TOKEN_TO    = 3,
        ERR_TOKEN       = 4,
        ERR_CRC         = 5;

    localparam integer DIV_WIDTH = HALF_PERIOD_CYCLES < 2 ? 1 :
                                   $clog2(HALF_PERIOD_CYCLES);

    reg [3:0] state;
    reg start_d;
    reg [DIV_WIDTH-1:0] divider;
    reg [47:0] command_frame;
    reg [5:0] tx_bit;
    reg [2:0] rx_bit;
    reg [8:0] data_count;
    reg [7:0] rx_shift;
    reg [3:0] trail_count;
    reg [15:0] crc_rx;
    reg crc_byte_count;
    reg [15:0] crc_calc;
    reg [31:0] wait_count;
    reg [2:0] pending_error_code;

    function [15:0] crc16_byte;
        input [15:0] crc_in;
        input [7:0] data_in;
        integer bit_number;
        reg [15:0] value;
        begin
            value = crc_in ^ {data_in, 8'h00};
            for (bit_number = 0; bit_number < 8; bit_number = bit_number + 1)
                if (value[15])
                    value = (value << 1) ^ 16'h1021;
                else
                    value = value << 1;
            crc16_byte = value;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            start_d <= 0;
            divider <= 0;
            command_frame <= 0;
            tx_bit <= 0;
            rx_bit <= 0;
            data_count <= 0;
            rx_shift <= 0;
            trail_count <= 0;
            crc_rx <= 0;
            crc_byte_count <= 0;
            crc_calc <= 0;
            wait_count <= 0;
            pending_error_code <= 0;
            sd_sck <= 0;
            sd_mosi <= 1;
            sd_cs_n <= 1;
            busy <= 0;
            done <= 0;
            error <= 0;
            error_code <= 0;
            data_valid <= 0;
            data_byte <= 0;
            byte_index <= 0;
            block_valid <= 0;
        end else begin
            start_d <= start;
            done <= 0;
            data_valid <= 0;
            block_valid <= 0;

            if (state == IDLE) begin
                sd_sck <= 0;
                sd_mosi <= 1;
                sd_cs_n <= 1;
                busy <= 0;
                divider <= 0;

                if (start && !start_d) begin
                    state <= TX_CMD;
                    command_frame <= {8'h51, lba, 8'hFF};
                    tx_bit <= 0;
                    rx_bit <= 0;
                    rx_shift <= 0;
                    crc_calc <= 0;
                    crc_byte_count <= 0;
                    crc_rx <= 0;
                    wait_count <= 0;
                    byte_index <= 0;
                    data_count <= 0;
                    error <= 0;
                    error_code <= 0;
                    sd_cs_n <= 0;
                    sd_mosi <= 0;
                    busy <= 1;
                end
            end else if (divider == HALF_PERIOD_CYCLES-1) begin
                divider <= 0;
                if (!sd_sck) begin
                    sd_sck <= 1;
                    case (state)
                        WAIT_R1: begin
                            if (!sd_miso) begin
                                state <= READ_R1;
                                rx_bit <= 0;
                                rx_shift <= 0;
                            end else if (wait_count >= MAX_WAIT_R1_CLOCKS-1) begin
                                pending_error_code <= ERR_R1_TIMEOUT;
                                state <= END_ERROR;
                            end else begin
                                wait_count <= wait_count + 1'b1;
                            end
                        end
                        READ_R1: begin
                            rx_shift <= {rx_shift[6:0], sd_miso};
                            if (rx_bit == 6) begin
                                if ({1'b0, rx_shift[5:0], sd_miso} == 8'h00) begin
                                    state <= WAIT_TOKEN;
                                    wait_count <= 0;
                                    rx_bit <= 0;
                                    rx_shift <= 0;
                                end else begin
                                    pending_error_code <= ERR_R1;
                                    state <= END_ERROR;
                                end
                            end else begin
                                rx_bit <= rx_bit + 1'b1;
                            end
                        end
                        WAIT_TOKEN: begin
                            wait_count <= wait_count + 1'b1;
                            rx_shift <= {rx_shift[6:0], sd_miso};
                            if (rx_bit == 7) begin
                                if ({rx_shift[6:0], sd_miso} == 8'hFE) begin
                                    state <= READ_DATA;
                                    rx_bit <= 0;
                                    rx_shift <= 0;
                                    byte_index <= 0;
                                    data_count <= 0;
                                    crc_calc <= 0;
                                end else if ({rx_shift[6:0], sd_miso} != 8'hFF) begin
                                    pending_error_code <= ERR_TOKEN;
                                    state <= END_ERROR;
                                end else if (wait_count >= MAX_WAIT_TOKEN_CLOCKS-1) begin
                                    pending_error_code <= ERR_TOKEN_TO;
                                    state <= END_ERROR;
                                end else begin
                                    rx_bit <= 0;
                                    rx_shift <= 0;
                                end
                            end else begin
                                rx_bit <= rx_bit + 1'b1;
                            end
                        end
                        READ_DATA: begin
                            rx_shift <= {rx_shift[6:0], sd_miso};
                            if (rx_bit == 7) begin
                                data_byte <= {rx_shift[6:0], sd_miso};
                                data_valid <= 1;
                                byte_index <= data_count;
                                crc_calc <= crc16_byte(crc_calc, {rx_shift[6:0], sd_miso});
                                rx_bit <= 0;
                                rx_shift <= 0;
                                if (data_count == 511)
                                    state <= READ_CRC;
                                else
                                    data_count <= data_count + 1'b1;
                            end else begin
                                rx_bit <= rx_bit + 1'b1;
                            end
                        end
                        TRAIL_OK, TRAIL_ERR: begin
                            if (trail_count == 7)
                                state <= state == TRAIL_OK ? TRAIL_DONE_OK : TRAIL_DONE_ERR;
                            else
                                trail_count <= trail_count + 1'b1;
                        end
                        READ_CRC: begin
                            rx_shift <= {rx_shift[6:0], sd_miso};
                            if (rx_bit == 7) begin
                                rx_bit <= 0;
                                rx_shift <= 0;
                                if (!crc_byte_count) begin
                                    crc_rx[15:8] <= {rx_shift[6:0], sd_miso};
                                    crc_byte_count <= 1;
                                end else begin
                                    crc_rx[7:0] <= {rx_shift[6:0], sd_miso};
                                    if ({crc_rx[15:8], {rx_shift[6:0], sd_miso}} == crc_calc)
                                        state <= END_BLOCK;
                                    else begin
                                        pending_error_code <= ERR_CRC;
                                        state <= END_ERROR;
                                    end
                                end
                            end else begin
                                rx_bit <= rx_bit + 1'b1;
                            end
                        end
                    endcase
                end else begin
                    sd_sck <= 0;
                    case (state)
                        TX_CMD: begin
                            if (tx_bit == 47) begin
                                state <= WAIT_R1;
                                sd_mosi <= 1;
                                wait_count <= 0;
                            end else begin
                                tx_bit <= tx_bit + 1'b1;
                                sd_mosi <= command_frame[46-tx_bit];
                            end
                        end
                        END_BLOCK: begin
                            sd_cs_n <= 1;
                            sd_mosi <= 1;
                            trail_count <= 0;
                            state <= TRAIL_OK;
                        end
                        END_ERROR: begin
                            sd_cs_n <= 1;
                            sd_mosi <= 1;
                            trail_count <= 0;
                            state <= TRAIL_ERR;
                        end
                        TRAIL_DONE_OK: begin
                            busy <= 0;
                            done <= 1;
                            block_valid <= 1;
                            state <= IDLE;
                        end
                        TRAIL_DONE_ERR: begin
                            busy <= 0;
                            error <= 1;
                            error_code <= pending_error_code;
                            state <= IDLE;
                        end
                    endcase
                end
            end else begin
                divider <= divider + 1'b1;
            end
        end
    end
endmodule
