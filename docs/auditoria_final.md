# Auditoria Final — HUD Aeronáutico em FPGA

## 1. Identificação

- Projeto: Display de avião / HUD acadêmico
- Placa: Nexys A7-100T
- FPGA: Artix-7 `xc7a100tcsg324-1`
- Linguagem: SystemVerilog
- Vivado: 2026.1
- VGA: 640x480
- Clock do sistema: 100 MHz
- Clock de pixel: 25 MHz
- Atualização VGA: aproximadamente 59,52 Hz
- Data da consolidação: 03/10/2026
- Branch validada: `fix/roll-horizonte-aeronautico`
- Commit funcional: `7ccf8be`

## 2. Resultado dos requisitos funcionais

| Requisito | Resultado | Evidência principal |
|---|---|---|
| RF-01 | PASS | HSYNC, VSYNC e `video_on` em `vga_controller.sv` |
| RF-02 | PASS | Coordenadas `pixel_x` e `pixel_y` |
| RF-03 | PASS | Retículo central em `reticula_vga.sv` |
| RF-04 | PASS | Horizonte artificial com pitch e roll |
| RF-05 | PASS | Escala vertical de altitude |
| RF-06 | PASS | Indicador de direção/heading |
| RF-07 | PASS | Marcador gráfico de alvo |
| RF-08 | PASS | Modos NORMAL e DECLUTTER |
| RF-09 | PASS | Atualização contínua e CDC entre 100 e 25 MHz |
| RF-10 | PASS | Simbologia limitada à região ativa |

**Resultado final: 10/10 requisitos funcionais atendidos.**

## 3. VGA e retículo

A saída VGA utiliza:

- 640 pixels visíveis;
- 16 pixels de front porch;
- 96 pixels de sincronismo;
- 48 pixels de back porch;
- total horizontal de 800 pixels;
- 480 linhas visíveis;
- 10 linhas de front porch;
- 2 linhas de sincronismo;
- 33 linhas de back porch;
- total vertical de 525 linhas.

O teste VGA confirmou:

- 420000 posições por quadro;
- 307200 pixels ativos;
- HSYNC de 96 pixels por linha;
- VSYNC de 2 linhas;
- período de pixel de 40 ns.

O retículo permanece fixo no centro da tela em aproximadamente `(320,240)`.

Ele deve ser descrito como uma referência fixa da aeronave, simplificada como
um Aircraft Reference Symbol ou boresight.

Ele não representa Flight Path Marker, Flight Path Vector ou sistema de mira.
63
## 4. Atitude e horizonte artificial

A atitude pode ser obtida pelo MPU-6050, mantendo joystick e switches como fallback manual.

A cadeia principal utiliza acelerômetro e giroscópio do MPU-6050, passando pelos módulos atitude_accel_fixa, gyro_bias_dt, gyro_integrador, atitude_fusao_complementar e atitude_gyro_hud até chegar à simbologia do HUD.

A convenção física validada é:
- nariz sobe -> horizonte desce;
- nariz desce -> horizonte sobe;
- direita da aeronave para baixo -> roll positivo;
- esquerda da aeronave para baixo -> roll negativo.

O horizonte representa uma referência estabilizada no mundo e contrarrota em relação ao banco da aeronave:
- banco para direita -> horizonte sobe para a direita (/);
- banco para esquerda -> horizonte desce para a direita (\).

A correção foi consolidada no commit 7ccf8be.

O teste tb_roll apresentou:
PASS roll: horizonte contrarrota nos dois sentidos e escala fixa.

O comportamento também foi validado fisicamente na FPGA.

## 5. MPU-6050

O driver rtl/mpu6050_i2c.sv realiza identificação do dispositivo, wake-up, configuração do acelerômetro e giroscópio, aquisição dos seis eixos, tratamento de ACK/NACK, clock stretching, timeout e recuperação de falhas.

Configuração utilizada:
- acelerômetro: +/-2 g;
- giroscópio: +/-250 graus/s.

O valor padrão esperado de WHO_AM_I para MPU-6050 é 0x68. O projeto também aceita 0x70 como caminho de compatibilidade observado e testado.

## 6. Entradas e modos

A combinação SW15..SW12 = 1111 seleciona o caminho do MPU quando sensor, calibração e fusão estão válidos.

Caso contrário, permanecem os fallbacks por joystick e switches.

O joystick KY-023 é lido por entradas analógicas do XADC.

Os modos gráficos são:
- SW0 = 0 -> NORMAL;
- SW0 = 1 -> DECLUTTER.

A mudança de modo é sincronizada entre quadros.

## 7. Regressão

Foi executado bash scripts/test.sh.

Resultado:
TODOS OS TESTES PASSARAM.

A regressão consolidada inclui 19 grupos de testes:
reticula, controle_heading, controle_joystick, horizonte, atitude, atitude_accel_fixa, gyro_bias_dt, gyro_integrador, atitude_gyro_hud, atitude_fusao_complementar, entrada_hud, dados_hud, numeros, roll, modo, modos, top_atitude, vga e mpu6050_i2c.

Os avisos do Icarus relacionados a constant selects in always_* não causaram falhas de teste e não impediram a implementação no Vivado.

## 8. Implementação física e timing

A implementação final apresentou:
- WNS = +0.414 ns;
- TNS = 0.000 ns;
- WHS = +0.105 ns;
- THS = 0.000 ns.

Status final do roteamento:
- Failed nets = 0;
- Unrouted nets = 0;
- Partially routed nets = 0;
- Node overlaps = 0.

O roteamento terminou com sucesso.

O DRC utilizado antes da geração do bitstream apresentou 0 Errors.

O warning Power 33-332 pertence à estimativa vector-less de potência e não representa falha funcional ou violação de timing.

## 9. Bitstream final

Arquivo:
build/vivado/reticula.runs/impl_1/top_reticula.bit

Tamanho aproximado:
3.7 MB

SHA-256:
732634a3dac00efbfeaa1217f0981edc4a896a11830379de32cdd8d28914fdf6

A geração terminou com Bitgen Completed Successfully.

A programação física terminou com PROGRAM_DONE=1.

## 10. Elementos simulados

Alguns dados continuam propositalmente simulados:
- velocidade: 280 KT;
- altitude: 36000 FT;
- heading: controle manual;
- alvo: posição gráfica fixa.

O projeto não implementa radar, target lock real, GPS, Flight Path Vector calculado, sistema de armas, framebuffer ou certificação aeronáutica.

## 11. Extensões além do MVP

Foram acrescentados MPU-6050 real, acelerômetro, giroscópio, calibração de bias, medição de tempo entre amostras, integração angular, fusão complementar, joystick analógico via XADC, fallback de atitude, recuperação de erros I2C e testbenches específicos dos sensores.

Esses recursos são extensões acadêmicas e não substituem os requisitos obrigatórios RF-01 a RF-10.

## 12. Conclusão

O projeto atende aos dez requisitos funcionais definidos para o trabalho.

A regressão completa passa.

A implementação fecha timing de setup e hold.

O roteamento não apresenta nets pendentes.

O DRC não apresenta erros impeditivos.

O bitstream foi gerado e programado com sucesso.

Pitch e roll foram validados fisicamente.

A representação final do roll contrarrota o horizonte em relação ao banco da aeronave, mantendo o retículo central fixo.

Com base em RTL, simulação, implementação Vivado e validação física, esta versão é considerada adequada para congelamento do RTL e preparação da entrega acadêmica.
