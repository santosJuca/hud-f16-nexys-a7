#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
task_out="${1:?Uso: test_attitude_capture.sh diretorio_novo}"
mkdir "$task_out"
task_out="$(realpath "$task_out")"
bash scripts/test_video.sh "$task_out/video" > "$task_out/video.log" 2>&1
for top in tb_horizonte_completo tb_atitude_vetorial tb_atitude_bias tb_top_atitude_bias tb_captura_controle tb_sd_video_capture tb_top_capture tb_top_sd_video; do
    args=()
    if [[ "$top" == tb_sd_video_capture ]]; then
        args=(-GWIDTH=160 -GHEIGHT=120 -GFRAMES=2 -GTEST_CLK_HZ=1000000)
    fi
    verilator --binary --timing -j 2 -Wno-fatal --top-module "$top" "${args[@]}" \
        --Mdir "$task_out/$top" tests/xadc_stub.sv rtl/*.sv \
        tests/sd_video_card_model.sv "tests/$top.sv" > "$task_out/$top-build.log" 2>&1
    "$task_out/$top/V$top" +VIDEO_HEX="$task_out/video/synthetic160/two-frame.hex" > "$task_out/$top.log" 2>&1
    tail -2 "$task_out/$top.log"
done
