module hud_vertical_adjust #(
    parameter integer DEBOUNCE_CYCLES = 250000,
    parameter integer REPEAT_START_CYCLES = 8750000,
    parameter integer REPEAT_CYCLES = 2500000,
    parameter integer STEP = 1,
    parameter integer LIMIT = 64
)(
    input wire clk, reset, align_enable,
    input wire up_button, down_button,
    input wire frame_boundary,
    output logic signed [8:0] offset_y = 0
);
    (* ASYNC_REG="TRUE" *) logic up_meta=0, up_sync=0;
    (* ASYNC_REG="TRUE" *) logic down_meta=0, down_sync=0;
    (* ASYNC_REG="TRUE" *) logic cap_meta=0, cap_sync=0;

    logic up_stable=0, down_stable=0;
    logic [31:0] up_debounce=0, down_debounce=0;
    logic [31:0] up_hold=0, down_hold=0;
    logic signed [8:0] pending_y=0;

    wire up_press = up_sync && !up_stable &&
                    up_debounce == DEBOUNCE_CYCLES-1;
    wire down_press = down_sync && !down_stable &&
                      down_debounce == DEBOUNCE_CYCLES-1;

    wire up_repeat = cap_sync && up_stable && !down_sync &&
                     up_hold == REPEAT_START_CYCLES-1;
    wire down_repeat = cap_sync && down_stable && !up_sync &&
                       down_hold == REPEAT_START_CYCLES-1;

    initial begin
        if(DEBOUNCE_CYCLES<1 ||
           REPEAT_CYCLES<1 ||
           REPEAT_START_CYCLES<REPEAT_CYCLES ||
           STEP<1 || LIMIT<STEP || LIMIT>120)
            $fatal(1,"Parametros invalidos do ajuste HUD");
    end

    always_ff @(posedge clk) begin
        up_meta<=up_button;
        up_sync<=up_meta;
        down_meta<=down_button;
        down_sync<=down_meta;
        cap_meta<=align_enable;
        cap_sync<=cap_meta;

        if(reset) begin
            up_stable<=0;
            down_stable<=0;
            up_debounce<=0;
            down_debounce<=0;
            up_hold<=0;
            down_hold<=0;
            pending_y<=0;
            offset_y<=0;
        end else begin
            if(up_sync==up_stable)
                up_debounce<=0;
            else if(up_debounce==DEBOUNCE_CYCLES-1) begin
                up_stable<=up_sync;
                up_debounce<=0;
            end else
                up_debounce<=up_debounce+1'b1;

            if(down_sync==down_stable)
                down_debounce<=0;
            else if(down_debounce==DEBOUNCE_CYCLES-1) begin
                down_stable<=down_sync;
                down_debounce<=0;
            end else
                down_debounce<=down_debounce+1'b1;

            if(cap_sync && up_stable && !down_sync) begin
                if(up_hold==REPEAT_START_CYCLES-1)
                    up_hold<=REPEAT_START_CYCLES-REPEAT_CYCLES;
                else
                    up_hold<=up_hold+1'b1;
            end else
                up_hold<=0;

            if(cap_sync && down_stable && !up_sync) begin
                if(down_hold==REPEAT_START_CYCLES-1)
                    down_hold<=REPEAT_START_CYCLES-REPEAT_CYCLES;
                else
                    down_hold<=down_hold+1'b1;
            end else
                down_hold<=0;

            // Somente comandos ALIGN alteram o offset; sem escrita na atitude/video.
            if(cap_sync && !down_sync && !down_stable &&
               (up_press || up_repeat)) begin
                if(pending_y >= LIMIT-STEP)
                    pending_y<=LIMIT;
                else
                    pending_y<=pending_y+STEP;
            end else if(cap_sync && !up_sync && !up_stable &&
                        (down_press || down_repeat)) begin
                if(pending_y <= -LIMIT+STEP)
                    pending_y<=-LIMIT;
                else
                    pending_y<=pending_y-STEP;
            end

            // Atualiza a posicao somente na fronteira do quadro.
            if(frame_boundary)
                offset_y<=pending_y;
        end
    end
endmodule
