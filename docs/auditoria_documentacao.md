# Auditoria de documentação e organização

Auditoria em **06/10/2026**, no repositório `Trabalho-display-aviao-v2`.
Escopo: documentação, inventário elétrico e política de arquivos gerados.
Não houve alteração de RTL, testes, scripts, pinagem ou constraints.

## Estado inicial e preservação

| Item | Estado observado antes da edição |
| --- | --- |
| Branch inicial | `dev/fusao-sensores` |
| HEAD inicial | `84411c39e84df39d634250863321ae072ef5965b` |
| main local/remota | `de80521704b04bc6029f99fae43a71ad09780658` |
| Fusão local/remota | Ambas em `84411c3` após fetch |
| Alterações rastreadas | Nenhuma |
| Não rastreado | `QWEN.md`, preservado fora das alterações e dos commits |
| Branch de trabalho criada | `docs/organizacao-final`, derivada da fusão |

Foram consultados status, branches, log, diferenças, arquivos rastreados,
estrutura local, fontes e relatórios. `git diff --check` estava limpo. Nenhum merge,
reset, clean, rebase ou comando de programação foi usado. A main e a branch de
fusão foram preservadas.

Antes das edições, cópias de README, `.gitignore`, documentos e READMEs históricos
foram guardadas em `build/docs_organizacao_audit/before/`. Um manifesto local das
fontes rastreadas permite conferir preservação byte a byte. Backups existentes
não foram movidos, sobrescritos ou removidos.

## Inventário e organização

Na base havia 36 arquivos em `rtl/`, 49 em `tests/`, nove documentos em `docs/`,
um XDC, quatro scripts e 19 arquivos em `bitstreams/`, todos rastreados. O inventário
não conta backups locais como fontes ou testbenches.

As pastas já correspondiam às responsabilidades do projeto. Nenhum código foi
movido por estética. A nova navegação está no [índice técnico](README.md), com
guias atuais e históricos separados. O [catálogo de bitstreams](../bitstreams/README.md)
conserva nomes/caminhos publicados e define metadados para novas versões.

### Arquivos criados

- `docs/README.md`
- `docs/arquitetura.md`
- `docs/pinagem.md`
- `docs/sensores.md`
- `docs/testes.md`
- `docs/timing_recursos.md`
- `docs/vga_auxiliar.md`
- `docs/roadmap.md`
- `docs/auditoria_documentacao.md`
- `bitstreams/README.md`
- `bitstreams/2026-10-05_3849e9e_heading_timing_fix/README.md`

### Arquivos atualizados

- `README.md`: entrada do projeto, modos, arquitetura, reprodução, estado e limitações.
- `.gitignore`: regras portáveis para intermediários e backups locais.
- `docs/entradas_hud.md`: contrato de 57 bits com heading e fontes atuais.
- `docs/fusao_sensores.md`: precisão da descrição da constante de tempo do ganho 1/32.
- `docs/atitude_mpu.md` e `docs/auditoria_final.md`: identificação explícita como históricos.
- `docs/ideias_opcionais_sensores.md`: encaminhamento para o roadmap consolidado.
- `bitstreams/2026-10-05/README.md` e `bitstreams/2026-10-05_hmc5883l/README.md`: metadados e limites de cada pacote.

## Inconsistências corrigidas ou delimitadas

| Achado | Tratamento |
| --- | --- |
| README misturava estados antigos e atuais | Porta de entrada reescrita; fatos históricos mantidos nos registros |
| Instrução antiga de habilitar MPU com 1111 | Estado atual documentado: SENSOR usa MPU válido; switches são fallback |
| Interface sem campo heading e com altitude/velocidade chamadas simuladas | Tabela e origem dos dados corrigidas; 280 KT/36000 FT identificados como fallback |
| “Converge em 32 atualizações” no heading | Aproximadamente 63% em 32 e 95% em 95 atualizações no modelo ideal |
| Cabeçalho antigo do driver BMP descreve apenas probe | Guia de sensores explica recursos habilitados no top; RTL preservado |
| Ideias antigas sugeriam QMC como próximo heading | Roadmap distingue HMC já implementado de QMC, que exige outro driver |
| Pacote `3849e9e` sem README | Registro acrescentado a partir de manifesto/relatórios, sem inventar teste físico |
| Bitstream antigo com timing VGA pendente | Ressalva preservada e destacada no catálogo; não reclassificado como aprovado |

## Pinagem e expansão

A [auditoria de pinagem](pinagem.md) cruzou portas do top, XDC ativo, Master XDC
oficial fixado em uma revisão e manual/esquemático da Digilent. Resultado:

- **40 bits de portas**, 40 pinos distintos, todos com IOSTANDARD correspondente ao Master.
- Nenhum conflito entre atribuições ativas; comentários do XDC não são reservas.
- JA: um sinal ocupado e sete livres; JB: oito livres; JC: oito livres; JD: seis
  ocupados e dois livres. Total: **25 GPIOs digitais livres antes das propostas**.
- JXADC: quatro contatos ocupados, quatro livres em dois pares analógicos; separados
  da contagem de GPIO digital. Alimentação/terra não foram contadas como sinais.
- SW8 e SW9 são LVCMOS18. Recursos onboard dedicados não foram classificados como
  GPIO solto apenas por ausência no top.
- Propostas: JA2/D18 para VIDEO_AUX_ENABLE, JA3/E18 para seleção, JA4/G17 para debug
  e JA7/D17 para controle futuro. JB/JC ficam disponíveis para barramento de vídeo.

Ocupação física dos cabos e níveis dos módulos continuam **PENDENTES DE VALIDAÇÃO FÍSICA**.
O XDC foi preservado. O estudo de [VGA auxiliar](vga_auxiliar.md) recomenda começar
por fonte digital controlada; captura RGB analógica necessita ADC/front-end externo,
com recuperação de clock, condicionamento e compatibilidade elétrica.

## Arquivos gerados

Não foram encontrados `.log`, `.jou`, `.pb`, `.dcp`, `.bak` ou arquivos de `build/`
rastreados. Existem logs/journals locais de Vivado, relatórios auxiliares e nove
backups `.bak` em RTL/testes. Eles foram preservados. Os bitstreams e relatórios
históricos publicados são intencionais, não intermediários acidentais.

O `.gitignore` já cobria `/build/`, `/.Xil/`, `*.jou` e `*.log`. `*.bak`,
`clockInfo.txt` e `tight_setup_hold_pins.txt` dependiam do exclude local;
essas regras passaram à configuração versionada, junto de `*.pb` e `*.dcp`.
Isso não apaga arquivos nem remove artefatos já rastreados. Não foi criada regra
para ocultar `QWEN.md`, que continua não rastreado e fora do commit.

## Verificações desta revisão

| Verificação executada | Resultado |
| --- | --- |
| Links Markdown internos e âncoras dos documentos | Sem destino ausente após consolidação |
| Top × XDC × Master × tabela de sinais usados | 40 bits correspondentes; zero duplicação de pino |
| Mapas dos PMODs digitais | Posições e saldo 7/8/8/2 reconferidos |
| Preservação das fontes e artefatos técnicos | 106 arquivos protegidos pelo manifesto anterior sem alteração |
| Manifesto do build da fusão | 39 arquivos correspondentes às fontes atuais |
| Integridade do acervo | Três bitstreams históricos e relatórios cobertos por manifestos conferidos |
| Integridade do bitstream local da fusão | SHA256 corresponde ao registro de validação |
| Compilação estrutural Icarus feita nesta revisão | `EXIT_TOP=0` |
| `git diff --check` | Limpo |
| Nova regressão completa | Não repetida: nenhum RTL/XDC/teste/script mudou |
| Novo Vivado | Não executado: alteração documental e `.gitignore` |
| Programação / validação física | Não executadas |

A compilação utilizou `iverilog -g2012 -s top_reticula`, `tests/xadc_stub.sv` e
`rtl/*.sv`, com saída em `build/docs_organizacao_audit/top_completo`.
Logs e verificações locais estão nessa mesma pasta, ignorada pelo Git.

## Resultados anteriores reconferidos

O log existente contém os 46 bancos e a mensagem final de aprovação. Os relatórios
associados ao manifesto registram WNS **+0,770 ns**, TNS **0**, WHS **+0,043 ns**,
THS **0**, route completo e DRC **0 erros/56 avisos**. Recursos: **10.838 LUT,
6.263 FF, 32 DSP48E1, 0 BRAM, 1 XADC**. São resultados do build da fusão, não uma
nova implementação desta branch documental. Detalhes e limites de temporização
externa estão em [timing e recursos](timing_recursos.md).

A revisão não conclui calibração, orientação física, drift, resposta térmica,
altitude/VSI nem compatibilidade de vídeo externo. Essas atividades permanecem
**PENDENTES DE VALIDAÇÃO FÍSICA**, priorizadas no [roadmap](roadmap.md).
