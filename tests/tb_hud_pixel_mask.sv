`timescale 1ns/1ps

// Todos os 1024 estados logicos das 10 entradas sao exercitados.
// A mascara sinaliza ocupacao por camada, nunca "RGB != preto".
module tb_hud_pixel_mask;
    reg video_on=0, declutter=0, estilo_caca=0;
    reg alerta_on=0, mira_on=0, reticula_on=0, alvo_on=0;
    reg sensor_status_on=0, horizonte_on=0, extras_on=0;
    wire mask_on;
    reg esperado;

    hud_pixel_mask dut (
        .video_on(video_on), .declutter(declutter),
        .estilo_caca(estilo_caca), .alerta_on(alerta_on),
        .mira_on(mira_on), .reticula_on(reticula_on),
        .alvo_on(alvo_on), .sensor_status_on(sensor_status_on),
        .horizonte_on(horizonte_on), .extras_on(extras_on),
        .mask_on(mask_on)
    );

    initial begin
        for (integer i=0; i<1024; i=i+1) begin
            {video_on,declutter,estilo_caca,alerta_on,mira_on,
             reticula_on,alvo_on,sensor_status_on,horizonte_on,
             extras_on} = 10'(i);
            #1;
            esperado = video_on &&
                (alerta_on || mira_on || reticula_on ||
                 (!estilo_caca && alvo_on) || horizonte_on ||
                 (!declutter && (sensor_status_on || extras_on)));
            if (mask_on !== esperado)
                $fatal(1,"Mascara i=%0d: obtido=%b esperado=%b",i,mask_on,esperado);
            if (!video_on && mask_on)
                $fatal(1,"Mascara ativa no blanking i=%0d",i);
        end
        // O teste nao compara RGB, deliberadamente: pixel preto pode ser opaco.
        $display("PASS hud_pixel_mask: 1024 combinacoes, camadas/estilos/declutter e blanking");
        $finish;
    end
endmodule
