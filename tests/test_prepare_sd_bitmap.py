import sys
sys.dont_write_bytecode=True
import importlib.util
from pathlib import Path
import tempfile, unittest
from PIL import Image
spec=importlib.util.spec_from_file_location('bitmap',Path(__file__).resolve().parents[1]/'scripts/prepare_sd_bitmap.py')
bitmap=importlib.util.module_from_spec(spec);spec.loader.exec_module(bitmap)


class BitmapTest(unittest.TestCase):
    def test_pack_and_refuse_overwrite(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);source=root/'image.png'
            im=Image.new('RGBA',(64,64),(0,0,0,255))
            for xy in [(0,0),(7,0),(8,0),(63,63)]: im.putpixel(xy,(255,255,255,255))
            im.putpixel((9,0),(255,255,255,0)); im.save(source)
            data,info=bitmap.convert(source,root/'out')
            self.assertEqual(len(data),512)
            self.assertEqual((data[0],data[1],data[511]),(0x81,0x80,0x01))
            self.assertEqual(sum(data[2:511]),0)
            self.assertIsNone(info['lba'])
            with self.assertRaises(FileExistsError):bitmap.convert(source,root/'out')
            im.resize((63,64)).save(source)
            with self.assertRaises(ValueError):bitmap.convert(source,root/'other')


if __name__=='__main__':unittest.main()
