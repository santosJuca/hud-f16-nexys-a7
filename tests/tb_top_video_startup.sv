`timescale 1ns/1ps
module tb_top_video_startup;
    localparam integer PRAZO=100000;
    reg clk=0;
    always #5 clk=~clk;
    reg [15:9] switches=7'b1111000;
    tri1 sda,scl,baro_sda,baro_scl,mag_sda,mag_scl;
    top_reticula #(.ENABLE_SD_SUBSYSTEM(1),.ENABLE_SD_VIDEO(1),
        .SD_VIDEO_WIDTH(160),.SD_VIDEO_HEIGHT(120),.SD_VIDEO_LBA(1000),.SD_VIDEO_SECTORS(77),
        .MPU_GIRO_ESQUERDA_90(1),.FRENTE_INVERTIDA_180(1),
        .MAG_OFFSET_X(717),.MAG_OFFSET_Y(-161),.MAG_GAIN_X_Q12(4545),.MAG_GAIN_Y_Q12(3727),
        .VIDEO_SENSOR_STARTUP_CYCLES(PRAZO)) dut(
        .clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),.btn_heading(2'b00),.sw(switches),
        .display_mode(1'b0),.style_mode(1'b1),.VIDEO_TOGGLE_BUTTON(1'b0),
        .SD_DIAG_PAGE(4'd0),.SD_READ_SWITCH(1'b0),.SD_DAT0(1'b1),.SD_CD(1'b1),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(sda),.i2c_scl(scl),.baro_sda(baro_sda),.baro_scl(baro_scl),
        .mag_sda(mag_sda),.mag_scl(mag_scl));
    task automatic measurement;
        repeat(900) @(negedge clk);
        if(!dut.vector_valid && dut.video_request)
            $fatal(1,"Leitura de video iniciou antes da primeira atitude valida");
        force dut.u_sensor.amostra_nova=1'b1; @(negedge clk);
        force dut.u_sensor.amostra_nova=1'b0;
        repeat(99) @(negedge clk);
    endtask
    task automatic reset_startup;
        force dut.reset_operacao=1'b1;
        repeat(4) @(negedge clk);
        force dut.reset_operacao=1'b0;
    endtask
    initial begin
        // Amostras do driver sao injetadas; calibracao, validade e pedido de video sao reais.
        force dut.sd_init_ready=1'b1;
        force dut.sd_init_failed=1'b0;
        force dut.video_grant=1'b0;
        force dut.u_sensor.sensor_ok=1'b1;
        force dut.u_sensor.amostra_nova=1'b0;
        force dut.u_sensor.accel_x=-16'sd640;
        force dut.u_sensor.accel_y=-16'sd1152;
        force dut.u_sensor.accel_z=16'sd16512;
        force dut.u_sensor.gyro_x=-16'sd384;
        force dut.u_sensor.gyro_y=16'sd1311;
        force dut.u_sensor.gyro_z=-16'sd128;
        wait(!dut.reset_operacao);
        repeat(3) measurement();
        if(dut.vector_valid || dut.metadados_operacao[3] || dut.video_request)
            $fatal(1,"Calibracao bloqueada foi ignorada na partida");
        force dut.u_sensor.gyro_y=16'sd1152;
        repeat(70) measurement();
        if(!dut.vector_valid || !dut.vector_calibrated || !dut.metadados_operacao[3] || !dut.video_request)
            $fatal(1,"Partida nao liberou o video apos calibracao real");
        if(dut.capture_mode || !dut.video_mode)
            $fatal(1,"Partida automatica dependeu de captura ou desligou o video");
        force dut.u_sensor.sensor_ok=1'b0;
        repeat(20) @(negedge clk);
        if(dut.vector_valid || dut.metadados_operacao[3] || !dut.video_request)
            $fatal(1,"Perda posterior do MPU foi mascarada ou parou novamente o video");

        reset_startup();
        repeat(PRAZO-1) begin
            @(negedge clk);
            if(dut.video_request) $fatal(1,"Video iniciou antes do prazo com MPU ausente");
        end
        repeat(5) @(negedge clk);
        if(!dut.video_request || dut.metadados_operacao[3] || dut.vector_valid)
            $fatal(1,"Prazo bloqueou video indefinidamente ou inventou atitude valida");

        reset_startup();
        switches[9]=1'b1;
        repeat(8) @(negedge clk);
        if(!dut.video_request) $fatal(1,"Modo manual esperou calibracao do MPU desabilitado");

        switches[9]=1'b0;
        reset_startup();
        force dut.sd_init_failed=1'b1;
        repeat(8) @(negedge clk);
        if(!dut.g_video.u_loader.failed || dut.video_request)
            $fatal(1,"Falha de inicializacao do SD foi escondida pela espera do MPU");
        $display("PASS partida: calibracao real antes do video, sem BTNL; prazo, modo manual e falhas MPU/SD preservados");
        $finish;
    end
    initial begin #10_000_000; $fatal(1,"Timeout partida video/MPU"); end
endmodule
