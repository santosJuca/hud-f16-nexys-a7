`timescale 1ns/1ps
`include "tests/hmc5883l_slave.svh"
module tb_top_heading;
    logic clk=0;
    always #5 clk=~clk;
    tri1 sda,scl,mpu_sda,mpu_scl,baro_sda,baro_scl;
    logic [1:0] btn=0;
    logic [15:9] sw=7'b0101000;
    wire led;
    logic presente=0;
    logic signed [15:0] mx=0,my=1000,mz=100;
    // Regressao da configuracao anterior; modos novos tem banco integrado proprio.
    top_reticula #(.MODOS_OPERACIONAIS(1'b0)) dut(.operacao_sw(2'b00),.ack_btn(1'b0),.clk(clk),.btn_heading(btn),.sw(sw),
        .display_mode(1'b0),.style_mode(1'b0),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),
        .joystick_sw_n(1'b1),.i2c_sda(mpu_sda),.i2c_scl(mpu_scl),
        .baro_sda(baro_sda),.baro_scl(baro_scl),
        .mag_sda(sda),.mag_scl(scl),.MAG_LED(led));
    defparam dut.u_heading.DEBOUNCE_CYCLES=4;
    defparam dut.u_magnetometro.STARTUP_TICKS=16'd4;
    defparam dut.u_magnetometro.POLL_TICKS=16'd40;
    defparam dut.u_magnetometro.CONFIG_WAIT=16'd4;
    hmc5883l_slave slave(sda,scl);
    initial forever begin
        if(!presente) begin
            slave.start(); slave.receive(8'h3c); slave.ack(0); slave.stop();
        end else begin
            slave.configure();
            while(presente) slave.sample(mx,my,mz,0);
        end
    end
    task automatic botao(input logic [1:0] valor);
        @(negedge clk); btn=valor;
        repeat(12) @(negedge clk);
        btn=0; repeat(12) @(negedge clk);
    endtask
    task automatic entrada(input integer esperado);
        #1;
        if(dut.heading_entrada !== 9'(esperado))
            $fatal(1,"heading entrada=%0d esperado=%0d",dut.heading_entrada,esperado);
    endtask
    task automatic quadro(input integer esperado);
        // Encurta somente o intervalo entre quadros; CDC e buffers reais.
        repeat(100) @(negedge clk);
        @(negedge dut.pixel_clk);
        force dut.u_vga.v_cont=10'd480;
        @(posedge dut.pixel_clk); #1;
        if(dut.heading_deg !== 9'(esperado))
            $fatal(1,"heading HUD=%0d esperado=%0d",dut.heading_deg,esperado);
        @(negedge dut.pixel_clk); force dut.u_vga.v_cont=10'd0;
    endtask
    logic [8:0] anterior=0;
    logic atualiza;
    always @(posedge dut.pixel_clk) begin
        atualiza=(dut.pixel_x==0 && dut.pixel_y==480);
        #1;
        if(dut.heading_deg !== anterior && !atualiza)
            $fatal(1,"heading HUD mudou fora do quadro");
        anterior=dut.heading_deg;
    end
    initial begin
        force dut.u_vga.h_cont=10'd0; force dut.u_vga.v_cont=10'd0;
        botao(1); entrada(10); quadro(10);
        if(led) $fatal(1,"MAG_LED aceso sem HMC");
        if(dut.pitch_px_entrada !== -11'sd60 || dut.roll_q8_entrada !== -10'sd112)
            $fatal(1,"fallback de atitude alterado pelo HMC ausente");
        // Aguarda fim da tentativa ausente antes de oferecer o dispositivo.
        @(posedge sda); wait(scl===1); #100; presente=1;
        wait(led); entrada(10);
        if(dut.heading_magnetico_valido) $fatal(1,"rumo valido antes da primeira amostra");
        wait(dut.heading_magnetico_valido); entrada(90);
        if(dut.heading_deg!=10) $fatal(1,"HUD mudou antes do quadro");
        quadro(90);
        botao(1); entrada(90);
        if(dut.heading_manual!=20) $fatal(1,"botao manual parou durante HMC valido");
        force dut.joystick_x_raw=12'd4095; force dut.joystick_y_raw=12'd0;
        #1;
        if(dut.pitch_px_entrada!=-60 || dut.roll_q8_entrada!=-112)
            $fatal(1,"Joystick interferiu na atitude de fallback");
        entrada(90);
        release dut.joystick_x_raw; release dut.joystick_y_raw;
        sw=7'b1111000; repeat(3) @(negedge clk);
        force dut.sensor_ok=1'b1; force dut.atitude_calibrada=1'b1;
        force dut.gyro_bias_calibrado=1'b1; force dut.fusao_valida=1'b1;
        force dut.fusao_pitch_px=-11'sd12; force dut.fusao_roll_q8=10'sd17;
        #1;
        if(!dut.usar_mpu || dut.pitch_px_entrada!=-12 || dut.roll_q8_entrada!=17)
            $fatal(1,"HMC interferiu no SENSOR");
        mx=0;my=0;
        wait(!dut.heading_magnetico_valido); entrada(20); quadro(20);
        if(!led) $fatal(1,"vetor zero confundido com perda de comunicacao");
        mx=-1000;my=0;
        wait(dut.heading_magnetico_valido); entrada(180); quadro(180);
        mz=-4096;
        wait(!dut.heading_magnetico_valido); entrada(20); quadro(20);
        mz=100;
        wait(dut.heading_magnetico_valido); entrada(180); quadro(180);
        presente=0;
        wait(!led); entrada(20); quadro(20);
        if(!dut.usar_mpu) $fatal(1,"perda do HMC invalidou MPU");
        botao(2); entrada(10); quadro(10);
        // Recuperacao exige ID, configuracao e amostra nova.
        #10_000; presente=1;
        wait(led); entrada(10);
        wait(dut.heading_magnetico_valido); entrada(180); quadro(180);
        $display("PASS top: rumo magnético e CDC; joystick independente, botoes, perdas, recuperacao e estabilidade de quadro");
        $finish;
    end
    initial begin #20_000_000; $fatal(1,"timeout top heading"); end
endmodule
