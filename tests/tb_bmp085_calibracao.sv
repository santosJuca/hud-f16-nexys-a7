`timescale 1ns/1ps

module tb_bmp085_calibracao;

    logic clk = 1'b0;

    always #5 clk = ~clk; // 100 MHz


    tri1 i2c_sda;
    tri1 i2c_scl;

    logic slave_sda_low = 1'b0;

    assign i2c_sda =
        slave_sda_low ? 1'b0 : 1'bz;


    wire [7:0] chip_id;
    wire sensor_ok;
    wire calibracao_ok;

    wire signed [15:0] ac1;
    wire signed [15:0] ac2;
    wire signed [15:0] ac3;

    wire [15:0] ac4;
    wire [15:0] ac5;
    wire [15:0] ac6;

    wire signed [15:0] b1;
    wire signed [15:0] b2;
    wire signed [15:0] mb;
    wire signed [15:0] mc;
    wire signed [15:0] md;


    bmp085_i2c #(
        .ENABLE_CALIBRATION(1'b1)
    ) dut (
        .clk          (clk),
        .i2c_sda      (i2c_sda),
        .i2c_scl      (i2c_scl),

        .chip_id      (chip_id),
        .sensor_ok    (sensor_ok),
        .calibracao_ok(calibracao_ok),

        .ac1(ac1),
        .ac2(ac2),
        .ac3(ac3),

        .ac4(ac4),
        .ac5(ac5),
        .ac6(ac6),

        .b1(b1),
        .b2(b2),
        .mb(mb),
        .mc(mc),
        .md(md)
    );


    logic [7:0] calib [0:21];


    task automatic falha(input string msg);
        begin
            $display("FAIL BMP085 CALIB: %s", msg);
            $fatal(1);
        end
    endtask


    task automatic espera_start;
        begin
            @(negedge i2c_sda);

            #1;

            if (i2c_scl !== 1'b1)
                falha("START com SCL baixo");
        end
    endtask


    task automatic recebe_byte(
        output logic [7:0] valor
    );

        integer i;

        begin
            valor = 8'h00;

            for (i = 7; i >= 0; i = i - 1) begin

                @(posedge i2c_scl);

                #100;

                valor[i] = i2c_sda;

                @(negedge i2c_scl);

            end
        end
    endtask


    task automatic envia_ack;
        begin

            slave_sda_low = 1'b1;

            @(posedge i2c_scl);

            #100;

            @(negedge i2c_scl);

            slave_sda_low = 1'b0;

        end
    endtask


    task automatic envia_byte(
        input logic [7:0] valor
    );

        integer i;

        begin

            for (i = 7; i >= 0; i = i - 1) begin

                slave_sda_low = ~valor[i];

                @(posedge i2c_scl);

                #100;

                @(negedge i2c_scl);

            end

            slave_sda_low = 1'b0;

        end
    endtask


    task automatic recebe_nack;
        begin

            slave_sda_low = 1'b0;

            @(posedge i2c_scl);

            #100;

            if (i2c_sda !== 1'b1)
                falha("master deveria enviar NACK");

            @(negedge i2c_scl);

        end
    endtask


    task automatic espera_stop;
        begin

            @(posedge i2c_sda);

            #100;

            if (i2c_scl !== 1'b1)
                falha("STOP com SCL baixo");

        end
    endtask


    task automatic responde_registro(
        input logic [7:0] reg_addr,
        input logic [7:0] valor
    );

        logic [7:0] recebido;

        begin

            espera_start();

            recebe_byte(recebido);

            if (recebido !== 8'hEE)
                falha("endereco WRITE deveria ser 0xEE");

            envia_ack();


            recebe_byte(recebido);

            if (recebido !== reg_addr) begin

                $display(
                    "esperado reg=%02h recebido=%02h",
                    reg_addr,
                    recebido
                );

                falha("registrador incorreto");
            end

            envia_ack();


            espera_start();

            recebe_byte(recebido);

            if (recebido !== 8'hEF)
                falha("endereco READ deveria ser 0xEF");

            envia_ack();


            envia_byte(valor);

            recebe_nack();

            espera_stop();

        end
    endtask


    initial begin

        // =================================================
        // Exemplo oficial do datasheet BMP085.
        // EEPROM 0xAA .. 0xBF, MSB primeiro.
        // =================================================

        calib[0]  = 8'h01; // AC1 = 0x0198 = 408
        calib[1]  = 8'h98;

        calib[2]  = 8'hFF; // AC2 = -72
        calib[3]  = 8'hB8;

        calib[4]  = 8'hC7; // AC3 = -14383
        calib[5]  = 8'hD1;

        calib[6]  = 8'h7F; // AC4 = 32741
        calib[7]  = 8'hE5;

        calib[8]  = 8'h7F; // AC5 = 32757
        calib[9]  = 8'hF5;

        calib[10] = 8'h5A; // AC6 = 23153
        calib[11] = 8'h71;

        calib[12] = 8'h18; // B1 = 6190
        calib[13] = 8'h2E;

        calib[14] = 8'h00; // B2 = 4
        calib[15] = 8'h04;

        calib[16] = 8'h80; // MB = -32768
        calib[17] = 8'h00;

        calib[18] = 8'hDD; // MC = -8711
        calib[19] = 8'hF9;

        calib[20] = 8'h0B; // MD = 2868
        calib[21] = 8'h34;


        $display(
            "===== TESTE BMP085 CALIBRACAO ====="
        );


        // Evita os 100 ms iniciais na simulacao.
        force dut.idle_count = 16'd0;

        wait (dut.state != 0);

        release dut.idle_count;


        // Primeiro: CHIP_ID.
        responde_registro(
            8'hD0,
            8'h55
        );

        // O DUT publica CHIP_ID em ST_STOP_RELEASE,
        // alguns clocks depois da borda fisica de STOP.
        repeat (1000)
            @(posedge clk);


        if (chip_id !== 8'h55)
            falha("CHIP_ID nao publicado");

        if (sensor_ok !== 1'b1)
            falha("sensor_ok deveria estar ativo");


        // Agora a EEPROM completa.
        for (integer i = 0; i < 22; i = i + 1) begin

            responde_registro(
                8'hAA + i,
                calib[i]
            );

        end


        wait (calibracao_ok === 1'b1);

        repeat (20)
            @(posedge clk);


        // =================================================
        // Verificacao exata dos 11 coeficientes.
        // =================================================

        if (ac1 !== 16'h0198)
            falha("AC1 incorreto");

        if (ac2 !== 16'hFFB8)
            falha("AC2 incorreto");

        if (ac3 !== 16'hC7D1)
            falha("AC3 incorreto");

        if (ac4 !== 16'h7FE5)
            falha("AC4 incorreto");

        if (ac5 !== 16'h7FF5)
            falha("AC5 incorreto");

        if (ac6 !== 16'h5A71)
            falha("AC6 incorreto");

        if (b1 !== 16'h182E)
            falha("B1 incorreto");

        if (b2 !== 16'h0004)
            falha("B2 incorreto");

        if (mb !== 16'h8000)
            falha("MB incorreto");

        if (mc !== 16'hDDF9)
            falha("MC incorreto");

        if (md !== 16'h0B34)
            falha("MD incorreto");


        $display("PASS CHIP_ID = 0x55");

        $display(
            "PASS AC1=%0d AC2=%0d AC3=%0d",
            $signed(ac1),
            $signed(ac2),
            $signed(ac3)
        );

        $display(
            "PASS AC4=%0d AC5=%0d AC6=%0d",
            ac4,
            ac5,
            ac6
        );

        $display(
            "PASS B1=%0d B2=%0d MB=%0d MC=%0d MD=%0d",
            $signed(b1),
            $signed(b2),
            $signed(mb),
            $signed(mc),
            $signed(md)
        );

        $display(
            "PASS todos os 11 coeficientes BMP085"
        );

        $finish;

    end


    initial begin

        #100_000_000;

        falha(
            "timeout global da calibracao"
        );

    end

endmodule
