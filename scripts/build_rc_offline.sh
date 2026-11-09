#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Somente STA offline. LBA=1 e sintetico; nenhum bitstream e escrito aqui.
sensor_args="$(python3 - "$ROOT/evidencias/perfil-fisico-preservado.json" <<'PY'
import json,sys
profile=json.load(open(sys.argv[1]))['generics']
names=('MPU_GIRO_ESQUERDA_90','FRENTE_INVERTIDA_180','MAG_TROCAR_XY','MAG_INVERTER_X','MAG_INVERTER_Y','MAG_OFFSET_X','MAG_OFFSET_Y','MAG_GAIN_X_Q12','MAG_GAIN_Y_Q12','MAG_ALINHAMENTO_GRAUS')
for name in names:
    value=profile[name]
    if not isinstance(value,int):raise ValueError('Perfil fisico nao numerico')
    print(f'{name}={value}')
PY
)"
mapfile -t sensors <<< "$sensor_args"
test "${#sensors[@]}" -eq 10
bash "$ROOT/scripts/run.sh" ENABLE_SD_SUBSYSTEM=1 ENABLE_SD_VIDEO=1 \
 ENABLE_DDR2_SD_MIRROR=1 ENABLE_DDR2_VIDEO=1 ENABLE_DDR2_FRAME_TEST=0 \
 SD_VIDEO_WIDTH=320 SD_VIDEO_HEIGHT=240 SD_VIDEO_FPS=30 \
 SD_VIDEO_LBA=1 SD_VIDEO_SECTORS=2599651 "${sensors[@]}"
