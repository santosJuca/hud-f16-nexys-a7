#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/validation/video-ddr2-repro"
export OUT STREAM=1
bash "$ROOT/scripts/test_p4c.sh"
run_case() {
 local name="$1"
 shift
 iverilog -g2012 -s tb_ddr2_sd_frame_mirror -Ptb_ddr2_sd_frame_mirror.STREAM=1 \
   "$@" -o "$OUT/$name.vvp" "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv" \
   "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" "$ROOT/hud/rtl/sd_sector_buffer.sv" \
   "$ROOT/tests/tb_ddr2_sd_frame_mirror.sv"
 vvp "$OUT/$name.vvp" | tee "$OUT/$name.txt"
}
run_case loop -Ptb_ddr2_sd_frame_mirror.TB_FRAMES=3
run_case output_stall -Ptb_ddr2_sd_frame_mirror.HOLD_OUTPUT=5000
run_case bad_read_end -Ptb_ddr2_sd_frame_mirror.BAD_RD_END=1
run_case read_timeout -Ptb_ddr2_sd_frame_mirror.DROP_READ=1
run_case fifo_overflow -Ptb_ddr2_sd_frame_mirror.STALL=1 -Ptb_ddr2_sd_frame_mirror.FIFO_BITS=2
run_case preserve -Ptb_ddr2_sd_frame_mirror.TB_FRAMES=2 -Ptb_ddr2_sd_frame_mirror.CORRUPT_ON_SECOND=1
python3 -m unittest discover -s "$ROOT/tests" -p test_convert_video_for_fpga.py
VIVADO_ROOT="${VIVADO_ROOT:-$HOME/AMD/2026.1}"
cp "$ROOT/tests/xadc_analog.txt" "$OUT/design.txt"
iverilog -g2012 -s tb_xadc_cadence -s glbl -o "$OUT/cadence.vvp" \
 "$ROOT/tests/tb_xadc_cadence.sv" "$ROOT/hud/rtl/joystick_xadc.sv" \
 "$ROOT/hud/rtl/xadc_temperature_cdc.v" "$VIVADO_ROOT/data/verilog/src/unisims/XADC.v" \
 "$VIVADO_ROOT/data/verilog/src/glbl.v"
(cd "$OUT" && vvp cadence.vvp | tee xadc.txt)
echo VIDEO_DDR2_SIMULATIONS_PASS
