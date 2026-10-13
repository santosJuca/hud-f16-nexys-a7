`timescale 1ns/1ps
module tb_marcador_integrado;
    logic clk=0, pix=0;
    always #5 clk=~clk;
    always #20 pix=~pix;
    logic modo_caca=0, declutter=0, sw_n=1;
    logic [11:0] adc_x=2048, adc_y=2048;
    wire [11:0] xadc_x, xadc_y;
    wire [9:0] origem_x;
    wire [8:0] origem_y;
    wire locked;
    wire [18:0] pacote={origem_y,origem_x};
    wire pronto, valido;
    wire [18:0] pacote_pix;
    logic frame=0;
    wire [9:0] aplicado_x;
    wire [8:0] aplicado_y;
    wire alvo_raster;
    logic [9:0] raster_x=0;
    logic [8:0] raster_y=0;

    joystick_xadc u_adc(.clk(clk),.vauxp3(1'b0),.vauxn3(1'b0),
        .vauxp10(1'b0),.vauxn10(1'b0),.x_raw(xadc_x),.y_raw(xadc_y));
    // Injeta as amostras do conversor para exercitar o caminho a partir da
    // interface digital do XADC sem depender do modelo comportamental da FPGA.
    mira_joystick #(.DEADZONE(100),.CALIB_BITS(3),.TICK_CYCLES(1),
        .X_MIN(24),.X_MAX(615),.Y_MIN(24),.Y_MAX(455),
        .INITIAL_X(430),.INITIAL_Y(180),.MAX_STEP(8),
        .PASSO_SHIFT(5),.DEBOUNCE_CYCLES(3)) u_ctrl(
        .clk(clk),.x_raw(xadc_y),.y_raw(xadc_x),.sw_n(sw_n),
        .enable(!modo_caca),.reset(1'b0),.x(origem_x),.y(origem_y),.locked(locked));
    entrada_hud #(.WIDTH(19)) u_cdc(.clk_origem(clk),.clk_destino(pix),
        .valido(1'b1),.dados(pacote),.pronto(pronto),
        .valido_destino(valido),.dados_destino(pacote_pix));
    dados_hud u_data(.clk(pix),.atualizar_quadro(frame),.dados_validos(valido),
        .metadados_in(32'd0),.velocidade_kt_in(10'd0),.altitude_ft_in(17'd0),
        .pitch_px_in(11'sd0),.roll_q8_in(10'sd0),.heading_deg_in(9'd0),
        .mira_x_in(10'd320),.mira_y_in(9'd240),.mira_lock_in(1'b0),
        .alvo_x_in(pacote_pix[9:0]),.alvo_y_in(pacote_pix[18:10]),
        .alvo_x(aplicado_x),.alvo_y(aplicado_y));
    simbologia_vga u_render(.pixel_x(raster_x),.pixel_y({1'b0,raster_y}),
        .video_on(!modo_caca),.horizonte_y(10'd240),.roll_q8(10'sd0),
        .heading_deg(9'd0),.alvo_x(aplicado_x),.alvo_y(aplicado_y),
        .horizonte_on(),.altitude_on(),.direcao_on(),.alvo_on(alvo_raster),
        .velocidade_on());

    task automatic ciclos_pix(input integer n);
        repeat(n) @(negedge pix);
    endtask
    task automatic quadro;
        @(negedge pix); frame=1; @(negedge pix); frame=0; #1;
    endtask
    task automatic aplica_amostra;
        repeat(30) @(negedge pix);
        quadro();
    endtask
    task automatic confere_canto(input integer cx,input integer cy,input logic esperado);
        raster_x=10'(cx-24); raster_y=9'(cy-24); #1;
        if (alvo_raster !== esperado)
            $fatal(1,"Raster esperado=%b em centro %0d,%0d; origem %0d,%0d",esperado,cx,cy,aplicado_x,aplicado_y);
    endtask
    initial begin
        force u_adc.x_raw = adc_x;
        force u_adc.y_raw = adc_y;
        ciclos_pix(8);
        aplica_amostra();
        if(aplicado_x!=430 || aplicado_y!=180) $fatal(1,"posição inicial incorreta");
        adc_y=4095; repeat(5) @(negedge clk); ciclos_pix(5);
        if(origem_x<=430) $fatal(1,"NORMAL não moveu o marcador");
        aplica_amostra();
        if(aplicado_x!=origem_x) $fatal(1,"CDC/dados_hud não aplicou a posição");
        confere_canto(aplicado_x,aplicado_y,1'b1);
        declutter=1;
        confere_canto(aplicado_x,aplicado_y,1'b1);
        declutter=0;
        modo_caca=1; repeat(5) @(negedge clk);
        adc_y=0; repeat(8) @(negedge clk);
        if(origem_x<=430) $fatal(1,"CAÇA não congelou posição");
        aplica_amostra();
        if(aplicado_x!=origem_x) $fatal(1,"posição deveria ficar retida em CAÇA");
        confere_canto(aplicado_x,aplicado_y,1'b0);
        modo_caca=0; repeat(5) @(negedge clk); repeat(8) @(negedge clk);
        if(origem_x>=aplicado_x) $fatal(1,"NORMAL não retomou movimento armazenado");
        sw_n=0; repeat(10) @(negedge clk); sw_n=1; repeat(5) @(negedge clk);
        if(!locked) $fatal(1,"LOCK não foi ativado");
        adc_y=4095; repeat(8) @(negedge clk);
        if(origem_x>=aplicado_x) $fatal(1,"LOCK não congelou posição");
        sw_n=0; repeat(10) @(negedge clk); sw_n=1; repeat(5) @(negedge clk);
        if(locked) $fatal(1,"UNLOCK não foi ativado");
        adc_x=4095; adc_y=0; repeat(200) @(negedge clk);
        if(origem_x!=24 || origem_y!=455) $fatal(1,"limites incorretos %0d,%0d",origem_x,origem_y);
        aplica_amostra();
        if(aplicado_x!=24 || aplicado_y!=455) $fatal(1,"limite não propagou até dados_hud");
        confere_canto(24,455,1'b1);
        adc_x=0; adc_y=4095; repeat(200) @(negedge clk);
        if(origem_x!=615 || origem_y!=24) $fatal(1,"limite oposto incorreto");
        aplica_amostra();
        if(aplicado_x!=615 || aplicado_y!=24) $fatal(1,"limite oposto não propagou");
        $display("PASS integração marcador: controlador, CDC, quadro, raster, modos, LOCK e limites");
        $finish;
    end
endmodule
