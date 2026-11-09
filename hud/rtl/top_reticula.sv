// =========================================================
// top_reticula.sv
// Top-level do display de avião.
// =========================================================

module top_reticula #(
    parameter bit FULL_ATTITUDE = 1'b1,
    parameter bit MPU_GIRO_ESQUERDA_90 = 1'b0,
    parameter bit FRENTE_INVERTIDA_180 = 1'b0,
    parameter integer CAPTURE_DEBOUNCE = 1_000_000, CAPTURE_LONG_PRESS = 100_000_000,
    parameter bit MODOS_OPERACIONAIS = 1'b1,
    parameter integer OPERACAO_DEBOUNCE = 10_000_000,
    parameter integer OPERACAO_TICK = 5_000_000,
    parameter integer OPERACAO_ACK = 1_000_000,
    parameter integer MIRA_TICK = 5_000_000,
    parameter integer MIRA_DEBOUNCE = 1_000_000,
    parameter integer VIDEO_SENSOR_STARTUP_CYCLES = 1_000_000_000,
    parameter logic signed [15:0] MAG_OFFSET_X = 16'sd0,
    parameter logic signed [15:0] MAG_OFFSET_Y = 16'sd0,
    // Sem compensacao de montagem por padrao; builds registram a orientacao usada.
    parameter bit MAG_TROCAR_XY = 1'b0,
    parameter bit MAG_INVERTER_X = 1'b0,
    parameter bit MAG_INVERTER_Y = 1'b0,
    parameter logic [12:0] MAG_GAIN_X_Q12 = 13'd4096,
    parameter logic [12:0] MAG_GAIN_Y_Q12 = 13'd4096,
    parameter integer MAG_ALINHAMENTO_GRAUS = 0,
    parameter bit ENABLE_SD_SUBSYSTEM = 1'b0,
    parameter bit ENABLE_SD_OVERLAY = 1'b0,
    parameter bit ENABLE_SD_VIDEO = 1'b0,
    // P4A: 0=teste DDR2 P3D de 16 beats; 1=quadro completo sintetico.
    parameter bit ENABLE_DDR2_FRAME_TEST = 1'b0,
    // P4B: espelho de stream real SD na DDR2. A VGA segue usando BRAM.
    parameter bit ENABLE_DDR2_SD_MIRROR = 1'b0,
    parameter bit ENABLE_DDR2_VIDEO = 1'b0,
    parameter logic [31:0] SD_VIDEO_LBA = 0,
    parameter integer SD_VIDEO_SECTORS = 0,
    parameter integer SD_VIDEO_WIDTH = 320, SD_VIDEO_HEIGHT = 240, SD_VIDEO_FPS = 10,
    parameter integer SD_REQUEST_DEBOUNCE = 1_000_000,
    parameter logic [31:0] SD_DIAGNOSTIC_LBA = 0,
    parameter SD_REFERENCE_FILE = "",
    parameter integer SD_POWERUP_CYCLES = 200_000,
    parameter integer SD_HALF_PERIOD_CYCLES = 125,
    parameter integer SD_INIT_HALF_PERIOD_CYCLES = SD_HALF_PERIOD_CYCLES,
    parameter integer SD_READ_HALF_PERIOD_CYCLES = SD_HALF_PERIOD_CYCLES
) (
    input  logic        clk,
    input wire [1:0] operacao_sw, // SW3:SW2
    input wire ack_btn, // BTNC; reconhecimento de alerta.
    input  logic [1:0]  btn_heading,  // BTNU=+10, BTND=-10
    input  logic [15:9]  sw,        // SW9-11 fontes; SW12-15 atitude manual
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

    // HMC5883L em barramento independente.
    // JD3 = SDA / JD9 = SCL.
    inout  wire         mag_sda,
    inout  wire         mag_scl,

    // LED4 indica o MPU-6050 habilitado e identificado.
    output wire         GYRO_LED,

    // LED5 indica o BMP085 calibrado e com leituras validas.
    output wire         BARO_LED,

    // LD6 acende quando o HMC5883L esta operacional.
    output wire         MAG_LED,

    // Saida logica para o transistor do buzzer em JD4.
    output wire         buzzer_out,

    output wire [3:0]   VGA_R,
    output wire [3:0]   VGA_G,
    output wire [3:0]   VGA_B,

    output wire         VGA_HS,
    output wire         VGA_VS,

    input wire VIDEO_TOGGLE_BUTTON, // BTNL, livre no mapeamento anterior.
    input  wire         SD_DAT0,
    input  wire         SD_CD,
    input  wire         SD_READ_SWITCH,
    output wire         SD_RESET,
    output wire         SD_SCK,
    output wire         SD_CMD,
    output wire         SD_DAT3,

    output wire         SD_READY_LED,
    output wire         SD_ERROR_LED,
    output wire         SD_BUSY_LED,
    output wire         SD_CRC_OK_LED,
    input wire [3:0]    SD_DIAG_PAGE, // SW4=ALIGN; SW5..7 continuam diagnosticos/captura
    output wire [6:0]   SD_SEG,
    output wire [7:0]   SD_AN,
    output wire         SD_DP,
    output wire         SD_DATA_OK_LED,
    // P3A experimental: DDR2 em paralelo ao HUD, sem alterar caminho VGA.
    input  wire         cpu_resetn,
    output wire [3:0]   DDR2_STATUS_LED,
    inout  wire [15:0]  ddr2_dq,
    inout  wire [1:0]   ddr2_dqs_n,
    inout  wire [1:0]   ddr2_dqs_p,
    output wire [12:0]  ddr2_addr,
    output wire [2:0]   ddr2_ba,
    output wire         ddr2_ras_n,
    output wire         ddr2_cas_n,
    output wire         ddr2_we_n,
    output wire [0:0]   ddr2_ck_p,
    output wire [0:0]   ddr2_ck_n,
    output wire [0:0]   ddr2_cke,
    output wire [0:0]   ddr2_cs_n,
    output wire [1:0]   ddr2_dm,
    output wire [0:0]   ddr2_odt
);

    // P3B: BUFG dedicado ao dominio de 100 MHz do HUD.
    // A entrada fisica E3 permanece conectada ao MIG
    // e ao MMCM de referencia da DDR2.
    wire clk_hud;
    BUFG u_hud_clock_bufg (
        .I(clk),
        .O(clk_hud)
    );

    wire reset_operacao;

    wire sd_buffer_ready, sd_buffer_pending, sd_buffer_error, sd_buffer_published;
    logic sd_read_busy_d=0, sd_block_valid_d=0;
    logic sd_asset_published=0;
    logic [31:0] sd_publications=0;
    always_ff @(posedge clk_hud) begin
        sd_read_busy_d <= sd_diag_busy;
        sd_block_valid_d <= sd_diag_block;
        if(reset_operacao) begin
            sd_read_busy_d<=0; sd_block_valid_d<=0;
            sd_asset_published<=0; sd_publications<=0;
        end else if(sd_buffer_published) begin
            sd_asset_published<=1;
            sd_publications<=sd_publications+1'b1;
        end
    end
    wire video_request, video_grant;
    wire [31:0] video_lba;
    logic video_owner=0, sd_dispatch=0, sd_busy_seen=0;
    wire diagnostic_grant = sd_request && (!ENABLE_SD_OVERLAY || sd_buffer_ready) && !sd_dispatch && !sd_read_busy;
    assign video_grant = video_request && !diagnostic_grant && !sd_dispatch && !sd_read_busy;
    always_ff @(posedge clk_hud) begin
        if(reset_operacao) begin video_owner<=0; sd_dispatch<=0; sd_busy_seen<=0; end
        else if(diagnostic_grant || video_grant) begin
            video_owner<=video_grant; sd_dispatch<=1; sd_busy_seen<=0;
        end else if(sd_dispatch && sd_read_busy) sd_busy_seen<=1;
        else if(sd_dispatch && sd_busy_seen && !sd_read_busy) begin
            sd_dispatch<=0; sd_busy_seen<=0;
        end
    end
    wire sd_diag_busy = sd_read_busy && !video_owner;
    wire sd_diag_valid = sd_data_valid && !video_owner;
    wire sd_diag_block = sd_block_valid && !video_owner;
    wire video_failed;
    wire [31:0] video_frames, video_errors, video_late, video_cycles;
    wire [3:0] video_state;
    wire sd_path_busy = sd_read_busy || (ENABLE_SD_OVERLAY && !sd_buffer_ready);
    wire sd_diagnostic_error;
    wire sd_crc_ok, sd_data_ok;
    wire [9:0] sd_diag_byte_count;
    wire [8:0] sd_first_mismatch;
    wire [7:0] sd_expected_byte, sd_received_byte;
    wire [31:0] sd_attempts, sd_timeout_count;
    wire [3:0] sd_current_state;
    wire [5:0] sd_current_command;
    wire [7:0] sd_r1_response, sd_data_token;
    wire [9:0] sd_bytes_received;
    wire [15:0] sd_crc_received, sd_crc_calculated;
    wire [31:0] sd_good_reads, sd_failed_reads;
    wire sd_request;
    wire sd_init_ready;
    wire sd_init_failed;
    wire [2:0] sd_init_error_code;
    wire sd_read_busy;
    wire sd_read_done;
    wire sd_read_error;
    wire [2:0] sd_read_error_code;
    wire sd_block_valid;
    wire sd_data_valid;
    wire [7:0] sd_data_byte;
    wire [8:0] sd_byte_index;

    generate if (ENABLE_SD_SUBSYSTEM) begin : g_sd
        sd_diagnostic #(.DEBOUNCE_CYCLES(SD_REQUEST_DEBOUNCE),
                        .REFERENCE_FILE(SD_REFERENCE_FILE)) u_diagnostico (
            .clk(clk_hud), .rst(reset_operacao), .read_switch(SD_READ_SWITCH),
            .ready(sd_init_ready), .busy(sd_path_busy || sd_dispatch), .failed(sd_init_failed),
            .data_valid(sd_diag_valid), .data_byte(sd_data_byte),
            .byte_index(sd_byte_index), .block_valid(sd_diag_block),
            .read_error(sd_read_error && !video_owner), .read_error_code(sd_read_error_code),
            .request(sd_request), .diagnostic_error(sd_diagnostic_error),
            .crc_ok(sd_crc_ok), .data_ok(sd_data_ok), .byte_count(sd_diag_byte_count),
            .first_mismatch(sd_first_mismatch), .expected_byte(sd_expected_byte),
            .received_byte(sd_received_byte), .attempts(sd_attempts),
            .timeout_count(sd_timeout_count), .good_reads(sd_good_reads),
            .failed_reads(sd_failed_reads)
        );
        sd_spi_controller #(
            .POWERUP_CYCLES(SD_POWERUP_CYCLES),
            .HALF_PERIOD_CYCLES(SD_HALF_PERIOD_CYCLES),
            .INIT_HALF_PERIOD_CYCLES(SD_INIT_HALF_PERIOD_CYCLES),
            .READ_HALF_PERIOD_CYCLES(SD_READ_HALF_PERIOD_CYCLES)
        ) u_sd_spi_controller (
            .clk(clk_hud),
            .rst(reset_operacao),
            .read_start(diagnostic_grant || video_grant),
            .read_lba(video_grant ? video_lba : SD_DIAGNOSTIC_LBA),
            .sd_miso(SD_DAT0),
            .sd_reset(SD_RESET),
            .sd_sck(SD_SCK),
            .sd_mosi(SD_CMD),
            .sd_cs_n(SD_DAT3),
            .init_ready(sd_init_ready),
            .init_failed(sd_init_failed),
            .init_error_code(sd_init_error_code),
            .read_busy(sd_read_busy),
            .read_done(sd_read_done),
            .read_error(sd_read_error),
            .read_error_code(sd_read_error_code),
            .block_valid(sd_block_valid),
            .data_valid(sd_data_valid),
            .data_byte(sd_data_byte),
            .byte_index(sd_byte_index), .current_state(sd_current_state),
            .current_command(sd_current_command), .r1_response(sd_r1_response),
            .data_token(sd_data_token), .bytes_received(sd_bytes_received),
            .crc_received(sd_crc_received), .crc_calculated(sd_crc_calculated)
        );
    end else begin : g_sd_disabled
        assign {sd_crc_ok, sd_data_ok, sd_diag_byte_count, sd_first_mismatch,
                sd_expected_byte, sd_received_byte, sd_attempts, sd_timeout_count,
                sd_good_reads, sd_failed_reads,
                sd_current_state, sd_current_command, sd_r1_response, sd_data_token,
                sd_bytes_received, sd_crc_received, sd_crc_calculated} = '0;
        assign sd_request = 1'b0;
        assign sd_diagnostic_error = 1'b0;
        assign SD_RESET = 1'b1;
        assign SD_SCK = 1'b0;
        assign SD_CMD = 1'b1;
        assign SD_DAT3 = 1'b1;
        assign sd_init_ready = 1'b0;
        assign sd_init_failed = 1'b0;
        assign sd_init_error_code = 3'd0;
        assign sd_read_busy = 1'b0;
        assign sd_read_done = 1'b0;
        assign sd_read_error = 1'b0;
        assign sd_read_error_code = 3'd0;
        assign sd_block_valid = 1'b0;
        assign sd_data_valid = 1'b0;
        assign sd_data_byte = 8'd0;
        assign sd_byte_index = 9'd0;
    end endgenerate

    assign SD_READY_LED = ENABLE_SD_SUBSYSTEM &&
                          sd_init_ready && !sd_init_failed;

    assign SD_ERROR_LED = ENABLE_SD_SUBSYSTEM &&
                          (sd_init_failed || sd_read_error || sd_diagnostic_error || sd_buffer_error || video_failed);

    assign SD_CRC_OK_LED = ENABLE_SD_SUBSYSTEM && sd_crc_ok;
    assign SD_DATA_OK_LED = ENABLE_SD_SUBSYSTEM && sd_data_ok;

    assign SD_BUSY_LED = ENABLE_SD_SUBSYSTEM &&
                         !reset_operacao &&
                         !sd_init_failed &&
                         (!sd_init_ready || sd_path_busy);

    wire [3:0] sd_display_page;
    reg [31:0] sd_display_value;
    always @* begin
        case (sd_display_page)
            0: sd_display_value = {8'h50, 2'd0, sd_current_command, sd_current_state,
                1'b0, sd_init_error_code, 1'b0, sd_read_error_code,
                sd_init_ready, sd_read_busy, sd_crc_ok, sd_data_ok};
            1: sd_display_value = {sd_r1_response, sd_data_token, 6'd0, sd_bytes_received};
            2: sd_display_value = {sd_crc_received, sd_crc_calculated};
            3: sd_display_value = {3'd0, sd_first_mismatch, sd_expected_byte,
                                  sd_received_byte, 3'd0, sd_diagnostic_error};
            4: sd_display_value = sd_attempts;
            5: sd_display_value = sd_good_reads;
            6: sd_display_value = sd_timeout_count;
            7: sd_display_value = sd_failed_reads;
            8: sd_display_value = SD_DIAGNOSTIC_LBA;
            9: sd_display_value = SD_REFERENCE_FILE != "" ? 32'd1 : 32'd0;
            10: sd_display_value = {28'd0, sd_buffer_error, sd_buffer_pending,
                                    sd_buffer_ready, sd_asset_published};
            11: sd_display_value = sd_publications;
            12: sd_display_value = video_frames;
            13: sd_display_value = video_errors;
            14: sd_display_value = video_cycles;
            15: sd_display_value = {video_late[23:0],video_state,3'd0,video_failed};
            default: sd_display_value = 32'h00000000;
        endcase
    end
    // Remove SW4 da selecao de diagnostico. SW5..SW7 selecionam paginas 0..7.
    wire [3:0] diagnostic_page={1'b0,SD_DIAG_PAGE[3:1]};
    sd_status_display #(.SHOW_OPERATION_MODE(MODOS_OPERACIONAIS)) u_sd_display (
        .clk(clk_hud), .rst(reset_operacao), .enabled(ENABLE_SD_SUBSYSTEM || MODOS_OPERACIONAIS),
        .diagnostic_switch(ENABLE_SD_SUBSYSTEM && SD_READ_SWITCH),
        .operation_status(metadados_operacao[2:0]),
        .page_switches(diagnostic_page), .page(sd_display_page), .value(sd_display_value),
        .segments(SD_SEG), .anodes(SD_AN), .dp(SD_DP)
    );

    logic [9:0] pixel_x;
    logic [9:0] pixel_y;
    logic       video_on;

    // -----------------------------------------------------
    // Joystick analogico KY-023 via XADC
    // -----------------------------------------------------

    logic [11:0] joystick_x_raw;
    logic [11:0] joystick_y_raw;
    wire [11:0] temperature_xadc_raw;
    wire temperature_xadc_valid;
    wire temperature_xadc_toggle;
    wire temperature_xadc_ack;
    // Corrige o sentido vertical da montagem atual, antes da calibracao.
    wire [11:0] joystick_vertical_raw = 12'd4095 - joystick_x_raw;

    logic joystick_x_menos;
    logic joystick_x_mais;
    logic joystick_y_menos;
    logic joystick_y_mais;

    logic [9:0] mira_x_origem;
    logic [8:0] mira_y_origem;
    wire mira_lock_origem;
    logic mira_caca_lock_origem;
    logic alvo_lock_origem;
    logic [9:0] alvo_x_origem;
    logic [8:0] alvo_y_origem;

    wire clk_xadc;
    wire [11:0] joystick_x_adc,joystick_y_adc;
    wire temperature_adc_valid;
    joystick_xadc u_joystick_xadc (
        .clk     (ENABLE_DDR2_VIDEO ? clk_xadc : clk_hud),
        .vauxp3  (vauxp3),
        .vauxn3  (vauxn3),
        .vauxp10 (vauxp10),
        .vauxn10 (vauxn10),
        .x_raw   (joystick_x_adc),
        .y_raw   (joystick_y_adc),
        .temperature_raw    (temperature_xadc_raw),
        .temperature_valid  (temperature_adc_valid),
        .temperature_toggle (temperature_xadc_toggle),
        .temperature_ack    (temperature_xadc_ack)
    );

    generate if (ENABLE_DDR2_VIDEO) begin : g_xadc_fast
        // Barramento retido ate ACK: preserva amostras coerentes no HUD 100 MHz.
        entrada_hud #(.WIDTH(24)) u_joystick_cdc (
            .clk_origem(clk_xadc),.clk_destino(clk_hud),.valido(1'b1),
            .dados({joystick_x_adc,joystick_y_adc}),
            .dados_destino({joystick_x_raw,joystick_y_raw}));
        (* ASYNC_REG = "TRUE" *) reg temperature_valid_meta=0,temperature_valid_sync=0;
        always @(posedge clk_hud) begin
            temperature_valid_meta <= temperature_adc_valid;
            temperature_valid_sync <= temperature_valid_meta;
        end
        assign temperature_xadc_valid=temperature_valid_sync;
    end else begin : g_xadc_original
        assign joystick_x_raw=joystick_x_adc;
        assign joystick_y_raw=joystick_y_adc;
        assign temperature_xadc_valid=temperature_adc_valid;
    end endgenerate

    controle_joystick u_controle_joystick (
        .clk     (clk_hud),
        // Eixos trocados e sentido vertical corrigido para a montagem atual.
        .x_raw   (joystick_y_raw),
        .y_raw   (joystick_vertical_raw),

        .sw_n    (joystick_sw_n),

        .x_menos (joystick_x_menos),
        .x_mais  (joystick_x_mais),
        .y_menos (joystick_y_menos),
        .y_mais  (joystick_y_mais),
        .botao   ()
    );

    wire pixel_clk;
    wire declutter;
    wire estilo_caca;
    (* ASYNC_REG = "TRUE" *) logic estilo_caca_meta = 1'b0;
    (* ASYNC_REG = "TRUE" *) logic estilo_caca_sync = 1'b0;
    always_ff @(posedge clk_hud) begin
        estilo_caca_meta <= estilo_caca;
        estilo_caca_sync <= estilo_caca_meta;
    end

    assign mira_lock_origem = estilo_caca_sync ? mira_caca_lock_origem : alvo_lock_origem;

    mira_joystick #(.TICK_CYCLES(MIRA_TICK),.DEBOUNCE_CYCLES(MIRA_DEBOUNCE),
        .FIXED_STEP(4)) u_mira (
        .clk(clk_hud),.x_raw(joystick_y_raw),.y_raw(joystick_vertical_raw),.sw_n(joystick_sw_n),
        .enable(estilo_caca_sync),.reset(reset_operacao),
        .x(mira_x_origem),.y(mira_y_origem),.locked(mira_caca_lock_origem)
    );

    mira_joystick #(
        .TICK_CYCLES(MIRA_TICK), .DEBOUNCE_CYCLES(MIRA_DEBOUNCE),
        .X_MIN(24), .X_MAX(615), .Y_MIN(24), .Y_MAX(455),
        .INITIAL_X(430), .INITIAL_Y(180), .FIXED_STEP(4)
    ) u_marcador_joystick (
        .clk(clk_hud), .x_raw(joystick_y_raw), .y_raw(joystick_vertical_raw), .sw_n(joystick_sw_n),
        .enable(!estilo_caca_sync), .reset(reset_operacao),
        .x(alvo_x_origem), .y(alvo_y_origem), .locked(alvo_lock_origem)
    );

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
    (* ASYNC_REG = "TRUE" *) logic [2:0] fonte_desabilitada_meta = '0;
    (* ASYNC_REG = "TRUE" *) logic [2:0] fonte_desabilitada_sync = '0;
    wire [9:0] horizonte_y;
    wire signed [9:0] roll_q8;
    wire [9:0] velocidade_kt;
    wire [16:0] altitude_ft;
    wire [8:0] heading_deg;
    wire [9:0] mira_x;
    wire [8:0] mira_y;
    wire [9:0] alvo_x;
    wire [8:0] alvo_y;
    wire mira_lock;
    logic signed [10:0] pitch_px_entrada;
    logic signed [9:0] roll_q8_entrada;
    logic sensor_ok;
    logic atitude_calibrada;
    logic signed [10:0] pitch_sensor;
    logic signed [9:0] roll_sensor;

    logic gyro_bias_calibrado;
    wire fusao_valida;
    wire legacy_fusao_valida;
    logic signed [10:0] fusao_pitch_px;
    logic signed [9:0]  fusao_roll_q8;

    // Velocidade inercial estimada pelo MPU6050.
    logic [9:0] velocidade_inercial_kt;
    logic       velocidade_inercial_calibrada;
    logic       velocidade_inercial_valida;

    wire atitude_mpu_habilitada = !fonte_desabilitada_sync[0];
    wire barometro_habilitado = !fonte_desabilitada_sync[1];
    wire magnetometro_habilitado = !fonte_desabilitada_sync[2];
    wire modo_atitude_manual = !atitude_mpu_habilitada ||
        ({roll_sync, horizonte_sync} != 4'b1111);
    wire signed [31:0] pitch_manual_q10 = horizonte_sync == 2'b01 ? -32'sd15360 :
        horizonte_sync == 2'b10 ? 32'sd15360 : 32'sd0;
    wire signed [31:0] roll_manual_q10 = roll_sync == 2'b01 ? -32'sd26096 :
        roll_sync == 2'b10 ? 32'sd26096 : 32'sd0;

    // SW15..12=1111 seleciona o MPU; os demais estados comandam pitch/roll.
    wire usar_mpu = !modo_atitude_manual && sensor_ok && fusao_valida &&
        (FULL_ATTITUDE ? vector_calibrated : (atitude_calibrada && gyro_bias_calibrado));

    always_ff @(posedge clk_hud) begin
        horizonte_meta <= sw[13:12];
        horizonte_sync <= horizonte_meta;

        roll_meta <= sw[15:14];
        roll_sync <= roll_meta;
        fonte_desabilitada_meta <= sw[11:9];
        fonte_desabilitada_sync <= fonte_desabilitada_meta;
    end

    // O joystick controla somente a mira; atitude usa o MPU ou switches de bancada.
    always_comb begin
        if (usar_mpu)
            pitch_px_entrada = fusao_pitch_px;
        else begin
            case (horizonte_sync)
                2'b01: pitch_px_entrada = -11'sd60;
                2'b10: pitch_px_entrada =  11'sd60;
                default: pitch_px_entrada = 11'sd0;
            endcase
        end
    end

    always_comb begin
        if (usar_mpu)
            roll_q8_entrada = fusao_roll_q8;
        else begin
            case (roll_sync)
                2'b01: roll_q8_entrada = -10'sd112;
                2'b10: roll_q8_entrada =  10'sd112;
                default: roll_q8_entrada = 10'sd0;
            endcase
        end
    end

    wire capture_mode,video_mode,step_toggle,zero_request,cal_grid;
    // SW4 has one meaning: visual alignment. BTNU/BTND are mutually routed.
    wire align_mode;
    wire [1:0] heading_command_buttons,align_command_buttons;
    wire capture_grid_pulse;
    logic capture_grid_enabled=1'b0;
    // The capture mode owns the grid chord, not SW4 or the video mode FSM.
    always_ff @(posedge clk_hud) begin
        if(reset_operacao || !capture_mode) capture_grid_enabled<=1'b0;
        else if(capture_grid_pulse) capture_grid_enabled<=~capture_grid_enabled;
    end
    hud_command_dispatch u_hud_commands(
        .clk(clk_hud),.reset(reset_operacao),
        .align_switch(SD_DIAG_PAGE[0]),.capture_active(capture_mode),
        .buttons(btn_heading),.align_mode(align_mode),
        .heading_buttons(heading_command_buttons),
        .align_buttons(align_command_buttons),
        .capture_grid_pulse(capture_grid_pulse)
    );
    wire [1:0] capture_view;
    captura_controle #(.DEBOUNCE(CAPTURE_DEBOUNCE),.LONG_PRESS(CAPTURE_LONG_PRESS)) u_capture_control(
        // SW5/SW6: four capture views; SW7: MPU zero request.
        // CAPTURE grid is switched by BTNU+BTND, never by SW4.
        .clk(clk_hud),.reset(reset_operacao),.button(VIDEO_TOGGLE_BUTTON),
        .page({SD_DIAG_PAGE[3],capture_grid_enabled,SD_DIAG_PAGE[2:1]}),
        .video_mode(video_mode),.capture(capture_mode),.step_toggle(step_toggle),
        .zero_request(zero_request),.view(capture_view),.grid(cal_grid));
    wire vector_calibrated,vector_valid,vector_updated,vector_stationary,zero_set,zero_rejected;
    wire [25:0] vector_calibration_debug;
    wire signed [31:0] vector_raw_roll,vector_raw_pitch,vector_roll,vector_pitch;
    // Zeragem automatica, uma vez por inicializacao.
    wire auto_zero_request, auto_zero_done;

    hud_auto_zero #(.SETTLE_UPDATES(8)) u_auto_zero (
        .clk(clk_hud),
        .reset(reset_operacao),
        .enabled(FULL_ATTITUDE && sensor_ok && !modo_atitude_manual),
        .calibrated(vector_calibrated),
        .valid(vector_valid),
        .stationary(vector_stationary),
        .updated(vector_updated),
        .already_zeroed(zero_set),
        .raw_roll(vector_raw_roll),
        .raw_pitch(vector_raw_pitch),
        .zero_pulse(auto_zero_request),
        .done(auto_zero_done)
    );

    atitude_vetorial #(
        .ALLOW_TILTED_STARTUP(1'b1),
        .SENSOR_FAULT_GRACE_CYCLES(50_000_000),
        .STALE_RESET_CYCLES(100_000_000)
    ) u_vector(.clk(clk_hud),
        .reset(reset_operacao || !atitude_mpu_habilitada),
        .sensor_ok(sensor_ok && atitude_mpu_habilitada),.sample(amostra_nova),.zero_request(zero_request | auto_zero_request),
        .ax(mpu_accel_x),.ay(mpu_accel_y),.az(mpu_accel_z),
        .gx(mpu_gyro_x),.gy(mpu_gyro_y),.gz(mpu_gyro_z),
        .calibrated(vector_calibrated),.valid(vector_valid),.updated(vector_updated),
        .stationary(vector_stationary),.zero_set(zero_set),.zero_rejected(zero_rejected),
        .raw_roll(vector_raw_roll),.raw_pitch(vector_raw_pitch),.roll(vector_roll),.pitch(vector_pitch),
        .calibration_debug(vector_calibration_debug));
    localparam integer VIDEO_STARTUP_W = VIDEO_SENSOR_STARTUP_CYCLES > 1 ?
        $clog2(VIDEO_SENSOR_STARTUP_CYCLES) : 1;
    logic [VIDEO_STARTUP_W-1:0] video_startup_count = 0;
    logic video_startup_ready = 0;
    initial if (VIDEO_SENSOR_STARTUP_CYCLES < 1)
        $fatal(1,"Prazo de partida do video deve ser positivo");
    // A pausa do video permitiu calibrar o MPU real; inicia leituras apos esse repouso.
    // O prazo de 10 s libera o video mesmo com sensor ausente, preservando ATT BAD.
    always_ff @(posedge clk_hud) begin
        if (reset_operacao) begin
            video_startup_count <= 0;
            video_startup_ready <= 0;
        end else if (!video_startup_ready) begin
            if (!FULL_ATTITUDE || !MODOS_OPERACIONAIS || modo_atitude_manual ||
                (sensor_ok && vector_calibrated && vector_valid) ||
                video_startup_count == VIDEO_STARTUP_W'(VIDEO_SENSOR_STARTUP_CYCLES-1))
                video_startup_ready <= 1;
            else video_startup_count <= video_startup_count + 1'b1;
        end
    end
    wire signed [31:0] render_roll_source=modo_atitude_manual ? roll_manual_q10 :
        vector_valid ? vector_roll : 32'sd0;
    wire signed [31:0] render_pitch_source=modo_atitude_manual ? pitch_manual_q10 :
        vector_valid ? vector_pitch : 32'sd0;
    wire trig_done,trig_busy;
    wire signed [31:0] trig_x,trig_y;
    logic signed [31:0] trig_roll_pending=0,trig_pitch_pending=0;
    logic signed [31:0] render_roll_ready=0;
    logic signed [10:0] render_pitch_ready=0;
    logic signed [15:0] render_sine_ready=0,render_cosine_ready=16384;
    logic trig_start=0,trig_wait=0;
    // Os operandos e resultados pertencem a mesma amostra; CORDIC leva 18 ciclos.
    always_ff @(posedge clk_hud) begin
        trig_start<=0;
        if(reset_operacao) begin trig_wait<=0; render_roll_ready<=0; render_pitch_ready<=0; end
        else if(!trig_wait) begin
            trig_roll_pending<=render_roll_source; trig_pitch_pending<=render_pitch_source;
            trig_start<=1; trig_wait<=1;
        end else if(trig_done) begin
            render_sine_ready<=16'(trig_y>>>6); render_cosine_ready<=16'(trig_x>>>6);
            render_roll_ready<=trig_roll_pending;
            render_pitch_ready<=trig_pitch_pending>40960 ? 11'sd160 :
                trig_pitch_pending < -40960 ? -11'sd160 : 11'(trig_pitch_pending>>>8);
            trig_wait<=0;
        end
    end
    atitude_cordic #(.VECTORING(0)) u_render_trig(.clk(clk_hud),.reset(reset_operacao),.start(trig_start),
        .x_in(32'sd0),.y_in(32'sd0),.angle_in(trig_roll_pending<<<6),.busy(trig_busy),
        .done(trig_done),.x_out(trig_x),.y_out(trig_y),.angle_out());
    wire [238:0] attitude_packet={capture_mode,cal_grid,capture_view,
        vector_calibration_debug,sensor_ok,vector_valid,zero_rejected,zero_set,vector_stationary,vector_calibrated,
        vector_raw_roll,vector_raw_pitch,vector_roll,vector_pitch,render_roll_ready,
        render_pitch_ready,render_sine_ready,render_cosine_ready};
    wire [238:0] attitude_received;
    wire attitude_received_valid;
    entrada_hud #(.WIDTH(239)) u_attitude_cdc(.clk_origem(clk_hud),.clk_destino(pixel_clk),
        .valido(1'b1),.dados(attitude_packet),.pronto(),
        .valido_destino(attitude_received_valid),.dados_destino(attitude_received));
    logic [238:0] attitude_pending=239'd16384,attitude_display=239'd16384;
    always_ff @(posedge pixel_clk) begin
        if(attitude_received_valid) attitude_pending<=attitude_received;
        if(pixel_x==0 && pixel_y==480) attitude_display<=attitude_pending;
    end
    wire signed [15:0] attitude_cosine=attitude_display[15:0],attitude_sine=attitude_display[31:16];
    wire signed [10:0] attitude_pitch_px=attitude_display[42:32];
    wire signed [31:0] attitude_render_roll=attitude_display[74:43];
    wire signed [31:0] attitude_pitch=attitude_display[106:75],attitude_roll=attitude_display[138:107];
    wire signed [31:0] attitude_raw_pitch=attitude_display[170:139],attitude_raw_roll=attitude_display[202:171];
    wire [31:0] attitude_status=attitude_display[234:203];
    wire [1:0] pixel_view=attitude_display[236:235];
    wire pixel_grid=attitude_display[237],pixel_capture=attitude_display[238];
    wire calibration_on;
    wire [31:0] display_frame_id;
    wire [31:0] mag_diagnostics;
    wire [159:0] video_diag_received;
    wire video_diag_valid;
    entrada_hud #(.WIDTH(160)) u_video_diag_cdc(.clk_origem(clk_hud),.clk_destino(pixel_clk),
        .valido(1'b1),.dados({mag_diagnostics,mpu_raw_ax,mpu_raw_ay,mpu_raw_az,
                            mpu_raw_gx,mpu_raw_gy,mpu_raw_gz,27'd0,video_failed,video_state}),.pronto(),
        .valido_destino(video_diag_valid),.dados_destino(video_diag_received));
    logic [159:0] video_diag_pending=0,video_diag_display=0;
    always_ff @(posedge pixel_clk) begin
        if(video_diag_valid) video_diag_pending<=video_diag_received;
        if(pixel_x==0 && pixel_y==480) video_diag_display<=video_diag_pending;
    end
    calibracao_vga u_calibration_display(.x(pixel_x),.y(pixel_y),.video_on(video_on),
        .grid(pixel_capture && (pixel_grid || pixel_view==2)),
        .diagnostics(pixel_capture && pixel_view==3),
        .raw_roll(attitude_raw_roll),.raw_pitch(attitude_raw_pitch),
        .roll(attitude_roll),.pitch(attitude_pitch),.render_roll(attitude_render_roll),
        .sine(attitude_sine),.cosine(attitude_cosine),.pitch_px(attitude_pitch_px),
        .status(attitude_status),.video_status(video_diag_display[31:0]),.frame_id(display_frame_id),
        .sensor_raw(video_diag_display[127:32]),.mag_status(video_diag_display[159:128]),.on(calibration_on));

    // Pacote atômico com dados do HUD, mira CAÇA e alvo manual.
    wire [127:0] amostra_completa;
    wire [56:0] amostra_pixel = amostra_completa[95:39];
    wire [31:0] hud_metadados;
    wire amostra_valida;
    wire entrada_pronta;
    wire [8:0] heading_entrada;
    wire [8:0] heading_manual;
    wire [8:0] heading_magnetico_deg;
    wire heading_magnetico_valido;
    wire heading_magnetico_atualizado;
    wire [8:0] heading_fusionado_deg;
    wire heading_fusionado_valido;
wire [16:0] altitude_hud_entrada;

wire [9:0] velocidade_hud_entrada =
    velocidade_inercial_valida ?
    velocidade_inercial_kt :
    10'd280;

    controle_heading u_heading (
        .clk         (clk_hud),
        .btn         (heading_command_buttons),
        .heading_deg (heading_manual)
    );
    // Ordem: velocidade(10), altitude(17), pitch(11), roll(10), heading(9)..
    wire [56:0] dados_operacao;
    wire [31:0] metadados_operacao;
    logic [3:0] inicio_operacao = 0;
    assign reset_operacao = !inicio_operacao[3];
    always_ff @(posedge clk_hud) inicio_operacao <= {inicio_operacao[2:0],1'b1};
    wire [127:0] pacote_hud = MODOS_OPERACIONAIS ?
        {metadados_operacao,dados_operacao,mira_lock_origem,mira_y_origem,mira_x_origem,alvo_y_origem,alvo_x_origem} :
        {32'd0,velocidade_hud_entrada,altitude_hud_entrada,pitch_px_entrada,roll_q8_entrada,
         heading_entrada,mira_lock_origem,mira_y_origem,mira_x_origem,alvo_y_origem,alvo_x_origem};
    entrada_hud #(.WIDTH(128)) u_entrada (
        .clk_origem(clk_hud), .clk_destino(pixel_clk),
        .valido(1'b1),
        .dados(pacote_hud),
        .pronto(entrada_pronta),
        .valido_destino(amostra_valida), .dados_destino(amostra_completa)
    );
    dados_hud #(.INICIAL_V(MODOS_OPERACIONAIS ? 0 : 280),
        .INICIAL_H(MODOS_OPERACIONAIS ? 0 : 36000)) u_dados (
        .clk(pixel_clk),
        .atualizar_quadro((pixel_x == 0) && (pixel_y == 480)),
        .dados_validos(amostra_valida),
        .metadados_in(amostra_completa[127:96]),.metadados(hud_metadados),
        .velocidade_kt_in(amostra_pixel[56:47]),
        .altitude_ft_in(amostra_pixel[46:30]),
        .pitch_px_in($signed(amostra_pixel[29:19])),
        .roll_q8_in($signed(amostra_pixel[18:9])),
        .heading_deg_in(amostra_pixel[8:0]),
        .mira_x_in(amostra_completa[28:19]),
        .mira_y_in(amostra_completa[37:29]),
        .mira_lock_in(amostra_completa[38]),
        .alvo_x_in(amostra_completa[9:0]),
        .alvo_y_in(amostra_completa[18:10]),
        .velocidade_kt(velocidade_kt), .altitude_ft(altitude_ft),
        .horizonte_y(horizonte_y),
        .roll_q8(roll_q8),
        .heading_deg(heading_deg),.mira_x(mira_x),.mira_y(mira_y),.mira_lock(mira_lock),
        .alvo_x(alvo_x),.alvo_y(alvo_y)
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
    logic mira_on;
    logic [11:0] mira_rgb;

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
    wire signed [15:0] mpu_raw_ax,mpu_raw_ay,mpu_raw_az;
    wire signed [15:0] mpu_raw_gx,mpu_raw_gy,mpu_raw_gz;
    // Compoe a montagem de 90 graus com a frente oposta, sem alterar Z.
    wire signed [15:0] mpu_montagem_ax=MPU_GIRO_ESQUERDA_90 ? mpu_raw_ay : mpu_raw_ax;
    wire signed [15:0] mpu_montagem_ay=MPU_GIRO_ESQUERDA_90 ? mpu_raw_ax : mpu_raw_ay;
    wire signed [15:0] mpu_montagem_gx=MPU_GIRO_ESQUERDA_90 ? mpu_raw_gy : mpu_raw_gx;
    wire signed [15:0] mpu_montagem_gy=MPU_GIRO_ESQUERDA_90 ? mpu_raw_gx : mpu_raw_gy;
    localparam bit MPU_INVERTER_X=MPU_GIRO_ESQUERDA_90 ^ FRENTE_INVERTIDA_180;
    localparam bit MPU_INVERTER_Y=FRENTE_INVERTIDA_180;
    function automatic logic signed [15:0] negar_mpu_saturado(input logic signed [15:0] valor);
        negar_mpu_saturado=valor==16'sh8000 ? 16'sh7fff : -valor;
    endfunction
    assign mpu_accel_x=MPU_INVERTER_X ? negar_mpu_saturado(mpu_montagem_ax) : mpu_montagem_ax;
    assign mpu_accel_y=MPU_INVERTER_Y ? negar_mpu_saturado(mpu_montagem_ay) : mpu_montagem_ay;
    assign mpu_accel_z=mpu_raw_az;
    assign mpu_gyro_x=MPU_INVERTER_X ? negar_mpu_saturado(mpu_montagem_gx) : mpu_montagem_gx;
    assign mpu_gyro_y=MPU_INVERTER_Y ? negar_mpu_saturado(mpu_montagem_gy) : mpu_montagem_gy;
    assign mpu_gyro_z=mpu_raw_gz;

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

    wire signed [31:0] fusao_pitch_q10,fusao_roll_q10;
    wire signed [31:0] legacy_pitch_q10,legacy_roll_q10;
    assign fusao_pitch_q10=FULL_ATTITUDE ? vector_pitch : legacy_pitch_q10;
    assign fusao_roll_q10=FULL_ATTITUDE ? vector_roll : legacy_roll_q10;
    assign fusao_valida=FULL_ATTITUDE ? vector_valid : legacy_fusao_valida;


    // Referencial original do GY-521, apos a compensacao de montagem acima.
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
        .clk       (clk_hud),
        .i2c_sda   (i2c_sda),
        .i2c_scl   (i2c_scl),
        .who_am_i  (sensor_id),
        .sensor_ok (sensor_ok),
        .amostra_nova(amostra_nova),
        .accel_x   (mpu_raw_ax),
        .accel_y   (mpu_raw_ay),
        .accel_z   (mpu_raw_az),
        .gyro_x    (mpu_raw_gx),
        .gyro_y    (mpu_raw_gy),
        .gyro_z    (mpu_raw_gz)
    );

    // -----------------------------------------------------
    // HMC5883L / magnetometro
    // -----------------------------------------------------

    logic mag_sensor_ok;
    logic mag_amostra_nova;

    logic signed [15:0] mag_x;
    logic signed [15:0] mag_y;
    logic signed [15:0] mag_z;

    hmc5883l_i2c u_magnetometro (
        .clk          (clk_hud),

        .mag_sda      (mag_sda),
        .mag_scl      (mag_scl),

        .sensor_ok    (mag_sensor_ok),
        .amostra_nova (mag_amostra_nova),

        .mag_x        (mag_x),
        .mag_y        (mag_y),
        .mag_z        (mag_z),
        .diagnostico  (mag_diagnostics)
    );

    heading_magnetico #(
        .OFFSET_X(MAG_OFFSET_X), .OFFSET_Y(MAG_OFFSET_Y),
        .GAIN_X_Q12(MAG_GAIN_X_Q12), .GAIN_Y_Q12(MAG_GAIN_Y_Q12),
        .ALINHAMENTO_GRAUS(MAG_ALINHAMENTO_GRAUS),
        .TROCAR_XY(MAG_TROCAR_XY),
        .INVERTER_X(MAG_INVERTER_X ^ FRENTE_INVERTIDA_180),
        .INVERTER_Y(MAG_INVERTER_Y ^ FRENTE_INVERTIDA_180)
    ) u_heading_magnetico (
        .clk(clk_hud),
        .sensor_ok(magnetometro_habilitado && mag_sensor_ok && (mag_z != -16'sd4096)),
        .amostra_nova(mag_amostra_nova),
        .mag_x(mag_x), .mag_y(mag_y),
        .heading_deg(heading_magnetico_deg), .valido(heading_magnetico_valido),
        .atualizado(heading_magnetico_atualizado)
    );

    // O manual continua ativo; a troca chega ao HUD pela interface de quadro.
    heading_fusao u_heading_fusao (
        .clk(clk_hud), .sensor_ok(sensor_ok && atitude_mpu_habilitada), .amostra_nova(amostra_nova),
        .gyro_z(mpu_gyro_z), .dt_valid(gyro_dt_valid), .dt_cycles(gyro_dt_cycles),
        .mag_valido(magnetometro_habilitado && mag_sensor_ok && heading_magnetico_valido),
        .mag_atualizado(heading_magnetico_atualizado), .heading_mag(heading_magnetico_deg),
        .heading_deg(heading_fusionado_deg), .valido(heading_fusionado_valido), .atualizado()
    );
    assign heading_entrada = heading_fusionado_valido ? heading_fusionado_deg :
        magnetometro_habilitado && mag_sensor_ok && heading_magnetico_valido ?
        heading_magnetico_deg : heading_manual;
    assign MAG_LED = magnetometro_habilitado && mag_sensor_ok;
    assign GYRO_LED = atitude_mpu_habilitada && sensor_ok;


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
        .clk          (clk_hud),
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
        .clk(clk_hud),
        .amostra_valid(barometro_habilitado && baro_sensor_ok && baro_calibracao_ok &&
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
        .clk           (clk_hud),
        .pressao_pa    (baro_pressao_pa),
        .pressao_valid (baro_press_calculo_ok),
        .altitude_ft   (baro_altitude_ft_calc),
        .calculo_ok    (baro_altitude_calc_ok)
    );

    always_ff @(posedge clk_hud) begin
        if (barometro_habilitado && baro_altitude_calc_ok)
            baro_altitude_ft_hold <= baro_altitude_ft_calc;
    end

    wire [16:0] altitude_fusionada_ft;
    wire signed [13:0] vel_vertical_fpm;
    wire vertical_valido, vertical_altitude_disponivel;
    estado_vertical u_estado_vertical (
        .clk(clk_hud), .sensor_ok(sensor_ok && atitude_mpu_habilitada),
        .atitude_valida(fusao_valida),
        .accel_x(mpu_accel_x), .accel_y(mpu_accel_y), .accel_z(mpu_accel_z),
        .pitch_q10(fusao_pitch_q10), .roll_q10(fusao_roll_q10),
        .dt_valid(gyro_dt_valid), .dt_cycles(gyro_dt_cycles),
        .baro_ok(barometro_habilitado && baro_sensor_ok && baro_calibracao_ok),
        .baro_nova(barometro_habilitado && baro_altitude_calc_ok),
        .altitude_baro_ft(baro_altitude_ft_calc),
        .altitude_ft(altitude_fusionada_ft), .vel_vertical_fpm(vel_vertical_fpm),
        .valido(vertical_valido), .altitude_disponivel(vertical_altitude_disponivel),
        .calibrado(), .atualizado()
    );
    assign altitude_hud_entrada = !barometro_habilitado ? 17'd0 :
        vertical_altitude_disponivel ? altitude_fusionada_ft : baro_altitude_ft_hold;

    assign BARO_LED =
        barometro_habilitado && baro_sensor_ok &&
        baro_calibracao_ok &&
        baro_ut_valid &&
        baro_up_valid &&
        baro_temp_calculo_ok &&
        baro_press_calculo_ok &&
        (baro_pressao_pa >= 32'd30000) &&
        (baro_pressao_pa <= 32'd120000);


    gyro_bias_dt u_gyro_bias_dt (
        .clk         (clk_hud),
        .sensor_ok   (sensor_ok && atitude_mpu_habilitada),
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

    // Separa a subtracao do bias dos DSPs; preserva dt e os dois eixos juntos.
    logic signed [16:0] gyro_x_integracao = 0, gyro_y_integracao = 0;
    logic [31:0] gyro_dt_integracao = 0;
    logic gyro_dt_integracao_valid = 0;
    always_ff @(posedge clk_hud) begin
        gyro_dt_integracao_valid <= sensor_ok && atitude_mpu_habilitada && gyro_dt_valid;
        if (sensor_ok && atitude_mpu_habilitada && gyro_dt_valid) begin
            gyro_x_integracao <= gyro_x_corr;
            gyro_y_integracao <= gyro_y_corr;
            gyro_dt_integracao <= gyro_dt_cycles;
        end
    end

    gyro_integrador u_gyro_pitch_integrador (
        .clk        (clk_hud),
        .sensor_ok  (sensor_ok && atitude_mpu_habilitada),
        .dt_valid   (gyro_dt_integracao_valid),
        .gyro_corr  (gyro_x_integracao),
        .dt_cycles  (gyro_dt_integracao),
        .angulo_q10 (gyro_pitch_q10),
        .angulo_valid (gyro_pitch_atualizado)
    );

    gyro_integrador u_gyro_roll_integrador (
        .clk        (clk_hud),
        .sensor_ok  (sensor_ok && atitude_mpu_habilitada),
        .dt_valid   (gyro_dt_integracao_valid),
        .gyro_corr  (gyro_y_integracao),
        .dt_cycles  (gyro_dt_integracao),
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
        .clk         (clk_hud),
        .sensor_ok   (sensor_ok && atitude_mpu_habilitada),
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
        .clk             (clk_hud),

        .sensor_ok       (sensor_ok && atitude_mpu_habilitada),
        .accel_calibrado (atitude_calibrada),
        .gyro_calibrado  (gyro_bias_calibrado),

        .atualizar       (fusao_atualizar),

        .accel_pitch_px  (pitch_sensor),
        .accel_roll_q8   (roll_sensor),

        .gyro_pitch_q10  (gyro_pitch_q10),
        .gyro_roll_q10   (gyro_roll_q10),

        .valido          (legacy_fusao_valida),

        .pitch_q10       (legacy_pitch_q10),
        .roll_q10        (legacy_roll_q10)
    );

    atitude_gyro_hud u_atitude_fusao_hud (
        .pitch_q10 (fusao_pitch_q10),
        .roll_q10  (fusao_roll_q10),

        .pitch_px  (fusao_pitch_px),
        .roll_q8   (fusao_roll_q8)
    );


    // -----------------------------------------------------
    // Velocidade inercial estimada
    //
    // Valor demonstrativo derivado do acelerometro.
    // NAO representa airspeed medida.
    // -----------------------------------------------------

    velocidade_inercial u_velocidade_inercial (
        .clk            (clk_hud),

        .sensor_ok      (sensor_ok && atitude_mpu_habilitada),
        .amostra_nova   (amostra_nova),

        // Eixo longitudinal ja validado fisicamente.
        .accel_forward  (mpu_accel_y),

        .pitch_px       (fusao_pitch_px),
        .atitude_valida (fusao_valida),

        .dt_valid       (gyro_dt_valid),
        .dt_cycles      (gyro_dt_cycles),

        .calibrado      (velocidade_inercial_calibrada),
        .valido         (velocidade_inercial_valida),

        .velocidade_kt  (velocidade_inercial_kt)
    );

    // -----------------------------------------------------
    // VGA
    // -----------------------------------------------------

    vga_controller u_vga (
        .clk_100mhz (clk_hud),
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

    // SW4 != capture. Offset only changes flight coordinates, at VGA frame boundary.
    wire signed [8:0] hud_offset_y;
    wire [9:0] hud_pixel_y;
    wire hud_video_on;
    hud_flight_coords u_flight_coords(
        .screen_y(pixel_y),.screen_video_on(video_on),
        .active_offset_y(hud_offset_y),
        .flight_y(hud_pixel_y),.flight_video_on(hud_video_on)
    );
    hud_vertical_adjust u_hud_vertical_adjust(
        .clk(pixel_clk),.reset(reset_operacao),
        .align_enable(align_mode && !capture_mode),
        .up_button(align_command_buttons[0]),
        .down_button(align_command_buttons[1]),
        .frame_boundary(pixel_x==0 && pixel_y==480),
        .offset_y(hud_offset_y)
    );

    reticula_vga #(
        .ESPESSURA   (1),
        .TAMANHO     (28),
        .VAO_CENTRAL (5)
    ) u_retic (
        .pixel_x     (pixel_x),
        .pixel_y     (hud_pixel_y),
        .video_on    (hud_video_on),
        .reticula_on (retic)
    );

    reticula_caca_vga #(
        .ESPESSURA (1),
        .CLEARANCE (3)
    ) u_retic_caca (
        .pixel_x      (pixel_x),
        .pixel_y      (hud_pixel_y),
        .video_on     (hud_video_on),
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

    simbologia_vga #(.FULL_ATTITUDE(FULL_ATTITUDE),
                      .SEPARATE_FLIGHT_COORDS(1'b1)) u_simbologia (
        .attitude_sine(attitude_sine),.attitude_cosine(attitude_cosine),.attitude_pitch_px(attitude_pitch_px),
        .horizonte_y  (horizonte_y),
        .roll_q8      (roll_q8),
        .heading_deg  (heading_deg),
        .alvo_x       (alvo_x),
        .alvo_y       (alvo_y),
        .pixel_x      (pixel_x),
        .pixel_y      (pixel_y),
        .video_on     (video_on),
        .flight_pixel_y(hud_pixel_y),
        .flight_video_on(hud_video_on),

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

    mira_caca_vga u_mira_caca (
        .pixel_x(pixel_x),.pixel_y(hud_pixel_y),.video_on(hud_video_on && estilo_caca),
        .mira_x(mira_x),.mira_y(mira_y),.locked(mira_lock),.on(mira_on),.rgb(mira_rgb)
    );


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
        (caca_sim && (!MODOS_OPERACIONAIS || hud_metadados[8]));

    wire extras_estilo =
        estilo_caca ?
        extras_caca :
        extras_originais;

    generate if (MODOS_OPERACIONAIS) begin : g_operacao
    operacao_hud #(.TICK_CYCLES(OPERACAO_TICK),.DEBOUNCE_CYCLES(OPERACAO_DEBOUNCE),
        .ACK_CYCLES(OPERACAO_ACK)) u_operacao (
        .clk(clk_hud),.reset(reset_operacao),.switches(operacao_sw),.ack(ack_btn),
        .fontes_validas({(heading_fusionado_valido ||
                          (magnetometro_habilitado && mag_sensor_ok && heading_magnetico_valido)),
                         (barometro_habilitado && baro_sensor_ok && baro_calibracao_ok),
                         (!modo_atitude_manual && sensor_ok && fusao_valida &&
                          (FULL_ATTITUDE ? vector_calibrated : (atitude_calibrada && gyro_bias_calibrado)))}),
        .novas_amostras({(magnetometro_habilitado && heading_magnetico_atualizado),
                         (barometro_habilitado && baro_altitude_calc_ok),(FULL_ATTITUDE ? vector_updated : fusao_atualizar)}),
        .attitude_manual_valid(modo_atitude_manual),
        .pitch_real_q10(fusao_pitch_q10),.roll_real_q10(fusao_roll_q10),
        .pitch_manual_q10(pitch_manual_q10),.roll_manual_q10(roll_manual_q10),
        .pitch_real_px(fusao_pitch_px),.roll_real_q8(fusao_roll_q8),
        .pitch_fallback_px(pitch_px_entrada),.roll_fallback_q8(roll_q8_entrada),
        .altitude_real_ft(altitude_hud_entrada),.heading_real_deg(heading_entrada),
        .heading_manual_deg(heading_manual),.vertical_real_fpm(vel_vertical_fpm),
        .vertical_real_valido(vertical_valido),.dados(dados_operacao),
        .metadados(metadados_operacao),.buzzer_out(buzzer_out));
    end else begin : g_legado
        assign dados_operacao=0; assign metadados_operacao=0; assign buzzer_out=0;
    end endgenerate

    wire overlay_on;
    wire [11:0] overlay_rgb;
    generate if (MODOS_OPERACIONAIS) begin : g_overlay
    alertas_vga u_alertas_vga(.pixel_x(pixel_x),.pixel_y(pixel_y),.video_on(video_on),
        .metadados(hud_metadados),.aim_locked(mira_lock),.on(overlay_on),.rgb(overlay_rgb));
    end else begin : g_sem_overlay
        assign overlay_on=0; assign overlay_rgb=0;
    end endgenerate

    wire align_status_on;
    hud_align_status_vga u_align_status(
        .pixel_clk(pixel_clk),.pixel_x(pixel_x),.pixel_y(pixel_y),
        .video_on(video_on),.align_mode(align_mode),.offset_y(hud_offset_y),
        .on(align_status_on)
    );
    // Indicador discreto de captura, fixo no raster.
    // A vista pura permanece completamente sem HUD.
    wire capture_status_on;
    hud_capture_status_vga u_capture_status (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .capture_active(pixel_capture),
        .view(pixel_view),
        .on(capture_status_on)
    );

    wire [11:0] hud_rgb;
    assign hud_rgb[11:8] =
        (MODOS_OPERACIONAIS && overlay_on) ? overlay_rgb[11:8] :
        align_status_on ? 4'h0 :
        capture_status_on ? 4'h0 :
        (MODOS_OPERACIONAIS && mira_on) ? mira_rgb[11:8] :
        retic_visivel                                ? 4'h0 :
        (!estilo_caca && alvo)                      ? 4'hF :
        (
            sensor_status &&
            !declutter &&
            !sensor_ok
        )                                            ? 4'hF :
                                                       4'h0;

    assign hud_rgb[7:4] =
        (MODOS_OPERACIONAIS && overlay_on) ? overlay_rgb[7:4] :
        align_status_on ? 4'hF :
        capture_status_on ? 4'hF :
        (MODOS_OPERACIONAIS && mira_on) ? mira_rgb[7:4] :
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

    assign hud_rgb[3:0] = (MODOS_OPERACIONAIS && overlay_on) ? overlay_rgb[3:0] :
        align_status_on ? 4'hF :
        capture_status_on ? 4'hF :
        (MODOS_OPERACIONAIS && mira_on) ? mira_rgb[3:0] : 4'h0;

    // Opacidade vem dos sinais de desenho, inclusive elementos pretos prioritarios.
    wire hud_opaque = align_status_on || capture_status_on || (MODOS_OPERACIONAIS && (overlay_on || mira_on)) ||
        retic_visivel || (!estilo_caca && alvo) || horizonte_visivel ||
        (!declutter && (extras_estilo || sensor_status));
    wire capture_hud_enabled=!pixel_capture || pixel_view!=0;
    wire [11:0] capture_hud_rgb=calibration_on ? 12'h0ff : capture_hud_enabled ? hud_rgb : 12'h000;
    wire capture_hud_opaque=calibration_on || (capture_hud_enabled && hud_opaque);
    wire [11:0] scene_rgb;
    // P4B: sinais de captura somente espelhados; nao interceptam VGA.
    initial if (ENABLE_DDR2_VIDEO &&
        (!ENABLE_DDR2_SD_MIRROR || !ENABLE_SD_VIDEO || !ENABLE_SD_SUBSYSTEM))
        $error("DDR2_VIDEO exige SD, video e espelho DDR2 habilitados");
    wire ddr_video_ready, ddr_src_ready;
    wire ddr_out_start,ddr_out_abort,ddr_out_commit,ddr_out_valid;
    wire [($clog2(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT))-1:0] ddr_out_address;
    wire [7:0] ddr_out_byte;
    wire p4b_frame_start, p4b_frame_abort, p4b_frame_commit, p4b_frame_write;
    wire [($clog2(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT))-1:0] p4b_frame_address;
    wire [7:0] p4b_data_byte;
    generate if (ENABLE_SD_VIDEO && ENABLE_SD_SUBSYSTEM) begin : g_video
        localparam integer AB = $clog2(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT);
        wire frame_start, frame_abort, frame_commit, frame_write, frame_ready;
        wire [AB-1:0] frame_address, display_address;
        wire display_enable, display_valid, frame_valid;
        wire [7:0] display_byte;
        wire publish_frame,frozen,updated_frame;
        assign ddr_video_ready=frame_ready;
        assign p4b_frame_start = frame_start;
        assign p4b_frame_abort = frame_abort;
        assign p4b_frame_commit = frame_commit;
        assign p4b_frame_write = frame_write;
        assign p4b_frame_address = frame_address;
        assign p4b_data_byte = sd_data_byte;
        video_captura u_capture(.pixel_clk(pixel_clk),.reset(reset_operacao),
            .capture(capture_mode),.step_toggle(step_toggle),.frame_boundary(pixel_x==0 && pixel_y==480),
            .frame_valid(frame_valid),.updated(updated_frame),.publish(publish_frame),
            .frozen(frozen),.frame_id(display_frame_id));
        sd_video_loader #(.WIDTH(SD_VIDEO_WIDTH),.HEIGHT(SD_VIDEO_HEIGHT),.FPS(SD_VIDEO_FPS),
            .BASE_LBA(SD_VIDEO_LBA),.MAX_FILE_SECTORS(SD_VIDEO_SECTORS)) u_loader (
            .clk(clk_hud),.rst(reset_operacao),.init_ready(sd_init_ready && video_startup_ready),.init_failed(sd_init_failed),
            .request(video_request),.grant(video_grant),.lba(video_lba),
            .read_busy(sd_read_busy && video_owner),.read_done(sd_read_done && video_owner),
            .read_error(sd_read_error && video_owner),.data_valid(sd_data_valid && video_owner),
            .block_valid(sd_block_valid && video_owner),.byte_index(sd_byte_index),.data_byte(sd_data_byte),
            .buffer_ready(frame_ready && (!ENABLE_DDR2_VIDEO || ddr_src_ready)),.frame_start(frame_start),.frame_abort(frame_abort),
            .frame_commit(frame_commit),.frame_write(frame_write),.frame_address(frame_address),
            .header_valid(),.failed(video_failed),.frames_loaded(video_frames),.errors(video_errors),
            .late_frames(video_late),.transfer_cycles(video_cycles),.state(video_state));
        sd_sector_buffer #(.BYTES(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT)) u_frames (
            .wr_clk(clk_hud),.rd_clk(pixel_clk),.rst(reset_operacao),
            .wr_start(ENABLE_DDR2_VIDEO ? ddr_out_start : frame_start),
            .wr_abort(ENABLE_DDR2_VIDEO ? ddr_out_abort : frame_abort),
            .wr_valid(ENABLE_DDR2_VIDEO ? ddr_out_valid : frame_write),
            .wr_commit(ENABLE_DDR2_VIDEO ? ddr_out_commit : frame_commit),
            .wr_byte(ENABLE_DDR2_VIDEO ? ddr_out_byte : sd_data_byte),
            .wr_index(ENABLE_DDR2_VIDEO ? ddr_out_address : frame_address),.wr_ready(frame_ready),
            .wr_active(),.wr_pending(),.wr_error(),.wr_published(),
            .rd_frame_start(publish_frame),
            .rd_enable(display_enable),.rd_address(display_address),.rd_byte(display_byte),
            .rd_valid(display_valid),.rd_sector_valid(frame_valid),.rd_updated(updated_frame));
        sd_video_background #(.WIDTH(SD_VIDEO_WIDTH),.HEIGHT(SD_VIDEO_HEIGHT)) u_background (
            .pixel_clk(pixel_clk),.rst(reset_operacao),.toggle_button(video_mode),
            .pixel_x(pixel_x),.pixel_y(pixel_y),.video_on(video_on),.hsync(hsync),.vsync(vsync),
            .hud_rgb(capture_hud_rgb),.hud_opaque(capture_hud_opaque),.frame_valid(frame_valid),
            .byte_valid(display_valid),.pixel_byte(display_byte),.read_enable(display_enable),
            .read_address(display_address),.rgb(scene_rgb),.hs(),.vs(),.enabled());
    end else begin : g_no_video
        assign ddr_video_ready=0;
        assign {p4b_frame_start,p4b_frame_abort,p4b_frame_commit,p4b_frame_write}=4'b0;
        assign p4b_frame_address='0;
        assign p4b_data_byte=8'd0;
        assign video_request=0; assign video_lba=0; assign video_failed=0;
        assign {video_frames,video_errors,video_late,video_cycles,video_state}=0;
        assign scene_rgb=capture_hud_rgb;
        assign display_frame_id=32'hffffffff;
    end endgenerate
    generate if (ENABLE_SD_OVERLAY && ENABLE_SD_SUBSYSTEM) begin : g_sd_overlay
        wire [8:0] bitmap_address;
        wire [7:0] bitmap_byte;
        wire bitmap_enable, bitmap_valid, sector_valid;
        wire reference_ok = SD_REFERENCE_FILE == "" || sd_data_ok;
        // read_busy sobe com o erro antigo do leitor ja limpo.
        sd_sector_buffer u_buffer (
            .wr_clk(clk_hud), .rd_clk(pixel_clk), .rst(reset_operacao),
            .wr_start(sd_diag_busy && !sd_read_busy_d),
            .wr_abort((sd_read_error && !video_owner) || (sd_block_valid_d && !reference_ok)),
            .wr_valid(sd_diag_valid), .wr_commit(sd_block_valid_d && reference_ok),
            .wr_byte(sd_data_byte), .wr_index(sd_byte_index),
            .wr_ready(sd_buffer_ready), .wr_active(), .wr_pending(sd_buffer_pending),
            .wr_error(sd_buffer_error), .wr_published(sd_buffer_published),
            .rd_frame_start(pixel_x == 0 && pixel_y == 480),
            .rd_enable(bitmap_enable), .rd_address(bitmap_address),
            .rd_byte(bitmap_byte), .rd_valid(bitmap_valid),
            .rd_sector_valid(sector_valid), .rd_updated()
        );
        sd_bitmap_overlay u_bitmap (
            .pixel_clk(pixel_clk), .rst(reset_operacao),
            .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on),
            .hsync(hsync), .vsync(vsync), .base_rgb(scene_rgb),
            .sector_valid(sector_valid),
            .byte_valid(bitmap_valid && capture_hud_enabled && !(ENABLE_SD_VIDEO && MODOS_OPERACIONAIS && (overlay_on || mira_on))),
            .bitmap_byte(bitmap_byte),
            .read_enable(bitmap_enable), .read_address(bitmap_address),
            .rgb({VGA_R,VGA_G,VGA_B}), .hs(VGA_HS), .vs(VGA_VS),
            .de(), .overlay_pixel()
        );
    end else begin : g_sd_overlay_disabled
        assign sd_buffer_ready=1;
        assign {sd_buffer_pending,sd_buffer_error,sd_buffer_published}=0;
        assign {VGA_R,VGA_G,VGA_B}=scene_rgb;
        assign VGA_HS=hsync;
        assign VGA_VS=vsync;
    end endgenerate

    // P3A - coexistencia experimental: sem trafego de video na DDR2.
    wire clk200_raw;
    wire clk_xadc_raw;
    wire clk200_ref;
    wire clkfb_raw;
    wire clkfb_buf;
    wire ref_mmcm_locked;

    // VCO=1000 MHz: CLKOUT1=200 MHz para MIG; CLKOUT0=102.564 MHz
    // para XADC (divisor ADC=4, 25.641 MHz < limite de 26 MHz).
    // MIG's REFCLK_TYPE=NOBUF expects an internal 200 MHz clock here.
    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKIN1_PERIOD(10.000),
        .DIVCLK_DIVIDE(1),
        .CLKFBOUT_MULT_F(10.000),
        .CLKFBOUT_PHASE(0.000),
        .CLKOUT0_DIVIDE_F(9.750),
        .CLKOUT1_DIVIDE(5),
        .CLKOUT0_PHASE(0.000),
        .CLKOUT0_DUTY_CYCLE(0.500),
        .STARTUP_WAIT("FALSE")
    ) u_refclk_mmcm (
        .CLKIN1(clk),
        .CLKFBIN(clkfb_buf),
        .RST(~cpu_resetn),
        .PWRDWN(1'b0),
        .CLKFBOUT(clkfb_raw),
        .CLKOUT0(clk_xadc_raw),
        .CLKOUT1(clk200_raw),
        .LOCKED(ref_mmcm_locked)
    );

    BUFG u_xadc_global (.I(clk_xadc_raw),.O(clk_xadc));
    BUFG u_refclk_feedback (.I(clkfb_raw), .O(clkfb_buf));
    BUFG u_refclk_global   (.I(clk200_raw), .O(clk200_ref));

    // Assert reset when the button is pressed or MMCM is not locked.
    // Deassert over four input-clock cycles; active LOW reset to MIG.
    reg [3:0] reset_release = 4'b0000;
    always @(posedge clk_hud or negedge cpu_resetn) begin
        if (!cpu_resetn)
            reset_release <= 4'b0000;
        else if (!ref_mmcm_locked)
            reset_release <= 4'b0000;
        else
            reset_release <= {reset_release[2:0], 1'b1};
    end
    // O MIG so sai de reset depois da primeira amostra real de temperatura.
    // P3C: reset externo do MIG registrado no dominio clk_hud.
    // Assert assincrono pelo botao; release sincronizado.
    reg mig_resetn = 1'b0;

    always @(posedge clk_hud or negedge cpu_resetn) begin
        if (!cpu_resetn)
            mig_resetn <= 1'b0;
        else
            mig_resetn <= reset_release[3] && temperature_xadc_valid;
    end

    wire calib_ok;
    wire smoke_error;
    wire smoke_done;
    wire smoke_pass;
    wire [12:0] compared_words;

    // O modo DDR2_VIDEO alimenta o buffer de exibicao pela releitura do MIG.
    ddr2_ui_smoke_top #(
        .FRAME_TEST_WORDS(ENABLE_DDR2_FRAME_TEST ?
            (SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT/16) : 0),
        .ENABLE_SD_MIRROR(ENABLE_DDR2_SD_MIRROR),.OUTPUT_STREAM(ENABLE_DDR2_VIDEO),
        .MIRROR_FRAME_BYTES(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT)
    ) u_ui_test (
        .src_clk(clk_hud),
        .src_rst(reset_operacao),
        .out_ready(ddr_video_ready),.src_ready(ddr_src_ready),
        .out_start(ddr_out_start),.out_abort(ddr_out_abort),
        .out_commit(ddr_out_commit),.out_valid(ddr_out_valid),
        .out_address(ddr_out_address),.out_byte(ddr_out_byte),
        .src_frame_start(p4b_frame_start),
        .src_frame_abort(p4b_frame_abort),
        .src_frame_commit(p4b_frame_commit),
        .src_frame_write(p4b_frame_write),
        .src_frame_address(p4b_frame_address),
        .src_data_byte(p4b_data_byte),
        .sys_clk_i(clk),
        .clk_ref_i(clk200_ref),
        .sys_rst(mig_resetn),
        .device_temp_raw(temperature_xadc_raw),
        .device_temp_req(temperature_xadc_toggle),
        .device_temp_ack(temperature_xadc_ack),
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_n(ddr2_dqs_n),
        .ddr2_dqs_p(ddr2_dqs_p),
        .ddr2_addr(ddr2_addr),
        .ddr2_ba(ddr2_ba),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_cke(ddr2_cke),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_odt(ddr2_odt),
        .init_calib_complete(calib_ok),
        .tg_compare_error(smoke_error),
        .smoke_done(smoke_done),
        .smoke_pass(smoke_pass),
        .smoke_words_compared(compared_words)
    );

    initial if (ENABLE_DDR2_FRAME_TEST && ENABLE_DDR2_SD_MIRROR)
        $error("P4B: habilite somente um modo de teste DDR2");
    initial if (ENABLE_DDR2_SD_MIRROR && !(ENABLE_SD_VIDEO && ENABLE_SD_SUBSYSTEM))
        $error("P4B: precisa de ENABLE_SD_VIDEO e ENABLE_SD_SUBSYSTEM");
    initial if (ENABLE_DDR2_SD_MIRROR && (SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT)%16 != 0)
        $error("P4B: quadro deve ter bytes multiplos de 16");
    initial if (ENABLE_DDR2_SD_MIRROR && (SD_VIDEO_LBA == 0 || SD_VIDEO_SECTORS <= 1))
        $error("P4B: informe LBA e quantidade de setores verificados no cartao atual");

    // Status dedicado LD12-15: LD12 lock, LD13 calib,
    // LD14 teste PASS concluido, LD15 erro.
    assign DDR2_STATUS_LED[0] = ref_mmcm_locked;
    assign DDR2_STATUS_LED[1] = calib_ok;
    assign DDR2_STATUS_LED[2] = smoke_done && smoke_pass;
    assign DDR2_STATUS_LED[3] = smoke_error;
endmodule
