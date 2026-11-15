module joystick_xadc (
    input  wire        clk,

    input  wire        vauxp3,
    input  wire        vauxn3,
    input  wire        vauxp10,
    input  wire        vauxn10,

    output logic [11:0] x_raw = 12'd0,
    output logic [11:0] y_raw = 12'd0,

    // Barramento bruto XADC; permanece estavel ate o ack do dominio MIG.
    output logic [11:0] temperature_raw = 12'd0,
    output logic        temperature_valid = 1'b0,
    output logic        temperature_toggle = 1'b0,
    input  wire         temperature_ack
);

    wire [15:0] vauxp_bus;
    wire [15:0] vauxn_bus;

    wire [4:0]  channel;
    wire        eoc;
    wire        drdy;
    wire [15:0] do_data;

    logic [4:0] channel_drp = 5'd0;

    // Ack de retorno do dominio UI DDR2: dois estagios de sincronizacao.
    (* ASYNC_REG = "TRUE" *) logic temp_ack_meta = 1'b0;
    (* ASYNC_REG = "TRUE" *) logic temp_ack_sync = 1'b0;

    // Somente VAUX3 e VAUX10 sao usados.
    assign vauxp_bus = {
        5'b00000,
        vauxp10,
        6'b000000,
        vauxp3,
        3'b000
    };

    assign vauxn_bus = {
        5'b00000,
        vauxn10,
        6'b000000,
        vauxn3,
        3'b000
    };

    XADC #(
        .INIT_40(16'h1000),

        // Sequenciador continuo.
        .INIT_41(16'h2EF0),

        // DCLK = 100 MHz; divisor 4 (ADCCLK=25 MHz) para temperatura periodica.
        .INIT_42(16'h0400),

        // Calibracao.
        .INIT_48(16'h0101),

        // Bit 3  = VAUX3
        // Bit 10 = VAUX10
        .INIT_49(16'h0408),

        // Media de 16 amostras apenas no canal de temperatura (INIT_4A bit 8).
        .INIT_4A(16'h0100),
        .INIT_4B(16'h0000),

        // Modo unipolar.
        .INIT_4C(16'h0000),
        .INIT_4D(16'h0000),

        .INIT_4E(16'h0000),
        .INIT_4F(16'h0000),

        .SIM_DEVICE("7SERIES")
    ) u_xadc (
        .CONVST       (1'b0),
        .CONVSTCLK    (1'b0),

        .DADDR        ({2'b00, channel}),
        .DCLK         (clk),
        .DEN          (eoc),
        .DI           (16'h0000),
        .DWE          (1'b0),
        .RESET        (1'b0),

        .VAUXP        (vauxp_bus),
        .VAUXN        (vauxn_bus),

        .VP           (1'b0),
        .VN           (1'b0),

        .ALM          (),
        .BUSY         (),
        .CHANNEL      (channel),
        .DO           (do_data),
        .DRDY         (drdy),
        .EOC          (eoc),
        .EOS          (),
        .JTAGBUSY     (),
        .JTAGLOCKED   (),
        .JTAGMODIFIED (),
        .OT           (),
        .MUXADDR      ()
    );

    // Guarda qual canal iniciou a leitura DRP.
    always_ff @(posedge clk) begin
        temp_ack_meta <= temperature_ack;
        temp_ack_sync <= temp_ack_meta;

        if (eoc)
            channel_drp <= channel;

        if (drdy) begin
            case (channel_drp)

                // Sensor interno de temperatura: canal 0, resultado bruto de 12 bits.
                // Nunca alterar o dado enquanto a amostra anterior nao foi reconhecida.
                5'd0: begin
                    temperature_valid <= 1'b1;
                    if (temperature_toggle == temp_ack_sync) begin
                        temperature_raw <= do_data[15:4];
                        temperature_toggle <= ~temperature_toggle;
                    end
                end

                // VAUX3 = canal 19
                5'd19:
                    x_raw <= do_data[15:4];

                // VAUX10 = canal 26
                5'd26:
                    y_raw <= do_data[15:4];

                default:
                    ;
            endcase
        end
    end

endmodule
