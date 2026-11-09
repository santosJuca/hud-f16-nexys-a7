# Resultado do fechamento técnico HUD F-16

## CONFIRMADO

Área isolada: `/home/santojuca/Downloads/hud_ddr2_fechamento_20261109`, branch `sprint/fechamento-tecnico-20261109`, derivada de `3fc45f2a782f54fff0e22338775fd8697d405700`. A referência noturna permanece preservada. A FPGA, a Flash, o cartão e a main não foram modificados; não houve JTAG ou publicação.

O mapa físico foi concluído pelo usuário com o mapeador O_RDONLY. A partição começa em LBA 8192; `HUDVIDEO.BIN` começa no **LBA absoluto 30028160**, com **13501 setores de conteúdo**, uma extensão contígua de 13504 setores e hash integral idêntico à amostra local. São 90 quadros RGB332 de 320×240/30 nominal. A montagem continua ro. Relatório exato: `evidencias/mapa-cartao-20261109.json`.

Foram executados seis cenários focados com XPM real: nominal, pulsos lógicos de 1 ns nas três fontes de reset, perda de calibração com clock UI parado/retornado e reset durante retorno à BRAM. Todos passaram com recuperação, CRC e comparação dos bytes da imagem. O teste integrado no LBA alto passou com quatro publicações, loop ao quadro zero, zero erros e **2.150.400 comparações RGB**. Usa fixture sintética de três quadros, SPI de modelo 25 MHz e modelo UI MIG, sem PHY. Não é reprodução física dos 90 quadros. O contrato estático também passou; os 86 arquivos congelados de RTL/MIG/XDC/placa conferiram por hash.

A nova síntese e implementação Vivado 2026.1 aplicaram o perfil real do cartão e calibração preservada: **WNS +0,335 ns, WHS +0,016 ns**, TNS/THS zero, pulse-width mínimo +0,206 ns; **oito grupos de skew aprovados**, menor folga +6,863 ns; **zero erros DRC**. Clocks ausentes e endpoints internos não temporizados: zero. Utilização: 20656 LUTs, 15391 registradores, 64 tiles BRAM, 62 DSP e 131 IOB. Genéricos conferidos no projeto Vivado, não apenas no comando de entrada.

Os resultados anteriores de 17 cenários DDR2, 18.432.000 comparações RGB e 12 combinações de modos são históricos confirmados nos arquivos da referência. Não foram repetidos integralmente. As mudanças desta sprint estão nos testes, perfil e documentação; **não houve alteração do RTL de produção, sensores, atitude, orientação magnética ou constraints**. O caminho BRAM permanece disponível.

## CORRIGIDO

O build anterior usava LBA=1 sintético e 2599651 setores do vídeo completo. Esse perfil rejeitaria o cabeçalho físico de 90 quadros pelo teste de tamanho/frame_count do loader. A implementação nova usa **LBA=30028160 e 13501 setores**, sem incluir os três setores extras da alocação FAT. Parâmetros e comando reproduzível: `evidencias/perfil-cartao-fechamento.json`.

A lacuna de cobertura de pulso curto e parada do clock UI foi preenchida. Os três CDC-10 foram rastreados no circuito roteado, com todas as origens, LUTs, clocks e PRE identificados. Dois são o reset próprio comum, liberado por cinco estágios locais; o terceiro é a cadeia de 12 estágios gerada pelo MIG. Não foi encontrado defeito funcional que justifique mudar esses cones. A infraestrutura de clock/reset gerada também confere por hash com a referência.

## NÃO VALIDADO

Continuam **3 CDC-10 críticos, 1 CDC-8 interno MIG e 176 CDC-15 de payloads protegidos**, sem waivers. O detalhamento e a comparação com documentação AMD estão em `VALIDACAO_OFFLINE.md`. A liberação sincronizada e os testes digitais não provam imunidade física a glitches, largura mínima de PRE, metastabilidade ou resets repetidos durante busy. O REQP-1709 corresponde ao caminho gerado PLL→BUFH→MMCM/BUF_IN em paralelo às referências PHASER; foi explicado, não ocultado ou declarado dispensado pela AMD. O relatório de metodologia mantém 134 ocorrências.

A margem de hold é positiva, mas estreita: 16 ps no caminho `attitude_pending_reg[146]`→`attitude_display_reg[146]`, domínio pixel, canto rápido do modelo. Não foi modificado o algoritmo de atitude para aumentar esse número. Permanecem 29 entradas e 40 saídas sem delay externo; SD_DAT0 exige orçamento real da interface. Não se inventaram constraints para aprovar a placa.

**Não foi gerado `.bit` novo**, pois essas ressalvas ainda impedem promoção. A implementação mapeada está preservada como DCP. Calibração/recalibração física, DDR2 contínua, sensores, SPI e taxa efetiva permanecem sem ensaio desta candidata.

SPI de leitura permanece **400 kHz**: capacidade bruta 50 kB/s, carga mínima ideal 1,569 s/quadro, loop de 90 quadros >=141,21 s, antes de esperas. O arquivo de 30 FPS não implica essa taxa na tela. O perfil de 25 MHz foi apenas modelado; 30 FPS exigem 2.304.000 bytes/s úteis, e 60 FPS excedem a capacidade bruta de 25 MHz. Não foi alterada a frequência física.

A conversão completa de 17331 quadros, a origem e as prévias anteriores foram preservadas. Dimensões, cabeçalhos e tamanhos dos dois arquivos locais foram conferidos; a validação integral antiga do vídeo completo não foi repetida. Não houve nova conversão, filtro subjetivo ou redesenho do HUD. As capturas e testes anteriores de modos/ajuste permanecem a evidência offline, sem novo monitor VGA físico.

## ARTEFATOS

O estado estruturado está em `evidencias/resultado.json`; hashes em `evidencias/manifesto-fechamento.json`, que exclui a si próprio. Relatórios novos e brutos: `evidencias/relatorios-fechamento/`; logs novos: `evidencias/reset-fechamento-20261109.txt`, `pipeline-lba-real.txt` e `build-fechamento.txt`. As referências noturnas continuam em `evidencias/relatorios-noturna/` e na área original. Commits locais: `695c4e0` (reset/clock) e `e199ea6` (LBA e perfil); o commit de consolidação pode ser obtido com `git rev-parse HEAD`.

| Artefato | SHA-256 |
|---|---|
| `resultado/routed.dcp` | `99edc5c8f61a2b272b53a8a9dad6c6c200a48095d1c210a52e9f38f0e8e3c3e3` |
| `resultado/synthesized.dcp` | `9c59c8d019cf64d0c52cb9c47cf4a9f0f70389c835fc3d8462ea1b1e28bbb305` |
| Mapa do cartão | `066823aa6b90d362ae600991e955ef46aa1a9c9ad522c931eb2ae01ab097349d` |
| Vídeo físico conferido | `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2` |

## PRÓXIMO TESTE FÍSICO

Primeiro fechar as ressalvas offline e gerar/identificar o `.bit` mapeado; então obter autorização específica para JTAG SRAM. Não programar o DCP nem usar o bitstream antigo como se contivesse esta integração. O passo a passo em `PROCEDIMENTO_TESTE_FPGA.md` cobre retorno do SD com a placa desligada, LD12–15, calibração, carga lenta, loop dos 90 quadros, modos, ajuste vertical, bússola, reset e recuperação. Distingue observação visual de contagem instrumentada de publicação VGA.

Recuperação preservada: `/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`, SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`. O usuário confirmou o boot do firmware anterior; isso não valida a candidata DDR2. Flash futura somente após aceite físico e autorização específica, conforme `PROCEDIMENTO_FLASH_QSPI.md`. Atlas elétrico da main preservado.
