#!/usr/bin/env python3
"""Compara amostras locais em RGB332 usando a expansao de cores real do RTL."""
import argparse
import hashlib
import json
import math
from pathlib import Path
import subprocess
from PIL import Image,ImageChops,ImageDraw,ImageFilter,ImageStat


def extract(source,time,scaler,fmt):
    vf=f'scale=320:240:flags={scaler}:force_original_aspect_ratio=decrease,pad=320:240:(ow-iw)/2:(oh-ih)/2,setsar=1'
    return subprocess.run(['ffmpeg','-v','error','-nostdin','-threads','1','-ss',str(time),'-i',str(source),
        '-frames:v','1','-an','-vf',vf,'-pix_fmt',fmt,'-threads','1','-f','rawvideo','pipe:1'],
        check=True,stdout=subprocess.PIPE).stdout


def rtl_rgb(packed):
    rgb=bytearray()
    for byte in packed:
        r=(byte>>5)&7;g=(byte>>2)&7;b=byte&3
        rgb.extend((((r<<1)|(r>>2))*17,((g<<1)|(g>>2))*17,((b<<2)|b)*17))
    return Image.frombytes('RGB',(320,240),bytes(rgb))


def compare(source,out):
    out.mkdir(parents=True,exist_ok=False)
    candidates=[]
    for time in (1,45,90,150,210,270,360,450,540):
        raw=extract(source,time,'area','rgb24')
        if len(raw)!=320*240*3:raise ValueError('Quadro incompleto')
        img=Image.frombytes('RGB',(320,240),raw)
        next_image=Image.frombytes('RGB',(320,240),extract(source,time+0.1,'area','rgb24'))
        active=img.crop((0,30,320,210));gray=active.convert('L')
        candidates.append(dict(time=time,raw=raw,image=img,
            brightness=ImageStat.Stat(gray).mean[0],
            detail=ImageStat.Stat(gray.filter(ImageFilter.FIND_EDGES)).mean[0],
            motion=sum(ImageStat.Stat(ImageChops.difference(img,next_image)).mean)/3))
    selected=[]
    for name,metric,reverse in (('escura','brightness',False),('clara','brightness',True),('detalhe','detail',True),('movimento','motion',True)):
        row=sorted((c for c in candidates if c not in [s[1] for s in selected]),key=lambda c:c[metric],reverse=reverse)[0]
        selected.append((name,row))
    profiles=(('area_sem_dither','area',False),('area_rgb8','area',True),('bicubic_rgb8','bicubic',True),('lanczos_rgb8','lanczos',True))
    sheet=Image.new('RGB',(5*320,4*270),(20,20,20));draw=ImageDraw.Draw(sheet)
    results=[]
    for y,(scene,row) in enumerate(selected):
        ref=row['image'];sheet.paste(ref,(0,y*270+30));draw.text((4,y*270+5),f'{scene} t={row["time"]}s | referencia RGB24',fill='white')
        ref.save(out/f'{scene}-referencia.png')
        for x,(name,scaler,native) in enumerate(profiles,1):
            if native:packed=extract(source,row['time'],scaler,'rgb8')
            else:
                raw=row['raw'];packed=bytes((raw[i]&224)|((raw[i+1]>>3)&28)|(raw[i+2]>>6) for i in range(0,len(raw),3))
            img=rtl_rgb(packed);img.save(out/f'{scene}-{name}.png')
            sheet.paste(img,(x*320,y*270+30));draw.text((x*320+4,y*270+5),name,fill='white')
            diff=ImageChops.difference(ref.crop((0,30,320,210)),img.crop((0,30,320,210)))
            mse=sum(ImageStat.Stat(diff).sum2)/(320*180*3)
            smooth_diff=ImageChops.difference(ref.filter(ImageFilter.BoxBlur(2)).crop((0,30,320,210)),
                img.filter(ImageFilter.BoxBlur(2)).crop((0,30,320,210)))
            smooth_mse=sum(ImageStat.Stat(smooth_diff).sum2)/(320*180*3)
            results.append(dict(scene=scene,time=row['time'],profile=name,psnr_db=10*math.log10(255*255/mse),
                mse=mse,psnr_spatial_5x5_db=10*math.log10(255*255/smooth_mse),sha256=hashlib.sha256(packed).hexdigest(),
                brightness=row['brightness'],motion=row['motion'],detail=row['detail']))
    sheet.save(out/'comparativo.png')
    metadata=dict(source=str(source.resolve()),palette='RTL VGA de 12 bits, expandida para RGB24',
        reference='area RGB24; PSNR inclui a diferenca do filtro e nao substitui avaliacao visual',samples=results)
    (out/'comparativo.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print(json.dumps({p:sum(r['psnr_db'] for r in results if r['profile']==p)/4 for p,_,_ in profiles},indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path);parser.add_argument('output',type=Path)
    args=parser.parse_args();compare(args.source,args.output)
