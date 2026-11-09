#!/usr/bin/env python3
"""Confere arquivo local, hashes de quadro e CRC16 de setores. Somente leitura."""
import binascii
import hashlib
import json
from pathlib import Path
import sys
from convert_video_for_fpga import parse_header


def verify(directory):
    directory = Path(directory)
    metadata = json.loads((directory / 'metadata.json').read_text())
    whole = hashlib.sha256()
    sectors = 0
    with (directory / 'HUDVIDEO.BIN').open('rb') as stream:
        header_bytes = stream.read(512)
        header = parse_header(header_bytes)
        whole.update(header_bytes)
        if len(metadata['frames']) != header['frame_count']:
            raise ValueError('Numero de quadros diverge dos metadados')
        for index, expected in enumerate(metadata['frames']):
            frame = stream.read(header['frame_stride'])
            if len(frame) != header['frame_stride'] or expected['index'] != index:
                raise ValueError(f'Quadro incompleto ou fora de ordem: {index}')
            pixels = frame[:header['frame_bytes']]
            if hashlib.sha256(pixels).hexdigest() != expected['sha256']:
                raise ValueError(f'Hash de quadro incorreto: {index}')
            crc = [f'{binascii.crc_hqx(frame[i:i+512], 0):04X}'
                   for i in range(0, len(frame), 512)]
            if crc != expected['sector_crc16']:
                raise ValueError(f'CRC16 de setor incorreto: quadro {index}')
            sectors += len(crc)
            whole.update(frame)
        if stream.read(1):
            raise ValueError('Dados excedentes apos o ultimo quadro')
    if (directory / 'HUDVIDEO.BIN').stat().st_size != header['total_bytes']:
        raise ValueError('Tamanho do arquivo incorreto')
    if whole.hexdigest() != metadata['sha256']:
        raise ValueError('Hash integral incorreto')
    return dict(status='PASS', file=str((directory/'HUDVIDEO.BIN').resolve()),
                **header, sha256=whole.hexdigest(), crc16_sectors_checked=sectors,
                physical_validation=False)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('USO: verify_video.py diretorio-de-conversao')
    print(json.dumps(verify(sys.argv[1]), indent=2))
