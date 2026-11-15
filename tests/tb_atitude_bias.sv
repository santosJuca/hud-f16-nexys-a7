`timescale 1ns/1ps
module tb_atitude_bias;
    reg clk=0,reset=1,ok=1,sample=0,zero=0;
    always #5 clk=~clk;
    reg signed [15:0] ax=-640,ay=-1152,az=16512,gx=-384,gy=1152,gz=-128;
    wire calibrated,valid,stationary,zero_set,rejected;
    wire signed [31:0] roll,pitch;
    wire [25:0] debug_status;
    atitude_vetorial #(.CLK_HZ(1_000_000)) dut(.clk(clk),.reset(reset),.sensor_ok(ok),
        .sample(sample),.zero_request(zero),.ax(ax),.ay(ay),.az(az),.gx(gx),.gy(gy),.gz(gz),
        .calibrated(calibrated),.valid(valid),.updated(),.stationary(stationary),
        .zero_set(zero_set),.zero_rejected(rejected),.raw_roll(),.raw_pitch(),.roll(roll),.pitch(pitch),
        .calibration_debug(debug_status));
    task automatic measurement;
        repeat(9900) @(negedge clk);
        sample=1;@(negedge clk);sample=0;
        repeat(99) @(negedge clk);
    endtask
    task automatic restart;
        reset=1;repeat(3) @(negedge clk);reset=0;
        ax=-640;ay=-1152;az=16512;gx=-384;gy=1152;gz=-128;
    endtask
    initial begin
        restart();
        // Valores sinteticos dentro dos intervalos parciais informados na bancada.
        // Extremos alternados verificam media e estabilidade sem presumir os bytes ausentes.
        for(integer i=0;i<68;i++) begin
            gx=i[0] ? -257 : -512;
            gy=i[0] ? 1279 : 1024;
            gz=i[0] ? -1 : -256;
            measurement();
            if(i<64 && calibrated) $fatal(1,"Calibracao terminou antes de 64 amostras estaveis");
        end
        if(!calibrated || !valid || !stationary)
            $fatal(1,"Offset de repouso observado impede calibracao: cal=%b valid=%b stationary=%b",calibrated,valid,stationary);
        if(debug_status!=0) $fatal(1,"Bloqueios anteriores nao limpos apos calibracao");
        if(dut.bias[0]!=-385 || dut.bias[1]!=1151 || dut.bias[2]!=-129)
            $fatal(1,"Media do offset incorreta: %0d/%0d/%0d",dut.bias[0],dut.bias[1],dut.bias[2]);
        if(roll < -512 || roll>512 || pitch < -512 || pitch>512)
            $fatal(1,"Repouso com offset produziu atitude fora de meio grau");
        @(negedge clk);zero=1;@(negedge clk);zero=0;
        if(!zero_set || rejected) $fatal(1,"Zero em repouso valido recusado");
        // O limite de repouso depois da calibracao continua sendo 131 counts corrigidos.
        gx=-385;gy=1351;gz=-129;measurement();
        if(stationary) $fatal(1,"Movimento acima de 131 counts corrigidos aceito como repouso");
        @(negedge clk);zero=1;@(negedge clk);zero=0;
        if(!rejected) $fatal(1,"Zero em movimento foi aceito");
        ok=0;repeat(3) @(negedge clk);
        if(!debug_status[12]) $fatal(1,"Perda de sensor nao registrada");
        ok=1;
        $display("PASS offset observado: media dos tres eixos, nivel, validade e zero condicionado");

        // Bias de aproximadamente 10,05 graus/s em repouso.
        restart();gy=1316;
        repeat(80) measurement();
        if(!calibrated || !valid || !stationary)
            $fatal(1,"Bias 1316 em repouso nao calibrou");
        if(dut.bias[1]!=1316)
            $fatal(1,"Bias estimado incorretamente");

        // Acima de 12 graus/s continua proibido.
        restart();gy=1573;
        repeat(80) measurement();
        if(calibrated || valid) $fatal(1,"Offset fora do limite inicial foi aceito");
        if(!debug_status[4]) $fatal(1,"Causa do limite GY ausente");
        restart();
        for(integer i=0;i<80;i++) begin gy=i[0] ? 1279 : 512;measurement();end
        if(calibrated || valid) $fatal(1,"Variacao excessiva do giroscopio foi aceita");
        if(!debug_status[7]) $fatal(1,"Causa da faixa GY ausente");
        restart();
        for(integer i=0;i<80;i++) begin gy=16'(512+i*8);measurement();end
        if(calibrated || valid) $fatal(1,"Rampa lenta passou pela janela de estabilidade");
        if(!debug_status[7]) $fatal(1,"Causa da rampa GY ausente");
        $display("PASS rejeicao: offset excessivo, variacao e rampa acumulada na janela");

        restart();
        for(integer i=0;i<80;i++) begin ax=i[0] ? -384 : -640;measurement();end
        if(calibrated || valid) $fatal(1,"Movimento no acelerometro foi aceito");
        if(!debug_status[0]) $fatal(1,"Causa de instabilidade AX ausente");
        restart();ay=2000;repeat(80) measurement();
        if(calibrated || valid) $fatal(1,"Pose fora do nivel foi aceita");
        if(!debug_status[10]) $fatal(1,"Causa de nivel AY ausente");
        restart();az=-16384;repeat(80) measurement();
        if(calibrated || valid) $fatal(1,"Sensor invertido foi aceito");
        if(!debug_status[11]) $fatal(1,"Causa de nivel AZ ausente");
        $display("PASS rejeicao: aceleracao instavel, pose inclinada e sensor invertido");
        $finish;
    end
    initial begin #100000000; $fatal(1,"Timeout do teste de bias"); end
endmodule
