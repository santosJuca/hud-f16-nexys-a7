# Conclusão e Trabalhos Futuros

**Escopo:** HUD aeronáutico acadêmico em FPGA Nexys A7-100T, revisão `4107002`, evidências consolidadas até 21/10/2026.

## Conclusão

Este trabalho apresentou o desenvolvimento e a implementação de um *Head-Up Display* (HUD) aeronáutico em FPGA, utilizando a plataforma Digilent Nexys A7-100T, equipada com o dispositivo AMD/Xilinx Artix-7 XC7A100TCSG324-1. O sistema foi desenvolvido predominantemente em SystemVerilog e compreende geração de vídeo, aquisição de sensores, processamento digital, sincronização de dados e controle gráfico e operacional.

A arquitetura produz diretamente vídeo VGA de 640 × 480 pixels, contendo referências visuais de atitude, rumo e altitude. O projeto inclui apresentação convencional e CAÇA, opção DECLUTTER e modos operacionais SOLO, VOO e POUSO. Estes dois últimos utilizam cenários didáticos de voo; não se trata de instrumentação aeronáutica certificada.

Os sensores MPU6050, BMP085 e HMC5883L fornecem informações relacionadas à atitude, pressão atmosférica e campo magnético. O joystick KY-023 permite o controle do marcador móvel, enquanto o buzzer ativo participa da sinalização dos alertas.

A verificação digital incluiu regressão de 62 casos automatizados, aprovada no GitHub Actions diretamente no commit `4107002`, além de implementação histórica no Vivado 2026.1. Na implementação calibrada de 19/10/2026, os relatórios registram WNS de +0,326 ns, WHS de +0,020 ns, TNS e THS de 0 ns para as restrições analisadas. O manifesto do build foi comparado ao checkout de referência, com correspondência de 51/51 hashes SHA-256. O bitstream preservado foi identificado por hash; a reprodução independente da implementação e a identificação direta da configuração atualmente carregada continuam fora do escopo comprovado.

A bancada virtual em Linux, baseada em Verilator, C++ e GTKmm, permitiu visualizar o vídeo gerado pelo RTL e operar os modos. Em 21/10/2026, o operador observou a saída VGA e os modos funcionais, resposta do MPU6050 em pitch e roll, variação de rumo no HMC5883L, estabilidade visual da altitude do BMP085 e funcionamento do joystick e do buzzer.

Essas observações demonstram integração funcional básica, mas não substituem caracterização metrológica dos sensores, medições elétricas do XADC ou ensaios quantitativos dos alertas. Conclui-se que o projeto atingiu seu propósito acadêmico de integração de interfaces, lógica sequencial e combinacional, processamento em ponto fixo, transferência entre domínios de clock e renderização VGA, com evidências digitais e físicas claramente delimitadas.

## Trabalhos futuros

| Prioridade | Atividade | Objetivo |
| --- | --- | --- |
| P0 | Reprodução independente do build da revisão `4107002` | Confrontar fontes, calibração, toolchain, relatórios e novo artefato; não presumir hash binário idêntico |
| P0 | Caracterização elétrica do XADC e interfaces | Medir faixa efetiva, divisores, referência, pull-ups e estágio do buzzer |
| P1 | Calibração quantitativa dos sensores | Determinar erro absoluto, repetibilidade e estabilidade |
| P1 | Ensaios específicos de alertas | Validar limiares, histerese, prioridade e cadências |
| P1 | Evolução controlada da bancada virtual | Emulação adicional e cenários de falhas reproduzíveis |
| P2 | Sobreposição VGA externa | Estudar sincronismo e composição com hardware adicional |
| P2 | Gabinete de proteção | Organizar sensores e preservar acesso a switches e conectores |

Esses itens não são apresentados como funcionalidades concluídas.

## Referências de implementação e documentação

1. [Digilent, Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual).
2. [Digilent, Nexys A7-100T Master XDC](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc).
3. [AMD, UG480: 7 Series FPGAs and Zynq-7000 SoC XADC](https://docs.amd.com/r/en-US/ug480_7Series_XADC).
4. [AMD, UG906: Vivado Design Analysis and Closure Techniques](https://docs.amd.com/r/en-US/ug906-vivado-design-analysis).
5. [TDK InvenSense, MPU-6000/MPU-6050 Product Specification](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Datasheet.pdf).
6. [Bosch Sensortec, BMP085 Data Sheet, cópia técnica](https://www.mysensors.org/dl/57c41ff6071cb0e34c90057d/design/BST-BMP085-DS000-05.pdf).
7. [Honeywell, HMC5883L Data Sheet, espelho SparkFun](https://cdn.sparkfun.com/datasheets/Sensors/Magneto/HMC5883L-FDS.pdf).
8. [Validação e rastreabilidade de 21/10](validacao_e_rastreabilidade_20261021.md), [arquitetura e montagem](arquitetura_e_montagem_20261021.md), [simulador virtual](simulador_vgasim_20261021.md), [calibração HMC5883L](calibracao_hmc5883l_20261019/README.md) e [relatórios do bitstream calibrado](../bitstreams/2026-10-19_mag_calibrado/README.md).

As referências internas registram o contexto exato de cada artefato. Ilustrações de montagem e capturas experimentais devem ser identificadas com sua origem e data, sem apresentar desenhos didáticos como fotografias ou medições.
