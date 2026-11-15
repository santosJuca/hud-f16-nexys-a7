// BTNL curto: video on/off; longo: captura. Curto na captura: um quadro.
module captura_controle #(
    parameter integer DEBOUNCE=1_000_000,LONG_PRESS=100_000_000
)(
    input wire clk,reset,button,
    input wire inhibit=1'b0,
    input wire [3:0] page,
    output logic video_mode=1,capture=0,step_toggle=0,zero_request=0,
    output wire [1:0] view,
    output wire grid
);
    (* ASYNC_REG="TRUE" *) logic button_meta=0,button_sync=0;
    (* ASYNC_REG="TRUE" *) logic [3:0] page_meta=0,page_sync=0;
    (* ASYNC_REG="TRUE" *) logic inhibit_meta=0,inhibit_sync=0;
    logic button_armed=0;
    logic filtered=0,was_long=0,zero_previous=0;
    logic [31:0] debounce_count=0,hold_count=0;
    assign view=capture ? page_sync[1:0] : 2'd1;
    assign grid=capture && page_sync[2];
    always_ff @(posedge clk) begin
        button_meta<=button; button_sync<=button_meta;
        inhibit_meta<=inhibit; inhibit_sync<=inhibit_meta;
        page_meta<=page; page_sync<=page_meta;
        zero_request<=0;
        zero_previous<=page_sync[3];
        if(reset) begin
            filtered<=0; debounce_count<=0; hold_count<=0; was_long<=0;
            video_mode<=1; capture<=0; step_toggle<=0; zero_previous<=0; button_armed<=0;
        end else if(inhibit_sync || !button_armed) begin
            filtered<=0; debounce_count<=0; hold_count<=0; was_long<=0;
            button_armed<=!inhibit_sync && !button_sync;
        end else begin
            if(capture && page_sync[3] && !zero_previous) zero_request<=1;
            if(button_sync==filtered) debounce_count<=0;
            else if(debounce_count==DEBOUNCE-1) begin
                debounce_count<=0; filtered<=button_sync;
                if(!button_sync) begin
                    if(!was_long) begin
                        if(capture) step_toggle<=~step_toggle;
                        else video_mode<=~video_mode;
                    end
                    hold_count<=0; was_long<=0;
                end
            end else debounce_count<=debounce_count+1'b1;
            if(filtered && !was_long) begin
                if(hold_count==LONG_PRESS-1) begin capture<=~capture; was_long<=1; end
                else hold_count<=hold_count+1'b1;
            end
        end
    end
endmodule
