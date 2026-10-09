# Documentação técnica

O [README principal](../README.md) resume o HUD e as instruções de uso. Os guias abaixo detalham a implementação da branch `feat/modos-alertas`, referência no commit `84afb86`.

| Documento | Conteúdo |
| --- | --- |
| [Pinagem](pinagem.md) | Pinos efetivamente usados no top e no XDC, controles e sensores |
| [Arquitetura](arquitetura.md) | Fluxo de dados e responsabilidades dos blocos ativos |
| [Sensores](sensores.md) | Interfaces, funções e limites de validação |
| [Testes](testes.md) | Regressão, cobertura e ressalvas da simulação |
| [Timing e recursos](timing_recursos.md) | Resultados do build de 08/10/2026 e cobertura das constraints |
| [Roadmap](roadmap.md) | Próximas verificações, sem ampliar o escopo funcional |
| [Estudo de vídeo auxiliar](vga_auxiliar.md) | Exploração não implementada de captura/composição de vídeo |
| [Catálogo de bitstreams](../bitstreams/README.md) | Versões, hashes, relatórios e status físico |

Os documentos descrevem o RTL em `rtl/top_reticula.sv` e o XDC `constraints/nexys_a7_reticula.xdc`. Os relatórios do build de 08/10 são evidência de síntese e implementação, não de validação integrada na placa. Arquivos de auditoria e validação com datas anteriores são registros históricos, não substituem esta descrição do estado atual.
