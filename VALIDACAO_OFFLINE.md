# Validação offline: histórico e candidata SPI 5 MHz

Estado atual: seção final “Reprodução offline SPI 5 MHz”. As seções anteriores registram suas respectivas etapas históricas.

## Execução nova e referência anterior

Os resultados desta seção foram executados na sprint de 08–09/11/2026, no worktree `hud_ddr2_noturna_20261108`, com Vivado/XSim 2026.1. A tag inicial `rc/hud-ddr2-offline-20261108` permanece preservada. Seus WNS +0,539 ns / WHS +0,049 ns e a validação integral anterior do arquivo de vídeo são referências históricas, não testes novamente executados nesta sprint.

## Implementação roteada

Comando real: `bash scripts/build_rc_offline.sh`. Logs em `resultado/vivado.log` e `evidencias/build-noturna.txt`. Relatórios adicionais foram obtidos abrindo o checkpoint roteado com `scripts/qualificar_rc.tcl` e `scripts/qualificar_clock_reset.tcl`, sem reimplementar ou acessar hardware.

| Verificação | Resultado novo |
|---|---|
| Setup WNS final, com pre-carga | +0,230 ns |
| Hold WHS final | +0,011 ns |
| Bus skew | 8 grupos aprovados; menor folga +6,543 ns |
| DRC | Zero erros; REQP-1709 e avisos de otimização preservados |
| Clocks sem definição / endpoints internos não limitados | Zero no gate do build |
| Recursos | 20.690 LUTs, 15.391 registradores, 64 blocos RAM, 62 DSPs, 131 IOBs |
| Checkpoint | `resultado/routed.dcp` |
| Bitstream / MCS novos | Não gerados; mapa físico e interfaces externas ainda pendentes |

A primeira implementação XPM desta sprint, antes da pré-carga, fechou em +0,442/+0,010 ns e ficou preservada em resultado-xpm-4309c53/, com relatórios em evidencias/relatorios-xpm-4309c53/. Ela não é o checkpoint final da pré-carga.

O build final incorpora a calibração de sensores preservada e o formato completo 320×240/30/17.331 quadros. Usa LBA=1 sintético e leitura SPI padrão de 400 kHz. O timing interno positivo não qualifica essa frequência para reproduzir 30 FPS. A margem de hold é de apenas 0,011 ns e deve ser reavaliada em qualquer novo build.

`report_methodology` mantém 134 ocorrências: 2 LUTAR-1, 12 PDRC-190, 32 SYNTH-6, 1 SYNTH-14, 1 TIMING-10, 39 TIMING-18, 1 XDCB-1, 29 XDCB-5, 1 XDCC-1 e 16 REQP-1959 advisory. Não há errors/critical nessa lista. PDRC-190 aponta a cadeia de temperatura interna do MIG; LUTAR-1 inclui o OR de resets de transação e a infraestrutura MIG. Os 39 TIMING-18 mostram que os atrasos de IO externos não estão integralmente qualificados. Não foram inventados atrasos de placa/cartão para eliminar esses avisos. O check_timing da primeira implementação XPM lista SD_DAT0 e cpu_resetn sem input delay, além de sinais assíncronos com exceções próprias; a entrada SPI exige orçamento externo real antes do perfil rápido.

## Classificação CDC e clocking

`resultado/cdc_routed.rpt` passou de 243 CDC-1 e 144 CDC-13 na referência anterior para **zero ocorrências dessas regras**; CDC-6 também deixou de aparecer. A mudança é consequência da substituição das FIFOs próprias por XPM, não de waivers. O relatório atual conserva 46 CDC-3 informativos, 3 CDC-10 críticos, 1 CDC-8 e 176 CDC-15 warnings. `report_waivers` não encontrou waivers de CDC, DRC ou metodologia.

| Grupo | Origem e qualificação |
|---|---|
| 2 CDC-10 do espelho | Reset de operação/MIG chega ao OR de reset comum e aos PRE das cadeias locais. São resets assíncronos intencionais, não dados. Cinco estágios liberam cada domínio sincronamente; ASYNC_REG=1 e cada cadeia agrupada em uma slice foram conferidos no DCP. O OR pode provocar reset espúrio por glitch; a arquitetura descarta a transação e conserva o último banco, mas a estabilidade física das fontes permanece pendente. |
| 1 CDC-10 interno MIG | `mig_resetn_reg` → `u_ddr2_infrastructure/rstdiv0_sync_r_reg[0]/PRE`, cadeia de 12 estágios do IP gerado. Não foi editada nem declarada isenta por waiver inexistente. |
| 1 CDC-8 interno MIG | Reset do `u_iodelay_ctrl/rst_ref_sync_r_reg[0][0]/PRE`, cadeia reportada com profundidade 15 e ASYNC_REG ausente. É uma ressalva do IP gerado, preservada para revisão e calibração física. |
| 140 CDC-15 XPM | Payload das FIFOs de entrada (130 bits) e retorno (10 bits), controlado pelos ponteiros/flags da macro AMD. O payload não recebe sincronizadores bit a bit. Foram usadas as constraints oficiais da macro e simulado o modelo real XPM. |
| 24 CDC-15 joystick | Barramento `retido` → `dados_destino`; origem mantém dados até ACK sincronizado, destino captura após pedido sincronizado. Max delay e bus skew limitados a 8 ns. Algoritmo preservado. |
| 12 CDC-15 temperatura | `temperature_raw` → `destination_data`; solicitação/ACK por toggle e retenção até reconhecimento. Modelo XADC e cadência exercitados. |

A análise justifica a estrutura dos avisos, **não converte o relatório em “zero críticos” nem concede sign-off físico ao MIG**. As únicas exceções de reset adicionadas miram os dez PRE das duas cadeias de cinco estágios; os caminhos de reset local para registradores funcionais continuam temporizados. Não foi adicionado false path global entre domínios.

O XPM aplica suas constraints de ponteiros Gray e bus skew. O teste direto atravessou repetidamente wraparound, full/empty e resets, com 3.072 palavras comparadas em ordem. O manual oficial exige respeito a reset/busy e configuração de profundidade: [XPM_FIFO_ASYNC, UG953](https://docs.amd.com/r/2024.2-English/ug953-vivado-7series-libraries/XPM_FIFO_ASYNC). As constraints de skew seguem a finalidade descrita em [UG903](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/About-Bus-Skew-Constraints).

`REQP-1709` permanece na infraestrutura gerada: PLLE2 CLKOUT0–2 alimentam referências/controle PHASER; CLKOUT3 passa por BUFH até o MMCM, cujo modo é `BUF_IN`, com realimentação via BUFG. O detalhamento está em `resultado/qualificacao/mig_clocking.txt` e `clock_reset_detail.txt`. Na primeira implementação XPM, a consulta deixou o nome MMCM em branco por não incluir gen_mmcm; esse relatório histórico está em resultado-xpm-4309c53/. O filtro foi corrigido e os dois relatórios finais confirmam a célula e suas propriedades. Nenhum buffer interno do MIG foi trocado para silenciar a regra. O log também mantém Constraints 18-1056: a definição tardia do clock principal substitui o nome padrão criado no XDC in-context do MIG. As duas definições têm período 10 ns e waveform {0 5}; o relatório final deve conservar um único clock primário com essa forma de onda. É uma redundância identificada, sem mudança de frequência, e não foi ocultada.

Os clocks observados são 100 MHz principal, 25 MHz pixel, 200 MHz referência, ~102,564 MHz XADC, 81,25 MHz UI, 325 MHz memória e 650 MHz referência PHASER. A topologia deve ser confrontada com o IP gerado e [UG472](https://www.amd.com/content/dam/xilinx/support/documents/user_guides/ug472_7Series_Clocking.pdf); não há evidência de dispensa AMD específica para este REQP-1709.

## Integridade e recuperação em simulação

`evidencias/testes-xpm-final.txt` registra **17 cenários aprovados** usando `xpm_fifo_async` real do Vivado: quadro curto de teste, quadro de 76.800 bytes, corrupção, commit incompleto, abort, MIG bloqueado, três fontes de reset durante escrita, perda de calibração durante releitura e retorno, três quadros distintos, saída bloqueada, marcador de fim de leitura inválido, timeout, FIFO saturada e manutenção da última imagem após corrupção.

O teste direto da FIFO comparou 3.072 palavras em três épocas com full/empty, wraparound e reset. O teste de contrato conferiu fontes críticas preservadas e CRC32 contra zlib. Cinco testes do conversor passaram. O modelo AMD XADC forneceu 20 atualizações; maior intervalo observado 113,578224 µs, com média de 16 amostras mantida. A recomendação de temperatura é descrita no [UG586](https://docs.amd.com/r/en-US/ug586_7Series_MIS/Temperature-Monitor).

O teste integrado `tests/tb_sd_ddr2_vga.sv` usa controlador SPI/CMD17/CRC16 real, loader real, XPM real, modelo da UI MIG com backpressure, buffer BRAM e VGA/background reais. Três cenários passaram: nominal, erro CRC recuperado e vídeo desligado/religado. Foram **6.144.000 comparações RGB**, com ordem e conteúdo dos quadros, blanking e sincronismo verificados. Logs: `evidencias/pipeline-sd-ddr2-vga-final.txt` e `validation/sd-ddr2-vga-final/`.

A medição adicional de cadência está em `evidencias/cadencia-vga.txt`: carga SPI em 2.515.651 ciclos de 100 MHz = **25,15651 ms**, ~3,053 MB/s úteis; três intervalos consecutivos de publicação de **33,600 ms**, ~29,7619 FPS. O modelo usa SPI de 25 MHz sem esperas extras de token do cartão e UI com atrasos modelados. O arquivo pede 30 FPS, mas a VGA de 25 MHz faz 59,5238 Hz; duas varreduras dão essa cadência observada. O payload exigido a 30 FPS é 2,304 MB/s; a capacidade bruta de 25 MHz é 3,125 MB/s. 60 FPS exigiria 4,608 MB/s e excederia essa capacidade bruta.

O primeiro teste integrado completou as comparações de pixels, mas falhou numa checagem final do testbench que consultava `ddr_pass` já durante a transação seguinte. A checagem foi corrigida para contabilizar releituras completas e erros latched; os três cenários finais passaram sem enfraquecer as comparações de dados. A falha e os logs anteriores permanecem preservados.

O ensaio do top completo com HUD/ícone passou em 12 combinações efetivas de modos e 4.608.000 pixels; log em evidencias/top-ddr2-preload-final.txt e validation/top-ddr2-preload-final/result.txt. As quatro capturas foram inspecionadas e preservadas em evidencias/previas/hud-comparativo.png. Ele usa sensores sem resposta e modelo UI, portanto não qualifica a atitude, sensores ou PHY na placa.

Cinco testes novos do mapeador FAT32 passaram: contiguidade, rejeição de fragmentação, FATs divergentes, payload incorreto e ciclo de FAT. O hash integral da imagem antes/depois do caso válido é igual. A primeira fixture tinha cabeçalho de resolução não suportada e foi corrigida; o verificador de produção não foi alterado.

## Qualidade visual do vídeo

A origem local é 1920×1080/60, aproximadamente 577,7 s. Foram comparados quatro perfis em cenas escura (210 s), clara (540 s), detalhada (90 s) e de movimento (270 s), escolhidas entre nove amostras por luminância, bordas e diferença temporal. As imagens usam a expansão RGB332 → VGA de 12 bits efetivamente implementada no RTL.

| Perfil | PSNR por pixel médio | PSNR após média espacial 5×5 |
|---|---:|---:|
| Area sem dither | 20,888 dB | 21,974 dB |
| Area RGB8 nativo, atual | 20,531 dB | 35,378 dB |
| Bicubic RGB8 | 20,524 dB | 35,369 dB |
| Lanczos RGB8 | 20,489 dB | 35,302 dB |

Referência: redimensionamento area em RGB24. O dither reduz PSNR por pixel devido ao padrão de quantização, mas preserva melhor a média local dos gradientes; as imagens foram inspecionadas e a versão sem dither mostrou bandas mais fortes. As diferenças entre filtros nativos são pequenas e não justificam substituir a conversão atual. Não foram aplicados sharpening, deformação, contraste automático ou mudança de canais. Proporção 16:9 preservada em área 320×180, com barras de 30 pixels em cima/baixo.

Prévia: `validation/qualidade-final/comparativo.png`; métricas e hashes em `comparativo.json`. Comando: `python3 tools/compare_video_profiles.py ORIGEM DIRETORIO_NOVO`. As métricas não são medição do monitor VGA e não comprovam ausência de flicker físico.

Uma análise nova dos hashes do manifesto anterior encontrou 51 pares adjacentes idênticos, todos no encerramento, entre os quadros 17.269 e 17.330. Amostras novas da origem em 575/576/577 s mostram o logo final estático. Não há justificativa para remover esses quadros ou modificar a duração; o resultado está em `evidencias/duplicatas-video.json`. Não foi repetida a validação integral de 2.599.650 CRC16 já realizada antes da sprint.

## Correção da espera entre quadros

O cenário de SPI a 12,5 MHz revelou espera evitável: o loader exigia simultaneamente disponibilidade da DDR2 e da BRAM, mesmo recebendo dados somente na DDR2. Foi alterada apenas a seleção de buffer_ready no top: com DDR2, usar ddr_src_ready; sem DDR2, manter frame_ready. A FIFO de retorno continua segurando START até out_ready, e a BRAM continua publicando exclusivamente no blanking.

No experimento de quatro quadros, o intervalo de publicação caiu de 67,200 ms (~14,88 FPS) para 50,400 ms (~19,84 FPS), com a mesma carga SPI de 50,30851 ms, sem erros e com 3.072.000 comparações RGB na versão com pré-carga. É uma melhora de 33,3% na taxa do modelo lento, sem aumentar o SPI. Logs: evidencias/pipeline-atraso.txt e evidencias/pipeline-preload.txt. A nova regressão verifica explicitamente o início de pré-carga enquanto a BRAM ainda está ocupada.

O oráculo de pixels foi ajustado para usar a sequência de quadros publicados, e não o contador de quadros carregados do SD, que pode avançar antes da exibição com a pré-carga. O teste ainda compara cada byte RGB e exige ordem e wrap ao quadro zero.

O executor de três casos adicionais foi alterado enquanto ainda executava e terminou com erro de parsing depois dos três PASS. Os logs XSim foram conferidos separadamente, sem edição, em evidencias/pipeline-falhas-conferidas.txt. O script estabilizado passou bash -n e concluiu normalmente o cenário lento posterior. Uma tentativa de compilar o novo monitor de pré-carga também encontrou uma declaração fora de ordem no testbench; foi corrigida antes da regressão, sem alteração do RTL de produção.

As capturas preliminares de estilo foram descartadas como prova de mudança de modo: o ensaio podia capturar antes de a seleção ser aplicada no blanking. O teste final reduz somente os parâmetros de debounce das instâncias simuladas, espera os estados internos reais e mantém cada combinação durante a área ativa inteira. Não altera os parâmetros de produção nem desativa as verificações RGB. O xvlog usa --relax no top por declarações antecipadas já existentes nos fontes; as assertions e comparações permanecem ativas.

A regressão final da pré-carga concluiu os sete cenários com 13.824.000 comparações RGB, sem falhas funcionais. O cenário lento registrou quatro inícios de pré-carga enquanto a BRAM estava ocupada, quatro quadros atrasados contabilizados e zero erros de dados. Resumo estruturado: evidencias/regressao-pipeline.json; log completo de resultados: evidencias/pipeline-regressao.txt.

O teste tests/tb_hud_offset_video.sv reaproveita o ensaio anterior de ajuste vertical e acrescenta o compositor real sd_video_background com fundo constante. Passaram passo de 1 pixel, publicação apenas na fronteira, saturação, clipping sem wrap, persistência e preservação do fundo quando o HUD sai da tela. Comando real: iverilog -g2012 -s tb_hud_offset_video -o validation/hud-offset-video/test.vvp tests/tb_hud_offset_video.sv hud/rtl/hud_vertical_adjust.sv hud/rtl/hud_flight_coords.sv hud/rtl/sd_video_background.sv; depois vvp validation/hud-offset-video/test.vvp. Log em evidencias/hud-offset-video.txt. Não exercita sensores ou PHY; o transporte DDR2 foi validado nos ensaios separados descritos acima.

## Atualização do cartão após a sprint

O usuário inseriu o microSD no PC. Leitor USB serial 816820130806, partição FAT32 UUID 3562-6631. Após desmontar a montagem automática rw, o cartão foi remontado com ro. HUDVIDEO.BIN tem 320×240/30, 90 quadros, 6.912.512 bytes, sequência a7699c175ddb435194c191d3e95ecb79 e SHA-256 24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2. Conferiu com /home/santojuca/Downloads/hud-correcao-video-FHPwL3/amostra/HUDVIDEO.BIN. A cópia local extraída passou os 90 hashes de quadros e 13.500 CRC16 usando os metadados dessa referência anterior. Evidências: arquivo-cartao-20261109.json e integridade-arquivo-cartao-20261109.json.

O mapeador não pôde abrir os setores: acesso direto negado, sudo sem autenticação indisponível e UDisks OpenForBackup não autorizado. Nenhuma dessas tentativas escreveu no cartão. Foi solicitado ao usuário executar o comando O_RDONLY no Terminal com autenticação. A identidade e integridade do arquivo estão confirmadas; localização LBA e fragmentação não estão. Não foi criado um mapa físico com números históricos.


## Fechamento técnico de 09/11: resets e correspondência com o cartão

A área isolada `hud_ddr2_fechamento_20261109`, branch `sprint/fechamento-tecnico-20261109`, parte de `3fc45f2`. Os resultados das seções anteriores pertencem à sprint noturna. A nova consulta abre seu DCP roteado preservado, sem reimplementar, salvar constraints ou acessar hardware. Comando executado:

```bash
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -nojournal \
 -log validation/fechamento-reset/vivado.log \
 -source scripts/inspecionar_reset_routed.tcl -tclargs \
 /home/santojuca/Downloads/hud_ddr2_noturna_20261108/resultado/routed.dcp \
 "$PWD/evidencias/reset-cones-20261109.txt"
```

Prefixos dos endpoints: M=`u_ui_test/g_sd_mirror.u_mirror`; I=`u_ui_test/u_mig/u_ddr2_p0_mig_nexys_mig/u_ddr2_infrastructure`. O clock principal tem nome Vivado `u_ui_test/u_mig/sys_clk_i` (100 MHz); UI=`clk_pll_i` (~81,25 MHz).

| CDC-10 | Origem registrada apontada pelo CDC | Destino | Lógica, reset e exceção |
|---|---|---|---|
| Próprio, principal → UI | `inicio_operacao_reg[3]__0` | M/`ui_reset_pipe_reg[0]/PRE` | LUT3 INIT=DF: `src_rst OR ui_rst OR NOT calib`; PRE ativo alto, liberação por cinco FF UI; false path somente aos PRE em `scripts/p4c_cdc.tcl`. |
| Próprio, UI → principal | I/`rstdiv0_sync_r1_reg` | M/`src_reset_pipe_reg[0]/PRE` | A mesma LUT3 e as três fontes; liberação por cinco FF do principal, mesma exceção específica. |
| Interno MIG, principal → UI | `mig_resetn_reg` | I/`rstdiv0_sync_r_reg[0]/PRE` | LUT4 INIT=7FFF reúne reset externo ativo baixo e ausência de RDY/locks; cadeia de 12 estágios. A exceção gerada passa por `u_iodelay_ctrl/sys_rst_i`; XDC do MIG também limita rstdiv0→PHY_CONTROL/RESET a 5 ns. |

O novo relatório lista **todas** as origens do cone, incluindo `init_calib_complete_reg` nos dois resets próprios e MMCM/PHASER LOCKED e IDELAYCTRL RDY no MIG. A lógica coincide com `rst_tmp` de `mig_7series_v4_2_infrastructure.v` gerado (linhas 704–723 na saída local), incluindo inversão por RST_ACT_LOW. Não há alteração desse IP ou nova exceção.

O padrão de liberação local é compatível com a descrição AMD de [sincronizador de reset assíncrono, UG906](https://docs.amd.com/r/en-US/ug906-vivado-design-analysis/Asynchronous-Reset-Synchronizer). Isso não dispensa CDC-10: lógica combinacional pode gerar pulsos e a simulação digital não comprova largura mínima de PRE, ausência de metastabilidade ou ausência física de glitches. Não foi identificado defeito funcional nesses cones que justifique substituir as cadeias ou registrar o OR, atrasando a proteção contra perda de calibração.

O ensaio novo usa XPM real: referência nominal, pulso de 1 ns em cada uma das três fontes durante escrita, pulso de perda de calibração com UI parada e retorno posterior, e regressão do reset durante retorno à BRAM. Exige recuperação e compara endereço, CRC32, cada byte recebido e cada byte da imagem de saída. Com UI parada, exige reset local ativo, origem indisponível e nenhum banco pendente; após retorno exige quadro novo íntegro. Os seis cenários passaram. Pulsos são estímulos lógicos, não especificação elétrica aceita para a FPGA. Também não qualificam resets repetidos antes de `wr_rst_busy`/`rd_rst_busy` terminarem, condição que a [UG953](https://docs.amd.com/r/2024.2-English/ug953-vivado-7series-libraries/XPM_FIFO_ASYNC) restringe. Log bruto: `evidencias/reset-fechamento-20261109.txt`.

```bash
OUT="$PWD/validation/reset-fechamento-final" bash scripts/test_video_ddr2.sh --reset-only
```

### Clocking MIG

O REQP-1709 aponta precisamente a diferença entre CLKOUT3→BUFH→MMCM e CLKOUT0–2→PHASER/controle. O RTL gerado contém essa topologia e COMPENSATION=BUF_IN; não foi introduzida pelo espelho. Os clocks de memória 325 MHz, referência PHASER 650 MHz e UI 81,25 MHz são coerentes com a relação 2× de referência abaixo de 400 MHz e UI a 1/4 descritas pela AMD em [Clocking Architecture, UG586](https://docs.amd.com/r/en-US/ug586_7Series_MIS/Clocking-Architecture?contentId=RgaY9X9JIysZNUWlzwAGGg) e [Internal FPGA Logic Clock](https://docs.amd.com/r/en-US/ug586_7Series_MIS/Internal-FPGA-Logic-Clock?contentId=ahFtqieBVh~leekxFphRBw). Isso sustenta preservar os buffers gerados; não foi encontrada dispensa específica AMD para a ocorrência. Calibração e estabilidade do PHY continuam pendentes. Não foi aplicado waiver nem anunciado CDC limpo.

### Mapa físico recebido e perfil corrigido

Após autenticação feita pelo usuário, o mapeador O_RDONLY concluiu: partição começa em LBA 8192 (4.194.304 bytes), arquivo começa no **LBA absoluto 30028160** e ocupa 13501 setores de conteúdo. A extensão FAT contígua reserva 13504 setores; os três setores finais de alocação não pertencem ao arquivo e não devem aumentar `MAX_FILE_SECTORS`. O mapper percorreu a cadeia de clusters e conferiu as cópias FAT; seus números individuais de clusters não são exportados pelo relatório atual. O hash integral físico conferiu com a referência local: `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2`. Cópia exata do relatório: `evidencias/mapa-cartao-20261109.json`. A montagem permanece ro.

O perfil anterior LBA=1/2599651 setores rejeitaria o cabeçalho de 90 quadros: o loader exige `frame_count == (MAX_FILE_SECTORS-1)/150` e tamanho exato. O perfil novo corrige ambos: LBA=30028160/13501 setores, 320×240/30 nominal, leitura SPI=400 kHz e calibração preservada. Está em `evidencias/perfil-cartao-fechamento.json`, inclusive o vetor exato de argumentos do build. O vídeo não foi alterado.

### Vazão e limites do perfil conservador

Cada quadro exige 150 CMD17 de 512 bytes. O limite inferior de transação, sem esperas, inclui 6 bytes comando, pelo menos 1 R1, 1 token, 512 dados, 2 CRC e 1 byte final com CS alto: 523 bytes equivalentes por setor. Há ainda transições de FSM, polling R1/token, arbitragem, espera do cartão e releitura DDR2.

| SPI | Capacidade bruta | Tempo mínimo de 150 transações | Limite superior ideal de FPS |
|---|---:|---:|---:|
| 400 kHz, divisor 125 | 50.000 B/s | 1,569 s | 0,637 |
| 25 MHz, divisor 2, somente modelo qualificado | 3.125.000 B/s | 25,104 ms | 39,834 |

A 25 MHz, 30 FPS requer 2.304.000 B/s úteis e deixa no máximo 8,229 ms/quadro após esse limite ideal; o modelo anterior mediu 25,15651 ms de carga, reduzindo o orçamento a 8,177 ms (~54,5 µs/setor em média), antes dos outros custos não sobrepostos. Isso não é margem física garantida. A 400 kHz, o loop de 90 quadros leva **pelo menos 141,21 s**, e não os 3 s nominais do arquivo. O timeout do espelho é ~4,923 s; esperas longas podem provocar descarte/recuperação. Não foi aumentado SPI ou alterada constraint elétrica. A VGA segue seu clock fixo; o fundo permanece estável entre atualizações lentas.


O cenário integrado nominal foi repetido com `BASE_LBA=30028160` tanto no loader como no modelo SDHC, para detectar truncamento/endereço incorreto na serialização CMD17. Passou com quatro publicações, loop ao quadro zero, zero erros e 2.150.400 comparações RGB. Usa fixture sintética de três quadros completos a SPI 25 MHz e modelo UI sem PHY; não é reprodução física dos 90 quadros nem validação do SPI rápido. O teste decodifica os comandos de 32 bits no modelo do cartão e compara os pixels publicados. Log: `evidencias/pipeline-lba-real.txt`.

```bash
OUT="$PWD/validation/pipeline-lba-real" BASE_LBA=30028160 SCENARIOS=0 bash scripts/test_sd_ddr2_vga.sh
```

Os 76 arquivos RTL, três arquivos MIG, três XDC e quatro arquivos de placa do manifesto congelado conferiram por SHA-256 na nova área. O diff dos fontes de produção e constraints contra `3fc45f2` é vazio. As diferenças de simulação continuam explícitas: MIG substituído por modelo UI, sensores ausentes nos ensaios anteriores, fixture de vídeo e frequência SPI de modelo. O novo build usa as fontes de produção preservadas com o perfil mapeado; resultados da implementação serão registrados em `RESULTADO_FINAL.md` e `evidencias/resultado.json`.


### Implementação do perfil mapeado

O build concluiu às 07:12:20 de 09/11/2026, fuso America/Sao_Paulo. O vetor executado é o campo `command` de `evidencias/perfil-cartao-fechamento.json`; cada genérico foi também conferido no XPR produzido pelo Vivado. WNS +0,335 ns, WHS +0,016 ns, TNS/THS zero, oito grupos de skew (mínimo +6,863 ns), zero erros DRC, zero no_clock e zero endpoints internos sem temporização. Não são os números históricos +0,230/+0,011 ns. Há 29 entradas e 40 saídas sem delay externo, portanto a aprovação interna não é sign-off de interface.

A consulta complementar executou `scripts/qualificar_rc.tcl` e `scripts/qualificar_clock_reset.tcl` com esta raiz, depois `scripts/inspecionar_reset_routed.tcl resultado/routed.dcp evidencias/reset-cones-mapeado-20261109.txt`, usando Vivado em batch e logs novos em `validation/fechamento-reset/`. Os cones de reset do novo DCP são textualmente iguais aos da referência. Os cinco FF de origem ficaram em SLICE_X59Y62 e os cinco UI em SLICE_X61Y63, todos ASYNC_REG=1. O código gerado `mig_7series_v4_2_infrastructure.v` também é idêntico ao anterior, SHA-256 `2dbb9bb2a1a4b95407c16b87d9ab421ba1d25c516a6faddff50fa46392035c52`.

A metodologia continua com 134 ocorrências e nenhum waiver. CDC mantém 46 CDC-3, 3 CDC-10, 1 CDC-8 e 176 CDC-15. O pior hold de 16 ps é interno ao domínio pixel, no caminho attitude_pending_reg[146]→attitude_display_reg[146], canto rápido do modelo; é positivo, mas estreito. Sem defeito de RTL demonstrado, não se alterou a atitude nem se iniciou uma busca de seeds apenas para aumentar a margem. Ficam retidos os checkpoints; nenhum `.bit` foi gerado enquanto reset/clocking e a interface externa não têm qualificação suficiente. Os relatórios brutos novos estão em `evidencias/relatorios-fechamento/`, sem tratamento de whitespace, e o log integral em `evidencias/build-fechamento.txt`.


## Liberação experimental do bitstream em 09/11/2026

A missão posterior autorizou explicitamente gerar um `.bit` experimental sem esperar a validação física, mantendo a proibição de programar hardware. A análise anterior não identificou contenção de barramento, tensão incompatível ou falha funcional demonstrada nos três cones de reset. Por isso, os avisos qualificados abaixo não impedem este ensaio controlado. Isso revisa o gate conservador da entrega `74b3541`; não declara resolvida a qualificação física nem altera o RTL para remover avisos.

| Item | Decisão para o candidato experimental | Limite preservado |
|---|---|---|
| Dois CDC-10 próprios | Reset comum chega a PRE, nunca a payload. Cinco estágios locais, ASYNC_REG, agrupamento em slice, exceções apenas nos PRE e bloqueio XPM busy. Os testes de reset, perda de calibração e parada/retorno UI passaram. Não há falha de dados demonstrada que exija nova topologia. | Pulso físico, metastabilidade, glitches e reset repetido durante busy não foram medidos. Evitar reset repetido antes da recuperação. Não há waiver. |
| CDC-10/CDC-8 MIG | Cones e código gerado conferidos; cadeia interna de reset do MIG, sem edição. A calibração e os locks condicionam a liberação. | A qualificação estrutural não é prova de calibração física; não se concede dispensa AMD inexistente. |
| REQP-1709 | CLKOUT0–2→PHASER/controle e CLKOUT3→BUFH→MMCM BUF_IN correspondem ao RTL gerado e às relações de clock UG586 já documentadas. Preservar o IP. | Alerta permanece no DRC e estabilidade real é requisito de teste. Não trocar buffers por preferência. |
| SPI/microSD | Inicialização e leitura em 400 kHz, divisor 125; SD_RESET E2, SCK B1, MOSI C1, MISO C2, CS D2, CD A1, todos LVCMOS33. SD_DAT0 permanece entrada. Controlador executa leitura CMD17/CRC16; não há alteração do cartão. | Existem IOs sem delay externo. Não há sign-off de setup/hold do cartão, nem autorização técnica para 25 MHz físicos ou 30 FPS. CRC/timeout detectam falha funcional; não substituem medição elétrica. |
| Pinagem e alimentação | CFGBVS=VCCO, CONFIG_VOLTAGE=3.3; 132 atribuições IO iguais ao build preservado, incluindo DDR2. Oscilador E3=100 MHz. Não houve mudança em sensor/pino/drive/slew. | Exige a placa e conexões conhecidas, sem reconfiguração elétrica. |

A referência primária [manual Nexys A7, seções 5 e 11](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf) confirma oscilador E3, uso SPI do slot, entrega do barramento à FPGA após configuração e SD_RESET ativo baixo para alimentar o slot. As atribuições de SD conferem com [Master XDC Digilent](https://github.com/Digilent/Nexys-A7-100T-OOB/blob/master/src/constraints/Nexys-A7-100T-Master.xdc). O candidato usa a interface nativa da placa, sem adaptador ou nível novo. A inferência de segurança elétrica para o ensaio decorre de direções/níveis compatíveis e da preservação do circuito conhecido; não de uma promessa de desempenho do cartão.

Foi executado um novo teste a 400 kHz do `sd_spi_read_block` real, usando o cabeçalho de 512 bytes da amostra mapeada e modelo SDHC. Verificou CMD17 no LBA 30028160, cada byte/endereço, CRC16 e cada meio período SCK de 1250 ns. PASS em `evidencias/spi-400khz.txt`. O modelo não inclui atraso analógico. Reprodução:

```bash
mkdir -p validation/spi-400khz
iverilog -g2012 -s tb_sd_read_400khz -o validation/spi-400khz/test.vvp \
 tests/tb_sd_read_400khz.sv tests/sd_video_card_model.sv hud/rtl/sd_spi_read_block.sv
vvp validation/spi-400khz/test.vvp +VIDEO_HEX=tests/sd_header_90.hex
```

O contrato de fontes/CRC também passou novamente. Os seis cenários de reset e o integrado no LBA real da entrega `74b3541` continuam válidos, pois nenhum RTL/XDC foi alterado. A regressão longa anterior não foi repetida. A proveniência do DCP foi conferida por SHA-256 antes da emissão.

`write_bitstream` foi executado no checkpoint roteado SHA-256 `99edc5c8f61a2b272b53a8a9dad6c6c200a48095d1c210a52e9f38f0e8e3c3e3`. Não houve nova síntese/route nesta etapa, porque o RTL e o perfil mapeado são idênticos ao build já aprovado internamente (+0,335/+0,016 ns). A geração terminou com zero erros, sem reduzir severidades ou acrescentar exceções. Configuração serial x1 e CONFIGRATE=3, somente para opções de configuração; não altera o SPI do microSD. Registro: `evidencias/relatorios-release/config_properties.txt`. O script recusa DCP cujo SHA não corresponda; o guard passou com entrada correta e rejeitou entrada diferente.

O `.bit` tem 3825992 bytes, cabeçalho `7a100tcsg324`, payload com tamanho consistente e sync word AA995566. SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. Log completo: `evidencias/bitgen-release.txt`; DRC/route status: `evidencias/relatorios-release/`. Nenhum hardware manager/JTAG foi aberto.

A `.mcs` não foi gerada: o modelo físico exato ainda não é identificável offline. A [página oficial Digilent](https://digilent.com/shop/nexys-a7-amd-artix-7-fpga-trainer-board-recommended-for-ece-curriculum/) informa variantes S25FL127S/S25FL128S; o RDID histórico comum não resolve a revisão. CONFIGRATE e largura x1 registrados no BIT não identificam a Flash. Não selecionar um part de programação por aproximação.


## Correção dos indicadores após o primeiro ensaio físico

Base preservada: commit publicado `52e223d22a190b61c868cfa2966d83ff715fd965`, BIT `hud-f16-ddr2-74b3541-experimental.bit`, SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. O usuário confirmou que programou esse arquivo por JTAG e fotografou antes de desligar/religar. A identidade é atribuída por esse relato, não por SHA recuperado da SRAM. Nesta sessão a interface USB-JTAG não está enumerada no computador e não há Hardware Manager ativo; os logs locais selecionados não contêm uma programação correlacionável. Registro: `evidencias/identificacao-teste-fisico.json`. Não foram executadas programação JTAG, gravação Flash ou operações no cartão.

### Causa confirmada no código publicado

LD12 era `ref_mmcm_locked`, LD13 `calib_ok`, LD14 `smoke_done && smoke_pass` e LD15 `smoke_error`. Em modo DDR2_VIDEO, os três últimos sinais de teste vêm diretamente de `ddr2_sd_frame_mirror`, no domínio UI. `CHECK_BYTE` conclui CRC32 e ativa done/pass; `WAIT_START`, ao consumir START seguinte, limpa done/pass/error. Assim, LD14 é uma janela de sucesso da última releitura, que pode desaparecer imediatamente com a pré-carga seguinte. LD15 também esquece uma falha na próxima tentativa. Nenhum dos dois representa histórico persistente; LD14 não observava o ACK da troca de banco. Isso explica por que LD14 apagado não comprova ausência de quadros válidos. Não comprova, por si, que essa foi a única causa da fotografia.

Há também `VIDEO_SENSOR_STARTUP_CYCLES=1000000000` a 100 MHz: espera de até 10 s para liberar vídeo, antes da carga. A 400 kHz um quadro precisa de pelo menos 1,569 s mais overhead/esperas. Calibração pronta e imagem HUD visível não encerram essa espera nem provam a origem dos pixels de fundo.

### Eventos do pipeline e origem dos pixels

| Sinal | Domínio | Significado exato |
|---|---|---|
| `video_frames` | HUD 100 MHz | Incrementa no COMMIT do loader após quadro SD completo com setores CRC16 válidos. Ainda não prova releitura DDR2 ou banco publicado. |
| `video_errors` / `video_failed` | HUD | Falhas do loader/cabeçalho/leitura. Contador não é o diagnóstico CRC32 do MIG. |
| `video_late` | HUD | Carga SD excedeu o período nominal; esperado no perfil 400 kHz, não é corrupção. |
| `video_cycles` | HUD | Ciclos de carga da última transferência SD, não tempo de publicação nem FPS VGA. |
| `smoke_done/pass/error` | UI MIG | Resultado da transação de escrita/releitura/CRC32; limpo no próximo START. |
| `ddr_out_commit` | HUD via FIFO XPM | Token de commit somente após readback/CRC32 aprovados; encerra o quadro no banco BRAM inativo. |
| `g_video.u_frames.rd_updated` | Pixel 25 MHz | Pulso da troca real do banco na fronteira permitida; diferente de visibilidade de fundo. |
| `video_frame_published` | HUD | Novo nome para o `wr_published` existente: ACK da troca, após drenar leitura anterior e passar pelo sincronizador de retorno. |
| `sd_publications` | HUD | Publicações do overlay/ícone diagnóstico de setor. Não conta quadros de vídeo. Com ENABLE_SD_OVERLAY=0, não comprova avanço do vídeo. |

No perfil físico, ENABLE_DDR2_VIDEO=1 faz todos os controles/dados de `u_frames` virem do retorno DDR2. O caminho SD direto→BRAM é selecionado apenas em outro build com essa opção zero; não existe fallback automático que contorne a DDR2 neste BIT. A saída do compositor ainda pode ser apenas HUD (vídeo desativado, banco inválido ou pixel opaco). Logo, a imagem F-16/HUD descrita nas fotos permanece **sem comprovação física independente de origem DDR2**. Na simulação, a origem é comprovada por comandos/bytes CRC16, escrita/leitura MIG, CRC32, troca do banco e comparação de cada pixel exibido.

### Alteração mínima

`ddr2_video_status.sv` só registra diagnóstico, sem dirigir ready, dados, FSM, reset do vídeo ou seleção de banco. Usa exclusivamente sinais do domínio HUD. LD14 mantém histórico de um commit DDR2 seguido do ACK de publicação. Commit sem ACK ou ACK sem commit não acende PASS. Uma pré-carga abortada não invalida o commit íntegro já pendente de publicação. LD15 registra `video_failed`, erro do buffer ou ABORT após início de uma transferência; o ABORT de calibração inicial é ignorado. PASS e erro podem ficar simultaneamente acesos: houve quadro válido e também uma falha na sessão.

O reset desse histórico é `reset_operacao`, de inicialização do HUD. Recarregar o candidato por JTAG limpa LD14/LD15. CPU RESET reinicia o MIG, mas não apaga histórico; uma transferência interrompida pode registrar erro. Desligar/religar volta ao firmware anterior da Flash e exige nova carga JTAG do candidato para testar a correção. Não foram reaproveitados botões nem alterados sensores/modos.

Nenhum pulso do clock pixel foi ligado diretamente à lógica de LEDs: o diagnóstico usa `wr_published`, cujo CDC de ACK já existe no buffer. A indicação legada é mantida quando ENABLE_DDR2_VIDEO=0. Não há ILA, novo clock, porta ou constraint adicional.

### Verificações executadas

O teste unitário `tb_ddr2_video_status` aprovou ausência de falso PASS, espera por publicação, persistência, abort de pré-carga, erro seguido de recuperação e limpeza do histórico no reset. Os 17 cenários XPM existentes passaram com as novas assertions do status: quadro de 76800 bytes, corrupções, abort, timeout, FIFO cheia, backpressure, reset de origem/UI/calibração, retorno, múltiplos quadros e preservação da última imagem. Também passaram FIFO real com 3072 palavras, contrato/CRC, cinco testes do conversor e cadência XADC. Logs novos em `evidencias/status-unit.txt` e `status-xpm.txt`. São testes digitais; não constituem nova prova física.

O teste específico de ajuste vertical passou novamente em passo, blanking, saturação, clipping e preservação do fundo (`evidencias/hud-offset-status.txt`). A geometria/atitude/bússola não foi alterada. Os 12 modos da release anterior são evidência histórica, não reexecução nova.

O top completo original com QUICK_STATUS=1 passou com 307200 pixels, duas publicações, um erro CRC16 injetado e LEDs=1111 após uma publicação íntegra. Confirmou LD14 persistente enquanto smoke_done já estava zero e LD15 retido após erro. Os sensores desse teste são NACK e a DDR2 é modelo UI, sem PHY. O teste usa 160×120, SPI de modelo 25 MHz e temporizador acelerado, sem alterar os parâmetros físicos do candidato.

O executor recebeu também uma espera RETRY_CYCLES=50 apenas no testbench para repetir esse diagnóstico sem simular a espera de 100 ms pixel a pixel; a versão anterior já tinha concluído com PASS quando foi conferida. A repetição e o ensaio separado da recuperação BRAM terão seus logs finais registrados no resultado. Não há falha funcional ocultada por essa aceleração: CRC, número de retries e FSM são os reais.

Para o próximo ensaio será gravado somente no arquivo BIT o USERID do commit RTL, legível por REGISTER.USERCODE no Hardware Manager. Esse identificador não recupera SHA-256 da SRAM e não é atestado criptográfico; evita confundir o firmware da Flash com a candidata sem introduzir lógica na FPGA. Referências AMD: [UG908, USERID](https://docs.amd.com/r/en-US/ug908-vivado-programming-debugging/7-Series-Bitstream-Settings) e [UG912, HW_DEVICE/REGISTER.USERCODE](https://docs.amd.com/r/en-US/ug912-vivado-properties/HW_DEVICE).


A repetição acelerada do top passou: 307200 pixels, duas publicações, três quadros SD carregados, um erro CRC16 e LEDs=1111. A diferença entre três cargas e duas publicações demonstra por que os contadores não são equivalentes. A recuperação BRAM passou separadamente com 307200 pixels, duas publicações e **zero leituras/escritas MIG**, com app_rdy/app_wdf_rdy bloqueados apenas no modelo. Logs: `evidencias/top-status-original.txt`, `top-status-fast.txt`, `top-bram-status.txt`.

A nova implementação do RTL `b38e538b330805b265fe1b9a7cf45d7c5501acec` concluiu em Vivado 2026.1 com WNS +0,468 ns, WHS +0,017 ns, TNS/THS zero, pulse-width mínimo +0,206 ns, oito grupos de skew (mínimo +6,449 ns), zero erros DRC. Mantém 46 CDC-3, 3 CDC-10, 1 CDC-8 e 176 CDC-15; nenhum alerta CDC novo e nenhum waiver. As 132 atribuições IO conferiram com a candidata anterior. Os clocks e o IP MIG permanecem iguais. Utilização: 20616 LUTs, 15399 FF, 64 tiles BRAM e 62 DSP. A folga de hold continua estreita e as ressalvas externas da primeira RC continuam aplicáveis. Relatórios novos em `evidencias/relatorios-status/`, log completo `evidencias/build-status.txt`.

Reprodução: `iverilog -g2012 -s tb_ddr2_video_status -o SAIDA_NOVA tests/tb_ddr2_video_status.sv hud/rtl/ddr2_video_status.sv`; executar com vvp. Para XPM, `OUT=PASTA_NOVA bash scripts/test_video_ddr2.sh`. Para o top, `OUT=PASTA_NOVA QUICK_STATUS=1 bash scripts/test_top_ddr2_video.sh`; para BRAM, `OUT=OUTRA_PASTA TOP_CASE=bram bash scripts/test_top_ddr2_video.sh`. O perfil real de build mantém o vetor `command` de `evidencias/perfil-cartao-fechamento.json`; fonte e genéricos foram conferidos contra `fontes-status-build.json` e o XPR efetivamente sintetizado.


O novo BIT foi gerado e validado como arquivo: 3825990 bytes, part 7a100tcsg324, USERID B38E538B, payload/tamanho/sync conferidos, SHA-256 `7c74a9d635f378c980f6378683126f182df92bcc0c3a16e19c1d11ecdd8df292`. A primeira checagem de cabeçalho esperava o prefixo 0x usado pelo default anterior; a forma explícita retornada pelo Vivado é UserID=B38E538B, normalizada e conferida contra config_properties.txt. Não foi falha de RTL nem reemissão do BIT. Log `evidencias/bitgen-status.txt`; DCP SHA-256 `57f162876e9e0f26cac82d4ce7f6770ad5fdc6561740e7d5b009bc129590ba10`. Nenhum hardware foi programado.

## Reprodução offline SPI 5 MHz nesta consolidação

Fonte exata f8b36f8, build isolado, sem alteração de RTL/constraints. Snapshot das fontes/board/scripts e manifesto em `evidencias/spi-h010-reproducao/`. Os resumos `spi-h010-f8b36f8/` são históricos. O BIT histórico não foi localizado; o novo BIT tem SHA `2fd3dbc1d0da6fb4d3a8962f811d740fed0b2b23317928c3b591f7c44e1157b2`, DCP `110d421af4501b52c808f830582edb1f41ea61731e60f704aff6771b7faf4043`, USERCODE 5DF8B30A. Não houve JTAG/Flash/cartão nesta execução. Datas e metadados de nova emissão podem alterar hashes, e identidade binária não foi presumida.

Comandos reais: `bash scripts/build_spi_profile.sh 10`; `bash scripts/test_spi_profiles.sh`; `SCENARIOS=6 READ_HALF=10 INIT_HALF=125 BASE_LBA=30028160 bash scripts/test_sd_ddr2_vga.sh`; `bash scripts/emit_spi_profile_bit.sh resultado-spi-h010-f8b36f8`. O executor integrado atualizado aceita os divisores opcionais; seus padrões foram mantidos. Para os relatórios adicionais, `resultado` foi um link local para a pasta produzida, seguido de `vivado -mode batch -nojournal -source scripts/qualificar_rc.tcl -tclargs RAIZ_BUILD`. Nenhum novo parâmetro elétrico ou exceção foi acrescentado.

Os 23 cenários SPI passaram. O integrado passou com 7.372.800 comparações RGB, quatro publicações, quatro releituras válidas, 20273 escritas e 19200 leituras MIG e quatro pré-cargas, sem erros. Os quatro late_frames são esperados em 5 MHz frente à meta nominal 30 FPS; não são CRC ruim. Intervalos observados no modelo: 134,4 / 117,6 / 134,4 ms (três intervalos, amostra curta). Não se extrapola para estabilidade de longa duração ou FPS físico. XPM real e UI MIG modelada não simulam o PHY.

Nova implementação: WNS +0,391 / WHS +0,006 ns, TNS/THS zero, oito grupos de bus skew com mínimo +6,810 ns. DRC sem erros, 104 ocorrências de warning; CDC 46/1/3/176 para CDC-3/8/10/15, respectivamente. Sem waivers. Clocks base 100 MHz, pixel 25 MHz, UI ~81,25 MHz. Zero no_clock/endpoints internos sem constraints. As 132 atribuições IO, incluindo drive/slew/terminação, são idênticas à candidata de status. Utilização 20630 LUT, 15389 FF, 64 BRAM tiles e 62 DSP. Logs completos acompanham os relatórios.

Persistem três CDC-10 e um CDC-8, os mesmos resets/IP já analisados nas seções anteriores, e REQP-1709. `report_methodology` contém 43 TIMING-18; o orçamento elétrico externo não foi fechado. Hold de somente 6 ps restringe a margem de implementação. O emissor conferiu part, hash do checkpoint, timing positivo e DRC; cabeçalho, payload/sync e hash do BIT foram analisados depois. Perfil-spi-build.json é o registro ao terminar o build, antes da emissão (bitstream_generated=false naquele instante); manifesto-build.json registra o BIT efetivamente gerado depois.

Os testes anteriores de status persistente, modos, sensores e BRAM não foram integralmente repetidos, pois suas fontes não mudaram. O diagnóstico físico precisa seguir PROCEDIMENTO_TESTE_FPGA.md. CRC_ERROR=0 do log de configuração histórico não qualifica CRC16 SD ou CRC32 do vídeo. As três cronometragens de loop são estimativas condicionadas à sequência completa; contagem instrumentada de publicação é outra evidência. A simulação de atraso MISO 0–30 ns permanece um modelo, sem comprovar os atrasos reais. Não houve aumento além de 5 MHz nem alteração de qualidade do vídeo.
