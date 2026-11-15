# Arquitetura RTL consolidada

> Este documento descreve o RTL v1.1 da raiz. O [firmware recente](../firmware/calibracao-guiada-5d7a3ae2/README.md) tem fontes, MIG e parâmetros próprios. Os detalhes operacionais da base estão no [guia preservado](historico/README_baseline_20261106.md).

O top é `rtl/top_reticula.sv`, com aquisição/controles a 100 MHz e raster VGA a 25 MHz. A saída permanece 640×480 em um total de 800×525 pixels, 59,524 Hz.

| Cadeia | Implementação e seleção |
|---|---|
| Atitude | `mpu6050_i2c` → transformação de montagem → `atitude_vetorial`/`atitude_cordic`; `FULL_ATTITUDE=1` é o padrão. `hud_auto_zero` solicita referência estável após calibração. `FULL_ATTITUDE=0` preserva accel/bias/integração/fusão complementar legados. |
| Heading | `hmc5883l_i2c` → offsets/ganhos/orientação → `heading_magnetico` → `heading_fusao`, usando gyro Z e fallback manual. |
| Altitude/VSI | `bmp085_i2c` → compensação sequencial → `bmp085_altitude` e `estado_vertical`; validade segue a política operacional. |
| Operação | `operacao_hud`, simuladores SOLO/VOO/POUSO, `alertas_voo` e `buzzer_driver`; velocidade é demonstrativa. |
| Mira | `joystick_xadc` → duas instâncias `mira_joystick`, com passo fixo, limites e LOCK por estilo. Não controla o estimador de atitude. |
| Dados entre clocks | `entrada_hud`/`dados_hud` e pacotes adicionais transferem dados com handshake; publicação visual na fronteira do quadro. |
| Ajuste/captura | `hud_command_dispatch`, `hud_vertical_adjust`, `hud_flight_coords`, `captura_controle` e `video_captura`; bússola e vídeo mantêm coordenadas de tela, horizonte/retículos recebem o deslocamento de voo. |
| SD | Preamble/CMD0/comandos/inicialização → CMD17 e CRC16; árbitro do top separa diagnóstico e vídeo em um único mestre SPI. |
| Memória/vídeo | `sd_video_loader` escreve somente no banco livre de `sd_sector_buffer`; quadro íntegro é publicado no blanking. `sd_video_background` faz prefetch e RGB332→RGB444. Falha conserva HUD/último quadro válido. |
| Composição | Máscaras explícitas de HUD/captura, alertas, mira, retículos, horizonte e instrumentos; ícone microSD e RGB final. Preto pode ser opaco. HS/VS não são deslocados. |

`ENABLE_SD_SUBSYSTEM`, `ENABLE_SD_OVERLAY` e `ENABLE_SD_VIDEO` são desabilitados por padrão; os scripts especializados habilitam os perfis. Dois bancos de vídeo usam BRAM interna, sem DDR externa. O formato admite 160×120 ou 320×240; o refresh VGA não muda. Resolução/FPS do arquivo e divisor SPI pertencem ao perfil de build.

As três interfaces I²C são independentes. Clocks relacionados e exceções dos primeiros estágios assíncronos estão nos XDC; STA interno e CDC não qualificam os atrasos externos de SPI/I²C. `controle_manche`/`modo_manche` e velocidade inercial permanecem legados ou experimentais, sem substituir as fontes operacionais.

A consolidação não altera o RTL de `622eacb`; preserva a versão ensaiada e corrige sua infraestrutura de reprodução. Os riscos físicos de ajuste/ângulo/vídeo estão em [cobertura](consolidacao_20261106/cobertura.md). A máscara de chaveamento VGA externo do PR #5 permanece fora do top consolidado.
