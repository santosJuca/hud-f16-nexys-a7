// Produto modulo 2^64 e divisao signed com truncamento em direcao a zero.
module bmp085_aritmetica_seq (
    input  logic clk,
    input  logic iniciar,
    input  logic dividir,
    input  logic signed [63:0] a,
    input  logic signed [63:0] b,
    output logic signed [63:0] resultado = 0,
    output logic ocupado = 0,
    output logic pronto = 0
);
    typedef enum logic [2:0] {IDLE, MULT, DIV_PREP, DIV_SUB, DIV_BIT, DIV_SIGN} estado_t;
    estado_t estado = IDLE;
    logic [63:0] operando_a, operando_b, acumulador, quociente;
    logic [63:0] resto;
    logic [64:0] diferenca;
    logic negativo;
    logic [5:0] contador;
    wire [63:0] soma = acumulador + (operando_b[0] ? operando_a : 64'd0);

    always_ff @(posedge clk) begin
        pronto <= 0;
        case (estado)
            IDLE: if (iniciar) begin
                ocupado <= 1;
                operando_a <= a;
                operando_b <= b;
                acumulador <= 0;
                contador <= 0;
                estado <= dividir ? DIV_PREP : MULT;
            end
            MULT: begin
                acumulador <= soma;
                operando_a <= operando_a << 1;
                operando_b <= operando_b >> 1;
                contador <= contador + 1'b1;
                if (contador == 63) begin
                    resultado <= soma;
                    ocupado <= 0;
                    pronto <= 1;
                    estado <= IDLE;
                end
            end
            DIV_PREP: begin
                quociente <= operando_a[63] ? -operando_a : operando_a;
                operando_b <= operando_b[63] ? -operando_b : operando_b;
                negativo <= operando_a[63] ^ operando_b[63];
                resto <= 0;
                estado <= DIV_SUB;
            end
            DIV_SUB: begin
                // Separar a subtracao da selecao evita duas cadeias de carry.
                diferenca <= {resto, quociente[63]} - {1'b0, operando_b};
                estado <= DIV_BIT;
            end
            DIV_BIT: begin
                resto <= diferenca[64] ? {resto[62:0], quociente[63]} : diferenca[63:0];
                quociente <= {quociente[62:0], !diferenca[64]};
                contador <= contador + 1'b1;
                estado <= (contador == 63) ? DIV_SIGN : DIV_SUB;
            end
            DIV_SIGN: begin
                resultado <= negativo ? -quociente : quociente;
                ocupado <= 0;
                pronto <= 1;
                estado <= IDLE;
            end
            default: estado <= IDLE;
        endcase
    end
endmodule
