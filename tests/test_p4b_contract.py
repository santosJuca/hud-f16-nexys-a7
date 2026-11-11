#!/usr/bin/env python3
"""Contrato estatico + referencia de empacotamento/CRC. Nao executa HDL."""
from pathlib import Path
import hashlib
import zlib

ROOT = Path(__file__).resolve().parents[1]
rtl = ROOT / "hud/rtl"
read = lambda name: (rtl / name).read_text()
top = read("top_reticula.sv")
wrapper = read("ddr2_ui_smoke_top.v")
mirror = read("ddr2_sd_frame_mirror.sv")
fifo = read("ddr2_p4b_async_fifo.sv")
assert "parameter bit ENABLE_DDR2_SD_MIRROR = 1'b0" in top
assert ".src_frame_write(p4b_frame_write)" in top
assert "assign p4b_frame_write = frame_write;" in top
assert "sd_sector_buffer #(.BYTES(SD_VIDEO_FRAME_BYTES))" in top
assert "localparam integer SD_VIDEO_FRAME_BYTES = SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT*SD_VIDEO_BPP/8;" in top
assert "parameter integer SD_VIDEO_BPP = 8," in top  # padrao preserva RGB332
assert ".buffer_ready(ENABLE_DDR2_VIDEO ? ddr_src_ready : frame_ready)" in top
assert ".rd_clk(pixel_clk)" in top
assert "SD_VIDEO_LBA == 0 || SD_VIDEO_SECTORS <= 1" in top
assert "ddr2_sd_frame_mirror" in wrapper
assert "generate if (ENABLE_SD_MIRROR != 0)" in wrapper
assert "FRAME_TEST_WORDS > 0" in wrapper
assert "ddr2_ui_smoke #(.WORDS(16))" in wrapper
assert "app_wdf_wren = !ui_local_rst && write_accept" in mirror
assert "(write_accept || read_accept)" in mirror
assert "app_addr = {11'd0, ui_index, 3'd0}" in mirror
assert "event_kind == EV_COMMIT" in mirror
assert "event_kind == EV_ABORT" in mirror
assert "~crc_next == expected_crc" in mirror
assert "xpm_fifo_async" in fifo and ".READ_MODE(\"fwft\")" in fifo
assert "wr_busy" in fifo and "rd_busy" in fifo
# Os fontes criticos nao devem ter mudado desde P3D/P4A.
expected = {
    "atitude_vetorial.sv": "a71500526bf475e804835a7ed112b2a7f1c2543c29af66e5999baf50c029e147",
    # Atualizado conscientemente em exp/video-640x480-2bpp-20261111: parametros BPP/PALETTE
    # (padrao BPP=8 preserva o RGB332; base anterior 0e263464...). Ver VIDEO_640x480_2BPP.md.
    "sd_video_loader.sv": "04fd66a22cabbd6b330ebd86ca958f5431ee8c3e7016a4ba0680265246141e34",
    "sd_sector_buffer.sv": "3f637d6b82044af68e28d5ee9dfa9997d1ac4d65a25d76fdbdff391cef5b32e3",
    "ddr2_ui_frame_test.v": "9e3cf12bc58e95f497d14d5902103ec31f38052f58f0b9649e40a3b2a300e7af",
}
for filename, sha in expected.items():
    actual = hashlib.sha256((rtl / filename).read_bytes()).hexdigest()
    assert actual == sha, f"Fonte fora da base homologada: {filename}: {actual}"

for size in (256, 76800):
    raw = bytes((((i * 37) ^ (i >> 5) ^ (i >> 11) ^ 0xA5) & 0xFF) for i in range(size))
    beats = [raw[i:i + 16] for i in range(0, size, 16)]
    assert all(len(beat) == 16 for beat in beats)
    assert len(beats) == size // 16
    reconstructed = b"".join(beats)
    assert reconstructed == raw
    crc = zlib.crc32(raw)
    assert crc == zlib.crc32(reconstructed)
    corrupt = bytearray(reconstructed)
    corrupt[71] ^= 1
    assert zlib.crc32(corrupt) != crc
    print(f"P4B_PYTHON_MODEL_PASS bytes={size} beats={len(beats)} crc32={crc:08x}")
print("P4B_STATIC_CONTRACT_PASS")
