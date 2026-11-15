# Bancada virtual VGA do HUD: estado em 21/10/2026

A bancada foi desenvolvida **fora do repositório RTL** na estação Linux e integra Verilator, C++ e GTKmm à saída de vídeo do módulo `top_reticula`. Os controles foram exercitados visualmente pelo operador. Este documento registra a existência e os limites da integração; **não publica o código-fonte externo nem substitui o snapshot arquivado**.

## Ambiente conferido

- Ubuntu 24.04.5 LTS; Verilator 5.020; GTKmm 3.24.9; G++ 13.3.0; Make.
- Código de integração C++: `~/Downloads/ferramentas-hud-fpga/hud-vgasim-integration/hud_vga.cpp`.
- Snapshot dos arquivos RTL: `hud-vgasim-integration/snapshot/rtl`.
- Stub XADC: `hud-vgasim-integration/snapshot/tests/xadc_stub.sv`.
- Executável local: `hud-vgasim-integration/obj/Vtop_reticula`.
- Baseline externa: `~/Downloads/ferramentas-hud-fpga/hud-baseline-20261021-Vukv4w0Q`, com `BASELINE.md`, hashes e pacote de fontes da simulação.
- A comparação local anterior identificou snapshot RTL coincidente com o checkout então auditado no commit `4107002`.

## Interface

A bancada exibe os sinais VGA 640×480 derivados do RTL em uma janela GTK. Mapeamento confirmado dos atalhos da interface C++:

| Tecla | Função |
| --- | --- |
| 1 | Exibição NORMAL |
| 2 | Exibição DECLUTTER |
| 3 | Estilo HUD convencional |
| 4 | Estilo CAÇA |
| 5 | Operação SOLO |
| 6 | Operação VOO |
| 7 | Operação POUSO |

A mudança de modos operacionais pode demorar na simulação devido ao debounce do RTL (`OPERACAO_DEBOUNCE` padrão 10.000.000 ciclos de 100 MHz). Não registrar atraso como falha funcional.

## Alcance

- A interface foi operada e exibiu os modos informados.
- O stub XADC e os estímulos disponíveis não constituem emulação integral de MPU6050, BMP085, HMC5883L ou do comportamento elétrico das entradas analógicas.
- Os parâmetros magnéticos padrão do `top_reticula` são neutros; o build Vivado de 19/10 utiliza offsets e ganhos aplicados por `constraints/magnetometer_calibration.tcl`. Não afirmar que a bancada virtual reproduz a calibração física sem configuração e teste específicos.
- O simulador interativo não faz parte da regressão de 62 testes do CI.
- Os arquivos da integração e a baseline permanecem **locais**, não incluídos no versionamento deste repositório. O pacote arquivado não deve ser anunciado como reprodutível de ponta a ponta sem dependências externas (vgasim/GTK/toolchain).
- Capturas reais do simulador ainda precisam ser selecionadas e anexadas à documentação acadêmica; não há novas capturas incluídas neste commit.

## Ferramentas auxiliares

| Ferramenta | Evidência disponível |
| --- | --- |
| Graphify | Relatório local com 106 nós, 101 arestas e 32 comunidades; não prova correção funcional |
| Verible | Binário local identificado como v0.0-4296-g0f262651 e registros de lint |
| Ponytail | Seis SKILL.md encontrados em `~/.agents/skills` |
| Agent Skills | Mecanismo de distribuição por arquivos SKILL.md |
| fernando-humanizer / fernando-clean-code | SKILL.md instalados em `~/.agents/skills`; fontes canônicas no repositório privado `santosJuca/fernando-ai-style` |
| Playwright CLI | SKILL.md encontrada; não é parte dos testes da janela GTK |
| Playwright MCP | Sem entrada identificada no `~/.codex/config.toml`; funcionamento não confirmado |

Instalação de ferramenta e existência de Skill não devem ser confundidas com execução ou com cobertura de testes. Nenhuma dessas ferramentas adiciona funcionalidade ao bitstream publicado.
