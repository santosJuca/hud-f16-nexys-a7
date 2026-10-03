# Atitude pelo MPU-6050 no HUD

Documento evolutivo da integração do MPU-6050. O estado consolidado descrito
aqui incorpora a calibração do acelerômetro, correção de bias do giroscópio,
integração temporal e fusão complementar.
Antes da edição, `rtl/top_reticula.sv` estava igual ao commit e ao backup
`rtl/top_reticula.sv.pre-atitude-accel.bak`. A tentativa anterior não havia
alterado o arquivo. Os arquivos `.bak` foram preservados.

## Seleção e calibração

O `top` conecta `amostra_nova` do driver ao estimador `atitude_accel_fixa`.
Pitch e roll do sensor são usados somente quando `SW15..SW12 = 1111`,
`sensor_ok = 1` e a calibração terminou. Em qualquer outra condição,
permanece a prioridade anterior: joystick, depois switches.
Com `1111` e sensor indisponível, os pares de switches são neutros e o
joystick continua funcionando.

A calibração usa as primeiras 64 amostras válidas, independentemente dos
switches. Mantenha o GY-521 parado e aproximadamente plano após programar
ou religar a placa. Selecionar o modo MPU não reinicia a calibração.
A perda de `sensor_ok` invalida a calibração e retorna ao fallback;
na recuperação, o estimador coleta outras 64 amostras.

O mapeamento é `pitch <- accel_y` e `roll <- -accel_x`, com filtro IIR de
1/4 e limites de ±80 pixels para pitch e ±128 unidades Q8 para roll.
A conversão é uma aproximação linear para demonstração, sem fusão com o
giroscópio nem uso de `accel_z` para validar gravidade. As marcas da escada
não comprovam medição angular calibrada. O indicador verde acompanha
`sensor_ok`; ele não indica conclusão da calibração.

Heading, display_mode, LEDs do joystick e pinagem não foram alterados.

## Simulação

Os testes `tb_atitude_accel_fixa` e `mpu6050_i2c_tb` passaram. O primeiro
verifica sinais, saturação e perda do sensor. O segundo verifica leitura,
publicação conjunta dos eixos, pulso único, NACK, clock stretching,
timeout, recuperação e identificação `0x70`.

O novo `tb_top_atitude` passou com o estimador real: 16 combinações de
switches, prioridade do joystick, fallback dos switches, 64 amostras de
calibração, atualização somente por pulso e perda/recuperação do sensor.
As saídas do driver e os sinais digitais do joystick são forçados neste
teste para isolar a seleção. Ele não simula a aquisição analógica do XADC.

Comandos executados a partir da raiz:

```sh
mkdir -p build/atitude-validacao
iverilog -g2012 -s tb_atitude_accel_fixa -o build/atitude-validacao/tb_atitude rtl/atitude_accel_fixa.sv tests/tb_atitude_accel_fixa.sv
vvp build/atitude-validacao/tb_atitude
iverilog -g2012 -s mpu6050_i2c_tb -o build/atitude-validacao/tb_mpu rtl/mpu6050_i2c.sv tests/mpu6050_i2c_tb.sv
vvp build/atitude-validacao/tb_mpu
iverilog -g2012 -i -s tb_top_atitude -o build/atitude-validacao/tb_top rtl/*.sv tests/tb_top_atitude.sv
vvp build/atitude-validacao/tb_top
git diff --check
```

A opção `-i` permite elaborar o top sem o modelo proprietário do XADC.
O Icarus avisa que inclui todos os bits na sensibilidade de `always_*`
em `numeros_hud.sv`; a simulação termina com PASS.

## Build Vivado

Build final concluído em 02/10/2026 com Vivado 2026.1 para
`xc7a100tcsg324-1`, sem erros. Foram usadas cópias dos scripts existentes,
com saída em `build/atitude-final/`, preservando `build/vivado/`.
A primeira execução ficou em `build/atitude-validacao/`; o aviso de
`sensor_ok` usado antes da declaração foi corrigido no build final.

- Bitstream: `build/atitude-final/vivado/reticula.runs/impl_1/top_reticula.bit`.
- Timing: WNS 0,722 ns; TNS 0; WHS 0,108 ns; THS 0.
- Utilização: 2.775 LUTs (4,38%), 594 registradores (0,47%), 1 DSP e 0 BRAM.
- Relatórios: `timing_summary.rpt`, `utilization.rpt`, `drc.rpt` e
  `fmax.rpt`, dentro de `build/atitude-final/`.

As restrições de timing especificadas foram atendidas. O relatório ainda
lista duas entradas sem input delay, outras sete cobertas por false path
e 16 saídas sem output delay. Isso limita a análise de timing externo;
o XDC foi preservado.

Warnings registrados:

- Síntese: remoção de `samples_reg[6:7]`, VGA_B constante em zero e
  `accel_z` sem carga útil no estimador.
- DRC: `CFGBVS-1` por ausência de CFGBVS/CONFIG_VOLTAGE e
  `DPIP-1`, `DPOP-1`, `DPOP-2` por pipeline do DSP da simbologia.

Comandos usados para o build separado e programação:

```sh
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -source build/atitude-final/build_vivado.tcl
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -source build/atitude-final/program_board.tcl
```

As cópias dos scripts ficam na pasta de build ignorada pelo Git. Para
reproduzir na saída padrão, os scripts versionados continuam sendo
`scripts/build_vivado.tcl` e `scripts/program_board.tcl`.

## Programação da placa

A FPGA conectada foi identificada como `xc7a100t` e programada com o
bitstream final. O Vivado retornou `PROGRAM_DONE=1` e startup `HIGH`.
Registro: `build/atitude-final/program.log`. A programação é volátil.
O aviso de ausência de núcleos de depuração não impediu a programação.
Juarez confirmou o funcionamento na placa após a programação: “Deu certo aqui bem perfeito”.
Esse retorno registra a validação física geral da integração; não atribui
resultados individuais a cada item do roteiro abaixo.

Se o sensor estava inclinado ou em movimento durante a programação,
reprograme com ele plano e parado para obter uma nova referência.

## Roteiro de teste físico

1. Com o sensor plano e parado desde a programação, aguarde a calibração.
2. Ligue SW12, SW13, SW14 e SW15. Incline lentamente o sensor: frente para
   baixo deve produzir pitch negativo; trás para baixo, positivo; direita
   para baixo deve produzir roll positivo; esquerda para baixo, negativo.
3. Mova o joystick no modo MPU já calibrado: ele não deve alterar pitch/roll.
4. Desligue um dos quatro switches e confirme o retorno ao joystick.
   Com joystick neutro, confira as posições de teste dos switches.
5. Confira SW0 e BTNU/BTND nos dois modos e a estabilidade da imagem VGA.

O roteiro permanece como referência para repetir a validação após mudanças.
PASS de simulação e programação concluída não substituem a observação na placa.

## Configuração e integração do giroscópio

Após a validação física da integração, o driver passou a escrever
`GYRO_CONFIG (0x1B) = 0x00` e `ACCEL_CONFIG (0x1C) = 0x00`, depois de
acordar o sensor e antes de ler os eixos. As faixas selecionadas são
±250 graus/s e ±2g. Os endereços e seletores também estão definidos no
[driver MPU60X0 da Intel](https://android.googlesource.com/platform/hardware/bsp/intel/+/bf215a6d8d17433b6ada853f0f9ba29ebd07b505/peripheral/libupm/src/mpu9150/mpu60x0.h).

As escritas exigem ACK. Se uma falhar, o driver reinicia a identificação;
não publica amostra válida antes de concluir a configuração e uma leitura
completa. Ainda não há leitura de retorno dos registradores de configuração.
O testbench rejeita leitura antecipada e injeta NACK em cada nova escrita.

A medição do driver anterior na simulação com clock stretching encontrou
11,745 ms entre duas amostras consecutivas. Os 10 ms de `POLL_TICKS` são
apenas a espera entre transações. Após falhas e recuperação, os intervalos
foram maiores. O registro está em `build/intervalo-mpu/resultado.log`.
Esse resultado é de simulação, não uma medição da placa nem garantia de
período fixo. A integração atual do giroscópio utiliza o tempo entre amostras válidas
e reinicia a referência temporal após perda do sensor.

O HUD atualmente utiliza fusão complementar entre a referência do
acelerômetro e a variação angular obtida pelo giroscópio. O caminho inclui
calibração do bias, medição do intervalo entre amostras, integração temporal
e conversão para as unidades gráficas do HUD. A cadeia foi coberta por
testbenches e validada fisicamente na placa.

Validação desta preparação:

- `mpu6050_i2c_tb`: PASS, incluindo NACK em GYRO_CONFIG e ACCEL_CONFIG,
  ordem das escritas e reconfiguração após falhas, com ID 0x68 e com aceitação adicional de 0x70. O valor padrão documentado
para WHO_AM_I do MPU-6050 é 0x68; 0x70 é mantido apenas como compatibilidade
adicional e não deve ser descrito como o ID padrão do MPU-6050.
- `tb_atitude_accel_fixa` e `tb_top_atitude`: PASS.
- `git diff --check`: sem erros.
- Vivado 2026.1: build concluído em `build/faixas-mpu/`; WNS 0,575 ns,
  WHS 0,021 ns, TNS/THS zero; 2.777 LUTs, 596 registradores e 1 DSP.
- Permanecem os quatro warnings DRC descritos acima e as limitações de
  timing externo. Não houve erros nem critical warnings no log do build.

O bitstream anterior permanece em `build/atitude-final/`. Para conferir
esta alteração na placa, repita a seleção `1111`, as inclinações e o retorno
ao joystick; o resultado esperado é o mesmo da versão já validada.

A versão com faixas explícitas foi programada na FPGA `xc7a100t`, com
`PROGRAM_DONE=1` e startup `HIGH`. Log: `build/faixas-mpu/program.log`.
A confirmação física anterior refere-se ao build `atitude-final`; a nova
programação ainda precisa de conferência visual pelo usuário.
