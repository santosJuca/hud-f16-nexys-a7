// Oito digitos hexadecimais, anodos e segmentos ativos em zero.
module sd_status_display #(
    parameter integer SCAN_BITS = 14
)(
    input wire clk, rst, enabled,
    input wire [3:0] page_switches,
    input wire [31:0] value,
    output wire [3:0] page,
    output reg [6:0] segments,
    output wire [7:0] anodes,
    output wire dp
);
    (* ASYNC_REG = "TRUE" *) reg [3:0] page_meta = 0, page_sync = 0;
    reg [SCAN_BITS+2:0] scan = 0;
    wire [2:0] digit = scan[SCAN_BITS+2:SCAN_BITS];
    wire [3:0] nibble = value >> (digit * 4);
    assign page = page_sync;
    assign anodes = enabled ? ~(8'b1 << digit) : 8'hFF;
    assign dp = 1'b1;
    always @(posedge clk) begin
        page_meta <= page_switches;
        page_sync <= page_meta;
        if (rst) scan <= 0;
        else scan <= scan + 1'b1;
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
        if (!enabled) segments=7'b1111111;
    end
endmodule
