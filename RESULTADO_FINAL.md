# Correção do teste físico DDR2: vídeo e indicadores

## CONFIRMADO

O usuário confirmou carga JTAG de `hud-f16-ddr2-74b3541-experimental.bit` antes das fotos, sem power-cycle. O arquivo local e a release anterior correspondem ao SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. A identificação é por relato do usuário; não houve leitura independente da configuração nesta máquina, sem USB-JTAG enumerada. Nenhum SHA foi inferido da SRAM.

LD12 e LD13 continuam indicando lock da referência e calibração MIG. Na candidata anterior, LD14 era `smoke_done && smoke_pass`, resultado da releitura/CRC32 no domínio UI, limpo no START seguinte. LD15 era `smoke_error`, também limpo na próxima tentativa. Eles não representavam histórico nem comprovavam troca de banco VGA.

## CAUSA RAIZ

**Confirmado no RTL:** o início da próxima pré-carga apaga PASS e erro anteriores. LD14 pode ficar visualmente apagado mesmo após quadros válidos. O ACK de publicação do buffer de vídeo não estava conectado a esse indicador. Isso é um defeito de diagnóstico, não prova de falha no transporte DDR2. A espera de sensores pode chegar a 10 s e a carga a 400 kHz exige >=1,569 s/quadro; falta de espera também não foi excluída na fotografia.

**Origem física da imagem VGA: INDETERMINADA.** O relato identifica a candidata, mas ver HUD/F-16 não comprova pixels de fundo vindos da DDR2. No perfil real ENABLE_DDR2_VIDEO=1 não há bypass automático SD→BRAM: os bytes do banco vêm do retorno MIG; o compositor ainda pode mostrar apenas HUD. O teste corrigido torna observável a publicação do banco e acrescenta identificação de versão.

## CORREÇÃO

Novo módulo `hud/rtl/ddr2_video_status.sv` e conexões pontuais em `hud/rtl/top_reticula.sv`:

- LD14 registra commit íntegro de retorno DDR2 **seguido do ACK sincronizado da troca de banco**. Permanece aceso no próximo quadro. ACK sem commit e commit sem ACK não geram PASS.
- LD15 mantém falha de vídeo/buffer ou ABORT após início de transferência. Ignora o ABORT normal da calibração inicial; erro não é apagado por sucesso posterior.
- Eventos pertencem ao clock HUD; usa `wr_published`, não o pulso pixel `rd_updated` diretamente. Não há CDC novo, ILA, porta nova ou interferência em ready/dados/FSM.
- O histórico limpa ao inicializar/recarregar o HUD. CPU RESET do MIG não limpa o diagnóstico. PASS e erro podem coexistir.
- O modo BRAM e os indicadores legados permanecem quando ENABLE_DDR2_VIDEO=0. Sensores, orientação magnética, atitude, vídeo, pinagem, constraints e SPI=400 kHz foram preservados.

O BIT registra USERID **B38E538B**, legível como REGISTER.USERCODE, para identificar o commit RTL. Não é uma recuperação do hash do BIT por JTAG.

## TESTES E IMPLEMENTAÇÃO

Passaram o teste unitário de persistência/ausência de falso PASS/reset, 17 cenários XPM com novas assertions de status (incluindo quadro 76800 bytes, CRC ruim, timeout, FIFO cheia, backpressure, reset e última imagem), FIFO real de 3072 palavras, contrato/CRC, cinco testes do conversor e cadência XADC. O ajuste vertical passou novamente, incluindo clipping e preservação do fundo.

O top completo passou com 307200 comparações RGB, duas publicações, um erro CRC16 injetado e LEDs=1111: LD14 permaneceu ligado com smoke_done já zero, e LD15 permaneceu após uma publicação íntegra. A repetição acelerada passou com três cargas SD e duas publicações. A recuperação BRAM passou com 307200 pixels, duas publicações e **zero leituras/escritas MIG**, com o MIG bloqueado apenas no modelo. Sensores NACK e modelo UI sem PHY; isso não é ensaio físico novo. Os 12 modos anteriores não foram repetidos integralmente porque sua lógica não mudou.

Vivado 2026.1 executou nova síntese/implementação: **WNS +0,468 ns / WHS +0,017 ns**, TNS/THS zero, oito grupos de skew aprovados (mínimo +6,449 ns), zero erros DRC, zero clocks ausentes e zero endpoints internos não temporizados. CDC permaneceu 46 CDC-3, 3 CDC-10, 1 CDC-8 e 176 CDC-15, sem novos alertas ou waivers. REQP-1709 e ressalvas MIG/SPI permanecem qualificadas para ensaio experimental. A margem de hold continua estreita. As 132 atribuições IO conferiram com a RC anterior. Utilização: 20616 LUTs, 15399 FF, 64 BRAM tiles, 62 DSP.

O `write_bitstream` concluiu sem erros. Cabeçalho, part, USERID, payload, tamanho e hash conferidos. Não foi gerada MCS: modelo exato da Flash continua pendente.

## NOVO CANDIDATO

Branch `fix/hud-ddr2-indicadores-20261109`, derivada da publicada `52e223d22a190b61c868cfa2966d83ff715fd965`. Commit RTL: `b38e538b330805b265fe1b9a7cf45d7c5501acec`. O commit da tag publicada é vinculado no manifesto dos assets.

| Arquivo | SHA-256 |
|---|---|
| `hud-f16-ddr2-b38e538-status-experimental.bit` (3825990 bytes) | `7c74a9d635f378c980f6378683126f182df92bcc0c3a16e19c1d11ecdd8df292` |
| DCP roteado correspondente | `57f162876e9e0f26cac82d4ce7f6770ad5fdc6561740e7d5b009bc129590ba10` |
| BIT funcional anterior de recuperação | `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f` |

Área: `/home/santojuca/Downloads/hud_ddr2_indicadores_20261109`; BIT em `resultado-release-status/`, DCP em `resultado/routed.dcp`. Relatórios: `evidencias/relatorios-status/` e `relatorios-bit-status/`; logs de testes em `evidencias/status-*.txt` e `top-*.txt`. `fontes-status-build.json` registra a fonte sintetizada; `manifesto-release-fontes.json` cobre a árvore publicada, e manifesto-release.json/SHA256SUMS dos assets vinculam o commit exato aos binários.

[Branch](https://github.com/santosJuca/Trabalho-display-aviao-v2/tree/fix/hud-ddr2-indicadores-20261109) · [Nova pre-release](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-status-rc-20261109). A release `hud-f16-ddr2-rc-20261109`, o BIT anterior e a main permanecem preservados. A conclusão da publicação depende da conferência de retorno do GitHub.

## TESTE FÍSICO

Baixar todos os assets, executar `sha256sum -c SHA256SUMS` e seguir PROCEDIMENTO_TESTE_FPGA.md. O usuário deve carregar apenas SRAM por JTAG, conferir USERCODE B38E538B, aguardar 20–30 s e registrar LD12–15 com o fundo habilitado e mudando. O loop de 90 quadros ainda exige >=141,21 s no limite ideal; 30 FPS físicos não foram demonstrados. Testar modos, ajuste, referência angular e recuperação. Recarregar o candidato limpa o histórico; power-cycle volta à Flash anterior.

**FPGA não alterada pelo agente. Flash não gravada. microSD não modificado. Candidato experimental sem validação física nova.**
