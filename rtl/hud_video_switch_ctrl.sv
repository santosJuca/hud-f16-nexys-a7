// P1: controle LOGICO de selecao de uma futura chave RGB analogica.
// Nao recebe nem digitaliza RGB externo. O projeto atual continua sem
// entrada VGA, sem relogio recuperado e sem pino fisico de selecao.
// sync_locked deve vir de um circuito futuro com alinhamento real de pixel.
module hud_video_switch_ctrl (
    input  wire overlay_enable,
    input  wire sync_locked,
    input  wire external_video_active,
    input  wire mask_on,
    output wire select_hud
);
    // Em ausencia de sincronismo ou durante blanking, preservar a fonte externa.
    assign select_hud = overlay_enable && sync_locked &&
                        external_video_active && mask_on;
endmodule
