# HUD F-16 na Nexys A7-100T

Projeto acadêmico de Sistemas Digitais: simbologia aeronáutica gerada em
SystemVerilog e exibida em VGA 640×480 na FPGA Artix-7 `xc7a100tcsg324-1`.
Inclui horizonte, retículo, escalas, rumo, mira com LOCK, modos de exibição,
sensores e simulação didática de voo e pouso.

## Versão recente: 5D7A3AE2

O [firmware com calibração magnética guiada](firmware/calibracao-guiada-5d7a3ae2/README.md)
é o conjunto recente ensaiado na placa em 13/11/2026. Seu snapshot foi publicado
em `057b586820b86153536804148213a63c487086b6` e está integrado neste repositório,
com fontes, constraints, MIG, parâmetros, testes, relatórios e aceites.

- [Baixar BIT, fontes e pacote completo](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-calibracao-guiada-5d7a3ae2-20261113).
- [Operação, calibração, identidade e recuperação](firmware/calibracao-guiada-5d7a3ae2/README.md).
- [Entrega e demonstração](docs/entrega_demo.md).
- [Índice da documentação](docs/README.md).

O operador confirmou calibração aplicada, giro/retorno da bússola, vídeo,
horizonte, chegada ao POUSO e início normal após desligar/religar. Os
[aceites](firmware/calibracao-guiada-5d7a3ae2/aceites/) distinguem esses relatos
dos registros de programação e readback. São resultados daquela montagem,
não uma garantia de precisão em qualquer ambiente.

O programa é persistente na Flash; os coeficientes calculados durante a
calibração guiada são voláteis. Permanecem três CDC-10, um CDC-8 e a
qualificação de timing externo SPI. Os 30 FPS do vídeo são configurados,
não medidos fisicamente.

## Escolha do conjunto

| Conjunto | Fontes e reprodução | Uso |
| --- | --- | --- |
| **5D7A3AE2, 13/11** | [Pacote recente](firmware/calibracao-guiada-5d7a3ae2/README.md) | Calibração guiada, esteira híbrida, vídeo 2 bpp/DDR2 e modos sincronizados |
| HUD v1.1, consolidação do PR #6 | [RTL](rtl/), [constraints](constraints/), [scripts](scripts/) e [testes](tests/) | Base anterior preservada, com captura e vídeo BRAM; não gera o firmware recente |
| Builds de outubro | [Catálogo](bitstreams/README.md) | Artefatos históricos identificados por data e hash |
| Mecânica | [Stealth V3](mechanical/HUD_FPGA_Stealth_V3/README.md) e [gabinete F-16](gabinete/) | CAD e documentação preliminares; fabricação não liberada |

Esses conjuntos têm controles, pinagens e relatórios próprios. Não combine
um XDC ou BIT de outubro com o procedimento do firmware recente.

## Reproduzir os testes

Na raiz do repositório, com Python 3 e Icarus Verilog (`iverilog`/`vvp`):

```bash
bash firmware/calibracao-guiada-5d7a3ae2/scripts/reproduzir-testes.sh
```

O comando executa testes específicos da calibração, regressões selecionadas e
integração do top com modelos. Gera arquivos locais no pacote. Os dois testes
legados documentados como inconclusivo/incompatível não são contabilizados como PASS.

Para a base v1.1, com Icarus, Verilator, compilador C++, Python 3, Tcl e FFmpeg:

```bash
bash scripts/test.sh
python3 -m unittest discover -s tests -p 'test_*.py'
bash scripts/test_attitude_capture.sh build/capture
```

Para a cobertura complementar recuperada dos worktrees, com Python 3 e Icarus:

```bash
mkdir -p build
bash scripts/test_latest_reconciliation.sh build/reconciliacao-recente
```

O diretório deve ser novo. O script preserva o pacote publicado e executa uma
cópia, incluindo orientação MPU, prioridade dos comandos e recuperação I²C.
O banco MPU pode consumir vários minutos; timeout é falha, não PASS. A
[reconciliação local](docs/reconciliacao_local_20261115.md) registra as origens e os limites.

Os testes geram resultados em `build/`. O [workflow de CI](.github/workflows/ci.yml)
verifica os dois conjuntos e salva os logs. Simulação não acessa a placa nem
comprova funcionamento físico.

## Reproduzir a implementação recente

Com Vivado 2026.1 instalado:

```bash
VIVADO=/caminho/do/Vivado/2026.1/bin/vivado bash firmware/calibracao-guiada-5d7a3ae2/scripts/reproduzir-build.sh
```

O script copia as entradas para uma pasta temporária nova e executa síntese e
roteamento. Não gera BIT nem programa hardware. O pacote documenta separadamente
a emissão offline de BIT a partir de checkpoint. A reprodução de um build novo
não o torna idêntico ao BIT ensaiado; confira os hashes de cada artefato.

## Vídeo e montagem

O firmware recente usa o vídeo **B++ 640×480, 2 bpp, 4.800 quadros**, com SHA-256
`229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`.
O perfil compilado espera LBA `31837888` e `720001` setores no cartão documentado.
Ele não localiza automaticamente o arquivo em outro cartão.

O B++ não está incluído na release de firmware. A
[release de mídia de 13/11](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-video-640x480-2bpp-20261113)
contém a versão anterior, de hash `450d2b3d…`; ela não é o B++ esperado pelo conjunto recente.

O [atlas elétrico](docs/atlas-eletrico/README.md) é uma referência de montagem.
Confira-o contra o XDC do perfil utilizado. JTAG, Flash e microSD são operações
separadas e exigem identificação do alvo, conferência de integridade e recuperação.

## Escopo acadêmico e evidências

O caminho gráfico procedural da base v1.1 não usa framebuffer externo. O vídeo
com DDR2 é uma extensão e deve ser distinguido desse núcleo, pois o enunciado
proíbe framebuffer externo. Sensores, gabinete e calibração guiada também são extensões.

A [consolidação atual](docs/consolidacao_20261115.md) registra origens, decisões,
validações e limites. Os detalhes da base anterior foram preservados no
[guia v1.1](docs/historico/README_baseline_20261106.md). O projeto é didático;
os dados simulados e a mira não representam instrumentos ou rastreamento aeronáuticos reais.
