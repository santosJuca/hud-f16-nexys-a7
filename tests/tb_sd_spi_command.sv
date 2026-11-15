`timescale 1ns/1ps

module tb_sd_spi_command;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg miso = 1;

    reg [47:0] command_frame = 48'h48000001AA87;
    reg long_response = 1;

    // 0: resposta valida
    // 1: resposta com eco incorreto
    // 2: cartao sem resposta
    integer mode = 0;

    wire sck, mosi, cs_n, busy, done, timeout;
    wire [7:0] r1;
    wire [31:0] extra;

    integer edges = 0;
    reg [47:0] captured = 0;
    reg [31:0] simulated_extra = 32'h000001AA;

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

    // Captura os 48 bits transmitidos pelo controlador.
    always @(posedge sck) begin
        if (!cs_n) begin
            if (edges < 48)
                captured = {captured[46:0], mosi};

            edges = edges + 1;
        end
    end

    // Modelo simplificado da resposta do microSD.
    always @(negedge sck) begin
        if (!cs_n) begin
            if (mode == 2 || edges < 56)
                miso = 1'b1;
            else if (edges < 64)
                miso = (8'h01 >> (63-edges)) & 1;
            else if (edges < 96)
                miso = (simulated_extra >> (95-edges)) & 1;
            else
                miso = 1'b1;
        end
    end

    task run_command;
        input integer test_mode;
        begin
            @(negedge clk);
            mode = test_mode;
            edges = 0;
            captured = 0;
            miso = 1;
            simulated_extra =
                test_mode == 1 ? 32'h000001AB :
                                 32'h000001AA;

            start = 1;
            @(negedge clk);
            start = 0;

            wait (done);
            #1;

            if (captured !== 48'h48000001AA87)
                $fatal(1, "Frame CMD8 incorreto");

            if (cs_n !== 1 || sck !== 0 || busy !== 0)
                $fatal(1, "SPI nao retornou ao estado inativo");
        end
    endtask

    initial begin
        repeat (5) @(negedge clk);
        rst = 0;

        run_command(0);

        if (timeout || r1 !== 8'h01 ||
            extra !== 32'h000001AA)
            $fatal(1, "CMD8: resposta R7 incorreta");

        $display("PASS: CMD8 R7 valido");

        run_command(1);

        if (timeout || r1 !== 8'h01 ||
            extra !== 32'h000001AB)
            $fatal(1, "CMD8: eco incorreto nao capturado");

        $display("PASS: CMD8 eco incorreto detectavel");

        run_command(2);

        if (!timeout || r1 !== 8'hFF)
            $fatal(1, "CMD8: timeout incorreto");

        $display("PASS: CMD8 timeout controlado");
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "TIMEOUT global");
    end
endmodule
