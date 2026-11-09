#!/usr/bin/env bash
# Regressao digital dos perfis SPI incrementais com Icarus Verilog (sem Vivado/XPM).
# Usa o sd_spi_controller real (init + CMD17/CRC16) e o modelo SDHC do repositorio.
# Nao qualifica eletricamente nenhuma frequencia.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$ROOT/validation/spi-profiles}"
test ! -e "$OUT" || { echo "Preservado: $OUT" >&2; exit 1; }
mkdir -p "$OUT"
command -v iverilog >/dev/null || { echo "iverilog ausente" >&2; exit 1; }

python3 -I - "$OUT/data.hex" <<'PY'
import sys, random
r = random.Random(20261109)
data = bytes(r.randrange(256) for _ in range(512 * 8))
open(sys.argv[1], 'w').write('\n'.join(f'{b:02x}' for b in data) + '\n')
PY

SRC=("$ROOT"/hud/rtl/sd_spi_*.sv "$ROOT/tests/sd_video_card_model.sv" "$ROOT/tests/tb_sd_spi_freq_profiles.sv")

run() {
  local name="$1"; shift
  local args=()
  for p in "$@"; do args+=(-P "tb_sd_spi_freq_profiles.$p"); done
  iverilog -g2012 -s tb_sd_spi_freq_profiles "${args[@]}" -o "$OUT/$name.vvp" "${SRC[@]}" \
    > "$OUT/$name-compile.txt" 2>&1
  (cd "$ROOT" && vvp -n "$OUT/$name.vvp" +VIDEO_HEX="$OUT/data.hex") > "$OUT/$name.txt" 2>&1 || true
  if grep -qE 'FATAL|Fatal|fatal|ERROR' "$OUT/$name.txt" || ! grep -q '^PASS spi_profile' "$OUT/$name.txt"; then
    echo "FALHOU $name"; tail -5 "$OUT/$name.txt"; return 1
  fi
  echo "$name: $(grep -E '^PASS|^SECTOR_CYCLES' "$OUT/$name.txt" | tr '\n' ' ')"
}

# Atraso de ida e volta assumido para o MISO: 0..30 ns (tODLY 0..14 ns do cartao + ~16 ns
# estimados de saida FPGA, trilhas e entrada). Estimativa, nao medicao.
for half in 125 50 10 5 4; do
  n=4; [[ $half == 125 ]] && n=2
  run "nominal-h$half"   SCENARIO=0 READ_HALF=$half NREADS=$n
  run "atraso-h$half"    SCENARIO=0 READ_HALF=$half NREADS=$n MISO_DMIN_NS=0 MISO_DMAX_NS=30 SEED=7
  run "crc-h$half"       SCENARIO=1 READ_HALF=$half NREADS=3
  run "reset-h$half"     SCENARIO=2 READ_HALF=$half NREADS=2
done
# Latencia Nac de 100 us por setor nos perfis rapidos (custo nao medido no cartao real).
run "nac100us-h5" SCENARIO=0 READ_HALF=5 NREADS=4 NAC_BYTES=125
run "nac100us-h4" SCENARIO=0 READ_HALF=4 NREADS=4 NAC_BYTES=157
# 25 MHz com a mesma faixa 0..30 ns: o atraso atravessa o ponto de amostragem (20 ns).
run "atraso-h2-deve-detectar" SCENARIO=3 READ_HALF=2 NREADS=8 MISO_DMIN_NS=0 MISO_DMAX_NS=30 SEED=7
echo "PASS test_spi_profiles: logs em $OUT"
