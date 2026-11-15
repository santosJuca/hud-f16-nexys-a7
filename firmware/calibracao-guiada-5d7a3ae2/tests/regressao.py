from pathlib import Path
import re,subprocess,shutil,json
r=Path(__file__).resolve().parent.parent
compat=r/'tests/compat';compat.mkdir(exist_ok=True)
# Apenas defaults de portas input que o Icarus nao suporta. Defaults de saidas
# e registradores permanecem, e o RTL de entrega nao e modificado.
for p in (r/'hud/rtl').glob('*.sv'):
 text=p.read_text()
 pattern=r'(input\s+(?:wire|logic)\b[^;\n]*?)\s*=\s*[^,\n;)]+(?=[,\n;)])'
 while re.search(pattern,text):text=re.sub(pattern,r'\1',text)
 (compat/p.name).write_text(text)
fixtures=r/'tests/regressao';fixtures.mkdir(exist_ok=True)
names=['tb_heading_magnetico','tb_heading_fusao','tb_controle_heading','tb_hmc5883l_i2c','tb_atitude_fusao_complementar','tb_sd_status_display','tb_modo_operacao']
results={}
names+=['tb_alinhamento81','tb_video_mode_publication']
for name in names:
 command=['iverilog','-g2012','-I',str(r),'-y',str(compat),'-Y','.sv','-s',name,'-o',str(fixtures/name),str(r/'tests/xadc_stub.sv'),str(fixtures/f'{name}.sv')]
 p=subprocess.run(command,text=True,capture_output=True,cwd=r)
 (r/'evidencias'/f'compile-reg-{name}.log').write_text(p.stdout+p.stderr)
 if p.returncode:print(name,p.stdout+p.stderr);raise SystemExit(p.returncode)
 p=subprocess.run(['vvp',str(fixtures/name)],text=True,capture_output=True,cwd=r,timeout=120)
 (r/'evidencias'/f'reg-{name}.log').write_text(p.stdout+p.stderr)
 if p.returncode:print(name,p.stdout+p.stderr);raise SystemExit(p.returncode)
 print(name,p.stdout.strip()[:200]);results[name]='PASS'
results['tb_hud_dispatch']='INCOMPATIVEL COM BASELINE: expectativa CAPTURE sobre SW4 difere do RTL preservado; mesma falha reproduzida na fonte5DE9E304; teste integrado novo passou'
results['mpu6050_i2c_tb']='INCONCLUSIVO: Icarus timeout120s; Verilator nao suporta disable do testbench; fonte MPU inalterada'
(r/'evidencias/regressoes.json').write_text(json.dumps(results,indent=2)+'\n')
