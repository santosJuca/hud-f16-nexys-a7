`timescale 1ns/1ps
module tb_estado_vertical;
    logic clk=0; always #5 clk=~clk;
    logic sensor_ok=0, atitude_valida=0,dt_valid=0,baro_ok=0,baro_nova=0;
    logic signed [15:0] accel_x=0,accel_y=0,accel_z=16384;
    logic signed [31:0] pitch_q10=0,roll_q10=0;
    logic [31:0] dt_cycles=10000000;
    logic [16:0] altitude_baro_ft=10000;
    wire [16:0] altitude_ft;
    wire signed [13:0] vel_vertical_fpm;
    wire valido,altitude_disponivel,calibrado,atualizado;
    integer checks=0;
    estado_vertical #(.CAL_LOG2(2)) dut(.*);
    task automatic check(input logic ok,input string msg);
        checks++; if(!ok) $fatal(1,"%s: alt=%0d VSI=%0d valido=%b",msg,altitude_ft,vel_vertical_fpm,valido);
    endtask
    task automatic baro(input integer h);
        @(negedge clk); altitude_baro_ft=h; baro_nova=1;
        @(negedge clk); baro_nova=0;
    endtask
    task automatic tick;
        @(negedge clk); dt_valid=1;
        @(negedge clk); dt_valid=0;
        repeat(22) @(negedge clk);
    endtask
    task automatic iniciar;
        sensor_ok=0; atitude_valida=0; baro_ok=0;
        repeat(3) @(negedge clk);
        sensor_ok=1; atitude_valida=1; baro_ok=1;
        accel_x=0; accel_y=0; accel_z=16384; pitch_q10=0;roll_q10=0;
        baro(10000);
        repeat(5) tick();
        check(valido && calibrado,"calibracao repouso");
    endtask
    integer antes,vantes;
    initial begin
        repeat(3) @(negedge clk);
        check(!valido && !altitude_disponivel,"sem referencia nao inventa altitude");
        iniciar();
        repeat(100) tick();
        check(altitude_ft==10000 && vel_vertical_fpm==0,"repouso e remocao gravidade");
        antes=dut.altitude_q8; repeat(30) @(negedge clk);
        check(dut.altitude_q8==antes && !atualizado,"sem dt retencao");
        dt_cycles=0; tick(); check(dut.altitude_q8==antes,"dt zero bloqueado");
        dt_cycles=32'hffffffff; tick(); check(dut.altitude_q8==antes,"dt excessivo bloqueado"); dt_cycles=10000000;
        // Gravidade inclinada, sem aceleracao linear.
        pitch_q10=30720; accel_y=8192; accel_z=14189;
        repeat(20) tick(); check(vel_vertical_fpm==0,"gravidade removida com pitch");
        pitch_q10=0;roll_q10=-30720;accel_x=8192;accel_y=0;
        repeat(20) tick(); check(vel_vertical_fpm==0,"gravidade removida com roll");
        roll_q10=0;accel_x=0;accel_z=18022;
        repeat(10) tick();
        check(vel_vertical_fpm>150 && vel_vertical_fpm<210 && altitude_ft>10000,"+0,1g por 1s: VSI proximo 193fpm");
        accel_z=16384; repeat(1000) tick();
        check(altitude_ft>=9999 && altitude_ft<=10001 && vel_vertical_fpm>=-2 && vel_vertical_fpm<=2,"barometro elimina drift e retorno ao repouso");
        accel_z=14746; repeat(10) tick();
        check(vel_vertical_fpm< -150 && vel_vertical_fpm> -210 && altitude_ft<10000,"aceleracao negativa e descida");
        accel_z=16384; baro(10100); antes=altitude_ft; tick();
        check(altitude_ft<antes+5,"correcao barometrica sem salto grande");
        repeat(2000) tick();
        check(altitude_ft>=10099 && altitude_ft<=10101 && vel_vertical_fpm>=-2 && vel_vertical_fpm<=2,"convergencia subida barometrica");
        baro(10000); repeat(2000) tick();
        check(altitude_ft>=9999 && altitude_ft<=10001,"convergencia descida barometrica");
        baro_ok=0; antes=altitude_ft; accel_z=32767; repeat(10) tick();
        check(!valido && altitude_ft==antes && vel_vertical_fpm==0,"baro invalido: retencao e VSI invalido");
        iniciar(); sensor_ok=0; antes=altitude_ft; repeat(10) tick();
        check(!valido && altitude_ft==antes && vel_vertical_fpm==0,"MPU invalido sem integracao");
        baro(10016); repeat(3) @(negedge clk);
        check(altitude_ft>=antes && altitude_ft<=antes+2,"baro sozinho filtrado");
        iniciar(); pitch_q10=31744; tick(); check(!valido,"fora da faixa invalida");
        iniciar();
        // Referencia acompanha a altitude: exercita o limitador sem servo contrario.
        accel_z=32767;
        repeat(100) begin baro(altitude_ft); tick(); end
        check(vel_vertical_fpm==6000,"saturacao positiva VSI");
        accel_z=-32768;
        repeat(100) begin baro(altitude_ft); tick(); end
        check(vel_vertical_fpm==-6000,"saturacao negativa VSI");
        check(altitude_ft<99999 && !$isunknown(altitude_ft),"extremos sem overflow");
        // Interrompe pipeline antes de publicar uma amostra.
        antes=altitude_ft; @(negedge clk); dt_valid=1;
        @(negedge clk); dt_valid=0; sensor_ok=0;
        repeat(30) @(negedge clk); check(altitude_ft==antes && !atualizado,"cancelamento de pipeline");
        // Bias Z positivo deve ser absorvido, sem movimento.
        iniciar(); sensor_ok=0; repeat(3) @(negedge clk); sensor_ok=1; accel_z=16500;
        repeat(2000) tick(); check(valido && vel_vertical_fpm>=-2 && vel_vertical_fpm<=2,"bias Z removido em repouso");
        force dut.altitude_q8=32'sd25599700; @(negedge clk); release dut.altitude_q8;
        baro(99999); accel_z=32767; repeat(10) tick();
        check(altitude_ft==99999 && vel_vertical_fpm==0,"limite superior altitude sem overflow");
        force dut.altitude_q8=32'sd1; @(negedge clk); release dut.altitude_q8;
        baro(0); accel_z=-32768; repeat(10) tick();
        check(altitude_ft==0 && vel_vertical_fpm==0,"limite inferior altitude sem overflow");
        $display("PASS estado_vertical: %0d verificacoes",checks); $finish;
    end
    initial begin #10000000; $fatal(1,"timeout vertical"); end
endmodule
