# Testes e validação

> Esta página descreve a suíte v1.1 da raiz. A [suíte 5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/scripts/reproduzir-testes.sh) é executada separadamente pelo CI; consulte o [guia recente](../firmware/calibracao-guiada-5d7a3ae2/README.md).

A consolidação usa três entradas reproduzíveis, também executadas pelo workflow existente em `.github/workflows/ci.yml`:

```sh
scripts/test.sh
python3 -m unittest discover -s tests -p 'test_*.py'
scripts/test_attitude_capture.sh build/capture
```

`scripts/test.sh` contém 84 bancos. Compila todos contra o RTL e o stub XADC. Icarus cobre a lógica digital; Verilator acelera os rasters exaustivos sem reduzir vetores. `TEST_FILTER` seleciona um subconjunto e `TEST_OUT_DIR` muda o destino. A mensagem final de um teste filtrado não significa que os demais bancos foram executados.

Os nove testes Python cobrem conversão, cabeçalho/padding, mapa FAT32 contíguo, corrupção/fragmentação, referência SD e despacho portátil do build. Os testes do wrapper simulam a chamada do Vivado, não substituem sua execução real.

`scripts/test_attitude_capture.sh` executa os seis cenários do pipeline de vídeo e dez bancos de autozero, partida, geometria completa, atitude vetorial/bias, controles, captura e top vídeo. Usa diretório novo e modelo SD; não acessa cartão nem FPGA. `tb_hud_atitude_preview` é um gerador auxiliar de seis imagens, não uma regressão de aceite; fica fora do CI. `sd_video_card_model` e `xadc_stub` são suporte.

Os resultados, as versões efetivamente usadas e os relatórios Vivado desta execução estão em [consolidação/testes](consolidacao_20261106/testes.md). O [mapa de cobertura](consolidacao_20261106/cobertura.md) liga os testes às funcionalidades.

A simulação não valida faixa elétrica XADC, barramentos externos, montagem, precisão dos sensores, imagem física ou power cycle. Relatos v1.0/v1.1 continuam vinculados aos hashes históricos. Não programar um bitstream com LBA de simulação em cartão real.
