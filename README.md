# HUD F-16 com DDR2: fechamento técnico

Esta cópia isolada está em `/home/santojuca/Downloads/hud_ddr2_fechamento_20261109`, branch `sprint/fechamento-tecnico-20261109`, a partir de `3fc45f2`. A referência noturna e seus checkpoints permanecem em `/home/santojuca/Downloads/hud_ddr2_noturna_20261108`. A FPGA e o cartão físico não foram modificados. Nenhuma alteração desta sprint foi publicada.

A mudança funcional substitui as FIFOs CDC próprias por `xpm_fifo_async`, mantém a interface FWFT e coordena o reset por cinco estágios locais. A pré-carga DDR2 remove a espera redundante pela publicação BRAM antes da próxima leitura SD. O caminho BRAM continua disponível. O build incorpora a calibração física preservada dos sensores, com o mapa físico conferido do cartão: LBA absoluto 30028160, 13501 setores, 90 quadros. O RTL de produção continua idêntico à referência.

Leia [RESULTADO_FINAL.md](RESULTADO_FINAL.md) para o resultado atual e [VALIDACAO_OFFLINE.md](VALIDACAO_OFFLINE.md) para evidências e limites. A arquitetura está em [ARQUITETURA_VIDEO_DDR2.md](ARQUITETURA_VIDEO_DDR2.md). Os documentos `README_INTEGRACAO.md` e `README_P4B.md` são históricos da versão anterior.

Para a próxima sessão, siga [PENDENCIAS_FISICAS.md](PENDENCIAS_FISICAS.md) e [PROCEDIMENTO_TESTE_FPGA.md](PROCEDIMENTO_TESTE_FPGA.md). A Flash tem um procedimento separado: [PROCEDIMENTO_FLASH_QSPI.md](PROCEDIMENTO_FLASH_QSPI.md). Nenhum desses documentos autoriza programação.

## Reprodução local

Ubuntu 24.04.5, Vivado/XSim 2026.1 em `/home/santojuca/AMD/2026.1/Vivado/bin`; Python 3.12.3, FFmpeg 6.1.1-3ubuntu5, Pillow 10.2.0 e Icarus 12.0 já disponíveis. As versões e o hash do vídeo de origem estão em evidencias/ferramentas-video.json. O submódulo Digilent foi copiado da referência local, sem atualização de IP. Os comandos abaixo criam saídas novas ou recusam sobrescrever resultados existentes.

```bash
cd /home/santojuca/Downloads/hud_ddr2_fechamento_20261109
OUT="$PWD/validation/repeticao-reset" bash scripts/test_video_ddr2.sh --reset-only
OUT="$PWD/validation/repeticao-lba" BASE_LBA=30028160 SCENARIOS=0 bash scripts/test_sd_ddr2_vga.sh
OUT="$PWD/validation/repeticao-xpm" bash scripts/test_video_ddr2.sh
OUT="$PWD/validation/repeticao-pipeline" bash scripts/test_sd_ddr2_vga.sh
OUT="$PWD/validation/repeticao-top" bash scripts/test_top_ddr2_video.sh
python3 -m unittest discover -s tests -p test_map_sd_video.py
python3 tools/compare_video_profiles.py /home/santojuca/Downloads/videos-hud/E4DvcvNDQoQ.mp4 validation/repeticao-qualidade
```

`bash scripts/build_rc_offline.sh` conserva o perfil sintético histórico. Para reproduzir o novo perfil mapeado em outra área isolada com os quatro arquivos de placa preservados, executar o vetor `command` de `evidencias/perfil-cartao-fechamento.json`, por exemplo:

```bash
python3 - <<'PYBUILD'
import json, subprocess
from pathlib import Path
p = json.loads(Path("evidencias/perfil-cartao-fechamento.json").read_text())
raise SystemExit(subprocess.call(p["command"]))
PYBUILD
```

Esse comando faz síntese, implementação e relatórios; recusa repetir sobre `resultado/projeto`. Para repetir o build, use outro worktree com o submódulo local preservado. Ele não gera `.bit` nem abre o hardware. O novo perfil usa LBA=30028160, 13501 setores, 320×240/30 nominal e leitura de 400 kHz. O limite ideal é inferior a 0,638 FPS, antes de esperas: destina-se a qualificar integridade com atualização lenta. O perfil sintético antigo permanece apenas para reprodução histórica. Não há liberação física ou `.bit` novo.

A conversão completa existente permanece em `/home/santojuca/Downloads/hud_ddr2_video_integracao/validation/video-completo-320-30/`. Seu vídeo não foi substituído. As capturas dos quatro modos estão em evidencias/previas/hud-comparativo.png.

O manifesto desta entrega é `evidencias/manifesto-fechamento.json`. O manifesto noturno preservado é histórico e seus caminhos apontam para a área anterior; não deve ser usado como descrição dos documentos atualizados. Os arquivos artefatos-sha256.json, fontes-candidato-sha256.json e os relatórios da tag inicial são referências históricas; não descrevem o novo HEAD.

A identificação aleatória do cabeçalho muda a cada conversão; a comparação reproduzível deve distinguir pixels, metadados e hash do arquivo completo.

O atlas elétrico já publicado anteriormente está no commit `14d1bf00d26a621e5d1213a41ff8071a9026a91e` da main original, em `docs/atlas-eletrico/`. Essa publicação precede a sprint e não foi repetida.
