`timescale 1ns/1ps

module tb_sd_spi_init;

    localparam integer POWERUP = 16;
    localparam integer HALF_PERIOD = 2;
    localparam integer MAX_TRIES = 3;
    localparam integer LIMIT_CYCLES = 2000000;

    localparam integer SC_OK          = 0;
    localparam integer SC_RETRIES     = 1;
    localparam integer SC_TMO_CMD0    = 2;
    localparam integer SC_TMO_CMD8    = 3;
    localparam integer SC_BAD_ECHO    = 4;
    localparam integer SC_BAD_R1      = 5;
    localparam integer SC_BAD_CCS     = 6;
    localparam integer SC_BAD_POWER   = 7;
    localparam integer SC_EXHAUST     = 8;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg sd_miso = 1;

    wire sd_reset;
    wire sd_sck;
    wire sd_mosi;
    wire sd_cs_n;

    wire ready;
    wire failed;
    wire [2:0] error_code;
    wire [31:0] ocr;

    sd_spi_init #(
        .POWERUP_CYCLES(POWERUP),
        .HALF_PERIOD_CYCLES(HALF_PERIOD),
        .MAX_ACMD41_TRIES(MAX_TRIES)
    ) dut (
        .clk(clk),
        .rst(rst),
        .sd_miso(sd_miso),
        .sd_reset(sd_reset),
        .sd_sck(sd_sck),
        .sd_mosi(sd_mosi),
        .sd_cs_n(sd_cs_n),
        .ready(ready),
        .failed(failed),
        .error_code(error_code),
        .current_command(),
        .ocr(ocr)
    );

    integer scenario;
    integer phase;
    integer preamble_edges;
    integer rx_count;

    integer command_count;
    integer count_cmd0;
    integer count_cmd8;
    integer count_cmd55;
    integer count_acmd41;
    integer count_cmd58;

    reg [47:0] rx_frame;

    reg [47:0] reply_frame;
    integer reply_index;
    reg reply_active;

    // Prepara uma resposta com 8 clocks de espera,
    // um byte R1 e quatro bytes adicionais.
    task automatic prepare_reply;
        input [7:0] r1;
        input [31:0] extra;
        input enable;
        begin
            reply_frame = {8'hFF, r1, extra};
            reply_index = 0;
            reply_active = enable;
        end
    endtask

    // Analisa o comando completo antes de responder.
    task automatic process_command;
        input [47:0] frame;

        reg [5:0] cmd;
        reg [31:0] arg;
        reg [7:0] crc;
        reg [7:0] r1;
        reg [31:0] extra;
        reg respond;

        begin
            cmd = frame[45:40];
            arg = frame[39:8];
            crc = frame[7:0];

            r1 = 8'hFF;
            extra = 32'hFFFFFFFF;
            respond = 1;

            if (frame[47:46] !== 2'b01)
                $fatal(1, "Formato SPI invalido: %h", frame);

            if (frame[0] !== 1'b1)
                $fatal(1, "Stop bit invalido: %h", frame);

            command_count = command_count + 1;

            case (phase)

                0: begin
                    if (cmd !== 6'd0 ||
                        arg !== 32'h00000000 ||
                        crc !== 8'h95)
                        $fatal(1, "CMD0 incorreto: %h", frame);

                    count_cmd0 = count_cmd0 + 1;
                    r1 = 8'h01;
                    phase = 1;

                    if (scenario == SC_TMO_CMD0)
                        respond = 0;
                end

                1: begin
                    if (cmd !== 6'd8 ||
                        arg !== 32'h000001AA ||
                        crc !== 8'h87)
                        $fatal(1, "CMD8 incorreto: %h", frame);

                    count_cmd8 = count_cmd8 + 1;
                    r1 = 8'h01;
                    extra = 32'h000001AA;
                    phase = 2;

                    if (scenario == SC_TMO_CMD8)
                        respond = 0;

                    if (scenario == SC_BAD_ECHO)
                        extra = 32'h000001AB;

                    if (scenario == SC_BAD_R1)
                        r1 = 8'h05;
                end

                2: begin
                    if (cmd !== 6'd55 ||
                        arg !== 32'h00000000)
                        $fatal(1, "CMD55 esperado: %h", frame);

                    count_cmd55 = count_cmd55 + 1;
                    r1 = 8'h01;
                    phase = 3;
                end

                3: begin
                    if (cmd !== 6'd41 ||
                        arg !== 32'h40000000)
                        $fatal(1, "ACMD41 incorreto: %h", frame);

                    count_acmd41 = count_acmd41 + 1;

                    if (count_acmd41 > MAX_TRIES)
                        $fatal(1, "Limite ACMD41 ultrapassado");

                    if (scenario == SC_EXHAUST ||
                        (scenario == SC_RETRIES &&
                         count_acmd41 < 3)) begin
                        r1 = 8'h01;
                        phase = 2;
                    end else begin
                        r1 = 8'h00;
                        phase = 4;
                    end
                end

                4: begin
                    if (cmd !== 6'd58 ||
                        arg !== 32'h00000000)
                        $fatal(1, "CMD58 esperado: %h", frame);

                    count_cmd58 = count_cmd58 + 1;

                    r1 = 8'h00;
                    extra = 32'hC0FF8000;

                    if (scenario == SC_BAD_CCS)
                        extra = 32'h80FF8000;

                    if (scenario == SC_BAD_POWER)
                        extra = 32'h40FF8000;

                    phase = 5;
                end

                default: begin
                    $fatal(1,
                        "Comando inesperado apos CMD58: CMD%0d",
                        cmd);
                end

            endcase

            $display(
                "SPI: CMD%0d ARG=%h R1=%h fase=%0d",
                cmd, arg, r1, phase
            );

            prepare_reply(r1, extra, respond);
        end
    endtask

    // Cartao SD: recebe MOSI na borda de subida.
    always @(posedge sd_sck) begin
        if (!rst) begin

            if (sd_reset !== 1'b0)
                $fatal(1,
                    "Clock SPI com alimentacao SD desabilitada");

            if (sd_cs_n === 1'b1) begin

                if (phase == 0 && sd_mosi !== 1'b1)
                    $fatal(1,
                        "MOSI invalido durante preambulo");

                preamble_edges = preamble_edges + 1;

            end else if (sd_cs_n === 1'b0) begin

                if (preamble_edges < 80)
                    $fatal(1,
                        "CMD antes de 80 clocks: %0d",
                        preamble_edges);

                if (rx_count == 0) begin

                    // Ignora bytes FF usados para clocks vazios.
                    if (sd_mosi === 1'b0) begin
                        rx_frame = 48'd0;
                        rx_frame[47] = sd_mosi;
                        rx_count = 1;
                    end

                end else begin

                    rx_frame[47-rx_count] = sd_mosi;
                    rx_count = rx_count + 1;

                    if (rx_count == 48) begin
                        rx_count = 0;
                        process_command(rx_frame);
                    end
                end

            end else begin
                $fatal(1, "CS indefinido");
            end
        end
    end

    // Cartao SD: atualiza MISO na borda de descida.
    always @(negedge sd_sck or posedge sd_cs_n) begin
        if (rst || sd_cs_n !== 1'b0 ||
            sd_reset !== 1'b0) begin
            sd_miso = 1'b1;
        end else if (reply_active &&
                     reply_index < 48) begin

            sd_miso = reply_frame[47-reply_index];
            reply_index = reply_index + 1;

            if (reply_index == 48)
                reply_active = 0;

        end else begin
            sd_miso = 1'b1;
        end
    end

    // Desselecionar o cartao descarta transacao parcial.
    always @(posedge sd_cs_n) begin
        rx_count = 0;
        reply_active = 0;
    end

    task automatic run_case;
        input integer mode;
        input [8*48-1:0] case_name;
        input expected_success;

        integer elapsed;

        begin
            rst = 1;
            scenario = mode;

            phase = 0;
            preamble_edges = 0;
            rx_count = 0;

            command_count = 0;
            count_cmd0 = 0;
            count_cmd8 = 0;
            count_cmd55 = 0;
            count_acmd41 = 0;
            count_cmd58 = 0;

            reply_frame = 48'hFFFFFFFFFFFF;
            reply_index = 0;
            reply_active = 0;
            sd_miso = 1;

            repeat (10) @(negedge clk);
            rst = 0;

            elapsed = 0;

            while (ready !== 1'b1 &&
                   failed !== 1'b1 &&
                   elapsed < LIMIT_CYCLES) begin
                @(negedge clk);
                elapsed = elapsed + 1;
            end

            if (elapsed >= LIMIT_CYCLES)
                $fatal(1,
                    "TIMEOUT de simulacao: %0s",
                    case_name);

            if (ready === 1'b1 && failed === 1'b1)
                $fatal(1,
                    "ready e failed simultaneos");

            if (expected_success) begin

                if (ready !== 1'b1 ||
                    failed !== 1'b0)
                    $fatal(1,
                        "Inicializacao falhou: %0s",
                        case_name);

                if (phase != 5 ||
                    count_cmd58 != 1)
                    $fatal(1,
                        "Sequencia incompleta: %0s",
                        case_name);

                if (ocr !== 32'hC0FF8000)
                    $fatal(1,
                        "OCR incorreto: %h",
                        ocr);

                if (error_code !== 8'h00)
                    $fatal(1,
                        "Erro indevido: %h",
                        error_code);

                if (mode == SC_RETRIES &&
                    count_acmd41 != 3)
                    $fatal(1,
                        "Numero incorreto de tentativas");

                if (mode == SC_OK &&
                    count_acmd41 != 1)
                    $fatal(1,
                        "ACMD41 deveria concluir imediatamente");

            end else begin

                if (failed !== 1'b1 ||
                    ready !== 1'b0)
                    $fatal(1,
                        "Falha nao sinalizada: %0s",
                        case_name);

                if (error_code === 8'h00 ||
                    (^error_code) === 1'bx)
                    $fatal(1,
                        "Codigo de erro invalido: %h",
                        error_code);

                case (mode)
                    SC_TMO_CMD0, SC_TMO_CMD8:
                        if (error_code !== 3'd7)
                            $fatal(1, "Codigo timeout incorreto");
                    SC_BAD_ECHO, SC_BAD_R1:
                        if (error_code !== 3'd2)
                            $fatal(1, "Codigo CMD8 incorreto");
                    SC_BAD_CCS, SC_BAD_POWER:
                        if (error_code !== 3'd6)
                            $fatal(1, "Codigo OCR incorreto");
                    SC_EXHAUST:
                        if (error_code !== 3'd5)
                            $fatal(1, "Codigo ACMD41 incorreto");
                endcase
                case (mode)
                    SC_TMO_CMD0: begin
                        if (count_cmd0 != 1 ||
                            count_cmd8 != 0)
                            $fatal(1,
                                "Timeout CMD0 nao isolado");
                    end

                    SC_TMO_CMD8,
                    SC_BAD_ECHO,
                    SC_BAD_R1: begin
                        if (count_cmd8 != 1 ||
                            count_cmd55 != 0)
                            $fatal(1,
                                "Erro CMD8 nao isolado");
                    end

                    SC_BAD_CCS,
                    SC_BAD_POWER: begin
                        if (count_cmd58 != 1)
                            $fatal(1,
                                "Falha OCR antes do CMD58");
                    end

                    SC_EXHAUST: begin
                        if (count_acmd41 != MAX_TRIES ||
                            count_cmd58 != 0)
                            $fatal(1,
                                "Limite ACMD41 incorreto");
                    end
                endcase

            end

            $display(
                "PASS: %0s | comandos=%0d ACMD41=%0d erro=%h",
                case_name,
                command_count,
                count_acmd41,
                error_code
            );

            repeat (5) @(negedge clk);
        end
    endtask

    initial begin
        run_case(SC_OK,
                 "Inicializacao SDHC nominal", 1);

        run_case(SC_RETRIES,
                 "ACMD41 com tres tentativas", 1);

        run_case(SC_TMO_CMD0,
                 "Timeout CMD0", 0);

        run_case(SC_TMO_CMD8,
                 "Timeout CMD8", 0);

        run_case(SC_BAD_ECHO,
                 "CMD8 R7 eco invalido", 0);

        run_case(SC_BAD_R1,
                 "CMD8 R1 invalido", 0);

        run_case(SC_BAD_CCS,
                 "OCR CCS incompativel", 0);

        run_case(SC_BAD_POWER,
                 "OCR power-up incompleto", 0);

        run_case(SC_EXHAUST,
                 "Limite de tentativas ACMD41", 0);

        $display(
            "PASS: todos os 9 cenarios P2G aprovados"
        );

        $finish;
    end

endmodule
