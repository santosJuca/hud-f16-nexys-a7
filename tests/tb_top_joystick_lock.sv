`timescale 1ns/1ps
module tb_top_joystick_lock;
    logic clk=0;
    always #5 clk=~clk;
    logic modo_caca=0, sw_n=1;
    logic [11:0] adc_x=2047, adc_y=2048;
    integer x_antes, y_antes, dx, dy;
    tri1 mpu_sda,mpu_scl,baro_sda,baro_scl,mag_sda,mag_scl;

    top_reticula #(.MIRA_TICK(20),.MIRA_DEBOUNCE(3)) dut(
        .clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),
        .btn_heading(2'b00),.sw(7'b0000000),
        .display_mode(1'b0),.style_mode(modo_caca),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),
        .joystick_sw_n(sw_n),.i2c_sda(mpu_sda),.i2c_scl(mpu_scl),
        .baro_sda(baro_sda),.baro_scl(baro_scl),
        .mag_sda(mag_sda),.mag_scl(mag_scl));
    defparam dut.u_estilo.DEBOUNCE_CYCLES=3;
    defparam dut.u_mira.CALIB_BITS=3;
    defparam dut.u_marcador_joystick.CALIB_BITS=3;

    task automatic ciclos(input integer n);
        repeat(n) @(negedge clk);
    endtask
    task automatic botao;
        sw_n=0; ciclos(12); sw_n=1; ciclos(12);
    endtask
    task automatic centro;
        adc_x=2047; adc_y=2048; ciclos(4);
    endtask

    task automatic quadro;
        @(negedge dut.pixel_clk);
        force dut.u_vga.h_cont=0; force dut.u_vga.v_cont=480;
        @(negedge dut.pixel_clk);
        force dut.u_vga.h_cont=100; force dut.u_vga.v_cont=100;
        ciclos(8);
    endtask
    task automatic estilo(input logic novo);
        modo_caca=novo; ciclos(40); quadro();
        if (dut.estilo_caca_sync!==novo) $fatal(1,"Seletor real nao aplicou o estilo");
    endtask
    task automatic lock_visivel(input logic esperado);
        ciclos(100); quadro();
        if (dut.mira_lock!==esperado)
            $fatal(1,"LOCK nao chegou ao dominio de video: obtido %b esperado %b",dut.mira_lock,esperado);
    endtask

    initial begin
        // Injeta amostras digitais; os fios, a trava e o pacote sao do top real.
        force dut.u_joystick_xadc.x_raw=adc_x;
        force dut.u_joystick_xadc.y_raw=adc_y;
        force dut.u_vga.h_cont=100; force dut.u_vga.v_cont=100;
        ciclos(40);
        if (dut.alvo_x_origem!=430 || dut.alvo_y_origem!=180)
            $fatal(1,"NORMAL saiu do centro sem comando");

        // Cada eixo sozinho deve mover apenas uma coordenada.
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_y=2600; ciclos(60);
        if (dut.alvo_x_origem-x_antes!=12 || dut.alvo_y_origem!=y_antes)
            $fatal(1,"Comando horizontal positivo gerou diagonal");
        centro();
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_y=1000; ciclos(60);
        if (x_antes-dut.alvo_x_origem!=12 || dut.alvo_y_origem!=y_antes)
            $fatal(1,"Comando horizontal negativo gerou diagonal");
        centro();
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_x=1000; ciclos(60);
        if (dut.alvo_y_origem-y_antes!=12 || dut.alvo_x_origem!=x_antes)
            $fatal(1,"Comando vertical positivo gerou diagonal");
        centro();
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_x=2600; ciclos(60);
        if (y_antes-dut.alvo_y_origem!=12 || dut.alvo_x_origem!=x_antes)
            $fatal(1,"Comando vertical negativo gerou diagonal");
        centro();

        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_y=2600; adc_x=1000; ciclos(60);
        dx=dut.alvo_x_origem-x_antes; dy=dut.alvo_y_origem-y_antes;
        if (dx!=12 || dy!=12)
            $fatal(1,"Deflexoes diferentes: obtido %0d,%0d esperado 12,12",dx,dy);
        centro();
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_y=1000; adc_x=2600; ciclos(60);
        dx=x_antes-dut.alvo_x_origem; dy=y_antes-dut.alvo_y_origem;
        if (dx!=12 || dy!=12)
            $fatal(1,"Sentidos opostos: obtido %0d,%0d esperado 12,12",dx,dy);

        botao();
        if (!dut.u_marcador_joystick.locked || !dut.mira_lock_origem || !dut.pacote_hud[38])
            $fatal(1,"NORMAL nao publicou LOCK pelo botao real");
        lock_visivel(1'b1);
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_x=0; adc_y=4095; ciclos(100);
        if (dut.alvo_x_origem!=x_antes || dut.alvo_y_origem!=y_antes)
            $fatal(1,"NORMAL moveu durante LOCK");

        estilo(1'b1);
        if (dut.mira_lock_origem) $fatal(1,"CAÇA herdou trava de NORMAL");
        botao();
        if (!dut.u_mira.locked || !dut.mira_lock_origem)
            $fatal(1,"CAÇA nao travou");
        lock_visivel(1'b1);
        x_antes=dut.mira_x_origem; y_antes=dut.mira_y_origem;
        adc_x=4095; adc_y=0; ciclos(80);
        if (dut.mira_x_origem!=x_antes || dut.mira_y_origem!=y_antes)
            $fatal(1,"CAÇA moveu durante LOCK");

        estilo(1'b0);
        if (!dut.mira_lock_origem) $fatal(1,"NORMAL perdeu trava ao trocar estilo");
        botao();
        if (dut.u_marcador_joystick.locked || dut.mira_lock_origem)
            $fatal(1,"NORMAL nao publicou UNLOCK");
        if (!dut.u_mira.locked) $fatal(1,"Botao NORMAL alterou trava inativa");
        lock_visivel(1'b0);
        x_antes=dut.alvo_x_origem; ciclos(60);
        if (dut.alvo_x_origem>=x_antes) $fatal(1,"NORMAL nao retomou movimento");

        centro();
        x_antes=dut.alvo_x_origem; y_antes=dut.alvo_y_origem;
        adc_y=2148; adc_x=1947; ciclos(80);
        if (dut.alvo_x_origem!=x_antes || dut.alvo_y_origem!=y_antes)
            $fatal(1,"Velocidade fixa ignorou deadzone");
        $display("PASS top joystick: velocidade igual com deflexoes desiguais, quatro sentidos, deadzone, LOCK/UNLOCK NORMAL e CAÇA");
        $finish;
    end
endmodule
