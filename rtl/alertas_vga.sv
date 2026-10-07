// Overlay de estado. Nao decide alertas; usa o pacote aplicado entre quadros.
module alertas_vga(
    input logic [9:0] pixel_x,pixel_y,
    input logic video_on,
    input logic [31:0] metadados,
    output logic on,
    output logic [11:0] rgb
);
    function automatic logic [34:0] glifo(input logic [7:0] c);
        case(c)
            8'd65: glifo=35'b01110_10001_10001_11111_10001_10001_10001;
            8'd66: glifo=35'b11110_10001_10001_11110_10001_10001_11110;
            8'd67: glifo=35'b01111_10000_10000_10000_10000_10000_01111;
            8'd68: glifo=35'b11110_10001_10001_10001_10001_10001_11110;
            8'd69: glifo=35'b11111_10000_10000_11110_10000_10000_11111;
            8'd70: glifo=35'b11111_10000_10000_11110_10000_10000_10000;
            8'd71: glifo=35'b01110_10001_10000_10111_10001_10001_01110;
            8'd72: glifo=35'b10001_10001_10001_11111_10001_10001_10001;
            8'd73: glifo=35'b11111_00100_00100_00100_00100_00100_11111;
            8'd75: glifo=35'b10001_10010_10100_11000_10100_10010_10001;
            8'd76: glifo=35'b10000_10000_10000_10000_10000_10000_11111;
            8'd77: glifo=35'b10001_11011_10101_10101_10001_10001_10001;
            8'd78: glifo=35'b10001_11001_10101_10011_10001_10001_10001;
            8'd79: glifo=35'b01110_10001_10001_10001_10001_10001_01110;
            8'd80: glifo=35'b11110_10001_10001_11110_10000_10000_10000;
            8'd82: glifo=35'b11110_10001_10001_11110_10100_10010_10001;
            8'd83: glifo=35'b01111_10000_10000_01110_00001_00001_11110;
            8'd84: glifo=35'b11111_00100_00100_00100_00100_00100_00100;
            8'd85: glifo=35'b10001_10001_10001_10001_10001_10001_01110;
            8'd86: glifo=35'b10001_10001_10001_10001_10001_01010_00100;
            8'd87: glifo=35'b10001_10001_10001_10101_10101_10101_01010;
            default: glifo=0;
        endcase
    endfunction
    function automatic logic texto(input logic [55:0] palavra,input integer ox,oy);
        logic [34:0] mapa;
        logic [2:0] dx,dy;
        logic [5:0] indice;
        begin
            texto=0;
            for(integer i=0;i<7;i=i+1) begin
                mapa=glifo(palavra[55-i*8 -:8]);
                dx=3'(pixel_x-ox-i*6); dy=3'(pixel_y-oy);
                indice=6'd34-({3'd0,dy}*6'd5)-{3'd0,dx};
                if(pixel_x>=ox+i*6 && pixel_x<ox+i*6+5 && pixel_y>=oy && pixel_y<oy+7)
                    texto=texto | mapa[indice];
            end
        end
    endfunction
    logic [55:0] nome_modo,nome_causa,nome_nivel;
    logic status_on,alerta_on;
    always_comb begin
        case(metadados[1:0])
            1: nome_modo="FLT    ";
            2: nome_modo="LDG    ";
            default: nome_modo="GND    ";
        endcase
        case(metadados[13:11])
            1: nome_causa="ROLL   "; 2: nome_causa="PITCH  ";
            3: nome_causa="SPEED  "; 4: nome_causa="SINK   ";
            5: nome_causa="SENSOR "; 6: nome_causa="ALT    ";
            7: nome_causa="MODE   "; default: nome_causa="       ";
        endcase
        case(metadados[10:9])
            3: nome_nivel="WARNING"; 2: nome_nivel="CAUTION";
            1: nome_nivel="INFO   "; default: nome_nivel="       ";
        endcase
        status_on=texto(nome_modo,20,42) |
            (metadados[8] && texto("SIM    ",20,54)) |
            (metadados[7] && texto("FALLBK ",62,54)) |
            (!metadados[3] && texto("ATT BAD",20,66)) |
            (!metadados[4] && texto("ALT BAD",20,78)) |
            (!metadados[5] && texto("HDG BAD",20,90)) |
            (metadados[15] && texto("ACK    ",20,102)) |
            (metadados[2] && texto("MODE   ",62,42));
        alerta_on=metadados[10:9]!=0 && (texto(nome_nivel,440,12) | texto(nome_causa,440,24));
        on=0; rgb=0;
        if(video_on) begin
            if(alerta_on) begin
                on=1;
                rgb=metadados[10:9]==3 ? 12'hF00 : metadados[10:9]==2 ? 12'hFA0 : 12'h0FF;
            end else if(status_on) begin on=1; rgb=12'h0F0; end
            else if(metadados[14] && pixel_x>=110 && pixel_x<114 && pixel_y>=42 && pixel_y<46)
                begin on=1; rgb=12'hFA0; end
        end
    end
endmodule
