# Sensores e entradas externas

Este documento descreve as conexões do top atual, conferidas em `rtl/top_reticula.sv` e `constraints/nexys_a7_reticula.xdc`. A existência de driver e simulação não comprova o funcionamento elétrico da montagem.

| Dispositivo | Conexão atual | Uso no HUD | Limites conhecidos |
| --- | --- | --- | --- |
| MPU-6050 | I²C independente: SDA JD8/G4, SCL JD7/H2 | Accel/gyro para atitude, gyro Z e entradas da estimação vertical | Testes RTL e relato de 13/10: LD4 aceso, ATT BAD ausente e inclinações corretas; precisão não medida |
| BMP085 | I²C independente: SDA JD1/H4, SCL JD2/H1 | Temperatura/pressão compensadas e altitude barométrica | Identificação/cálculos em simulação; LD5 aceso e ALT BAD ausente relatados em 13/10; altitude absoluta não caracterizada |
| HMC5883L | I²C independente: SDA JD3/G1, SCL JD9/G2 | Rumo magnético planar combinado com gyro Z | LD6 aceso e rumo respondendo à rotação relatados em 13/10; sem compensação de inclinação/declinação e precisão não medida |
| KY-023 | Eixos em VAUX3 e VAUX10 via JXADC; botão em JA1/C17 | Movimento da mira em CAÇA e LOCK/UNLOCK | Função relatada em 13/10; teste posterior com resistores de 27 kΩ relatou leituras acima de 1 V. Topologia/valores finais não documentados; faixa elétrica não validada |

## Atitude e calibração atuais

`FULL_ATTITUDE=1` seleciona o estimador vetorial e CORDIC; a cadeia complementar anterior permanece por parâmetro. A v1.1 tem relato físico de horizonte acompanhando MPU e desaparecimento de ATT BAD após calibração. Zero automático e SW7 em captura não dispensam estabilidade do sensor; não tratar ausência de validade como ângulo medido.

A calibração HMC de 31/10 usa offsets X=717/Y=-161 e ganhos Q12 X=4545/Y=3727 em `constraints/magnetometer_calibration.tcl`. Os parâmetros de orientação do perfil ensaiado estão em `scripts/build_attitude_capture.tcl`. São específicos da montagem; a calibração de 19/10 é histórica, não deve sobrescrever o perfil posterior. A leitura continua planar.

## Alimentação e níveis

O XDC especifica `LVCMOS33` para sinais digitais e configura pull-up interno em SDA/SCL do HMC e na entrada do botão do joystick. O BMP e o MPU não têm pull-up indicado no XDC. Verifique a placa breakout, seus reguladores, pull-ups e tensão de sinal antes de conectar. Use terra comum. Não derive a tensão efetiva do módulo apenas do `IOSTANDARD`.

Os dois eixos do KY-023 usam pares diferenciais de canais auxiliares XADC: VAUX3 (JXADC1/7, A13/A14) e VAUX10 (JXADC2/8, A15/A16). O top configura conversão unipolar, nominalmente 0–1 V. Foi relatado valor superior a 1 V em testes com resistores de 27 kΩ, sem registro da topologia completa ou dos pontos exatos de medição. Não conectar a rede ao XADC até confirmar os divisores e medir a tensão em JXADC1/JXADC2. A resistência de fonte também pode afetar o tempo de aquisição do conversor. O stub de simulação não valida o ADC físico.

## Seleção e fallback

SW15..SW12=`1111` seleciona a atitude MPU se SW9 estiver desligado; os demais estados selecionam comandos manuais em qualquer modo. SW9 ligado força o modo manual e desativa o processamento da cadeia MPU. SW10 e SW11 desativam o uso do barômetro e magnetômetro; os drivers seguem consultando os sensores. Atitude manual não deve ser interpretada como leitura física. O heading também dispõe de ajuste manual por BTNU/BTND.

VOO e POUSO também simulam grandezas de voo conforme a política operacional; isso não transforma sensores simulados em dados físicos. O heading do HMC é magnético/plano, sem compensação de inclinação ou declinação. A velocidade inercial experimental não é selecionada como velocidade operacional nem mede velocidade no ar.

## Validação pendente

Na bancada, confirmar cada barramento, identificação, leituras em repouso e movimento conhecido, desconexão e recuperação. Registrar orientação dos eixos, faixa observada do joystick, estabilidade do centro e tensão da montagem. LEDs LD4/LD5 informam estados de diagnóstico definidos no RTL, não precisão ou calibração completa.

## microSD e buzzer

SDHC SPI com CMD17, CRC16 e retries usa o leitor onboard; o perfil físico histórico é 160×120, solicitação de 1 FPS e half-period 125. A temporização elétrica SPI não está integralmente qualificada. O buzzer sai em JD4/G3 para estágio transistorizado externo. Não programar hardware ou alterar a fiação com base apenas na aprovação dos testes RTL.
