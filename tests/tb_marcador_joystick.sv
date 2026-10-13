`timescale 1ns/1ps
module tb_marcador_joystick;
    logic clk=0; always #5 clk=~clk;
    logic [11:0] eixo_x=2048, eixo_y=2048;
    logic enable=1, reset=1;
    wire [9:0] x;
    wire [8:0] y;
    wire locked;
    integer y_antes;
    integer passo_menor;

    mira_joystick #(
        .DEADZONE(100), .CALIB_BITS(3), .TICK_CYCLES(1),
        .X_MIN(24), .X_MAX(615), .Y_MIN(24), .Y_MAX(455),
        .INITIAL_X(430), .INITIAL_Y(180), .MAX_STEP(8),
        .PASSO_SHIFT(5), .DEBOUNCE_CYCLES(3)
    ) dut (
        .clk(clk), .x_raw(eixo_y), .y_raw(eixo_x), .sw_n(1'b1),
        .enable(enable), .reset(reset), .x(x), .y(y), .locked(locked)
    );

    task automatic ciclos(input integer n);
        repeat(n) @(negedge clk);
    endtask
    task automatic centro;
        eixo_x=2048; eixo_y=2048; ciclos(8);
    endtask
    task automatic reset_inicial;
        reset=1; ciclos(2); reset=0; eixo_x=2048; eixo_y=2048; ciclos(12);
    endtask

    initial begin
        ciclos(2); reset=0; ciclos(12);
        if (x!=430 || y!=180) $fatal(1,"Reset deve iniciar marcador em 430,180; obtido %0d,%0d",x,y);

        eixo_y=2300; ciclos(5);
        passo_menor=x-430;
        if (passo_menor<=0) $fatal(1,"Deflexão X positiva não moveu marcador à direita: %0d",x);
        reset_inicial();
        eixo_y=4095; ciclos(5);
        if (x-430 <= passo_menor) $fatal(1,"Passo não aumentou com deflexão maior: menor=%0d maior=%0d",passo_menor,x-430);
        if (x-430 > 40) $fatal(1,"Passo proporcional excedeu faixa esperada: %0d",x-430);
        centro();
        if (x<430) $fatal(1,"Marcador não reteve posição ao centralizar: %0d",x);
        if (x!=470) $fatal(1,"Centralizar o joystick não deve alterar a posição: %0d",x);
        eixo_y=0; ciclos(5);
        if (x>=470) $fatal(1,"Deflexão X negativa não moveu marcador à esquerda: %0d",x);
        centro();

        eixo_x=0; ciclos(5);
        if (y>=180) $fatal(1,"Orientação aprovada do eixo Y não moveu para cima: %0d",y);
        centro();
        y_antes=y;
        eixo_x=4095; ciclos(5);
        if (y<=y_antes) $fatal(1,"Orientação aprovada do eixo Y não moveu para baixo: %0d",y);
        centro();

        reset_inicial();
        eixo_x=2148; eixo_y=1948; ciclos(20);
        if (x!=430 || y!=180) $fatal(1,"Deadzone permitiu jitter: %0d,%0d",x,y);

        eixo_x=4095; eixo_y=0; ciclos(120);
        if (x!=24 || y!=455) $fatal(1,"Clamp mínimo X/máximo Y incorreto: %0d,%0d",x,y);
        eixo_x=0; eixo_y=4095; ciclos(120);
        if (x!=615 || y!=24) $fatal(1,"Clamp máximo X/mínimo Y incorreto: %0d,%0d",x,y);
        eixo_x=4095; eixo_y=4095; ciclos(120);
        if (x!=615 || y!=455) $fatal(1,"Clamp máximo X/Y incorreto: %0d,%0d",x,y);
        eixo_x=0; eixo_y=0; ciclos(120);
        if (x!=24 || y!=24) $fatal(1,"Clamp mínimo X/Y incorreto: %0d,%0d",x,y);

        enable=0; eixo_x=4095; eixo_y=0; ciclos(50);
        if (x!=24 || y!=24) $fatal(1,"Marcador moveu no estilo CAÇA");
        enable=1; ciclos(5);
        if (x!=24 || y<=24) $fatal(1,"NORMAL não retomou controle do marcador: %0d,%0d",x,y);

        reset_inicial();
        if (x!=430 || y!=180 || locked) $fatal(1,"Reset durante movimento não restaurou posição inicial");
        $display("PASS marcador: inicial, sentidos, proporcionalidade, retenção, deadzone, clamp, arbitragem e reset");
        $finish;
    end
endmodule
