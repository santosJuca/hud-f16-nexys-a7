import importlib.util
from pathlib import Path
import struct
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from convert_video_for_fpga import HEADER, MAGIC
from map_sd_video import inspect


class MapTest(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.root=Path(self.temp.name)
        self.reference=self.root/'HUDVIDEO.BIN'
        self.data=HEADER.pack(MAGIC,1,512,160,120,10,1,2,19200,19456,39424,1,b's'*16)+bytes(448)+bytes(range(256))*152
        self.reference.write_bytes(self.data)
        self.image=self.root/'card.img'
        self.start=1; self.reserved=32; self.fatsize=513
        self.data_start=self.start+self.reserved+2*self.fatsize
        self.total=self.reserved+2*self.fatsize+65525
        self.fat=bytearray(self.fatsize*512)
        struct.pack_into('<III',self.fat,0,0x0ffffff8,0x0fffffff,0x0fffffff)
        for c in range(3,80):
            struct.pack_into('<I',self.fat,c*4,c+1 if c<79 else 0x0fffffff)
        with self.image.open('wb') as stream:
            stream.truncate((self.start+self.total)*512)
            mbr=bytearray(512);mbr[450]=0x0c
            struct.pack_into('<II',mbr,454,self.start,self.total);mbr[510:]=b'\x55\xaa'
            stream.write(mbr)
            boot=bytearray(512)
            struct.pack_into('<H',boot,11,512);boot[13]=1
            struct.pack_into('<H',boot,14,self.reserved);boot[16]=2
            struct.pack_into('<I',boot,32,self.total);struct.pack_into('<I',boot,36,self.fatsize)
            struct.pack_into('<I',boot,44,2);boot[510:]=b'\x55\xaa'
            stream.seek(512);stream.write(boot)
            self.write_fats(stream)
            directory=bytearray(512);directory[:11]=b'HUDVIDEOBIN';directory[11]=0x20
            struct.pack_into('<H',directory,26,3);struct.pack_into('<I',directory,28,len(self.data))
            stream.seek(self.data_start*512);stream.write(directory);stream.write(self.data)

    def write_fats(self,stream):
        for i in range(2):
            stream.seek((self.start+self.reserved+i*self.fatsize)*512)
            stream.write(self.fat)

    def tearDown(self):
        self.temp.cleanup()

    def test_contiguous_verified_read_only(self):
        before=self.image.stat().st_mtime_ns
        result=inspect(self.image,self.reference)
        self.assertEqual(result['lba'],self.data_start+1)
        self.assertEqual(result['file_sectors'],77)
        self.assertEqual(result['free_bytes'],(65525-78)*512)
        self.assertFalse(result['device_writes'])
        self.assertEqual(self.image.stat().st_mtime_ns,before)

    def test_fragmentation_cycles_and_mirrors(self):
        for bad in ('fragment','cycle','mirror'):
            with self.subTest(bad=bad):
                original=self.fat.copy()
                if bad=='fragment':
                    struct.pack_into('<I',self.fat,3*4,5)
                    struct.pack_into('<I',self.fat,5*4,4)
                    struct.pack_into('<I',self.fat,4*4,6)
                elif bad=='cycle':
                    struct.pack_into('<I',self.fat,79*4,3)
                with self.image.open('r+b') as stream:
                    self.write_fats(stream)
                    if bad=='mirror':
                        stream.seek((self.start+self.reserved+self.fatsize)*512+12)
                        stream.write(b'\0'*4)
                with self.assertRaises(ValueError):
                    inspect(self.image,self.reference)
                self.fat=original
                with self.image.open('r+b') as stream:
                    self.write_fats(stream)

    def test_corrupt_file_and_missing_name(self):
        with self.image.open('r+b') as stream:
            stream.seek((self.data_start+1)*512+520);stream.write(b'x')
        with self.assertRaises(ValueError):
            inspect(self.image,self.reference)
        with self.image.open('r+b') as stream:
            stream.seek(self.data_start*512);stream.write(b'X')
        with self.assertRaises(ValueError):
            inspect(self.image,self.reference)


if __name__=='__main__':
    unittest.main()
