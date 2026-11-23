# Documentação do HUD F-16

Comece pelo [README principal](../README.md). O firmware de bancada de referência é **5D7A3AE2**,
preservado como pacote reproduzível. Os módulos da raiz pertencem à base v1.1
anterior e têm documentação própria.

## Candidato v1.2 documentado

A [arquitetura v1.2 `12000007`](hud-v12-12000007/README.md) reúne documentos em PDF/DOCX, catálogo e conexões em CSV e 15 esquemas nativos do Vivado 2026.1. A configuração usa SD nativo/DDR2 e tem fontes próprias no pacote da release. Não substitui a base v1.1 ou os aceites físicos do 5D7A3AE2.

## Firmware recente e entrega

| Documento | Conteúdo |
| --- | --- |
| [Guia 5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/README.md) | Operação, calibração, testes, build, vídeo e recuperação |
| [Manifesto](../firmware/calibracao-guiada-5d7a3ae2/MANIFESTO.json) | Hashes, recursos, parâmetros e limites |
| [Relatórios Vivado](../firmware/calibracao-guiada-5d7a3ae2/relatorios/) | Síntese, utilização, timing roteado, CDC, DRC e bus skew |
| [Aceites](../firmware/calibracao-guiada-5d7a3ae2/aceites/) | Ensaios relatados, Flash/readback e ciclo físico de energia |
| [Entrega e demonstração](entrega_demo.md) | Requisitos, evidência de pipeline e anexos necessários |
| [Reconciliação local](reconciliacao_local_20261115.md) | Comparação de worktrees, melhorias recuperadas e testes complementares |
| [Consolidação de 15/11](consolidacao_20261115.md) | Origens, decisões e validação da integração |
| [Montagem confirmada e interfaces](montagem.md) | Duas caixas, interfaces e limites da documentação elétrica |
| [Atlas elétrico](atlas-eletrico/README.md) | Pranchas e PDF de referência por perfil |
| [Pipeline do MVP](entrega_academica/mvp_v11/README.md) | Captura simulada, identidade do candidato e reprodução |

## Base v1.1 e registros anteriores

| Documento | Conteúdo |
| --- | --- |
| [Guia v1.1 preservado](historico/README_baseline_20261106.md) | Controles, fontes e reprodução da base anterior |
| [Arquitetura v1.1](arquitetura.md) | Fluxo e composição no RTL da raiz |
| [Pinagem v1.1](pinagem.md) e [sensores](sensores.md) | Interfaces da base; não substituem o XDC 5D7A3AE2 |
| [Testes v1.1](testes.md) | Regressão da raiz, vídeo, captura e ferramentas Python |
| [Consolidação do PR #6](consolidacao_20261106/README.md) | Cobertura das branches, relatórios e recuperação |
| [Validação física v1.1](HUD_V1_1_VALIDACAO_FISICA.md) | Oito verificações relatadas, com identidade e limites |
| [Timing histórico](timing_recursos.md) | Métricas de 08/10, não da versão recente |
| [Entrega de 08/10](historico/entrega_20261008.md) | Registro anterior preservado |

Arquivos datados preservam resultados da versão indicada. O registro posterior
de aceite não altera retroativamente o status de um build anterior.

## Arquivos históricos

O [commit 28e736d](https://github.com/santosJuca/Trabalho-display-aviao-v2/tree/28e736db2b0962ae3494660a8b84944ad087d8c5)
preserva os gabinetes CAD preliminares, os esquemáticos de outubro, os BITs antigos
com seus manifestos e relatórios, e os estudos de VGA externo e SPI. A árvore
histórica é recuperável sem alterar o checkout atual:

```bash
git ls-tree -r --name-only 28e736db2b0962ae3494660a8b84944ad087d8c5 -- gabinete mechanical docs/esquematico bitstreams
git archive --format=zip --output=hud-historico.zip 28e736db2b0962ae3494660a8b84944ad087d8c5 -- gabinete mechanical docs/esquematico bitstreams
```
