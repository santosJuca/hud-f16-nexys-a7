> Documento histórico da versão inicial. Para a sprint noturna, consulte README.md e RESULTADO_FINAL.md. Os caminhos e resultados abaixo pertencem à referência anterior.

# HUD F-16: integração DDR2 em validação offline

Esta cópia isolada parte das fontes locais P4B, preservadas pelo manifesto `evidencias/base-p4b-sha256.json`. O repositório original `hud-video-modos-20261106` e os experimentos P3D/P4A/P4B não foram editados. A integração não foi enviada ao GitHub.

## Caminho implementado

```text
microSD → SPI/CMD17/CRC16 → sd_video_loader
                            ↓ eventos de quadro e bytes RGB332
                         empacotador 128 bits
                            ↓ FIFO Gray 100 MHz → UI MIG
                         DDR2: quadro provisório
                            ↓ releitura + CRC32
                         FIFO Gray UI MIG → 100 MHz
                            ↓ bytes + commit/abort
                         dois bancos BRAM de saída
                            ↓ troca no blanking vertical
                         compositor HUD → VGA 640×480 / 25 MHz
```

`ENABLE_DDR2_VIDEO=1` seleciona os bytes relidos da DDR2 para o buffer de exibição. Exige `ENABLE_DDR2_SD_MIRROR`, `ENABLE_SD_VIDEO` e `ENABLE_SD_SUBSYSTEM`. Com `ENABLE_DDR2_VIDEO=0`, o caminho SD → BRAM original permanece disponível.

Há um quadro de trabalho na DDR2 e dois bancos BRAM de saída. Não há dupla superfície DDR2 nem carregamento e releitura DDR2 simultâneos. O novo caminho usa a DDR2 efetivamente, mas conserva um quadro inteiro em BRAM para manter a última imagem íntegra e a troca sem tearing. A aceitação do próximo quadro também aguarda disponibilidade do buffer de saída; isso pode limitar a cadência.

Os bytes são provisórios até o CRC16 dos setores e o CRC32 da releitura serem aprovados. Quadros incompletos, abortados ou corrompidos não recebem commit de exibição. Falhas de MIG abortam o quadro em construção. O espelho drena eventos antigos antes de aceitar nova transação. Reset de qualquer domínio e perda de calibração descartam a transação nos dois lados das FIFOs, com liberação sincronizada em cada clock.

## CDC, temperatura e limites

`ui_ready` é registrado no clock MIG antes dos dois estágios `ASYNC_REG`. Os ponteiros Gray, o payload retido das FIFOs e os handshakes recebem limites de 8 ns; os barramentos Gray também recebem `set_bus_skew`. O limite é menor que os períodos dos domínios envolvidos. As únicas novas exceções `set_false_path` atingem os quatro pinos PRE dos sincronizadores de reset, conferidos por nome e propriedade; os caminhos dos resets locais até os registros funcionais permanecem temporizados.

O modelo XADC AMD 2026.1 mediu 116,483 µs entre atualizações com DCLK=100 MHz. No modo DDR2_VIDEO, um clock MMCM de 102,564 MHz alimenta o XADC, mantendo o divisor ADC=4 e ADCCLK=25,641 MHz. Foram observadas 20 atualizações com intervalo máximo de 113,578 µs no modelo. A média de temperatura e calibração permanece em 16 amostras. Um handshake transfere o par de amostras do joystick ao HUD de 100 MHz; a referência MIG continua em 200 MHz. Isto é simulação, não medição na placa.

As fontes dos algoritmos de MPU, heading, atitude, controle de joystick, loader SD, buffer BRAM e compositor de vídeo coincidem com o worktree funcional consultado. O novo clock XADC, seu CDC e a integração DDR2 ainda exigem ensaio físico.

Referências: [AMD UG903, bus skew](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/About-Bus-Skew-Constraints), [AMD UG586, temperatura](https://docs.amd.com/r/en-US/ug586_7Series_MIS/Temperature-Monitor), [AMD UG480, DRP/ADC](https://docs.amd.com/r/en-US/ug480_7Series_XADC/Control-Registers), [FFmpeg, RGB8/RGB332](https://www.ffmpeg.org/doxygen/8.1/pixfmt_8h.html).

## Reproduzir

Requer Vivado 2026.1, Icarus Verilog, Python 3 e FFmpeg. Em clone novo, inicialize o submódulo Digilent fixado pelo Git com `git submodule update --init`. Os scripts preservam diretórios de resultado existentes e recusam sobrescrita.

```bash
bash scripts/test_video_ddr2.sh
bash scripts/build_p4c_offline.sh
# Para repetir a qualificacao a partir do checkpoint roteado existente:
"$HOME/AMD/2026.1/Vivado/bin/vivado" -mode batch -source scripts/requalificar_routed.tcl -tclargs "$PWD"
```

O segundo comando gera síntese, implementação e relatórios, sem `.bit`, JTAG ou Flash. Usa LBA sintético 1 e 13.501 setores para análise do perfil de 90 quadros, com defaults de sensores da base. Não representa um cartão real nem reproduz os parâmetros de calibração do bitstream físico. Não usá-lo para programação. Os parâmetros físicos aprovados estão preservados em `evidencias/perfil-fisico-preservado.json`. O mapa real e esses parâmetros precisam ser incorporados antes de gerar um candidato físico.

Os testes dirigidos exercitaram quadro integral de 76.800 bytes e sua leitura pelo buffer de saída, corrupção, commit incompleto, abort, stalls, overflow da FIFO, timeout de leitura, `app_rd_data_end` inválido, resets independentes e perda de calibração. Também foram exercitados três quadros diferentes nas mesmas posições DDR2 e a preservação da imagem anterior após corrupção. O MIG do teste é um modelo da interface, sem PHY DDR2 real. Esses testes não medem throughput físico do cartão.

## Vídeo e cartão

A origem local é `/home/santojuca/Downloads/videos-hud/E4DvcvNDQoQ.mp4`, 1920×1080, 60 FPS, duração aproximada de 577,7 segundos. A conversão nova preserva o aspecto 16:9 em 320×240 com barras horizontais, gera RGB332 pelo FFmpeg e registra hashes por quadro e CRC16 por setor. O arquivo completo fica em `validation/video-completo-320-30/HUDVIDEO.BIN`, com metadados ao lado.

Para reproduzir a conversão e sua conferência, criando um diretório novo:

```bash
mkdir -p validation
python3 tools/convert_video_for_fpga.py validation/video-completo-320-30 --input /home/santojuca/Downloads/videos-hud/E4DvcvNDQoQ.mp4 --width 320 --fps 30 --seconds 578
python3 tools/verify_video.py validation/video-completo-320-30
```

O resultado tem 17.331 quadros, 1.331.021.312 bytes e SHA-256 `fb5dfdb6bae21b7285d3053bd4725d8f86a06ef0d4a49b311a364075600b3643`. Os hashes dos quadros e 2.599.650 CRC16 de setores foram recalculados e conferidos. A ordem dos canais RGB332 foi testada com cores primárias; uma corrupção deliberada em arquivo temporário foi rejeitada pelo verificador.

A taxa do arquivo é 30 FPS; a reprodução física nessa taxa não foi comprovada. O payload de 320×240/30 exige 2.304.000 bytes/s, sem contar overhead SPI. DDR2 não aumenta a capacidade de leitura do cartão.

A cópia histórica de 160×120/1 FPS, 578 quadros e 11.246.080 bytes foi reencontrada com SHA-256 `615729d0740adc978b42fdf0a13dc4f18820109e4dd9e68ac66d137d431012d0`. O microSD está na Nexys, segundo o usuário, e não aparece como dispositivo no computador. Seu arquivo atual, FAT32, contiguidade, identidade e LBA continuam NÃO RECONFERIDOS. Nenhum número histórico foi usado como mapa físico nesta execução. Não houve escrita no cartão.

## Recuperação e estado físico

O usuário confirmou neste chat que a Nexys iniciou pela Flash após desligar e religar e que está funcionando. Trata-se de confirmação do firmware preservado, não da integração nova.

O bitstream de recuperação existente foi conferido novamente:

- Arquivo: `/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`.
- SHA-256: `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`.
- FPGA documentada: Nexys A7-100T / `xc7a100t_0`; alvo documentado `Digilent/210292AD34F5A`. Não foi reconsultado via JTAG nesta execução.

O manifesto `evidencias/recuperacao-preservada.json` registra os caminhos e hashes da MCS SPIx1 e das leituras integrais de Flash. As duas cópias anteriores ao erase continuam idênticas, SHA-256 `6f0b00c5ef632a64c29b6136a091ce1ca8033116bb0dc0d13fb5354663d12e05`. Restauração de Flash não foi ensaiada nesta execução.

Como a Flash não foi alterada, o retorno após um futuro teste JTAG volátil pode usar o boot SPI/QSPI já confirmado pelo usuário, com JP1 na posição que funciona atualmente. Conferir o alvo e o hash antes de qualquer carga JTAG. Não regravar a Flash como primeira tentativa de recuperação. Uma restauração da Flash exigirá identidade atual da memória e procedimento documentado; os scripts históricos permanecem no diretório de backup.

## Pendências para aprovação física

1. Conferir o cartão em leitura somente e obter um mapa atual compatível com o vídeo.
2. Qualificar timing externo SPI com cartão, pinagem, níveis e atrasos reais. Os XDC existentes declaram essa lacuna; não foram inventados delays.
3. Aprovar STA, CDC, DRC, skew e clocking da implementação integrada, incluindo alertas do MIG.
4. Incorporar a calibração/orientação do firmware aprovado e gerar `.bit` identificável, somente após os gates técnicos.
5. Ensaiar JTAG, vídeo contínuo, HUD, sensores, reset e recuperação com observação física.
6. Somente após aprovação física, tratar a autorização condicional de Flash, backup, verificação e novo boot.

O atlas elétrico foi adicionado separadamente à `main` do projeto original pelo commit `14d1bf00d26a621e5d1213a41ff8071a9026a91e`. Nenhuma fonte FPGA experimental foi incluída nesse envio.

## Resultado de implementação

A execução inicial está em `resultado`. Após acrescentar o limite de 8 ns ao primeiro estágio de validade do XADC, o checkpoint foi otimizado e roteado novamente em `resultado-qualificado`: WNS +0,539 ns, WHS +0,049 ns, oito grupos de bus skew aprovados (menor folga +6,604 ns) e DRC sem erros. `REQP-1709` continua como warning do clocking MIG.

O relatório CDC final conserva CDC-1 crítico (243), CDC-13 crítico (144), CDC-10 crítico (3), CDC-8 warning (1), CDC-6 warning (4) e CDC-15 warning (333). Há caminhos do payload LUTRAM das FIFOs próprios que o analisador não reconhece como uma estrutura CDC padrão; os três CDC-10 atingem redes de reset (dois no reset do espelho e um no MIG). A simulação e os limites de atraso/skew fornecem evidência dirigida, mas não encerram a qualificação CDC. Não foram criados waivers para ocultar esses alertas. O checkpoint é uma evidência de STA interno aprovado, não um artefato liberado para hardware.
