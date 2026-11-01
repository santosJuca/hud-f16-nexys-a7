`timescale 1ns/1ps
module tb_horizonte_completo;
    reg clk=0,reset=1,start=0;
    always #5 clk=~clk;
    reg signed [31:0] angle=0;
    wire done;
    wire signed [31:0] cosine_q20,sine_q20;
    wire signed [15:0] sine=sine_q20>>>6,cosine=cosine_q20>>>6;
    reg [9:0] x=0,y=0;
    reg signed [10:0] pitch_px=0;
    wire signed [21:0] u,v;
    wire horizon;
    atitude_cordic #(.VECTORING(0)) trig(.clk(clk),.reset(reset),.start(start),
        .x_in(32'sd0),.y_in(32'sd0),.angle_in(angle),.done(done),.busy(),
        .x_out(cosine_q20),.y_out(sine_q20),.angle_out());
    horizonte_atitude geometry(.pixel_x(x),.pixel_y(y),.sine(sine),.cosine(cosine),.pitch_px(pitch_px),.local_x(u),.local_y(v));
    simbologia_vga #(.FULL_ATTITUDE(1)) raster(.pixel_x(x),.pixel_y(y),.video_on(1'b1),
        .attitude_sine(sine),.attitude_cosine(cosine),.attitude_pitch_px(pitch_px),
        .horizonte_y(10'd240),.roll_q8(10'sd0),.heading_deg(9'd0),.alvo_x(10'd430),.alvo_y(9'd180),
        .horizonte_on(horizon),.altitude_on(),.direcao_on(),.alvo_on(),.velocidade_on());
    function automatic real absolute(input real v); absolute=v<0 ? -v : v; endfunction
    integer checks=0,points=0;
    real pi=3.141592653589793,theta,eu,ev,error;
    integer roll_values[0:14]='{0,15,-15,30,-30,45,-45,60,-60,90,-90,120,-120,180,-180};
    integer pitch_values[0:8]='{0,5,-5,10,-10,15,-15,20,-20};
    task automatic set_roll(input integer r);
        @(negedge clk); angle=r*65536; start=1;
        @(negedge clk); start=0;
        wait(done); @(negedge clk);
        theta=r*pi/180.0;
        if(absolute($itor($signed(sine))/16384.0-$sin(theta))>0.00015 ||
           absolute($itor($signed(cosine))/16384.0-$cos(theta))>0.00015)
            $fatal(1,"Trig r=%0d sin=%0d cos=%0d",r,$signed(sine),$signed(cosine));
    endtask
    task automatic check_point(input integer px,py,r,p);
        x=10'(px); y=10'(py); pitch_px=11'(p*4); #1;
        eu=(px-320)*$cos(theta)-(py-240)*$sin(theta);
        ev=(px-320)*$sin(theta)+(py-240)*$cos(theta)-p*4;
        if(absolute($itor($signed(u))-eu)>1.08 || absolute($itor($signed(v))-ev)>1.08)
            $fatal(1,"Geometry r=%0d p=%0d x/y=%0d/%0d u/v=%0d/%0d expected=%f/%f",r,p,px,py,$signed(u),$signed(v),eu,ev);
        checks++;
    endtask
    task automatic line_point(input integer r,p,level);
        integer px,py,hits;
        real vv;
        begin
            vv=4*(p-level);
            px=$rtoi(320+100*$cos(theta)+vv*$sin(theta));
            py=$rtoi(240-100*$sin(theta)+vv*$cos(theta));
            if(level!=0) begin
                px=$rtoi(320+50*$cos(theta)+vv*$sin(theta));
                py=$rtoi(240-50*$sin(theta)+vv*$cos(theta));
            end
            hits=0;
            for(integer yy=py-2;yy<=py+2;yy++) for(integer xx=px-2;xx<=px+2;xx++) begin
                x=10'(xx);y=10'(yy);pitch_px=11'(p*4);#1;
                if(horizon) hits++;
            end
            if(hits==0) $fatal(1,"Linha desapareceu r=%0d p=%0d level=%0d",r,p,level);
            points++;
        end
    endtask
    initial begin
        repeat(3) @(negedge clk);reset=0;
        for(integer r=0;r<15;r++) begin
            set_roll(roll_values[r]);
            for(integer p=0;p<9;p++) begin
                for(integer yy=0;yy<480;yy+=13) for(integer xx=0;xx<640;xx+=17)
                    check_point(xx,yy,roll_values[r],pitch_values[p]);
                line_point(roll_values[r],pitch_values[p],0);
                line_point(roll_values[r],pitch_values[p],10);
            end
        end
        // Varredura continua cobre as transicoes 0/90/-90/180 e pitch simultaneo.
        for(integer r=-180;r<=180;r++) begin
            set_roll(r); check_point(420,300,r,(r%21));
        end
        $display("PASS geometria: %0d pontos, %0d linhas; roll completo e pitch combinado",checks,points);
        $finish;
    end
    initial begin #10000000; $fatal(1,"Timeout geometry");end
endmodule
