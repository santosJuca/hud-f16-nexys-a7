# Timing e recursos do build de 08/10/2026

> Registro histórico de 08/10. Os [relatórios 5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/relatorios/) e seu [manifesto](../firmware/calibracao-guiada-5d7a3ae2/MANIFESTO.json) pertencem à versão recente; não reutilize as métricas abaixo como atuais.

Os valores desta página vêm dos relatórios versionados em [`bitstreams/2026-10-08_hud_caca_marker/`](https://github.com/santosJuca/Trabalho-display-aviao-v2/blob/11343bb/bitstreams/2026-10-08_hud_caca_marker/), associados pelo README daquela pasta ao bitstream `top_reticula.bit`, à branch `feat/modos-alertas` e ao Vivado 2026.1 (build 6511674). O repositório não contém um manifesto de hashes de todas as fontes daquele build; portanto, não se afirma identidade criptográfica entre cada fonte e os relatórios.

| Métrica | Relatório | Valor |
| --- | --- | ---: |
| Slice LUTs | `utilization.rpt` | 11.984 (18,90%) |
| Slice registers (FF) | `utilization.rpt` | 6.669 (5,26%) |
| DSP48E1 | `utilization.rpt` | 31 (12,92%) |
| Block RAM | `utilization.rpt` | 0 |
| WNS / TNS | `timing_summary.rpt` | +0,078 ns / 0 ns |
| Endpoints setup com falha | `timing_summary.rpt` | 0 |
| WHS / THS | `timing_summary.rpt` | +0,017 ns / 0 ns |
| Endpoints hold com falha | `timing_summary.rpt` | 0 |
| DRC | `drc.rpt` | 0 erros; 55 checks reportados como avisos |

O pior caminho de setup reportado tem 15 níveis lógicos; o detalhe está em `timing_summary.rpt`. Slacks positivos valem para os clocks e caminhos cobertos pelas constraints deste build. Não significam fechamento de todos os requisitos elétricos externos.

## Cobertura de constraints

`check_timing.rpt` registra seis entradas I²C sem input delay e 26 saídas sem output delay. Doze entradas assíncronas têm exceção até estágios de sincronização definidos no XDC. O clock de 100 MHz e o clock gerado de 25 MHz estão declarados. Não há atrasos externos arbitrários para I²C, VGA, XADC ou GPIO. A suficiência dessas restrições externas requer requisitos elétricos e medições correspondentes.

`drc.rpt` inclui aviso de `CFGBVS`/`CONFIG_VOLTAGE` não explicitados e avisos de recomendações de pipeline DSP. São itens de revisão; não os converter em violações de slack. O relatório preservado registra 0 erros DRC. Consulte também `cdc.rpt` e `check_timing.rpt` para limites de análise.

## Proveniência e validação

O catálogo em [`bitstreams/README.md`](https://github.com/santosJuca/Trabalho-display-aviao-v2/blob/28e736db2b0962ae3494660a8b84944ad087d8c5/bitstreams/README.md) identifica a versão, hash e status físico. Os resultados de síntese, roteamento e geração desta página não são validação física. À época deste registro, não havia ensaios físicos; resultados posteriores informados pelo operador estão em [`entrega_demo.md`](entrega_demo.md). Builds de 05/10, 06/10 e 07/10 têm conjuntos e resultados diferentes e não são usados como fonte das métricas desta página.
