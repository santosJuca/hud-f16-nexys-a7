// Tick de 20 Hz. Velocidade 275..285 kt; altitude 35950..36050 ft.
module simulador_voo (
    input logic clk, reset, enable, tick,
    output wire [9:0] velocidade_kt,
    output wire [16:0] altitude_ft
);
    logic signed [4:0] velocidade_delta = 0;
    logic signed [7:0] altitude_delta = 0;
    logic sobe_v = 1, sobe_h = 1;
    logic [3:0] tempo_v = 0;
    logic [1:0] tempo_h = 0;
    assign velocidade_kt = 10'(11'sd280 + velocidade_delta);
    assign altitude_ft = 17'(18'sd36000 + altitude_delta);
    always_ff @(posedge clk) begin
        if (reset || !enable) begin
            velocidade_delta <= 0; altitude_delta <= 0;
            sobe_v <= 1; sobe_h <= 1; tempo_v <= 0; tempo_h <= 0;
        end else if (tick) begin
            if (tempo_v == 9) begin
                tempo_v <= 0;
                if (sobe_v) begin
                    velocidade_delta <= velocidade_delta + 1'b1;
                    if (velocidade_delta == 4) sobe_v <= 0;
                end else begin
                    velocidade_delta <= velocidade_delta - 1'b1;
                    if (velocidade_delta == -4) sobe_v <= 1;
                end
            end else tempo_v <= tempo_v + 1'b1;
            if (tempo_h == 3) begin
                tempo_h <= 0;
                if (sobe_h) begin
                    altitude_delta <= altitude_delta + 1'b1;
                    if (altitude_delta == 49) sobe_h <= 0;
                end else begin
                    altitude_delta <= altitude_delta - 1'b1;
                    if (altitude_delta == -49) sobe_h <= 1;
                end
            end else tempo_h <= tempo_h + 1'b1;
        end
    end
endmodule
