`timescale 1ns/1ps
module tb_calibracao_diagnostico;
    reg [9:0] x=0,y=0;
    reg video_on=1,diagnostics=1;
    wire on;
    integer pixels=0;
    calibracao_vga dut(.x(x),.y(y),.video_on(video_on),.grid(1'b0),.diagnostics(diagnostics),
        .raw_roll(32'd0),.raw_pitch(32'd0),.roll(32'd0),.pitch(32'd0),.render_roll(32'd0),
        .sine(16'sd0),.cosine(16'sd16384),.pitch_px(11'sd0),.status({6'd0,7'h12,13'h1234,6'h20}),
        .video_status(32'd5),.frame_id(32'd123),
        .sensor_raw(96'h800112344000fffe00007fff),.mag_status(32'h48343213),.on(on));
    function automatic [34:0] digit(input byte c);
        case(c)
            "0":digit=35'b01110_10001_10011_10101_11001_10001_01110;
            "1":digit=35'b00100_01100_00100_00100_00100_00100_01110;
            "2":digit=35'b01110_10001_00001_00010_00100_01000_11111;
            "3":digit=35'b11110_00001_00001_01110_00001_00001_11110;
            "4":digit=35'b00010_00110_01010_10010_11111_00010_00010;
            "7":digit=35'b11111_00001_00010_00100_01000_01000_01000;
            "8":digit=35'b01110_10001_10001_01110_10001_10001_01110;
            "E":digit=35'b11111_10000_10000_11110_10000_10000_11111;
            "F":digit=35'b11111_10000_10000_11110_10000_10000_10000;
            default:$fatal(1,"Digito sem referencia");
        endcase
    endfunction
    task automatic check_line(input integer base,row,input string expected);
        reg [34:0] bitmap;
        for(integer c=0;c<8;c++) begin
            bitmap=digit(expected[c]);
            for(integer py=0;py<7;py++) for(integer px=0;px<8;px++) begin
                x=10'(base+(12+c)*8+px);y=10'(128+row*16+py);#1;
                if(on!==(px<5 ? bitmap[34-py*5-px] : 1'b0))
                    $fatal(1,"Texto hexadecimal incorreto x=%0d y=%0d esperado=%s",x,y,expected);
                pixels++;
            end
        end
    endtask
    initial begin
        check_line(8,7,"00000020");
        check_line(200,0,"FFFF8001");
        check_line(200,1,"00001234");
        check_line(200,2,"00004000");
        check_line(200,3,"FFFFFFFE");
        check_line(200,4,"00000000");
        check_line(200,5,"00007FFF");
        check_line(200,6,"00483432");
        check_line(200,7,"00000013");
        check_line(200,8,"00000012");
        check_line(200,9,"00001234");
        x=201;y=128;#1;
        if(!on) $fatal(1,"Painel de sensores ausente");
        diagnostics=0;#1;if(on) $fatal(1,"Painel fora do modo diagnostico");
        diagnostics=1;video_on=0;#1;if(on) $fatal(1,"Texto fora do video ativo");
        video_on=1;x=180;#1;if(on) $fatal(1,"Texto invade intervalo entre paineis");
        $display("PASS diagnostico VGA: %0d pixels; seis eixos, sinal, ID/IO e ocultacao",pixels);
        $finish;
    end
endmodule
