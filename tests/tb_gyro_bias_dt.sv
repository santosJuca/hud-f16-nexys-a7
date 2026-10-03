`timescale 1ns/1ps

module tb_gyro_bias_dt;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic sensor_ok = 1'b0;
    logic amostra_nova = 1'b0;

    logic signed [15:0] gyro_x = 16'sd0;
    logic signed [15:0] gyro_y = 16'sd0;

    wire calibrado;
    wire signed [15:0] bias_x;
    wire signed [15:0] bias_y;
    wire signed [16:0] gyro_x_corr;
    wire signed [16:0] gyro_y_corr;
    wire [31:0] dt_cycles;
    wire dt_valid;

    gyro_bias_dt #(
        .CAL_LOG2(2)
    ) dut (
        .clk(clk),
        .sensor_ok(sensor_ok),
        .amostra_nova(amostra_nova),

        .gyro_x(gyro_x),
        .gyro_y(gyro_y),

        .calibrado(calibrado),
        .bias_x(bias_x),
        .bias_y(bias_y),
        .gyro_x_corr(gyro_x_corr),
        .gyro_y_corr(gyro_y_corr),

        .dt_cycles(dt_cycles),
        .dt_valid(dt_valid)
    );

    task automatic envia_amostra(
        input integer gx,
        input integer gy
    );
    begin
        gyro_x = gx;
        gyro_y = gy;

        @(negedge clk);
        amostra_nova = 1'b1;

        @(negedge clk);
        amostra_nova = 1'b0;

        #1;
    end
    endtask

    initial begin
        repeat (3) @(posedge clk);

        sensor_ok = 1'b1;

        // Quatro amostras estacionarias.
        envia_amostra(100, -50);
        envia_amostra(100, -50);
        envia_amostra(100, -50);
        envia_amostra(100, -50);

        if (!calibrado)
            $fatal(1, "giroscopio nao calibrou");

        if ($signed(bias_x) !== 100 ||
            $signed(bias_y) !== -50)
            $fatal(
                1,
                "bias incorreto: x=%0d y=%0d",
                $signed(bias_x),
                $signed(bias_y)
            );

        $display(
            "PASS bias: x=%0d y=%0d",
            $signed(bias_x),
            $signed(bias_y)
        );

        gyro_x = 16'sd125;
        gyro_y = -16'sd20;
        #1;

        if ($signed(gyro_x_corr) !== 25 ||
            $signed(gyro_y_corr) !== 30)
            $fatal(
                1,
                "gyro corrigido incorreto: x=%0d y=%0d",
                $signed(gyro_x_corr),
                $signed(gyro_y_corr)
            );

        $display(
            "PASS correcao: x=%0d y=%0d",
            $signed(gyro_x_corr),
            $signed(gyro_y_corr)
        );

        // Primeira amostra depois da calibracao estabelece
        // referencia temporal e nao publica dt.
        envia_amostra(100, -50);

        if (dt_valid)
            $fatal(1, "primeira referencia nao deve publicar dt");

        // Espera conhecida entre amostras.
        repeat (20) @(posedge clk);

        envia_amostra(100, -50);

        if (!dt_valid)
            $fatal(1, "dt_valid esperado");

        if (dt_cycles == 0)
            $fatal(1, "dt_cycles nao pode ser zero");

        $display(
            "PASS dt: %0d ciclos entre amostras",
            dt_cycles
        );

        // Perda do sensor invalida calibracao e referencia temporal.
        sensor_ok = 1'b0;
        @(posedge clk);
        #1;

        if (calibrado)
            $fatal(1, "calibracao deveria ser invalidada");

        if (dt_valid)
            $fatal(1, "dt_valid deveria ser zero");

        if (bias_x !== 0 || bias_y !== 0)
            $fatal(1, "bias deveria zerar apos perda do sensor");

        $display("PASS perda do sensor: estado temporal reiniciado");
        $display("PASS todos os testes gyro_bias_dt");

        $finish;
    end

endmodule
