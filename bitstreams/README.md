# Catálogo de bitstreams

Os artefatos abaixo são versões distintas. A data mais recente não implica validação física. A referência funcional atual do projeto é `feat/modos-alertas` no commit `84afb86`; o bitstream gerado associado à tag `hud-20261008-caca-marker` foi construído a partir de `de568516`, ancestral do commit de referência.

| Versão | Fonte e ferramenta | SHA-256 do bitstream | Relatórios preservados | Estado físico |
| --- | --- | --- | --- | --- |
| [2026-10-08 CAÇA sem marcador](2026-10-08_hud_caca_marker/README.md) | Tag `hud-20261008-caca-marker`, commit `de568516c863b2f10eae73f8890b1671bc18c1f2`; Vivado 2026.1, `xc7a100tcsg324-1` | `e55d29a48ed0ace7a7a7d94d512f8b05fa465905cf1d78a5317b047a32782c49` | timing, constraints, CDC, DRC e utilização na mesma pasta | Síntese/implementação aprovadas; não programado |
| [2026-10-05 HMC5883L](2026-10-05_hmc5883l/README.md) | Referência documentada como commit `de80521`; Vivado 2026.1, Nexys A7-100T | `1a3ca507dfbeb5a832cf933a2f3ccd5c3a151ad4a077852b5262e715595786ef` | timing, Fmax, DRC, utilização, testes e hashes de fontes | Implementação aprovada para aquelas fontes; placa não programada |
| [2026-10-05 correção de timing do heading](2026-10-05_3849e9e_heading_timing_fix/MANIFEST.txt) | Commit `3849e9e9f6c965dadc8556356dcad295141aa03e`; Vivado 2026.1 | `296a11e799682ad4b3a75e203813c490d8f96548c963abd839cdca17a2170e86` | timing, DRC e utilização na mesma pasta | Build histórico, anterior à integração atual de sensores/modos |
| [2026-10-05 baseline](2026-10-05/README.md) | Commit `9c25900bf18e9d98687c6274e1829073f96ccbca`; Vivado 2026.1 | `6926266a1f9256e418b258cbc993e5d43ca181b51bc161b3626861e59c7ef211` | caminho VGA e resumo de validação no README da pasta | Não aprovado globalmente: caminho VGA relatado em 42,597 ns para período de 40 ns |

## Referência de uso atual

`2026-10-08_hud_caca_marker/top_reticula.bit` contém o HUD CAÇA com mira móvel/LOCK, marcador vermelho fixo somente em NORMAL, modos e sensores descritos no README principal. Seu SHA-256 foi conferido contra `SHA256.txt`. O relatório registra 11.984 LUTs, 6.669 registradores, 31 DSP48E1, WNS +0,078 ns e WHS +0,017 ns. Consulte os relatórios originais para o contexto completo das constraints.

O bitstream é referência de implementação, mas não há evidência de que essa versão tenha sido programada na placa. A validação física integrada permanece pendente. Não usar os artefatos históricos como equivalentes do HUD atual.

## Tags e limites de associação

As tags `hud-20261008-caca-marker` e `hud-20261008-100mhz` identificam commits de código correspondentes a builds distintos. A segunda aponta para `5f69a16a203cbdfd6ecb71122cad74094f539190` e representa um checkpoint anterior; não é o bitstream CAÇA atual. A tag `hud-hardware-ok-v1` registra uma validação física de uma versão anterior, mas não possui nesta árvore um bitstream com hash associado e não comprova o comportamento do build de 08/10.

Antes de publicar novos bitstreams, preservar os existentes e registrar commit-fonte, ferramenta/dispositivo, testes, relatórios, SHA-256 e estado físico. Distinguir o commit que gerou as fontes do commit que apenas acrescenta o artefato.
