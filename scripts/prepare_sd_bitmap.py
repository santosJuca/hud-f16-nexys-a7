#!/usr/bin/env python3
"""Converte PNG/BMP 64x64 em bitmap de um setor; so cria arquivos locais novos."""
import argparse
import hashlib
import json
from pathlib import Path
from PIL import Image


def convert(source, output):
    raw = source.read_bytes()
    with Image.open(source) as original:
        if original.size != (64, 64):
            raise ValueError('A imagem deve ter exatamente 64x64 pixels')
        image = original.convert('RGBA')
        pixels = image.load()
        data = bytearray(512)
        for y in range(64):
            for x in range(64):
                r, g, b, a = pixels[x, y]
                if a >= 128 and 299*r + 587*g + 114*b >= 128000:
                    data[y*8 + x//8] |= 1 << (7-(x%8))
    output.mkdir(mode=0o700)
    for name, content in [('HUDICON.BIN', bytes(data)),
                          ('HUDICON.hex', ''.join(f'{b:02x}\n' for b in data).encode())]:
        with (output/name).open('xb') as stream:
            stream.write(content)
    metadata = {'dimensions':[64,64], 'bytes':512, 'row_order':'top to bottom',
                'byte_order':'8 bytes per row, left to right', 'bit_order':'MSB is leftmost pixel',
                'one':'overlay color', 'zero':'transparent, preserve HUD', 'lba':None,
                'source_sha256':hashlib.sha256(raw).hexdigest(),
                'bitmap_sha256':hashlib.sha256(data).hexdigest()}
    with (output/'bitmap.json').open('x') as stream:
        json.dump(metadata,stream,indent=2)
    return bytes(data), metadata


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path); parser.add_argument('output',type=Path)
    args=parser.parse_args()
    try:
        _, info=convert(args.source,args.output)
        print('512 bytes; SHA256='+info['bitmap_sha256'])
    except (OSError,ValueError) as exc:
        parser.exit(2,str(exc)+'\n')
