`timescale 1ns/1ps

module tb_roll;

    logic [9:0] x = 192;
    logic [9:0] y = 272;
    logic signed [9:0] roll = 64;
    logic ativo = 1;

    wire h, a, d, t, v;

    simbologia_vga dut(
        x,
        y,
        ativo,
        10'd240,
        roll,
        9'd0,
        h,
        a,
        d,
        t,
        v
    );

    initial begin
        // Roll positivo = banco da aeronave para a direita.
        // Horizonte estabilizado deve girar visualmente no sentido oposto.
        #1;
        if (!h)
            $fatal(1, "Roll positivo: esquerda deveria descer");

        x = 448;
        y = 208;
        #1;
        if (!h)
            $fatal(1, "Roll positivo: direita deveria subir");

        // A linha nao pode permanecer horizontal quando existe roll.
        y = 240;
        #1;
        if (h)
            $fatal(1, "Horizonte permaneceu horizontal");

        // Roll negativo = banco para a esquerda.
        // O horizonte deve novamente girar no sentido oposto.
        roll = -64;
        y = 272;
        #1;
        if (!h)
            $fatal(1, "Roll negativo: direita deveria descer");

        x = 192;
        y = 208;
        #1;
        if (!h)
            $fatal(1, "Roll negativo: esquerda deveria subir");

        // Escalas laterais permanecem fixas.
        x = 80;
        y = 200;
        #1;
        if (!v)
            $fatal(1, "Escala de velocidade deslocada pelo roll");

        // Nenhum simbolo durante blanking.
        ativo = 0;
        #1;
        if (h || a || d || t || v)
            $fatal(1, "Blanking com roll");

        $display(
            "PASS roll: horizonte contrarrota nos dois sentidos e escala fixa"
        );

        $finish;
    end

endmodule
