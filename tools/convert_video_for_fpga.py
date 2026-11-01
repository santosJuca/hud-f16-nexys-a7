#!/usr/bin/env python3
"""Converte video com FFmpeg para HUDVIDEO.BIN RGB332; cria apenas diretorio novo."""
import argparse
import binascii
import hashlib
import json
from pathlib import Path
import stat
import struct
import subprocess
import tempfile
import uuid

HEADER = struct.Struct('<8s6H5I16s8x')
MAGIC = b'HUDVID1\0'


def parse_header(data):
    if len(data) != 512:
        raise ValueError('Cabecalho exige 512 bytes')
    magic, version, header_bytes, width, height, fps, fmt, count, size, stride, total, offset, sequence = HEADER.unpack(data[:64])
    if (magic != MAGIC or version != 1 or header_bytes != 512 or fmt != 1 or
            (width, height) not in ((320, 240), (160, 120)) or not 1 <= fps <= 60 or
            count < 2 or size != width*height or stride != (size+511)//512*512 or
            total != 512+count*stride or offset != 1 or not any(sequence) or any(data[56:])):
        raise ValueError('Cabecalho HUDVIDEO invalido')
    return dict(version=version, width=width, height=height, fps=fps,
                pixel_format='RGB332', frame_count=count, frame_bytes=size,
                frame_stride=stride, total_bytes=total, data_sector=offset,
                sequence_id=sequence.hex())


def convert(source, output, width=320, height=240, fps=10, synthetic=False, seconds=2):
    if (width, height) not in ((320, 240), (160, 120)) or not 1 <= fps <= 60:
        raise ValueError('Perfil invalido')
    if synthetic:
        origin = 'FFmpeg testsrc2 (sintetico local)'
        inputs = ['-f', 'lavfi', '-i', f'testsrc2=size={width}x{height}:rate={fps}', '-t', str(seconds)]
    else:
        if source is None or not stat.S_ISREG(source.lstat().st_mode):
            raise ValueError('Entrada deve ser arquivo regular')
        origin = str(source.resolve())
        inputs = ['-i', origin]
    output.mkdir(mode=0o700)
    target = output/'HUDVIDEO.BIN'
    command = ['ffmpeg', '-v', 'error', '-nostdin', '-threads', '1', *inputs,
               '-an', '-vf', f'scale={width}:{height}:flags=area,fps={fps}',
               '-pix_fmt', 'rgb24', '-threads', '1', '-f', 'rawvideo', 'pipe:1']
    frame_bytes = width*height
    stride = (frame_bytes+511)//512*512
    sequence = uuid.uuid4().bytes
    frames = []
    with tempfile.TemporaryFile() as errors, target.open('xb') as out:
        out.write(bytes(512))
        proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=errors)
        try:
            while True:
                raw = proc.stdout.read(frame_bytes*3)
                if not raw:
                    break
                if len(raw) != frame_bytes*3:
                    raise ValueError('Quadro RGB24 incompleto')
                packed = bytes((raw[i]&0xe0) | ((raw[i+1]>>3)&0x1c) | (raw[i+2]>>6)
                               for i in range(0, len(raw), 3))
                padded = packed+bytes(stride-frame_bytes)
                if 512+(len(frames)+1)*stride > 0xffffffff:
                    raise ValueError('Arquivo excede limite FAT32/RTL de 32 bits')
                out.write(padded)
                frames.append({'index': len(frames), 'sha256': hashlib.sha256(packed).hexdigest(),
                               'sector_crc16': [f'{binascii.crc_hqx(padded[i:i+512],0):04X}'
                                                for i in range(0, stride, 512)]})
            if proc.wait() != 0:
                errors.seek(0)
                raise ValueError('FFmpeg falhou: '+errors.read().decode(errors='replace'))
            if len(frames) < 2:
                raise ValueError('Video exige pelo menos dois quadros')
            total = 512+len(frames)*stride
            header = HEADER.pack(MAGIC, 1, 512, width, height, fps, 1, len(frames),
                                 frame_bytes, stride, total, 1, sequence)+bytes(448)
            out.seek(0)
            out.write(header)
        finally:
            if proc.poll() is None:
                proc.kill()
                proc.wait()
            proc.stdout.close()
    digest = hashlib.sha256()
    with target.open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024), b''):
            digest.update(block)
    info = {**parse_header(header), 'sha256': digest.hexdigest(), 'source': origin,
            'synthetic': synthetic, 'ffmpeg_command': command, 'frames': frames,
            'physical_validation': False}
    with (output/'metadata.json').open('x') as stream:
        json.dump(info, stream, indent=2)
    return info


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('output', type=Path)
    p.add_argument('--input', type=Path)
    p.add_argument('--synthetic', action='store_true')
    p.add_argument('--width', type=int, choices=(160, 320), default=320)
    p.add_argument('--fps', type=int, default=10)
    p.add_argument('--seconds', type=int, default=2)
    a = p.parse_args()
    try:
        if a.synthetic == (a.input is not None) or a.seconds < 1:
            raise ValueError('Escolha --input VIDEO ou --synthetic')
        info = convert(a.input, a.output, a.width, a.width*3//4, a.fps, a.synthetic, a.seconds)
        print(json.dumps({k: v for k, v in info.items() if k != 'frames'}, indent=2))
    except (OSError, ValueError) as exc:
        p.exit(2, str(exc)+'\n')


if __name__ == '__main__':
    main()
