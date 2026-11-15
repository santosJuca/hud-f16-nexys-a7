`timescale 1ns/1ps
module tb_mvp_v11_entrega;
    logic clk=0;
    always #5 clk=~clk;
    logic [1:0] operation=0,buttons=0;
    logic display_mode=0,style_mode=0;
    // SW9/10/11 desabilitam fontes reais; demais bits comandam pitch/roll.
    logic [15:9] sw=7'b0000111;
    tri1 sda,scl,bsda,bscl,msda,mscl;
    wire [3:0] r,g,b;
    wire hs,vs;
    top_reticula #(
        `include "mvp_profile.svh"
    ) dut (
        .clk(clk),.operacao_sw(operation),.ack_btn(1'b0),.btn_heading(buttons),
        .sw(sw),.display_mode(display_mode),.style_mode(style_mode),
        .vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),
        .joystick_sw_n(1'b1),.i2c_sda(sda),.i2c_scl(scl),
        .baro_sda(bsda),.baro_scl(bscl),.mag_sda(msda),.mag_scl(mscl),
        .VIDEO_TOGGLE_BUTTON(1'b0),.SD_DIAG_PAGE(4'd0),
        .SD_READ_SWITCH(1'b0),.SD_DAT0(1'b1),.SD_CD(1'b1),
        .VGA_R(r),.VGA_G(g),.VGA_B(b),.VGA_HS(hs),.VGA_VS(vs));

    wire [9:0] x=dut.pixel_x,y=dut.pixel_y;
    wire active=dut.video_on;
    wire [11:0] rgb={r,g,b};
    wire [511:0] visual_state={dut.attitude_display,dut.hud_metadados,
        dut.velocidade_kt,dut.altitude_ft,dut.horizonte_y,dut.roll_q8,
        dut.heading_deg,dut.declutter,dut.estilo_caca,dut.alvo_x,dut.alvo_y,
        dut.mira_x,dut.mira_y,dut.mira_lock};
    logic [511:0] previous_visual;
    logic extra_only,expected_declutter,expected_style;
    integer csv,summary,ppm,ex=0,ey=0;
    integer ac,hc,vc,ret_count,hor_count,extra_count,overlay_count,mira_count;
    integer overlap_count,total_overlap=0,publications=0;
    time last_pixel;

    initial begin
        csv=$fopen("pipeline.csv","w");summary=$fopen("quadros.csv","w");
        if(!csv || !summary) $fatal(1,"Arquivos de evidencia indisponiveis");
        $fwrite(csv,"time_ns,frame,x,y,active,reticle,horizon,overlay,mira,rgb,hs,vs,declutter,style,operation,heading,manual_heading,horizon_y,roll,metadata\n");
        $fwrite(summary,"frame,declutter,style,operation,heading,manual_heading,horizon_y,active,hs_low,vs_low,reticle,horizon,extra_only,overlay,mira,mira_over_reticle\n");
        wait(y==480);wait(y==0 && x==0);
        previous_visual=visual_state;
        last_pixel=$time;
        for(integer frame=0;frame<20;frame++) begin
            ac=0;hc=0;vc=0;ret_count=0;hor_count=0;extra_count=0;
            overlay_count=0;mira_count=0;overlap_count=0;ppm=0;
            expected_declutter=(frame==1 || frame==4 || frame==12);
            expected_style=(frame==3 || frame==4 || frame==11 || frame==12);
            if(frame==0 || frame==1 || frame==3 || frame==4 || frame==7 || frame==16) begin
                ppm=$fopen($sformatf("quadro-%0d.ppm",frame),"wb");
                if(!ppm) $fatal(1,"Nao abriu quadro");
                $fwrite(ppm,"P6\n640 480\n255\n");
            end
            for(integer n=0;n<420000;n++) begin
                #1;
                if(x!=ex || y!=ey || active !== (ex<640 && ey<480))
                    $fatal(1,"Raster frame=%0d x=%0d y=%0d esperado=%0d,%0d",frame,x,y,ex,ey);
                if(hs !== !(ex>=656 && ex<752) || vs !== !(ey>=490 && ey<492))
                    $fatal(1,"Sincronismo frame=%0d x=%0d y=%0d",frame,x,y);
                // Os contadores ja avancaram por NBA: a publicacao ocorre apos x=0,y=480.
                if(visual_state!==previous_visual) begin
                    if(x!=1 || y!=480) $fatal(1,"Dados visuais mudaram fora da fronteira de quadro: %0d,%0d",x,y);
                    publications++;
                end
                previous_visual=visual_state;
                if(active) begin
                    ac++;
                    if(dut.declutter!==expected_declutter || dut.estilo_caca!==expected_style)
                        $fatal(1,"Modo grafico frame=%0d declutter=%b estilo=%b",frame,dut.declutter,dut.estilo_caca);
                    // ALT valido em VOO/POUSO identifica o simulador, nao um barometro ativo.
                    if(dut.hud_metadados[5] || dut.hud_metadados[3] || dut.usar_mpu ||
                       dut.atitude_mpu_habilitada || dut.magnetometro_habilitado || dut.barometro_habilitado)
                        $fatal(1,"Cenario deve usar fontes manuais, sem sensores reais");
                    if(dut.align_status_on || dut.capture_status_on || dut.calibration_on)
                        $fatal(1,"Captura/ALIGN inesperados");
                    // Verifique a prioridade; reticulo verde so e obrigatorio sem camadas superiores.
                    if(dut.overlay_on) begin
                        overlay_count++;
                        if(rgb!==dut.overlay_rgb) $fatal(1,"Prioridade overlay");
                    end else if(dut.mira_on) begin
                        mira_count++;
                        if(rgb!==dut.mira_rgb) $fatal(1,"Prioridade mira");
                        if(dut.retic_visivel) begin overlap_count++;total_overlap++;end
                    end else if(dut.retic_visivel && rgb!==12'h0f0)
                        $fatal(1,"Reticulo sem sobreposicao");
                    if(dut.retic_visivel) ret_count++;
                    if(dut.horizonte_visivel) begin
                        hor_count++;
                        if(!dut.overlay_on && !dut.mira_on && g!=15) $fatal(1,"Horizonte invisivel");
                    end
                    extra_only=dut.extras_estilo && !dut.retic_visivel && !dut.horizonte_visivel &&
                        !dut.overlay_on && !dut.mira_on && !dut.sensor_status &&
                        !(!dut.estilo_caca && dut.alvo);
                    if(extra_only) begin
                        extra_count++;
                        if(dut.declutter && rgb!=0) $fatal(1,"DECLUTTER nao ocultou detalhe");
                        if(!dut.declutter && g!=15) $fatal(1,"NORMAL nao mostrou detalhe");
                    end
                    if(ppm) $fwrite(ppm,"%c%c%c",8'(r*17),8'(g*17),8'(b*17));
                end else if(rgb!==0) $fatal(1,"RGB no blanking");
                if(!hs) hc++;if(!vs) vc++;
                if((y==240 && x>=290 && x<=770) ||
                   ((y==12 || y==42 || y==66 || y==90) && x>=15 && x<=485) ||
                   ((y==479 || y==480 || y==490 || y==492) && x<4) ||
                   (y==480 && x<8))
                    $fwrite(csv,"%0d,%0d,%0d,%0d,%0b,%0b,%0b,%0b,%0b,%03h,%0b,%0b,%0b,%0b,%0d,%0d,%0d,%0d,%0d,%08h\n",
                        $time,frame,x,y,active,dut.retic_visivel,dut.horizonte_visivel,
                        dut.overlay_on,dut.mira_on,rgb,hs,vs,dut.declutter,dut.estilo_caca,
                        dut.hud_metadados[1:0],dut.heading_deg,dut.heading_manual,
                        dut.horizonte_y,$signed(dut.roll_q8),dut.hud_metadados);

                if(x==100 && y==100) begin
                    if(frame==0) begin operation=1;display_mode=1;sw[12]=1;buttons=1;end
                    if(frame==1) begin display_mode=0;buttons=0;sw[12]=0;end
                    if(frame==2) style_mode=1;
                    if(frame==3) display_mode=1;
                    if(frame==4) begin display_mode=0;style_mode=0;end
                    if(frame==8) begin operation=2;buttons=1;end
                    if(frame==9) begin buttons=0;sw[12]=1;sw[14]=1;end
                    if(frame==10) begin sw[12]=0;sw[14]=0;style_mode=1;end
                    if(frame==11) display_mode=1;
                    if(frame==12) begin display_mode=0;style_mode=0;end
                    if(frame==17) buttons=2;
                    if(frame==18) buttons=0;
                end
                if(x==0 && y==240) begin
                    if(frame==0 && (dut.hud_metadados[1:0]!=0 || dut.velocidade_kt!=0 || dut.altitude_ft!=0)) $fatal(1,"SOLO sem sensores");
                    if(frame==1 && dut.horizonte_y!=180) $fatal(1,"Pitch manual nao chegou ao quadro");
                    if(frame==2 && dut.horizonte_y!=240) $fatal(1,"Pitch manual nao retornou");
                    // Antes do primeiro tick de VOO o rumo ainda e zero; depois,
                    // a inicializacao so aparece na fronteira de quadro seguinte.
                    if(frame==7 && (dut.hud_metadados[1:0]!=1 || dut.heading_manual!=10 || dut.heading_deg!=0 || dut.altitude_ft<35000))
                        $fatal(1,"VOO/fallback rumo: modo=%0d manual=%0d heading=%0d altitude=%0d",dut.hud_metadados[1:0],dut.heading_manual,dut.heading_deg,dut.altitude_ft);
                    if(frame==9 && (dut.hud_metadados[1:0]!=1 || dut.heading_deg!=10)) $fatal(1,"Inicializacao do rumo apos tick de VOO");
                    if(frame==10 && (dut.horizonte_y!=180 || $signed(dut.roll_q8)==0)) $fatal(1,"Pitch/roll manuais em VOO");
                    if(frame==16 && (dut.hud_metadados[1:0]!=2 || dut.heading_deg!=20 || dut.altitude_ft>1500)) $fatal(1,"POUSO/fallback manual");
                    if(frame==19 && (dut.hud_metadados[1:0]!=2 || dut.heading_manual!=10 || dut.heading_deg!=10)) $fatal(1,"Comando manual de rumo em POUSO");
                end
                if(ex==799) begin ex=0;ey=(ey==524)?0:ey+1;end else ex++;
                @(posedge dut.pixel_clk);
                if($time-last_pixel!=40) $fatal(1,"Periodo pixel");
                last_pixel=$time;
            end
            if(ppm) $fclose(ppm);
            if(ac!=307200 || hc!=50400 || vc!=1600 || ret_count==0 || hor_count==0 || extra_count==0 || overlay_count==0)
                $fatal(1,"Cobertura frame=%0d active=%0d hs=%0d vs=%0d ret=%0d hor=%0d extra=%0d overlay=%0d",frame,ac,hc,vc,ret_count,hor_count,extra_count,overlay_count);
            $fwrite(summary,"%0d,%0b,%0b,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",frame,expected_declutter,expected_style,
                dut.hud_metadados[1:0],dut.heading_deg,dut.heading_manual,dut.horizonte_y,ac,hc,vc,ret_count,hor_count,extra_count,overlay_count,mira_count,overlap_count);
            $display("PASS frame=%0d NORMAL_DECLUTTER=%0b estilo=%0b active=%0d HS=%0d VS=%0d mira_sobre_reticulo=%0d",frame,expected_declutter,expected_style,ac,hc,vc,overlap_count);
        end
        if(total_overlap==0 || publications==0) $fatal(1,"Faltou prioridade real ou publicacao");
        $fclose(csv);$fclose(summary);
        $display("PASS MVP v1.1: 8400000 pixels, 20 quadros, parametros de sintese, raster real, NORMAL/DECLUTTER, SOLO/VOO/POUSO, controle manual, prioridade RGB e publicacao; sobreposicoes=%0d publicacoes=%0d",total_overlap,publications);
        $finish;
    end
    initial begin #400000000;$fatal(1,"Timeout MVP");end
endmodule
