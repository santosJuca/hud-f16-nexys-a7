`timescale 1ns/1ps

module tb_velocidade_inercial_dt_real;

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

    velocidade_inercial #(
        .CAL_LOG2(2)
    ) dut (
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

    task automatic pulse_amostra;
        begin
            amostra_nova = 1'b1;
            @(posedge clk);
            #1;
            amostra_nova = 1'b0;
            @(posedge clk);
            #1;
        end
    endtask

    task automatic pulse_dt;
        begin
            dt_valid = 1'b1;
            @(posedge clk);
            #1;

            dt_valid = 1'b0;

            repeat (4) begin
                @(posedge clk);
                #1;
            end
        end
    endtask

    initial begin

        repeat (3)
            @(posedge clk);

        sensor_ok = 1'b1;

        // Calibracao parada.
        accel_forward = 16'sd0;

        repeat (4)
            pulse_amostra();

        if (!calibrado)
            $fatal(1, "Nao calibrado");

        atitude_valida = 1'b1;

        // Simula o comportamento real:
        // primeiro o MPU publica a amostra,
        // depois dt_valid chega.
        accel_forward = 16'sd16384;

        repeat (20) begin
            pulse_amostra();
            pulse_dt();
        end

        if (velocidade_kt == 0)
            $fatal(
                1,
                "dt_valid atrasado nao integrou velocidade"
            );

        $display(
            "PASS timing real: amostra_nova antes de dt_valid, velocidade=%0d kt",
            velocidade_kt
        );

        $finish;
    end

endmodule
