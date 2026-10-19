// P1: mascara explicita do HUD para futura sobreposicao VGA.
// Independente do valor de RGB: um pixel ocupado pode ser preto no futuro.
// Somente o compositor decide quais camadas participam da mascara.
module hud_pixel_mask (
    input  wire video_on,
    input  wire declutter,
    input  wire estilo_caca,
    input  wire alerta_on,
    input  wire mira_on,
    input  wire reticula_on,
    input  wire alvo_on,
    input  wire sensor_status_on,
    input  wire horizonte_on,
    input  wire extras_on,
    output wire mask_on
);
    assign mask_on = video_on &&
        (alerta_on ||
         mira_on ||
         reticula_on ||
         (!estilo_caca && alvo_on) ||
         horizonte_on ||
         (!declutter && (sensor_status_on || extras_on)));
endmodule
