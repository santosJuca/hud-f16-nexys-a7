# Vídeo 640×480, 2 bpp, quatro tons de verde — candidata experimental

**EXPERIMENTAL, sem validação física.** Branch local `exp/video-640x480-2bpp-20261111`, criada a partir de `origin/sprint/spi-ddr2-throughput-20261109` (59f1c7b). O RTL dessa base é idêntico ao da RC publicada de 5 MHz (8162051); só foram acrescentados testes, a sonda (não instanciada) e documentação. Nesta sessão não houve push, merge, JTAG, Flash, escrita no microSD, nem alteração em sensores, atitude, magnetômetro, clocks ou resets.

## A. Situação inicial (verificada em 2026-11-11)

| Item | Estado encontrado |
|---|---|
| Repositório | `santosJuca/Trabalho-display-aviao-v2`, clonado com o histórico completo |
| `main` | 14d1bf0. HUD sem vídeo, com bitstreams `2026-10-13_hud_flash` e `2026-10-19_mag_calibrado`. É a última versão funcional preservada (Flash). |
| Vídeo mais recente | `sprint/spi-ddr2-throughput-20261109` (59f1c7b). A RC publicada é a de 5 MHz (`hud-f16-ddr2-spi5-rc-20261109`, commit f8b36f8 ≡ RTL 8162051). As candidatas offline de 10 e 12,5 MHz não foram programadas. A aprovação física ainda está pendente (PENDENCIAS_FISICAS.md). |
| Arquitetura de vídeo | microSD → `sd_spi_controller` (init 400 kHz, CMD17, CRC16) → `sd_video_loader` → `ddr2_sd_frame_mirror` (XPM, MIG, CRC32 na releitura) → `sd_sector_buffer` (dois bancos BRAM de 76.800 B, troca em y=480) → `sd_video_background` (prioridade do HUD) → VGA 640×480 a 59,52 Hz |
| DDR2 | **Integrada ao vídeo** (`ENABLE_DDR2_VIDEO=1`) como um quadro de trabalho com releitura verificada. O caminho SD→BRAM continua disponível com `ENABLE_DDR2_VIDEO=0`. Nada foi trocado. |
| BRAM (build 10 MHz) | 64/135 RAMB36. O vetor de `sd_sector_buffer` é declarado com 2·2^17 bytes. Esse valor não muda neste trabalho, porque `BYTES` continua 76.800. |
| Vídeo original | Referenciado em `evidencias/ferramentas-video.json` como `/home/santojuca/Downloads/videos-hud/E4DvcvNDQoQ.mp4` (304.945.288 B, SHA `89075ad5…`). **Indisponível nesta sessão**: esse caminho é de outra máquina, e o pedido de acesso às pastas locais foi negado. |
| AGENTS.md | Não existe em nenhuma branch remota. |
| Testes existentes | Regressão SPI no Icarus (`test_spi_profiles.sh`), bancadas xsim/XPM (`test_sd_ddr2_vga.sh`, `test_video_ddr2.sh`, `test_top_ddr2_video.sh`) e testes Python. A baseline SPI foi reproduzida aqui: 25/25 casos PASS. |

## B. Implementação

### Formato do arquivo (HUDVID1, version 1, fmt=2)

- Setor 0: cabeçalho de 512 bytes, com a mesma estrutura `<8s6H5I16s8x>` do RGB332. Valores: `width=640`, `height=480`, `fmt=2`, `frame_bytes=frame_stride=76800`. A **paleta RGB332** ocupa os bytes 56..59 (índices 0..3) e os bytes 60..511 são zero.
- Quadros brutos, **sem cabeçalho por quadro**, com exatamente 76.800 bytes (150 setores) cada. O quadro *n* começa no LBA `base+1+150·n`.
- Endereço: `byte = y·160 + x/4`. Bits 7:6 = pixel com x%4=0; 5:4 = 1; 3:2 = 2; 1:0 = 3.
- Dados incompletos: o loader exige 512 bytes e CRC16 válido por setor e 150 setores por quadro. Um quadro parcial ou inválido nunca é publicado. Retentativas: 3. O cabeçalho precisa casar com `MAX_FILE_SECTORS = 1+150·quadros`.
- Repetição: depois do último quadro volta ao quadro 0 (comportamento já existente).
- O RTL recusa um cabeçalho com paleta diferente da sintetizada, ou com `fmt=1` na geometria 2 bpp. Ambos os casos foram testados.

### Paleta (padrão `SD_VIDEO_PALETTE = 32'h100C0400`)

| Índice | RGB332 | RGB444 na VGA | Uso |
|---|---|---|---|
| 0 | 00 | 000 | preto, sombras e faixas de letterbox |
| 1 | 04 | 020 | verde muito escuro |
| 2 | 0C | 060 | verde médio (terreno) |
| 3 | 10 | 090 | verde claro (detalhes) |

A simbologia do HUD usa `12'h0F0` (verde máximo). O vídeo para em G=9/15, o que mantém uma margem de luminância para a leitura. Antes era 0x14 (G=11), mas a prévia mostrou contraste insuficiente com o HUD. O verde máximo fica reservado à simbologia.

### Conversor (`tools/convert_video_nv2bpp.py`)

FFmpeg faz `fps=30` → escala sem distorção (`flags=area`) → `hqdn3d` (redução de ruído temporal) → faixas → luminância. Depois o numpy quantiza com limiares **globais**, calculados uma única vez a partir de quadros espalhados pelo vídeo inteiro (quantis 40/75/94 %). Assim a paleta e os limiares não mudam entre quadros. Em seguida aplica histerese temporal determinística por pixel (±6 níveis), contra a cintilação, e empacota 4 pixels por byte.

- Proporção: `letterbox` (padrão) preserva todo o campo de visão. Uma fonte 16:9 vira 640×360, com faixas de 60 linhas no índice 0. `crop` faz o recorte central. Uma fonte 4:3 não ganha faixas. O manifesto registra a área ativa.
- Saídas: `HUDVIDEO.BIN`, `metadata.json` (manifesto, hashes por quadro, CRC16 por setor, ffprobe da fonte, limiares, histograma), `palette.json`, `previa_nv2bpp.mp4` (decodificada **a partir do .BIN**) e `comparacao_qNNNNN.png` (origem, 2 bpp e simbologia fictícia 0F0).
- `verify_video.py` e `map_sd_video.py` aceitam o fmt=2 através de `parse_header`.
- A entrada nunca é alterada (há teste com SHA antes e depois), e a saída exige um diretório novo.

### RTL (diff mínimo, commit 73c91ff)

| Arquivo | Mudança |
|---|---|
| `sd_video_background.sv` | `BPP`/`PALETTE`. Com BPP=2: `read_address = y·160 + x/4`; o byte pedido 2 pixels adiante chega quando `pixel_x == future_x`, então `pixel_x[1:0]` seleciona os bits; depois vem a paleta e a mesma expansão RGB332→RGB444. Com BPP=8 o código fica inalterado, dentro de um `generate`. |
| `sd_video_loader.sv` | `FRAME_BYTES = W·H·BPP/8`; o campo fmt é conferido; os bytes 56..59 precisam ser iguais à paleta. |
| `top_reticula.sv` | `SD_VIDEO_BPP` (padrão 8), `SD_VIDEO_PALETTE` e `SD_VIDEO_FRAME_BYTES`. |
| Sem mudança | SPI, CRC16, espelho DDR2/MIG/XPM, `sd_sector_buffer`, clocks, resets, sensores, atitude, heading, controles e modos. |

O framebuffer continua compactado: dois bancos de 76.800 B, com a mesma BRAM de hoje. A leitura acontece em todo pixel a 25 MHz (o mesmo byte é lido 4 vezes), com a mesma latência de 2 ciclos já compensada. A troca de banco só ocorre com o quadro completo e em `y=480`.

## C. Resultados

### Vazão necessária e medida (modelo do controlador real, sem Nac)

76.800 B × 30 = **2.304.000 B/s**. No modelo, o CMD17 gasta `8384·HALF+2` ciclos de 100 MHz por setor. A simulação do loader 2 bpp mediu 2.515.651 ciclos por quadro a 25 MHz, ou seja, ~1 ciclo de overhead por setor.

| SCK de leitura | ms/quadro (150 setores) | Teto de FPS | Margem para 33,33 ms | Estado |
|---|---|---|---|---|
| 5 MHz (RC publicada) | 125,76 | 7,95 | −277 % | build/bit existentes, físico pendente |
| 10 MHz | 62,88 | 15,90 | −89 % | bit offline, não programado |
| 12,5 MHz | 50,31 | 19,88 | −51 % | bit offline; falhou o stress de 45 ns |
| 25 MHz | 25,16 | 39,75 | +24,5 % (≤54,5 µs de Nac/setor) | **recusado**: no modelo, MISO de 0–30 ns já gera falhas detectadas |

**Gargalo confirmado:** a frequência de leitura SPI. O formato 2 bpp não piora nem melhora a vazão, porque usa os mesmos bytes por quadro do RGB332 320×240.

**Limite da VGA:** o raster é 25 MHz/(800·525) = **59,524 Hz**. Com troca só no blanking, a apresentação máxima sem descarte é de 2 varreduras por quadro, ou **29,76 FPS** (intervalo de 33,6 ms medido na simulação). Um arquivo de 30 FPS toca 0,8 % mais devagar, sem tearing, sem descarte e sem quadro de varredura única. Não foi forçada nenhuma divisão 60/30.

### Simulações executadas (Icarus 12.0 e Verilator 5.020, commit 73c91ff)

`scripts/test_video_2bpp_icarus.sh`: **21/21 PASS**. Usa o controlador SPI real, o modelo SDHC (CRC16), o loader, o espelho DDR2 com UI MIG modelada (ready/latência aleatórios), `sd_sector_buffer`, `sd_video_background` e `vga_controller`. O XPM é um **stub** comportamental. Cada pixel visível é comparado com uma decodificação independente feita no testbench.

| Caso | Resultado |
|---|---|
| 2 bpp DDR2, nominal (25 MHz no modelo) | 4 publicações, 2.150.400 pixels, 0 erros, carga de 2.515.651 ciclos (25,16 ms), intervalos de 33,6 ms, loop de volta ao quadro 0 |
| 2 bpp DDR2: CRC injetado, timeout de token, 3 retentativas e parada, BTNL desliga/religa | erro detectado, último quadro válido mantido, recuperação; nenhum quadro parcial publicado |
| 2 bpp: cabeçalho inválido, paleta divergente, fmt=1 em 640×480 | recusados, nada publicado |
| 2 bpp SD→BRAM (sem DDR2): nominal, CRC, timeout | PASS, mesma cadência |
| Regressão RGB332 320×240 (DDR2 e BRAM, nominal, CRC, cabeçalho) | PASS, comportamento igual ao anterior |
| Cadência 2 bpp a 12,5 / 10 / 5 MHz | 50,4 / 67,2 / 117,6–134,4 ms → **19,84 / 14,88 / ~7,76 FPS apresentados**; `late_frames` incrementa e nenhum quadro é descartado |
| 25 MHz com Nac de 55 µs/setor | carga de 33,41 ms (passa de 33,33 por 0,24 %); apresentação ainda a 33,6 ms |
| Equivalência RTL × Python | 307.200 pixels da varredura VGA (DDR2 e BRAM) = `convert_video_nv2bpp.decode`: **0 divergências**, com os 256 valores de byte nas 4 posições |

Lint Verilator do `top_reticula` completo (stubs unisim): com BPP=2 e com BPP=8 não há erro. O conjunto de avisos do BPP=8 é **idêntico** ao da base (456 = 456), e o BPP=2 não acrescenta aviso novo.

Baseline SPI (`test_spi_profiles.sh`, sem alterações): 25/25 PASS, reproduzindo 83.842 / 41.922 / 33.538 ciclos por setor e a detecção de falha a 25 MHz com MISO de 0–30 ns.

Python: 6 suítes PASS, incluindo 14 testes novos do conversor (ordem de pixels, roundtrip exaustivo, paleta = expansão do RTL, cabeçalho e corrupções, letterbox 16:9, 4:3, crop, determinismo, histerese, preservação da entrada). A guarda de hash `test_p4b_contract.py` foi atualizada conscientemente para o novo `sd_video_loader.sv`. O `verificar_estatico.py` tem a mesma falha da base ("clock 200 MHz com MMCM"), que já existia antes deste trabalho.

**`top_reticula` completo** (`scripts/test_top_video_2bpp_icarus.sh`, `MODES=2`, commit 61a7f19; RTL igual ao de 73c91ff). O teste usa o HUD real, o ícone SD, o diagnóstico, BTNL e o espelho DDR2 com o modelo de UI MIG; BUFG, MMCM, XADC e XPM são **stubs**. Resultado: **PASS**, com 1.536.000 pixels VGA comparados com vídeo 2 bpp, HUD opaco ou ícone; 4 publicações; HS/VS inalterados; troca só no blanking; BTNL volta ao HUD; diagnóstico isolado. Foram cobertas **2 das 12** combinações de modo (estilos padrão e CACA). As outras 10 não rodaram, porque o top no Icarus simula a ~70 µs/s. Capturas: `top_2bpp_modo0.png` e `top_2bpp_modo1.png`.

### Recursos e timing

**NÃO EXECUTADOS** (sem Vivado nesta sessão). Expectativa, sem medição: BRAM igual (mesmo `BYTES`); poucas dezenas de LUTs (seletor de 2 bits, paleta constante e comparação de 4 bytes no cabeçalho). O caminho 25 MHz `pixel_x → shift → paleta → RGB` acrescenta 2 a 3 níveis de LUT depois da BRAM. A base fechou com WNS +0,346 ns e WHS +0,026 ns (10 MHz), então é preciso **conferir no build real**.


## D. Evidências

| Item | Classificação |
|---|---|
| Conversor, formato 2 bpp, empacotamento, paleta RGB332 e cabeçalho | **CONFIRMADO por teste** (dados sintéticos) |
| Conversão do vídeo real E4DvcvNDQoQ.mp4 e prévia real | **NÃO VALIDADO**: o original está indisponível; nenhum quadro real foi gerado |
| Decodificador RTL 2 bpp, endereçamento 640×480, limites, troca de banco em y=480, HUD por cima | **CONFIRMADO por teste** (simulação de módulos integrados) |
| Equivalência RTL × Python | **CONFIRMADO por teste** |
| Preservação do RGB332 | **CONFIRMADO por teste** (regressão e lint idênticos) |
| Caminho DDR2 com XPM oficial | **PARCIAL**: o stub passou; `BPP=2 test_sd_ddr2_vga.sh` (xsim) não foi executado |
| Composição no `top_reticula` completo | **PARCIAL**: PASS em 2 de 12 modos com stubs; `tb_top_video_2bpp` no xsim/unisims (12 modos) não executado |
| Vazão para 30 FPS | **PARCIAL**: só a 25 MHz no modelo, perfil já recusado eletricamente; a 5/10/12,5 MHz **não atinge** a meta (confirmado em simulação) |
| 29,76 FPS como teto de apresentação na VGA de 59,52 Hz | **CONFIRMADO por teste** (simulação) |
| Síntese, implementação, timing, DRC, CDC, bitstream | **NÃO VALIDADO** (não executados) |
| Funcionamento físico, Nac do cartão, SPI elétrico, FPS na placa | **INDETERMINADO** |
| Sensores, atitude, heading, modos | preservados por **identidade de fonte** (sem diff); não reobservados na VGA física |


## E. Candidata experimental e preparo físico (NÃO executado)

Não há bitstream: o Vivado não estava disponível nesta sessão. Para gerar o arquivo na sua máquina:

1. **Conversão (prévia primeiro):**
   `python3 tools/convert_video_nv2bpp.py <dir-novo> --input <E4DvcvNDQoQ.mp4> --start 210 --seconds 10`
   Revise as comparações e a prévia. Depois rode `--full` (≈17.331 quadros, 1.331.020.800 B de quadros mais o cabeçalho) e então `python3 tools/verify_video.py <dir>`.
2. **Mídia (pela pessoa responsável, fora desta sessão):** copiar `HUDVIDEO.BIN` para o FAT32 do cartão de teste, `sync`, e mapear **somente em leitura** com `python3 tools/map_sd_video.py /dev/sdX <dir>/HUDVIDEO.BIN` para obter LBA e setores contíguos (setores = 1+150·quadros). Não reaproveitar o LBA 30028160 sem conferir.
3. **Build offline:** com o checkout limpo deste commit, rodar `bash scripts/build_video_2bpp_profile.sh 10 <LBA> <SETORES>` (5 MHz; 5 ou 4 só depois de qualificar a interface), conferir WNS/WHS/DRC/CDC e depois rodar `bash scripts/emit_spi_profile_bit.sh resultado-v2bpp-h010-<commit>`. USERCODE esperado: `5D` + 4 hex do commit + `8A` (bit 7 marca o 2 bpp).
4. **Antes da placa:** `BPP=2 bash scripts/test_sd_ddr2_vga.sh` (XPM oficial) e a bancada `tests/tb_top_video_2bpp.sv` no xsim, com unisims.
5. **JTAG (com autorização específica):** carregar só a SRAM pelo Hardware Manager e ler `REGISTER.USERCODE`. Seguir o PROCEDIMENTO_TESTE_FPGA.md: LD12/13/14 acesos e LD15 apagado; fundo verde de 4 tons; HUD legível nos 12 modos; BTNL; joystick; bússola; atitude; 10 minutos. Valores esperados: a 5 MHz ~7,9 quadros novos/s (uns 4× mais devagar que o original) e a 10 MHz ~15,9/s. Para recuperar, desligar e religar (a Flash não foi tocada).

## F. Próximo passo para comprovar 30 FPS na placa

1. Qualificar fisicamente a RC de 5 MHz e, em seguida, este perfil 2 bpp na mesma frequência (identidade de imagem e HUD).
2. Medir o Nac real do cartão e o par SCK→MISO com instrumento.
3. Implementar e fechar uma captura SPI dedicada (IOB/IDDR/fase, proposta em SPI_PERFIS_INCREMENTAIS.md) que permita **25 MHz** com o Nac médio ≤ ~54 µs/setor.
4. Integrar a sonda `video_publication_metrics` e medir os ACKs por segundo. A meta realista de apresentação é 29,76 FPS, limitada pelos 59,52 Hz da VGA.
