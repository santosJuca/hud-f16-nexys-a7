#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ $# != 1 || -e "$1" ]]; then
    echo 'Uso: test_sd_p0.sh diretorio_novo' >&2
    exit 2
fi
mkdir -m 700 -p "$1"
out=$(realpath "$1")
for top in tb_sd_spi_preamble tb_sd_spi_command tb_sd_spi_cmd0 tb_sd_spi_startup \
           tb_sd_spi_acmd tb_sd_spi_init tb_sd_spi_read_block tb_sd_spi_controller \
           tb_sd_spi_throughput tb_sd_status_display tb_sd_diagnostic tb_top_sd_integration; do
    iverilog -g2012 -s "$top" -o "$out/$top.vvp" \
        tests/xadc_stub.sv rtl/*.sv "tests/$top.sv" > "$out/$top.compile.log" 2>&1
    vvp "$out/$top.vvp" > "$out/$top.log" 2>&1
    echo "PASS $top"
done
for half in 125 10 5 2; do
    top=tb_sd_spi_token_timeout
    iverilog -g2012 -s "$top" -P"$top.HALF=$half" -o "$out/token-$half.vvp" \
        rtl/sd_spi_read_block.sv "tests/$top.sv" > "$out/token-$half.compile.log" 2>&1
    vvp "$out/token-$half.vvp" > "$out/token-$half.log" 2>&1
    echo "PASS token timeout HALF=$half"
done
python3 tests/test_sd_sector_reference.py > "$out/reference.log" 2>&1
echo 'PASS preparacao da referencia'
