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
