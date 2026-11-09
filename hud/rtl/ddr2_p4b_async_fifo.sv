// P4B: FIFO de eventos entre clk_hud (100 MHz) e ui_clk do MIG.
// Ponteiros Gray, dois estagios ASYNC_REG; sem clock ou reset gerado por logica.
// Os dados sao lidos apenas enquanto a palavra permanece na posicao de leitura.
// DEPTH = 2**ADDR_BITS, com ADDR_BITS >= 2.
module ddr2_p4b_async_fifo #(
    parameter integer WIDTH = 130,
    parameter integer ADDR_BITS = 5
) (
    input  wire wr_clk,
    input  wire wr_rst,
    input  wire wr_en,
    input  wire [WIDTH-1:0] wr_data,
    output wire full,
    input  wire rd_clk,
    input  wire rd_rst,
    input  wire rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire empty
);
    localparam integer PTR_BITS = ADDR_BITS + 1;
    (* ram_style = "distributed" *) reg [WIDTH-1:0] mem [0:(1<<ADDR_BITS)-1];

    reg [PTR_BITS-1:0] wbin = 0, wgray = 0;
    reg [PTR_BITS-1:0] rbin = 0, rgray = 0;
    (* ASYNC_REG = "TRUE" *) reg [PTR_BITS-1:0] rgray_meta = 0, rgray_sync = 0;
    (* ASYNC_REG = "TRUE" *) reg [PTR_BITS-1:0] wgray_meta = 0, wgray_sync = 0;

    wire wpush = wr_en && !full;
    wire rpop = rd_en && !empty;
    wire [PTR_BITS-1:0] wbin_next = wbin + wpush;
    wire [PTR_BITS-1:0] rbin_next = rbin + rpop;
    wire [PTR_BITS-1:0] wgray_next = (wbin_next >> 1) ^ wbin_next;
    wire [PTR_BITS-1:0] rgray_next = (rbin_next >> 1) ^ rbin_next;

    // Full compara os dois bits mais altos invertidos do ponteiro de leitura.
    assign full = wgray == {~rgray_sync[PTR_BITS-1:PTR_BITS-2],
                                    rgray_sync[PTR_BITS-3:0]};
    assign empty = rgray == wgray_sync;
    assign rd_data = mem[rbin[ADDR_BITS-1:0]];

    always @(posedge wr_clk) begin
        if (wr_rst) begin
            wbin <= 0;
            wgray <= 0;
            rgray_meta <= 0;
            rgray_sync <= 0;
        end else begin
            rgray_meta <= rgray;
            rgray_sync <= rgray_meta;
            if (wpush) begin
                mem[wbin[ADDR_BITS-1:0]] <= wr_data;
                wbin <= wbin_next;
                wgray <= wgray_next;
            end
        end
    end

    always @(posedge rd_clk) begin
        if (rd_rst) begin
            rbin <= 0;
            rgray <= 0;
            wgray_meta <= 0;
            wgray_sync <= 0;
        end else begin
            wgray_meta <= wgray;
            wgray_sync <= wgray_meta;
            if (rpop) begin
                rbin <= rbin_next;
                rgray <= rgray_next;
            end
        end
    end

    initial if (ADDR_BITS < 2) $error("P4B FIFO: ADDR_BITS >= 2 exigido");
endmodule
