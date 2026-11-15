`timescale 1ns/1ps

module tb_sd_spi_controller;
    localparam integer POWERUP = 4;
    localparam integer HALF = 2;
    localparam integer MODE_NORMAL = 0;
    localparam integer MODE_INIT_FAIL = 1;
    localparam integer MODE_READ_TIMEOUT = 2;
    localparam integer MODE_BAD_CRC = 3;
    localparam integer MAX_GLOBAL_CYCLES = 2000000;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg read_start = 0;
    reg [31:0] read_lba = 0;
    reg sd_miso = 1;
    wire sd_reset, sd_sck, sd_mosi, sd_cs_n;
    wire init_ready, init_failed;
    wire [2:0] init_error_code;
    wire read_busy, read_done, read_error;
    wire [2:0] read_error_code;
    wire block_valid, data_valid;
    wire [7:0] data_byte;
    wire [8:0] byte_index;

    sd_spi_controller #(
        .POWERUP_CYCLES(POWERUP),
        .HALF_PERIOD_CYCLES(HALF),
        .MAX_ACMD41_TRIES(3),
        .MAX_READ_WAIT_R1_CLOCKS(12),
        .MAX_READ_WAIT_TOKEN_CLOCKS(64)
    ) dut (
        .clk(clk), .rst(rst),
        .read_start(read_start), .read_lba(read_lba),
        .sd_miso(sd_miso), .sd_reset(sd_reset), .sd_sck(sd_sck),
        .sd_mosi(sd_mosi), .sd_cs_n(sd_cs_n),
        .init_ready(init_ready), .init_failed(init_failed),
        .init_error_code(init_error_code), .read_busy(read_busy),
        .read_done(read_done), .read_error(read_error),
        .read_error_code(read_error_code), .block_valid(block_valid),
        .data_valid(data_valid), .data_byte(data_byte),
        .byte_index(byte_index)
    );

    reg [47:0] command_frame = 0;
    integer command_bits = 0;
    integer init_step = 0;
    integer acmd41_count = 0;
    integer cmd0_count = 0;
    integer cmd8_count = 0;
    integer cmd55_count = 0;
    integer cmd58_count = 0;
    integer cmd17_count = 0;
    integer preamble_rises = 0;
    integer mode = MODE_NORMAL;
    integer reply_length = 0;
    integer reply_index = 0;
    reg [0:4135] reply_bits;
    reg reply_active = 0;
    reg read_in_transaction = 0;
    reg last_command_is_read = 0;
    reg waiting_read_trail = 0;
    integer read_trailing_edges = 0;
    integer model_read_count = 0;
    reg [31:0] expected_lba = 0;
    integer received_bytes = 0;
    integer global_cycles = 0;
    reg owner_previous = 0;
    integer i;
    reg [7:0] r1;
    reg [31:0] extra;
    reg [7:0] block_byte;
    reg [15:0] block_crc;

    function [15:0] crc16_byte;
        input [15:0] crc_in;
        input [7:0] data_in;
        integer bit_number;
        reg [15:0] value;
        begin
            value = crc_in ^ {data_in, 8'h00};
            for (bit_number = 0; bit_number < 8; bit_number = bit_number + 1)
                if (value[15]) value = (value << 1) ^ 16'h1021;
                else value = value << 1;
            crc16_byte = value;
        end
    endfunction

    function [7:0] expected_byte;
        input [31:0] address;
        input integer seed;
        input integer index;
        reg [31:0] value;
        begin
            value = seed * 29 + index * 3 + address[7:0];
            expected_byte = value[7:0];
        end
    endfunction

    task append_byte;
        input [7:0] value;
        integer bit_number;
        begin
            for (bit_number = 7; bit_number >= 0; bit_number = bit_number - 1) begin
                if (reply_length <= 4135) begin
                    reply_bits[reply_length] = value[bit_number];
                    reply_length = reply_length + 1;
                end
            end
        end
    endtask

    task build_command_reply;
        input [5:0] opcode;
        input [7:0] response_r1;
        input [31:0] response_extra;
        input integer read_mode;
        integer byte_number;
        begin
            for (i = 0; i <= 4135; i = i + 1)
                reply_bits[i] = 1'b1;
            reply_length = 0;
            reply_index = 0;
            reply_active = 1;

            if (opcode == 6'd17 && read_mode == MODE_READ_TIMEOUT) begin
                reply_active = 0;
            end else begin
                append_byte(8'hFF); // Ncr delay
                append_byte(response_r1);
                if (opcode == 6'd8 || opcode == 6'd58) begin
                    append_byte(response_extra[31:24]);
                    append_byte(response_extra[23:16]);
                    append_byte(response_extra[15:8]);
                    append_byte(response_extra[7:0]);
                end
                if (opcode == 6'd17) begin
                    append_byte(8'hFE);
                    block_crc = 0;
                    for (byte_number = 0; byte_number < 512; byte_number = byte_number + 1) begin
                        block_byte = (model_read_count * 29 + byte_number * 3 +
                                      command_frame[15:8]) & 8'hFF;
                        append_byte(block_byte);
                        block_crc = crc16_byte(block_crc, block_byte);
                    end
                    if (read_mode == MODE_BAD_CRC)
                        block_crc = block_crc ^ 16'h0001;
                    append_byte(block_crc[15:8]);
                    append_byte(block_crc[7:0]);
                end
            end
        end
    endtask

    task process_command;
        reg [5:0] opcode;
        reg [31:0] argument;
        reg [7:0] crc;
        reg [7:0] response_r1;
        reg [31:0] response_extra;
        begin
            opcode = command_frame[45:40];
            argument = command_frame[39:8];
            crc = command_frame[7:0];
            response_r1 = 8'hFF;
            response_extra = 32'hFFFFFFFF;

            if (command_frame[47:46] !== 2'b01 || command_frame[0] !== 1'b1)
                $fatal(1, "Enquadramento SPI inválido: %h", command_frame);

            case (opcode)
                6'd0: begin
                    if (init_step != 0 || argument != 0 || crc != 8'h95)
                        $fatal(1, "CMD0 fora de sequência/formato: %h passo=%0d", command_frame, init_step);
                    if (preamble_rises < 80)
                        $fatal(1, "CMD0 antes de 80 clocks de preâmbulo: %0d", preamble_rises);
                    cmd0_count = cmd0_count + 1;
                    if (mode == MODE_INIT_FAIL) begin
                        response_r1 = 8'h04;
                        init_step = 99;
                    end else begin
                        response_r1 = 8'h01;
                        init_step = 1;
                    end
                end
                6'd8: begin
                    if (init_step != 1 || argument != 32'h000001AA || crc != 8'h87)
                        $fatal(1, "CMD8 fora de sequência/formato: %h passo=%0d", command_frame, init_step);
                    cmd8_count = cmd8_count + 1;
                    response_r1 = 8'h01;
                    response_extra = 32'h000001AA;
                    init_step = 2;
                end
                6'd55: begin
                    if ((init_step != 2 && init_step != 4 && init_step != 6) ||
                        argument != 0 || crc != 8'hFF)
                        $fatal(1, "CMD55 fora de sequência/formato: %h passo=%0d", command_frame, init_step);
                    cmd55_count = cmd55_count + 1;
                    response_r1 = 8'h01;
                    init_step = init_step + 1;
                end
                6'd41: begin
                    if ((init_step != 3 && init_step != 5 && init_step != 7) ||
                        argument != 32'h40000000 || crc != 8'hFF)
                        $fatal(1, "ACMD41 fora de sequência/formato: %h passo=%0d", command_frame, init_step);
                    acmd41_count = acmd41_count + 1;
                    if (acmd41_count < 3) begin
                        response_r1 = 8'h01;
                        init_step = init_step - 1;
                    end else begin
                        response_r1 = 8'h00;
                        init_step = 8;
                    end
                end
                6'd58: begin
                    if (init_step != 8 || argument != 0 || crc != 8'hFF)
                        $fatal(1, "CMD58 fora de sequência/formato: %h passo=%0d", command_frame, init_step);
                    cmd58_count = cmd58_count + 1;
                    response_r1 = 8'h00;
                    response_extra = 32'hC0FF8000;
                    init_step = 9;
                end
                6'd17: begin
                    if (init_step != 9 || !init_ready)
                        $fatal(1, "CMD17 antes de init_ready");
                    if (argument !== expected_lba || crc !== 8'hFF)
                        $fatal(1, "CMD17 LBA/CRC incorreto: %h esperado=%h", argument, expected_lba);
                    cmd17_count = cmd17_count + 1;
                    last_command_is_read = 1;
                    $display("MODEL CMD17 #%0d LBA=%h mode=%0d", cmd17_count, argument, mode);
                    model_read_count = model_read_count + 1;
                    response_r1 = 8'h00;
                    read_in_transaction = 1;
                    build_command_reply(opcode, response_r1, response_extra, mode);
                end
                default: $fatal(1, "Opcode SPI inesperado: CMD%0d (%h)", opcode, command_frame);
            endcase

            if (opcode != 6'd17)
                build_command_reply(opcode, response_r1, response_extra, mode);
        end
    endtask

    always @(posedge rst) begin
        sd_miso = 1;
        command_frame = 0;
        command_bits = 0;
        init_step = 0;
        acmd41_count = 0;
        cmd0_count = 0;
        cmd8_count = 0;
        cmd55_count = 0;
        cmd58_count = 0;
        cmd17_count = 0;
        preamble_rises = 0;
        reply_length = 0;
        reply_index = 0;
        reply_active = 0;
        read_in_transaction = 0;
        last_command_is_read = 0;
        waiting_read_trail = 0;
        read_trailing_edges = 0;
        model_read_count = 0;
        received_bytes = 0;
        owner_previous = 0;
    end

    always @(posedge sd_sck) begin
        if (!rst) begin
            if (sd_reset !== 1'b0)
                $fatal(1, "SD_RESET desabilitou slot durante SPI");
            if (sd_cs_n === 1'b1) begin
                if (waiting_read_trail && dut.read_owner) begin
                    read_trailing_edges = read_trailing_edges + 1;
                    if (read_trailing_edges > 8)
                        $fatal(1, "Mais de oito clocks finais após CMD17");
                end
                preamble_rises = preamble_rises + 1;
            end else if (sd_cs_n === 1'b0) begin
                if (command_bits < 48) begin
                    command_frame[47-command_bits] = sd_mosi;
                    command_bits = command_bits + 1;
                    if (command_bits == 48) begin
                        command_bits = 48;
                        process_command();
                    end
                end
            end else begin
                $fatal(1, "CS indefinido");
            end
            if (read_in_transaction && sd_cs_n !== 1'b0)
                $fatal(1, "CS subiu durante CMD17 antes de concluir CRC/trailing");
        end
    end

    always @(posedge sd_cs_n or posedge rst) begin
        if (rst) begin
            command_bits = 0;
            command_frame = 0;
            reply_active = 0;
            reply_index = 0;
            read_in_transaction = 0;
            last_command_is_read = 0;
            waiting_read_trail = 0;
            read_trailing_edges = 0;
        end else begin
            if (last_command_is_read) begin
                waiting_read_trail = 1;
                read_trailing_edges = 0;
            end
            command_bits = 0;
            command_frame = 0;
            reply_active = 0;
            reply_index = 0;
            read_in_transaction = 0;
            last_command_is_read = 0;
        end
    end

    always @(negedge sd_sck or posedge sd_cs_n or posedge rst) begin
        if (rst || sd_cs_n !== 1'b0) begin
            sd_miso = 1;
        end else if (reply_active && reply_index < reply_length) begin
            sd_miso = reply_bits[reply_index];
            reply_index = reply_index + 1;
        end else begin
            sd_miso = 1;
        end
    end

    always @(posedge data_valid) begin
        if (rst)
            $fatal(1, "data_valid durante reset");
        if (sd_cs_n !== 1'b0)
            $fatal(1, "CS inativo ao emitir byte");
        if (byte_index !== received_bytes[8:0])
            $fatal(1, "Índice de byte %0d, esperado %0d", byte_index, received_bytes);
        if (data_byte !== expected_byte(expected_lba, model_read_count, received_bytes))
            $fatal(1, "Setor LBA %h byte[%0d]=%h inesperado", expected_lba, received_bytes, data_byte);
        received_bytes = received_bytes + 1;
    end

    always @(posedge clk) begin
        global_cycles <= global_cycles + 1;
        if (global_cycles > MAX_GLOBAL_CYCLES)
            $fatal(1, "Timeout global do testbench P2I");
    end

    always @(negedge clk) begin
        if (!rst) begin
            if (sd_sck !== (dut.read_owner ? dut.read_sck : dut.init_sck) ||
                sd_mosi !== (dut.read_owner ? dut.read_mosi : dut.init_mosi) ||
                sd_cs_n !== (dut.read_owner ? dut.read_cs_n : dut.init_cs_n))
                $fatal(1, "Saídas físicas não correspondem ao mestre selecionado");
            if (dut.read_owner &&
                (dut.init_sck !== 1'b0 || dut.init_mosi !== 1'b1 || dut.init_cs_n !== 1'b1))
                $fatal(1, "Mestre de init alterou SPI durante CMD17");
            if (!dut.read_owner &&
                (dut.read_sck !== 1'b0 || dut.read_mosi !== 1'b1 || dut.read_cs_n !== 1'b1))
                $fatal(1, "Mestre CMD17 ativo sem propriedade do barramento");
            if (dut.read_owner !== owner_previous) begin
                if (dut.init_sck !== 1'b0 || dut.init_mosi !== 1'b1 || dut.init_cs_n !== 1'b1 ||
                    dut.read_sck !== 1'b0 || dut.read_mosi !== 1'b1 || dut.read_cs_n !== 1'b1 ||
                    sd_sck !== 1'b0 || sd_cs_n !== 1'b1)
                    $fatal(1, "Troca de proprietário fora do estado SPI ocioso");
                if (!dut.read_owner && waiting_read_trail && read_trailing_edges != 8)
                    $fatal(1, "Troca de barramento após %0d clocks finais CMD17, esperado 8", read_trailing_edges);
                if (!dut.read_owner)
                    waiting_read_trail = 0;
            end
            owner_previous = dut.read_owner;
        end
    end

    task apply_reset;
        input integer selected_mode;
        begin
            rst = 1;
            mode = selected_mode;
            read_start = 0;
            read_lba = 0;
            repeat (4) @(negedge clk);
            if (sd_sck !== 1'b0 || sd_cs_n !== 1'b1 || sd_reset !== 1'b1)
                $fatal(1, "Reset não colocou SPI/slot em estado seguro");
            rst = 0;
            repeat (2) @(negedge clk);
        end
    endtask

    task wait_init_success;
        integer ticks;
        begin
            ticks = 0;
            while (!init_ready && !init_failed && ticks < 20000) begin
                @(negedge clk);
                ticks = ticks + 1;
            end
            if (ticks == 20000)
                $fatal(1, "Timeout global aguardando inicialização");
            if (!init_ready || init_failed || init_error_code != 0 || sd_reset !== 1'b0)
                $fatal(1, "Inicialização não confirmou SDHC pronto");
            if (init_step != 9 || acmd41_count != 3 || cmd0_count != 1 ||
                cmd8_count != 1 || cmd55_count != 3 || cmd58_count != 1)
                $fatal(1, "Sequência inicial incompleta ou ACMD41 sem retries");
            repeat (4) @(negedge clk);
            if (!init_ready || cmd0_count != 1 || cmd58_count != 1)
                $fatal(1, "init_ready não permaneceu estável");
        end
    endtask

    task issue_read;
        input [31:0] address;
        integer ticks;
        begin
            expected_lba = address;
            received_bytes = 0;
            read_lba = address;
            @(negedge clk); read_start = 1;
            @(negedge clk); read_start = 0;
            // O endereco so precisa permanecer valido ate a aceitacao.
            read_lba = ~address;
            ticks = 0;
            while (!read_busy && ticks < 20) begin
                @(negedge clk);
                ticks = ticks + 1;
            end
            if (!read_busy)
                $fatal(1, "Solicitação CMD17 aceita não ativou read_busy");
        end
    endtask

    task wait_read_success;
        integer ticks;
        begin
            ticks = 0;
            while (!read_done && !read_error && ticks < 100000) begin
                @(negedge clk);
                ticks = ticks + 1;
            end
            if (ticks == 100000)
                $fatal(1, "Timeout aguardando conclusão CMD17");
            if (!read_done || read_error || !block_valid || read_busy ||
                received_bytes != 512 || !sd_cs_n || !init_ready)
                $fatal(1, "Conclusão CMD17 inválida done=%b err=%b code=%0d valid=%b bytes=%0d cmd17=%0d step=%0d mode=%0d owner=%b",
                       read_done, read_error, read_error_code, block_valid, received_bytes,
                       cmd17_count, init_step, mode, dut.read_owner);
            if (read_error_code != 0)
                $fatal(1, "Código de leitura residual após sucesso: %0d", read_error_code);
            repeat (3) @(negedge clk);
        end
    endtask

    task wait_read_error;
        input [2:0] expected_code;
        input integer expected_data_count;
        integer ticks;
        begin
            ticks = 0;
            while (!read_error && !read_done && ticks < 100000) begin
                @(negedge clk);
                ticks = ticks + 1;
            end
            if (ticks == 100000)
                $fatal(1, "Timeout aguardando erro CMD17");
            if (!read_error || read_done || block_valid || read_busy ||
                !sd_cs_n || read_error_code !== expected_code ||
                received_bytes != expected_data_count)
                $fatal(1, "Erro CMD17 incorreto code=%0d bytes=%0d esperado code=%0d bytes=%0d",
                       read_error_code, received_bytes, expected_code, expected_data_count);
            repeat (3) @(negedge clk);
        end
    endtask

    integer init_commands_snapshot;
    integer elapsed;
    initial begin
        block_crc = 0;
        block_crc = crc16_byte(block_crc, 8'h31);
        block_crc = crc16_byte(block_crc, 8'h32);
        block_crc = crc16_byte(block_crc, 8'h33);
        block_crc = crc16_byte(block_crc, 8'h34);
        block_crc = crc16_byte(block_crc, 8'h35);
        block_crc = crc16_byte(block_crc, 8'h36);
        block_crc = crc16_byte(block_crc, 8'h37);
        block_crc = crc16_byte(block_crc, 8'h38);
        block_crc = crc16_byte(block_crc, 8'h39);
        if (block_crc !== 16'h31C3)
            $fatal(1, "Modelo CRC16 diverge do vetor de referência 123456789");

        // Antes do ready, um pulso deve ser ignorado e não ficar pendente.
        apply_reset(MODE_NORMAL);
        @(negedge clk); read_start = 1; read_lba = 32'hDEADBEEF;
        @(negedge clk); read_start = 0;
        repeat (8) @(negedge clk);
        if (init_ready || read_busy || cmd17_count != 0 || dut.read_owner)
            $fatal(1, "Solicitação pré-init disparou CMD17 ou ficou pendente");
        wait_init_success();
        $display("PASS: preâmbulo e inicialização com três tentativas ACMD41");

        issue_read(0); wait_read_success();
        $display("PASS: leitura LBA 0, 512 bytes byte a byte e CRC16 correto");
        init_commands_snapshot = cmd0_count + cmd8_count + cmd55_count + acmd41_count + cmd58_count;

        issue_read(32'h12345678); wait_read_success();
        if (cmd17_count != 2 ||
            cmd0_count + cmd8_count + cmd55_count + acmd41_count + cmd58_count != init_commands_snapshot)
            $fatal(1, "Segunda leitura reinicializou o cartão ou CMD17 ausente");
        $display("PASS: segundo LBA e dados distintos sem repetir inicialização");

        mode = MODE_READ_TIMEOUT;
        issue_read(32'h00000033); wait_read_error(3'd2, 0);
        $display("PASS: timeout R1 libera CS e retorna erro específico");

        mode = MODE_NORMAL;
        issue_read(32'h00000034); wait_read_success();
        $display("PASS: nova leitura após timeout recuperável");

        mode = MODE_BAD_CRC;
        issue_read(32'h00000045); wait_read_error(3'd5, 512);
        $display("PASS: CRC incorreto não confirma block_valid");

        mode = MODE_NORMAL;
        issue_read(32'h00000046); wait_read_success();
        $display("PASS: nova leitura após falha de CRC recuperável");

        apply_reset(MODE_INIT_FAIL);
        elapsed = 0;
        while (!init_failed && !init_ready && elapsed < 20000) begin
            @(negedge clk); elapsed = elapsed + 1;
        end
        if (!init_failed || init_ready || init_error_code !== 3'd1 || cmd17_count != 0)
            $fatal(1, "Falha de inicialização não propagada/bloqueada");
        expected_lba = 32'hFFFFFFFF;
        read_lba = expected_lba;
        @(negedge clk); read_start = 1;
        @(negedge clk); read_start = 0;
        repeat (10) @(negedge clk);
        if (cmd17_count != 0 || read_busy || dut.read_owner)
            $fatal(1, "CMD17 permitido após falha de inicialização");
        $display("PASS: falha de init propagada e leituras bloqueadas");

        // Reset no preâmbulo reinicia toda a sequência.
        apply_reset(MODE_NORMAL);
        wait (preamble_rises >= 20);
        rst = 1;
        repeat (4) @(negedge clk);
        if (sd_cs_n !== 1'b1 || sd_sck !== 1'b0 || sd_reset !== 1'b1 || dut.read_owner)
            $fatal(1, "Reset durante inicialização não deixou SPI seguro");
        rst = 0;
        wait_init_success();
        issue_read(32'h00000071); wait_read_success();
        $display("PASS: reset durante inicialização reinicia e permite leitura");

        // Reset com dados em streaming aborta o bloco e obriga nova inicialização.
        apply_reset(MODE_NORMAL);
        wait_init_success();
        issue_read(32'h00000072);
        elapsed = 0;
        while (received_bytes < 12 && elapsed < 100000) begin
            @(negedge clk); elapsed = elapsed + 1;
        end
        if (elapsed == 100000 || received_bytes < 12)
            $fatal(1, "Leitura não iniciou antes do teste de reset");
        rst = 1;
        #1;
        if (sd_cs_n !== 1'b1 || sd_sck !== 1'b0 || read_busy || block_valid || dut.read_owner)
            $fatal(1, "Reset durante CMD17 não abortou/liberou o barramento");
        repeat (4) @(negedge clk);
        rst = 0;
        wait_init_success();
        issue_read(32'h00000073); wait_read_success();
        $display("PASS: reset durante leitura aborta, reinicializa e recupera");

        if (cmd17_count != 1 || cmd0_count != 1 || cmd8_count != 1 || cmd58_count != 1)
            $fatal(1, "Contagem final de comandos inesperada após último reset");
        $display("PASS: arbitragem exclusiva, trocas em idle, CS e sequência CMDs verificados");
        $display("PASS: todos os cenários integrados P2I executados");
        $finish;
    end
endmodule
