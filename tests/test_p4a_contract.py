#!/usr/bin/env python3
"""Verificacoes de contrato; nao substituem compilacao ou simulacao HDL."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
legacy = root / 'hud/rtl/ddr2_ui_smoke.v'
new = root / 'hud/rtl/ddr2_ui_frame_test.v'
top = (root / 'hud/rtl/top_reticula.sv').read_text()
wrapper = (root / 'hud/rtl/ddr2_ui_smoke_top.v').read_text()
frame = new.read_text()

assert 'parameter bit ENABLE_DDR2_FRAME_TEST = 1\'b0' in top
assert 'FRAME_TEST_WORDS(ENABLE_DDR2_FRAME_TEST ?' in top
assert '.FRAME_TEST_WORDS' in top
assert 'else if (FRAME_TEST_WORDS > 0)' in wrapper
assert 'ddr2_ui_smoke #(.WORDS(16))' in wrapper
assert 'ddr2_ui_frame_test #(.WORDS(FRAME_TEST_WORDS))' in wrapper
assert 'app_addr = {11\'d0, index, 3\'d0}' in frame
assert 'app_wdf_wren = write_accept' in frame
assert 'app_en = write_accept || read_accept' in frame
assert 'app_wdf_mask = 16\'d0' in frame
assert 'sd_sector_buffer #(.BYTES(SD_VIDEO_WIDTH*SD_VIDEO_HEIGHT))' in top
assert 'assign scene_rgb=' not in frame
print('P4A_STATIC_CONTRACT_PASS')
print('P3D_SMOKE_SHA256:', hashlib.sha256(legacy.read_bytes()).hexdigest())

# Modelo de referencia Python do padrao; cobre todos os beats de um frame.
def word(index: int) -> bytes:
    data = []
    for byte_idx in range(16):
        if byte_idx == 0:
            pattern = (index & 255) ^ 0xA5
        elif byte_idx == 1:
            pattern = ((index >> 8) & 31) ^ 0x5A
        else:
            pattern = ((index & 255) + ((index >> 8) & 31)*29 + byte_idx*37) & 255
            pattern ^= 0xA5
        data.append(pattern)
    return bytes(data)

for total in (1200, 4800):
    payload = [word(idx) for idx in range(total)]
    assert len(set(payload)) == total, 'Padrao com colisao de indice'
    assert (total-1)*8 < (1 << 27)
    assert len(b''.join(payload)) == total*16
    print(f'P4A_MODEL_PASS: {total} beats, {total*16} bytes')
