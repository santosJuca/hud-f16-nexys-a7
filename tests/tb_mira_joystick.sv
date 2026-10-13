`timescale 1ns/1ps
module tb_mira_joystick;
    logic clk=0; always #5 clk=~clk;
    logic [11:0] x_raw=2048, y_raw=2048;
    logic sw_n=1;
    logic enable=1, reset=0;
    wire [9:0] x;
    wire [8:0] y;
    wire locked;
    logic [9:0] pixel_x=329;
    logic [9:0] pixel_y=240;
    logic video_on=1;
    wire mira_on;
    wire [11:0] mira_rgb;
    mira_joystick #(.DEADZONE(100),.CALIB_BITS(2),.TICK_CYCLES(1),
        .MAX_STEP(8),.PASSO_SHIFT(5),.DEBOUNCE_CYCLES(3)) dut(.*);
    mira_caca_vga grafico(.pixel_x(pixel_x),.pixel_y(pixel_y),.video_on(video_on),
        .mira_x(10'd320),.mira_y(9'd240),.locked(locked),.on(mira_on),.rgb(mira_rgb));

    task automatic ciclos(input integer quantidade);
        repeat(quantidade) @(negedge clk);
    endtask
    initial begin
        ciclos(8);
        if (x!=320 || y!=240) $fatal(1,"Centro esperado 320,240; obtido %0d,%0d",x,y);
        #1;
        if(!mira_on || mira_rgb!=12'h0FF) $fatal(1,"Mira CAÇA móvel não desenhada em UNLOCK");
        x_raw=2148; y_raw=1948; ciclos(4);
        if (x!=320 || y!=240) $fatal(1,"Deadzone moveu a mira: %0d,%0d",x,y);

        x_raw=4095; y_raw=0; ciclos(20);
        if (x<=320 || y>=240) $fatal(1,"Eixos X/Y não moveram: %0d,%0d",x,y);
        ciclos(100);
        if (x!=616 || y!=24) $fatal(1,"Limites não saturaram: %0d,%0d",x,y);

        sw_n=0; ciclos(8);
        if (!locked) $fatal(1,"Pressionamento não ativou LOCK");
        #1;
        if(!mira_on || mira_rgb!=12'hFA0) $fatal(1,"Mira CAÇA não indicou LOCK");
        x_raw=0; y_raw=4095; ciclos(100);
        if (x!=616 || y!=24) $fatal(1,"Mira LOCK mudou: %0d,%0d",x,y);
        ciclos(20);
        if (!locked) $fatal(1,"Botão mantido alternou mais de uma vez");
        video_on=0; #1;
        if(mira_on) $fatal(1,"Mira apareceu durante blanking");
        video_on=1;

        sw_n=1; ciclos(8); sw_n=0; ciclos(8);
        if (locked) $fatal(1,"Segundo pressionamento não ativou UNLOCK");
        ciclos(20);
        if (x>=616 || y<=24) $fatal(1,"Mira UNLOCK não retomou movimento");
        $display("PASS mira: centro/deadzone, eixos, limites, debounce, LOCK e UNLOCK");
        $finish;
    end
endmodule
