`timescale 1ns/1ps

module tb_estilos;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic display_mode = 1'b0;
    logic style_mode   = 1'b0;

    tri1 sda;
    tri1 scl;

    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;
    wire hs;
    wire vs;

    // Regressao da configuracao anterior; modos novos tem banco integrado proprio.
    top_reticula #(.MODOS_OPERACIONAIS(1'b0)) dut (
        .operacao_sw(2'b00),.ack_btn(1'b0),.clk(clk),

        .btn_heading(2'b00),

        .sw(4'b0000),

        .display_mode(display_mode),
        .style_mode(style_mode),

        .vauxp3(1'b0),
        .vauxn3(1'b0),
        .vauxp10(1'b0),
        .vauxn10(1'b0),

        .JOY_LED(),

        .i2c_sda(sda),
        .i2c_scl(scl),

        .VGA_R(r),
        .VGA_G(g),
        .VGA_B(b),

        .VGA_HS(hs),
        .VGA_VS(vs)
    );

    // Reduz debounce apenas para simulacao.
    defparam dut.u_modo.DEBOUNCE_CYCLES   = 4;
    defparam dut.u_estilo.DEBOUNCE_CYCLES = 4;


    task posiciona(
        input integer px,
        input integer py
    );
        begin
            force dut.u_vga.h_cont = px;
            force dut.u_vga.v_cont = py;
            #1;
        end
    endtask


    task automatic confere_rgb(
        input integer px,
        input integer py,
        input logic [11:0] esperado,
        input [255:0] nome
    );
        begin
            posiciona(px, py);

            if ({r,g,b} !== esperado) begin
                $fatal(
                    1,
                    "%0s: pixel=%0d,%0d RGB=%h esperado=%h",
                    nome,
                    px,
                    py,
                    {r,g,b},
                    esperado
                );
            end
        end
    endtask


    task automatic estabiliza_entrada;
        begin
            // Mantem fora do frame boundary enquanto
            // sincronizadores e debounce estabilizam.
            posiciona(10, 10);

            repeat (10)
                @(posedge dut.pixel_clk);

            #1;
        end
    endtask


    task automatic aplica_quadro;
        begin
            // A troca visivel so pode ocorrer no inicio
            // do blanking vertical.
            posiciona(0, 480);

            @(posedge dut.pixel_clk);
            #1;
        end
    endtask


    task automatic seleciona(
        input logic estilo,
        input logic declutter_esperado
    );
        begin
            style_mode   = estilo;
            display_mode = declutter_esperado;

            estabiliza_entrada();
            aplica_quadro();

            if (dut.estilo_caca !== estilo)
                $fatal(
                    1,
                    "estilo_caca=%b esperado=%b",
                    dut.estilo_caca,
                    estilo
                );

            if (dut.declutter !== declutter_esperado)
                $fatal(
                    1,
                    "declutter=%b esperado=%b",
                    dut.declutter,
                    declutter_esperado
                );
        end
    endtask


    initial begin

        // -------------------------------------------------
        // Estado inicial: ORIGINAL + NORMAL
        // -------------------------------------------------

        seleciona(1'b0, 1'b0);

        // Pixel exclusivo da barra antiga de velocidade.
        confere_rgb(
            80,
            110,
            12'h0F0,
            "original normal: barra antiga"
        );

        // Pixel exclusivo da nova fita CAÇA.
        confere_rgb(
            73,
            110,
            12'h000,
            "original normal: caca oculto"
        );

        // Reticulo original possui braço vertical maior.
        confere_rgb(
            320,
            220,
            12'h0F0,
            "original normal: reticulo original"
        );

        $display(
            "PASS estilo 00: HUD original NORMAL"
        );


        // -------------------------------------------------
        // Verifica troca de estilo SOMENTE entre quadros.
        // -------------------------------------------------

        posiciona(10, 10);

        style_mode = 1'b1;

        repeat (10)
            @(posedge dut.pixel_clk);

        #1;

        // Debounce ja aceitou SW1, mas o estilo visivel
        // ainda nao pode mudar durante o quadro.
        if (dut.estilo_caca !== 1'b0)
            $fatal(
                1,
                "SW1 mudou estilo durante quadro ativo"
            );

        aplica_quadro();

        if (dut.estilo_caca !== 1'b1)
            $fatal(
                1,
                "SW1 nao foi aplicado no frame boundary"
            );

        $display(
            "PASS SW1: troca somente entre quadros"
        );


        // -------------------------------------------------
        // CAÇA + NORMAL
        // -------------------------------------------------

        // Nova fita CAÇA ativa.
        confere_rgb(
            73,
            110,
            12'h0F0,
            "caca normal: nova fita"
        );

        // Barra antiga deve desaparecer.
        confere_rgb(
            80,
            110,
            12'h000,
            "caca normal: barra antiga oculta"
        );

        // Reticulo original maior nao deve mais aparecer.
        confere_rgb(
            320,
            205,
            12'h000,
            "caca normal: reticulo antigo oculto"
        );

        // Reticulo CAÇA menor continua presente.
        confere_rgb(
            320,
            224,
            12'h0F0,
            "caca normal: reticulo menor"
        );


        // Novo datum CAÇA:
        // largura total 49 px.
        confere_rgb(
            296,
            240,
            12'h0F0,
            "caca normal: extremo esquerdo datum"
        );

        confere_rgb(
            344,
            240,
            12'h0F0,
            "caca normal: extremo direito datum"
        );

        // Pixel imediatamente fora do braço:
        // pertence ao horizonte, mas cai dentro do
        // clearance de 3 px e deve ficar apagado.
        confere_rgb(
            293,
            240,
            12'h000,
            "caca normal: clearance attitude grid"
        );

        // Um pixel alem do clearance volta a mostrar
        // o horizonte normalmente.
        confere_rgb(
            292,
            240,
            12'h0F0,
            "caca normal: fim do clearance"
        );

        $display(
            "PASS estilo 10: HUD CACA NORMAL"
        );


        // -------------------------------------------------
        // CAÇA + DECLUTTER
        // -------------------------------------------------

        seleciona(1'b1, 1'b1);

        // Escala CAÇA deve desaparecer.
        confere_rgb(
            73,
            110,
            12'h000,
            "caca declutter: escala oculta"
        );

        // Horizonte permanece.
        confere_rgb(
            100,
            240,
            12'h0F0,
            "caca declutter: horizonte preservado"
        );

        // Reticulo permanece.
        confere_rgb(
            320,
            224,
            12'h0F0,
            "caca declutter: reticulo preservado"
        );

        // Marcador de alvo permanece vermelho.
        confere_rgb(
            444,
            156,
            12'hF00,
            "caca declutter: alvo preservado"
        );

        $display(
            "PASS estilo 11: HUD CACA DECLUTTER"
        );


        // -------------------------------------------------
        // ORIGINAL + DECLUTTER
        // -------------------------------------------------

        seleciona(1'b0, 1'b1);

        // Barra original também desaparece.
        confere_rgb(
            80,
            110,
            12'h000,
            "original declutter: escala oculta"
        );

        // Horizonte continua presente.
        confere_rgb(
            100,
            240,
            12'h0F0,
            "original declutter: horizonte preservado"
        );

        // Reticulo original volta a ser usado.
        confere_rgb(
            320,
            220,
            12'h0F0,
            "original declutter: reticulo preservado"
        );

        // Alvo permanece.
        confere_rgb(
            444,
            156,
            12'hF00,
            "original declutter: alvo preservado"
        );

        $display(
            "PASS estilo 01: HUD original DECLUTTER"
        );


        // -------------------------------------------------
        // Blanking nos dois estilos
        // -------------------------------------------------

        seleciona(1'b0, 1'b0);

        confere_rgb(
            700,
            500,
            12'h000,
            "blanking original"
        );

        seleciona(1'b1, 1'b0);

        confere_rgb(
            700,
            500,
            12'h000,
            "blanking caca"
        );

        $display(
            "PASS blanking: original e CACA"
        );


        // -------------------------------------------------
        // Confirma independência SW0 / SW1
        // -------------------------------------------------

        seleciona(1'b0, 1'b0);

        if (
            dut.estilo_caca !== 1'b0 ||
            dut.declutter   !== 1'b0
        )
            $fatal(1, "falha combinacao 00");

        seleciona(1'b0, 1'b1);

        if (
            dut.estilo_caca !== 1'b0 ||
            dut.declutter   !== 1'b1
        )
            $fatal(1, "falha combinacao 01");

        seleciona(1'b1, 1'b0);

        if (
            dut.estilo_caca !== 1'b1 ||
            dut.declutter   !== 1'b0
        )
            $fatal(1, "falha combinacao 10");

        seleciona(1'b1, 1'b1);

        if (
            dut.estilo_caca !== 1'b1 ||
            dut.declutter   !== 1'b1
        )
            $fatal(1, "falha combinacao 11");

        $display(
            "PASS controles: SW0/SW1 independentes nas quatro combinacoes"
        );


        release dut.u_vga.h_cont;
        release dut.u_vga.v_cont;

        $display(
            "PASS todos os testes de estilos"
        );

        $finish;
    end


    initial begin
        #5000000;

        $fatal(
            1,
            "Timeout global tb_estilos"
        );
    end

endmodule
