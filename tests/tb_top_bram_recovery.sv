`timescale 1ns/1ps
module tb_top_bram_recovery #(parameter integer QUICK_STATUS=0);
    tb_top_ddr2_video tb();
    defparam tb.dut.ENABLE_DDR2_SD_MIRROR=0;
    defparam tb.dut.ENABLE_DDR2_VIDEO=0;
    initial begin
        // A recuperacao BRAM deve continuar mesmo sem aceitar trafego DDR2.
        force tb.dut.u_ui_test.u_mig.app_rdy=1'b0;
        force tb.dut.u_ui_test.u_mig.app_wdf_rdy=1'b0;
        wait(tb.updates>=2);
        repeat(20) @(negedge tb.clk);
        if(tb.checks<307200 || tb.dut.video_errors!=0 ||
           tb.dut.u_ui_test.u_mig.reads!=0 || tb.dut.u_ui_test.u_mig.writes!=0)
            $fatal(1,"Recuperacao BRAM dependeu do trafego DDR2");
        $display("PASS top BRAM recovery: pixels=%0d updates=%0d DDR2_reads=0 DDR2_writes=0",tb.checks,tb.updates);
        $finish;
    end
endmodule
