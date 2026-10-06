// Rumo magnetico estimado plano: atan2(Y, X), arredondado para 0..359.
// Offsets nos eixos originais; depois troca/inversao conforme a montagem.
module heading_magnetico #(
    parameter logic signed [15:0] OFFSET_X = 16'sd0,
    parameter logic signed [15:0] OFFSET_Y = 16'sd0,
    parameter bit TROCAR_XY = 1'b0,
    parameter bit INVERTER_X = 1'b0,
    parameter bit INVERTER_Y = 1'b0
)(
    input logic clk,
    input logic sensor_ok,
    input logic amostra_nova,
    input logic signed [15:0] mag_x, mag_y,
    output logic [8:0] heading_deg = 9'd0,
    output logic valido = 1'b0
);
    typedef enum logic [2:0] {IDLE, MAPA, PREPARA, ROTACIONA, NORMALIZA, PUBLICA} estado_t;
    estado_t estado = IDLE;
    logic signed [17:0] corrigido_x = 0, corrigido_y = 0;
    wire signed [17:0] eixo_x = TROCAR_XY ? corrigido_y : corrigido_x;
    wire signed [17:0] eixo_y = TROCAR_XY ? corrigido_x : corrigido_y;
    logic signed [31:0] x = 0, y = 0;
    logic signed [25:0] angulo = 0;
    logic [25:0] normalizado = 0;
    logic [3:0] iteracao = 0;

    // atan(2^-i) em graus Q16; 16 iteracoes, uma por ciclo.
    function automatic logic signed [25:0] atan_graus(input logic [3:0] i);
        case(i)
            0: atan_graus=26'sd2949120;
            1: atan_graus=26'sd1740967;
            2: atan_graus=26'sd919879;
            3: atan_graus=26'sd466945;
            4: atan_graus=26'sd234379;
            5: atan_graus=26'sd117304;
            6: atan_graus=26'sd58666;
            7: atan_graus=26'sd29335;
            8: atan_graus=26'sd14668;
            9: atan_graus=26'sd7334;
            10: atan_graus=26'sd3667;
            11: atan_graus=26'sd1833;
            12: atan_graus=26'sd917;
            13: atan_graus=26'sd458;
            14: atan_graus=26'sd229;
            default: atan_graus=26'sd115;
        endcase
    endfunction

    always_ff @(posedge clk) begin
        if (!sensor_ok) begin
            valido <= 1'b0;
            estado <= IDLE;
        end else begin
            case (estado)
                IDLE: if (amostra_nova) begin
                    // -4096 e o indicador de overflow do HMC5883L.
                    if (mag_x == -16'sd4096 || mag_y == -16'sd4096)
                        valido <= 1'b0;
                    else begin
                        corrigido_x <= {{2{mag_x[15]}},mag_x} - {{2{OFFSET_X[15]}},OFFSET_X};
                        corrigido_y <= {{2{mag_y[15]}},mag_y} - {{2{OFFSET_Y[15]}},OFFSET_Y};
                        estado <= MAPA;
                    end
                end
                MAPA: begin
                    // 12 bits fracionarios preservam precisao em vetores pequenos.
                    // 32 bits cobrem offsets extremos e o ganho do CORDIC.
                    x <= $signed(INVERTER_X ? -eixo_x : eixo_x) * 32'sd4096;
                    y <= $signed(INVERTER_Y ? -eixo_y : eixo_y) * 32'sd4096;
                    estado <= PREPARA;
                end
                PREPARA: begin
                    if (x == 0 && y == 0) begin
                        valido <= 1'b0;
                        estado <= IDLE;
                    end else begin
                        // Leva o vetor para o semiplano direito.
                        if (x < 0) begin
                            x <= -x;
                            y <= -y;
                            angulo <= 26'sd11796480; // 180 graus Q16
                        end else angulo <= 0;
                        iteracao <= 0;
                        estado <= ROTACIONA;
                    end
                end
                ROTACIONA: begin
                    if (y > 0) begin
                        x <= x + (y >>> iteracao);
                        y <= y - (x >>> iteracao);
                        angulo <= angulo + atan_graus(iteracao);
                    end else if (y < 0) begin
                        x <= x - (y >>> iteracao);
                        y <= y + (x >>> iteracao);
                        angulo <= angulo - atan_graus(iteracao);
                    end
                    if (iteracao == 15) estado <= NORMALIZA;
                    else iteracao <= iteracao + 1'b1;
                end
                NORMALIZA: begin
                    // Arredondamento separado da publicacao para limitar o caminho.
                    normalizado <= angulo < 0 ?
                        angulo + 26'sd23625728 : angulo + 26'sd32768;
                    estado <= PUBLICA;
                end
                PUBLICA: begin
                    heading_deg <= normalizado[25:16] >= 10'd360 ? 9'd0 : normalizado[24:16];
                    valido <= 1'b1;
                    estado <= IDLE;
                end
                default: begin estado <= IDLE; valido <= 1'b0; end
            endcase
        end
    end
endmodule
