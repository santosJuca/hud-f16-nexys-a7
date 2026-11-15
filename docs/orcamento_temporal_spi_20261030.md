# Orçamento temporal SPI do HUD Nexys A7-100T

Data: 30/10/2026. **APROVAÇÃO NEGADA: orçamento externo ainda indeterminado.**

A arquitetura e os atrasos internos foram confirmados. Não há, nas fontes públicas consultadas, limites AC garantidos aplicáveis ao WD Purple SC QD101 identificado. Também faltam limites do enlace físico. Não é tecnicamente possível fechar margens numéricas de setup/hold nem aplicar delays externos defensáveis com os dados disponíveis. Este documento entrega as equações, parcelas calculadas, evidências e o procedimento necessário para eliminar esses bloqueios. Não declara fechamento obtido.

## Base preservada e escopo

- Repositório `santosJuca/Trabalho-display-aviao-v2`, checkout `/home/santojuca/Downloads/Trabalho-display-aviao-v2-video-sd`, branch `feat/video-sd-overlay`, HEAD `0271499a8538135abc6291e512b421382337c7c2`; árvore limpa no início.
- Backup integral dos arquivos versionados: `/home/santojuca/Downloads/spi-preservation-0271499-20261030.tar`. Conteúdo de cada arquivo conferido contra SHA-256; catálogo em `validation/spi-budget-20261030/preservation.json`.
- Nenhum arquivo preexistente foi modificado. RTL, XDC, calibração, manifestos e evidências anteriores permanecem intactos. Sem commit, push, merge, Release, JTAG, Flash ou bitstream novo.
- Os hashes de todos os fontes listados em `validation/signoff-20261030-config-io/sources-sha256.json` coincidem com o checkout atual. Isso permite reutilizar o checkpoint roteado anterior, com a cadeia de proveniência do manifesto anterior, sem atribuir sua síntese ao commit atual.
- O manifesto antigo antecede a identificação comercial do cartão e ainda contém texto de bloqueio por modelo desconhecido. Não foi reescrito: o modelo comercial agora é conhecido; revisão e garantias AC continuam pendentes.

## Fontes primárias e limites da consulta

| Ref. | Documento, fabricante, revisão e localização | Uso e limite |
|---|---|---|
| F1 | [WD Purple SC QD101 Product Brief](https://documents.sandisk.com/content/dam/asset-library/en_us/assets/public/western-digital/product/embedded-flash/surveillance-wd-purple-microSD/product-brief-wd-purple-sc-qd101-ultra-endurance-microsd.pdf), Western Digital, 02-05-WW-04-00176-A03, dez/2020, pp. 1–2 | Modelo, temperatura, SDA 6.0; sem tabela AC SPI. Cópia anterior em `validation/card-identification-20261030/qd101-product-brief.pdf`. |
| F2 | [Physical Layer Simplified Specification](https://www.sdcard.org/downloads/pls/), SD Association, 9.10, 01/12/2023, §§6.6.5–6.6.7, 7.5.4, 7.6–7.8; páginas impressas 280–282 e 309 | Omissão das tabelas elétricas/temporais; §7.8 relaciona timing SPI ao SD e inclui CS. Não prova conformidade deste exemplar com revisão 9.10. PDF anterior em `validation/signoff-20261030-config-io/sd-physical-9.10.pdf`. |
| F3 | [Nexys A7 Schematic](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7-sch.pdf), Digilent 500-292, D.0, 24/07/2018 | Consulta online e inspeção visual da cópia local D.0, arquivada em `validation/spi-budget-20261030/nexys-a7-D0-local-reference.pdf`. Folhas impressas 2 (7 SEG, VGA, SD), 4 (USB HID), 7 (FPGA BANKS), 10 (FPGA POWER). O download direto atual recebeu HTTP 403; não se afirma igualdade binária entre cópia local e PDF online. |
| F4 | [Nexys A7 Reference Manual](https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf), Digilent, 10/07/2019, §11 | Alimentação ativa em zero e entrega do barramento pelo microcontrolador após configuração. |
| F5 | [Nexys-A7-100T-Master.xdc](https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-100T-Master.xdc), Digilent, branch master consultada em 30/10/2026, seção MicroSD | Referência de pinagem; linhas comentadas não são constraints ativas. |
| F6 | [Artix 7 DC and AC Switching Characteristics, DS181](https://docs.amd.com/v/u/en-US/ds181_Artix_7_Data_Sheet), AMD, v1.27.1, 03/07/2024, tabelas 3, 9 e 20, pp. 3, 9, 21 | Limites FPGA e referência de medição de atraso de I/O. |
| F7 | [7 Series SelectIO, UG471](https://docs.amd.com/v/u/en-US/ug471_7Series_SelectIO), AMD/Xilinx, v1.10, 08/05/2018, p. 48 | DRIVE e SLEW; defaults não equivalem a validação de carga. |
| F8 | [UG903 Input Delay](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Input-Delay), [Output Delay](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Output-Delay), [Generated Clocks](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints/Generated-Clocks), AMD, 2026.1, 01/07/2026 | Semântica dos delays relativos a bordas e clocks derivados. |

A consulta adicional aos domínios Western Digital/SanDisk não localizou datasheet AC SPI do SC QD101. Resultados de outras famílias (por exemplo CL QD101) não foram transferidos para este cartão. “NÃO DOCUMENTADO PUBLICAMENTE” abaixo significa não encontrado nas fontes primárias consultadas, não prova de inexistência de documentação sob NDA.

## Identificação física e elétrica

Cartão informado: WD Purple SC QD101, 32 GB, microSDHC, UHS-I, U1/Class 10; catálogo WDD032G1P0C (F1). Código completo, revisão, lote/CID e exemplar não foram inspecionados fisicamente. A revisão da placa montada também não foi confirmada; D.0 é a referência documental.

Mapa conferido no esquema local, Master XDC e XDC ativo, linhas 22–27:

| Porta | FPGA | J1 | Função |
|---|---|---|---|
| SD_RESET | E2 | alimentação via Q8 | Habilitação ativa em zero |
| SD_SCK | B1 | 5 | Clock |
| SD_CMD | C1 | 3 | MOSI |
| SD_DAT0 | C2 | 7 | MISO |
| SD_DAT3 | D2 | 2 | CS baixo |
| SD_CD | A1 | contato CD | Não consumido pelo RTL |

Em F3, banco 35 e alimentação nominal de 3,3 V. Q8 chaveia VDD; C191=100 nF; R118/R121=10 kΩ; R124=100 Ω pertence à detecção. R251/R252/R266/R267/R268=100 kΩ puxam DAT3/DAT1/CMD/DAT2/DAT0 para VDD comutado. D11/D12 protegem as linhas. Não há resistor série discreto no caminho direto FPGA–slot. R154/R155/R157/R158=49,9 Ω ficam nos ramos PIC24 de SCK/DAT0/CMD/DAT3. Comprimentos, impedâncias e capacitâncias ESD não constam dessa folha. Correção documental: na cópia local D.0, o slot está na folha 2, não na 3 citada no relatório anterior.

O PIC24 deixa o barramento após configuração segundo F4; seus ramos continuam cargas elétricas. Estado de alta impedância, alimentação e ausência de contenção não foram medidos.

O checkpoint confirma LVCMOS33; SCK/MOSI/CS/RESET usam DRIVE=12 e SLEW=SLOW, herdados dos defaults (F7), não declarados explicitamente no XDC. Não há justificativa para mudar drive/slew ou adicionar carga fictícia.

## Parâmetros disponíveis

ND = **NÃO DOCUMENTADO PUBLICAMENTE** para o SC QD101/revisão nas fontes consultadas. Traço indica valor não aplicável ou não determinado, nunca zero.

| Parâmetro | Mínimo | Máximo | Unidade | Condições | Fonte |
|---|---:|---:|---|---|---|
| Frequência SCK garantida do cartão em SPI | ND | ND | Hz | Revisão, VDD, temperatura e carga a confirmar | F1; tabelas omitidas em F2 |
| tCO MISO, inclusive primeiro bit e liberação | ND | ND | ns | Flanco de lançamento e níveis de referência a confirmar | F1/F2 |
| Setup MOSI / CS | ND | ND | ns | Em relação ao flanco de captura do cartão | F1/F2 |
| Hold MOSI / CS | ND | ND | ns | Mesmo perfil AC | F1/F2 |
| Larguras high/low de SCK exigidas | ND | ND | ns | Duty cycle no receptor | F1/F2 |
| Rise/fall permitidos de SCK/MOSI/CS | ND | ND | ns | Limiares e carga ausentes | F1/F2 |
| Rise/fall de MISO, carga e capacitância do cartão | ND | ND | ns / pF | Condições do tCO ausentes | F1/F2 |
| VDD operacional específico do SC QD101 | ND | ND | V | Brief não informa; não importar de CL QD101 | F1 |
| VIH/VIL/VOH/VOL do cartão em SPI | ND | ND | V | Margens DC de ambas as direções ainda abertas | F1/F2 |
| Temperatura operacional do cartão | -25 | 85 | °C | Temperatura de carcaça, nota 5; não qualifica a placa nessa faixa | F1 p. 2 |
| VDD nominal da placa/slot ligado | — | 3,3 nominal | V | Valor de projeto, não medição nem limite min/max | F3/F4 |
| Entrada FPGA LVCMOS33: VIL / VIH | — / 2,0 | 0,8 / — | V | Limites lógicos; demais condições e limites de tensão em DS181 | F6 tabela 9 |
| Saída FPGA LVCMOS33: VOL / VOH | — / VCCO−0,4 | 0,4 / — | V | Corrente conforme drive, notas da tabela; não é tensão medida | F6 tabela 9 |
| Capacitância de entrada no die FPGA | — | 8 | pF | Não inclui todo o enlace; aplicar nota 2 da tabela | F6 tabela 3 |
| Tsys nominal | 10 | 10 | ns | Clock constrained de 100 MHz, não tolerância do oscilador | RTL/XDC |
| Semiciclo H nominal | 1.250 | 1.250 | ns | 125 ciclos de sistema | RTL |
| Período SCK nominal | 2.500 | 2.500 | ns | Sem pausas de FSM | RTL |
| SCK inicialização / leitura nominal | 400.000 | 400.000 | Hz | Configuração C, ambas divisões 125 | RTL/manifesto/teste |

Não se inferem frequência SPI, tCO ou setup/hold a partir de UHS-I, U1 ou Class 10. Não se adotam valores usuais de outros cartões (25 MHz, 14 ns etc.). O clock de 400 kHz é comportamento comprovado do host, não comprovação do limite do cartão.

## Arquitetura e instante de captura

Cadeia ativa: `top_reticula.g_sd.u_sd_spi_controller` → `init` → `preamble`/`command`, e `read_block`. O top conecta `.clk(clk)`; VGA a 25 MHz não alimenta o SPI. `sd_spi_cmd0` é módulo legado sem instância no RTL ativo. O default isolado de `sd_spi_read_block` é 2, mas a instância recebe 125. Overrides de benchmark não são configuração de produção.

A configuração C habilita `ENABLE_SD_SUBSYSTEM=1`; o default do top é zero e mantém SD desligado. Não confundir configuração C auditada com executar o build genérico sem habilitação SD.

- CPOL=0, CPHA=0: idle baixo; primeiro MOSI preparado junto da ativação de CS; demais bits mudam quando SCK é comandado baixo.
- `divider == HALF_PERIOD_CYCLES-1` alterna SCK. H=125×10=1.250 ns; f=100 MHz/(2×125)=400 kHz. Não há aceleração após init nos parâmetros atuais.
- Em `command` e `read_block`, MISO é lido no `posedge clk` que executa `sck <= 1`. Não existe sincronizador MISO de dois estágios nem clock SCK nos registradores receptores.
- A atribuição não bloqueante faz o dado ser capturado antes de SCK↑ aparecer no pad. A janela de leitura começa em SCK↓ anterior, sob a hipótese de lançamento do cartão na descida que precisa constar do perfil aplicável.
- Comando: IDLE/TX/WAIT_R1/READ_R1/READ_R7/TRAIL. Leitura: comando, R1, token, dados, CRC e terminação; MISO alimenta dados e decisões. A netlist tem 126 endpoints distintos, inclusive D e CE. Constranger apenas `rx_shift` deixaria controle exposto.
- O preâmbulo espera 200.000 ciclos (aproximadamente 2 ms após habilitação) e gera 80 pulsos (200 µs nominais). Isso não prova que VDD já assentou pelo tempo mínimo exigido pelo cartão.
- `pre_ready` e `read_owner` multiplexam as engines. Handoffs, primeiro/último bit, timeout, CS e reset precisam ser tratados separadamente do trecho periódico. Simulação lógica não exclui pulsos espúrios físicos.

## Orçamento calculado, sem preencher lacunas

Todas as grandezas abaixo estão em ns. `D_X` é atraso FPGA entre C do registrador de saída e pad; `D_I` é pad MISO até D/CE receptor; `L_X` é latência de clock até o registrador. `B_X` representa o atraso externo, incluindo assentamento/limiar e ajuste da carga real em relação à referência do modelo. Não somar duas vezes correção IBIS já incluída em B. `SU`, `HD` são setup/hold do receptor; `U` inclui incerteza relativa, medição e variações ainda não absorvidas pelos extremos. `CO` é tCO do cartão. Selecionar extremos coerentes com direção de transição e corner na validação final.

Para o bit periódico, lançamento interno em t=0, captura de MISO em t=H+L_RX, SCK↑ no cartão em t=H+L_S+D_S↑+B_S↑. Próximo lançamento MISO pelo cartão corresponde à descida comandada em t=2H. A validade não deve ser medida apenas contra SCK↑ externo, pois a captura FPGA o antecede.

### MOSI e CS

Para MOSI, `M` identifica a saída e `S` SCK:

```text
margem_setup_M = H + (L_S,min − L_M,max)
                + D_S↑,min + B_S↑,min
                − D_M,max − B_M,max − SU_card − U_setup

margem_hold_M  = H + (L_M,min − L_S,max)
                + D_M,min + B_M,min
                − D_S↑,max − B_S↑,max − HD_card − U_hold
```

Usar as mesmas equações para CS quando a transição correspondente fica a H da captura. Primeiro bit/ativação de CS têm H nominal desde start. Liberação de CS, reset e troca de engine exigem conferir os eventos reais; não supor um dado periódico nesses estados. Para pulsos: `tWH_card = H + (L_S↓−L_S↑) + (D_S↓−D_S↑) + (B_S↓−B_S↑)`; expressão análoga para low. Comparar mínimos com requisitos do cartão, descontando U.

### MISO: ida e volta

```text
margem_setup_I = H + (L_RX,min − L_S,max)
                − D_S↓,max − B_S↓,max − CO_max − B_I,max
                − D_I,max − SU_RX − U_setup

margem_hold_I  = H + (L_S,min − L_RX,max)
                + D_S↓,min + B_S↓,min + CO_min + B_I,min
                + D_I,min − HD_RX − U_hold
```

O hold usa a próxima descida, H depois da captura; a primeira resposta, tri-state e desativação de CS podem ter regras próprias. SU_RX/HD_RX devem ser extraídos do timing model para cada D/CE e corner, não substituídos por um número genérico do FPGA. O caminho até CE também exige estabilidade; a prova de habilitação deve abranger todos os endpoints, não somente dados.

### Parcelas obtidas do checkpoint

Extração nova no Vivado 2026.1 build 6511674, Speed File -1 PRODUCTION 1.23, netlist roteada preservada. Valores são atrasos do modelo atual; não medidas físicas, não margens e não caracterização da carga externa.

| Caminho | Menor atraso min | Maior atraso max | Relatórios novos |
|---|---:|---:|---|
| C de fontes/seletores de SCK → pad | 3,722 | 11,485 | SD_SCK_min/max.rpt |
| C de fontes/seletores de MOSI → pad | 3,995 | 10,939 | SD_CMD_min/max.rpt |
| C de fontes/seletores de CS → pad | 3,953 | 10,880 | SD_DAT3_min/max.rpt |
| MISO pad → D/CE | 2,746 | 12,514 | miso_min/max.rpt |
| C de SD_RESET → pad | 3,437 | 9,350 | SD_RESET_min/max.rpt |

Substituindo somente H e essas parcelas (envelope preliminar, extremos podem ser de caminhos/corners distintos):

| Expressão parcial | Cálculo | Parcela conhecida |
|---|---|---:|
| Setup MISO | 1.250 − 11,485 − 12,514 | 1.226,001 ns |
| Hold MISO | 1.250 + 3,722 + 2,746 | 1.256,468 ns |
| Setup MOSI | 1.250 + 3,722 − 10,939 | 1.242,783 ns |
| Hold MOSI | 1.250 + 3,995 − 11,485 | 1.242,510 ns |
| Setup CS | 1.250 + 3,722 − 10,880 | 1.242,842 ns |
| Hold CS | 1.250 + 3,953 − 11,485 | 1.242,468 ns |

Por exemplo, a condição necessária a verificar para setup MISO é:

`B_S,max + CO_max + B_I,max + SU_RX + U_setup + L_S,max − L_RX,min ≤ 1.226,001 ns`.

Não se assumiu que as parcelas faltantes valem zero. As seis margens finais são **INDETERMINADAS**. Os relatórios incluem latências de clock completas; a diferença não deve ser descartada nem contabilizada duas vezes. A incerteza de 0,025 ns exibida nos relatórios antigos é do modelo atual do Vivado (TSJ=0,050 ns), não um orçamento medido de oscilador/placa/cartão. A tolerância do oscilador deve limitar H_min, hoje nominal.

## Integridade elétrica e medições necessárias

`C_total = C_slot + C_trilhas + C_ESD + C_card + C_ramo_PIC + C_FPGA + C_sonda`, com carga efetiva dependente da frequência e dos ramos. Não existe valor total comprovado. Para trecho RC concentrado, `t10–90 ≈ 2,2 R_eq C_total`; com pull-up de 100 kΩ, isso equivale a **220 ns por pF**, sem atribuir C_total. Essa equação serve para a recuperação quando ninguém dirige a linha; não modela a borda push-pull nem reflexões do enlace.

A soma 49,9 Ω×C não é modelo do caminho direto: esses resistores pertencem aos ramos PIC24. Usar IBIS/topologia real quando houver layout e modelos. A metodologia de F6 usa uma carga de referência para atrasos de saída, não a carga medida deste slot. A margem DC é `VOH_tx,min−VIH_rx,min` e `VIL_rx,max−VOL_tx,max`; faltam os limites do cartão e a queda/ripple de VDD para avaliá-la nas duas direções.

### Procedimento executável de caracterização (ainda não executado)

1. Registrar revisão serigrafada da placa, código completo/lote/revisão do cartão e, quando obtido legitimamente, CID. Definir faixa ambiental de uso; não aplicar automaticamente −25…85 °C à placa inteira. Confirmar perfil AC do cartão, limites da placa, instrumentos e sondas disponíveis antes do ensaio.
2. Com placa desligada, localizar J1. Medir posteriormente SCK=5, MOSI=3, MISO=7, CS=2, VDD=4 contra VSS=6. Identificar contato pelo esquema e continuidade desenergizada; não inferir pela orientação visual do conector. Usar pontos acessíveis equivalentes das redes, microposicionador e proteção contra curto. Não tocar BGA nem modificar placa. Não conectar terra de bancada a sinal; confirmar terra comum e caminho de alimentação, evitando backfeed.
3. Osciloscópio de quatro canais, inicialmente ≥500 MHz e ≥2,5 GSa/s por canal ativo; sondas ativas de baixa capacitância (meta ≤1 pF), retorno curto, tensão admissível adequada. Esses são critérios de instrumentação propostos, não valores do cartão. Verificar `t_r,instrumento ≤ t_r,sinal/3`, usando aproximadamente `t_r≈0,35/BW`; para bordas mais rápidas, aumentar banda/amostragem. A taxa de 400 kHz não determina a banda necessária para observar bordas e ringing.
4. Compensar/deskew canais com a mesma borda; registrar erro residual, calibração, resolução temporal, ruído e carga da sonda. A carga acrescentada deve entrar no modelo, e sua remoção não é automaticamente pior ou melhor. Analisador lógico ≥20 MSa/s auxilia a decodificação modo 0, comandos e pulsos; não valida overshoot, thresholds, tCO ou margem elétrica. Multímetro auxilia VDD estático, não temporização.
5. Somente em ensaio de bancada autorizado, usar imagem já identificada e autorizada, com leitura de dados conhecidos contendo transições 00/FF/AA/55 quando disponíveis. Esta execução não programa FPGA nem prepara/grava cartão. Capturar power-up, 80 pulsos, CMD0/8/55/41/58, CMD17, token, payload/CRC, erros/timeout e passagens entre engines. Manter registro do hash da imagem efetivamente em execução; uma imagem diferente invalida a correspondência com este checkpoint.
6. Medir no slot: VDD e rampa/ripple; high/low SCK; duty cycle; rise/fall nos thresholds especificados; MOSI/CS estáveis antes/depois de SCK↑; MISO válido após SCK↓ e primeira resposta/liberação; overshoot/undershoot e recrossings. Repetir capturas nos extremos autorizados de alimentação/temperatura, incluindo partida fria/quente. Registrar mínimos/máximos por transição e condição, não somente médias. Manter captura longa ou segmentada para localizar outliers; número finito de leituras não garante todos os lotes/PVT.
7. Para MISO, medir SCK↓→MISO no slot dá CO aparente local, incluindo sonda e assentamento. Não mede, sozinho, ida de SCK nem retorno até o FPGA. Fechar esses termos com layout/stackup/IBIS ou pontos acessíveis próximos ao FPGA, caracterizando também derivações; se esses pontos não existirem, obter limites da Digilent. Captura interna por ILA é quantizada ao clock e não substitui os atrasos analógicos. Não autoriza margem interna por observar SCK↑ no slot.
8. Orçar incerteza: limite conservador `U_med = erro_tempo_base×intervalo + erro_deskew + erro_interpolacao + erro_ruido/menor_slew + erro_carga/deembedding`. Incluir erros de ambos os canais; alternativamente usar combinação estatística justificada, fator de cobertura e confiança declarados. Sem dados do instrumento não há U_med numérico. Não subtrair um valor arbitrário de segurança.
9. Aprovar apenas se todas as margens das equações, com limites PVT e U, forem positivas; larguras/bordas e níveis atenderem datasheets; não houver contenção ou recrossing de clock; carga respeitar as condições de tCO; startup atender o perfil; e a STA cobrir todos os caminhos relevantes. Medições típicas de um exemplar não substituem garantias de fabricante para outros exemplares. Sem perfil garantido, uma qualificação restrita exigiria envelope de uso e aceitação explicitamente definidos, sem alegar garantia geral.

Não há instrumentação disponível confirmada nem medição realizada nesta sessão. Isso continua bloqueador, não ensaio simulado.

## Decisão sobre XDC

**Nenhuma constraint nova aplicada.** Pinagem/LVCMOS33 existentes são coerentes com a referência; `create_clock` de 10 ns e clock VGA derivado de 40 ns permanecem. O relatório de clocks confirma que SCK não é clock de captura interno.

Modelo a implementar somente após obter os limites:

- Referenciar o enlace ao SCK encaminhado e à borda correta; se a referência estiver no pad SCK, `input_delay_max = B_S,max + CO_max + B_I,max` e `input_delay_min = B_S,min + CO_min + B_I,min`, relativos à descida. Não incluir novamente D_S se já propagado pelo clock de referência.
- Para captura do cartão na subida, `output_delay_max = SU_card + B_M,max − B_S,min`; `output_delay_min = B_M,min − B_S,max − HD_card`. Mesma forma para CS com seus próprios requisitos. O mínimo pode ser negativo; não o zerar.
- Essas expressões são uma especificação matemática, **não um XDC pronto**. Um `create_generated_clock -divide_by 250` isolado não representa reinícios de fase, muxes, CE e captura a 100 MHz. Sem análise de habilitação, o STA pode escolher a primeira borda de 10 ns seguinte ao lançamento, em vez da captura funcional H depois.
- Escolher análise por engine/fase com prova explícita das capturas habilitadas e transientes. Eventuais multicycles precisam dessa prova para D e CE e da relação de hold correta. Não declarar genericamente 125 ciclos em todos os caminhos. Uma referência virtual exige latências explícitas e a mesma prova; não remove a dependência arquitetural.
- Após limites/prova, aplicar `set_input_delay`/`set_output_delay` min/max, clocks/fases e incerteza sustentados pelas equações; conferir `report_timing -path_type full_clock_expanded` nas bordas efetivamente escolhidas. Carga/drive/slew dependem da caracterização elétrica. Nenhum false path SPI, exclusão global ou delay zero foi criado.

## Validação e rastreabilidade

Evidências novas em `validation/spi-budget-20261030/` (diretório ignorado pelas regras Git existentes; arquivos locais preservados, sem staging ou commit):

- `extract.tcl`, `console-valid.txt`, `extract-valid.log/jou`: reabertura somente de leitura do checkpoint, sem reset de timing, mudança de XDC ou implementação; término normal, código zero.
- `clocks.rpt`, `port-properties.txt`, `miso-endpoints.txt`, `miso_min/max.rpt`, `SD_*_min/max.rpt`, `path-summary.json`: min/max por porta, todos os 126 endpoints MISO com duas alternativas por endpoint (252 caminhos por tipo). Slack continua infinito nos caminhos sem modelo externo.
- `throughput-compile.txt`, `throughput-test.txt`: testbench existente `tb_sd_spi_throughput`, HALF=125, init=125. Três setores, 1.536 bytes e CRCs conferidos, saída zero. POWERUP é reduzido no testbench; não valida os 2 ms reais nem comportamento elétrico do cartão. Não houve regressão completa nova.
- `preservation.json`, `reused-evidence-sha256.json`, `manifest.json`, `SHA256SUMS`: integridade e proveniência. Primeira chamada do Vivado não encontrou o script por diretório de trabalho incorreto; `console.txt`/`extract.log/jou` registram a tentativa sem análise. Somente os arquivos `*-valid` comprovam extração concluída.

Reprodução da extração: no diretório de evidências, executar `/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch -source extract.tcl -log nova-extracao.log -journal nova-extracao.jou`. Fazer em cópia desse diretório para preservar relatórios. O script não contém acesso a hardware nem geração de bitstream.

Os relatórios existentes em `validation/signoff-20261030-config-io/verified/` foram revisados e seus hashes registrados, sem repetir análise global inalterada: WNS=+0,337 ns, WHS=+0,015 ns; DRC sem erros e 55 avisos DSP; CDC com 24 informações CDC-3 e 112 avisos CDC-15 relacionados ao barramento retido. O handshake e bus-skew=1,414 ns/limite 10 ns já estão documentados em `docs/aprovacao_interfaces_sd.md`. Esses números internos não aprovam SPI; report_cdc não comprova o retorno externo capturado por enables. Há uma entrada externa pendente, SD_DAT0, e quatro saídas SD/power sem output delay. Não se criou comparação “antes/depois” de XDC porque o XDC não mudou.

## Situação e próxima ação indispensável

| Critério | Resultado |
|---|---|
| Pinagem e configuração lógica | Conferidas contra documentação; revisão física ainda pendente |
| Modo/frequência/captura | Comprovados em RTL, netlist e teste lógico dirigido |
| Limites temporais do cartão | Pendentes |
| Setup/hold MOSI e MISO | Equações e parcelas internas calculadas; margens finais indeterminadas |
| Condições elétricas e carga | Circuito identificado; envelope e medições pendentes |
| XDC externo e cobertura | Pendente; não mascarado |
| DRC/CDC | Evidência anterior revisada, sem mudança de projeto |
| Aprovação para bitstream/publicação | **NEGADA** |

A ação mínima é obter da Western Digital/SanDisk o perfil SPI aplicável ao código e revisão exatos (solicitação pronta em `docs/solicitacao_tecnica_qd101_spi.md`) e obter limites do enlace ou executar a caracterização acima. Sem isso, mais place/route ou WNS positivo não elimina o bloqueio. Quando os dados chegarem, preencher as seis equações, justificar fases/enables no STA e executar a validação externa completa antes de liberar bitstream. Esta entrega conclui a investigação executável com os dados disponíveis, mas **não conclui a aprovação técnica solicitada**.
