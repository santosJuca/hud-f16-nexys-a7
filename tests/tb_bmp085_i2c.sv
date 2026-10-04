`timescale 1ns/1ps

module tb_bmp085_i2c;

    logic clk = 1'b0;

    always #5 clk = ~clk; // 100 MHz


    // Barramento I2C com pull-up.
    tri1 i2c_sda;
    tri1 i2c_scl;


    // Slave BMP085 virtual somente dirige nivel baixo.
    logic slave_sda_low = 1'b0;

    assign i2c_sda =
        slave_sda_low ? 1'b0 : 1'bz;


    wire [7:0] chip_id;
    wire       sensor_ok;


    bmp085_i2c dut (
        .clk       (clk),
        .i2c_sda   (i2c_sda),
        .i2c_scl   (i2c_scl),
        .chip_id   (chip_id),
        .sensor_ok (sensor_ok)
    );


    task automatic falha(input string msg);
        begin
            $display("FAIL BMP085: %s", msg);
            $fatal(1);
        end
    endtask


    task automatic inicia_agora;
        begin

            // Evita esperar os 100 ms de startup no testbench.
            force dut.idle_count = 16'd0;

            wait (dut.state != 0);

            release dut.idle_count;

        end
    endtask


    task automatic espera_start;
        begin

            @(negedge i2c_sda);

            #1;

            if (i2c_scl !== 1'b1)
                falha("START ocorreu com SCL baixo");

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


    task automatic envia_ack(
        input logic ack
    );
        begin

            // ACK = SDA baixo.
            slave_sda_low = ack;

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


    task automatic recebe_nack_master;
        begin

            slave_sda_low = 1'b0;

            @(posedge i2c_scl);

            #100;

            if (i2c_sda !== 1'b1)
                falha("master deveria responder NACK");

            @(negedge i2c_scl);

        end
    endtask


    task automatic espera_stop;
        begin

            @(posedge i2c_sda);

            #100;

            if (i2c_scl !== 1'b1)
                falha("STOP ocorreu com SCL baixo");

        end
    endtask


    task automatic responde_id(
        input logic [7:0] id
    );

        logic [7:0] recebido;

        begin

            espera_start();

            recebe_byte(recebido);

            if (recebido !== 8'hEE)
                falha("endereco WRITE diferente de 0xEE");

            envia_ack(1'b1);


            recebe_byte(recebido);

            if (recebido !== 8'hD0)
                falha("registrador CHIP_ID diferente de 0xD0");

            envia_ack(1'b1);


            espera_start();

            recebe_byte(recebido);

            if (recebido !== 8'hEF)
                falha("endereco READ diferente de 0xEF");

            envia_ack(1'b1);


            envia_byte(id);

            recebe_nack_master();

            espera_stop();

            repeat (1000)
                @(posedge clk);

        end
    endtask


    task automatic responde_nack_endereco;

        logic [7:0] recebido;

        begin

            espera_start();

            recebe_byte(recebido);

            if (recebido !== 8'hEE)
                falha("endereco WRITE incorreto no teste NACK");

            // NACK: deixa SDA alto.
            envia_ack(1'b0);

            espera_stop();

            repeat (1000)
                @(posedge clk);

        end
    endtask


    initial begin

        $display("===== TESTE BMP085 =====");


        // -------------------------------------------------
        // TESTE 1
        // Sensor correto: CHIP_ID = 0x55
        // -------------------------------------------------

        inicia_agora();

        responde_id(8'h55);

        if (chip_id !== 8'h55)
            falha("CHIP_ID correto nao foi publicado");

        if (sensor_ok !== 1'b1)
            falha("sensor_ok deveria ser 1 para ID 0x55");

        $display(
            "PASS BMP085: endereco 0x77 e CHIP_ID=0x55"
        );


        // -------------------------------------------------
        // TESTE 2
        // Sensor responde, mas ID esta incorreto.
        // -------------------------------------------------

        inicia_agora();

        responde_id(8'h54);

        if (chip_id !== 8'h54)
            falha("ID incorreto nao foi publicado");

        if (sensor_ok !== 1'b0)
            falha("sensor_ok deveria ser 0 para ID != 0x55");

        $display(
            "PASS BMP085: CHIP_ID incorreto detectado"
        );


        // -------------------------------------------------
        // TESTE 3
        // Dispositivo ausente / NACK no endereco.
        // -------------------------------------------------

        inicia_agora();

        responde_nack_endereco();

        if (sensor_ok !== 1'b0)
            falha("sensor_ok deveria permanecer 0 apos NACK");

        if (chip_id !== 8'h00)
            falha("chip_id deveria voltar para 0 apos NACK");

        $display(
            "PASS BMP085: NACK de endereco detectado"
        );


        $display(
            "PASS todos os testes bmp085_i2c"
        );

        $finish;

    end


    initial begin

        #20_000_000;

        falha("timeout global do testbench");

    end

endmodule
