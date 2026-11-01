`timescale 1ns/1ps
module tb_top_sd_video;
    reg clk=0;
    always #5 clk=~clk;
    wire sck,mosi,cs_n,miso;
    wire [3:0] r,g,b;
    wire hs,vs;
    reg icon_request=0,button=0;
    reg style=0,declutter=0;
    reg [1:0] operation=0;
    tri1 mpu_sda,mpu_scl,baro_sda,baro_scl,mag_sda,mag_scl;
    top_reticula #(.ENABLE_SD_SUBSYSTEM(1),.ENABLE_SD_OVERLAY(1),.ENABLE_SD_VIDEO(1),
        .SD_VIDEO_WIDTH(160),.SD_VIDEO_HEIGHT(120),.SD_VIDEO_LBA(1000),.SD_VIDEO_SECTORS(77),
        .SD_DIAGNOSTIC_LBA(30006080),.SD_REFERENCE_FILE("tests/hud_aircraft_64.hex"),
        .SD_POWERUP_CYCLES(4),.SD_HALF_PERIOD_CYCLES(2),.SD_REQUEST_DEBOUNCE(4),.OPERACAO_DEBOUNCE(4)) dut(
        .clk(clk),.operacao_sw(operation),.ack_btn(1'b0),.btn_heading(2'd0),.sw(7'b0000111),
        .display_mode(declutter),.style_mode(style),.VIDEO_TOGGLE_BUTTON(button),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(mpu_sda),.i2c_scl(mpu_scl),.baro_sda(baro_sda),.baro_scl(baro_scl),.mag_sda(mag_sda),.mag_scl(mag_scl),
        .SD_DIAG_PAGE(4'd0),.SD_DAT0(miso),.SD_CD(1'b1),.SD_READ_SWITCH(icon_request),
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
            if(dut.hud_opaque||!dut.g_video.u_background.enabled) rgb_expected=dut.hud_rgb;
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
        force dut.mira_on=1'b1;
        @(posedge vs);
        release dut.mira_on;
        for(integer m=0;m<12;m=m+1) begin
            style=m%2; declutter=(m/2)%2; operation=m/4;
            @(posedge vs);
            styles_checked=styles_checked+1;
        end
        button=1; repeat(1100000) @(negedge clk); button=0;
        wait(!dut.g_video.u_background.enabled);
        @(posedge vs);
        if(dut.sd_diagnostic_error||dut.sd_good_reads!=1||!dut.sd_asset_published||dut.video_errors!=0)
            $fatal(1,"Diagnostico/icone afetado pelo video");
        if(checks<307200||styles_checked!=12) $fatal(1,"Cobertura de modos incompleta");
        $display("PASS top video+HUD+icone: %0d pixels, %0d combinacoes, BTNL retorna ao HUD, diagnostico isolado",checks,styles_checked);
        $finish;
    end
    initial begin #500000000; $fatal(1,"Timeout top: video_state=%0d frames=%0d",dut.video_state,dut.video_frames); end
endmodule
