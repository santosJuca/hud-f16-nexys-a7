# Acervo de bitstreams

Os diretórios preservam versões históricas, sem substituir arquivos ou renomear
caminhos já publicados. Nenhum bitstream foi gerado ou programado nesta revisão.

| Versão | Fonte / situação |
| --- | --- |
| [2026-10-05](2026-10-05/README.md) | `9c25900`: publicado com pendência de temporização VGA; não aprovado globalmente |
| [2026-10-05_3849e9e_heading_timing_fix](2026-10-05_3849e9e_heading_timing_fix/README.md) | `3849e9e`: correção do caminho de heading; resultados e limites no registro |
| [2026-10-05_hmc5883l](2026-10-05_hmc5883l/README.md) | Fontes publicadas em `de80521`: HMC e 42 testes; sem teste físico desse build |
| Fusão `84411c3` | Bitstream somente em `build/` local, SHA256 e resultados em [validação da fusão](../docs/validacao_fusao_sensores.md) |

A main permanece em `de80521`; fusão e organização documental estão em branches
separadas. Timing positivo não substitui validação de montagem ou interfaces externas.

## Política para novas versões

Usar `YYYY-MM-DD_nome-da-versao/` e incluir README com commit exato das fontes,
branch, data/ferramenta/dispositivo, funcionalidades, testes, DRC, timing,
recursos, limitações e status físico. Incluir SHA256 do `.bit` e dos relatórios,
com caminhos relativos à pasta, além de manifesto das fontes se o build anteceder
o commit de publicação. Distinguir commit-fonte de commit que apenas adiciona artefatos.

Preservar versões antigas e suas ressalvas. Publicar um bitstream como aprovado
somente após os critérios de [timing e recursos](../docs/timing_recursos.md).
Builds experimentais e intermediários ficam em `build/`, ignorados pelo Git.
