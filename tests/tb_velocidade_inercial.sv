`timescale 1ns/1ps

module tb_velocidade_inercial;

    logic clk = 0;
    always #5 clk = ~clk;

    logic sensor_ok = 0;
    logic amostra_nova = 0;

    logic signed [15:0] accel_forward = 0;
    logic signed [10:0] pitch_px = 0;

    logic atitude_valida = 0;

    logic dt_valid = 0;
    logic [31:0] dt_cycles = 32'd1000000;

    wire calibrado;
    wire valido;
    wire [9:0] velocidade_kt;

    velocidade_inercial dut (
        .clk(clk),

        .sensor_ok(sensor_ok),
        .amostra_nova(amostra_nova),

        .accel_forward(accel_forward),

        .pitch_px(pitch_px),
        .atitude_valida(atitude_valida),

        .dt_valid(dt_valid),
        .dt_cycles(dt_cycles),

        .calibrado(calibrado),
        .valido(valido),

        .velocidade_kt(velocidade_kt)
    );


    task automatic amostra(
        input signed [15:0] accel,
        input signed [10:0] pitch,
        input logic usar_dt
    );
        begin

            accel_forward = accel;
            pitch_px = pitch;

            dt_valid = usar_dt;
            amostra_nova = 1'b1;

            @(posedge clk);
            #1;

            amostra_nova = 1'b0;
            dt_valid = 1'b0;

            @(posedge clk);
            #1;

        end
    endtask


    integer antes_tilt;


    initial begin

        repeat (4)
            @(posedge clk);

        sensor_ok = 1'b1;

        // -------------------------------------------------
        // Calibracao:
        // bias artificial = +1000 counts
        // -------------------------------------------------

        for (integer i=0; i<64; i++)
            amostra(16'sd1000, 11'sd0, 1'b0);

        if (!calibrado)
            $fatal(1, "Velocidade nao calibrada");

        atitude_valida = 1'b1;

        repeat (3)
            @(posedge clk);

        if (!valido)
            $fatal(1, "Velocidade deveria estar valida");

        if (velocidade_kt != 0)
            $fatal(
                1,
                "Velocidade inicial=%0d esperado=0",
                velocidade_kt
            );


        // -------------------------------------------------
        // +1g longitudinal durante aproximadamente 1 s
        //
        // 100 amostras * 10 ms
        //
        // Esperado aproximadamente 19 kt.
        // -------------------------------------------------

        for (integer i=0; i<100; i++)
            amostra(
                16'sd17384,
                11'sd0,
                1'b1
            );

        repeat (5)
            @(posedge clk);

        if (
            velocidade_kt < 10'd18 ||
            velocidade_kt > 10'd21
        )
            $fatal(
                1,
                "Integracao +1g: velocidade=%0d kt",
                velocidade_kt
            );

        $display(
            "PASS +1g: velocidade=%0d kt",
            velocidade_kt
        );


        // -------------------------------------------------
        // Teste da compensacao de pitch.
        //
        // pitch = +40 px
        // compensacao = 40*72 = 2880 counts.
        //
        // Bias=1000.
        // Raw=3880 deve resultar aproximadamente em zero.
        // -------------------------------------------------

        antes_tilt = velocidade_kt;

        for (integer i=0; i<20; i++)
            amostra(
                16'sd3880,
                11'sd40,
                1'b1
            );

        repeat (5)
            @(posedge clk);

        if (
            velocidade_kt < antes_tilt - 1 ||
            velocidade_kt > antes_tilt + 1
        )
            $fatal(
                1,
                "Compensacao pitch alterou velocidade: antes=%0d depois=%0d",
                antes_tilt,
                velocidade_kt
            );

        $display(
            "PASS compensacao de pitch"
        );


        // -------------------------------------------------
        // -1g longitudinal por aproximadamente 1 s.
        // Deve trazer a velocidade de volta proximo de zero.
        // -------------------------------------------------

        for (integer i=0; i<100; i++)
            amostra(
                -16'sd15384,
                11'sd0,
                1'b1
            );

        repeat (5)
            @(posedge clk);

        if (velocidade_kt > 10'd1)
            $fatal(
                1,
                "Desaceleracao: velocidade=%0d kt esperado ~0",
                velocidade_kt
            );

        $display(
            "PASS desaceleracao: velocidade=%0d kt",
            velocidade_kt
        );


        // -------------------------------------------------
        // Perda do MPU
        // -------------------------------------------------

        sensor_ok = 1'b0;

        repeat (3)
            @(posedge clk);

        if (calibrado || valido || velocidade_kt != 0)
            $fatal(
                1,
                "Perda do sensor nao reiniciou velocidade"
            );

        $display(
            "PASS velocidade inercial: calibracao, integracao, pitch, saturacao e perda de sensor"
        );

        $finish;
    end

endmodule
