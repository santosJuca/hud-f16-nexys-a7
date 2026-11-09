`timescale 1ns/1ps
// Qualifica digitalmente os perfis SPI incrementais do sd_spi_controller real:
// inicializacao sempre no divisor 125 (400 kHz), leitura CMD17 no divisor READ_HALF,
// CRC16, erro recuperado, reset no meio da leitura e incerteza de atraso no MISO.
// Nao substitui medicao eletrica: o atraso do MISO e um modelo de ida e volta
// (saida SCK da FPGA + trilha + tODLY do cartao + entrada), nao um valor medido.
//
// SCENARIO 0: leituras nominais
// SCENARIO 1: CRC corrompido na segunda leitura; as seguintes devem passar
// SCENARIO 2: reset durante a primeira leitura; reinicializacao a 400 kHz e leituras OK
// SCENARIO 3: atraso MISO incerto atravessando o ponto de amostragem; exige deteccao
//             de falha (nenhum bloco corrompido pode ser aceito)
// SCENARIO 4: timeout de token na segunda leitura e recuperacao
// SCENARIO 5/6: R1/token invalido, sem aceitar bloco
// NAC_JITTER_BYTES varia deterministicamente a espera entre setores.
module tb_sd_spi_freq_profiles #(
    parameter integer SCENARIO = 0,
    parameter integer READ_HALF = 125,
    parameter integer INIT_HALF = 125,
    parameter integer NREADS = 4,
    parameter integer MISO_DMIN_NS = 0,
    parameter integer MISO_DMAX_NS = 0,
    parameter integer NAC_BYTES = 0,
    parameter integer NAC_JITTER_BYTES = 0,
    parameter integer R1_WAIT_BYTES = 0,
    parameter integer TOKEN_LIMIT_CLOCKS = 4096,
    parameter integer SEED = 1
);
    localparam integer BASE_LBA = 30028160;
    reg clk = 0, rst = 1, read_start = 0, corrupt_crc = 0, timeout_token = 0;
    reg [31:0] read_lba = BASE_LBA;
    always #5 clk = ~clk;

    wire sck, mosi, cs_n, sd_reset, miso_card;
    reg miso_d = 1;
    wire init_ready, init_failed, read_busy, read_done, read_error;
    wire block_valid, data_valid;
    wire [2:0] init_error_code, read_error_code;
    wire [7:0] data_byte;
    wire [8:0] byte_index;
    wire [9:0] bytes_received;
    integer reads;

    sd_spi_controller #(
        .POWERUP_CYCLES(1000),
        .INIT_HALF_PERIOD_CYCLES(INIT_HALF),
        .READ_HALF_PERIOD_CYCLES(READ_HALF),
        .MAX_READ_WAIT_TOKEN_CLOCKS(TOKEN_LIMIT_CLOCKS)
    ) dut (
        .clk(clk), .rst(rst), .read_start(read_start), .read_lba(read_lba),
        .sd_miso(miso_d), .sd_reset(sd_reset), .sd_sck(sck), .sd_mosi(mosi),
        .sd_cs_n(cs_n), .init_ready(init_ready), .init_failed(init_failed),
        .init_error_code(init_error_code), .read_busy(read_busy),
        .read_done(read_done), .read_error(read_error),
        .read_error_code(read_error_code), .block_valid(block_valid),
        .data_valid(data_valid), .data_byte(data_byte), .byte_index(byte_index),
        .current_state(), .current_command(), .r1_response(), .data_token(),
        .bytes_received(bytes_received), .crc_received(), .crc_calculated()
    );

    sd_video_card_model #(.FILE_BYTES(512*NREADS), .BASE_LBA(BASE_LBA),
                          .NAC_BYTES(NAC_BYTES), .NAC_JITTER_BYTES(NAC_JITTER_BYTES),
                          .R1_WAIT_BYTES(R1_WAIT_BYTES),
                          .READ_R1_VALUE(SCENARIO==5 ? 8'h04 : 8'h00),
                          .READ_TOKEN_VALUE(SCENARIO==6 ? 8'hfd : 8'hfe)) card (
        .sck(sck), .cs_n(cs_n), .mosi(mosi), .rst(rst), .corrupt_crc(corrupt_crc),
        .timeout_token(timeout_token), .bad_header(1'b0), .miso(miso_card), .reads(reads));

    // Atraso de transporte por transicao, sorteado em [DMIN, DMAX].
    integer seed_state = SEED;
    integer miso_delay;
    always @(miso_card) begin
        miso_delay = MISO_DMIN_NS;
        if (MISO_DMAX_NS > MISO_DMIN_NS)
            miso_delay = MISO_DMIN_NS + ({$random(seed_state)} % (MISO_DMAX_NS - MISO_DMIN_NS + 1));
        miso_d <= #(miso_delay) miso_card;
    end

    // Meio periodo minimo observado em cada fase (dono do barramento no instante da borda).
    realtime last_edge = 0;
    realtime min_init = 1e12, min_read = 1e12;
    integer init_edges = 0, read_edges = 0, init_edges_after_reset = 0;
    reg reset_done = 0;
    always @(sck) if (!rst) begin
        if (last_edge != 0) begin
            if (dut.read_owner) begin
                if ($realtime - last_edge < min_read) min_read = $realtime - last_edge;
                read_edges = read_edges + 1;
            end else begin
                if ($realtime - last_edge < min_init) min_init = $realtime - last_edge;
                init_edges = init_edges + 1;
                if (reset_done) init_edges_after_reset = init_edges_after_reset + 1;
            end
        end
        last_edge = $realtime;
    end

    // Captura dos bytes provisorios e conferencia do bloco aceito.
    reg [7:0] block [0:511];
    integer captured = 0;
    always @(posedge clk) if (!rst && data_valid) begin
        block[byte_index] <= data_byte;
        captured <= captured + 1;
    end

    integer good = 0, failures = 0, crc_failures = 0, token_timeouts = 0, r1_failures = 0, token_failures = 0, i, n, offset;
    integer t_start, cycles, total_cycles = 0, timed = 0;
    integer cyc = 0;
    always @(posedge clk) cyc <= cyc + 1;

    task automatic do_read(input integer index, output integer ok);
        integer local_timeout;
        begin
            ok = 0;
            @(negedge clk);
            read_lba = BASE_LBA + index;
            corrupt_crc = (SCENARIO == 1 && index == 1);
            timeout_token = (SCENARIO == 4 && index == 1);
            captured = 0;
            read_start = 1;
            t_start = cyc;
            @(negedge clk);
            read_start = 0;
            local_timeout = 0;
            // Como o loader (SECTOR_BUSY): read_error anterior e retido ate a nova transacao.
            while (!read_busy) begin
                @(posedge clk);
                local_timeout = local_timeout + 1;
                if (local_timeout > 1000) $fatal(1, "Leitura nao aceita idx=%0d", index);
            end
            while (!(read_done || read_error)) begin
                @(posedge clk);
                local_timeout = local_timeout + 1;
                if (local_timeout > 400_000_000) $fatal(1, "Leitura sem termino idx=%0d", index);
            end
            cycles = cyc - t_start;
            $display("READ idx=%0d done=%0d err=%0d code=%0d valid=%0d cycles=%0d t=%0t", index, read_done, read_error, read_error_code, block_valid, cycles, $time);
            if (read_done && block_valid) begin
                @(negedge clk);
                offset = index * 512;
                for (n = 0; n < 512; n = n + 1)
                    if (block[n] !== card.memory[offset + n])
                        $fatal(1, "BLOCO CORROMPIDO ACEITO idx=%0d byte=%0d lido=%02x esperado=%02x",
                               index, n, block[n], card.memory[offset + n]);
                if (captured != 512) $fatal(1, "Bloco aceito com %0d bytes", captured);
                ok = 1;
                good = good + 1;
                total_cycles = total_cycles + cycles;
                timed = timed + 1;
            end else begin
                failures = failures + 1;
                if (read_error_code == 3'd5) crc_failures = crc_failures + 1;
                if (read_error_code == 3'd3) token_timeouts = token_timeouts + 1;
                if (read_error_code == 3'd1) r1_failures = r1_failures + 1;
                if (read_error_code == 3'd4) token_failures = token_failures + 1;
                if (block_valid) $fatal(1, "block_valid junto com erro");
            end
            corrupt_crc = 0;
            timeout_token = 0;
            // Aguarda o controlador liberar a posse do barramento.
            while (read_busy || dut.read_owner) @(posedge clk);
            repeat (4) @(posedge clk);
        end
    endtask

    integer ok, idx;
    initial begin
        if (MISO_DMAX_NS < MISO_DMIN_NS) $fatal(1, "Faixa de atraso invalida");
        repeat (10) @(negedge clk);
        rst = 0;
        wait (init_ready || init_failed);
        if (init_failed) $fatal(1, "Inicializacao falhou codigo=%0d", init_error_code);

        if (SCENARIO == 2) begin
            // Reset no meio da primeira leitura.
            @(negedge clk);
            read_lba = BASE_LBA;
            read_start = 1;
            @(negedge clk);
            read_start = 0;
            wait (bytes_received > 100);
            repeat (3) @(negedge clk);
            rst = 1;
            repeat (20) @(negedge clk);
            if (sd_reset !== 1'b1 && sd_reset !== 1'b0) $fatal(1, "SD_RESET indefinido");
            if (cs_n !== 1'b1) $fatal(1, "CS ativo durante reset");
            last_edge = 0;
            reset_done = 1;
            rst = 0;
            wait (init_ready || init_failed);
            if (init_failed) $fatal(1, "Reinicializacao falhou");
            if (init_edges_after_reset == 0) $fatal(1, "Reinicializacao sem bordas SCK");
        end

        for (idx = 0; idx < NREADS; idx = idx + 1)
            do_read(idx, ok);

        if (min_init != INIT_HALF * 10.0)
            $fatal(1, "Meio periodo de inicializacao %0t != %0d ns", min_init, INIT_HALF * 10);
        if (read_edges == 0 || min_read != READ_HALF * 10.0)
            $fatal(1, "Meio periodo de leitura %0t != %0d ns", min_read, READ_HALF * 10);

        case (SCENARIO)
            0, 2: if (good != NREADS || failures != 0)
                $fatal(1, "Esperado %0d leituras OK, obtido %0d (falhas %0d)", NREADS, good, failures);
            1: if (good != NREADS - 1 || failures != 1 || crc_failures != 1)
                $fatal(1, "CRC injetado: OK=%0d falhas=%0d crc=%0d", good, failures, crc_failures);
            3: if (failures == 0)
                $fatal(1, "Atraso atravessando a amostragem nao foi detectado (OK=%0d)", good);
            4: if (good != NREADS-1 || failures != 1 || token_timeouts != 1)
                $fatal(1,"Timeout token nao recuperado OK=%0d falhas=%0d timeout=%0d",good,failures,token_timeouts);
            5: if (good != 0 || r1_failures != NREADS)
                $fatal(1,"R1 ruim aceito ou mal classificado");
            6: if (good != 0 || token_failures != NREADS)
                $fatal(1,"Token ruim aceito ou mal classificado");
            default: $fatal(1, "Cenario invalido");
        endcase

        $display("PASS spi_profile scenario=%0d init_half_ns=%0d read_half_ns=%0d spi_read_hz=%0d nac_bytes=%0d miso_delay_ns=[%0d,%0d] ok=%0d falhas=%0d crc=%0d",
                 SCENARIO, INIT_HALF * 10, READ_HALF * 10, 50_000_000 / READ_HALF, NAC_BYTES,
                 MISO_DMIN_NS, MISO_DMAX_NS, good, failures, crc_failures);
        if (timed != 0)
            $display("SECTOR_CYCLES avg=%0d ciclos_100MHz frame150_ms=%0.3f fps_teto_carga=%0.2f",
                     total_cycles / timed, 150.0 * (total_cycles / timed) / 100_000.0,
                     100_000_000.0 / (150.0 * (total_cycles / timed)));
        $finish;
    end
endmodule
