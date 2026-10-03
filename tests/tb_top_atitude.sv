`timescale 1ns/1ps
module tb_top_atitude;
    logic clk = 0;
    always #5 clk = ~clk;
    logic [15:12] sw = 0;
    tri1 sda, scl;
    integer modo;
    integer pitch_esperado, roll_esperado;

    top_reticula dut (
        .clk(clk), .btn_heading(2'b00), .sw(sw), .display_mode(1'b0),
        .vauxp3(1'b0), .vauxn3(1'b0), .vauxp10(1'b0), .vauxn10(1'b0),
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
        force dut.joystick_x_mais = 1'b1;
        force dut.joystick_x_menos = 1'b0;
        force dut.joystick_y_mais = 1'b0;
        force dut.joystick_y_menos = 1'b1;
        force dut.u_sensor.sensor_ok = 1'b0;
        force dut.u_sensor.amostra_nova = 1'b0;
        force dut.u_sensor.accel_x = 16'sd0;
        force dut.u_sensor.accel_y = 16'sd0;
        force dut.u_sensor.accel_z = 16'sd16384;
        seleciona(4'b1111);
        confere(40, -64);
        force dut.u_sensor.sensor_ok = 1'b1;
        repeat (63) amostra();
        confere(40, -64);
        if (dut.atitude_calibrada !== 1'b0)
            $fatal(1, "calibracao antecipada");
        amostra();
        confere(0, 0);
        if (dut.atitude_calibrada !== 1'b1)
            $fatal(1, "calibracao nao concluiu com 64 amostras");

        force dut.u_sensor.accel_x = -16'sd4096;
        force dut.u_sensor.accel_y = 16'sd8192;
        // Sem pulso, a atitude deve permanecer inalterada.
        repeat (3) @(negedge clk);
        confere(0, 0);
        amostra();
        confere(16, 16);

        // Somente 1111 deve sobrepor o joystick.
        for (modo = 0; modo < 16; modo = modo + 1) begin
            seleciona(modo[3:0]);
            if (modo == 15) confere(16, 16);
            else confere(40, -64);
        end

        force dut.joystick_x_mais = 1'b0;
        force dut.joystick_y_menos = 1'b0;
        for (modo = 0; modo < 16; modo = modo + 1) begin
            seleciona(modo[3:0]);
            case (modo & 3)
                1: pitch_esperado = -40;
                2: pitch_esperado = 40;
                default: pitch_esperado = 0;
            endcase
            case (modo >> 2)
                1: roll_esperado = -64;
                2: roll_esperado = 64;
                default: roll_esperado = 0;
            endcase
            if (modo == 15) confere(16, 16);
            else confere(pitch_esperado, roll_esperado);
        end
        force dut.joystick_x_menos = 1'b1;
        force dut.joystick_y_mais = 1'b1;
        force dut.u_sensor.sensor_ok = 1'b0;
        confere(-40, 64);
        @(negedge clk);
        force dut.u_sensor.sensor_ok = 1'b1;
        confere(-40, 64);
        $display("PASS top: 16 modos, joystick, switches, calibracao, pulso e perda do sensor");
        $finish;
    end
endmodule
