`timescale 1ns/1ps
module tb_alertas_voo;
    logic clk=0; always #5 clk=~clk;
    logic reset=1; logic [1:0] modo=1; logic modo_invalido=0;
    logic [2:0] fase_pouso=0;
    logic signed [31:0] roll_q10=0,pitch_q10=0;
    logic [9:0] velocidade_kt=280; logic [16:0] altitude_ft=36000;
    logic signed [13:0] vertical_fpm=0;
    logic att_valid=1,alt_valid=1,heading_valid=1,vertical_valid=1;
    wire [1:0] severity; wire [2:0] causa;
    wire alert_roll,alert_pitch,alert_speed,alert_altitude,alert_sink,alert_sensor;
    integer checks=0;
    alertas_voo dut(.*);
    task automatic confere(input integer sev, code);
        repeat(2) @(negedge clk); checks++;
        if(severity!=sev || causa!=code) $fatal(1,"Roll=%0d pitch=%0d: obtido=%0d/%0d esperado=%0d/%0d",roll_q10,pitch_q10,severity,causa,sev,code);
    endtask
    initial begin
        @(negedge clk); reset=0; confere(0,0);
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
        pitch_q10=13*1024; confere(3,2);
        pitch_q10=13*1024-1; confere(2,2);
        roll_q10=25*1024; confere(3,1);
        if(!alert_roll || !alert_pitch) $fatal(1,"Flags simultaneas perdidas");
        pitch_q10=0; roll_q10=32'sh80000000; confere(3,1);
        att_valid=0; confere(2,5);
        modo=0; confere(3,5);
        att_valid=1; roll_q10=0; confere(0,0);
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
        reset=1; confere(0,0);
        $display("PASS alertas: %0d verificacoes, limiares, histerese, sinais, prioridade, sensores e pouso",checks); $finish;
    end
endmodule
