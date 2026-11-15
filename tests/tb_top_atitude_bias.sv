`timescale 1ns/1ps
module tb_top_atitude_bias #(parameter bit ROTATED=0, FRONT_REVERSED=0);
    reg clk=0;
    always #5 clk=~clk;
    reg [15:9] switches=7'b1111000;
    tri1 sda,scl,baro_sda,baro_scl,mag_sda,mag_scl;
    localparam integer SINAL=FRONT_REVERSED ? -1 : 1;
    localparam integer MAG_ESPERADO=ROTATED ? (FRONT_REVERSED ? 90 : 270) : (FRONT_REVERSED ? 180 : 0);
    top_reticula #(.MPU_GIRO_ESQUERDA_90(ROTATED),.FRENTE_INVERTIDA_180(FRONT_REVERSED),
        .MAG_TROCAR_XY(ROTATED),.MAG_INVERTER_Y(ROTATED)) dut(.clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),.btn_heading(2'b00),
        .sw(switches),.display_mode(1'b0),.style_mode(1'b0),.VIDEO_TOGGLE_BUTTON(1'b0),
        .SD_DIAG_PAGE(4'd0),.SD_READ_SWITCH(1'b0),.SD_DAT0(1'b1),.SD_CD(1'b1),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(sda),.i2c_scl(scl),.baro_sda(baro_sda),.baro_scl(baro_scl),.mag_sda(mag_sda),.mag_scl(mag_scl));
    task automatic measurement;
        repeat(900) @(negedge clk);
        force dut.u_sensor.amostra_nova=1'b1;@(negedge clk);
        force dut.u_sensor.amostra_nova=1'b0;
        repeat(99) @(negedge clk);
    endtask
    initial begin
        // Injeta somente as amostras do driver; estimador, validade e HUD sao reais.
        force dut.u_sensor.sensor_ok=1'b1;
        force dut.u_sensor.amostra_nova=1'b0;
        force dut.u_sensor.accel_x=-16'sd640;
        force dut.u_sensor.accel_y=-16'sd1152;
        force dut.u_sensor.accel_z=16'sd16512;
        force dut.u_sensor.gyro_x=-16'sd384;
        force dut.u_sensor.gyro_y=16'sd1573;
        force dut.u_sensor.gyro_z=-16'sd128;
        wait(!dut.reset_operacao);
        repeat(3) measurement();
        repeat(2) @(posedge dut.vsync);
        if(dut.attitude_status[5:0]!=6'h20 || !dut.attitude_status[ROTATED ? 9 : 10])
            $fatal(1,"Causa da calibracao bloqueada nao chegou ao painel VGA");
        force dut.u_sensor.gyro_y=16'sd1152;
        #1;
        if(dut.mpu_accel_x!=SINAL*(ROTATED ? 1152 : -640) || dut.mpu_accel_y!=SINAL*(ROTATED ? -640 : -1152) ||
           dut.mpu_accel_z!=16512 || dut.mpu_gyro_x!=SINAL*(ROTATED ? -1152 : -384) ||
           dut.mpu_gyro_y!=SINAL*(ROTATED ? -384 : 1152) || dut.mpu_gyro_z!=-128)
            $fatal(1,"Mapeamento da montagem incorreto");
        repeat(70) measurement();
        if(!dut.vector_calibrated || !dut.vector_valid || !dut.usar_mpu || !dut.metadados_operacao[3])
            $fatal(1,"MPU com bias de bancada nao chegou valido ao HUD");
        if(dut.metadados_operacao[5]) $fatal(1,"Heading sem magnetometro foi marcado valido");
        repeat(2) @(posedge dut.vsync);
        if(!dut.hud_metadados[3] || dut.hud_metadados[5])
            $fatal(1,"Validade de ATT/HDG nao atravessou o CDC ate a VGA");
        if(dut.attitude_status[31:6]!=0) $fatal(1,"Diagnostico nao limpou apos calibracao");
        // A posicao inicial e zerada pelo estimador; verifica movimento posterior.
        force dut.u_sensor.accel_x=16'sd1200;
        force dut.u_sensor.accel_y=16'sd800;
        repeat(70) measurement();
        if((dut.vector_pitch>0)!=(!FRONT_REVERSED) ||
           (dut.vector_roll>0)!=(ROTATED ^ FRONT_REVERSED))
            $fatal(1,"Sinais de pitch/roll nao acompanharam a frente selecionada");
        $display("PASS top bias: estimador real, fonte MPU e ATT validos; HDG ausente continua invalido");
        switches[9]=1;repeat(100) @(negedge clk);
        if(dut.vector_valid || dut.metadados_operacao[3]) $fatal(1,"SW9 nao invalidou a atitude");
        switches[9]=0;repeat(70) measurement();
        if(!dut.vector_valid || !dut.metadados_operacao[3]) $fatal(1,"Recalibracao apos SW9 falhou");
        $display("PASS top bias: desabilitacao por SW9 e recalibracao preservadas");
        force dut.u_magnetometro.sensor_ok=1'b1;
        force dut.u_magnetometro.mag_x=16'sd1000;
        force dut.u_magnetometro.mag_y=16'sd0;
        force dut.u_magnetometro.mag_z=16'sd300;
        force dut.u_magnetometro.amostra_nova=1'b1;
        @(negedge clk);
        force dut.u_magnetometro.amostra_nova=1'b0;
        repeat(40) @(negedge clk);
        if(!dut.heading_magnetico_valido || dut.heading_magnetico_deg!=MAG_ESPERADO)
            $fatal(1,"Rumo nao acompanhou a frente: obtido %0d esperado %0d",dut.heading_magnetico_deg,MAG_ESPERADO);
        force dut.u_sensor.accel_x=16'sh8000;
        force dut.u_sensor.accel_y=16'sh8000;
        force dut.u_sensor.gyro_x=16'sh8000;
        force dut.u_sensor.gyro_y=16'sh8000;
        #1;
        if(dut.mpu_accel_x!=((ROTATED ^ FRONT_REVERSED) ? 32767 : -32768) ||
           dut.mpu_gyro_x!=((ROTATED ^ FRONT_REVERSED) ? 32767 : -32768) ||
           dut.mpu_accel_y!=(FRONT_REVERSED ? 32767 : -32768) ||
           dut.mpu_gyro_y!=(FRONT_REVERSED ? 32767 : -32768))
            $fatal(1,"Extremos inteiros corrompidos pela composicao das rotacoes");
        $display("PASS montagem, pitch/roll, rumo e motivos no CDC: ROTATED=%0d FRONT_REVERSED=%0d",ROTATED,FRONT_REVERSED);
        $finish;
    end
    initial begin #100000000; $fatal(1,"Timeout top bias"); end
endmodule
