#!/usr/bin/env python3
"""Le FAT32 e valida HUDVIDEO.BIN contiguo contra a copia local. Nunca escreve no dispositivo."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import struct
from convert_video_for_fpga import parse_header


def inspect(device, reference):
    mode = device.stat().st_mode
    if not (stat.S_ISBLK(mode) or stat.S_ISREG(mode)):
        raise ValueError('Esperado dispositivo ou imagem regular')
    if not stat.S_ISREG(reference.lstat().st_mode):
        raise ValueError('Referencia deve ser arquivo regular, nunca dispositivo/link')
    size = reference.stat().st_size
    with reference.open('rb') as stream:
        info = parse_header(stream.read(512))
    if size != info['total_bytes']:
        raise ValueError('Referencia truncada ou com bytes excedentes')
    fd = os.open(device, os.O_RDONLY | os.O_CLOEXEC)
    def read(offset, size):
        data = os.pread(fd, size, offset)
        if len(data) != size:
            raise ValueError('Leitura incompleta')
        return data
    def sector(lba, count=1):
        return read(lba*512, count*512)
    u16 = lambda b, o: struct.unpack_from('<H', b, o)[0]
    u32 = lambda b, o: struct.unpack_from('<I', b, o)[0]
    try:
        capacity = os.lseek(fd,0,os.SEEK_END)
        mbr = sector(0)
        if mbr[510:] != b'\x55\xaa':
            raise ValueError('MBR invalido')
        entries = [mbr[446+i*16:462+i*16] for i in range(4)]
        parts = [e for e in entries if e[4] in (0x0b, 0x0c)]
        if len(parts) != 1:
            raise ValueError('Particao FAT32 ausente ou ambigua')
        start, total = u32(parts[0], 8), u32(parts[0], 12)
        if not start or not total or (start+total)*512 > capacity:
            raise ValueError('Particao fora da capacidade do dispositivo')
        boot = sector(start)
        spc, reserved, fats, fatsize = boot[13], u16(boot,14), boot[16], u32(boot,36)
        if (boot[510:] != b'\x55\xaa' or u16(boot,11) != 512 or
                u16(boot,17) or u16(boot,22) or not spc or spc & (spc-1) or
                spc > 128 or fats not in (1,2) or not fatsize or not reserved or
                u32(boot,32) != total or u16(boot,40) & 0x80):
            raise ValueError('Geometria FAT32 invalida ou FAT ativo nao suportado')
        data_start = start+reserved+fats*fatsize
        clusters = (total-reserved-fats*fatsize)//spc
        if clusters < 65525 or clusters+2 > fatsize*128:
            raise ValueError('Quantidade de clusters FAT32 invalida')
        fat = sector(start+reserved, fatsize)
        for i in range(1, fats):
            if sector(start+reserved+i*fatsize, fatsize) != fat:
                raise ValueError('Copias FAT divergem')
        def chain(first):
            seen = set()
            while first < 0x0ffffff8:
                if first < 2 or first >= clusters+2 or first in seen:
                    raise ValueError('Cadeia FAT invalida/ciclica')
                seen.add(first)
                yield first
                first = u32(fat, first*4) & 0x0fffffff
        entry = None
        for cluster in chain(u32(boot,44)):
            block = sector(data_start+(cluster-2)*spc, spc)
            for i in range(0,len(block),32):
                e = block[i:i+32]
                if e[0] == 0:
                    break
                if e[0] != 0xe5 and not e[11] & 0x18 and e[:11] == b'HUDVIDEOBIN':
                    if entry is not None:
                        raise ValueError('Nome de arquivo duplicado')
                    entry = e
            if block[i] == 0:
                break
        if entry is None or u32(entry,28) != size:
            raise ValueError('HUDVIDEO.BIN ausente ou tamanho diferente')
        first = (u16(entry,20)<<16) | u16(entry,26)
        file_clusters = list(chain(first))
        needed = (size+spc*512-1)//(spc*512)
        if len(file_clusters) != needed:
            raise ValueError('Alocacao FAT nao corresponde ao arquivo')
        extents = []
        for cluster in file_clusters:
            lba = data_start+(cluster-2)*spc
            if extents and extents[-1]['lba']+extents[-1]['sectors'] == lba:
                extents[-1]['sectors'] += spc
            else:
                extents.append(dict(lba=lba,sectors=spc))
        if len(extents) != 1:
            raise ValueError(f'Arquivo fragmentado ({len(extents)} extensoes); build contiguo recusado')
        lba = extents[0]['lba']
        digest = hashlib.sha256()
        with reference.open('rb') as stream:
            for offset in range(0,size,1024*1024):
                expected = stream.read(min(1024*1024,size-offset))
                actual = read(lba*512+offset,len(expected))
                if not expected or actual != expected:
                    raise ValueError('Conteudo fisico difere da referencia local')
                digest.update(actual)
        free = sum((u32(fat,c*4)&0x0fffffff)==0 for c in range(2,clusters+2))
        return {**info, 'device':str(device.resolve()), 'file':'HUDVIDEO.BIN',
                'reference':str(reference.resolve()), 'sha256':digest.hexdigest(),
                'mbr_sha256':hashlib.sha256(mbr).hexdigest(), 'partition_start':start,
                'free_bytes':free*spc*512, 'lba':lba, 'file_sectors':size//512,
                'extents':extents, 'contiguous_verified':True, 'device_writes':False}
    finally:
        os.close(fd)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('device',type=Path)
    p.add_argument('reference',type=Path)
    p.add_argument('output',type=Path)
    a=p.parse_args()
    try:
        result=inspect(a.device,a.reference)
        with a.output.open('x') as stream:
            json.dump(result,stream,indent=2)
        print(json.dumps(result,indent=2))
    except (OSError,ValueError) as exc:
        p.exit(2,str(exc)+'\n')


if __name__=='__main__':
    main()
