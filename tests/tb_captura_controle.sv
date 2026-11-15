`timescale 1ns/1ps
module tb_captura_controle;
    reg clk=0,reset=1,button=0;
    always #5 clk=~clk;
    reg [3:0] page=0;
    wire video_mode,capture,step,zero,grid;
    wire [1:0] view;
    captura_controle #(.DEBOUNCE(4),.LONG_PRESS(40)) dut(.clk(clk),.reset(reset),.button(button),
        .page(page),.video_mode(video_mode),.capture(capture),.step_toggle(step),.zero_request(zero),.view(view),.grid(grid));
    integer zeros=0;
    always @(posedge clk) if(zero) zeros++;
    task automatic short_press;
        button=1;repeat(12) @(negedge clk);button=0;repeat(12) @(negedge clk);
    endtask
    task automatic long_press;
        button=1;repeat(55) @(negedge clk);button=0;repeat(12) @(negedge clk);
    endtask
    initial begin
        repeat(3) @(negedge clk);reset=0;
        button=1;repeat(2) @(negedge clk);button=0;repeat(8) @(negedge clk);
        if(!video_mode) $fatal(1,"Bounce alterou video");
        short_press(); if(video_mode) $fatal(1,"BTNL curto nao alternou");
        short_press(); if(!video_mode) $fatal(1,"BTNL curto nao retornou");
        long_press(); if(!capture || !video_mode || step) $fatal(1,"BTNL longo tambem executou curto");
        short_press(); if(!step || !capture) $fatal(1,"Avanco nao gerou token");
        page=4'b0111;repeat(6) @(negedge clk);
        if(view!=3 || !grid) $fatal(1,"Selecao de vista/grade");
        page=15;repeat(8) @(negedge clk);
        if(zeros!=1) $fatal(1,"Zero deve ser pulso unico");
        long_press(); if(capture || view!=1 || grid) $fatal(1,"Saida captura");
        $display("PASS controles: bounce, video, captura, passo, vistas, grade, pulso de zero");$finish;
    end
endmodule
