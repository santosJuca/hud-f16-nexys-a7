`timescale 1ns/1ps
module tb_sd_status_display;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, enabled=0;
    reg diagnostic_switch=1;
    reg [2:0] operation_status=0;
    reg [3:0] page_switches=0;
    reg [31:0] value=32'h76543210;
    wire [3:0] page;
    wire [6:0] segments;
    wire [7:0] anodes;
    wire dp;
    integer i,digit,seen;
    reg [6:0] glyph [0:15];
    sd_status_display #(.SCAN_BITS(1),.SHOW_OPERATION_MODE(1)) dut(.*);
    task check_word(input [55:0] expected);
        integer covered;
        begin
            covered=0;
            repeat(32) begin
                @(negedge clk);
                for(int d=0;d<8;d++) if(!anodes[d]) begin
                    if(anodes !== ~(8'b1<<d) || !dp) $fatal(1,"Varredura do modo incorreta");
                    if(segments !== expected[d*7 +:7])
                        $fatal(1,"Modo %b digito %0d: segmentos %h, esperado %h",operation_status,d,segments,expected[d*7 +:7]);
                    covered=covered|(1<<d);
                end
            end
            if(covered!=255) $fatal(1,"Modo nao percorreu os oito digitos");
        end
    endtask
    initial begin
        glyph[0]=7'h40; glyph[1]=7'h79; glyph[2]=7'h24; glyph[3]=7'h30;
        glyph[4]=7'h19; glyph[5]=7'h12; glyph[6]=7'h02; glyph[7]=7'h78;
        glyph[8]=7'h00; glyph[9]=7'h10; glyph[10]=7'h08; glyph[11]=7'h03;
        glyph[12]=7'h46; glyph[13]=7'h21; glyph[14]=7'h06; glyph[15]=7'h0E;
        repeat(3) @(negedge clk);
        if(anodes!=8'hFF || segments!=7'h7F || !dp) $fatal(1,"Display desabilitado nao apagou");
        rst=0; enabled=1; page_switches=9;
        repeat(3) @(negedge clk);
        if(page!=9) $fatal(1,"Seletor de pagina nao sincronizado");
        seen=0;
        for(i=0;i<32;i=i+1) begin
            @(negedge clk);
            for(digit=0;digit<8;digit=digit+1) if(!anodes[digit]) begin
                if(anodes !== ~(8'b1<<digit)) $fatal(1,"Mais de um anodo ativo");
                if(segments!==glyph[(value>>(digit*4))&15]) $fatal(1,"Digito/glyph desalinhados");
                seen=seen|(1<<digit);
            end
            if(i==15) value=32'hFEDCBA98;
        end
        if(seen!=255) $fatal(1,"Nem todos os digitos foram varridos");
        diagnostic_switch=0;
        repeat(3) @(negedge clk);
        operation_status=0;
        check_word({7'h7F,7'h7F,7'h7F,7'h7F,7'h12,7'h40,7'h47,7'h40}); // SOLO
        operation_status=1;
        check_word({7'h7F,7'h7F,7'h7F,7'h7F,7'h7F,7'h63,7'h40,7'h40}); // VOO
        operation_status=2;
        check_word({7'h7F,7'h7F,7'h7F,7'h0C,7'h40,7'h41,7'h12,7'h40}); // POUSO
        operation_status=4;
        check_word({7'h7F,7'h7F,7'h7F,7'h7F,7'h7F,7'h06,7'h2F,7'h2F}); // Err: 11 filtrado
        operation_status=3;
        check_word({7'h7F,7'h7F,7'h7F,7'h7F,7'h7F,7'h06,7'h2F,7'h2F});
        diagnostic_switch=1;
        repeat(3) @(negedge clk);
        check_word({7'h0E,7'h06,7'h21,7'h46,7'h03,7'h08,7'h10,7'h00}); // FEDCBA98
        enabled=0;
        @(negedge clk);
        if(anodes!=8'hFF || segments!=7'h7F || !dp) $fatal(1,"Desabilitado nao apagou apos mudar o modo");
        $display("PASS sd_status_display: SOLO/VOO/POUSO/Err, retorno ao diagnostico, 16 glifos, 8 anodos e apagamento");
        $finish;
    end
endmodule
