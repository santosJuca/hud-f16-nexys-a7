"""Verifica o preparo da referencia com fixture sintetica, sem dispositivos."""
import sys
sys.dont_write_bytecode = True
import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('reference', Path(__file__).resolve().parents[1] / 'scripts/sd_sector_reference.py')
reference = importlib.util.module_from_spec(spec)
spec.loader.exec_module(reference)


class SectorReferenceTest(unittest.TestCase):
    def test_prepare_reference(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            data = bytes([255]) * 512
            source = root / 'source.bin'
            source.write_bytes(data)
            info = reference.prepare(source, root / 'reference', 0)
            self.assertEqual(info['crc16'], '7FA1')
            with self.assertRaises(FileExistsError):
                reference.prepare(source, root / 'reference', 0)
            self.assertEqual((root / 'reference/sector_reference.bin').read_bytes(), data)
            self.assertEqual(len((root / 'reference/sector_reference.hex').read_text().split()), 512)
            link = root / 'link'
            link.symlink_to(source)
            with self.assertRaises(ValueError):
                reference.sector_file(link)
            source.write_bytes(b'')
            with self.assertRaises(ValueError):
                reference.sector_file(source)


if __name__ == '__main__':
    unittest.main()
