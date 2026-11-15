# Caixa manual com o MPU6050 existente

Este documento é uma proposta de montagem e um roteiro de validação. Nenhuma conexão foi alterada. Não é necessário comprar outro sensor para experimentar a caixa. A transferência física do módulo para a caixa depende da autorização do usuário.

## Orientação e fixação

Marque FRENTE, DIREITA e CIMA na caixa. O referencial usado pelo RTL, baseado nas observações históricas da montagem, exige +Y do sensor para frente, +X para direita e +Z para cima. Confirme as setas dos eixos do módulo real e a identidade do componente antes de fixar; não use a posição dos conectores como definição de eixo.

Fixe rigidamente o módulo em espaçadores isolantes, usando seus furos, sem flexionar a placa nem pressionar componentes. Evite que a placa possa girar ou vibrar dentro da caixa. Mantenha o sensor próximo ao centro de rotação e ao ponto de apoio da mão para reduzir aceleração por translação. A caixa deve permitir roll até invertido sem o cabo prender ou arrastar a Nexys.

Um suporte com base plana e uma marca central facilita retornar ao nível. Um berço mecânico com dois eixos é opcional; a caixa pode ser movimentada livremente. Não há mecanismo motorizado nesta etapa.

## Conexões propostas, preservando o XDC

| Sinal | Nexys A7 atual | Destino |
|---|---|---|
| SDA | JD8, FPGA G4 | SDA do módulo existente |
| SCL | JD7, FPGA H2 | SCL do módulo existente |
| Terra | GND Pmod, verificar posição física | GND do módulo |
| Alimentação | Preservar alimentação atual verificada | Pino de alimentação correto do módulo |

O [manual oficial Digilent](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf) especifica alimentação Pmod de 3,3 V e sinais de expansão nessa tensão. O [mapa do MPU6050](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf) deve ser usado junto do datasheet/esquemático do breakout real. GY-521 e módulos compatíveis podem incluir regulador e pull-ups com ligações diferentes. Não assumir que o pino VCC de qualquer breakout aceita a mesma alimentação diretamente.

Antes de energizar uma montagem transferida: placa desligada, identificar VCC/GND e o breakout, conferir continuidade e ausência de curto, confirmar tensão de alimentação e medir a tensão de repouso de SDA/SCL. Nenhum pull-up pode levar 5 V aos pinos FPGA. Não alimentar o sensor por uma saída lógica. Não ligar duas fontes de alimentação em paralelo.

Comece com o menor cabo que permita o movimento, por exemplo 15 a 20 cm como ensaio inicial, sem tratar esse comprimento como especificação garantida de I2C. Organize SDA junto de GND e SCL junto de GND, afastados do buzzer, fontes chaveadas e cabos de potência. Mantenha terra comum, conectores firmes e desacoplamento do módulo. Confira os pull-ups já instalados antes de adicionar resistores: associações em paralelo podem exigir corrente excessiva.

Faça alívio de tração na caixa e perto do suporte da Nexys, deixando uma curva de folga para a rotação. Não transmita força aos pinos Pmod nem ao módulo. Não deixe soldas expostas, peças metálicas soltas ou cabos passar por quinas. A PCB não deve tocar a parede condutora de uma caixa metálica.

Se for preciso cabo maior, medir capacitância e tempos de subida/descida de SDA/SCL com osciloscópio na configuração real, conferir ACK e recuperação, antes de considerar a extensão aprovada. Esta implementação não altera frequência I2C, pull-ups ou pinagem para mascarar problemas de cabo.

## Validação física assistida

Esta etapa exige um build experimental identificado e programação volátil autorizada separadamente. Não usar um bitstream antigo como prova do RTL novo. Foi gerado somente o bitstream experimental identificado no relatório de resultados. Sua existência não aprova o SPI externo nem autoriza programar a placa.

1. Com a alimentação desligada, inspecione a montagem e as conexões acima. Mantenha o baseline e as evidências de recuperação disponíveis.
2. Com a caixa nivelada e parada desde a inicialização, selecione SW9=0 e SW15..SW12=1111. Aguarde calibração e atitude válidas. Falta de calibração exige investigar orientação, repouso e bias, sem forçar offsets.
3. Incline a asa direita: roll deve ser positivo e o horizonte deve girar à esquerda. Incline a asa esquerda: sinais opostos. Levante o nariz: pitch positivo e horizonte para baixo ao longo da normal; abaixe: oposto.
4. Use uma referência angular independente (esquadro, transferidor ou suporte graduado) em 0, ±15, ±30, ±45, ±60, ±90, ±120 e ±180°. Não atribua precisão à estimativa pela posição da mão.
5. Faça pitch 0, ±5, ±10, ±15 e ±20°, e os cinco pares combinados do pedido. Em ±90° de bank, o pitch deve deslocar o horizonte horizontalmente, não continuar preso à vertical da tela.
6. Faça 0→90→0, 90→-90 e 0→180 devagar e continuamente. A referência central permanece fixa; a linha não para em 26°. Não exceda ±250°/s do gyro.
7. Retorne ao nível dez vezes, registrando RAW/COR, referência angular, tempo de estabilização e deriva. Se desejar ajustar o zero, espere o bit de repouso e solicite SW7 somente próximo do nível.
8. Congele o vídeo, mova a caixa e confira a estabilidade de pixels do fundo. Avance quadro a quadro, confirme o contador e compare as quatro vistas. Retome o vídeo e observe vários loops sem corrupção.
9. Confira estilos, declutter, joystick, alertas, heading, BMP085, HMC5883L e diagnóstico microSD. Registre a identificação do build, do vídeo e a tensão/fiação empregada.

A aceitação física deve registrar sentido correto, continuidade, retorno ao zero, estabilidade do vídeo e eventual latência visível. Não há validação física automática nesta entrega. O conjunto é um demonstrador de bancada; os testes não o qualificam como instrumento para navegação ou operação de aeronave.
