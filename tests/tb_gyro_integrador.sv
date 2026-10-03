`timescale 1ns/1ps

module tb_gyro_integrador;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic sensor_ok = 1'b0;
    logic dt_valid = 1'b0;

    logic signed [16:0] gyro_corr = 17'sd0;
    logic [31:0] dt_cycles = 32'd0;

    wire signed [31:0] angulo_q10;

    gyro_integrador dut (
        .clk(clk),
        .sensor_ok(sensor_ok),
        .dt_valid(dt_valid),
        .gyro_corr(gyro_corr),
        .dt_cycles(dt_cycles),
        .angulo_q10(angulo_q10)
    );

    task automatic integra(
        input integer gyro,
        input integer ciclos
    );
    begin
        gyro_corr = gyro;
        dt_cycles = ciclos;

        @(negedge clk);
        dt_valid = 1'b1;

        @(negedge clk);
        dt_valid = 1'b0;

        #1;
    end
    endtask

    initial begin
        repeat (3) @(posedge clk);

        sensor_ok = 1'b1;

        // 10 graus/s por 0,1 s = +1 grau.
        integra(1310, 10_000_000);

        if ($signed(angulo_q10) !== 32'sd1024)
            $fatal(
                1,
                "+1 grau incorreto: %0d",
                $signed(angulo_q10)
            );

        $display(
            "PASS +1 grau: angulo_q10=%0d",
            $signed(angulo_q10)
        );

        // Mais +1 grau.
        integra(1310, 10_000_000);

        if ($signed(angulo_q10) !== 32'sd2048)
            $fatal(
                1,
                "+2 graus incorreto: %0d",
                $signed(angulo_q10)
            );

        $display(
            "PASS acumulacao +2 graus: angulo_q10=%0d",
            $signed(angulo_q10)
        );

        // -1 grau deve retornar exatamente para +1 grau.
        integra(-1310, 10_000_000);

        if ($signed(angulo_q10) !== 32'sd1024)
            $fatal(
                1,
                "integracao negativa assimetrica: %0d",
                $signed(angulo_q10)
            );

        $display(
            "PASS retorno para +1 grau: angulo_q10=%0d",
            $signed(angulo_q10)
        );

        // Perda do sensor reinicia o acumulador.
        sensor_ok = 1'b0;
        @(posedge clk);
        #1;

        if ($signed(angulo_q10) !== 32'sd0)
            $fatal(
                1,
                "angulo deveria zerar: %0d",
                $signed(angulo_q10)
            );

        // Testa movimento pequeno nos dois sentidos usando
        // intervalo proximo ao periodo nominal observado.
        sensor_ok = 1'b1;

        integra(100, 1_174_500);

        if ($signed(angulo_q10) !== 32'sd9)
            $fatal(
                1,
                "movimento pequeno positivo incorreto: %0d",
                $signed(angulo_q10)
            );

        integra(-100, 1_174_500);

        if ($signed(angulo_q10) !== 32'sd0)
            $fatal(
                1,
                "movimento pequeno nao cancelou: %0d",
                $signed(angulo_q10)
            );

        $display("PASS simetria positiva/negativa");
        $display("PASS todos os testes gyro_integrador");

        $finish;
    end

endmodule
