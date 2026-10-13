`timescale 1ns/1ps
module tb_hud_joystick_vertical;
    logic clk=0, estilo=0;
    always #5 clk=~clk;
    logic [11:0] adc_x=2048, adc_y=2048;
    tri1 mpu_sda,mpu_scl,baro_sda,baro_scl,mag_sda,mag_scl;
    wire [3:0] leds;
    integer y_antes,x_antes;
    top_reticula #(.MIRA_TICK(1),.MIRA_DEBOUNCE(3)) dut(
        .clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),.btn_heading(2'b00),
        .sw(7'b0000000),.display_mode(1'b0),.style_mode(estilo),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),
        .joystick_sw_n(1'b1),.JOY_LED(leds),
        .i2c_sda(mpu_sda),.i2c_scl(mpu_scl),.baro_sda(baro_sda),
        .baro_scl(baro_scl),.mag_sda(mag_sda),.mag_scl(mag_scl));
    defparam dut.u_mira.CALIB_BITS=3;
    defparam dut.u_marcador_joystick.CALIB_BITS=3;
    defparam dut.u_controle_joystick.CALIB_BITS=3;
    task automatic ciclos(input integer n); repeat(n) @(negedge clk); endtask
    initial begin
        force dut.estilo_caca_sync=estilo;
        force dut.joystick_x_raw=adc_x;
        force dut.joystick_y_raw=adc_y;
        ciclos(80);
        if(dut.alvo_y_origem!=180 || dut.alvo_x_origem!=430)
            $fatal(1,"Centro NORMAL mudou: %0d,%0d",dut.alvo_x_origem,dut.alvo_y_origem);
        adc_x=0; ciclos(6);
        if(dut.alvo_y_origem<=180 || dut.alvo_x_origem!=430 || !leds[3])
            $fatal(1,"NORMAL: ADC X=0 deveria mover para baixo e manter X");
        adc_x=2048; ciclos(3); y_antes=dut.alvo_y_origem;
        ciclos(6); if(dut.alvo_y_origem!=y_antes) $fatal(1,"Centro vertical moveu");
        adc_x=4095; ciclos(6);
        if(dut.alvo_y_origem>=y_antes || !leds[2]) $fatal(1,"NORMAL: ADC X=4095 deveria mover para cima");
        adc_x=2048; ciclos(3); x_antes=dut.alvo_x_origem;
        adc_y=4095; ciclos(6);
        if(dut.alvo_x_origem<=x_antes) $fatal(1,"Horizontal direita alterada");
        adc_y=2048; ciclos(3); x_antes=dut.alvo_x_origem;
        adc_y=0; ciclos(6);
        if(dut.alvo_x_origem>=x_antes) $fatal(1,"Horizontal esquerda alterada");
        adc_y=2048; ciclos(3); estilo=1; ciclos(80);
        if(dut.mira_y_origem!=240 || dut.mira_x_origem!=320) $fatal(1,"Centro CACA mudou: x=%0d y=%0d cx=%0d cy=%0d rawy=%0d estilo=%b",dut.mira_x_origem,dut.mira_y_origem,dut.u_mira.center_x,dut.u_mira.center_y,dut.joystick_vertical_raw,dut.estilo_caca_sync);
        adc_x=0; ciclos(6);
        if(dut.mira_y_origem<=240 || dut.mira_x_origem!=320) $fatal(1,"CACA: ADC X=0 deveria mover para baixo");
        adc_x=2048; ciclos(3); y_antes=dut.mira_y_origem;
        adc_x=4095; ciclos(6);
        if(dut.mira_y_origem>=y_antes) $fatal(1,"CACA: ADC X=4095 deveria mover para cima");
        $display("PASS: vertical invertido em NORMAL/CACA, horizontal preservado, centro e LEDs corretos");
        $finish;
    end
endmodule
