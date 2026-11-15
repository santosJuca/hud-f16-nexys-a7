`timescale 1ns/1ps
module tb_top_mpu_orientacao #(parameter bit CORRIGIDO=1);
    logic clk=0;
    always #5 clk=~clk;
    tri1 sda,scl,baro_sda,baro_scl,mag_sda,mag_scl;
    top_reticula #(
        .MPU_GIRO_ESQUERDA_90(!CORRIGIDO),.FRENTE_INVERTIDA_180(!CORRIGIDO),
        .MAG_TROCAR_XY(0),.MAG_INVERTER_X(CORRIGIDO),.MAG_INVERTER_Y(CORRIGIDO),
        .MAG_OFFSET_X(16'sd892),.MAG_OFFSET_Y(-16'sd274),
        .MAG_GAIN_X_Q12(13'd4546),.MAG_GAIN_Y_Q12(13'd3727),.MAG_ALINHAMENTO_GRAUS(81)
    ) dut(.clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),.btn_heading(2'b00),
        .sw(7'b1111000),.display_mode(1'b0),.style_mode(1'b0),
        .VIDEO_TOGGLE_BUTTON(1'b0),.SD_DIAG_PAGE(4'd0),.SD_READ_SWITCH(1'b0),
        .SD_DAT0(1'b1),.SD_CD(1'b1),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(sda),.i2c_scl(scl),.baro_sda(baro_sda),.baro_scl(baro_scl),
        .mag_sda(mag_sda),.mag_scl(mag_scl));

    task automatic measurement;
        repeat(900) @(negedge clk);
        force dut.u_sensor.amostra_nova=1;
        @(negedge clk); force dut.u_sensor.amostra_nova=0;
        repeat(99) @(negedge clk);
    endtask

    task automatic pose(input integer position,expected_pitch,expected_roll);
        // Gravidade sintetica: replica os dois movimentos descritos pelo operador.
        case(position)
            0: begin force dut.u_sensor.accel_x=16'sd0; force dut.u_sensor.accel_y=16'sd0; end
            1: begin force dut.u_sensor.accel_x=16'sd0; force dut.u_sensor.accel_y=-16'sd3000; end
            2: begin force dut.u_sensor.accel_x=-16'sd3000; force dut.u_sensor.accel_y=16'sd0; end
            3: begin force dut.u_sensor.accel_x=16'sd0; force dut.u_sensor.accel_y=16'sd3000; end
            4: begin force dut.u_sensor.accel_x=16'sd3000; force dut.u_sensor.accel_y=16'sd0; end
        endcase
        if(position==0) force dut.u_sensor.accel_z=16'sd16384;
        else force dut.u_sensor.accel_z=16'sd16107;
        repeat(160) measurement();
        repeat(500) @(negedge clk);
        if(!dut.vector_calibrated || !dut.vector_valid || !dut.metadados_operacao[3])
            $fatal(1,"Atitude invalida na pose %0d",position);
        if(expected_pitch==0) begin
            if(dut.vector_pitch < -1024 || dut.vector_pitch > 1024)
                $fatal(1,"Pitch espurio na pose %0d: %0d",position,dut.vector_pitch);
        end else if(expected_pitch*dut.vector_pitch < 8192)
            $fatal(1,"Pitch com eixo/sinal errado na pose %0d: %0d",position,dut.vector_pitch);
        if(expected_roll==0) begin
            if(dut.vector_roll < -1024 || dut.vector_roll > 1024)
                $fatal(1,"Roll espurio na pose %0d: %0d",position,dut.vector_roll);
        end else if(expected_roll*dut.vector_roll < 8192)
            $fatal(1,"Roll com eixo/sinal errado na pose %0d: %0d",position,dut.vector_roll);
        if(expected_pitch!=0 && expected_pitch*dut.render_pitch_ready < 30)
            $fatal(1,"Sentido vertical do horizonte incorreto na pose %0d",position);
        if(expected_roll!=0 && expected_roll*dut.render_sine_ready < 1800)
            $fatal(1,"Sentido de inclinacao do horizonte incorreto na pose %0d",position);
        if(!dut.heading_magnetico_valido || dut.heading_magnetico_deg!=325)
            $fatal(1,"Correcao do MPU alterou bussola: %0d",dut.heading_magnetico_deg);
    endtask

    initial begin
        force dut.u_sensor.sensor_ok=1;
        force dut.u_sensor.amostra_nova=0;
        force dut.u_sensor.accel_x=16'sd0;
        force dut.u_sensor.accel_y=16'sd0;
        force dut.u_sensor.accel_z=16'sd16384;
        force dut.u_sensor.gyro_x=16'sd0;
        force dut.u_sensor.gyro_y=16'sd0;
        force dut.u_sensor.gyro_z=16'sd0;
        force dut.u_magnetometro.sensor_ok=1;
        force dut.u_magnetometro.mag_x=16'sd1000;
        force dut.u_magnetometro.mag_y=16'sd0;
        force dut.u_magnetometro.mag_z=16'sd300;
        force dut.u_magnetometro.amostra_nova=0;
        wait(!dut.reset_operacao);
        @(negedge clk);
        force dut.u_magnetometro.amostra_nova=1;
        @(negedge clk); force dut.u_magnetometro.amostra_nova=0;
        pose(0,0,0);
        // Antes: frente abaixo inclina a ponta direita para cima; direita abaixo desce a linha.
        // Depois: frente abaixo sobe a linha; direita abaixo inclina a ponta direita para cima.
        pose(1,CORRIGIDO ? -1 : 0,CORRIGIDO ? 0 : 1);
        pose(2,CORRIGIDO ? 0 : 1,CORRIGIDO ? 1 : 0);
        pose(3,CORRIGIDO ? 1 : 0,CORRIGIDO ? 0 : -1);
        pose(4,CORRIGIDO ? 0 : -1,CORRIGIDO ? -1 : 0);
        pose(0,0,0);
        force dut.u_sensor.gyro_x=-16'sd262;
        force dut.u_sensor.gyro_y=16'sd393;
        force dut.u_sensor.gyro_z=-16'sd131;
        #1;
        if(dut.mpu_gyro_x!=(CORRIGIDO ? -262 : 393) ||
           dut.mpu_gyro_y!=(CORRIGIDO ? 393 : 262) || dut.mpu_gyro_z!=-131)
            $fatal(1,"Acelerometro e giroscopio com referenciais diferentes");
        $display("PASS orientacao MPU: CORRIGIDO=%0d; frente/direita e opostos, retorno ao nivel, gyro e bussola preservada",CORRIGIDO);
        $finish;
    end
    initial begin #20_000_000; $fatal(1,"Timeout orientacao MPU"); end
endmodule
