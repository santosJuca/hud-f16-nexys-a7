# Fechamento funcional e rastreabilidade: 21/10/2026

**Projeto:** HUD aeronáutico em FPGA, Nexys A7-100T, Artix-7 XC7A100TCSG324-1  
**Referência do código:** `4107002ab3cff7ceab9c2d89a62e4223a523e426`, branch `fix/calibracao-hmc5883l-20261019`  
**Natureza:** registro documental de evidências; não é relatório de nova implementação nem certificação aeronáutica.

## 1. Hierarquia das evidências

| Camada | Evidência | Limite |
| --- | --- | --- |
| Fontes do build | 51/51 hashes SHA-256 do manifesto coincidem com os arquivos do checkout `4107002`; nenhuma divergência | Comparação dos arquivos locais com o manifesto versionado, não reconstrução do bitstream |
| Regressão automatizada | 62/62 casos do `scripts/test.sh` concluídos com sucesso no GitHub Actions do próprio commit | Aprovação dos cenários executados, não cobertura formal completa |
| Síntese/implementação | Relatórios do Vivado 2026.1, build calibrado de 19/10/2026 | Evidência do build preservado, não de todos os sinais externos |
| Flash | Log de gravação/verificação em 19/10/2026 e readback integral realizado | Readback de 16 MiB teve sucesso, mas não houve comparação binária registrada do conteúdo lido |
| Bancada | Observações do operador em 21/10/2026 | Sem instrumentação metrológica ou fotos anexadas a este registro |
| Simulador interativo | Verilator + C++ + GTKmm operacionais no Linux | Integração externa ao repositório; não emula integralmente os três sensores |

## 2. Auditoria do commit, testes e build

- SHA do commit: `4107002ab3cff7ceab9c2d89a62e4223a523e426`.
- Manifesto: [`sources_sha256.json`](../bitstreams/2026-10-19_mag_calibrado/sources_sha256.json), 51 entradas.
- Auditoria local de 21/10: **SOURCE_MANIFEST=PASS**, 51 correspondências, 0 divergências; working tree sem alterações.
- Script de regressão: [`scripts/test.sh`](../scripts/test.sh), 62 entradas.
- GitHub Actions, mesmo commit: [execução 39329024900](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/39329024900) e [execução 39329019921](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/39329019921), ambas concluídas com sucesso em 19/10/2026. O log da primeira termina com “TODOS OS TESTES PASSARAM”.
- Artefato da primeira execução: [`simulacao-rtl`](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/39329024900/artifacts/12224058296). A disponibilidade do artefato é limitada pela retenção do GitHub Actions.

Os testes incluem aquisição e falhas I²C, fusão de atitude e rumo, compensação barométrica, modos, joystick, buzzer, CDC e renderização. O testbench de altitude do BMP085 verificou monotonicidade em 71.326 pressões de teste. Esses resultados são digitais, não medições físicas.

### Bitstream calibrado, 19/10/2026

- Arquivo preservado: [`top_reticula.bit`](../bitstreams/2026-10-19_mag_calibrado/top_reticula.bit).
- SHA-256 confirmado no Ubuntu: `16bb1d1c4fdee04c6dde4d9b5a1134a9e510beb79be5d75c69df4d359d1a9cf6`.
- Perfil magnético: [`magnetometer_calibration.tcl`](../constraints/magnetometer_calibration.tcl), offsets X=-8 e Y=-148; ganhos Q12 X=3935, Y=4270. Calibração feita a partir de 882 amostras, específica da montagem.
- O [`build_vivado.tcl`](../scripts/build_vivado.tcl) aplica o perfil de calibração ao fileset; os parâmetros padrão do RTL são neutros.

| Indicador do relatório de implementação de 19/10 | Resultado |
| --- | ---: |
| WNS / TNS | +0,326 ns / 0,000 ns |
| WHS / THS | +0,020 ns / 0,000 ns |
| Falhas de setup e hold nos caminhos analisados | 0 |
| Erros de DRC | 0 |
| Slice LUTs | 12.448 (19,63%) |
| Slice registers | 6.967 (5,49%) |
| DSP48E1 | 33 (13,75%) |
| BRAM | 0 |
| IOB | 48 |
| BUFG | 2 |
| XADC | 1 |

Fontes: [`timing_summary.rpt`](../bitstreams/2026-10-19_mag_calibrado/timing_summary.rpt), [`utilization.rpt`](../bitstreams/2026-10-19_mag_calibrado/utilization.rpt) e [`drc.rpt`](../bitstreams/2026-10-19_mag_calibrado/drc.rpt).

O log `build/flash_mag_calibrado_20261019_183732/program.log`, preservado na estação de desenvolvimento, registra apagamento, blank check, Program/Verify e leitura completa da Flash bem-sucedidos. O script também concluiu a programação JTAG com DONE=1. A verificação do readback não representa comparação byte a byte do conteúdo. A identificação direta da configuração *atualmente executada* não foi realizada nesta auditoria.

## 3. Ensaios físicos relatados em 21/10/2026

| Item | Observação do operador |
| --- | --- |
| Saída VGA 640×480 | Imagem do HUD funcional |
| NORMAL / DECLUTTER / CAÇA | Seleção funcional |
| SOLO / VOO / POUSO | Seleção funcional |
| MPU6050 | Pitch e roll reagem ao movimento; retículo central permanece fixo |
| HMC5883L | Rumo varia ao girar e retorna aproximadamente ao valor inicial |
| BMP085 | Indicação de altitude estável, sem saltos observados |
| KY-023 | Joystick funciona na montagem atual |
| Buzzer | Acionamento funcional na montagem atual |
| Indicadores LD4 / LD5 / LD6 | Acesos na bancada |
| Alertas inesperados | Não observados durante os ensaios relatados |

**Classificação:** resposta funcional observada. Não atribuir aprovação quantitativa à precisão absoluta dos sensores, aos limiares de alertas, à histerese, às cadências sonoras ou às margens elétricas externas sem ensaio correspondente.

## 4. Pendências delimitadas

1. Reproduzir independentemente a implementação com o mesmo perfil magnético, guardar manifesto de toolchain e comparar resultados e artefatos, sem presumir identidade binária automática.
2. Se requerido, identificar diretamente a configuração carregada na FPGA e correlacioná-la ao bitstream preservado.
3. Medir a tensão nos terminais JXADC1/JXADC2, validar a rede de divisores e registrar alimentações e pull-ups dos módulos.
4. Quantificar o erro de pitch, roll, heading e altitude com instrumentos de referência.
5. Executar ensaios específicos dos limiares/histerese/temporização dos alertas.
6. Preservar capturas e fotografias reais identificando data, configuração e fonte.

Documentação histórica de 08/10 e 13/10 pertence a builds anteriores e não deve substituir os resultados específicos de 19/10 e 21/10. O projeto não é instrumento aeronáutico certificado.
