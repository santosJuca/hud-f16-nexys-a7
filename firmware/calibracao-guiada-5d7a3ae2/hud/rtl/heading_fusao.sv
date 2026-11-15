// Rumo magnetico estimado, graus Q10. Correcao 1/32 por dt valido.
// Montagem do MPU: giro horario produz gyro Z negativo.
module heading_fusao #(
    parameter integer CAL_LOG2 = 6,
    parameter integer CORR_SHIFT = 5,
    parameter bit INVERTER_GYRO = 1'b1,
    parameter integer MAG_TIMEOUT = 50000000
)(
    input logic clk,
    input logic sensor_ok, amostra_nova,
    input logic signed [15:0] gyro_z,
    input logic dt_valid,
    input logic [31:0] dt_cycles,
    input logic mag_valido, mag_atualizado,
    input logic [8:0] heading_mag,
    output logic [8:0] heading_deg = 0,
    output wire valido,
    output logic atualizado = 0
);
    wire calibrado;
    wire signed [16:0] gyro_corr;
    gyro_bias_dt #(.CAL_LOG2(CAL_LOG2)) u_bias (
        .clk(clk), .sensor_ok(sensor_ok), .amostra_nova(amostra_nova),
        .gyro_x(gyro_z), .gyro_y(16'sd0), .calibrado(calibrado),
        .gyro_x_corr(gyro_corr), .gyro_y_corr(), .bias_x(), .bias_y(),
        .dt_cycles(), .dt_valid()
    );
    logic [31:0] idade_mag = MAG_TIMEOUT;
    always_ff @(posedge clk) begin
        if (!mag_valido) idade_mag <= MAG_TIMEOUT;
        else if (mag_atualizado) idade_mag <= 0;
        else if (idade_mag < MAG_TIMEOUT) idade_mag <= idade_mag + 1'b1;
    end
    wire pronto = sensor_ok && calibrado && mag_valido &&
                  heading_mag < 360 && idade_mag < MAG_TIMEOUT;
    wire signed [16:0] gyro_orientado = INVERTER_GYRO ? -gyro_corr : gyro_corr;
    logic signed [16:0] gyro_reg = 0;
    logic [31:0] dt_reg = 0;
    logic dt_reg_valid = 0;
    always_ff @(posedge clk) begin
        dt_reg_valid <= pronto && dt_valid && dt_cycles != 0 && dt_cycles <= 10000000;
        if (pronto && dt_valid) begin
            gyro_reg <= gyro_orientado;
            dt_reg <= dt_cycles;
        end
    end
    wire signed [31:0] integrado;
    wire integrado_novo;
    gyro_integrador u_integrador (
        .clk(clk), .sensor_ok(pronto),
        .dt_valid(dt_reg_valid),
        .dt_cycles(dt_reg), .gyro_corr(gyro_reg),
        .angulo_q10(integrado), .angulo_valid(integrado_novo)
    );
    localparam signed [31:0] VOLTA = 368640;
    logic iniciado = 0;
    logic signed [31:0] estado_q10 = 0, anterior = 0;
    logic signed [31:0] previsto = 0, referencia = 0;
    // Separa predicao, erro circular, ganho e wrap para fechar 100 MHz.
    typedef enum logic [2:0] {IDLE, PREVER, DIFERENCA, ERRO, CORRIGIR, SOMAR, PUBLICAR} fase_t;
    fase_t fase = IDLE;
    logic signed [31:0] delta_reg = 0, diferenca_reg = 0, erro_reg = 0;
    logic signed [31:0] correcao_reg = 0, soma_reg = 0;
    function automatic signed [31:0] wrap(input signed [31:0] a);
        if (a < 0) wrap = a + VOLTA;
        else if (a >= VOLTA) wrap = a - VOLTA;
        else wrap = a;
    endfunction
    wire signed [31:0] corrigido = wrap(soma_reg);
    assign valido = pronto && iniciado;
    always_ff @(posedge clk) begin
        atualizado <= 0;
        if (!pronto) begin
            iniciado <= 0;
            fase <= IDLE;
            anterior <= 0;
        end else begin
            case (fase)
                IDLE: if (integrado_novo) begin
                    anterior <= integrado;
                    if (!iniciado) begin
                        estado_q10 <= $signed({1'b0,heading_mag,10'b0});
                        heading_deg <= heading_mag;
                        iniciado <= 1;
                        atualizado <= 1;
                    end else begin
                        delta_reg <= integrado - anterior;
                        referencia <= $signed({1'b0,heading_mag,10'b0});
                        fase <= PREVER;
                    end
                end
                PREVER: begin previsto <= wrap(estado_q10 + delta_reg); fase <= DIFERENCA; end
                DIFERENCA: begin diferenca_reg <= referencia - previsto; fase <= ERRO; end
                ERRO: begin
                    erro_reg <= diferenca_reg > 184320 ? diferenca_reg - VOLTA :
                                diferenca_reg < -184320 ? diferenca_reg + VOLTA : diferenca_reg;
                    fase <= CORRIGIR;
                end
                CORRIGIR: begin
                    correcao_reg <= erro_reg < 0 ? -((-erro_reg) >>> CORR_SHIFT) : erro_reg >>> CORR_SHIFT;
                    fase <= SOMAR;
                end
                SOMAR: begin soma_reg <= previsto + correcao_reg; fase <= PUBLICAR; end
                PUBLICAR: begin
                    estado_q10 <= corrigido;
                    heading_deg <= corrigido[18:10];
                    atualizado <= 1;
                    fase <= IDLE;
                end
                default: fase <= IDLE;
            endcase
        end
    end
endmodule
