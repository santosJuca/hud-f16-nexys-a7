#!/usr/bin/env bash
# top_reticula completo (HUD real, 12 modos, icone SD, BTNL) com video 640x480 2 bpp no Icarus.
# ATENCAO: BUFG/MMCME2_BASE/XADC/xpm_fifo_async sao STUBS de simulacao (tests/sim_stubs) e o
# MIG e o modelo de UI do repositorio. Equivalente oficial: xsim com unisims/XPM.
# Uso: TOP_CASE=ddr2|bram bash scripts/test_top_video_2bpp_icarus.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASE="${TOP_CASE:-ddr2}"
case "$CASE" in ddr2) USE=1 ;; bram) USE=0 ;; *) echo "TOP_CASE ddr2|bram" >&2; exit 2 ;; esac
OUT="${OUT:-$ROOT/validation/top-video-2bpp-$CASE}"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
mkdir -p "$OUT/tests"
cp "$ROOT/tests/hud_aircraft_64.hex" "$OUT/tests/"
python3 - "$ROOT" "$OUT" <<'PY'
from pathlib import Path
import sys
root, out = map(Path, sys.argv[1:]); sys.path.insert(0, str(root/'tools'))
from convert_video_for_fpga import HEADER, MAGIC, parse_header
import numpy as np
import convert_video_nv2bpp as nv
y, x = np.mgrid[0:480, 0:640]
frames = []
for f in range(2):  # "terreno" sintetico: horizonte inclinado + relevo, valores 0..3
    horizon = 240 + (x - 320)*(0.15 if f == 0 else -0.15) + 20*np.sin(x/37.0 + f)
    idx = np.where(y < horizon, 1, 2).astype(np.uint8)
    idx[(y > horizon) & (((x//16) + (y//16) + f) % 5 == 0)] = 3
    idx[:40] = 0
    frames.append(nv.pack_indices(idx))
hd = bytearray(HEADER.pack(MAGIC, 1, 512, 640, 480, 30, 2, 2, 76800, 76800, 512+2*76800, 1, b'top-2bpp-fixture')+bytes(448))
hd[56:60] = bytes(nv.DEFAULT_PALETTE); parse_header(bytes(hd))
data = bytes(hd)+b''.join(frames)
(out/'video.hex').write_text('\n'.join(f'{v:02x}' for v in data)+'\n')
PY
cd "$OUT"
iverilog -g2012 -s tb_top_video_2bpp -P tb_top_video_2bpp.USE_DDR2=$USE -P tb_top_video_2bpp.MODES="${MODES:-12}" -o top.vvp \
  "$ROOT"/hud/rtl/*.sv "$ROOT"/hud/rtl/*.v "$ROOT/tests/ddr2_mig_ui_model.sv" \
  "$ROOT/tests/sd_video_card_model.sv" "$ROOT"/tests/sim_stubs/*.sv "$ROOT/tests/tb_top_video_2bpp.sv" \
  > compile.txt 2>&1
vvp -n top.vvp +VIDEO_HEX="$OUT/video.hex" +CAPTURE="$OUT" > result.txt 2>&1 || true
rm -f top.vvp
if grep -qE 'FATAL|Fatal|fatal|ERROR' result.txt || ! grep -q '^PASS top video 2bpp' result.txt; then
  echo "FALHOU top $CASE"; tail -5 result.txt; exit 1
fi
grep -E '^PASS|TOP_MODE_PASS' result.txt
