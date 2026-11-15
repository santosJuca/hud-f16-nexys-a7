`timescale 1ns/1ps
module tb_video_operacao_f16_anchors;
    reg clk=0, reset=1, frame_valid=0;
    always #5 clk=~clk;
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
        .fontes_validas(3'b000),.novas_amostras(3'b000),
        .attitude_manual_valid(1'b1),
        .pitch_real_q10(32'sd0),.roll_real_q10(32'sd0),
        .pitch_manual_q10(32'sd0),.roll_manual_q10(32'sd0),
        .pitch_real_px(11'sd0),.pitch_fallback_px(11'sd0),
        .roll_real_q8(10'sd0),.roll_fallback_q8(10'sd0),
        .altitude_real_ft(17'd1234),.heading_real_deg(9'd20),
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
        check(0,0,0,0,0,0);
        check(1104,1,348,0,1,0);
        check(1536,1,360,5000,1,0);
        check(1968,1,360,13000,1,0);
        check(2400,2,360,13000,1,0);
        check(3900,3,200,2000,2,0);
        check(4500,3,128,0,2,3);
        check(4799,3,0,0,2,4);
        check(4799,4,0,0,0,0);
        check(0,0,0,0,0,0);
        $display("PASS_OPERACAO_F16_ANCHORS");
        $finish;
    end
    initial begin #20000; $fatal(1,"TIMEOUT"); end
endmodule
