# Validação offline da sprint noturna

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
