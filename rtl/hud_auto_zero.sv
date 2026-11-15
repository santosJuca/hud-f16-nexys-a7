module hud_auto_zero #(
    parameter integer SETTLE_UPDATES = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic enabled,
    input  logic calibrated,
    input  logic valid,
    input  logic stationary,
    input  logic updated,
    input  logic already_zeroed,
    input  logic signed [31:0] raw_roll,
    input  logic signed [31:0] raw_pitch,
    output logic zero_pulse = 1'b0,
    output logic done = 1'b0
);

    localparam integer W =
        SETTLE_UPDATES > 1 ? $clog2(SETTLE_UPDATES) : 1;

    logic [W-1:0] stable_updates = '0;

    wire near_neutral =
        raw_roll >= -32'sd5120 &&
        raw_roll <=  32'sd5120 &&
        raw_pitch >= -32'sd5120 &&
        raw_pitch <=  32'sd5120;

    wire eligible =
        enabled && calibrated && valid &&
        stationary && near_neutral;

    always_ff @(posedge clk) begin
        zero_pulse <= 1'b0;

        if (reset) begin
            done <= 1'b0;
            stable_updates <= '0;
        end
        else if (!done) begin
            if (already_zeroed) begin
                done <= 1'b1;
                stable_updates <= '0;
            end
            else if (!eligible) begin
                stable_updates <= '0;
            end
            else if (updated) begin
                if (stable_updates == W'(SETTLE_UPDATES-1)) begin
                    zero_pulse <= 1'b1;
                    done <= 1'b1;
                end
                else
                    stable_updates <= stable_updates + 1'b1;
            end
        end
    end
endmodule
