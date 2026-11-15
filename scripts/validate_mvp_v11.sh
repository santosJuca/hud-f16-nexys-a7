#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
out="${1:?Uso: validate_mvp_v11.sh diretorio_novo}"
mkdir -p -- "$(dirname -- "$out")"
mkdir -- "$out"
out="$(realpath "$out")"
python3 - "$root" "$out" <<'PY'
import hashlib,json,sys
from pathlib import Path
root,out=map(Path,sys.argv[1:])
profile=json.loads((root/'docs/entrega_academica/mvp_v11/perfil.json').read_text())
for name,expected in {**profile['compiled_sources'],**profile['constraints']}.items():
    if hashlib.sha256((root/name).read_bytes()).hexdigest()!=expected:
        raise SystemExit('Fonte/constraint divergiu: '+name)
params=profile['effective_parameters_sv']
assert params['MODOS_OPERACIONAIS']=="1'b1"
(out/'mvp_profile.svh').write_text(',\n'.join('.'+n+'('+v+')' for n,v in params.items())+'\n')
(out/'sources.f').write_text('\n'.join(str(root/n) for n in profile['compiled_sources'])+'\n')
(out/'perfil.json').write_text(json.dumps(profile,ensure_ascii=False,indent=2)+'\n')
PY
mapfile -t sources < "$out/sources.f"
cd "$root"
verilator --binary --timing -j 4 -Wno-fatal -I"$out" \
    --top-module tb_mvp_v11_entrega --Mdir "$out/obj" \
    tests/xadc_stub.sv "${sources[@]}" tests/tb_mvp_v11_entrega.sv > "$out/compile.log" 2>&1
(cd "$out" && timeout 600 ./obj/Vtb_mvp_v11_entrega > resultado.log 2>&1)
tail -3 "$out/resultado.log"
# Regressao pontual preexistente, com force/temporizacoes reduzidas preservados.
for top in tb_modo_operacao tb_fontes_operacao tb_alertas_voo tb_alertas_vga tb_modos_operacao_integrado; do
    iverilog -g2012 -s "$top" -o "$out/$top" tests/xadc_stub.sv \
        "${sources[@]}" "tests/$top.sv" > "$out/$top-compile.log" 2>&1
    timeout 60 vvp "$out/$top" > "$out/$top.log" 2>&1
    tail -1 "$out/$top.log"
done
echo "PASS validacao offline direcionada MVP v1.1"
