module bmp085_compensacao_temp_seq (
    input logic clk, iniciar,
    input logic [15:0] ut_raw, ac5, ac6,
    input logic signed [15:0] mc, md,
    output logic signed [31:0] x1 = 0, x2 = 0, b5 = 0,
    output logic signed [15:0] temperatura_decic = 0,
    output logic calculo_ok = 0, ocupado = 0, pronto = 0
);
    typedef enum logic [3:0] {
        IDLE, PREPARAR, MULT_INICIO, MULT_ESPERA, DENOMINADOR,
        DIV_INICIO, DIV_ESPERA, SOMAR, PUBLICAR
    } estado_t;
    estado_t estado = IDLE;
    logic signed [63:0] ut_reg, ac5_reg, ac6_reg, mc_reg, md_reg;
    logic signed [63:0] x1_reg, x2_reg, b5_reg, denominador;
    logic signed [63:0] a = 0, b = 0, resultado;
    logic iniciar_op = 0, dividir = 0, op_pronto;
    bmp085_aritmetica_seq u_op (
        .clk(clk), .iniciar(iniciar_op), .dividir(dividir), .a(a), .b(b),
        .resultado(resultado), .ocupado(), .pronto(op_pronto)
    );
    always_ff @(posedge clk) begin
        pronto <= 0;
        iniciar_op <= 0;
        case (estado)
            IDLE: if (iniciar) begin
                ut_reg <= $signed({1'b0, ut_raw});
                ac5_reg <= $signed({1'b0, ac5});
                ac6_reg <= $signed({1'b0, ac6});
                mc_reg <= mc;
                md_reg <= md;
                ocupado <= 1;
                estado <= PREPARAR;
            end
            PREPARAR: begin
                a <= ut_reg - ac6_reg;
                b <= ac5_reg;
                dividir <= 0;
                estado <= MULT_INICIO;
            end
            MULT_INICIO: begin
                iniciar_op <= 1;
                estado <= MULT_ESPERA;
            end
            MULT_ESPERA: if (op_pronto) begin
                x1_reg <= resultado >>> 15;
                estado <= DENOMINADOR;
            end
            DENOMINADOR: begin
                denominador <= x1_reg + md_reg;
                a <= mc_reg <<< 11;
                estado <= DIV_INICIO;
            end
            DIV_INICIO: begin
                if (denominador == 0) begin
                    x1 <= x1_reg;
                    x2 <= 0;
                    b5 <= 0;
                    temperatura_decic <= 0;
                    calculo_ok <= 0;
                    ocupado <= 0;
                    pronto <= 1;
                    estado <= IDLE;
                end else begin
                    b <= denominador;
                    dividir <= 1;
                    iniciar_op <= 1;
                    estado <= DIV_ESPERA;
                end
            end
            DIV_ESPERA: if (op_pronto) begin
                x2_reg <= resultado;
                estado <= SOMAR;
            end
            SOMAR: begin
                b5_reg <= x1_reg + x2_reg;
                estado <= PUBLICAR;
            end
            PUBLICAR: begin
                x1 <= x1_reg;
                x2 <= x2_reg;
                b5 <= b5_reg;
                temperatura_decic <= (b5_reg + 64'sd8) >>> 4;
                calculo_ok <= 1;
                ocupado <= 0;
                pronto <= 1;
                estado <= IDLE;
            end
            default: estado <= IDLE;
        endcase
    end
endmodule
