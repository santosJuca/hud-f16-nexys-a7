`timescale 1ns/1ps
module tb_ddr2_video_status;
    reg clk=0,rst=1,frame_started=0,readback_commit=0,readback_abort=1;
    reg frame_published=0,transfer_error=0;
    wire pass_seen,error_seen;
    always #5 clk=~clk;
    ddr2_video_status dut(.clk(clk),.rst(rst),.frame_started(frame_started),
        .readback_commit(readback_commit),.readback_abort(readback_abort),
        .frame_published(frame_published),.transfer_error(transfer_error),
        .published_seen(pass_seen),.error_seen(error_seen));
    task tick;
        @(negedge clk);
    endtask
    task expect_status(input bit pass_value,input bit error_value);
        if(pass_seen!==pass_value || error_seen!==error_value)
            $fatal(1,"Status inesperado PASS=%b ERROR=%b",pass_seen,error_seen);
    endtask
    initial begin
        tick();rst=0;
        repeat(8) tick();expect_status(0,0); // Abort de calibracao inicial.
        readback_abort=0;frame_published=1;
        tick();frame_published=0;tick();expect_status(0,0); // ACK sem CRC/commit.
        frame_started=1;tick();frame_started=0;
        readback_commit=1;tick();readback_commit=0;
        repeat(8) tick();expect_status(0,0); // Readback nao e publicacao.
        // Proximo preload falha enquanto o banco integro aguarda o blanking.
        frame_started=1;tick();frame_started=0;readback_abort=1;
        tick();readback_abort=0;tick();expect_status(0,1);
        frame_published=1;tick();frame_published=0;
        repeat(8) tick();expect_status(1,1);
        // Inicio de outro quadro nao limpa nenhum dos historicos.
        frame_started=1;tick();frame_started=0;
        repeat(30) tick();expect_status(1,1);
        rst=1;tick();rst=0;tick();expect_status(0,0);
        transfer_error=1;tick();transfer_error=0;
        repeat(8) tick();expect_status(0,1);
        readback_commit=1;tick();readback_commit=0;
        frame_published=1;tick();frame_published=0;
        repeat(8) tick();expect_status(1,1); // Recuperacao nao esconde a falha.
        rst=1;tick();rst=0;tick();expect_status(0,0);
        $display("DDR2_STATUS_STICKY_PUBLICATION_ABORT_RESET_PASS");$finish;
    end
endmodule
