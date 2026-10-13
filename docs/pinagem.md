# Pinagem e controles

Este mapa foi conferido contra o top [top_reticula](../rtl/top_reticula.sv) e o [XDC ativo](../constraints/nexys_a7_reticula.xdc). O alvo configurado é a Nexys A7-100T, FPGA `xc7a100tcsg324-1`. Pinos indicados são PACKAGE_PIN do FPGA. A conferência documental não valida cabos, módulos ou níveis elétricos da montagem.

## Controles da placa

| Controle | Pino FPGA | Função atual |
| --- | --- | --- |
| SW0 | J15 | NORMAL (`0`) / DECLUTTER (`1`) |
| SW1 | L16 | HUD original (`0`) / CAÇA (`1`) |
| SW2 | M13 | Bit 0 de modo: SOLO `00`, VOO `01`, POUSO `10`; `11` inválido |
| SW3 | R15 | Bit 1 de modo (`SW3:SW2`) |
| SW4–SW8 | Não declarados no top/XDC | Sem uso |
| SW9 | U8, LVCMOS18 | SW ligado desativa o uso da atitude MPU e seleciona comandos manuais |
| SW10 | R16, LVCMOS33 | SW ligado desativa o uso da fonte barométrica |
| SW11 | T13, LVCMOS33 | SW ligado desativa o uso da fonte magnética |
| SW12 | H6 | Bit menos significativo do comando de pitch |
| SW13 | U12 | Bit mais significativo do comando de pitch |
| SW14 | U11 | Bit menos significativo do comando de roll |
| SW15 | V10 | Bit mais significativo do comando de roll |
| BTNU | M18 | Incrementa heading manual em 10° |
| BTND | P18 | Decrementa heading manual em 10° |
| BTNC | N17 | ACK lógico do alerta/buzzer interno |
| Buzzer | JC7/E7, LVCMOS33 | Saída lógica para o estágio transistorizado |
| BTNL, BTNR | Não declarados no top/XDC | Sem uso |
| KY-023, eixo X | JXADC1/7, VAUX3, A13/A14 | Entrada analógica para a mira móvel |
| KY-023, eixo Y | JXADC2/8, VAUX10, A15/A16 | Entrada analógica para a mira móvel; orientação configurada no top |
| KY-023, botão SW | JC1, K1 | Ativo baixo; alterna LOCK/UNLOCK |

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
| LD7–LD15 | Não declarados no top/XDC | Sem uso |

Não há LED dedicado para modo, LOCK, alerta ou buzzer. `buzzer_out` é lógico e está atribuído a JC7/E7 para o estágio transistorizado.

## Sensores e VGA

| Interface | Conector/posição | Pino FPGA | Sinais |
| --- | --- | --- | --- |
| Clock da placa | Oscilador | E3 | `clk`, 100 MHz |
| MPU-6050 I²C | JD8 / JD7 | G4 / H2 | SDA / SCL |
| BMP085 I²C | JD1 / JD2 | H4 / H1 | SDA / SCL |
| HMC5883L I²C | JD3 / JD9 | G1 / G2 | SDA / SCL |
| VGA RGB | DE-15 | conforme tabela no XDC | RGB444, 4 bits por canal |
| VGA sync | DE-15 | B11 / B12 | HS / VS |

As três interfaces I²C são independentes. O XDC configura `LVCMOS33`; isso não confirma a alimentação real do módulo nem substitui a verificação de pull-ups e limites elétricos. Os eixos usam entradas diferenciais dedicadas do JXADC; respeite a faixa elétrica do XADC e não trate `LVCMOS33` como autorização para excedê-la.

## Sinais VGA

| Sinal | PACKAGE_PIN |
| --- | --- |
| VGA_R[3:0] | A3, B4, C5, A4 |
| VGA_G[3:0] | C6, A5, B6, A6 |
| VGA_B[3:0] | B7, C7, D7, D8 |
| VGA_HS / VGA_VS | B11 / B12 |

A saída VGA onboard é saída analógica por DAC resistivo. O projeto não captura entrada VGA.
