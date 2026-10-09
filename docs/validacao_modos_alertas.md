# Validação dos modos e alertas

Validação em 7 de outubro de 2026, na branch `feat/modos-alertas`, com Vivado
2026.1 (build 6511674), top `top_reticula` e FPGA `xc7a100tcsg324-1`.
Fontes funcionais: commit `0d37afc2411509170f5f01f025eff844caf541ff`.
Continuação do HEAD auditado `8c8e66c`: módulos existentes preservados; warning de
pitch agora libera abaixo de 12°, com testes ampliados de fronteiras, tempos e ACK.
Os dois comentários locais sobre orientação do HMC5883L foram preservados e
estavam presentes no build. Não alteram o circuito.
O manifesto SHA256 em `build/continuacao-20261007-102309/source-manifest.json` foi conferido
após o build, sem mudanças nos arquivos RTL, XDC, scripts e testes registrados.

## Testes

`./scripts/test.sh` completou os 54 bancos, com a mensagem
`===== TODOS OS TESTES PASSARAM =====` e `TEST EXIT = 0`.
Antes da regressão completa, os oito bancos operacionais também passaram
isoladamente. `tb_alertas_voo` executa 175 verificações, incluindo ambos os sinais,
fronteiras inteiras e um passo Q10 abaixo dos limiares. Os simuladores rejeitam
saídas indefinidas; o pouso confere a duração das fases e a parada aos 130 s.
Nenhum banco antigo foi alterado nesta continuação.

Os bancos antigos que instanciam o top selecionam explicitamente
`MODOS_OPERACIONAIS=0`, preservando suas verificações das fontes legadas.
O gerador de quadros antigo usa a mesma configuração. O padrão novo é testado por
`tb_modos_operacao_integrado` (39 verificações, incluindo escalada de CAUTION para WARNING após ACK), além dos bancos de fontes e overlay.
Isso mantém cobertura de compatibilidade; não equivale a executar as expectativas
de valores iniciais legados na configuração nova de SOLO.

Logs: `build/continuacao-20261007-102309/regression.log`; execuções isoladas em `build/continuacao-20261007-102309/*-test.log`.
Matriz anterior à edição: `build/continuacao-20261007-102309/matriz-auditoria.md`.

| Teste | Banco | Resultado |
| --- | --- | --- |
| modo_operacao | `tb_modo_operacao` | PASS |
| simulador_voo | `tb_simulador_voo` | PASS |
| simulador_pouso | `tb_simulador_pouso` | PASS |
| alertas_voo | `tb_alertas_voo` | PASS |
| buzzer_driver | `tb_buzzer_driver` | PASS |
| fontes_operacao | `tb_fontes_operacao` | PASS |
| alertas_vga | `tb_alertas_vga` | PASS |
| modos_operacao_integrado | `tb_modos_operacao_integrado` | PASS |
| heading_fusao | `tb_heading_fusao` | PASS |
| projecao_vertical | `tb_projecao_vertical` | PASS |
| estado_vertical | `tb_estado_vertical` | PASS |
| top_fusao_sensores | `tb_top_fusao_sensores` | PASS |
| reticula | `tb_reticula` | PASS |
| hmc5883l_i2c | `tb_hmc5883l_i2c` | PASS |
| heading_magnetico | `tb_heading_magnetico` | PASS |
| top_heading | `tb_top_heading` | PASS |
| controle_heading | `tb_controle_heading` | PASS |
| controle_joystick | `tb_controle_joystick` | PASS |
| controle_manche | `tb_controle_manche` | PASS |
| modo_manche | `tb_modo_manche` | PASS |
| horizonte | `tb_horizonte` | PASS |
| atitude | `tb_atitude` | PASS |
| atitude_accel_fixa | `tb_atitude_accel_fixa` | PASS |
| gyro_bias_dt | `tb_gyro_bias_dt` | PASS |
| gyro_integrador | `tb_gyro_integrador` | PASS |
| atitude_gyro_hud | `tb_atitude_gyro_hud` | PASS |
| atitude_fusao_complementar | `tb_atitude_fusao_complementar` | PASS |
| velocidade_inercial | `tb_velocidade_inercial` | PASS |
| velocidade_inercial_pipeline | `tb_velocidade_inercial_pipeline` | PASS |
| velocidade_inercial_dt_real | `tb_velocidade_inercial_dt_real` | PASS |
| entrada_hud | `tb_entrada_hud` | PASS |
| dados_hud | `tb_dados_hud` | PASS |
| numeros | `tb_numeros` | PASS |
| roll | `tb_roll` | PASS |
| modo | `tb_modo` | PASS |
| modos | `tb_modos` | PASS |
| estilos | `tb_estilos` | PASS |
| top_atitude | `tb_top_atitude` | PASS |
| vga | `tb_vga` | PASS |
| bmp085_calibracao | `tb_bmp085_calibracao` | PASS |
| bmp085_temperatura | `tb_bmp085_temperatura` | PASS |
| bmp085_pressao | `tb_bmp085_pressao` | PASS |
| bmp085_continuo | `tb_bmp085_continuo` | PASS |
| bmp085_compensacao_temp | `tb_bmp085_compensacao_temp` | PASS |
| bmp085_compensacao_pressao | `tb_bmp085_compensacao_pressao` | PASS |
| bmp085_aritmetica_seq | `tb_bmp085_aritmetica_seq` | PASS |
| bmp085_compensacao_temp_seq | `tb_bmp085_compensacao_temp_seq` | PASS |
| bmp085_compensacao_pressao_seq | `tb_bmp085_compensacao_pressao_seq` | PASS |
| bmp085_compensacao_seq | `tb_bmp085_compensacao_seq` | PASS |
| top_bmp085_seq | `tb_top_bmp085_seq` | PASS |
| bmp085_altitude | `tb_bmp085_altitude` | PASS |
| bmp085_altitude_monotonia | `tb_bmp085_altitude_monotonia` | PASS |
| bmp085_i2c | `tb_bmp085_i2c` | PASS |
| mpu6050_i2c | `mpu6050_i2c_tb` | PASS |

## Síntese, implementação e bitstream

O fluxo `scripts/build_vivado.tcl` terminou com `VIVADO EXIT = 0` e os marcadores
`SYNTHESIS=PASS`, `IMPLEMENTATION=PASS`, `TIMING=PASS` e `WRITE_BITSTREAM=PASS`.
O build anterior foi arquivado pelo script. O novo fluxo verifica setup, hold e
erros de DRC antes da escrita do bitstream.

| Métrica | Resultado |
| --- | --- |
| WNS | +0,398 ns |
| TNS | 0,000 ns |
| WHS | +0,020 ns |
| THS | 0,000 ns |
| WPWS | +4,020 ns |
| TPWS | 0,000 ns |
| Endpoints internos sem constraint | 0 |
| CDC unsafe / unknown / sem ASYNC_REG | 0 / 0 / 0 |

Timing atendido para as restrições existentes. Há 18 entradas sem input delay:
seis portas I2C e 12 controles assíncronos com false path. Há 26 saídas sem output
delay (VGA, LEDs e I2C). Portanto, o resultado não certifica timing externo dessas
interfaces. Não foram inventados delays para eliminar os avisos.

## Recursos

Comparação com `build/continuacao-20261007-102309/utilization-before.rpt`, preservado antes do build:

| Recurso | Antes | Atual | Diferença |
| --- | ---: | ---: | ---: |
| LUT | 11587 | 11583 (18,27%) | -4 |
| FF | 6528 | 6528 (5,15%) | 0 |
| BRAM | 0 | 0 | 0 |
| DSP | 30 | 30 (12,50%) | 0 |
| XADC | 1 | 1 | 0 |
| BUFG | 2 | 2 | 0 |

O build atual usa quatro LUTs a menos que o anterior. Os demais recursos
permaneceram iguais; não houve crescimento inesperado.

## Avisos e limitações

- ERROR: nenhum nos resultados de síntese, implementação e bitstream.
- CRITICAL WARNING: nenhum nesses resultados.
- WARNING: a fase de síntese informa 182; o resumo do processo completo de síntese
  informa 186. Incluem portas e registradores sem uso e otimizações. O aviso de FSM
  sem reset refere-se ao módulo preexistente `bmp085_altitude`.
- DRC: 53 avisos, sem erros. CFGBVS-1 (1) indica propriedades CFGBVS/CONFIG_VOLTAGE
  não definidas; DPIP-1 (11), DPOP-1 (16) e DPOP-2 (25) recomendam pipeline de DSP.
  As categorias já existiam no build anterior. A tensão de configuração não foi
  presumida nem alterada para silenciar o aviso.
- Power 33-332: atividade estimada de reset pode reduzir a precisão da análise de
  potência. Não foi feita validação de consumo físico.
- Icarus informa limitações conhecidas de seleção constante em `always_*` e avisos
  de timescale. Os testes terminaram sem falhas. Não foram encontrados avisos finais
  de implicit nets, width mismatch, múltiplos drivers ou latches na revisão dos logs.

As imagens de demonstração foram produzidas por simulação com entradas controladas;
não são capturas de uma FPGA programada. A nova versão ainda precisa de teste físico.
Os limites dos alertas são didáticos. O ACK não é cancelado por mudança de causa
na mesma severidade. A velocidade vertical alimenta a lógica quando válida, mas
não ganhou indicador numérico dedicado no HUD.

A auditoria adicional do checkpoint roteado terminou com `ROUTED_AUDIT=PASS`: 138
células no caminho hierárquico do buzzer, SW2=M13, SW3=R15, BTNC=N17 e nenhuma
porta física de buzzer. Log: `build/continuacao-20261007-102309/verify-routed-console.log`.

## Artefato

- Arquivo: `build/vivado/reticula.runs/impl_1/top_reticula.bit`
- Tamanho: 3825992 bytes.
- Timestamp: `2026-10-07 15:01:50.281456324 -0300`.
- SHA256: `f945ca6156f2f72cb089878be2936de1bb318759a5934719cd1fa01d65b391e5`.

O timestamp é posterior ao início do build (`2026-10-07T17:56:51.157209+00:00`).
A presença do arquivo foi conferida junto ao sucesso de `write_bitstream` e ao
exit code do Vivado; não foi usada isoladamente como prova de build válido.

Não houve push, programação da FPGA, gravação de flash ou implementação elétrica
do buzzer. `buzzer_out` é interno e mantém um indicador no HUD; não há porta externa
nem pino de buzzer definido. A identificação elétrica e o circuito de acionamento
ficam para a etapa física.
