`timescale 1ns/1ps
module tb_atitude_vetorial;
    reg clk=0,reset=1,ok=1,sample=0,zero=0;
    always #5 clk=~clk;
    reg signed [15:0] ax=0,ay=0,az=16384,gx=100,gy=-50,gz=30;
    wire calibrated,valid,updated,stationary,zero_set,rejected;
    wire signed [31:0] raw_r,raw_p,r,p;
    atitude_vetorial #(.CLK_HZ(1_000_000)) dut(.clk(clk),.reset(reset),.sensor_ok(ok),.sample(sample),
        .zero_request(zero),.ax(ax),.ay(ay),.az(az),.gx(gx),.gy(gy),.gz(gz),
        .calibrated(calibrated),.valid(valid),.updated(updated),.stationary(stationary),
        .zero_set(zero_set),.zero_rejected(rejected),.raw_roll(raw_r),.raw_pitch(raw_p),.roll(r),.pitch(p),.calibration_debug());
    real bank=0,tilt=0,pi=3.141592653589793;
    integer checked=0,updates=0;
    function automatic real absolute(input real v); absolute=v<0 ? -v : v; endfunction
    function automatic real circular_error(input real a,b);
        real d; begin d=a-b;if(d>180)d-=360;if(d < -180)d+=360;circular_error=absolute(d);end
    endfunction
    always @(posedge clk) if(updated) updates++;
    task automatic measurement(input real roll_rate,pitch_rate,input bit linear_acceleration);
        begin
            // Amostra a cada 10 ms (10000 ciclos no perfil acelerado de 1 MHz).
            repeat(9900) @(negedge clk);
            ax=16'($rtoi(-16384*$sin(bank*pi/180)*$cos(tilt*pi/180)));
            ay=16'($rtoi(16384*$sin(tilt*pi/180)));
            az=16'($rtoi(16384*$cos(bank*pi/180)*$cos(tilt*pi/180)));
            if(linear_acceleration) ay=ay+16000;
            gx=16'($rtoi(pitch_rate*$cos(bank*pi/180)*131)+100);
            gy=16'($rtoi(roll_rate*131)-50);
            gz=16'($rtoi(pitch_rate*$sin(bank*pi/180)*131)+30);
            sample=1; @(negedge clk); sample=0;
            repeat(99) @(negedge clk);
        end
    endtask
    task automatic verify(input real expected_r,expected_p,tolerance);
        if(!valid || circular_error($itor(raw_r)/1024.0,expected_r)>tolerance ||
            absolute($itor(raw_p)/1024.0-expected_p)>tolerance)
            $fatal(1,"Attitude r/p=%f/%f expected=%f/%f valid=%b",$itor(raw_r)/1024.0,$itor(raw_p)/1024.0,expected_r,expected_p,valid);
        else checked++;
    endtask
    task automatic move_to(input real dest_r,dest_p,input integer steps);
        real dr,dp;
        begin
            dr=(dest_r-bank)/steps; dp=(dest_p-tilt)/steps;
            for(integer i=0;i<steps;i++) begin
                bank+=dr;tilt+=dp;measurement(dr*100,dp*100,0);
                if(valid) verify(bank,tilt,1.5);
            end
            for(integer i=0;i<20;i++) measurement(0,0,0);
            verify(dest_r,dest_p,1.0);
        end
    endtask
    initial begin
        repeat(3) @(negedge clk);reset=0;
        // Movimento impede calibracao; nenhum zero automaticamente em movimento.
        for(integer i=0;i<70;i++) measurement(20,0,0);
        if(calibrated || valid) $fatal(1,"Calibrou em movimento");
        for(integer i=0;i<68;i++) measurement(0,0,0);
        if(!calibrated) $fatal(1,"Nao calibrou parado");
        verify(0,0,0.1);
        if(dut.bias[0]!=100 || dut.bias[1]!=-50 || dut.bias[2]!=30) $fatal(1,"Bias incorreto");
        move_to(15,5,50);move_to(-15,-5,60);
        move_to(30,10,90);move_to(-30,-10,120);
        move_to(45,15,150);move_to(-45,-15,180);
        move_to(60,-10,210);move_to(-60,10,240);
        move_to(90,10,250);move_to(0,0,180);
        move_to(-90,-10,180);move_to(90,10,360);
        move_to(120,0,60);move_to(-120,0,480);
        move_to(180,0,600);move_to(-180,0,720);move_to(0,0,360);
        move_to(0,20,100);move_to(0,-20,200);move_to(0,0,100);
        // Rejeicao de aceleracao linear evidente, gyro continua propagando.
        for(integer i=0;i<10;i++) measurement(0,0,1);
        verify(0,0,1.5);
        @(negedge clk);zero=1;@(negedge clk);zero=0;
        if(!rejected) $fatal(1,"Aceitou zero durante aceleracao");
        for(integer i=0;i<80;i++) measurement(0,0,0);
        @(negedge clk);zero=1;@(negedge clk);zero=0;
        if(!zero_set || rejected) $fatal(1,"Rejeitou zero parado");
        measurement(0,0,0);
        if(absolute($itor(r)/1024)>0.1 || absolute($itor(p)/1024)>0.1) $fatal(1,"Zero incorreto");
        ok=0;repeat(3) @(negedge clk);
        if(valid || calibrated || zero_set) $fatal(1,"Sensor perdido conservou validade");
        ok=1;
        for(integer i=0;i<68;i++) measurement(0,0,0);
        verify(0,0,0.1);
        repeat(250010) @(negedge clk);
        if(valid || calibrated) $fatal(1,"Timeout de amostra nao invalidou atitude");
        $display("PASS atitude vetorial: %0d comparacoes dinamicas, %0d atualizacoes; calibracao, eixos, zero, aceleracao, falhas",checked,updates);
        $finish;
    end
    initial begin #1000000000; $fatal(1,"Timeout sensor"); end
endmodule
