`timescale 1ns/1ps
module tb_top_capture;
    reg clk=0;
    always #5 clk=~clk;
    wire sck,mosi,cs_n,miso;
    wire [3:0] r,g,b;
    wire hs,vs;
    reg icon_request=0,button=0;
    reg style=0,declutter=0;
    reg [1:0] operation=0;
    reg [3:0] page=0;
    reg [1:0] head_buttons=0;
    tri1 mpu_sda,mpu_scl,baro_sda,baro_scl,mag_sda,mag_scl;
    top_reticula #(
        .VIDEO_SENSOR_STARTUP_CYCLES(1000),.MPU_GIRO_ESQUERDA_90(1),.ENABLE_SD_SUBSYSTEM(1),.ENABLE_SD_OVERLAY(1),.ENABLE_SD_VIDEO(1),
        .CAPTURE_DEBOUNCE(4),.CAPTURE_LONG_PRESS(40),.SD_VIDEO_WIDTH(160),.SD_VIDEO_HEIGHT(120),.SD_VIDEO_LBA(1000),.SD_VIDEO_SECTORS(77),
        .SD_DIAGNOSTIC_LBA(30006080),.SD_REFERENCE_FILE("tests/hud_aircraft_64.hex"),
        .SD_POWERUP_CYCLES(4),.SD_HALF_PERIOD_CYCLES(2),.SD_REQUEST_DEBOUNCE(4),.OPERACAO_DEBOUNCE(4)) dut(
        .clk(clk),.operacao_sw(operation),.ack_btn(1'b0),.btn_heading(head_buttons),.sw(7'b1111000),
        .display_mode(declutter),.style_mode(style),.VIDEO_TOGGLE_BUTTON(button),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(mpu_sda),.i2c_scl(mpu_scl),.baro_sda(baro_sda),.baro_scl(baro_scl),.mag_sda(mag_sda),.mag_scl(mag_scl),
        .SD_DIAG_PAGE(page),.SD_DAT0(miso),.SD_CD(1'b1),.SD_READ_SWITCH(icon_request),
        .SD_SCK(sck),.SD_CMD(mosi),.SD_DAT3(cs_n),.VGA_R(r),.VGA_G(g),.VGA_B(b),.VGA_HS(hs),.VGA_VS(vs));
    wire [31:0] reads;
    sd_video_card_model #(.FILE_BYTES(39424),.ALLOW_ICON(1)) card(.sck(sck),.cs_n(cs_n),.mosi(mosi),
        .rst(dut.reset_operacao),.corrupt_crc(1'b0),.timeout_token(1'b0),.bad_header(1'b0),.miso(miso),.reads(reads));
    integer shown=-1,updates=0,checks=0,styles_checked=0;
    reg [7:0] expected;
    reg [11:0] rgb_expected;
    always @(negedge dut.pixel_clk) if(!dut.reset_operacao) begin
        if(dut.g_video.u_frames.rd_updated) begin
            shown=(dut.video_frames-1)%2; updates=updates+1;
            if(dut.pixel_y!=480||dut.pixel_x!=1) $fatal(1,"Tearing no top");
        end
        if(hs!==dut.hsync||vs!==dut.vsync) $fatal(1,"HS/VS alterados no top");
        if(shown>=0 && dut.video_on) begin
            expected=card.memory[512+shown*19456+(dut.pixel_y/4)*160+dut.pixel_x/4];
            rgb_expected={expected[7:5],expected[7],expected[4:2],expected[4],expected[1:0],expected[1:0]};
            if(dut.capture_hud_opaque||!dut.g_video.u_background.enabled) rgb_expected=dut.capture_hud_rgb;
            if(dut.g_sd_overlay.u_bitmap.overlay_pixel) rgb_expected=12'hff0;
            if({r,g,b}!==rgb_expected) $fatal(1,"Composicao top x=%0d y=%0d got=%h expected=%h",dut.pixel_x,dut.pixel_y,{r,g,b},rgb_expected);
            checks=checks+1;
        end
    end
    initial begin
        // A espera entre quadros e acelerada apenas neste teste de integracao do top.
        force dut.g_video.u_loader.timer=32'd10000000;
        wait(dut.sd_init_ready);
        // Carrega o icone antes de liberar a primeira leitura de video.
        force dut.g_video.video_request=1'b0;
        repeat(12) @(negedge clk);
        icon_request=1;
        wait(dut.sd_data_ok);
        wait(dut.sd_asset_published);
        release dut.g_video.video_request;
        wait(updates>=1);
        // Integra fonte de atitude -> CORDIC -> mailbox -> raster durante captura.
        // O estimador e exercitado com sensores sinteticos em tb_atitude_vetorial.
        force dut.vector_valid=1'b1;
        force dut.vector_calibrated=1'b1;
        force dut.vector_roll=32'sd0;
        force dut.vector_pitch=32'sd0;
        force dut.u_sensor.accel_x=16'sh8001;
        force dut.u_sensor.accel_y=16'sh1234;
        force dut.u_sensor.accel_z=16'sh4000;
        force dut.u_sensor.gyro_x=16'shfffe;
        force dut.u_sensor.gyro_y=16'sh0000;
        force dut.u_sensor.gyro_z=16'sh7fff;
        force dut.mag_diagnostics=32'h48343213;
        button=1;repeat(55) @(negedge clk);button=0;repeat(12) @(negedge clk);
        wait(dut.g_video.frozen);
        begin : modes
            integer held,angle_before,grid_checks=0;
            held=updates;
            @(posedge vs);
            force dut.vector_roll=32'sd92160;
            force dut.vector_pitch=32'sd10240;
            repeat(2) @(posedge vs);
            if(dut.video_diag_display[159:32]!==128'h48343213_800112344000fffe00007fff)
                $fatal(1,"Leituras dos sensores nao chegaram intactas ao dominio VGA");
            if(updates!=held) $fatal(1,"Video congelado mudou");
            if($signed(dut.attitude_render_roll)!=92160 || $signed(dut.attitude_pitch_px)!=40 ||
                $signed(dut.attitude_sine)<16380 || $signed(dut.attitude_cosine)>4)
                $fatal(1,"Atitude nao chegou ao raster durante captura");
            for(integer m=0;m<4;m++) begin
                page=4'(m<<1);repeat(2) @(posedge vs);
                if(dut.pixel_view!=m) $fatal(1,"Vista nao foi aplicada no blanking");
                if(m==0 && (dut.capture_hud_opaque || dut.g_sd_overlay.u_bitmap.overlay_pixel))
                    $fatal(1,"Vista pura manteve HUD");
                styles_checked++;
            end
            // Physical SW7 remains available to zero the MPU; the grid is a
            // deliberate BTNU+BTND chord while CAPTURE is active.
            page=0;
            head_buttons=2'b11;
            repeat(250100) @(negedge clk);
            head_buttons=0;
            repeat(30) @(negedge clk);
            repeat(2) @(posedge vs);
            if(!dut.pixel_grid) $fatal(1,"Grade nao ativa via BTNU+BTND");
            // Passo por BTNL deve publicar exatamente um quadro e voltar a congelar.
            button=1;repeat(12) @(negedge clk);button=0;repeat(12) @(negedge clk);
            wait(updates==held+1);repeat(2) @(posedge vs);
            if(updates!=held+1) $fatal(1,"Passo duplo");
            if(dut.g_video.u_capture.frame_id!=updates-1) $fatal(1,"Frame ID errado");
            // Mantem coordenadas e sincronos reais durante a verificacao pixel a pixel.
            button=1;repeat(55) @(negedge clk);button=0;repeat(12) @(negedge clk);
            wait(!dut.g_video.frozen);wait(updates>=held+3);
        end
        if(dut.sd_diagnostic_error||dut.sd_good_reads!=1||!dut.sd_asset_published||dut.video_errors!=0)
            $fatal(1,"Diagnostico/icone afetado pelo video");
        if(checks<307200||styles_checked!=4) $fatal(1,"Cobertura de modos incompleta");
        $display("PASS top captura+atitude+vistas+icone: %0d pixels, %0d combinacoes, BTNL retorna ao HUD, diagnostico isolado",checks,styles_checked);
        $finish;
    end
    initial begin #1500000000; $fatal(1,"Timeout top: video_state=%0d frames=%0d",dut.video_state,dut.video_frames); end
endmodule
