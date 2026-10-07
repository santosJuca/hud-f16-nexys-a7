`timescale 1ns/1ps

module tb_frames_estilos;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    tri1 sda;
    tri1 scl;

    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;

    wire hs;
    wire vs;

    integer arquivo;
    integer x;
    integer y;


    // Regressao da configuracao anterior; modos novos tem banco integrado proprio.
    top_reticula #(.MODOS_OPERACIONAIS(1'b0)) dut (
        .operacao_sw(2'b00),.ack_btn(1'b0),.clk(clk),

        .btn_heading(2'b00),

        .sw(4'b0000),

        .display_mode(1'b0),
        .style_mode(1'b0),

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


    task render_original;
        begin

            arquivo =
                $fopen(
                    "build/hud_original_pitch_roll.ppm",
                    "w"
                );

            if (arquivo == 0)
                $fatal(
                    1,
                    "Nao foi possivel criar PPM original"
                );

            $fwrite(
                arquivo,
                "P3\n640 480\n255\n"
            );


            // -------------------------------------------------
            // Mesma atitude nos dois estilos.
            //
            // horizonte_y = 280:
            // pitch positivo -> horizonte abaixo do centro.
            //
            // roll_q8 = +64:
            // banco positivo para direita,
            // horizonte contrarrota em "/".
            // -------------------------------------------------

            force dut.horizonte_y   = 10'd280;
            force dut.roll_q8       = 10'sd64;
            force dut.heading_deg   = 9'd123;

            force dut.velocidade_kt = 10'd280;
            force dut.altitude_ft   = 17'd36000;

            force dut.declutter     = 1'b0;
            force dut.estilo_caca   = 1'b0;


            for (y = 0; y < 480; y = y + 1) begin

                for (x = 0; x < 640; x = x + 1) begin

                    force dut.u_vga.h_cont = x;
                    force dut.u_vga.v_cont = y;

                    #1;

                    $fwrite(
                        arquivo,
                        "%0d %0d %0d\n",
                        r * 17,
                        g * 17,
                        b * 17
                    );

                end
            end

            $fclose(arquivo);

            $display(
                "PASS imagem original: build/hud_original_pitch_roll.ppm"
            );

        end
    endtask


    task render_caca;
        begin

            arquivo =
                $fopen(
                    "build/hud_caca_pitch_roll.ppm",
                    "w"
                );

            if (arquivo == 0)
                $fatal(
                    1,
                    "Nao foi possivel criar PPM CACA"
                );

            $fwrite(
                arquivo,
                "P3\n640 480\n255\n"
            );


            // -------------------------------------------------
            // Exatamente os mesmos dados da imagem original.
            // Somente o estilo muda.
            // -------------------------------------------------

            force dut.horizonte_y   = 10'd280;
            force dut.roll_q8       = 10'sd64;
            force dut.heading_deg   = 9'd123;

            force dut.velocidade_kt = 10'd280;
            force dut.altitude_ft   = 17'd36000;

            force dut.declutter     = 1'b0;
            force dut.estilo_caca   = 1'b1;


            for (y = 0; y < 480; y = y + 1) begin

                for (x = 0; x < 640; x = x + 1) begin

                    force dut.u_vga.h_cont = x;
                    force dut.u_vga.v_cont = y;

                    #1;

                    $fwrite(
                        arquivo,
                        "%0d %0d %0d\n",
                        r * 17,
                        g * 17,
                        b * 17
                    );

                end
            end

            $fclose(arquivo);

            $display(
                "PASS imagem CACA: build/hud_caca_pitch_roll.ppm"
            );

        end
    endtask


    initial begin

        #100;

        render_original();
        render_caca();


        release dut.u_vga.h_cont;
        release dut.u_vga.v_cont;

        release dut.horizonte_y;
        release dut.roll_q8;
        release dut.heading_deg;

        release dut.velocidade_kt;
        release dut.altitude_ft;

        release dut.declutter;
        release dut.estilo_caca;


        $display(
            "PASS comparacao visual ORIGINAL x CACA"
        );

        $finish;

    end

endmodule
