`timescale 1ns/1ps

module tb_sd_spi_acmd;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg miso = 1;

    reg [47:0] command_frame = 0;
    reg long_response = 0;

    reg [7:0] sim_r1 = 8'hFF;
    reg [31:0] sim_extra = 0;

    wire sck, mosi, cs_n, busy, done, timeout;
    wire [7:0] r1;
    wire [31:0] extra;

    integer edges = 0;
    reg [47:0] captured = 0;

    always #5 clk = ~clk;

    sd_spi_command #(
        .HALF_PERIOD_CYCLES(3),
        .MAX_WAIT_R1_CLOCKS(32)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .command_frame(command_frame),
        .long_response(long_response),
        .miso(miso),
        .sck(sck),
        .mosi(mosi),
        .cs_n(cs_n),
        .busy(busy),
        .done(done),
        .timeout(timeout),
        .r1(r1),
        .extra(extra)
    );

    // Captura os comandos transmitidos pela FPGA.
    always @(posedge sck) begin
        if (!cs_n) begin
            if (edges < 48)
                captured = {captured[46:0], mosi};

            edges = edges + 1;
        end
    end

    // Modelo de resposta SPI:
    // 8 clocks de espera, R1 e, se necessario, R3.
    always @(negedge sck) begin
        if (!cs_n) begin
            if (edges < 56)
                miso = 1;
            else if (edges < 64)
                miso = (sim_r1 >> (63-edges)) & 1;
            else if (edges < 96)
                miso = (sim_extra >> (95-edges)) & 1;
            else
                miso = 1;
        end else begin
            miso = 1;
        end
    end

    task automatic issue_command;
        input [47:0] requested_frame;
        input [7:0] expected_r1;
        input [31:0] expected_extra;
        input expects_extra;
        input integer step_number;

        begin
            @(negedge clk);

            command_frame = requested_frame;
            long_response = expects_extra;

            sim_r1 = expected_r1;
            sim_extra = expected_extra;

            captured = 0;
            edges = 0;
            miso = 1;

            start = 1;
            @(negedge clk);
            start = 0;

            wait (done == 1);
            #1;

            if (timeout)
                $fatal(1, "Etapa %0d: timeout", step_number);

            if (captured !== requested_frame)
                $fatal(1, "Etapa %0d: frame incorreto",
                       step_number);

            if (r1 !== expected_r1)
                $fatal(1, "Etapa %0d: R1 incorreto",
                       step_number);

            if (expects_extra && extra !== expected_extra)
                $fatal(1, "Etapa %0d: OCR incorreto",
                       step_number);

            if (cs_n !== 1 || sck !== 0 || busy !== 0)
                $fatal(1, "Etapa %0d: SPI nao liberado",
                       step_number);
        end
    endtask

    initial begin
        repeat (5) @(negedge clk);
        rst = 0;

        // CMD55: avisa que o proximo e um ACMD.
        issue_command(
            48'h7700000000FF,
            8'h01, 32'h0, 0, 1
        );
        $display("PASS: CMD55 em estado idle");

        // ACMD41 HCS=1: cartao ainda inicializando.
        issue_command(
            48'h6940000000FF,
            8'h01, 32'h0, 0, 2
        );
        $display("PASS: ACMD41 ainda inicializando");

        // Repetir CMD55 antes do proximo ACMD41.
        issue_command(
            48'h7700000000FF,
            8'h01, 32'h0, 0, 3
        );
        $display("PASS: CMD55 repetido");

        // ACMD41: cartao pronto.
        issue_command(
            48'h6940000000FF,
            8'h00, 32'h0, 0, 4
        );
        $display("PASS: ACMD41 concluiu inicializacao");

        // CMD58: R3 com POWER_UP=1, CCS=1.
        issue_command(
            48'h7A00000000FF,
            8'h00, 32'hC0FF8000, 1, 5
        );

        if (extra[31:30] !== 2'b11 ||
            extra[21:20] == 0)
            $fatal(1, "OCR: capacidade ou tensao invalida");

        $display("PASS: CMD58 OCR e CCS=1");
        $display("PASS: sequencia SDHC simulada");

        $finish;
    end

    initial begin
        #300000;
        $fatal(1, "TIMEOUT global");
    end
endmodule
