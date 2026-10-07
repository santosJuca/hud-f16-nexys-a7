`timescale 1ns/1ps
module tb_alertas_vga;
    logic [9:0] pixel_x=0,pixel_y=0; logic video_on=1;
    logic [31:0] metadados=32'h78;
    wire on; wire [11:0] rgb;
    integer pontos;
    alertas_vga dut(.*);
    initial begin
        for(int sev=1;sev<=3;sev++) begin
            metadados[10:9]=2'(sev); metadados[13:11]=1; pontos=0;
            for(int y=10;y<32;y++) for(int x=278;x<324;x++) begin
                pixel_x=10'(x);pixel_y=10'(y); #1;
                if(on) begin
                    pontos++;
                    if(rgb!==(sev==3?12'hF00:sev==2?12'hFA0:12'h0FF)) $fatal(1,"Cor severity=%0d: %h",sev,rgb);
                end
            end
            if(pontos<30) $fatal(1,"Texto severity=%0d nao desenhado",sev);
        end
        video_on=0;
        for(int y=0;y<120;y++) for(int x=0;x<340;x++) begin
            pixel_x=10'(x);pixel_y=10'(y);#1;
            if(on || rgb!=0) $fatal(1,"Blanking: pixel=%0d,%0d",x,y);
        end
        $display("PASS overlay: textos, cores de prioridade e blanking");$finish;
    end
endmodule
