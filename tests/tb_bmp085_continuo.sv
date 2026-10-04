`timescale 1ns/1ps

module bmp085_continuo_caso #(
    parameter bit PRESSURE = 1'b1,
    parameter logic [15:0] INTERVAL = 16'd40000
)(output logic done = 1'b0);

    logic clk = 1'b0;

    always #5 if (!done) clk = ~clk; // 100 MHz

    tri1 i2c_sda;
    tri1 i2c_scl;

    logic slave_sda_low = 1'b0;

    assign i2c_sda =
        slave_sda_low ? 1'b0 : 1'bz;

    wire [7:0] chip_id;
    wire sensor_ok;
    wire calibracao_ok;

wire [15:0] ut_raw;
wire ut_valid;

wire [18:0] up_raw;
wire up_valid;

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
        .ENABLE_CALIBRATION(1'b1),
    .ENABLE_TEMPERATURE(1'b1),
    .ENABLE_PRESSURE(PRESSURE),
    .ENABLE_CONTINUOUS(1'b1),
    .MEASUREMENT_INTERVAL_TICKS(INTERVAL)
    ) dut (
        .clk          (clk),
        .i2c_sda      (i2c_sda),
        .i2c_scl      (i2c_scl),

        .chip_id      (chip_id),
        .sensor_ok    (sensor_ok),
        .calibracao_ok(calibracao_ok),

    .ut_raw       (ut_raw),
    .ut_valid     (ut_valid),

    .up_raw       (up_raw),
    .up_valid     (up_valid),

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
    integer id_reads = 0;
    integer calib_reads = 0;
    integer temp_commands = 0;
    integer press_commands = 0;
    time sample_time = 0;
    time ut_publish_time = 0;
    always @(ut_raw or ut_valid)
        if (ut_valid) ut_publish_time = $time;
    time cycle_start;
    logic [15:0] expected_ut;
    logic [15:0] expected_up;

time temp_cmd_stop_time;
time temp_read_start_time;
time press_cmd_stop_time;
time press_read_start_time;

    task automatic falha(input string msg);
        begin
            $display("FAIL BMP085 CONTINUO pressao=%0b: %s", PRESSURE, msg);
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
            if (reg_addr == 8'hD0) id_reads = id_reads + 1;
            if (reg_addr >= 8'hAA && reg_addr <= 8'hBF)
                calib_reads = calib_reads + 1;

        end
    endtask

task automatic recebe_comando_temperatura;

    logic [7:0] recebido;

    begin

        espera_start();
        cycle_start = $time;
        if (sample_time != 0 && cycle_start - sample_time < INTERVAL * 2500)
            falha($sformatf("intervalo obtido=%0d ns esperado>=%0d ns",
                           cycle_start - sample_time, INTERVAL * 2500));
        if (sample_time != 0)
            $display("PASS intervalo pressao=%0b obtido=%0d ns esperado>=%0d ns",
                     PRESSURE, cycle_start - sample_time, INTERVAL * 2500);
        temp_commands = temp_commands + 1;

        recebe_byte(recebido);

        if (recebido !== 8'hEE)
            falha("TEMP: endereco WRITE deveria ser 0xEE");

        envia_ack();

        recebe_byte(recebido);

        if (recebido !== 8'hF4) begin
            $display(
                "TEMP: esperado F4 recebido=%02h",
                recebido
            );
            falha("TEMP: registrador incorreto");
        end

        envia_ack();

        recebe_byte(recebido);

        if (recebido !== 8'h2E) begin
            $display(
                "TEMP: esperado 2E recebido=%02h",
                recebido
            );
            falha("TEMP: comando incorreto");
        end

        envia_ack();

        // A liberacao do SDA apos o ACK ocorre com SCL baixo
        // e nao deve ser confundida com uma condicao STOP.
        begin : espera_stop_temperatura

            logic stop_ok;

            stop_ok = 1'b0;

            while (!stop_ok) begin

                @(posedge i2c_sda);

                #100;

                if (i2c_scl === 1'b1)
                    stop_ok = 1'b1;

            end

        end

        temp_cmd_stop_time = $time;

    end

endtask

task automatic recebe_comando_pressao;

    logic [7:0] recebido;

    begin

        espera_start();

        recebe_byte(recebido);

        if (recebido !== 8'hEE)
            falha("PRESS: endereco WRITE deveria ser 0xEE");

        envia_ack();

        recebe_byte(recebido);

        if (recebido !== 8'hF4) begin

            $display(
                "PRESS: esperado F4 recebido=%02h",
                recebido
            );

            falha("PRESS: registrador incorreto");

        end

        envia_ack();

        recebe_byte(recebido);

        if (recebido !== 8'h34) begin

            $display(
                "PRESS: esperado 34 recebido=%02h",
                recebido
            );

            falha("PRESS: comando OSS=0 incorreto");

        end

        envia_ack();

        // A liberacao do SDA depois do ACK acontece
        // com SCL baixo. Esperamos um STOP verdadeiro.
        begin : espera_stop_pressao

            logic stop_ok;

            stop_ok = 1'b0;

            while (!stop_ok) begin

                @(posedge i2c_sda);

                #100;

                if (i2c_scl === 1'b1)
                    stop_ok = 1'b1;

            end

        end

        press_cmd_stop_time = $time;
        press_commands = press_commands + 1;

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

    for (integer ciclo = 0; ciclo < 2; ciclo = ciclo + 1) begin
        expected_ut = 16'h6CFA + ciclo;
        expected_up = 16'h5D23 + ciclo;
        recebe_comando_temperatura();

        // Mede do STOP do comando ao START da primeira leitura.
        fork
            begin
                @(negedge i2c_sda);
                temp_read_start_time = $time;
                if (temp_read_start_time - temp_cmd_stop_time < 4_500_000)
                    falha("TEMP: espera menor que 4,5 ms");
            end
            responde_registro(8'hF6, expected_ut[15:8]);
        join
        responde_registro(8'hF7, expected_ut[7:0]);
        // Aguarda a publicacao, inclusive quando ut_valid ja estava ativo.
        repeat (1000) @(posedge clk);
        if (ut_valid !== 1'b1 || ut_raw !== expected_ut)
            falha($sformatf("UT obtido=%0d valido=%b esperado=%0d valido=1",
                           ut_raw, ut_valid, expected_ut));

        if (PRESSURE) begin
            if (up_valid !== 1'b0)
                falha("UP deveria ficar invalido durante a nova conversao");
            recebe_comando_pressao();
            fork
                begin
                    @(negedge i2c_sda);
                    press_read_start_time = $time;
                    if (press_read_start_time - press_cmd_stop_time < 4_500_000)
                        falha("PRESS: espera menor que 4,5 ms");
                end
                responde_registro(8'hF6, expected_up[15:8]);
            join
            responde_registro(8'hF7, expected_up[7:0]);
            responde_registro(8'hF8, 8'hA5);
            wait (up_valid === 1'b1);
            #1;
            if (up_raw !== {3'b0, expected_up})
                falha($sformatf("UP obtido=%0d esperado=%0d", up_raw, expected_up));
        end
        else if (up_valid !== 1'b0)
            falha("UP deveria permanecer invalido com pressao desabilitada");

        // O proximo START deve respeitar a pausa desde a publicacao.
        sample_time = PRESSURE ? $time : ut_publish_time;
        if (sensor_ok !== 1'b1 || calibracao_ok !== 1'b1 ||
            id_reads != 1 || calib_reads != 22)
            falha("esperado sensor/calibracao validos, 1 ID e 22 bytes EEPROM");
        if ({ac1,ac2,ac3,ac4,ac5,ac6,b1,b2,mb,mc,md} !==
            176'h0198_FFB8_C7D1_7FE5_7FF5_5A71_182E_0004_8000_DDF9_0B34)
            falha("coeficientes alterados entre ciclos");
        $display("PASS CONTINUO pressao=%0b ciclo=%0d UT=%0d UP=%0d TEMP_WAIT=%0d ns PRESS_WAIT=%0d ns",
                 PRESSURE, ciclo + 1, ut_raw, up_raw,
                 temp_read_start_time - temp_cmd_stop_time,
                 PRESSURE ? press_read_start_time - press_cmd_stop_time : 0);
    end
    if (temp_commands != 2 || press_commands != (PRESSURE ? 2 : 0))
        falha("quantidade incorreta de comandos TEMP/PRESS");
    done = 1'b1;
    end
endmodule

module tb_bmp085_continuo;
    wire press_done;
    wire temp_done;
    bmp085_continuo_caso pressao (.done(press_done));
    bmp085_continuo_caso #(.PRESSURE(1'b0), .INTERVAL(16'd17))
        temperatura (.done(temp_done));

    initial begin
        wait (press_done && temp_done);
        $display("PASS BMP085 continuo: dois ciclos TEMP/PRESS, pausa de 100 ms e modo somente TEMP");
        $finish;
    end
    initial begin
        #300_000_000;
        $fatal(1, "FAIL BMP085 continuo: timeout esperado dois ciclos");
    end
endmodule
