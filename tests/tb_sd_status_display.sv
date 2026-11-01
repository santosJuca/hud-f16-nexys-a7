`timescale 1ns/1ps
module tb_sd_status_display;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, enabled=0;
    reg [3:0] page_switches=0;
    reg [31:0] value=32'h76543210;
    wire [3:0] page;
    wire [6:0] segments;
    wire [7:0] anodes;
    wire dp;
    integer i,digit,seen;
    reg [6:0] glyph [0:15];
    sd_status_display #(.SCAN_BITS(1)) dut(.*);
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
        $display("PASS sd_status_display: 16 glifos, 8 anodos, paginas e apagamento");
        $finish;
    end
endmodule
