`timescale 1ns/1ps

module tb_atitude_accel_fixa;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic sensor_ok = 1'b0;
    logic amostra_nova = 1'b0;

    logic signed [15:0] accel_x = 16'sd0;
    logic signed [15:0] accel_y = 16'sd0;
    logic signed [15:0] accel_z = 16'sd16384;

    wire calibrado;
    wire signed [10:0] pitch_px;
    wire signed [9:0] roll_q8;

    atitude_accel_fixa #(
        .CAL_LOG2    (2),
        .FILTER_SHIFT(0)
    ) dut (
        .clk         (clk),
        .sensor_ok   (sensor_ok),
        .amostra_nova(amostra_nova),

        .accel_x     (accel_x),
        .accel_y     (accel_y),
        .accel_z     (accel_z),

        .calibrado   (calibrado),
        .pitch_px    (pitch_px),
        .roll_q8     (roll_q8)
    );

    task automatic envia_amostra(
        input integer x,
        input integer y,
        input integer z
    );
    begin
        accel_x = x;
        accel_y = y;
        accel_z = z;

        @(negedge clk);
        amostra_nova = 1'b1;

        @(negedge clk);
        amostra_nova = 1'b0;

        #1;
    end
    endtask

    task automatic confere(
        input integer pitch_esperado,
        input integer roll_esperado,
        input [255:0] nome
    );
    begin
        if ($signed(pitch_px) !== pitch_esperado)
            $fatal(
                1,
                "%0s: pitch=%0d esperado=%0d",
                nome,
                $signed(pitch_px),
                pitch_esperado
            );

        if ($signed(roll_q8) !== roll_esperado)
            $fatal(
                1,
                "%0s: roll=%0d esperado=%0d",
                nome,
                $signed(roll_q8),
                roll_esperado
            );

        $display(
            "PASS %0s: pitch=%0d roll=%0d",
            nome,
            $signed(pitch_px),
            $signed(roll_q8)
        );
    end
    endtask

    initial begin
        repeat (3) @(posedge clk);

        sensor_ok = 1'b1;

        // Calibracao plana.
        envia_amostra(0, 0, 16384);
        envia_amostra(0, 0, 16384);
        envia_amostra(0, 0, 16384);
        envia_amostra(0, 0, 16384);

        if (!calibrado)
            $fatal(1, "sensor nao calibrou");

        confere(0, 0, "calibracao plana");

        // Frente para baixo -> accel_y negativo -> pitch negativo.
        envia_amostra(0, -8192, 14189);
        confere(-64, 0, "frente para baixo");

        // Tras para baixo -> accel_y positivo -> pitch positivo.
        envia_amostra(0, 8192, 14189);
        confere(64, 0, "tras para baixo");

        // Direita para baixo -> accel_x negativo -> roll positivo.
        envia_amostra(-4096, 0, 15860);
        confere(0, 64, "direita para baixo");

        // Esquerda para baixo -> accel_x positivo -> roll negativo.
        envia_amostra(4096, 0, 15860);
        confere(0, -64, "esquerda para baixo");

        // Saturacao positiva de pitch.
        envia_amostra(0, 16384, 0);
        confere(80, 0, "saturacao pitch");

        // Saturacao positiva de roll.
        envia_amostra(-16384, 0, 0);
        confere(0, 128, "saturacao roll");

        // Perda do sensor deve invalidar a calibracao.
        sensor_ok = 1'b0;
        @(posedge clk);
        #1;

        if (calibrado !== 1'b0)
            $fatal(1, "calibrado deveria zerar sem sensor");

        confere(0, 0, "perda do sensor");

        $display("PASS todos os testes atitude_accel_fixa");
        $finish;
    end

endmodule
