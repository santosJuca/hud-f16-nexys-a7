# Resultado da missão HUD F-16

## CONFIRMADO

- Código integrado localmente na branch `integration/ddr2-video`, commit de implementação `6fbdbd119fcd527f61a5629f887a09e70572a617`. Diretório: `/home/santojuca/Downloads/hud_ddr2_video_integracao`. Identificação local: `rc/hud-ddr2-offline-20261108`.
- `ui_ready` registrado no domínio MIG; reset coordenado das FIFOs e recuperação após perda de calibração exercitados em simulação.
- Fluxo SD → DDR2 → FIFO de retorno → buffer BRAM de exibição implementado sob `ENABLE_DDR2_VIDEO`. O caminho BRAM anterior continua selecionável. Modelo MIG, quadro integral e pixels no buffer de saída passaram; corrupção não substituiu a última imagem íntegra.
- STA interno final: WNS **+0,539 ns**, WHS **+0,049 ns**. Oito grupos de bus skew passaram; menor folga **+6,604 ns**. DRC sem erros, com warnings preservados. Relatórios em `resultado-qualificado/` e log `evidencias/requalificar.log`.
- XADC com média de 16 amostras: maior intervalo observado **113,578 µs**, em 20 atualizações do modelo AMD. O teste anterior de 100 MHz encontrou **116,483 µs**. A referência MIG continua em 200 MHz; os algoritmos dos sensores não foram alterados.
- Vídeo completo local: **RGB332, 320×240, taxa nominal de arquivo 30 FPS, 17.331 quadros**, proporção 16:9 preservada com barras. Arquivo `validation/video-completo-320-30/HUDVIDEO.BIN`, **1.331.021.312 bytes**. SHA-256 `fb5dfdb6bae21b7285d3053bd4725d8f86a06ef0d4a49b311a364075600b3643`. Hashes de todos os quadros e **2.599.650 CRC16** recalculados e aprovados. Cinco testes do conversor passaram; corrupção deliberada de arquivo temporário foi rejeitada pelo verificador.
- Checkpoint roteado `resultado-qualificado/routed.dcp`: SHA-256 `ca38d575e9f3b260d6841c23c787850d2d2ca50fcaa6d6ac1dd822374ce14ff0`.
- Recuperação preservada: bitstream funcional SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`, MCS SPIx1 e duas cópias integrais anteriores da Flash conferidas por hash. Caminhos em `evidencias/recuperacao-preservada.json`. O usuário confirmou que o firmware preservado inicia pela Flash e está funcionando.
- Atlas elétrico: os 11 documentos foram enviados separadamente à `main` do repositório original, commit `14d1bf00d26a621e5d1213a41ff8071a9026a91e`. Nenhuma fonte experimental FPGA foi enviada.

## NÃO VALIDADO

A integração nova não foi programada na FPGA. Não há prova física de DDR2, CRC, XADC, vídeo contínuo, sensores, resets ou FPS desse candidato. A simulação usa modelo da UI MIG, sem PHY DDR2 real. O teste de pixels cobre o buffer usado pela exibição; não constitui medição do monitor VGA nem ensaio de bancada.

A arquitetura usa um quadro DDR2 e dois bancos BRAM, sem dupla superfície DDR2 ou escrita e releitura simultâneas. A taxa efetiva pode ser limitada pela leitura SPI e pela espera de publicação do buffer. Não foi medida taxa física nem prometida reprodução a 30 FPS.

## BLOQUEIOS

- O cartão permanece na Nexys; o usuário informou que não pode transferi-lo para o leitor nesta sessão. Identidade, arquivo, FAT32, integridade atual e mapa LBA do cartão: **INDETERMINADOS nesta execução**. A cópia histórica local foi localizada, mas não prova o conteúdo atual do cartão.
- CDC ainda sem sign-off: o relatório conserva **243 CDC-1**, **144 CDC-13** e **3 CDC-10** críticos, além dos warnings CDC-6/8/15. Muitos endpoints correspondem ao payload das FIFOs LUTRAM próprios; os CDC-10 atingem redes de reset do espelho e do MIG. Os caminhos foram limitados e exercitados, mas os alertas não foram removidos nem mascarados por waivers. A avaliação de troca por XPM precisa preservar FWFT, reset e compatibilidade de simulação; não foi feita uma substituição não validada.
- `REQP-1709` permanece no clocking MIG. A temporização externa SPI, níveis/topologia reais e throughput útil do cartão continuam sem qualificação suficiente.
- O build de STA usa mapa sintético e defaults de sensores. O perfil físico aprovado foi preservado em `evidencias/perfil-fisico-preservado.json`; ele e o mapa real ainda precisam integrar e validar o candidato destinado à placa.

## RESULTADO FINAL

**Entrega offline preservada, com integração funcional em simulação e timing interno aprovado. A missão física permanece incompleta.** Não foram gerados novos `.bit`/`.mcs` liberados para uso, nem realizados JTAG, escrita no microSD ou nova gravação da Flash. O boot confirmado pelo usuário pertence ao firmware preservado.

A próxima ação física indispensável é disponibilizar o cartão ao computador para inspeção somente leitura. Antes de programar a FPGA, também é necessário encerrar os bloqueios CDC/clocking/SPI, aplicar o perfil físico preservado e identificar o novo artefato. A autorização condicional de Flash permanece sem condições técnicas satisfeitas.

Arquitetura e reprodução: `README_INTEGRACAO.md`. Hashes: `evidencias/artefatos-sha256.json`. Fontes: `evidencias/fontes-candidato-sha256.json`. Testes executados: `evidencias/testes-executados.txt`. Estado estruturado: `evidencias/resultado.json`.
