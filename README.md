# HUD F-16 DDR2 — release candidate experimental

**EXPERIMENTAL — NÃO VALIDADO FISICAMENTE.** Candidato Nexys A7-100T, Vivado 2026.1, pronto para teste temporário por JTAG pelo usuário. Nenhuma FPGA, Flash ou microSD foi programada pelo agente nesta missão. A main permanece preservada.

- Branch: `release/hud-f16-ddr2-video-rc`.
- [Pre-release e arquivos](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-rc-20261109).
- [Programação JTAG e recuperação](PROCEDIMENTO_TESTE_FPGA.md).
- [Validação offline e classificação dos avisos](VALIDACAO_OFFLINE.md).
- [Arquitetura implementada](ARQUITETURA_VIDEO_DDR2.md).

O `.bit` `hud-f16-ddr2-74b3541-experimental.bit` tem SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. A Release inclui BIT de recuperação, DCP, relatórios, manifesto e SHA256SUMS. Os binários/checkpoint são assets; não entram no histórico Git. A `.mcs` está pendente da identificação exata da Flash, conforme [procedimento QSPI](PROCEDIMENTO_FLASH_QSPI.md).

## Perfil e resultado

microSD CMD17/CRC16 → FIFO XPM → quadro de trabalho DDR2 → releitura/CRC32 → FIFO de retorno → dois bancos BRAM → HUD procedural → VGA 640×480. Há pré-carga enquanto a BRAM aguarda publicação e preservação da última imagem válida. O caminho BRAM anterior continua selecionável. Não há dupla superfície DDR2 nem escrita/releitura DDR2 simultâneas.

O cartão mapeado contém **90 quadros RGB332 de 320×240, FPS nominal 30**, LBA absoluto **30028160**, **13501 setores**, contíguo. A extensão FAT reserva 13504 setores; não usar o padding como conteúdo. O vídeo completo de 17331 quadros permanece no computador. O arquivo/cartão não foi alterado. Se mudar o conteúdo ou a alocação, repetir o mapa somente leitura antes de usar este candidato.

A leitura física configurada é **400 kHz**, divisor 125 a 100 MHz. Não é um candidato de 30 FPS físicos: mínimo ideal 1,569 s/quadro, loop >=141,21 s, antes de esperas. A VGA mantém a varredura a ~59,52 Hz. O perfil 25 MHz foi apenas simulado e não está habilitado no BIT.

Implementação mapeada: **WNS +0,335 ns, WHS +0,016 ns**, oito grupos de skew aprovados, zero erros DRC. Permanecem três CDC-10 de reset qualificados estruturalmente, um CDC-8 MIG e REQP-1709 gerado, sem waivers. A margem de hold é estreita. Não se inventaram IO delays; a temporização externa e o PHY continuam pendentes de validação. O critério experimental permite emitir o BIT para esse teste controlado, sem confundir isso com aceite físico.

## Reproduzir

O RTL/XDC/MIG de produção é idêntico à referência `74b3541`. O commit da tag acrescenta emissão, teste SPI e documentação. Ubuntu 24.04, Vivado/XSim 2026.1 em `/home/santojuca/AMD/2026.1/Vivado/bin`, Python 3.12 e Icarus 12 já utilizados.

```bash
git clone --branch release/hud-f16-ddr2-video-rc --single-branch \
 https://github.com/santosJuca/Trabalho-display-aviao-v2.git hud-ddr2-rc
cd hud-ddr2-rc
git submodule update --init --recursive
mkdir -p validation/spi-400khz
iverilog -g2012 -s tb_sd_read_400khz -o validation/spi-400khz/test.vvp \
 tests/tb_sd_read_400khz.sv tests/sd_video_card_model.sv hud/rtl/sd_spi_read_block.sv
vvp validation/spi-400khz/test.vvp +VIDEO_HEX=tests/sd_header_90.hex
```

Os demais executores estão em `scripts/test_video_ddr2.sh --reset-only`, `scripts/test_sd_ddr2_vga.sh` e `scripts/test_top_ddr2_video.sh`; cada um recusa sobrescrever saídas. As regressões longas já concluídas não precisam ser repetidas apenas para baixar/programar o BIT. Para testar o LBA alto: `OUT="$PWD/validation/lba-real" BASE_LBA=30028160 SCENARIOS=0 bash scripts/test_sd_ddr2_vga.sh`.

Para reconstruir o perfil mapeado, executar o vetor `command` de `evidencias/perfil-cartao-fechamento.json` numa cópia sem `resultado/projeto`. `scripts/build_rc_offline.sh` conserva o perfil sintético histórico; não usá-lo como configuração física. O build completo gera DCP/relatórios, sem JTAG.

Para repetir apenas a emissão do checkpoint preservado, baixar o asset DCP e conferir SHA256SUMS, então:

```bash
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -nojournal \
 -log emissao-nova.log -source scripts/emit_experimental_bit.tcl -tclargs \
 /CAMINHO/hud-f16-ddr2-74b3541-routed.dcp /CAMINHO/SAIDA_NOVA
```

O script aceita somente o SHA do DCP qualificado, verifica part/pinagem/timing/DRC e não abre hardware. Um build novo terá outro hash de DCP; deve ser requalificado e ter sua proveniência registrada antes de adaptar esse guard. O BIT novo também pode ter outro hash por metadados de data/hora; não alegar reprodução byte a byte sem comparar.

`evidencias/manifesto-release-fontes.json` cobre esta árvore de fontes/documentos/relatórios. O `manifesto-release.json` e `SHA256SUMS` dos assets associam o commit exato aos binários. Os manifestos anteriores descrevem áreas e entregas históricas. O atlas elétrico já publicado na main, commit `14d1bf00d26a621e5d1213a41ff8071a9026a91e`, permanece intacto.
