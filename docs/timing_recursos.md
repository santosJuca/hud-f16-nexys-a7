# Timing, recursos e evidências

O build associado às fontes de `84411c3` foi reconferido nos artefatos locais
em 06/10/2026. O manifesto SHA256 corresponde ao RTL, XDC e scripts atuais.
Esta reorganização documental **não executou um novo build Vivado**.
O registro completo e a comparação antes/depois permanecem em
[validação da fusão](validacao_fusao_sensores.md), fonte principal desses resultados.

| Verificação | Resultado confirmado no build da fusão |
| --- | --- |
| Ferramenta / dispositivo | Vivado 2026.1 / xc7a100tcsg324-1 |
| Síntese / implementação | Concluídas sem erros; Fully Routed |
| WNS / TNS | +0,770 ns / 0,000 ns |
| WHS / THS | +0,043 ns / 0,000 ns |
| DRC | 0 erros, 56 avisos |
| LUT / FF / DSP48E1 | 10.838 / 6.263 / 32 |
| BRAM / XADC | 0 / 1 |

Os avisos são CFGBVS-1 (1), DPIP-1 (11), DPOP-1 (17) e DPOP-2 (27).
Não chamar esse resultado de DRC sem avisos. CFGBVS/CONFIG_VOLTAGE não foram
presumidos nem alterados nesta revisão. As recomendações de registros DSP não
impediram o fechamento de timing interno.

## Limites da análise

O XDC declara clock de 100 MHz e clock gerado de pixel de 25 MHz. O relatório
aponta zero endpoints internos sem restrição, mas conserva 15 entradas sem input
delay e 22 saídas sem output delay. Portanto, WNS positivo não certifica a interface
elétrica inteira até sensores e monitor. Uma futura captura digital deverá receber
constraints próprias de clock e atrasos de entrada, com análise de CDC.

Não relaxar período, criar false path global ou multicycle para ocultar um caminho
crítico. A solução na fusão foi registrar etapas de cálculo; o XDC foi preservado.
O arquivo histórico `bitstreams/2026-10-05/` inclui uma pendência VGA antiga e não
é equivalente ao build final. Veja o [catálogo](../bitstreams/README.md).

## Reproduzir e aceitar um build

Execute primeiro os [testes](testes.md), depois os comandos Vivado do
[README](../README.md#gerar-bitstream). O script usa o mesmo diretório com `-force`;
preserve resultados anteriores antes de repetir. Audite:

```sh
RPT=build/vivado/reticula.runs/impl_1/top_reticula_timing_summary_routed.rpt
grep -n -A10 'Design Timing Summary' "$RPT"
grep -n 'Slack (VIOLATED)' "$RPT"
grep -nE 'ERROR:|CRITICAL WARNING:|Timing constraints are not met' build/build_vivado.log
sha256sum build/vivado/reticula.runs/impl_1/top_reticula.bit
```

`grep` retorna 1 quando não encontra a expressão; isso é esperado nas buscas
por violações/erros. Conferir também término das runs, route, DRC e utilização;
a mera existência de um `.bit` pode corresponder a um build antigo.
Aceitar apenas síntese/implementação sem erros, route completo, DRC sem erros,
**WNS > 0, TNS = 0, WHS > 0, THS = 0**, fontes identificadas e hash registrado.

## Artefatos locais da fusão

- Bitstream: `build/vivado/reticula.runs/impl_1/top_reticula.bit`.
- Timing, recursos e DRC: `build/timing_summary.rpt`, `build/utilization.rpt`, `build/drc.rpt`.
- Log: `build/fusao_sensores_vivado.log`.
- Fontes e regressão: `build/fusao_sensores_audit/fontes_sha256.json` e `regression.log`.

SHA256 do bitstream reconferido:

```text
5e53786cdec31fa7de29d951f34dbe95b5486447d11602062868a57740434bc4
```

Esses caminhos de `build/` são locais e ignorados, não downloads do GitHub.
O bitstream da fusão não foi copiado para o acervo histórico nesta revisão.
A validade física permanece **PENDENTE DE VALIDAÇÃO FÍSICA**.
