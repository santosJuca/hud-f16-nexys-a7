# Testes e implementação de 06/11/2026

Ferramentas encontradas: Ubuntu 24.04.5 LTS, Vivado 2026.1 build 6511674, Verilator 5.020, Icarus Verilog 12.0 e Python 3.12.3. Não houve instalação de dependência nova para o firmware.

## Execuções

| Verificação | Resultado / evidência |
|---|---|
| Regressão principal, 84 bancos | PASS em todos; resultado individual em `evidencias/rtl-resultados.json`; logs completos no diretório local de validação e, após execução remota, nos artefatos do CI |
| Python, nove testes | PASS; conversão, FAT32, referência SD e wrapper de build |
| Pipeline microSD 160×120 | PASS nos seis cenários: normal, CRC inválido, timeout, cabeçalho inválido, retries limitados e alternância de vídeo |
| Captura/atitude/partida, dez bancos adicionais | PASS; suíte `scripts/test_attitude_capture.sh` executada do início ao fim |
| Top de vídeo | PASS: 4.300.800 pixels e 12 combinações de modos, ícone/diagnóstico e BTNL |
| Top de captura | PASS: 5.222.400 pixels, quatro vistas, diagnóstico e retorno do vídeo |
| Estimador vetorial | PASS: 4.713 comparações dinâmicas e 5.188 atualizações; pose, calibração, zero, aceleração e falhas |
| Geometria completa | PASS: 190.171 pontos/270 linhas, roll completo e pitch combinado |
| Heading e fusão | PASS: 1.393 vetores em nove configurações; 124 verificações de fusão |
| Sintaxe/elaboração e lint | PASS nos bancos e no top. Verilator reporta 287 WIDTHEXPAND e 46 WIDTHTRUNC, sem erro; avisos existentes não foram ocultados nem corrigidos por alteração algorítmica |
| Pinagem | 81 portas/pinos atribuídos, sem duplicatas; `evidencias/pin-map.json` |
| CAD | Stealth: CRC ZIP/FCStd, envelope STEP, arestas fechadas STL e hashes das quatro referências aprovados. F-16: par STEP bate exatamente com os dois hashes históricos; DXF/manual copiados do ZIP íntegro |
| Git LFS | Nenhum ponteiro LFS na árvore; cliente git-lfs ausente, sem objeto LFS exigido por este checkout |
| Segredos | Varredura de padrões de tokens/chaves privadas no diff não encontrou credenciais de alta confiança; somente arquivos pertinentes foram selecionados |
| Placa, cartão real e power cycle | NÃO EXECUTADOS. Nenhuma programação JTAG/Flash ou escrita no cartão |
| Pipeline 320×240 | NÃO REEXECUTADO; capacidade preservada, evidências anteriores permanecem históricas |
| CAD v1.3.2 integral e geometria independente | NÃO REEXECUTADOS; fontes auxiliares ausentes. Fabricação bloqueada |
| Preview de atitude | Não executado: gerador de imagens auxiliar, não teste de aceite |
| PR #5, máscara VGA externa | Não reexecutado nem integrado; experimental e fora do caminho SD aprovado |

O primeiro CI remoto aprovou todos os 84 bancos RTL, mas falhou em um teste Python por ausência de FFmpeg no runner. FFmpeg também gera a fixture sintética; sua instalação e versão foram incluídas no workflow, sem mudar o conversor ou o RTL. A suíte de captura foi pulada nessa execução e precisa da nova execução completa.

## Vivado executado nesta consolidação

Os dois builds usam RTL byte a byte igual ao commit fisicamente ensaiado `622eacb`. Os relatórios completos estão em `evidencias/hud/` e `evidencias/video/`. Os bitstreams novos permanecem fora do Git, nos diretórios de build/validação locais.

| Métrica após roteamento | HUD sem vídeo | Vídeo 160×120 / 1 FPS solicitado |
|---|---:|---:|
| Síntese / implementação / bitstream | PASS / PASS / PASS | PASS / PASS / PASS |
| Estratégia | Performance_Explore | opt/place/phys_opt/route do script de vídeo |
| WNS | +0,147 ns | +0,412 ns |
| WHS | +0,009 ns | +0,019 ns |
| TNS / THS | 0 / 0 ns | 0 / 0 ns |
| WPWS | +4,020 ns | +4,020 ns |
| LUT | 15.182 | 16.703 |
| FF | 9.581 | 11.352 |
| BRAM tiles | 0 | 17 |
| DSP | 62 | 62 |
| CDC seguros | 588 | 624 |
| CDC unsafe / unknown / sem ASYNC_REG | 0 / 0 / 0 | 0 / 0 / 0 |
| DRC erros | 0 | 0 |
| DRC avisos de pipeline DSP | 103 | 104 |
| Endpoints internos sem restrição / sem clock | 0 / 0 | 0 / 0 |
| Bus skew | PASS, relatório extra no checkpoint roteado | PASS no próprio build |
| Entradas classificadas sem input delay | 26 | 28 |
| Saídas sem output delay | 14 | 38 |

O build básico inicial com a estratégia padrão falhou em setup, WNS −0,123 ns entre `u_vector/w_reg[2][31]` e `u_vector/quiet_reg/D`. A estratégia física `Performance_Explore` corrigiu a falha. Não houve relaxamento de clocks, false path novo nem alteração no algoritmo de calibração.

O primeiro build de vídeo com caminho relativo de referência perdeu o arquivo após `cd`; foi invalidado e interrompido. Os scripts agora normalizam a referência antes de mudar de diretório; o build final não contém essa falha. A falha de elaboração inicial de `tb_atitude` (18 portas esperadas/16 conectadas) foi corrigida com o patch local preservado.

Os rasters longos usam Verilator conservando todos os vetores. `tb_modos` passou com o debounce real de 10 ms; a redução por `defparam` foi retirada apenas desse banco para compatibilidade com o simulador. O banco `tb_estilos`, que depende dessa redução, continua no Icarus. Execuções interrompidas e tentativas incompatíveis não contam como aprovação; somente mensagens finais de cada banco entram no resumo e o CI executa a suíte final de uma vez.

O perfil de vídeo recompilado usa LBA histórico 30006144, 21965 setores, half=125, 160×120, FPS=1 e montagem `mpu-left90-mag-right90-front180-hdg-plus90`, com **origem simulation**. Esses valores reproduzem parâmetros históricos, sem provar a alocação atual no cartão. Não programar esse bitstream como build mapeado.

SHA-256 dos novos BIT:

- HUD: `4bbb80662a517d059c862e1f92170716523cef34200e439e03cf51603cb5e735`.
- Vídeo: `fe7b89422e33623980c072341dc7c6ed91df1728741b7a57488c975fd38b849a`.

O perfil vídeo reproduziu os slacks históricos v1.1 (+0,412/+0,019 ns); os hashes dos BIT diferem, portanto não se trata do mesmo artefato físico. O antigo perfil de 19/10 usava menos lógica e outro estimador; seus recursos/slacks não são baseline equivalente. O STA interno não homologa a interface externa SPI/I²C nem os riscos físicos de controles.
