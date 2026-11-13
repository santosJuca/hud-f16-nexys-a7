// Read/write smoke test for the native MIG 7-Series DDR2 user interface.
// Simulation candidate only: not a framebuffer or a qualified hardware tester.
// UI: 4:1, DDR2 BL8, 16-bit DDR bus => 128-bit UI word per write/read.
module ddr2_ui_smoke #(
    parameter integer WORDS = 16,
    parameter integer MAX_ACTIVE_CYCLES = 100000
) (
    input  wire         ui_clk,
    input  wire         ui_rst,
    input  wire         init_calib_complete,
    input  wire         app_rdy,
    input  wire         app_wdf_rdy,
    input  wire [127:0] app_rd_data,
    input  wire         app_rd_data_valid,
    input  wire         app_rd_data_end,
    output wire [26:0]  app_addr,
    output wire [2:0]   app_cmd,
    output wire         app_en,
    output wire [127:0] app_wdf_data,
    output wire [15:0]  app_wdf_mask,
    output wire         app_wdf_wren,
    output wire         app_wdf_end,
    output reg          test_done,
    output reg          test_pass,
    output reg          test_error,
    output reg [7:0]    words_compared
);
    localparam [2:0] S_CAL  = 3'd0;
    localparam [2:0] S_WR   = 3'd1;
    localparam [2:0] S_RD   = 3'd2;
    localparam [2:0] S_WAIT = 3'd3;
    localparam [2:0] S_DONE = 3'd4;
    localparam [2:0] S_FAIL = 3'd5;

    reg [2:0] state;
    reg [7:0] word_index;
    reg [31:0] active_cycles;

    // 16 RGB332-like pixel bytes, packed into a single 128-bit UI beat.
    function [127:0] pixel_word;
        input [7:0] index;
        integer j;
        begin
            for (j = 0; j < 16; j = j + 1)
                pixel_word[(8*j) +: 8] = (({index, 4'b0} + j) ^ 12'h0a5);
        end
    endfunction

    // A write command and its BL8 data are accepted on the SAME UI edge.
    // Waiting for both ready signals prevents a command-to-data delay.
    wire write_accept = (state == S_WR) && app_rdy && app_wdf_rdy;
    wire read_accept  = (state == S_RD) && app_rdy;

    // BL8 on a 16-bit DDR bus: each UI word covers 8 column addresses.
    assign app_addr     = {16'b0, word_index, 3'b0};
    assign app_cmd      = (state == S_RD) ? 3'b001 : 3'b000;
    assign app_en       = write_accept || read_accept;
    assign app_wdf_data = pixel_word(word_index);
    assign app_wdf_mask = 16'b0;
    assign app_wdf_wren = write_accept;
    assign app_wdf_end  = write_accept;

    always @(posedge ui_clk) begin
        if (ui_rst) begin
            state          <= S_CAL;
            word_index     <= 8'd0;
            active_cycles  <= 32'd0;
            words_compared <= 8'd0;
            test_done      <= 1'b0;
            test_pass      <= 1'b0;
            test_error     <= 1'b0;
        end else begin
            if ((state != S_CAL) && (state != S_DONE) && (state != S_FAIL))
                active_cycles <= active_cycles + 1'b1;

            if ((state != S_CAL) && (state != S_DONE) && (state != S_FAIL) &&
                (active_cycles >= MAX_ACTIVE_CYCLES)) begin
                state      <= S_FAIL;
                test_done  <= 1'b1;
                test_error <= 1'b1;
            end else begin
                case (state)
                    S_CAL: begin
                        if (init_calib_complete) begin
                            word_index    <= 8'd0;
                            active_cycles <= 32'd0;
                            state         <= S_WR;
                        end
                    end
                    S_WR: begin
                        if (write_accept) begin
                            if (word_index == (WORDS - 1)) begin
                                word_index <= 8'd0;
                                state <= S_RD;
                            end else
                                word_index <= word_index + 1'b1;
                        end
                    end
                    S_RD: begin
                        if (read_accept)
                            state <= S_WAIT;
                    end
                    S_WAIT: begin
                        if (app_rd_data_valid) begin
                            if (!app_rd_data_end ||
                                (app_rd_data !== pixel_word(word_index))) begin
                                test_error <= 1'b1;
                                test_done  <= 1'b1;
                                state      <= S_FAIL;
                            end else begin
                                words_compared <= words_compared + 1'b1;
                                if (word_index == (WORDS - 1)) begin
                                    test_pass <= 1'b1;
                                    test_done <= 1'b1;
                                    state <= S_DONE;
                                end else begin
                                    word_index <= word_index + 1'b1;
                                    state <= S_RD;
                                end
                            end
                        end
                    end
                    default: begin
                        // Terminal states keep their results until reset.
                    end
                endcase
            end
        end
    end
endmodule
