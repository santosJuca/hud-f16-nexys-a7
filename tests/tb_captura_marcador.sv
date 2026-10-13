`timescale 1ns/1ps
module tb_captura_marcador;
    logic [9:0] pixel_x=0, pixel_y=0;
    logic video_on=1;
    logic [9:0] alvo_x=430;
    logic [8:0] alvo_y=180;
    wire horizonte, altitude, direcao, alvo, velocidade;
    string outdir="build/tests";
    integer fd;
    integer cena;
    integer x, y;
    integer cx[0:7];
    integer cy[0:7];
    string nome;

    simbologia_vga dut (
        .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on),
        .horizonte_y(10'd240), .roll_q8(10'sd0), .heading_deg(9'd0),
        .alvo_x(alvo_x), .alvo_y(alvo_y), .horizonte_on(horizonte),
        .altitude_on(altitude), .direcao_on(direcao), .alvo_on(alvo),
        .velocidade_on(velocidade)
    );

    task automatic verifica_pixel(input integer px, input integer py);
        begin
            pixel_x=10'(px); pixel_y=10'(py); #1;
            if (alvo !== 1'b1)
                $fatal(1,"Marcador ausente em pixel (%0d,%0d), centro (%0d,%0d)",px,py,alvo_x,alvo_y);
        end
    endtask

    initial begin
        if ($value$plusargs("OUTDIR=%s",outdir)==0) outdir="build/tests";
        cx[0]=430; cy[0]=180;
        cx[1]=300; cy[1]=180;
        cx[2]=560; cy[2]=180;
        cx[3]=430; cy[3]=80;
        cx[4]=430; cy[4]=400;
        cx[5]=24; cy[5]=455;
        cx[6]=615; cy[6]=455;
        cx[7]=24; cy[7]=24;
        for (cena=0;cena<8;cena=cena+1) begin
            alvo_x=10'(cx[cena]); alvo_y=9'(cy[cena]); #1;
            verifica_pixel(cx[cena]-24,cy[cena]-24);
            verifica_pixel(cx[cena]+24,cy[cena]-24);
            verifica_pixel(cx[cena]-24,cy[cena]+24);
            verifica_pixel(cx[cena]+24,cy[cena]+24);
            $sformat(nome,"%s/marcador_%0d.ppm",outdir,cena);
            fd=$fopen(nome,"w");
            if (!fd) $fatal(1,"Falha criando captura %s",nome);
            $fdisplay(fd,"P3\n640 480\n255");
            for (y=0;y<480;y=y+1) begin
                for (x=0;x<640;x=x+1) begin
                    pixel_x=10'(x); pixel_y=10'(y); #1;
                    if (alvo) $fwrite(fd,"255 0 0 ");
                    else $fwrite(fd,"0 0 0 ");
                end
                $fwrite(fd,"\n");
            end
            $fclose(fd);
        end
        $display("PASS captura marcador: quatro cantos RTL e 8 posições incluindo os quatro limites");
        $finish;
    end
endmodule
