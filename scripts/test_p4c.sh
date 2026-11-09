#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/validation/p4c"
export OUT
bash "$ROOT/scripts/test_p4b.sh"
for n in 1 2 3; do
  iverilog -g2012 -s tb_ddr2_sd_frame_mirror \
    -P tb_ddr2_sd_frame_mirror.RESET_CASE="$n" \
    -o "$OUT/reset-$n.vvp" "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv" \
    "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" "$ROOT/tests/tb_ddr2_sd_frame_mirror.sv"
  vvp "$OUT/reset-$n.vvp" | tee "$OUT/reset-$n.log"
done
python3 "$ROOT/tests/test_p4b_contract.py"
echo P4C_ALL_SIMULATIONS_PASS
