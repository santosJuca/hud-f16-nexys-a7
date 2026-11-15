`timescale 1ns/1ps
module tb_video_pipe_equivalence;
    reg clk=0,reset=1,valid=0;
    always #5 clk=~clk;
    reg [31:0] frame=0;
    reg [2:0] phase=0;
    wire [9:0] v_ref,v_pipe,v_ref_touch,v_pipe_touch;
    wire [16:0] a_ref,a_pipe,a_ref_touch,a_pipe_touch;
    wire [2:0] p_ref,p_pipe,p_ref_touch,p_pipe_touch,phase_pipe,phase_pipe_touch;

    video_flight_profile #(
        .GROUND_FRAMES(240),.DEPARTURE_FRAMES(2160),.CRUISE_FRAMES(1500),.LANDING_FRAMES(900),
        .TAKEOFF_ROLL_FRAMES(1200),.CRUISE_SPEED_KT(160),.CRUISE_ALT_FT(1500),
        .LANDING_HAS_TOUCHDOWN(1'b0),.APPROACH_END_SPEED_KT(130),.APPROACH_END_ALT_FT(150)
    ) ref_approach(.frame_valid(valid),.frame_index(frame),.phase(phase),
        .velocidade_kt(v_ref),.altitude_ft(a_ref),.fase_pouso(p_ref));
    video_flight_profile_pipelined #(
        .GROUND_FRAMES(240),.DEPARTURE_FRAMES(2160),.CRUISE_FRAMES(1500),.LANDING_FRAMES(900),
        .TAKEOFF_ROLL_FRAMES(1200),.CRUISE_SPEED_KT(160),.CRUISE_ALT_FT(1500),
        .LANDING_HAS_TOUCHDOWN(1'b0),.APPROACH_END_SPEED_KT(130),.APPROACH_END_ALT_FT(150)
    ) dut_approach(.clk(clk),.reset(reset),.frame_valid(valid),.frame_index(frame),.phase(phase),
        .velocidade_kt(v_pipe),.altitude_ft(a_pipe),.fase_pouso(p_pipe),.phase_aligned(phase_pipe));

    video_flight_profile #(
        .GROUND_FRAMES(240),.DEPARTURE_FRAMES(2160),.CRUISE_FRAMES(1500),.LANDING_FRAMES(900),
        .TAKEOFF_ROLL_FRAMES(1200),.LANDING_AIR_FRAMES(600),
        .CRUISE_SPEED_KT(160),.CRUISE_ALT_FT(1500),.TOUCHDOWN_SPEED_KT(100)
    ) ref_touch(.frame_valid(valid),.frame_index(frame),.phase(phase),
        .velocidade_kt(v_ref_touch),.altitude_ft(a_ref_touch),.fase_pouso(p_ref_touch));
    video_flight_profile_pipelined #(
        .GROUND_FRAMES(240),.DEPARTURE_FRAMES(2160),.CRUISE_FRAMES(1500),.LANDING_FRAMES(900),
        .TAKEOFF_ROLL_FRAMES(1200),.LANDING_AIR_FRAMES(600),
        .CRUISE_SPEED_KT(160),.CRUISE_ALT_FT(1500),.TOUCHDOWN_SPEED_KT(100)
    ) dut_touch(.clk(clk),.reset(reset),.frame_valid(valid),.frame_index(frame),.phase(phase),
        .velocidade_kt(v_pipe_touch),.altitude_ft(a_pipe_touch),.fase_pouso(p_pipe_touch),.phase_aligned(phase_pipe_touch));
    task check(input integer idx,input integer ph,input integer frame_ok);
        begin
            @(negedge clk);
            frame=idx;
            phase=ph;
            valid=frame_ok;
            repeat(4) @(posedge clk);
            #1;
            if(v_pipe!==v_ref || a_pipe!==a_ref || p_pipe!==p_ref || phase_pipe!==phase)
                $fatal(1,"PIPE_APPROACH_MISMATCH frame=%0d phase=%0d got %0d/%0d/%0d expected %0d/%0d/%0d",
                    frame,phase,v_pipe,a_pipe,p_pipe,v_ref,a_ref,p_ref);
            if(v_pipe_touch!==v_ref_touch || a_pipe_touch!==a_ref_touch || p_pipe_touch!==p_ref_touch || phase_pipe_touch!==phase)
                $fatal(1,"PIPE_TOUCH_MISMATCH frame=%0d phase=%0d got %0d/%0d/%0d expected %0d/%0d/%0d",
                    frame,phase,v_pipe_touch,a_pipe_touch,p_pipe_touch,v_ref_touch,a_ref_touch,p_ref_touch);
        end
    endtask
    integer i,ph;
    initial begin
        repeat(2) @(posedge clk);
        @(negedge clk); reset=0;
        check(0,0,0);
        for(i=0;i<4800;i=i+1) begin
            if(i<240) ph=0;
            else if(i<2400) ph=1;
            else if(i<3900) ph=2;
            else ph=3;
            check(i,ph,1);
        end
        check(4799,4,1);
        check(0,0,1);
        check(4799,3,0);
        check(245,1,1);
        check(3900,3,1);
        check(10,0,0);
        $display("PASS VIDEO_PIPE_EQUIVALENCE_4800_FRAMES_BOTH_PROFILES");
        $finish;
    end
    initial begin #300000; $fatal(1,"timeout"); end
endmodule
