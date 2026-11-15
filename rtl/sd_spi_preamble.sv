module sd_spi_preamble #(
    parameter integer POWERUP_CYCLES = 100_000,
    parameter integer HALF_PERIOD_CYCLES = 125
)(
    input  wire clk,
    input  wire rst,
    output reg  sd_reset,
    output reg  sd_sck,
    output reg  sd_cmd,
    output reg  sd_cs_n,
    output reg  ready
);

    localparam integer PW = (POWERUP_CYCLES < 2)
                          ? 1 : $clog2(POWERUP_CYCLES);
    localparam integer DW = (HALF_PERIOD_CYCLES < 2)
                          ? 1 : $clog2(HALF_PERIOD_CYCLES);

    reg [PW-1:0] power_count;
    reg [DW-1:0] divider;
    reg [7:0] half_edges;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= 0;
            power_count <= 0;
            divider     <= 0;
            half_edges  <= 0;
            sd_reset    <= 1'b1;
            sd_sck      <= 1'b0;
            sd_cmd      <= 1'b1;
            sd_cs_n     <= 1'b1;
            ready       <= 1'b0;
        end else begin
            case (state)
                0: begin
                    sd_reset <= 1'b0;
                    if (power_count == POWERUP_CYCLES-1)
                        state <= 1;
                    else
                        power_count <= power_count + 1'b1;
                end

                1: begin
                    if (divider == HALF_PERIOD_CYCLES-1) begin
                        divider <= 0;
                        sd_sck <= ~sd_sck;

                        if (half_edges == 159) begin
                            state <= 2;
                            ready <= 1'b1;
                        end else begin
                            half_edges <= half_edges + 1'b1;
                        end
                    end else begin
                        divider <= divider + 1'b1;
                    end
                end

                2: ready <= 1'b1;
                default: state <= 0;
            endcase
        end
    end
endmodule
