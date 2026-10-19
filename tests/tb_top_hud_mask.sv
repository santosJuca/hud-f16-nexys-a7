`timescale 1ns/1ps
// Exercita a mascara ligada ao top real, sem alterar os RGB do produto.
// Cobre amostras de tela dos quatro estilos e os periodos de blanking.
module tb_top_hud_mask;
    reg clk=0; always #5 clk=~clk;
    tri1 i2c_sda, i2c_scl, baro_sda, baro_scl, mag_sda, mag_scl;
    wire [3:0] r,g,b;
    wire hs,vs;
    reg estilo=0, pouco=0;
    integer total=0;

    top_reticula dut(
        .clk(clk), .operacao_sw(2'b00), .ack_btn(1'b0),
        .btn_heading(2'b00), .sw(7'b0000000),
        .display_mode(1'b0), .style_mode(1'b0),
        .vauxp3(1'b0),.vauxn3(1'b0),
        .vauxp10(1'b0),.vauxn10(1'b0),
        .joystick_sw_n(1'b1), .JOY_LED(),
        .i2c_sda(i2c_sda),.i2c_scl(i2c_scl),
        .baro_sda(baro_sda),.baro_scl(baro_scl),
        .mag_sda(mag_sda),.mag_scl(mag_scl),
        .VGA_R(r),.VGA_G(g),.VGA_B(b),
        .VGA_HS(hs),.VGA_VS(vs)
    );

    task automatic verifica;
        reg esperado;
        begin
            esperado = dut.video_on &&
                ((dut.overlay_on && dut.MODOS_OPERACIONAIS) ||
                 (dut.mira_on && dut.MODOS_OPERACIONAIS) ||
                 dut.retic_visivel ||
                 (!dut.estilo_caca && dut.alvo) ||
                 dut.horizonte_visivel ||
                 (!dut.declutter && (dut.sensor_status || dut.extras_estilo)));
            if (dut.hud_mask !== esperado)
                $fatal(1, "Mascara difere das camadas pixel=%0d,%0d estilo=%b declutter=%b",
                    dut.pixel_x, dut.pixel_y, estilo, pouco);
            if (dut.video_on===1'b0 && dut.hud_mask!==1'b0)
                $fatal(1,"Mascara durante blanking");
            // Nunca podemos tornar transparente um pixel nao preto do HUD.
            if ((^{r,g,b} !== 1'bx) && ({r,g,b} != 12'h000) &&
                dut.hud_mask !== 1'b1)
                $fatal(1,"RGB visivel sem mascara em %0d,%0d",dut.pixel_x,dut.pixel_y);
            total=total+1;
        end
    endtask

    initial begin
        #120;
        for (integer modo=0;modo<4;modo=modo+1) begin
            estilo=1'(modo & 1);
            pouco=1'((modo >> 1) & 1);
            force dut.estilo_caca=estilo;
            force dut.declutter=pouco;
            for (integer y=0;y<480;y=y+16) begin
                for(integer x=0;x<640;x=x+16) begin
                    force dut.u_vga.h_cont=x;
                    force dut.u_vga.v_cont=y;
                    #1;
                    verifica();
                end
            end
            force dut.u_vga.h_cont=700;
            force dut.u_vga.v_cont=490;
            #1;
            verifica();
            if(dut.hud_mask !== 1'b0 || {r,g,b} !== 12'h000)
                $fatal(1,"Blanking nao ficou transparente e preto");
        end
        release dut.estilo_caca;
        release dut.declutter;
        release dut.u_vga.h_cont;
        release dut.u_vga.v_cont;
        $display("PASS top_hud_mask: %0d pixels amostrados, NORMAL/CACA x DECLUTTER, blanking",total);
        $finish;
    end
endmodule
