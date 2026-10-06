# Documentação técnica

Referência atual: fontes de `84411c39e84df39d634250863321ae072ef5965b`, na
branch `dev/fusao-sensores`. Esta organização é uma branch derivada de documentação;
não altera a main nem promove a fusão. Comece pelo [README principal](../README.md).

## Guias atuais

| Documento | Conteúdo principal |
| --- | --- |
| [Arquitetura](arquitetura.md) | Módulos, clocks, fluxo dos dados e seleção das fontes |
| [Pinagem](pinagem.md) | Cada porta ativa, conectores, tensões e disponibilidade para expansão |
| [Sensores](sensores.md) | Interfaces reais, escalas, montagem e limites das medições |
| [Fusão](fusao_sensores.md) | Equações, aritmética fixa, validade e recuperação dos estimadores |
| [Entradas do HUD](entradas_hud.md) | Contrato do barramento interno, unidades e atualização por quadro |
| [HMC5883L](hmc5883l.md) | Driver, ordenação XYZ e cálculo magnético por CORDIC |
| [Testes](testes.md) | Como executar, cobertura e limites da simulação |
| [Timing e recursos](timing_recursos.md) | Critérios de aceitação, recursos e proveniência do build |
| [VGA auxiliar](vga_auxiliar.md) | Estudo de captura, composição, clocks e memória; não implementado |
| [Roadmap](roadmap.md) | Prioridades, dependências e validação física |
| [Auditoria documental](auditoria_documentacao.md) | Inventário, inconsistências corrigidas e verificações desta revisão |
| [Catálogo de bitstreams](../bitstreams/README.md) | Artefatos históricos e política de publicação |

## Registros históricos

Estes documentos preservam fatos de versões anteriores. Não usar comandos de
seleção, quantidades de testes ou timing histórico como descrição da branch atual.

| Registro | Alcance |
| --- | --- |
| [Validação da fusão](validacao_fusao_sensores.md) | Resultado técnico de 06/10/2026 que originou `84411c3` |
| [Evolução da atitude MPU](atitude_mpu.md) | Integração gradual e observações físicas anteriores à fusão heading/vertical |
| [Auditoria final anterior](auditoria_final.md) | Estado de 03/10/2026 |
| [Auditoria inicial](auditoria.md) | Revisão de 27/09/2026 |
| [RF-08](rf08.md) | Modos e requisitos anteriores; conserva referência de origem do projeto |

As antigas [ideias de sensores](ideias_opcionais_sensores.md) foram incorporadas ao
roadmap. A fusão atual, calibrações e expansões estão **PENDENTES DE VALIDAÇÃO FÍSICA**.
