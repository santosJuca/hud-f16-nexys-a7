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
    "gyro_integrador|tb_gyro_integrador|tests/tb_gyro_integrador.sv"
    "atitude_gyro_hud|tb_atitude_gyro_hud|tests/tb_atitude_gyro_hud.sv"
    "atitude_fusao_complementar|tb_atitude_fusao_complementar|tests/tb_atitude_fusao_complementar.sv"
    "entrada_hud|tb_entrada_hud|tests/tb_entrada_hud.sv"
    "dados_hud|tb_dados_hud|tests/tb_dados_hud.sv"
    "numeros|tb_numeros|tests/tb_numeros.sv"
    "roll|tb_roll|tests/tb_roll.sv"
    "modo|tb_modo|tests/tb_modo.sv"
    "modos|tb_modos|tests/tb_modos.sv"
    "estilos|tb_estilos|tests/tb_estilos.sv"
    "top_atitude|tb_top_atitude|tests/tb_top_atitude.sv"
    "vga|tb_vga|tests/tb_vga.sv"
    "bmp085_calibracao|tb_bmp085_calibracao|tests/tb_bmp085_calibracao.sv"
    "bmp085_temperatura|tb_bmp085_temperatura|tests/tb_bmp085_temperatura.sv"
    "bmp085_pressao|tb_bmp085_pressao|tests/tb_bmp085_pressao.sv"
    "bmp085_continuo|tb_bmp085_continuo|tests/tb_bmp085_continuo.sv"
    "bmp085_compensacao_temp|tb_bmp085_compensacao_temp|tests/tb_bmp085_compensacao_temp.sv"
    "bmp085_compensacao_pressao|tb_bmp085_compensacao_pressao|tests/tb_bmp085_compensacao_pressao.sv"
    "bmp085_aritmetica_seq|tb_bmp085_aritmetica_seq|tests/tb_bmp085_aritmetica_seq.sv"
    "bmp085_compensacao_temp_seq|tb_bmp085_compensacao_temp_seq|tests/tb_bmp085_compensacao_temp_seq.sv"
    "bmp085_compensacao_pressao_seq|tb_bmp085_compensacao_pressao_seq|tests/tb_bmp085_compensacao_pressao_seq.sv"
    "bmp085_compensacao_seq|tb_bmp085_compensacao_seq|tests/tb_bmp085_compensacao_seq.sv"
    "top_bmp085_seq|tb_top_bmp085_seq|tests/tb_top_bmp085_seq.sv"
    "bmp085_altitude|tb_bmp085_altitude|tests/tb_bmp085_altitude.sv"
    "bmp085_altitude_monotonia|tb_bmp085_altitude_monotonia|tests/tb_bmp085_altitude_monotonia.sv"
    "bmp085_i2c|tb_bmp085_i2c|tests/tb_bmp085_i2c.sv"
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
