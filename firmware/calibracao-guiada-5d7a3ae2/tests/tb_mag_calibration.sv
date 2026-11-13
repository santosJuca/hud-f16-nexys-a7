`timescale 1ns/1ps
module tb_mag_calibration;
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
    string name,path;integer postfault=0;integer accept,expect_ox,expect_oy,expect_gx,expect_gy;
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
    initial begin
        if(!$value$plusargs("CASE=%s",name) || !$value$plusargs("DIR=%s",path))$fatal(1,"args");
        if(!$value$plusargs("ACCEPT=%d",accept))$fatal(1,"ACCEPT");
        if($value$plusargs("OX=%d",expect_ox))begin end
        if($value$plusargs("OY=%d",expect_oy))begin end
        if($value$plusargs("GX=%d",expect_gx))begin end
        if($value$plusargs("GY=%d",expect_gy))begin end
        $readmemh({path,"/",name,"-train.hex"},train);$readmemh({path,"/",name,"-holdout.hex"},holdout);
        $readmemh({path,"/",name,"-corrected.hex"},corrected);$readmemh({path,"/",name,"-heading.hex"},expected_heading);
        tick(3);reset=0;tick(3);
        if(active || state!=0 || ox!=67 || oy!=-181 || gx!=3923 || gy!=4004)$fatal(1,"Boot alterou perfil aprovado");
        send(train[0]);command(0);if(state!=1)$fatal(1,"Nao entrou CHECK");command(1);
        for(integer i=0;i<72;i++)send(train[i]);
        if(active)$fatal(1,"Aplicacao antes da avaliacao");
        command(1);tick(60);
        if(state==4)begin
            for(integer i=0;i<72;i++)send(holdout[i]);
            command(1);tick(8);
        end
        if(accept!=0)begin
            if(state!=5)$fatal(1,"Candidato valido rejeitado state=%0d reason=%0d n=%0d cov=%h",state,reason,count,coverage);
            if(active || ox!=67 || oy!=-181)$fatal(1,"Candidato publicou cedo");
            if($value$plusargs("POSTFAULT=%d",postfault))begin
                if(postfault==1)begin
                    @(negedge clk);next_step=1;sample=1;mx=-4096;my=0;mz=300;
                    @(negedge clk);next_step=0;sample=0;tick(10);
                end else if(postfault==2)begin command(1);send({16'sd1800,16'sd1600,16'sd300});end
                else if(postfault==3)tick(1002);
                if(active || state!=8 || ox!=67 || oy!=-181)$fatal(1,"Falha durante confirmacao aplicou candidato");
                $display("PASS candidato: falha %0d na confirmacao nunca aplica perfil",postfault);$finish;
            end

            if(cox!=expect_ox || coy!=expect_oy || cgx!=expect_gx || cgy!=expect_gy)$fatal(1,"Divergencia Python/RTL parametros got=%0d,%0d,%0d,%0d exp=%0d,%0d,%0d,%0d",cox,coy,cgx,cgy,expect_ox,expect_oy,expect_gx,expect_gy);
            command(1);send(holdout[0]);if(!active || state!=0)$fatal(1,"Aplicacao falhou");
            for(integer i=0;i<72;i++)begin
                send(holdout[i]);
                if({cx,cy}!==corrected[i])$fatal(1,"Q12 Python/RTL i=%0d",i);
                if(!heading_valid || (heading!=expected_heading[i] && heading!=(expected_heading[i]+1)%360 && heading!=(expected_heading[i]+359)%360))
                    $fatal(1,"Heading atan2 i=%0d got=%0d exp=%0d",i,heading,expected_heading[i]);
            end
            if(name=="diagonal")begin
                // Segunda sessao: o perfil ativo permanece em uso e pode ser recuperado.
                $readmemh({path,"/hard_iron-train.hex"},train);$readmemh({path,"/hard_iron-holdout.hex"},holdout);
                command(0);command(1);
                for(integer i=0;i<72;i++)send(train[i]);command(1);tick(60);
                for(integer i=0;i<72;i++)begin
                    send(holdout[i]);
                    if(dut.pipe!=0)$fatal(1,"Pipeline nao terminou");
                end
                command(1);tick(8);if(state!=5)$fatal(1,"Segunda sessao nao aceitou %0d/%0d",state,reason);
                command(1);send(holdout[0]);if(!active || ox!=300 || oy!=-200)$fatal(1,"Segundo perfil");
                command(3);if(!active || ox!=expect_ox || oy!=expect_oy || gx!=expect_gx || gy!=expect_gy)$fatal(1,"Backup do perfil 2D anterior");
            end
            send({16'sd1800,16'sd1600,16'sd300});if(healthy || !suspect || heading_valid)$fatal(1,"Interferencia nao invalidou heading");
            command(3);if(active || ox!=67 || oy!=-181 || gx!=3923 || gy!=4004)$fatal(1,"Recuperacao falhou");
        end else begin
            if(state!=8 || active || ox!=67 || oy!=-181)$fatal(1,"Candidato incorreto nao rejeitado s=%0d reason=%0d",state,reason);
            command(1);if(active)$fatal(1,"NEXT aplicou candidato rejeitado");
        end
        command(2);if(state!=0)$fatal(1,"Cancelar");
        $display("PASS %s; aceite/rejeicao, perfil separado, referencia Python, recuperacao",name);$finish;
    end
    initial begin #1000000;$fatal(1,"Timeout TB");end
endmodule
