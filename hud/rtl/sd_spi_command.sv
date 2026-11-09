module sd_spi_command #(
    parameter integer HALF_PERIOD_CYCLES = 125,
    parameter integer MAX_WAIT_R1_CLOCKS = 64
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [47:0] command_frame,
    input  wire        long_response,
    input  wire        miso,

    output reg         sck,
    output reg         mosi,
    output reg         cs_n,
    output reg         busy,
    output reg         done,
    output reg         timeout,
    output reg  [7:0]  r1,
    output reg  [31:0] extra
);

    localparam [2:0]
        IDLE    = 3'd0,
        TX      = 3'd1,
        WAIT_R1 = 3'd2,
        READ_R1 = 3'd3,
        READ_R7 = 3'd4,
        TRAIL   = 3'd5;

    localparam integer DW =
        HALF_PERIOD_CYCLES < 2 ? 1 :
        $clog2(HALF_PERIOD_CYCLES);

    localparam integer WW =
        MAX_WAIT_R1_CLOCKS < 2 ? 1 :
        $clog2(MAX_WAIT_R1_CLOCKS);

    reg [2:0] state;
    reg [DW-1:0] divider;
    reg [WW-1:0] wait_count;

    reg [47:0] frame;
    reg [5:0] tx_count;
    reg [2:0] r1_count;
    reg [5:0] extra_count;
    reg [3:0] trail_count;

    reg want_extra;
    reg finish_pending;
    reg timeout_pending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            divider         <= 0;
            wait_count      <= 0;
            frame           <= 0;
            tx_count        <= 0;
            r1_count        <= 0;
            extra_count     <= 0;
            trail_count     <= 0;
            want_extra      <= 0;
            finish_pending  <= 0;
            timeout_pending <= 0;

            sck     <= 0;
            mosi    <= 1;
            cs_n    <= 1;
            busy    <= 0;
            done    <= 0;
            timeout <= 0;
            r1      <= 8'hFF;
            extra   <= 0;
        end else begin
            done <= 0;

            if (state == IDLE) begin
                sck     <= 0;
                mosi    <= 1;
                cs_n    <= 1;
                busy    <= 0;
                divider <= 0;

                if (start) begin
                    state           <= TX;
                    frame           <= command_frame;
                    want_extra      <= long_response;
                    tx_count        <= 0;
                    r1_count        <= 0;
                    extra_count     <= 0;
                    trail_count     <= 0;
                    wait_count      <= 0;
                    finish_pending  <= 0;
                    timeout_pending <= 0;

                    mosi    <= command_frame[47];
                    cs_n    <= 0;
                    busy    <= 1;
                    timeout <= 0;
                    r1      <= 8'hFF;
                    extra   <= 0;
                end
            end else if (divider == HALF_PERIOD_CYCLES-1) begin
                divider <= 0;

                if (!sck) begin
                    sck <= 1;

                    case (state)
                        TX: begin
                            tx_count <= tx_count + 1'b1;
                        end

                        WAIT_R1: begin
                            if (!miso) begin
                                r1 <= 0;
                                r1_count <= 0;
                                state <= READ_R1;
                            end else if (wait_count ==
                                         MAX_WAIT_R1_CLOCKS-1) begin
                                finish_pending <= 1;
                                timeout_pending <= 1;
                            end else begin
                                wait_count <= wait_count + 1'b1;
                            end
                        end

                        READ_R1: begin
                            r1 <= {r1[6:0], miso};

                            if (r1_count == 6) begin
                                if (want_extra)
                                    state <= READ_R7;
                                else
                                    finish_pending <= 1;
                            end else begin
                                r1_count <= r1_count + 1'b1;
                            end
                        end

                        READ_R7: begin
                            extra <= {extra[30:0], miso};

                            if (extra_count == 31)
                                finish_pending <= 1;
                            else
                                extra_count <= extra_count + 1'b1;
                        end

                        TRAIL: begin
                            trail_count <= trail_count + 1'b1;
                        end
                    endcase

                end else begin
                    sck <= 0;

                    case (state)
                        TX: begin
                            if (tx_count == 48) begin
                                state <= WAIT_R1;
                                mosi <= 1;
                            end else begin
                                mosi <= frame[47-tx_count];
                            end
                        end

                        WAIT_R1, READ_R1, READ_R7: begin
                            if (finish_pending) begin
                                cs_n <= 1;
                                mosi <= 1;
                                state <= TRAIL;
                                trail_count <= 0;
                            end
                        end

                        TRAIL: begin
                            if (trail_count == 8) begin
                                state <= IDLE;
                                busy <= 0;
                                done <= 1;
                                timeout <= timeout_pending;
                            end
                        end
                    endcase
                end
            end else begin
                divider <= divider + 1'b1;
            end
        end
    end
endmodule
