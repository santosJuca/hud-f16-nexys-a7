#!/usr/bin/env bash
# Regressao digital do perfil experimental 640x480 2 bpp com Icarus Verilog (sem Vivado).
# Usa sd_spi_controller real, modelo SDHC, loader, espelho DDR2 com UI MIG modelada,
# sd_sector_buffer e sd_video_background. ATENCAO: o xpm_fifo_async aqui e um STUB
# comportamental (tests/sim_stubs); a mesma bancada com XPM oficial roda em
# scripts/test_sd_ddr2_vga.sh (BPP=2 WIDTH=640 HEIGHT=480). Nao qualifica placa.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/video-2bpp-icarus}"
JOBS="${JOBS:-2}"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
mkdir -p "$OUT"
command -v iverilog >/dev/null || { echo "iverilog ausente" >&2; exit 1; }
python3 - "$ROOT" "$OUT" <<'PY'
from pathlib import Path
import sys
root, out = map(Path, sys.argv[1:]); sys.path.insert(0, str(root/'tools'))
from convert_video_for_fpga import HEADER, MAGIC, parse_header
size, frames = 76800, 3
def pattern(f):  # cobre os 256 valores de byte em cada quadro, quadros distintos
    return bytes(((i*37) ^ (i >> 4) ^ (f*17)) & 255 for i in range(size))
def write(name, fmt, w, h, palette=None, check=True):
    hd = bytearray(HEADER.pack(MAGIC, 1, 512, w, h, 30, fmt, frames, size, size, 512+frames*size, 1,
                               b'nv2bpp-fixture01')+bytes(448))
    if palette: hd[56:60] = bytes(palette)
    if check: parse_header(bytes(hd))
    data = bytes(hd)+b''.join(pattern(f) for f in range(frames))
    (out/name).write_text('\n'.join(f'{x:02x}' for x in data)+'\n')
write('video-2bpp.hex', 2, 640, 480, [0x00, 0x04, 0x0C, 0x10])
write('video-rgb332.hex', 1, 320, 240)
write('video-fmt1-640.hex', 1, 640, 480, check=False)  # deve ser recusado pelo RTL
PY
SRC=("$ROOT"/hud/rtl/sd_spi_*.sv "$ROOT/hud/rtl/sd_video_loader.sv" "$ROOT/hud/rtl/sd_video_background.sv"
     "$ROOT/hud/rtl/vga_controller.sv" "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv"
     "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" "$ROOT/hud/rtl/sd_sector_buffer.sv"
     "$ROOT/tests/sd_video_card_model.sv" "$ROOT/tests/sim_stubs/xpm_fifo_async_stub.sv"
     "$ROOT/tests/tb_sd_ddr2_vga.sv")
# nome | arquivo | parametros
CASES="${CASES:-
2bpp-ddr2-s0|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=0 READ_HALF=2
2bpp-ddr2-s1-crc|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=1 READ_HALF=2
2bpp-ddr2-s2-timeout|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=2 READ_HALF=2
2bpp-ddr2-s3-header|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=3 READ_HALF=2
2bpp-ddr2-s4-retries|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=4 READ_HALF=2
2bpp-ddr2-s5-toggle|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=5 READ_HALF=2
2bpp-ddr2-s6-lento|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=6 READ_HALF=4
2bpp-ddr2-s7-paleta|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=7 READ_HALF=2
2bpp-ddr2-s8-fmt|video-fmt1-640.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=8 READ_HALF=2
2bpp-bram-s0|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 USE_DDR2=0 SCENARIO=0 READ_HALF=2
2bpp-bram-s1-crc|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 USE_DDR2=0 SCENARIO=1 READ_HALF=2
2bpp-bram-s2-timeout|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 USE_DDR2=0 SCENARIO=2 READ_HALF=2
rgb332-ddr2-s0|video-rgb332.hex|SCENARIO=0 READ_HALF=2
rgb332-ddr2-s1-crc|video-rgb332.hex|SCENARIO=1 READ_HALF=2
rgb332-ddr2-s3-header|video-rgb332.hex|SCENARIO=3 READ_HALF=2
rgb332-bram-s0|video-rgb332.hex|USE_DDR2=0 SCENARIO=0 READ_HALF=2
2bpp-ddr2-cadencia-h4|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=9 READ_HALF=4
2bpp-ddr2-cadencia-h5|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=9 READ_HALF=5
2bpp-ddr2-cadencia-h10|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=9 READ_HALF=10
2bpp-bram-cadencia-h2|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 USE_DDR2=0 SCENARIO=9 READ_HALF=2
2bpp-ddr2-nac55us-h2|video-2bpp.hex|BPP=2 WIDTH=640 HEIGHT=480 SCENARIO=9 READ_HALF=2 NAC_BYTES=172
}"
run_case() {
  local line="$1" name hex params args=()
  IFS='|' read -r name hex params <<< "$line"
  [[ -z "$name" ]] && return 0
  for p in $params; do args+=(-P "tb_sd_ddr2_vga.$p"); done
  iverilog -g2012 -s tb_sd_ddr2_vga "${args[@]}" -o "$OUT/$name.vvp" "${SRC[@]}" > "$OUT/$name-compile.txt" 2>&1
  local dump=()
  [[ "$name" == 2bpp-ddr2-s0 || "$name" == 2bpp-bram-s0 ]] && dump=(+RGB_DUMP="$OUT/$name-rgb.txt")
  local t0=$SECONDS
  vvp -n "$OUT/$name.vvp" +VIDEO_HEX="$OUT/$hex" "${dump[@]}" > "$OUT/$name.txt" 2>&1 || true
  rm -f "$OUT/$name.vvp"
  if grep -qE 'FATAL|Fatal|fatal|ERROR' "$OUT/$name.txt" || ! grep -qE '^PASS ' "$OUT/$name.txt"; then
    echo "FALHOU $name ($((SECONDS-t0)) s)"; tail -4 "$OUT/$name.txt"; return 1
  fi
  echo "OK $name ($((SECONDS-t0)) s): $(grep -E '^PASS |^DDR2_TRAFFIC|^DISPLAY_CADENCE' "$OUT/$name.txt" | tr '\n' ' ')"
}
export -f run_case; export OUT; export SRC_LIST="${SRC[*]}"
status=0
printf '%s\n' "$CASES" | grep -v '^$' | while IFS= read -r line; do printf '%s\0' "$line"; done |
  xargs -0 -P "$JOBS" -I{} bash -c 'SRC=($SRC_LIST); '"$(declare -f run_case)"'; run_case "$1"' _ {} \
  | tee "$OUT/resumo.txt" || status=1
if grep -q '^FALHOU' "$OUT/resumo.txt"; then status=1; fi
[[ $status == 0 ]] && echo "PASS test_video_2bpp_icarus: logs em $OUT" || echo "FALHA test_video_2bpp_icarus"
exit $status
