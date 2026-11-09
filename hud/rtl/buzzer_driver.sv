// Envelope para buzzer ativo; sem portadora de audio e sem clock derivado.
module buzzer_driver #(
    parameter integer DEBOUNCE_CYCLES=1_000_000,
    parameter integer INFO_ON=10_000_000, INFO_OFF=490_000_000,
    parameter integer CAUTION_ON=25_000_000, CAUTION_OFF=75_000_000,
    parameter integer WARNING_ON=20_000_000, WARNING_OFF=20_000_000
)(
    input logic clk, reset,
    input logic [1:0] severity,
    input logic ack, enable,
    output wire buzzer_out,
    output logic reconhecido=0
);
    localparam integer DW=DEBOUNCE_CYCLES>1 ? $clog2(DEBOUNCE_CYCLES) : 1;
    (* ASYNC_REG = "TRUE" *) logic ack_meta=0,ack_sync=0;
    logic ack_estavel=0,ack_pulso=0;
    logic [DW-1:0] debounce_count=0;
    logic [31:0] contador=0;
    logic [1:0] anterior=0;
    logic [31:0] ligado,total;
    always_comb begin
        case(severity)
            1: begin ligado=INFO_ON; total=INFO_ON+INFO_OFF; end
            2: begin ligado=CAUTION_ON; total=CAUTION_ON+CAUTION_OFF; end
            3: begin ligado=WARNING_ON; total=WARNING_ON+WARNING_OFF; end
            default: begin ligado=0; total=1; end
        endcase
    end
    assign buzzer_out = enable && !reset && !reconhecido && severity!=0 && contador<ligado;
    always_ff @(posedge clk) begin
        if(reset) begin
            ack_meta<=0; ack_sync<=0; ack_estavel<=0; ack_pulso<=0; debounce_count<=0;
            contador<=0; anterior<=0; reconhecido<=0;
        end else begin
            ack_meta<=ack; ack_sync<=ack_meta; ack_pulso<=0;
            if(ack_sync==ack_estavel) debounce_count<=0;
            else if(debounce_count==DW'(DEBOUNCE_CYCLES-1)) begin
                debounce_count<=0; ack_estavel<=ack_sync;
                if(ack_sync) ack_pulso<=1;
            end else debounce_count<=debounce_count+1'b1;
            anterior<=severity;
            if(!enable || severity==0) begin contador<=0; reconhecido<=0; end
            else begin
                if(severity>anterior) reconhecido<=0;
                else if(ack_pulso) reconhecido<=1;
                if(severity!=anterior || reconhecido || contador>=total-1) contador<=0;
                else contador<=contador+1'b1;
            end
        end
    end
endmodule
