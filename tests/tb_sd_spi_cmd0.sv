`timescale 1ns/1ps

module tb_sd_spi_cmd0;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg miso = 1;
    reg send_response = 1;

    wire power_n, pre_sck, pre_mosi, pre_cs, pre_ready;
    wire sck, mosi, cs_n, done, success;
    wire [7:0] r1;

    integer edges = 0;
    reg [47:0] captured = 0;

    always #5 clk = ~clk;

    sd_spi_preamble #(
        .POWERUP_CYCLES(20),
        .HALF_PERIOD_CYCLES(3)
    ) preamble (
        .clk(clk), .rst(rst),
        .sd_reset(power_n),
        .sd_sck(pre_sck),
        .sd_cmd(pre_mosi),
        .sd_cs_n(pre_cs),
        .ready(pre_ready)
    );

    sd_spi_cmd0 #(
        .HALF_PERIOD_CYCLES(3),
        .MAX_RESPONSE_CLOCKS(32)
    ) dut (
        .clk(clk), .rst(rst), .start(start),
        .miso(miso), .sck(sck), .mosi(mosi),
        .cs_n(cs_n), .done(done),
        .success(success), .r1(r1)
    );

    always @(posedge sck) begin
        if (!cs_n) begin
            if (edges < 48)
                captured = {captured[46:0], mosi};
            edges = edges + 1;
        end
    end

    // Cartao simulado: 8 clocks de espera e R1=0x01.
    always @(negedge sck) begin
        if (!cs_n) begin
            if (!send_response || edges < 56)
                miso = 1;
            else if (edges < 64)
                miso = (8'h01 >> (7 - (edges - 56))) & 1;
            else
                miso = 1;
        end
    end

    task launch;
    begin
        wait(pre_ready);
        @(negedge clk);
        start = 1;
        @(negedge clk);
        start = 0;
        wait(done);
        #1;
    end
    endtask

    initial begin
        repeat (5) @(negedge clk);
        rst = 0;

        launch();

        if (!success || r1 !== 8'h01)
            $fatal(1, "CMD0: resposta incorreta");

        if (captured !== 48'h400000000095)
            $fatal(1, "CMD0: bytes transmitidos incorretos");

        if (cs_n !== 1 || sck !== 0 || power_n !== 0)
            $fatal(1, "CMD0: estado final incorreto");

        $display("PASS: CMD0 recebeu R1=0x01");

        @(negedge clk);
        rst = 1;
        send_response = 0;
        miso = 1;
        edges = 0;
        captured = 0;

        repeat (5) @(negedge clk);
        rst = 0;

        launch();

        if (success || cs_n !== 1 || sck !== 0)
            $fatal(1, "CMD0: timeout incorreto");

        $display("PASS: CMD0 timeout controlado");
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "TIMEOUT global");
    end
endmodule
