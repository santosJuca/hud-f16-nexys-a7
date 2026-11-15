# HUD FPGA v1.0: Autonomous Boot

Versão funcional estável da Nexys A7-100T com vídeo F-16
por microSD, HUD VGA, MPU6050 e zeragem automática.

## Validação física

Em 31/10/2026, o usuário confirmou funcionamento do
HUD após desligar e religar a FPGA, inicializando pela
flash QSPI, sem necessidade de programação JTAG.

A zeragem do horizonte ocorre automaticamente.

## Artefatos oficiais

Bitstream SHA-256:

58d71e7435640e3675e872dff2723aa263d33da523ed323867e03885b9e3474d

Imagem QSPI SPIx1 SHA-256:

cf8714e5c5bf671efb59c6c5e177109ef3aa63aa30af6e98c2a8db8492fb7176

## Qualificação Vivado 2026.1

- WNS: +0.315 ns
- WHS: +0.020 ns
- WPWS: +4.020 ns
- Roteamento: zero erros
- CDC: zero unsafe/unknown nos cruzamentos classificados
- Regressão RTL integrada: PASS

Persistem advertências de temporização externa de I/O,
portanto esta versão não representa homologação elétrica
integral das interfaces externas.

## Preservação

Os backups de recuperação QSPI são mantidos fora do Git.
A gravação permanente da flash exige procedimento próprio
e confirmação explícita.

O manifesto hud-v1.0-source-hashes.sha256 documenta
a identidade dos fontes da versão fisicamente validada.
