// Modelo SDHC somente leitura; payload convertido no PC, CRC calculado no modelo.
module sd_video_card_model #(
    parameter integer FILE_BYTES = 768512,
    parameter integer BASE_LBA = 1000,
    parameter bit ALLOW_ICON = 0,
    // Latencia de leitura (Nac) em bytes 0xFF antes do token; 0 preserva o modelo anterior.
    parameter integer NAC_BYTES = 0,
    parameter integer NAC_JITTER_BYTES = 0,
    parameter integer R1_WAIT_BYTES = 0,
    parameter [7:0] READ_R1_VALUE = 0,
    parameter [7:0] READ_TOKEN_VALUE = 8'hfe
)(
    input wire sck, cs_n, mosi, rst,
    input wire corrupt_crc, timeout_token, bad_header,
    output reg miso = 1,
    output integer reads = 0
);
    reg [7:0] memory [0:FILE_BYTES-1];
    reg [7:0] icon [0:511];
    initial if(ALLOW_ICON) $readmemh("tests/hud_aircraft_64.hex",icon);
    string fixture;
    initial begin
        if (!$value$plusargs("VIDEO_HEX=%s",fixture)) $fatal(1,"VIDEO_HEX ausente");
        $readmemh(fixture,memory);
    end
    reg [47:0] command=0;
    integer bits=0, length=0, position=0;
    reg reply [0:4300+8*(NAC_BYTES+NAC_JITTER_BYTES+R1_WAIT_BYTES)];
    reg [15:0] crc;
    reg [7:0] value;
    integer i,j,offset;
    function automatic [15:0] crc16(input [15:0] c,input [7:0] b);
        reg [15:0] v;
        begin
            v=c^{b,8'h00};
            for(integer n=0;n<8;n=n+1) v=v[15]?(v<<1)^16'h1021:v<<1;
            return v;
        end
    endfunction
    task append(input [7:0] b);
        for(integer n=7;n>=0;n=n-1) begin reply[length]=b[n]; length=length+1; end
    endtask
    always @(posedge cs_n or posedge rst) begin bits=0; length=0; position=0; command=0; end
    always @(posedge sck) if (!cs_n && !rst && bits<48) begin
        command={command[46:0],mosi}; bits=bits+1;
        if(bits==48) begin
            length=0; position=0; append(8'hff);
            case(command[45:40])
                0,55: append(1);
                8: begin append(1); append(0); append(0); append(1); append(8'haa); end
                41: append(0);
                58: begin append(0); append(8'hc0); append(8'hff); append(8'h80); append(0); end
                17: begin
                    reads=reads+1;
                    offset=(command[39:8]-BASE_LBA)*512;
                    if(!(ALLOW_ICON && command[39:8]==30006080) && (offset<0 || offset+512>FILE_BYTES)) $fatal(1,"LBA fora do arquivo %0d",command[39:8]);
                    for(j=0;j<R1_WAIT_BYTES;j=j+1) append(8'hff);
                    append(READ_R1_VALUE);
                    // Padrao deterministico por setor: latencia varia sem depender do simulador.
                    for(j=0;j<NAC_BYTES+((reads*37)%(NAC_JITTER_BYTES+1));j=j+1) append(8'hff);
                    if(!timeout_token) begin
                        append(READ_TOKEN_VALUE); crc=0;
                        for(j=0;j<512;j=j+1) begin
                            value=(ALLOW_ICON && command[39:8]==30006080)?icon[j]:memory[offset+j];
                            if(bad_header && offset==0 && j==0) value=value^8'hff;
                            append(value); crc=crc16(crc,value);
                        end
                        if(corrupt_crc) crc=crc^1;
                        append(crc[15:8]); append(crc[7:0]);
                    end
                end
                default: $fatal(1,"Comando inesperado CMD%0d",command[45:40]);
            endcase
        end
    end
    always @(negedge sck or posedge cs_n or posedge rst) begin
        if(cs_n || rst) miso=1;
        else if(position<length) begin miso=reply[position]; position=position+1; end
        else miso=1;
    end
endmodule
