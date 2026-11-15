# Reconciliação final dos desenvolvimentos locais do HUD F-16

## A. Estado identificado e preservado

Base da integração: main `a6f47b9b373bfd2dd4f6c23288cd0f2561592959`, confirmada no
GitHub e no repositório local em 15/11/2026. A integração está em
`/home/santojuca/Downloads/hud-reconciliacao-local-20261115`, branch
`integration/reconciliacao-local-20261115`, ainda sem novos commits.

Foram inventariados todos os oito worktrees originais do repositório, seus HEADs,
branches, diffs unstaged/staged, arquivos não rastreados, ignorados e commits locais
sem referências remotas. Nenhum conteúdo original foi alterado. Os três conjuntos
com trabalho não commitado permanecem:

| Worktree | HEAD | Estado confirmado antes da integração |
| --- | --- | --- |
| `Trabalho-display-aviao-v2` | `85da5f7` | 9 arquivos modificados e 2 testes novos |
| `hud-video-modos-20261106` | `c481ceb` | 20 modificados; 6 arquivos novos em 3 entradas de status |
| `Trabalho-display-aviao-v2-video-sd` | `90e5e78` | 4 testes modificados e 4 arquivos de cache em 2 entradas |

Não havia alterações staged. Os demais worktrees estavam limpos, inclusive o de
consolidação `c481ceb` e o de organização `8c282f6`. Os três commits locais
`5eb6c8a`, `b7c78cd` e `b2c86e4` têm patch-id idêntico a `0053899`, `d096e68` e
`d00eb57`, já incorporados ao histórico da main. Não precisam ser reaplicados.

Os arquivos ignorados incluem builds, validações, BITs/MCS, backups `.bak`, logs
e caches. Foram preservados; não foram promovidos a fonte por data de modificação.
Os worktrees são divergentes: não existe um único HEAD que represente todo o conteúdo
local. A data mais nova de uma cópia de BIT também não indica uma nova compilação.

### Código, artefatos e bancada são estados distintos

| Estado | Identificação e evidência |
| --- | --- |
| Último código da main | `a6f47b9`, que integra PR #6 e snapshot `057b586` |
| Código local desta integração | Mesmo RTL/perfil da main; ferramentas, testes e documentação alterados sem commit |
| Última implementação recente identificada | Build de 13/11 de 5D7A3AE2; os 88 arquivos HUD, 3 arquivos MIG e genéricos do pacote coincidem com suas entradas locais |
| Último BIT recente identificado | `ad8d6d7902bd50ed2924de9eb6b159d1d5b3ca8614247476aae44e0f79ee027a`; cabeçalho: 13/11/2026, 18:56:53, USERCODE5D7A3AE2 |
| Checkpoint roteado desse BIT | SHA-256 `4f451a9d247de0b9cc79f640bd94840b25ac14ca425d6b5738a5400f8aad2bd3`, reconferido |
| Último aceite físico localizado | 5D7A3AE2; relatos de bússola, vídeo, horizonte, POUSO e ciclo físico de energia em 13/11 |
| Última gravação Flash registrada | MCS SHA-256 `c7a16ae94504167fa432fc04d2accf8c6a0595c30f2ba68745008ae187dc11fd`; imagem BIN e readback arquivado são idênticos, SHA-256 `a1d99f09e991c7b53b52a6f2ad144304189eccdda2ec038f3e5e77ae5e7a6b0f` |
| Último boot físico relatado | Confirmação do operador em 13/11, 19:34; complementa o resultado anterior que ainda aguardava desligar/religar |
| Imagem presente na placa/Flash hoje | **INDETERMINADA**: não houve acesso ao dispositivo nesta tarefa |

[Identidades dos artefatos](evidencias/reconciliacao_local_20261115/artefatos_identificados.json)
e [aceites publicados](../firmware/calibracao-guiada-5d7a3ae2/aceites/) preservam a
proveniência e os limites. Comparação com celular não é qualificação metrológica.

## B. Reconciliação por arquivo e subsistema

A [matriz completa](matriz_reconciliacao_local_20261115.md) classifica as 45
entradas de arquivos locais, além de testes e estudos encontrados fora dos três
worktrees sujos. Para cada item, indica origem, comparação com a raiz/pacote recente,
decisão e evidência. Os patches originais e SHA-256 estão em
`build/reconciliacao-local/estado-original.json` e `matriz-reconciliacao.json`.

| Subsistema | Resultado da comparação | Decisão |
| --- | --- | --- |
| microSD/SPI, CRC e buffers | O pacote recente já contém as evoluções SD/DDR2 e publicação; o arquivo B++ depende de layout específico | Preservar RTL, clocks e genéricos; não reintroduzir perfis antigos |
| Formato e conversão | O conversor RGB332 da base ignorava `seconds` em entrada real | Corrigir a ferramenta e seu teste; não modificar o vídeo/cartão existente |
| Pipeline de instrumentos | Testes de equivalência, âncoras e rumo ao vivo estavam fora do pacote publicado | Recuperar e executar contra as fontes recentes |
| SOLO/VOO/POUSO | Sequenciamento e espera por publicação já estão presentes; teste antigo esperava término da decolagem | Preservar a regra recente e a cobertura de publicação, sem restaurar comportamento antigo |
| Composição, clipping, prioridades e esteira híbrida | Fontes recentes coincidem com o build final; comparadores visuais anteriores dependem de baseline externo | Não trocar código por um candidato anterior; manter estudos separados |
| Bússola e inclinação | Heading alinhado e recuperação já incorporados; calibração de 08/11 é anterior à versão com perfil inicial 3D e calibração guiada 2D | Preservar perfil 67/−181/−226, ganhos 3923/4004/4390 e alinhamento81; arquivar os dados antigos |
| MPU/I²C | Driver e teste completos de recuperação já estavam no pacote, mas o banco excedia o timeout anterior | Recuperar a execução com os tempos I²C originais; sem mudar RTL |
| Orientação MPU | Teste local não rastreado verificava eixos e independência do heading | Incorporar o teste fora do snapshot, nas configurações anterior/corrigida |
| Mira e LOCK | Passo fixo, limiar e travas independentes já presentes | Não reaplicar patches de 19/10; preservar testes existentes |
| Comandos e alinhamento | Versão recente prioriza SW4 e inibe captura; teste legado esperava contrato anterior | Novo teste do contrato recente e recuperação do teste de isolamento de BTNL |
| XDC/atlas | Ambos os XDC atuais usam buzzer JD4/G3 | Corrigir a afirmação documental anterior de divergência; nenhuma pinagem alterada |
| Builds, CAD, caches e backups | Material histórico ou gerado | Preservar, sem copiar builds/caches para a integração |

## C. Melhorias incorporadas na área isolada

1. `tools/convert_video_for_fpga.py`: encaminha `seconds` ao FFmpeg também para
   entrada real. O padrão continua 2 s; a documentação agora o explicita.
2. `tests/test_convert_video_for_fpga.py`: recupera o teste local que reproduziu
   60 quadros em vez de 30 ao pedir 1 s de um vídeo real de 2 s.
3. `tests/test_build_video_bitstream.py`: recupera verificações do Tcl efetivo até
   `synth_design`, sem Vivado; rotação muda apenas os flags magnéticos e perfis
   SPI não qualificados são recusados antes de criar o build. Nenhum novo clock
   ou perfil físico foi habilitado.
4. `tests/tb_top_mpu_orientacao.sv`, `tb_alignment_routing.sv`, `tb_compass_tilt.sv`,
   `tb_heading_video_live.sv`, `tb_video_pipe_equivalence.sv` e
   `tb_video_operacao_f16_anchors.sv`: testes locais recuperados sem alterar seus bytes.
5. `tests/tb_hud_dispatch_latest.sv`: verifica o contrato atual, inclusive prioridade
   de SW4, rearme, grade e ausência de comandos fantasmas. O teste antigo permanece
   válido para a base v1.1, sem ter sua expectativa alterada para apenas fazê-lo passar.
6. `scripts/test_latest_reconciliation.sh`: reproduz a suíte publicada em cópia
   isolada e executa os complementos. O banco MPU recebe até 600 s; timeout é falha.
7. `scripts/report_fmax_checkpoint.tcl`: verifica hash e dispositivo do DCP e extrai
   STA, recursos, CDC, DRC e Fmax em saída nova; não sintetiza nem gera BIT.
8. Os quatro registros da medição de 08/11 e o contexto de orientação foram
   preservados em [histórico](historico/README.md), sem ativar seus coeficientes.
9. README, índice, guia de conversão, atlas e relatório anterior corrigidos;
   workflow preparado para a suíte complementar, com prazo de 20 min no job recente.

**Nenhum RTL, XDC, MIG, genérico ou artefato físico aprovado foi alterado.**
A revisão melhora ferramentas e cobertura sem inventar uma nova versão física.

## D. Validações e limites

### Executado nesta reconciliação

| Verificação | Resultado |
| --- | --- |
| Conversor antes da correção | FAIL reproduzido: 60 quadros, esperado 30 |
| Conversor depois da correção | PASS, inclusive integridade/padding e preservação de saída existente |
| Ferramentas Python/Tcl | 12 testes PASS; sem Vivado, cartão ou placa nos testes do wrapper |
| Suíte publicada recente | PASS: cenários de treino/holdout, falhas/controles/display, aritmética, regressões selecionadas e integração do top |
| Dispatcher atual | PASS; contrato distinto do teste legado |
| Orientação local recuperada | PASS nas configurações CORRIGIDO=0 e 1; os vetores são sintéticos |
| MPU completo | PASS: identificação, filtros, leituras, falhas, SDA retida, nove clocks e liberação de linha permanentemente baixa |
| Rumo ao vivo durante vídeo | PASS: atualização, wrap, fallback e recuperação |
| Equivalência do pipeline | PASS em 4.800 quadros, em dois perfis |
| Âncoras de velocidade/altitude e fases | PASS nos pontos definidos no teste |
| Alinhamento e captura | PASS: prioridade SW4 e BTNL retido na entrada/saída |
| Compensação de inclinação | PASS: 99 poses sintéticas por mapeamento MAP=0/1, validade, stale, overflow e singularidade |
| Runner final em diretório limpo | PASS do início ao fim; evidências em `build/reconciliacao-local/final/` |
| Vivado 2026.1 | Checkpoint identificado reaberto; STA/utilização/CDC/DRC e Fmax extraídos |

A execução exploratória duplicada do MPU foi interrompida e não é contabilizada;
o resultado PASS acima é do runner integrado. A fonte original e seus tempos não
foram acelerados. O registro publicado `regressoes.json` permanece histórico e
inalterado; a evidência nova complementa seu estado INCONCLUSIVO anterior.

A regressão da base (84 bancos, nove testes Python originais e vídeo/captura) foi
confirmada no [CI da main a6f47b9](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/43733362726),
concluído com sucesso. Não foi apresentada como nova execução local desta tarefa.
O RTL da base é idêntico; a mudança do conversor foi exercitada pelos 12 testes
locais. O workflow modificado está apenas preparado: não foi publicado ou executado
no GitHub nesta tarefa.

### Checkpoint da versão 5D7A3AE2

A [análise identificada](evidencias/reconciliacao_local_20261115/analise_checkpoint.json)
e a [Fmax extraída](evidencias/reconciliacao_local_20261115/fmax_estimado.rpt) registram:

| Métrica | Resultado reconferido |
| --- | ---: |
| WNS / WHS | +0,070 / +0,019 ns |
| TNS / THS | 0 / 0 ns |
| WPWS | +0,206 ns |
| LUT / FF | 22.684 / 16.800 |
| BRAM tiles / DSP | 64 / 82 |
| DRC | 0 erros, 180 avisos |
| CDC resumido | 3 endpoints unsafe, 0 unknown; não encerrados por esta análise |
| Fmax estimada, domínio principal | 100,705 MHz, com clock configurado 100 MHz |
| Fmax estimada, pixel | 64,025 MHz, com clock configurado 25 MHz |

A estimativa usa `1000/(período−slack)` para caminhos de setup de um ciclo no mesmo
domínio. Não é varredura de frequência, Fmax global ou autorização para overclock;
não qualifica caminhos entre clocks, I/O nem a interface física DDR2/SPI.
Os relatórios detalhados novos ficam em `build/reconciliacao-local/sta/reproducivel/`.
O relatório CDC anterior identifica três CDC-10 e um CDC-8 pendentes. Não foram
adicionados waivers ou relaxadas constraints.

Não houve nova síntese/implementação: as entradas do FPGA não mudaram. A reabertura
do DCP é análise do artefato anterior, não um build nem ensaio físico novo.

## E. Pendências reais e itens opcionais

- **Bloqueios de qualificação física:** CDC-10/CDC-8, timing externo SPI, taxa
  efetiva de vídeo, precisão/repetibilidade magnética e restauração física do backup.
  O aceite funcional de 13/11 não elimina esses limites.
- **Dependência operacional fora do Git:** B++ de 368.640.512 bytes, SHA-256
  `229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`, reconferido
  no arquivo local. O perfil espera LBA 31837888 e 720001 setores; o layout atual
  do cartão não foi consultado. A release pública de mídia contém o arquivo anterior.
- **Publicação:** nenhum commit, push, PR ou merge está autorizado nesta etapa.
- **Opcional:** ampliar SPI, novos perfis visuais, máscara VGA externa, liberação de
  fabricação do gabinete ou inclusão de comparadores visuais de candidatos antigos.
  Não são requisitos para incorporar a correção e os testes desta revisão.

### Entrega acadêmica

Enunciado consultado: `PT - Desafio Sistemas Digitais AEL PLD 2026.pdf`, disponível
fora do Git em Downloads, SHA-256
`910d2f0293b72ad8eecf3fdc931284b68e9d498ae5613c70544d9875130bc342`.
A cópia de nome exato 2026(2) não foi localizada; não se afirma identidade entre versões.

| Item do enunciado | Evidência e pendência |
| --- | --- |
| RF-01 a RF-10 | Código/testes da base preservados e testes recentes complementares; relacionar os trechos da demo à versão demonstrada |
| Arquitetura e pipeline gráfico | Arquitetura funcional existente; os testes recuperados verificam alinhamento temporal de dados de vídeo/instrumentos, não substituem uma captura temporal RGB/HS/VS do raster |
| Máquina de estados e modos | Controle de modo, sequência de vídeo, publicação e operação; mostrar estados/transições da versão selecionada |
| Interfaces/periféricos | XDC, guia e atlas existentes; nenhum cabeamento ou nível elétrico requalificado nesta revisão |
| Síntese, timing, utilização e Fmax | Relatórios do artefato identificado e Fmax recém-extraída disponíveis; manter limites de STA externo |
| Projeto Vivado/README | Scripts, constraints, MIG e parâmetros preservados; instruções de reprodução e teste atualizadas |
| Relatório final e apresentação | Ainda precisam ser montados como entregáveis finais |
| Demo VGA | Há aceites escritos; falta anexar uma gravação identificada cobrindo os requisitos e a evidência temporal do pipeline |
| CI | Main anterior aprovada; novo workflow local precisa executar após autorização de publicação |

O requisito sem framebuffer externo é atendido pelo núcleo procedural da base;
a extensão de vídeo DDR2 não deve ser apresentada como conforme a essa restrição
sem aceite do professor. Sensores, calibração guiada, gabinete e mídia de fundo são
extensões. A [checklist de entrega](entrega_demo.md) continua aplicável.

## F. Reprodução e revisão

Na raiz do worktree isolado:

```bash
python3 -m unittest discover -s tests -p 'test_*.py'
mkdir -p build
bash scripts/test_latest_reconciliation.sh build/reconciliacao-reproducao
```

Python3, FFmpeg e Tcl são usados nos testes das ferramentas; Python3 e Icarus
(`iverilog`/`vvp`) no runner recente. Use um diretório de saída novo, pois as saídas
anteriores são preservadas. Para a estimativa do checkpoint original:

```bash
/caminho/do/Vivado/2026.1/bin/vivado -mode batch -nojournal -nolog \
  -source scripts/report_fmax_checkpoint.tcl \
  -tclargs /caminho/routed.dcp /caminho/saida_nova \
  4f451a9d247de0b9cc79f640bd94840b25ac14ca425d6b5738a5400f8aad2bd3
```

O DCP é um artefato externo, identificado no manifesto; o script recusa hash ou
FPGA divergente e saída existente. Nenhum desses comandos programa hardware.

O diff completo, incluindo novos arquivos, está preservado em
`build/reconciliacao-local/integracao-final.patch`. Inventário, diffs originais,
logs, JSONs e verificações ficam em `build/reconciliacao-local/`, fora do Git.

## G. Próxima decisão

**PRONTA PARA REVISÃO E COMMIT.** O runner final passou, os oito worktrees
originais mantêm HEAD/status e hashes dos arquivos locais, e a main continua em
`a6f47b9`. O [resumo verificável](evidencias/reconciliacao_local_20261115/testes.json)
registra os resultados. Não há novo BIT para programar. Qualquer commit,
push, PR, merge ou programação exigirá autorização explícita posterior.
