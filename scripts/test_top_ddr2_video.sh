#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/top-ddr2}"
VB="${VIVADO_BIN:-$HOME/AMD/2026.1/Vivado/bin}"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
mkdir -p "$OUT/tests"
cp "$ROOT/tests/hud_aircraft_64.hex" "$OUT/tests/"
cp "$ROOT/tests/xadc_analog.txt" "$OUT/design.txt"
python3 - "$ROOT" "$OUT" <<'PY'
from pathlib import Path
import sys,subprocess
root,out=map(Path,sys.argv[1:]);sys.path.insert(0,str(root/'tools'))
from convert_video_for_fpga import HEADER,MAGIC,parse_header
raw=subprocess.run(['ffmpeg','-v','error','-ss','210','-i','/home/santojuca/Downloads/videos-hud/E4DvcvNDQoQ.mp4','-frames:v','2','-vf','fps=10,scale=160:90:flags=area,pad=160:120:0:15','-pix_fmt','rgb8','-f','rawvideo','pipe:1'],check=True,stdout=subprocess.PIPE).stdout
assert len(raw)==38400
header=HEADER.pack(MAGIC,1,512,160,120,10,1,2,19200,19456,39424,1,b'noturna-top-0001')+bytes(448)
parse_header(header)
data=header+raw[:19200]+bytes(256)+raw[19200:]+bytes(256)
(out/'video.hex').write_text('\n'.join(f'{v:02x}' for v in data)+'\n')
PY
cd "$OUT"
"$VB/xvlog" --relax --sv "$ROOT"/hud/rtl/*.sv "$ROOT"/hud/rtl/*.v \
 "$ROOT/tests/ddr2_mig_ui_model.sv" "$ROOT/tests/sd_video_card_model.sv" \
 "$ROOT/tests/tb_top_ddr2_video.sv" > compile.txt 2>&1
"$VB/xvlog" "$VB/../../data/verilog/src/glbl.v" > glbl.txt 2>&1
"$VB/xelab" -mt 4 -L xpm -L unisims_ver work.tb_top_ddr2_video work.glbl \
 -generic_top QUICK_STATUS="${QUICK_STATUS:-0}" -s top_ddr2 > elaborate.txt 2>&1
"$VB/xsim" top_ddr2 -runall -testplusarg "VIDEO_HEX=$OUT/video.hex" -testplusarg "CAPTURE=$OUT" > result.txt 2>&1
if rg '(FATAL|Fatal:|Error:|ERROR:)' result.txt; then exit 1; fi
rg 'PASS top DDR2' result.txt
