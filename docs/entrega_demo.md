# Entrega e demonstração do HUD F-16

## Identidade do conjunto recente

| Item | Referência |
| --- | --- |
| Firmware | 5D7A3AE2, snapshot `057b586820b86153536804148213a63c487086b6` |
| Fontes, testes e build | [Pacote recente](../firmware/calibracao-guiada-5d7a3ae2/README.md) |
| BIT ensaiado | SHA-256 `ad8d6d7902bd50ed2924de9eb6b159d1d5b3ca8614247476aae44e0f79ee027a` |
| Downloads | [Release identificada](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-calibracao-guiada-5d7a3ae2-20261113) |
| Placa dos ensaios | Nexys A7-100T, Digilent `210292AD34F5A` |
| Evidências | [Manifesto](../firmware/calibracao-guiada-5d7a3ae2/MANIFESTO.json), [relatórios](../firmware/calibracao-guiada-5d7a3ae2/relatorios/) e [aceites](../firmware/calibracao-guiada-5d7a3ae2/aceites/) |

O operador confirmou bússola/calibração, vídeo, horizonte, POUSO e início normal
após desligar/religar. A versão mantém ressalvas de CDC e SPI externo; a taxa física
do vídeo e a precisão magnética integral não estão qualificadas. Os coeficientes
runtime da calibração são voláteis. A organização do Git não altera essas condições.

O [registro de 08/10](historico/entrega_20261008.md) foi preservado como histórico.
Seus controles, BIT e pendências não descrevem automaticamente o firmware recente.

## Núcleo exigido e extensões

O enunciado disponível pede VGA, coordenadas, retículo, horizonte configurável,
escala de altitude, direção, marcador, dois modos, atualização contínua e elementos
na região ativa (RF-01 a RF-10). Pede ainda arquitetura, RTL/testbench, projeto
Vivado com constraints e relatórios, README, utilização/Fmax, apresentação e demo.

A base v1.1 na raiz preserva o caminho procedural sem framebuffer externo.
O firmware recente acrescenta vídeo em DDR2. Essa extensão precisa ser distinguida
do núcleo, pois o enunciado proíbe framebuffer externo. Sensores, gabinete,
calibração guiada e fundo de vídeo não são condições para completar o MVP.

## Evidência de pipeline gráfico

A cadeia a apresentar é:

```text
VGA timing → coordenadas/região ativa → geradores de símbolos → compositor → RGB/HS/VS
```

Na base v1.1, `vga_controller` fornece coordenadas, região ativa e sincronismos;
retículos, `simbologia_vga`, números e alertas geram máscaras; `top_reticula`
compõe o RGB. `entrada_hud` transfere os dados entre clocks e `dados_hud` os
aplica na fronteira de quadro. Consulte a [arquitetura](arquitetura.md).

Esse é um fluxo funcional, não uma declaração de cinco estágios registrados.
Para a versão demonstrada, anexar uma captura temporal que mostre coordenadas,
região ativa, máscara de símbolo, RGB e sincronismos, explicando sua latência.
O teste `tb_vga` da base verifica o raster completo e o blanking; os testes de
modos verificam mudanças entre quadros. Esses resultados não substituem a captura
temporal da implementação selecionada nem a demonstração em monitor.

O CI é evidência complementar: guardar SHA, URL do run, logs e capturas. O run
[42271011383](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/42271011383)
pertence a `c481ceb`, não ao snapshot recente. O CI de
[057b586](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/runs/43521449535)
executou a suíte antiga da raiz; a consolidação acrescenta um job específico do
firmware recente. O novo run só deve ser citado como aprovado após sua conclusão.

## Checklist de entrega

- [ ] Identificar commit/tag, perfil, BIT e hash na capa do relatório e na demo.
- [ ] Relacionar RF-01 a RF-10 aos módulos, testes e trechos demonstrados da mesma versão.
- [ ] Anexar arquitetura e evidência temporal do pipeline gráfico.
- [ ] Anexar relatório final e apresentação.
- [ ] Anexar síntese, utilização, timing e Fmax da versão escolhida; não usar Fmax histórica como atual.
- [ ] Preservar os artefatos do CI fora da retenção temporária do GitHub Actions.
- [ ] Mostrar retículo, horizonte, escalas, direção e marcador simultâneos.
- [ ] Demonstrar controle manual, NORMAL/DECLUTTER, atualização contínua e limites da tela; LOCK é adicional.
- [ ] Registrar demo em monitor VGA, identificando controles e a versão ensaiada.
- [ ] Se incluir o fundo B++, entregar o BIN correto e seu hash; a release pública de vídeo anterior não o contém.
- [ ] Listar limites de CDC/SPI, precisão dos sensores e 30 FPS não medidos, sem confundir simulação e bancada.

O pacote recente já inclui fontes, parâmetros, MIG, constraints, scripts,
relatórios e aceites. BIT, DCP, MCS e recuperação ficam nos assets da release.
Não é preciso gerar ou programar outro firmware para organizar esses anexos.

A reconciliação local acrescenta a [Fmax estimada do checkpoint 5D7A3AE2](evidencias/reconciliacao_local_20261115/fmax_estimado.rpt)
e sua [proveniência e limites](evidencias/reconciliacao_local_20261115/analise_checkpoint.json).
É uma análise do DCP preservado, sem nova síntese ou varredura de frequência.

## Vídeo associado

O BIT recente espera B++ 640×480/2 bpp, 4.800 quadros, SHA-256
`229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`,
LBA `31837888`, `720001` setores no cartão identificado no pacote.
O BIN está preservado localmente, mas não está nos assets da release de firmware;
a release de mídia anterior publica hash `450d2b3d…`. Não renomear essa mídia
como se fosse B++ nem reutilizar o LBA em outro cartão sem conferir o layout.
