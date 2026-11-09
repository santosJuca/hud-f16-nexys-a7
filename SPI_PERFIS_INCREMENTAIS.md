# Aumento de FPS: perfis SPI de leitura incrementais

**EXPERIMENTAL.** A seção 6.1 registra um build/JTAG histórico; a seção 6.2 registra a reprodução offline desta publicação. O agente não programou hardware nesta consolidação. Base: `fix/hud-ddr2-indicadores-20261109`, commit
`f752a7404e2a4f390cf3c8d13329761f53ac7a04` (RTL `b38e538`). Branch desta etapa:
`perf/hud-spi-leitura-incremental-20261109`.

## 1. Causa comprovada do FPS baixo

O perfil do BIT `b38e538` (`evidencias/perfil-cartao-fechamento.json`) passa
`SD_READ_HALF_PERIOD_CYCLES=125`. O `top_reticula` já repassa divisores separados para
inicialização e leitura (`SD_INIT_HALF_PERIOD_CYCLES`, `SD_READ_HALF_PERIOD_CYCLES` →
`sd_spi_controller` → `sd_spi_init` / `sd_spi_read_block`), mas os dois estão em 125 ciclos
de 100 MHz: **400 kHz durante toda a reprodução**, não só na inicialização.

Custo por setor no `sd_spi_read_block` real, medido em simulação (sem latência do cartão):

| Etapa CMD17 | Períodos SCK |
|---|---|
| Comando (48 bits) | 48 |
| 0xFF + R1 | 16 |
| Token 0xFE | 8 (+8 por byte de latência Nac) |
| Dados | 4096 |
| CRC16 | 16 |
| Fim de bloco/CS | ~9 |
| **Total** | **~4193** |

Overhead fora do SPI: o `sd_video_loader` gasta poucos ciclos entre setores (SECTOR_REQ →
grant → SECTOR_BUSY), e não há pausas entre bytes. A 400 kHz o setor leva
**1.048.002 ciclos = 10,48 ms**. Um quadro tem 150 setores: **1,572 s, ≈0,64 FPS**,
mais a latência Nac do cartão, que não foi medida. O gargalo é a frequência de leitura.

## 2. Alteração mínima

Nenhuma mudança de RTL. A estrutura existente já separa as frequências. A alteração é
**somente o perfil de build**:

- `SD_INIT_HALF_PERIOD_CYCLES=125` explícito (inicialização continua a 400 kHz, como exige o
  modo de identificação SD).
- `SD_READ_HALF_PERIOD_CYCLES` ∈ {50, 10, 5, 4}, um build por perfil.
- `scripts/build_spi_profile.sh <READ_HALF>` parte do perfil físico preservado (LBA
  30028160, 13501 setores, calibração dos sensores) e altera só esse genérico. Recusa 25 MHz
  (`READ_HALF=2`), exige árvore limpa e grava `perfil-spi.json` com commit, SHA-256 do DCP e
  USERCODE.
- `scripts/emit_spi_profile_bit.sh <dir>` gera o BIT a partir desse DCP. Confere SHA, timing
  positivo, pinagem/LVCMOS33 e DRC, e grava `report_datasheet` para o orçamento elétrico.
  USERCODE: `5D` + 4 hex do commit + divisor em hex (ex.: `5Dxxxx0A` para 5 MHz).

Preservados: 320×240 RGB332, vídeo e cartão, CRC16 com descarte do quadro, alternância de
bancos, última imagem válida, HUD, sensores, alternativa BRAM, pinagem e constraints. Nenhuma
exceção ou delay externo foi inventado.

## 3. Throughput calculado

Ciclos por setor medidos na simulação do controlador real. "Teto" ignora DDR2/VGA. A coluna
VGA é uma **estimativa** de publicação alinhada a varreduras de 16,8 ms (59,52 Hz); o
pipeline do repositório mediu 50,4 ms a 12,5 MHz, o que é coerente com ela.

| READ_HALF | SPI leitura | Ciclos/setor | Carga do quadro | Teto FPS | Estimativa VGA | Loop 90 quadros |
|---|---|---|---|---|---|---|
| 125 (atual) | 400 kHz | 1.048.002 | 1572,0 ms | 0,64 | ~0,63 | ~142 s |
| 50 | 1 MHz | 419.202 | 628,8 ms | 1,59 | ~1,57 | ~57 s |
| 10 | 5 MHz | 83.842 | 125,8 ms | 7,95 | ~7,4 | ~12 s |
| 5 | 10 MHz | 41.922 | 62,9 ms | 15,9 | ~14,9 | ~6 s |
| 4 | 12,5 MHz | 33.538 | 50,3 ms | 19,9 | ~19,8 | ~4,5 s |

Com latência Nac de 100 µs por setor (valor ilustrativo, **não medido**): 10 MHz cai para
77,9 ms/quadro (12,8 FPS teto) e 12,5 MHz para 65,4 ms (15,3 FPS teto).

**30 FPS não são alcançáveis nestes perfis.** São necessários 2.304.000 B/s úteis. Mesmo
12,5 MHz sem latência dá no máximo ~19,9 FPS. 30 FPS exigiria ~25 MHz **e** Nac médio abaixo de
~55 µs/setor, e o ponto 4 mostra que 25 MHz não é seguro com a amostragem atual. CMD18
(leitura múltipla) só se justifica depois de medir Nac na placa.

## 4. Orçamento elétrico (estimativa, não medição)

O `sd_spi_read_block` lança o SCK de subida e amostra o MISO no mesmo ciclo de 100 MHz. O
cartão muda o dado na descida anterior. Portanto o atraso total de ida e volta precisa
caber em **meio período** (menos o setup do flip-flop):

atraso = saída SCK da FPGA + trilha + tODLY do cartão (0–14 ns, especificação SD default speed) + trilha + entrada/roteamento até o FF.

Estimativa usada: **0–30 ns** (14 ns do cartão + ~16 ns de FPGA/placa). Esses ~16 ns precisam
ser substituídos pelos valores de `report_datasheet` do build e pelo esquema da Nexys A7.

| SPI | Meio período | Folga com 30 ns |
|---|---|---|
| 1 MHz | 500 ns | ~470 ns |
| 5 MHz | 100 ns | ~70 ns |
| 10 MHz | 50 ns | ~20 ns |
| 12,5 MHz | 40 ns | ~10 ns |
| 25 MHz | 20 ns | **negativa** |

A simulação confirma o critério (seção 5): com atraso incerto de 0–30 ns, 1–12,5 MHz passam
byte a byte. A 25 MHz, 8 de 8 leituras falharam, todas detectadas (R1/token/CRC), e nenhum
bloco corrompido foi aceito.

## 5. Testes executados

`scripts/test_spi_profiles.sh` (Icarus Verilog 12) roda o `sd_spi_controller` real e o modelo
SDHC do repositório. Dados aleatórios, LBA 30028160. Logs em `validation/spi-profiles/`.
**23/23 PASS.**

Para cada READ_HALF em {125, 50, 10, 5, 4}:
- nominal: leituras byte a byte contra o cartão;
- atraso MISO incerto 0–30 ns (sorteado por transição): leituras íntegras;
- CRC corrompido na 2ª leitura: erro código 5, sem `block_valid`, e as leituras seguintes passam;
- reset no meio da leitura: CS liberado, reinicialização a 400 kHz e leituras OK.

Em todos os cenários, o meio período mínimo de SCK é verificado por fase: **1250 ns em toda a
inicialização** e exatamente `READ_HALF×10 ns` nas leituras.

Extras:
- Nac de 100 µs a 10 e 12,5 MHz: PASS, e os ciclos por setor medidos estão na seção 3.
- 25 MHz com atraso 0–30 ns: falhas detectadas, zero blocos corrompidos aceitos.

Regressão do teste existente `tb_sd_read_400khz` com o modelo alterado (parâmetro novo
`NAC_BYTES`, padrão 0): PASS.

**Não executados na etapa inicial f8b36f8 (antes dos builds das seções 6.1/6.2):** `test_sd_ddr2_vga.sh` (XPM/xsim),
`test_top_ddr2_video.sh`, síntese/implementação, timing, CDC, DRC, bus skew e geração de BIT.
Esse pipeline integrado já foi exercitado no repositório a 12,5 e 25 MHz com o modelo da UI
MIG (`evidencias/pipeline-preload.txt`, `cadencia-vga.txt`).

## 6. Como reproduzir um build (máquina com Vivado)

```bash
git checkout perf/hud-spi-leitura-incremental-20261109
bash scripts/test_spi_profiles.sh             # regressao digital (iverilog)
bash scripts/build_spi_profile.sh 10          # 5 MHz, primeiro candidato fisico
# conferir resultado-spi-h010-*/ : WNS/WHS > 0, CDC sem novos alertas, DRC, bus skew
bash scripts/emit_spi_profile_bit.sh resultado-spi-h010-<commit>
```

Repetir com `5` (10 MHz) e depois `4` (12,5 MHz) **somente após** o ensaio físico do perfil
anterior passar. Os divisores mudam só contadores locais do domínio de 100 MHz. Ainda
assim, cada build precisa de nova conferência de setup/hold, porque a margem de hold do
build anterior foi de apenas 0,017 ns.

## 6.1 Resultado do perfil 5 MHz (READ_HALF=10)

Build na máquina do usuário, Vivado 2026.1, commit `f8b36f8`. Evidências em
`evidencias/spi-h010-f8b36f8/`.

- **Timing:** WNS +0,391 ns / WHS +0,006 ns, TNS/THS zero. O hold está mais estreito que no
  build `b38e538` (+0,017 ns) e precisa ser reconferido em cada novo perfil.
- **DRC:** sem erros (só warnings DSP e o REQP-1709 conhecido).
- **CDC:** igual ao build anterior: 46 CDC-3, 3 CDC-10, 1 CDC-8, 176 CDC-15.
- **Bus skew:** positivo.
- **Avisos críticos:** os já conhecidos (Constraints 18-1056 e Netlist 29-160 do XDC do MIG).
- **BIT:** `hud-f16-ddr2-f8b36f8-spi-h010-experimental.bit`, SHA-256
  `41503a5fbf86d8cf7d97c3007802cedb0231ab5efcacf7ece7defd86179ce49d`, USERID `5DF8B30A`.
- **Carga JTAG (SRAM)** na Nexys 210292AD34F5A: DONE=1, INIT_B=1, EOS=1, CRC_ERROR=0,
  USERCODE lido `5df8b30a`. O usuário relatou funcionamento.
- **Pendente:** cronometrar o loop de 90 quadros (estimativa de ~12 s, ~7,4 FPS), 10 min com
  LD15 apagado e medir SCK→MISO antes de subir para 10 MHz.

## 6.2 Reprodução offline e publicação de 5 MHz

Nesta consolidação o BIT histórico não foi localizado; foi feito novo build do commit f8b36f8 com o mesmo perfil, sem alterar RTL ou constraints. WNS +0,391 ns / WHS +0,006 ns; oito grupos de skew aprovados (mínimo +6,810 ns), zero erros DRC, CDC inalterado e sem waivers. As 132 atribuições IO conferiram. A margem de hold continua de apenas 6 ps e o orçamento externo permanece pendente.

Passaram novamente os 23 cenários SPI e o teste integrado com init=125/read=10/LBA=30028160: quatro publicações e releituras íntegras, zero erros, 7.372.800 comparações RGB. Os testes usam UI MIG/XPM/SDHC modelados, sem PHY físico.

O novo `hud-f16-ddr2-f8b36f8-spi-h010-experimental.bit` tem SHA-256 `2fd3dbc1d0da6fb4d3a8962f811d740fed0b2b23317928c3b591f7c44e1157b2` e USERCODE 5DF8B30A. **É uma nova emissão, sem ensaio JTAG nesta consolidação.** O hash histórico 41503a5f... e o log da seção 6.1 não são atribuídos ao novo arquivo. A tag `hud-f16-ddr2-spi5-rc-20261109` e os manifestos vinculam o pacote ao código e ao build. Relatórios completos em `evidencias/spi-h010-reproducao/`.

Seguir PROCEDIMENTO_TESTE_FPGA.md para identidade do arquivo, estimativa de cadência, diagnóstico e recuperação. Não aumentar novamente antes do ensaio/instrumentação. Nenhuma Flash, FPGA ou microSD foi programada nesta execução.

## 7. Ensaio físico incremental (um perfil por vez)

1. Programar só a SRAM por JTAG e conferir o USERCODE do perfil (`5D…0A`, `5D…05`, `5D…04`).
   Se não conferir, não atribuir resultados.
2. LD12 e LD13 acesos. Esperar 20–30 s. LD14 aceso (publicação íntegra), LD15 apagado.
3. Ligar o fundo (BTNL) e **cronometrar o loop de 90 quadros**, do primeiro quadro até a
   volta a ele. Esperado: ~12 s (5 MHz), ~6 s (10 MHz), ~4,5 s (12,5 MHz), contra ~142 s hoje.
   Estimativa FPS = 90 / tempo, supondo todos os 90 quadros publicados uma vez por ciclo. Sem conferir perdas/duplicações, não tratar como contagem instrumentada. Repetir 3 loops.
4. Deixar rodando 10 min: LD15 deve continuar apagado e a imagem sem mistura ou tearing.
   Testar modos, joystick, bússola e ajuste vertical.
5. **Critério para subir de perfil:** LD15 apagado nos 10 min e loop estável. Se houver
   osciloscópio, medir da descida de SCK até MISO estável e conferir a borda real de amostragem; confirmar que cabe no meio
   período do próximo perfil com folga.
6. Em falha: o loader faz três tentativas e depois para (LD15 aceso, última imagem mantida).
   Registrar LEDs e voltar ao perfil anterior. Desligar e religar a placa carrega a Flash
   funcional.
