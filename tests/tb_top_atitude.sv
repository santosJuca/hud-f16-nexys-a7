`timescale 1ns/1ps
module tb_top_atitude;
    logic clk = 0;
    always #5 clk = ~clk;
    logic [15:12] sw = 0;
    tri1 sda, scl;
    integer modo;
    integer pitch_esperado, roll_esperado;

    // Regressao da configuracao anterior; modos novos tem banco integrado proprio.
    top_reticula #(.MODOS_OPERACIONAIS(1'b0)) dut (
        .operacao_sw(2'b00),.ack_btn(1'b0),.clk(clk), .btn_heading(2'b00), .sw(sw), .display_mode(1'b0),
        .style_mode(1'b0),
        .vauxp3(1'b0), .vauxn3(1'b0), .vauxp10(1'b0), .vauxn10(1'b0),
        .joystick_sw_n(1'b1),
        .i2c_sda(sda), .i2c_scl(scl)
    );

    task automatic confere(input integer pitch, roll);
        #1;
        if ($signed(dut.pitch_px_entrada) !== pitch ||
            $signed(dut.roll_q8_entrada) !== roll)
            $fatal(1, "sw=%b: pitch=%0d roll=%0d esperado=%0d/%0d",
                sw, $signed(dut.pitch_px_entrada),
                $signed(dut.roll_q8_entrada), pitch, roll);
    endtask

    task automatic seleciona(input logic [3:0] valor);
        @(negedge clk);
        sw = valor;
        repeat (3) @(negedge clk);
    endtask

    task automatic amostra;
        @(negedge clk);
        force dut.u_sensor.amostra_nova = 1'b1;
        @(negedge clk);
        force dut.u_sensor.amostra_nova = 1'b0;
    endtask

    initial begin
        // Isola as entradas analogicas e I2C; usa o estimador real do top.
        force dut.u_sensor.sensor_ok = 1'b0;
        force dut.u_sensor.amostra_nova = 1'b0;
        force dut.u_sensor.accel_x = 16'sd0;
        force dut.u_sensor.accel_y = 16'sd0;
        force dut.u_sensor.accel_z = 16'sd16384;

        // Bias conhecido para validar o observador do giroscopio.
        force dut.u_sensor.gyro_x = 16'sd100;
        force dut.u_sensor.gyro_y = -16'sd50;
        seleciona(4'b1111);
        confere(0, 0);
        force dut.u_sensor.sensor_ok = 1'b1;
        repeat (63) amostra();
        confere(0, 0);
        if (dut.atitude_calibrada !== 1'b0)
            $fatal(1, "calibracao antecipada");
        amostra();

        // A calibracao do acelerometro e do bias do gyro
        // termina nesta amostra, mas a fusao ainda nao
        // recebeu uma atualizacao temporal valida.
        //
        // Portanto o modo SENSOR ainda NAO deve assumir a fusao.
        // Os switches permanecem como fallback de bancada.
        confere(0, 0);

        if (dut.atitude_calibrada !== 1'b1)
            $fatal(1, "calibracao nao concluiu com 64 amostras");

        if (dut.gyro_bias_calibrado !== 1'b1)
            $fatal(1, "bias do giroscopio nao calibrou com 64 amostras");

        if (dut.fusao_valida !== 1'b0)
            $fatal(1, "fusao nao deveria estar valida imediatamente apos calibracao");

        if (dut.usar_mpu !== 1'b0)
            $fatal(1, "modo MPU nao deveria assumir HUD antes da fusao valida");

        if ($signed(dut.gyro_bias_x) !== 100 ||
            $signed(dut.gyro_bias_y) !== -50)
            $fatal(
                1,
                "bias do giroscopio incorreto: x=%0d y=%0d",
                $signed(dut.gyro_bias_x),
                $signed(dut.gyro_bias_y)
            );

        // A correcao deve existir no caminho real sem alterar o HUD.
        force dut.u_sensor.gyro_x = 16'sd125;
        force dut.u_sensor.gyro_y = -16'sd20;
        #1;

        if ($signed(dut.gyro_x_corr) !== 25 ||
            $signed(dut.gyro_y_corr) !== 30)
            $fatal(
                1,
                "gyro corrigido incorreto no top: x=%0d y=%0d",
                $signed(dut.gyro_x_corr),
                $signed(dut.gyro_y_corr)
            );

        // -------------------------------------------------
        // Valida a cadeia completa do observador do gyro.
        //
        // Primeiro cria a referencia temporal com o sensor
        // exatamente no bias.
        // -------------------------------------------------

        force dut.u_sensor.gyro_x = 16'sd100;
        force dut.u_sensor.gyro_y = -16'sd50;

        amostra();

        // Neste ponto o gyro ainda deve estar em zero.
        if ($signed(dut.gyro_pitch_q10) !== 0 ||
            $signed(dut.gyro_roll_q10) !== 0)
            $fatal(
                1,
                "angulo do gyro deveria iniciar em zero: pitch=%0d roll=%0d",
                $signed(dut.gyro_pitch_q10),
                $signed(dut.gyro_roll_q10)
            );

        // Cria um intervalo conhecido antes da proxima
        // amostra. O valor elevado do gyro permite observar
        // movimento sem tornar a simulacao excessivamente longa.
        repeat (120000) @(posedge clk);

        // Bias:
        //   X = +100
        //   Y = -50
        //
        // Valores abaixo resultam em:
        //   gyro_x_corr = +30000
        //   gyro_y_corr = +30000
        force dut.u_sensor.gyro_x = 16'sd30100;
        force dut.u_sensor.gyro_y = 16'sd29950;

        amostra();

        // Aguarda os dois pipelines concluirem a nova
        // amostra angular.
        wait (
            dut.gyro_pitch_atualizado &&
            dut.gyro_roll_atualizado
        );
        #1;

        if ($signed(dut.gyro_pitch_q10) <= 0 ||
            $signed(dut.gyro_roll_q10) <= 0)
            $fatal(
                1,
                "observador gyro nao integrou: pitch=%0d roll=%0d",
                $signed(dut.gyro_pitch_q10),
                $signed(dut.gyro_roll_q10)
            );

        if ($signed(dut.gyro_pitch_px) <= 0 ||
            $signed(dut.gyro_roll_q8) <= 0)
            $fatal(
                1,
                "conversao gyro->HUD nao ocorreu: pitch_px=%0d roll_q8=%0d",
                $signed(dut.gyro_pitch_px),
                $signed(dut.gyro_roll_q8)
            );

        // Os dois integradores concluiram a nova amostra.
        // fusao_atualizar fica ativo pelo handshake e a fusao
        // consome esse pulso na proxima borda de clock.
        //
        // Na PRIMEIRA atualizacao a fusao apenas estabelece
        // sua referencia:
        //
        //   atitude inicial <- acelerometro
        //   gyro anterior   <- gyro atual
        //
        // Portanto, como o acelerometro ainda esta em zero,
        // a fusao deve iniciar em zero mesmo que o gyro ja
        // tenha integrado o primeiro intervalo.
        @(posedge clk);
        #1;

        if (dut.fusao_valida !== 1'b1)
            $fatal(1, "fusao complementar deveria estar valida");

        if ($signed(dut.fusao_pitch_q10) !== 0 ||
            $signed(dut.fusao_roll_q10) !== 0)
            $fatal(
                1,
                "fusao deveria iniciar pela referencia accel: pitch=%0d roll=%0d",
                $signed(dut.fusao_pitch_q10),
                $signed(dut.fusao_roll_q10)
            );

        if ($signed(dut.fusao_pitch_px) !== 0 ||
            $signed(dut.fusao_roll_q8) !== 0)
            $fatal(
                1,
                "saida HUD da fusao deveria iniciar em zero: pitch=%0d roll=%0d",
                $signed(dut.fusao_pitch_px),
                $signed(dut.fusao_roll_q8)
            );

        $display(
            "PASS inicializacao fusao: gyro=%0d/%0d fusao=0/0",
            $signed(dut.gyro_pitch_q10),
            $signed(dut.gyro_roll_q10)
        );

        // -------------------------------------------------
        // Segunda amostra com movimento.
        //
        // Agora existe uma referencia anterior do gyro.
        // A fusao deve usar o incremento angular entre as
        // duas amostras e aplicar a pequena correcao do
        // acelerometro.
        // -------------------------------------------------

        repeat (120000) @(posedge clk);

        // Mantem o mesmo movimento:
        //
        // gyro_x_corr = +30000
        // gyro_y_corr = +30000
        amostra();

        // Aguarda pitch e roll concluirem o pipeline.
        wait (
            dut.gyro_pitch_atualizado &&
            dut.gyro_roll_atualizado
        );
        #1;

        // Primeiro clock apos a conclusao do gyro:
        // a fusao captura a predicao no primeiro estagio.
        @(posedge clk);
        #1;

        // Segundo clock:
        // a fusao aplica a correcao complementar e atualiza
        // suas saidas registradas.
        @(posedge clk);
        #1;

        if ($signed(dut.gyro_pitch_q10) <= 281 ||
            $signed(dut.gyro_roll_q10) <= 281)
            $fatal(
                1,
                "gyro nao acumulou segunda amostra: pitch=%0d roll=%0d",
                $signed(dut.gyro_pitch_q10),
                $signed(dut.gyro_roll_q10)
            );

        if ($signed(dut.fusao_pitch_q10) <= 0 ||
            $signed(dut.fusao_pitch_q10) >=
                $signed(dut.gyro_pitch_q10))
            $fatal(
                1,
                "fusao pitch incoerente: fusao=%0d gyro=%0d",
                $signed(dut.fusao_pitch_q10),
                $signed(dut.gyro_pitch_q10)
            );

        if ($signed(dut.fusao_roll_q10) <= 0 ||
            $signed(dut.fusao_roll_q10) >=
                $signed(dut.gyro_roll_q10))
            $fatal(
                1,
                "fusao roll incoerente: fusao=%0d gyro=%0d",
                $signed(dut.fusao_roll_q10),
                $signed(dut.gyro_roll_q10)
            );

        if ($signed(dut.fusao_pitch_px) <= 0 ||
            $signed(dut.fusao_roll_q8) <= 0)
            $fatal(
                1,
                "fusao nao converteu para HUD: pitch=%0d roll=%0d",
                $signed(dut.fusao_pitch_px),
                $signed(dut.fusao_roll_q8)
            );

        $display(
            "PASS fusao observadora: gyro=%0d/%0d fusao=%0d/%0d HUD=%0d/%0d",
            $signed(dut.gyro_pitch_q10),
            $signed(dut.gyro_roll_q10),
            $signed(dut.fusao_pitch_q10),
            $signed(dut.fusao_roll_q10),
            $signed(dut.fusao_pitch_px),
            $signed(dut.fusao_roll_q8)
        );

        // A fusao agora controla efetivamente o modo MPU.
        if (dut.usar_mpu !== 1'b1)
            $fatal(1, "modo MPU deveria usar a fusao valida");

        confere(
            $signed(dut.fusao_pitch_px),
            $signed(dut.fusao_roll_q8)
        );

        if ($signed(dut.pitch_px_entrada) !==
                $signed(dut.fusao_pitch_px) ||
            $signed(dut.roll_q8_entrada) !==
                $signed(dut.fusao_roll_q8))
            $fatal(
                1,
                "HUD nao esta recebendo a fusao: entrada=%0d/%0d fusao=%0d/%0d",
                $signed(dut.pitch_px_entrada),
                $signed(dut.roll_q8_entrada),
                $signed(dut.fusao_pitch_px),
                $signed(dut.fusao_roll_q8)
            );

        $display(
            "PASS fusao ativa no HUD: pitch=%0d roll=%0d",
            $signed(dut.fusao_pitch_px),
            $signed(dut.fusao_roll_q8)
        );

        $display(
            "PASS observador gyro: pitch_q10=%0d roll_q10=%0d pitch_px=%0d roll_q8=%0d",
            $signed(dut.gyro_pitch_q10),
            $signed(dut.gyro_roll_q10),
            $signed(dut.gyro_pitch_px),
            $signed(dut.gyro_roll_q8)
        );

        // Volta o gyro ao bias para o restante do teste.
        force dut.u_sensor.gyro_x = 16'sd100;
        force dut.u_sensor.gyro_y = -16'sd50;

        force dut.u_sensor.accel_x = -16'sd4096;
        force dut.u_sensor.accel_y = 16'sd8192;
        // Sem nova amostra, a fusao deve permanecer retida.
        repeat (3) @(negedge clk);

        confere(
            $signed(dut.fusao_pitch_px),
            $signed(dut.fusao_roll_q8)
        );

        amostra();

        // Permite que acelerometro, integrador e fusao
        // atravessem seus respectivos ciclos sequenciais.
        repeat (4) @(posedge clk);
        #1;

        if (dut.usar_mpu !== 1'b1)
            $fatal(1, "fusao deveria continuar valida no modo MPU");

        confere(
            $signed(dut.fusao_pitch_px),
            $signed(dut.fusao_roll_q8)
        );

        if ($signed(dut.pitch_px_entrada) !==
                $signed(dut.fusao_pitch_px) ||
            $signed(dut.roll_q8_entrada) !==
                $signed(dut.fusao_roll_q8))
            $fatal(1, "modo MPU deixou de encaminhar a fusao");

        // -------------------------------------------------
        // MODO SENSOR
        //
        // Com a fusao valida, os switches nao devem mais
        // selecionar o MPU. O sensor e a fonte principal
        // independentemente de SW15..SW12.
        // -------------------------------------------------

        for (modo = 0; modo < 16; modo = modo + 1) begin
            seleciona(modo[3:0]);

            if (dut.usar_mpu !== 1'b1)
                $fatal(
                    1,
                    "SENSOR valido deveria usar MPU para sw=%b",
                    sw
                );

            confere(
                $signed(dut.fusao_pitch_px),
                $signed(dut.fusao_roll_q8)
            );
        end

        $display(
            "PASS modo SENSOR: fusao MPU independente dos switches"
        );

        // Joystick desloca a mira e nao altera a atitude selecionada.
        force dut.joystick_x_raw = 12'd4095;
        force dut.joystick_y_raw = 12'd0;
        #1;
        if (dut.usar_mpu !== 1'b1)
            $fatal(1,"Movimento do joystick alterou a selecao do MPU");
        confere($signed(dut.fusao_pitch_px),$signed(dut.fusao_roll_q8));
        release dut.joystick_x_raw;
        release dut.joystick_y_raw;

        // -------------------------------------------------
        // PERDA DO SENSOR
        //
        // Em SENSOR sem MPU valido, somente os switches
        // permanecem como fallback de bancada.
        // -------------------------------------------------

        force dut.u_sensor.sensor_ok = 1'b0;
        #1;

        if (dut.usar_mpu !== 1'b0)
            $fatal(
                1,
                "MPU nao deveria ser usado apos perda do sensor"
            );

        for (modo = 0; modo < 16; modo = modo + 1) begin
            seleciona(modo[3:0]);

            case (modo & 3)
                1: pitch_esperado = -40;
                2: pitch_esperado =  40;
                default: pitch_esperado = 0;
            endcase

            case (modo >> 2)
                1: roll_esperado = -64;
                2: roll_esperado =  64;
                default: roll_esperado = 0;
            endcase

            confere(
                pitch_esperado,
                roll_esperado
            );
        end

        $display(
            "PASS fallback SENSOR: switches preservados quando MPU indisponivel"
        );

        // Sem MPU, o joystick continua sem comandar atitude; ficam os switches.
        force dut.joystick_x_raw = 12'd4095;
        force dut.joystick_y_raw = 12'd0;
        #1;
        confere(pitch_esperado,roll_esperado);
        release dut.joystick_x_raw;
        release dut.joystick_y_raw;

        // Garante que os modulos realmente enxergaram
        // a perda do sensor.
        @(posedge clk);
        #1;

        if (dut.gyro_bias_calibrado !== 1'b0)
            $fatal(
                1,
                "bias do giroscopio deveria ser invalidado"
            );

        if (dut.gyro_dt_valid !== 1'b0 ||
            dut.gyro_dt_cycles !== 32'd0)
            $fatal(
                1,
                "referencia temporal do giroscopio nao foi reiniciada"
            );

        // Ao recuperar sensor, ele precisa calibrar novamente.
        // Portanto neste instante o fallback continua sendo SW.
        @(negedge clk);
        force dut.u_sensor.sensor_ok = 1'b1;
        #1;

        confere(0, 0);

        $display("PASS top: SENSOR, joystick independente, fusao, fallback e perda do sensor");
        $finish;
    end
endmodule
