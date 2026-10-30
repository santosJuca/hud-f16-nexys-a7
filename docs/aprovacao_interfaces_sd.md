# HUD SD: correções de configuração e cobertura de I/O em 30/10/2026

**Publicação bloqueada pelo modelo temporal externo do microSD.** Foram corrigidos a tensão de configuração, os seis retornos assíncronos I²C e a cobertura digital das saídas VGA. Nenhum RTL foi alterado. Não foram gerados bitstream ou imagem Flash, feitos push/tag/Release ou acessos a hardware.

## Correções e método de validação

Arquivo alterado: `constraints/nexys_a7_reticula.xdc`, consumido pelos scripts existentes de build e implementação.

- `CFGBVS=VCCO` e `CONFIG_VOLTAGE=3.3`: o esquemático Digilent 500-292, Nexys A7 D.0, folha 8, liga CFGBVS_0/P8 a VCC3V3; a folha 10 liga VCCO_0/R9 à mesma alimentação. Não se trata da identificação da memória Flash.
- Seis `set_false_path` de SDA/SCL ao pino D do primeiro estágio do respectivo sincronizador. O fanout de cada entrada foi conferido na netlist: exatamente esse endpoint. Os 12 registradores mantêm `ASYNC_REG=1`; os seis caminhos entre primeiro e segundo estágio continuam analisados em setup e hold. Não há exceção global de I²C ou de clocks.
- VGA: `set_max_delay -datapath_only 40` dos registradores de dados até os 14 pads VGA. O divisor que origina o clock de pixel fica fora dessa seleção para preservar a árvore de clock. É um requisito de assentamento digital em um período de pixel; não é um setup/hold inventado de monitor.
- Os registradores publicados de `u_dados` têm uma exceção específica de assentamento durante blanking, incluindo réplicas físicas. `top_reticula.sv` só aciona `atualizar_quadro` em x=0,y=480; `dados_hud.sv` só publica os dados nessa condição. Após a atualização restam `(45*800-1)*40 = 1.439.960 ns` antes do vídeo ativo. Os registradores `*_pendente*` não pertencem à seleção. Não foi aplicada exceção aos contadores de raster nem aos caminhos internos entre registradores.

A netlist roteada original foi preservada e reaberta no Vivado 2026.1 build 6511674. Os hashes de suas entradas foram conferidos antes da alteração. Como somente constraints mudaram, foi executado `reset_timing`, seguido da leitura integral do XDC atual e nova análise do mesmo roteamento. Não foi necessário repetir síntese/place/route para validar estas mudanças. O checkpoint resultante continua explicitamente **não aprovado** para publicação por falta dos parâmetros externos SPI.

Evidência válida desta revisão: `validation/signoff-20261030-config-io/verified/`. O diretório contém os scripts Tcl usados, checkpoint reanalisado, timing, DRC, metodologia, clock interaction, exceções/cobertura, CDC, bus skew, utilização, pinagem e relatórios de caminhos SPI/VGA/I²C. As tentativas intermediárias foram preservadas. A primeira formulação VGA omitia o startpoint exigido pelo Vivado; uma seleção posterior incluía o gerador de clock e omitia réplicas. Essas seleções foram corrigidas antes da validação válida; os resultados intermediários não são aprovação.

## Resultados pós-route reanalisados

| Item | Resultado |
|---|---:|
| WNS / TNS | +0,337 ns / 0 ns |
| WHS / THS | +0,015 ns / 0 ns |
| WPWS / TPWS | +4,020 ns / 0 ns |
| Endpoints internos essenciais sem restrição | 0 |
| Setup mínimo entre estágios I²C | +8,804 ns |
| Hold mínimo entre estágios I²C | +0,160 ns |
| VGA: menor margem de assentamento por pixel | +1,209 ns |
| VGA: pior caminho de raster até pad | 38,791 ns, limite 40 ns |
| LUTs / registradores / DSPs | 12.774 / 7.275 / 32 |
| BRAM / BUFG | 0 / 2 |
| DRC | 0 erros; 55 avisos de pipeline DSP |
| CFGBVS-1 | Resolvido |
| CDC | 24 informações CDC-3; 112 avisos CDC-15 |
| Skew bundled-data / limite | 1,414 ns / 10 ns |

O hold interno de 15 ps e o assentamento VGA de 1,209 ns têm pouca folga. São resultados desse roteamento e modelos PVT do Vivado; não autorizam transportar a aprovação para outra implementação ou ampliar incertezas sem reanálise. A interface analógica VGA e a montagem dos sensores não foram ensaiadas nesta execução.

Os 112 CDC-15 continuam associados ao barramento retido, capturado após sincronização do pedido, com backpressure até o retorno da confirmação. Max-delay de 20 ns e bus-skew de 10 ns continuam ativos. Os quatro registradores de controle mantêm ASYNC_REG. Os seis novos tratamentos de entradas I²C acrescentam seis informações CDC-3. Não foram escondidos avisos nem reduzidas severidades.

## Classificação completa dos I/Os sinalizados

As sete entradas originalmente sem input delay eram MISO e seis retornos I²C. Após a correção, resta **uma entrada indeterminada: SD_DAT0**. As 16 entradas manuais já tratadas somam-se às seis I²C: 22 entradas assíncronas com exceções específicas.

Das 35 saídas originalmente sem output delay, 14 VGA agora possuem max-delay efetivo. Restam 21 avisos: dez LEDs, buzzer, seis I²C e quatro controles SD. O número de avisos não é um critério de aprovação isolado.

| Interface e pinos | Natureza, registradores e tratamento | Estado |
|---|---|---|
| VGA RGB: A3/B4/C5/A4, C6/A5/B6/A6, B7/C7/D7/D8; HS/VS B11/B12 | Rede resistiva analógica e sincronismos, sem pixel clock encaminhado. Contadores `u_vga/h_cont_reg*`, `v_cont_reg*`, dados de quadro `u_dados/*_reg` e lógica de desenho. Max-delay com janelas de pixel/blanking; os 14 endpoints têm slack finito positivo. Não há requisito convencional de hold em receptor com clock comum. | Orçamento digital FPGA→pad restringido e atendido; características analógicas externas não medidas. |
| MPU6050: SDA G4, SCL H2 | I²C open-drain. `u_sensor/{sda,scl}_sync_reg[0:1]`; drive por `sda_low`/`scl_low`. Exceções somente no primeiro D; segundo estágio temporizado. | Entrada assíncrona tratada; saída regida pelo protocolo, sem output delay de 100 MHz fictício. |
| BMP085: SDA H4, SCL H1 | Mesmo tratamento, em `u_baro`. | Entrada assíncrona tratada; saída open-drain. |
| HMC5883L: SDA G1, SCL G2 | Mesmo tratamento, em `u_magnetometro`; calibração preservada. | Entrada assíncrona tratada; saída open-drain. |
| Joystick analógico: A13/A14, A15/A16 | VAUX3/VAUX10 do XADC, `u_joystick_xadc/u_xadc`. Entrada analógica; não é input delay digital. DRP/DCLK e registradores digitais continuam na STA. | Não aplicável a delays digitais nos pads. Limite unipolar de 0–1 V e montagem física continuam requisitos de uso. |
| Botão do joystick JA1/C17; demais botões/switches e SW8/T8 | Contatos assíncronos; sincronizadores/debounce existentes. Exceções anteriores até o primeiro estágio preservadas. SW8 solicita leitura, não clocka registradores. | Assíncronos tratados. |
| Buzzer JC10/E6 | Saída de estado/contador em `g_operacao.u_operacao/u_buzzer`; não há receptor externo síncrono. | Output delay convencional não aplicável. Sem falsa exceção para esconder lógica interna. |
| Dez LEDs: H17/K15/J13/N14, R18/V17/U17, U16/V16/T15 | Diagnóstico visual, sem captura externa síncrona. | Output delay convencional não aplicável. |
| microSD MISO C2; SCK B1; MOSI C1; CS D2 | SPI modo 0, gerado por enables do clock de 100 MHz; ver análise abaixo. | **Setup/hold externos indeterminados. Bloqueia publicação.** |
| SD_RESET E2 | Habilitação de alimentação do slot ativa em zero; gerada pelo preâmbulo e espera de power-up. Não é reset SPI convencional. | Caminho de drive identificado; sem assumir tempo de subida de alimentação não documentado. |
| SD_CD A1 | Detecção não consumida pelo RTL; netlist tem zero endpoints funcionais. | Não requer input delay; não há aprovação de hot-plug. |

O mapa por porta e o registrador físico correspondente estão em `io.rpt`, `synchronizer-coverage.txt` e `coverage-check.txt`. Os retornos I²C são amostrados continuamente a 100 MHz por dois estágios; o protocolo usa fases de 2,5 µs e espera a observação de SCL alto. Isso não transforma o pad em entrada síncrona a 100 MHz. Os requisitos elétricos de pull-ups, carga e rise/fall continuam sendo de um barramento I²C compatível com os sensores, não são comprovados por STA interna. Não houve energização ou mudança de montagem.

## SPI: origem, flancos e cobertura faltante

`sd_spi_command` e `sd_spi_read_block` usam `HALF_PERIOD_CYCLES=125`: SCK baixo em idle, semiciclo de 1.250 ns, período de 2.500 ns, 400 kHz. MOSI é atualizado na descida; a primeira posição é preparada antes da primeira subida. MISO é usado no mesmo posedge de 100 MHz que agenda a subida de SCK. Portanto a captura interna antecede a chegada dessa subida ao cartão pelo atraso FPGA→pad→placa. O orçamento de leitura deve partir da **descida anterior** que provoca a mudança de MISO no cartão, não de um clock de 100 MHz externo inventado.

SCK, MOSI e CS são multiplexados entre preâmbulo/comando e leitura por `read_owner` e pelo estado do preâmbulo. O começo e a fase dessas transações dependem da FSM. Declarar somente `create_generated_clock -divide_by 250` não demonstra essas relações, o gating de captura ou os transientes de troca de proprietário. O preâmbulo e as duas engines devem fazer parte do modelo, incluindo os pinos CE dependentes de MISO.

Endpoints reais de MISO incluem `init/command/r1_reg*`, `extra_reg*`, `finish_pending_reg`, `read_block/rx_shift_reg*`, `state_reg*`, `rx_bit_reg*` e CE de contadores/CRC. Foram reportados 126 endpoints max e 126 min no roteamento. Não é uma entrada exclusivamente em um shift register; restringir só esse registrador deixaria controles sem cobertura.

Startpoints das saídas, sob `g_sd.u_sd_spi_controller`:

- SCK: `init/preamble/sd_sck_reg`, `init/command/sck_reg`, `read_block/sd_sck_reg`, seleção `read_owner_reg` e `init/preamble/ready_reg`.
- MOSI: `init/command/mosi_reg`, `read_block/sd_mosi_reg` e seletores.
- CS: `init/command/cs_n_reg`, `read_block/sd_cs_n_reg` e seletores.
- Alimentação: `init/preamble/sd_reset_reg`.

Os relatórios de caminhos físicos fornecem máximos de 12,514 ns em MISO e 11,485 ns no caminho de dados que gera SCK; MOSI/CS têm máximos de 10,939/10,880 ns. Esses números não incluem os parâmetros externos ausentes e não são margens de setup/hold. Os caminhos SPI continuam com slack infinito; isso está registrado como **não aprovado**.

Para fechar o modelo, são necessários limites aplicáveis de:

1. `tCO_min/max` do cartão (flanco de lançamento de MISO, tensão, carga e temperatura pertinentes).
2. Setup/hold de MOSI e CS no cartão, e limites de largura de pulso/transition de SCK.
3. Atrasos mínimo/máximo FPGA-pad→cartão para SCK/MOSI/CS e cartão→FPGA-pad para MISO; carga elétrica que torna válidos os limites de datasheet. O esquemático identifica as conexões, mas não fornece comprimentos/stackup/limites de propagação e assentamento do enlace.

O modelo do microSD não foi localizado no repositório e foi solicitado ao usuário. A especificação pública **SD Physical Layer Simplified 9.10** foi obtida diretamente da SD Association e conferida: os valores de timing de 6.6.6, 7.5/7.5.4 são omitidos. A seção 7.8 remete ao timing do modo SD, incluindo CS; não fornece os números omitidos. Não se usaram tabelas de um cartão de outro fabricante nem cópias secundárias para preencher os valores.

O fechamento deverá comparar o round-trip máximo `SCK_FPGA + SCK_placa + tCO_cartao + MISO_placa + MISO_FPGA + setup + incertezas`, com diferenças de latência de lançamento/captura, ao semiciclo real de 1.250 ns. O hold deve considerar a próxima alteração de MISO, os mínimos e o flanco efetivo de captura. MOSI/CS precisam de análise análoga entre seus flancos e SCK no cartão. Sem esses parâmetros não se pode assinar setup/hold externo, mesmo com a frequência baixa.

## Testes, integridade e Git

Nesta revisão passaram dois testbenches dirigidos existentes: `tb_dados_hud` (captura de quadro, retenção e coincidência) e `tb_entrada_hud` (16 palavras atômicas de 128 bits). Ambos terminaram com código zero. A validação Tcl confere fanout/ASYNC_REG/setup/hold dos seis sincronizadores e cobertura finita positiva dos 14 pads VGA. Não houve alteração de RTL, calibração ou parâmetros do subsistema SD.

A regressão anterior permanece a evidência funcional do RTL: 73 testbenches, 256 linhas PASS, zero FATAL, código zero. Não foi repetida uma regressão completa nem uma implementação final, pois não existe ainda uma configuração SPI externamente aprovada. A regressão completa exigida para a entrega será executada quando houver o modelo final para revalidar; não é anunciada como executada nesta revisão.

Os commits originais 446406e, be2c381 e 26f461d e o snapshot recuperável foram preservados. As correções novas ficam em commits locais. Nenhum commit foi enviado. O manifesto novo distingue commit dos fontes, revisão das constraints e origem do checkpoint; contém aprovação falsa e artefatos de bitstream/Flash nulos. `SHA256SUMS` cobre as evidências novas; o manifesto anterior não foi sobrescrito. `git diff --check` e a inspeção dos arquivos a versionar não identificaram problemas de whitespace ou segredos.

## Artefatos e publicação

- Relatório: `docs/aprovacao_interfaces_sd.md`.
- Manifesto e checksums: `validation/signoff-20261030-config-io/manifest.json` e `SHA256SUMS`.
- Bitstream, checksum de bitstream, tag e URL de Release: **inexistentes nesta revisão**.
- O repositório `santosJuca/Trabalho-display-aviao-v2` já possui Releases; essa é a convenção apropriada após aprovação. Não houve publicação provisória nem substituição por um bitstream histórico.
- Identificação/backup/gravação de Flash ficam para etapa futura e **não são bloqueadores da publicação do .bit**. Não houve Hardware Manager, JTAG ou programação.

A ação mínima pendente é obter um perfil temporal aplicável ao microSD identificado e limites verificáveis do enlace físico, preencher o modelo SPI, conferir cobertura de todos os endpoints/seletores e revalidar. Depois cabem regressão final, geração do .bit, manifesto ligado ao commit, Release e conferência do SHA-256 do asset remoto. A aprovação não pode ser emitida antes disso.

## Fontes primárias

- [Esquemático Digilent Nexys A7 D.0, 500-292](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7-sch.pdf), folhas 3 (VGA/SD), 8 (CFGBVS), 10 (VCCO).
- [Manual oficial Nexys A7](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf).
- [Master XDC Nexys A7-100T oficial](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-100T-Master.xdc).
- [SD Association: especificações simplificadas](https://www.sdcard.org/downloads/pls/), Physical Layer 9.10. PDF consultado preservado localmente: SHA-256 `ee86b20ec02b30797f14ceaf9f760feadb321de12cceb278b917aab7a65380e3`.
- [AMD UG903 2026.1: Input Delay](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Input-Delay).
- [AMD UG906 2026.1: Check Timing Section](https://docs.amd.com/r/en-US/ug906-vivado-design-analysis/Check-Timing-Section).
- [AMD UG899: configuração de CFGBVS](https://docs.amd.com/r/en-US/ug899-vivado-io-clock-planning/Setting-the-Configuration-Bank-Voltage-Select-Pin).
