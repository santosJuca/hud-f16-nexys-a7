#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
run="$(mktemp -d "${TMPDIR:-/tmp}/hud-mag-build-XXXXXXXX")"
for folder in hud mig digilent-vivado-boards scripts; do cp -a "$root/$folder" "$run/$folder"; done
cp "$root/genericos.txt" "$run/genericos.txt"
mapfile -t generics < "$run/genericos.txt"
bash "$run/scripts/run.sh" "${generics[@]}"
printf 'Build offline preservado em %s\n' "$run"
