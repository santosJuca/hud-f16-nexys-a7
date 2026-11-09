// P4A: verifica um quadro inteiro RGB332 sintetico na interface nativa do MIG.
// Nao recebe bytes do microSD nem alimenta VGA: teste isolado de capacidade
// e integridade. Cada beat de 128 bits corresponde a 16 pixels consecutivos.
// DDR2 x16, burst BL8, UI 4:1: enderecos MIG avancam 8 por beat.
module ddr2_ui_frame_test #(
    parameter integer WORDS = 4800,
    parameter integer MAX_ACTIVE_CYCLES = 1000000
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
    output reg          test_done = 1'b0,
    output reg          test_pass = 1'b0,
    output reg          test_error = 1'b0,
    output reg [12:0]   words_compared = 13'd0
);
    localparam [2:0] WAIT_CAL = 3'd0;
    localparam [2:0] WRITE    = 3'd1;
    localparam [2:0] READ     = 3'd2;
    localparam [2:0] WAIT_RD  = 3'd3;
    localparam [2:0] PASS     = 3'd4;
    localparam [2:0] FAIL     = 3'd5;

    reg [2:0] state = WAIT_CAL;
    reg [12:0] index = 13'd0;
    reg [31:0] elapsed = 32'd0;

    // Padrao calculado pelo endereco absoluto, sem RAM de referencia interna.
    // Integra todos os 13 bits do indice para localizar trocas de beats.
    function [127:0] expected_word;
        input [12:0] beat_index;
        integer byte_idx;
        reg [7:0] pattern;
        begin
            for (byte_idx = 0; byte_idx < 16; byte_idx = byte_idx + 1) begin
                if (byte_idx == 0)
                    pattern = beat_index[7:0] ^ 8'hA5;
                else if (byte_idx == 1)
                    pattern = {3'd0, beat_index[12:8]} ^ 8'h5A;
                else
                    pattern = (beat_index[7:0] +
                        (beat_index[12:8] * 8'd29) + (byte_idx * 8'd37)) ^ 8'hA5;
                expected_word[(byte_idx*8) +: 8] = pattern;
            end
        end
    endfunction

    wire write_accept = state == WRITE && app_rdy && app_wdf_rdy;
    wire read_accept = state == READ && app_rdy;

    // 13 bits de indice + 3 de coluna BL8, zero-extendendo para app_addr[26:0].
    assign app_addr = {11'd0, index, 3'd0};
    assign app_cmd = state == READ ? 3'b001 : 3'b000;
    assign app_en = write_accept || read_accept;
    assign app_wdf_data = expected_word(index);
    assign app_wdf_mask = 16'd0;
    assign app_wdf_wren = write_accept;
    assign app_wdf_end = write_accept;

    initial begin
        if (WORDS < 1 || WORDS > 8191 || MAX_ACTIVE_CYCLES < 1)
            $error("P4A: WORDS deve estar entre 1 e 8191");
    end

    always @(posedge ui_clk) begin
        if (ui_rst) begin
            state <= WAIT_CAL;
            index <= 13'd0;
            elapsed <= 32'd0;
            words_compared <= 13'd0;
            test_done <= 1'b0;
            test_pass <= 1'b0;
            test_error <= 1'b0;
        end else begin
            if (state != WAIT_CAL && state != PASS && state != FAIL)
                elapsed <= elapsed + 1'b1;

            if (state != WAIT_CAL && state != PASS && state != FAIL &&
                elapsed >= MAX_ACTIVE_CYCLES) begin
                state <= FAIL;
                test_done <= 1'b1;
                test_error <= 1'b1;
            end else begin
                case (state)
                    WAIT_CAL: if (init_calib_complete) begin
                        index <= 13'd0;
                        elapsed <= 32'd0;
                        state <= WRITE;
                    end
                    WRITE: if (write_accept) begin
                        if (index == WORDS-1) begin
                            index <= 13'd0;
                            state <= READ;
                        end else
                            index <= index + 1'b1;
                    end
                    READ: if (read_accept)
                        state <= WAIT_RD;
                    WAIT_RD: if (app_rd_data_valid) begin
                        if (!app_rd_data_end || app_rd_data !== expected_word(index)) begin
                            state <= FAIL;
                            test_done <= 1'b1;
                            test_error <= 1'b1;
                        end else begin
                            words_compared <= words_compared + 1'b1;
                            if (index == WORDS-1) begin
                                state <= PASS;
                                test_done <= 1'b1;
                                test_pass <= 1'b1;
                            end else begin
                                index <= index + 1'b1;
                                state <= READ;
                            end
                        end
                    end
                    default: begin
                        // PASS e FAIL ficam latched ate reset.
                    end
                endcase
            end
        end
    end
endmodule
