from pathlib import Path
import subprocess,json,sys
root=Path(__file__).resolve().parent.parent
rtl=root/'hud/rtl';tests=root/'tests'
def run(args,log):
 p=subprocess.run([str(x) for x in args],text=True,capture_output=True)
 (root/'evidencias'/log).write_text(p.stdout+p.stderr)
 if p.returncode: print(p.stdout+p.stderr);raise SystemExit(p.returncode)
 return p.stdout
print(run([sys.executable,tests/'referencia.py'],'referencia.log').strip())
common=[rtl/'mag_calibration_2d.sv',rtl/'heading_magnetico.sv']
for top,sources in [('tb_mag_calibration',common),('tb_mag_faults',common),('tb_mag_controls',[rtl/'mag_calibration_controls.sv']),('tb_mag_display',[rtl/'mag_calibration_display.sv'])]:
 run(['iverilog','-g2012','-s',top,'-o',tests/top,*sources,tests/f'{top}.sv'],f'compile-{top}.log')
 if top!='tb_mag_calibration':print(run(['vvp',tests/top],f'{top}.log').strip())
ref=json.loads((tests/'referencia.json').read_text());results={}
for name,d in ref.items():
 args=['vvp',tests/'tb_mag_calibration',f'+CASE={name}',f'+DIR={tests}/vetores',f'+ACCEPT={int(d["expect_accept"])}',f'+OX={d["offset"][0]}',f'+OY={d["offset"][1]}',f'+GX={d["gain_q12"][0]}',f'+GY={d["gain_q12"][1]}']
 print(run(args,f'cenario-{name}.log').splitlines()[0]);results[name]='PASS'
(root/'evidencias/cenarios.json').write_text(json.dumps(results,indent=2)+'\n')

for fault in (1,2,3):
 d=ref['diagonal']
 args=['vvp',tests/'tb_mag_calibration','+CASE=diagonal',f'+DIR={tests}/vetores','+ACCEPT=1','+OX=200','+OY=-120','+GX=2621','+GY=4194',f'+POSTFAULT={fault}']
 print(run(args,f'confirmacao-falha-{fault}.log').splitlines()[0])

import random
rng=random.Random(16)
rows=[(1,1,1,1),(33554431,33554431,33554431,33554431),(78643,33538050,33538050,52428)]
rows += [tuple(rng.randrange(1,1<<25) for _ in range(4)) for _ in range(125)]
(tests/'score.hex').write_text(''.join(f'{(a<<75)|(b<<50)|(c<<25)|d:025x}\n' for a,b,c,d in rows))
run(['iverilog','-g2012','-s','tb_mag_score','-o',tests/'tb_mag_score',rtl/'mag_calibration_2d.sv',tests/'tb_mag_score.sv'],'compile-score.log')
print(run(['vvp',tests/'tb_mag_score',f'+FILE={tests}/score.hex'],'score.log').splitlines()[0])
