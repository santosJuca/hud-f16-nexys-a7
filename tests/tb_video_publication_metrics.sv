`timescale 1ns/1ps
module tb_video_publication_metrics;
    reg clk=0,rst=1,ddr_commit=0,vga_published=0;
    always #5 clk=~clk;
    wire [7:0] validated,published,ticks,interval_cycles;
    wire interval_valid;
    video_publication_metrics #(.WIDTH(8)) dut(
        .clk(clk),.rst(rst),.ddr_commit(ddr_commit),.vga_published(vga_published),
        .validated_count(validated),.published_count(published),.time_cycles(ticks),
        .last_interval_cycles(interval_cycles),.interval_valid(interval_valid));
    task tick(input bit commit_event,input bit publish_event);
        @(negedge clk);ddr_commit=commit_event;vga_published=publish_event;
        @(posedge clk);#1;
    endtask
    integer i;
    initial begin
        repeat(2) @(negedge clk);rst=0;
        tick(1,0);tick(0,0);
        if(validated!=1||published!=0||interval_valid) $fatal(1,"Commit virou publicacao");
        tick(0,1);
        if(published!=1||interval_valid) $fatal(1,"Primeiro evento gerou intervalo falso");
        repeat(9) tick(0,0);
        tick(1,1);
        if(validated!=2||published!=2||interval_cycles!=10||!interval_valid) $fatal(1,"Contagem/intervalo incorreto");
        // O timestamp cruza wrap, mas intervalo menor que 2^WIDTH conserva a diferenca modular.
        repeat(249) tick(0,0);tick(0,1);
        if(interval_cycles!=250||published!=3||validated!=2) $fatal(1,"Wrap perdeu o intervalo");
        repeat(20) tick(0,0);
        if(published!=3||interval_cycles!=250) $fatal(1,"Ausencia de quadro contada como publicacao");
        @(negedge clk);rst=1;ddr_commit=1;vga_published=1;
        @(posedge clk);#1;
        if(validated||published||ticks||interval_cycles||interval_valid) $fatal(1,"Reset nao prevaleceu");
        $display("PASS video_metrics: etapas separadas, intervalo, wrap, ausencia de evento e reset");$finish;
    end
endmodule
