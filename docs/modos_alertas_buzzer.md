# Modos operacionais, alertas e buzzer lógico

A configuração padrão acrescenta SOLO, VOO e POUSO sem associar modo operacional
a estilo visual. SW0 continua NORMAL/DECLUTTER e SW1 continua original/CAÇA.
As simulações são determinísticas e didáticas; não representam um modelo de
performance de aeronave nem sistemas de proteção certificados.

## Controles

| Controle | Função | Pino |
| --- | --- | --- |
| SW3:SW2 = 00 | SOLO | SW2=M13, SW3=R15 |
| SW3:SW2 = 01 | VOO | Mesmos pinos |
| SW3:SW2 = 10 | POUSO | Mesmos pinos |
| SW3:SW2 = 11 | SOLO com modo_invalido=1 | Mesmos pinos |
| BTNC | ACK do áudio | N17 |
| SW0 / SW1 | Declutter / estilo | J15 / L16 |
| BTNU / BTND | Heading manual de fallback | M18 / P18 |
| Botão KY-023 | Seleção do fallback SENSOR/MANCHE | JA1/C17 |
| SW12–15 | Atitude discreta de fallback | Pinagem anterior preservada |

A atribuição foi conferida no Master XDC Nexys-A7-100T da Digilent.
O vetor SW3:SW2 é sincronizado e precisa ficar estável por 100 ms. O ACK usa
sincronização e debounce de 10 ms. A mudança visual é aplicada entre quadros.
Não foi atribuído pino externo para buzzer.

## Fontes por modo

| Modo | Velocidade | Altitude | Pitch/roll | Heading |
| --- | --- | --- | --- | --- |
| SOLO | 0 kt comandado | Estimativa real barométrica/fusionada válida | Fusão MPU válida | Fusão/magnetômetro válido |
| VOO | 280 ±5 kt simulados | 36000 ±50 ft simulados | Físicos quando válidos | Real quando válido; manual como fallback |
| POUSO | Perfil simulado | Altura relativa à pista simulada | Físicos quando válidos | Real quando válido; manual como fallback |

Em SOLO, campos sem fonte válida recebem zero e indicação explícita ATT BAD,
ALT BAD ou HDG BAD. Zero não significa medição válida. Não aparecem os fallbacks
antigos de 280 kt e 36000 ft como se fossem medições físicas. A velocidade de
SOLO é um valor de cenário, não uma medição de airspeed.

Em VOO/POUSO, atitude física válida tem prioridade mesmo se o botão do joystick
estiver em MANCHE. Quando a atitude física não está disponível, a cadeia de
fallback existente fornece manche ou switches, com FALLBK e SENSOR. O heading
manual também é identificado como fallback quando a referência real falha.
Os alertas angulares são suspensos para atitude física inválida; SENSOR continua
ativo. O manche preserva sua função no fallback e na configuração legada.

A validade inclui identificação/calibração dos módulos existentes e recebimento
de primeira amostra. Sem nova amostra, expira após 250 ms para atitude, 1 s para
altitude e 500 ms para heading. Recuperação exige nova amostra. A validade de
VSI real ainda depende do estimador vertical e dos sensores correspondentes;
fora da faixa de atitude suportada, não usar esse VSI como medida válida.

A altitude física usa referência barométrica de 101325 Pa; não é altura acima do
terreno. No pouso, zero é a pista simulada. A velocidade inercial anterior
permanece no código e na configuração legada, mas não dirige a velocidade dos
três modos novos. Não há medição de airspeed por pitot.

## Simuladores

Ambos recebem enable síncrono de 20 Hz a partir do clock de 100 MHz. Não geram
novos clocks. Reset ou saída do modo reinicializa o cenário.

VOO usa ondas triangulares: velocidade dá passos de 1 kt a cada 0,5 s e altitude
dá passos de 1 ft a cada 0,2 s. Os períodos completos são 10 s e 40 s,
respectivamente. Nenhuma oscilação artificial é somada à atitude física.

| Fase de pouso | Altitude | Velocidade | VSI | Duração aproximada |
| --- | --- | --- | --- | --- |
| APPROACH | 1500 → 500 ft | 160 → 145 kt | −1200 ft/min | 50 s |
| FINAL | 500 → 40 ft | 145 → 135 kt | −600 ft/min | 46 s |
| FLARE | 40 → 0 ft | 135 → 125 kt | −300 ft/min | 8 s |
| TOUCHDOWN | 0 ft | 125 kt | 0 | 1 s |
| ROLLOUT | 0 ft | 125 → 0 kt | 0 | 25 s |

Altitude e velocidade internas usam Q8. As saídas são unidades inteiras.
A sequência dura aproximadamente 130 s; termina parada em ROLLOUT e não reinicia
sozinha. Sair e retornar a POUSO reinicia. A altitude não troca automaticamente
para a barométrica no toque, evitando misturar referências.

## Alertas

Os limiares angulares usam graus Q10 da fusão, antes da conversão para pixels e
inclinação Q8 do renderer. Um grau corresponde a 1024 unidades Q10. Os valores
abaixo são didáticos. Não são GPWS, stall warning ou proteção de envelope.

| Condição | CAUTION entra | WARNING entra | Saída por histerese |
| --- | --- | --- | --- |
| Roll em VOO/POUSO | abs ≥15° | abs ≥25° | Caution <12°; warning <22° |
| Pitch em VOO/POUSO | abs ≥10° | abs ≥15° | Caution <8°; warning <13° |
| Roll em POUSO abaixo de 200 ft, antes do toque | abs ≥8° | abs ≥12° | Caution <6°; warning <10° |
| Velocidade em POUSO, 10<ALT<200 ft, antes do toque | ≥155 ou ≤100 kt | ≥175 ou ≤85 kt | Caution sai em 105<V<150; warning em 90<V<170 |
| Sink em POUSO, 50<ALT<500 ft, VSI válido | ≤−1500 ft/min | ≤−2000 ft/min | Caution >−1300; warning >−1800 |

As flags são registradas a 100 MHz; a histerese é de amplitude, sem tempo mínimo
adicional para disparo. Mudança de modo limpa a memória de histerese anterior.
SOLO inibe os alertas de atitude/velocidade de voo. TOUCHDOWN/ROLLOUT inibem
speed/sink, para a redução normal de velocidade não gerar falso alerta.

| Severity | Nome | Uso |
| --- | --- | --- |
| 00 | NONE | Sem alerta |
| 01 | INFO | Modo reservado ou chegada a FLARE ≤40 ft |
| 10 | CAUTION | Limite moderado ou fonte física necessária inválida em VOO/POUSO |
| 11 | WARNING | Limite maior ou fonte necessária inválida em SOLO |

WARNING > CAUTION > INFO. As flags individuais permanecem disponíveis.
Desempate visual por severidade: ROLL, PITCH, SPEED, SINK, SENSOR. INFO usa MODE
antes de ALT. Uma falha secundária continua indicada pelos rótulos de validade.
O VSI usado nos alertas de POUSO é o da trajetória simulada, não o movimento
vertical físico da bancada.

## HUD e sincronismo

GND/FLT/LDG identifica o modo. SIM identifica os cenários VOO/POUSO; FALLBK
indica uso de dados manuais. Avisos WARNING são vermelhos; CAUTION âmbar; INFO
ciano. Os avisos e as indicações de validade permanecem em DECLUTTER nos dois
estilos. Todos respeitam blanking. O rótulo SIM do estilo CAÇA também passa a
respeitar a origem dos dados.

`operacao_hud` registra valores e estado em paralelo aos alertas calculados para
a mesma amostra. `entrada_hud`, agora parametrizável, transfere 89 bits: os
57 bits de dados anteriores e 32 de metadados. O handshake mantém todo o pacote
estável até confirmação. `dados_hud` armazena o pacote pendente e só aplica dados
e metadados em x=0,y=480. Dados válidos de transporte não significam sensores
válidos; a validade por fonte está nos metadados.

A validade de VSI é transportada, mas ainda não há fita/valor numérico de VSI
no HUD. O valor real permanece disponível internamente no estimador; o valor
simulado é usado no detector de sink durante o pouso.

## Buzzer

Lógica implementada para buzzer **ativo**, conforme o teste do componente
relatado pelo usuário. `buzzer_out` gera somente liga/desliga. Não há portadora
nem novo clock.

| Severity | Ligado | Desligado |
| --- | --- | --- |
| NONE | Nunca | Sempre |
| INFO | 100 ms | 4900 ms |
| CAUTION | 250 ms | 750 ms |
| WARNING | 200 ms | 200 ms |

Os tempos são parâmetros em ciclos de 100 MHz. BTNC reconhece a severidade atual
e silencia o áudio, mantendo alerta visual. Escalada de severidade cancela ACK;
NONE limpa ACK. Manter BTNC pressionado não reconhece novos alertas repetidamente.
Troca de causa com a mesma severidade não cancela ACK nesta versão.

`buzzer_out` é sinal **interno ao top**, ligado a um pequeno indicador âmbar no
HUD para observabilidade e retenção da lógica na síntese. Não existe porta de
buzzer sem constraint nem atribuição a JA2. O indicador ACK mostra reconhecimento.
A implementação elétrica está pendente. Nenhuma corrente, acionamento direto,
transistor ou conexão física foi definido nesta etapa.

## Regressão e configuração anterior

`MODOS_OPERACIONAIS=1` é o padrão do hardware. O parâmetro zero mantém a cadeia
anterior para regressão e comparação. Nove bancos/geradores que instanciam o top
foram configurados explicitamente para essa cadeia; suas verificações anteriores
não foram removidas. Isso preserva a cobertura dos fallbacks antigos sem fingir
que 280/36000 pertencem ao novo SOLO. A configuração padrão nova é exercitada por
`tb_modos_operacao_integrado`, além dos bancos unitários e de validade de fontes.

O script mantém os 46 bancos anteriores e acrescenta oito: modo_operacao,
simulador_voo, simulador_pouso, alertas_voo, buzzer_driver, fontes_operacao,
alertas_vga e modos_operacao_integrado. Os testes aceleram contadores por
parâmetro; o bitstream usa os tempos reais.

Executar `./scripts/test.sh` antes de `scripts/build_vivado.tcl`. O build preserva
projetos/relatórios anteriores em `build/before-*`, faz route, emite relatórios,
bloqueia bitstream em caso de setup/hold negativo ou DRC com erro e então executa
write_bitstream. Examinar também check_timing e CDC; a existência de um .bit não
substitui essas verificações. Não programar a placa automaticamente.
