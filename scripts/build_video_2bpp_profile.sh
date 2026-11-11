#!/usr/bin/env bash
# Build offline (sintese/implementacao, sem bitstream, sem JTAG) do perfil EXPERIMENTAL
# 640x480 2 bpp. Parte do perfil fisico preservado (evidencias/perfil-cartao-fechamento.json:
# sensores, magnetometro, DDR2) e altera SOMENTE: SD_VIDEO_WIDTH/HEIGHT/BPP/FPS,
# SD_VIDEO_LBA/SECTORS do novo arquivo mapeado e SD_READ_HALF_PERIOD_CYCLES.
#
# Uso: bash scripts/build_video_2bpp_profile.sh <READ_HALF> <LBA> <SETORES>
#   READ_HALF em {10,5,4} (5 / 10 / 12,5 MHz); 25 MHz continua recusado.
#   LBA e SETORES vem de tools/map_sd_video.py sobre o cartao JA preparado (somente leitura).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HALF="${1:-}"; LBA="${2:-}"; SECTORS="${3:-}"
case "$HALF" in 10|5|4) ;; *) echo "READ_HALF invalido: '$HALF' (permitidos: 10 5 4)" >&2; exit 2 ;; esac
[[ "$LBA" =~ ^[1-9][0-9]*$ && "$SECTORS" =~ ^[1-9][0-9]*$ ]] || { echo "LBA/SETORES invalidos" >&2; exit 2; }
(( (SECTORS-1) % 150 == 0 && SECTORS > 301 )) || { echo "SETORES deve ser 1+150*quadros (>=2 quadros)" >&2; exit 2; }
if [[ -n "$(git -C "$ROOT" status --porcelain -- hud mig scripts)" ]]; then
  echo "Fontes/scripts com alteracoes locais; faca commit antes." >&2; exit 1
fi
COMMIT="$(git -C "$ROOT" rev-parse HEAD)"
OUTDIR="$ROOT/resultado-v2bpp-h$(printf %03d "$HALF")-${COMMIT:0:7}"
test ! -e "$OUTDIR" || { echo "Preservado: $OUTDIR" >&2; exit 1; }
test ! -e "$ROOT/resultado" || { echo "resultado/ existe; mova-o antes (nada sobrescrito)." >&2; exit 1; }
mapfile -t GENERICS < <(python3 -I - "$ROOT/evidencias/perfil-cartao-fechamento.json" "$HALF" "$LBA" "$SECTORS" <<'PY'
import json, sys
profile = json.load(open(sys.argv[1]))['generics']
half, lba, sectors = map(int, sys.argv[2:])
profile.update(SD_HALF_PERIOD_CYCLES=125, SD_INIT_HALF_PERIOD_CYCLES=125,
               SD_READ_HALF_PERIOD_CYCLES=half, SD_VIDEO_WIDTH=640, SD_VIDEO_HEIGHT=480,
               SD_VIDEO_BPP=2, SD_VIDEO_FPS=30, SD_VIDEO_LBA=lba, SD_VIDEO_SECTORS=sectors)
for name, value in profile.items():
    if not isinstance(value, int): raise SystemExit(f'Generico nao inteiro: {name}')
    print(f'{name}={value}')
PY
)
echo "Perfil 640x480 2 bpp: leitura $((50000000 / HALF)) Hz, LBA $LBA, $SECTORS setores, commit $COMMIT"
bash "$ROOT/scripts/run.sh" "${GENERICS[@]}"
mv "$ROOT/resultado" "$OUTDIR"
# Bit 7 do ultimo byte identifica o perfil 2 bpp no USERCODE (5D + commit + 0x80|HALF).
USERCODE="5d${COMMIT:0:4}$(printf %02x $((HALF | 128)))"
python3 -I - "$OUTDIR" "$HALF" "$COMMIT" "$USERCODE" "${GENERICS[@]}" <<'PY'
import json, sys, hashlib, pathlib
out, half, commit, usercode, *generics = sys.argv[1:]
out = pathlib.Path(out)
info = {
    'classification': 'EXPERIMENTAL - NAO VALIDADO FISICAMENTE',
    'profile': 'video 640x480 2 bpp indexado (4 tons)',
    'bit_name_tag': 'v2bpp',
    'rtl_commit': commit, 'read_half_period_cycles': int(half),
    'spi_init_hz': 400000, 'spi_read_hz': 50_000_000 // int(half),
    'usercode': usercode.upper(),
    'routed_dcp_sha256': hashlib.sha256((out / 'routed.dcp').read_bytes()).hexdigest(),
    'generics': dict(g.split('=', 1) for g in generics),
    'bitstream_generated': False, 'physical_validation': False,
}
(out / 'perfil-spi.json').write_text(json.dumps(info, indent=2) + '\n')
print(json.dumps({k: info[k] for k in ('spi_read_hz', 'usercode', 'routed_dcp_sha256')}))
PY
echo "Relatorios em $OUTDIR. Bitstream (somente arquivo): bash scripts/emit_spi_profile_bit.sh $OUTDIR"
