# HUD F-16 na Nexys A7-100T

Demonstrador de Sistemas Digitais em SystemVerilog para a FPGA Artix-7
`xc7a100tcsg324-1`. Gera um HUD em VGA 640×480 com retículo, horizonte artificial,
escalas, rumo, mira com LOCK e alertas. A versão de bancada integra sensores,
calibração magnética guiada e vídeo de fundo sincronizado aos modos SOLO, VOO e POUSO.

## Versões e evidências

| Conjunto | Uso | Referência |
| --- | --- | --- |
| **5D7A3AE2** | Firmware de bancada ensaiado em 13/11/2026. Vídeo 2 bpp, DDR2 e calibração magnética guiada. | [Fontes, operação e artefatos](firmware/calibracao-guiada-5d7a3ae2/README.md) · [Aceites físicos](firmware/calibracao-guiada-5d7a3ae2/aceites/) |
| **MVP v1.1** | Perfil procedural sem framebuffer externo, selecionado para a entrega. Validação offline com `MODOS_OPERACIONAIS=1`. | [Pipeline, perfil e reprodução](docs/entrega_academica/mvp_v11/README.md) · [Checklist da entrega](docs/entrega_demo.md) |

O operador registrou resposta do horizonte, bússola e calibração, vídeo, entrada
em POUSO e boot após desligar e religar no 5D7A3AE2. A identidade do BIT ensaiado
está no [manifesto](firmware/calibracao-guiada-5d7a3ae2/MANIFESTO.json). O candidato
acadêmico tem BIT e DCP próprios e a demonstração física desse candidato está pendente.

## Arquitetura e pipeline

O `vga_controller` gera coordenadas, região ativa e pulsos HS/VS. Os módulos
de retículo, horizonte, instrumentos e alertas calculam máscaras a partir das
coordenadas e do estado de voo. `top_reticula` resolve a prioridade das camadas
e entrega RGB durante a área ativa. O estado visual da base é publicado na
fronteira do quadro para evitar mudanças no meio da imagem.

No 5D7A3AE2, o leitor SPI busca setores do microSD e o caminho de vídeo com DDR2 e
buffers entrega os pixels de fundo sincronizados ao raster. A sequência de modos
coordena a reprodução e as referências de velocidade e altitude. O compositor
aplica a simbologia por cima do fundo. O MPU6050 alimenta roll e pitch, e o
HMC5883L alimenta o cálculo de rumo, com perfil inicial 3D e perfil guiado 2D
selecionável próximo do nível.

A [captura temporal](docs/entrega_academica/mvp_v11/README.md) mostra coordenadas,
máscaras, RGB e sincronismos no MVP. A [arquitetura da base](docs/arquitetura.md)
detalha a publicação por quadro e a composição.

## Montagem

A montagem informada pelo responsável tem **uma caixa de madeira** e **uma caixa
separada para a Nexys A7-100T**. A [documentação de montagem](docs/montagem.md)
identifica as interfaces com evidência disponível e os limites das pranchas elétricas.

## Simular e reproduzir

Na raiz, com Python 3, Icarus Verilog, Verilator, make, compilador C++, FFmpeg e Tcl:

```bash
bash scripts/validate_mvp_v11.sh build/mvp-v11
bash scripts/test.sh
python3 -m unittest discover -s tests -p 'test_*.py'
bash scripts/test_attitude_capture.sh build/capture
bash scripts/test_latest_reconciliation.sh build/reconciliacao-recente
```

Os comandos com destino explícito esperam diretórios novos. O runner do MVP
confere os hashes do perfil antes de compilar. O último comando roda a suíte
5D7A3AE2 e a cobertura complementar recuperada dos worktrees.
O [CI](.github/workflows/ci.yml) executa as regressões da base e do firmware recente.

Para síntese e implementação offline do 5D7A3AE2 com Vivado 2026.1:

```bash
VIVADO=/caminho/do/Vivado/2026.1/bin/vivado \
  bash firmware/calibracao-guiada-5d7a3ae2/scripts/reproduzir-build.sh
```

Consulte o [perfil acadêmico](docs/entrega_academica/mvp_v11/README.md) para
identificar os genéricos efetivos do candidato v1.1. O [build padrão da raiz](scripts/build_vivado.tcl)
usa o perfil v1.1 padrão. Um novo build precisa de identidade e evidência próprias.

## Limites

O perfil 5D7A3AE2 espera o B++ de 4.800 quadros, SHA-256
`229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`, no LBA
`31837888`, com `720001` setores. O BIN está fora da release de firmware e a release
anterior de mídia contém outro hash. Os 30 FPS são configurados. A taxa física, a
precisão magnética integral e o timing externo SPI seguem sem qualificação. Os
coeficientes da calibração guiada são voláteis. Os relatórios do firmware registram
três CDC-10 e um CDC-8 pendentes.

O [índice técnico](docs/README.md) reúne operação, pinagem por perfil, validações e
histórico recuperável.
