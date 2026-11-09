// Filtra o vetor inteiro; 11 sempre seleciona SOLO e sinaliza erro.
module controle_modo_operacao #(
    parameter integer DEBOUNCE_CYCLES = 10_000_000
)(
    input logic clk, reset,
    input logic [1:0] switches,
    output logic [1:0] modo = 0,
    output logic modo_invalido = 0
);
    localparam integer W = DEBOUNCE_CYCLES > 1 ? $clog2(DEBOUNCE_CYCLES) : 1;
    (* ASYNC_REG = "TRUE" *) logic [1:0] meta = 0, sync = 0;
    logic [1:0] candidato = 0;
    logic [W-1:0] contador = 0;
    always_ff @(posedge clk) begin
        if (reset) begin
            meta <= 0; sync <= 0; candidato <= 0; contador <= 0;
            modo <= 0; modo_invalido <= 0;
        end else begin
            meta <= switches; sync <= meta;
            if (sync != candidato) begin
                candidato <= sync; contador <= 0;
            end else if (contador == W'(DEBOUNCE_CYCLES-1)) begin
                modo <= candidato == 3 ? 2'd0 : candidato;
                modo_invalido <= candidato == 3;
            end else contador <= contador + 1'b1;
        end
    end
endmodule
