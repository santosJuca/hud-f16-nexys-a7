// SW4 (legacy SD_DIAG_PAGE[0]) exclusively enables HUD visual alignment.
// This is the only command router for BTNU/BTND. All signals are in clk domain.
module hud_command_dispatch #(
    parameter integer DEBOUNCE_CYCLES=250000,
    parameter integer SWITCH_DEBOUNCE_CYCLES=250000
)(
    input wire clk, reset,
    input wire align_switch, capture_active,
    input wire [1:0] buttons,
    output wire align_mode,
    output wire [1:0] heading_buttons, align_buttons,
    output logic capture_grid_pulse=0
);
    localparam integer BW=DEBOUNCE_CYCLES>1 ? $clog2(DEBOUNCE_CYCLES) : 1;
    localparam integer SW=SWITCH_DEBOUNCE_CYCLES>1 ? $clog2(SWITCH_DEBOUNCE_CYCLES) : 1;
    (* ASYNC_REG="TRUE" *) logic align_meta=0,align_sync=0;
    (* ASYNC_REG="TRUE" *) logic [1:0] buttons_meta='0,buttons_sync='0;
    logic align_stable=0;
    logic [SW-1:0] switch_count='0;
    logic [1:0] stable='0;
    logic [BW-1:0] button_count[0:1];
    logic [1:0] route_previous=2'd0;
    logic route_armed=0;
    logic grid_chord_seen=0;
    wire [1:0] route= capture_active ? 2'd0 : align_stable ? 2'd2 : 2'd1;
    assign align_mode=align_stable && !capture_active;
    // Both pressed: no command, and do not re-arm until both are released.
    wire exclusive_button=stable==2'b01 || stable==2'b10;
    assign heading_buttons=(route==2'd1 && route_armed && exclusive_button) ? stable : 2'b00;
    assign align_buttons=(route==2'd2 && route_armed && exclusive_button) ? stable : 2'b00;
    initial begin
        if(DEBOUNCE_CYCLES<1 || SWITCH_DEBOUNCE_CYCLES<1)
            $fatal(1,"HUD command debounce must be positive");
    end
    always_ff @(posedge clk) begin
        capture_grid_pulse<=1'b0;
        align_meta<=align_switch;
        align_sync<=align_meta;
        buttons_meta<=buttons;
        buttons_sync<=buttons_meta;
        if(reset) begin
            align_stable<=0;
            switch_count<='0;
            stable<='0;
            button_count[0]<='0;
            button_count[1]<='0;
            route_previous<=2'd0;
            route_armed<=0;
            grid_chord_seen<=0;
        end else begin
            if(align_sync==align_stable) switch_count<='0;
            else if(switch_count == SW'(SWITCH_DEBOUNCE_CYCLES-1)) begin
                align_stable<=align_sync;
                switch_count<='0;
            end else switch_count<=switch_count+1'b1;
            for(integer i=0;i<2;i=i+1) begin
                if(buttons_sync[i]==stable[i]) button_count[i]<='0;
                else if(button_count[i]==BW'(DEBOUNCE_CYCLES-1)) begin
                    stable[i]<=buttons_sync[i];
                    button_count[i]<='0;
                end else button_count[i]<=button_count[i]+1'b1;
            end
            if(route!=route_previous) begin
                route_previous<=route;
                route_armed<=0;
                grid_chord_seen<=0;
            end else if(stable==2'b00) route_armed<=1;
            // A deliberate two-button chord toggles the capture grid once.
            // No single-button event can affect the grid, heading or alignment.
            if(route!=2'd0 || stable!=2'b11)
                grid_chord_seen<=0;
            else if(route==route_previous && route_armed && !grid_chord_seen) begin
                capture_grid_pulse<=1'b1;
                grid_chord_seen<=1'b1;
            end
        end
    end
endmodule
