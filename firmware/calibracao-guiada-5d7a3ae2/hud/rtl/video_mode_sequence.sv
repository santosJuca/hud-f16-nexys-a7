// Avanca apenas apos a publicacao do quadro completo; modo ja filtrado no top.
module video_mode_sequence #(
    parameter integer GROUND_FRAMES=240, DEPARTURE_FRAMES=1260,
    CRUISE_FRAMES=1200, LANDING_FRAMES=900
)(
    input wire clk,reset,advance,
    input wire [1:0] requested_mode,
    output logic [31:0] frame_index=0,
    output logic [2:0] phase=0,
    output logic landing_pending=0
);
    localparam [2:0] GROUND=0,DEPARTURE=1,CRUISE=2,LANDING=3,LANDED=4;
    localparam integer DEPARTURE_FIRST=GROUND_FRAMES;
    localparam integer CRUISE_FIRST=GROUND_FRAMES+DEPARTURE_FRAMES;
    localparam integer LANDING_FIRST=CRUISE_FIRST+CRUISE_FRAMES;
    localparam integer END_FRAME=LANDING_FIRST+LANDING_FRAMES-1;
    initial if(GROUND_FRAMES<2 || DEPARTURE_FRAMES<2 || CRUISE_FRAMES<2 || LANDING_FRAMES<2)
        $fatal(1,"Cada trecho de apresentacao precisa de pelo menos dois quadros");
    always_ff @(posedge clk) begin
        if(reset) begin frame_index<=0;phase<=GROUND;landing_pending<=0;end
        else begin
            if(requested_mode==0) landing_pending<=0;
            else if(requested_mode==2 && (phase==DEPARTURE || phase==CRUISE)) landing_pending<=1;
            if(advance) begin
                // 11 e transitorio entre VOO e POUSO: conserva a fase atual.
                if(requested_mode==0 && phase!=GROUND) begin
                    phase<=GROUND;frame_index<=0;landing_pending<=0;
                end else case(phase)
                    GROUND: if(requested_mode==1) begin phase<=DEPARTURE;frame_index<=DEPARTURE_FIRST;end
                            else frame_index<=frame_index==GROUND_FRAMES-1 ? 0 : frame_index+1'b1;
                    DEPARTURE: if(frame_index==CRUISE_FIRST-1) begin phase<=CRUISE;frame_index<=CRUISE_FIRST;end
                               else frame_index<=frame_index+1'b1;
                    // Atende POUSO no proximo quadro completo, sem esperar outro ciclo de cruzeiro.
                    CRUISE: if(landing_pending || requested_mode==2) begin
                                phase<=LANDING;frame_index<=LANDING_FIRST;landing_pending<=0;
                            end else frame_index<=frame_index==LANDING_FIRST-1 ? CRUISE_FIRST : frame_index+1'b1;
                    LANDING: if(frame_index==END_FRAME) begin phase<=LANDED;frame_index<=END_FRAME;end
                             else frame_index<=frame_index+1'b1;
                    LANDED: if(requested_mode==1) begin phase<=DEPARTURE;frame_index<=DEPARTURE_FIRST;end
                    default: begin phase<=GROUND;frame_index<=0;landing_pending<=0;end
                endcase
            end
        end
    end
endmodule
