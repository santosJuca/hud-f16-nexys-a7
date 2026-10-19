# Calibração HMC5883L em 19/10/2026

Coleta via JTAG de 882 amostras válidas durante aproximadamente 90 segundos, com o sensor fixado e o conjunto apoiado. O operador confirmou que a primeira coleta teve inclinação; ela foi descartada. A segunda cobriu todos os setores de 30° e apresentou trajetória X/Y aproximadamente circular. Isso permite estimar offsets e escala; não comprova precisão absoluta do rumo.

| Eixo | Mínimo | Máximo | Offset calculado | Offset aplicado | Ganho Q12 |
| --- | ---: | ---: | ---: | ---: | ---: |
| X | -186 | 171 | -7,5 | -8 | 3935 |
| Y | -312 | 17 | -147,5 | -148 | 4270 |

O offset é `(máximo + mínimo) / 2`. A amplitude é `(máximo - mínimo) / 2`; o ganho é a média das amplitudes dividida pela amplitude do eixo. Os ganhos são positivos, quantizados em Q12, com 4096 representando 1. A correção subtrai o offset e aplica a escala antes da troca/inversão dos eixos e do cálculo angular. Os eixos não foram invertidos nesta calibração.

O perfil físico está em `constraints/magnetometer_calibration.tcl`, carregado por `scripts/build_vivado.tcl`. Os defaults dos módulos RTL permanecem neutros. Outros fluxos de compilação precisam aplicar explicitamente os mesmos parâmetros. Este perfil é específico desta montagem e precisa ser reavaliado ao mover o sensor ou alterar materiais próximos.

O cálculo continua plano, sem compensação de inclinação e sem declinação para norte geográfico. Antes de comparar com celular, conferir se ele apresenta norte magnético ou geográfico. A diferença de referência não é um offset de calibração do sensor.

Fontes: [datasheet Honeywell HMC5883L](https://cdn.sparkfun.com/datasheets/Sensors/Magneto/HMC5883L-FDS.pdf), [AN-203: rumo](https://cdn-shop.adafruit.com/datasheets/AN203_Compass_Heading_Using_Magnetometers.pdf) e [AN-214: procedimento geral de calibração por extremos](https://prod-edam.honeywell.com/content/dam/honeywell-edam/aero/en-us/products/navigation-and-sensors/sensors/small-size-axis-analog-magnetic-sensors/documents/hon-aero-an214-reference-design-low-cost-compass-en.pdf). A AN-214 usa outro sensor Honeywell; aproveita-se o procedimento de calibração, não o circuito analógico.

O operador confirmou em 19/10/2026 que a indicação corrigida ficou próxima da referência real, com precisão ainda aproximada. Não houve ensaio instrumental de erro angular.

Síntese, implementação e bitstream aprovados no Vivado 2026.1: WNS +0,326 ns, WHS +0,020 ns e zero erros de DRC. Programação JTAG confirmada. SHA256 do bitstream validado: `16bb1d1c4fdee04c6dde4d9b5a1134a9e510beb79be5d75c69df4d359d1a9cf6`.

Os testes `tb_heading_magnetico` (1.382 vetores em seis configurações), `tb_heading_fusao` (124 verificações), `tb_top_heading` e `tb_hmc5883l_i2c` passaram. A regressão completa de 62 testes também passou. A confirmação física acima foi realizada após programação JTAG.
