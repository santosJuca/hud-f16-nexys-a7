# HUD v1.2 12000007: arquitetura e esquemas do Vivado

Esta documentação descreve o candidato local `12000007`, preservado em 16/11/2026 e documentado em 23/11/2026. O snapshot não substitui o RTL v1.1 da raiz nem o firmware de bancada `5D7A3AE2`. Sua demonstração física continua pendente.

## Documentos e esquemas

| Material | Conteúdo |
| --- | --- |
| [Arquitetura em PDF](arquitetura.pdf) · [DOCX editável](arquitetura.docx) | Sensores, comandos, modos, dados por quadro, composição VGA, SD nativo, DDR2, clocks, resets e limites de validação |
| [Catálogo de módulos em PDF](modulos.pdf) · [CSV](modulos.csv) | Função, arquivo de origem, portas, conexões, clocks/resets e seleção; distingue módulos autorais, IPs, opcionais e históricos |
| [Apresentação resumida](apresentacao.pdf) | Visão geral da mesma configuração documentada |
| [Índice dos 15 esquemas Vivado](vivado/README.md) | PDFs vetoriais, arquivos nativos `.sch`, procedência e alcance de cada recorte |
| [Pipeline registrado](vivado/07-pipeline-tres-estagios.pdf) | Três grupos de FDREs do caminho de fase, com nomes reais da implementação |
| [Estado por quadro e CDC](vivado/12-rtl-cdc-quadro.pdf) | Publicação de dados e travessia entre domínios de clock na elaboração RTL |
| [Visão geral RTL](vivado/11-rtl-visao-geral.pdf) | Blocos e portas selecionados na configuração v1.2 |
| [Interligações locais](interligacoes.csv) · [pinagem do snapshot](pinagem.csv) | 1.306 associações de portas e 81 declarações de pinagem; referências relativas ao snapshot, não à raiz desta branch |
| [Parâmetros da referência](genericos-referencia.txt) · [manifesto Vivado](vivado/manifesto-vivado.json) | 55 overrides, ferramenta, hashes, seleção e limites das extrações |

A elaboração RTL no Vivado 2026.1 confirmou as 99 instâncias locais do catálogo. Cinco macros AMD `xpm_fifo_async` antes omitidas foram acrescentadas, totalizando 111 instâncias diretas abaixo do top, antes dos internos das bibliotecas. Os inventários expandidos contêm 225 células não primitivas no RTL e 223 na implementação; não são contagens de módulos autorais ou flip-flops.

O MIG é representado pela interface extraída do próprio checkpoint somente na elaboração RTL. Os esquemas roteados usam o conteúdo preservado da implementação. Os PDFs de leitura ajustam apenas a rotação da página; os originais e `.sch` estão em [vivado/nativos](vivado/nativos/). As vistas densas exigem zoom. Os diagramas explicativos e as capturas temporais históricas no relatório têm origem e perfil próprios, indicados nas legendas.

## Relação com a main e acesso às fontes

Na comparação com a `main` após o merge do PR #9 (`110dc59bc38441bf9445b7e7784461483d9a850a`), das 100 fontes HDL do candidato, 51 são idênticas às homônimas em `rtl/`, 18 diferem e 31 não existem nesse diretório. Em relação a `firmware/calibracao-guiada-5d7a3ae2/hud/rtl/`, 80 são idênticas, cinco diferem e 15 são adicionais. Essa comparação é byte a byte por arquivo homônimo, sem avaliar equivalência funcional.

Por isso, os nomes de arquivo, linhas e caminhos dos documentos e CSVs devem ser consultados nas fontes do snapshot. Esta inclusão adiciona documentação; não promove o hardware v1.2 a firmware de bancada validado.

O [pacote completo da release documental](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/docs-hud-v12-12000007-vivado-20261123) reúne as fontes exatas, constraints, parâmetros, documentos em MD/HTML/DOCX/CSV/SVG/PDF, checkpoint, scripts de extração, logs e manifestos. Os links internos exibidos no DOCX/PDF seguem a estrutura desse pacote. Para reproduzir a leitura ou navegar entre fontes e documentos, extraia o ZIP completo. Os scripts/logs citados no índice Vivado também estão nesse pacote.

- ZIP: `documentacao-hud-v12-12000007-vivado.zip`, SHA-256 `dac268e9a626af1e503750ed68ea5741abd41e135d52e142535ef13080caf947`.
- Checkpoint roteado original: SHA-256 `79b7caa7b93c18a618fe680c039371f944cc22b3bf731ea53d8f2cac049b1110`.
- BIT de referência, não incluído nesta pasta: SHA-256 `88f7872de8cb77769781611b84aa1caa2c2f37bc4cfddc43baefa717d91aaec6`.

Os [hashes dos arquivos desta pasta](SHA256SUMS.txt) cobrem as cópias incorporadas à main. A release mantém os artefatos completos e suas listas próprias de integridade. O checkpoint, vídeos completos e logs volumosos permanecem fora da árvore principal.

Não houve nova síntese completa, implementação, bitstream ou programação para produzir esta documentação. A elaboração RTL, os esquemas e os relatórios estáticos não demonstram funcionamento físico. Permanecem as pendências de CDC, aceitação física do candidato, alocação do setor HFCAL2D e qualificação dos coeficientes da montagem descritas no relatório.
