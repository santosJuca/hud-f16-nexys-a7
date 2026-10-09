# Testes e validação

O script [`scripts/test.sh`](../scripts/test.sh) contém 55 entradas de regressão e executa Icarus Verilog (`iverilog` e `vvp`). Ele compila cada testbench contra os módulos de `rtl/*.sv` e `tests/xadc_stub.sv`.

```sh
./scripts/test.sh
```

O script cria/substitui executáveis em `build/tests/`. Preserve qualquer artefato existente nesse diretório ou execute a regressão a partir de uma cópia de trabalho isolada.

## Cobertura declarada pelo conjunto atual

Os casos incluem modos e simuladores, mira/joystick, alertas e ACK, heading/fusão/controle manual, atitude e sua fusão, estimativa vertical, VGA e sincronização dos dados do HUD, além dos drivers e cálculos do BMP085, HMC5883L e MPU-6050. A lista exata de tops e fontes está no array `tests` do script.

O teste do simulador de voo verifica estabilidade do heading durante invalidação da atitude e avanço após recuperação. Outros casos verificam blocos isolados e integrações específicas; a quantidade de bancos não deve ser confundida com teste físico ou cobertura formal de todas as combinações.

## Resultado do build preservado

O README do artefato `bitstreams/2026-10-08_hud_caca_marker` registra a regressão completa como PASS, síntese e implementação roteada aprovadas, WNS/WHS positivos e bitstream gerado. Essa associação é a documentação disponível para o build. A regressão não exercita placa, cabeamento, tensão, calibração magnética nem qualidade da imagem em monitor.

Na versão atual, a programação da Nexys A7-100T e a validação integrada de VGA, joystick e sensores permanecem pendentes. Consulte o [roteiro de prioridades](roadmap.md) antes da bancada.
