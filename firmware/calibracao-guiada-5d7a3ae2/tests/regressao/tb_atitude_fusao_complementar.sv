`timescale 1ns/1ps

module tb_atitude_fusao_complementar;

    logic clk = 1'b0;

    logic sensor_ok = 1'b0;
    logic accel_calibrado = 1'b0;
    logic gyro_calibrado = 1'b0;
    logic atualizar = 1'b0;

    logic signed [10:0] accel_pitch_px = 11'sd0;
    logic signed [9:0]  accel_roll_q8 = 10'sd0;

    logic signed [31:0] gyro_pitch_q10 = 32'sd0;
    logic signed [31:0] gyro_roll_q10 = 32'sd0;

    logic valido;

    logic signed [31:0] pitch_q10;
    logic signed [31:0] roll_q10;

    always #5 clk = ~clk;

    atitude_fusao_complementar #(
        .CORR_SHIFT(5)
    ) dut (
        .clk            (clk),

        .sensor_ok       (sensor_ok),
        .accel_calibrado (accel_calibrado),
        .gyro_calibrado  (gyro_calibrado),

        .atualizar       (atualizar),

        .accel_pitch_px  (accel_pitch_px),
        .accel_roll_q8   (accel_roll_q8),

        .gyro_pitch_q10  (gyro_pitch_q10),
        .gyro_roll_q10   (gyro_roll_q10),

        .valido          (valido),

        .pitch_q10       (pitch_q10),
        .roll_q10        (roll_q10)
    );

    task automatic atualiza;
        begin
            atualizar = 1'b1;

            @(posedge clk);
            #1;

            atualizar = 1'b0;

            @(posedge clk);
            #1;
        end
    endtask

    task automatic perde_sensor;
        begin
            sensor_ok = 1'b0;

            @(posedge clk);
            #1;

            if (valido !== 1'b0)
                $fatal(1, "fusao deveria ficar invalida");

            if ($signed(pitch_q10) !== 0 ||
                $signed(roll_q10) !== 0)
                $fatal(
                    1,
                    "estado deveria zerar apos perda do sensor: pitch=%0d roll=%0d",
                    $signed(pitch_q10),
                    $signed(roll_q10)
                );
        end
    endtask

    initial begin

        repeat (2) @(posedge clk);

        // -------------------------------------------------
        // Inicializacao plana
        // -------------------------------------------------

        sensor_ok = 1'b1;
        accel_calibrado = 1'b1;
        gyro_calibrado = 1'b1;

        accel_pitch_px = 11'sd0;
        accel_roll_q8 = 10'sd0;

        gyro_pitch_q10 = 32'sd0;
        gyro_roll_q10 = 32'sd0;

        atualiza();

        if (!valido)
            $fatal(1, "fusao deveria estar valida");

        if ($signed(pitch_q10) !== 0 ||
            $signed(roll_q10) !== 0)
            $fatal(1, "atitude inicial deveria ser zero");

        $display("PASS inicializacao plana");

        // -------------------------------------------------
        // Movimento positivo do gyro
        //
        // +10 graus = +10240 Q10.
        //
        // O acelerometro continua em zero.
        //
        // Complementar:
        //
        // 10240 - 10240/32
        // = 10240 - 320
        // = 9920
        // -------------------------------------------------

        gyro_pitch_q10 = 32'sd10240;
        gyro_roll_q10 = 32'sd10240;

        atualiza();

        if ($signed(pitch_q10) !== 32'sd9920 ||
            $signed(roll_q10) !== 32'sd9920)
            $fatal(
                1,
                "fusao positiva incorreta: pitch=%0d roll=%0d esperado=9920",
                $signed(pitch_q10),
                $signed(roll_q10)
            );

        $display(
            "PASS gyro positivo: pitch=%0d roll=%0d",
            $signed(pitch_q10),
            $signed(roll_q10)
        );

        // -------------------------------------------------
        // Perda do sensor deve limpar o estado.
        // -------------------------------------------------

        perde_sensor();

        $display("PASS perda do sensor");

        // -------------------------------------------------
        // Movimento negativo.
        //
        // Verifica simetria da divisao assinada.
        // -------------------------------------------------

        sensor_ok = 1'b1;

        accel_pitch_px = 11'sd0;
        accel_roll_q8 = 10'sd0;

        gyro_pitch_q10 = 32'sd0;
        gyro_roll_q10 = 32'sd0;

        atualiza();

        gyro_pitch_q10 = -32'sd10240;
        gyro_roll_q10 = -32'sd10240;

        atualiza();

        if ($signed(pitch_q10) !== -32'sd9920 ||
            $signed(roll_q10) !== -32'sd9920)
            $fatal(
                1,
                "fusao negativa incorreta: pitch=%0d roll=%0d esperado=-9920",
                $signed(pitch_q10),
                $signed(roll_q10)
            );

        $display(
            "PASS gyro negativo: pitch=%0d roll=%0d",
            $signed(pitch_q10),
            $signed(roll_q10)
        );

        // -------------------------------------------------
        // Nova inicializacao a partir do acelerometro.
        // -------------------------------------------------

        perde_sensor();

        sensor_ok = 1'b1;

        gyro_pitch_q10 = 32'sd0;
        gyro_roll_q10 = 32'sd0;

        // Valida diretamente as escalas usadas na fusao.
        //
        // Pitch:
        //   22 * 458 = 10076 Q10
        //
        // Roll:
        //   44 * 229 = 10076 Q10
        //
        // Os dois representam aproximadamente a mesma
        // pequena inclinacao angular.
        accel_pitch_px = 11'sd22;
        accel_roll_q8 = 10'sd44;

        atualiza();

        if ($signed(pitch_q10) !== 32'sd10076)
            $fatal(
                1,
                "conversao accel pitch incorreta: %0d",
                $signed(pitch_q10)
            );

        if ($signed(roll_q10) !== 32'sd10076)
            $fatal(
                1,
                "conversao accel roll incorreta: %0d",
                $signed(roll_q10)
            );

        $display(
            "PASS referencia accel: pitch=%0d roll=%0d",
            $signed(pitch_q10),
            $signed(roll_q10)
        );

        // -------------------------------------------------
        // Sem atualizar, a saida deve permanecer congelada.
        // -------------------------------------------------

        gyro_pitch_q10 = 32'sd20000;
        gyro_roll_q10 = -32'sd20000;

        repeat (5) @(posedge clk);
        #1;

        if ($signed(pitch_q10) !== 32'sd10076 ||
            $signed(roll_q10) !== 32'sd10076)
            $fatal(1, "estado mudou sem pulso atualizar");

        $display("PASS retencao sem nova amostra");

        $display("PASS todos os testes atitude_fusao_complementar");

        $finish;
    end

endmodule
