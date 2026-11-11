#!/usr/bin/env bash
# Gera o BIT de um build feito por build_spi_profile.sh. Somente arquivos locais:
# nenhum comando de hardware, JTAG, Flash ou microSD.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VIVADO="${VIVADO:-$HOME/AMD/2026.1/Vivado/bin/vivado}"
DIR="$(cd "${1:?USO: emit_spi_profile_bit.sh resultado-spi-hNNN-commit}" && pwd)"
read -r SHA USERCODE HALF COMMIT TAG < <(python3 -I - "$DIR/perfil-spi.json" <<'PY'
import json, sys
p = json.load(open(sys.argv[1]))
print(p['routed_dcp_sha256'], p['usercode'], p['read_half_period_cycles'], p['rtl_commit'][:7], p.get('bit_name_tag', ''))
PY
)
NAME="hud-f16-ddr2-${COMMIT}${TAG:+-$TAG}-spi-h$(printf %03d "$HALF")-experimental.bit"
OUT="$DIR/bitstream"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
"$VIVADO" -mode batch -nojournal -log "$DIR/bitgen.log" \
  -source "$ROOT/scripts/emit_spi_profile_bit.tcl" \
  -tclargs "$DIR/routed.dcp" "$OUT" "$SHA" "$USERCODE" "$NAME"
sha256sum "$OUT/$NAME" | tee "$OUT/SHA256SUMS"
echo "USERCODE esperado na placa: $USERCODE"
