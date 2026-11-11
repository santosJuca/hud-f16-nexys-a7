import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import numpy as np

TOOLS = Path(__file__).resolve().parents[1]/'tools'
sys.path.insert(0, str(TOOLS))
spec = importlib.util.spec_from_file_location('nv', TOOLS/'convert_video_nv2bpp.py')
nv = importlib.util.module_from_spec(spec)
spec.loader.exec_module(nv)
import convert_video_for_fpga as base  # noqa: E402
import verify_video  # noqa: E402


def make_source(path, size, seconds=1, rate=30, src='testsrc2'):
    subprocess.run(['ffmpeg', '-v', 'error', '-nostdin', '-f', 'lavfi', '-i',
                    f"{src}{':' if '=' in src else '='}size={size}:rate={rate}", '-t', str(seconds), '-c:v', 'ffv1', str(path)],
                   check=True)


class PackingTest(unittest.TestCase):
    def test_pixel_order_msb_first(self):
        idx = np.zeros((480, 640), dtype=np.uint8)
        idx[0, :4] = [3, 2, 1, 0]
        idx[1, 4:8] = [0, 1, 2, 3]
        idx[479, 636:640] = [1, 1, 1, 2]
        data = nv.pack_indices(idx)
        self.assertEqual(len(data), 76800)
        self.assertEqual(data[0], 0b11100100)
        self.assertEqual(data[160+1], 0b00011011)
        self.assertEqual(data[479*160+159], 0b01010110)
        self.assertEqual(sum(1 for b in data if b), 3)

    def test_exhaustive_byte_roundtrip(self):
        # Duas linhas de 160 bytes cobrem os 256 valores possiveis de byte.
        for offset in (0, 96):
            vals = (np.arange(160) + offset) & 255
            idx = np.repeat(np.array([[(v >> s) & 3 for v in vals for s in (6, 4, 2, 0)]], dtype=np.uint8), 480, axis=0)
            data = nv.pack_indices(idx)
            self.assertEqual(bytes(data[:160]), bytes(int(v) for v in vals))
            self.assertTrue(np.array_equal(nv.unpack_indices(data), idx))

    def test_rejects_invalid_index_or_shape(self):
        with self.assertRaises(ValueError):
            nv.pack_indices(np.full((480, 640), 4, dtype=np.uint8))
        with self.assertRaises(ValueError):
            nv.pack_indices(np.zeros((240, 320), dtype=np.uint8))
        with self.assertRaises(ValueError):
            nv.unpack_indices(bytes(76799))


class PaletteTest(unittest.TestCase):
    def test_rgb332_decoding_matches_rtl_expansion(self):
        # Formula do sd_video_background: {r,r[2]},{g,g[2]},{b,b}.
        for v in range(256):
            r, g, b = v >> 5, (v >> 2) & 7, v & 3
            expected = ((r << 1) | (r >> 2)) << 8 | ((g << 1) | (g >> 2)) << 4 | ((b << 2) | b)
            self.assertEqual(nv.rgb332_to_rgb12(v), expected)

    def test_default_palette_is_green_dark_and_below_hud(self):
        rgb12 = [nv.rgb332_to_rgb12(p) for p in nv.DEFAULT_PALETTE]
        self.assertEqual(len(set(nv.DEFAULT_PALETTE)), 4)
        self.assertEqual([c >> 8 for c in rgb12], [0]*4)        # sem vermelho
        self.assertEqual([c & 15 for c in rgb12], [0]*4)        # sem azul
        greens = [(c >> 4) & 15 for c in rgb12]
        self.assertEqual(greens, sorted(greens))
        self.assertEqual(greens[0], 0)
        self.assertLess(max(greens), 15)                        # 12'h0F0 reservado ao HUD

    def test_decode_uses_only_palette_colors(self):
        rng = np.random.default_rng(1)
        idx = rng.integers(0, 4, size=(480, 640), dtype=np.uint8)
        rgb = nv.decode_rgb24(nv.pack_indices(idx), nv.DEFAULT_PALETTE)
        for i, p in enumerate(nv.DEFAULT_PALETTE):
            expected = np.frombuffer(nv.rgb12_to_rgb24(nv.rgb332_to_rgb12(p)), dtype=np.uint8)
            self.assertTrue(np.all(rgb[idx == i] == expected))


class HeaderTest(unittest.TestCase):
    def header(self, palette=(0, 4, 12, 16), frames=2):
        data = bytearray(base.HEADER.pack(base.MAGIC, 1, 512, 640, 480, 30, 2, frames, 76800, 76800,
                                          512+frames*76800, 1, b'2'*16)+bytes(448))
        data[56:60] = bytes(palette)
        return data

    def test_indexed2_header_accepted(self):
        info = base.parse_header(bytes(self.header()))
        self.assertEqual(info['pixel_format'], 'INDEXED2_RGB332')
        self.assertEqual(info['frame_bytes'], 76800)
        self.assertEqual(info['frame_stride'], 76800)
        self.assertEqual(info['palette_rgb332'], ['00', '04', '0C', '10'])

    def test_indexed2_header_corruption_rejected(self):
        data = self.header()
        for offset in (0, 8, 10, 12, 14, 18, 20, 24, 28, 32, 36, 60, 63, 511):
            corrupt = data.copy()
            corrupt[offset] ^= 0xff
            with self.assertRaises(ValueError, msg=f'offset={offset}'):
                base.parse_header(bytes(corrupt))

    def test_rgb332_geometry_not_mixed_with_indexed2(self):
        bad = bytearray(base.HEADER.pack(base.MAGIC, 1, 512, 640, 480, 30, 1, 2, 307200, 307200,
                                         512+2*307200, 1, b'3'*16)+bytes(448))
        with self.assertRaises(ValueError):
            base.parse_header(bytes(bad))
        bad = bytearray(base.HEADER.pack(base.MAGIC, 1, 512, 320, 240, 30, 2, 2, 19200, 19456,
                                         512+2*19456, 1, b'3'*16)+bytes(448))
        with self.assertRaises(ValueError):
            base.parse_header(bytes(bad))


class ConversionTest(unittest.TestCase):
    def test_synthetic_preview_layout_hashes_and_verify(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)/'nv'
            info = nv.convert(out, synthetic=True, seconds=1, preview=True, comparisons=(0, 15))
            data = (out/'HUDVIDEO.BIN').read_bytes()
            self.assertEqual(info['frame_count'], 30)
            self.assertEqual(len(data), 512+30*76800)
            self.assertEqual((len(data)-512) % 512, 0)
            self.assertEqual(info['sectors_per_frame'], 150)
            self.assertEqual(info['required_bytes_per_second'], 2304000)
            self.assertEqual(hashlib.sha256(data).hexdigest(), info['sha256'])
            self.assertEqual(data[56:60], bytes(nv.DEFAULT_PALETTE))
            self.assertEqual(verify_video.verify(out)['status'], 'PASS')
            self.assertGreater(len({f['sha256'] for f in info['frames']}), 1)  # movimento preservado
            self.assertTrue((out/'previa_nv2bpp.mp4').stat().st_size > 0)
            self.assertTrue((out/'comparacao_q00015.png').exists())
            palette = json.loads((out/'palette.json').read_text())
            self.assertEqual([e['rgb332'] for e in palette['entries']], ['00', '04', '0C', '10'])
            with self.assertRaises(FileExistsError):
                nv.convert(out, synthetic=True, seconds=1, preview=False)
            self.assertEqual((out/'HUDVIDEO.BIN').read_bytes(), data)

    def test_letterbox_preserves_16x9_without_distortion(self):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp)/'wide.mkv'
            make_source(src, '1280x720', src='color=c=white')
            before = hashlib.sha256(src.read_bytes()).hexdigest()
            info = nv.convert(Path(tmp)/'out', src, seconds=1, preview=False, thresholds=(40, 120, 200))
            self.assertEqual(hashlib.sha256(src.read_bytes()).hexdigest(), before)  # origem intacta
            self.assertEqual(info['active_area_xywh'], [0, 60, 640, 360])
            frame = nv.unpack_indices((Path(tmp)/'out/HUDVIDEO.BIN').read_bytes()[512:512+76800])
            self.assertTrue(np.all(frame[:60] == 0))
            self.assertTrue(np.all(frame[420:] == 0))
            self.assertTrue(np.all(frame[60:420] == 3))
            self.assertEqual(info['source_probe']['codec'], 'ffv1')
            self.assertEqual(info['source_sha256'], before)

    def test_4x3_source_and_crop_have_no_bands(self):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp)/'std.mkv'
            make_source(src, '320x240', src='color=c=white')
            info = nv.convert(Path(tmp)/'a', src, seconds=1, preview=False, thresholds=(40, 120, 200))
            self.assertEqual(info['active_area_xywh'], [0, 0, 640, 480])
            frame = nv.unpack_indices((Path(tmp)/'a/HUDVIDEO.BIN').read_bytes()[512:512+76800])
            self.assertTrue(np.all(frame == 3))
            wide = Path(tmp)/'wide.mkv'
            make_source(wide, '1280x720', src='color=c=white')
            info = nv.convert(Path(tmp)/'b', wide, seconds=1, preview=False, framing='crop',
                              thresholds=(40, 120, 200))
            frame = nv.unpack_indices((Path(tmp)/'b/HUDVIDEO.BIN').read_bytes()[512:512+76800])
            self.assertTrue(np.all(frame == 3))

    def test_deterministic_output_and_global_calibration(self):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp)/'motion.mkv'
            make_source(src, '640x360', seconds=2)
            a = nv.convert(Path(tmp)/'a', src, seconds=1, preview=False, calib_samples=6)
            b = nv.convert(Path(tmp)/'b', src, seconds=1, preview=False, calib_samples=6)
            self.assertEqual(a['thresholds_luma'], b['thresholds_luma'])
            self.assertEqual([f['sha256'] for f in a['frames']], [f['sha256'] for f in b['frames']])
            self.assertTrue(a['thresholds_luma'][0] < a['thresholds_luma'][1] < a['thresholds_luma'][2])

    def test_hysteresis_reduces_threshold_flicker(self):
        t = (64, 128, 192)
        rng = np.random.default_rng(7)
        base_l = np.full((480, 640), 128, dtype=np.int16)
        prev_raw = prev_stable = None
        flips_raw = flips_stable = 0
        for _ in range(20):
            luma = np.clip(base_l + rng.integers(-4, 5, size=base_l.shape), 0, 255).astype(np.uint8)
            raw = nv.quantize(luma, t)
            stable = nv.quantize_stable(luma, t, prev_stable, 6)
            if prev_raw is not None:
                flips_raw += int(np.count_nonzero(raw != prev_raw))
                flips_stable += int(np.count_nonzero(stable != prev_stable))
            prev_raw, prev_stable = raw, stable
        self.assertGreater(flips_raw, 100000)
        self.assertEqual(flips_stable, 0)
        # Mudanca real de cena atravessa a histerese.
        dark = nv.quantize_stable(np.zeros((480, 640), dtype=np.uint8), t, prev_stable, 6)
        self.assertTrue(np.all(dark == 0))


if __name__ == '__main__':
    unittest.main()
