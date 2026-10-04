// =========================================================
// controle_modo_manche.sv
//
// Botao ativo em nivel baixo.
// Cada pressionamento valido alterna:
//   0 = SENSOR
//   1 = MANCHE
//
// Inicia sempre em SENSOR.
// =========================================================

module controle_modo_manche #(
    parameter integer DEBOUNCE_CYCLES = 1_000_000
)(
    input  logic clk,
    input  logic botao_n,
    output logic modo_manche = 1'b0
);

    localparam integer COUNT_WIDTH =
        (DEBOUNCE_CYCLES > 1) ? $clog2(DEBOUNCE_CYCLES) : 1;

    (* ASYNC_REG = "TRUE" *) logic [1:0] btn_meta = 2'b11;

    logic btn_estavel = 1'b1;
    logic [COUNT_WIDTH-1:0] contador = '0;

    always_ff @(posedge clk) begin
        btn_meta[0] <= botao_n;
        btn_meta[1] <= btn_meta[0];

        if (btn_meta[1] == btn_estavel) begin
            contador <= '0;
        end
        else if (contador == COUNT_WIDTH'(DEBOUNCE_CYCLES - 1)) begin
            contador <= '0;
            btn_estavel <= btn_meta[1];

            // Alterna somente na borda de pressionamento.
            if (!btn_meta[1])
                modo_manche <= ~modo_manche;
        end
        else begin
            contador <= contador + 1'b1;
        end
    end

endmodule
