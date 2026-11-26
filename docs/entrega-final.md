# Operação e reprodução

O protótipo acadêmico final usa o build **12000007**. As fontes de implementação estão no snapshot publicado na [release documental do Vivado](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/docs-hud-v12-12000007-vivado-20261123). A tag da release aponta para o commit documental `90e5e78de190aaf0b8f34b38f9bb832142f7d550`. Baixe o asset `documentacao-hud-v12-12000007-vivado.zip` para recuperar o snapshot.

## Identidade da implementação

| Artefato | SHA-256 |
| --- | --- |
| BIT aprovado | `88f7872de8cb77769781611b84aa1caa2c2f37bc4cfddc43baefa717d91aaec6` |
| Checkpoint roteado | `79b7caa7b93c18a618fe680c039371f944cc22b3bf731ea53d8f2cac049b1110` |
| ZIP Vivado | `dac268e9a626af1e503750ed68ea5741abd41e135d52e142535ef13080caf947` |

O ZIP preserva o checkpoint, os relatórios e o diretório `hud-v12-entrega-offline-20261116/candidato/`. Dentro dele estão `hud/rtl/`, `hud/constraints/`, `mig/`, os arquivos de placa Digilent, 55 overrides em `genericos.txt`, scripts e testes. O BIT aprovado é preservado separadamente no acervo local da entrega.

O `rtl/` e os scripts da raiz pertencem à base v1.1. O diretório [firmware/calibracao-guiada-5d7a3ae2](../firmware/calibracao-guiada-5d7a3ae2/README.md) preserva o perfil de bancada anterior. O [índice de arquitetura](hud-v12-12000007/README.md) explica a procedência dos três conjuntos.

## Conferência e build offline

Depois de extrair o ZIP, rode `sha256sum -c SHA256SUMS-PACOTE.txt` na raiz extraída. Com o Vivado 2026.1 licenciado, execute `bash scripts/reproduzir-build.sh` dentro de `candidato/`. O script usa um diretório temporário e executa síntese, implementação e relatórios pós-rota. O [índice Vivado](hud-v12-12000007/vivado/README.md) explica como abrir o checkpoint e navegar pelos esquemas.

Na revisão de 26/11, a conferência dos hashes e a simulação do pipeline passaram. A tentativa de executar o build offline parou na inicialização do Vivado por indisponibilidade de uma licença válida no ambiente de execução. O checkpoint e o bitstream acima são os artefatos originais.

## Operação no protótipo

| Controle | Uso |
| --- | --- |
| SW3:SW2 | `00` SOLO, `01` pedido de VOO, `10` pedido de POUSO. `11` mantém a fase. |
| SW5 | Seleção DIA/NOITE durante a operação de vídeo. |
| Joystick | Posicionamento do marcador e comando LOCK/UNLOCK conforme o perfil. |

Use o `PROCEDIMENTO.md` do ZIP para os controles por perfil, mapa lógico do cartão e limites de calibração. Os arquivos ajustados têm 4.800 quadros por modo, com deslocamentos por cena registrados em `MANIFESTO-AJUSTE.json`. A origem, autoria e permissão de redistribuição dos vídeos permanecem indeterminadas.

## Evidência e limites

O registro JTAG de 26/11 às 15h52 identifica `DONE=1` e `USERCODE=12000007`. A resolução do problema de recuperação do rumo após abrir e fechar a tampa foi informada pela equipe em 26/11. A documentação técnica preserva as ressalvas de CDC, timing externo, qualificação dos coeficientes e alocação do setor HFCAL2D. A equipe relatou operação prolongada. A duração e os FPS físicos permanecem sem medição registrada.
