#!/usr/bin/env python3
"""Localiza somente HUDICON.BIN na raiz FAT32 e confere o setor; dispositivo O_RDONLY."""
import argparse, binascii, hashlib, json, os, stat, struct
from pathlib import Path


def inspect(device, expected_sha):
    if not stat.S_ISBLK(device.stat().st_mode):
        raise ValueError('Esperado dispositivo de bloco')
    sys=Path('/sys/class/block')/device.name
    capacity=int((sys/'size').read_text())*512
    if capacity!=31914983424 or (sys/'removable').read_text().strip()!='1':
        raise ValueError('Capacidade/removibilidade diferente do QD101 confirmado')
    fd=os.open(device,os.O_RDONLY|os.O_CLOEXEC)
    def sector(lba, count=1):
        if lba<0 or (lba+count)*512>capacity: raise ValueError('LBA fora do dispositivo')
        data=os.pread(fd,count*512,lba*512)
        if len(data)!=count*512: raise ValueError('Leitura incompleta')
        return data
    u16=lambda b,o:struct.unpack_from('<H',b,o)[0]
    u32=lambda b,o:struct.unpack_from('<I',b,o)[0]
    try:
        mbr=sector(0)
        if hashlib.sha256(mbr).hexdigest()!='6f29a2a768e00982b8777bfae1feb7fc0241b57d7ff0ff81b95f8bf7b8627698':
            raise ValueError('MBR nao corresponde a referencia P0')
        entries=[mbr[446+i*16:462+i*16] for i in range(4)]
        parts=[e for e in entries if e[4] in (0x0b,0x0c)]
        if len(parts)!=1: raise ValueError('Particao FAT32 ambigua')
        start=u32(parts[0],8);total=u32(parts[0],12);boot=sector(start)
        if boot[510:]!=b'\x55\xaa' or u16(boot,11)!=512 or u16(boot,17)!=0 or u16(boot,22)!=0:
            raise ValueError('BPB FAT32 invalido')
        spc=boot[13];reserved=u16(boot,14);fats=boot[16];fatsize=u32(boot,36)
        if not spc or spc&(spc-1) or spc>128 or fats not in (1,2) or not fatsize:
            raise ValueError('Geometria FAT32 invalida')
        firstdata=start+reserved+fats*fatsize;cluster=u32(boot,44);seen=set()
        for _ in range(10000):
            if cluster in seen or cluster<2 or cluster>=0x0ffffff8:break
            seen.add(cluster);lba=firstdata+(cluster-2)*spc
            if lba+spc>start+total: raise ValueError('Diretorio fora da particao')
            block=sector(lba,spc)
            for offset in range(0,len(block),32):
                e=block[offset:offset+32]
                if e[0]==0: raise ValueError('HUDICON.BIN ausente')
                if e[0]==0xe5 or e[11]&0x18 or e[11]==0x0f:continue
                if e[:11]!=b'HUDICON BIN':continue
                if u32(e,28)!=512: raise ValueError('Arquivo nao tem 512 bytes')
                first=(u16(e,20)<<16)|u16(e,26)
                asset=firstdata+(first-2)*spc
                if first<2 or asset>=start+total:raise ValueError('Cluster do bitmap invalido')
                data=sector(asset);sha=hashlib.sha256(data).hexdigest()
                if sha!=expected_sha:raise ValueError('Setor fisico difere do bitmap local')
                return {'device':str(device),'partition_start':start,'sectors_per_cluster':spc,
                        'file':'HUDICON.BIN','size':512,'first_cluster':first,'lba':asset,
                        'sha256':sha,'crc16':f'{binascii.crc_hqx(data,0):04X}',
                        'mbr_matches_p0':True,'raw_device_writes':False}
            pos=cluster*4
            if pos//512>=fatsize:raise ValueError('Indice FAT fora da tabela')
            cluster=u32(sector(start+reserved+pos//512),pos%512)&0x0fffffff
        raise ValueError('Cadeia de diretorio invalida ou limite excedido')
    finally:os.close(fd)


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('device',type=Path);p.add_argument('--sha256',required=True)
    args=p.parse_args()
    try:print(json.dumps(inspect(args.device,args.sha256),indent=2))
    except (OSError,ValueError) as exc:p.exit(2,str(exc)+'\n')
