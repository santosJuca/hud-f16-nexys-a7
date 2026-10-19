`timescale 1ns/1ps
module tb_alertas_voo;
    logic clk=0; always #5 clk=~clk;
    logic reset=1; logic [1:0] modo=1; logic modo_invalido=0;
    logic [2:0] fase_pouso=0;
    logic signed [31:0] roll_q10=0,pitch_q10=0;
    logic [9:0] velocidade_kt=280; logic [16:0] altitude_ft=36000;
    logic signed [13:0] vertical_fpm=0;
    logic att_valid=1,attitude_alert_valid=1,alt_valid=1,heading_valid=1,vertical_valid=1;
    wire [1:0] severity; wire [2:0] causa;
    wire alert_roll,alert_pitch,alert_speed,alert_stall,alert_altitude,alert_sink,alert_sensor;
    integer checks=0;
    alertas_voo dut(.*);
    task automatic confere(input integer sev, code);
        repeat(2) @(negedge clk); checks++;
        if(severity !== 2'(sev) || causa !== 3'(code)) $fatal(1,"Roll=%0d pitch=%0d: obtido=%0d/%0d esperado=%0d/%0d",roll_q10,pitch_q10,severity,causa,sev,code);
    endtask
    task automatic atitude(input bit eixo_pitch, input integer angulo_q10, sev);
        roll_q10=eixo_pitch ? 0 : angulo_q10;
        pitch_q10=eixo_pitch ? angulo_q10 : 0;
        confere(sev,sev==0 ? 0 : eixo_pitch ? 2 : 1);
        if(alert_roll !== (!eixo_pitch && sev!=0) ||
           alert_pitch !== (eixo_pitch && sev!=0))
            $fatal(1,"Eixo pitch=%b Q10=%0d: flags roll/pitch=%b/%b severity esperada=%0d",
                eixo_pitch,angulo_q10,alert_roll,alert_pitch,sev);
    endtask
    initial begin
        @(negedge clk); reset=0; confere(0,0);
        for(int sinal=-1;sinal<=1;sinal+=2) begin
            // Inclui 14/15/16/24/25/26 graus e os dois sentidos.
            for(int graus=0;graus<=26;graus++)
                atitude(0,sinal*graus*1024,graus>=25 ? 3 : graus>=15 ? 2 : 0);
            atitude(0,sinal*25*1024,3);
            atitude(0,sinal*22*1024,3);
            atitude(0,sinal*(22*1024-1),2);
            atitude(0,sinal*21*1024,2);
            atitude(0,sinal*12*1024,2);
            atitude(0,sinal*(12*1024-1),0);
            atitude(0,0,0);
            atitude(0,sinal*(15*1024-1),0);
            atitude(0,sinal*15*1024,2);
            atitude(0,sinal*(25*1024-1),2);
            atitude(0,sinal*25*1024,3);
            atitude(0,0,0);
            // Inclui 9/10/11/14/15/16 graus; warning libera abaixo de 12.
            for(int graus=0;graus<=16;graus++)
                atitude(1,sinal*graus*1024,graus>=15 ? 3 : graus>=10 ? 2 : 0);
            atitude(1,sinal*15*1024,3);
            atitude(1,sinal*13*1024,3);
            atitude(1,sinal*12*1024,3);
            atitude(1,sinal*(12*1024-1),2);
            atitude(1,sinal*11*1024,2);
            atitude(1,sinal*8*1024,2);
            atitude(1,sinal*(8*1024-1),0);
            atitude(1,0,0);
            atitude(1,sinal*(10*1024-1),0);
            atitude(1,sinal*10*1024,2);
            atitude(1,sinal*(15*1024-1),2);
            atitude(1,sinal*15*1024,3);
            atitude(1,0,0);
        end
        roll_q10=25*1024; pitch_q10=-10*1024; confere(3,1);
        if({alert_roll,alert_pitch} !== 2'b11) $fatal(1,"Roll warning/pitch caution perdeu flags");
        roll_q10=0; pitch_q10=0; confere(0,0);
        roll_q10=-15*1024; pitch_q10=15*1024; confere(3,2);
        if({alert_roll,alert_pitch} !== 2'b11) $fatal(1,"Pitch warning/roll caution perdeu flags");
        roll_q10=0; pitch_q10=0; confere(0,0);
        roll_q10=15*1024; confere(2,1);
        roll_q10=12*1024; confere(2,1);
        roll_q10=12*1024-1; confere(0,0);
        roll_q10=-25*1024; confere(3,1);
        roll_q10=-22*1024; confere(3,1);
        roll_q10=-22*1024+1; confere(2,1);
        roll_q10=0; confere(0,0);
        pitch_q10=-10*1024; confere(2,2);
        pitch_q10=-8*1024; confere(2,2);
        pitch_q10=-8*1024+1; confere(0,0);
        pitch_q10=15*1024; confere(3,2);
        pitch_q10=12*1024; confere(3,2);
        pitch_q10=12*1024-1; confere(2,2);
        roll_q10=25*1024; confere(3,1);
        if(!alert_roll || !alert_pitch) $fatal(1,"Flags simultaneas perdidas");
        pitch_q10=0; roll_q10=32'sh80000000; confere(3,1);
        att_valid=0; attitude_alert_valid=0; confere(2,5);
        modo=0; confere(3,5);
        att_valid=1; attitude_alert_valid=1; roll_q10=0; confere(0,0);
        alt_valid=0; confere(3,5); alt_valid=1;
        modo=2; altitude_ft=100; velocidade_kt=145; confere(0,0);
        roll_q10=8*1024; confere(2,1);
        roll_q10=12*1024; confere(3,1);
        roll_q10=0; velocidade_kt=175; confere(3,3);
        velocidade_kt=170; confere(3,3);
        velocidade_kt=169; confere(2,3);
        velocidade_kt=145; vertical_fpm=-2000; confere(3,4);
        vertical_valid=0; confere(0,0);
        velocidade_kt=85; confere(3,3);
        fase_pouso=3; confere(0,0);
        fase_pouso=2; velocidade_kt=130; altitude_ft=40; confere(1,6);
        modo=0; modo_invalido=1; confere(1,7);
        modo=1; modo_invalido=0; attitude_alert_valid=1;
        pitch_q10=15*1024; confere(3,2);
        pitch_q10=0; attitude_alert_valid=0; confere(0,0);
        velocidade_kt=120; confere(2,3);
        velocidade_kt=100; confere(3,3);
        if(alert_stall !== 1'b1) $fatal(1,"STALL ausente em 100 kt");
        velocidade_kt=105; confere(3,3);
        if(alert_stall !== 1'b1) $fatal(1,"STALL perdeu histerese em 105 kt");
        velocidade_kt=106; confere(2,3);
        if(alert_stall !== 1'b0) $fatal(1,"STALL nao liberou em 106 kt");
        velocidade_kt=126; confere(0,0);
        velocidade_kt=100; confere(3,3);
        reset=1; confere(0,0);
        if(alert_stall !== 1'b0) $fatal(1,"Reset nao limpou STALL");
        $display("PASS alertas: %0d verificacoes, limiares, histerese, sinais, prioridade, sensores e pouso",checks); $finish;
    end
endmodule
