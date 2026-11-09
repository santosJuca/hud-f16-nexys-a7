#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Endereco sintetico para STA; nao corresponde a cartao nem autoriza bitstream.
bash "$ROOT/scripts/run.sh" ENABLE_SD_SUBSYSTEM=1 ENABLE_SD_VIDEO=1 \
 ENABLE_DDR2_SD_MIRROR=1 ENABLE_DDR2_VIDEO=1 ENABLE_DDR2_FRAME_TEST=0 \
 SD_VIDEO_WIDTH=320 SD_VIDEO_HEIGHT=240 SD_VIDEO_FPS=30 \
 SD_VIDEO_LBA=1 SD_VIDEO_SECTORS=13501
