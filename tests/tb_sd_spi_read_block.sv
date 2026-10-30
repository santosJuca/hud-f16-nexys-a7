`timescale 1ns/1ps

module tb_sd_spi_read_block;
    localparam integer HALF = 2;
    localparam integer SC_OK = 0, SC_BAD_R1 = 1, SC_TMO_R1 = 2;
    localparam integer SC_TMO_TOKEN = 3, SC_BAD_TOKEN = 4;
    localparam integer SC_BAD_CRC = 5;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg start = 0;
    reg [31:0] lba = 0;
    reg sd_miso = 1;
    wire sd_sck, sd_mosi, sd_cs_n, busy, done, error;
    wire [2:0] error_code;
    wire data_valid, block_valid;
    wire [7:0] data_byte;
    wire [8:0] byte_index;

    sd_spi_read_block #(
        .HALF_PERIOD_CYCLES(HALF),
        .MAX_WAIT_R1_CLOCKS(16),
        .MAX_WAIT_TOKEN_CLOCKS(64)
    ) dut (
        .clk(clk), .rst(rst), .start(start), .lba(lba),
        .sd_miso(sd_miso), .sd_sck(sd_sck), .sd_mosi(sd_mosi),
        .sd_cs_n(sd_cs_n), .busy(busy), .done(done), .error(error),
        .error_code(error_code), .data_valid(data_valid),
        .data_byte(data_byte), .byte_index(byte_index),
        .block_valid(block_valid)
    );

    reg [47:0] command_rx;
    integer command_bits = 0;
    integer command_count = 0;
    integer selected_scenario = SC_OK;
    integer stream_index = 0;
    integer read_number = 0;
    integer commands_before_busy;
    integer expected_seed = 0;
    reg [31:0] expected_lba;
    reg [7:0] stream [0:4127];
    integer i;
    integer j;
    integer byte_count = 0;
    integer observed_data;
    integer global_cycles = 0;
    reg saw_command = 0;

    function [15:0] crc_byte;
        input [15:0] crc_in;
        input [7:0] value_in;
        integer k;
        reg [15:0] value;
        begin
            value = crc_in ^ {value_in, 8'h00};
            for (k = 0; k < 8; k = k + 1)
                if (value[15]) value = (value << 1) ^ 16'h1021;
                else value = value << 1;
            crc_byte = value;
        end
    endfunction

    task build_reply;
        input integer mode;
        input integer seed;
        reg [7:0] r1_value;
        reg [7:0] token_value;
        reg [15:0] crc_value;
        reg [7:0] data_value;
        begin
            for (i = 0; i < 4128; i = i + 1)
                stream[i] = 8'hFF;
            r1_value = mode == SC_BAD_R1 ? 8'h04 : 8'h00;
            for (i = 0; i < 8; i = i + 1)
                stream[i] = (r1_value >> (7-i)) & 1'b1;
            if (mode != SC_TMO_TOKEN) begin
                token_value = mode == SC_BAD_TOKEN ? 8'h0B : 8'hFE;
                for (i = 0; i < 8; i = i + 1)
                    stream[8+i] = (token_value >> (7-i)) & 1'b1;
                crc_value = 0;
                for (i = 0; i < 512; i = i + 1) begin
                    data_value = (seed * 37 + i) & 8'hFF;
                    for (j = 0; j < 8; j = j + 1)
                        stream[16+i*8+j] = (data_value >> (7-j)) & 1'b1;
                    crc_value = crc_byte(crc_value, data_value);
                end
                if (mode == SC_BAD_CRC)
                    crc_value = crc_value ^ 16'h0001;
                for (i = 0; i < 16; i = i + 1)
                    stream[4112+i] = (crc_value >> (15-i)) & 1'b1;
            end
            stream_index = 0;
        end
    endtask

    always @(posedge sd_sck) begin
        if (!rst && !sd_cs_n && command_bits < 48) begin
            command_rx = {command_rx[46:0], sd_mosi};
            command_bits = command_bits + 1;
            if (command_bits == 48) begin
                if (command_rx[47:46] !== 2'b01 ||
                    command_rx[45:40] !== 6'd17 ||
                    command_rx[39:8] !== expected_lba ||
                    command_rx[7:0] !== 8'hFF ||
                    command_rx[0] !== 1'b1)
                    $fatal(1, "CMD17 incorreto: %h esperado LBA=%h", command_rx, expected_lba);
                command_count = command_count + 1;
                read_number = read_number + 1;
                expected_seed = read_number;
                saw_command = 1;
                build_reply(selected_scenario, expected_seed);
            end
        end
    end

    always @(posedge sd_sck) begin
        if (!rst && saw_command && busy && sd_cs_n && dut.state < 9)
            $fatal(1, "CS foi desativado antes da conclusao da transacao");
    end

    always @(negedge sd_sck) begin
        if (rst || sd_cs_n) begin
            sd_miso = 1;
        end else if (saw_command) begin
            if (selected_scenario == SC_TMO_R1 && stream_index == 0)
                sd_miso = 1;
            else begin
                sd_miso = stream[stream_index];
                if (stream_index < 4127)
                    stream_index = stream_index + 1;
                else
                    stream_index = 4127;
            end
        end
    end

    always @(posedge data_valid) begin
        if (!sd_cs_n)
            observed_data = observed_data + 1;
        else
            $fatal(1, "CS foi desativado durante dados");
        if (byte_index !== byte_count[8:0])
            $fatal(1, "byte_index=%0d esperado=%0d", byte_index, byte_count);
        if (data_byte !== ((expected_seed * 37 + byte_count) & 8'hFF))
            $fatal(1, "byte[%0d]=%h inesperado", byte_count, data_byte);
        byte_count = byte_count + 1;
    end

    always @(posedge clk) begin
        global_cycles <= global_cycles + 1;
        if (global_cycles > 2000000)
            $fatal(1, "Timeout global do testbench");
    end

    task reset_card;
        begin
            rst = 1;
            start = 0;
            sd_miso = 1;
            repeat (4) @(negedge clk);
            rst = 0;
            repeat (2) @(negedge clk);
        end
    endtask

    task launch;
        input [31:0] address;
        input integer mode;
        begin
            expected_lba = address;
            selected_scenario = mode;
            expected_seed = read_number + 1;
            command_bits = 0;
            command_rx = 0;
            stream_index = 0;
            byte_count = 0;
            observed_data = 0;
            saw_command = 0;
            lba = address;
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
        end
    endtask

    task wait_terminal;
        input integer want_success;
        integer timeout_count;
        begin
            timeout_count = 0;
            while (!done && !error && timeout_count < 100000) begin
                @(negedge clk);
                timeout_count = timeout_count + 1;
            end
            if (timeout_count == 100000)
                $fatal(1, "Timeout global aguardando terminal");
            if (want_success) begin
                if (!done || error || !block_valid || byte_count != 512 || observed_data != 512)
                    $fatal(1, "Leitura nominal invalida done=%b err=%b bytes=%0d", done, error, byte_count);
                if (!sd_cs_n || busy)
                    $fatal(1, "CS/busy nao finalizados apos sucesso");
            end else begin
                if (!error || done || block_valid)
                    $fatal(1, "Falha nao reportada corretamente");
                if (!sd_cs_n || busy)
                    $fatal(1, "CS/busy nao finalizados apos erro");
            end
        end
    endtask

    task run_error_case;
        input integer mode;
        input [31:0] address;
        input [2:0] code;
        input integer expected_bytes;
        begin
            reset_card();
            read_number = 0;
            launch(address, mode);
            wait_terminal(0);
            if (error_code !== code)
                $fatal(1, "error_code=%0d esperado=%0d", error_code, code);
            if (byte_count != expected_bytes)
                $fatal(1, "bytes provisórios=%0d esperado=%0d", byte_count, expected_bytes);
            $display("PASS: erro scenario=%0d codigo=%0d", mode, code);
        end
    endtask

    initial begin
        // Leitura LBA 0: valida 512 bytes, seus índices e CRC.
        reset_card(); read_number = 0;
        launch(0, SC_OK); wait_terminal(1);
        $display("PASS: leitura nominal LBA 0, 512 bytes e CRC");

        // LBA não nulo e duas transações consecutivas, com setores distintos.
        launch(32'h12345678, SC_OK); wait_terminal(1);
        launch(32'h0000002A, SC_OK); wait_terminal(1);
        if (command_count != 3 || expected_seed != 3)
            $fatal(1, "Leituras consecutivas nao foram distintas");
        $display("PASS: LBA nao nulo e leituras consecutivas distintas");

        run_error_case(SC_BAD_R1, 32'hA5A55A5A, 3'd1, 0);
        run_error_case(SC_TMO_R1, 32'h00000003, 3'd2, 0);
        run_error_case(SC_TMO_TOKEN, 32'h00000004, 3'd3, 0);
        run_error_case(SC_BAD_TOKEN, 32'h00000005, 3'd4, 0);
        run_error_case(SC_BAD_CRC, 32'h00000006, 3'd5, 512);

        // start ocupado deve ser ignorado sem alterar a leitura em curso.
        reset_card(); read_number = 0;
        launch(32'h00000099, SC_OK);
        commands_before_busy = command_count;
        wait (busy);
        @(negedge clk); start = 1; lba = 32'hFFFFFFFF;
        @(negedge clk); start = 0;
        wait_terminal(1);
        if (command_count != commands_before_busy + 1 || expected_lba !== 32'h00000099)
            $fatal(1, "start ocupado alterou comando ativo");
        $display("PASS: start durante busy ignorado");

        // Reset no meio do setor deve liberar CS sem emitir sucesso.
        reset_card(); read_number = 0;
        launch(32'h00000077, SC_OK);
        wait (byte_count >= 8);
        @(negedge clk); rst = 1;
        #1;
        if (!sd_cs_n || busy || done || block_valid)
            $fatal(1, "Reset nao abortou e liberou CS imediatamente");
        repeat (3) @(negedge clk);
        rst = 0;
        $display("PASS: reset durante transferencia aborta e libera CS");

        $display("PASS: todos os cenarios P2H executados");
        $finish;
    end
endmodule
