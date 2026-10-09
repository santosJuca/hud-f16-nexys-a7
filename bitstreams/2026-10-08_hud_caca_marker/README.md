# HUD CAÇA sem marcador de alvo

Bitstream para Nexys A7-100T (`xc7a100tcsg324-1`), gerado em 8 de outubro de
2026 com Vivado 2026.1 (build 6511674), a partir da branch `feat/modos-alertas`.

## Validação

| Verificação | Resultado |
| --- | --- |
| `./scripts/test.sh` | PASS, todos os bancos |
| Síntese | PASS |
| Implementação roteada | PASS |
| WNS / TNS | +0,078 ns / 0,000 ns |
| WHS / THS | +0,017 ns / 0,000 ns |
| Endpoints setup/hold com falha | 0 / 0 |
| DRC | 0 erros, 55 avisos |
| Geração do bitstream | PASS |

O retículo CAÇA, a mira móvel e os sensores mantêm seus caminhos originais. O
marcador vermelho de quatro cantos permanece no estilo NORMAL e fica oculto no
estilo CAÇA. A pinagem e as restrições de timing não foram alteradas. A FPGA não
foi programada.

Os avisos DRC são CFGBVS-1 (propriedades de tensão de configuração não definidas)
e recomendações DPIP/DPOP para pipeline dos DSPs. Não são falhas de timing. O
`check_timing.rpt` registra seis entradas I2C sem input delay, 12 controles com
false path e 26 saídas sem output delay; assim, os slacks comprovam as restrições
internas especificadas, não a temporização elétrica externa dessas interfaces.

O projeto e o bitstream do build anterior foram preservados no arquivo local
criado pelo fluxo Vivado. A release anterior [`hud-20261008-100mhz`](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-20261008-100mhz)
e seu asset permanecem intactos. Esta versão usa uma pasta e uma tag novas.

## Arquivos

- `top_reticula.bit`: bitstream novo.
- `SHA256.txt`: SHA-256 do bitstream.
- `timing_summary.rpt`, `check_timing.rpt`: timing final e cobertura das restrições.
- `drc.rpt`: regras de projeto.
- `cdc.rpt`: cruzamentos entre domínios de clock.
- `utilization.rpt`: recursos utilizados.
