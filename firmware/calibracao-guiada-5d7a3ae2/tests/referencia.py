"""Vetores de campo gerados em ponto flutuante; referencia independente do RTL."""
import math,json
from pathlib import Path
root=Path(__file__).resolve().parent
vectors=root/'vetores';vectors.mkdir(exist_ok=True)
def field(cx,cy,rx,ry,phase=0,noise=False,rot=0):
    result=[]
    a=math.radians(rot)
    for i in range(72):
        t=math.radians(i*5+phase);x=rx*math.cos(t);y=ry*math.sin(t)
        n=((i*17)%5-2) if noise else 0
        result.append((round(cx+x*math.cos(a)-y*math.sin(a))+n,round(cy+x*math.sin(a)+y*math.cos(a))-n,300))
    return result
cases={
 'diagonal':(field(200,-120,400,250),field(200,-120,400,250,2.5),True),
 'hard_iron':(field(300,-200,350,350),field(300,-200,350,350,2.5),True),
 'noise':(field(200,-120,400,250,noise=True),field(200,-120,400,250,2.5,True),True),
 'rotated_soft_iron':(field(200,-120,500,200,rot=35),field(200,-120,500,200,2.5,rot=35),False),
}
train,valid,_=cases['diagonal']
cases['holdout_arc']=(train,[valid[i%10] for i in range(72)],False)
cases['holdout_cluster']=(train,[(valid[0][0]+i%5,valid[0][1]+i//5,300) for i in range(72)],False)
cases['holdout_outlier']=(train,[(1800,1600,300)]+valid[1:],False)
cases['interference']=(train,[(x+(300 if i%2 else -300),y,z) for i,(x,y,z) in enumerate(valid)],False)
cases['z_interference']=(train,[(x,y,z+100) for x,y,z in valid],False)
cases['training_outlier']=([(1500,-120,300)]+train[1:],valid,False)
cases['stationary']=([(200,-120,300)]*72,valid,False)
cases['limited_arc']=(train[:10]*7+[train[0]]*2,valid,False)
cases['no_improvement']=([],[],False)
for phase,key in [(0,0),(2.5,1)]:
 rows=[]
 for i in range(72):
  t=math.radians(i*5+phase)
  rows.append((round(67+400*math.cos(t)*4096/3923),round(-181+400*math.sin(t)*4096/4004),300))
 old=list(cases['no_improvement']);old[key]=rows;cases['no_improvement']=tuple(old)
manifest={}
for name,(a,b,accept) in cases.items():
 for suffix,rows in [('train',a),('holdout',b)]:
  (vectors/f'{name}-{suffix}.hex').write_text(''.join(''.join(f'{v&65535:04x}' for v in row)+'\n' for row in rows))
 ox=(min(x for x,y,z in a)+max(x for x,y,z in a))//2
 oy=(min(y for x,y,z in a)+max(y for x,y,z in a))//2
 dx=max(x for x,y,z in a)-min(x for x,y,z in a);dy=max(y for x,y,z in a)-min(y for x,y,z in a)
 gx=2097152//dx if dx else 0;gy=2097152//dy if dy else 0
 heading=[];corrected=[]
 for x,y,z in b:
  cx=((x-ox)*gx)//4096;cy=((y-oy)*gy)//4096
  corrected.append(f'{cx&65535:04x}{cy&65535:04x}')
  heading.append(int(math.floor((math.degrees(math.atan2(-cy,-cx))+81)%360+0.5))%360)
 (vectors/f'{name}-corrected.hex').write_text('\n'.join(corrected)+'\n')
 (vectors/f'{name}-heading.hex').write_text(''.join(f'{h:03x}\n' for h in heading))
 manifest[name]={'expect_accept':accept,'offset':[ox,oy],'gain_q12':[gx,gy],'training_samples':len(a),'holdout_samples':len(b)}
(root/'referencia.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(f'Referencia Python:{len(cases)} cenarios, treino e holdout disjuntos; atan2 independente')
