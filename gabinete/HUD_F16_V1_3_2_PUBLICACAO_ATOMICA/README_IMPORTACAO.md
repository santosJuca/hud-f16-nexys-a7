# Gabinete HUD F-16 v1.3.2

Gerador e manifesto recuperados da branch `case` (`9d3ff33`). STEP, DXF preliminar, lista de materiais, inventário, figuras e manual recuperados de `Manual_HUD_F16_R2_Kit_Completo.zip`. Os dois STEP correspondem em tamanho e SHA-256 ao manifesto original. A procedência de cada arquivo está em [importacao_20261106.json](04_VALIDACAO/importacao_20261106.json).

O par canônico está em `01_CAD_3D/ATUAL/`, link relativo para a publicação imutável `20261103T172921Z-61ed8b479b3b`. Não são STEP regenerados nesta consolidação. O manifesto histórico registra 101 sólidos válidos por estado; nesta execução foram conferidos os bytes, os hashes e a integridade do ZIP, sem novo ensaio geométrico.

**Fabricação bloqueada.** Interferências reais de cabos/case, medidas de componentes, MDF e kerf continuam pendentes. O manual de pré-montagem e o DXF não aprovam essas dimensões. A pinagem atual do firmware está no XDC e em `docs/pinagem.md`; documentos mecânicos não autorizam conexões elétricas.

A regeneração do projeto editável está incompleta: faltam `gerador_v12_preservado.py`, `nucleo_v11_preservado.py`, os STEP em `01_CAD_3D/originais/` e o ZIP original v1.2 em `00_FONTE/`. Esses itens não foram encontrados no repositório nem nos arquivos locais pesquisados. Não executar o gerador como se fosse autossuficiente.

O projeto Stealth V3 em `mechanical/HUD_FPGA_Stealth_V3/` é outra revisão preliminar; foi preservado separadamente.
