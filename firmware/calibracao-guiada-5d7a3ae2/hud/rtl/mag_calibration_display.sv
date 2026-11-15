// Texto compativel com sete segmentos: G->6, N->n, K->H, M->H.
// Nao usa percentuais nem promete precisao absoluta.
module mag_calibration_display #(parameter integer SCAN_BITS=14)(
    input wire clk,reset,healthy,level,active,
    input wire [3:0] state,reason,
    output logic [6:0] segments,
    output wire [7:0] anodes,
    output wire dp,
    output logic [63:0] text_value
);
    logic [SCAN_BITS+2:0] scan=0;
    wire [2:0] digit=scan[SCAN_BITS+2:SCAN_BITS];
    wire [7:0] letter=text_value >> (digit*8);
    assign anodes=~(8'b1<<digit);assign dp=1'b1;
    always_ff @(posedge clk) if(reset)scan<=0;else scan<=scan+1'b1;
    always_comb begin
        case(state)
            1:text_value=level ? "CAL 2d  " : "nIVEL   ";
            2:text_value="GIrAr 1 ";
            3:text_value="CALC    ";
            4:text_value="GIrAr 2 ";
            5:text_value="APtO 2d ";
            6,9:text_value="APLICA  ";
            7:text_value="rECUP   ";
            8:case(reason)
                1:text_value="I2C Err ";2:text_value="dAt Err ";3:text_value="OVEr    ";
                4:text_value="nIVEL   ";5:text_value="COB Err ";7:text_value="rUIdO   ";
                8:text_value="IGUAL   ";9:text_value="tEMPO   ";default:text_value="CAL Err ";
              endcase
            default:text_value=!healthy ? "rUIdO   " : active && level ? "CAL 2d  " : "CAL 3d  ";
        endcase
        case(letter)
            "0","O":segments=7'b1000000;"1","I":segments=7'b1111001;
            "2":segments=7'b0100100;"3":segments=7'b0110000;
            "A":segments=7'b0001000;"B":segments=7'b0000011;
            "C":segments=7'b1000110;"d":segments=7'b0100001;
            "E":segments=7'b0000110;"G":segments=7'b0000010;
            "H","M","K":segments=7'b0001001;"L":segments=7'b1000111;
            "n","N":segments=7'b0101011;"P":segments=7'b0001100;
            "r":segments=7'b0101111;"S":segments=7'b0010010;
            "t":segments=7'b0000111;"U":segments=7'b1000001;
            "V":segments=7'b1100011;default:segments=7'b1111111;
        endcase
    end
endmodule
