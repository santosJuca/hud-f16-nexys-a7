#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
out="${1:?Uso: test_latest_reconciliation.sh diretorio_novo}"
mkdir "$out"
out="$(realpath "$out")"
firmware="$out/firmware"
# A suite publicada gera vetores e logs: execute uma copia, preservando o snapshot.
cp -a "$root/firmware/calibracao-guiada-5d7a3ae2" "$firmware"
bash "$firmware/scripts/reproduzir-testes.sh" > "$out/published-suite.log" 2>&1
tail -2 "$out/published-suite.log"

iverilog -g2012 -s tb_hud_dispatch_latest -o "$out/dispatcher" \
    "$firmware/hud/rtl/hud_command_dispatch.sv" "$root/tests/tb_hud_dispatch_latest.sv" \
    > "$out/dispatcher-compile.log" 2>&1
timeout 30 vvp "$out/dispatcher" > "$out/dispatcher.log" 2>&1
cat "$out/dispatcher.log"

for corrected in 0 1; do
    iverilog -g2012 -I "$root" -y "$firmware/tests/compat" -y "$firmware/hud/rtl" -Y .sv -Y .v \
        -s tb_top_mpu_orientacao -Ptb_top_mpu_orientacao.CORRIGIDO="$corrected" \
        -o "$out/orientation-$corrected" \
        "$firmware/tests/sim_stubs/unisim_stubs.sv" \
        "$firmware/tests/sim_stubs/xpm_fifo_async_stub.sv" \
        "$firmware/tests/ddr2_mig_ui_model.sv" "$root/tests/tb_top_mpu_orientacao.sv" \
        > "$out/orientation-$corrected-compile.log" 2>&1
    timeout 180 vvp "$out/orientation-$corrected" > "$out/orientation-$corrected.log" 2>&1
    tail -2 "$out/orientation-$corrected.log"
done

# O limite anterior de 120 s era inferior ao tempo deste banco no Icarus.
# Mantenha o divisor e os tempos I2C reais; timeout nao conta como PASS.
iverilog -g2012 -s mpu6050_i2c_tb -o "$out/mpu" \
    "$firmware/hud/rtl/mpu6050_i2c.sv" "$firmware/tests/regressao/mpu6050_i2c_tb.sv" \
    > "$out/mpu-compile.log" 2>&1
timeout 600 vvp "$out/mpu" > "$out/mpu.log" 2>&1
tail -4 "$out/mpu.log"

for top in tb_heading_video_live tb_video_pipe_equivalence tb_video_operacao_f16_anchors tb_alignment_routing; do
    iverilog -g2012 -y "$firmware/tests/compat" -Y .sv -Y .v \
        -s "$top" -o "$out/$top" "$root/tests/$top.sv" > "$out/$top-compile.log" 2>&1
    timeout 60 vvp "$out/$top" > "$out/$top.log" 2>&1
    tail -2 "$out/$top.log"
done
for mapping in 0 1; do
    iverilog -g2012 -y "$firmware/tests/compat" -Y .sv -Y .v \
        -s tb_compass_tilt -Ptb_compass_tilt.MAP="$mapping" -o "$out/compass-$mapping" \
        "$root/tests/tb_compass_tilt.sv" > "$out/compass-$mapping-compile.log" 2>&1
    timeout 60 vvp "$out/compass-$mapping" > "$out/compass-$mapping.log" 2>&1
    tail -2 "$out/compass-$mapping.log"
done
echo "PASS reconciliacao recente: suite publicada, comandos, orientacao, MPU, video, instrumentos e bussola"
