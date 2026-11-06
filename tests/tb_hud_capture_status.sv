`timescale 1ns/1ps
module tb_hud_capture_status;
    logic [9:0] x=0, y=0;
    logic video_on=1, capture=0;
    logic [1:0] view=0;
    wire on;

    hud_capture_status_vga dut (
        .pixel_x(x), .pixel_y(y),
        .video_on(video_on),
        .capture_active(capture),
        .view(view), .on(on)
    );

    task automatic check(
        input logic c,
        input logic [1:0] v,
        input logic vid,
        input logic [9:0] px, py,
        input logic expected
    );
        capture=c;
        view=v;
        video_on=vid;
        x=px;
        y=py;
        #1;
        if(on !== expected)
            $fatal(1,
                "CAP errado: c=%b v=%b vid=%b x=%0d y=%0d got=%b expected=%b",
                c,v,vid,px,py,on,expected);
    endtask

    initial begin
        // Fora da captura, nenhum indicador.
        check(0,2'd1,1,562,440,0);

        // Na vista de video puro, nenhum indicador.
        check(1,2'd0,1,562,440,0);

        // As tres vistas com HUD mostram o indicador.
        check(1,2'd1,1,562,440,1);
        check(1,2'd2,1,562,440,1);
        check(1,2'd3,1,562,440,1);

        // Confere pixels das letras A e P.
        check(1,2'd1,1,578,440,1);
        check(1,2'd1,1,588,440,1);

        // Pixel apagado dentro da caixa.
        check(1,2'd1,1,560,440,0);

        // Ausencia de desenho fora da area ativa.
        check(1,2'd1,0,562,440,0);
        check(1,2'd1,1,562,439,0);
        check(1,2'd1,1,562,454,0);
        check(1,2'd1,1,602,440,0);

        $display("PASS CAP: modos, pixels, vista pura e clipping");
        $finish;
    end
endmodule
