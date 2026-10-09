`timescale 1ns/1ps
module tb_modos_operacao_integrado;
    logic clk=0; always #5 clk=~clk;
    logic [1:0] operacao_sw=0; logic ack_btn=0,display_mode=0,style_mode=0;
    tri1 sda,scl,bsda,bscl,msda,mscl;
    wire [3:0] r,g,b;
    top_reticula #(.OPERACAO_DEBOUNCE(4),.OPERACAO_TICK(20),.OPERACAO_ACK(2)) dut(
        .clk(clk),.operacao_sw(operacao_sw),.ack_btn(ack_btn),.btn_heading(2'b0),.sw(4'b0),
        .display_mode(display_mode),.style_mode(style_mode),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
        .i2c_sda(sda),.i2c_scl(scl),.baro_sda(bsda),.baro_scl(bscl),.mag_sda(msda),.mag_scl(mscl),
        .VGA_R(r),.VGA_G(g),.VGA_B(b));
    defparam dut.u_modo.DEBOUNCE_CYCLES=2;
    defparam dut.u_estilo.DEBOUNCE_CYCLES=2;
    integer checks=0;
    task automatic check(input logic ok,input string nome);
        checks++;
        if(ok !== 1'b1) $fatal(1,"%s: modo=%0d v=%0d h=%0d meta=%h",nome,dut.hud_metadados[1:0],dut.velocidade_kt,dut.altitude_ft,dut.hud_metadados);
    endtask
    task quadro;
        repeat(100) @(negedge clk);
        @(negedge dut.pixel_clk); force dut.u_vga.h_cont=0; force dut.u_vga.v_cont=480;
        @(posedge dut.pixel_clk); #1;
        @(negedge dut.pixel_clk); force dut.u_vga.h_cont=100; force dut.u_vga.v_cont=100;
    endtask
    task automatic modo(input logic [1:0] novo);
        logic [31:0] anterior;
        logic [9:0] v_anterior;
        anterior=dut.hud_metadados; v_anterior=dut.velocidade_kt;
        operacao_sw=novo; repeat(100) @(negedge clk);
        check(dut.hud_metadados===anterior && dut.velocidade_kt===v_anterior,"retencao durante quadro");
        quadro();
        check(dut.hud_metadados[1:0]==(novo==3?0:novo),"modo aplicado por quadro");
        check(dut.hud_metadados[2]==(novo==3),"estado reservado");
    endtask
    initial begin
        force dut.u_vga.h_cont=100; force dut.u_vga.v_cont=100;
        force dut.sensor_ok=0; force dut.mag_sensor_ok=0; force dut.baro_sensor_ok=0;
        repeat(20) @(negedge clk); quadro();
        check(dut.velocidade_kt==0 && dut.altitude_ft==0,"SOLO sem fallback 280/36000");
        check(dut.hud_metadados[5:3]==0 && dut.hud_metadados[10:9]==3,"falha explicita SOLO");
        force dut.sensor_ok=1; force dut.atitude_calibrada=1; force dut.gyro_bias_calibrado=1;
        force dut.fusao_valida=1; force dut.fusao_atualizar=1;
        force dut.fusao_pitch_q10=5120; force dut.fusao_roll_q10=10240;
        force dut.baro_sensor_ok=1; force dut.baro_calibracao_ok=1;
        force dut.baro_altitude_calc_ok=1; force dut.altitude_hud_entrada=1234;
        force dut.mag_sensor_ok=1; force dut.heading_magnetico_valido=1;
        force dut.heading_magnetico_atualizado=1; force dut.heading_entrada=90;
        force dut.vertical_valido=1; force dut.vel_vertical_fpm=120;
        quadro();
        check(dut.velocidade_kt==0 && dut.altitude_ft==1234 && dut.heading_deg==90,"SOLO real");
        check(dut.horizonte_y==260 && dut.roll_q8>40 && dut.roll_q8<50,"atitude real");
        check(dut.hud_metadados[6:3]==15,"validade das fontes");
        modo(1);
        check(dut.velocidade_kt>=275 && dut.velocidade_kt<=285 && dut.altitude_ft>=35950,"VOO simulado");
        check(dut.horizonte_y==260 && dut.hud_metadados[8] && !dut.hud_metadados[7],"VOO atitude fisica");
        force dut.joystick_x_raw=12'd4095; force dut.joystick_y_raw=12'd0;
        quadro(); check(dut.horizonte_y==260,"joystick não interfere na atitude do VOO");
        force dut.fusao_roll_q10=15360; quadro();
        check(dut.hud_metadados[10:9]==2 && dut.buzzer_out,"ROLL CAUTION/audio");
        ack_btn=1; repeat(20) @(negedge clk); quadro();
        check(!dut.buzzer_out && dut.hud_metadados[15] && dut.hud_metadados[10:9]==2,"ACK preserva CAUTION");
        force dut.fusao_roll_q10=30720; quadro();
        check(dut.hud_metadados[10:9]==3 && dut.hud_metadados[13:11]==1 && dut.buzzer_out,"ROLL WARNING/audio");
        check(!dut.hud_metadados[15],"escalada cancela ACK com botao mantido");
        ack_btn=0; repeat(20) @(negedge clk);
        ack_btn=1; repeat(20) @(negedge clk); quadro();
        check(!dut.buzzer_out && dut.hud_metadados[15] && dut.hud_metadados[10:9]==3,"ACK preserva visual");
        for(int estilo=0;estilo<2;estilo++) begin
            style_mode=1'(estilo); display_mode=1; quadro();
            force dut.u_vga.h_cont=440; force dut.u_vga.v_cont=12; #2;
            check({r,g,b}==12'hF00,"WARNING visivel em DECLUTTER nos dois estilos");
            force dut.u_vga.h_cont=700; #2; check({r,g,b}==0,"blanking");
            force dut.u_vga.h_cont=100; force dut.u_vga.v_cont=100;
        end
        force dut.fusao_roll_q10=0; ack_btn=0; quadro();
        check(dut.hud_metadados[10:9]==0 && !dut.hud_metadados[15],"fim limpa ACK");
        modo(2); check(dut.altitude_ft<=1500 && dut.altitude_ft>1400 && dut.velocidade_kt<=160,"POUSO inicia");
        modo(0); check(dut.velocidade_kt==0 && dut.altitude_ft==1234,"retorno SOLO");
        modo(3); check(dut.velocidade_kt==0 && dut.altitude_ft==1234 && dut.hud_metadados[2],"11 seguro");
        modo(1); force dut.sensor_ok=0; quadro();
        check(dut.hud_metadados[7] && !dut.hud_metadados[3] && dut.hud_metadados[24],"fallback explicito VOO");
        check(dut.horizonte_y==240,"fallback explícito sem comando do joystick");
        force dut.reset_operacao=1; quadro();
        check(dut.hud_metadados[1:0]==0 && !dut.buzzer_out,"reset integrado");
        release dut.reset_operacao;
        $display("PASS modos integrados: %0d verificacoes, fontes, CDC, quadro, visual, audio e reset",checks); $finish;
    end
    initial begin #2000000; $fatal(1,"Timeout integrado"); end
endmodule
