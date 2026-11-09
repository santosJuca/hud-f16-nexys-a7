#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/validation/p4a"
command -v iverilog >/dev/null || { echo "Icarus Verilog nao encontrado" >&2; exit 1; }
command -v vvp >/dev/null || { echo "vvp nao encontrado" >&2; exit 1; }
mkdir -p "$OUT"
for scenario in success corruption timeout; do
    inject=0; timeout=0
    case "$scenario" in
        corruption) inject=1 ;;
        timeout) timeout=1 ;;
    esac
    iverilog -g2012 -s tb_ddr2_ui_frame_test \
        -P tb_ddr2_ui_frame_test.INJECT_ERROR="$inject" \
        -P tb_ddr2_ui_frame_test.FORCE_TIMEOUT="$timeout" \
        -o "$OUT/${scenario}.vvp" \
        "$ROOT/hud/rtl/ddr2_ui_frame_test.v" \
        "$ROOT/tests/tb_ddr2_ui_frame_test.sv"
    vvp "$OUT/${scenario}.vvp" | tee "$OUT/${scenario}.log"
done
echo "P4A_ALL_SIMULATIONS_PASS"
