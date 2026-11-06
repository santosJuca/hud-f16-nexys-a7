`timescale 1ns/1ps

module tb_roll;

    logic [9:0] x = 192;
    logic [9:0] y = 272;
    logic signed [9:0] roll = 64;
    logic ativo = 1;
    logic [9:0] centro_y = 240;

    wire h, a, d, t, v;

    simbologia_vga dut(
        x,
        y,
        ativo,
    16'sd0,16'sd16384,11'sd0,
        centro_y,
        roll,
        9'd0,
        10'd430,
        9'd180,
        h,
        a,
        d,
        t,
        v
    );

    // Máscara de referência em roll=0, independente das coordenadas do DUT.
    function automatic bit grade(input int px, input int py);
        int ax, nivel, linha, coluna, codigo;
        bit barra, numero;
        logic [14:0] glifo;
        begin
            ax = (px < 0) ? -px : px;
            barra = (ax >= 20 && ax <= 220 && py >= -1 && py <= 1);
            numero = 0;
            for (int n = 1; n <= 4; n++) begin
                if (py >= -40*n && py <= -40*n+1)
                    barra |= ax >= 20 && ax <= ((n <= 2) ? 70 : (n == 3 ? 55 : 42));
                if (py >= 40*n && py <= 40*n+1) begin
                    case (n)
                        1, 2: barra |= (ax >= 20 && ax <= 30) ||
                                       (ax >= 40 && ax <= 50) ||
                                       (ax >= 60 && ax <= 70);
                        // Os tracejados originais não são todos simétricos.
                        3: barra |= (px >= -55 && px <= -47) ||
                                    (px >= -37 && px <= -29) ||
                                    (px >= 20 && px <= 28) ||
                                    (px >= 38 && px <= 46);
                        4: barra |= (ax >= 20 && ax <= 26) ||
                                    (ax >= 36 && ax <= 42);
                    endcase
                end
            end
            coluna = (px < 0) ? px+94 : px-78;
            if (coluna >= 0 && coluna < 16 && coluna % 8 < 6) begin
                for (int n = -4; n <= 4; n++) begin
                    if (n != 0 && py >= n*40-5 && py <= n*40+4) begin
                        nivel = (n < 0) ? -n : n;
                        linha = (py-(n*40-5))/2;
                        codigo = (coluna < 8) ? nivel : 0;
                        case (codigo)
                            0: glifo = 15'b111_101_101_101_111;
                            1: glifo = 15'b010_110_010_010_111;
                            2: glifo = 15'b111_001_111_100_111;
                            3: glifo = 15'b111_001_111_001_111;
                            4: glifo = 15'b101_101_111_001_001;
                        endcase
                        numero |= glifo[14-linha*3-(coluna%8)/2];
                    end
                end
            end
            grade = barra || numero;
        end
    endfunction

    // Divisão com piso, inclusive para produtos negativos não múltiplos de 256.
    function automatic int piso_q8(input int produto);
        piso_q8 = (produto >= 0) ? produto/256 : -((-produto+255)/256);
    endfunction

    logic [3:0] fixos [0:479][0:639];
    task automatic quadro(input int inclinacao, input int centro);
        int u, w;
        bit esperado;
        begin
            roll = 10'(inclinacao);
            centro_y = 10'(centro);
            ativo = 1;
            for (int py = 0; py < 480; py++) begin
                for (int px = 0; px < 640; px++) begin
                    x = 10'(px);
                    y = 10'(py);
                    #1;
                    u = px-320-piso_q8((py-centro)*inclinacao);
                    w = py-centro+piso_q8((px-320)*inclinacao);
                    esperado = grade(u, w);
                    if (h !== esperado)
                        $fatal(1, "Grid roll=%0d centro=%0d x=%0d y=%0d: obtido=%b esperado=%b",
                               inclinacao, centro, px, py, h, esperado);
                    if (inclinacao == 0)
                        fixos[py][px] = {a,d,t,v};
                    else if ({a,d,t,v} !== fixos[py][px])
                        $fatal(1, "Símbolos fixos roll=%0d x=%0d y=%0d: obtido=%b esperado=%b",
                               inclinacao, px, py, {a,d,t,v}, fixos[py][px]);
                    ativo = 0;
                    #1;
                    if ({h,a,d,t,v} !== 5'b0)
                        $fatal(1, "Blanking roll=%0d x=%0d y=%0d: obtido=%b esperado=00000",
                               inclinacao, px, py, {h,a,d,t,v});
                    ativo = 1;
                end
            end
            $display("PASS grid: roll=%0d centro=%0d, 307200 pixels e blanking", inclinacao, centro);
        end
    endtask

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

        quadro(0, 160);
        quadro(0, 320);
        quadro(0, 240);
        // Permite validar a máscara contra o RTL anterior à correção.
        if (!$test$plusargs("SOMENTE_ZERO")) begin
            quadro(64, 240);
            quadro(-64, 240);
            quadro(127, 160);
            quadro(-127, 320);
            quadro(128, 320);
            quadro(-128, 160);
            quadro(511, 240);
            quadro(-512, 240);
        end
        $finish;
    end

endmodule
