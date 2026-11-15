`timescale 1ns/1ps
module tb_mag_faults;
    reg clk=0;always #5 clk=~clk;
    reg reset=1,start=0,next_step=0,cancel=0,recover=0,sensor_ok=1,sample=0,level=1;
    reg signed [15:0] mx=0,my=0,mz=300;
    wire [3:0] state,reason;
    wire active,healthy,changed,suspect,corrected_sample;
    wire signed [15:0] ox,oy,cx,cy,cox,coy;
    wire [13:0] gx,gy,cgx,cgy;
    wire [15:0] count,duplicates,invalid_samples;
    wire [7:0] coverage;
    mag_calibration_2d #(.STALE_CYCLES(1000),.PHASE_CYCLES(20000),.REPEAT_LIMIT(80)) dut(
        .clk(clk),.reset(reset),.start(start),.next_step(next_step),.cancel(cancel),.recover(recover),
        .sensor_ok(sensor_ok),.sample(sample),.level(level),.mx(mx),.my(my),.mz(mz),
        .state(state),.reason(reason),.active(active),.profile_changed(changed),.healthy(healthy),.suspect(suspect),
        .offset_x(ox),.offset_y(oy),.gain_x(gx),.gain_y(gy),.samples(count),.duplicates(duplicates),.invalid_samples(invalid_samples),.coverage(coverage),
        .min_x(),.max_x(),.min_y(),.max_y(),.min_z(),.max_z(),.candidate_x(cox),.candidate_y(coy),.candidate_gx(cgx),.candidate_gy(cgy),
        .corrected_sample(corrected_sample),.corrected_x(cx),.corrected_y(cy));
    wire [8:0] heading;wire heading_valid,heading_updated;
    heading_magnetico #(.INVERTER_X(1),.INVERTER_Y(1),.ALINHAMENTO_GRAUS(81)) heading_core(
        .clk(clk),.sensor_ok(active && healthy && !changed),.amostra_nova(corrected_sample),.mag_x(cx),.mag_y(cy),
        .heading_deg(heading),.valido(heading_valid),.atualizado(heading_updated));
    reg [47:0] train[0:71],holdout[0:71];reg [31:0] corrected[0:71];reg [8:0] expected_heading[0:71];
    string name,path;integer accept,expect_ox,expect_oy,expect_gx,expect_gy;
    task tick(input integer n);repeat(n)@(negedge clk);endtask
    task command(input integer which);
        begin
            @(negedge clk);case(which)0:start=1;1:next_step=1;2:cancel=1;3:recover=1;endcase
            @(negedge clk);start=0;next_step=0;cancel=0;recover=0;tick(3);
        end
    endtask
    task send(input [47:0] vector);
        begin @(negedge clk);{mx,my,mz}=vector;sample=1;@(negedge clk);sample=0;tick(38);end
    endtask
    task init_session;
        begin reset=1;sample=0;sensor_ok=1;level=1;tick(3);reset=0;tick(3);send({16'sd400,-16'sd100,16'sd300});end
    endtask
    task collecting;
        begin init_session();command(0);command(1);if(state!=2)$fatal(1,"COLLECT");end
    endtask
    initial begin
        init_session();if(!healthy || active)$fatal(1,"Inicializacao");tick(1002);if(healthy)$fatal(1,"Heading obsoleto valido");
        init_session();sensor_ok=0;command(0);command(1);if(state!=8 || reason!=1)$fatal(1,"Sensor ausente");
        collecting();sensor_ok=0;tick(4);if(state!=8 || reason!=1)$fatal(1,"Perda comunicacao");
        collecting();tick(1002);if(state!=8 || reason!=2)$fatal(1,"Perda amostras");
        collecting();level=0;tick(4);if(state!=8 || reason!=4 || active)$fatal(1,"Nivel");
        for(integer axis=0;axis<3;axis++)begin
            collecting();case(axis)
              0:send({-16'sd4096,16'sd10,16'sd300});
              1:send({16'sd10,-16'sd4096,16'sd300});
              2:send({16'sd10,16'sd10,-16'sd4096});
            endcase
            if(healthy || state!=8 || reason!=3 || invalid_samples==0)$fatal(1,"Overflow");
        end
        collecting();send({16'sd2048,16'sd10,16'sd300});if(state!=8 || reason!=3)$fatal(1,"Fora da faixa ADC");
        collecting();for(integer i=0;i<83;i++)send({16'sd400,-16'sd100,16'sd300});
        if(healthy || state!=8 || duplicates==0)$fatal(1,"Repeticoes");
        init_session();command(0);for(integer i=0;i<21000;i++)begin
            if(i%100==0)begin @(negedge clk);sample=1;mx=mx+1;end
            else begin @(negedge clk);sample=0;end
        end
        if(state!=8 || reason!=9)$fatal(1,"Timeout da fase");
        collecting();command(2);if(state!=0 || active || ox!=67)$fatal(1,"Cancelar mudou perfil");
        command(3);if(active || ox!=67 || oy!=-181)$fatal(1,"Recuperacao sem candidato");
        $display("PASS falhas: ausente, NACK/sensor_ok, stale, nivel, overflow XYZ, faixa ADC, repeticao, timeout, cancelar");$finish;
    end
endmodule
