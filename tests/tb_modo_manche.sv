`timescale 1ns/1ps

module tb_modo_manche;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic botao_n = 1'b1;
    wire modo_manche;

    controle_modo_manche #(
        .DEBOUNCE_CYCLES(3)
    ) dut (
        .clk         (clk),
        .botao_n     (botao_n),
        .modo_manche (modo_manche)
    );

    initial begin
        // Estado inicial.
        repeat (4) @(posedge clk);
        #1;

        if (modo_manche !== 1'b0)
            $fatal(1, "Deveria iniciar em SENSOR");

        // =================================================
        // PRIMEIRO CLIQUE: SENSOR -> MANCHE
        // =================================================
        botao_n = 1'b0;

        // 2 clocks de sincronizacao + 3 de debounce.
        repeat (5) @(posedge clk);
        #1;

        if (modo_manche !== 1'b1)
            $fatal(1, "Falha SENSOR -> MANCHE");

        // Manter pressionado nao pode gerar novos toggles.
        repeat (10) @(posedge clk);
        #1;

        if (modo_manche !== 1'b1)
            $fatal(1, "Botao mantido causou novo toggle");

        // =================================================
        // SOLTA O BOTAO
        // =================================================
        botao_n = 1'b1;

        repeat (5) @(posedge clk);
        #1;

        if (modo_manche !== 1'b1)
            $fatal(1, "Soltar botao alterou modo indevidamente");

        // =================================================
        // SEGUNDO CLIQUE: MANCHE -> SENSOR
        // =================================================
        botao_n = 1'b0;

        repeat (5) @(posedge clk);
        #1;

        if (modo_manche !== 1'b0)
            $fatal(1, "Falha MANCHE -> SENSOR");

        // Solta novamente.
        botao_n = 1'b1;
        repeat (5) @(posedge clk);
        #1;

        if (modo_manche !== 1'b0)
            $fatal(1, "Modo final deveria permanecer SENSOR");

        $display(
            "PASS modo manche: SENSOR/MANCHE por toggle, debounce e retencao"
        );

        $finish;
    end

endmodule
