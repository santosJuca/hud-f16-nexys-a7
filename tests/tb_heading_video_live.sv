`timescale 1ns/1ps
module tb_heading_video_live;
    reg clk=0, reset=1, frame_valid=0;
    always #5 clk=~clk;
    reg [8:0] real_heading=9'd20;
    reg heading_ok=1;
    reg [2:0] phase=0;
    reg [31:0] frame_index=0;
    wire [56:0] dados;
    wire [31:0] meta;
    wire [1:0] req;
    wire invalido, buzzer;
    operacao_hud #(
        .VIDEO_MODE_SEQUENCE(1'b1), .VIDEO_INSTRUMENT_SYNC(1'b1),
        .VIDEO_GROUND_FRAMES(240), .VIDEO_DEPARTURE_FRAMES(2160),
        .VIDEO_CRUISE_FRAMES(1500), .VIDEO_LANDING_FRAMES(900),
        .VIDEO_TAKEOFF_ROLL_FRAMES(960), .VIDEO_LANDING_AIR_FRAMES(600),
        .VIDEO_CRUISE_SPEED_KT(360), .VIDEO_CRUISE_ALT_FT(13000),
        .VIDEO_TOUCHDOWN_SPEED_KT(128), .VIDEO_LANDING_HAS_TOUCHDOWN(1'b1),
        .VIDEO_APPROACH_END_SPEED_KT(135), .VIDEO_APPROACH_END_ALT_FT(75),
        .VIDEO_ANCHOR_400MPH_FRAME(864), .VIDEO_ANCHOR_400MPH_KT(348),
        .VIDEO_ANCHOR_5000FT_FRAME(1296), .VIDEO_ANCHOR_13000FT_FRAME(1728),
        .VIDEO_LANDING_ENTRY_SPEED_KT(200), .VIDEO_LANDING_ENTRY_ALT_FT(2000),
        .TICK_CYCLES(2),.DEBOUNCE_CYCLES(1),.ACK_CYCLES(1),
        .ATT_TIMEOUT(10),.ALT_TIMEOUT(10),.HDG_TIMEOUT(10)
    ) dut(
        .clk(clk),.reset(reset),.switches(2'd0),.ack(1'b0),
        .fontes_validas({heading_ok,2'b00}),.novas_amostras({heading_ok,2'b00}),
        .attitude_manual_valid(1'b1),
        .pitch_real_q10(32'sd0),.roll_real_q10(32'sd0),
        .pitch_manual_q10(32'sd0),.roll_manual_q10(32'sd0),
        .pitch_real_px(11'sd0),.pitch_fallback_px(11'sd0),
        .roll_real_q8(10'sd0),.roll_fallback_q8(10'sd0),
        .altitude_real_ft(17'd1234),.heading_real_deg(real_heading),
        .heading_manual_deg(9'd20),.vertical_real_fpm(14'sd0),
        .vertical_real_valido(1'b0),
        .dados(dados),.metadados(meta),.buzzer_out(buzzer),
        .video_phase(phase),.video_frame_index(frame_index),.video_frame_valid(frame_valid),
        .requested_video_mode(req),.invalid_video_mode(invalido)
    );
    task check(input integer idx, input integer ph, input integer v, input integer a,
               input integer mode, input integer land);
      begin
        @(negedge clk);
        frame_index=idx;
        phase=ph;
        frame_valid=1;
        repeat(6) @(posedge clk);
        #1;
        if(dados[56:47] !== v || dados[46:30] !== a ||
           meta[1:0] !== mode || meta[18:16] !== land)
            $fatal(1,"OPERACAO_F16_MISMATCH frame=%0d phase=%0d got %0d/%0d mode%0d landing%0d expected %0d/%0d mode%0d landing%0d",
                   idx,ph,dados[56:47],dados[46:30],meta[1:0],meta[18:16],v,a,mode,land);
      end
    endtask
    initial begin
        repeat(2) @(posedge clk);
        @(negedge clk);reset=0;
        frame_valid=1; frame_index=2400;phase=2;
        repeat(16) @(negedge clk);
        real_heading=9'd173;
        repeat(16) @(negedge clk);
        if(dados[8:0]!==9'd173 || !meta[5])
            $fatal(1,"VIDEO_HEADING_NOT_LIVE got=%0d expected=173 valid=%b",dados[8:0],meta[5]);
        real_heading=9'd359; repeat(8) @(negedge clk);
        if(dados[8:0]!==9'd359) $fatal(1,"heading 359");
        real_heading=9'd0; repeat(8) @(negedge clk);
        if(dados[8:0]!==9'd0) $fatal(1,"heading wrap 0");
        phase=3;frame_index=3900;real_heading=9'd91;
        repeat(8) @(negedge clk);
        if(dados[8:0]!==9'd91 || meta[1:0]!==2) $fatal(1,"landing heading");
        heading_ok=0; repeat(16) @(negedge clk);
        if(dados[8:0]!==9'd20 || meta[5]) $fatal(1,"manual fallback");
        heading_ok=1;real_heading=9'd222;repeat(8) @(negedge clk);
        if(dados[8:0]!==9'd222 || !meta[5]) $fatal(1,"heading recovery");
        $display("PASS_VIDEO_HEADING_LIVE_WRAP_LOSS_RECOVERY");
        $finish;
    end
    initial begin #20000; $fatal(1,"TIMEOUT"); end
endmodule
