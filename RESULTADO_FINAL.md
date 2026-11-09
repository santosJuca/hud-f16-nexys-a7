# Resultado da sprint noturna HUD F-16

## Estado da entrega

**Candidato offline com avanço funcional demonstrado; programação física bloqueada pelos itens identificados abaixo.** A FPGA, a Flash, o microSD e a main não foram modificados durante a sprint. Nenhum novo `.bit`/`.mcs` foi gerado ou liberado para programação.

- Diretório: `/home/santojuca/Downloads/hud_ddr2_noturna_20261108`.
- Branch: `sprint/noturna-ddr2-20261108`.
- Referência inicial preservada: tag `rc/hud-ddr2-offline-20261108`, commit `93ee5a61a5e53dcf91c5845c0b14c5f446265284`, no diretório original `/home/santojuca/Downloads/hud_ddr2_video_integracao`.
- Mudança funcional implementada no commit `4309c53`, com pré-carga adicionada posteriormente e seguida por commits locais de robustez, testes e documentação. O HEAD final é informado na entrega e pode ser conferido com `git rev-parse HEAD`; não há remotos configurados nesta cópia.

## Alterações implementadas e verificadas

As duas FIFOs próprias foram substituídas por XPM AMD, mantendo FWFT e as portas existentes. Reset coordenado com liberação por cinco estágios locais, bloqueio por busy e constraints oficiais de ponteiros/skew. A saída DDR2 continua entregando apenas quadros completos e íntegros à BRAM de exibição. A seleção do loader DDR2 agora permite pré-carregar o próximo quadro enquanto a BRAM aguarda publicação. No cenário SPI lento, o intervalo caiu de 67,2 para 50,4 ms, mantendo integridade. O caminho BRAM anterior permanece selecionável. Sensores, algoritmo de atitude, correção magnética, pinagem e desenho do HUD foram preservados. O build agora aplica os parâmetros físicos de calibração guardados na referência anterior.

O build Vivado 2026.1 desta sprint terminou com **WNS +0,230 ns, WHS +0,011 ns**, oito grupos de bus skew aprovados (menor folga +6,543 ns), zero erros DRC e gate interno de clocks/endpoints aprovado. Os WNS +0,539 / WHS +0,049 ns da versão inicial são históricos.

O novo CDC não apresenta os antigos 243 CDC-1, 144 CDC-13 ou CDC-6. Conserva **3 CDC-10 de reset**, **1 CDC-8 interno MIG** e **176 CDC-15 de payloads protegidos**. Não foram aplicados waivers. A classificação, endpoints, propriedades reais dos sincronizadores e ressalvas estão em `VALIDACAO_OFFLINE.md`. O clocking gerado mantém REQP-1709 e exige revisão/ensaio físico; não foi modificado internamente para suprimir avisos.

Passaram 17 cenários XPM do caminho DDR2, incluindo quadro de 76.800 bytes, corrupção, saturação, backpressure, reset em escrita/releitura/retorno e recuperação. O teste direto comparou 3.072 palavras atravessando full/empty, wraparound e reset. Cinco testes do conversor, cinco do mapa FAT32 e o teste de cadência do XADC também passaram. O overflow foi observado explicitamente como FIFO cheia e abort pendente.

O pipeline SPI/CMD17/CRC16 → XPM → modelo UI MIG → BRAM → VGA passou inicialmente nos três cenários nominal, CRC recuperado e vídeo desligado/religado, com **6.144.000 comparações de pixels**. A medição nominal adicional obteve carga de 25,15651 ms e publicação a cada 33,600 ms (~29,76 FPS) no modelo a SPI 25 MHz, sem esperas extras de cartão. Não é medição física.

A regressão final dos sete cenários integrados passou com **13.824.000 comparações RGB**: nominal, CRC recuperado, timeout recuperado, cabeçalho inválido, tentativas esgotadas com última imagem preservada, vídeo desligado/religado e leitura lenta com pré-carga observada. O commit RTL qualificado é `415149935a67f0825a995a6aa793366c03683701`. O cenário lento ficou em 50,400 ms por publicação (~19,84 FPS), contra 67,200 ms antes da mudança, sem aumentar o clock SPI.

O top completo também passou: **12 combinações** de estilo/declutter/Solo/Voo/Pouso, **4.608.000 pixels**, retorno do vídeo ao HUD e diagnóstico/ícone isolados. Com os sete cenários anteriores, são **18.432.000 comparações RGB** nesses dois ensaios finais. O teste específico do ajuste vertical passou em passo, commit na fronteira, saturação, clipping e preservação do vídeo de fundo. Esse teste usa fundo constante no compositor; não é ensaio físico.

As execuções de simulação terminaram às 01:06 de 09/11/2026 (America/Sao_Paulo). A consolidação documental foi retomada após as 06:00, mediante a mensagem “Continue”, sem iniciar outros builds ou simulações. Capturas reais da simulação: evidencias/previas/hud-comparativo.png; sensores sem resposta e vídeo de amostra 160×120/10 com temporizador acelerado apenas no ensaio. Não há prova de sensores físicos nessas capturas.

## Vídeo e acabamento

O vídeo completo anterior foi preservado: RGB332, 320×240, 30 FPS nominais de arquivo, 17.331 quadros, 1.331.021.312 bytes. Caminho: `/home/santojuca/Downloads/hud_ddr2_video_integracao/validation/video-completo-320-30/HUDVIDEO.BIN`; SHA-256 histórico `fb5dfdb6bae21b7285d3053bd4725d8f86a06ef0d4a49b311a364075600b3643`. A validação integral anterior de 2.599.650 CRC16 não foi repetida nesta sprint.

A comparação nova entre quatro perfis e quatro cenas, com prévias inspecionadas, favoreceu manter area + RGB8 nativo com dither. Preserva aspecto 16:9 em 320×180 mais barras. Bicubic/lanczos não mostraram ganho objetivo suficiente para uma nova conversão completa. Foram identificados 51 pares idênticos no encerramento; amostras da origem confirmam o logo final estático. Não foram removidos quadros arbitrariamente. Prévia comparativa versionada: `evidencias/previas/comparativo-video.png`.

O HUD não recebeu redesenho subjetivo. As capturas offline e testes do compositor devem ser interpretados com sensores simulados sem resposta, sem prova de legibilidade no monitor VGA físico.

## Limites e próxima ação

Após a sprint, o usuário disponibilizou o cartão no PC. O leitor foi identificado como /dev/sdc, USB serial 816820130806, partição FAT32 UUID 3562-6631. A montagem automática inicial estava em escrita; foi desmontada normalmente e remontada somente leitura antes de acessar o arquivo. O arquivo atual é a **amostra 320×240/30 de 90 quadros**, 6.912.512 bytes, SHA-256 `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2`, idêntica à referência local. Os 90 hashes de quadro e 13.500 CRC16 da cópia extraída passaram. Não é o vídeo completo de 17.331 quadros.

O acesso bruto aos setores foi negado pelas permissões do Linux; sudo exige senha e UDisks OpenForBackup também não autorizou a leitura. Foi enviado ao usuário um comando de leitura para autenticação no Terminal. **Fragmentação, contiguidade e LBA físico continuam INDETERMINADOS** até essa execução. O build usa LBA=1 sintético e SPI conservador de 400 kHz; incorpora o formato completo e a calibração preservada, mas não é imagem de programação física de 30 FPS. A geração de bitstream foi retida porque o mapa e a temporização externa/clocking ainda não satisfazem os critérios de promoção.

A arquitetura contém um quadro DDR2 de trabalho e dois bancos BRAM, sem dupla superfície DDR2 ou leitura/escrita simultâneas. Os testes usam modelo UI, sem PHY DDR2. Permanecem não validados fisicamente: calibração/recalibração, temperatura MIG, clocking/SPI, DDR2 contínua, sensores, vídeo e FPS. O relatório não declara CDC totalmente limpo ou aprovação de hardware.

A menor ação indispensável agora é autenticar no Terminal o comando de mapeamento somente leitura enviado no chat, usando a cópia local conferida da amostra de 90 quadros. Não reutilizar o LBA histórico. Depois, preparar outro build com mapa real e perfil preservado, fechar as ressalvas e obter autorização específica para JTAG. O passo a passo está em `PROCEDIMENTO_TESTE_FPGA.md`; a futura Flash, em `PROCEDIMENTO_FLASH_QSPI.md`.

A recuperação funcional foi revalidada por hash no início da sprint: `/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`, SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`. A confirmação de boot autônomo pelo usuário pertence a esse firmware, preservado na placa. A origem E4DvcvNDQoQ.mp4 foi identificada por SHA-256 89075ad5f74204622fb25c0c0da445cb9a8c18c01515a3f0274216ed1fa0c9a0 nesta sprint. Atlas elétrico já disponível na main desde a execução anterior, commit `14d1bf00d26a621e5d1213a41ff8071a9026a91e`; nenhuma publicação noturna.

Relatórios: `resultado/` e cópia versionada em `evidencias/relatorios-noturna/`. Estado estruturado e hashes finais estão em `evidencias/resultado.json` e `evidencias/manifesto-noturna.json`. Arquitetura: `ARQUITETURA_VIDEO_DDR2.md`. Reprodução: `README.md`.

Checkpoint roteado final: resultado/routed.dcp, SHA-256 `e83af26c3baf3a37f57d602ea6648ecef6f1ac1782bb4184fdfe6077e5657d98`. Checkpoint sintetizado: resultado/synthesized.dcp, SHA-256 `aea47fc86fac7c4acb2a429e54874bcadae2823146e08e9d60876c480faae87f`. A referência XPM anterior permanece em resultado-xpm-4309c53/.
