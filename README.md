# HUD aeronáutico em FPGA

## Visão geral

Projeto acadêmico de Sistemas Digitais que gera um HUD aeronáutico em VGA na Digilent Nexys A7-100T, com FPGA Artix-7 `xc7a100tcsg324-1`. O desenho é gerado por coordenadas, sem framebuffer, e combina simbologia de voo, dados de sensores, simulação de voo/pouso, modos de exibição e alertas.

O RTL está em SystemVerilog. O fluxo de implementação usa Xilinx Vivado e o clock de 100 MHz da placa; o controlador deriva um clock de pixel de 25 MHz para VGA 640×480. Simulações usam Icarus Verilog. O top é `top_reticula`, em [`rtl/top_reticula.sv`](rtl/top_reticula.sv), e as restrições de pinos estão em [`constraints/nexys_a7_reticula.xdc`](constraints/nexys_a7_reticula.xdc).

## Estado da implementação

| Área | Estado confirmado no RTL | Validação disponível |
| --- | --- | --- |
| Geração VGA, retículo, horizonte, escalas e valores numéricos | Implementada | Testbenches de geometria, quadro, pitch/roll, estilos e top |
| Estilos NORMAL e CAÇA; exibição NORMAL e DECLUTTER | Implementados e independentes | `tb_estilos`, `tb_frames_estilos`, `tb_modo`, `tb_modos` |
| Atitude MPU-6050 | Aquisição, calibração, integração temporal do giroscópio e fusão complementar conectadas ao HUD | Testbenches de sensores, fusão e top; montagem GY-521 foi verificada em etapa anterior, mas não há validação física registrada para o bitstream de 8/10/2026 |
| Heading | HMC5883L plano, fusão com gyro Z e fallback manual | Testes de I²C, cálculo, fusão e top; orientação/calibração do magnetômetro no estado atual aguardam validação física |
| BMP085 | Aquisição, calibração, compensação de temperatura/pressão e estimação vertical conectadas | Testbenches I²C, compensação, altitude e top; sem confirmação física no estado atual |
| KY-023 | Eixos por XADC movem a mira; botão alterna LOCK/UNLOCK; quatro LEDs mostram direção | Testes de lógica da mira e joystick; sem validação física registrada no bitstream atual |
| Modos SOLO/VOO/POUSO e alertas | Integrados; buzzer é somente sinal lógico interno | Testes unitários e integrados |
| Bitstream mais recente | Gerado e roteado em 8/10/2026 com Vivado 2026.1 | Relatórios preservados em `bitstreams/2026-10-08_hud_caca_marker/`; placa não foi programada |

“Implementado” descreve o RTL e os testes de simulação existentes. Não significa que sensores, eixos, cores ou controles tenham sido testados na placa nesta versão. O relatório de implementação não valida a precisão física dos sensores.

## Funcionalidades do HUD

- **Retículo fixo:** referência central verde. O estilo NORMAL usa cruz com vão; o CAÇA usa outro desenho fixo com pequeno vão central.
- **Mira móvel:** no estilo CAÇA, o KY-023 move um marcador pela tela; o botão do joystick congela ou libera a posição. LOCK não representa aquisição ou rastreamento de alvo real.
- **Marcador de alvo:** quatro cantos vermelhos fixos aparecem apenas no estilo NORMAL. Ficam ocultos em CAÇA. Não acompanham a mira nem representam alvo detectado.
- **Horizonte e escada de pitch:** deslocam-se e inclinam-se conforme pitch e roll. A cadeia MPU é selecionada quando sensor, calibrações e fusão estão válidos. SW12/SW13 e SW14/SW15 formam o fallback discreto de bancada.
- **Pitch e roll:** estimados a partir do MPU-6050. A aceleração fornece a referência gravitacional e o giroscópio é calibrado, integrado com `dt` medido e combinado por filtro complementar.
- **Velocidade e altitude:** escalas laterais, rótulos e números. Em VOO e POUSO, velocidade/altitude seguem os simuladores; em SOLO a velocidade é zero e a altitude usa a fonte barométrica/fusão disponível, com indicação de validade. A velocidade inercial experimental não é a fonte selecionada para os modos operacionais e não mede velocidade em relação ao ar.
- **Heading:** graus e cardeais. O cálculo magnético usa o plano XY do HMC5883L; gyro Z corrige o rumo por fusão complementar. BTNU/BTND ajustam um fallback manual em passos de 10°.
- **Alertas:** texto VGA para condições de atitude, velocidade, altitude, razão vertical, sensores e fase/seleção inválida. As prioridades, limiares e histerese estão em `rtl/alertas_voo.sv`.
- **Indicadores:** identificação do MPU na VGA em modo completo; LEDs físicos mostram estado/direção conforme a tabela abaixo.

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

NORMAL/DECLUTTER é um filtro de exibição, não muda a fonte dos sensores. CAÇA substitui o retículo e a apresentação das escalas e habilita a mira móvel. O marcador vermelho fixo dos quatro cantos pertence apenas ao estilo NORMAL.

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
| SW9 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW10 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW11 | — | Não declarado nem mapeado | Não utilizado | Livre; não atribuir função sem atualizar XDC/RTL |
| SW12 | H6 | Fallback de pitch: par SW13:SW12=`01` desloca horizonte 40 px para cima | ATIVO SEM VALIDAÇÃO FÍSICA; só controla quando cadeia MPU não está selecionada; teste RTL | Manter como fallback/diagnóstico |
| SW13 | U12 | Fallback de pitch: `10` desloca horizonte 40 px para baixo | ATIVO SEM VALIDAÇÃO FÍSICA; só controla quando cadeia MPU não está selecionada; teste RTL | Manter como fallback/diagnóstico |
| SW14 | U11 | Fallback de roll negativo: par SW15:SW14=`01` | ATIVO SEM VALIDAÇÃO FÍSICA; só controla quando cadeia MPU não está selecionada; teste RTL | Manter como fallback/diagnóstico |
| SW15 | V10 | Fallback de roll positivo: `10` | ATIVO SEM VALIDAÇÃO FÍSICA; só controla quando cadeia MPU não está selecionada; teste RTL | Manter como fallback/diagnóstico |

SW12/SW13 iguais produzem pitch de fallback zero; SW14/SW15 iguais produzem roll zero. Se a cadeia MPU estiver válida, ela tem prioridade. No top operacional atual, esses switches servem de fallback em VOO/POUSO quando a atitude MPU não está válida; em SOLO, a falha é sinalizada e os switches não substituem o sensor. O parâmetro de regressão `MODOS_OPERACIONAIS=0` mantém o caminho legado de fallback. Não há teste físico do fallback no bitstream mais recente.

### Botões e joystick

| Controle | Pino FPGA / conexão | Função e tratamento | Estado |
| --- | --- | --- | --- |
| BTNU | M18 | Incrementa heading manual em 10°; sincronização de dois estágios, debounce e detecção de pressionamento | ATIVO E VALIDADO em simulação; sem validação física atual |
| BTND | P18 | Decrementa heading manual em 10°; mesma proteção de BTNU | ATIVO E VALIDADO em simulação; sem validação física atual |
| BTNC | N17 | ACK do alerta: silencia a saída lógica do buzzer enquanto o alerta reconhecido permanecer na mesma severidade; sincronização/debounce | ATIVO E VALIDADO logicamente; sem buzzer físico conectado |
| BTNL | — | Não declarado nem mapeado | Não utilizado |
| BTNR | — | Não declarado nem mapeado | Não utilizado |
| KY-023, eixo ligado a VAUX3 | JXADC, VAUX3 diferencial | Canal é amostrado pelo XADC; depois do período de calibração do centro, deadzone 180 e movimento limitado da mira | ATIVO SEM VALIDAÇÃO FÍSICA |
| KY-023, eixo ligado a VAUX10 | JXADC, VAUX10 diferencial | Segundo canal XADC; a associação X/Y é trocada no top para corresponder à orientação configurada | ATIVO SEM VALIDAÇÃO FÍSICA; orientação precisa ser conferida |
| KY-023, botão SW | JA1, C17; entrada ativa baixa com pull-up no XDC | Pressionamento alterna LOCK/UNLOCK; sincronização e debounce de 10 ms. LOCK congela a mira | ATIVO E VALIDADO em simulação; sem validação física atual |

O joystick calibra o centro durante a inicialização; mantenha-o solto nesse período. A posição é atualizada em ticks lentos, limitada à região interna da tela. A deadzone e os limites reduzem deriva, mas calibração e estabilidade analógica precisam ser avaliadas na montagem real.

### LEDs físicos

| LED | Pino FPGA | Sinal controlador | Significado | Estado / decisão |
| --- | --- | --- | --- | --- |
| LD0 | H17 | `JOY_LED[0]` = `joystick_x_menos` | Movimento negativo do eixo X interpretado pelo controle | ATIVO SEM VALIDAÇÃO FÍSICA; manter |
| LD1 | K15 | `JOY_LED[1]` = `joystick_x_mais` | Movimento positivo do eixo X | ATIVO SEM VALIDAÇÃO FÍSICA; manter |
| LD2 | J13 | `JOY_LED[2]` = `joystick_y_menos` | Movimento negativo do eixo Y | ATIVO SEM VALIDAÇÃO FÍSICA; manter |
| LD3 | N14 | `JOY_LED[3]` = `joystick_y_mais` | Movimento positivo do eixo Y | ATIVO SEM VALIDAÇÃO FÍSICA; manter |
| LD4 | R18 | `BARO_LED` | BMP085 identificado/calibrado, amostras válidas e pressão compensada na faixa 30–120 kPa | ATIVO SEM VALIDAÇÃO FÍSICA; manter como diagnóstico independente da VGA |
| LD5 | V17 | `MAG_LED` = `mag_sensor_ok` | HMC5883L identificado/operacional; não indica calibração nem precisão | ATIVO SEM VALIDAÇÃO FÍSICA; manter como diagnóstico independente da VGA |
| LD6–LD15 | — | Nenhum sinal declarado no top/XDC | Sem função atribuída | Não utilizados |

Não há LED de LOCK, modo, alerta ou buzzer no mapeamento atual. O estado LOCK e os alertas aparecem na VGA. O sinal `buzzer_out` existe dentro do RTL e é tratado logicamente, mas não há saída elétrica atribuída a um buzzer.

## Sensores e conexões

As linhas XDC usam `LVCMOS33`; isso descreve o padrão elétrico dos pinos FPGA, mas não substitui a verificação da tensão permitida pelo módulo conectado. Use GND comum. Confirme pull-ups e condicionamento no módulo/montagem antes de energizar.

| Dispositivo | Barramento e pinos do top | Papel no HUD | Limites/validação |
| --- | --- | --- | --- |
| MPU-6050 / GY-521 | I²C independente: SDA JD8/G4, SCL JD7/H2 | Acelerômetro e giroscópio de seis eixos; atitude, gyro Z e parte da estimação vertical | Driver contém identificação, configuração, leitura e recuperação. Validação física documentada refere-se a etapa anterior; versão atual ainda requer teste integrado |
| BMP085 / SEN-09694 | I²C independente: SDA JD1/H4, SCL JD2/H1 | Pressão/temperatura compensadas, altitude barométrica e entrada para estado vertical | XDC não declara pull-up interno neste barramento; top testa CHIP_ID `0x55`. Precisão e leitura física na versão atual não confirmadas |
| HMC5883L | I²C independente: SDA JD3/G1, SCL JD9/G2 | Vetor magnético e heading plano; combinado ao gyro Z, com rumo manual de fallback | XDC habilita pull-up interno; confirmar pull-ups externos do módulo. Offset/orientação atuais são padrão, sem calibração física confirmada |
| KY-023 | Eixos em JXADC: VAUX3 (A13/A14) e VAUX10 (A15/A16); botão em JA1/C17 | Mira móvel e LOCK/UNLOCK | Código usa XADC interno; período inicial calibra centro. Montagem de eixos deve respeitar entrada diferencial e faixa do XADC; sem teste físico atual |

O XDC declara seis interfaces I²C separadas: MPU, BMP085 e HMC5883L, cada uma com SDA/SCL próprios. SDA/SCL são linhas open-drain no RTL. O diagrama de montagem, alimentação do módulo e eventuais resistores externos precisa ser conferido com os módulos específicos usados pelo grupo; a constraint sozinha não confirma a tensão efetivamente aplicada.

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
| Marcador de alvo | Quatro cantos vermelhos, fixos e exclusivos do estilo NORMAL; não é rastreador |
| Horizonte/escada | Referência de pitch com marcas angulares; inclinação representa roll |
| Pitch e roll | Estimativas de atitude ou fallback conforme o modo operacional e validade |
| Heading | Rumo em graus/cardinal, HMC/gyro fusionado ou fallback manual/simulado |
| Altitude e velocidade | Escalas laterais com números e unidades; origem depende de SOLO, VOO ou POUSO |
| LOCK/UNLOCK | Estado de congelamento da mira, exibido pela camada de status nos dois estilos quando `MODOS_OPERACIONAIS=1` |
| Alertas | Texto/cores definidos pela severidade e causa; permanecem visíveis no modo reduzido conforme a composição VGA |
| Sensores | Indicador VGA do MPU em modo completo; LD4/LD5 e LD0–LD3 oferecem diagnóstico físico |

## Compilação e simulação

O script de regressão é `scripts/test.sh`. Requer `iverilog` e `vvp`; compila os testbenches listados no próprio script usando `rtl/*.sv` e `tests/xadc_stub.sv`. No uso normal, a saída executável é gravada em `build/tests/`, portanto confira esse diretório se precisar preservar arquivos ali existentes.

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

Esses slacks valem para os clocks e caminhos internos restritos. O relatório `check_timing.rpt` registra seis entradas I²C sem input delay, 12 controles tratados como false path e 26 saídas sem output delay; logo, os números não validam temporização elétrica externa. O resumo completo, CDC, DRC e utilização estão junto ao bitstream. O repositório preserva outros bitstreams em pastas datadas; eles correspondem a estados anteriores e não devem ser confundidos com o build mais recente.

Em 9/10/2026, foi executada síntese e implementação do baseline em diretório temporário, com Vivado 2026.1. A execução reproduziu o WNS de +0,078 ns e o WHS de +0,017 ns do relatório preservado; o pior caminho continua entre `u_fusao_atitude/valido_reg` e `u_operacao/u_voo/heading_deg_reg[4]`, com 15 níveis lógicos. Uma variante experimental que retirava o mux de validade do somador do heading foi descartada: apesar de passar a simulação e a implementação, seu WNS foi +0,041 ns, abaixo do baseline. Nenhum bitstream aprovado foi substituído ou programado; o único artefato de release continua sendo o datado de 8/10/2026.

As constraints atuais ainda deixam seis entradas I²C sem input delay, 12 controles assíncronos tratados como false path até sincronizadores e 26 saídas sem output delay. Esses itens não são cobertos pelo slack dos clocks internos; qualquer alteração deve ser baseada nos requisitos elétricos das interfaces e na documentação da placa, sem atrasos arbitrários.

## Limitações conhecidas

- O bitstream mais recente não foi programado na placa. Operação física conjunta de VGA, MPU, BMP085, HMC5883L, XADC e controles permanece pendente.
- O heading magnético é uma estimativa planar, sem compensação de inclinação ou declinação geográfica; offsets/orientação precisam de calibração na montagem.
- Velocidade em VOO/POUSO é simulada. O estimador inercial legado não mede airspeed e não é selecionado pela política operacional atual.
- LOCK só congela a mira móvel; não existe detecção, rastreamento ou aquisição de alvo.
- `buzzer_out` é interno. BTNC confirma/silencia a indicação lógica, mas nenhum transdutor ou pino de buzzer está conectado.
- SW4–SW11, BTNL/BTNR e LD6–LD15 não estão no top/XDC e não têm função.
- O par de switches de atitude só atua como fallback quando a cadeia MPU não está selecionada; não há indicação dedicada nos LEDs para esse fallback.
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

## Próximos passos

1. Programar a versão mais recente e validar VGA, modos, marcadores e cores na Nexys A7-100T.
2. Testar isoladamente e em conjunto os sensores, o sentido dos eixos do KY-023, estabilidade da deadzone, LOCK e recuperação após desconexão.
3. Calibrar o HMC5883L na montagem real e confirmar convenções de eixos/unidades.
4. Revisar constraints elétricas e DRC: tensão de configuração, atrasos de I/O e pull-ups/barramentos conforme os módulos conectados.
5. Decidir se será instalado um buzzer físico. Se não, simplificar/remover a saída lógica em uma alteração futura; se sim, atribuir pino e validar driver de acordo com o transdutor. Reavaliar módulos legados sem consumidor.
