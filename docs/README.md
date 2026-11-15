# Documentação do HUD F-16

Comece pelo [README principal](../README.md). A versão recente é **5D7A3AE2**,
preservada como pacote reproduzível. Os módulos da raiz pertencem à base v1.1
anterior e têm documentação própria.

## Firmware recente e entrega

| Documento | Conteúdo |
| --- | --- |
| [Guia 5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/README.md) | Operação, calibração, testes, build, vídeo e recuperação |
| [Manifesto](../firmware/calibracao-guiada-5d7a3ae2/MANIFESTO.json) | Hashes, recursos, parâmetros e limites |
| [Relatórios Vivado](../firmware/calibracao-guiada-5d7a3ae2/relatorios/) | Síntese, utilização, timing roteado, CDC, DRC e bus skew |
| [Aceites](../firmware/calibracao-guiada-5d7a3ae2/aceites/) | Ensaios relatados, Flash/readback e ciclo físico de energia |
| [Entrega e demonstração](entrega_demo.md) | Requisitos, evidência de pipeline e anexos necessários |
| [Consolidação de 15/11](consolidacao_20261115.md) | Origens, decisões e validação da integração |
| [Atlas elétrico](atlas-eletrico/README.md) | Pranchas e PDF; conferir com o XDC do perfil utilizado |

## Base v1.1 e registros anteriores

| Documento | Conteúdo |
| --- | --- |
| [Guia v1.1 preservado](historico/README_baseline_20261106.md) | Controles, fontes e reprodução da base anterior |
| [Arquitetura v1.1](arquitetura.md) | Fluxo e composição no RTL da raiz |
| [Pinagem v1.1](pinagem.md) e [sensores](sensores.md) | Interfaces da base; não substituem o XDC 5D7A3AE2 |
| [Testes v1.1](testes.md) | Regressão da raiz, vídeo, captura e ferramentas Python |
| [Consolidação do PR #6](consolidacao_20261106/README.md) | Cobertura das branches, relatórios e recuperação |
| [Validação física v1.1](HUD_V1_1_VALIDACAO_FISICA.md) | Oito verificações relatadas, com identidade e limites |
| [Builds históricos](../bitstreams/README.md) | BITs e relatórios de outubro |
| [Timing histórico](timing_recursos.md) | Métricas de 08/10, não da versão recente |
| [Entrega de 08/10](historico/entrega_20261008.md) | Registro anterior preservado |
| [Estudo de VGA externo](vga_auxiliar.md) | Proposta histórica; não é a reprodução SD/DDR2 atual |

Arquivos datados preservam resultados da versão indicada. O registro posterior
de aceite não altera retroativamente o status de um build anterior.
