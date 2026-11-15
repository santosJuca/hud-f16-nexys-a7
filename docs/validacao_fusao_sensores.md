# Validação da fusão de sensores

Validação em 6 de outubro de 2026, na branch `dev/fusao-sensores`, a partir de
`de80521704b04bc6029f99fae43a71ad09780658`. Plataforma: Nexys A7-100T,
`xc7a100tcsg324-1`, Vivado 2026.1. Nenhuma programação da FPGA foi executada.

## Resultado final

| Verificação | Resultado |
| --- | --- |
| `git diff --check` | Limpo |
| `./scripts/test.sh` | 46/46 bancos aprovados, 0 falhas |
| Mensagem final da regressão | `===== TODOS OS TESTES PASSARAM =====` |
| Icarus, top completo com `tests/xadc_stub.sv` e `rtl/*.sv` | `EXIT_TOP=0` |
| Síntese | Concluída; 0 erros e 0 avisos críticos |
| Implementação | Concluída; Fully Routed, 0 redes sem route |
| DRC | 0 erros; 56 avisos |
| WNS | +0,770 ns |
| TNS | 0,000 ns |
| WHS | +0,043 ns |
| THS | 0,000 ns |
| WPWS / TPWS | +4,500 ns / 0,000 ns |
| `Slack (VIOLATED)` | Nenhuma ocorrência |
| Endpoints internos sem restrição | 0 |
| Bitstream | Gerado; build retornou 0 |

A primeira implementação apresentou WNS −2,531 ns. Foram acrescentados registros
entre as etapas da correção circular do heading, entre bias e DSPs dos três
integradores e antes da tabela trigonométrica da projeção vertical. As equações
foram preservadas. A regressão completa foi repetida antes do segundo build,
que produziu os resultados acima. Nenhuma restrição de clock, false path ou
multicycle path foi acrescentada.

## Utilização após route

A referência anterior é o relatório arquivado em
[`utilization.rpt`](https://github.com/santosJuca/Trabalho-display-aviao-v2/blob/de80521704b04bc6029f99fae43a71ad09780658/bitstreams/2026-10-05_hmc5883l/utilization.rpt).

| Recurso | Base | Fusão | Diferença | Uso do dispositivo |
| --- | ---: | ---: | ---: | ---: |
| LUT | 9.284 | 10.838 | +1.554 | 17,09% |
| FF | 5.399 | 6.263 | +864 | 4,94% |
| DSP48E1 | 15 | 32 | +17 | 13,33% |
| BRAM | 0 | 0 | 0 | 0% |
| XADC | 1 | 1 | 0 | 100% |

Os DSPs novos atendem à integração de heading, à projeção XYZ e às integrações
temporais do estado vertical. Ganhos complementares usam shifts. A conversão
final de VSI sem consumidor no top pode ser removida na síntese; a velocidade
interna permanece necessária à previsão de altitude. A saída em ft/min está
implementada e testada no RTL para futura integração visual.

Os 56 avisos de DRC são `CFGBVS-1` (1), `DPIP-1` (11), `DPOP-1` (17) e `DPOP-2`
(27). As mesmas categorias já existiam na base. `CFGBVS/CONFIG_VOLTAGE` continuam
sem declaração no XDC; não foram presumidos valores elétricos novos. Os demais
avisos recomendam registros de DSP. Não impedem o timing positivo desta execução.
O relatório mantém 15 entradas sem input delay e 22 saídas sem output delay,
como na base. Portanto, o timing interno aprovado não comprova temporização
elétrica ponta a ponta de VGA, I²C e controles externos.

## Testes e arquitetura

Foram mantidos os 42 bancos anteriores e acrescentados quatro:

| Banco novo | Cobertura registrada |
| --- | --- |
| `tb_heading_fusao` | 124 verificações: inicialização, bias, gyro zero/positivo/negativo, correção gradual, wrap nos dois sentidos, erros ±2° cruzando norte, validade, recuperação, expiração, dt e extremos signed |
| `tb_projecao_vertical` | Nove vetores de projeção, mais bloqueios por faixa e sensor inválido; pitch/roll positivos, negativos e combinados |
| `tb_estado_vertical` | 29 verificações: gravidade, bias, repouso, subida/descida, referência barométrica, perdas/recuperação, VSI, saturação e cancelamento de pipeline |
| `tb_top_fusao_sensores` | 11 verificações: CORDIC → fusão → CDC → dados HUD, BMP/MPU → vertical, atualização por quadro e fallbacks |

A atitude continua usando gyro X/Y e acelerômetro no filtro complementar
existente. O heading combina gyro Z e HMC5883L, com correção circular de 1/32,
para fornecer **rumo magnético estimado**. A seleção é fusionado válido,
magnético válido e, por último, manual.

O estado vertical projeta XYZ usando pitch/roll, remove gravidade e bias inicial
e usa altitude barométrica como referência lenta de posição e velocidade.
Fornece **altitude estimada/fusionada** e **velocidade vertical estimada** limitada
a ±6000 ft/min. Sem barômetro, retém altitude e invalida/zera VSI; sem MPU válido,
usa atualização barométrica suave. O fallback inicial de 36000 FT foi preservado.

A **velocidade inercial estimada** existente não foi modificada e não representa
airspeed real. Detalhes de escalas, ganhos, convenções e recuperação estão em
[fusão de sensores](fusao_sensores.md).

## Arquivos

Novos:

- `rtl/heading_fusao.sv`
- `rtl/projecao_vertical.sv`
- `rtl/estado_vertical.sv`
- `tests/tb_heading_fusao.sv`
- `tests/tb_projecao_vertical.sv`
- `tests/tb_estado_vertical.sv`
- `tests/tb_top_fusao_sensores.sv`
- `docs/fusao_sensores.md`
- `docs/validacao_fusao_sensores.md`

Modificados:

- `rtl/top_reticula.sv`: estimadores, seleção de fontes e registros antes dos integradores de atitude.
- `rtl/heading_magnetico.sv`: pulso `atualizado` junto da publicação existente.
- `tests/tb_heading_magnetico.sv`: conexão da porta adicional, sem mudar os testes anteriores.
- `scripts/test.sh`: quatro bancos novos.
- `README.md`: arquitetura, fontes dos dados e limitações.

A `main` não foi alterada.
Os arquivos anteriores e o projeto Vivado da base estão em
`build/fusao_sensores_audit/before/`; a tentativa com timing negativo está em
`build/fusao_sensores_audit/attempt1/`. Esses backups locais não são versionados.

## Bitstream e evidências locais

Bitstream:

```text
build/vivado/reticula.runs/impl_1/top_reticula.bit
```

SHA256:

```text
5e53786cdec31fa7de29d951f34dbe95b5486447d11602062868a57740434bc4
```

Relatórios finais: `build/timing_summary.rpt`, `build/utilization.rpt` e
`build/drc.rpt`. Log: `build/fusao_sensores_vivado.log`. Regressão e manifesto
SHA256 das fontes: `build/fusao_sensores_audit/regression.log` e
`build/fusao_sensores_audit/fontes_sha256.json`. Esses artefatos gerados ficam
localmente em `build/`, conforme o `.gitignore` existente.

## Pendências físicas

A placa permaneceu desligada. Faltam confirmar +Z em repouso, orientação relativa
dos sensores e sentido de giro, medir hard-iron, avaliar ruído e drift térmico,
ajustar ganhos e comparar altitude/VSI com movimentos conhecidos. O estimador
vertical está limitado a ±30° e exige calibração imóvel aproximadamente plana.
A compensação magnética de inclinação foi adiada até validar o alinhamento XYZ;
os offsets X/Y existentes permanecem neutros. Não há correção de declinação,
cinemática completa de yaw inclinado nem VSI visual. GPS e pitot não foram
acrescentados: futuramente serviriam, respectivamente, à correção de ground speed
e à medição de airspeed com pressão diferencial.
