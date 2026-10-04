module bmp085_compensacao_pressao_seq (
    input logic clk, iniciar,
    input logic [18:0] up_raw,
    input logic signed [31:0] b5,
    input logic signed [15:0] ac1, ac2, ac3,
    input logic [15:0] ac4,
    input logic signed [15:0] b1, b2,
    output logic signed [31:0] b6 = 0, b3 = 0,
    output logic [31:0] b4 = 0, b7 = 0, pressao_base_pa = 0, pressao_pa = 0,
    output logic calculo_ok = 0, ocupado = 0, pronto = 0
);
    typedef enum logic [5:0] {
        IDLE,
        B6,
        QUADRADO,
        QUADRADO_RESULTADO,
        B3_X1,
        B3_X1_RESULTADO,
        B3_X2,
        B3_X2_RESULTADO,
        B3_SOMA,
        B3_AC1,
        B3_FINAL,
        B4_X1,
        B4_X1_RESULTADO,
        B4_X2,
        B4_X2_RESULTADO,
        B4_SOMA,
        B4_SHIFT,
        B4_OFFSET,
        B4_PROD,
        B4_PROD_RESULTADO,
        B7_SUB,
        B7_PROD,
        B7_PROD_RESULTADO,
        VALIDAR,
        DIVISAO,
        DIV_RESULTADO,
        CORR_QUADRADO,
        CORR_QUADRADO_RESULTADO,
        CORR_MULT,
        CORR_MULT_RESULTADO,
        CORR_LINEAR,
        CORR_LINEAR_RESULTADO,
        CORR_SOMA,
        CORR_OFFSET,
        FINAL,
        ESPERAR,
        PUBLICAR
    } estado_t;
    estado_t estado = IDLE, retorno;
    logic signed [63:0] up_reg, b5_reg, ac1_reg, ac2_reg, ac3_reg, ac4_reg, b1_reg, b2_reg;
    logic signed [63:0] b6_reg, b3_reg, b4_reg, b7_reg, quadrado;
    logic signed [63:0] x1_reg, x2_reg, x3_reg, base_reg, final_reg, corr1, corr2;
    logic signed [63:0] a = 0, b = 0, resultado;
    logic iniciar_op = 0, dividir = 0, op_pronto, dobrar_depois, valido;
    bmp085_aritmetica_seq u_op (
        .clk(clk), .iniciar(iniciar_op), .dividir(dividir), .a(a), .b(b),
        .resultado(resultado), .ocupado(), .pronto(op_pronto)
    );
    always_ff @(posedge clk) begin
        pronto <= 0;
        iniciar_op <= 0;
        case (estado)
            IDLE: if (iniciar) begin
                up_reg <= $signed({1'b0, up_raw});
                b5_reg <= b5;
                ac1_reg <= ac1;
                ac2_reg <= ac2;
                ac3_reg <= ac3;
                ac4_reg <= $signed({1'b0, ac4});
                b1_reg <= b1;
                b2_reg <= b2;
                ocupado <= 1;
                estado <= B6;
            end
            B6: begin
                b6_reg <= b5_reg - 64'sd4000;
                estado <= QUADRADO;
            end
            QUADRADO: begin
                a <= b6_reg;
                b <= b6_reg;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= QUADRADO_RESULTADO;
                estado <= ESPERAR;
            end
            QUADRADO_RESULTADO: begin
                quadrado <= resultado;
                estado <= B3_X1;
            end
            B3_X1: begin
                a <= b2_reg;
                b <= quadrado >>> 12;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B3_X1_RESULTADO;
                estado <= ESPERAR;
            end
            B3_X1_RESULTADO: begin
                x1_reg <= resultado >>> 11;
                estado <= B3_X2;
            end
            B3_X2: begin
                a <= ac2_reg;
                b <= b6_reg;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B3_X2_RESULTADO;
                estado <= ESPERAR;
            end
            B3_X2_RESULTADO: begin
                x2_reg <= resultado >>> 11;
                estado <= B3_SOMA;
            end
            B3_SOMA: begin
                x3_reg <= x1_reg + x2_reg;
                estado <= B3_AC1;
            end
            B3_AC1: begin
                x3_reg <= (ac1_reg <<< 2) + x3_reg;
                estado <= B3_FINAL;
            end
            B3_FINAL: begin
                b3_reg <= (x3_reg + 64'sd2) >>> 2;
                estado <= B4_X1;
            end
            B4_X1: begin
                a <= ac3_reg;
                b <= b6_reg;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B4_X1_RESULTADO;
                estado <= ESPERAR;
            end
            B4_X1_RESULTADO: begin
                x1_reg <= resultado >>> 13;
                estado <= B4_X2;
            end
            B4_X2: begin
                a <= b1_reg;
                b <= quadrado >>> 12;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B4_X2_RESULTADO;
                estado <= ESPERAR;
            end
            B4_X2_RESULTADO: begin
                x2_reg <= resultado >>> 16;
                estado <= B4_SOMA;
            end
            B4_SOMA: begin
                x3_reg <= x1_reg + x2_reg;
                estado <= B4_SHIFT;
            end
            B4_SHIFT: begin
                x3_reg <= (x3_reg + 64'sd2) >>> 2;
                estado <= B4_OFFSET;
            end
            B4_OFFSET: begin
                x3_reg <= x3_reg + 64'sd32768;
                estado <= B4_PROD;
            end
            B4_PROD: begin
                a <= ac4_reg;
                b <= x3_reg;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B4_PROD_RESULTADO;
                estado <= ESPERAR;
            end
            B4_PROD_RESULTADO: begin
                b4_reg <= resultado >>> 15;
                estado <= B7_SUB;
            end
            B7_SUB: begin
                x3_reg <= up_reg - b3_reg;
                estado <= B7_PROD;
            end
            B7_PROD: begin
                a <= x3_reg;
                b <= 64'sd50000;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= B7_PROD_RESULTADO;
                estado <= ESPERAR;
            end
            B7_PROD_RESULTADO: begin
                b7_reg <= resultado;
                estado <= VALIDAR;
            end
            VALIDAR: begin
                valido <= (b4_reg > 0) && (b7_reg >= 0);
                base_reg <= 0;
                final_reg <= 0;
                if ((b4_reg <= 0) || (b7_reg < 0)) estado <= PUBLICAR;
                else estado <= DIVISAO;
            end
            DIVISAO: begin
                dobrar_depois <= b7_reg >= 64'sh0000000080000000;
                a <= (b7_reg < 64'sh0000000080000000) ? (b7_reg <<< 1) : b7_reg;
                b <= b4_reg;
                dividir <= 1;
                iniciar_op <= 1;
                retorno <= DIV_RESULTADO;
                estado <= ESPERAR;
            end
            DIV_RESULTADO: begin
                base_reg <= dobrar_depois ? (resultado <<< 1) : resultado;
                estado <= CORR_QUADRADO;
            end
            CORR_QUADRADO: begin
                a <= base_reg >>> 8;
                b <= base_reg >>> 8;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= CORR_QUADRADO_RESULTADO;
                estado <= ESPERAR;
            end
            CORR_QUADRADO_RESULTADO: begin
                corr1 <= resultado;
                estado <= CORR_MULT;
            end
            CORR_MULT: begin
                a <= corr1;
                b <= 64'sd3038;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= CORR_MULT_RESULTADO;
                estado <= ESPERAR;
            end
            CORR_MULT_RESULTADO: begin
                corr1 <= resultado >>> 16;
                estado <= CORR_LINEAR;
            end
            CORR_LINEAR: begin
                a <= -64'sd7357;
                b <= base_reg;
                dividir <= 0;
                iniciar_op <= 1;
                retorno <= CORR_LINEAR_RESULTADO;
                estado <= ESPERAR;
            end
            CORR_LINEAR_RESULTADO: begin
                corr2 <= resultado >>> 16;
                estado <= CORR_SOMA;
            end
            CORR_SOMA: begin
                corr1 <= corr1 + corr2;
                estado <= CORR_OFFSET;
            end
            CORR_OFFSET: begin
                corr1 <= (corr1 + 64'sd3791) >>> 4;
                estado <= FINAL;
            end
            FINAL: begin
                final_reg <= base_reg + corr1;
                estado <= PUBLICAR;
            end
            ESPERAR: if (op_pronto) estado <= retorno;
            PUBLICAR: begin
                b6 <= b6_reg;
                b3 <= b3_reg;
                b4 <= b4_reg[31:0];
                b7 <= b7_reg[31:0];
                pressao_base_pa <= base_reg[31:0];
                pressao_pa <= final_reg[31:0];
                calculo_ok <= valido;
                ocupado <= 0;
                pronto <= 1;
                estado <= IDLE;
            end
            default: estado <= IDLE;
        endcase
    end
endmodule
