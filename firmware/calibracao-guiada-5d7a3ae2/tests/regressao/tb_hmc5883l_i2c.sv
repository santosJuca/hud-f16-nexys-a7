`timescale 1ns/1ps
`include "tests/hmc5883l_slave.svh"
module tb_hmc5883l_i2c;
    logic clk = 0;
    always #5 clk = ~clk;
    tri1 sda,scl;
    wire ok,nova;
    wire signed [15:0] x,y,z;
    wire [31:0] diagnostics;
    hmc5883l_i2c #(.STARTUP_TICKS(16'd4),.POLL_TICKS(16'd8),.CONFIG_WAIT(16'd4)) dut(
        .clk(clk),.mag_sda(sda),.mag_scl(scl),.sensor_ok(ok),
        .amostra_nova(nova),.mag_x(x),.mag_y(y),.mag_z(z),.diagnostico(diagnostics));
    hmc5883l_slave slave(sda,scl);
    integer publications=0, last_stop=0;
    logic last_nova=0;
    logic [47:0] last_sample=0;
    always @(posedge clk) begin
        #1;
        if (nova && last_nova) $fatal(1,"amostra_nova excedeu um ciclo");
        if ({x,y,z} !== last_sample && !nova) $fatal(1,"publicacao parcial/sem pulso");
        if (nova) begin
            if (slave.ativo || !ok || sda !== 1 || scl !== 1 || slave.stops <= last_stop)
                $fatal(1,"amostra publicada sem STOP valido");
            publications=publications+1;
            last_stop=slave.stops;
        end
        last_nova=nova; last_sample={x,y,z};
    end
    task automatic settle;
        repeat(800) @(negedge clk);
    endtask
    task automatic check_sample(input integer ex,ey,ez,count);
        if ($signed(x) !== ex || $signed(y) !== ey || $signed(z) !== ez || publications!=count)
            $fatal(1,"XYZ=%0d/%0d/%0d pulsos=%0d esperado=%0d/%0d/%0d pulsos=%0d",x,y,z,publications,ex,ey,ez,count);
    endtask
    initial begin
        // Ausente em duas tentativas, depois ID incorreto.
        repeat(2) begin
            slave.start(); slave.receive(8'h3c); slave.ack(0); slave.stop(); settle();
            if(ok || publications) $fatal(1,"NACK de endereco aceito");
            if(diagnostics[3:2]!==2'd1) $fatal(1,"NACK ausente no diagnostico");
            if(diagnostics[7:6]!==2'd0) $fatal(1,"Etapa NACK endereco W incorreta");
        end
        slave.start();slave.receive(8'h3c);slave.ack(1);
        slave.receive(8'h0a);slave.ack(0);slave.stop();settle();
        if(diagnostics[7:6]!==2'd1 || diagnostics[3:2]!==2'd1)
            $fatal(1,"Etapa NACK registrador incorreta");
        slave.identify(8'h32); settle();
        if(ok || publications) $fatal(1,"ID incorreto aceito");
        if(diagnostics[31:8]!==24'h483432 || !diagnostics[4] || diagnostics[5] || diagnostics[3:2]!=0)
            $fatal(1,"ID incorreto nao registrado no diagnostico: %h",diagnostics);
        $display("PASS HMC: ausencia, novas tentativas e ID incorreto");
        slave.configure(); settle();
        if(!ok || publications) $fatal(1,"configuracao/ID H43 falhou");
        if(diagnostics!==32'h48343333) $fatal(1,"Diagnostico H43/OK/barramento errado: %h",diagnostics);
        slave.sample(16'h1234,16'hfedc,16'h8001,1); settle();
        check_sample(4660,-292,-32767,1);
        $display("PASS HMC: H43, writes, repeated START, stretching, XYZ, ACK/NACK e STOP atomico");
        // NACK do endereco R na operacao de dados.
        slave.start(); slave.receive(8'h3c); slave.ack(1);
        slave.receive(8'h03); slave.ack(1);
        slave.start(); slave.receive(8'h3d); slave.ack(0); slave.stop(); settle();
        if(ok) $fatal(1,"NACK de dados nao invalidou sensor");
        if(diagnostics[7:6]!==2'd3) $fatal(1,"Etapa NACK endereco R incorreta");
        check_sample(4660,-292,-32767,1);
        slave.configure();
        slave.sample(16'd100,16'd200,16'd300,0); settle();
        check_sample(100,200,300,2);
        $display("PASS HMC: NACK em dados preserva amostra e exige reidentificacao");
        // SDA presa impede STOP; timeout preserva a ultima amostra.
        slave.read_begin(8'h03,0); slave.data_bytes(16'd9,16'd8,16'd7);
        #100; slave.sda_low=1;
        #10_100_000;
        if(ok) $fatal(1,"SDA presa nao invalidou sensor");
        if(diagnostics[3:2]!==2'd2 || diagnostics[0]!==1'b0)
            $fatal(1,"Timeout/SDA presa ausente no diagnostico");
        check_sample(100,200,300,2);
        slave.sda_low=0;
        slave.configure(); slave.sample(16'd400,16'd500,16'd600,0); settle();
        check_sample(400,500,600,3);
        $display("PASS HMC: SDA presa no STOP, timeout e recuperacao");
        // SCL presa durante uma transacao.
        slave.start(); @(negedge scl); slave.scl_low=1;
        #10_100_000;
        if(ok) $fatal(1,"SCL presa nao invalidou sensor");
        if(diagnostics[3:2]!==2'd2 || diagnostics[1]!==1'b0)
            $fatal(1,"Timeout/SCL presa ausente no diagnostico");
        check_sample(400,500,600,3);
        slave.scl_low=0;
        slave.configure(); slave.sample(-16'd1000,16'd1000,16'd0,0); settle();
        check_sample(-1000,1000,0,4);
        $display("PASS HMC: SCL presa, timeout e recuperacao; todos os testes passaram");
        $finish;
    end
    initial begin #50_000_000; $fatal(1,"timeout global HMC"); end
endmodule
