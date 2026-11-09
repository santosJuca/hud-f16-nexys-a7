# HUD F-16 DDR2 — correção de LD14/LD15

**EXPERIMENTAL — NÃO VALIDADO FISICAMENTE.** Esta candidata corrige o diagnóstico do primeiro teste físico. Não altera sensores, atitude, orientação magnética, modos, vídeo, SPI ou pinagem.

[Baixar nova pre-release](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-status-rc-20261109) · [Teste JTAG e recuperação](PROCEDIMENTO_TESTE_FPGA.md) · [Resultado](RESULTADO_FINAL.md) · [Validação](VALIDACAO_OFFLINE.md)

Branch: `fix/hud-ddr2-indicadores-20261109`. Base publicada preservada: `52e223d`. Fonte RTL: `b38e538b330805b265fe1b9a7cf45d7c5501acec`.

BIT: `hud-f16-ddr2-b38e538-status-experimental.bit`  
SHA-256: `7c74a9d635f378c980f6378683126f182df92bcc0c3a16e19c1d11ecdd8df292`  
USERCODE esperado após carga: **B38E538B**. O manifesto dos assets identifica o commit exato da tag.

## Indicadores

| LED | Significado nesta candidata |
|---|---|
| LD12 | Referência de clock travada agora. |
| LD13 | Calibração MIG concluída agora. |
| LD14 | Houve commit íntegro DDR2 e ACK da troca do banco de exibição; persistente. |
| LD15 | Houve falha de vídeo/retorno/buffer; persistente, mesmo após recuperação. |

LD14 anterior apagava no START seguinte e não comprovava publicação VGA. O novo status usa apenas o domínio HUD e o ACK já sincronizado do buffer. Recarregar o BIT limpa o histórico; CPU RESET do MIG não limpa. PASS e erro podem ficar simultaneamente acesos. LD14 não garante fundo visível sob o HUD ou vídeo habilitado.

O usuário confirmou JTAG da RC anterior antes das fotos. Nesta máquina não há USB-JTAG acessível; a origem física dos pixels das fotos continua sem comprovação independente. O novo USERID permite distinguir esta candidata no Hardware Manager, sem tentar recuperar SHA da SRAM. Nenhuma programação foi feita pelo agente.

## Perfil e validação

Cartão preservado: 90 quadros 320×240 RGB332/30 nominal, LBA absoluto 30028160, 13501 setores contíguos. Leitura SPI=400 kHz: atualização lenta, mínimo ideal 1,569 s/quadro e loop >=141,21 s, sem promessa de 30 FPS físicos. Há liberação de vídeo por sensores ou timeout de até 10 s. O vídeo completo de 17331 quadros permanece no PC.

A implementação corrigida passou com WNS +0,468 ns / WHS +0,017 ns, oito grupos de skew e zero erros DRC. Mesmos CDC-10/CDC-8/CDC-15 e REQP-1709 qualificados, sem alertas novos ou waivers. Passaram status/reset, 17 cenários XPM com status, top com CRC ruim e publicação, recuperação BRAM sem tráfego MIG e ajuste vertical preservando fundo. São modelos digitais, não teste físico desta correção.

A Release fornece BIT, DCP, recuperação anterior, relatórios e hashes como assets. Nenhum binário/checkpoint entra no histórico Git. Não há MCS enquanto o modelo exato da Flash não estiver confirmado. A main e a pre-release anterior não foram substituídas.

## Reproduzir os testes

Ubuntu 24.04, Vivado/XSim 2026.1, Icarus 12 e Python 3.12. Clonar esta branch e inicializar o submódulo Digilent no gitlink preservado. Saídas dos executores devem ser novas:

```bash
mkdir -p validation/status-unit
iverilog -g2012 -s tb_ddr2_video_status -o validation/status-unit/test.vvp \
 tests/tb_ddr2_video_status.sv hud/rtl/ddr2_video_status.sv
vvp validation/status-unit/test.vvp
OUT="$PWD/validation/status-xpm" bash scripts/test_video_ddr2.sh
OUT="$PWD/validation/top-status" QUICK_STATUS=1 bash scripts/test_top_ddr2_video.sh
OUT="$PWD/validation/top-bram" TOP_CASE=bram bash scripts/test_top_ddr2_video.sh
```

O top usa modelo UI MIG, sensores NACK, amostra 160×120 e SPI de modelo 25 MHz. Apenas no teste, debounce, timer e espera de retry são acelerados. O teste BRAM bloqueia app_rdy/app_wdf_rdy do modelo e compara pixels sem leituras/escritas DDR2. Os parâmetros físicos não são alterados por esses ensaios.

Para reconstruir, executar o vetor `command` de `evidencias/perfil-cartao-fechamento.json` em cópia sem `resultado/projeto`. O script de emissão `scripts/emit_experimental_bit.tcl` aceita o DCP do hash publicado, confere part/pinagem/timing/DRC e gera o BIT local com USERID B38E538B. Exemplo:

```bash
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -nojournal \
 -log emissao-nova.log -source scripts/emit_experimental_bit.tcl -tclargs \
 /CAMINHO/hud-f16-ddr2-b38e538-status-routed.dcp /CAMINHO/SAIDA_NOVA
```

Um build novo terá outro hash de DCP e precisa de nova qualificação/proveniência antes de adaptar o guard. Data/hora também podem mudar o hash do BIT. O script não abre hardware. A arquitetura e as etapas exatas dos contadores estão em ARQUITETURA_VIDEO_DDR2.md e VALIDACAO_OFFLINE.md. Manifestos anteriores são históricos; esta árvore tem manifesto-release-fontes.json e os assets têm manifesto-release.json/SHA256SUMS.
