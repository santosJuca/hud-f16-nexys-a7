`timescale 1ns/1ps
module tb_hud_dispatch_latest;
    logic clk=0, reset=1, sw4=0, capture=0;
    logic [1:0] buttons=0;
    wire align;
    wire [1:0] heading_btn, align_btn;
    wire grid_pulse;
    integer grid_count=0;
    always #5 clk=~clk;
    always @(posedge clk) if(grid_pulse) grid_count=grid_count+1;
    hud_command_dispatch #(.DEBOUNCE_CYCLES(3),.SWITCH_DEBOUNCE_CYCLES(3)) dut(
        .clk(clk),.reset(reset),.align_switch(sw4),.capture_active(capture),
        .buttons(buttons),.align_mode(align),.heading_buttons(heading_btn),
        .align_buttons(align_btn),.capture_grid_pulse(grid_pulse));
    task automatic settle; repeat(14) @(negedge clk); endtask
    initial begin
        settle(); reset=0; settle();
        if(align || heading_btn || align_btn) $fatal(1,"Roteamento inicial");
        buttons=2'b01; settle();
        if(heading_btn!=1 || align_btn) $fatal(1,"Rumo nao recebeu botao");
        sw4=1; settle();
        if(!align || heading_btn || align_btn) $fatal(1,"Botao retido vazou para ALIGN");
        buttons=0; settle(); buttons=1; settle();
        if(heading_btn || align_btn!=1) $fatal(1,"ALIGN nao recebeu botao");
        buttons=3; settle();
        if(heading_btn || align_btn) $fatal(1,"Acorde gerou movimento");
        // A versao recente prioriza SW4; o controle de captura tem inhibit proprio.
        capture=1; settle();
        if(!align || heading_btn || align_btn || grid_count) $fatal(1,"Prioridade ALIGN/captura");
        buttons=0; settle(); buttons=2; settle();
        if(!align || heading_btn || align_btn!=2 || grid_count) $fatal(1,"Captura roubou ALIGN");
        sw4=0; settle();
        if(align || heading_btn || align_btn || grid_count) $fatal(1,"Troca de rota gerou comando");
        buttons=0; settle(); buttons=3; settle();
        if(grid_count!=1) $fatal(1,"Grade nao recebeu acorde novo");
        settle(); if(grid_count!=1) $fatal(1,"Grade repetiu acorde retido");
        buttons=0; settle(); buttons=3; settle();
        if(grid_count!=2) $fatal(1,"Segundo acorde perdido");
        capture=0; settle();
        if(heading_btn || align_btn || grid_pulse) $fatal(1,"Comando fantasma ao sair da captura");
        buttons=0; settle(); buttons=2; settle();
        if(heading_btn!=2 || align_btn) $fatal(1,"Rumo nao restaurado");
        $display("PASS dispatcher recente: prioridade ALIGN, captura, grade, rearme e ausencia de comandos fantasmas");
        $finish;
    end
    initial begin #100000; $fatal(1,"Timeout dispatcher recente"); end
endmodule
