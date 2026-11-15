// Captura uma leitura completa e publica somente a pressao compensada concluida.
module bmp085_compensacao_seq (
    input logic clk, amostra_valid,
    input logic [15:0] ut_raw,
    input logic [18:0] up_raw,
    input logic signed [15:0] ac1, ac2, ac3, b1, b2, mc, md,
    input logic [15:0] ac4, ac5, ac6,
    output wire signed [31:0] x1, x2, b5, b6, b3,
    output wire signed [15:0] temperatura_decic,
    output wire [31:0] b4, b7,
    output logic [31:0] pressao_base_pa = 0, pressao_pa = 0,
    output wire temp_calculo_ok,
    output logic calculo_ok = 0, pronto = 0,
    output wire ocupado
);
    typedef struct packed {
        logic [15:0] ut;
        logic [18:0] up;
        logic signed [15:0] ac1, ac2, ac3, b1, b2, mc, md;
        logic [15:0] ac4, ac5, ac6;
    } amostra_t;
    amostra_t atual, pendente;
    logic valid_anterior = 0, tem_pendente = 0;
    logic iniciar_temp = 0, iniciar_press = 0;
    wire temp_pronto, press_pronto, press_ok;
    wire [31:0] press_base_resultado, press_resultado;
    typedef enum logic [1:0] {IDLE, TEMP, PRESS} estado_t;
    estado_t estado = IDLE;
    assign ocupado = (estado != IDLE) || tem_pendente;

    bmp085_compensacao_temp_seq u_temp (
        .clk(clk), .iniciar(iniciar_temp), .ut_raw(atual.ut),
        .ac5(atual.ac5), .ac6(atual.ac6), .mc(atual.mc), .md(atual.md),
        .x1(x1), .x2(x2), .b5(b5), .temperatura_decic(temperatura_decic),
        .calculo_ok(temp_calculo_ok), .pronto(temp_pronto), .ocupado()
    );
    bmp085_compensacao_pressao_seq u_press (
        .clk(clk), .iniciar(iniciar_press), .up_raw(atual.up), .b5(b5),
        .ac1(atual.ac1), .ac2(atual.ac2), .ac3(atual.ac3), .ac4(atual.ac4),
        .b1(atual.b1), .b2(atual.b2), .b6(b6), .b3(b3), .b4(b4), .b7(b7),
        .pressao_base_pa(press_base_resultado), .pressao_pa(press_resultado),
        .calculo_ok(press_ok), .pronto(press_pronto), .ocupado()
    );
    always_ff @(posedge clk) begin
        valid_anterior <= amostra_valid;
        iniciar_temp <= 0;
        iniciar_press <= 0;
        pronto <= 0;
        case (estado)
            IDLE: if (tem_pendente) begin
                atual <= pendente;
                tem_pendente <= 0;
                iniciar_temp <= 1;
                estado <= TEMP;
            end
            TEMP: if (temp_pronto) begin
                if (temp_calculo_ok) begin
                    iniciar_press <= 1;
                    estado <= PRESS;
                end else begin
                    calculo_ok <= 0;
                    pressao_base_pa <= 0;
                    pressao_pa <= 0;
                    pronto <= 1;
                    estado <= IDLE;
                end
            end
            PRESS: if (press_pronto) begin
                pressao_base_pa <= press_base_resultado;
                pressao_pa <= press_resultado;
                calculo_ok <= press_ok;
                pronto <= 1;
                estado <= IDLE;
            end
            default: estado <= IDLE;
        endcase
        // Enquanto ocupado, reter a leitura pendente mais recente, sem misturar campos.
        // Uma leitura nova simultanea ao consumo da pendente fica para a proxima transacao.
        if (amostra_valid && !valid_anterior) begin
            pendente <= {ut_raw, up_raw, ac1, ac2, ac3, b1, b2, mc, md, ac4, ac5, ac6};
            tem_pendente <= 1;
        end
    end
endmodule
