> Documento histórico da versão inicial. Para a sprint noturna, consulte README.md e RESULTADO_FINAL.md. Os caminhos e resultados abaixo pertencem à referência anterior.

# HUD FPGA Nexys A7-100T — P4B espelho microSD → DDR2 (experimental)

## Objetivo e limites

Este patch acrescenta, **sob habilitacao explicita**, um caminho de observacao paralelo ao video original:

`sd_video_loader` (clk_hud 100 MHz) → empacotador 16×8 bits → FIFO assincrona Gray (32 eventos) → escrita de 128 bits pela UI MIG (~81,25 MHz) → leitura do mesmo endereco → CRC32 do quadro.

A imagem exibida na VGA continua **exclusivamente pelo caminho BRAM que ja funciona**. O teste P3D de 16 palavras e o P4A sintetico de 4.800 palavras ficam disponiveis, mutuamente exclusivos com P4B. Nao edita `sd_video_loader.sv`, `sd_sector_buffer.sv`, `sd_video_background.sv`, `atitude_vetorial.sv`, a configuracao MIG, os XDCs nem os scripts Vivado de implementacao.

O loader recebe bytes antes da validacao CRC do setor. O espelho pode escreve-los provisoriamente na area DDR2 de teste, mas **PASS so ocorre apos frame_commit do loader e CRC32 da releitura DDR2**. Falha de CRC do setor (frame_abort), falta de bytes, overflow na FIFO, falha do CRC de releitura e timeout impedem PASS. O loader BRAM nao e bloqueado pelo espelho: se o espelho estiver ocupado, quadros subsequentes nao sao espelhados. Este primeiro P4B **nao garante espelhamento de todos os quadros**, nao oferece double buffering DDR2, nem apresenta pixels da DDR2 na VGA.

O teste de releitura usa CRC32 de quadro (risco teorico de colisao), e nao armazenamento de copia integral para comparacao byte a byte. Valores de pixel obtidos do microSD podem ser quaisquer dados RGB332; o espelho nao reinterpreta os pixels.

## Aplicacao segura no Ubuntu

Extrair `HUD_DDR2_P4B_PATCH.tar.gz` em `~/Downloads/`. Requer a pasta local `~/Downloads/hud_ddr2_p4a_frame_test` que passou pelos testes anteriores:

```bash
bash "$HOME/Downloads/hud_ddr2_p4b_patch/aplicar_p4b.sh"
```

O aplicador verifica SHA-256 dos arquivos criticos P4A e cria somente `~/Downloads/hud_ddr2_p4b_sd_mirror`. Nunca sobrescreve a origem, nem copia o `resultado` da compilacao P4A.

## Testes Icarus

```bash
bash "$HOME/Downloads/hud_ddr2_p4b_sd_mirror/scripts/test_p4b.sh"
```

Cenarios: 256 bytes corretos, quadro integral 76.800 bytes correto, corrupcao introduzida no modelo de DDR2, commit incompleto, abort do loader e stall permanente do MIG. Os clocks do testbench sao independentes (100 e ~81,25 MHz). **O testbench usa um modelo simplificado da UI MIG, nao simula PHY DDR2 real ou temporizacao eletrica**.

## Sintese e roteamento (sem bitstream)

Executar **somente apos** as simulacoes Icarus e apos obter o mapeamento do arquivo RGB332 no **cartao atual**: LBA inicial do cabecalho e total de setores contiguos, resolucao e FPS reais. A configuracao aceita `SD_VIDEO_LBA` e `SD_VIDEO_SECTORS` como genericos (e tem um `initial $error` para impedir os padroes zero em P4B):

```bash
P="$HOME/Downloads/hud_ddr2_p4b_sd_mirror"
# Estes valores devem ser definidos a partir do mapa VERIFICADO do cartao atual.
test -n "${SD_VIDEO_LBA_VERIFICADO:-}"
test -n "${SD_VIDEO_SECTORS_VERIFICADO:-}"
test -n "${SD_VIDEO_WIDTH_VERIFICADA:-}"
test -n "${SD_VIDEO_HEIGHT_VERIFICADA:-}"
test -n "${SD_VIDEO_FPS_VERIFICADO:-}"
bash "$P/scripts/run.sh" \
  ENABLE_SD_SUBSYSTEM=1 \
  ENABLE_SD_VIDEO=1 \
  ENABLE_DDR2_SD_MIRROR=1 \
  ENABLE_DDR2_FRAME_TEST=0 \
  SD_VIDEO_LBA="$SD_VIDEO_LBA_VERIFICADO" \
  SD_VIDEO_SECTORS="$SD_VIDEO_SECTORS_VERIFICADO" \
  SD_VIDEO_WIDTH="$SD_VIDEO_WIDTH_VERIFICADA" \
  SD_VIDEO_HEIGHT="$SD_VIDEO_HEIGHT_VERIFICADA" \
  SD_VIDEO_FPS="$SD_VIDEO_FPS_VERIFICADO"
```

**ATENCAO:** `SD_VIDEO_LBA=0` e `SD_VIDEO_SECTORS=0` sao valores padrao que desabilitam o carregamento de video real do cartao. O P4B rejeita esses defaults; nao use LBA ou setores de experimento, mapa antigo ou numeros inventados no build destinado a hardware. Nao grave SD/flash.

Resultado esperado: `P3A_BUILD_ROUTED`, WNS/WHS >= 0 e relatórios em `resultado`. O resultado de tempo de P4A +0,193/+0,021 ns **nao garante** timing do P4B.

## Restricoes conhecidas e bloqueios fisicos

- A UI MIG requer `app_rdy` + `app_wdf_rdy` para aceitar comando e dados da mesma escrita; o P4B so os emite no mesmo ciclo de aceite. Endereco aumenta 8 unidades por BL8 128 bits.
- CRC32 do stream e verificado contra a releitura da DDR2. Nao publica video DDR2, somente LEDs de status existentes.
- O desenho da FIFO utiliza ponteiros Gray e sincronizadores ASYNC_REG. Reset independente dos dominios e recuperacao durante perda de calibração ainda requerem qualificacao, alem de `report_cdc -details` do projeto integrado.
- O MIG conserva os alertas de clock `REQP-1709` e de reset `CDC-10`/`CDC-8` observados no P3D; nenhum alerta e mascarado automaticamente.
- O firmware do loader requer validacao FAT32/LBA real no computador e controlador SPI suficiente para FPS desejado.
- Nao foi realizado acesso ao hardware ou gerado/programado bitstream.

## Sem alteracoes no algoritmo de atitude

`atitude_vetorial.sv` e os modulos de sensor sao copiados sem modificacao. Caso as simulacoes ou o Vivado falhem, P4A e P3D permanecem intactos; nao executar programacao na placa.
