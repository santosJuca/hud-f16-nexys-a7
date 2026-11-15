// Interface FWFT preservada. Ambos os resets pertencem a uma transacao comum;
// o reset da macro e sincrono ao clock de escrita e os busy bloqueiam acessos.
module ddr2_p4b_async_fifo #(
    parameter integer WIDTH = 130,
    parameter integer ADDR_BITS = 5
) (
    input wire wr_clk, wr_rst, wr_en,
    input wire [WIDTH-1:0] wr_data,
    output wire full,
    input wire rd_clk, rd_rst, rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire empty
);
    wire fifo_full, fifo_empty, wr_busy, rd_busy;
    assign full = fifo_full || wr_busy || wr_rst;
    assign empty = fifo_empty || rd_busy || rd_rst;
    xpm_fifo_async #(
        .FIFO_MEMORY_TYPE("distributed"), .FIFO_WRITE_DEPTH(1 << ADDR_BITS),
        .WRITE_DATA_WIDTH(WIDTH), .READ_DATA_WIDTH(WIDTH),
        .WR_DATA_COUNT_WIDTH(ADDR_BITS+1), .RD_DATA_COUNT_WIDTH(ADDR_BITS+1),
        .READ_MODE("fwft"), .FIFO_READ_LATENCY(0), .CDC_SYNC_STAGES(2),
        .RELATED_CLOCKS(0), .USE_ADV_FEATURES("0000"),
        .SIM_ASSERT_CHK(1), .EN_SIM_ASSERT_ERR("error")
    ) u_xpm (
        .wr_clk(wr_clk), .rst(wr_rst), .wr_en(wr_en && !full), .din(wr_data),
        .full(fifo_full), .wr_rst_busy(wr_busy),
        .rd_clk(rd_clk), .rd_en(rd_en && !empty), .dout(rd_data),
        .empty(fifo_empty), .rd_rst_busy(rd_busy),
        .sleep(1'b0), .injectsbiterr(1'b0), .injectdbiterr(1'b0)
    );
    initial if (ADDR_BITS < 4) $error("XPM FIFO exige pelo menos 16 entradas");
endmodule
