// Autoriza a troca de bancos somente no blanking; nao interrompe CMD17.
module video_captura(
    input wire pixel_clk,reset,capture,step_toggle,frame_boundary,frame_valid,updated,
    output wire publish,
    output logic frozen=0,
    output logic [31:0] frame_id=32'hffffffff
);
    (* ASYNC_REG="TRUE" *) logic capture_meta=0,capture_sync=0,step_meta=0,step_sync=0;
    logic step_seen=0,credit=0;
    always_ff @(posedge pixel_clk) begin
        capture_meta<=capture; capture_sync<=capture_meta;
        step_meta<=step_toggle; step_sync<=step_meta;
        if(reset) begin frozen<=0; step_seen<=0; credit<=0; frame_id<=32'hffffffff; end
        else begin
            if(frame_boundary) frozen<=capture_sync;
            if(step_sync!=step_seen) begin step_seen<=step_sync; if(capture_sync) credit<=1; end
            if(updated) begin frame_id<=frame_id+1'b1; credit<=0; end
            if(!capture_sync) credit<=0;
        end
    end
    assign publish=frame_boundary && (!capture_sync || credit || !frame_valid);
endmodule
