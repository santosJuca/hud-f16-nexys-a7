// =========================================================
// top_reticula.sv
// Top-level do display de avião.
// =========================================================

module top_reticula (
    input  logic        clk,
    input  logic [1:0]  btn_heading,  // BTNU=+10, BTND=-10
    input  logic [15:12] sw,        // pitch e roll
    input  logic        display_mode, // SW0: 0=NORMAL, 1=DECLUTTER
    input  logic        style_mode,   // SW1: 0=HUD atual, 1=HUD CACA

    // Entradas analogicas do joystick pelo JXADC.
    input  wire         vauxp3,
    input  wire         vauxn3,
    input  wire         vauxp10,
    input  wire         vauxn10,

    // Botao do KY-023. Ativo em nivel baixo.
    input  wire         joystick_sw_n,

    // LEDs temporarios para validacao do joystick.
    output wire [3:0]   JOY_LED,

    inout  wire         i2c_sda,
    inout  wire         i2c_scl,

    // BMP085 em barramento I2C independente:
    // JD1 = SDA, JD2 = SCL.
    inout  wire         baro_sda,
    inout  wire         baro_scl,

    // LED4 indica BMP085 identificado corretamente.
    output wire         BARO_LED,

    output wire [3:0]   VGA_R,
    output wire [3:0]   VGA_G,
    output wire [3:0]   VGA_B,

    output wire         VGA_HS,
    output wire         VGA_VS
);

    logic [9:0] pixel_x;
    logic [9:0] pixel_y;
    logic       video_on;

    // -----------------------------------------------------
    // Joystick analogico KY-023 via XADC
    // -----------------------------------------------------

    logic [11:0] joystick_x_raw;
    logic [11:0] joystick_y_raw;

    logic joystick_x_menos;
    logic joystick_x_mais;
    logic joystick_y_menos;
    logic joystick_y_mais;

    logic modo_manche;
    logic manche_calibrado;
    logic signed [10:0] manche_pitch;
    logic signed [9:0]  manche_roll;

    joystick_xadc u_joystick_xadc (
        .clk     (clk),
        .vauxp3  (vauxp3),
        .vauxn3  (vauxn3),
        .vauxp10 (vauxp10),
        .vauxn10 (vauxn10),
        .x_raw   (joystick_x_raw),
        .y_raw   (joystick_y_raw)
    );

    controle_joystick u_controle_joystick (
        .clk     (clk),
        // Orientacao observada na placa: frente aumenta X; direita aumenta Y.
        .x_raw   (joystick_y_raw),
        .y_raw   (joystick_x_raw),

        .sw_n    (joystick_sw_n),

        .x_menos (joystick_x_menos),
        .x_mais  (joystick_x_mais),
        .y_menos (joystick_y_menos),
        .y_mais  (joystick_y_mais),
        .botao   ()
    );

    // Alterna entre atitude real do sensor e manche manual.
    controle_modo_manche u_modo_manche (
        .clk         (clk),
        .botao_n     (joystick_sw_n),
        .modo_manche (modo_manche)
    );

    // Manche analogico proporcional.
    // Mantem a mesma orientacao fisica ja validada no KY-023.
    controle_manche u_manche (
        .clk       (clk),
        .x_raw     (joystick_y_raw),
        .y_raw     (joystick_x_raw),
        .calibrado (manche_calibrado),
        .pitch_cmd (manche_pitch),
        .roll_cmd  (manche_roll)
    );

    wire pixel_clk;
    wire declutter;
    wire estilo_caca;

    controle_modo u_modo (
        .clk(pixel_clk),
        .display_mode(display_mode),
        .atualizar(
            (pixel_x == 0) &&
            (pixel_y == 480)
        ),
        .declutter(declutter)
    );

    controle_modo u_estilo (
        .clk(pixel_clk),
        .display_mode(style_mode),
        .atualizar(
            (pixel_x == 0) &&
            (pixel_y == 480)
        ),
        .declutter(estilo_caca)
    );

    (* ASYNC_REG = "TRUE" *) logic [1:0] horizonte_meta = '0;
    (* ASYNC_REG = "TRUE" *) logic [1:0] horizonte_sync = '0;
    (* ASYNC_REG = "TRUE" *) logic [1:0] roll_meta = '0;
    (* ASYNC_REG = "TRUE" *) logic [1:0] roll_sync = '0;
    wire [9:0] horizonte_y;
    wire signed [9:0] roll_q8;
    wire [9:0] velocidade_kt;
    wire [16:0] altitude_ft;
    wire [8:0] heading_deg;
    logic signed [10:0] pitch_px_entrada;
    logic signed [9:0] roll_q8_entrada;
    logic sensor_ok;
    logic atitude_calibrada;
    logic signed [10:0] pitch_sensor;
    logic signed [9:0] roll_sensor;

    logic gyro_bias_calibrado;
    logic fusao_valida;
    logic signed [10:0] fusao_pitch_px;
    logic signed [9:0]  fusao_roll_q8;

    // No modo SENSOR, o MPU e a fonte principal sempre que estiver valido.
    // O joystick somente assume pitch/roll quando modo_manche=1.
    wire usar_mpu =
        !modo_manche &&
        sensor_ok &&
        atitude_calibrada &&
        gyro_bias_calibrado &&
        fusao_valida;

    always_ff @(posedge clk) begin
        horizonte_meta <= sw[13:12];
        horizonte_sync <= horizonte_meta;

        roll_meta <= sw[15:14];
        roll_sync <= roll_meta;
    end

    // Fonte de pitch:
    //   MANCHE -> KY-023 proporcional.
    //   SENSOR -> fusao MPU6050.
    //   Sensor indisponivel -> switches como fallback de bancada.
    always_comb begin
        if (modo_manche)
            pitch_px_entrada = manche_pitch;
        else if (usar_mpu)
            pitch_px_entrada = fusao_pitch_px;
        else begin
            case (horizonte_sync)
                2'b01: pitch_px_entrada = -11'sd40;
                2'b10: pitch_px_entrada =  11'sd40;
                default: pitch_px_entrada = 11'sd0;
            endcase
        end
    end

    // Fonte de roll:
    //   MANCHE -> KY-023 proporcional.
    //   SENSOR -> fusao MPU6050.
    //   Sensor indisponivel -> switches como fallback de bancada.
    always_comb begin
        if (modo_manche)
            roll_q8_entrada = manche_roll;
        else if (usar_mpu)
            roll_q8_entrada = fusao_roll_q8;
        else begin
            case (roll_sync)
                2'b01: roll_q8_entrada = -10'sd64;
                2'b10: roll_q8_entrada =  10'sd64;
                default: roll_q8_entrada = 10'sd0;
            endcase
        end
    end

    wire [56:0] amostra_pixel;
    wire amostra_valida;
    wire entrada_pronta;
    wire [8:0] heading_entrada;
wire [16:0] altitude_hud_entrada;

    controle_heading u_heading (
        .clk         (clk),
        .btn         (btn_heading),
        .heading_deg (heading_entrada)
    );
    // Ordem: velocidade(10), altitude(17), pitch(11), roll(10), heading(9)..
    entrada_hud u_entrada (
        .clk_origem(clk), .clk_destino(pixel_clk),
        .valido(1'b1),
        .dados({10'd280, altitude_hud_entrada, pitch_px_entrada, roll_q8_entrada, heading_entrada}),
        .pronto(entrada_pronta),
        .valido_destino(amostra_valida), .dados_destino(amostra_pixel)
    );
    dados_hud u_dados (
        .clk(pixel_clk),
        .atualizar_quadro((pixel_x == 0) && (pixel_y == 480)),
        .dados_validos(amostra_valida),
        .velocidade_kt_in(amostra_pixel[56:47]),
        .altitude_ft_in(amostra_pixel[46:30]),
        .pitch_px_in($signed(amostra_pixel[29:19])),
        .roll_q8_in($signed(amostra_pixel[18:9])),
        .heading_deg_in(amostra_pixel[8:0]),
        .velocidade_kt(velocidade_kt), .altitude_ft(altitude_ft),
        .horizonte_y(horizonte_y),
        .roll_q8(roll_q8),
        .heading_deg(heading_deg)
    );

    wire numeros;
    numeros_hud u_numeros (
        .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on),
        .velocidade_kt(velocidade_kt), .altitude_ft(altitude_ft),
        .numeros_on(numeros)
    );

    logic hsync;
    logic vsync;

    logic retic;
    logic retic_caca;
    logic retic_caca_clearance;
    logic retic_visivel;
    logic horizonte;
    logic altitude;
    logic velocidade;
    logic direcao;
    logic alvo;

    // -----------------------------------------------------
    // GY-521 / MPU-6050
    // -----------------------------------------------------

    logic [7:0] sensor_id;
    logic amostra_nova;

    logic signed [15:0] mpu_accel_x;
    logic signed [15:0] mpu_accel_y;
    logic signed [15:0] mpu_accel_z;
    logic signed [15:0] mpu_gyro_x;
    logic signed [15:0] mpu_gyro_y;
    logic signed [15:0] mpu_gyro_z;

    // Preparacao do giroscopio para a fusao complementar de atitude.
    // Estas saidas alimentam a fusao; nao dirigem o HUD diretamente.
    logic signed [15:0] gyro_bias_x;
    logic signed [15:0] gyro_bias_y;
    logic signed [16:0] gyro_x_corr;
    logic signed [16:0] gyro_y_corr;
    logic [31:0] gyro_dt_cycles;
    logic gyro_dt_valid;
    logic gyro_pitch_atualizado;
    logic gyro_roll_atualizado;

    // Observador de atitude pelo giroscopio.
    // Ainda nao controla o HUD.
    logic signed [31:0] gyro_pitch_q10;
    logic signed [31:0] gyro_roll_q10;

    logic signed [10:0] gyro_pitch_px;
    logic signed [9:0]  gyro_roll_q8;

    // Fusao complementar accel + gyro.
    // No modo MPU, a fusao alimenta efetivamente o HUD.
    wire fusao_atualizar =
        gyro_pitch_atualizado && gyro_roll_atualizado;

    logic signed [31:0] fusao_pitch_q10;
    logic signed [31:0] fusao_roll_q10;


    // Mapeamento fisico validado em hardware no GY-521.
    //
    // Acelerometro:
    // frente para baixo   -> accel_y negativo
    // tras para baixo     -> accel_y positivo
    // direita para baixo  -> accel_x negativo
    // esquerda para baixo -> accel_x positivo
    //
    // Giroscopio:
    // frente para baixo   -> gyro_x negativo
    // tras para baixo     -> gyro_x positivo
    // direita para baixo  -> gyro_y positivo
    // esquerda para baixo -> gyro_y negativo
    // horario             -> gyro_z negativo
    // anti-horario        -> gyro_z positivo
    //
    // LEDs retornam ao diagnostico normal do joystick.
    assign JOY_LED[0] = joystick_x_menos;
    assign JOY_LED[1] = joystick_x_mais;
    assign JOY_LED[2] = joystick_y_menos;
    assign JOY_LED[3] = joystick_y_mais;

    mpu6050_i2c u_sensor (
        .clk       (clk),
        .i2c_sda   (i2c_sda),
        .i2c_scl   (i2c_scl),
        .who_am_i  (sensor_id),
        .sensor_ok (sensor_ok),
        .amostra_nova(amostra_nova),
        .accel_x   (mpu_accel_x),
        .accel_y   (mpu_accel_y),
        .accel_z   (mpu_accel_z),
        .gyro_x    (mpu_gyro_x),
        .gyro_y    (mpu_gyro_y),
        .gyro_z    (mpu_gyro_z)
    );

    // -----------------------------------------------------
    // BMP085 / SEN-09694
    // Barramento independente do MPU-6050.
    // Nesta etapa valida apenas endereco 0x77 e CHIP_ID 0x55.
    // -----------------------------------------------------

    logic [7:0] baro_chip_id;
    logic       baro_sensor_ok;
    logic       baro_calibracao_ok;

    // Coeficientes de calibracao do BMP085.
    logic signed [15:0] baro_ac1;
    logic signed [15:0] baro_ac2;
    logic signed [15:0] baro_ac3;

    logic        [15:0] baro_ac4;
    logic        [15:0] baro_ac5;
    logic        [15:0] baro_ac6;

    logic signed [15:0] baro_b1;
    logic signed [15:0] baro_b2;
    logic signed [15:0] baro_mb;
    logic signed [15:0] baro_mc;
    logic signed [15:0] baro_md;

    // Medidas brutas.
    logic [15:0] baro_ut_raw;
    logic        baro_ut_valid;

    logic [18:0] baro_up_raw;
    logic        baro_up_valid;

    // Compensacao de temperatura.
    logic signed [31:0] baro_temp_x1;
    logic signed [31:0] baro_temp_x2;
    logic signed [31:0] baro_b5;

    logic signed [15:0] baro_temperatura_decic;
    logic               baro_temp_calculo_ok;

    // Compensacao de pressao.
    logic signed [31:0] baro_press_b6;
    logic signed [31:0] baro_press_b3;

    logic [31:0] baro_press_b4;
    logic [31:0] baro_press_b7;

    logic [31:0] baro_pressao_base_pa;
    logic [31:0] baro_pressao_pa;

    logic baro_press_calculo_ok;


    bmp085_i2c #(
        .ENABLE_CALIBRATION (1'b1),
        .ENABLE_TEMPERATURE (1'b1),
        .ENABLE_PRESSURE    (1'b1),
        .ENABLE_CONTINUOUS  (1'b1)
    ) u_baro (
        .clk          (clk),
        .i2c_sda      (baro_sda),
        .i2c_scl      (baro_scl),

        .chip_id      (baro_chip_id),
        .sensor_ok    (baro_sensor_ok),
        .calibracao_ok(baro_calibracao_ok),

        .ac1(baro_ac1),
        .ac2(baro_ac2),
        .ac3(baro_ac3),

        .ac4(baro_ac4),
        .ac5(baro_ac5),
        .ac6(baro_ac6),

        .b1(baro_b1),
        .b2(baro_b2),
        .mb(baro_mb),
        .mc(baro_mc),
        .md(baro_md),

        .ut_raw  (baro_ut_raw),
        .ut_valid(baro_ut_valid),

        .up_raw  (baro_up_raw),
        .up_valid(baro_up_valid)
    );


    bmp085_compensacao_seq u_baro_comp (
        .clk(clk),
        .amostra_valid(baro_sensor_ok && baro_calibracao_ok &&
                       baro_ut_valid && baro_up_valid),
        .ut_raw(baro_ut_raw), .up_raw(baro_up_raw),
        .ac1(baro_ac1), .ac2(baro_ac2), .ac3(baro_ac3),
        .ac4(baro_ac4), .ac5(baro_ac5), .ac6(baro_ac6),
        .b1(baro_b1), .b2(baro_b2), .mc(baro_mc), .md(baro_md),
        .x1(baro_temp_x1), .x2(baro_temp_x2), .b5(baro_b5),
        .temperatura_decic(baro_temperatura_decic),
        .b6(baro_press_b6), .b3(baro_press_b3),
        .b4(baro_press_b4), .b7(baro_press_b7),
        .pressao_base_pa(baro_pressao_base_pa), .pressao_pa(baro_pressao_pa),
        .temp_calculo_ok(baro_temp_calculo_ok), .calculo_ok(baro_press_calculo_ok),
        .pronto(), .ocupado()
    );

    // -----------------------------------------------------
    // BMP085 -> altitude barometrica / pressure altitude
    // -----------------------------------------------------
    //
    // A altitude e calculada usando P0 = 101325 Pa.
    // O registrador abaixo inicia em 36000 ft como fallback.
    //
    // Depois da primeira conversao valida, mantemos a ultima
    // altitude boa entre as novas aquisicoes do BMP085.
    // Isso evita retornar momentaneamente a 36000 ft enquanto
    // up_valid alterna durante o modo continuo.

    logic [16:0] baro_altitude_ft_calc;
    logic        baro_altitude_calc_ok;

    logic [16:0] baro_altitude_ft_hold = 17'd36000;

    bmp085_altitude u_baro_altitude (
        .clk           (clk),
        .pressao_pa    (baro_pressao_pa),
        .pressao_valid (baro_press_calculo_ok),
        .altitude_ft   (baro_altitude_ft_calc),
        .calculo_ok    (baro_altitude_calc_ok)
    );

    always_ff @(posedge clk) begin
        if (baro_altitude_calc_ok)
            baro_altitude_ft_hold <= baro_altitude_ft_calc;
    end

    assign altitude_hud_entrada = baro_altitude_ft_hold;

    assign BARO_LED =
        baro_sensor_ok &&
        baro_calibracao_ok &&
        baro_ut_valid &&
        baro_up_valid &&
        baro_temp_calculo_ok &&
        baro_press_calculo_ok &&
        (baro_pressao_pa >= 32'd30000) &&
        (baro_pressao_pa <= 32'd120000);


    gyro_bias_dt u_gyro_bias_dt (
        .clk         (clk),
        .sensor_ok   (sensor_ok),
        .amostra_nova(amostra_nova),

        .gyro_x      (mpu_gyro_x),
        .gyro_y      (mpu_gyro_y),

        .calibrado   (gyro_bias_calibrado),
        .bias_x      (gyro_bias_x),
        .bias_y      (gyro_bias_y),
        .gyro_x_corr (gyro_x_corr),
        .gyro_y_corr (gyro_y_corr),

        .dt_cycles   (gyro_dt_cycles),
        .dt_valid    (gyro_dt_valid)
    );

    // A fusao somente e atualizada quando os pipelines de
    // pitch e roll concluem a nova amostra angular.

    // -----------------------------------------------------
    // Observador de atitude pelo giroscopio
    //
    // Mapeamento fisico validado:
    //   gyro_x -> pitch
    //   gyro_y -> roll
    //
    // A saida ainda nao participa da selecao do HUD.
    // -----------------------------------------------------

    gyro_integrador u_gyro_pitch_integrador (
        .clk        (clk),
        .sensor_ok  (sensor_ok),
        .dt_valid   (gyro_dt_valid),
        .gyro_corr  (gyro_x_corr),
        .dt_cycles  (gyro_dt_cycles),
        .angulo_q10 (gyro_pitch_q10),
        .angulo_valid (gyro_pitch_atualizado)
    );

    gyro_integrador u_gyro_roll_integrador (
        .clk        (clk),
        .sensor_ok  (sensor_ok),
        .dt_valid   (gyro_dt_valid),
        .gyro_corr  (gyro_y_corr),
        .dt_cycles  (gyro_dt_cycles),
        .angulo_q10 (gyro_roll_q10),
        .angulo_valid (gyro_roll_atualizado)
    );

    atitude_gyro_hud u_atitude_gyro_hud (
        .pitch_q10 (gyro_pitch_q10),
        .roll_q10  (gyro_roll_q10),
        .pitch_px  (gyro_pitch_px),
        .roll_q8   (gyro_roll_q8)
    );

    atitude_accel_fixa u_atitude_accel (
        .clk         (clk),
        .sensor_ok   (sensor_ok),
        .amostra_nova(amostra_nova),
        .accel_x     (mpu_accel_x),
        .accel_y     (mpu_accel_y),
        .accel_z     (mpu_accel_z),
        .calibrado   (atitude_calibrada),
        .pitch_px    (pitch_sensor),
        .roll_q8     (roll_sensor)
    );

    // -----------------------------------------------------
    // Fusao complementar accel + gyro
    //
    // O resultado controla o HUD quando a fusao esta valida.
    // -----------------------------------------------------

    atitude_fusao_complementar #(
        .CORR_SHIFT(5)
    ) u_fusao_atitude (
        .clk             (clk),

        .sensor_ok       (sensor_ok),
        .accel_calibrado (atitude_calibrada),
        .gyro_calibrado  (gyro_bias_calibrado),

        .atualizar       (fusao_atualizar),

        .accel_pitch_px  (pitch_sensor),
        .accel_roll_q8   (roll_sensor),

        .gyro_pitch_q10  (gyro_pitch_q10),
        .gyro_roll_q10   (gyro_roll_q10),

        .valido          (fusao_valida),

        .pitch_q10       (fusao_pitch_q10),
        .roll_q10        (fusao_roll_q10)
    );

    atitude_gyro_hud u_atitude_fusao_hud (
        .pitch_q10 (fusao_pitch_q10),
        .roll_q10  (fusao_roll_q10),

        .pitch_px  (fusao_pitch_px),
        .roll_q8   (fusao_roll_q8)
    );

    // -----------------------------------------------------
    // VGA
    // -----------------------------------------------------

    vga_controller u_vga (
        .clk_100mhz (clk),
        .pixel_clk  (pixel_clk),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y),
        .video_on   (video_on)
    );

    // -----------------------------------------------------
    // Retícula
    // -----------------------------------------------------

    reticula_vga #(
        .ESPESSURA   (2),
        .TAMANHO     (40),
        .VAO_CENTRAL (6)
    ) u_retic (
        .pixel_x     (pixel_x),
        .pixel_y     (pixel_y),
        .video_on    (video_on),
        .reticula_on (retic)
    );

    reticula_caca_vga #(
        .ESPESSURA (2),
        .CLEARANCE (3)
    ) u_retic_caca (
        .pixel_x      (pixel_x),
        .pixel_y      (pixel_y),
        .video_on     (video_on),
        .reticula_on  (retic_caca),
        .clearance_on (retic_caca_clearance)
    );

    assign retic_visivel =
        estilo_caca ?
        retic_caca :
        retic;

    // -----------------------------------------------------
    // Simbologia
    // -----------------------------------------------------

    simbologia_vga u_simbologia (
        .horizonte_y  (horizonte_y),
        .roll_q8      (roll_q8),
        .heading_deg  (heading_deg),
        .pixel_x      (pixel_x),
        .pixel_y      (pixel_y),
        .video_on     (video_on),

        .horizonte_on (horizonte),
        .altitude_on  (altitude),
        .velocidade_on (velocidade),
        .direcao_on   (direcao),
        .alvo_on      (alvo)
    );

    logic caca_velocidade;
    logic caca_altitude;
    logic caca_heading;
    logic caca_sim;

    simbologia_caca_vga u_simbologia_caca (
        .pixel_x        (pixel_x),
        .pixel_y        (pixel_y),
        .video_on       (video_on),

        .velocidade_kt  (velocidade_kt),
        .altitude_ft    (altitude_ft),
        .heading_deg    (heading_deg),

        .velocidade_on  (caca_velocidade),
        .altitude_on    (caca_altitude),
        .heading_on     (caca_heading),
        .sim_on         (caca_sim)
    );

    assign VGA_HS = hsync;
    assign VGA_VS = vsync;

    // -----------------------------------------------------
    // Indicador do sensor
    //
    // Vermelho = sensor não reconhecido
    // Verde = WHO_AM_I == 0x2A
    // -----------------------------------------------------

    logic sensor_status;

    always_comb begin
        sensor_status =
            video_on &&
            (pixel_x >= 20) &&
            (pixel_x <= 35) &&
            (pixel_y >= 20) &&
            (pixel_y <= 35);
    end


    // -----------------------------------------------------
    // Compositor RGB
    // -----------------------------------------------------

    // No estilo CAÇA, a attitude grid recebe somente
    // um pequeno recorte ao redor do datum fixo.
    // O HUD original permanece pixel a pixel inalterado.
    wire horizonte_visivel =
        horizonte &&
        !(
            estilo_caca &&
            retic_caca_clearance
        );

    wire extras_originais =
        altitude ||
        velocidade ||
        direcao ||
        numeros;

    wire extras_caca =
        caca_velocidade ||
        caca_altitude ||
        caca_heading ||
        caca_sim;

    wire extras_estilo =
        estilo_caca ?
        extras_caca :
        extras_originais;

    assign VGA_R =
        retic_visivel                                ? 4'h0 :
        alvo                                         ? 4'hF :
        (
            sensor_status &&
            !declutter &&
            !sensor_ok
        )                                            ? 4'hF :
                                                       4'h0;

    assign VGA_G =
        retic_visivel ? 4'hF :
        (
            horizonte_visivel ||
            (
                !declutter &&
                extras_estilo
            )
        ) ? 4'hF :
        (
            sensor_status &&
            !declutter &&
            sensor_ok
        ) ? 4'hF :
            4'h0;

    assign VGA_B = 4'h0;

endmodule
