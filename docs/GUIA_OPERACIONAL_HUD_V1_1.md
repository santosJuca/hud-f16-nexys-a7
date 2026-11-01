# Guia operacional HUD v1.1

Base de referência: `hud-v1.0-autozero-qspi`, commit `33bf42c`.

Este documento descreve o comportamento implementado. A v1.1 ainda
não altera a interface física nem o bitstream publicado.

## Operação normal

- SW0: 0 normal, 1 declutter.
- SW1: 0 estilo original, 1 caça.
- SW3:SW2: 00 solo, 01 voo, 10 pouso, 11 inválido.
- SW4=0: BTNU/BTND comandam o rumo manual.
- BTNC: reconhecimento e silenciamento de alerta.
- BTNL curto: alterna a exibição do vídeo de fundo.
- Botão KY-023: LOCK da mira ou marcador ativo.

## Alinhamento visual

- SW4=1: habilita o ajuste vertical.
- BTNU: deslocamento para cima.
- BTND: deslocamento para baixo.
- Passos de 1 pixel e limites de -64 a +64 pixels.
- A posição é aplicada na fronteira do quadro VGA.
- A estimativa angular do MPU6050 não é modificada.
- A função de alinhamento é suspensa durante captura.

## Captura e diagnóstico

- BTNL longo: entra ou sai da captura.
- BTNL curto durante captura: avança um quadro.
- SW6:SW5=00: vídeo sem HUD.
- SW6:SW5=01: vídeo com HUD.
- SW6:SW5=10: vídeo com HUD e grade.
- SW6:SW5=11: vídeo com HUD e diagnóstico.
- BTNU+BTND simultâneos durante captura: alterna grade adicional.
- SW7, borda de subida durante captura: solicita zero manual do MPU.
- SW8: solicita leitura de diagnóstico do cartão microSD.
- SW5 a SW7 também participam das páginas do display de diagnóstico.

## Sensores e atitude

- SW9=1: desabilita uso da atitude MPU.
- SW10=1: desabilita fonte barométrica.
- SW11=1: desabilita fonte magnética.
- SW15:SW12=1111 com SW9=0 permite atitude real do MPU,
  desde que o estimador esteja válido.
- Outras combinações de SW12 a SW15 selecionam comandos manuais.
- Zeragem automática do MPU já implementada na v1.0.

## Alertas e segurança

- Buzzer: saída JD4/G3 via estágio transistorizado.
- O vídeo microSD e a atitude permanecem independentes do ajuste visual.
- Não alterar a fiação do JXADC sem validar a faixa de tensão.
- O estudo de VGA externo permanece separado do vídeo microSD funcional.

## Próxima fase

Avaliar simplificação dos modos com testes de isolamento,
preservando a lógica de atitude, vídeo e boot QSPI.
