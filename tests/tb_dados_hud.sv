`timescale 1ns/1ps
module tb_dados_hud;
    logic clk=0;
    always #20 clk=~clk;
    logic quadro=0,valido=0;
    logic [9:0] vel=0;
    logic [16:0] alt=0;
    logic signed [10:0] pitch=0;
    logic signed [9:0] roll=0;
    logic [8:0] heading=0;
    logic [9:0] mira_x_in=320;
    logic [8:0] mira_y_in=240;
    logic mira_lock_in=0;
    logic [9:0] alvo_x_in=430;
    logic [8:0] alvo_y_in=180;
    wire [9:0] v,y;
    wire [16:0] a;
    wire signed [9:0] r;
    wire [8:0] h;
    wire [9:0] mira_x;
    wire [8:0] mira_y;
    wire mira_lock;
    wire [9:0] alvo_x;
    wire [8:0] alvo_y;
    dados_hud dut (
        .clk(clk),
        .atualizar_quadro(quadro),
        .dados_validos(valido),

        .velocidade_kt_in(vel),
        .altitude_ft_in(alt),
        .pitch_px_in(pitch),
        .roll_q8_in(roll),
        .heading_deg_in(heading),
        .mira_x_in(mira_x_in),.mira_y_in(mira_y_in),.mira_lock_in(mira_lock_in),
        .alvo_x_in(alvo_x_in),.alvo_y_in(alvo_y_in),

        .velocidade_kt(v),
        .altitude_ft(a),
        .horizonte_y(y),
        .roll_q8(r),
        .heading_deg(h),.mira_x(mira_x),.mira_y(mira_y),.mira_lock(mira_lock),
        .alvo_x(alvo_x),.alvo_y(alvo_y)
    );
    task ciclo; @(posedge clk); #1; @(negedge clk); endtask
    initial begin
        ciclo();
        vel=321; alt=45678; pitch=-40; roll=64; heading=275;
        mira_x_in=500; mira_y_in=300; mira_lock_in=1; valido=1; ciclo(); valido=0;
        if(v!=280 || a!=36000 || y!=240 || r!=0 || h!=0) $fatal(1,"Dados mudaram durante o quadro");
        if(mira_x!=320 || mira_y!=240 || mira_lock) $fatal(1,"Mira mudou durante o quadro");
        if(alvo_x!=430 || alvo_y!=180) $fatal(1,"Marcador mudou antes do quadro");
        vel=0; alt=0; pitch=0; roll=0; repeat(3) ciclo();
        quadro=1; ciclo(); quadro=0;
        if(v!=321 || a!=45678 || y!=200 || r!=64 || h!=275) $fatal(1,"Amostra entre quadros foi perdida");
        if(mira_x!=500 || mira_y!=300 || !mira_lock) $fatal(1,"Mira não aplicou a amostra na fronteira de quadro");
        if(alvo_x!=430 || alvo_y!=180) $fatal(1,"Amostra inicial do marcador incorreta");
        alvo_x_in=24; alvo_y_in=455; valido=1; ciclo(); valido=0;
        if(alvo_x!=430 || alvo_y!=180) $fatal(1,"Marcador furou a fronteira do quadro");
        quadro=1; ciclo(); quadro=0;
        if(alvo_x!=24 || alvo_y!=455) $fatal(1,"Marcador não aplicou posição no limite do quadro");
        alvo_x_in=0; alvo_y_in=0; valido=1; ciclo(); valido=0;
        quadro=1; ciclo(); quadro=0;
        if(alvo_x!=24 || alvo_y!=24) $fatal(1,"Clamp do marcador deveria ser X=24 Y=24");
        vel=1023; alt=131071; pitch=1023; roll=511; heading=511; valido=1; ciclo(); valido=0;
        quadro=1; ciclo(); quadro=0;
        if(v!=999 || a!=99999 || y!=400 || r!=128) $fatal(1,"Limites superiores incorretos");
        if(h !== 9'd359) $fatal(1,"Rumo de entrada=511: obtido=%0d esperado=359",h);
        pitch=-1024; roll=-512; valido=1; quadro=1; ciclo();
        if(y!=400) $fatal(1,"Amostra simultânea deve aguardar próximo quadro");
        valido=0; quadro=0; ciclo(); quadro=1; ciclo(); quadro=0;
        if(y!=80 || r!=-128) $fatal(1,"Limites inferiores incorretos");
        heading=0; valido=1; ciclo(); valido=0;
        if(h !== 9'd359) $fatal(1,"Antes do quadro: obtido=%0d esperado=359",h);
        quadro=1; ciclo(); quadro=0;
        if(h !== 9'd0) $fatal(1,"Rumo de entrada=0: obtido=%0d esperado=0",h);

        // Pitch físico de +30 graus: 120 px devem deslocar o horizonte
        // de y=240 para y=360, preservando a escala de 4 px/grau.
        pitch=120; valido=1; ciclo(); valido=0; quadro=1; ciclo(); quadro=0;
        if(y!=360) $fatal(1,"Pitch +30 graus deveria posicionar horizonte em y=360, obtido %0d",y);
        pitch=-120; valido=1; ciclo(); valido=0; quadro=1; ciclo(); quadro=0;
        if(y!=120) $fatal(1,"Pitch -30 graus deveria posicionar horizonte em y=120, obtido %0d",y);
        $display("PASS dados: captura atômica, pulso válido, retenção, coincidência e saturação de rumo"); $finish;
    end
endmodule
