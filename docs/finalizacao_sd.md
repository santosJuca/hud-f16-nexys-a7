# HUD com diagnóstico microSD: validação de 30/10/2026

Esta versão acrescenta inicialização SDHC e leitura explícita de um setor de diagnóstico. Não implementa reprodução de vídeo, sistema de arquivos, framebuffer nem captura/sobreposição VGA externa. O subsistema continua desabilitado no parâmetro padrão do RTL; a implementação `C` habilita `ENABLE_SD_SUBSYSTEM=1` explicitamente.

## Comportamento integrado

SW8 (T8, LVCMOS18) solicita CMD17 para LBA 2048. Após inicialização, colocar SW8 em zero e depois em um; o sinal passa por dois sincronizadores e 10 ms de debounce a 100 MHz. Cada transição aceita produz uma leitura. Pedidos durante inicialização ou ocupação não são enfileirados; manter o switch alto não repete operações. Não existe comando de escrita no controlador.

O bloco de diagnóstico tem 512 bytes, com `byte[i] = (i & 255) XOR 0xA5`. O comparador mantém apenas um resultado provisório durante a transferência; somente `block_valid`, após CRC16 correto do bloco completo, publica o resultado. LD8 acende em erro de inicialização, leitura ou formato. Um novo pedido limpa o diagnóstico anterior; erros de leitura são limpos pelo controlador ao iniciar a próxima leitura. LD7 continua indicando inicialização e LD9 indica inicialização/leitura em curso. LD4–LD6 e os LEDs do joystick foram preservados.

A imagem de teste é criada com `python3 scripts/make_sd_diagnostic.py caminho-novo.img`. O gerador cria exclusivamente um arquivo novo, recusa sobrescrita e não acessa dispositivos. A imagem tem 1.049.088 bytes, não contém partição nem filesystem e não foi gravada em cartão. Não copiar esta imagem sobre mídia com arquivos do usuário. A preparação física de um cartão dedicado permanece separada.

O controlador verifica CMD0, CMD8/R7, CMD55/ACMD41 e CMD58/OCR com CCS e power-up completos. SDSC não é suportado. CMD17 usa endereçamento de bloco, verifica token, 512 bytes e CRC16, e libera CS com clocks de término. Existem timeout de R1, token e limite de tentativas ACMD41. O limite padrão ACMD41 foi ampliado de 32 para 4096 para não esgotar a inicialização em poucos milissegundos com clock de 400 kHz. Os testes de erro usam limites menores explícitos.

SD_CD não é consumido: ausência é detectada por timeout de resposta. Não há suporte aprovado a hot-plug. Reinicialização é exercitada na interface de reset do controlador; no top, o reset é o de partida. A aplicação não expõe um novo botão de reset e não solicita power cycle automaticamente após uma falha.

## Correções de temporização

A projeção vertical armazena `-sin(roll)` no estágio que já registrava o seno. Isso retira a negação do caminho de entrada do multiplicador, sem acrescentar estágio e sem alterar a faixa de ângulos. A equivalência foi comparada ao RTL do snapshot para os 3.721 pares inteiros de pitch/roll em ±30 graus, com acelerações assinadas pseudoaleatórias e amostras consecutivas. Resultado e validade coincidiram bit a bit.

O clock de pixel mantém o divisor existente. `-edges {3 7 11}` descreve waveform `{10 30}` e período 40 ns relativos ao primeiro posedge do clock principal. Com o primeiro posedge simulado em 5 ns, a primeira subida de pixel ocorre em 15 ns. Não foi usado multicycle path.

O handshake de `entrada_hud` retém a palavra lógica de 128 bits desde o pedido até a confirmação retornar. O destino captura somente após `pedido_meta`, `pedido_sync` e a comparação com a confirmação. Mesmo com a primeira captura de controle imediata, há dois períodos de pixel (80 ns) antes da captura do barramento. Um atraso de dados limitado a 20 ns e skew limitado a 10 ns deixam margem para essa estabilização. A origem só aceita a próxima palavra após dois estágios de retorno da confirmação. O protocolo aplica backpressure e pode descartar ofertas enquanto ocupado; não garante amostrar toda alteração dos sensores. O HUD oferece continuamente o estado mais recente.

As exceções de controle terminam exclusivamente em `pedido_meta/D` e `confirmado_meta/D`. Os segundos estágios continuam temporizados. `set_max_delay -datapath_only 20` e `set_bus_skew 10` cobrem apenas retido → dados_destino. As restrições não declaram os clocks globalmente assíncronos. A síntese remove/combina bits da palavra, deixando 112 registradores físicos em cada extremidade; isso não altera a largura lógica testada de 128 bits.

## Interface externa e aprovação

O build usa inicialização e leitura a 400 kHz (`HALF_PERIOD_CYCLES=125`, clock principal 100 MHz): cada semiciclo tem 1.250 ns. Os testes funcionais de SPI não comprovam atrasos elétricos de cartão, trilhas e buffers. As constraints existentes ainda não contêm um modelo aprovado de input/output delay para SD_DAT0, SD_CMD, SD_DAT3 e SD_SCK. Não foram inseridos valores supostos para produzir fechamento artificial.

O Master XDC oficial confirma SD_RESET E2, SCK B1, MOSI C1, MISO C2, CS D2, CD A1, LEDs U16/V16/T15 e SW8 T8/LVCMOS18. O manual informa que SD_RESET baixo alimenta o slot. Esses documentos identificam o projeto da placa, não o exemplar físico conectado nem sua revisão ou cartão.

Referências consultadas:

- [Master XDC Nexys A7-100T, Digilent](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-100T-Master.xdc).
- [Manual da Nexys A7, Digilent](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf).
- [Especificações simplificadas, SD Association](https://www.sdcard.org/downloads/pls/).

## Reprodução e preservação

A branch permanece `feat/video-sd-overlay`. Executar `bash scripts/test.sh` para a regressão. Para implementação sem geração de bitstream ou acesso a hardware:

```sh
source /home/santojuca/AMD/2026.1/Vivado/settings64.sh
vivado -mode batch -log /caminho/novo.log -journal /caminho/novo.jou \
  -source scripts/implement_sd_timing.tcl -tclargs C /caminho/diretorio-inexistente
```

O script lê a calibração de `constraints/magnetometer_calibration.tcl`: offsets X=-8, Y=-148 e ganhos Q12 X=3935, Y=4270. Faz síntese, otimização, placement e routing com quatro threads e diretivas Default. Produz checkpoints e relatórios; não gera `.bit` nem `.mcs` e não abre Hardware Manager. Produzir um relatório não significa aprová-lo.

As evidências locais ficam no diretório indicado por `validation/finalization-current.txt`, fora dos commits. `source-snapshot.tar.gz`, `snapshot.json`, `initial-status.txt` e `initial.patch` preservam fontes rastreados e não rastreados antes das alterações. O arquivo tar foi reaberto e sua lista de membros conferida. Para rollback, extrair em diretório novo e comparar com o checkout; não extrair por cima de trabalho posterior. Os diretórios históricos de validação e bitstreams não foram substituídos.

## Programação e Flash

Esta versão exige aprovação temporal externa antes de qualquer liberação. Não utilizar bitstreams históricos como se correspondessem a estes fontes. O script legado `program_board.tcl` agora recusa execução por padrão antes de abrir hardware; sua liberação volátil é reservada à ação explícita do usuário, após revisão do caminho do bitstream. Não foi executado.

A gravação Flash foi autorizada condicionalmente pelo usuário, mas exige aprovação integral, identificação do exemplar e backup recuperável do conteúdo atual. Há registros históricos de uma S25FL128S e backups antigos em `/home/santojuca/Downloads/HUD_FPGA_Entrega_2026-10-13/`; eles não identificam o conteúdo atual. Não houve acesso JTAG, leitura, apagamento, programação, reset ou ciclo de alimentação da placa nesta execução.

Quando os bloqueios forem resolvidos: gerar o `.bit` a partir do checkpoint aprovado; confirmar Flash real, capacidade e modo; gerar a imagem de configuração com parâmetros confirmados; verificar a correspondência da imagem com o payload do bitstream e seus SHA-256; preservar e conferir backup atual antes de qualquer apagamento. Se o fluxo Flash exigir carregar um helper volátil na FPGA, isso conflita com a proibição atual de programação volátil e deve ser resolvido antes de executar tal fluxo.

Após liberação, a programação direta via JTAG continua a cargo do usuário. Antes de energizar periféricos, conferir a montagem existente, em especial a faixa unipolar de 0–1 V do XADC já registrada como pendente na documentação histórica. Depois, verificar VGA, modos, sensores, joystick e buzzer; inserir cartão de teste preparado e conferir inicialização, solicitação única, ocupação, erro CRC/timeout e recuperação. Nenhuma dessas verificações físicas foi realizada nesta execução.

## Resultado da implementação executada

A execução válida está em `validation/finalization-20261030T101146Z/route-C-v2/`, com Vivado 2026.1 build 6511674 e FPGA `xc7a100tcsg324-1`. Terminou com código zero e 18.998 de 18.998 nets roteáveis concluídas, sem erros de roteamento.

| Métrica pós-route | Resultado |
|---|---:|
| WNS / TNS | +0,337 ns / 0 ns |
| WHS / THS | +0,015 ns / 0 ns |
| WPWS / TPWS | +4,020 ns / 0 ns |
| LUT / registradores | 12.774 / 7.275 |
| DSP / BRAM / BUFG | 32 / 0 / 2 |
| Endpoints internos sem restrição | 0 |
| Skew do barramento CDC / limite | 1,414 ns / 10 ns |
| Pior atraso de dados CDC reportado | 1,611 ns, limite 20 ns |
| DRC | 0 erros; 56 avisos |
| CDC | 18 informações CDC-3; 112 avisos CDC-15; nenhum crítico reportado |

Os 112 avisos CDC-15 correspondem à estrutura bundled-data com clock enable. Permanecem visíveis no relatório, com revisão fundamentada no handshake e no limite físico de atraso/skew. A auditoria adicional do checkpoint confirmou os quatro estágios de sincronização de controle presentes com `ASYNC_REG=1`. A cobertura de max-delay tem 112 endpoints. O percentual To=33,33% contabiliza pinos implícitos das células (dados/controle/clock); não significa que somente um terço dos bits de dados foi restringido. Os dois false paths de controle cobrem um endpoint cada.

O DRC apresenta CFGBVS-1 (1), DPIP-1 (10), DPOP-1 (18) e DPOP-2 (27). O aviso CFGBVS-1 exige declarar CFGBVS/CONFIG_VOLTAGE conforme a alimentação real do banco de configuração antes da geração definitiva. Os outros avisos são recomendações de pipeline DSP; não foram alterados por não haver violação nas restrições internas atuais.

`check_timing` registra sete entradas sem input delay (SD_DAT0 e seis linhas I2C), outras 16 entradas com false path de sincronização, e 35 saídas sem output delay, incluindo SPI, VGA, I2C, LEDs e buzzer. LEDs e buzzer não têm receptor síncrono externo; isso não justifica ignorar a interface SD. O relatório de MISO mostra `Slack: inf`, portanto seu atraso físico de até 12,514 ns **não equivale a aprovação de setup/hold externo**. A metodologia apresenta 36 avisos TIMING-18 e 11 XDCB-5. Não houve redução de severidade, waiver automático nem declaração de aprovação por ausência de erros DRC.

No teste de throughput a 400 kHz foram confirmados três setores consecutivos, 1.536 bytes, CRC correto, 1.050.003 ciclos por setor e aproximadamente 48.761,77 bytes/s úteis. O limite calculado pelo teste para quadros hipotéticos de 76.800 bytes (por exemplo, 320×240 com um byte por pixel) foi 0,6349 quadro/s; não é reprodução implementada nem medição de bancada.

A primeira chamada do Vivado falhou por posição incorreta de argumentos na linha de comando. A tentativa seguinte concluiu síntese, mas a checagem inicialmente exigia 128 registradores físicos e interrompeu antes de implementar; foi corrigida para a netlist otimizada de 112. A execução `route-C-v2` é a evidência válida. Uma primeira checagem adicional confundiu a representação booleana `1` com a string `TRUE`; a checagem corrigida terminou com código zero. Os logs anteriores foram preservados e não contam como aprovações.

**Liberação bloqueada.** Não foram gerados `.bit` ou `.mcs` desta versão e a Flash não foi gravada. O próximo passo mínimo é completar o modelo temporal externo das interfaces essenciais, especialmente SPI, com limites verificáveis de cartão, placa e I/O, e declarar a tensão de configuração confirmada. Reanalisar o checkpoint roteado com essas constraints antes de considerar nova implementação. Só depois de aprovado cabe identificar a Flash atual e preservar seu conteúdo. O SHA-256 do backup histórico de 13/10 foi novamente conferido como `b52dcf59ceb12d79d43e35e973c9db680746b86da4db5fa7b3c4fd7a74463cb2`; ele não substitui backup atual.

## Regressão concluída e entrega

A regressão completa terminou com código 0: 73 testbenches, 256 linhas contendo a palavra PASS e nenhuma linha FATAL. A contagem de PASS não é uma contagem de testes independentes. Foram executados os cenários existentes de HUD, VGA, sensores, modos, joystick, buzzer e CDC, mais os testes SD incorporados ao runner. Além disso, passaram os testes direcionados de integração, equivalência numérica de projeção, criação/recusa de sobrescrita da imagem de teste, conferência SHA-256 e bloqueio padrão do script de programação.

O manifesto local `manifest.json` registra aprovação falsa e caminhos nulos para `.bit` e `.mcs`. `sources-sha256.json` identifica os 55 arquivos de entrada da implementação. `SHA256SUMS` identifica os checkpoints, relatórios, logs e a imagem de diagnóstico. As evidências volumosas permanecem locais em `validation/`; fontes, testes, scripts e documentação foram organizados em commits locais, sem push.
