// SOMENTE SIMULACAO COM ICARUS/VERILATOR, NUNCA SINTESE.
// Modelo comportamental minimo do xpm_fifo_async (FWFT, latencia 0) usado por
// ddr2_p4b_async_fifo. Nao substitui o modelo oficial AMD: os testes com XPM real
// continuam sendo os scripts xsim (test_sd_ddr2_vga.sh, test_video_ddr2.sh).
// Ponteiros Gray com dois estagios de sincronizacao; reset sincrono ao wr_clk,
// propagado ao rd_clk e sinalizado por wr_rst_busy/rd_rst_busy.
`timescale 1ns/1ps
module xpm_fifo_async #(
    parameter FIFO_MEMORY_TYPE = "auto",
    parameter integer FIFO_WRITE_DEPTH = 16,
    parameter integer WRITE_DATA_WIDTH = 32,
    parameter integer READ_DATA_WIDTH = 32,
    parameter integer WR_DATA_COUNT_WIDTH = 1,
    parameter integer RD_DATA_COUNT_WIDTH = 1,
    parameter READ_MODE = "fwft",
    parameter integer FIFO_READ_LATENCY = 0,
    parameter integer CDC_SYNC_STAGES = 2,
    parameter integer RELATED_CLOCKS = 0,
    parameter USE_ADV_FEATURES = "0000",
    parameter integer SIM_ASSERT_CHK = 0,
    parameter EN_SIM_ASSERT_ERR = "warning"
) (
    input wire wr_clk, rst, wr_en,
    input wire [WRITE_DATA_WIDTH-1:0] din,
    output wire full,
    output reg wr_rst_busy = 1,
    input wire rd_clk, rd_en,
    output wire [READ_DATA_WIDTH-1:0] dout,
    output wire empty,
    output reg rd_rst_busy = 1,
    input wire sleep, injectsbiterr, injectdbiterr
);
    localparam integer AW = $clog2(FIFO_WRITE_DEPTH);
    reg [WRITE_DATA_WIDTH-1:0] mem [0:FIFO_WRITE_DEPTH-1];
    reg [AW:0] wbin = 0, rbin = 0, wgray = 0, rgray = 0;
    reg [AW:0] rgray_w1 = 0, rgray_w2 = 0, wgray_r1 = 0, wgray_r2 = 0;
    reg [3:0] wr_busy_cnt = 4'hf, rd_busy_cnt = 4'hf;
    reg rst_r1 = 1, rst_r2 = 1;
    function automatic [AW:0] g2b(input [AW:0] g);
        integer i; begin g2b[AW] = g[AW]; for (i = AW-1; i >= 0; i = i-1) g2b[i] = g2b[i+1] ^ g[i]; end
    endfunction
    wire [AW:0] rbin_w = g2b(rgray_w2);
    wire [AW:0] wbin_r = g2b(wgray_r2);
    assign full = wr_rst_busy || ((wbin - rbin_w) == FIFO_WRITE_DEPTH);
    assign empty = rd_rst_busy || (rbin == wbin_r);
    assign dout = mem[rbin[AW-1:0]];
    always @(posedge wr_clk) begin
        if (rst) begin
            wbin <= 0; wgray <= 0; rgray_w1 <= 0; rgray_w2 <= 0;
            wr_busy_cnt <= 4'hf; wr_rst_busy <= 1;
        end else begin
            rgray_w1 <= rgray; rgray_w2 <= rgray_w1;
            if (wr_busy_cnt != 0) wr_busy_cnt <= wr_busy_cnt - 1'b1;
            wr_rst_busy <= wr_busy_cnt != 0 || rst_r2;
            if (wr_en && !full) begin
                mem[wbin[AW-1:0]] <= din;
                wbin <= wbin + 1'b1;
                wgray <= (wbin + 1'b1) ^ ((wbin + 1'b1) >> 1);
            end
            if (wr_en && full && !wr_rst_busy && SIM_ASSERT_CHK) $error("xpm stub: escrita com full");
        end
    end
    always @(posedge rd_clk) begin
        rst_r1 <= rst; rst_r2 <= rst_r1;
        if (rst_r2) begin
            rbin <= 0; rgray <= 0; wgray_r1 <= 0; wgray_r2 <= 0;
            rd_busy_cnt <= 4'hf; rd_rst_busy <= 1;
        end else begin
            wgray_r1 <= wgray; wgray_r2 <= wgray_r1;
            if (rd_busy_cnt != 0) rd_busy_cnt <= rd_busy_cnt - 1'b1;
            rd_rst_busy <= rd_busy_cnt != 0;
            if (rd_en && !empty) begin
                rbin <= rbin + 1'b1;
                rgray <= (rbin + 1'b1) ^ ((rbin + 1'b1) >> 1);
            end
            if (rd_en && empty && !rd_rst_busy && SIM_ASSERT_CHK) $error("xpm stub: leitura com empty");
        end
    end
    initial if (READ_MODE != "fwft" || FIFO_READ_LATENCY != 0 || WRITE_DATA_WIDTH != READ_DATA_WIDTH)
        $fatal(1, "xpm stub suporta apenas FWFT, latencia 0 e larguras iguais");
endmodule
