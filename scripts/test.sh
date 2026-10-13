#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p build/tests

tests=(
    "modo_operacao|tb_modo_operacao|tests/tb_modo_operacao.sv"
    "simulador_voo|tb_simulador_voo|tests/tb_simulador_voo.sv"
    "mira_joystick|tb_mira_joystick|tests/tb_mira_joystick.sv"
    "marcador_joystick|tb_marcador_joystick|tests/tb_marcador_joystick.sv"
    "marcador_integrado|tb_marcador_integrado|tests/tb_marcador_integrado.sv"
    "captura_marcador|tb_captura_marcador|tests/tb_captura_marcador.sv"
    "simulador_pouso|tb_simulador_pouso|tests/tb_simulador_pouso.sv"
    "alertas_voo|tb_alertas_voo|tests/tb_alertas_voo.sv"
    "buzzer_driver|tb_buzzer_driver|tests/tb_buzzer_driver.sv"
    "fontes_operacao|tb_fontes_operacao|tests/tb_fontes_operacao.sv"
    "alertas_vga|tb_alertas_vga|tests/tb_alertas_vga.sv"
    "modos_operacao_integrado|tb_modos_operacao_integrado|tests/tb_modos_operacao_integrado.sv"
    "heading_fusao|tb_heading_fusao|tests/tb_heading_fusao.sv"
    "projecao_vertical|tb_projecao_vertical|tests/tb_projecao_vertical.sv"
    "estado_vertical|tb_estado_vertical|tests/tb_estado_vertical.sv"
    "top_fusao_sensores|tb_top_fusao_sensores|tests/tb_top_fusao_sensores.sv"
    "reticula|tb_reticula|tests/tb_reticula.sv"
    "hmc5883l_i2c|tb_hmc5883l_i2c|tests/tb_hmc5883l_i2c.sv"
    "heading_magnetico|tb_heading_magnetico|tests/tb_heading_magnetico.sv"
    "top_heading|tb_top_heading|tests/tb_top_heading.sv"
    "controle_heading|tb_controle_heading|tests/tb_controle_heading.sv"
    "controle_joystick|tb_controle_joystick|tests/tb_controle_joystick.sv"
    "controle_manche|tb_controle_manche|tests/tb_controle_manche.sv"
    "modo_manche|tb_modo_manche|tests/tb_modo_manche.sv"
    "horizonte|tb_horizonte|tests/tb_horizonte.sv"
    "atitude|tb_atitude|tests/tb_atitude.sv"
    "atitude_accel_fixa|tb_atitude_accel_fixa|tests/tb_atitude_accel_fixa.sv"
    "gyro_bias_dt|tb_gyro_bias_dt|tests/tb_gyro_bias_dt.sv"
    "gyro_integrador|tb_gyro_integrador|tests/tb_gyro_integrador.sv"
    "atitude_gyro_hud|tb_atitude_gyro_hud|tests/tb_atitude_gyro_hud.sv"
    "atitude_fusao_complementar|tb_atitude_fusao_complementar|tests/tb_atitude_fusao_complementar.sv"
    "velocidade_inercial|tb_velocidade_inercial|tests/tb_velocidade_inercial.sv"
    "velocidade_inercial_pipeline|tb_velocidade_inercial_pipeline|tests/tb_velocidade_inercial_pipeline.sv"
    "velocidade_inercial_dt_real|tb_velocidade_inercial_dt_real|tests/tb_velocidade_inercial_dt_real.sv"
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

    if [[ "$nome" =~ ^(roll|vga)$ ]] && command -v verilator >/dev/null 2>&1; then
        # Exhaustive raster sweeps are much faster in Verilator; keep every vector.
        verilator --binary --timing -Wno-fatal \
            --top-module "$top" \
            --Mdir "build/tests/${nome}_verilator" \
            tests/xadc_stub.sv \
            rtl/*.sv \
            "$fonte"

        "build/tests/${nome}_verilator/V${top}"
    else
        iverilog -g2012 \
            -s "$top" \
            -o "build/tests/$nome" \
            tests/xadc_stub.sv \
            rtl/*.sv \
            "$fonte"

        vvp "build/tests/$nome"
    fi
done

echo
echo "===== TODOS OS TESTES PASSARAM ====="
