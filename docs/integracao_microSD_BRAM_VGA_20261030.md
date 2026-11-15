# Integração microSD, BRAM e VGA — 30/10/2026

A integração está simulada, sintetizada e implementada para a Nexys A7-100T. O bitstream experimental está preparado para programação manual. Esta versão não foi programada na FPGA nem teve o ícone observado fisicamente. As três leituras físicas corretas da P0 continuam sendo evidência da P0, não desta integração.

## Estado inicial e preservação

Repositório `/home/santojuca/Downloads/Trabalho-display-aviao-v2-video-sd`, branch `feat/video-sd-overlay`, HEAD `0271499a8538135abc6291e512b421382337c7c2`. Já havia alterações locais da P0 e o buffer da P1. O registro `validation/sd-overlay-20261030T165217Z/initial.json` contém o estado inicial e os hashes de 246 arquivos, preservados no backup verificado `before.tar` do mesmo diretório. Nenhum commit ou push foi feito nesta entrega.

O top efetivo é `rtl/top_reticula.sv`. A leitura SPI, CMD17, CRC e diagnóstico já estavam ligados ao top. O buffer `rtl/sd_sector_buffer.sv` existia e havia sido validado isoladamente, mas ainda não alimentava a VGA. Foi reutilizado sem alterações. O controlador VGA e os módulos de instrumentos foram preservados. O XDC está byte a byte igual ao início desta tarefa, incluindo as restrições anteriores da P0; não foram acrescentadas exceções de temporização.

Documentos P0, caracterização, buffer, bitstreams e manifestos anteriores permanecem preservados. A primeira execução exploratória de síntese foi interrompida e substituída pela execução final `implementation-2`; a classificação consta em `preliminary-build-note.txt`. Os resultados finais abaixo pertencem exclusivamente a `implementation-2`.

## Arquitetura implementada

```text
QD101 / LBA 30006080
  → controlador SPI existente / CMD17 / CRC16 / comparação de 512 bytes
  → banco inativo do sd_sector_buffer (100 MHz)
  → commit completo / pedido toggle / sincronização
  → troca do banco em x=0, y=480 (blanking vertical, 25 MHz)
  → BRAM síncrona / antecipação de dois pixels
  → sd_bitmap_overlay / composição transparente com RGB original
  → VGA existente 640×480
```

O top habilita o caminho com `ENABLE_SD_SUBSYSTEM=1` e `ENABLE_SD_OVERLAY=1`. O padrão de `ENABLE_SD_OVERLAY` continua zero. O build experimental habilita ambos e usa o LBA físico confirmado. A frequência SPI permanece 400 kHz, tanto na inicialização quanto na leitura.

O buffer contém dois bancos de 512 bytes em uma RAMB18. A escrita recebe os bytes e índices reais do controlador; a memória do overlay não é inicializada com o desenho. O arquivo hexadecimal do build inicializa apenas a ROM de referência do diagnóstico, usada para comparar os bytes efetivamente recebidos. São duas RAMB18 no projeto completo: uma para essa referência e outra para os dois bancos.

Uma nova leitura escreve exclusivamente no banco inativo. A publicação exige os 512 índices na ordem correta, CRC válido e, nesta configuração com referência, igualdade dos 512 bytes. O top espera mais um ciclo de sistema após `block_valid` para a comparação terminar. Erro de leitura ou divergência cancela a publicação e conserva o banco visível. Uma nova solicitação fica bloqueada enquanto o buffer aguarda confirmação.

O bit de pedido também identifica o banco; não há barramento de dados atravessando sincronizadores independentes. Pedido e confirmação usam dois registradores por sentido. A VGA troca o banco no início do blanking vertical e drena dois clocks de leitura antes de liberar o banco antigo. O reset comum é afirmado assincronamente e liberado por sincronização em cada domínio. Reset limpa a validade; não é necessário apagar o conteúdo da BRAM.

Os clocks de 100 MHz e 25 MHz têm origem comum. O relatório CDC pós-rota classifica 123 endpoints de sistema para pixel e quatro no sentido inverso como `Safely Timed`, sem exceções. Os seis endpoints de entradas externas mantêm os sincronizadores e false paths preexistentes. Total: zero cruzamentos inseguros e zero desconhecidos.

## Recurso físico e formato

Foi criado um avião geométrico com um pequeno marcador de orientação no canto superior esquerdo. Após autorização explícita do usuário para escrita no cartão, somente o novo arquivo `HUDICON.BIN` foi criado pelo sistema de arquivos, sem sobrescrever arquivos, formatar ou escrever setores diretamente. O arquivo foi sincronizado e relido para conferir seu hash. `card-copy.json` registra a operação.

O usuário executou o mapeador somente de leitura com privilégio administrativo e forneceu sua saída. `card-map-verified.json` preserva esses dados e sua origem. A identidade foi conferida pela capacidade, UUID da partição e MBR correspondente à referência da P0.

| Propriedade | Valor |
| --- | --- |
| Cartão | QD101 de 32 GB, confirmado pelo usuário |
| Volume Linux | UUID `3562-6631`, FAT32 |
| Capacidade | 31.914.983.424 bytes |
| Início da partição | LBA 8192 |
| Cluster inicial / setores por cluster | 468463 / 64 |
| Arquivo / tamanho | `HUDICON.BIN` / 512 bytes |
| LBA físico do primeiro setor | **30006080**, hexadecimal **01C9DB40** |
| CRC16 esperado | **408A** |
| SHA-256 BIN | `35d7e7b63d5e2eee79c2e48507878583a068df17bdd40f3a0ee25f30823a1c51` |
| SHA-256 PNG original | `3230f7a0453f9280506269bb8b3c52940c73955883771ffaef82d76d71178344` |

Formato: 64×64, um bit por pixel, sem cabeçalho; linhas de cima para baixo; oito bytes por linha, da esquerda para a direita; bit 7 é o pixel da esquerda. Bit 1 desenha amarelo `12'hFF0`; bit 0 conserva o RGB do HUD. São 804 pixels ligados. O conversor aceita PNG/BMP de exatamente 64×64, com alfa e luminância de pelo menos 128 para o bit 1. Recusa sobrescrever o diretório de saída.

O recurso original está em `assets/hud_aircraft_64.png`. A conversão entregue está em `validation/sd-overlay-20261030T165217Z/bitmap/`. O setor zero contém o MBR e não foi usado como imagem. Não mover, substituir ou recriar `HUDICON.BIN` depois do mapeamento sem descobrir novamente seu LBA e atualizar o build. A FPGA desta versão lê um LBA fixo, sem interpretar FAT32.

## Endereçamento e latência VGA

A imagem ocupa x=540…603 e y=40…103. O endereço lógico é `linha_local*8 + coluna_local/8`, e o índice do bit é `7-coluna_local%8`.

A BRAM tem um estágio de endereço e a saída síncrona. O overlay solicita cada byte dois pixels antes do pixel a desenhar, a partir de x=538. A máscara e o índice do bit acompanham esses dois estágios. A composição usa o RGB original do pixel corrente; HSYNC, VSYNC e vídeo ativo passam diretamente. Não foi inserido atraso global no HUD ou no sincronismo. Posição parametrizada exige X≥2 e a imagem inteiramente dentro de 640×480.

Antes da primeira publicação, todo o HUD permanece visível. Fora do desenho e nos bits transparentes, RGB é exatamente o original. O banco só muda durante blanking vertical, evitando alteração parcial durante o quadro.

## Arquivos da entrega

Reutilizados sem mudança nesta tarefa: `sd_spi_controller.sv`, `sd_spi_read_block.sv`, inicialização/comandos SPI, CRC existente, `sd_diagnostic.sv`, `sd_sector_buffer.sv`, `sd_status_display.sv`, `vga_controller.sv`, instrumentos, sensores, calibração e XDC.

Modificados em relação ao início desta tarefa:

- `rtl/top_reticula.sv`: ligação real do buffer, commit/abort, composição RGB, publicação e páginas A/B.
- `tests/tb_top_sd_integration.sv`: reaproveitamento do modelo de cartão e comparação com top sem overlay, incluindo recuperação e combinações operacionais.
- `scripts/test.sh`: inclusão dos novos bancos de teste e diretório de saída configurável; varredura integrada com Verilator.

Criados:

- `rtl/sd_bitmap_overlay.sv`.
- `scripts/prepare_sd_bitmap.py`, `scripts/read_sd_bitmap_lba.py`, `scripts/build_sd_overlay.tcl`.
- `tests/tb_sd_bitmap_overlay.sv`, `tests/tb_top_sd_overlay.sv`, `tests/test_prepare_sd_bitmap.py`, `tests/hud_aircraft_64.hex`.
- `assets/hud_aircraft_64.png`, este documento e o novo diretório de evidências.

## Verificação funcional

Os **78 bancos de teste da regressão passaram**, com saída zero e marcador final de aprovação. O registro está em `validation/sd-overlay-20261030T165217Z/regression.log`; os resultados individuais e avisos permanecem nele. `converter-test.log` registra a aprovação do teste Python de conversão, orientação, transparência, dimensões e recusa de sobrescrita.

O teste dedicado usa o controlador VGA e a BRAM reais, confere todos os 4096 pixels, os quatro cantos, orientação, bits transparentes, preservação do RGB externo e igualdade de HS/VS/vídeo ativo. O teste integrado instancia o top e o modelo SPI, inicializa o cartão, verifica CMD17 no LBA 30006080, envia o setor e CRC, aguarda publicação no blanking e confere os 804 pixels do ícone. Depois injeta CRC inválido, verifica preservação do banco e recupera com nova leitura válida.

Também verifica quadros completos nas 12 combinações: SOLO/VOO/POUSO × ORIGINAL/CAÇA × NORMAL/DECLUTTER, comparando os pixels transparentes com um top sem overlay. Os bancos existentes de BRAM cobrem recepção incompleta, erro de sequência, abort, reset, troca e recuperação; a regressão existente cobre sensores MPU6050/BMP085/HMC5883L, fusão, joystick, alertas, simuladores e buzzer. Esses resultados são de simulação, sem alegação de nova verificação física dos sensores.

No fim do teste integrado há uma mensagem histórica que menciona LBA0; ela pertence ao texto reaproveitado da P0. O novo wrapper configura explicitamente LBA 30006080, conferido pelo modelo de cartão. As mensagens `PASS top overlay` identificam o novo caminho.

## Síntese, implementação e avisos

Vivado 2026.1, parte `xc7a100tcsg324-1`, projeto completo, place/phys_opt/route concluídos. Relatórios finais em `validation/sd-overlay-20261030T165217Z/implementation-2/`.

| Métrica | P0 física, 400 kHz | Overlay final | Diferença |
| --- | ---: | ---: | ---: |
| LUT | 12892 | 12965 | +73 |
| FF | 7526 | 7641 | +115 |
| RAMB18 | 1 | 2 | +1 |
| RAMB36 | 0 | 0 | 0 |
| DSP | 32 | 32 | 0 |
| BUFG | 2 | 2 | 0 |
| WNS (ns) | +0,316 | **+0,353** | +0,037 |
| WHS (ns) | +0,023 | **+0,023** | 0 |
| TNS / THS (ns) | 0 / 0 | **0 / 0** | 0 |
| Endpoints internos sem restrição | 0 | **0** | 0 |

Nenhum endpoint de setup/hold falhou; nenhum registrador ficou sem clock. O bus skew preexistente de `u_entrada` também foi conferido no checkpoint roteado: 1,520 ns para limite de 10 ns, folga +8,480 ns (`bus_skew.rpt`).

DRC: zero erros. Permanecem os mesmos 55 avisos de pipeline de DSP da P0: DPIP-1=10, DPOP-1=18, DPOP-2=27. Não houve REQP-1840 de controle assíncrono de BRAM.

O log final possui 177 linhas `WARNING`, contra 174 na P0. Há três avisos novos `Synth 8-6901`: `sd_read_busy` e `sd_block_valid` são usados antes de suas declarações no top. Os sinais estão declarados e conectados, e o fluxo foi validado; os avisos não foram suprimidos. As demais categorias têm as mesmas contagens da P0, embora a ordem da síntese possa mudar quais trechos redundantes são listados. `build-warnings.txt` contém todos os avisos; `warnings-comparison.json` conserva a comparação textual.

Permanecem avisos de sinais/registradores sem uso, redução de largura, saída constante SD_DP, arredondamento de uma restrição antiga e recomendação de conferir bus skew. O arredondamento e o XDC preexistentes não foram alterados. Na simulação há avisos existentes de seleções constantes do Icarus e portas não ligadas nos bancos de teste, além de oito avisos de largura no novo overlay: parâmetros inteiros ampliam a aritmética de coordenadas antes da atribuição de 10 bits. Os limites geométricos e a máscara impedem uso de valores fora da imagem; a varredura completa confere o resultado. O log não esconde esses avisos.

`check_timing.rpt` também informa 27 entradas sem input delay (26 com false path preexistente; SD_DAT0 sem delay) e 38 saídas sem output delay. Portanto a aprovação é da STA interna: não certifica margem elétrica externa de SPI, sensores ou outros conectores. A caracterização elétrica anterior continua separada. Não foram inventadas restrições para ocultar essa limitação.

## Reprodução

Na raiz do repositório, usar um diretório de saída que ainda não exista:

```bash
python3 scripts/prepare_sd_bitmap.py assets/hud_aircraft_64.png /tmp/hud-bitmap-novo
TEST_OUT_DIR=/tmp/hud-regressao-nova bash scripts/test.sh
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch \
  -source scripts/build_sd_overlay.tcl \
  -tclargs /tmp/hud-build-novo /tmp/hud-bitmap-novo/HUDICON.hex 30006080
```

O conversor e o build não escrevem no cartão nem programam a placa. A reprodução acima só vale enquanto o arquivo físico continuar no mesmo LBA. Para remapear, o utilitário `read_sd_bitmap_lba.py` abre o dispositivo somente para leitura e verifica MBR, limites FAT32, tamanho e SHA; conferir a identidade atual do dispositivo antes de informar seu caminho.

## Programação e bancada manuais

Bitstream desta entrega:

`validation/sd-overlay-20261030T165217Z/implementation-2/experimental.bit`

SHA-256: `41cea8bb64136553dfc58c62f7e0708badef20de10b137a431930c59b62fa035`.

1. Feche a janela do cartão no gerenciador de arquivos e ejete-o com segurança no Linux. A tentativa automática de desmontagem foi recusada porque o Nautilus mantém o volume ocupado; nenhum processo foi encerrado à força (`card-unmount.json`). Com a Nexys desligada, retire-o do leitor e coloque-o no slot microSD da placa. Preserve as conexões já usadas na P0; não há nova ligação elétrica nesta entrega.
2. Ligue a placa e abra Vivado → Hardware Manager → Open Target → Auto Connect. Selecione o dispositivo `xc7a100t` e **Program Device**, apontando para o arquivo acima. Não escolha programação de memória Flash. O arquivo de debug probes pode ficar vazio; esta licença não permite ILA, por isso a observação usa LEDs e display.
3. Deixe SW8 baixo durante a inicialização e aguarde LD7 acender. Suba SW8 uma vez. LD9 acompanha leitura/publicação pendente; o banco será exibido no próximo blanking vertical após a leitura correta.
4. Espere um avião amarelo 64×64 em (540,40), com pequeno marcador no canto superior esquerdo e HUD visível nos espaços transparentes. LD10 e LD11 devem acender; LD8 deve permanecer apagado. LD9 apaga após concluir a publicação.
5. Selecione as páginas pelo valor binário de SW7…SW4 e confira a tabela abaixo. As páginas são valores hexadecimais nos oito dígitos.
6. Repita duas vezes: SW8 baixo por pelo menos 20 ms e depois alto. O ícone anterior deve permanecer estável durante a leitura; página B deve avançar a cada publicação. Confira também os modos de operação, estilo e declutter no monitor, joystick, sensores, alertas e buzzer conforme a rotina já utilizada.

| Página / SW7…SW4 | Esperado após a primeira leitura/publicação |
| --- | --- |
| 1 / 0001 | `00FE0200`: R1, token e 512 bytes |
| 2 / 0010 | **`408A408A`**: CRC recebido/calculado |
| 8 / 1000 | **`01C9DB40`**: LBA |
| 9 / 1001 | `00000001`: referência presente |
| A / 1010 | **`00000003`**: buffer disponível e publicação confirmada |
| B / 1011 | `00000001`: uma publicação; aumenta nas repetições |

Se CRC, comparação ou leitura falharem, não aprovar a validação física: registrar LED de erro, página 0, páginas 1/2/3 e contadores. O banco anterior continua visível até uma nova leitura válida. A versão fornecida não foi gravada automaticamente na FPGA e nenhuma Flash foi escrita.

## Estado da entrega e pendências

| Evidência | Estado |
| --- | --- |
| P0, três leituras reais e CRC 5DC5 | Validada fisicamente em registro anterior |
| Ícone copiado ao QD101 e setor físico conferido no Linux | Concluído, SHA e CRC 408A confirmados |
| SPI → CRC → BRAM → CDC → VGA no top | Simulado com modelo de cartão |
| Projeto completo / BRAM real / STA / CDC / DRC | Sintetizado e implementado |
| Bitstream experimental desta integração | Gerado e preservado em novo diretório |
| Programação da integração na Nexys | Pendente, manual |
| Ícone lido pela FPGA e observado no monitor | Pendente, validação física |
| Margem elétrica externa SPI | Não certificada por esta STA |

A ação indispensável restante é executar a bancada manual acima e registrar o ícone, LEDs, CRC, publicação e modos. Nenhum resultado simulado foi tratado como leitura física do ícone pela FPGA.
