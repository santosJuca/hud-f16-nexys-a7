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

## Indicador visual de captura, v1.1

A v1.1 acrescenta `CAP` em ciano, fixo em
`x=560..601`, `y=440..453`, quando a captura esta ativa
nas vistas 01, 10 ou 11.

Na vista 00, o indicador permanece oculto para preservar
a imagem de video puro. O indicador identifica o modo
captura, nao certifica isoladamente que o proximo quadro
ja tenha sido congelado.

Esta alteracao nao modifica o estimador de atitude,
os comandos, a bussola, a geometria de voo ou a QSPI.

## Lapidacao da ladder em bank elevado

A partir da v1.1, na geometria FULL_ATTITUDE, quando o
cosseno de roll Q14 esta entre -8192 e +8192,
a escada omite somente os numeros dos niveis 10 e 30 graus.

Os numeros 20 e 40 graus, horizonte zero, todas as marcas,
bussola, instrumentos laterais e referencia central permanecem.

A mudanca e exclusivamente visual e usa a atitude ja publicada
na fronteira de quadro. O modo legado nao e alterado.

A escolha de limiar e experimental e requer revisao do atlas
e validacao visual sobre o video antes da liberacao fisica.
