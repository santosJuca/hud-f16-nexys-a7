import hashlib
import importlib.util
import json
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest

spec=importlib.util.spec_from_file_location('video',Path(__file__).resolve().parents[1]/'tools/convert_video_for_fpga.py')
video=importlib.util.module_from_spec(spec)
spec.loader.exec_module(video)


class ConversionTest(unittest.TestCase):
    def test_rgb332_channel_order(self):
        pixels=bytes([255,0,0, 0,255,0, 0,0,255, 255,255,255, 0,0,0])
        output=subprocess.run(['ffmpeg','-v','error','-f','rawvideo','-pixel_format','rgb24',
            '-video_size','5x1','-i','pipe:0','-frames:v','1','-pix_fmt','rgb8',
            '-f','rawvideo','pipe:1'],input=pixels,stdout=subprocess.PIPE,check=True).stdout
        self.assertEqual(output,bytes([0xe0,0x1c,0x03,0xff,0x00]))

    def test_preserves_widescreen_aspect_ratio(self):
        with tempfile.TemporaryDirectory() as tmp:
            source=Path(tmp)/'wide.mkv'
            subprocess.run(['ffmpeg','-v','error','-nostdin','-f','lavfi','-i',
                            'color=white:size=640x360:rate=2','-t','1','-c:v','ffv1',str(source)],check=True)
            video.convert(source,Path(tmp)/'out',320,240,2,False,1)
            frame=(Path(tmp)/'out/HUDVIDEO.BIN').read_bytes()[512:512+76800]
            self.assertEqual(frame[:30*320],bytes(30*320))
            self.assertTrue(set(frame[30*320:210*320]).issubset({254,255}))
            self.assertEqual(frame[210*320:],bytes(30*320))

    def test_seconds_limits_real_input(self):
        with tempfile.TemporaryDirectory() as tmp:
            source=Path(tmp)/'source.mkv'
            subprocess.run(['ffmpeg','-v','error','-nostdin','-f','lavfi','-i',
                            'testsrc2=size=320x240:rate=30','-t','2','-c:v','ffv1',str(source)],
                           check=True)
            info=video.convert(source,Path(tmp)/'short',320,240,30,False,1)
            self.assertEqual(info['frame_count'],30)
            self.assertEqual(info['total_bytes'],512+30*76800)

    def test_motion_alignment_hashes_and_preservation(self):
        with tempfile.TemporaryDirectory() as tmp:
            out=Path(tmp)/'video'
            info=video.convert(None,out,160,120,10,True,1)
            data=(out/'HUDVIDEO.BIN').read_bytes()
            header=video.parse_header(data[:512])
            self.assertEqual(header['frame_count'],10)
            self.assertEqual(len(data),512+10*19456)
            self.assertEqual(hashlib.sha256(data).hexdigest(),info['sha256'])
            self.assertGreater(len({f['sha256'] for f in info['frames']}),1)
            for f in info['frames']:
                start=512+f['index']*19456
                self.assertEqual(hashlib.sha256(data[start:start+19200]).hexdigest(),f['sha256'])
                self.assertEqual(data[start+19200:start+19456],bytes(256))
            with self.assertRaises(FileExistsError):
                video.convert(None,out,160,120,10,True,1)
            self.assertEqual((out/'HUDVIDEO.BIN').read_bytes(),data)

    def test_reject_header_corruption(self):
        data=bytearray(video.HEADER.pack(video.MAGIC,1,512,320,240,10,1,2,76800,76800,154112,1,b'1'*16)+bytes(448))
        video.parse_header(data)
        for offset in (0,8,10,12,14,16,18,20,24,28,32,36,56,511):
            corrupt=data.copy()
            corrupt[offset]^=0xff
            with self.assertRaises(ValueError,msg=f'offset={offset}'):
                video.parse_header(corrupt)


if __name__=='__main__':
    unittest.main()
