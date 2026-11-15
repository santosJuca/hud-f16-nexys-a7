// Todos os eventos ja pertencem a clk (origem/HUD). frame_published e o
// ACK sincronizado da troca de banco, nao o pulso rd_updated do clock pixel.
module ddr2_video_status (
    input wire clk, rst,
    input wire frame_started, readback_commit, readback_abort,
    input wire frame_published, transfer_error,
    output reg published_seen = 0,
    output reg error_seen = 0
);
    reg started = 0, commit_pending = 0;
    always @(posedge clk) begin
        if (rst) begin
            started <= 0;
            commit_pending <= 0;
            published_seen <= 0;
            error_seen <= 0;
        end else begin
            if (frame_started) started <= 1;
            if (readback_commit) commit_pending <= 1;
            if (frame_published) begin
                if (commit_pending) published_seen <= 1;
                commit_pending <= 0;
            end
            // O abort de inicializacao/calibracao nao e uma transferencia falha.
            // Um preload que aborta nao invalida o banco integro ja pendente.
            if (transfer_error || (started && readback_abort)) error_seen <= 1;
        end
    end
endmodule
