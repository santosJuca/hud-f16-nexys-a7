`timescale 1ns/1ps
// Sonda opcional: todos os eventos devem pertencer ao mesmo clock HUD.
// Nao conectada ao top de producao; validacao DDR2 e publicacao VGA sao etapas distintas.
module video_publication_metrics #(
    parameter integer WIDTH = 32
)(
    input wire clk, rst,
    input wire ddr_commit, vga_published,
    output reg [WIDTH-1:0] validated_count, published_count,
    output reg [WIDTH-1:0] time_cycles, last_interval_cycles,
    output reg interval_valid
);
    reg [WIDTH-1:0] last_publication;
    reg have_publication;
    always @(posedge clk) begin
        if (rst) begin
            validated_count <= 0;
            published_count <= 0;
            time_cycles <= 0;
            last_interval_cycles <= 0;
            last_publication <= 0;
            interval_valid <= 0;
            have_publication <= 0;
        end else begin
            time_cycles <= time_cycles + 1'b1;
            if (ddr_commit) validated_count <= validated_count + 1'b1;
            if (vga_published) begin
                published_count <= published_count + 1'b1;
                if (have_publication) begin
                    last_interval_cycles <= time_cycles - last_publication;
                    interval_valid <= 1;
                end
                last_publication <= time_cycles;
                have_publication <= 1;
            end
        end
    end
endmodule
