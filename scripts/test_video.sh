#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:?Uso: test_video.sh diretorio_novo}"
mkdir "$out"
python3 -m unittest discover -s tests -p 'test_*video*.py' > "$out/python-tests.log" 2>&1
python3 tools/convert_video_for_fpga.py "$out/synthetic160" --synthetic --width 160 --seconds 1 > "$out/conversion160.log"
python3 - "$out/synthetic160" <<'PY'
from pathlib import Path
import struct,sys
folder=Path(sys.argv[1]);data=bytearray((folder/'HUDVIDEO.BIN').read_bytes()[:512+2*19456])
struct.pack_into('<I',data,20,2);struct.pack_into('<I',data,32,len(data))
(folder/'two-frame.hex').write_text('\n'.join(f'{v:02x}' for v in data)+'\n')
PY
read -r -a scenarios <<< "${VIDEO_SCENARIOS:-0 1 2 3 4 5}"
for scenario in "${scenarios[@]}"; do
    name="scenario-$scenario"
    verilator --binary --timing -j 2 -Wno-fatal --top-module tb_sd_video_pipeline \
        -GWIDTH=160 -GHEIGHT=120 -GFRAMES=2 -GSCENARIO="$scenario" -GTEST_CLK_HZ=1000000 \
        --Mdir "$out/$name" rtl/sd_spi*.sv rtl/sd_sector_buffer.sv rtl/sd_video*.sv \
        rtl/vga_controller.sv tests/sd_video_card_model.sv tests/tb_sd_video_pipeline.sv \
        > "$out/$name-build.log" 2>&1
    "$out/$name/Vtb_sd_video_pipeline" +VIDEO_HEX="$out/synthetic160/two-frame.hex" > "$out/$name.log" 2>&1
    tail -3 "$out/$name.log"
done
