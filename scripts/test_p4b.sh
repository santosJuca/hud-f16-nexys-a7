#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Executa as FIFOs reais XPM; nao substitui a macro por um modelo Icarus.
exec bash "$ROOT/scripts/test_video_ddr2.sh" "$@"
