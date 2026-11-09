#!/usr/bin/env python3
"""Amostra de compressao sem perdas para estudar throughput; nao gera video nem altera o original."""
import argparse
import json
import math
from pathlib import Path
from convert_video_for_fpga import parse_header


def packbits(data):
    out = bytearray()
    i = 0
    while i < len(data):
        run = 1
        while run < 128 and i+run < len(data) and data[i+run] == data[i]:
            run += 1
        if run >= 3:
            out.extend((257-run, data[i]))
            i += run
        else:
            start = i
            i += run
            while i < len(data) and i-start < 128:
                run = 1
                while run < 3 and i+run < len(data) and data[i+run] == data[i]:
                    run += 1
                if run >= 3:
                    break
                i += min(run, 128-(i-start))
            out.append(i-start-1)
            out.extend(data[start:i])
    return bytes(out)


def unpackbits(data, limit):
    out = bytearray()
    i = 0
    while i < len(data):
        control = data[i]
        i += 1
        if control < 128:
            n = control+1
            if i+n > len(data):
                raise ValueError('Literal truncado')
            out.extend(data[i:i+n])
            i += n
        elif control > 128:
            if i == len(data):
                raise ValueError('Repeticao truncada')
            out.extend(bytes([data[i]])*(257-control))
            i += 1
        if len(out) > limit:
            raise ValueError('Quadro excede limite')
    return bytes(out)


def analyze(path, samples):
    if samples < 2:
        raise ValueError('Minimo de duas amostras')
    rows = []
    with path.open('rb') as f:
        header = parse_header(f.read(512))
        count = header['frame_count']
        indexes = sorted({round(i*(count-1)/(samples-1)) for i in range(samples)})
        for index in indexes:
            f.seek(512+index*header['frame_stride'])
            data = f.read(header['frame_bytes'])
            if len(data) != header['frame_bytes']:
                raise ValueError('Quadro truncado')
            encoded = packbits(data)
            if unpackbits(encoded, len(data)) != data:
                raise ValueError('Roundtrip incorreto')
            # Hipotese de protocolo futuro: 8 bytes tamanho/CRC por quadro e alinhamento a setor.
            rows.append(dict(index=index, raw_bytes=len(data), packbits_bytes=len(encoded),
                             hypothetical_sectors=math.ceil((len(encoded)+8)/512)))
    mean_sectors = sum(r['hypothetical_sectors'] for r in rows)/len(rows)
    return dict(scope='Amostra, nao pior caso do filme nem codec FPGA implementado',
                original_unchanged=True, header=header, samples=rows,
                mean_ratio=sum(r['packbits_bytes'] for r in rows)/len(rows)/header['frame_bytes'],
                max_sample_ratio=max(r['packbits_bytes'] for r in rows)/header['frame_bytes'],
                assumed_frame_framing_bytes=8,
                required_sck_hz_at_30fps_zero_nac=mean_sectors*4193*30,
                hypothetical_12mhz5_mean_frame_ms_zero_nac=mean_sectors*4193/12500,
                hypothetical_12mhz5_mean_frame_ms_nac100us=mean_sectors*(4193/12500+0.1),
                physical_validation=False)


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('video', type=Path)
    p.add_argument('--samples', type=int, default=64)
    args = p.parse_args()
    print(json.dumps(analyze(args.video, args.samples), indent=2))
