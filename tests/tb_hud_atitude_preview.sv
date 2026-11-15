`timescale 1ns/1ps
module tb_hud_atitude_preview;
    reg clk=0,reset=1,start=0;
    always #5 clk=~clk;
    reg signed [31:0] angle=0;
    wire done;
    wire signed [31:0] cx,sy;
    wire signed [15:0] cosine=cx>>>6,sine=sy>>>6;
    reg [9:0] x=0,y=0;
    reg diagnostics=0;
    wire horizon,reticle,calibration;
    atitude_cordic #(.VECTORING(0)) trig(.clk(clk),.reset(reset),.start(start),
        .x_in(32'sd0),.y_in(32'sd0),.angle_in(angle),.done(done),.busy(),.x_out(cx),.y_out(sy),.angle_out());
    simbologia_vga #(.FULL_ATTITUDE(1)) raster(.pixel_x(x),.pixel_y(y),.video_on(1'b1),
        .attitude_sine(sine),.attitude_cosine(cosine),.attitude_pitch_px(11'sd40),
        .horizonte_y(10'd240),.roll_q8(10'sd0),.heading_deg(9'd0),.alvo_x(10'd430),.alvo_y(9'd180),
        .horizonte_on(horizon),.altitude_on(),.direcao_on(),.alvo_on(),.velocidade_on());
    reticula_caca_vga #(.ESPESSURA(1)) datum(.pixel_x(x),.pixel_y(y),.video_on(1'b1),.reticula_on(reticle),.clearance_on());
    calibracao_vga panel(.x(x),.y(y),.video_on(1'b1),.grid(1'b1),.diagnostics(diagnostics),
        .raw_roll(angle>>>6),.raw_pitch(32'sd10240),.roll(angle>>>6),.pitch(32'sd10240),.render_roll(angle>>>6),
        .sine(sine),.cosine(cosine),.pitch_px(11'sd40),.status(32'h37),.video_status(32'd5),.frame_id(32'd123),
        .sensor_raw(96'd0),.mag_status(32'd0),.on(calibration));
    string folder;
    integer file_handle;
    integer angles[0:5]='{0,30,60,90,120,180};
    initial begin
        if(!$value$plusargs("OUT=%s",folder)) $fatal(1,"OUT ausente");
        repeat(3) @(negedge clk);reset=0;
        for(integer i=0;i<6;i++) begin
            angle=angles[i]*65536;start=1;@(negedge clk);start=0;wait(done);@(negedge clk);
            diagnostics=angles[i]==90;
            file_handle=$fopen($sformatf("%s/roll-%0d.ppm",folder,angles[i]),"w");
            if(!file_handle) $fatal(1,"Falha ao abrir preview");
            $fwrite(file_handle,"P3\n640 480\n255\n");
            for(integer yy=0;yy<480;yy++) for(integer xx=0;xx<640;xx++) begin
                x=10'(xx);y=10'(yy);#1;
                if(reticle || horizon) $fwrite(file_handle,"0 255 0\n");
                else if(calibration) $fwrite(file_handle,"0 255 255\n");
                else $fwrite(file_handle,"0 0 0\n");
            end
            $fclose(file_handle);
        end
        $display("PASS previews: seis rasters reais do horizonte/escada, datum fixo, grade e diagnostico");$finish;
    end
endmodule
