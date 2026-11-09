#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/p4b}"
command -v iverilog >/dev/null || { echo 'Icarus Verilog ausente' >&2; exit 1; }
command -v vvp >/dev/null || { echo 'vvp ausente' >&2; exit 1; }
test ! -e "$OUT" || { echo "P4B ja foi testado em $OUT. Preserve os resultados." >&2; exit 1; }
mkdir -p "$OUT"
for case in short_good full_good corruption incomplete aborted stalled; do
    case "$case" in
        short_good) bytes=256; corrupt=0; incomplete=0; aborted=0; stalled=0 ;;
        full_good) bytes=76800; corrupt=0; incomplete=0; aborted=0; stalled=0 ;;
        corruption) bytes=256; corrupt=1; incomplete=0; aborted=0; stalled=0 ;;
        incomplete) bytes=256; corrupt=0; incomplete=1; aborted=0; stalled=0 ;;
        aborted) bytes=256; corrupt=0; incomplete=0; aborted=1; stalled=0 ;;
        stalled) bytes=256; corrupt=0; incomplete=0; aborted=0; stalled=1 ;;
    esac
    echo "===== P4B $case ====="
    iverilog -g2012 -s tb_ddr2_sd_frame_mirror \
        -P tb_ddr2_sd_frame_mirror.TB_BYTES="$bytes" \
        -P tb_ddr2_sd_frame_mirror.CORRUPT="$corrupt" \
        -P tb_ddr2_sd_frame_mirror.SHORT_COMMIT="$incomplete" \
        -P tb_ddr2_sd_frame_mirror.ABORT_FRAME="$aborted" \
        -P tb_ddr2_sd_frame_mirror.STALL="$stalled" \
        -o "$OUT/$case.vvp" \
        "$ROOT/hud/rtl/ddr2_p4b_async_fifo.sv" \
        "$ROOT/hud/rtl/ddr2_sd_frame_mirror.sv" \
        "$ROOT/tests/tb_ddr2_sd_frame_mirror.sv" \
        > "$OUT/$case.compile.log" 2>&1 || {
            cat "$OUT/$case.compile.log"; exit 1;
        }
    vvp "$OUT/$case.vvp" | tee "$OUT/$case.log"
done
echo P4B_ALL_SIMULATIONS_PASS
