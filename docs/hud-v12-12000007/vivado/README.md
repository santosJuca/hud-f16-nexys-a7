# Esquemas e pipelines exportados pelo Vivado

Estes arquivos foram gerados pelo Vivado 2026.1, build 6511674, para o candidato local `12000007`. Os PDFs e `.sch` nativos vêm de `show_schematic`/`write_schematic`. A declaração de interface do MIG vem de `write_verilog -mode synth_stub -cell u_ui_test/u_mig`, aplicada ao checkpoint roteado original. Os arquivos gerados são evidência de ferramenta, separada dos diagramas explicativos anteriores.

## Comece por estes três arquivos

- [Pipeline registrado de três estágios](07-pipeline-tres-estagios.pdf): nove FDREs do caminho de fase, com `phase_a_reg` → `phase_b_reg` → `phase_aligned_reg`. Não representa todos os bits dos multiplicadores de velocidade/altitude.
- [RTL do CDC e publicação no quadro](12-rtl-cdc-quadro.pdf): `u_entrada`, `u_dados`, `u_attitude_cdc`, `u_simbologia` e `u_vga`, com nomes de portas do RTL.
- [Visão geral RTL](11-rtl-visao-geral.pdf): sensores, operação, estado, vídeo nativo e wrapper DDR2. Portas externas ao recorte podem aparecer sem conexão; isso não demonstra ausência de ligação no circuito completo.

As versões PDF para leitura mantêm o conteúdo vetorial gerado pelo Vivado e ajustam apenas a rotação de página (`/Rotate=0`). Os PDFs originais e esquemas nativos estão em `nativos/`. O texto e as conexões não foram redesenhados. Vistas densas exigem zoom no PDF ou expansão interativa no Vivado; os recortes menores são a entrada recomendada.

## Índice de esquemas

| Arquivo | Origem e alcance |
| --- | --- |
| [01-visao-geral.pdf](01-visao-geral.pdf) | Dez blocos selecionados na implementação roteada; útil para zoom, pois a otimização recompõe portas e atravessa hierarquias. |
| [02-atitude-bussola.pdf](02-atitude-bussola.pdf) | Estimador, sensores, referência e rumo na implementação. |
| [03-comandos-estado.pdf](03-comandos-estado.pdf) | Joystick, comandos, captura, offsets e publicação na implementação. |
| [04-host-sd-nativo.pdf](04-host-sd-nativo.pdf) | Inicialização, checagens, publicação e caminho de memória implementados. |
| [05-ddr2-fifos.pdf](05-ddr2-fifos.pdf) | Ponte, descritores, leitor VGA, MIG e temperatura implementados. |
| [06-renderizacao.pdf](06-renderizacao.pdf) | Raster, dados, simbologia e leitor de vídeo implementados. |
| [07-pipeline-tres-estagios.pdf](07-pipeline-tres-estagios.pdf) | Caminho representativo de fase com três grupos de FDREs. |
| [08-cdc-pedido-confirmacao.pdf](08-cdc-pedido-confirmacao.pdf) | Seis registros de pedido/ACK do `u_entrada`; lógica combinacional fora da seleção não é expandida. |
| [09-prefetch-pixel.pdf](09-prefetch-pixel.pdf) | Cone de entrada de um bit de `pixel_word_reg`, limitado a três níveis; inclui LUTs e memória distribuída. |
| [10-saida-rgb.pdf](10-saida-rgb.pdf) | Cone de quatro níveis de `VGA_R[0]`, não todos os canais da saída. |
| [11-rtl-visao-geral.pdf](11-rtl-visao-geral.pdf) | Nove blocos na elaboração RTL; MIG representado pela sua interface. |
| [12-rtl-cdc-quadro.pdf](12-rtl-cdc-quadro.pdf) | CDC, estado por quadro e uso de coordenadas no RTL. |
| [13-rtl-sensores.pdf](13-rtl-sensores.pdf) | Interfaces de aquisição, estimação e calibração do RTL. |
| [14-rtl-sd-ddr2.pdf](14-rtl-sd-ddr2.pdf) | Interfaces do host, memória/VGA e wrapper de MIG. |
| [15-rtl-pipeline.pdf](15-rtl-pipeline.pdf) | Interface do módulo de instrumentos na elaboração; detalhes registrados estão em 07 e no inventário. |

## Extrações e correspondência

A comparação automática encontrou as **99 instâncias locais** do catálogo anterior na elaboração RTL, com módulo correspondente em todas elas. Veja [comparacao-catalogo-rtl-vivado.csv](comparacao-catalogo-rtl-vivado.csv).

- [hierarquia-rtl-vivado.tsv](hierarquia-rtl-vivado.tsv): 225 células não primitivas, incluindo internos XPM e o MIG como caixa-preta. Não é contagem de módulos autorais ou flip-flops.
- [hierarquia-vivado.tsv](hierarquia-vivado.tsv): 223 células não primitivas da implementação roteada, incluindo o interior do MIG e otimizações de síntese/implementação. A ausência de uma fronteira hierárquica não prova que a função foi removida.
- [portas-rtl-vivado.tsv.gz](portas-rtl-vivado.tsv.gz): pinos, direção e nets da elaboração RTL. Barramentos aparecem expandidos conforme o Vivado.
- [portas-hierarquicas-vivado.tsv.gz](portas-hierarquicas-vivado.tsv.gz): pinos e segmentos de nets das fronteiras hierárquicas pós-roteamento. Nomes podem ter sido reconstruídos pela ferramenta.
- [pipeline-registradores-vivado.tsv](pipeline-registradores-vivado.tsv): objetos sequenciais do módulo de perfil de voo, com referências e clocks. Contém 94 FDREs e seis DSP48E1. A presença do DSP na classe sequencial não informa, isoladamente, quais registradores internos estão habilitados.
- [estagio1-para-2-timing.rpt](estagio1-para-2-timing.rpt) e [estagio2-para-3-timing.rpt](estagio2-para-3-timing.rpt): análise estática de três caminhos de fase em cada ligação entre grupos de registros. O período reportado é 10 ns.
- [manifesto-vivado.json](manifesto-vivado.json): ferramenta, hashes dos artefatos, limites, comandos e tentativas preservadas.

A conferência pelo Vivado acrescentou as cinco macros AMD `xpm_fifo_async` omitidas no primeiro catálogo estático. As FIFOs internas são XPM, enquanto os wrappers e a política de banco/publicação são do projeto. O catálogo e o CSV de módulos foram corrigidos. Os 1.306 vínculos do CSV anterior continuam sendo associações de portas dos módulos locais, sem os internos das bibliotecas.

## Como foi executado e como abrir

A extração da implementação abriu o checkpoint SHA-256 `79b7caa7b93c18a618fe680c039371f944cc22b3bf731ea53d8f2cac049b1110`. Nenhum checkpoint novo foi salvo. O BIT original mantém SHA-256 `88f7872de8cb77769781611b84aa1caa2c2f37bc4cfddc43baefa717d91aaec6`.

A elaboração RTL usou as 100 fontes HDL do candidato, os 55 overrides de `genericos.txt` e os defaults. Como o kit não trazia o módulo gerado do MIG para a análise RTL, usou-se a declaração de interface emitida pelo Vivado a partir do próprio checkpoint. O MIG fica como caixa-preta somente nessa elaboração; os esquemas roteados usam o interior real preservado no DCP. Não foi substituído o RTL funcional ou o IP do kit.

Os scripts e logs estão na pasta `output/documentacao-vivado-20261123` do ambiente de origem e no pacote completo desta revisão. Para abrir o pipeline roteado nessa pasta:

```bash
vivado -mode gui -source abrir-pipeline-vivado.tcl -tclargs ../hud-v12-entrega-offline-20261116/implementacao/routed.dcp 07-pipeline-tres-estagios.sch
```

O Tcl apenas abre o checkpoint e lê o esquema nativo. Se os arquivos estiverem em outro lugar, forneça seus caminhos. Use o Vivado 2026.1 correspondente ao checkpoint. Para inspecionar os esquemas RTL, consulte os PDFs ou reproduza a elaboração do script no projeto de análise; nomes de portas RTL não são necessariamente os mesmos da implementação otimizada.

Não houve nova síntese completa, implementação, bitstream, programação ou simulação. O comando `synth_design -rtl` executa elaboração e otimizações próprias dessa análise, não uma implementação nova. Os relatórios de timing são análise estática do roteamento preservado; não medem atrasos na placa. Os aceites físicos e pendências da versão continuam separados.
