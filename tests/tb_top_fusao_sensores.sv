`timescale 1ns/1ps
module tb_top_fusao_sensores;
    logic clk=0; always #5 clk=~clk;
    tri1 sda,scl,bsda,bscl,msda,mscl;
    top_reticula dut(.clk(clk),.btn_heading(2'b0),.sw(4'b0),
        .display_mode(1'b0),.style_mode(1'b0),.vauxp3(1'b0),.vauxn3(1'b0),
        .vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(sda),.i2c_scl(scl),.baro_sda(bsda),.baro_scl(bscl),
        .mag_sda(msda),.mag_scl(mscl));
    defparam dut.u_heading_fusao.CAL_LOG2=2;
    defparam dut.u_estado_vertical.CAL_LOG2=2;
    integer checks=0;
    task automatic check(input logic ok,input string msg);
        checks++; if(!ok) $fatal(1,"%s heading=%0d alt=%0d VSI=%0d",msg,dut.heading_entrada,dut.altitude_hud_entrada,dut.vel_vertical_fpm);
    endtask
    task automatic tick;
        @(negedge clk); force dut.u_sensor.amostra_nova=1;
        @(negedge clk); force dut.u_sensor.amostra_nova=0; force dut.u_gyro_bias_dt.dt_valid=1;
        @(negedge clk); force dut.u_gyro_bias_dt.dt_valid=0;
        repeat(30) @(negedge clk);
    endtask
    task automatic quadro;
        repeat(100) @(negedge clk);
        @(negedge dut.pixel_clk); force dut.u_vga.v_cont=480;
        @(posedge dut.pixel_clk); #1;
        check(dut.heading_deg==dut.heading_entrada && dut.altitude_ft==dut.altitude_hud_entrada,"CDC e dados HUD no quadro");
        @(negedge dut.pixel_clk); force dut.u_vga.v_cont=0;
    endtask
    initial begin
        force dut.u_vga.h_cont=0; force dut.u_vga.v_cont=0;
        force dut.sensor_ok=0; force dut.mag_sensor_ok=0;
        force dut.baro_sensor_ok=0; force dut.u_sensor.amostra_nova=0;
        force dut.u_gyro_bias_dt.dt_valid=0;
        repeat(4) @(negedge clk);
        check(dut.heading_entrada==0 && dut.altitude_hud_entrada==36000,"fallback inicial preservado");
        force dut.mag_sensor_ok=1; force dut.mag_x=0;force dut.mag_y=1000;force dut.mag_z=100;
        force dut.mag_amostra_nova=1; @(negedge clk); force dut.mag_amostra_nova=0;
        wait(dut.heading_magnetico_valido); #1;
        check(dut.heading_entrada==90 && !dut.heading_fusionado_valido,"CORDIC e fallback magnetico");
        force dut.sensor_ok=1; force dut.fusao_valida=1;
        force dut.fusao_pitch_q10=0; force dut.fusao_roll_q10=0;
        force dut.mpu_accel_x=0; force dut.mpu_accel_y=0; force dut.mpu_accel_z=16384;
        force dut.mpu_gyro_z=0; force dut.gyro_dt_cycles=10000000;
        force dut.baro_sensor_ok=1; force dut.baro_calibracao_ok=1;
        @(negedge clk); force dut.baro_altitude_ft_calc=10000; force dut.baro_altitude_calc_ok=1;
        @(negedge clk); force dut.baro_altitude_calc_ok=0;
        repeat(8) tick();
        check(dut.heading_fusionado_valido && dut.heading_entrada==90,"mag -> fusao -> entrada");
        check(dut.vertical_valido && dut.altitude_hud_entrada==10000 && dut.vel_vertical_fpm==0,"BMP e MPU -> vertical");
        quadro();
        force dut.mpu_gyro_z=-13100; force dut.mpu_accel_z=18022;
        repeat(10) tick();
        check(dut.heading_entrada>90 && dut.heading_entrada<180,"gyro Z controla heading fusionado");
        check(dut.vel_vertical_fpm>0 && dut.altitude_hud_entrada>10000,"subida vertical integrada");
        quadro();
        force dut.sensor_ok=0; repeat(5) @(negedge clk);
        check(dut.heading_entrada==90 && !dut.vertical_valido,"perda MPU: mag e vertical retida");
        force dut.mag_sensor_ok=0; repeat(5) @(negedge clk);
        check(dut.heading_entrada==dut.heading_manual,"perda mag: manual");
        quadro();
        $display("PASS top_fusao_sensores: %0d verificacoes",checks); $finish;
    end
    initial begin #1000000; $fatal(1,"timeout top fusao"); end
endmodule
