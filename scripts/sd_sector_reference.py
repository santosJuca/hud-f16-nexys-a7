#!/usr/bin/env python3
"""Prepara uma referencia local de setor; recusa dispositivos e nao escreve no cartao."""
import argparse
import binascii
import hashlib
import json
import os
from pathlib import Path
import stat


def sector_file(path):
    if not stat.S_ISREG(path.lstat().st_mode):
        raise ValueError('A entrada deve ser arquivo regular, nunca dispositivo ou link')
    with path.open('rb') as stream:
        if not stat.S_ISREG(os.fstat(stream.fileno()).st_mode):
            raise ValueError('A entrada deve ser arquivo regular, nunca dispositivo')
        data = stream.read(513)
    if len(data) != 512:
        raise ValueError('A referencia deve conter exatamente 512 bytes')
    return data


def write_private(path, data):
    with path.open('xb') as stream:
        os.chmod(path, 0o600)
        stream.write(data)


def prepare(reference, output, lba):
    data = sector_file(reference)
    output.mkdir(mode=0o700)
    write_private(output / 'sector_reference.bin', data)
    write_private(output / 'sector_reference.hex', ''.join(f'{b:02x}\n' for b in data).encode())
    write_private(output / 'sector_reference.hexdump', ''.join(
        f'{offset:04x}: ' + data[offset:offset+16].hex(' ') + '\n'
        for offset in range(0, 512, 16)).encode())
    info = {'lba': lba, 'size': 512, 'sha256': hashlib.sha256(data).hexdigest(),
            'crc16': f'{binascii.crc_hqx(data, 0):04X}',
            'origin': str(reference.resolve()), 'fpga_read_verified': False}
    write_private(output / 'reference.json', json.dumps(info, indent=2).encode())
    return info


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('reference', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--lba', type=int, default=0)
    args = parser.parse_args()
    try:
        if not 0 <= args.lba <= 0xffffffff:
            raise ValueError('LBA fora de 32 bits')
        prepare(args.reference, args.output, args.lba)
        print('Referencia preparada:', args.output)
    except (OSError, ValueError) as exc:
        parser.exit(2, str(exc) + '\n')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
