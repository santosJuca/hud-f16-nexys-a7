`timescale 1ns/1ps

module tb_sd_spi_startup;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg miso = 1;

    reg [47:0] frame = 0;
    reg long_response = 0;

    wire sd_reset;
    wire pre_sck, pre_mosi, pre_cs, pre_ready;
    wire cmd_sck, cmd_mosi, cmd_cs;
    wire busy, done, timeout;
    wire [7:0] r1;
    wire [31:0] extra;

    wire sd_sck  = pre_ready ? cmd_sck  : pre_sck;
    wire sd_mosi = pre_ready ? cmd_mosi : pre_mosi;
    wire sd_cs   = pre_ready ? cmd_cs   : pre_cs;

    integer preamble_edges = 0;
    integer tx_edges = 0;
    integer transaction = 0;
    reg [47:0] captured = 0;

    always #5 clk = ~clk;

    sd_spi_preamble #(
        .POWERUP_CYCLES(20),
        .HALF_PERIOD_CYCLES(3)
    ) preamble (
        .clk(clk),
        .rst(rst),
        .sd_reset(sd_reset),
        .sd_sck(pre_sck),
        .sd_cmd(pre_mosi),
        .sd_cs_n(pre_cs),
        .ready(pre_ready)
    );

    sd_spi_command #(
        .HALF_PERIOD_CYCLES(3),
        .MAX_WAIT_R1_CLOCKS(32)
    ) command (
        .clk(clk),
        .rst(rst),
        .start(start),
        .command_frame(frame),
        .long_response(long_response),
        .miso(miso),
        .sck(cmd_sck),
        .mosi(cmd_mosi),
        .cs_n(cmd_cs),
        .busy(busy),
        .done(done),
        .timeout(timeout),
        .r1(r1),
        .extra(extra)
    );

    // Monitor do barramento SPI.
    always @(posedge sd_sck) begin
        if (!pre_ready) begin
            if (sd_cs !== 1'b1 ||
                sd_mosi !== 1'b1 ||
                sd_reset !== 1'b0)
                $fatal(1, "Preamble: sinais invalidos");

            preamble_edges = preamble_edges + 1;
        end else if (!sd_cs) begin
            if (tx_edges < 48)
                captured = {captured[46:0], sd_mosi};

            tx_edges = tx_edges + 1;
        end
    end

    // Modelo do cartao SD.
    // CMD0: R1 = 01
    // CMD8: R1 = 01, R7 = 000001AA
    always @(negedge sd_sck) begin
        if (pre_ready && !sd_cs) begin
            if (tx_edges >= 56 && tx_edges < 64) begin
                miso = (8'h01 >> (63-tx_edges)) & 1;
            end else if (transaction == 2 &&
                         tx_edges >= 64 &&
                         tx_edges < 96) begin
                miso = (32'h000001AA >>
                        (95-tx_edges)) & 1;
            end else begin
                miso = 1;
            end
        end else begin
            miso = 1;
        end
    end

    task run_command;
        input [47:0] requested_frame;
        input requested_long;
        input integer requested_transaction;

        begin
            @(negedge clk);

            frame = requested_frame;
            long_response = requested_long;
            transaction = requested_transaction;
            tx_edges = 0;
            captured = 0;
            miso = 1;

            start = 1;
            @(negedge clk);
            start = 0;

            wait(done);
            #1;

            if (timeout)
                $fatal(1, "Comando: timeout inesperado");

            if (captured !== requested_frame)
                $fatal(1, "Comando: bytes incorretos");

            if (sd_cs !== 1 ||
                sd_sck !== 0 ||
                busy !== 0)
                $fatal(1, "SPI: estado final invalido");
        end
    endtask

    initial begin
        repeat (5) @(negedge clk);
        rst = 0;

        wait(pre_ready);
        #1;

        if (preamble_edges != 80)
            $fatal(1, "Preamble: nao gerou 80 clocks");

        if (sd_reset !== 0)
            $fatal(1, "Alimentacao SD nao habilitada");

        $display("PASS: preamble integrado, 80 clocks");

        run_command(48'h400000000095, 0, 1);

        if (r1 !== 8'h01)
            $fatal(1, "CMD0: R1 incorreto");

        $display("PASS: CMD0 integrado");

        run_command(48'h48000001AA87, 1, 2);

        if (r1 !== 8'h01 ||
            extra !== 32'h000001AA)
            $fatal(1, "CMD8: R7 incorreto");

        $display("PASS: CMD8 integrado");

        $display("PASS: sequencia CMD0 -> CMD8");
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "TIMEOUT global");
    end
endmodule
