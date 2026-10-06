# Pinagem e expansão da Nexys A7-100T

Auditoria da fonte `84411c3`, em 06/10/2026. Foram cruzados o [XDC ativo](../constraints/nexys_a7_reticula.xdc), as portas de [top_reticula](../rtl/top_reticula.sv), o [Master XDC da Digilent, revisão `00a3404`](https://github.com/Digilent/digilent-xdc/blob/00a3404901f35aa9567b01ecb3f2c233b6efe9f4/Nexys-A7-100T-Master.xdc), o [manual oficial, seções 8–10](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf) e o [esquemático D.0, folhas 1, 2 e 8](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7-sch.pdf).

**Resultado:** 40 bits de portas, 40 pinos FPGA distintos, nenhum pino ativo duplicado e nenhum IOSTANDARD divergente do Master XDC. Esta conferência documental não inspeciona cabos ou a revisão física da placa: **PENDENTE DE VALIDAÇÃO FÍSICA**. Nenhum XDC foi alterado.

## Legenda

- **USADO:** conectado no top e no XDC atual.
- **RESERVADO:** recurso dedicado da placa ou proposta identificada; a proposta não configura o FPGA.
- **DISPONÍVEL:** sem uso neste design e fisicamente presente no recurso indicado. Não implica conector desocupado na montagem.
- **POSSÍVEL CONFLITO:** exigiria revisar ligação, tensão, direção ou recurso compartilhado.
- **NECESSITA HARDWARE EXTERNO:** função não atendida pelo conector/FPGA sozinho.

## Sinais usados

Em JXADC, a coluna IOSTANDARD registra o XDC; ela **não** autoriza aplicar 3,3 V ao conversor analógico.

| Função | Sinal RTL | Conector físico | Pino FPGA | IOSTANDARD | Estado |
| --- | --- | --- | --- | --- | --- |
| Clock 100 MHz | `clk` | Oscilador da placa | E3 | LVCMOS33 | USADO |
| VGA R, bit 0, DAC resistivo | `VGA_R[0]` | VGA DE-15 pino 1 | A3 | LVCMOS33 | USADO |
| VGA R, bit 1, DAC resistivo | `VGA_R[1]` | VGA DE-15 pino 1 | B4 | LVCMOS33 | USADO |
| VGA R, bit 2, DAC resistivo | `VGA_R[2]` | VGA DE-15 pino 1 | C5 | LVCMOS33 | USADO |
| VGA R, bit 3, DAC resistivo | `VGA_R[3]` | VGA DE-15 pino 1 | A4 | LVCMOS33 | USADO |
| VGA G, bit 0, DAC resistivo | `VGA_G[0]` | VGA DE-15 pino 2 | C6 | LVCMOS33 | USADO |
| VGA G, bit 1, DAC resistivo | `VGA_G[1]` | VGA DE-15 pino 2 | A5 | LVCMOS33 | USADO |
| VGA G, bit 2, DAC resistivo | `VGA_G[2]` | VGA DE-15 pino 2 | B6 | LVCMOS33 | USADO |
| VGA G, bit 3, DAC resistivo | `VGA_G[3]` | VGA DE-15 pino 2 | A6 | LVCMOS33 | USADO |
| VGA B, bit 0, DAC resistivo | `VGA_B[0]` | VGA DE-15 pino 3 | B7 | LVCMOS33 | USADO |
| VGA B, bit 1, DAC resistivo | `VGA_B[1]` | VGA DE-15 pino 3 | C7 | LVCMOS33 | USADO |
| VGA B, bit 2, DAC resistivo | `VGA_B[2]` | VGA DE-15 pino 3 | D7 | LVCMOS33 | USADO |
| VGA B, bit 3, DAC resistivo | `VGA_B[3]` | VGA DE-15 pino 3 | D8 | LVCMOS33 | USADO |
| Sincronismo horizontal | `VGA_HS` | VGA DE-15 pino 13 | B11 | LVCMOS33 | USADO |
| Sincronismo vertical | `VGA_VS` | VGA DE-15 pino 14 | B12 | LVCMOS33 | USADO |
| MPU6050 SDA | `i2c_sda` | JD8 | G4 | LVCMOS33 | USADO |
| MPU6050 SCL | `i2c_scl` | JD7 | H2 | LVCMOS33 | USADO |
| BMP085 SDA | `baro_sda` | JD1 | H4 | LVCMOS33 | USADO |
| BMP085 SCL | `baro_scl` | JD2 | H1 | LVCMOS33 | USADO |
| Status da conversão BMP085 | `BARO_LED` | LED4 | R18 | LVCMOS33 | USADO |
| Fallback pitch −40 px | `sw[12]` | SW12 | H6 | LVCMOS33 | USADO |
| Fallback pitch +40 px | `sw[13]` | SW13 | U12 | LVCMOS33 | USADO |
| Fallback roll −64 Q8 | `sw[14]` | SW14 | U11 | LVCMOS33 | USADO |
| Fallback roll +64 Q8 | `sw[15]` | SW15 | V10 | LVCMOS33 | USADO |
| Rumo manual +10° | `btn_heading[0]` | BTNU | M18 | LVCMOS33 | USADO |
| Rumo manual −10° | `btn_heading[1]` | BTND | P18 | LVCMOS33 | USADO |
| SW0: NORMAL/DECLUTTER | `display_mode` | SW0 | J15 | LVCMOS33 | USADO |
| SW1: ORIGINAL/CAÇA | `style_mode` | SW1 | L16 | LVCMOS33 | USADO |
| KY-023 X, VAUX3 positivo | `vauxp3` | JXADC1 | A13 | LVCMOS33 | USADO |
| KY-023 X, VAUX3 negativo | `vauxn3` | JXADC7 | A14 | LVCMOS33 | USADO |
| KY-023 Y, VAUX10 positivo | `vauxp10` | JXADC2 | A15 | LVCMOS33 | USADO |
| KY-023 Y, VAUX10 negativo | `vauxn10` | JXADC8 | A16 | LVCMOS33 | USADO |
| Diagnóstico joystick: X menos | `JOY_LED[0]` | LED0 | H17 | LVCMOS33 | USADO |
| Diagnóstico joystick: X mais | `JOY_LED[1]` | LED1 | K15 | LVCMOS33 | USADO |
| Diagnóstico joystick: Y menos | `JOY_LED[2]` | LED2 | J13 | LVCMOS33 | USADO |
| Diagnóstico joystick: Y mais | `JOY_LED[3]` | LED3 | N14 | LVCMOS33 | USADO |
| KY-023: alterna SENSOR/MANCHE, ativo baixo | `joystick_sw_n` | JA1 | C17 | LVCMOS33 | USADO |
| HMC5883L SDA | `mag_sda` | JD3 | G1 | LVCMOS33 | USADO |
| HMC5883L SCL | `mag_scl` | JD9 | G2 | LVCMOS33 | USADO |
| HMC identificado/configurado | `MAG_LED` | LED5 | V17 | LVCMOS33 | USADO |

Os três I²C são independentes: MPU em JD8/JD7, BMP em JD1/JD2 e HMC em JD3/JD9 (SDA/SCL). São sinais open-drain; conferir pull-ups externos e níveis de 3,3 V. O XDC explicita pull-ups internos no HMC e no botão do joystick. Pull-up interno não substitui dimensionamento do barramento.

`BARO_LED` depende de identificação, coeficientes, amostras e cálculo de pressão na faixa aceita; pode apagar entre conversões. `MAG_LED` acompanha identificação/configuração, não precisão nem calibração magnética. Os quatro `JOY_LED` mostram direções detectadas.

A saída VGA combina quatro bits por cor em uma rede resistiva, não quatro contatos separados no DE-15. O conector da placa é de **saída**; não recebe RGB externo. Os controles SW12..SW15 só assumem pitch/roll quando SENSOR está sem MPU utilizável. BTNU/BTND continuam atualizando o fallback de rumo durante a seleção de outra fonte.

## Portas disponíveis para expansão

JA/JB/JC/JD têm oito sinais por conector. No esquemático D.0 há resistores série de 200 Ω nesses caminhos; não tratar PMOD como barramento de vídeo caracterizado em alta frequência. JXADC tem rede analógica própria. Alimentação e terra não são GPIO. As posições são as impressas na placa, não índices 0..7.

### JA

| Conector | Posição | FPGA pin | Uso atual / proposta | Disponível? | Observação elétrica | Estado |
| --- | ---: | --- | --- | --- | --- | --- |
| JA | 1 | C17 | `joystick_sw_n` | Não | LVCMOS33; série 200 Ω | USADO |
| JA | 2 | D18 | VIDEO_AUX_ENABLE (proposta) | Sim no RTL; reserva proposta | LVCMOS33; série 200 Ω | RESERVADO |
| JA | 3 | E18 | VIDEO_SOURCE_SELECT (proposta) | Sim no RTL; reserva proposta | LVCMOS33; série 200 Ω | RESERVADO |
| JA | 4 | G17 | debug/trigger (proposta) | Sim no RTL; reserva proposta | LVCMOS33; série 200 Ω | RESERVADO |
| JA | 5 | — | GND | Não: terra | Referência comum | RESERVADO |
| JA | 6 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
| JA | 7 | D17 | controle auxiliar futuro (proposta) | Sim no RTL; reserva proposta | LVCMOS33; série 200 Ω | RESERVADO |
| JA | 8 | E17 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JA | 9 | F18 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JA | 10 | G18 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JA | 11 | — | GND | Não: terra | Referência comum | RESERVADO |
| JA | 12 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
### JB

| Conector | Posição | FPGA pin | Uso atual / proposta | Disponível? | Observação elétrica | Estado |
| --- | ---: | --- | --- | --- | --- | --- |
| JB | 1 | D14 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 2 | F16 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 3 | G16 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 4 | H14 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 5 | — | GND | Não: terra | Referência comum | RESERVADO |
| JB | 6 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
| JB | 7 | E16 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 8 | F13 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 9 | G13 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 10 | H16 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JB | 11 | — | GND | Não: terra | Referência comum | RESERVADO |
| JB | 12 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
### JC

| Conector | Posição | FPGA pin | Uso atual / proposta | Disponível? | Observação elétrica | Estado |
| --- | ---: | --- | --- | --- | --- | --- |
| JC | 1 | K1 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 2 | F6 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 3 | J2 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 4 | G6 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 5 | — | GND | Não: terra | Referência comum | RESERVADO |
| JC | 6 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
| JC | 7 | E7 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 8 | J3 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 9 | J4 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 10 | E6 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JC | 11 | — | GND | Não: terra | Referência comum | RESERVADO |
| JC | 12 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
### JD

| Conector | Posição | FPGA pin | Uso atual / proposta | Disponível? | Observação elétrica | Estado |
| --- | ---: | --- | --- | --- | --- | --- |
| JD | 1 | H4 | `baro_sda` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 2 | H1 | `baro_scl` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 3 | G1 | `mag_sda` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 4 | G3 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JD | 5 | — | GND | Não: terra | Referência comum | RESERVADO |
| JD | 6 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
| JD | 7 | H2 | `i2c_scl` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 8 | G4 | `i2c_sda` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 9 | G2 | `mag_scl` | Não | LVCMOS33; série 200 Ω | USADO |
| JD | 10 | F3 | Sem função no RTL | Sim no design | LVCMOS33; série 200 Ω | DISPONÍVEL |
| JD | 11 | — | GND | Não: terra | Referência comum | RESERVADO |
| JD | 12 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
### JXADC

| Conector | Posição | FPGA pin | Uso atual / proposta | Disponível? | Observação elétrica | Estado |
| --- | ---: | --- | --- | --- | --- | --- |
| JXADC | 1 | A13 | `vauxp3` | Não | Par analógico; conferir faixa XADC e filtro | USADO |
| JXADC | 2 | A15 | `vauxp10` | Não | Par analógico; conferir faixa XADC e filtro | USADO |
| JXADC | 3 | B16 | Sem função no RTL | Sim no design | Par analógico; conferir faixa XADC e filtro | DISPONÍVEL |
| JXADC | 4 | B18 | Sem função no RTL | Sim no design | Par analógico; conferir faixa XADC e filtro | DISPONÍVEL |
| JXADC | 5 | — | GND | Não: terra | Referência comum | RESERVADO |
| JXADC | 6 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |
| JXADC | 7 | A14 | `vauxn3` | Não | Par analógico; conferir faixa XADC e filtro | USADO |
| JXADC | 8 | A16 | `vauxn10` | Não | Par analógico; conferir faixa XADC e filtro | USADO |
| JXADC | 9 | B17 | Sem função no RTL | Sim no design | Par analógico; conferir faixa XADC e filtro | DISPONÍVEL |
| JXADC | 10 | A18 | Sem função no RTL | Sim no design | Par analógico; conferir faixa XADC e filtro | DISPONÍVEL |
| JXADC | 11 | — | GND | Não: terra | Referência comum | RESERVADO |
| JXADC | 12 | — | VCC 3,3 V | Não: alimentação | Conferir consumo total | RESERVADO |

**Saldo antes das reservas propostas:** JA 7, JB 8, JC 8 e JD 2 sinais digitais livres, total 25. JXADC tem mais quatro contatos não usados, formando dois pares (VAUX2 e VAUX11); eles não entram nesse total digital. **JB e JC são os únicos PMODs digitais inteiramente livres.** JA1 e seis posições de JD permanecem ocupados. JXADC não é recomendado para controle/vídeo enquanto há PMOD digital livre.

### Switches, botões e LEDs

Estes são recursos de interface na placa, não headers para ligar uma fonte externa. Estado DISPONÍVEL significa reutilizável pela lógica como botão, switch ou indicador.

| Recurso / posição | Pino FPGA | IOSTANDARD | Uso atual | Disponível? | Observação elétrica | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| SW[0] | J15 | LVCMOS33 | SW0: NORMAL/DECLUTTER | Não | Recurso onboard | USADO |
| SW[1] | L16 | LVCMOS33 | SW1: ORIGINAL/CAÇA | Não | Recurso onboard | USADO |
| SW[2] | M13 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[3] | R15 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[4] | R17 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[5] | T18 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[6] | U18 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[7] | R13 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[8] | T8 | LVCMOS18 | Sem função no RTL | Sim, como recurso onboard | Banco 34 a 1,8 V; não usar LVCMOS33 | DISPONÍVEL |
| SW[9] | U8 | LVCMOS18 | Sem função no RTL | Sim, como recurso onboard | Banco 34 a 1,8 V; não usar LVCMOS33 | DISPONÍVEL |
| SW[10] | R16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[11] | T13 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| SW[12] | H6 | LVCMOS33 | Fallback pitch −40 px | Não | Recurso onboard | USADO |
| SW[13] | U12 | LVCMOS33 | Fallback pitch +40 px | Não | Recurso onboard | USADO |
| SW[14] | U11 | LVCMOS33 | Fallback roll −64 Q8 | Não | Recurso onboard | USADO |
| SW[15] | V10 | LVCMOS33 | Fallback roll +64 Q8 | Não | Recurso onboard | USADO |
| BTNC | N17 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| BTNU | M18 | LVCMOS33 | Rumo manual +10° | Não | Recurso onboard | USADO |
| BTNL | P17 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| BTNR | M17 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| BTND | P18 | LVCMOS33 | Rumo manual −10° | Não | Recurso onboard | USADO |
| CPU_RESETN | C12 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Botão ativo baixo; não conectado a reset do design | DISPONÍVEL |
| LED[0] | H17 | LVCMOS33 | Diagnóstico joystick: X menos | Não | Recurso onboard | USADO |
| LED[1] | K15 | LVCMOS33 | Diagnóstico joystick: X mais | Não | Recurso onboard | USADO |
| LED[2] | J13 | LVCMOS33 | Diagnóstico joystick: Y menos | Não | Recurso onboard | USADO |
| LED[3] | N14 | LVCMOS33 | Diagnóstico joystick: Y mais | Não | Recurso onboard | USADO |
| LED[4] | R18 | LVCMOS33 | Status da conversão BMP085 | Não | Recurso onboard | USADO |
| LED[5] | V17 | LVCMOS33 | HMC identificado/configurado | Não | Recurso onboard | USADO |
| LED[6] | U17 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[7] | U16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[8] | V16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[9] | T15 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[10] | U14 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[11] | T16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[12] | V15 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[13] | V14 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[14] | V12 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED[15] | V11 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | Recurso onboard | DISPONÍVEL |
| LED16_R | N15 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |
| LED16_G | M16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |
| LED16_B | R12 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |
| LED17_R | N16 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |
| LED17_G | R11 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |
| LED17_B | G14 | LVCMOS33 | Sem função no RTL | Sim, como recurso onboard | LED RGB onboard; seguir limite de PWM do manual | DISPONÍVEL |

### Outros recursos acessíveis

| Recurso | Pinos FPGA / interface | Uso atual e disponibilidade | Estado |
| --- | --- | --- | --- |
| USB-UART onboard | C4: RX da FPGA (`UART_TXD_IN`); D4: TX da FPGA (`UART_RXD_OUT`); D3/E5: handshake | Livre para implementar UART pela ponte USB existente; não é GPIO externo solto | RESERVADO |
| Display de sete segmentos | CA..CG/DP: T10, R10, K16, K13, P15, T11, L18, H15; AN0..7: J17, J18, T9, J14, P14, T14, K2, U13 | Livre como display; pinos ligados aos circuitos onboard | DISPONÍVEL |
| MicroSD J1 | E2, A1, B1, C1, C2, E1, F1, D2 | Sem controlador neste projeto; compartilhamento com circuito de configuração exige projeto próprio | POSSÍVEL CONFLITO |
| USB HID | F4/B2 no lado FPGA/PIC24 | Porta dedicada; não conectar GPIO aos contatos USB | RESERVADO |
| Ethernet | PHY/RMII onboard | Sem controlador; pinos conectados ao PHY, não livres para headers | RESERVADO |
| DDR2 / QSPI | Memórias onboard e sinais dedicados de configuração | DDR2 candidata a framebuffer via controlador; QSPI exige respeito ao boot | RESERVADO |
| Acelerômetro, temperatura, microfone e áudio onboard | Interfaces próprias no Master XDC/esquemático | Não usados pelo HUD; reutilizar apenas como periféricos, não como GPIO livre | RESERVADO |
| USB-JTAG / header JTAG / PIC24 de programação | Interface de configuração | Não reservar para controle de vídeo | RESERVADO |
| VGA analógico externo | Nenhum pino de entrada RGB no design | Requer front-end de captura ou compositor analógico externo | NECESSITA HARDWARE EXTERNO |

### Melhor GPIO disponível para novas funções

| Proposta | Escolha | Motivo e condição |
| --- | --- | --- |
| VIDEO_AUX_ENABLE | **JA2 / D18 / LVCMOS33** | Livre no XDC e no Master, ao lado do botão em JA1, sem usar sensores ou JXADC. Entrada digital estática; sincronizador e nível definido no futuro. |
| VIDEO_SOURCE_SELECT | JA3 / E18 / LVCMOS33 | Mesmo conector; reserva apenas documental. |
| Debug / trigger | JA4 / G17 | Permite pulso para analisador lógico; não confundir com clock dedicado. |
| Controle futuro | JA7 / D17 | Mantém JB/JC inteiros para eventual barramento digital de vídeo. |
| Pixel clock externo, se adotado | JB3 / G16 (MRCC no Master) | Candidato de clock dedicado; confirmar alcance de clock, banco, integridade e constraints antes da implementação. |
| Logger UART | Ponte USB existente, C4/D4 | Evita consumir PMOD; nomes do Master são vistos do lado da ponte. |

Essas reservas **não foram adicionadas ao top nem ao XDC**. Não basta conectar um fio para habilitar a função. Conferir a ocupação física de JA2 antes de montar. VIDEO_AUX_ENABLE é um comando lógico; não transporta R/G/B e não captura VGA.

## Conflitos e limites encontrados

- Nenhuma colisão entre os 40 pinos ativos. As linhas comentadas de JA/JD no XDC não representam reservas efetivas.
- JA1/C17 já pertence ao botão KY-023. Não reutilizar como enable de vídeo.
- JD1/2/3/7/8/9 estão ocupados. Apenas JD4/G3 e JD10/F3 sobram no conector.
- SW8/T8 e SW9/U8 exigem LVCMOS18, conforme Master e esquema; não copiar LVCMOS33 de outros switches.
- JXADC1/7 e 2/8 estão ocupados pelo joystick. Condicionar os eixos à faixa analógica; a configuração unipolar não equivale a uma entrada digital de 3,3 V.
- Os conectores VGA, USB, Ethernet, SD e memória têm circuitos dedicados. Ausência no top não os torna GPIO livre.
- Posição dos cabos, alimentação dos breakouts e pinagem do módulo físico: **PENDENTE DE VALIDAÇÃO FÍSICA**.
