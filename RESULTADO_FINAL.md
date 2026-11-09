# Sprint local SPI, DDR2 e engenharia para 30 FPS

Referencia preservada: commit 816205119db3abb69443b51ba8f46470539f911e / emissao publicada 5 MHz SHA `2fd3dbc1d0da6fb4d3a8962f811d740fed0b2b23317928c3b591f7c44e1157b2`. Branch local: `sprint/spi-ddr2-throughput-20261109`. **Sem push, release, JTAG, Flash ou escrita no microSD.**

## Estado por frente

| Frente | Resultado efetivamente obtido | Proximo passo |
|---|---|---|
| 10 MHz | Build e BIT offline, WNS +0,346 / WHS +0,026 ns, DRC sem erros, 8 skew positivos (min +6,736 ns). | Retido ate aprovar a emissao de 5 MHz e o orcamento externo. |
| 12,5 MHz | Build e BIT offline, WNS +0,251 / WHS +0,020 ns, DRC sem erros, 8 skew positivos (min +6,991 ns). | Retido: alem do gate anterior, stress 45 ns falhou com deteccao. |
| Controlador/integracao | 21 cenarios focados SPI; 4 cenarios integrados a 10 MHz e 3 a 12,5 MHz passaram. CRC/token timeout recuperados, MIG sob atrasos/backpressure, quadro completo e ordem/loop comparados. | Ensaiar placa; modelo nao contem PHY real. |
| 30 FPS | Orcamento e solucao candidata de IOB/captura definidos; CMD18 sozinho economiza no maximo ~1,72% dos clocks sem mudar Nac. | Medir cartao/placa e desenvolver PHY dedicado antes de 25 MHz. |
| Medicao | Sonda isolada separa DDR2 validado de VGA publicado; teste e implementacao OOC passaram (37 LUT, 162 FF, +6,985/+0,198 ns). | Integracao/ILA em build diagnostico futuro, com novo fechamento. |
| Video/qualidade | SHA integral dos 17.331 quadros reconferido; 64 amostras PackBits reconstruidas byte a byte. Original preservado. | Manter RGB332/qualidade; amostra comprimida ainda nao atende 30 FPS em 12,5 MHz. |

## Candidatos e proveniencia

Os dois BITs sintetizam **exatamente o commit 8162051**, com inicializacao 400 kHz e leitura configurada em 10/12,5 MHz. Top, sensores, atitude, magnetometro, controles, compositor, constraints e protocolo CMD17 nao foram alterados. Os 109 arquivos de fontes/board/scripts congelados foram reconferidos por SHA apos os builds. A sonda e os novos testes pertencem aos commits locais posteriores e nao estao sintetizados nos candidatos.

| Perfil | BIT | USERCODE | SHA-256 |
|---|---|---|---|
| 10 MHz | `hud-f16-ddr2-8162051-spi-h005-experimental.bit` | 5D816205 | `eb266ae1818d0cc41c5bbc7a854e32533936222d20980011852d8264909fccf7` |
| 12,5 MHz | `hud-f16-ddr2-8162051-spi-h004-experimental.bit` | 5D816204 | `113f97b45cf3450aced15914cec1d4f9a5de399837c0a1072fddd88a5a2f32fc` |

DCP 10 MHz: `bc76fc58b5fc36f6666da952d41f785a98f6a8500e566d8b054d5359767d4cea`. DCP 12,5 MHz: `8258930d30e8ed95cb44fc5f830f659090385d569982dc99aed0a4a09aaa76e6`. Cabeçalhos, part, USERID, payload/sync e tamanho (3825990 bytes cada BIT) conferidos. USERCODE identifica perfil/fonte, nao hash recuperado da SRAM.

Builds completos em `/home/santojuca/Downloads/hud_ddr2_spi_fast_build_20261109/resultado-spi-h005-8162051/` e `resultado-spi-h004-8162051/`. Copias agrupadas dos candidatos/DCP/SHA256SUMS em `resultado-candidatos/` desta sprint. Os manifestos distinguem a fonte do build do commit de consolidacao. Relatorios e logs novos: `evidencias/sprint-spi-20261109/`; comandos em `comandos.txt`.

## Testes novos e limites

Os 21 cenarios focados cobrem divisores 5/4, inicializacao 400 kHz, MISO 0–30 ns, CRC, reset, Nac variavel por setor (5 + padrao 0..150 bytes), R1 com quatro bytes extras, token timeout, respostas R1/token invalidas, Nac ilustrativo de 100 us e deteccao de erros a 25 MHz no modelo antigo. Incluem dois stresses adicionais 0–45 ns: 10 MHz passou oito leituras integras; **12,5 MHz falhou nas oito tentativas, cinco por CRC**, sem aceitar bloco corrompido. PASS do teste de deteccao NAO significa PASS do perfil sob esse atraso. Os primeiros 19 casos e os dois stresses foram executados em invocacoes separadas, sem repetir tudo para inflar metricas. A regressao CMD17 400 kHz tambem passou; seu fixture maior gerou aviso benigno de palavras excedentes, e os 512 bytes esperados foram comparados.

Na integracao, ambos os perfis passaram cenarios 6 (carga lenta/pre-carga), 1 (CRC16 injetado) e 2 (timeout com recuperacao). O perfil 10 MHz passou tambem o cenario 5 (desabilitar/habilitar fundo), sem reiniciar o fluxo indevidamente. Nac varia por setor; a UI MIG usa ready e latencia de leitura variaveis. No caso sem erro, 10 MHz comparou 4.300.800 pixels, com quatro publicacoes/releituras, zero erros e intervalos 67,2/84,0/67,2 ms; 12,5 MHz comparou 3.686.400 pixels, com quatro publicacoes/releituras, zero erros e 67,2/50,4/67,2 ms. A incerteza de MISO foi exercitada no teste do controlador, nao adicionada ao teste integrado. O timeout e encurtado nos modelos; nao foi simulado um bloqueio real de 250 ms por leitura.

As novas simulacoes usam dados sinteticos, XPM real e UI MIG modelada; nao aprovam PHY, sensores ou FPS na placa. Os 17 cenarios DDR2/reset/FIFO e testes de ajuste vertical/modos da referencia nao foram repetidos integralmente: seu RTL permanece igual. A simbologia e referencia angular foram preservadas por identidade das fontes, nao por nova observacao VGA.

## Temporizacao e caminho externo

TNS/THS zero e nenhum clock ausente/endpoint interno sem constraints nos dois builds. As 132 atribuicoes IO/propriedades conferiram com 5 MHz. CDC manteve 46 CDC-3, tres CDC-10, um CDC-8 e 176 CDC-15. Sem waivers. REQP-1709 e os resets/MIG documentados permanecem ressalvas. Hold positivo nao qualifica a interface externa.

Na triagem baseada no report_datasheet, sobram para cartao+trilhas **26,353 ns a 10 MHz** e **17,308 ns a 12,5 MHz**. A hipotese historica de tODLY=14 ns deixaria apenas 3,308 ns no ultimo perfil; ela nao e um limite identificado do cartao efetivo. O clock-to-output ainda tem mux/rota longa, e MISO alimenta logica alem da captura de bits. Os relatorios de caminhos externos tem slack infinito por falta de constraints completas, nao por margem fisica ilimitada. Nenhum atraso ou false path foi inventado. Detalhes, fontes oficiais e proposta de IOB/IDDR/fase de captura em SPI_PERFIS_INCREMENTAIS.md.

## Video e alternativas

Nova leitura SHA do arquivo completo (1.331.021.312 bytes) corresponde a `fb5dfdb6bae21b7285d3053bd4725d8f86a06ef0d4a49b311a364075600b3643`. Cabecalho 320×240 RGB332/30 nominal/17.331 quadros confere. A identidade com a referencia historica reaproveita a prova anterior dos 2.599.650 CRC16 e hashes ordenados sem recalcula-los nesta sprint. O cartao de 90 quadros nao foi lido nem alterado novamente; mapa historico LBA 30028160/13501 setores foi preservado.

PackBits em 64 quadros: media 69,31% do tamanho original, maximo amostrado 73,88%, roundtrip exato. Ainda pede ~13,14 MHz para 30 FPS sem Nac; em 12,5 MHz estima ~35,04 ms/quadro sem Nac. O analisador/prototipo e testes foram preservados, mas nenhum codec FPGA ou arquivo de video convertido foi criado. A qualidade nao foi alterada por filtros. 30 FPS sustentados continuam NAO VALIDADOS e nao sao possiveis em RGB332 bruto com os perfis 10/12,5 MHz.

## Proximo ensaio fisico

Primeiro usar somente a emissao publicada de 5 MHz, apos autorizacao especifica: conferir SHA/USERCODE, LD12/13/14, LD15 apagado, tres ciclos e dez minutos estaveis com controles e ajuste vertical. Cronometragem de loop estima FPS sob hipotese de todos os 90 quadros publicados. A sonda proposta mede diretamente os ACKs apos um futuro build diagnostico. So considerar 10 MHz apos esse ensaio e orcamento eletrico coerente; 12,5 MHz exige ainda confirmar sua pequena janela externa. Recuperacao e procedimento detalhado em PROCEDIMENTO_TESTE_FPGA.md. Nenhum novo candidato esta liberado para programacao nesta sprint.
