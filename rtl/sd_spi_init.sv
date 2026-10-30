module sd_spi_init #(
    parameter integer POWERUP_CYCLES = 200_000,
    parameter integer HALF_PERIOD_CYCLES = 125,
    parameter integer MAX_ACMD41_TRIES = 4096
)(
    input  wire clk,
    input  wire rst,
    input  wire sd_miso,

    output wire sd_reset,
    output wire sd_sck,
    output wire sd_mosi,
    output wire sd_cs_n,

    output reg  ready,
    output reg  failed,
    output reg [2:0] error_code,
    output wire [2:0] current_command,
    output reg [31:0] ocr
);

    localparam [2:0]
        CMD0   = 0,
        CMD8   = 1,
        CMD55  = 2,
        ACMD41 = 3,
        CMD58  = 4;

    localparam [2:0]
        POWER_WAIT = 0,
        ISSUE      = 1,
        WAIT_REPLY = 2,
        COMPLETE   = 3,
        ERROR      = 4;

    reg [2:0] state;
    reg [2:0] command_sel;
    reg [31:0] attempts;
    reg command_start;

    reg [47:0] command_frame;
    reg extended_reply;

    wire pre_sck, pre_mosi, pre_cs, pre_ready;
    wire cmd_sck, cmd_mosi, cmd_cs;
    wire cmd_done, cmd_timeout;
    wire [7:0] cmd_r1;
    wire [31:0] cmd_extra;

    assign current_command = command_sel;

    assign sd_sck  = pre_ready ? cmd_sck  : pre_sck;
    assign sd_mosi = pre_ready ? cmd_mosi : pre_mosi;
    assign sd_cs_n = pre_ready ? cmd_cs   : pre_cs;

    sd_spi_preamble #(
        .POWERUP_CYCLES(POWERUP_CYCLES),
        .HALF_PERIOD_CYCLES(HALF_PERIOD_CYCLES)
    ) preamble (
        .clk(clk),
        .rst(rst),
        .sd_reset(sd_reset),
        .sd_sck(pre_sck),
        .sd_cmd(pre_mosi),
        .sd_cs_n(pre_cs),
        .ready(pre_ready)
    );

    always @(*) begin
        extended_reply = 0;
        case (command_sel)
            CMD0:
                command_frame = 48'h400000000095;
            CMD8: begin
                command_frame = 48'h48000001AA87;
                extended_reply = 1;
            end
            CMD55:
                command_frame = 48'h7700000000FF;
            ACMD41:
                command_frame = 48'h6940000000FF;
            CMD58: begin
                command_frame = 48'h7A00000000FF;
                extended_reply = 1;
            end
            default:
                command_frame = 48'hFFFFFFFFFFFF;
        endcase
    end

    sd_spi_command #(
        .HALF_PERIOD_CYCLES(HALF_PERIOD_CYCLES)
    ) command (
        .clk(clk),
        .rst(rst),
        .start(command_start),
        .command_frame(command_frame),
        .long_response(extended_reply),
        .miso(sd_miso),
        .sck(cmd_sck),
        .mosi(cmd_mosi),
        .cs_n(cmd_cs),
        .busy(),
        .done(cmd_done),
        .timeout(cmd_timeout),
        .r1(cmd_r1),
        .extra(cmd_extra)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= POWER_WAIT;
            command_sel <= CMD0;
            command_start <= 0;
            attempts <= 0;
            ready <= 0;
            failed <= 0;
            error_code <= 0;
            ocr <= 0;
        end else begin
            command_start <= 0;

            case (state)
                POWER_WAIT: begin
                    if (pre_ready)
                        state <= ISSUE;
                end

                ISSUE: begin
                    command_start <= 1;
                    state <= WAIT_REPLY;
                end

                WAIT_REPLY: begin
                    if (cmd_done) begin
                        if (cmd_timeout) begin
                            failed <= 1;
                            error_code <= 7;
                            state <= ERROR;
                        end else begin
                            case (command_sel)
                                CMD0: begin
                                    if (cmd_r1 == 8'h01) begin
                                        command_sel <= CMD8;
                                        state <= ISSUE;
                                    end else begin
                                        failed <= 1;
                                        error_code <= 1;
                                        state <= ERROR;
                                    end
                                end

                                CMD8: begin
                                    if (cmd_r1 == 8'h01 &&
                                        cmd_extra == 32'h000001AA) begin
                                        command_sel <= CMD55;
                                        state <= ISSUE;
                                    end else begin
                                        failed <= 1;
                                        error_code <= 2;
                                        state <= ERROR;
                                    end
                                end

                                CMD55: begin
                                    if (cmd_r1 == 8'h01) begin
                                        command_sel <= ACMD41;
                                        state <= ISSUE;
                                    end else begin
                                        failed <= 1;
                                        error_code <= 3;
                                        state <= ERROR;
                                    end
                                end

                                ACMD41: begin
                                    if (cmd_r1 == 8'h00) begin
                                        command_sel <= CMD58;
                                        state <= ISSUE;
                                    end else if (cmd_r1 == 8'h01) begin
                                        if (attempts + 1 >=
                                            MAX_ACMD41_TRIES) begin
                                            failed <= 1;
                                            error_code <= 5;
                                            state <= ERROR;
                                        end else begin
                                            attempts <= attempts + 1;
                                            command_sel <= CMD55;
                                            state <= ISSUE;
                                        end
                                    end else begin
                                        failed <= 1;
                                        error_code <= 4;
                                        state <= ERROR;
                                    end
                                end

                                CMD58: begin
                                    ocr <= cmd_extra;

                                    if (cmd_r1 == 8'h00 &&
                                        cmd_extra[31:30] == 2'b11 &&
                                        |cmd_extra[23:15]) begin
                                        ready <= 1;
                                        state <= COMPLETE;
                                    end else begin
                                        failed <= 1;
                                        error_code <= 6;
                                        state <= ERROR;
                                    end
                                end

                                default: begin
                                    failed <= 1;
                                    error_code <= 7;
                                    state <= ERROR;
                                end
                            endcase
                        end
                    end
                end

                COMPLETE: ready <= 1;
                ERROR: failed <= 1;

                default: state <= ERROR;
            endcase
        end
    end
endmodule
