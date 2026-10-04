`timescale 1ns/1ps

module tb_numeros;

    logic [9:0] x = 0;
    logic [9:0] y = 0;

    logic [9:0] vel = 280;
    logic [16:0] alt = 11220;

    logic ativo = 1'b1;

    wire on;

    numeros_hud dut (
        .pixel_x(x),
        .pixel_y(y),
        .video_on(ativo),
        .velocidade_kt(vel),
        .altitude_ft(alt),
        .numeros_on(on)
    );

    logic [14:0] referencia [0:9];


    task automatic digito(
        input integer inicio_x,
        input integer inicio_y,
        input integer numero
    );
        begin

            for (integer py = 0; py < 10; py++) begin

                for (integer px = 0; px < 8; px++) begin

                    x = 10'(inicio_x + px);
                    y = 10'(inicio_y + py);

                    #1;

                    if (
                        on !==
                        (
                            (px < 6)
                            ?
                            referencia[numero][
                                14 -
                                (
                                    (py/2)*3 +
                                    px/2
                                )
                            ]
                            :
                            1'b0
                        )
                    )
                        $fatal(
                            1,
                            "Digito=%0d x=%0d y=%0d incorreto",
                            numero,
                            x,
                            y
                        );
                end
            end
        end
    endtask


    initial begin

        referencia[0] = 15'b111101101101111;
        referencia[1] = 15'b010110010010111;
        referencia[2] = 15'b111001111100111;
        referencia[3] = 15'b111001111001111;
        referencia[4] = 15'b101101111001001;
        referencia[5] = 15'b111100111001111;
        referencia[6] = 15'b111100111101111;
        referencia[7] = 15'b111001010010010;
        referencia[8] = 15'b111101111101111;
        referencia[9] = 15'b111101111001111;


        // ---------------------------------------------
        // Valor atual central
        // ---------------------------------------------

        vel = 123;
        alt = 45678;

        digito(46, 235, 1);
        digito(54, 235, 2);
        digito(62, 235, 3);

        digito(572, 235, 4);
        digito(580, 235, 5);
        digito(588, 235, 6);
        digito(596, 235, 7);
        digito(604, 235, 8);


        // ---------------------------------------------
        // Escalas arredondadas
        //
        // vel=280 -> topo = 360
        // alt=11220 -> base=11200 -> topo=11800
        // ---------------------------------------------

        vel = 280;
        alt = 11220;

        digito(46, 95, 3);
        digito(54, 95, 6);
        digito(62, 95, 0);

        // Altitude:
        // base 11200 + 600 = 11800 no topo.
        digito(572, 85, 1);
        digito(580, 85, 1);
        digito(588, 85, 8);
        digito(596, 85, 0);
        digito(604, 85, 0);


        // ---------------------------------------------
        // Molduras centrais
        // ---------------------------------------------

        x = 42;
        y = 228;
        #1;

        if (!on)
            $fatal(1, "Moldura da velocidade ausente");


        x = 568;
        y = 228;
        #1;

        if (!on)
            $fatal(1, "Moldura da altitude ausente");


        // ---------------------------------------------
        // Unidade FT reposicionada
        // ---------------------------------------------

        x = 584;
        y = 424;
        #1;

        if (!on)
            $fatal(
                1,
                "FT deve aparecer centralizado abaixo da altitude"
            );


        // A antiga posicao vertical de FT deve estar livre.
        x = 584;
        y = 402;
        #1;

        if (on)
            $fatal(
                1,
                "FT ainda aparece na posicao antiga"
            );


        // ---------------------------------------------
        // Zero à esquerda
        // ---------------------------------------------

        vel = 7;

        x = 46;
        y = 235;
        #1;

        if (on)
            $fatal(
                1,
                "Zero a esquerda da velocidade deve ficar vazio"
            );


        // ---------------------------------------------
        // Valor negativo da escala não pode dar wrap.
        // ---------------------------------------------

        vel = 0;

        for (
            integer px = 46;
            px < 70;
            px = px + 1
        ) begin

            for (
                integer py = 375;
                py < 385;
                py = py + 1
            ) begin

                x = 10'(px);
                y = 10'(py);

                #1;

                if (on)
                    $fatal(
                        1,
                        "Escala negativa deu wrap"
                    );
            end
        end


        // ---------------------------------------------
        // Blanking
        // ---------------------------------------------

        ativo = 1'b0;

        x = 46;
        y = 235;

        #1;

        if (on)
            $fatal(
                1,
                "Blanking dos numeros"
            );


        $display(
            "PASS numeros: fitas arredondadas, valor central, molduras, zeros e limites"
        );

        $finish;

    end

endmodule
