# microSD P0: leitura CMD17 e comparação com referência Linux

Data: 30/10/2026. Placa Nexys A7-100T, XC7A100TCSG324-1. **Três leituras físicas confirmadas pelo usuário, com páginas de dados e CRC conferidas.** Partida a frio e recuperação física após erro continuam pendentes; overlay e interface elétrica não estão aprovados.

## Preservação e estado inicial

Checkout: `/home/santojuca/Downloads/Trabalho-display-aviao-v2-video-sd`.
Branch `feat/video-sd-overlay`; HEAD `0271499a8538135abc6291e512b421382337c7c2`.
Nenhum arquivo rastreado modificado inicialmente. Havia três documentos locais: auditoria de viabilidade, orçamento temporal SPI e solicitação técnica QD101.

Os 230 arquivos rastreados coincidiram por SHA-256 com `validation/spi-budget-20261030/preservation.json`. Os dois documentos locais mencionados pela auditoria continuam presentes; esse manifesto não contém hashes históricos desses dois documentos. Portanto, a contagem anterior de 232 está registrada na auditoria, mas a comparação histórica independente disponível cobre os 230 rastreados. Nesta execução foram inventariados e copiados 233 arquivos, incluindo os três documentos. Todos os membros do novo backup foram conferidos por hash.

Evidência desta execução: `validation/p0-read-20261030T155225Z/`. `initial.json` registra Git e hashes iniciais; `before.tar` preserva os arquivos anteriores às alterações. Nenhum manifesto ou relatório histórico foi substituído. Na entrega inicial não houve push, merge, gravação de cartão, Flash ou programação JTAG. Depois, a pedido explícito do usuário, o agente carregou somente a configuração volátil por JTAG, com DONE=1, conforme o registro abaixo. Não houve escrita na Flash ou no cartão.

## Arquitetura reaproveitada

`top_reticula` continua compondo o HUD. `sd_spi_controller` arbitra o SPI entre `sd_spi_init` e `sd_spi_read_block`. Clock do controle: 100 MHz. Inicialização e leitura deste experimento: 400 kHz, SPI Mode 0. Não foi introduzido clock gerado.

A inicialização existente executa CMD0, CMD8, CMD55/ACMD41 e CMD58. Exige power-up completo, CCS=1 e faixa OCR compatível. SDSC é rejeitado, não recebe silenciosamente endereço de bloco. O QD101 de 32 GB é SDHC; CMD17 recebe o LBA de 32 bits diretamente, sem multiplicar por 512. Suporte SDSC exigiria outra sequência e CMD16, fora deste P0.

O leitor existente transmite `{0x51, LBA, 0xFF}` MSB primeiro, mantém CS baixo, encontra o primeiro zero de R1, completa seus sete bits restantes e exige R1=0. Depois recebe bytes de espera FF até FE, 512 bytes de dados e dois bytes de CRC, primeiro o mais significativo. Dados geram `data_valid` provisório; somente `block_valid`, após comparar CRC e emitir oito clocks finais com CS alto, confirma sucesso. Erros também liberam CS, emitem os clocks finais e voltam ao estado ocioso. Reset aborta imediatamente a transação.

CRC16 existente preservado: polinômio `0x1021`, inicialização zero, MSB primeiro, sem reflexão ou XOR final. Foi conferido com o vetor independente publicado pela SD Association: 512 bytes FF resultam em `0x7FA1`, além dos cenários variáveis. A referência real tem CRC16 de software `0x5DC5`.

## Timeout: causa e correção

A pendência estava em `WAIT_TOKEN`, não na recepção dos 512 bytes. `wait_count` incrementa em cada borda de subida de SCK. Antes, `MAX_WAIT_TOKEN_CLOCKS=65535` era constante: 163,84 ms a 400 kHz, mas somente 2,62 ms a 25 MHz. Não se encontrou necessidade de aumentar o timeout de R1 ou reinicializar o contador em outro estado.

Agora o limite padrão é derivado de `CLK_HZ`, `TOKEN_TIMEOUT_MS=250` e `HALF_PERIOD_CYCLES`, arredondando para bytes SPI inteiros:

```
MAX_WAIT_TOKEN_CLOCKS = 8 * ceil(CLK_HZ * TOKEN_TIMEOUT_MS / (16000 * HALF_PERIOD_CYCLES))
```

A multiplicação usa 64 bits para evitar overflow. O contador permanece habilitado por SCK; o prazo de parede é preservado quando o divisor muda. A quantização é de até um byte SPI. São 100.000 clocks a 400 kHz e 6.250.000 a 25 MHz. Overrides explícitos continuam disponíveis para testes curtos. O contador passou de 32 bits para a largura suficiente ao limite configurado.

Os 250 ms são a política conservadora definida na auditoria, não um máximo SPI garantido do QD101. A referência pública SD §4.6.2.1 recomenda ao menos 100 ms na discussão de leitura SDHC; não estabelece sozinha a latência específica deste cartão em SPI.

Fases permanecem separadas:

- R1: até 64 clocks SCK para início da resposta; erro 2.
- Token: 250 ms de espera, encerrada por FE, token de erro ou expiração; erro 3.
- Dados: exatamente 4.096 clocks, 10,24 ms a 400 kHz.
- CRC: exatamente 16 clocks, 40 µs a 400 kHz.
- Término/recuperação: oito clocks, 20 µs a 400 kHz.

Dados/CRC não esperam um evento externo para avançar: o host gera SCK. Se o cartão interromper a transmissão, o host ainda recebe níveis em DAT0 até completar essas fases; o teste de transmissão interrompida verifica rejeição por CRC. Não existe um sinal SPI que permita distinguir um FF legítimo de uma linha liberada. A comparação integral com a referência também é necessária.

## Referência Linux real

O usuário confirmou `/dev/sdc` como o QD101 conectado por leitor USB. O Linux identificou dispositivo removível, leitor `Storage Device`, capacidade **31.914.983.424 bytes**. O leitor não expôs CID/modelo do cartão; a identidade do exemplar foi confirmada pelo usuário. O dispositivo de sistema é outro.

A permissão de leitura bruta exigiu sudo. O agente não recebeu senha nem elevou privilégios. O usuário executou no terminal a leitura somente de entrada `dd if=/dev/sdc bs=512 count=1 iflag=fullblock status=none`, redirecionada para o arquivo local privado. O agente verificou o arquivo de 512 bytes e preparou os derivados. Não houve formatação, reparo ou escrita no dispositivo pelo agente.

- LBA: **0**, offset zero.
- Tamanho: **512 bytes**.
- SHA-256: `6f29a2a768e00982b8777bfae1feb7fc0241b57d7ff0ff81b95f8bf7b8627698`.
- CRC16 de software: **5DC5**.
- Aquisição e identidade: `linux/acquisition.json`.
- Binário: `linux/sector_reference.bin`.
- ROM, cópia e hexdump privado: `linux/reference/`.

Caminhos acima são relativos à pasta desta execução. O hexdump não é reproduzido em relatórios públicos. O setor não é tratado como imagem gráfica. Para outra referência regular já adquirida, usar:

```sh
python3 scripts/sd_sector_reference.py CAMINHO/sector_reference.bin PASTA_NOVA --lba 0
```

O utilitário recusa dispositivos, links, tamanho diferente de 512 e pasta de saída existente. Cria pasta 0700 e arquivos 0600.

## Comparação e diagnóstico na FPGA

O novo parâmetro `SD_DIAGNOSTIC_LBA` substitui o LBA 2048 fixo; o experimento usa zero. `SD_REFERENCE_FILE` seleciona a ROM dos 512 bytes reais. Cada byte recebido é comparado à posição correspondente. A ROM tem leitura síncrona e controles registrados sem reset assíncrono; a comparação acompanha a latência desse pipeline. O diagnóstico confere quantidade e sequência dos índices, retém a primeira divergência e só publica DATA_OK após `block_valid` e exatamente 512 bytes. CRC incorreto ou reset nunca aprovam conteúdo. Sem arquivo de referência, DATA_OK permanece apagado.

LD0..LD9 e seus usos foram preservados. Acrescentados LD10 e LD11, antes livres. SW4..SW7 e os oito dígitos também estavam livres. Os pinos novos foram conferidos no Master XDC oficial. Apenas as entradas do primeiro estágio dos sincronizadores de página receberam exceção de caminho assíncrono; estágios seguintes continuam temporizados. Todos os registros novos trabalham a 100 MHz.

| LED | Significado |
|---|---|
| LD7 | Inicialização SDHC concluída |
| LD8 | Erro de inicialização, leitura ou comparação |
| LD9 | Inicialização/leitura em andamento |
| LD10 | Última leitura com CRC válido |
| LD11 | Última leitura com 512 bytes idênticos à referência e CRC válido |

SW8 continua solicitando uma única leitura na transição 0→1, com debounce. Mantê-lo alto não repete leituras. É preciso deixá-lo baixo depois da inicialização para armar a primeira solicitação. Cada novo pedido limpa o resultado anterior; contadores persistem até reset.

Seleção de página: número binário em **SW7 SW6 SW5 SW4**, SW4 é o bit de menor peso. Todos os números exibidos são hexadecimais; oito dígitos lidos da esquerda para a direita.

| Página | Formato / interpretação |
|---|---|
| 0 | `50 CC S I E F`: comando CC; estado S; erro init I; erro leitura E; flags F=READY,BUSY,CRC_OK,DATA_OK |
| 1 | `RR TT NNNN`: R1, token e quantidade de bytes recebidos |
| 2 | `RRRR CCCC`: CRC recebido e calculado pela FPGA |
| 3 | `III EE RR F`: primeiro índice divergente, esperado, recebido, flag de divergência finalizada |
| 4 | Tentativas de leitura |
| 5 | Leituras aprovadas com comparação integral |
| 6 | Timeouts de leitura R1/token |
| 7 | Leituras com erro, inclusive divergência de conteúdo |
| 8 | LBA selecionado no build |
| 9 | `00000001` se a referência foi incorporada; zero se ausente |

Erro de leitura E: 1=R1 inválido; 2=timeout R1; 3=timeout token; 4=token inválido; 5=CRC incorreto. I pertence à inicialização: 1=CMD0, 2=CMD8, 3=CMD55, 4=ACMD41, 5=tentativas ACMD41, 6=CMD58/OCR, 7=timeout de comando.

Estado S: 0=ocioso; 1=comando; 2=espera R1; 3=recebe R1; 4=espera token; 5=dados; 6=CRC; 7/8=término sucesso/erro; 9..C=clocks finais. Depois da leitura, o comando corrente volta a CMD58 (`3A`) pela arbitragem existente.

O ILA foi tentado, mas `create_debug_core` foi recusado pela licença Vivado BASIC (erro 12-29205). O log foi preservado. O caminho entregue usa ROM, LEDs e sete segmentos; **não produz dump binário de bytes recebidos pela FPGA**. A comparação byte a byte é executada dentro da FPGA contra os bytes Linux incorporados. A observação desses resultados em hardware continua pendente.

## Simulações e implementação

Os logs `verified-regression/` e `real-reference-simulation-safe.log` registram as verificações dirigidas. O último executa a integração usando os bytes realmente adquiridos no Linux como resposta do modelo de cartão, sem alegar leitura física da FPGA.

Cobertura: inicialização válida e falhas existentes; CMD17; R1 inválido e timeout; token atrasado até o último byte permitido; token inválido e timeout; 512 bytes; CRC correto/incorreto; transmissão interrompida com DAT0 alto; reset durante transferência; nova leitura após erro sem reset; requests ocupados; debounce; primeira divergência no byte 511; contadores; publicação após CRC; equivalência da saída VGA entre top com SD habilitado/desabilitado durante os cenários.

O teste do prazo usa 1 ms para executar rapidamente e mede ciclos de 100 MHz, com divisores 125, 10, 5 e 2. Isso verifica a derivação temporal sem simular centenas de milissegundos desnecessariamente. O padrão de 250 ms é derivado pela mesma expressão. O display tem teste próprio dos 16 glifos, oito ânodos, seleção de página e apagamento.

Reexecutar sem sobrescrever evidência:

```sh
bash scripts/test_sd_p0.sh validation/NOVA_EXECUCAO
```

O runner completo também inclui os testes novos; a regressão histórica de 73 benches foi preservada, não reclassificada como execução atual. A integração do buffer e o overlay não foram iniciados no top. Após as três leituras confirmadas, o buffer foi preparado e validado isoladamente, conforme o registro de P1.

O build indicado para ensaio fica em `bench-400khz/`. A tentativa `experimental/` terminou na restrição de licença do ILA. `with-reference/` e `with-reference-safe/` foram preservados, mas não devem ser usados: ambos apresentaram avisos REQP-1840 na ROM. O estágio síncrono da primeira correção foi retimado pelo Vivado para a saída da memória, mantendo os controles ligados aos registros assíncronos originais.

A correção preserva explicitamente, com `DONT_TOUCH`, apenas os nove bits de endereço e o enable da ROM. A síntese isolada (`check-rom.log`, `rom-controls.rpt`, `rom-control-drivers.txt`) confirmou controles dirigidos por FDRE e nenhum aviso REQP-1840. O script de build agora bloqueia o bitstream se esse aviso reaparecer, houver erro DRC, slack interno negativo, registro sem clock ou endpoint interno sem restrição. Não há supressão de severidade. Os resultados do build completo estão no manifesto desta execução.

A verificação adicional `bench-pages-reference.log` confirmou, em simulação com a referência Linux, as páginas de dados, CRC e estado descritas abaixo. A leitura completa após reset em plena transferência também passou (`reset-recovery.log`).


## Resultado local verificado

O build `bench-400khz` terminou com código zero no Vivado 2026.1. Bitstream experimental: `validation/p0-read-20261030T155225Z/bench-400khz/experimental.bit`. SHA-256: `26ec2db29f8b69d1cbe0b53c45e0a88bf004bc20bce5803a86616bf3edf60f39`.

STA roteado: WNS **+0,316 ns**, TNS zero; WHS **+0,023 ns**, THS zero. Zero registros sem clock e zero endpoints internos não restringidos. CDC: zero endpoints inseguros ou desconhecidos no relatório. DRC: zero erros, zero avisos REQP-1840; permanecem 55 avisos de pipeline de DSP, sem modificação dessas funções preexistentes. O relatório ainda identifica SD_DAT0 sem input delay e saídas sem output delay, inclusive indicadores visuais e enlace SPI; isso não foi ocultado nem convertido em aprovação externa.

Recursos totais do HUD com diagnóstico: **12.892 LUTs, 7.526 FFs, 32 DSPs e 1 RAMB18**. Essa BRAM contém a referência Linux; não é buffer de dados recebidos para VGA.

Passaram os 13 testbenches RTL dirigidos, com 16 execuções configuradas (o prazo de token foi exercitado em quatro divisores), e a verificação Python da preparação da referência. Também passaram as verificações adicionais da recuperação após reset e das páginas do painel usando o setor Linux. Os últimos ajustes de preservação dos registradores afetam a síntese; sua eficácia foi comprovada no circuito sintetizado e no DRC roteado. Nenhuma simulação de comportamento ficou reprovada. A falha de licença e os artefatos com avisos BRAM permanecem como tentativas substituídas.

`manifest.json` registra aprovação física e elétrica falsas; os campos de resultados físicos permanecem nulos. `bench-sources-sha256.json` identifica as 57 entradas do build. `SHA256SUMS` identifica o artefato, checkpoint, relatórios e logs. Esse manifesto foi fechado antes da programação e permanece histórico. A programação volátil posteriormente autorizada e a observação física estão registradas separadamente abaixo.

## Procedimento de bancada

1. Ejetar com segurança o cartão no Linux. Com a Nexys desligada, recolocá-lo no slot original. Preservar a montagem previamente conferida; não ligar fonte externa ao slot nem alterar periféricos.
2. SW8 em zero. Deixar SW4..SW7 em zero para página 0. Manter os demais switches conforme o uso atual do HUD. Conectar VGA e a alimentação/JTAG habituais da placa.
3. Usar somente o **bitstream experimental desta execução**, depois de conferir o manifesto. No Vivado Hardware Manager: Open Target → selecionar a Nexys/`xc7a100t` correta → Program Device → selecionar `bench-400khz/experimental.bit`. Esse era o procedimento manual previsto. O usuário posteriormente autorizou o agente a carregar o bitstream; a configuração volátil foi executada com DONE=1. Não adicionar Configuration Memory Device nem gravar Flash.
4. Aguardar inicialização. LD9 deve apagar, LD7 acender e LD8 permanecer apagado. Na página 9 confirmar `00000001`; na página 8, `00000000`. LD7 sozinho não comprova leitura.
5. Voltar à página 0 e subir SW8 para um. A leitura típica dura cerca de 10,5 ms mais a espera do cartão; o pulso de LD9 pode ser curto demais para enxergar. Manter SW8 alto não repete a leitura.
6. Após a operação: LD7, LD10 e LD11 acesos; LD8 e LD9 apagados. Página 1 deve mostrar **`00FE0200`**. Página 2 deve mostrar **`5DC55DC5`**. Página 0 após retorno ao ocioso deve mostrar **`503A000B`**. Página 4 deve mostrar `00000001`, página 5 `00000001`, páginas 6 e 7 zero.
7. Registrar os valores e as condições reais de alimentação, placa e cartão. Se houver falha, registrar páginas 0, 1, 2, 3, 4, 6 e 7 antes de solicitar outra leitura. Timeout aparece em E=2/3 e aumenta página 6. CRC incorreto aparece em E=5 e mantém LD10/LD11 apagados. Divergência com CRC correto acende LD10 e LD8, deixa LD11 apagado e informa o primeiro byte na página 3.
8. Para repetir: SW8 baixo por pelo menos 20 ms e depois alto. Conferir que tentativas e aprovações aumentam juntas, sem crescer os contadores de falha ou timeout. Registrar várias leituras; a qualificação experimental ampliada proposta na auditoria continua exigindo sua amostra de 1.024 leituras e 20 partidas, ainda não realizada.
9. Para reinicializar após falha de init, usar nova configuração volátil manual ou partida a frio. O top não ganhou botão de reset; os testes de reset internos não significam que exista um comando de reset no painel. Nunca remover/inserir o cartão com a placa energizada neste ensaio.
10. Verificar que HUD, modos, sensores, joystick, alertas e buzzer continuam operantes. Se qualquer um falhar, registrar e interromper a integração seguinte.

## Registro físico de 30/10/2026

Após o pedido “OK adicionei o SD aqui no FPGa suba o bitstream”, o agente verificou o SHA-256 do artefato, identificou uma única FPGA `xc7a100t` e carregou a configuração volátil. O Vivado confirmou `PROGRAM_DONE=1`. Evidência: `manual-program-20261030T162640Z/`, sem alteração dos registros anteriores.

O usuário acionou a leitura e respondeu “Exatemente assim ficou” à indicação esperada de LD7, LD10 e LD11 acesos, com LD8 apagado. Isso é evidência de bancada relatada pelo usuário de inicialização, CRC válido e comparação integral dos 512 bytes com a referência Linux no LBA 0. Não é apenas resultado de simulação.

O registro `physical-leds-20261030T162917Z/observation.json` distingue indicação dos LEDs de leitura direta das páginas. Nesse primeiro registro ainda não havia valores de painel ou repetição. A confirmação posterior está no registro abaixo; contagem exata de tentativas, partida a frio e recuperação física após erro continuam sem observação. O manifesto original de build conserva os valores de aprovação existentes quando foi criado.

## Pendências e limite de aprovação

A aquisição Linux e a primeira leitura física indicada por CRC_OK/DATA_OK estão confirmadas. A observação dos LEDs foi informada pelo usuário; não houve captura automatizada desses indicadores. O usuário confirmou as duas leituras adicionais e as páginas 1=`00FE0200` e 2=`5DC55DC5`. Temos pelo menos três leituras físicas aprovadas na amostra relatada, com CRC e 512 bytes idênticos à referência. Partida a frio e recuperação física após erro também não estão comprovadas. P0 integral permanece pendente.

A ROM da referência não é o buffer de setores de P1. O módulo de buffer com dois bancos foi preparado e validado isoladamente após as três leituras; seu acoplamento físico ao top/VGA, recurso gráfico e overlay permanecem pendentes. LBA 0 não foi identificado como bitmap e não será desenhado como imagem. Não foi copiado arquivo para o cartão.

Os pinos SPI continuam sem orçamento externo completo aprovado, conforme a auditoria e o orçamento temporal anteriores. STA interno e DRC não comprovam margem elétrica do QD101. Não foram inventados input/output delays ou alteradas as exceções SPI para fazer relatórios passarem. A aprovação funcional de bancada e a aprovação elétrica permanecem distintas.

Fontes primárias: [SD Association, Physical Layer Simplified](https://www.sdcard.org/downloads/pls/), §§4.5, 4.6.2.1 e 7; [Master XDC Nexys A7-100T](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-100T-Master.xdc). Cópias e análise de escopo já constam nas evidências históricas.

## Arquivos desta entrega

Alterados: `rtl/sd_spi_read_block.sv`, `rtl/sd_spi_controller.sv`, `rtl/sd_diagnostic.sv`, `rtl/top_reticula.sv`, `constraints/nexys_a7_reticula.xdc`, `scripts/test.sh`, `tests/tb_sd_spi_read_block.sv`, `tests/tb_sd_diagnostic.sv` e `tests/tb_top_sd_integration.sv`.

Acrescentados: `rtl/sd_status_display.sv`; `scripts/build_sd_p0.tcl`, `scripts/test_sd_p0.sh`, `scripts/sd_sector_reference.py`; `tests/tb_sd_spi_token_timeout.sv`, `tests/tb_sd_status_display.sv`, `tests/sd_reference.hex` e `tests/test_sd_sector_reference.py`; este documento. A fixture `tests/sd_reference.hex` é sintética e não contém o setor do cartão. A referência real e os artefatos de bancada ficam na pasta privada ignorada pelo Git.

## Confirmação das leituras repetidas

O usuário respondeu “As duas passaram e as páginas mostram os valores esperados” à solicitação de mais duas leituras e conferência das páginas 1 e 2. Assim, a amostra relatada tem pelo menos três leituras físicas corretas, R1=00, token FE, 512 bytes, CRC recebido=5DC5 e CRC calculado=5DC5, com DATA_OK e sem LED de erro. A referência Linux foi mantida. Evidência: `physical-repeat-20261030T163524Z/observation.json`.

Isso comprova o caminho de leitura repetida nesta amostra e permite preparar P1 independentemente. Não comprova os ensaios de partida a frio, recuperação física após falha, amostra ampliada da auditoria ou margem elétrica. O bitstream P0 carregado permanece inalterado.

## Preparação independente de P1

O módulo `rtl/sd_sector_buffer.sv` e seu testbench foram preparados sem alterar o top ou o bitstream carregado. A simulação verificou bancos alternados, publicação no blanking, preservação após erro, leitura/escrita simultâneas, latência e reset. A síntese inferiu uma RAMB18E1, 35 LUTs e 61 FFs; os dois cruzamentos de controle foram classificados como seguros. A integração física ainda não foi executada. Detalhes em [buffer_BRAM_microSD_20261030.md](buffer_BRAM_microSD_20261030.md).
