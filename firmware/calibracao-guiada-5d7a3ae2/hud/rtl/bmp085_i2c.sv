// =========================================================
// bmp085_i2c.sv
//
// Probe minimo do Bosch BMP085.
// Barramento I2C independente do MPU-6050.
//
// Funcao desta primeira etapa:
//   - endereco I2C: 0x77
//   - ler CHIP_ID no registrador 0xD0
//   - valor esperado: 0x55
//
// Ainda NAO calcula:
//   - temperatura
//   - pressao
//   - altitude
//
// Clock de entrada: 100 MHz
// I2C aproximado: 100 kHz
// Open-drain: nunca dirige nivel alto.
// =========================================================

module bmp085_i2c #(
    parameter logic [6:0] DEVICE_ADDR = 7'h77,
    parameter bit ENABLE_CALIBRATION = 1'b0,
parameter bit ENABLE_TEMPERATURE = 1'b0,
    parameter bit ENABLE_PRESSURE = 1'b0,
    parameter bit ENABLE_CONTINUOUS = 1'b0,
    parameter logic [15:0] MEASUREMENT_INTERVAL_TICKS = 16'd40000
)(
    input  logic clk,

    inout  wire  i2c_sda,
    inout  wire  i2c_scl,

    output logic [7:0] chip_id        = 8'h00,
    output logic       sensor_ok      = 1'b0,
    output logic       calibracao_ok  = 1'b0,


output logic [15:0] ut_raw = 16'h0000,
output logic ut_valid = 1'b0,

    output logic [18:0] up_raw = 19'd0,
    output logic        up_valid = 1'b0,

    output logic signed [15:0] ac1 = 16'sd0,
    output logic signed [15:0] ac2 = 16'sd0,
    output logic signed [15:0] ac3 = 16'sd0,

    output logic        [15:0] ac4 = 16'd0,
    output logic        [15:0] ac5 = 16'd0,
    output logic        [15:0] ac6 = 16'd0,

    output logic signed [15:0] b1 = 16'sd0,
    output logic signed [15:0] b2 = 16'sd0,
    output logic signed [15:0] mb = 16'sd0,
    output logic signed [15:0] mc = 16'sd0,
    output logic signed [15:0] md = 16'sd0
);

    // -----------------------------------------------------
    // Open-drain
    // -----------------------------------------------------

    logic sda_low = 1'b0;
    logic scl_low = 1'b0;

    assign i2c_sda = sda_low ? 1'b0 : 1'bz;
    assign i2c_scl = scl_low ? 1'b0 : 1'bz;


    // -----------------------------------------------------
    // Sincronizacao das entradas I2C
    // -----------------------------------------------------

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] sda_sync = 2'b11;

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] scl_sync = 2'b11;


    logic [7:0] scl_high_count = 8'd0;

    wire scl_high_ready =
        (scl_high_count == 8'd225);


    always_ff @(posedge clk) begin

        sda_sync <= {
            sda_sync[0],
            i2c_sda
        };

        scl_sync <= {
            scl_sync[0],
            i2c_scl
        };


        if (!scl_sync[1])
            scl_high_count <= 8'd0;
        else if (!scl_high_ready)
            scl_high_count <=
                scl_high_count + 1'b1;

    end


    // -----------------------------------------------------
    // 100 MHz / 250 = passo de 2,5 us.
    // Quatro passos por bit ~= 100 kHz.
    // -----------------------------------------------------

    localparam logic [7:0]
        CLK_DIV_LAST = 8'd249;

    // 100 ms antes da primeira tentativa.
    localparam logic [15:0]
        STARTUP_TICKS = 16'd40000;

    // Nova verificacao aproximadamente a cada 100 ms.
    localparam logic [15:0]
        POLL_TICKS = 16'd40000;


    logic [7:0] div_count = 8'd0;

    logic [15:0] idle_count =
        STARTUP_TICKS;

    logic [12:0] timeout_count =
        13'd0;


    // -----------------------------------------------------
    // Estados I2C
    // -----------------------------------------------------

    typedef enum logic [5:0] {

        ST_IDLE,

        ST_START_1,
        ST_START_2,
        ST_START_HOLD,
        ST_START_3,

        ST_TX_LOW,
        ST_TX_HIGH,
        ST_TX_SAMPLE,
        ST_TX_FALL,

        ST_ACK_LOW,
        ST_ACK_HIGH,
        ST_ACK_SAMPLE,
        ST_ACK_FALL,

        ST_REP_1,
        ST_REP_2,
        ST_REP_3,

        ST_READ_LOW,
        ST_READ_HIGH,
        ST_READ_SAMPLE,
        ST_READ_FALL,

        ST_NACK_LOW,
        ST_NACK_HIGH,
        ST_NACK_FALL,

        ST_STOP_1,
        ST_STOP_2,
        ST_STOP_3,
        ST_STOP_RELEASE

    } state_t;


    state_t state = ST_IDLE;


    // -----------------------------------------------------
    // Transacao:
    //
    // START
    // 0xEE = 0x77 + W
    // ACK
    // 0xD0
    // ACK
    // REPEATED START
    // 0xEF = 0x77 + R
    // ACK
    // CHIP_ID
    // NACK
    // STOP
    // -----------------------------------------------------

    logic [7:0] tx_data = 8'h00;
    logic [7:0] rx_data = 8'h00;

    logic [2:0] bit_index = 3'd7;

    // 0 = endereco write
    // 1 = registrador 0xD0
    // 2 = endereco read
    logic [1:0] etapa = 2'd0;

    logic ack_error = 1'b0;


    // -----------------------------------------------------
    // Sequenciamento:
    //   OP_ID    -> le 0xD0 e espera 0x55
    //   OP_CALIB -> le individualmente 0xAA .. 0xBF
    //   OP_DONE  -> calibração disponivel
    // -----------------------------------------------------

    typedef enum logic [3:0] {
        OP_ID,
        OP_CALIB,

        OP_TEMP_CMD,
        OP_TEMP_MSB,
        OP_TEMP_LSB,

        OP_PRESS_CMD,
        OP_PRESS_MSB,
        OP_PRESS_LSB,
        OP_PRESS_XLSB,

        OP_DONE
    } operation_t;

    operation_t operation = OP_ID;

    logic [4:0] calib_index = 5'd0;
    logic [7:0] calib_bytes [0:21];

    logic finalize_pending   = 1'b0;
    logic calib_valid_pending = 1'b0;

    // Tornam o resultado fisicamente dependente
    // dos bytes realmente recebidos.
    logic [7:0] calib_or  = 8'h00;
    logic [7:0] calib_and = 8'hFF;

localparam logic [15:0] TEMP_WAIT_TICKS = 16'd2200;
    localparam logic [15:0] PRESS_WAIT_TICKS = 16'd2200;
logic [7:0] ut_msb = 8'h00;

    logic [7:0] press_msb = 8'h00;
    logic [7:0] press_lsb = 8'h00;


    always_ff @(posedge clk) begin

        if (div_count == CLK_DIV_LAST) begin

            div_count <= 8'd0;


            if (state != ST_IDLE)
                timeout_count <=
                    timeout_count + 1'b1;


            // ---------------------------------------------
            // Timeout de aproximadamente 10 ms.
            // ---------------------------------------------

            if (
                (state != ST_IDLE) &&
                (timeout_count >= 13'd4000)
            ) begin

                sda_low <= 1'b0;
                scl_low <= 1'b0;

                chip_id <= 8'h00;
                sensor_ok <= 1'b0;
                calibracao_ok <= 1'b0;

                etapa <= 2'd0;

                operation <= OP_ID;
                calib_index <= 5'd0;

                finalize_pending <= 1'b0;
                calib_valid_pending <= 1'b0;

                calib_or <= 8'h00;
                calib_and <= 8'hFF;

                idle_count <= POLL_TICKS;

                state <= ST_IDLE;

            end
            else begin

                case (state)


                    // -------------------------------------
                    // IDLE
                    // -------------------------------------

                    ST_IDLE: begin

                        sda_low <= 1'b0;
                        scl_low <= 1'b0;

                        timeout_count <= 13'd0;


                        // Depois que o ultimo byte foi salvo,
                        // publica os 11 coeficientes de uma vez.
                        if (finalize_pending) begin

                            ac1 <= {calib_bytes[0],  calib_bytes[1]};
                            ac2 <= {calib_bytes[2],  calib_bytes[3]};
                            ac3 <= {calib_bytes[4],  calib_bytes[5]};

                            ac4 <= {calib_bytes[6],  calib_bytes[7]};
                            ac5 <= {calib_bytes[8],  calib_bytes[9]};
                            ac6 <= {calib_bytes[10], calib_bytes[11]};

                            b1 <= {calib_bytes[12], calib_bytes[13]};
                            b2 <= {calib_bytes[14], calib_bytes[15]};
                            mb <= {calib_bytes[16], calib_bytes[17]};
                            mc <= {calib_bytes[18], calib_bytes[19]};
                            md <= {calib_bytes[20], calib_bytes[21]};

                            calibracao_ok <= calib_valid_pending;

                            finalize_pending <= 1'b0;

                            if (
                                calib_valid_pending &&
                                ENABLE_TEMPERATURE
                            ) begin

                                ut_valid <= 1'b0;

                                operation <= OP_TEMP_CMD;
                                idle_count <= 16'd1;

                            end
                            else begin

                                operation <= OP_DONE;
                                idle_count <= 16'd0;

                            end

                        end
                        else if (operation == OP_DONE) begin

                            // Repete apenas as conversoes, sem reler a EEPROM.
                            if (ENABLE_CONTINUOUS && ENABLE_TEMPERATURE &&
                                calibracao_ok) begin
                                if (idle_count != 0)
                                    idle_count <= idle_count - 1'b1;
                                else begin
                                    operation <= OP_TEMP_CMD;
                                    idle_count <= 16'd0;
                                end
                            end
                            else
                                idle_count <= 16'd0;

                        end
                        else if (idle_count != 0) begin

                            idle_count <=
                                idle_count - 1'b1;

                        end
                        else begin

                            tx_data <= {
                                DEVICE_ADDR,
                                1'b0
                            };

                            bit_index <= 3'd7;

                            etapa <= 2'd0;

                            ack_error <= 1'b0;

                            state <= ST_START_1;

                        end
                    end


                    // -------------------------------------
                    // START
                    // -------------------------------------

                    ST_START_1: begin

                        if (
                            scl_sync[1] &&
                            sda_sync[1]
                        )
                            state <= ST_START_2;

                    end


                    ST_START_2: begin

                        sda_low <= 1'b1;
                        state <= ST_START_HOLD;

                    end


                    ST_START_HOLD: begin

                        state <= ST_START_3;

                    end


                    ST_START_3: begin

                        scl_low <= 1'b1;
                        state <= ST_TX_LOW;

                    end


                    // -------------------------------------
                    // TX BYTE
                    // -------------------------------------

                    ST_TX_LOW: begin

                        sda_low <=
                            ~tx_data[bit_index];

                        state <= ST_TX_HIGH;

                    end


                    ST_TX_HIGH: begin

                        scl_low <= 1'b0;
                        state <= ST_TX_SAMPLE;

                    end


                    ST_TX_SAMPLE: begin

                        if (scl_high_ready)
                            state <= ST_TX_FALL;

                    end


                    ST_TX_FALL: begin

                        scl_low <= 1'b1;

                        if (bit_index == 0) begin

                            state <= ST_ACK_LOW;

                        end
                        else begin

                            bit_index <=
                                bit_index - 1'b1;

                            state <= ST_TX_LOW;

                        end
                    end


                    // -------------------------------------
                    // ACK DO SLAVE
                    // -------------------------------------

                    ST_ACK_LOW: begin

                        sda_low <= 1'b0;

                        state <= ST_ACK_HIGH;

                    end


                    ST_ACK_HIGH: begin

                        scl_low <= 1'b0;

                        state <= ST_ACK_SAMPLE;

                    end


                    ST_ACK_SAMPLE: begin

                        if (scl_high_ready) begin

                            ack_error <=
                                sda_sync[1];

                            state <= ST_ACK_FALL;

                        end
                    end


                    ST_ACK_FALL: begin

                        scl_low <= 1'b1;

                        if (ack_error) begin

                            sensor_ok <= 1'b0;

                            state <= ST_STOP_1;

                        end
                        else begin

                            case (etapa)

                                // Endereco W aceito.
                                2'd0: begin

                                    if (operation == OP_CALIB)
                                    tx_data <= 8'hAA + calib_index;
                                else if (operation == OP_TEMP_CMD)
                                    tx_data <= 8'hF4;
                                else if (operation == OP_TEMP_MSB)
                                    tx_data <= 8'hF6;
                                else if (operation == OP_TEMP_LSB)
                                    tx_data <= 8'hF7;
                                else if (operation == OP_PRESS_CMD)
                                    tx_data <= 8'hF4;
                                else if (operation == OP_PRESS_MSB)
                                    tx_data <= 8'hF6;
                                else if (operation == OP_PRESS_LSB)
                                    tx_data <= 8'hF7;
                                else if (operation == OP_PRESS_XLSB)
                                    tx_data <= 8'hF8;
                                else
                                    tx_data <= 8'hD0;

                                    bit_index <= 3'd7;

                                    etapa <= 2'd1;

                                    state <= ST_TX_LOW;

                                end


                                // Registrador aceito.
                            2'd1: begin

                                if (operation == OP_TEMP_CMD) begin
                                    tx_data <= 8'h2E;
                                    bit_index <= 3'd7;
                                    etapa <= 2'd3;
                                    state <= ST_TX_LOW;
                                end
                                else if (operation == OP_PRESS_CMD) begin
                                    // OSS=0:
                                    // comando de pressao = 0x34.
                                    tx_data <= 8'h34;
                                    bit_index <= 3'd7;
                                    etapa <= 2'd3;
                                    state <= ST_TX_LOW;
                                end
                                else begin
                                    etapa <= 2'd2;
                                    state <= ST_REP_1;
                                end

                            end

                            // Endereco R aceito.
                            2'd2: begin
                                rx_data <= 8'h00;
                                bit_index <= 3'd7;
                                state <= ST_READ_LOW;
                            end

                            // Byte 0x2E aceito.
                            default: begin
                                state <= ST_STOP_1;
                            end

                            endcase
                        end
                    end


                    // -------------------------------------
                    // REPEATED START
                    // -------------------------------------

                    ST_REP_1: begin

                        sda_low <= 1'b0;
                        scl_low <= 1'b0;

                        state <= ST_REP_2;

                    end


                    ST_REP_2: begin

                        if (scl_high_ready) begin

                            sda_low <= 1'b1;

                            state <= ST_REP_3;

                        end
                    end


                    ST_REP_3: begin

                        scl_low <= 1'b1;

                        tx_data <= {
                            DEVICE_ADDR,
                            1'b1
                        };

                        bit_index <= 3'd7;

                        state <= ST_TX_LOW;

                    end


                    // -------------------------------------
                    // READ CHIP_ID
                    // -------------------------------------

                    ST_READ_LOW: begin

                        sda_low <= 1'b0;

                        state <= ST_READ_HIGH;

                    end


                    ST_READ_HIGH: begin

                        scl_low <= 1'b0;

                        state <= ST_READ_SAMPLE;

                    end


                    ST_READ_SAMPLE: begin

                        if (scl_high_ready) begin

                            rx_data[bit_index]
                                <= sda_sync[1];

                            state <= ST_READ_FALL;

                        end
                    end


                    ST_READ_FALL: begin

                        scl_low <= 1'b1;

                        if (bit_index == 0) begin

                            state <= ST_NACK_LOW;

                        end
                        else begin

                            bit_index <=
                                bit_index - 1'b1;

                            state <= ST_READ_LOW;

                        end
                    end


                    // -------------------------------------
                    // NACK apos byte unico
                    // -------------------------------------

                    ST_NACK_LOW: begin

                        sda_low <= 1'b0;

                        state <= ST_NACK_HIGH;

                    end


                    ST_NACK_HIGH: begin

                        scl_low <= 1'b0;

                        if (scl_high_ready)
                            state <= ST_NACK_FALL;

                    end


                    ST_NACK_FALL: begin

                        scl_low <= 1'b1;

                        state <= ST_STOP_1;

                    end


                    // -------------------------------------
                    // STOP
                    // -------------------------------------

                    ST_STOP_1: begin

                        sda_low <= 1'b1;
                        scl_low <= 1'b1;

                        state <= ST_STOP_2;

                    end


                    ST_STOP_2: begin

                        scl_low <= 1'b0;

                        if (scl_high_ready)
                            state <= ST_STOP_3;

                    end


                    ST_STOP_3: begin

                        sda_low <= 1'b0;

                        state <= ST_STOP_RELEASE;

                    end


                    ST_STOP_RELEASE: begin

                        if (
                            scl_sync[1] &&
                            sda_sync[1]
                        ) begin

                            if (ack_error) begin

                                chip_id <= 8'h00;
                                sensor_ok <= 1'b0;
                                calibracao_ok <= 1'b0;

                                operation <= OP_ID;
                                calib_index <= 5'd0;

                                finalize_pending <= 1'b0;
                                calib_valid_pending <= 1'b0;

                                calib_or <= 8'h00;
                                calib_and <= 8'hFF;

                                idle_count <= POLL_TICKS;

                            end
                            else if (operation == OP_ID) begin

                                chip_id <= rx_data;

                                if (rx_data == 8'h55) begin

                                    sensor_ok <= 1'b1;

                                    if (ENABLE_CALIBRATION) begin

                                        calibracao_ok <= 1'b0;

                                        operation <= OP_CALIB;
                                        calib_index <= 5'd0;

                                        calib_or <= 8'h00;
                                        calib_and <= 8'hFF;

                                        // Comeca a EEPROM logo em seguida.
                                        idle_count <= 16'd1;

                                    end
                                    else begin

                                        operation <= OP_ID;
                                        idle_count <= POLL_TICKS;

                                    end

                                end
                                else begin

                                    sensor_ok <= 1'b0;
                                    calibracao_ok <= 1'b0;

                                    operation <= OP_ID;
                                    idle_count <= POLL_TICKS;

                                end

                            end
                            else if (operation == OP_CALIB) begin

                                sensor_ok <= 1'b1;

                                calib_bytes[calib_index] <=
                                    rx_data;

                                calib_or <=
                                    calib_or | rx_data;

                                calib_and <=
                                    calib_and & rx_data;


                                if (calib_index == 5'd21) begin

                                    // Rejeita apenas os casos fisicamente
                                    // invalidos mais obvios:
                                    // EEPROM inteira 0x00 ou inteira 0xFF.
                                    calib_valid_pending <=
                                        (((calib_or | rx_data) != 8'h00) &&
                                         ((calib_and & rx_data) != 8'hFF));

                                    finalize_pending <= 1'b1;

                                    operation <= OP_DONE;

                                    idle_count <= 16'd0;

                                end
                                else begin

                                    calib_index <=
                                        calib_index + 1'b1;

                                    idle_count <= 16'd1;

                                end

                            end

                            else if (operation == OP_TEMP_CMD) begin

                                sensor_ok <= 1'b1;

                                operation <= OP_TEMP_MSB;
                                idle_count <= TEMP_WAIT_TICKS;

                            end
                            else if (operation == OP_TEMP_MSB) begin

                                sensor_ok <= 1'b1;

                                ut_msb <= rx_data;

                                operation <= OP_TEMP_LSB;
                                idle_count <= 16'd1;

                            end
                            else if (operation == OP_TEMP_LSB) begin

                            sensor_ok <= 1'b1;

                            ut_raw <= {
                                ut_msb,
                                rx_data
                            };

                            ut_valid <= 1'b1;

                            if (ENABLE_PRESSURE) begin

                                up_valid <= 1'b0;

                                operation <= OP_PRESS_CMD;
                                idle_count <= 16'd1;

                            end
                            else begin

                                operation <= OP_DONE;
                                idle_count <= ENABLE_CONTINUOUS ?
                                    MEASUREMENT_INTERVAL_TICKS : 16'd0;

                            end

                        end
                        else if (operation == OP_PRESS_CMD) begin

                            sensor_ok <= 1'b1;

                            operation <= OP_PRESS_MSB;
                            idle_count <= PRESS_WAIT_TICKS;

                        end
                        else if (operation == OP_PRESS_MSB) begin

                            sensor_ok <= 1'b1;

                            press_msb <= rx_data;

                            operation <= OP_PRESS_LSB;
                            idle_count <= 16'd1;

                        end
                        else if (operation == OP_PRESS_LSB) begin

                            sensor_ok <= 1'b1;

                            press_lsb <= rx_data;

                            operation <= OP_PRESS_XLSB;
                            idle_count <= 16'd1;

                        end
                        else if (operation == OP_PRESS_XLSB) begin

                            sensor_ok <= 1'b1;

                            // OSS=0:
                            // UP = ({MSB, LSB, XLSB} >> 8)
                            up_raw <=
                                ({press_msb, press_lsb, rx_data} >> 8);

                            up_valid <= 1'b1;

                            operation <= OP_DONE;
                            idle_count <= ENABLE_CONTINUOUS ?
                                    MEASUREMENT_INTERVAL_TICKS : 16'd0;

                        end

                        etapa <= 2'd0;

                            state <= ST_IDLE;

                        end
                    end


                    default: begin

                        sda_low <= 1'b0;
                        scl_low <= 1'b0;

                        sensor_ok <= 1'b0;

                        state <= ST_IDLE;

                    end

                endcase
            end

        end
        else begin

            div_count <=
                div_count + 1'b1;

        end

    end

endmodule
