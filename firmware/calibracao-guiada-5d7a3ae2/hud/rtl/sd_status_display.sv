// Oito digitos: modo operacional ou diagnostico hexadecimal. Saidas ativas em zero.
module sd_status_display #(
    parameter integer SCAN_BITS = 14,
    parameter bit SHOW_OPERATION_MODE = 1'b0,
    parameter bit SCROLL_OPERATION_MODE = 1'b0,
    parameter integer SCROLL_CYCLES = 25_000_000
)(
    input wire clk, rst, enabled,
    input wire diagnostic_switch,
    input wire [2:0] operation_status,
    input wire [3:0] page_switches,
    input wire [31:0] value,
    output wire [3:0] page,
    output reg [6:0] segments,
    output wire [7:0] anodes,
    output wire dp
);
    (* ASYNC_REG = "TRUE" *) reg [3:0] page_meta = 0, page_sync = 0;
    (* ASYNC_REG = "TRUE" *) reg diagnostic_meta = 0, diagnostic_sync = 0;
    reg [SCAN_BITS+2:0] scan = 0;
    wire [2:0] digit = scan[SCAN_BITS+2:SCAN_BITS];
    wire [3:0] nibble = value >> (digit * 4);
    reg [63:0] mode_text;
    reg [127:0] mode_message;
    localparam integer CW=SCROLL_CYCLES>1 ? $clog2(SCROLL_CYCLES) : 1;
    reg [CW-1:0] scroll_timer=0;
    reg [3:0] scroll_offset=0;
    reg [2:0] previous_operation=0;
    initial if(SCROLL_CYCLES<1) $fatal(1,"Periodo de rolagem invalido");
    always @(posedge clk) begin
        previous_operation<=operation_status;
        if(rst || !enabled || diagnostic_sync || operation_status[2] ||
            operation_status!=previous_operation) begin scroll_timer<=0;scroll_offset<=0;end
        else if(SHOW_OPERATION_MODE && SCROLL_OPERATION_MODE) begin
            if(scroll_timer<CW'(SCROLL_CYCLES-1)) scroll_timer<=scroll_timer+1'b1;
            // Troca o texto somente entre duas varreduras completas dos oito digitos.
            else if(&scan) begin scroll_timer<=0;scroll_offset<=scroll_offset+1'b1;end
        end
    end
    wire [7:0] letter = mode_text >> (digit * 8);
    assign page = page_sync;
    assign anodes = enabled ? ~(8'b1 << digit) : 8'hFF;
    assign dp = 1'b1;
    always @(posedge clk) begin
        page_meta <= page_switches;
        page_sync <= page_meta;
        diagnostic_meta <= diagnostic_switch;
        diagnostic_sync <= diagnostic_meta;
        if (rst) scan <= 0;
        else scan <= scan + 1'b1;
    end
    always_comb begin
        mode_message="                ";
        case(operation_status[1:0])
            0: mode_message="  SOLO          ";
            1: mode_message="   VOO          ";
            2: mode_message=" POUSO          ";
            default: mode_message="                ";
        endcase
        if (operation_status[2]) mode_text = "     Err";
        else case (operation_status[1:0])
            0: mode_text = "    SOLO";
            1: mode_text = "     VOO";
            2: mode_text = "   POUSO";
            default: mode_text = "     Err";
        endcase
        if(SCROLL_OPERATION_MODE && !operation_status[2] && operation_status[1:0]!=3)
            for(integer i=0;i<8;i=i+1)
                mode_text[(7-i)*8 +:8]=mode_message[(15-((scroll_offset+i)&15))*8 +:8];
    end
    always @* begin
        case (nibble)
            0: segments=7'b1000000; 1: segments=7'b1111001;
            2: segments=7'b0100100; 3: segments=7'b0110000;
            4: segments=7'b0011001; 5: segments=7'b0010010;
            6: segments=7'b0000010; 7: segments=7'b1111000;
            8: segments=7'b0000000; 9: segments=7'b0010000;
            10: segments=7'b0001000; 11: segments=7'b0000011;
            12: segments=7'b1000110; 13: segments=7'b0100001;
            14: segments=7'b0000110; 15: segments=7'b0001110;
            default: segments=7'b1111111;
        endcase
        if (SHOW_OPERATION_MODE && !diagnostic_sync) begin
            case (letter)
                "S": segments=7'b0010010;
                "O": segments=7'b1000000;
                "L": segments=7'b1000111;
                "V": segments=7'b1100011; // Aproximacao de V com os segmentos inferiores.
                "P": segments=7'b0001100;
                "U": segments=7'b1000001;
                "E": segments=7'b0000110;
                "r": segments=7'b0101111;
                default: segments=7'b1111111;
            endcase
        end
        if (!enabled) segments=7'b1111111;
    end
endmodule
