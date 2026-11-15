`timescale 1ns/1ps
module tb_heading_fusao;
    logic clk=0; always #5 clk=~clk;
    logic sensor_ok=0, amostra_nova=0, dt_valid=0, mag_valido=0, mag_atualizado=0;
    logic signed [15:0] gyro_z=0;
    logic [31:0] dt_cycles=1000000;
    logic [8:0] heading_mag=0;
    wire [8:0] heading_deg;
    wire valido, atualizado;
    integer checks=0, updates=0;
    always @(posedge clk) if(atualizado) updates++;
    heading_fusao #(.CAL_LOG2(2),.MAG_TIMEOUT(10000)) dut(.*);
    task automatic check(input logic ok,input string msg);
        checks++; if(!ok) $fatal(1,"%s: heading=%0d estado_Q10=%0d",msg,heading_deg,dut.estado_q10);
    endtask
    task automatic tick;
        @(negedge clk); dt_valid=1; mag_atualizado=1;
        @(negedge clk); dt_valid=0; mag_atualizado=0;
        repeat(12) @(negedge clk);
    endtask
    task automatic iniciar(input integer h);
        sensor_ok=0; mag_valido=0; gyro_z=100;
        repeat(3) @(negedge clk);
        sensor_ok=1; mag_valido=1; heading_mag=h;
        repeat(4) begin
            amostra_nova=1; @(negedge clk); amostra_nova=0; @(negedge clk);
        end
        tick(); tick();
        check(valido && heading_deg==h,"inicializacao e bias Z");
    endtask
    integer anterior, antes_updates;
    initial begin
        repeat(3) @(negedge clk); check(!valido,"inicial invalido");
        iniciar(90);
        repeat(10) tick(); check(heading_deg==90,"gyro corrigido zero");
        gyro_z=-13000; tick(); check(heading_deg>=90 && dut.estado_q10>92160,"integracao positiva");
        anterior=dut.estado_q10; gyro_z=13200; tick(); check(dut.estado_q10<anterior,"integracao negativa");
        gyro_z=100; heading_mag=180; anterior=dut.estado_q10; tick();
        check(dut.estado_q10>anterior && heading_deg<180,"correcao gradual");
        anterior=dut.estado_q10; repeat(25) @(negedge clk);
        check(dut.estado_q10==anterior && !atualizado,"sem dt nao atualiza");
        dt_cycles=0; tick(); check(dut.estado_q10==anterior,"dt zero rejeitado");
        dt_cycles=32'hffffffff; tick(); check(dut.estado_q10==anterior,"dt excessivo rejeitado");
        dt_cycles=1000000;
        iniciar(359); heading_mag=1; tick();
        check(dut.estado_q10>359*1024 && dut.estado_q10<360*1024,"erro +2 cruzando norte");
        gyro_z=-26100; tick(); check(heading_deg<4,"wrap 359 para 0");
        iniciar(1); heading_mag=359; tick();
        check(dut.estado_q10<1024 && dut.estado_q10>0,"erro -2 cruzando norte");
        gyro_z=26300; tick(); check(heading_deg>356,"wrap 0 para 359");
        anterior=heading_deg; mag_valido=0; tick();
        check(!valido && heading_deg==anterior,"mag invalido retencao");
        mag_valido=1; heading_mag=200; gyro_z=100; tick(); tick();
        check(valido && heading_deg==200,"recuperacao mag");
        sensor_ok=0; tick(); check(!valido && heading_deg==200,"MPU invalido retencao");
        iniciar(45);
        repeat(10010) @(negedge clk); check(!valido,"referencia magnetica expirada");
        tick(); tick(); check(valido && heading_deg==45,"recuperacao referencia expirada");
        antes_updates=updates; tick();
        check(updates==antes_updates+1,"dt de um ciclo publica exatamente uma vez");
        repeat(30) @(negedge clk);
        check(updates==antes_updates+1,"sem publicacao duplicada");
        sensor_ok=0; repeat(3) @(negedge clk); sensor_ok=1; gyro_z=32767;
        repeat(4) begin amostra_nova=1; @(negedge clk); amostra_nova=0; @(negedge clk); end
        heading_mag=0; dt_cycles=10000000; tick(); tick();
        gyro_z=-32768; tick();
        check(heading_deg>=48 && heading_deg<=49,"bias e gyro extremos: 50 graus menos correcao");
        repeat(100) begin tick(); check(heading_deg<360,"wrap sob integracao maxima"); end
        $display("PASS heading_fusao: %0d verificacoes",checks); $finish;
    end
    initial begin #2000000; $fatal(1,"timeout heading"); end
endmodule
