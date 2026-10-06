`timescale 1ns/1ps
module tb_heading_magnetico;
    logic clk=0, ok=1, nova=0;
    always #5 clk=~clk;
    logic signed [15:0] x=0,y=0;
    wire [8:0] heading[0:3];
    wire [3:0] valido;
    heading_magnetico dut(clk,ok,nova,x,y,heading[0],valido[0]);
    heading_magnetico #(.OFFSET_X(16'sd100),.OFFSET_Y(-16'sd200),
        .TROCAR_XY(1),.INVERTER_X(1)) ajustado(clk,ok,nova,x,y,heading[1],valido[1]);
    heading_magnetico #(.OFFSET_X(-16'sd32768),.OFFSET_Y(16'sd32767),
        .INVERTER_X(1),.INVERTER_Y(1)) extremos(clk,ok,nova,x,y,heading[2],valido[2]);
    heading_magnetico #(.INVERTER_Y(1)) invertido(clk,ok,nova,x,y,heading[3],valido[3]);
    integer casos=0;
    task automatic confere(input integer idx,ex,ey);
        real graus;
        integer esperado,erro;
        bit valido_esperado;
        valido_esperado=ok && (ex!=0 || ey!=0) && x!=-4096 && y!=-4096;
        if(valido[idx] !== valido_esperado)
            $fatal(1,"XY=%0d/%0d modulo=%0d valido=%b esperado=%b",x,y,idx,valido[idx],valido_esperado);
        if(valido_esperado) begin
            graus=$atan2(ey,ex)*180.0/3.141592653589793;
            if(graus<0) graus=graus+360.0;
            esperado=$rtoi(graus+0.5)%360;
            erro=heading[idx]-esperado;
            if(erro>180) erro=erro-360;
            if(erro< -180) erro=erro+360;
            if(heading[idx]>359 || erro>1 || erro< -1)
                $fatal(1,"XY=%0d/%0d modulo=%0d heading=%0d esperado=%0d (+/-1)",x,y,idx,heading[idx],esperado);
        end
    endtask
    task automatic vetor(input integer vx,vy);
        @(negedge clk); x=16'(vx); y=16'(vy); nova=1;
        @(negedge clk); nova=0;
        repeat(24) @(negedge clk);
        confere(0,vx,vy); confere(1,-(vy+200),vx-100);
        confere(2,-(vx+32768),-(vy-32767)); confere(3,vx,-vy);
        casos=casos+1;
    endtask
    integer vx,vy;
    initial begin
        vetor(1000,0); if(heading[0]!=0) $fatal(1,"N != 0");
        vetor(0,1000); if(heading[0]!=90) $fatal(1,"E != 90");
        vetor(-1000,0); if(heading[0]!=180) $fatal(1,"S != 180");
        vetor(0,-1000); if(heading[0]!=270) $fatal(1,"W != 270");
        vetor(1000,1000); vetor(-1000,1000); vetor(-1000,-1000); vetor(1000,-1000);
        vetor(1000,-17); if(heading[0]!=359) $fatal(1,"wrap esperado 359");
        vetor(1000,-1); if(heading[0]!=0) $fatal(1,"wrap esperado 0");
        vetor(1,0); vetor(0,1); vetor(-1,-1); vetor(0,0); vetor(100,-200);
        vetor(-4096,10); vetor(10,-4096);
        vetor(-32768,32767); vetor(32767,-32768); vetor(-32768,-32768); vetor(32767,32767);
        for(integer i=0;i<360;i=i+1) begin
            vx=$rtoi(2000*$cos(i*3.141592653589793/180));
            vy=$rtoi(2000*$sin(i*3.141592653589793/180)); vetor(vx,vy);
        end
        for(integer i=0;i<1000;i=i+1) begin
            vx=$signed(16'($urandom)); vy=$signed(16'($urandom)); vetor(vx,vy);
        end
        @(negedge clk); ok=0; @(negedge clk);
        if(valido) $fatal(1,"perda do sensor manteve rumo valido");
        ok=1; repeat(25) @(negedge clk);
        if(valido) $fatal(1,"rumo antigo reutilizado sem nova amostra");
        vetor(1000,0);
        @(negedge clk); nova=1;
        @(negedge clk); nova=0;
        repeat(8) @(negedge clk); ok=0;
        @(negedge clk); ok=1;
        repeat(25) @(negedge clk);
        if(valido) $fatal(1,"calculo interrompido publicou rumo");
        $display("PASS heading: %0d vetores em 4 configuracoes; cardeais, quadrantes, wrap, offsets, limites e perda",casos);
        $finish;
    end
    initial begin #1_000_000; $fatal(1,"timeout heading"); end
endmodule
