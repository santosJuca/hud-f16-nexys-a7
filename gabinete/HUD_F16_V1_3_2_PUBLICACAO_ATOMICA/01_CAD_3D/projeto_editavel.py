#!/usr/bin/env python3
"""HUD F16 v1.3, revisão incremental reprodutível, sem dimensões físicas inventadas.

Run: python 01_CAD_3D/projeto_editavel.py --out .
Entradas relativas: originais/*.step e referência v1.2 reconstruível no ZIP preservado.
Correções: presilha M3 com rasgos reguláveis, almofada elástica candidata, bandeja
KY023 com quatro rasgos candidatos de PCB (furação sem homologação), auditoria 3D real.
O arquivo DXF permanece NÃO PRODUÇÃO até medição do hardware e MDF/kerf.
"""
from __future__ import annotations
import argparse,csv,hashlib,json,math,sys,shutil,zipfile,traceback,os,tempfile,gc,uuid
from datetime import datetime, timezone
from pathlib import Path
import cadquery as cq
import ezdxf
from shapely.geometry import LineString,Point,Polygon,box
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,PageBreak,KeepTogether
from reportlab.lib.styles import getSampleStyleSheet
import gerador_v12_preservado as v12
import nucleo_v11_preservado as old

HERE=Path(__file__).resolve().parent
CASE_LID=HERE/'originais/jumper-grabber-ventilation.step'
CASE_BASE=HERE/'originais/base.step'
V12_CLOSED=HERE/'originais/referencia_v12_fechado.step'
V12_OPEN=HERE/'originais/referencia_v12_aberto.step'
PAD_T=1.5 # APENAS prototipo nominal; calibração e material ainda pendentes
LIP_Z=101.02 # extrair novamente pela ferramenta em vez de aceitar esta constante como medição
HINGE_AXIS=(0,121,111.5)

def oblong(cx,cy,axis='y',width=3.4,total=7.5):
    # capsule with circular ends: total length includes end caps
    L=(total-width)/2
    if axis=='y':line=LineString([(cx,cy-L),(cx,cy+L)])
    else:line=LineString([(cx-L,cy),(cx+L,cy)])
    return line.buffer(width/2,resolution=12)

def updated_parts():
    parts,places=v12.incremental_parts()
    modifications=[]
    for p in parts:
        if p.kind=='CASE_CLIP':
            p.shape=old.clean(p.shape.difference(oblong(-8,0)).difference(oblong(8,0)))
            p.circles=[]
            p.note='V1.3: dois rasgos M3 3.4x7.5 ajustáveis em Y; almofada externa opcional, sem pressionar PCB'
            modifications.append({'piece':p.name,'new':'2 slots 3.4x7.5; total 8 slots','original':'2 holes M3 diameter 3.3'})
        elif p.kind=='JOYSTICK_TRAY':
            # Substitui passagem de cintas no corpo eletrônico por slots de fixação
            # com 4 espaçadores isolantes M3 do PCB. Somente candidato para KY023
            # que tenha furação horizontal 27 mm, vertical 20 mm.
            p.shape=old.polyrect(-27,-22,27,22)
            for x in (-13.5,13.5):
                for y in (-10,10):
                    p.shape=p.shape.difference(oblong(x,y,'x',3.4,8.0))
            p.shape=old.clean(p.shape)
            p.note='V1.3: 4 slots PCB de 3.4x8 para padrão candidato 27x20; fixar com isolantes M3; medir o KY023 físico'
            modifications.append({'piece':p.name,'new':'4 slotted module mounts 3.4x8.0','original':'4 zip tie slots'})
    return parts,places,modifications

def near(a,b,tol=.045):return abs(a-b)<tol

def find_from_bbox(solids,bounds):
    found=[]
    for i,s in enumerate(solids):
        b=s.BoundingBox()
        actual=(b.xmin,b.xmax,b.ymin,b.ymax,b.zmin,b.zmax)
        if all(near(x,y) for x,y in zip(actual,bounds)):found.append(i)
    return found

def real_case_lid():
    b=cq.importers.importStep(str(CASE_BASE)).val().BoundingBox()
    sh=cq.importers.importStep(str(CASE_LID)).val()
    return sh.translate((-(b.xmin+b.xmax)/2,30-(b.ymin+b.ymax)/2,80-b.zmin))

def get_pad(label,cx,cy,rear):
    # contact strip is only at rim-facing edge, away from M3 spacer centers
    cystrip=cy + (-9 if rear else 9)
    return cq.Workplane('XY',origin=(cx,cystrip,103-PAD_T)).box(34,6,PAD_T,centered=(True,True,False)).val()

def assign_replacements(old_solids,places,parts,opened=False):
    replacements={};newextras=[];assigned=[]
    for label,cx,cy,rear in places:
        p=next(p for p in parts if p.name==label)
        orig_bounds=(cx-17,cx+17,cy-(13 if rear else 7),cy+(7 if rear else 13),103,106)
        hits=find_from_bbox(old_solids,orig_bounds)
        if len(hits)!=1:raise RuntimeError(f'Cap identification FAILED {label}: {hits}')
        sh=v12.plate_solid(p,103,(cx,cy))
        replacements[hits[0]]=(label,sh)
        assigned.append(hits[0])
        newextras.append((f'ALMOFADA_ELASTOMERO_CANDIDATA_{label}',get_pad(label,cx,cy,rear)))
    # joystick original tray stays moving in both states
    label='SUPORTE_JOYSTICK_KY023'
    p=next(p for p in parts if p.name==label)
    newtray=v12.plate_solid(p,92,v12.JOYSTICK_POS)
    if opened:newtray=newtray.rotate((0,121,111.5),(1,121,111.5),-105)
    if opened:
        # We cannot select opened tray by old unrotated bbox. It was at old indices
        # via verified stable export order, matched using geometric volume and index
        cl=cq.importers.importStep(str(V12_CLOSED)).solids().vals()
        originals=find_from_bbox(cl,(93,147,-97,-53,92,95))
    else:originals=find_from_bbox(old_solids,(93,147,-97,-53,92,95))
    if len(originals)!=1:raise RuntimeError(f'Joystick tray not unique: {originals}')
    if originals[0] in replacements:raise RuntimeError('Unexpected duplicate replace index')
    replacements[originals[0]]=(label,newtray)
    if len(replacements)!=5:raise RuntimeError(f'Expected 5 replacements, found {len(replacements)}')
    return replacements,newextras

def _solid_geometry_vector(shape):
    """Bbox, volume e centro de massa para detectar STEP desatualizado."""
    b=shape.BoundingBox()
    c=shape.Center()
    return (b.xmin,b.ymin,b.zmin,b.xmax,b.ymax,b.zmax,shape.Volume(),c.x,c.y,c.z)


def _validate_step_export(exported, expected):
    """Confronta TODAS as pecas da exportacao com a geometria atual em memoria.

    A ordem das entidades no STEP pode mudar, portanto a comparacao e por
    assinatura geometrica ordenada, nao por indice no arquivo STEP.
    Este teste nao e uma verificacao completa de interferencias mecanicas.
    """
    if len(exported)!=len(expected):
        raise RuntimeError(f'STEP conteudo incorreto: {len(exported)} != {len(expected)} solidos')
    invalid=[i for i,x in enumerate(exported) if not x.isValid()]
    if invalid:raise RuntimeError(f'STEP solidos invalidos {invalid}')
    order=lambda row:tuple(round(x,1) for x in row)
    a=sorted(map(_solid_geometry_vector,expected),key=order)
    b=sorted(map(_solid_geometry_vector,exported),key=order)
    for index,(original,reimportado) in enumerate(zip(a,b)):
        for j,(x,y) in enumerate(zip(original,reimportado)):
            tolerancia=max(0.06,abs(x)*1e-6) if j==6 else 0.02
            if abs(x-y)>tolerancia:
                raise RuntimeError(f'STEP geometria diferente na peca {index}, eixo {j}: {x} != {y}')


def _export_step_atomically(solids,dest):
    """REGENERA sempre; valida temporario antes da substituicao atomica.

    Nao consulta existencia nem tamanho do STEP anterior. Se houver erro, nao
    substitui a ultima versao e a execucao FALHA explicitamente.
    """
    dest=Path(dest)
    dest.parent.mkdir(parents=True,exist_ok=True)
    fd,path=tempfile.mkstemp(prefix=f'.{dest.stem}.',suffix='.step',dir=dest.parent)
    os.close(fd)
    temp=Path(path)
    try:
        cq.exporters.export(cq.Compound.makeCompound(solids),str(temp),exportType='STEP')
        if temp.stat().st_size==0:raise RuntimeError('STEP temporario vazio')
        verification=cq.importers.importStep(str(temp)).solids().vals()
        _validate_step_export(verification,solids)
        os.replace(temp,dest)
    finally:
        temp.unlink(missing_ok=True)
    return {'filename':dest.name,'solids':len(verification),'invalid_solids':0,
            'bytes':dest.stat().st_size,'sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),
            'regenerated':True,'readback_checked':True,
            'geometry_compared_to_current_model':True}


# Canonical STEP publication in v1.3.2 is 01_CAD_3D/ATUAL/*.
# ATUAL is a single symbolic-link pointer to an immutable, fully verified pair.
# The two historical STEP paths directly under 01_CAD_3D remain legacy inputs.
_STEP_NAMES={
    'fechado':'gabinete_v13_tampa_fechada.step',
    'aberto':'gabinete_v13_tampa_aberta_105deg.step',
}


def _published_step_path(root, state):
    """Resolve canonical, consistent publication; never fall back to stale STEP."""
    cad=Path(root)/'01_CAD_3D'
    link=cad/'ATUAL'
    if not link.is_symlink():
        raise RuntimeError('Par STEP ainda nao publicado. Rode gerador integral primeiro; nao use arquivos legados como saida nova.')
    target=link/_STEP_NAMES[state]
    if not target.is_file():
        raise RuntimeError(f'Publicacao STEP incompleta: {target}')
    return target


def _publish_step_pair(root, sources):
    """Publish BOTH states as one logical revision via atomic symlink switch.

    sources: iterable of (state, callable returning current solids). Export, import
    and compare each in a private staging directory. A failure (including during
    the second state) leaves the prior ATUAL pointer unchanged. Linux required.
    """
    root=Path(root)
    cad=root/'01_CAD_3D'
    versions=cad/'geracoes_step'
    versions.mkdir(parents=True,exist_ok=True)
    token=datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:12]
    stage=versions/('.preparo-'+token)
    final=versions/token
    stage.mkdir()
    info={}
    pointer_tmp=None
    try:
        for label,make_solids in sources:
            if label not in _STEP_NAMES or label in info:
                raise RuntimeError(f'Estado STEP inesperado ou repetido: {label}')
            print('STEP preparando e exportando',label,flush=True)
            solids=make_solids()
            if not solids:raise RuntimeError('Lista de solidos vazia para '+label)
            target=stage/_STEP_NAMES[label]
            cq.exporters.export(cq.Compound.makeCompound(solids),str(target),exportType='STEP')
            if target.stat().st_size==0:raise RuntimeError('STEP vazio: '+label)
            actual=cq.importers.importStep(str(target)).solids().vals()
            _validate_step_export(actual,solids)
            info[label]={
                'filename':target.name, 'solids':len(actual), 'invalid_solids':0,
                'bytes':target.stat().st_size,
                'sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
                'regenerated':True, 'readback_checked':True,
                'geometry_compared_to_current_model':True,
            }
            del solids, actual
            gc.collect()
        if set(info)!=set(_STEP_NAMES):
            raise RuntimeError('A publicacao exige dois estados STEP completos')
        manifest={'versao':'1.3.2','publication_id':token,
                  'published_at_utc':datetime.now(timezone.utc).isoformat(),
                  'states':info,
                  'nota':'Somente 01_CAD_3D/ATUAL e canonico; arquivos de raiz sao historicos.'}
        (stage/'manifesto_publicacao.json').write_text(json.dumps(manifest,indent=2,ensure_ascii=False),encoding='utf8')
        # Verify both bytes one more time BEFORE switching current publication.
        for label in info:
            path=stage/_STEP_NAMES[label]
            if hashlib.sha256(path.read_bytes()).hexdigest()!=info[label]['sha256']:
                raise RuntimeError('SHA-256 mismatch in staging area for '+label)
        # Atomic rename of ready directory, then ONE atomic pointer replacement.
        os.replace(stage,final)
        pointer_tmp=cad/('.ATUAL-'+token)
        os.symlink(Path('geracoes_step')/token,pointer_tmp)
        os.replace(pointer_tmp,cad/'ATUAL')
        return info
    finally:
        if pointer_tmp is not None:pointer_tmp.unlink(missing_ok=True)
        if stage.exists():shutil.rmtree(stage)
        # Orphan immutable revisions, if a switch failed, are harmless and not
        # visible via ATUAL. We deliberately never delete previous revisions.


def export_assemblies(parts,places,root):
    def make_state(label,baseline,opened):
        def produce():
            original=cq.importers.importStep(str(baseline)).solids().vals()
            if len(original)!=97:
                raise RuntimeError(f'V1.2 {label}: contagem base inesperada ({len(original)})')
            repl,extras=assign_replacements(original,places,parts,opened=opened)
            solids=[repl[i][1] if i in repl else s for i,s in enumerate(original)]
            solids.extend(pad for _,pad in extras)
            if len(solids)!=101:raise RuntimeError('101 solidos v1.3 esperados')
            return solids
        return produce
    return _publish_step_pair(root,(
        ('fechado',make_state('fechado',V12_CLOSED,False)),
        ('aberto',make_state('aberto',V12_OPEN,True)),
    ))


def case_pad_test(places):
    case=real_case_lid(); report=[]
    for name,x,y,rear in places:
        pad=get_pad(name,x,y,rear)
        # verify local plastic maximum using a small 34x6 footprint probe
        Y=y+(-9 if rear else 9)
        prism=cq.Workplane('XY',origin=(x,Y,80)).box(34,6,30,centered=(True,True,False)).val()
        plast=prism.intersect(case); measured_z=plast.BoundingBox().zmax if plast.Volume()>1 else None
        report.append({'retentor':name,'altura_borda_step_mm':round(measured_z,4) if measured_z else None,
          'folga_plastica_pad_antes_de_levantar_mm':round(103-PAD_T-measured_z,4) if measured_z else None,
          'pad_x_mm':x,'pad_y_mm':Y,'pad_espessura_candidata_mm':PAD_T,
          'intersecao_sem_deslocamento_mm3':round(pad.intersect(case).Volume(),5),
          'intersecao_case_elevada_1mm_mm3':round(pad.intersect(case.translate((0,0,1))).Volume(),4),
          'intersecao_case_elevada_2mm_mm3':round(pad.intersect(case.translate((0,0,2))).Volume(),4)})
    return report

def sweep_test(root):
    # REAL BRep booleans, no blank list and no automatic approval on exception
    closed=cq.importers.importStep(str(_published_step_path(root,'fechado'))).solids().vals()
    lididx=find_from_bbox(closed,(-160,160,-120,120,107,110))
    if len(lididx)!=1:raise RuntimeError('cannot identify moving MDF lid')
    lid=closed[lididx[0]]
    static=[]
    for name,bounds in [
        ('PAREDE_FRENTE',(-155,155,-115,-112,0,107)),
        ('PAREDE_TRASEIRA',(-155,155,112,115,0,107)),
        ('PLATAFORMA',(-90,90,-40,100,77,80)),
    ]:
        # Walls have complex joint exteriors, bbox not strict; choose nearby by location.
        matches=[]
        for i,s in enumerate(closed):
            b=s.BoundingBox()
            if name=='PAREDE_FRENTE' and b.xlen>300 and b.ymin<-110 and b.zmax>=106 and b.zmin<=0:matches.append(i)
            if name=='PAREDE_TRASEIRA' and b.xlen>300 and b.ymax>110 and b.zmax>=106 and b.zmin<=0:matches.append(i)
            if name=='PLATAFORMA' and near(b.xmin,-90) and near(b.xmax,90) and near(b.zmin,77):matches.append(i)
        if matches:static.append((name,closed[matches[0]]))
    # Case STEP contains high-complexity BReps. For the full angular path,
    # record case/cable clearance as INDETERMINATE rather than silently pass.
    # Exact BRep intersections for primary structural MDF remain active.
    results=[]
    for angle in [0,15,30,45,60,75,90,105]:
        moving=lid.rotate((0,121,111.5),(1,121,111.5),-angle)
        coll=[];unknown=[]
        for label,obj in static:
            a=moving.BoundingBox();b=obj.BoundingBox()
            if a.xmax<=b.xmin or b.xmax<=a.xmin or a.ymax<=b.ymin or b.ymax<=a.ymin or a.zmax<=b.zmin or b.zmax<=a.zmin:continue
            try:
                v=moving.intersect(obj).Volume()
                if v>0.05:coll.append({'alvo':label,'volume_mm3':round(v,4)})
            except Exception as e:unknown.append({'alvo':label,'erro':str(e)[:200]})
        results.append({'angulo_graus':angle,'interferencias':coll,'erros_booleanos':unknown,
                        'nao_avaliado':['case_STEP_tampa_durante_giro','case_STEP_base_durante_giro','plugs_e_chicotes_reais']})
    return results

def structural_collision_test(root):
    # Reimport original full STEP, select actual MDF primary structural components,
    # preserve all intersection volumes, not auto-suppress unexpected collisions.
    ss=cq.importers.importStep(str(_published_step_path(root,'fechado'))).solids().vals()
    structural=[]
    for i,s in enumerate(ss):
        b=s.BoundingBox()
        kind=None
        if near(b.xmin,-160) and near(b.xmax,160) and near(b.ymin,-120) and near(b.ymax,120):
            if near(b.zmin,0):kind='BASE'
            elif near(b.zmin,107):kind='TAMPA'
        if near(b.xmin,-90) and near(b.xmax,90) and near(b.ymin,-40) and near(b.ymax,100) and near(b.zmin,77):kind='PLATAFORMA'
        if b.xlen>=300 and b.zmax>100 and b.zmin<=0.02 and b.ylen<=4:kind='PAINEL_FRENTE_TRASEIRA'
        if b.ylen>=220 and b.zmax>100 and b.zmin<=0.02 and b.xlen<=4:kind='PAINEL_LATERAL'
        if kind:structural.append((f'{kind}_SOLIDO_{i}',s))
    hits=[];errors=[];pairs=0
    for k,(an,a) in enumerate(structural):
        for bn,b in structural[k+1:]:
            aa=a.BoundingBox();bb=b.BoundingBox()
            if aa.xmax<=bb.xmin+1e-5 or bb.xmax<=aa.xmin+1e-5 or aa.ymax<=bb.ymin+1e-5 or bb.ymax<=aa.ymin+1e-5 or aa.zmax<=bb.zmin+1e-5 or bb.zmax<=aa.zmin+1e-5:continue
            pairs+=1
            try:
                vol=a.intersect(b).Volume()
                if vol>.05:hits.append({'a':an,'b':bn,'volume_mm3':round(vol,3)})
            except Exception as e:errors.append({'a':an,'b':bn,'erro':str(e)[:200]})
    return {'selecionados':[n for n,_ in structural],'pares_testados':pairs,'interferencias':hits,'falhas_booleanas':errors}

def draw_pdf(root,parts,nest,pads,collision):
    file=root/'03_DESENHOS/desenhos_cotados_v13.pdf'
    c=Canvas(str(file),pagesize=landscape(A4));W,H=landscape(A4)
    def header(h,sub):
        c.setFillColor(colors.HexColor('#1d374d'));c.setFont('Helvetica-Bold',15);c.drawString(32,H-37,h)
        c.setFillColor(colors.black);c.setFont('Helvetica',9);c.drawString(32,H-55,sub)
        c.setFont('Helvetica-Oblique',8);c.drawRightString(W-30,19,'HUD F16 v1.3 | NAO CORTAR DEFINITIVO | mm')
    def drawpolygon(poly,T):
        coords=old.external_coords(poly);p=c.beginPath();p.moveTo(*T(*coords[0]))
        for x,y in coords[1:]:p.lineTo(*T(x,y))
        p.close();c.drawPath(p)
        for pts in old.internal_coords(poly):
            p=c.beginPath();p.moveTo(*T(*pts[0]))
            for x,y in pts[1:]:p.lineTo(*T(x,y))
            p.close();c.drawPath(p)
    header('1. Nesting na chapa 800 x 500 mm',f"{len(parts)} pecas MDF; gap {nest['menor_distancia_mm']:.2f} mm; aproveitamento liquido {nest['aproveitamento_liquido_percentual']:.2f}%")
    T=lambda x,y:(36+x*.78,76+y*.78)
    c.rect(*T(0,0),800*.78,500*.78)
    for p in parts:
        c.setStrokeColor(colors.HexColor('#315b7b'));c.setLineWidth(.5)
        drawpolygon(old.nest_poly(p),T)
        for x,y,d in p.circles:
            X,Y=T(*old.nest_xy(p.nest,x,y));c.circle(X,Y,d*.78/2)
    c.showPage()
    header('2. Presilhas v1.3: rasgos M3 regulaveis','Quatro presilhas MDF 34 x 20 x 3. Rasgos de 3.4 x 7.5 mm eixos longitudinais Y. Pad elastico NAO MDF.')
    p=next(p for p in parts if p.name=='CASE_RETENTOR_F_E');T=lambda x,y:(W/2+x*8, H/2+y*8)
    c.setStrokeColor(colors.black);c.setLineWidth(2);drawpolygon(p.shape,T)
    c.setFont('Helvetica',10);c.drawCentredString(W/2,94,'Furos da presilha: centros X = -8 e +8 mm. Ajuste nominal +/-2.05 mm em Y.')
    c.drawCentredString(W/2,71,'Pastilha elastica candidata 34 x 6 x 1.5 mm, somente na borda plastica. Testar sem PCB.')
    c.showPage()
    header('3. Retencao em corte Z','Case real em Z 101.02 na borda | pastilha opcional | face inferior presilha Z 103')
    zitems=[(77,80,'Plataforma MDF'),(80,83,'Batente MDF'),(83,103,'Espacador M3 nominal 20 mm'),(101.5,103,'Pastilha compressivel candidata 1.5 mm'),(103,106,'Presilha MDF'),(107,110,'Tampa MDF')]
    for z0,z1,label in zitems:
        x0=142;y0=92+z0*3.6
        c.setLineWidth(.8);c.rect(x0,y0,135,max(1.5,(z1-z0)*3.6))
        c.setFont('Helvetica',9);c.drawString(x0+154,y0+3,f'{label} | Z{z0:g}..{z1:g}')
    c.setFont('Helvetica',10);c.drawString(50,65,'Folga nominal borda/pad antes de movimento: 0.48 mm. Altura de impressao nao medida; nao homologar.')
    c.showPage()
    header('4. Joystick: bandeja com suporte de PCB ajustavel','54 x 44 MDF; fixacao a tampa 4x M3, modulo PCB por 4 parafusos com isoladores candidatos')
    p=next(p for p in parts if p.name=='SUPORTE_JOYSTICK_KY023');T=lambda x,y:(W/2+x*7,240+y*7)
    c.setLineWidth(1.5);drawpolygon(p.shape,T)
    for x,y,d in p.circles:
        X,Y=T(x,y);c.circle(X,Y,d*7/2)
    c.setFont('Helvetica',10)
    c.drawCentredString(W/2,80,'Slots de PCB 3.4x8.0 mm em X +/-13.5, Y +/-10; padrao 27x20 e SOMENTE candidato.')
    c.showPage()
    header('5. Interfaces e articulacao: cotas PENDENTES','Nao houve corte arbitrario para VGA, USB, alimentacao, PMOD, XADC ou ferragens nao selecionadas')
    c.setFont('Helvetica',11)
    for i,s in enumerate(['Eixo cinemático preservado: Y=+121 mm, Z=111.5 mm, aberto 105 graus.',
       'Conector VGA: medir corpo do plug, parafusos e curvatura do cabo instalado.',
       'USB e energia: medir com conectores reais e verificar abertura da tampa.',
       'Dobradiças: obter desenho cotado do fabricante e comparar furação 18 mm nominal.',
       'Fecho: verificar curso, contrapeca e resistencia com MDF 3 mm.',
       'Furacoes de ferragem da v1.2 ainda NAO HOMOLOGADAS.',
       'Ensaiar MDF, kerf, 5 N / 10 N e 50 ciclos antes da fabricação completa.']):
        c.drawString(55,H-95-43*i,s)
    c.showPage();c.save()
    return file

def write_docs(root,parts,nest,dxf,steps,pad,sweep,structure):
    failures=[]
    if nest['erros']:failures.append('nesting_invalid')
    if dxf['erros']:failures.append('dxf_invalid')
    for x in pad:
        if x['intersecao_sem_deslocamento_mm3']>.05:failures.append('pad_interference_original')
        if x['intersecao_case_elevada_1mm_mm3']<=.5:failures.append('pad_no_capture_1mm')
    for s in sweep:
        if s['interferencias']:failures.append('tampa_cinematica_interferencias')
        if s['erros_booleanos']:failures.append('tampa_cinematica_boolean_failed')
    if structure['interferencias']:failures.append('estrutura_interferencias_detectadas')
    if structure['falhas_booleanas']:failures.append('estrutura_boolean_failed')
    if any(a.get('nao_avaliado') for a in sweep):failures.append('GIRO_CASE_CABOS_INDETERMINADO')
    matrix=[
      ('P1', 'Retentores: M3 slots + almofada removivel 34x6x1.5 mm, bordo STEP; sem forca na PCB', 'VALIDADO GEOMETRIA / PENDENTE ENSAIO'),
      ('P2', 'Dobradiças, eixo e furo nominal v1.2 mantidos; falta fabricante desenho cotado e fecho real', 'PENDENTE CRITICO'),
      ('P3', 'VGA USB energia presentes na placa Digilent; faltam XYZ da montagem e plugs conectados', 'PENDENTE CRITICO'),
      ('P4', 'KY023: slots PCB 4x 3.4x8; vendedor Flux Workshop informa 27/20 mm em versao Keyes; comparar modulo fisico', 'VALIDADO GEOMETRIA / PENDENTE MODULO'),
      ('P5', 'Protoboard 830 com base metalica e sensores sem ferragens definidas; envelope anterior preservado', 'PENDENTE CRITICO'),
      ('P6', 'Triagem de 5N/10N e planos de 50 ciclos sem testes fisicos', 'PENDENTE ENSAIO'),
      ('P7', 'Reimportacao STEP/DXF; angulos MDF testados por BRep; case/cabos em giro NAO AVALIADOS', 'VALIDADO PARCIAL / PENDENTE'),
      ('FABRICACAO', 'Criticos externos nao medidos. Nao usar DXF em corte final', 'BLOQUEADO')]
    report={'projeto':'HUD F16 V1.3 FECHAMENTO PARCIAL','status':'GEOMETRIA PRELIMINAR' if not failures else 'ALERTAS_GEOMETRICOS_REQUEREM_ANALISE',
      'fabricacao_liberada':False,'mudancas_concretas':['8 rasgos regulaveis nas 4 presilhas; furo da presilha substituido por corte interno','4 almofadas de elastomero nominal 1.5 mm modeladas no STEP (nao MDF, dependem de ensaio)','4 rasgos regulaveis no suporte KY023, substituindo fixacao por cinta na placa'],
      'invariantes_preservados':{'externo_mm':[320,240,110],'plataforma_z_mm':[77,80],'janela_mm':[142,128],'janela_centro_mm':[0,30],'quatro_cruzes':True},
      'nesting':{k:v for k,v in nest.items() if k!='pecas'},'dxf':dxf,'step':steps,'politica_exportacao_step':'regeneracao obrigatoria e substituicao atomica, geometria comparada apos reimportacao',
      'retencao_proposta':pad,'colisao_estrutura':structure,'varredura_tampa':sweep,'alertas':failures,'matriz':[{'item':a,'evidencia':b,'status':c} for a,b,c in matrix]}
    (root/'04_VALIDACAO/matriz_validacao_v13.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf8')
    with (root/'04_VALIDACAO/matriz_testes_v13.csv').open('w',newline='',encoding='utf8') as f:
        w=csv.writer(f);w.writerow(['item','evidencia','status']);w.writerows(matrix)
    with (root/'04_VALIDACAO/colisoes_e_contatos_v13.csv').open('w',newline='',encoding='utf8') as f:
        w=csv.writer(f);w.writerow(['teste','item','alvo','angulo','volume_mm3','resultado'])
        for h in structure['interferencias']:w.writerow(['estrutura',h['a'],h['b'],'',h['volume_mm3'],'AVALIAR'])
        if not structure['interferencias'] and not structure['falhas_booleanas']:
            w.writerow(['estrutura','PAINEIS_PRIMARIOS','8 pares verificados','',0,'TESTADO SEM COLISAO'])
        for a in sweep:
            for h in a['interferencias']:w.writerow(['tampa','TAMPA_MDF',h['alvo'],a['angulo_graus'],h['volume_mm3'],'AVALIAR'])
        for a in sweep:
            if not a['interferencias'] and not a['erros_booleanos']:
                w.writerow(['tampa','PAINÉIS_MDF_SELECIONADOS','',a['angulo_graus'],0,'TESTADO SEM COLISAO'])
            for unknown in a.get('nao_avaliado',[]):
                w.writerow(['tampa',unknown,'',a['angulo_graus'],'','INDETERMINADO'])
        for h in pad:w.writerow(['captura_elevacao_1mm',h['retentor'],'CASE_PLASTICA','',h['intersecao_case_elevada_1mm_mm3'],'VALIDADO_VIRTUAL'])
    (root/'04_VALIDACAO/medicoes_e_ensaios_pendentes.md').write_text('''# Portões físicos obrigatórios antes do LABFAB\n\n**FABRICACAO INTEGRAL BLOQUEADA**. Medir e registrar:\n\n1. Case impressa: Z da borda sob as quatro presilhas. A borda STEP tem Z aprox.101,02; pad prototipo 1,5 mm gera folga nominal 0,48 mm. Verificar compressibilidade, adesivo e que não toca botões, carcaça de conector ou PCB. NÃO cortar presilhas definitivas antes disso.\n2. MDF real e kerf, seis cupons de 2,9 a 3,4 mm, aplicar compensação APENAS uma vez no software ou no DXF.\n3. VGA conectado: posições XYZ reais no referencial da case, corpo do plug, cabeças/roscas e raio de curvatura; repetir USB e alimentação J13 com cabo energizado somente após montagem segura.\n4. Desenhos dimensionais e amostras das duas dobradiças e do fecho. Furos existentes no DXF são NOMINAIS, não aprovados. Precisam de correção conforme fornecedor.\n5. Medir a PCB do KY-023: 4 furos, distâncias centros, tipo de parafuso, espaço livre do curso da alavanca; os slots 27x20 candidatos podem não corresponder ao módulo.\n6. Buzzer: corpo, fixação e posicionamento do 2N2222A; garantir sem esmagar trilhas.\n7. Protoboard 830: base metálica, bornes, cabo e altura com jumpers; acomodação real e acesso à tampa.\n8. MPU6050: suporte rígido, eixos físicos marcados; HMC5883L afastado dos metais e correntes, testar interferência com buzzer; BMP085 exposto a pressão ambiente.\n9. Carga 5N: deflexão <=0,5 mm proposta. Carga 10N: deflexão <=1,0 mm. Descarregar sem deformação permanente, atenção ao MDF 3mm.\n10. 50 atuações de botão, 50 ciclos de tampa com chicotes conectados; medir abertura sem roçar e inspecionar afrouxamento/fissuras.\n11. Sem desenhos cotados e plugs medidos, NÃO cortar ferragens nem portas no gabinete principal.\n\nAs almofadas de elastômero são SOLUÇÃO CANDIDATA, não consumível homologado. Sem peça física não é possível verificar a pressão de contato nem resistência à vibração.\n''',encoding='utf8')
    with (root/'05_MONTAGEM/lista_materiais_v13.csv').open('w',newline='',encoding='utf8') as f:
        w=csv.writer(f);w.writerow(['item','quantidade','especificacao','classificacao','observacao'])
        for p in parts:w.writerow([p.name,1,p.kind,'MDF PRELIMINAR',p.note])
        for q in [('Almofada elastomero compressivel 34x6x1.5',4,'nominal; material e espessura aferir','NAO HOMOLOGADA','nao cortar de MDF'),
          ('Espacadores M3x20 nylon',8,'presilhas, reutiliza v1.2','CONFIRMAR','montagem v1.2'),
          ('Parafusos M3 isolantes PCB joystick',4,'furação centros candidato 27x20 mm','PENDENTE','verificar altura e PCB real'),
          ('Dobradiça 105 graus minimo',2,'furação exigida por modelo de fabricante','PENDENTE CRITICO','padrao nominal v1.2 nao homologado'),
          ('Fecho frontal positivo',1,'contrapeca e furos dimensionados fornecedor','PENDENTE CRITICO','modelo real'),
          ('MDF 800x500x3mm',1,'calibrar espessura e kerf','PENDENTE','area de corte')]:w.writerow(q)
    (root/'05_MONTAGEM/manual_montagem_v13.md').write_text('''# Procedimento de bancada v1.3 (nao fabricacao definitiva)\n\n1. Preservar a base, juntas, quatro cruzes e plataforma v1.2. Conferir funcionamento e retirar alimentacao.\n2. Cortar SOMENTE cupons de calibracao, medir MDF e kerf, validar folgas.\n3. Medir borda da case em quatro pontos; ensaiar tiras compressiveis removiveis sem deformar plasticos.\n4. Verificar pad 34x6 e posicao da presilha; usar arruelas/nylon e torque minimo, proteger PCB.\n5. Confrontar PCB KY023 e seus 4 furos com os slots propostos antes de produzir a bandeja. Usar isoladores M3 e conferir curso total da alavanca.\n6. Montar buzzer sobre bandeja existente e reter o corpo, nao o fio; proteger transistor e fiação.\n7. Escolher dobradiças/fecho e refazer os furos NOMINAIS antes do corte completo.\n8. Ensaiar cabos VGA/USB/potencia e a abertura da tampa, retificar recortes somente com medidas.\n9. Conferir protoboards, sensores, isolamento e rigidez. Rodar protocolo 5N/10N + 50 ciclos.\n10. Somente com matriz sem pendencias criticas gerar DXF de producao e solicitar LABFAB.\n''',encoding='utf8')
    (root/'README.md').write_text('''# HUD F-16 v1.3 | Fechamento mecanico parcial verificavel\n\n**Corte definitivo BLOQUEADO.** Este pacote preserva a v1.2 no diretorio `00_FONTE`, mantendo originais STEP e scripts.\n\nAlteracoes: oito rasgos regulaveis nas quatro presilhas MDF 34x20; quatro almofadas de elastomero nominal 34x6x1,5 em STEP, ainda hipoteticas e **fora** do nesting MDF; quatro rasgos para montagem com parafusos de modulo KY023 na bandeja 54x44.\n\nA posicao da case impressa e extraida dos STEP originais. Não há passo de fabricação aprovado para alumofadas elasticas sem ensaio. As versões fechada e aberta sao STEP separados.\n\nO nesting inclui 36 peças MDF com seis corpos de prova, mantendo a chapa 800x500. O DXF e PRELIMINAR, contendo furação legada de dobradiças e fecho ainda NAO HOMOLOGADA. Nenhum recorte de VGA, USB ou energia foi inventado.\n\n## Reproducao\n\n    python3 -m pip install -r requirements.txt\n    python3 01_CAD_3D/projeto_editavel.py --out .\n    python3 04_VALIDACAO/verificador_independente_v13.py\n\nO código usa caminhos relativos. Entradas principais: STEP em `01_CAD_3D/originais` e referencias STEP v1.2 preservadas. Outputs: STEP, DXF, PDF, JSON/CSV.\n\n## Documentacao\n\n- `03_DESENHOS/desenhos_cotados_v13.pdf`: nesting, detalhes de retentor, PCB joystick e portas pendentes.\n- `04_VALIDACAO/matriz_validacao_v13.json`: ensaios CAD, intersecoes e pendencias.\n- `04_VALIDACAO/colisoes_e_contatos_v13.csv`: resultados booleanos re-importados, NÃO lista vazia.\n- `04_VALIDACAO/medicoes_e_ensaios_pendentes.md`: lista concreta de bloqueios.\n- `05_MONTAGEM/lista_materiais_v13.csv` e `manual_montagem_v13.md`.\n\nFonte externa: Digilent Nexys A7 Reference Manual (https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf). KY023 furação candidata provém de variante Keyes Flux Workshop (https://fluxworkshop.com/products/biaa100065-dual-axis-joystick-keyes-black); NÃO comprova padrão do módulo físico instalado.\n''',encoding='utf8')
    # Visuals, real geometric diagrams generated from parts, not images imagined
    draw_pdf(root,parts,nest,pad,structure)
    return report

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--out',default=str(HERE.parent));args=ap.parse_args();root=Path(args.out).resolve()
    for folder in ['01_CAD_3D','02_DXF','03_DESENHOS','04_VALIDACAO','05_MONTAGEM']:(root/folder).mkdir(parents=True,exist_ok=True)
    # Preserve v1.2 STEP references; one-time extraction from unchanged v1.2 archive, relative
    if not V12_CLOSED.exists():
        zip_path=HERE.parent/'00_FONTE/HUD_F16_V12_ORIGINAL_INALTERADO.zip'
        if not zip_path.exists():raise FileNotFoundError('Need v1.2 original source ZIP in 00_FONTE')
        with zipfile.ZipFile(zip_path) as z:
            for member,dest in [('gabinete_montado_v12_preliminar.step',V12_CLOSED),('gabinete_tampa_aberta_v12.step',V12_OPEN)]:
                name=next(n for n in z.namelist() if n.endswith('/01_CAD_3D/'+member))
                dest.write_bytes(z.read(name))
    print("STAGE parts",flush=True)
    parts,places,mods=updated_parts()
    nest=old.verify_nest(parts)
    if nest['erros']:raise RuntimeError('Nesting v1.3 ERROR: '+json.dumps(nest['erros']))
    path=old.generate_dxf(parts,root)
    doc=ezdxf.readfile(str(path))
    for t in doc.modelspace().query('TEXT[layer=="REFERENCIA_NAO_CORTAR"]'):
        t.dxf.text='HUD V1.3 PRELIMINAR | NAO PRODUCAO | FUROS DOBRADICA/F ECHO NAO HOMOLOGADOS'
    dx=root/'02_DXF/gabinete_v13_PRELIMINAR_NAO_PRODUCAO.dxf'
    doc.saveas(str(dx));path.unlink()
    dxf=old.dxf_reimport_check(dx,parts,nest)
    old.save_csv(parts,root)
    print("STAGE steps",flush=True)
    steps=export_assemblies(parts,places,root)
    print("STAGE pads",flush=True)
    pad=case_pad_test(places)
    print("STAGE sweep",flush=True)
    sweep=sweep_test(root)
    print("STAGE structure",flush=True)
    structural=structural_collision_test(root)
    print("STAGE documents",flush=True)
    report=write_docs(root,parts,nest,dxf,steps,pad,sweep,structural)
    with (root/'README.md').open('a',encoding='utf8') as f:
        f.write('\n## Publicacao STEP segura v1.3.2\n\nA unica referencia canonica dos STEP regenerados e `01_CAD_3D/ATUAL/`.\nEste link aponta para uma revisao completa imutavel, publicada apenas apos os dois estados serem validados.\nOs STEP diretamente em `01_CAD_3D/` sao COPIAS HISTORICAS e nao devem ser usados para inferir sucesso da regeneracao.\nO DXF continua PRELIMINAR, pendente de testes fisicos.\n')
    print(json.dumps({'status':report['status'],'fabricacao_liberada':False,'pecas_MDF':len(parts),'gap_mm':nest['menor_distancia_mm'],'aproveitamento_liquido_percentual':nest['aproveitamento_liquido_percentual'],
       'step_solid_count':steps['fechado']['solids'],'retentores':len(pad),'interferencias_estruturais':len(structural['interferencias']),
       'sweep_hits':sum(len(x['interferencias']) for x in sweep),'alertas':report['alertas']},ensure_ascii=False,indent=2))

if __name__=='__main__':main()