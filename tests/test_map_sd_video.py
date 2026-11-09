"""Imagens FAT32 temporarias: valida mapa e rejeita fragmentacao/corrupcao."""
import hashlib
import struct
import sys
import tempfile
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from convert_video_for_fpga import HEADER, MAGIC
from map_sd_video import inspect


class MapSDTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.image = self.root / 'card.img'
        self.reference = self.root / 'HUDVIDEO.BIN'
        self.payload = HEADER.pack(MAGIC, 1, 512, 160, 120, 1, 1, 2, 19200, 19456, 39424, 1, b'fat-test-fixture!') + bytes(448) + (bytes(range(256))*75 + bytes(256))*2
        self.reference.write_bytes(self.payload)
        self.start, self.fatsize, self.clusters = 2048, 548, 70000
        self.total = 32 + 2*self.fatsize + self.clusters
        self.data_start = self.start + 32 + 2*self.fatsize
        with self.image.open('wb') as stream:
            stream.truncate((self.start+self.total)*512)
        mbr = bytearray(512)
        mbr[450] = 0x0c
        struct.pack_into('<II', mbr, 454, self.start, self.total)
        mbr[510:] = b'\x55\xaa'
        boot = bytearray(512)
        struct.pack_into('<H', boot, 11, 512)
        boot[13] = 1
        struct.pack_into('<H', boot, 14, 32)
        boot[16] = 2
        struct.pack_into('<I', boot, 32, self.total)
        struct.pack_into('<I', boot, 36, self.fatsize)
        struct.pack_into('<I', boot, 44, 2)
        boot[510:] = b'\x55\xaa'
        fat = bytearray(self.fatsize*512)
        for cluster, value in [(0,0x0ffffff8),(1,0xffffffff),(2,0x0fffffff)] + [(n, n+1 if n<79 else 0x0fffffff) for n in range(3,80)]:
            struct.pack_into('<I', fat, cluster*4, value)
        entry = bytearray(512)
        entry[:11] = b'HUDVIDEOBIN'
        entry[11] = 0x20
        struct.pack_into('<H', entry, 26, 3)
        struct.pack_into('<I', entry, 28, len(self.payload))
        self.write(0, mbr)
        self.write(self.start*512, boot)
        for i in range(2):
            self.write((self.start+32+i*self.fatsize)*512, fat)
        self.write(self.data_start*512, entry)
        self.write((self.data_start+1)*512, self.payload)

    def write(self, offset, data):
        with self.image.open('r+b') as stream:
            stream.seek(offset)
            stream.write(data)

    def test_contiguous_read_only(self):
        before = hashlib.sha256(self.image.read_bytes()).hexdigest()
        result = inspect(self.image, self.reference)
        self.assertEqual(result['lba'], self.data_start+1)
        self.assertEqual(result['file_sectors'], 77)
        self.assertTrue(result['contiguous_verified'])
        self.assertFalse(result['device_writes'])
        self.assertEqual(result['sha256'], hashlib.sha256(self.payload).hexdigest())
        self.assertEqual(before, hashlib.sha256(self.image.read_bytes()).hexdigest())

    def test_fragmented(self):
        for i in range(2):
            base = (self.start+32+i*self.fatsize)*512
            self.write(base+3*4, struct.pack('<I',5))
            self.write(base+4*4, bytes(4))
            self.write(base+79*4, struct.pack('<I',80))
            self.write(base+80*4, struct.pack('<I',0x0fffffff))
        with self.assertRaisesRegex(ValueError, 'fragmentado'):
            inspect(self.image, self.reference)

    def test_fat_mismatch(self):
        self.write((self.start+32+self.fatsize)*512+3*4, bytes(4))
        with self.assertRaisesRegex(ValueError, 'FAT divergem'):
            inspect(self.image, self.reference)

    def test_payload_mismatch(self):
        self.write((self.data_start+2)*512+1, b'\xff')
        with self.assertRaisesRegex(ValueError, 'difere'):
            inspect(self.image, self.reference)

    def test_fat_cycle(self):
        for i in range(2):
            self.write((self.start+32+i*self.fatsize)*512+79*4, struct.pack('<I',3))
        with self.assertRaisesRegex(ValueError, 'ciclica'):
            inspect(self.image, self.reference)


if __name__ == '__main__':
    unittest.main()
