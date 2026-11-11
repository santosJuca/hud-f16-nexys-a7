#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/sd-ddr2-vga}"
VB="${VIVADO_BIN:-$HOME/AMD/2026.1/Vivado/bin}"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
mkdir -p "$OUT"
python3 - "$ROOT" "$OUT" <<'PY'
from pathlib import Path
import sys
root,out=map(Path,sys.argv[1:]);sys.path.insert(0,str(root/'tools'))
from convert_video_for_fpga import HEADER,MAGIC,parse_header
import os
size=76800;frames=3
if os.environ.get('BPP','8')=='2':
    # Perfil experimental 640x480 2 bpp: fmt=2 e paleta padrao nos bytes 56..59.
    header=bytearray(HEADER.pack(MAGIC,1,512,640,480,30,2,frames,size,size,512+frames*size,1,b'noturna-fixture01')+bytes(448))
    header[56:60]=bytes([0x00,0x04,0x0C,0x10]);header=bytes(header)
else:
    header=HEADER.pack(MAGIC,1,512,320,240,30,1,frames,size,size,512+frames*size,1,b'noturna-fixture01')+bytes(448)
parse_header(header)
data=header+b''.join(bytes(((i*37)^(i>>4)^(frame*17))&255 for i in range(size)) for frame in range(frames))
(out/'video.hex').write_text('\n'.join(f'{x:02x}' for x in data)+'\n')
PY
cd "$OUT"
"$VB/xvlog" --sv "$ROOT"/hud/rtl/sd_spi_*.sv "$ROOT/hud/rtl/sd_video_loader.sv" \
 "$ROOT/hud/rtl/sd_video_background.sv" "$ROOT/hud/rtl/vga_controller.sv" \
 "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv" "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" \
 "$ROOT/hud/rtl/sd_sector_buffer.sv" "$ROOT/tests/sd_video_card_model.sv" \
 "$ROOT/tests/tb_sd_ddr2_vga.sv" > compile.txt 2>&1
"$VB/xvlog" "$VB/../../data/verilog/src/glbl.v" > glbl.txt 2>&1
for scenario in ${SCENARIOS:-0 1 2 3 4 5 6}; do
 read_half=2
 if [[ "$scenario" == 6 ]]; then read_half=4; fi
 read_half="${READ_HALF:-$read_half}"
 "$VB/xelab" -mt 4 -L xpm work.tb_sd_ddr2_vga work.glbl \
   -generic_top SCENARIO="$scenario" -generic_top READ_HALF="$read_half" \
   -generic_top INIT_HALF="${INIT_HALF:-2}" \
   -generic_top NAC_BYTES="${NAC_BYTES:-0}" -generic_top NAC_JITTER_BYTES="${NAC_JITTER_BYTES:-0}" \
   -generic_top R1_WAIT_BYTES="${R1_WAIT_BYTES:-0}" \
   -generic_top BASE_LBA="${BASE_LBA:-1000}" \
   -generic_top BPP="${BPP:-8}" -generic_top WIDTH="$([[ ${BPP:-8} == 2 ]] && echo 640 || echo 320)" \
   -generic_top HEIGHT="$([[ ${BPP:-8} == 2 ]] && echo 480 || echo 240)" -generic_top USE_DDR2="${USE_DDR2:-1}" \
   -s "pipeline_$scenario" > "$scenario-elaborate.txt" 2>&1
 "$VB/xsim" "pipeline_$scenario" -runall -testplusarg "VIDEO_HEX=$OUT/video.hex" > "$scenario.txt" 2>&1
 if rg '(FATAL|Fatal:|Error:|ERROR:)' "$scenario.txt"; then exit 1; fi
 rg 'PASS sd_ddr2_vga|PASS invalid header|DDR2_TRAFFIC|DISPLAY_CADENCE' "$scenario.txt"
done
