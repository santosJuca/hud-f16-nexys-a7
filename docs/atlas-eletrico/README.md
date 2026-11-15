# Atlas elétrico do HUD FPGA

> O atlas, o XDC da base v1.1 e o XDC 5D7A3AE2 mapeiam o buzzer para JD4/G3. Registros de outubro com JC10/E6 são históricos. Confira sempre o XDC do [perfil escolhido](../../README.md#versões-e-evidências) antes de usar as pranchas.

Quatro pranchas de referência para a Nexys A7-100T, com o mapeamento de sensores,
joystick e buzzer. A prancha do buzzer representa controle em JD4, alimentação em
JC12 (3,3 V) e GND em JC11. A [descrição da montagem](../montagem.md) registra o
que foi confirmado na bancada.

[PDF vetorial para impressão](atlas-eletrico-hud-nexys-a7.pdf)

| Prancha | Imagem | Vetor editável |
| --- | --- | --- |
| 01. Visão geral das conexões | [PNG](01-visao-geral.png) | [SVG](01-visao-geral.svg) |
| 02. Sensores | [PNG](02-sensores.png) | [SVG](02-sensores.svg) |
| 03. Joystick e XADC | [PNG](03-joystick-xadc.png) | [SVG](03-joystick-xadc.svg) |
| 04. Buzzer e driver NPN | [PNG](04-buzzer.png) | [SVG](04-buzzer.svg) |

![Visão geral das conexões](01-visao-geral.png)

![Sensores](02-sensores.png)

![Joystick e XADC](03-joystick-xadc.png)

![Buzzer e driver NPN](04-buzzer.png)

A visão geral apresenta os conectores em ordem funcional, sem indicar sua posição física na placa. A prancha do buzzer mostra os conectores JD e JC em vista frontal de encaixe, com os pinos utilizados em destaque.

Conferir a compatibilidade de alimentação e os pull-ups dos módulos antes de energizar. Identificar as pernas B/C/E do 2N2222A pelo datasheet do fabricante.

Referência: [manual oficial da Digilent, figura 10.1](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf#page=25).
