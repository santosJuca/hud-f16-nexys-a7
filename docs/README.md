# Documentação técnica

## Consolidação de 21/10/2026: revisão `4107002`

Os documentos abaixo preservam a auditoria e os resultados físicos mais recentes, sem substituir nem reescrever evidências históricas:

| Documento | Finalidade |
| --- | --- |
| [Validação física e rastreabilidade de 21/10](validacao_e_rastreabilidade_20261021.md) | 51/51 hashes, CI 62/62, bitstream calibrado, timing, Flash e bancada |
| [Arquitetura e montagem elétrica](arquitetura_e_montagem_20261021.md) | Diagrama em Mermaid, três barramentos I²C, 128 bits de CDC, joystick e buzzer |
| [Bancada virtual Verilator/GTKmm](simulador_vgasim_20261021.md) | Integração Linux, controles, ferramentas auxiliares e limites de reprodutibilidade |
| [Conclusão e trabalhos futuros](conclusao_e_trabalhos_futuros_20261021.md) | Texto acadêmico consolidado, prioridades e referências |

**Atenção:** as duas imagens ilustrativas da protoboard e do joystick e as capturas interativas estão fora deste commit; a inclusão de anexos binários permanece pendente. A documentação de 13/10 contém ligações históricas anteriores à pinagem JC10/E6.


O [README principal](../README.md) resume o HUD e as instruções de uso. Os guias abaixo detalham a branch `feat/modos-alertas`. A montagem de 13/10/2026 foi validada por relatos de bancada; os relatórios de 08/10 preservam seu contexto histórico.

| Documento | Conteúdo |
| --- | --- |
| [Validação da montagem em 13/10/2026](validacao_hardware_20261013.md) | Pinagem atual, Flash, resultados relatados, verificações digitais e pendências elétricas |
| [Pinagem](pinagem.md) | Pinos efetivamente usados no top e no XDC, controles e sensores |
| [Arquitetura](arquitetura.md) | Fluxo de dados e responsabilidades dos blocos ativos |
| [Entrega e demonstração](entrega_demo.md) | Estado físico informado, identidade do bitstream, ressalvas, roteiro, evidências e apresentação |
| [Sensores](sensores.md) | Interfaces, funções e limites de validação |
| [Testes](testes.md) | Regressão, cobertura e ressalvas da simulação |
| [Timing e recursos](timing_recursos.md) | Resultados do build de 08/10/2026 e cobertura das constraints |
| [Roadmap](roadmap.md) | Próximas verificações, sem ampliar o escopo funcional |
| [Estudo de vídeo auxiliar](vga_auxiliar.md) | Exploração não implementada de captura/composição de vídeo |
| [Catálogo de bitstreams](../bitstreams/README.md) | Versões, hashes, relatórios e status físico |

Os documentos descrevem o RTL em `rtl/top_reticula.sv` e o XDC `constraints/nexys_a7_reticula.xdc`. Os relatórios do build de 08/10 comprovam síntese e implementação; os ensaios físicos posteriores são resultados informados pelo operador e estão identificados separadamente em `entrega_demo.md`. Arquivos de auditoria e validação com datas anteriores são registros históricos, não substituem esta descrição do estado atual.
