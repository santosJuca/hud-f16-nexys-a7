# Consolidação geral do HUD F-16 — 06/11/2026

Repositório confirmado: `santosJuca/Trabalho-display-aviao-v2`, privado, branch padrão `main`. Integração isolada em `integration/consolidacao-geral-20261106`, baseada na main remota `0081e1dfc0e726c84a37bd41a31e9508d5876b48`. Diretório original e demais worktrees foram preservados.

## Resultado e limite de promoção

O candidato reúne o firmware funcional v1.1, recupera os testes locais, CADs e documentos exclusivos e torna os builds reproduzíveis. O RTL não foi redesenhado e coincide com `622eacb`. A falha de timing do build básico foi corrigida pela estratégia de implementação, sem mudar algoritmo/constraints. O perfil de vídeo passou síntese, route, timing, CDC, DRC e bitstream.

**A consolidação não está promovida a firmware fisicamente estável nem autorizada para fabricação.** Os episódios de perda de vídeo, deslocamento da bússola e inconsistência angular durante ajustes precisam de reteste dirigido na Nexys A7-100T. O mapa físico do cartão e a segurança elétrica XADC/SPI também não foram requalificados. Nenhum JTAG, Flash ou cartão foi escrito. O PR de consolidação deve permanecer separado da main até encerrar os bloqueios aplicáveis.

## Inventário e cobertura

- [22 branches / 37 referências e 138 commits alcançáveis](branches.md), mais um commit de reflog com timing antigo defeituoso.
- [Matriz completa de funcionalidades](cobertura.md), incluindo recursos integrados, substituídos, experimentais e pendências.
- [Resultados e relatórios](testes.md), com métricas atuais e distinção de evidências físicas históricas.
- [Preservação e recuperação](recuperacao.md), incluindo hashes das releases v1.0/v1.1 e backup local verificável.

## Histórico da integração

| Commit | Mudança |
|---|---|
| `dc5bce7` | Merge revisado da v1.2 documental, incluindo v1.0/v1.1; preserva o RTL validado |
| `1e15eed` | Recupera os quatro testes locais: conexões de simbologia/top, debounce de comandos e validade vetorial |
| `b018425` | Importa branch case, gerador e manifesto parcial v1.3.2 |
| `6ed0e47` | Importa projeto mecânico preliminar Stealth V3 sem alterar RTL |
| `4d7160a`, `eb59283`, `0139aa3`, `596784a` | Recupera os quatro commits documentais de bancada/cabo VGA por cherry-pick |
| `0b062f8` | Normaliza referência dos builds, remove caminho absoluto do Vivado, permite perfil de montagem e amplia o CI para testes existentes |
| `8690b49` | Recupera STEP/DXF/manual do kit R2 com hashes originais |
| `ef7c92b` | Fecha timing do build básico com Performance_Explore |

Os commits posteriores documentam os resultados e a cobertura final; o log da branch é a referência exata. Não houve conflito textual nos merges. As decisões semânticas foram: manter a calibração HMC de 31/10 para esta montagem; preservar a cadeia de atitude v1.1 e a complementar legada; evitar reintroduzir seleção SENSOR/MANCHE e correções CI anteriores já substituídas; manter a máscara VGA externa experimental no PR #5; conservar os dois projetos de gabinete sem tratá-los como uma única revisão fabricável.

Nenhum arquivo da main inicial foi eliminado. Caches, diretórios de build e bitstreams recém-gerados ficaram fora dos commits. Os arquivos do gabinete que já estavam no repositório e os recuperados do ZIP mantêm seus bytes; o link `ATUAL` aponta para o par STEP conferido.

## Pendências indispensáveis

1. Ensaiar em JTAG um candidato identificado por hash, usando mapa de cartão real reconferido e mantendo a QSPI v1.0 como recuperação. Não usar o BIT classificado simulation desta execução.
2. Reproduzir os ajustes SW4/BTNU/BTND, entradas/saídas de captura por BTNL, vistas SW5/SW6 e zero SW7, registrando vídeo, posição da bússola e resposta angular. Simulação aprovada não encerra os episódios físicos relatados.
3. Conferir eletricamente a rede XADC e qualificar a interface SPI antes de promover outro perfil. Não inventar pinos, tensões ou divisores.
4. Para regenerar o gabinete v1.3.2, recuperar os módulos auxiliares Python, STEP originais e ZIP-fonte v1.2 listados no README mecânico. A documentação recuperada não libera fabricação.

O aceite físico e as fontes CAD ausentes são impedimentos objetivos. Branches, tags e PRs anteriores não foram apagados, fechados ou alterados automaticamente.
