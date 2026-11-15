# Pinagem e controles

> Esta pinagem pertence à base v1.1 da raiz. Para 5D7A3AE2, use o [guia recente](../firmware/calibracao-guiada-5d7a3ae2/README.md) e seus XDC; não misture perfis.

Este mapa foi conferido contra o top [top_reticula](../rtl/top_reticula.sv) e o [XDC ativo](../constraints/nexys_a7_reticula.xdc). O alvo configurado é a Nexys A7-100T, FPGA `xc7a100tcsg324-1`. Pinos indicados são PACKAGE_PIN do FPGA. A conferência documental não valida cabos, módulos ou níveis elétricos da montagem.

Consulte também o [guia operacional v1.1](GUIA_OPERACIONAL_HUD_V1_1.md), baseado no RTL funcional da v1.0.

## Controles da placa

| Controle | Pino FPGA | Função atual |
| --- | --- | --- |
| SW0 | J15 | NORMAL (`0`) / DECLUTTER (`1`) |
| SW1 | L16 | HUD original (`0`) / CAÇA (`1`) |
| SW2 | M13 | Bit 0 de modo: SOLO `00`, VOO `01`, POUSO `10`; `11` inválido |
| SW3 | R15 | Bit 1 de modo (`SW3:SW2`) |
| SW4 | R17 | Ativa alinhamento vertical do HUD |
| SW5 | T18 | Bit 0 da vista de captura; página de diagnóstico |
| SW6 | U18 | Bit 1 da vista de captura; página de diagnóstico |
| SW7 | R13 | Zeragem manual por borda de subida durante captura; página de diagnóstico |
| SW8 | T8, LVCMOS18 | Solicita leitura de diagnóstico do microSD |
| SW9 | U8, LVCMOS18 | SW ligado desativa o uso da atitude MPU e seleciona comandos manuais |
| SW10 | R16, LVCMOS33 | SW ligado desativa o uso da fonte barométrica |
| SW11 | T13, LVCMOS33 | SW ligado desativa o uso da fonte magnética |
| SW12 | H6 | Bit menos significativo do comando de pitch |
| SW13 | U12 | Bit mais significativo do comando de pitch |
| SW14 | U11 | Bit menos significativo do comando de roll |
| SW15 | V10 | Bit mais significativo do comando de roll |
| BTNU | M18 | Rumo +10° no modo normal; alinhamento vertical para cima com SW4; combinação com BTND alterna grade na captura |
| BTND | P18 | Rumo -10° no modo normal; alinhamento vertical para baixo com SW4; combinação com BTNU alterna grade na captura |
| BTNC | N17 | ACK lógico do alerta/buzzer |
| Buzzer | JD4/G3, LVCMOS33 | Saída para o estágio transistorizado 2N2222A na versão funcional v1.0 |
| BTNL | P17 | Toque curto alterna vídeo; pressionamento longo alterna captura; toque curto na captura avança quadro |
| BTNR | Não declarado no top/XDC | Sem uso |
| KY-023, eixo X | JXADC1/7, VAUX3, A13/A14 | Entrada analógica para a mira móvel |
| KY-023, eixo Y | JXADC2/8, VAUX10, A15/A16 | Entrada analógica para a mira móvel; orientação configurada no top |
| KY-023, botão SW | JA1, C17 | Ativo baixo; alterna LOCK/UNLOCK |

SW12/SW13 codificam pitch e SW14/SW15 codificam roll; `00`/`11` representam zero e `01`/`10` selecionam os sentidos. `SW15..12=1111` seleciona o MPU quando SW9 está desligado; nos demais estados os comandos manuais têm prioridade. Eles aparecem no HUD também em SOLO. Em VOO/POUSO, os valores manuais alimentam ainda os alertas angulares e a velocidade simulada. SW9–SW11 são sincronizados e desativam as fontes MPU, barométrica e magnética no RTL; os drivers continuam fazendo aquisição nos barramentos.

## LEDs

| LED | Pino FPGA | Função |
| --- | --- | --- |
| LD0 | H17 | Diagnóstico de movimento X− do joystick |
| LD1 | K15 | Diagnóstico de movimento X+ do joystick |
| LD2 | J13 | Diagnóstico de movimento Y− do joystick |
| LD3 | N14 | Diagnóstico de movimento Y+ do joystick |
| LD4 | R18 | MPU-6050 habilitado e identificado, conforme `GYRO_LED` (giroscópio e acelerômetro) |
| LD5 | V17 | Estado de identificação/leitura válida do BMP085, conforme `BARO_LED` |
| LD6 | U17 | Estado de identificação/configuração do HMC5883L, não sua calibração |
| LD7 | U16 | Inicialização SD concluída |
| LD8 | V16 | Erros SD, incluindo carregador de vídeo |
| LD9 | T15 | Transação SD ocupada |
| LD10 | U14 | CRC válido do diagnóstico |
| LD11 | T16 | Conteúdo do diagnóstico confere com referência |
| LD12–LD15 | Não declarados no top/XDC | Sem uso |

Não há LED dedicado para modo, LOCK, alerta ou buzzer. A saída lógica do top está atribuída a JD4/G3 na versão v1.0. A v1.1 tem relato de joystick e buzzer aprovados; isso não qualifica eletricamente o estágio externo nem qualquer novo bitstream.

## Sensores e VGA

| Interface | Conector/posição | Pino FPGA | Sinais |
| --- | --- | --- | --- |
| Clock da placa | Oscilador | E3 | `clk`, 100 MHz |
| MPU-6050 I²C | JD8 / JD7 | G4 / H2 | SDA / SCL |
| BMP085 I²C | JD1 / JD2 | H4 / H1 | SDA / SCL |
| HMC5883L I²C | JD3 / JD9 | G1 / G2 | SDA / SCL |
| VGA RGB | DE-15 | conforme tabela no XDC | RGB444, 4 bits por canal |
| VGA sync | DE-15 | B11 / B12 | HS / VS |

As três interfaces I²C são independentes. O XDC configura `LVCMOS33`; isso não confirma a alimentação real do módulo nem substitui a verificação de pull-ups e limites elétricos. Os eixos usam entradas diferenciais dedicadas do JXADC; o top amostra VAUX3 e VAUX10 em modo unipolar, nominalmente 0–1 V. Foram relatadas leituras acima de 1 V em ensaios recentes com resistores de 27 kΩ, mas a topologia completa e os outros valores não estão registrados. Não repetir a ligação ao XADC até medir a tensão diretamente em JXADC1 e JXADC2 e confirmar a rede de condicionamento; `LVCMOS33` não autoriza exceder a faixa analógica.

## Sinais VGA

| Sinal | PACKAGE_PIN |
| --- | --- |
| VGA_R[0], [1], [2], [3] | A3, B4, C5, A4 |
| VGA_G[0], [1], [2], [3] | C6, A5, B6, A6 |
| VGA_B[0], [1], [2], [3] | B7, C7, D7, D8 |
| VGA_HS / VGA_VS | B11 / B12 |

A saída VGA onboard é saída analógica por DAC resistivo. O projeto não captura entrada VGA.

## microSD e display de diagnóstico

Pinagem do XDC: `SD_RESET=E2`, `SD_SCK=B1`, `SD_CMD=C1`, `SD_DAT0=C2`, `SD_DAT3=D2`, `SD_CD=A1`, todos LVCMOS33. SW8/`SD_READ_SWITCH` é T8/LVCMOS18. BTNL/`VIDEO_TOGGLE_BUTTON` é P17/LVCMOS33 no XDC principal; `constraints/sd_video.xdc` acrescenta uma exceção ao primeiro estágio de sincronização.

O display de sete segmentos usa `SD_SEG[0..6]=T10,R10,K16,K13,P15,T11,L18`, `SD_AN[0..7]=J17,J18,T9,J14,P14,T14,K2,U13` e `SD_DP=H15`. SW7..SW4 também selecionam as páginas de diagnóstico. O XDC é a fonte de verdade; não duplicar pinos livres a partir de tabelas históricas.

SW4/BTNU/BTND, vistas SW6:SW5 e SW7 compartilham funções por contexto. Conferir o guia operacional antes de ajustar. Os episódios físicos de perda de vídeo, deslocamento da bússola e inconsistência angular permanecem pendentes de reteste dirigido.
