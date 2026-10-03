#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p build/tests

tests=(
    "reticula|tb_reticula|tests/tb_reticula.sv"
    "controle_heading|tb_controle_heading|tests/tb_controle_heading.sv"
    "controle_joystick|tb_controle_joystick|tests/tb_controle_joystick.sv"
    "horizonte|tb_horizonte|tests/tb_horizonte.sv"
    "atitude|tb_atitude|tests/tb_atitude.sv"
    "atitude_accel_fixa|tb_atitude_accel_fixa|tests/tb_atitude_accel_fixa.sv"
    "gyro_bias_dt|tb_gyro_bias_dt|tests/tb_gyro_bias_dt.sv"
    "entrada_hud|tb_entrada_hud|tests/tb_entrada_hud.sv"
    "dados_hud|tb_dados_hud|tests/tb_dados_hud.sv"
    "numeros|tb_numeros|tests/tb_numeros.sv"
    "roll|tb_roll|tests/tb_roll.sv"
    "modo|tb_modo|tests/tb_modo.sv"
    "modos|tb_modos|tests/tb_modos.sv"
    "top_atitude|tb_top_atitude|tests/tb_top_atitude.sv"
    "vga|tb_vga|tests/tb_vga.sv"
    "mpu6050_i2c|mpu6050_i2c_tb|tests/mpu6050_i2c_tb.sv"
)

for spec in "${tests[@]}"; do
    IFS='|' read -r nome top fonte <<< "$spec"

    echo
    echo "===== TESTE: $nome ====="

    iverilog -g2012 \
        -s "$top" \
        -o "build/tests/$nome" \
        tests/xadc_stub.sv \
        rtl/*.sv \
        "$fonte"

    vvp "build/tests/$nome"
done

echo
echo "===== TODOS OS TESTES PASSARAM ====="
