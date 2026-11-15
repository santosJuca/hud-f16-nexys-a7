#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

out_dir="${OUT_DIR:-/tmp/p2l-throughput-$$}"
mkdir -p "$out_dir"

for half in 125 10 5 2; do
    for latency in "1 0" "4 4" "12 16"; do
        read -r r1_delay token_delay <<< "$latency"
        tag="half${half}_r1${r1_delay}_token${token_delay}"
        echo "===== $tag ====="
        iverilog -g2012 -Wall -s tb_sd_spi_throughput \
            -Ptb_sd_spi_throughput.HALF="$half" \
            -Ptb_sd_spi_throughput.R1_DELAY_BYTES="$r1_delay" \
            -Ptb_sd_spi_throughput.TOKEN_DELAY_BYTES="$token_delay" \
            -o "$out_dir/$tag.vvp" \
            rtl/sd_spi_preamble.sv rtl/sd_spi_command.sv rtl/sd_spi_init.sv \
            rtl/sd_spi_read_block.sv rtl/sd_spi_controller.sv \
            tests/tb_sd_spi_throughput.sv \
            > "$out_dir/$tag.compile.log" 2>&1
        vvp "$out_dir/$tag.vvp" | tee "$out_dir/$tag.log"
    done
done

echo "RESULTS_DIR=$out_dir"
