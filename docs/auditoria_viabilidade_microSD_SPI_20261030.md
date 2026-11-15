# Viabilidade do microSD SPI no HUD Nexys A7-100T

Data: 30/10/2026. Baseline: `0271499a8538135abc6291e512b421382337c7c2`.

**Decisão: CONTINUAR COM AJUSTES.** Manter o WD Purple SC QD101 de 32 GB, o slot da Nexys A7 e o SPI. Usar inicialmente 400 kHz tanto na inicialização quanto na leitura. Carregar um recurso gráfico pequeno para BRAM, confirmar sua integridade e só então disponibilizá-lo à VGA. DDR2, SD nativo, outro cartão e outro módulo não são necessários para essa entrega.

A ausência dos parâmetros específicos dos fabricantes impede uma assinatura documental completa do enlace, mas não impede desenvolver nem qualificar experimentalmente este protótipo. A aprovação acadêmica deve identificar o exemplar, a implementação, a frequência e as condições efetivamente ensaiadas. **Este relatório aprova o caminho de desenvolvimento, não declara o hardware já qualificado nem libera um bitstream para programação.**

## 1. Escopo, preservação e evidências

Checkout inspecionado: `/home/santojuca/Downloads/Trabalho-display-aviao-v2-video-sd`. Remote: `https://github.com/santosJuca/Trabalho-display-aviao-v2.git`. Branch confirmada: `feat/video-sd-overlay`. HEAD e resolução de `0271499` coincidem com o SHA acima.

No início havia dois arquivos não rastreados: `docs/orcamento_temporal_spi_20261030.md` e `docs/solicitacao_tecnica_qd101_spi.md`. Não havia alteração rastreada. Esses arquivos foram tratados como trabalho preexistente e preservados. Não há `AGENTS.md` adicional no checkout nem `graphify-out/graph.json`; não foi criado um grafo.

Foram inspecionados os sete módulos SD, o trecho SD do top, a geração VGA, o CDC existente, o XDC, os scripts de build/diagnóstico e os testbenches SD. Foram consultados relatórios de síntese e pós-route existentes. Não houve alteração de RTL, XDC ou scripts; execução de Vivado, regressão, acesso JTAG, geração de bitstream, escrita em cartão, gravação de Flash, solda, commit, push ou merge nesta auditoria. O único arquivo novo no checkout é este relatório.

Ao concluir, a comparação SHA-256 dos 232 arquivos preexistentes rastreados ou não ignorados não encontrou alteração ou remoção. O HEAD permaneceu no baseline. Para reaproveitar evidência sem repetir os testes:

| Evidência local | Conferência e significado |
|---|---|
| `validation/signoff-20261030-config-io/sources-sha256.json` | Os 55 arquivos listados coincidem, por SHA-256, com o checkout. Incluem RTL, XDC, calibração e script da implementação. |
| `validation/spi-budget-20261030/reused-evidence-sha256.json` | As 26 entradas foram reconferidas por SHA-256, incluindo checkpoint, PDFs e relatórios reutilizados; nenhuma divergência. |
| `validation/finalization-20261030T101146Z/regression-summary.json` e `regression.log` | Execução anterior: 73 testbenches, saída zero, 256 linhas PASS e zero FATAL. Linhas PASS não são 256 testes independentes. Os cenários SD estão presentes no log. |
| `validation/spi-budget-20261030/throughput-test.txt` | Simulação anterior a 400 kHz: três setores, 1.536 bytes confirmados e CRC correto. Não é medição do QD101. |
| `validation/signoff-20261030-config-io/verified/` | Temporização, utilização, CDC e DRC do roteamento reanalisado. A origem do checkpoint e os commits anteriores estão registrados no manifesto preservado. |
| `validation/spi-budget-20261030/path-summary.json` | Atrasos internos dos caminhos SD extraídos anteriormente. Não incluem cartão e placa. |

A comparação por hashes permite reutilizar os resultados internos sem afirmar que houve nova síntese em `0271499`. Os manifestos anteriores continuam com aprovação falsa. A conclusão desta auditoria acrescenta um caminho de qualificação experimental; não reescreve nem converte esses manifestos em aprovação.

## 2. O que existe de fato

### 2.1 Controlador, leitura e integração

O escopo real está mais avançado que os três módulos enumerados no pedido:

| Arquivo | Implementação observada |
|---|---|
| `rtl/sd_spi_preamble.sv` | Controle de alimentação ativo em zero, espera programável e 80 clocks com MOSI/CS altos. |
| `rtl/sd_spi_command.sv` | Quadro de comando de 48 bits, espera R1, resposta estendida de 32 bits e oito clocks finais com CS alto. |
| `rtl/sd_spi_init.sv` | CMD0, CMD8, CMD55/ACMD41 repetidos e CMD58; verifica eco, R1, power-up e CCS do OCR; falhas e limite de tentativas. |
| `rtl/sd_spi_read_block.sv` | **CMD17 implementado**, argumento LBA, R1, token `0xFE`, 512 bytes, CRC16 e encerramento. CS permanece baixo até terminar dados/CRC. |
| `rtl/sd_spi_controller.sv` | Arbitragem entre inicialização e leitura, divisores independentes e solicitação explícita; nova leitura após erro recuperável. |
| `rtl/sd_diagnostic.sv` | Debounce de SW8 e comparação com um padrão específico; resultado publicado após `block_valid`. |
| `rtl/sd_spi_cmd0.sv` | Implementação antiga de CMD0; sem instância na cadeia ativa. Não precisa ser reescrita. |

`top_reticula.sv:109–143` conecta a cadeia ao slot e fixa a leitura em **LBA 2048** (`:127`). O subsistema é opcional, com `ENABLE_SD_SUBSYSTEM=0` por padrão (`:22`). A configuração C dos relatórios o habilita. O build genérico não deve ser confundido com a configuração C: `scripts/build_vivado.tcl` não habilita explicitamente SD e também avança até gerar bitstream. Não é o script adequado para executar indiscriminadamente nesta auditoria.

O top entrega os bytes somente ao diagnóstico. **Não há carregador de imagem, memória gráfica SD, conexão desses bytes ao compositor VGA, FAT, CMD18, CMD9/CMD10 ou controlador DDR2/MIG no RTL atual.** Há infraestrutura de vídeo e CDC para dados do HUD, não um framebuffer de imagens do cartão.

`data_valid` representa bytes provisórios. `block_valid` confirma o setor inteiro depois do CRC. Não é permitido tornar esses bytes visíveis na VGA antes dessa confirmação. A leitura SDHC usa endereçamento por setor, sem multiplicar LBA por 512. A inicialização exige CCS=1; rejeitar SDSC é uma limitação deliberada compatível com o cartão de 32 GB, não um defeito a corrigir para esta entrega.

### 2.2 Frequência e captura de MISO

O domínio SPI é `clk` de 100 MHz. SCK é uma saída controlada por enable; não é clock dos registradores de recepção. A VGA usa 25 MHz, com raster 800 × 525, aproximadamente 59,52 Hz.

```text
Tsys = 10 ns
H = HALF_PERIOD_CYCLES × 10 ns
fSCK = 100 MHz / (2 × HALF_PERIOD_CYCLES)
HALF = 125 → H = 1.250 ns → fSCK = 400 kHz
```

Os parâmetros de inicialização e leitura já são separados no controller e no top, mas **ambos valem 125 na configuração auditada**. Portanto, 400 kHz não é atualmente exclusivo da inicialização. O default isolado 2 de `sd_spi_read_block` não prevalece sobre a instância de 125. O benchmark permite outros valores; isso não os qualifica eletricamente.

O barramento é Mode 0: SCK baixo em repouso, primeiro MOSI preparado antes da primeira subida e demais bits atualizados na descida. Em `sd_spi_command` e `sd_spi_read_block`, MISO é consultado no mesmo `posedge clk` que agenda `sck <= 1`. Pela semântica de atribuição não bloqueante, **a captura interna precede a subida de SCK no contato do cartão**. A janela útil parte da descida anterior, que lança o bit do cartão, e termina na captura interna.

Essa posição não é automaticamente errada: a 400 kHz oferece nominalmente um semiciclo de 1,25 µs para a ida e volta. Também não está aprovada apenas por ser lenta. O retorno depende de SCK até o cartão, resposta do cartão, retorno MISO, caminho interno, setup e incertezas. A próxima descida fornece a referência para hold. Primeiro bit, término de CS, power-up e troca de engine precisam ser verificados fora da hipótese de transferência periódica.

Não há sincronizador MISO de dois estágios. O pad alcança 126 endpoints distintos, inclusive controle e enables, conforme a extração anterior. O relatório CDC sem erro crítico não demonstra segurança desses caminhos externos sem clock de referência declarado. Se MISO estiver estável durante a janela de captura, a ausência de dois flip-flops não constitui, por si, um erro de CDC: trata-se de retorno de uma interface comandada pelo host. Se houver transição na janela, o fanout direto pode produzir decisões incoerentes.

**Escolha mínima:** manter a fase atual a 400 kHz e verificar a janela do enlace. Não inserir dois flip-flops nem mover a captura como correção automática. Um sampler comum a 100 MHz é uma opção localizada se a revisão temporal demonstrar necessidade; sua latência de aproximadamente 20 ns precisa entrar no orçamento e seus primeiros/últimos bits precisam de teste. Ele não corrige alimentação, ringing ou descumprimento do protocolo. Não adicionar SCK como novo domínio de clock para resolver esse problema.

### 2.3 Pinagem e circuito real

O XDC ativo coincide com a seção Micro SD do [Master XDC oficial](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-100T-Master.xdc). O [esquemático Digilent 500-292 D.0](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7-sch.pdf), folha 2, foi também inspecionado visualmente na cópia local preservada.

| Sinal | Pino FPGA | Contato microSD | Estado atual |
|---|---|---|---|
| `SD_SCK` | B1 | 5, CLK | Saída SPI |
| `SD_CMD` | C1 | 3, CMD | MOSI |
| `SD_DAT0` | C2 | 7, DAT0 | MISO |
| `SD_DAT3` | D2 | 2, DAT3 | CS ativo baixo |
| `SD_RESET` | E2 | Controle de Q8 | Baixo liga a alimentação; não é comando de reset do cartão |
| `SD_CD` | A1 | Contato mecânico CD | Porta declarada, sem uso funcional |
| DAT1 | E1 | 8 | Disponível na placa, ausente da interface RTL ativa |
| DAT2 | F1 | 1 | Disponível na placa, ausente da interface RTL ativa |

As linhas usam o banco 35, nominalmente 3,3 V, e LVCMOS33. Q8 chaveia VDD, C191 é 100 nF e há pull-ups de 100 kΩ nas cinco linhas CMD/DAT. R118/R121 são de 10 kΩ no controle de alimentação/detecção; R124 de 100 Ω pertence à detecção. D11/D12 são redes de proteção; a folha consultada não identifica seu código comercial nem capacitância. Q8 tampouco possui nessa folha um modelo que permita calcular sua rampa. Não inventar parâmetros ou consultar um diodo genérico como substituto.

Não há resistor série discreto no trajeto direto FPGA–slot. Há ramos para o PIC24, com resistores de 49,9 Ω na folha USB HID; esses resistores não são terminações série do caminho direto. Os ramos são cargas mesmo quando o PIC deixa de dirigir o barramento.

Segundo o [manual Nexys A7, §11](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf), o PIC24 entrega o barramento e faz um ciclo de alimentação após a configuração da FPGA; a FPGA deve dirigir `SD_RESET` baixo para alimentar o slot. Estado físico, revisão montada, rampa e ausência de contenção ainda não foram medidos. Não usar boot por cartão durante o ensaio inicial; preservar o modo de configuração conhecido e executar posteriormente apenas uma configuração volátil de bancada autorizada.

### 2.4 Síntese, temporização e cobertura já disponíveis

Os relatórios identificam Vivado 2026.1, build 6511674, parte `xc7a100tcsg324-1`.

| Item | Evidência existente |
|---|---:|
| Síntese, configuração C: LUT / registradores | 12.974 / 7.264 |
| Pós-route reanalisado: LUT / registradores / DSP | 12.774 / 7.275 / 32 |
| BRAM utilizada / RAMB36 disponível | 0 / 135 |
| WNS / TNS | +0,337 ns / 0 |
| WHS / THS | +0,015 ns / 0 |
| WPWS / TPWS | +4,020 ns / 0 |
| Endpoints internos sem restrição | 0 |
| DRC | 0 erros; 55 avisos de pipeline DSP |
| CDC | 24 informações CDC-3; 112 avisos CDC-15 |
| Skew do barramento retido / limite | 1,414 ns / 10 ns |
| Caminho interno MISO máximo extraído | 12,514 ns |
| Caminho interno de geração SCK máximo extraído | 11,485 ns |

O XDC declara os clocks de sistema e pixel, trata os sincronizadores I²C e mantém o handshake do barramento retido com max-delay de 20 ns e bus-skew de 10 ns. Os 112 avisos CDC-15 se referem a esse barramento de dados do HUD. Não são 112 falhas demonstradas, nem uma validação do microSD.

**Resta `SD_DAT0` sem input delay aplicável e faltam os requisitos externos SD.** Slack infinito nos caminhos SPI significa ausência de restrição, não margem infinita. Os valores internos não incluem o enlace. O hold interno de 15 ps é positivo, mas pequeno; qualquer mudança futura exige nova análise da implementação afetada. Não reconstruir agora o projeto apenas para obter os mesmos números.

### 2.5 Cobertura dos testbenches e lacunas reais

| Testbench existente | O que cobre |
|---|---|
| `tb_sd_spi_preamble` | 80 clocks e níveis finais de alimentação/CS/MOSI |
| `tb_sd_spi_cmd0` | CMD0 e timeout da implementação antiga |
| `tb_sd_spi_command` | Quadro CMD8, resposta estendida, eco incorreto capturado e timeout |
| `tb_sd_spi_startup` | Preâmbulo integrado com CMD0/CMD8 |
| `tb_sd_spi_acmd` | CMD55, repetição de ACMD41 e CMD58/OCR |
| `tb_sd_spi_init` | Nove cenários de inicialização, tentativas, eco, CCS, power-up e timeouts |
| `tb_sd_spi_read_block` | 512 bytes/índices, LBA não nulo, leituras distintas, R1/token/CRC inválidos, timeout, start ocupado e reset |
| `tb_sd_spi_controller` | Sequência integrada, arbitragem, erro recuperável, bloqueio antes de init e reset no meio da transferência |
| `tb_sd_spi_throughput` | Divisão de clocks, contagem de overhead, múltiplos CMD17, conteúdo e CRC |
| `tb_sd_diagnostic` | Debounce, armamento e confirmação tardia do resultado |
| `tb_top_sd_integration` | Top habilitado/desabilitado, pedido por SW8, LBA 2048, LEDs, rejeição de CRC e preservação lógica da VGA |

Os modelos lançam MISO na descida de SCK sem modelar a carga e os limites AC do QD101. Portanto, os PASS demonstram o contrato lógico desses modelos. Não demonstram tDO, margem elétrica, comportamento do exemplar ou imagem SD visível.

Não foi necessário executar outro teste funcional nesta auditoria. As lacunas a resolver são bancada, timeout em caso de aceleração, identificação/conteúdo real do cartão e caminho de publicação para a VGA.

## 3. Fontes públicas, aplicabilidade e graus de certeza

Foi feita consulta concentrada às fontes primárias abaixo e reutilizadas as cópias oficiais já preservadas. Não foi enviado pedido aos fabricantes. A tentativa de recuperar a especificação 6.00 diretamente do portal não forneceu PDF utilizável nesta consulta; não foram importadas tabelas de cópias secundárias. A versão 9.10 serve como referência pública do protocolo e de suas omissões, sem atribuir retroativamente essa revisão ao produto SDA 6.0.

| Informação | Classificação | Base e limite |
|---|---|---|
| WDD032G1P0C, 32 GB, microSDHC, SDA 6.0, U1/Class 10 | Publicada pelo fabricante | [Product brief QD101 A03, dez/2020](https://documents.sandisk.com/content/dam/asset-library/en_us/assets/public/western-digital/product/embedded-flash/surveillance-wd-purple-microSD/product-brief-wd-purple-sc-qd101-ultra-endurance-microsd.pdf), pp. 1–2. Não contém tabela AC SPI. |
| Entrada em SPI por CMD0 com CS baixo; CMD17/CMD18 e CRC16; CID/CSD por bloco de 16 bytes | Garantida por especificação para dispositivos conformes ao perfil aplicável | [SD Physical Layer Simplified, capítulo 7](https://www.sdcard.org/downloads/pls/), cópia 9.10 local. Não é prova de conformidade do exemplar. |
| Condições elétricas e temporais SPI relacionadas ao modo SD | Garantida por especificação, com escopo | §§7.6, 7.7 e 7.8 fazem a relação explicitamente; §7.6 exclui a opção de drivers programáveis. Isso autoriza consultar o perfil correspondente, não qualquer tabela UHS. |
| Alimentação de perfil SD de alta tensão: 2,7–3,6 V; operação inicial em 3,3 V | Especificação do perfil; placa publicada | Referência SD, §2 e sequência de power-up; esquema/manual Digilent. Ainda não é VDD medido deste slot. |
| 25 MHz como teto de referência Default Speed | Especificação do perfil, condicionado à aplicação SPI e ao enlace | Relação de §§7.7–7.8; não equivale a garantir 25 MHz neste conjunto nem a habilitar High Speed/UHS-I. |
| Pinagem, nominal de 3,3 V, slot apto a SPI e SD nativo | Publicada pelo fabricante | Esquema, Master XDC e manual Digilent. Conferir revisão física antes de medir. |
| Limites LVCMOS33 e características da FPGA | Publicada pelo fabricante | [AMD DS181 v1.27.1](https://docs.amd.com/v/u/en-US/ds181_Artix_7_Data_Sheet), especialmente tabelas de níveis e metodologia de medição de I/O. Entrada lógica: baixo até 0,8 V, alto a partir de 2,0 V, nas condições especificadas. |
| 135 RAMB36, 4.860 Kb de BRAM no XC7A100T | Publicada pelo fabricante | [AMD DS180, tabela 4](https://docs.amd.com/v/u/en-US/ds180_7Series_Overview); consistente com o relatório Vivado. Não usar 1.188 Kb do resumo do manual como total de BRAM: 1.188 Kb corresponde à RAM distribuída na tabela AMD. |
| Frequência de 400 kHz, instante de captura e fluxo CMD17 | Observada no código e verificada em simulação anterior | Não classificar como medição física. |
| 48.761,77 B/s no modelo a 400 kHz | Resultado de simulação | Cenário específico de latência curta, não desempenho garantido do cartão. |
| Vazão em outras frequências e tempos de carregamento abaixo | Estimada por cálculo | Mesma estrutura de transferência; latência real ainda desconhecida. |
| tDO mínimo/máximo do QD101 e limites específicos de setup/hold SPI | Desconhecida para o exemplar/revisão | Brief não publica; tabelas relevantes são omitidas na especificação simplificada consultada. |
| Capacitância/impedância do cartão, comprimentos de trilha, modelos D11/D12/Q8 | Desconhecida em detalhe | Esquema não fornece o modelo completo do enlace. Não preencher com zero ou valores típicos de terceiros. |
| VDD real, tDO observado, ringing, repetibilidade e frequência utilizável | Não medida | Nenhum acesso a hardware nesta auditoria. |

Não se aplicam tabelas de SDR50/SDR104/DDR50 ou sinalização de 1,8 V ao SPI de 3,3 V. Não solicitar CMD11 nem anunciar velocidade UHS com base na inscrição do cartão. U1/Class 10 também não garantem vazão SPI de leitura.

O §7.8 relaciona o timing dos modos; ele não repõe os valores ausentes de §§6.6.5–6.6.7 e 7.5. Não há base nesta auditoria para adotar, por exemplo, 14 ns como tDO máximo garantido do QD101. Conhecer um valor típico ou medir um exemplar não cria esse limite de fabricação.

### Níveis de aprovação

| Nível | É alcançável sem resposta dos fabricantes? | Situação e critério |
|---|---|---|
| A: conformidade documental | Parcialmente | Protocolo, conexão e parte FPGA são verificáveis. O fechamento documental completo do enlace não foi demonstrado com os dados públicos disponíveis. Não está aprovado. |
| B: qualificação experimental do conjunto | **Sim** | Ensaios de leitura, repetibilidade, integridade e observação elétrica sob condições registradas permitem qualificar o exemplar e a implementação. Ainda não executados. |
| C: qualificação de produção | Não com esta evidência | Exigiria controle de revisão/lote, cobertura de PVT, variação de alimentação, modelo e amostragem de fabricação. Não é requisito desta demonstração acadêmica. |

Nem todas as capacitâncias e comprimentos precisam ser conhecidos separadamente para B. Pode-se medir o comportamento resultante do enlace e manter folga conservadora no ponto de operação escolhido. Isso não elimina limites de tensão, integridade dos dados, setup/hold internos ou rastreabilidade. Sem instrumento analógico, obtém-se uma validação funcional mais limitada, não uma afirmação de margem elétrica.

## 4. Vazão e adequação ao HUD

### 4.1 Conta com overhead

Para CMD17 independente, sejam `nR` os bytes de espera antes de R1, `nT` os bytes de espera antes do token, `tL` uma latência adicional em segundos e `tG` o intervalo de controle:

```text
clocks/setor = 48 comando + 8·nR + 8 R1 + 8·nT + 8 token
             + 4.096 dados + 16 CRC + 8 finais
             = 4.184 + 8·(nR+nT)
tempo/setor = clocks/setor / fSCK + tL + tG
vazão útil = 512 / tempo/setor
```

`tL` deve representar espera adicional ainda não contada em `nT`; não somar duas vezes o mesmo tempo. Em uso real, a espera pelo token inclui o acesso interno à memória do cartão. Intervalos de software/loader, retries e power-up também reduzem a média; inicialização é custo único, não custo obrigatório de cada setor.

O log anterior contabiliza 4.200 clocks por setor: 48 comando, 24 espera+R1, 8 token, 4.096 dados, 16 CRC e 8 finais. A contagem da espera inclui o alinhamento do modelo. Cada setor leva 1.050.003 ciclos de 100 MHz, ou 10,50003 ms. Eficiência útil aproximada: `4096/4200 = 97,52%`. O registro entre setores mostra três ciclos de controle; não muda materialmente esses valores.

| fSCK | Divisor de semiciclo | Bruto | Útil, 4.200 clocks e 30 ns | Com mais 1 ms de espera/setor |
|---|---:|---:|---:|---:|
| 400 kHz | 125 | 50,00 kB/s | **48,76 kB/s** | 44,52 kB/s |
| 1 MHz | 50 | 125,00 kB/s | 121,90 kB/s | 98,46 kB/s |
| 5 MHz | 10 | 625,00 kB/s | 609,50 kB/s | 278,26 kB/s |
| 10 MHz | 5 | 1,25 MB/s | 1,219 MB/s | 360,56 kB/s |
| 25 MHz | 2 | 3,125 MB/s | 3,047 MB/s | 438,34 kB/s |

Unidades de vazão são decimais. Somente a linha de 400 kHz tem o resultado de simulação anterior citado. As demais são projeções, não novos benchmarks nem frequências aprovadas. Uma espera de 1 ms é exemplo de sensibilidade, não latência publicada do QD101. O cartão pode apresentar esperas maiores; não há uma vazão física medida nesta auditoria.

CMD18 reduziria comandos e esperas entre setores, mas acrescentaria CMD12, novos estados e recuperação. A economia de poucos por cento do overhead fixo não torna SPI capaz de transportar RGB24 a 60 FPS. Não implementar CMD18 nesta entrega.

### 4.2 Vídeo contínuo versus recurso carregado

```text
640 × 480 × 3 = 921.600 bytes por quadro RGB24
921.600 × 60 = 55.296.000 B/s = 55,296 MB/s
```

Essa demanda é aproximadamente 1.134 vezes a vazão simulada atual e 18,15 vezes a projeção útil a 25 MHz. Mesmo o teto bruto SPI de 3,125 MB/s é insuficiente. A frequência VGA real de 59,52 Hz reduz um pouco a demanda, sem mudar a conclusão.

Para carregar uma vez e reproduzir pela memória local, os números mudam:

| Recurso | Conteúdo útil | Tempo estimado a 48,76 kB/s |
|---|---:|---:|
| Bitmap 64 × 64, 1 bit/pixel | 512 B, um setor | 10,5 ms |
| Banco de ícones/fontes | 16 KiB, 32 setores | 0,336 s |
| Imagem 640 × 480 monocromática | 38.400 B, 75 setores | 0,788 s |
| Imagem 320 × 240, 8 bits/pixel | 76.800 B, 150 setores | 1,575 s |
| Quadro 640 × 480 RGB24 | 921.600 B, 1.800 setores | 18,900 s; não cabe inteiro na BRAM |

Tempos excluem inicialização, latência adicional, retries e preparação. Mesmo a 400 kHz um ícone cabe no orçamento acadêmico. Fontes e ícones podem ser carregados antes da exibição enquanto o HUD atual continua operando. O caminho mínimo não exige acelerar o SPI.

**Política de frequência:** primeira entrega a 400 kHz nominal. Se a carga crescer e o tempo de espera se tornar um problema demonstrado, qualificar 1 MHz e depois 5 MHz, mantendo init em até 400 kHz. Não escolher 25 MHz por ser possível no divisor. Considerar a tolerância do oscilador no limite de inicialização; se necessário, divisor 126 fornece cerca de 396,8 kHz nominal. Não alterar parâmetros antes da etapa autorizada.

### 4.3 Limitação concreta dos timeouts

`MAX_WAIT_TOKEN_CLOCKS=65535` é contado em clocks SPI, apesar da interface de 100 MHz:

| fSCK | Tempo nominal de espera atual pelo token |
|---|---:|
| 400 kHz | 163,84 ms |
| 1 MHz | 65,54 ms |
| 5 MHz | 13,11 ms |
| 10 MHz | 6,55 ms |
| 25 MHz | 2,62 ms |

A referência pública SD, §4.6.2.1, recomenda pelo menos 100 ms para leitura SDHC/SDXC na discussão do protocolo SD. O capítulo SPI define CMD17/CMD18, mas esse trecho não fornece sozinho uma garantia de latência SPI específica do QD101. **Não apresentar 13 ms como limite garantido do cartão.** Adotar na próxima implementação um timeout de token de 250 ms de relógio real, política conservadora escolhida para o host, separado do timeout curto de R1. Os 250 ms não são um máximo garantido pelo fabricante. Essa política evita que a tolerância de espera diminua quando a frequência muda e deve ser conferida contra as latências observadas no ensaio.

Se mantida a contagem em clocks SPI, 250 ms requer 100.000 clocks a 400 kHz, 250.000 a 1 MHz, 1.250.000 a 5 MHz ou 6.250.000 a 25 MHz. O contador atual tem 32 bits; não exige nova infraestrutura. Não aumentar o timeout R1 para centenas de milissegundos. O limite de tentativas de ACMD41 deve continuar permitindo o período de inicialização aplicável; não acelerar init para encurtá-lo.

## 5. Comparação de alternativas

As colunas não são alternativas inteiramente excludentes: DDR2 é destino dos dados e pode continuar sendo alimentada por SPI. A comparação considera o trabalho adicional sobre o projeto atual.

| Critério | SPI atual | Outro cartão | Módulo microSD | SD nativo | DDR2 + carregamento |
|---|---|---|---|---|---|
| Complexidade | Baixa, leitor já existe | Baixa no hardware; requer requalificar | Média, nova ligação e alimentação | Alta, novo protocolo/controlador | Alta neste repo, sem MIG existente |
| Custo | Incremental zero | Compra e entrega; estoque local não confirmado | Compra e cabeamento | Hardware atual permite; custo de desenvolvimento | Memória já na placa; custo de desenvolvimento |
| Desempenho | 48,76 kB/s no modelo atual; suficiente para preload pequeno | Nenhum ganho garantido no mesmo SCK | Não acelera o cartão por si | 1 bit/25 MHz: 3,125 MB/s bruto; 4 bits: 12,5 MB/s bruto | Alta vazão local após preload; entrada continua limitada ao SPI |
| Risco elétrico | Sem nova fiação; falta observar enlace | Mesmo enlace, outra carga | Adiciona contatos, fios e possível tradução | Mesmo slot e ramos PIC; mais sinais ativos | DDR2 e PHY adicionam exigências de timing |
| Esforço RTL | Buffer e consumidor, correções pequenas | Quase igual ao atual | Remapear pinos/controle | Comandos, direção CMD/DAT, CRC, estados, recuperação | MIG, calibração, arbitragem e passagem de clocks |
| Facilidade acadêmica | Alta com ícone carregado e CRC | Boa como comparação controlada | Útil para acesso físico, sem vantagem funcional clara | Menor para o prazo de entrega | Boa extensão futura, maior escopo agora |
| Confiabilidade | Qualificável neste conjunto | Não melhora por marca | Depende do circuito e da montagem | Também exige qualificação | Depende de PHY/calibração e buffers; não elimina falhas SD |

### A. Manter QD101 e SPI: alternativa escolhida

Reaproveita inicialização, CMD17, CRC, top e testes. A combinação é coerente com o uso do cartão como armazenamento de recursos. A identidade comercial está sustentada pelo brief; a identidade do exemplar deve ser registrada por CID/etiqueta. Faltam evidências de bancada, não há evidência de incompatibilidade.

São indispensáveis: alimentação adequada e sem contenção, sequência correta, dados e CRC conferidos, timeout/recovery finitos, isolamento de bytes provisórios e repetibilidade. Para afirmar margem elétrica, observar o enlace sob carga real e registrar a incerteza. Não é indispensável obter individualmente cada capacitância, impedância ou comprimento para uma qualificação acadêmica limitada.

### B. Outro cartão: somente se surgir uma falha específica ou documentação útil

Um SDHC comercial de 8–32 GB, genuíno e adquirido em canal rastreável, é uma boa peça de comparação se já disponível. Trocar por outra marca sem documento aplicável não resolve a lacuna AC. Evitar SDUC e não ampliar agora o host para SDSC.

Como exemplo documental, a [Swissbit S-30u, fact sheet oficial](https://www.swissbit.com/data/S-30u/S-30u_fact_sheet.pdf) declara SD SPI e inclui opção de 32 GB. Isso é uma vantagem verificável de documentação; o fact sheet consultado não fecha todos os limites AC do enlace e não demonstra vantagem de custo, prazo ou disponibilidade no Brasil. São produtos de distribuição especializada; não foi confirmada cotação ou disponibilidade para compra local. Cartão comercial comum tende a ser mais fácil de repor, mas também precisa ter SPI verificado e ser requalificado.

**Não comprar cartão nesta etapa.** Se o QD101 falhar de forma repetível com alimentação/protocolo corretos e outro SDHC passar no mesmo ensaio, a troca passa a ter fundamento. Não fazer semanas de pesquisa de catálogo antes dessa evidência.

### C. Outro módulo: útil para acesso, sem simplificar o controlador

O [Pmod MicroSD da Digilent](https://digilent.com/shop/pmod-microsd-microsd-card-slot/) é opção documentada para lógica de 3,3 V. O [esquema A.1](https://digilent.com/reference/_media/reference/pmod/pmodmicrosd/pmodmicrosd_sch.pdf) mostra ligação direta dos sinais, pull-ups de 20 kΩ, capacitores e posições opcionais de chave de alimentação. O NCP380 mostrado é chave de limitação de corrente, não regulador de 5 V para 3,3 V; o esquema marca componentes opcionais não montados. Conferir a montagem real antes de contar com essa função. Não há level shifter nem rede ESD dedicada indicada no caminho de dados dessa folha. Não foi encontrado ali um máximo de frequência que possa ser transferido para qualquer cabeamento.

É eletricamente mais apropriado que um módulo anônimo destinado a entrada de 5 V, mas acrescenta fios e contatos ao slot já existente. O atraso não pode ser declarado zero; será o do conector/cabeamento e da carga, sem conversor ativo nessa versão. Também ocupa pinos que precisam ser conferidos contra sensores e buzzer.

Rejeitar para esta tarefa módulos com divisor resistivo lento, LDO alimentado com tensão insuficiente para fornecer 3,3 V ou conversor por MOSFET/pull-up destinado a I²C sem caracterização push-pull. Conversores automáticos não são todos incompatíveis com SPI: a [TI informa suporte SPI no TXS0108E](https://www.ti.com/product/TXS0108E), condicionado às cargas e à aplicação. Isso não justifica adicioná-lo a dois lados que já usam 3,3 V. Não escolher por fotografia ou anúncio genérico de “alta velocidade”.

### D. SD nativo: possível fisicamente, custo maior no RTL

A Nexys A7 permite 1 e 4 bits pelo slot existente. DAT1/E1 e DAT2/F1 estão ligados à FPGA; CMD e DAT3 precisariam assumir suas funções nativas, com direção e liberação adequadas. Não há necessidade de solda para disponibilizá-los. O compartilhamento com PIC24 e a entrega após configuração continuam relevantes.

A 25 MHz, 1 bit oferece 3,125 MB/s bruto e 4 bits 12,5 MB/s bruto. Em 4 bits/50 MHz, sob modo High Speed e condições apropriadas, o teto seria 25 MB/s, ainda abaixo de 55,296 MB/s. Não é autorização para operar a 50 MHz, nem para mudar a sinalização a 1,8 V. Os limites reais incluem respostas, CRC e latência do cartão.

O controller atual não se converte mudando a pinagem: são necessários protocolo nativo, resposta CMD, CRC7/CRC16 por linha, direção de barramento, seleção/configuração do cartão, temporização e recuperação. Não é a opção de menor risco para adicionar um ícone a um HUD pronto.

### E. Preload em DDR2: válido para imagens grandes, desnecessário agora

A placa dispõe de 128 MiB DDR2. O manual, §3.1, descreve memória x16 e recomenda controlador/PHY, via MIG ou adaptador DDR–SRAM da Digilent. Esse controlador não existe neste checkout. A presença da memória na placa não significa disponibilidade de uma RAM acessível ao RTL atual.

Dois quadros RGB24 exigem 1.843.200 bytes, cerca de 1,76 MiB. A capacidade física comporta 145 quadros RGB24 inteiros antes de reservar espaço para controle/outros dados, cerca de 2,42 s a 60 FPS. A interface x16 a 650 Mb/s por pino tem teto aritmético de 1,3 GB/s, não vazão sustentada comprovada. Refresh, arbitragem, acesso em rajadas e FIFO afetam o resultado.

Preload em DDR2 elimina a exigência de leitura contínua do cartão durante a exibição de conteúdo já armazenado. Não acelera o carregamento inicial e não permite transmitir conteúdo novo indefinidamente acima da vazão SPI. Exigiria MIG, calibração, integração de clocks, buffers de linha e arbitragem VGA. Reservar essa extensão para quando os recursos excederem a BRAM ou houver uma animação concreta que a justifique.

## 6. Arquitetura recomendada e tamanho mínimo da entrega

```text
QD101 no slot existente
    → SPI Mode 0, init/leitura a 400 kHz
    → CMD17 + R1 + token + 512 bytes + CRC16 existentes
    → buffer provisório de setor em BRAM, domínio 100 MHz
    → confirmação block_valid e verificação do recurso esperado
    → memória do recurso retida
    → pedido/ACK para domínio VGA, com publicação no blanking
    → leitura local a 25 MHz e composição com HUD existente
```

Primeira demonstração: um bitmap monocromático de 64 × 64, 512 bytes. Um setor é suficiente. Pode-se usar BRAM de duas portas, escrita a 100 MHz e leitura a 25 MHz, com notificação sincronizada e proibição de escrita enquanto o recurso estiver visível. Na primeira carga, manter o overlay oculto até confirmar o bloco e alcançar o blanking. Para recarga, ocultar/confirmar a cessão antes de escrever ou usar um segundo banco se a continuidade visual for exigida. Não ler e escrever simultaneamente o mesmo endereço em clocks diferentes.

O XC7A100T tem 135 blocos de 36 Kb: 622.080 bytes de bits físicos incluindo paridade, aproximadamente 607,5 KiB. Na organização usual x8/x16 sem aproveitar bits de paridade, a capacidade de dados é 552.960 bytes, 540 KiB. Um ícone de 512 B ou uma imagem monocromática de 38.400 B cabe com folga; um quadro RGB24 não cabe. A inferência e o consumo exatos devem ser verificados na implementação futura, conforme [AMD UG473](https://docs.amd.com/v/u/en-US/ug473_7Series_Memory_Resources).

**Não é necessária FIFO assíncrona para a primeira carga estática.** A memória de duas portas com propriedade estável e handshake de publicação separa os domínios. A interface SD não tem backpressure por byte: o buffer precisa aceitar cada `data_valid`; um setor de 512 bytes resolve isso. Uma FIFO passa a ser necessária quando houver consumidor contínuo, arbitragem ou streaming entre clocks com dados em trânsito. Uma FIFO sozinha não compensa vazão média insuficiente e, antes do CRC, contém dados ainda não aprovados.

Não adaptar o barramento de 112 bits de `entrada_hud` para transportar a imagem inteira. Reutilizar seu padrão pedido/ACK para os poucos bits de controle do novo recurso, mantendo as constraints e o caminho dos sensores intactos. A saída síncrona da BRAM introduz latência de pixel; alinhar endereço, máscara e RGB do overlay sem alterar o raster ou deslocar os elementos existentes.

### Conteúdo real e restrição de somente leitura

O diagnóstico atual **não funciona como verificador genérico de cartão**. Ele exige `byte[i] = i[7:0] XOR 0xA5` no LBA 2048. Um setor perfeitamente lido, com CRC válido, pode acender erro por conteúdo diferente. `SD_READY_LED` informa init; não há LED dedicado persistente de leitura aprovada, nem contadores detalhados expostos.

`scripts/make_sd_diagnostic.py` cria apenas um arquivo regular com aquele padrão. Sua existência não prova que o cartão contenha esses bytes. Não executar uma gravação raw no LBA 2048: esse setor frequentemente coincide com o início de uma partição.

Para ensaiar sem qualquer escrita, obter por leitor de PC, em acesso somente leitura, um ou mais setores **já existentes**, registrar LBA, conteúdo esperado e SHA-256 e usar essa referência no diagnóstico. Se houver imagem existente, mapear seu conteúdo para os LBAs e offsets conhecidos com análise no PC; arquivos fragmentados precisam de uma lista explícita. O FPGA não precisa implementar FAT para ler uma lista pequena conhecida. O mapa deixa de valer se o cartão for alterado e deve ficar vinculado à imagem/conteúdo identificado.

Se o cartão não contiver um bitmap preparado, o primeiro resultado visual pode ser uma grade de 64 × 64 que representa os 512 bytes de um setor existente, comparada à mesma interpretação no PC. Isso comprova cartão → BRAM → VGA sem gravar. Um ícone desenhado exige que o conteúdo apropriado já exista; preparar/gravar mídia seria outra ação, fora desta auditoria e fora do procedimento de somente leitura.

## 7. Qualificação experimental executável

### 7.1 Equipamentos e o que comprovam

Não há inventário confirmado dos instrumentos do usuário. As menções no relatório anterior são requisitos propostos, não equipamentos comprovadamente disponíveis. Priorizar empréstimo do laboratório.

| Recurso | Necessidade prática | Limite |
|---|---|---|
| Nexys A7, cartão e leitor de PC | Essenciais para função e referência de dados | O leitor de PC também precisa ser usado sem montagem/escrita automática. |
| Multímetro | Recomendado como mínimo para VDD estático e continuidade com tudo desligado | Não vê queda transitória, borda ou tDO. Usar pontos acessíveis ou interposer seguro. |
| Diagnóstico interno/ILA e contadores | Essenciais para observar aprovação/erro se não houver captura externa | ILA registra amostras da FPGA; não mede sinal analógico nem tDO subciclo. Sua inclusão futura altera a implementação e exige análise correspondente. |
| Analisador lógico 3,3 V | Opcional para visualizar comandos | ≥10–20 MS/s atende à decodificação a 400 kHz; para 5 MHz, preferir ≥50 MS/s. Taxas propostas, não limites do cartão. |
| Osciloscópio e pontas adequadas | Necessários para alegar margem elétrica medida do enlace | Não é necessário comprar antes de verificar o acervo do laboratório. |
| Interposer microSD curto, com pontos identificados | Necessário se o slot/placa não tiver acesso seguro para sondagem | Acrescenta carga e comprimento; registrar e repetir o teste funcional sem ele. |

Um osciloscópio de bancada de 100 MHz e cerca de 1 GSa/s, com dois canais, é um ponto de partida razoável para investigar alimentação, estabilidade e janela larga a 400 kHz. Quatro canais facilitam correlação simultânea de SCK/MOSI/MISO/CS. **Não é garantia de resolução de todos os transientes:** uma cadeia de 100 MHz tem tempo de subida instrumental de ordem 3,5 ns e pode ocultar picos mais rápidos. Dimensionar a banda pelas bordas medidas e pela incerteza necessária, não apenas pelos 400 kHz. Reduzir SCK amplia o tempo entre bits, mas não torna automaticamente mais lentas as bordas do driver nem elimina ringing.

Começar com pontas x10 compensadas e capacitância conhecida, retorno curto e fixação segura; para tDO curto ou carga sensível, preferir sonda de poucos pF ou ativa e maior banda conforme a necessidade observada. Uma sonda de 10–15 pF pode alterar o enlace e não deve ser tratada como transparente. Não exigir de saída 500 MHz/sonda de 1 pF para demonstrar um ícone a 400 kHz, nem afirmar que um analisador lógico barato verifica overshoot. O [datasheet Analog Discovery 3](https://files.digilent.com/datasheets/Analog-Discovery-3-Datasheet.pdf) exemplifica por que conferir a configuração: sua banda e carga dependem da conexão/adaptador; não o considerar equivalente a um osciloscópio de alta banda por ter decodificador SPI.

### 7.2 Observação elétrica sem alterar a placa

Instalar, com tudo desligado, um interposer comercial identificado que preserve os oito contatos e exponha VDD/GND/SCK/CMD/DAT0/DAT3. Verificar correspondência e ausência de curtos antes da alimentação. Fixar as pontas nos pontos próprios, sem agulhas no soquete, fios soltos entre contatos ou solda na Nexys. Não conectar fonte externa à VDD do cartão, nem dirigir sinais de saída a partir do instrumento. Conferir a referência de terra do osciloscópio e da placa.

Medições em ordem de utilidade:

1. **VDD no lado do cartão:** nível estático, rampa após `SD_RESET=0`, tempo antes do primeiro comando e quedas durante leitura. Para power-cycle, verificar descarga real, inclusive eventual alimentação parasita pelas linhas; alguns ciclos de reset do RTL não comprovam desligamento do cartão.
2. **SCK/MOSI/CS no cartão:** amplitude, monotonicidade nas bordas relevantes, tempos alto/baixo e estabilidade do comando em torno da subida. Observar início e fim da seleção, não apenas bits periódicos. Procurar contenção após entrega do PIC.
3. **SCK e MISO no cartão:** capturar bytes que contenham transições 0→1 e 1→0. Disparar na descida de SCK e medir até MISO cruzar o limiar escolhido e assentar. Fazer deskew dos canais e registrar limiares, carga e incerteza. Isso é **tDO observado com aquela carga**, não máximo garantido do cartão.
4. **MISO no lado FPGA, se houver acesso seguro:** usar somente ponto de teste/via/pad existente identificado pelo layout e operador capacitado. Não tentar tocar a esfera BGA C2. Se não houver ponto acessível, declarar essa observação indisponível e combinar a observação no interposer com os caminhos FPGA conhecidos e um envelope conservador do trajeto restante. Não alegar que foi medido no pad da FPGA.

A margem de recepção pode ser obtida do atraso total observado, sem decompor com precisão o tDO intrínseco. O tDO separado só é necessário se o objetivo for caracterizar o cartão isoladamente ou fechar essa parcela específica. Para o protótipo, interessa principalmente o instante em que o bit chega estável ao receptor em relação à captura.

```text
janela disponível nominal = H = 1.250 ns a 400 kHz
margem_setup = H − [SCK FPGA→cartão + tDO + MISO cartão→FPGA
                   + caminho de entrada + setup + incertezas/skew]
```

Para hold, comparar a captura à primeira alteração possível do próximo bit, lançada na próxima descida, usando mínimos e skew coerentes. MOSI/CS exigem a verificação inversa no receptor cartão. O orçamento anterior já contém as equações detalhadas; não é necessário reconstruí-las aqui nem declarar a parcela interna como margem final.

Critério de engenharia proposto para esta operação lenta: além de respeitar os limites elétricos aplicáveis e margens de setup/hold positivas após incertezas, procurar pelo menos 250 ns de afastamento de MISO das transições em ambos os lados da captura a 400 kHz. Trata-se de reserva escolhida para o protótipo, não requisito SD nem margem medida. Se só se puder medir no cartão, descontar o trajeto restante com hipótese explícita; não atribuir 250 ns ao pad sem sustentação. Sem essa sustentação, limitar a conclusão à função.

No modelo XDC futuro, manter os atrasos internos e tratar as fases/enables reais, incluindo todos os endpoints D/CE e os seletores de saída. Usar [AMD UG903 Input Delay](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Input-Delay) e [Output Delay](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Output-Delay). Não adicionar um falso clock SPI periódico e multicycles genéricos para obter relatório verde, nem `false_path` global em MISO. Se o envelope vier de medição, identificá-lo como limite de qualificação B e registrar onde há hipóteses; não chamá-lo de signoff documental A.

### 7.3 Procedimento de leitura e critérios de parada

Todos os acessos abaixo são de leitura ou comandos de configuração volátil do protocolo. Não incluem CMD24/CMD25, erase, formatação ou escrita no cartão.

1. **Identificação e referência:** registrar placa/revisão, etiqueta do QD101, alimentação usada e futuro hash do bitstream de bancada. No PC, desativar montagem com escrita e extrair referências de setores existentes. Registrar CID/CSD por meio disponível, sem exigir novo RTL apenas para identificar a etiqueta.
2. **Alimentação:** verificar ligação de terra, VDD real e entrega do barramento. Não inserir/remover cartão energizado. Na medição de reset, confirmar descarga e rampa; a espera atual é aproximadamente 2 ms mais 80 clocks, mas depende de VDD efetivamente ter assentado.
3. **Inicialização a 400 kHz:** observar 80 clocks, CMD0, CMD8, CMD55/ACMD41 e CMD58. Exigir `ready=1`, ausência de falha e OCR coerente com SDHC/alimentação. Guardar códigos de erro, não apenas LEDs.
4. **CID/CSD:** CMD10/CMD9 são suportados pelo protocolo SPI, com token, 16 bytes e CRC16. Não estão implementados. Acrescentar leitura de registradores só se for necessária para registrar identidade/capacidade pela própria FPGA; não é pré-condição para o primeiro CMD17 se a identificação já veio do PC. Verificar capacidade antes de varrer LBAs.
5. **Um setor conhecido:** usar o conteúdo real escolhido. Exigir 512 bytes, ordem e índices corretos, CRC16 correto, igualdade byte a byte com o PC, `block_valid` único e CS liberado. Separar falha de CRC de padrão esperado diferente.
6. **Vários setores:** proposta limitada para qualificação inicial: 1.024 leituras, alternando até 64 LBAs válidos distribuídos dentro da capacidade confirmada, incluindo o recurso da demonstração. Selecionar setores existentes com conteúdo distinguível e extrair suas referências por leitura para detectar endereço errado; não gravar padrões novos no cartão. Se a fixture inicial só expuser um LBA, primeiro validar esse LBA e então ampliar o solicitante; não afirmar varredura inexistente.
7. **Integridade e erros:** contar timeouts, CRC, divergências de conteúdo e retries. O hardware atual verifica CRC16 do bloco mesmo com CRC de comando desabilitado por padrão no SPI. CMD0/CMD8 têm CRC correto. CMD59/CRC7 de todos os comandos podem aumentar detecção de corrupção de comando, mas ainda não existem; são recomendáveis se o uso crescer. Nesta demonstração fixa, comparação integral com a referência também precisa detectar setor errado com CRC válido. Um erro nunca pode publicar dados.
8. **Repetibilidade:** 20 partidas com alimentação efetivamente removida/restabelecida e descarga adequada, sempre com o cartão já encaixado antes de ligar. Registrar tempo de init/carga e resultado. Separar power-cycle de reset lógico. Usar a alimentação e a faixa ambiente da demonstração; não reivindicar ensaio de −25 a +85 °C pela etiqueta do cartão.
9. **Frequência utilizável:** a aprovação inicial é a 400 kHz. Se houver necessidade de reduzir o carregamento, ensaiar 1 MHz e 5 MHz com init inalterada e timeout corrigido. Registrar a maior frequência sem erro **entre as ensaiadas**. Não procurar o limite de falha por esporte, nem usar exatamente o último ponto sem erro como frequência operacional. Se o objetivo acadêmico exigir estimar o limite, fazer varredura limitada e escolher operação abaixo dele com margem observada; não extrapolar para outros exemplares.
10. **Encerrar:** para a frequência escolhida, exigir zero divergências, CRC ou timeouts na amostra de aprovação, 20/20 partidas e HUD operante; para alegar margem elétrica, acrescentar as observações e reservas acima. Se o primeiro conjunto passar a 400 kHz e carregar o recurso no prazo, parar a investigação de alternativas. Esses números são critérios de aceitação propostos, não testes já executados nem uma garantia estatística de produção.

Se surgirem falhas, conservar o primeiro log útil e decidir pela causa: alimentação/entrega PIC, protocolo/endereço, conteúdo, CRC, captura ou sinal. Após duas tentativas sem avanço, mudar o método de diagnóstico, por exemplo comparar com outro SDHC já disponível ou obter captura externa. Não alternar aleatoriamente divisores nem mascarar falhas com retries ilimitados.

### O que se pode concluir sem bancada analógica

| Meio | Pode comprovar | Não pode comprovar |
|---|---|---|
| Simulação | FSM, comandos, timeout, CRC, arbitragem, publicação e CDC lógico sob modelos definidos | Níveis, ringing, alimentação real, tDO do cartão |
| FPGA + referência PC + contadores/ILA | Leitura correta, integridade, tempo e repetibilidade do conjunto ensaiado | Margem analógica e todos os corners |
| Osciloscópio + fixture adequada + análise temporal | Comportamento elétrico e janela observados, com incerteza e carga declaradas | Garantia de todos os lotes e condições não ensaiadas |

Logo, **não comprar equipamento antes de consultar o laboratório**. Para fechar B com margem elétrica, será necessário acesso a osciloscópio/pontas e pontos seguros; pode ser empréstimo. Se só houver FPGA e leitor, o desenvolvimento e a demonstração funcional podem avançar com declaração explícita dessa limitação, sem converter sucesso ocasional em segurança elétrica universal.

## 8. Plano incremental P0–P4, sem implementação nesta auditoria

Os nomes de módulos novos abaixo são propostas, não arquivos existentes. Cada etapa tem uma entrega funcional e um critério de término; não pressupõe outra auditoria geral.

| Etapa | Arquivos/módulos envolvidos | Dependências | Testes direcionados e aprovação | Resultado esperado |
|---|---|---|---|---|
| **P0: preparar um ensaio correto** | `rtl/top_reticula.sv`, `rtl/sd_diagnostic.sv`, `rtl/sd_spi_preamble.sv` se a rampa exigir; `constraints/nexys_a7_reticula.xdc`; fluxo separado de bancada com o script de implementação existente | Conteúdo/LBA de referência obtido somente por leitura; identificação física; acesso seguro à alimentação | Trocar a hipótese do padrão A5 pela referência real; separar init, CRC, conteúdo e conclusão; manter SD desligado no perfil normal e habilitar explicitamente no ensaio. Confirmar pinos, alimentação, espera e fase; documentar envelope e lacunas do enlace. Não repetir os testes inalterados. Aprovar quando referência e perfil forem inequívocos, sem contenção ou tensão indevida, e a captura tiver análise coerente. | Bancada observável, sem falso diagnóstico causado pelo conteúdo do cartão. |
| **P1: concluir leitura confiável** | Reaproveitar `sd_spi_init`, `sd_spi_read_block`, `sd_spi_controller`; modificar timeout; tornar LBA do diagnóstico configurável; CMD9/10 somente se identidade/capacidade não puderem vir do PC | P0; fixture de bancada futura autorizada; init/leitura inicialmente a 400 kHz | Um teste novo da espera longa e da expiração no tempo real; repetir apenas testes dos módulos alterados. Verificar CRC inválido sem publicação e leitura seguinte recuperável. Aplicar o ensaio de 1.024 leituras e 20 partidas; registrar contadores e dados de referência. Falhas retiram aprovação, mesmo que retry depois passe. | CMD17 real repetível e comprovado; não reimplementar o leitor existente. |
| **P2: bufferizar e confirmar** | Novo `rtl/sd_sector_buffer.sv` ou memória local no carregador, conforme o menor desenho; `sd_spi_controller` e top como produtores | P1; contrato `data_valid` provisório / `block_valid` confirmado | Um teste de setor correto, CRC incorreto e reset parcial: só o setor aprovado fica disponível. Memória aceita todos os bytes sem backpressure; endereço 0–511 conferido. Confirmar inferência BRAM no próximo build. | Setor íntegro retido, pronto para uso sem depender da latência SD. |
| **P3: memória e VGA** | Novo `rtl/sd_asset_loader.sv` e `rtl/asset_overlay_vga.sv` se necessário; `top_reticula.sv`; padrão de handshake de `entrada_hud.sv`, sem alterar seu barramento; XDC do novo controle | P2; contrato de bitmap 64 × 64; BRAM dual-port | Um teste integrado: carga só aparece após CRC e blanking, alinhamento de pixel, memória imutável enquanto visível, erro mantém HUD/fallback. Análise CDC e timing da nova implementação; preservar paths/sensores/calibração e raster. | Recurso real do cartão desenhado a partir da BRAM; DDR2 não participa. |
| **P4: demonstração final** | Top, testes afetados, documentação de operação e novo manifesto em diretório distinto; reutilizar convenções de build sem sobrescrever evidência | P3 aprovado; condições da bancada registradas | Regressão final proporcional pela integração no top; timing/DRC/CDC da implementação entregue; demonstração visual com referência PC e leitura sem escrita. Testar ausência/falha do cartão sem parar HUD, sensores ou alertas. Manifesto vincula fontes, parâmetros, cartão e hash do artefato. | Demonstração acadêmica utilizável, limitações e recuperação claras; encerrar a tarefa. |

A alimentação do cartão pode falhar sem que o reset global do HUD seja acionado repetidamente. A política de erro do futuro loader deve liberar CS, descartar setor incompleto, oferecer nova solicitação limitada e manter o HUD original ou o último recurso integralmente aprovado. Não transformar a adição do cartão em dependência para VGA, sensores ou buzzer iniciarem.

O ensaio físico futuro pode usar bitstream de bancada volátil, após revisão elétrica e autorização própria dessa etapa. Não requer gravar Flash nem publicar uma Release. Nenhum desses procedimentos foi executado aqui. A eventual entrega final terá nova análise porque BRAM, loader e observabilidade mudam a implementação.

**Próxima implementação indispensável:** ajustar o diagnóstico para um setor existente conhecido, expor sucesso/erro e contadores, manter 400 kHz e corrigir o timeout em tempo real; então validar CMD17 no conjunto real. Em seguida, adicionar o buffer confirmado e o pequeno overlay. O primeiro passo não é construir DDR2, outro controlador SD ou outro leitor CMD17.

## 9. Respostas finais e encerramento da auditoria

1. **Vale continuar com o QD101? Sim.** Não há impedimento técnico demonstrado. A compatibilidade e a margem deste exemplar ainda precisam do ensaio definido.
2. **Vale continuar com SPI? Sim.** É suficiente para recursos carregados previamente e aproveita um leitor com CRC já implementado. Não atende vídeo RGB24 contínuo de 640 × 480 a 60 FPS.
3. **A falta de resposta dos fabricantes impede o projeto? Não.** Impede declarar o fechamento documental completo e a garantia de produção, não o caminho de qualificação acadêmica B.
4. **Podemos validar experimentalmente o conjunto? Sim.** Leitura comparada ao PC, CRC, repetibilidade, observação de alimentação e janela elétrica permitem uma qualificação limitada e rastreável. Ainda não foi realizada.
5. **Precisamos comprar equipamento? Não há compra obrigatória definida.** Precisamos verificar o acervo: FPGA/leitor permitem validação funcional; osciloscópio/pontas e acesso seguro são necessários para afirmar margem analógica. Priorizar empréstimo; interposer só se não houver ponto seguro.
6. **Precisamos trocar componente? Não há justificativa atual.** Troca só após falha específica sustentada por comparação controlada ou necessidade funcional nova.
7. **Qual arquitetura? QD101 + slot atual + SPI Mode 0 a 400 kHz + CMD17/CRC16 + BRAM + publicação por handshake no blanking + overlay VGA.** DDR2 fica fora da entrega mínima.
8. **O que implementar em seguida? Diagnóstico com referência real e observabilidade, timeout independente da frequência e buffer que só publica após CRC; depois conectar um bitmap pequeno à VGA.**

A auditoria está concluída. Há um caminho de implementação definido e critérios de encerramento. Permanecem pendentes a implementação incremental e os ensaios físicos, explicitamente fora do escopo de alterações desta auditoria. Não é necessário abrir outra investigação de fabricantes para começar esse trabalho.
