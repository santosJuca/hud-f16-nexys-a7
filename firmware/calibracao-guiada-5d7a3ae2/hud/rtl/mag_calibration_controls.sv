// BTNR so e reservado nesta pagina e em SOLO. Fora dela nao captura comandos.
module mag_calibration_controls #(
    parameter integer DEBOUNCE=250000,LONG_CYCLES=200000000
)(
    input wire clk,reset,eligible,right_button,
    input wire [1:0] buttons, // [0] BTNU recupera; [1] BTND cancela/sai.
    output logic owned=0,start=0,next_step=0,cancel=0,recover=0,
    output wire inhibit_buttons
);
    (* ASYNC_REG="TRUE" *) logic [3:0] meta=0,sync=0;
    logic [3:0] stable=0,previous=0;
    localparam DB=DEBOUNCE>1?$clog2(DEBOUNCE):1;
    localparam LB=LONG_CYCLES>1?$clog2(LONG_CYCLES):1;
    logic [DB-1:0] debounce_count=0;
    logic [LB-1:0] held=0;
    logic long_seen=0,release_guard=0;
    assign inhibit_buttons=owned || release_guard;
    always_ff @(posedge clk) begin
        meta<={eligible,right_button,buttons};sync<=meta;previous<=stable;
        start<=0;next_step<=0;cancel<=0;recover<=0;
        if(sync==stable)debounce_count<=0;
        else if(debounce_count==DEBOUNCE-1)begin stable<=sync;debounce_count<=0;end
        else debounce_count<=debounce_count+1'b1;
        if(stable[1:0]==0 && !stable[2])release_guard<=0;
        if(!stable[3])begin
            if(owned)begin owned<=0;cancel<=1;release_guard<=1;end
            held<=0;long_seen<=0;
        end else begin
            if(stable[2])begin
                if(held<LONG_CYCLES-1)held<=held+1'b1;
                else if(!long_seen)begin
                    long_seen<=1;
                    if(!owned)begin owned<=1;start<=1;end
                end
            end else begin
                if(previous[2] && !long_seen && owned)next_step<=1;
                held<=0;long_seen<=0;
            end
            if(owned && stable[1] && !previous[1])begin cancel<=1;owned<=0;release_guard<=1;end
            else if(owned && stable[0] && !previous[0])recover<=1;
        end
        if(reset)begin stable<=0;previous<=0;owned<=0;release_guard<=0;held<=0;debounce_count<=0;long_seen<=0;start<=0;next_step<=0;cancel<=0;recover<=0;end
    end
endmodule
