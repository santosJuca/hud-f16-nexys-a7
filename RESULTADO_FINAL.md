# HUD F-16 DDR2 — release candidate experimental

## CONFIRMADO

BIT experimental gerado pelo Vivado 2026.1 a partir do checkpoint roteado do perfil real de `74b3541`, sem alteração de RTL/XDC de produção. Cabeçalho `7a100tcsg324`, payload e tamanho conferidos; geração concluída com zero erros. O estado permanece **EXPERIMENTAL — NÃO VALIDADO FISICAMENTE**.

O build mapeado já concluído tem WNS +0,335 ns / WHS +0,016 ns, TNS/THS zero, oito grupos de skew (mínimo +6,863 ns), zero erros DRC, zero clocks ausentes e zero endpoints internos não temporizados. Esses números pertencem ao build mapeado preservado; não foi feita nova síntese/route nesta emissão. Os números +0,230/+0,011 ns são da sprint noturna anterior.

O novo teste CMD17 a 400 kHz passou: LBA 30028160, CRC16, 512 bytes do cabeçalho físico e meios períodos de 1250 ns. O contrato estático/CRC também passou novamente. Guard de SHA do DCP testado com entrada correta e incorreta. Os seis testes de reset e as 2.150.400 comparações RGB do LBA alto de `74b3541` são herdados sem mudança do RTL. A regressão histórica de 17 casos DDR2, 18.432.000 comparações RGB e 12 combinações de modos não foi repetida.

O mapa físico autenticado pelo usuário já confirma 90 quadros 320×240/30 nominal, LBA absoluto 30028160, 13501 setores contíguos, hash `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2`. O perfil anterior sintético foi corrigido na entrega precedente. O vídeo completo de 17331 quadros segue no computador, sem reconversão. A frequência SPI permanece 400 kHz, com atualização lenta e sem garantia de 30 FPS físicos.

## CDC, CLOCKING E LIMITES

Os três CDC-10 foram rastreados: dois no reset comum próprio com liberação por cinco estágios locais, um no MIG com cadeia gerada. ASYNC_REG, agrupamento e exceções específicas conferidos; sem waiver ou alteração do IP. Não foi demonstrado defeito funcional que exija nova topologia. REQP-1709 corresponde à topologia PLL/BUFH/MMCM BUF_IN/PHASER gerada. Os clocks observados são 100 MHz E3, 25 MHz VGA, 200 MHz referência, 81,25 MHz UI, 325 MHz memória e 650 MHz referência PHASER. O XADC/temperatura e a calibração conservam o fluxo qualificado na referência.

A missão posterior permitiu emitir um candidato experimental com avisos tecnicamente qualificados, sem aguardar o teste físico que depende do BIT. Pinagem/direções/níveis SD LVCMOS33 e CFGBVS/CONFIG_VOLTAGE=3.3 conferem com a placa; nenhum comportamento elétrico inseguro conhecido foi identificado. O teste digital a 400 kHz não é sign-off de IO externo. Permanecem três CDC-10, um CDC-8 MIG, 176 CDC-15 e REQP-1709; largura física de pulso, glitches, reset repetido durante busy, margens externas, PHY e sensores serão avaliados em hardware. A análise detalhada e fontes primárias estão na última seção de VALIDACAO_OFFLINE.md. Não foram inventados IO delays ou reduzidas severidades.

Não foi gerada MCS: a identidade exata da Flash S25FL127S/S25FL128S/revisão não foi confirmada offline. O BIT registra configuração serial x1 e CONFIGRATE=3, sem alteração do clock SPI do cartão. A imagem de Flash será preparada após identificação e aceite físico do BIT.

## ARTEFATOS

Área local: `/home/santojuca/Downloads/hud_ddr2_release_20261109`. Branch: `release/hud-f16-ddr2-video-rc`. Referência preservada: `74b354144c75274c4ff59dff83c80a68dabe1dd8`, na área `hud_ddr2_fechamento_20261109`.

| Artefato | SHA-256 |
|---|---|
| `hud-f16-ddr2-74b3541-experimental.bit` (3825992 bytes) | `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370` |
| DCP roteado correspondente | `99edc5c8f61a2b272b53a8a9dad6c6c200a48095d1c210a52e9f38f0e8e3c3e3` |
| BIT funcional anterior de recuperação | `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f` |

BIT local em `resultado-release/`; DCP original preservado em `/home/santojuca/Downloads/hud_ddr2_fechamento_20261109/resultado/routed.dcp`. Os assets incluem cópia do DCP e BIT de recuperação; nenhum binário/checkpoint entra no histórico Git. Logs: `evidencias/bitgen-release.txt`, `spi-400khz.txt`; relatórios de emissão em `evidencias/relatorios-release/`, implementação em `evidencias/relatorios-fechamento/`. Manifesto de fontes: `evidencias/manifesto-release-fontes.json`; manifesto de assets e SHA256SUMS na pre-release, com commit exato da tag. O script de emissão passou a recusar checkpoint de hash divergente.

## GITHUB E PRÓXIMA AÇÃO

Destino dedicado: [branch](https://github.com/santosJuca/Trabalho-display-aviao-v2/tree/release/hud-f16-ddr2-video-rc) e [pre-release hud-f16-ddr2-rc-20261109](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-rc-20261109). O commit da tag é registrado no manifesto dos assets; o retorno do GitHub deve ser conferido antes de declarar a publicação concluída. A main e o atlas elétrico não são alterados.

Baixar os assets com `gh release download`, conferir `sha256sum -c SHA256SUMS` e seguir PROCEDIMENTO_TESTE_FPGA.md no Vivado 2026.1 para JTAG SRAM. Conferir part/alvo, DONE, LD12–15, calibração, primeiro quadro, loop lento dos 90 quadros, HUD/sensores, modos, ajuste, reset e recuperação. A 400 kHz o loop tem mínimo ideal 141,21 s; não declarar 30 FPS físicos. Flash somente após aceite físico e identificação do chip, conforme PROCEDIMENTO_FLASH_QSPI.md.

**JTAG não executado. Flash não gravada. Cartão não modificado. Teste físico pendente.**
