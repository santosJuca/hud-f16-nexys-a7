#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$root/tests/run.py"
python3 "$root/tests/regressao.py"
iverilog -g2012 -I "$root" -y "$root/tests/compat" -y "$root/hud/rtl" -Y .sv -Y .v \
  -s tb_mag_top -o "$root/tests/tb_mag_top" \
  "$root/tests/sim_stubs/unisim_stubs.sv" "$root/tests/sim_stubs/xpm_fifo_async_stub.sv" \
  "$root/tests/ddr2_mig_ui_model.sv" "$root/tests/tb_mag_top.sv" > "$root/evidencias/compile-top.log" 2>&1
vvp "$root/tests/tb_mag_top" +DIR="$root/tests/vetores" > "$root/evidencias/top.log" 2>&1
cat "$root/evidencias/top.log"
