`timescale 1ns/1ps
module tb_hud_high_bank;
    logic [9:0] x=0,y=0;
    logic signed [15:0] sine=0,cosine=16384;
    logic signed [10:0] pitch=0;

    wire h0,a0,d0,t0,v0;
    wire h1,a1,d1,t1,v1;

    simbologia_vga #(
        .FULL_ATTITUDE(1'b1),
        .HIGH_BANK_PITCH_DECLUTTER(1'b0)
    ) original (
        .pixel_x(x),.pixel_y(y),.video_on(1'b1),
        .flight_pixel_y(y),.flight_video_on(1'b1),
        .attitude_sine(sine),.attitude_cosine(cosine),
        .attitude_pitch_px(pitch),
        .horizonte_y(10'd240),.roll_q8(10'sd0),
        .heading_deg(9'd123),
        .alvo_x(10'd430),.alvo_y(9'd180),
        .horizonte_on(h0),.altitude_on(a0),
        .direcao_on(d0),.alvo_on(t0),.velocidade_on(v0)
    );

    simbologia_vga #(
        .FULL_ATTITUDE(1'b1),
        .HIGH_BANK_PITCH_DECLUTTER(1'b1)
    ) lapidado (
        .pixel_x(x),.pixel_y(y),.video_on(1'b1),
        .flight_pixel_y(y),.flight_video_on(1'b1),
        .attitude_sine(sine),.attitude_cosine(cosine),
        .attitude_pitch_px(pitch),
        .horizonte_y(10'd240),.roll_q8(10'sd0),
        .heading_deg(9'd123),
        .alvo_x(10'd430),.alvo_y(9'd180),
        .horizonte_on(h1),.altitude_on(a1),
        .direcao_on(d1),.alvo_on(t1),.velocidade_on(v1)
    );

    task automatic scan(
        input integer bank,
        input logic signed [15:0] sn,cs,
        input integer pitch_degrees,
        input bit simplify
    );
        integer removed;
        begin
            sine=sn;
            cosine=cs;
            pitch=11'(pitch_degrees*4);
            removed=0;

            for(integer yy=0;yy<480;yy+=2)
                for(integer xx=0;xx<640;xx+=2) begin
                    x=10'(xx);
                    y=10'(yy);
                    #1;

                    // Os instrumentos fixos devem ser identicos.
                    if({a0,d0,t0,v0} !== {a1,d1,t1,v1})
                        $fatal(1,"Instrumentos alterados");

                    // Nenhuma marca pode ser acrescentada.
                    if(h1 && !h0)
                        $fatal(1,"Pixel novo no horizonte");

                    // Horizonte principal e marcas preservados.
                    if((original.horizonte_esq ||
                        original.horizonte_dir ||
                        original.marcas_superiores ||
                        original.marcas_inferiores) && !h1)
                        $fatal(1,"Linha essencial removida");

                    if(h0 !== h1) begin
                        if(!simplify ||
                           !original.pitch_numeros ||
                           (original.pitch_nivel != 1 &&
                            original.pitch_nivel != 3))
                            $fatal(1,"Mudanca nao autorizada");
                        removed++;
                    end
                end

            if(simplify && removed==0)
                $fatal(1,"Simplificacao nao atuou");

            if(!simplify && removed!=0)
                $fatal(1,"Regressao na geometria normal");

            $display(
                "PASS bank=%0d pitch=%0d pixels omitidos=%0d",
                bank,pitch_degrees,removed
            );
        end
    endtask

    initial begin
        scan(0,0,16384,0,0);
        scan(30,8192,14189,0,0);
        scan(-30,-8192,14189,0,0);
        scan(59,14047,8438,0,0);
        scan(60,14189,8192,0,1);
        scan(-60,-14189,8192,0,1);
        scan(90,16384,0,0,1);
        scan(-90,-16384,0,0,1);
        scan(120,14189,-8192,0,1);
        scan(150,8192,-14189,0,0);
        scan(90,16384,0,10,1);
        scan(-90,-16384,0,-10,1);
        $display("PASS high-bank: linha, marcas e instrumentos preservados");
        $finish;
    end
endmodule
