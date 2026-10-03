// =========================================================
// atitude_fusao_complementar.sv
//
// Fusao complementar entre:
//
//   - atitude integrada pelo giroscopio, em graus Q10
//   - estimativa do acelerometro, originalmente em unidades HUD
//
// Dominio interno:
//
//   1 grau = 1024 unidades Q10
//
// Conversoes usadas pelo projeto:
//
//   Pitch:
//     10 graus = 40 px
//     1 px = 256 unidades Q10
//
//   Roll:
//     10 graus = 44 unidades HUD
//     1 unidade HUD ~= 233 unidades Q10
//
// Algoritmo:
//
//   previsao = atitude_anterior + delta_gyro
//
//   atitude = previsao
//            + (atitude_accel - previsao) / 2^CORR_SHIFT
//
// CORR_SHIFT=5:
//   gyro = aproximadamente 31/32
//   accel = aproximadamente 1/32
//
// O acelerometro corrige lentamente o drift do giroscopio,
// enquanto o gyro preserva a resposta rapida.
//
// Este modulo nao converte diretamente para pixels.
// A conversao final continua responsabilidade de
// atitude_gyro_hud.sv.
// =========================================================

module atitude_fusao_complementar #(
    parameter integer CORR_SHIFT = 5
)(
    input logic clk,

    input logic sensor_ok,
    input logic accel_calibrado,
    input logic gyro_calibrado,

    // Pulso gerado depois que a integracao do gyro
    // correspondente a uma nova amostra estiver pronta.
    input logic atualizar,

    // Estimativa atual do acelerometro em unidades HUD.
    input logic signed [10:0] accel_pitch_px,
    input logic signed [9:0]  accel_roll_q8,

    // Atitude absoluta integrada pelo giroscopio.
    // 1 grau = 1024 unidades.
    input logic signed [31:0] gyro_pitch_q10,
    input logic signed [31:0] gyro_roll_q10,

    output logic valido = 1'b0,

    output logic signed [31:0] pitch_q10 = 32'sd0,
    output logic signed [31:0] roll_q10  = 32'sd0
);

    logic iniciado = 1'b0;

    logic signed [31:0] pitch_estado_q10 = 32'sd0;
    logic signed [31:0] roll_estado_q10  = 32'sd0;

    logic signed [31:0] gyro_pitch_anterior_q10 = 32'sd0;
    logic signed [31:0] gyro_roll_anterior_q10  = 32'sd0;

    wire pronto =
        sensor_ok &&
        accel_calibrado &&
        gyro_calibrado;

    // -----------------------------------------------------
    // Conversao da estimativa do acelerometro para graus Q10
    // -----------------------------------------------------

    wire signed [31:0] accel_pitch_ext =
        {{21{accel_pitch_px[10]}}, accel_pitch_px};

    wire signed [31:0] accel_roll_ext =
        {{22{accel_roll_q8[9]}}, accel_roll_q8};

    // Aproximacao linear coerente com atitude_accel_fixa:
//
//   1 px de pitch ~= 458 Q10.
//
// 458 = 512 - 32 - 16 - 4 - 2.
    wire signed [31:0] accel_pitch_q10 =
    (accel_pitch_ext <<< 9) -
    (accel_pitch_ext <<< 5) -
    (accel_pitch_ext <<< 4) -
    (accel_pitch_ext <<< 2) -
    (accel_pitch_ext <<< 1);

    // 10 graus = aproximadamente 44 unidades de roll.
    //
    // 10240 / 44 = 232.727...
    //
    // Usa-se 233 para evitar divisao de hardware.
    wire signed [31:0] accel_roll_q10 =
    (accel_roll_ext <<< 8) -
    (accel_roll_ext <<< 4) -
    (accel_roll_ext <<< 3) -
    (accel_roll_ext <<< 1) -
     accel_roll_ext;

    // -----------------------------------------------------
    // Pipeline da fusao
    // -----------------------------------------------------
    //
    // Estagio 1:
    //   - calcula delta do gyro
    //   - calcula a predicao
    //   - registra a referencia do acelerometro da mesma amostra
    //
    // Estagio 2:
    //   - calcula o erro
    //   - aplica a correcao complementar
    //   - atualiza o estado final
    //
    // A latencia adicional e de um ciclo de clk, sem alterar
    // a equacao do filtro.

    logic pipeline_pendente = 1'b0;

    logic signed [31:0] pitch_predito_reg = 32'sd0;
    logic signed [31:0] roll_predito_reg  = 32'sd0;

    logic signed [31:0] accel_pitch_reg = 32'sd0;
    logic signed [31:0] accel_roll_reg  = 32'sd0;

    // -----------------------------------------------------
    // Estagio 1: incremento angular e predicao
    // -----------------------------------------------------

    wire signed [31:0] delta_pitch_q10 =
        gyro_pitch_q10 - gyro_pitch_anterior_q10;

    wire signed [31:0] delta_roll_q10 =
        gyro_roll_q10 - gyro_roll_anterior_q10;

    wire signed [31:0] pitch_predito_comb =
        pitch_estado_q10 + delta_pitch_q10;

    wire signed [31:0] roll_predito_comb =
        roll_estado_q10 + delta_roll_q10;

    // -----------------------------------------------------
    // Estagio 2: erro e correcao
    // -----------------------------------------------------

    wire signed [31:0] erro_pitch_q10 =
        accel_pitch_reg - pitch_predito_reg;

    wire signed [31:0] erro_roll_q10 =
        accel_roll_reg - roll_predito_reg;

    // Divisao assinada por potencia de dois com truncamento
    // simetrico em torno de zero.
    function automatic signed [31:0] corrige(
        input signed [31:0] valor
    );
        logic signed [31:0] magnitude;
        begin
            if (valor >= 0) begin
                corrige = valor >>> CORR_SHIFT;
            end
            else begin
                magnitude = -valor;
                corrige = -(magnitude >>> CORR_SHIFT);
            end
        end
    endfunction

    wire signed [31:0] correcao_pitch_q10 =
        corrige(erro_pitch_q10);

    wire signed [31:0] correcao_roll_q10 =
        corrige(erro_roll_q10);

    wire signed [31:0] pitch_proximo_q10 =
        pitch_predito_reg + correcao_pitch_q10;

    wire signed [31:0] roll_proximo_q10 =
        roll_predito_reg + correcao_roll_q10;

    // -----------------------------------------------------
    // Estado do filtro
    // -----------------------------------------------------

    always_ff @(posedge clk) begin
        if (!pronto) begin
            iniciado <= 1'b0;
            valido <= 1'b0;
            pipeline_pendente <= 1'b0;

            pitch_estado_q10 <= 32'sd0;
            roll_estado_q10 <= 32'sd0;

            gyro_pitch_anterior_q10 <= 32'sd0;
            gyro_roll_anterior_q10 <= 32'sd0;

            pitch_predito_reg <= 32'sd0;
            roll_predito_reg <= 32'sd0;

            accel_pitch_reg <= 32'sd0;
            accel_roll_reg <= 32'sd0;

            pitch_q10 <= 32'sd0;
            roll_q10 <= 32'sd0;
        end
        else begin
            // Segundo estagio:
            // conclui a amostra capturada no ciclo anterior.
            if (pipeline_pendente) begin
                pitch_estado_q10 <= pitch_proximo_q10;
                roll_estado_q10 <= roll_proximo_q10;

                pitch_q10 <= pitch_proximo_q10;
                roll_q10 <= roll_proximo_q10;

                pipeline_pendente <= 1'b0;
                valido <= 1'b1;
            end

            if (atualizar) begin
                if (!iniciado) begin
                    // Primeira referencia:
                    // parte diretamente da atitude do acelerometro.
                    pitch_estado_q10 <= accel_pitch_q10;
                    roll_estado_q10 <= accel_roll_q10;

                    pitch_q10 <= accel_pitch_q10;
                    roll_q10 <= accel_roll_q10;

                    gyro_pitch_anterior_q10 <= gyro_pitch_q10;
                    gyro_roll_anterior_q10 <= gyro_roll_q10;

                    pipeline_pendente <= 1'b0;
                    iniciado <= 1'b1;
                    valido <= 1'b1;
                end
                else if (!pipeline_pendente) begin
                    // Primeiro estagio:
                    // registra a predicao e a referencia da mesma amostra.
                    pitch_predito_reg <= pitch_predito_comb;
                    roll_predito_reg <= roll_predito_comb;

                    accel_pitch_reg <= accel_pitch_q10;
                    accel_roll_reg <= accel_roll_q10;

                    gyro_pitch_anterior_q10 <= gyro_pitch_q10;
                    gyro_roll_anterior_q10 <= gyro_roll_q10;

                    pipeline_pendente <= 1'b1;
                end
            end
        end
    end

endmodule
