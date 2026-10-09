// Interface no domínio de pixel. Entradas devem estar estáveis e síncronas a clk.
module dados_hud #(parameter integer INICIAL_V=280, INICIAL_H=36000) (
    input logic clk,
    input logic atualizar_quadro,
    input logic dados_validos,
    input logic [31:0] metadados_in,
    output logic [31:0] metadados = 0,
    input logic [9:0] velocidade_kt_in,
    input logic [16:0] altitude_ft_in,
    input logic signed [10:0] pitch_px_in,
    input logic signed [9:0] roll_q8_in,
    input logic [8:0] heading_deg_in,
    input logic [9:0] mira_x_in,
    input logic [8:0] mira_y_in,
    input logic mira_lock_in,
    output logic [9:0] velocidade_kt = 10'(INICIAL_V),
    output logic [16:0] altitude_ft = 17'(INICIAL_H),
    output logic [9:0] horizonte_y = 10'd240,
    output logic signed [9:0] roll_q8 = 10'sd0,
    output logic [8:0] heading_deg = 9'd0,
    output logic [9:0] mira_x = 10'd320,
    output logic [8:0] mira_y = 9'd240,
    output logic mira_lock = 1'b0
);
    // Buffer da última amostra completa; evita perder pulsos entre quadros.
    logic [31:0] metadados_pendentes = 0;
    logic [9:0] velocidade_pendente = 10'(INICIAL_V);
    logic [16:0] altitude_pendente = 17'(INICIAL_H);
    logic [9:0] horizonte_pendente = 10'd240;
    logic signed [9:0] roll_pendente = 10'sd0;
    logic [8:0] heading_pendente = 9'd0;
    logic [9:0] mira_x_pendente = 10'd320;
    logic [8:0] mira_y_pendente = 9'd240;
    logic mira_lock_pendente = 1'b0;
    always_ff @(posedge clk) begin
        if (dados_validos) begin
            metadados_pendentes <= metadados_in;

            velocidade_pendente <= (velocidade_kt_in > 999) ? 10'd999 : velocidade_kt_in;
            altitude_pendente <= (altitude_ft_in > 99999) ? 17'd99999 : altitude_ft_in;
            // Pitch positivo move o horizonte para baixo (nariz para cima).
            if (pitch_px_in > 80) horizonte_pendente <= 10'd320;
            else if (pitch_px_in < -80) horizonte_pendente <= 10'd160;
            else horizonte_pendente <= 10'(11'sd240 + pitch_px_in);
            if (roll_q8_in > 128) roll_pendente <= 10'sd128;
            else if (roll_q8_in < -128) roll_pendente <= -10'sd128;
            else roll_pendente <= roll_q8_in;
            if (heading_deg_in > 9'd359)
    heading_pendente <= 9'd359;
else
    heading_pendente <= heading_deg_in;
            mira_x_pendente <= mira_x_in;
            mira_y_pendente <= mira_y_in;
            mira_lock_pendente <= mira_lock_in;
        end
        // Se amostra e quadro coincidirem, a amostra entra no próximo quadro.
        if (atualizar_quadro) begin
            metadados <= metadados_pendentes;
            heading_deg <= heading_pendente;
            mira_x <= mira_x_pendente;
            mira_y <= mira_y_pendente;
            mira_lock <= mira_lock_pendente;
            velocidade_kt <= velocidade_pendente;
            altitude_ft <= altitude_pendente;
            horizonte_y <= horizonte_pendente;
            roll_q8 <= roll_pendente;
        end
    end
endmodule
