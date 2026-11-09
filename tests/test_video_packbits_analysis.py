import random
import sys
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from analyze_video_throughput import packbits, unpackbits

class PackbitsAnalysisTest(unittest.TestCase):
    def test_boundaries_and_roundtrip(self):
        rng = random.Random(9)
        for n in [0,1,2,3,127,128,129,255,256,76800]:
            for data in [b'x'*n, bytes(i%251 for i in range(n)), bytes(rng.randrange(256) for _ in range(n))]:
                with self.subTest(n=n, prefix=data[:3]):
                    encoded = packbits(data)
                    self.assertEqual(unpackbits(encoded,n),data)
                    self.assertLessEqual(len(encoded), n+(n+127)//128)
    def test_reject_truncated_and_overflow(self):
        for data,limit in [(b'\x00',10),(b'\xff',10),(b'\x81x',127)]:
            with self.assertRaises(ValueError):unpackbits(data,limit)

if __name__=='__main__': unittest.main()
