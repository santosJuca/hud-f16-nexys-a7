# Sensores e entradas externas

Este documento descreve as conexões do top atual, conferidas em `rtl/top_reticula.sv` e `constraints/nexys_a7_reticula.xdc`. A existência de driver e simulação não comprova o funcionamento elétrico da montagem.

| Dispositivo | Conexão atual | Uso no HUD | Limites conhecidos |
| --- | --- | --- | --- |
| MPU-6050 | I²C independente: SDA JD8/G4, SCL JD7/H2 | Accel/gyro para atitude, gyro Z e entradas da estimação vertical | A cadeia de leitura, validade, calibração e fusão tem testes RTL; integração física da versão atual pendente |
| BMP085 | I²C independente: SDA JD1/H4, SCL JD2/H1 | Temperatura/pressão compensadas e altitude barométrica | Verificação de identificação e cálculos em simulação; funcionamento físico atual pendente |
| HMC5883L | I²C independente: SDA JD3/G1, SCL JD9/G2 | Rumo magnético planar combinado com gyro Z | Sem compensação de inclinação/declinação; calibração e orientação física pendentes |
| KY-023 | Eixos em VAUX3 e VAUX10 via JXADC; botão em JA1/C17 | Movimento da mira em CAÇA e LOCK/UNLOCK | Centro calibrado na inicialização; orientação, faixa analógica e estabilidade aguardam bancada |

## Alimentação e níveis

O XDC especifica `LVCMOS33` para sinais digitais e configura pull-up interno em SDA/SCL do HMC e na entrada do botão do joystick. O BMP e o MPU não têm pull-up indicado no XDC. Verifique a placa breakout, seus reguladores, pull-ups e tensão de sinal antes de conectar. Use terra comum. Não derive a tensão efetiva do módulo apenas do `IOSTANDARD`.

Os dois eixos do KY-023 usam pares diferenciais de canais auxiliares XADC: VAUX3 (JXADC1/7, A13/A14) e VAUX10 (JXADC2/8, A15/A16). A faixa analógica permitida depende da configuração e do dispositivo FPGA; a montagem elétrica precisa respeitá-la. O stub de simulação não valida o ADC físico.

## Seleção e fallback

No top operacional, a atitude principal vem da cadeia MPU quando sua validade permite; SW12–SW15 fornecem fallback de bancada em VOO/POUSO quando a atitude MPU não está selecionada. O heading tem caminho magnético fusionado e ajuste manual por BTNU/BTND; a seleção por modo/validade é implementada na política operacional. Em SOLO, um fallback não deve ser interpretado como leitura de sensor.

VOO e POUSO também simulam grandezas de voo conforme a política operacional; isso não transforma sensores simulados em dados físicos. O heading do HMC é magnético/plano, sem compensação de inclinação ou declinação. A velocidade inercial experimental não é selecionada como velocidade operacional nem mede velocidade no ar.

## Validação pendente

Na bancada, confirmar cada barramento, identificação, leituras em repouso e movimento conhecido, desconexão e recuperação. Registrar orientação dos eixos, faixa observada do joystick, estabilidade do centro e tensão da montagem. LEDs LD4/LD5 informam estados de diagnóstico definidos no RTL, não precisão ou calibração completa.
