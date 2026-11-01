`timescale 1ns/1ps

module tb_top_sd_integration;
    parameter bit TEST_OVERLAY = 0;
    parameter bit TEST_OPERATIONAL = 0;
    parameter integer TEST_LBA = 0;
    parameter TEST_REFERENCE_FILE = "tests/sd_reference.hex";
    reg [7:0] reference_bytes [0:511];
    initial $readmemh(TEST_REFERENCE_FILE, reference_bytes);
    localparam integer POWERUP = 4;
    localparam integer HALF = 2;

    reg test_style=0, test_declutter=0;
    reg [1:0] test_operation=0;
    integer mode_number;
    reg clk = 0;
    always #5 clk = ~clk;

    tri1 mpu_sda_off, mpu_scl_off, baro_sda_off, baro_scl_off;
    tri1 mag_sda_off, mag_scl_off;
    wire off_reset, off_sck, off_cmd, off_cs;
    wire off_ready_led, off_error_led, off_busy_led;

    top_reticula #(.MODOS_OPERACIONAIS(TEST_OPERATIONAL), .OPERACAO_DEBOUNCE(4)) disabled (
        .clk(clk), .operacao_sw(test_operation), .ack_btn(1'b0), .btn_heading(2'b00),
        .sw(7'b0), .display_mode(test_declutter), .style_mode(test_style),
        .vauxp3(1'b0), .vauxn3(1'b0), .vauxp10(1'b0), .vauxn10(1'b0),
        .joystick_sw_n(1'b1),
        .i2c_sda(mpu_sda_off), .i2c_scl(mpu_scl_off),
        .baro_sda(baro_sda_off), .baro_scl(baro_scl_off),
        .mag_sda(mag_sda_off), .mag_scl(mag_scl_off),
        .SD_DIAG_PAGE(4'd0), .SD_DAT0(1'b1), .SD_CD(1'b1), .SD_READ_SWITCH(1'b0), .SD_RESET(off_reset), .SD_SCK(off_sck),
        .SD_CMD(off_cmd), .SD_DAT3(off_cs),
        .SD_READY_LED(off_ready_led),
        .SD_ERROR_LED(off_error_led),
        .SD_BUSY_LED(off_busy_led)
    );

    reg read_switch = 0;
    reg [3:0] diagnostic_page = 4;
    reg corrupt_crc = 0;
    reg [15:0] crc;
    reg [7:0] payload;
    integer k;
    reg card_miso = 1'b1;
    wire card_reset, card_sck, card_cmd, card_cs;
    wire card_ready_led, card_error_led, card_busy_led;
    tri1 mpu_sda_on, mpu_scl_on, baro_sda_on, baro_scl_on;
    tri1 mag_sda_on, mag_scl_on;
    top_reticula #(
        .ENABLE_SD_SUBSYSTEM(1'b1), .ENABLE_SD_OVERLAY(TEST_OVERLAY),
        .SD_DIAGNOSTIC_LBA(TEST_LBA), .OPERACAO_DEBOUNCE(4), .SD_REFERENCE_FILE(TEST_REFERENCE_FILE), .SD_REQUEST_DEBOUNCE(4), .SD_POWERUP_CYCLES(POWERUP),
        .SD_HALF_PERIOD_CYCLES(HALF), .MODOS_OPERACIONAIS(TEST_OPERATIONAL)
    ) enabled (
        .clk(clk), .operacao_sw(test_operation), .ack_btn(1'b0), .btn_heading(2'b00),
        .sw(7'b0), .display_mode(test_declutter), .style_mode(test_style),
        .vauxp3(1'b0), .vauxn3(1'b0), .vauxp10(1'b0), .vauxn10(1'b0),
        .joystick_sw_n(1'b1),
        .i2c_sda(mpu_sda_on), .i2c_scl(mpu_scl_on),
        .baro_sda(baro_sda_on), .baro_scl(baro_scl_on),
        .mag_sda(mag_sda_on), .mag_scl(mag_scl_on),
        .SD_DIAG_PAGE(diagnostic_page), .SD_DAT0(card_miso), .SD_CD(1'b1), .SD_READ_SWITCH(read_switch), .SD_RESET(card_reset), .SD_SCK(card_sck),
        .SD_CMD(card_cmd), .SD_DAT3(card_cs),
        .SD_READY_LED(card_ready_led),
        .SD_ERROR_LED(card_error_led),
        .SD_BUSY_LED(card_busy_led)
    );

    reg [47:0] command_frame = 0;
    reg [0:4200] response_bits = 0;
    integer command_bit_count = 0;
    integer response_length = 0;
    integer response_index = 0;
    integer cmd0_count = 0, cmd8_count = 0, cmd55_count = 0;
    integer acmd41_count = 0, cmd58_count = 0, cmd17_count = 0;
    integer preamble_edges = 0;
    reg [5:0] opcode;
    integer init_state = 0;

    function automatic [15:0] crc16(input [15:0] c, input [7:0] b);
        reg [15:0] v;
        integer n;
        begin
            v = c ^ {b,8'h00};
            for (n=0;n<8;n=n+1) v = v[15] ? (v<<1)^16'h1021 : v<<1;
            crc16 = v;
        end
    endfunction

    task automatic append_byte(input [7:0] value);
        integer b;
        begin
            for (b = 7; b >= 0; b = b - 1) begin
                response_bits[response_length] = value[b];
                response_length = response_length + 1;
            end
        end
    endtask

    task automatic queue_response(input [7:0] r1, input [31:0] extra, input has_extra);
        begin
            response_bits = 0;
            response_length = 0;
            response_index = 0;
            append_byte(8'hFF);
            append_byte(r1);
            if (has_extra) begin
                append_byte(extra[31:24]);
                append_byte(extra[23:16]);
                append_byte(extra[15:8]);
                append_byte(extra[7:0]);
            end
        end
    endtask

    always @(posedge card_sck) begin
        if (card_cs) begin
            preamble_edges = preamble_edges + 1;
        end else if (!card_cs) begin
            if (command_bit_count < 48) begin
                command_frame[47-command_bit_count] = card_cmd;
                command_bit_count = command_bit_count + 1;
                if (command_bit_count == 48) begin
                    opcode = command_frame[45:40];
                    case (opcode)
                        0: begin
                            if (init_state != 0 || preamble_edges < 80) $fatal(1, "CMD0 fora de sequência");
                            cmd0_count = cmd0_count + 1; init_state = 1;
                            queue_response(8'h01, 32'd0, 1'b0);
                        end
                        8: begin
                            if (init_state != 1) $fatal(1, "CMD8 fora de sequência");
                            cmd8_count = cmd8_count + 1; init_state = 2;
                            queue_response(8'h01, 32'h000001AA, 1'b1);
                        end
                        55: begin
                            if (init_state != 2 && init_state != 4) $fatal(1, "CMD55 fora de sequência");
                            cmd55_count = cmd55_count + 1; init_state = init_state + 1;
                            queue_response(8'h01, 32'd0, 1'b0);
                        end
                        41: begin
                            if (init_state != 3) $fatal(1, "ACMD41 fora de sequência");
                            acmd41_count = acmd41_count + 1; init_state = 5;
                            queue_response(8'h00, 32'd0, 1'b0);
                        end
                        58: begin
                            if (init_state != 5) $fatal(1, "CMD58 fora de sequência");
                            cmd58_count = cmd58_count + 1; init_state = 6;
                            queue_response(8'h00, 32'hC0FF8000, 1'b1);
                        end
                        17: begin
                            cmd17_count = cmd17_count + 1;
                            if (command_frame[39:8] != TEST_LBA) $fatal(1,"LBA incorreto");
                            queue_response(8'h00,0,0);
                            append_byte(8'hFE);
                            crc = 0;
                            for (k=0;k<512;k=k+1) begin
                                payload = reference_bytes[k];
                                crc = crc16(crc,payload);
                                append_byte(payload);
                            end
                            append_byte(crc[15:8]);
                            append_byte(crc[7:0] ^ {7'd0,corrupt_crc});
                        end
                        default: $fatal(1, "Comando inesperado %0d", opcode);
                    endcase
                end
            end
        end
    end

    always @(negedge card_sck or posedge card_cs or posedge card_reset) begin
        if (card_reset || card_cs) begin
            card_miso = 1'b1;
            command_bit_count = 0;
            command_frame = 0;
            response_index = 0;
        end else if (response_index < response_length) begin
            card_miso = response_bits[response_index];
            response_index = response_index + 1;
        end else begin
            card_miso = 1'b1;
        end
    end

    integer timeout_cycles;
    always @(negedge clk) begin
        if (!TEST_OVERLAY && {disabled.pixel_clk, disabled.pixel_x, disabled.pixel_y,
             disabled.VGA_R, disabled.VGA_G, disabled.VGA_B,
             disabled.VGA_HS, disabled.VGA_VS} !==
            {enabled.pixel_clk, enabled.pixel_x, enabled.pixel_y,
             enabled.VGA_R, enabled.VGA_G, enabled.VGA_B,
             enabled.VGA_HS, enabled.VGA_VS})
            $fatal(1, "Habilitar SD alterou a saída VGA");
    end

    reg expected_pending=0, expected_visible=0;
    integer overlay_hits=0;
    reg [11:0] expected_rgb;
    integer sx,sy,offset,bit_number;
    always @(posedge enabled.sd_block_valid)
        if(TEST_OVERLAY && !corrupt_crc) expected_pending=1;
    always @(posedge disabled.pixel_clk) begin
        if(TEST_OVERLAY) begin
            if(disabled.reset_operacao) begin
                expected_visible=0; expected_pending=0;
            end else if(disabled.pixel_x==0 && disabled.pixel_y==480 && expected_pending) begin
                expected_visible=1; expected_pending=0;
            end
            #1;
            if(!disabled.reset_operacao) begin
                sx=disabled.pixel_x; sy=disabled.pixel_y;
                expected_rgb={disabled.VGA_R,disabled.VGA_G,disabled.VGA_B};
                if(expected_visible && sx>=540 && sx<604 && sy>=40 && sy<104) begin
                    offset=(sy-40)*8+(sx-540)/8;
                    bit_number=7-((sx-540)%8);
                    if(reference_bytes[offset][bit_number]) begin
                        expected_rgb=12'hFF0; overlay_hits=overlay_hits+1;
                    end
                end
                if({enabled.VGA_R,enabled.VGA_G,enabled.VGA_B} !== expected_rgb)
                    $fatal(1,"RGB top desalinhado x=%0d y=%0d recebido=%h esperado=%h",sx,sy,{enabled.VGA_R,enabled.VGA_G,enabled.VGA_B},expected_rgb);
                if({enabled.VGA_HS,enabled.VGA_VS} !== {disabled.VGA_HS,disabled.VGA_VS})
                    $fatal(1,"HS/VS alterados no top");
            end
        end
    end
    task scan_frame;
        begin
            wait(disabled.pixel_y==0 && disabled.pixel_x==0);
            wait(disabled.pixel_y==480 && disabled.pixel_x==1);
        end
    endtask

    initial begin
        #1;
        if ({off_ready_led, off_error_led, off_busy_led} !== 3'b000)
            $fatal(1, "LEDs SD deveriam permanecer apagados quando desabilitado");

        if ({off_reset, off_sck, off_cmd, off_cs} !== 4'b1011)
            $fatal(1, "Pinos SD desabilitados inseguros: %b%b%b%b", off_reset, off_sck, off_cmd, off_cs);
        repeat (1000) @(negedge clk);
        // O reset local de partida pode ser reaplicado enquanto o cartão inicia.
        wait (preamble_edges >= 20);
        force enabled.reset_operacao = 1'b1;
        if(TEST_OVERLAY) force disabled.reset_operacao = 1'b1;
        repeat (3) @(negedge clk);
        if (card_cs !== 1'b1 || card_sck !== 1'b0 || card_reset !== 1'b1)
            $fatal(1, "Reset durante init não deixou SPI em estado seguro");
        release enabled.reset_operacao;
        if(TEST_OVERLAY) release disabled.reset_operacao;
        #1;

        if (card_busy_led !== 1'b1 ||
            card_ready_led !== 1'b0 ||
            card_error_led !== 1'b0)
            $fatal(1, "LEDs SD incorretos durante inicializacao");

        preamble_edges = 0;
        command_bit_count = 0;
        init_state = 0;
        cmd0_count = 0; cmd8_count = 0; cmd55_count = 0;
        acmd41_count = 0; cmd58_count = 0;

        timeout_cycles = 0;
        while (!enabled.sd_init_ready && !enabled.sd_init_failed && timeout_cycles < 20000) begin
            @(negedge clk); timeout_cycles = timeout_cycles + 1;
        end
        if (!enabled.sd_init_ready || enabled.sd_init_failed ||
            cmd0_count != 1 || cmd8_count != 1 || cmd55_count != 1 ||
            acmd41_count != 1 || cmd58_count != 1)
            $fatal(1, "Inicialização SDHC automática falhou: ready=%b failed=%b cmds=%0d/%0d/%0d/%0d/%0d",
                enabled.sd_init_ready, enabled.sd_init_failed, cmd0_count, cmd8_count,
                cmd55_count, acmd41_count, cmd58_count);
        if (cmd17_count != 0 || enabled.sd_data_valid)
            $fatal(1, "Leitura ou dados começaram sem solicitante");
        if ({card_ready_led, card_error_led, card_busy_led} !== 3'b100)
            $fatal(1, "LEDs SD incorretos apos inicializacao: %b%b%b",
                card_ready_led, card_error_led, card_busy_led);

        read_switch = 1;
        wait(enabled.sd_read_busy); #1;
        if (!card_busy_led) $fatal(1,"LD9 apagado durante leitura");
        wait(enabled.sd_block_valid);
        repeat(20) @(negedge clk);
        if (cmd17_count != 1 || card_error_led || !enabled.SD_CRC_OK_LED || !enabled.SD_DATA_OK_LED || enabled.sd_diag_byte_count != 512) $fatal(1,"Leitura explicita falhou");
        repeat(20) @(negedge clk);
        if (cmd17_count != 1) $fatal(1,"Switch mantido repetiu leitura");
        if (enabled.sd_display_value !== {crc,crc}) $fatal(1,"Pagina CRC incorreta");
        diagnostic_page=2; repeat(4) @(negedge clk);
        if (enabled.sd_display_value !== 32'h00FE0200) $fatal(1,"Pagina de dados incorreta");
        diagnostic_page=0; repeat(4) @(negedge clk);
        if (enabled.sd_display_value !== 32'h503A000B) $fatal(1,"Pagina de estado incorreta");
        if(TEST_OVERLAY) begin
            wait(enabled.sd_asset_published);
            scan_frame();
            if(overlay_hits==0 || enabled.sd_publications!=1) $fatal(1,"Icone nao publicado/desenhado");
            $display("PASS top overlay: SPI/CMD17/CRC -> BRAM -> blanking -> RGB; pixels=%0d",overlay_hits);
        end
        read_switch = 0;
        repeat(20) @(negedge clk);
        corrupt_crc = 1;
        read_switch = 1;
        wait(enabled.sd_read_busy);
        wait(enabled.sd_read_error);
        repeat(3) @(negedge clk);
        if (!card_error_led || enabled.sd_block_valid) $fatal(1,"CRC invalido aceito");
        if(TEST_OVERLAY) begin
            if(enabled.sd_publications!=1) $fatal(1,"CRC ruim publicou outro banco");
            read_switch=0; repeat(20) @(negedge clk);
            corrupt_crc=0; read_switch=1;
            wait(enabled.sd_read_busy); wait(enabled.sd_block_valid);
            wait(enabled.sd_publications==2);
            for(mode_number=0;mode_number<12;mode_number=mode_number+1) begin
                test_operation=2'(mode_number%3);
                test_style=1'((mode_number/3)%2);
                test_declutter=1'(mode_number/6);
                scan_frame();
            end
            if(overlay_hits==0 || card_error_led) $fatal(1,"Recuperacao ou overlay falhou");
            $display("PASS top overlay: erro CRC preserva banco, recuperacao, 12 combinacoes HUD e sync alinhado");
        end
        $display("PASS top: SDHC, CMD17 explicito LBA0, CRC, LEDs e VGA preservado");
        $finish;
    end

    initial begin
        #(TEST_OVERLAY ? 400000000 : 10000000);
        $fatal(1, "Timeout global tb_top_sd_integration");
    end
endmodule
