// =========================================================
// hmc5883l_i2c.sv
//
// Driver HMC5883L
//
// I2C address: 0x1E
//
// Identificacao:
//   0x0A = 0x48 = H
//   0x0B = 0x34 = 4
//   0x0C = 0x33 = 3
//
// Configuracao:
//   CRA  0x00 <- 0x70
//   CRB  0x01 <- 0x20
//   MODE 0x02 <- 0x00
//
// Dados:
//   0x03/04 = X
//   0x05/06 = Z
//   0x07/08 = Y
//
// Clock FPGA = 100 MHz
// I2C ~= 100 kHz
// =========================================================

module hmc5883l_i2c #(
    // Esperas em ticks de 2,5 us; parametros permitem simulacao curta.
    parameter logic [15:0] STARTUP_TICKS = 16'd40000,
    parameter logic [15:0] POLL_TICKS = 16'd40000,
    parameter logic [15:0] CONFIG_WAIT = 16'd4000
) (
    input  logic clk,

    inout  wire mag_sda,
    inout  wire mag_scl,

    output logic sensor_ok     = 1'b0,
    output logic amostra_nova  = 1'b0,

    output logic signed [15:0] mag_x = 16'sd0,
    output logic signed [15:0] mag_y = 16'sd0,
    output logic signed [15:0] mag_z = 16'sd0,
    output wire [31:0] diagnostico
);

    localparam logic [6:0] DEVICE_ADDR = 7'h1E;

    // -----------------------------------------------------
    // Open drain
    // -----------------------------------------------------

    logic sda_low = 1'b0;
    logic scl_low = 1'b0;
    logic [23:0] ultimo_id = 24'd0;
    logic id_lido = 1'b0;
    logic [1:0] ultimo_erro = 2'd0;
    logic [1:0] etapa_nack = 2'd0;

    assign mag_sda = sda_low ? 1'b0 : 1'bz;
    assign mag_scl = scl_low ? 1'b0 : 1'bz;


    // -----------------------------------------------------
    // Sincronizacao
    // -----------------------------------------------------

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] sda_sync = 2'b11;

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] scl_sync = 2'b11;

    // ID observado; flags: OK, ID lido, erro (0=nenhum,1=NACK,2=timeout), SCL/SDA.
    assign diagnostico = {ultimo_id, etapa_nack, sensor_ok, id_lido,
                          ultimo_erro, scl_sync[1], sda_sync[1]};

    logic [7:0] scl_high_count = 8'd0;

    wire scl_high_ready =
        (scl_high_count == 8'd225);

    always_ff @(posedge clk) begin
        sda_sync <= {sda_sync[0], mag_sda};
        scl_sync <= {scl_sync[0], mag_scl};

        if (!scl_sync[1])
            scl_high_count <= 8'd0;
        else if (!scl_high_ready)
            scl_high_count <= scl_high_count + 1'b1;
    end


    // -----------------------------------------------------
    // Temporizacao
    // -----------------------------------------------------

    localparam logic [7:0] CLK_DIV_LAST = 8'd249;

    // ticks de 2,5 us

    logic [7:0]  div_count = 8'd0;
    logic [15:0] idle_count = STARTUP_TICKS;
    logic [12:0] timeout_count = 13'd0;


    // -----------------------------------------------------
    // Operacoes
    // -----------------------------------------------------

    typedef enum logic [2:0] {
        OP_ID,
        OP_CFG_A,
        OP_CFG_B,
        OP_MODE,
        OP_DATA
    } operation_t;

    operation_t operation = OP_ID;

    logic [7:0] op_reg;
    logic       op_write;
    logic [7:0] op_write_data;
    logic [2:0] op_read_count;

    always_comb begin
        op_reg        = 8'h00;
        op_write      = 1'b0;
        op_write_data = 8'h00;
        op_read_count = 3'd1;

        case (operation)

            OP_ID: begin
                op_reg        = 8'h0A;
                op_read_count = 3'd3;
            end

            OP_CFG_A: begin
                op_reg        = 8'h00;
                op_write      = 1'b1;
                op_write_data = 8'h70;
            end

            OP_CFG_B: begin
                op_reg        = 8'h01;
                op_write      = 1'b1;
                op_write_data = 8'h20;
            end

            OP_MODE: begin
                op_reg        = 8'h02;
                op_write      = 1'b1;
                op_write_data = 8'h00;
            end

            OP_DATA: begin
                op_reg        = 8'h03;
                op_read_count = 3'd6;
            end

            default: begin
            end
        endcase
    end


    // -----------------------------------------------------
    // FSM I2C
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

        ST_REPLY_LOW,
        ST_REPLY_HIGH,
        ST_REPLY_SAMPLE,
        ST_REPLY_FALL,

        ST_STOP_1,
        ST_STOP_2,
        ST_STOP_3,
        ST_STOP_RELEASE,

        ST_DONE
    } state_t;

    state_t state = ST_IDLE;

    logic [7:0] tx_data = 8'h00;
    logic [7:0] rx_data = 8'h00;

    logic [7:0] rx_bytes [0:5];

    logic [2:0] bit_index  = 3'd7;
    logic [2:0] byte_index = 3'd0;

    // 0 endereco W
    // 1 registrador
    // 2 dado de escrita
    // 3 endereco R
    logic [1:0] etapa = 2'd0;

    logic ack_error = 1'b0;

    wire ultimo_byte =
        (byte_index == (op_read_count - 1'b1));


    always_ff @(posedge clk) begin

        amostra_nova <= 1'b0;

        if (div_count == CLK_DIV_LAST) begin

            div_count <= 8'd0;

            if (state != ST_IDLE)
                timeout_count <= timeout_count + 1'b1;


            // -------------------------------------------------
            // Timeout ~10 ms
            // -------------------------------------------------

            if (
                state != ST_IDLE &&
                timeout_count >= 13'd4000
            ) begin

                sda_low <= 1'b0;
                scl_low <= 1'b0;

                sensor_ok <= 1'b0;

                ultimo_erro <= 2'd2;
                etapa_nack <= 2'd0;

                operation <= OP_ID;
                idle_count <= POLL_TICKS;

                timeout_count <= 13'd0;
                state <= ST_IDLE;

            end
            else begin

                case (state)

                    ST_IDLE: begin

                        sda_low <= 1'b0;
                        scl_low <= 1'b0;

                        timeout_count <= 13'd0;

                        if (idle_count != 0)
                            idle_count <= idle_count - 1'b1;

                        else begin
                            tx_data <= {DEVICE_ADDR, 1'b0};

                            bit_index  <= 3'd7;
                            byte_index <= 3'd0;
                            etapa      <= 2'd0;

                            ack_error <= 1'b0;

                            state <= ST_START_1;
                        end
                    end


                    // -----------------------------------------
                    // START
                    // -----------------------------------------

                    ST_START_1: begin
                        if (scl_sync[1] && sda_sync[1])
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


                    // -----------------------------------------
                    // TX
                    // -----------------------------------------

                    ST_TX_LOW: begin
                        sda_low <= ~tx_data[bit_index];
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

                        if (bit_index == 0)
                            state <= ST_ACK_LOW;

                        else begin
                            bit_index <= bit_index - 1'b1;
                            state <= ST_TX_LOW;
                        end
                    end


                    // -----------------------------------------
                    // ACK
                    // -----------------------------------------

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

                            if (sda_sync[1]) begin
                                ack_error <= 1'b1;
                                etapa_nack <= etapa;
                            end

                            state <= ST_ACK_FALL;
                        end
                    end

                    ST_ACK_FALL: begin

                        scl_low <= 1'b1;

                        if (ack_error)
                            state <= ST_STOP_1;

                        else begin

                            case (etapa)

                                2'd0: begin
                                    tx_data <= op_reg;
                                    bit_index <= 3'd7;
                                    etapa <= 2'd1;
                                    state <= ST_TX_LOW;
                                end


                                2'd1: begin

                                    if (op_write) begin

                                        tx_data <= op_write_data;
                                        bit_index <= 3'd7;

                                        etapa <= 2'd2;

                                        state <= ST_TX_LOW;

                                    end
                                    else begin

                                        state <= ST_REP_1;
                                    end
                                end


                                2'd2: begin
                                    state <= ST_STOP_1;
                                end


                                default: begin
                                    byte_index <= 3'd0;
                                    bit_index <= 3'd7;
                                    rx_data <= 8'h00;

                                    state <= ST_READ_LOW;
                                end

                            endcase
                        end
                    end


                    // -----------------------------------------
                    // REPEATED START
                    // -----------------------------------------

                    ST_REP_1: begin
                        sda_low <= 1'b0;
                        state <= ST_REP_2;
                    end

                    ST_REP_2: begin
                        scl_low <= 1'b0;
                        state <= ST_REP_3;
                    end

                    ST_REP_3: begin

                        if (scl_high_ready) begin
                            tx_data <= {DEVICE_ADDR, 1'b1};
                            bit_index <= 3'd7;
                            etapa <= 2'd3;

                            state <= ST_START_2;
                        end
                    end


                    // -----------------------------------------
                    // RX
                    // -----------------------------------------

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
                            rx_data[bit_index] <= sda_sync[1];
                            state <= ST_READ_FALL;
                        end
                    end

                    ST_READ_FALL: begin

                        scl_low <= 1'b1;

                        if (bit_index == 0) begin

                            rx_bytes[byte_index] <= rx_data;
                            state <= ST_REPLY_LOW;

                        end
                        else begin

                            bit_index <= bit_index - 1'b1;
                            state <= ST_READ_LOW;
                        end
                    end


                    // ACK intermediario / NACK ultimo
                    ST_REPLY_LOW: begin
                        sda_low <= !ultimo_byte;
                        state <= ST_REPLY_HIGH;
                    end

                    ST_REPLY_HIGH: begin
                        scl_low <= 1'b0;
                        state <= ST_REPLY_SAMPLE;
                    end

                    ST_REPLY_SAMPLE: begin
                        if (scl_high_ready)
                            state <= ST_REPLY_FALL;
                    end

                    ST_REPLY_FALL: begin

                        scl_low <= 1'b1;
                        sda_low <= 1'b0;

                        if (ultimo_byte)
                            state <= ST_STOP_1;

                        else begin
                            byte_index <= byte_index + 1'b1;
                            bit_index <= 3'd7;
                            rx_data <= 8'h00;

                            state <= ST_READ_LOW;
                        end
                    end


                    // -----------------------------------------
                    // STOP
                    // -----------------------------------------

                    ST_STOP_1: begin
                        scl_low <= 1'b1;
                        sda_low <= 1'b1;
                        state <= ST_STOP_2;
                    end

                    ST_STOP_2: begin
                        scl_low <= 1'b0;
                        state <= ST_STOP_3;
                    end

                    ST_STOP_3: begin
                        if (scl_high_ready)
                            state <= ST_STOP_RELEASE;
                    end

                    ST_STOP_RELEASE: begin
                        sda_low <= 1'b0;

                        if (
                            scl_sync[1] &&
                            scl_high_ready &&
                            sda_sync[1]
                        )
                            state <= ST_DONE;
                    end


                    // -----------------------------------------
                    // Fim da operacao
                    // -----------------------------------------

                    ST_DONE: begin

                        state <= ST_IDLE;

                        if (ack_error) begin

                            sensor_ok <= 1'b0;
                            ultimo_erro <= 2'd1;

                            operation <= OP_ID;
                            idle_count <= POLL_TICKS;

                        end
                        else begin

                            ultimo_erro <= 2'd0;
                            etapa_nack <= 2'd0;

                            case (operation)

                                OP_ID: begin

                                    ultimo_id <= {rx_bytes[0], rx_bytes[1], rx_bytes[2]};
                                    id_lido <= 1'b1;

                                    if (
                                        rx_bytes[0] == 8'h48 &&
                                        rx_bytes[1] == 8'h34 &&
                                        rx_bytes[2] == 8'h33
                                    ) begin

                                        operation <= OP_CFG_A;
                                        idle_count <= CONFIG_WAIT;

                                    end
                                    else begin

                                        sensor_ok <= 1'b0;

                                        operation <= OP_ID;
                                        idle_count <= POLL_TICKS;

                                    end
                                end


                                OP_CFG_A: begin
                                    operation <= OP_CFG_B;
                                    idle_count <= CONFIG_WAIT;
                                end


                                OP_CFG_B: begin
                                    operation <= OP_MODE;
                                    idle_count <= CONFIG_WAIT;
                                end


                                OP_MODE: begin

                                    sensor_ok <= 1'b1;

                                    operation <= OP_DATA;
                                    idle_count <= POLL_TICKS;
                                end


                                OP_DATA: begin

                                    // Ordem HMC5883L:
                                    // X, Z, Y - big endian.

                                    mag_x <= $signed({
                                        rx_bytes[0],
                                        rx_bytes[1]
                                    });

                                    mag_z <= $signed({
                                        rx_bytes[2],
                                        rx_bytes[3]
                                    });

                                    mag_y <= $signed({
                                        rx_bytes[4],
                                        rx_bytes[5]
                                    });

                                    sensor_ok <= 1'b1;
                                    amostra_nova <= 1'b1;

                                    operation <= OP_DATA;
                                    idle_count <= POLL_TICKS;
                                end


                                default: begin

                                    sensor_ok <= 1'b0;

                                    operation <= OP_ID;
                                    idle_count <= POLL_TICKS;
                                end

                            endcase
                        end
                    end


                    default: begin

                        sda_low <= 1'b0;
                        scl_low <= 1'b0;

                        sensor_ok <= 1'b0;

                        operation <= OP_ID;
                        idle_count <= POLL_TICKS;

                        state <= ST_IDLE;
                    end

                endcase
            end
        end
        else begin
            div_count <= div_count + 1'b1;
        end
    end

endmodule
