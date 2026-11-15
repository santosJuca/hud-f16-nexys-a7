#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VIVADO="${VIVADO:-$HOME/AMD/2026.1/Vivado/bin/vivado}"
test -x "$VIVADO" || { echo "Vivado não encontrado: $VIVADO"; exit 1; }
test ! -e "$ROOT/resultado/projeto" || { echo "Build existente. Nenhum arquivo sobrescrito."; exit 1; }
mkdir -p "$ROOT/resultado"
echo "P3A: compilação isolada. Nenhum bitstream/JTAG será executado."
"$VIVADO" -mode batch -nojournal -nolog \
    -source "$ROOT/scripts/p3a_build.tcl" \
    -tclargs "$ROOT" "$@" \
    > "$ROOT/resultado/vivado.log" 2>&1 || {
        tail -60 "$ROOT/resultado/vivado.log"
        exit 1
    }
grep -E "P3A: WNS=|P3A_BUILD_ROUTED" "$ROOT/resultado/vivado.log" || true
echo "Relatorios: $ROOT/resultado"
