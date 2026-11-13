// Altitude relativa a pista em ft Q8, velocidade em kt Q8. Tick de 20 Hz.
module simulador_pouso (
    input logic clk, reset, enable, tick,
    output logic [2:0] fase = 0,
    output wire [9:0] velocidade_kt,
    output wire [16:0] altitude_ft,
    output logic signed [13:0] vertical_fpm
);
    localparam logic [2:0] APPROACH=0, FINAL=1, FLARE=2, TOUCHDOWN=3, ROLLOUT=4;
    logic [24:0] altitude_q8 = 25'd384000;
    logic [17:0] velocidade_q8 = 18'd40960;
    logic [4:0] tempo_toque = 0;
    assign altitude_ft = altitude_q8[24:8];
    assign velocidade_kt = velocidade_q8[17:8];
    always_comb begin
        case(fase)
            APPROACH: vertical_fpm = -14'sd1200;
            FINAL: vertical_fpm = -14'sd600;
            FLARE: vertical_fpm = -14'sd300;
            default: vertical_fpm = 0;
        endcase
    end
    always_ff @(posedge clk) begin
        if(reset || !enable) begin
            fase <= APPROACH; altitude_q8 <= 384000;
            velocidade_q8 <= 40960; tempo_toque <= 0;
        end else if(tick) begin
            case(fase)
                APPROACH: begin
                    altitude_q8 <= altitude_q8 - 25'd256;
                    if(velocidade_q8 > 37124) velocidade_q8 <= velocidade_q8 - 18'd4;
                    else velocidade_q8 <= 37120;
                    if(altitude_q8 <= 128256) begin altitude_q8 <= 128000; fase <= FINAL; end
                end
                FINAL: begin
                    altitude_q8 <= altitude_q8 - 25'd128;
                    if(velocidade_q8 > 34563) velocidade_q8 <= velocidade_q8 - 18'd3;
                    else velocidade_q8 <= 34560;
                    if(altitude_q8 <= 10368) begin altitude_q8 <= 10240; fase <= FLARE; end
                end
                FLARE: begin
                    altitude_q8 <= altitude_q8 - 25'd64;
                    if(velocidade_q8 > 32016) velocidade_q8 <= velocidade_q8 - 18'd16;
                    else velocidade_q8 <= 32000;
                    if(altitude_q8 <= 64) begin altitude_q8 <= 0; fase <= TOUCHDOWN; end
                end
                TOUCHDOWN: begin
                    if(tempo_toque == 19) fase <= ROLLOUT;
                    else tempo_toque <= tempo_toque + 1'b1;
                end
                ROLLOUT: begin
                    if(velocidade_q8 > 64) velocidade_q8 <= velocidade_q8 - 18'd64;
                    else velocidade_q8 <= 0;
                end
                default: begin fase <= APPROACH; altitude_q8 <= 384000; velocidade_q8 <= 40960; end
            endcase
        end
    end
endmodule
