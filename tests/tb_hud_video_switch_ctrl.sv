`timescale 1ns/1ps
module tb_hud_video_switch_ctrl;
    reg overlay_enable=0, sync_locked=0, external_video_active=0, mask_on=0;
    wire select_hud;
    reg expected;
    hud_video_switch_ctrl dut(
        .overlay_enable(overlay_enable),.sync_locked(sync_locked),
        .external_video_active(external_video_active),
        .mask_on(mask_on),.select_hud(select_hud)
    );
    initial begin
        for(integer i=0;i<16;i=i+1) begin
            {overlay_enable,sync_locked,external_video_active,mask_on}=4'(i);
            #1;
            expected=overlay_enable && sync_locked && external_video_active && mask_on;
            if(select_hud !== expected)
                $fatal(1,"select_hud i=%0d obtido=%b esperado=%b",i,select_hud,expected);
            if ((!sync_locked || !external_video_active) && select_hud)
                $fatal(1,"Chave HUD selecionada sem sync ou durante blanking");
        end
        $display("PASS hud_video_switch_ctrl: 16 combinacoes, bypass sem lock");
        $finish;
    end
endmodule
