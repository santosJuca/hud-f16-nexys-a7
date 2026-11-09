#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/video-ddr2-xpm}"
VIVADO_BIN="${VIVADO_BIN:-$HOME/AMD/2026.1/Vivado/bin}"
test ! -e "$OUT" || { echo "Resultados existentes preservados: $OUT" >&2; exit 1; }
mkdir -p "$OUT"
cd "$OUT"
"$VIVADO_BIN/xvlog" --sv "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv" \
 "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" "$ROOT/hud/rtl/sd_sector_buffer.sv" \
 "$ROOT/tests/tb_ddr2_sd_frame_mirror.sv" > compile.txt 2>&1
"$VIVADO_BIN/xvlog" "$VIVADO_BIN/../../data/verilog/src/glbl.v" > glbl.txt 2>&1
run_case() {
 local name="$1"
 shift
 local params=(-generic_top STREAM=1)
 for value in "$@"; do params+=(-generic_top "$value"); done
 "$VIVADO_BIN/xelab" -mt 4 -L xpm work.tb_ddr2_sd_frame_mirror work.glbl \
   "${params[@]}" -s "$name" > "$name-elaborate.txt" 2>&1
 "$VIVADO_BIN/xsim" "$name" -runall > "$name.txt" 2>&1
 if rg -n '(^|[[:space:]])(FATAL|Fatal:|Error:|ERROR:)|Assertion.*fail' "$name.txt"; then
   echo "Falha em $name" >&2; exit 1
 fi
 rg 'P4B_FRAME_PASS|P4B_EXPECTED_ERROR_PASS' "$name.txt" >/dev/null
 echo "XPM_CASE_PASS $name"
}
run_case short_good
run_case full_good TB_BYTES=76800
run_case corruption CORRUPT=1
run_case incomplete SHORT_COMMIT=1
run_case aborted ABORT_FRAME=1
run_case stalled STALL=1
for n in 1 2 3; do run_case "reset_$n" RESET_CASE="$n"; done
run_case loop TB_FRAMES=3
run_case output_stall HOLD_OUTPUT=5000
run_case bad_read_end BAD_RD_END=1
run_case read_timeout DROP_READ=1
run_case fifo_overflow STALL=1 TB_BYTES=1024 FIFO_BITS=4 TIMEOUT_CYCLES=2500
run_case preserve TB_FRAMES=2 CORRUPT_ON_SECOND=1
"$VIVADO_BIN/xvlog" --sv "$ROOT/tests/tb_ddr2_fifo_xpm.sv" > fifo-compile.txt 2>&1
"$VIVADO_BIN/xelab" -mt 4 -L xpm work.tb_ddr2_fifo_xpm work.glbl -s fifo_stress > fifo-elaborate.txt 2>&1
"$VIVADO_BIN/xsim" fifo_stress -runall > fifo-stress.txt 2>&1
rg 'XPM_FIFO_RANDOM_WRAP_RESET_PASS' fifo-stress.txt
if rg '(FATAL|Fatal:|Error:|ERROR:)' fifo-stress.txt; then exit 1; fi
python3 "$ROOT/tests/test_p4b_contract.py"
python3 -m unittest discover -s "$ROOT/tests" -p test_convert_video_for_fpga.py
cp "$ROOT/tests/xadc_analog.txt" design.txt
iverilog -g2012 -s tb_xadc_cadence -s glbl -o cadence.vvp \
 "$ROOT/tests/tb_xadc_cadence.sv" "$ROOT/hud/rtl/joystick_xadc.sv" \
 "$ROOT/hud/rtl/xadc_temperature_cdc.v" "$VIVADO_BIN/../../data/verilog/src/unisims/XADC.v" \
 "$VIVADO_BIN/../../data/verilog/src/glbl.v" > xadc-compile.txt 2>&1
vvp cadence.vvp | tee xadc.txt
echo VIDEO_DDR2_XPM_SIMULATIONS_PASS
