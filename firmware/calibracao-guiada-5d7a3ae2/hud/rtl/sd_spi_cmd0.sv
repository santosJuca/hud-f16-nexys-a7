module sd_spi_cmd0 #(
    parameter integer HALF_PERIOD_CYCLES = 125,
    parameter integer MAX_RESPONSE_CLOCKS = 64
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire miso,
    output reg  sck,
    output reg  mosi,
    output reg  cs_n,
    output reg  done,
    output reg  success,
    output reg [7:0] r1
);

    localparam IDLE = 2'd0;
    localparam TX   = 2'd1;
    localparam RX   = 2'd2;
    localparam END_TX = 2'd3;

    localparam integer DW =
        (HALF_PERIOD_CYCLES < 2) ? 1 :
        $clog2(HALF_PERIOD_CYCLES);

    reg [1:0] state;
    reg [DW-1:0] divider;
    reg [47:0] tx_shift;
    reg [5:0] tx_left;

    reg [15:0] response_clocks;
    reg [3:0] response_bits;
    reg [7:0] rx_shift;
    reg finish_pending;
    reg timeout_pending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            divider <= 0;
            tx_shift <= 0;
            tx_left <= 0;
            response_clocks <= 0;
            response_bits <= 0;
            rx_shift <= 8'hFF;
            finish_pending <= 0;
            timeout_pending <= 0;
            sck <= 0;
            mosi <= 1;
            cs_n <= 1;
            done <= 0;
            success <= 0;
            r1 <= 8'hFF;
        end else begin
            done <= 0;

            case (state)
                IDLE: begin
                    sck <= 0;
                    mosi <= 1;
                    cs_n <= 1;
                    divider <= 0;

                    if (start) begin
                        state <= TX;
                        cs_n <= 0;
                        tx_shift <= 48'h400000000095;
                        tx_left <= 48;
                        mosi <= 0;
                        response_clocks <= 0;
                        response_bits <= 0;
                        rx_shift <= 8'hFF;
                        finish_pending <= 0;
                        timeout_pending <= 0;
                        success <= 0;
                    end
                end

                TX, RX: begin
                    if (divider == HALF_PERIOD_CYCLES-1) begin
                        divider <= 0;

                        if (!sck) begin
                            sck <= 1;

                            if (state == RX) begin
                                response_clocks <= response_clocks + 1'b1;

                                if (response_bits == 0) begin
                                    if (!miso) begin
                                        rx_shift <= 8'h00;
                                        response_bits <= 1;
                                    end
                                end else if (response_bits < 8) begin
                                    rx_shift <= {rx_shift[6:0], miso};
                                    response_bits <= response_bits + 1'b1;

                                    if (response_bits == 7)
                                        finish_pending <= 1;
                                end

                                if (response_clocks ==
                                    MAX_RESPONSE_CLOCKS-1 &&
                                    response_bits != 7) begin
                                    finish_pending <= 1;
                                    timeout_pending <= 1;
                                end
                            end
                        end else begin
                            sck <= 0;

                            if (state == TX) begin
                                if (tx_left == 1) begin
                                    state <= RX;
                                    mosi <= 1;
                                end else begin
                                    tx_left <= tx_left - 1'b1;
                                    mosi <= tx_shift[46];
                                    tx_shift <= {tx_shift[46:0], 1'b1};
                                end
                            end else if (finish_pending) begin
                                state <= END_TX;
                                cs_n <= 1;
                                r1 <= rx_shift;
                                success <= !timeout_pending &&
                                           (rx_shift == 8'h01);
                                done <= 1;
                            end
                        end
                    end else begin
                        divider <= divider + 1'b1;
                    end
                end

                END_TX: begin
                    sck <= 0;
                    cs_n <= 1;
                    mosi <= 1;
                    if (!start)
                        state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
