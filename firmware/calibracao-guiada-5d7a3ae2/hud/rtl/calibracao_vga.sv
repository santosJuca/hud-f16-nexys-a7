// Diagnostico hexadecimal exato: angulos Q10, coordenadas em pixels.
module calibracao_vga #(parameter bit MAG_CALIBRATION_VIEW=0)(
    input wire [9:0] x,y,
    input wire video_on,grid,diagnostics,
    input wire signed [31:0] raw_roll,raw_pitch,roll,pitch,render_roll,
    input wire signed [15:0] sine,cosine,
    input wire signed [10:0] pitch_px,
    input wire [31:0] status,video_status,frame_id,
    input wire [95:0] sensor_raw,
    input wire [31:0] mag_status,
    output wire on
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
            8'd48: glifo=35'b01110_10001_10011_10101_11001_10001_01110;
            8'd49: glifo=35'b00100_01100_00100_00100_00100_00100_01110;
            8'd50: glifo=35'b01110_10001_00001_00010_00100_01000_11111;
            8'd51: glifo=35'b11110_00001_00001_01110_00001_00001_11110;
            8'd52: glifo=35'b00010_00110_01010_10010_11111_00010_00010;
            8'd53: glifo=35'b11111_10000_10000_11110_00001_00001_11110;
            8'd54: glifo=35'b01110_10000_10000_11110_10001_10001_01110;
            8'd55: glifo=35'b11111_00001_00010_00100_01000_01000_01000;
            8'd56: glifo=35'b01110_10001_10001_01110_10001_10001_01110;
            8'd57: glifo=35'b01110_10001_10001_01111_00001_00001_01110;
            8'd81: glifo=35'b01110_10001_10001_10001_10101_10010_01101;
            8'd88: glifo=35'b10001_10001_01010_00100_01010_10001_10001;
            8'd89: glifo=35'b10001_10001_01010_00100_00100_00100_00100;
            8'd90: glifo=35'b11111_00001_00010_00100_01000_10000_11111;
            default: glifo=0;
        endcase
    endfunction

    wire signed [26:0] dx=sine*pitch_px,dy=cosine*pitch_px;
    wire signed [31:0] hx=32'sd320+32'(dx>>>14),hy=32'sd240+32'(dy>>>14);
    wire [3:0] row=4'((y-10'd128)>>4);
    wire sensor_panel=x>=200;
    wire [4:0] col=sensor_panel ? 5'((x-10'd200)>>3) : 5'((x-10'd8)>>3);
    logic [95:0] label_text;
    logic [31:0] value;
    logic [7:0] character;
    logic [3:0] nibble;
    logic [34:0] bitmap;
    always_comb begin
        label_text="            "; value=0;
        if(sensor_panel) case(row)
            0: begin label_text="ACC X HEX   "; value=32'($signed(sensor_raw[95:80])); end
            1: begin label_text="ACC Y HEX   "; value=32'($signed(sensor_raw[79:64])); end
            2: begin label_text="ACC Z HEX   "; value=32'($signed(sensor_raw[63:48])); end
            3: begin label_text="GYR X HEX   "; value=32'($signed(sensor_raw[47:32])); end
            4: begin label_text="GYR Y HEX   "; value=32'($signed(sensor_raw[31:16])); end
            5: begin label_text="GYR Z HEX   "; value=32'($signed(sensor_raw[15:0])); end
            6: begin label_text="MAG ID HEX  "; value=mag_status>>8; end
            7: begin label_text="MAG IO HEX  "; value={24'd0,mag_status[7:0]}; end
            8: begin label_text="CAL CNT HEX "; value={25'd0,status[25:19]}; end
            9: begin label_text="CAL BLK HEX "; value={19'd0,status[18:6]}; end
            default: begin end
        endcase
        else case(row)
            0: begin label_text="RAW R Q10   "; value=raw_roll; end
            1: begin label_text="RAW P Q10   "; value=raw_pitch; end
            2: begin label_text="COR R Q10   "; value=roll; end
            3: begin label_text="COR P Q10   "; value=pitch; end
            4: begin label_text="RENDER Q10  "; value=render_roll; end
            5: begin label_text="HORIZ X PX  "; value=hx; end
            6: begin label_text="HORIZ Y PX  "; value=hy; end
            7: begin label_text="MPU CAL HEX "; value={26'd0,status[5:0]}; end
            8: begin label_text="VIDEO HEX   "; value=video_status; end
            9: begin label_text="FRAME HEX   "; value=frame_id; end
            default: begin end
        endcase
        if(sensor_panel && MAG_CALIBRATION_VIEW) case(row)
            0: label_text="MAG X MIN   ";
            1: label_text="MAG X MAX   ";
            2: label_text="MAG Y MIN   ";
            3: label_text="MAG Y MAX   ";
            4: label_text="MAG Z MIN   ";
            5: label_text="MAG Z MAX   ";
            default: begin end
        endcase
        nibble=4'(value >> ((19-col)*4));
        character=col<12 ? label_text[95-col*8 -:8] : nibble<10 ? 8'd48+{4'd0,nibble} : 8'd55+{4'd0,nibble};
        bitmap=glifo(character);
    end
    wire text_on=diagnostics && ((x>=8 && x<168) || (x>=200 && x<360)) && y>=128 && y<288 &&
        x[2:0]<5 && y[3:0]<7 && bitmap[34-y[3:0]*5-x[2:0]];
    wire grid_on=grid && (
        (x==320 && y>=80 && y<=400) || (y==240 && x>=100 && x<=540) ||
        (x>=316 && x<=324 && (y==160 || y==200 || y==280 || y==320)) ||
        (y>=236 && y<=244 && (x==240 || x==280 || x==360 || x==400)) ||
        // Referencias fixas de bank: 0, +/-30, +/-60 e +/-90 graus.
        (y>=108 && y<=114 && x>=318 && x<=322) ||
        (y>=125 && y<=131 && ((x>=253 && x<=257)||(x>=383 && x<=387))) ||
        (y>=173 && y<=177 && ((x>=205 && x<=211)||(x>=429 && x<=435))) ||
        (y>=238 && y<=242 && ((x>=188 && x<=194)||(x>=446 && x<=452)))
    );
    assign on=video_on && (text_on || grid_on);
endmodule
