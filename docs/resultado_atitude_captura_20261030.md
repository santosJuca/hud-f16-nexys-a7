# Resultado da evolução de atitude e captura, 30/10/2026

## Entrega e preservação

Implementação local na branch `feat/video-sd-overlay`, commit base `0271499a8538135abc6291e512b421382337c7c2`. O working tree já continha o vídeo e alterações não commitadas. O backup inicial foi relido e verificado por SHA-256 para 274 arquivos antes das edições.

As novas funções são: geometria ortonormal em roll ±180°, escada na mesma transformação, referência da aeronave fixa, estimador vetorial de gravidade com gyro dos três eixos, calibração estacionária e zero temporário, captura sem framebuffer adicional, passo único, quatro vistas, grade e diagnóstico.

Foram conferidos byte a byte contra o manifesto inicial os 15 arquivos `rtl/sd_*.sv`, `rtl/mpu6050_i2c.sv`, `rtl/vga_controller.sv` e `constraints/nexys_a7_reticula.xdc`. O pipeline de vídeo/SPI, driver MPU, raster e XDC original não foram alterados nesta evolução. O top integra as funções e lê novas restrições específicas de CDC; os scripts de build incluem esse XDC. As alterações locais anteriores permanecem preservadas.

Novos módulos: `atitude_cordic`, `atitude_vetorial`, `horizonte_atitude`, `captura_controle`, `video_captura` e `calibracao_vga`. Foram modificados o top e `simbologia_vga`. Testes posicionais receberam os novos operandos; testes históricos de conversão limitada selecionam `FULL_ATTITUDE=0`. A integração dos modos usa a nova fonte vetorial no teste do padrão completo.

## Evidências de funcionamento

Pasta: `validation/hud-attitude-20261030-172730/`.

| Verificação executada | Resultado |
|---|---|
| Geometria RTL contra seno/cosseno de referência | 190171 pontos; 270 verificações de linhas; roll/pitch e combinações pedidos; varredura -180..180° |
| Estimador vetorial com IMU sintético | 4713 comparações dinâmicas; 5188 atualizações; bias, eixos, aceleração, zero, perda e timeout |
| Controles | Debounce, toque curto/longo, passo, vista, grade, pulso de zero aprovados |
| Captura no pipeline SPI/BRAM/VGA | 3379200 pixels; três passos individuais e retomada; quadro estável entre passos; 0 erros SPI |
| Captura no top | 5222400 pixels; quatro vistas; atualização 90°/10° durante congelamento; passo; ícone e transparência |
| Top de vídeo original | 4300800 pixels; 12 combinações de modo/estilo/declutter; BTNL e diagnóstico preservados |
| Regressão `scripts/test_video.sh` | Seis cenários aprovados: normal, CRC, timeout, cabeçalho inválido, retries limitados, alternância de fundo |
| Regressão dirigida de módulos existentes | 18 testbenches aprovados, inclusive I2C MPU, CDC, dados HUD, sensores e modos |
| Inspeção visual do raster real | Seis imagens, bank 0/30/60/90/120/180°, pitch +10°, retícula fixa; painel de diagnóstico em 90° |
| Integridade de whitespace | `git diff --check` aprovado |

Logs principais: `acceptance.log`, `acceptance/video.log`, `sensor-bounded.log`, `legacy-regression-compatible.log`, `top-video-modes.log`, `preview.log`. Os testes do estimador comprimem o tempo para um perfil lógico de 1 MHz, com coeficiente de integração escalado proporcionalmente. O clock de implementação e a análise temporal permanecem em 100 MHz. A integração de captura força a saída do estimador para isolar CDC/composição; não representa observação do sensor físico.

A primeira implementação reprovou STA no produto vetorial. Separar os produtos e a subtração ainda deixou caminhos largos. A versão qualificada dimensiona os registradores pelos limites do sensor e usa incrementos Q17 de 18 bits e vetor Q20 de 24 bits. Os relatórios das tentativas foram preservados, sem gerar bitstream a partir delas. Não foram acrescentadas exceções temporais para contornar os caminhos internos.

## Recursos e temporização após route

Vivado 2026.1, `xc7a100tcsg324-1`, mesmo perfil histórico de vídeo 160×120/1 FPS/SPI half=125.

| Métrica | Baseline de vídeo arquivado | Evolução final |
|---|---:|---:|
| LUT | 13850 | 15696 (24,76%) |
| FF | 8645 | 10393 (8,20%) |
| RAMB36 | 16 | 16 |
| RAMB18 | 2 | 2 |
| DSP | 32 | 62 (25,83%) |
| BUFG | 2 | 2 |
| WNS | Ver relatório anterior | +0,356 ns |
| WHS | Ver relatório anterior | +0,010 ns |
| TNS / THS | Ver relatório anterior | 0 / 0 |

Relatórios finais: `implementation-bounded/{utilization,timing_summary,check_timing,cdc,bus_skew,drc}.rpt`.

CDC: 339 endpoints sistema→pixel e 7 pixel→sistema classificados seguros, mais 6 entradas assíncronas com sincronizadores; 0 unsafe, 0 unknown e 0 sem ASYNC_REG. Bus skew: 1,518 ns no mailbox anterior e 1,538 ns nos novos, abaixo do limite de 10 ns. Endpoints internos sem restrição e sem clock: 0.

DRC: 0 erros; 102 avisos de pipeline DSP (DPIP-1=32, DPOP-1=27, DPOP-2=43). O build anterior documentava 55 avisos dessas classes. Eles não foram ocultados; o STA roteado atende aos períodos definidos. Não há aprovação elétrica derivada desses avisos nem da simulação.

Permanecem 28 entradas sem input delay e 38 saídas sem output delay no relatório. As exceções existentes de entradas assíncronas não qualificam a interface SPI com o cartão; SD_DAT0 e saídas SPI continuam exigindo orçamento externo e medição. A margem de hold de 0,010 ns é positiva nesta execução, mas pequena: qualquer nova alteração exige novo STA.

## Artefato experimental

Somente para revisão e futura validação assistida, sem liberação definitiva:

`validation/hud-attitude-20261030-172730/implementation-bounded/experimental_attitude_capture.bit`

SHA-256: `59f7e458522bb1616e344b0fcc648d6d53f1c6a8495f886267ed160594a3d3f6`.

Checkpoint roteado SHA-256: `439317b76966ab47d907a0c2bcf8e8d55b56c95a0561cfa03f605727d9ab8eb3`.

Gerado a partir do checkpoint que passou STA/DRC, sem nova síntese e sem abrir Hardware Manager. `experimental-bitstream.log` e `classification.txt` registram a classificação. Não houve programação JTAG, Flash, escrita no cartão, alteração física, push, merge ou release. Os LBAs são do mapa local histórico, sem revalidação do dispositivo nesta execução.

Para reproduzir o build em diretório novo, a partir da raiz do repositório:

```sh
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -nojournal -nolog \
  -source scripts/build_attitude_capture.tcl \
  -tclargs /tmp/hud-atitude-build-novo 30006144 21965 125 160 1 \
  /home/santojuca/Downloads/Trabalho-display-aviao-v2-video-sd/tests/hud_aircraft_64.hex mapped
```

Os parâmetros acima reproduzem o mapa arquivado e não atestam a posição atual do arquivo no cartão. O script gera somente artefato explicitamente experimental após os gates; não programa a placa. Revalidar o mapa antes de utilizar qualquer artefato na placa, sem escrever no dispositivo.

## O que permanece pendente

A simulação comprova geometria e integração lógica; o funcionamento da caixa na placa ainda não foi observado. Restam identificar e conferir a montagem real do sensor, aprovar eventual transferência física, confirmar os sinais e retorno ao zero com referência angular independente, autorizar separadamente a programação volátil experimental e executar o roteiro de `montagem_caixa_mpu6050.md`. Também permanece a qualificação temporal/elétrica externa SPI já documentada pelo projeto.

O vídeo é vista de cockpit, com enquadramento que inclui o painel; a origem em simulador é uma inferência visual. FOV, boresight e fixação da câmera não estão calibrados. Não se pode exigir coincidência óptica apenas ajustando offsets do sensor. A escala de pitch é linear, 4 px/°, limitada visualmente a ±40°. O zero tem limiar de repouso, não uma prova física de ausência absoluta de movimento. A calibração inicial é de uma pose conhecida, sem identificação completa de erros de escala ou montagem.

Procedimento operacional: `simulador_manual_atitude.md`, `modo_captura_calibracao.md`, `geometria_horizonte_artificial.md` e `montagem_caixa_mpu6050.md`. A próxima ação indispensável é a validação física assistida e a qualificação restante, mantendo o baseline disponível para recuperação.
