#!/usr/bin/env bash
# Build offline (sintese/implementacao, sem bitstream, sem JTAG) de um perfil SPI de leitura.
# Parte do perfil fisico preservado (evidencias/perfil-cartao-fechamento.json) e muda SOMENTE
# SD_READ_HALF_PERIOD_CYCLES. A inicializacao fica explicitamente em 125 (400 kHz).
#
# Uso: bash scripts/build_spi_profile.sh <READ_HALF>    READ_HALF em {50,10,5,4}
#   50 -> 1 MHz | 10 -> 5 MHz | 5 -> 10 MHz | 4 -> 12,5 MHz
# 25 MHz (READ_HALF=2) e recusado: o atraso estimado do MISO atravessa o ponto de amostragem.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HALF="${1:-}"
case "$HALF" in
  50|10|5|4) ;;
  *) echo "READ_HALF invalido: '$HALF' (permitidos: 50 10 5 4)" >&2; exit 2 ;;
esac
if [[ -n "$(git -C "$ROOT" status --porcelain -- hud mig scripts)" ]]; then
  echo "Fontes/scripts com alteracoes locais; faca commit antes para o USERCODE identificar o build." >&2
  exit 1
fi
COMMIT="$(git -C "$ROOT" rev-parse HEAD)"
OUTDIR="$ROOT/resultado-spi-h$(printf %03d "$HALF")-${COMMIT:0:7}"
test ! -e "$OUTDIR" || { echo "Preservado: $OUTDIR" >&2; exit 1; }
test ! -e "$ROOT/resultado" || { echo "resultado/ existe; mova-o antes (nada sobrescrito)." >&2; exit 1; }

mapfile -t GENERICS < <(python3 -I - "$ROOT/evidencias/perfil-cartao-fechamento.json" "$HALF" <<'PY'
import json, sys
profile = json.load(open(sys.argv[1]))['generics']
half = int(sys.argv[2])
profile['SD_HALF_PERIOD_CYCLES'] = 125
profile['SD_INIT_HALF_PERIOD_CYCLES'] = 125
profile['SD_READ_HALF_PERIOD_CYCLES'] = half
for name, value in profile.items():
    if not isinstance(value, int): raise SystemExit(f'Generico nao inteiro: {name}')
    print(f'{name}={value}')
PY
)
echo "Perfil SPI: init 400 kHz, leitura $((50000000 / HALF)) Hz (READ_HALF=$HALF), commit $COMMIT"
bash "$ROOT/scripts/run.sh" "${GENERICS[@]}"
mv "$ROOT/resultado" "$OUTDIR"

USERCODE="5d${COMMIT:0:4}$(printf %02x "$HALF")"
python3 -I - "$OUTDIR" "$HALF" "$COMMIT" "$USERCODE" "${GENERICS[@]}" <<'PY'
import json, sys, hashlib, pathlib
out, half, commit, usercode, *generics = sys.argv[1:]
out = pathlib.Path(out)
dcp = out / 'routed.dcp'
info = {
    'classification': 'EXPERIMENTAL - NAO VALIDADO FISICAMENTE',
    'rtl_commit': commit,
    'read_half_period_cycles': int(half),
    'spi_init_hz': 400000,
    'spi_read_hz': 50_000_000 // int(half),
    'usercode': usercode.upper(),
    'routed_dcp_sha256': hashlib.sha256(dcp.read_bytes()).hexdigest(),
    'generics': dict(g.split('=', 1) for g in generics),
    'bitstream_generated': False,
    'physical_validation': False,
}
(out / 'perfil-spi.json').write_text(json.dumps(info, indent=2) + '\n')
print(json.dumps({k: info[k] for k in ('spi_read_hz', 'usercode', 'routed_dcp_sha256')}))
PY
grep -E "P3A: WNS=" "$OUTDIR/vivado.log" || true
echo "Build em $OUTDIR. Confira timing/CDC/DRC/bus skew antes de gerar o BIT:"
echo "  bash scripts/emit_spi_profile_bit.sh $OUTDIR"
