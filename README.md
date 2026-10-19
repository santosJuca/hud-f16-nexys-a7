# HUD aeronáutico em FPGA

## Atualização de 19/10/2026

Joystick com velocidade fixa de 4 pixels por atualização nos dois sentidos e LOCK independente em NORMAL e CAÇA. O botão SW está em JA1/C17; o buzzer permanece em JC10/E6. O operador confirmou o funcionamento na placa após a programação JTAG desta correção. A Flash ainda contém a versão anterior. A confirmação funcional não substitui a medição elétrica das entradas XADC.

O registro abaixo conserva a referência da demonstração de 13/10 e suas pendências; os testes novos estão em [docs/testes.md](docs/testes.md).

## Montagem validada em 13/10/2026

O operador confirmou boot pela Flash, VGA estável, joystick nos quatro sentidos
em NORMAL e CAÇA, repouso/limites/LOCK, MPU sem ATT BAD, indicadores do BMP085 e
HMC5883L e buzzer silenciado por BTNC. SW do joystick está em JA1/C17. O buzzer
foi remanejado de JC7/E7 para JC10/E6; o vertical do joystick é invertido no top.

A versão preservada está em
[`bitstreams/2026-10-13_hud_flash/`](bitstreams/2026-10-13_hud_flash/README.md).
O [registro de bancada](docs/validacao_hardware_20261013.md) distingue esses
relatos dos testes digitais e das medições elétricas ainda pendentes. Resultados
datados de 08/10 e 09/10 abaixo pertencem às versões anteriores.

## Visão geral

Projeto acadêmico de Sistemas Digitais que gera um HUD aeronáutico em VGA na Digilent Nexys A7-100T, com FPGA Artix-7 `xc7a100tcsg324-1`. O desenho é gerado por coordenadas, sem framebuffer, e combina simbologia de voo, dados de sensores, simulação de voo/pouso, modos de exibição e alertas.

O RTL está em SystemVerilog. O fluxo de implementação usa Xilinx Vivado e o clock de 100 MHz da placa; o controlador deriva um clock de pixel de 25 MHz para VGA 640×480. A regressão usa Icarus Verilog; os testes raster exaustivos `roll` e `vga` usam Verilator quando disponível, com fallback ao Icarus. O top é `top_reticula`, em [`rtl/top_reticula.sv`](rtl/top_reticula.sv), e as restrições de pinos estão em [`constraints/nexys_a7_reticula.xdc`](constraints/nexys_a7_reticula.xdc).

## Estado da implementação

| Área | Estado confirmado no RTL | Validação disponível |
| --- | --- | --- |
| Geração VGA, retículo, horizonte, escalas e valores numéricos | Implementada | Testbenches de geometria, quadro, pitch/roll, estilos e top |
| Estilos NORMAL e CAÇA; exibição NORMAL e DECLUTTER | Implementados e independentes | `tb_estilos`, `tb_frames_estilos`, `tb_modo`, `tb_modos` |
| Atitude MPU-6050 | Aquisição, calibração, integração temporal do giroscópio e fusão complementar conectadas ao HUD | Testbenches de sensores e fusão; operador relatou MPU funcional e recuperado no teste físico do bitstream de 8/10 |
| Heading | HMC5883L plano, fusão com gyro Z e fallback manual | Testes de I²C, cálculo, fusão e top; operador relatou 5/5 ensaios em operação e recuperação no reteste após episódio intermitente. Calibração/precisão absoluta não verificada; `HDG BAD` foi breve |
| BMP085 | Aquisição, calibração, compensação de temperatura/pressão e estimação vertical conectadas | Testbenches I²C, compensação, altitude e top; operador relatou 3/3 ensaios físicos e recuperação |
| KY-023 | Eixos por XADC movem a mira; botão alterna LOCK/UNLOCK; quatro LEDs mostram direção | Sentidos e LOCK/UNLOCK foram relatados em 13/10. Em testes posteriores com resistores de 27 kΩ foram relatadas leituras acima de 1 V; circuito e faixa segura não validados |
| Modos SOLO/VOO/POUSO e alertas | Integrados; `buzzer_out` sai por JC10/E6 | Simulação unitária/integrada; operador confirmou buzzer e ACK por BTNC em 13/10, com a ligação anterior em JC7/E7 |
| Bitstream de demonstração | Versão de 13/10/2026 gravada na Flash; Vivado 2026.1 e SHA-256 registrados no catálogo | Boot pela Flash e funções relatadas em [`docs/validacao_hardware_20261013.md`](docs/validacao_hardware_20261013.md) |

“Implementado” descreve o RTL; simulação, implementação Vivado e ensaios físicos são evidências diferentes. Os resultados físicos resumidos acima foram informados pelo operador e não têm logs ou medições anexados. O relatório de implementação não valida precisão física dos sensores nem segurança elétrica da montagem.

## Funcionalidades do HUD

- **Retículo fixo:** referência central verde. O estilo NORMAL usa cruz com vão; o CAÇA usa outro desenho fixo com pequeno vão central.
- **Mira móvel:** no estilo CAÇA, o KY-023 move um marcador pela tela; o botão do joystick congela ou libera a posição. LOCK não representa aquisição ou rastreamento de alvo real.
- **Marcador vermelho fixo:** quatro cantos em torno de `(430,180)` aparecem no estilo HUD original (SW1=0), inclusive durante VOO; ficam ocultos no estilo CAÇA (SW1=1). Não dependem de SOLO/VOO/POUSO, não acompanham a mira e não representam alvo detectado. São apenas um marcador visual fixo e podem parecer sem função na demonstração de voo.
- **Horizonte e escada de pitch:** deslocam-se e inclinam-se conforme pitch e roll. SW15..SW12=`1111` seleciona o MPU se SW9 estiver desligado; os demais estados selecionam atitude manual. SW9–SW11 desativam o uso lógico das fontes MPU, barométrica e magnética.
- **Pitch e roll:** estimados a partir do MPU-6050. A aceleração fornece a referência gravitacional e o giroscópio é calibrado, integrado com `dt` medido e combinado por filtro complementar.
- **Velocidade e altitude:** escalas laterais, rótulos e números. Em VOO e POUSO, velocidade/altitude seguem os simuladores; em SOLO a velocidade é zero e a altitude usa a fonte barométrica/fusão disponível, com indicação de validade. A velocidade inercial experimental não é a fonte selecionada para os modos operacionais e não mede velocidade em relação ao ar.
- **Heading:** graus e cardeais. O cálculo magnético usa o plano XY do HMC5883L; gyro Z corrige o rumo por fusão complementar. BTNU/BTND ajustam um fallback manual em passos de 10°.
- **Alertas:** texto VGA para condições de atitude, velocidade, altitude, razão vertical, sensores e fase/seleção inválida. As prioridades, limiares e histerese estão em `rtl/alertas_voo.sv`.
- **Indicadores:** quadrado sólido no alto à esquerda mostra o estado do MPU na VGA: vermelho enquanto `sensor_ok=0`, verde após o driver publicar uma amostra completa; LEDs físicos mostram estado/direção conforme a tabela abaixo.

O compositor dá prioridade aos alertas, depois à mira móvel em CAÇA, retículo, marcador vermelho (somente NORMAL), horizonte/simbologia e indicador do MPU. DECLUTTER oculta escalas, números, heading e indicador do MPU; conserva os elementos de referência e os avisos definidos pelo compositor. Em CAÇA, o marcador de quatro cantos continua oculto independentemente de DECLUTTER.

## Modos de operação

### SOLO, VOO e POUSO

SW3:SW2 selecionam a operação. As entradas passam por sincronização/debounce; o estado `11` é inválido e o controle retorna a SOLO com flag de modo inválido.

| SW3:SW2 | Modo | Dados principais |
| --- | --- | --- |
| `00` | SOLO | Velocidade zero; sensores físicos válidos são usados. Ausência de fonte válida é sinalizada, sem substituir atitude/heading por comandos de bancada como fonte real. |
| `01` | VOO | Perfil didático iniciado em 280 kt e 36.000 ft. Atitude alimenta a dinâmica quando válida; heading do simulador acompanha a referência magnética/manual. Se atitude/heading falharem, a exibição usa fallback e sinaliza a condição. |
| `10` | POUSO | Sequência didática de aproximação, final, flare, toque e desaceleração. Velocidade, altitude relativa e VSI são simulados; fallback de atitude/heading é indicado quando necessário. |
| `11` | Entrada inválida | Tratada como SOLO com `modo_invalido` ativo. |

Os valores e a dinâmica são demonstrações, não instrumentos aeronáuticos. Os detalhes dos sinais e dos alertas estão em [`docs/modos_alertas_buzzer.md`](docs/modos_alertas_buzzer.md).

### NORMAL e CAÇA

SW1 troca o estilo visual entre quadros VGA. SW0 seleciona o nível de informação, também aplicado na fronteira de quadro. A combinação dos dois é independente:

| Controle | Posição 0 | Posição 1 |
| --- | --- | --- |
| SW0 | NORMAL: simbologia completa | DECLUTTER: conjunto reduzido |
| SW1 | HUD original | HUD CAÇA |

NORMAL/DECLUTTER é um filtro de exibição, não muda a fonte dos sensores. CAÇA substitui o retículo e a apresentação das escalas e habilita a mira móvel. O marcador vermelho fixo dos quatro cantos pertence ao estilo HUD original e é independente do modo de operação e do SW0.

## Interface física atual

As pinagens abaixo vêm do XDC versionado. Pinos listados são PACKAGE_PIN da FPGA, não nomes de conectores da placa. “Validado” nas tabelas significa coberto por teste RTL; nenhum desses testes substitui validação física da versão atual.

### Switches

| Switch | Pino FPGA | Função real | Estado | Recomendação |
| --- | --- | --- | --- | --- |
| SW0 | J15 | NORMAL/DECLUTTER | ATIVO E VALIDADO em simulação; sincronizado, debounce e troca entre quadros | Manter |
| SW1 | L16 | Estilo original/CAÇA | ATIVO E VALIDADO em simulação; sincronizado, debounce e troca entre quadros | Manter |
| SW2 | M13 | Bit menos significativo de operação | ATIVO E VALIDADO em simulação com SW3; debounce no vetor | Manter |
| SW3 | R15 | Bit mais significativo de operação | ATIVO E VALIDADO em simulação com SW2; debounce no vetor | Manter |
| SW4 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW5 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW6 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW7 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW8 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW9 | U8, LVCMOS18 | Ligado desativa a cadeia MPU de acelerômetro/giroscópio e seleciona atitude manual | Pino conforme Master XDC Nexys A7-100T | Desativa o uso no RTL; o driver I²C segue lendo o dispositivo |
| SW10 | R16, LVCMOS33 | Ligado desativa a fonte barométrica | Pino conforme Master XDC Nexys A7-100T | Desativa o uso no RTL; o driver I²C segue lendo o dispositivo |
| SW11 | T13, LVCMOS33 | Ligado desativa a fonte magnética | Pino conforme Master XDC Nexys A7-100T | Desativa o uso no RTL; o driver I²C segue lendo o dispositivo |
| SW12 | H6 | Comando manual de pitch; junto a SW13, `01` = −60 px e `10` = +60 px | Resposta física precisa ser verificada nesta versão | Seleciona modo manual quando SW15..12 não é `1111` |
| SW13 | U12 | Bit mais significativo do comando manual de pitch | Resposta física precisa ser verificada nesta versão | Seleciona modo manual quando SW15..12 não é `1111` |
| SW14 | U11 | Comando manual de roll; junto a SW15, `01` = −112 Q8 e `10` = +112 Q8 | Resposta física precisa ser verificada nesta versão | Seleciona modo manual quando SW15..12 não é `1111` |
| SW15 | V10 | Bit mais significativo do comando manual de roll | Resposta física precisa ser verificada nesta versão | `1111` seleciona o MPU quando SW9 está desligado |

Nos pares SW13:SW12 e SW15:SW14, `00` e `11` produzem zero; `01` e `10` comandam valores negativos e positivos. A combinação conjunta SW15..SW12=`1111` seleciona o MPU, exceto quando SW9 está ligado. Em qualquer outro estado, os switches comandam atitude manual mesmo com o MPU disponível. A seleção manual aparece no HUD em SOLO e VOO/POUSO; em VOO/POUSO, os comandos também alimentam os alertas angulares e a dinâmica didática de velocidade. Esses valores são entradas de validação, não medições calibradas.

### Botões e joystick

| Controle | Pino FPGA / conexão | Função e tratamento | Estado |
| --- | --- | --- | --- |
| BTNU | M18 | Incrementa heading manual em 10°; sincronização de dois estágios, debounce e detecção de pressionamento | Simulação coberta; operador relatou resposta física |
| BTND | P18 | Decrementa heading manual em 10°; mesma proteção de BTNU | Simulação coberta; operador relatou resposta física |
| BTNC | N17 | ACK do alerta: silencia a saída lógica do buzzer enquanto o alerta reconhecido permanecer na mesma severidade; sincronização/debounce | Lógica validada; saída agora mapeada para JC10/E6. Teste físico após a mudança pendente |
| BTNL | — | Não declarado nem mapeado | Não utilizado |
| BTNR | — | Não declarado nem mapeado | Não utilizado |
| KY-023, eixo ligado a VAUX3 | JXADC, VAUX3 diferencial | Canal é amostrado pelo XADC; depois do período de calibração do centro, limiar efetivo de movimento de 436 contagens e passo fixo de 4 pixels | Quatro sentidos relatados como corretos em 13/10; teste posterior relatou >1 V, acima da faixa nominal unipolar |
| KY-023, eixo ligado a VAUX10 | JXADC, VAUX10 diferencial | Segundo canal XADC; a associação X/Y é trocada no top para corresponder à orientação configurada | Orientação funcional relatada em 13/10; tensão do eixo e valores/topologia dos resistores ainda não caracterizados |
| KY-023, botão SW | JA1, C17; entrada ativa baixa com pull-up no XDC | Pressionamento alterna LOCK/UNLOCK no estilo ativo; sincronização e debounce de 10 ms. LOCK congela a mira | Simulação coberta; operador relatou LOCK/UNLOCK aprovados fisicamente |

O joystick calibra o centro durante a inicialização; mantenha-o solto nesse período. A posição é atualizada em ticks lentos, limitada à região interna da tela. A deadzone e os limites reduzem deriva, mas calibração e estabilidade analógica precisam ser avaliadas na montagem real.

### LEDs físicos

| LED | Pino FPGA | Sinal controlador | Significado | Estado / decisão |
| --- | --- | --- | --- | --- |
| LD0 | H17 | `JOY_LED[0]` = `joystick_x_menos` | Movimento negativo do eixo X interpretado pelo controle | Associação conferida no RTL; sem teste físico individual deste LED em 13/10 |
| LD1 | K15 | `JOY_LED[1]` = `joystick_x_mais` | Movimento positivo do eixo X | Associação conferida no RTL; sem teste físico individual deste LED em 13/10 |
| LD2 | J13 | `JOY_LED[2]` = `joystick_y_menos` | Movimento negativo do eixo Y | Associação conferida no RTL; sem teste físico individual deste LED em 13/10 |
| LD3 | N14 | `JOY_LED[3]` = `joystick_y_mais` | Movimento positivo do eixo Y | Associação conferida no RTL; sem teste físico individual deste LED em 13/10 |
| LD4 | R18 | `GYRO_LED` = MPU habilitado e `sensor_ok` | MPU-6050 identificado; inclui o giroscópio e o acelerômetro | Operador confirmou LD4 aceso e atitude funcional em 13/10 |
| LD5 | V17 | `BARO_LED` | BMP085 identificado/calibrado, amostras válidas e pressão compensada na faixa 30–120 kPa | BMP085 aprovado em 3/3 ensaios físicos relatados |
| LD6 | U17 | `MAG_LED` = `mag_sensor_ok` | HMC5883L identificado/operacional; não indica calibração nem precisão | HMC5883L em operação em 5/5 ensaios físicos relatados e recuperado no reteste; calibração não verificada |
| LD7–LD15 | — | Nenhum sinal declarado no top/XDC | Sem função atribuída | Não utilizados |

Não há LED de LOCK, modo, alerta ou buzzer no mapeamento atual. O estado LOCK e os alertas aparecem na VGA. `buzzer_out` está atribuído a JC10/E6 para o estágio transistorizado externo; a ligação foi informada, mas ainda não foi validada em teste físico com esta pinagem.

## Sensores e conexões

As linhas XDC usam `LVCMOS33`; isso descreve o padrão elétrico dos pinos FPGA, mas não substitui a verificação da tensão permitida pelo módulo conectado. Use GND comum. Confirme pull-ups e condicionamento no módulo/montagem antes de energizar.

| Dispositivo | Barramento e pinos do top | Papel no HUD | Limites/validação |
| --- | --- | --- | --- |
| MPU-6050 / GY-521 | I²C independente: SDA JD8/G4, SCL JD7/H2 | Acelerômetro e giroscópio de seis eixos; atitude, gyro Z e parte da estimação vertical | Driver com identificação, leitura e recuperação; operador confirmou inclinações e ausência de ATT BAD em 13/10 |
| BMP085 / SEN-09694 | I²C independente: SDA JD1/H4, SCL JD2/H1 | Pressão/temperatura compensadas, altitude barométrica e entrada para estado vertical | Sem pull-up interno no XDC; CHIP_ID `0x55`. LD5 aceso e ALT BAD ausente relatados em 13/10; precisão não medida |
| HMC5883L | I²C independente: SDA JD3/G1, SCL JD9/G2 | Vetor magnético e heading plano; combinado ao gyro Z, com rumo manual de fallback | XDC habilita pull-up interno; confirmar pull-ups externos do módulo. Offset/orientação atuais são padrão, sem calibração física confirmada |
| KY-023 | Eixos em JXADC: VAUX3 (A13/A14) e VAUX10 (A15/A16); botão em JA1/C17 | Mira móvel e LOCK/UNLOCK | XADC interno e calibração inicial; quatro sentidos, centro, limites e LOCK/UNLOCK relatados em 13/10; faixa elétrica não medida |

O XDC declara três barramentos I²C separados, com seis linhas: MPU, BMP085 e HMC5883L, cada um com SDA/SCL próprios. SDA/SCL são linhas open-drain no RTL. O diagrama de montagem, alimentação do módulo e eventuais resistores externos precisa ser conferido com os módulos específicos usados pelo grupo; a constraint sozinha não confirma a tensão efetivamente aplicada.

## Arquitetura RTL

`top_reticula` reúne três caminhos principais:

1. **Entradas e sensores, 100 MHz:** `mpu6050_i2c`, `hmc5883l_i2c`, `bmp085_i2c` e `joystick_xadc` coletam amostras. Blocos de calibração/fusão transformam essas leituras em atitude, rumo, altitude e velocidade vertical; o joystick controla apenas a mira. Switches e botões fornecem fallback e seleção.
2. **Política operacional, 100 MHz:** `operacao_hud` combina validade/idade das fontes com os modos, seleciona dados simulados para VOO/POUSO, produz flags de alertas e saída lógica de ACK/buzzer.
3. **Transferência e renderização:** `entrada_hud` transfere o pacote de dados entre 100 MHz e o domínio VGA de 25 MHz. `dados_hud` aplica valores na fronteira do quadro. `vga_controller`, `simbologia_vga`, os módulos de retículo, números, estilo CAÇA e `alertas_vga` formam o RGB por coordenada.

Blocos centrais ativos incluem `controle_modo`, `controle_modo_operacao`, `atitude_accel_fixa`, `gyro_bias_dt`, `gyro_integrador`, `atitude_fusao_complementar`, `heading_magnetico`, `heading_fusao`, `bmp085_compensacao_seq`, `bmp085_altitude`, `estado_vertical`, `simulador_voo`, `simulador_pouso`, `alertas_voo`, `buzzer_driver`, `mira_joystick`, `reticula_vga`, `reticula_caca_vga`, `mira_caca_vga`, `simbologia_vga`, `simbologia_caca_vga`, `numeros_hud` e `alertas_vga`.

Há RTL de experimentos/etapas anteriores no diretório que não integra o top atual. Entre eles estão `mma8452_i2c.sv` e controles de manche que não são instanciados por `top_reticula`. A existência de um módulo ou testbench isolado não implica que a função esteja conectada ao produto atual.

## Simbologia e leitura da tela

| Elemento | Leitura |
| --- | --- |
| Retículo | Referência fixa central da aeronave; geometria diferente em NORMAL e CAÇA |
| Mira móvel | Marcador controlado pelo joystick em CAÇA; ciano em UNLOCK e âmbar em LOCK |
| Marcador vermelho fixo | Quatro cantos em torno de `(430,180)`, exclusivos do estilo HUD original; não é rastreador nem alvo detectado |
| Horizonte/escada | Referência de pitch com marcas angulares; inclinação representa roll |
| Pitch e roll | Estimativas de atitude ou fallback conforme o modo operacional e validade |
| Heading | Rumo em graus/cardinal, HMC/gyro fusionado ou fallback manual/simulado |
| Altitude e velocidade | Escalas laterais com números e unidades; origem depende de SOLO, VOO ou POUSO |
| LOCK/UNLOCK | Estado de congelamento da mira, exibido pela camada de status nos dois estilos quando `MODOS_OPERACIONAIS=1` |
| Alertas | Texto/cores definidos pela severidade e causa; permanecem visíveis no modo reduzido conforme a composição VGA |
| Sensores | Indicador VGA do MPU em modo completo; LD4/LD5 e LD0–LD3 oferecem diagnóstico físico |

## Compilação e simulação

O script de regressão é `scripts/test.sh`. Requer `iverilog` e `vvp`; `verilator` é opcional e acelera os testes raster `roll` e `vga` sem reduzir os vetores. O script compila os testbenches listados usando `rtl/*.sv` e `tests/xadc_stub.sv`. A saída executável é gravada em `build/tests/`, portanto confira esse diretório se precisar preservar arquivos ali existentes.

```sh
./scripts/test.sh
```

Os testbenches abrangem modos operacionais, simuladores, alertas/ACK, joystick, estilos e quadro VGA, sincronização de dados, atitude, velocidade inercial, heading, HMC5883L, BMP085, altitude/estado vertical e o top integrado. A lista completa e os tops executados estão em [`scripts/test.sh`](scripts/test.sh) e [`tests/`](tests/).

## Síntese, implementação e programação

O script `scripts/build_vivado.tcl` cria o projeto para `xc7a100tcsg324-1`, adiciona todos os `rtl/*.sv` e `constraints/nexys_a7_reticula.xdc`, define `top_reticula`, sintetiza e roteia. Ele **move** `build/vivado` e relatórios existentes para um subdiretório `build/before-*` antes de criar outra execução. Verifique o conteúdo a preservar antes de usá-lo; nesta revisão, o script foi executado apenas em cópias temporárias isoladas.

Com Vivado 2026.1 (versão confirmada pelos relatórios preservados):

```sh
vivado -mode batch -source scripts/build_vivado.tcl
```

Bitstream resultante: `build/vivado/reticula.runs/impl_1/top_reticula.bit`. O XDC define o clock de entrada de 100 MHz, clock gerado de 25 MHz, VGA, sensores e controles mapeados. Para outro modelo/placa, não reutilize a pinagem sem verificar o dispositivo e as constraints.

Para programar manualmente, conecte a Nexys A7-100T correta, abra o Vivado Hardware Manager, conecte ao target e use **Program Device**, selecionando o bitstream desejado. O script `scripts/program_board.tcl` também programa o dispositivo conectado e requer Vivado/Hardware Manager. A programação não foi executada nesta auditoria.

## Testes e relatórios preservados

Na auditoria anterior, o conteúdo de `scripts/test.sh` foi inspecionado: ele cria e sobrescreve executáveis em `build/tests/`. Como esse diretório contém artefatos, a regressão desta revisão foi executada em uma cópia isolada de `rtl/`, `tests/` e `scripts/`, em `/tmp`. **Todos os testes listados passaram**, inclusive o teste MPU-6050 de falhas e recuperação. O `tb_simulador_voo` também verifica agora que o heading permanece estável quando a atitude MPU se invalida e volta a avançar após a recuperação. Icarus emitiu avisos `sorry: constant selects in always_* processes are not currently supported`; eles indicam limitações do simulador e não impediram a regressão.

Relatório de implementação correspondente ao bitstream versionado de 8/10/2026 (`bitstreams/2026-10-08_hud_caca_marker/`):

| Recurso/resultado | Valor reportado |
| --- | ---: |
| Vivado | 2026.1, build 6511674 |
| Slice LUTs | 11.984 (18,90%) |
| Slice registers | 6.669 (5,26%) |
| DSP48E1 | 31 (12,92%) |
| Block RAM | 0 |
| WNS / TNS | +0,078 ns / 0 ns |
| WHS / THS | +0,017 ns / 0 ns |
| Endpoints setup/hold com falha | 0 / 0 |
| DRC | 0 erros; 55 checks em avisos (inclui CFGBVS e recomendações de pipeline DSP) |
| CDC | Sem endpoint inseguro listado no relatório |

Esses slacks valem para os clocks e caminhos internos restritos. O relatório `check_timing.rpt` registra seis entradas I²C sem input delay, 12 controles tratados como false path e 26 saídas sem output delay; logo, os números não validam temporização elétrica externa. O resumo completo, CDC, DRC e utilização estão junto ao bitstream. Os relatórios acima são históricos. A árvore atual mantém apenas o pacote de 13/10/2026; as versões antigas continuam disponíveis no histórico Git.

Em 9/10/2026, foi executada síntese e implementação do baseline em diretório temporário, com Vivado 2026.1. A execução reproduziu o WNS de +0,078 ns e o WHS de +0,017 ns do relatório preservado; o pior caminho continua entre `u_fusao_atitude/valido_reg` e `u_operacao/u_voo/heading_deg_reg[4]`, com 15 níveis lógicos. Uma variante experimental que retirava o mux de validade do somador do heading foi descartada: apesar de passar a simulação e a implementação, seu WNS foi +0,041 ns, abaixo do baseline. Nenhum bitstream aprovado foi substituído ou programado; naquela revisão, o artefato de release era o datado de 8/10/2026. A versão atual está em `bitstreams/2026-10-13_hud_flash/`.

As constraints atuais ainda deixam seis entradas I²C sem input delay, 12 controles assíncronos tratados como false path até sincronizadores e 26 saídas sem output delay. Esses itens não são cobertos pelo slack dos clocks internos; qualquer alteração deve ser baseada nos requisitos elétricos das interfaces e na documentação da placa, sem atrasos arbitrários.

## Limitações conhecidas

- O operador relatou operação física conjunta de VGA, MPU-6050, BMP085, HMC5883L, XADC e controles na versão de demonstração. Resultados, limitações e identidade do bitstream estão em [`docs/entrega_demo.md`](docs/entrega_demo.md); não há logs ou medições anexados.
- O heading magnético é uma estimativa planar, sem compensação de inclinação ou declinação geográfica; offsets/orientação precisam de calibração na montagem.
- Velocidade em VOO/POUSO é simulada. O estimador inercial legado não mede airspeed e não é selecionado pela política operacional atual.
- LOCK só congela a mira móvel; não existe detecção, rastreamento ou aquisição de alvo.
- BTNC confirma/silencia a indicação lógica. `buzzer_out` está atribuído a JC10/E6 para o estágio transistorizado externo.
- SW4–SW8, BTNL/BTNR e LD7–LD15 não estão no top/XDC e não têm função.
- SW9–SW11 desativam o uso das fontes, mas os drivers continuam consultando os sensores nos barramentos. Os comandos manuais geram avisos angulares em VOO/POUSO. Em VOO, velocidade simulada ≤100 kt gera STALL; é um alerta didático, não uma detecção aerodinâmica de estol.
- O indicador vermelho/verde do MPU pode ficar vermelho durante inicialização ou recuperação; se persistir após o sensor voltar a publicar amostras, verificar a cadeia MPU. Ele não indica estado de heading.
- O marcador de quatro cantos vermelho do estilo HUD original é fixo em `(430,180)`, independente de VOO/POUSO/SOLO; não é um alvo detectado.
- O XDC não configura `CFGBVS`/`CONFIG_VOLTAGE`; DRC também lista avisos de recomendações DSP. A temporização externa de interfaces e I/O não está completamente especificada.

## Estrutura do repositório

```text
.
├── constraints/       # XDC da Nexys A7-100T
├── bitstreams/        # Bitstreams, hashes e relatórios por build
├── docs/              # Auditorias, arquitetura, sensores e validações
├── rtl/               # Módulos SystemVerilog (ativos e alguns legados)
├── scripts/           # Regressão, Vivado, relatórios e programação
├── tests/             # Testbenches e stub XADC para simulação
└── README.md
```

Não há diretório `.github/workflows/` neste checkout. Arquivos e subdiretórios concretos podem ser listados com `rg --files`. A pasta `build/` é local e contém resultados/experimentos de desenvolvimento; não é parte da hierarquia-fonte versionada descrita acima.

## Documentação técnica

Os guias detalhados de [arquitetura](docs/arquitetura.md), [pinagem](docs/pinagem.md), [sensores](docs/sensores.md), [testes](docs/testes.md), [timing e recursos](docs/timing_recursos.md), [entrega e demonstração](docs/entrega_demo.md) e [próximas etapas](docs/roadmap.md) complementam este README. O [índice de documentação](docs/README.md) reúne esses arquivos e o [catálogo de bitstreams](bitstreams/README.md). O [estudo de vídeo auxiliar](docs/vga_auxiliar.md) é histórico e não descreve uma função implementada.

## Próximos passos

1. Arquivar fotos/vídeos e anotações dos ensaios físicos já relatados junto ao registro de entrega.
2. Não repetir ensaios do KY-023 no XADC até conferir o circuito completo dos divisores e medir cada eixo no próprio JXADC: foram relatadas leituras acima de 1 V com resistores de 27 kΩ, acima da faixa nominal unipolar do XADC. Os valores, posições e conexões dos demais resistores não estão documentados, então a divisão de tensão não pode ser calculada ainda. Depois, caracterizar o deslocamento lento para a esquerda.
3. Calibrar o HMC5883L na montagem real e comparar o heading com uma referência absoluta; registrar condições e erro medido.
4. Revisar constraints elétricas e DRC: tensão de configuração, atrasos de I/O e pull-ups/barramentos conforme os módulos conectados.
5. Testar em bancada o buzzer após a mudança física de JC7/E7 para JC10/E6 e confirmar o estágio 2N2222A, resistor de base de 1,2 kΩ, alimentação do buzzer e terra comum. Reavaliar módulos legados sem consumidor.
