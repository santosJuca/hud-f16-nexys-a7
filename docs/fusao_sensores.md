# Fusão de sensores

A branch `dev/fusao-sensores` mantém a cadeia de atitude, o desenho VGA e a
velocidade inercial estimada. Acrescenta dois estimadores antes de `entrada_hud`.

| Estado | Medições | Processamento | Saída |
| --- | --- | --- | --- |
| Atitude | MPU6050: gyro X/Y e aceleração | Filtro complementar existente | Pitch/roll em graus Q10 |
| Heading | MPU6050: gyro Z; HMC5883L: X/Y | Integração e correção circular de 1/32 | Rumo magnético estimado, 0..359° |
| Vertical | BMP085; MPU6050: XYZ e pitch/roll | Projeção, remoção de gravidade e observador complementar | Altitude estimada/fusionada em ft e velocidade vertical estimada em ft/min |
| Velocidade horizontal | MPU6050 longitudinal | Integrador existente | Velocidade inercial estimada em KT |

Os módulos `heading_fusao`, `projecao_vertical` e `estado_vertical` operam a
100 MHz. Altitude e rumo passam pelo CDC existente e só chegam à imagem entre
quadros. O VSI fica disponível em `top_reticula.vel_vertical_fpm`, acompanhado
de `vertical_valido`; ainda não há símbolo de VSI no VGA. SENSOR/MANCHE continua
selecionando somente pitch/roll da tela; os estimadores usam a atitude do MPU.

## Heading

O gyro Z tem 131 LSB/(°/s). Uma instância de `gyro_bias_dt` calcula seu bias
nas primeiras 64 amostras; a placa deve ficar imóvel durante a calibração.
A integração usa o `gyro_dt_cycles` já existente, em ciclos de 100 MHz, e o
mesmo `gyro_integrador` da atitude. Registros antes dos três integradores
separam a subtração do bias dos multiplicadores, sem alterar a equação. Zero e intervalos maiores que 100 ms são
rejeitados. O primeiro intervalo estabelece o rumo a partir do magnetômetro.
A montagem documentada produz gyro Z negativo ao girar no sentido horário;
`INVERTER_GYRO=1` converte esse sinal para rumo crescente.

O estado é mantido em graus Q10, com 1024 unidades por grau:

```text
predito = wrap_0_360(estado + delta_gyro)
erro = wrap_menos180_180(heading_mag - predito)
estado = wrap_0_360(predito + erro / 32)
```

O truncamento da correção é simétrico. De 359° para 1°, o erro é +2°; de 1°
para 359°, é −2°. A saída inteira trunca a fração. O ganho 1/32 permite resposta
rápida do gyro e converge para a referência magnética em cerca de 32 atualizações
(aproximadamente 0,32 s a 100 Hz). A constante de tempo depende da taxa de amostras;
a referência magnética mais recente pode ser usada por mais de uma atualização.
Não há correção contínua a cada clock: o filtro só muda após integração válida.
Predição, diferença circular, ganho e normalização são separados por registros.
As interfaces novas exigem ao menos 16 clocks entre pulsos de `dt_valid`; os
drivers operam com intervalos de milissegundos, sem necessidade de fila.

O CORDIC publica `atualizado` junto com cada resultado. A fusão exige referência
magnética com menos de 0,5 s. Se o MPU, a referência magnética ou sua validade
falhar, o estado numérico é retido, mas a saída fusionada deixa de ser válida.
A recuperação reinicializa pelo magnetômetro e exige novo intervalo válido.
Não há navegação por gyro indefinidamente sem referência absoluta.

Seleção no top: **fusionado válido → magnético válido → manual**. Os botões
continuam atualizando o manual enquanto outra fonte está selecionada. O fallback
magnético preserva a política anterior do driver/CORDIC; o watchdog de 0,5 s é
específico da fusão. Uma troca de fonte pode mudar o rumo no próximo quadro.

`MAG_OFFSET_X/Y` continuam neutros por padrão e são subtraídos antes do CORDIC;
`MAG_TROCAR_XY` e `MAG_INVERTER_X/Y` definem a orientação da referência magnética.
Essa é a preparação existente para hard-iron no cálculo plano. Offset Z e
compensação magnética de inclinação ficam para uma etapa XYZ posterior, após
confirmar o alinhamento entre HMC e MPU. Não foi criada calibração física fictícia.
O rumo não possui correção de declinação geográfica.

## Vertical

O acelerômetro usa 16384 LSB/g. O código existente documenta pitch associado a
`accel_y` e roll a `-accel_x`, mas ainda não usa Z na atitude. O novo bloco adota
+Z para cima em repouso e só aceita calibração com projeção entre 14000 e 18000
counts, X/Y entre −1000 e +1000 e atitude até ±2°. Montagem com Z negativo não
habilita a integração; a altitude continua vindo do barômetro filtrado. Confirmar
Z e alinhamento físico faz parte da validação pendente.

Para a convenção adotada, o vetor unitário vertical em coordenadas do sensor é:

```text
n = (-sin(roll)*cos(pitch), sin(pitch), cos(roll)*cos(pitch))
a_projetada = dot(accel_XYZ, n)
a_linear = a_projetada - gravidade_bias
```

Seno/cosseno usam tabela inteira Q14, com arredondamento ao grau mais próximo,
limitada a ±30°. Produtos e soma são registrados. Não há `real` nem divisores
combinacionais nos módulos novos. A projeção preserva uma gravidade estática
inclinada; ela não equivale a usar Z diretamente.

`gravidade_bias` é a média de 64 projeções em repouso, incorporando 1 g e o bias
vertical inicial. Não é uma calibração completa dos três eixos; X/Y com bias,
erro da atitude, vibração, aceleração sustentada e temperatura limitam a precisão.
Uma zona morta de 100 counts (cerca de 0,006 g) reduz integração de ruído.
A aceleração linear é convertida para ft/s² Q16. O intervalo em segundos Q16
vem de `dt_cycles * 2814750 >> 32`.

O observador usa altitude em ft Q8 e velocidade em ft/s Q16:

```text
erro = limitar(altitude_baro - altitude_estimada, -32 ft, +32 ft)
v = limitar(v + a_linear*dt + 0,25*erro*dt, -100 ft/s, +100 ft/s)
h = limitar(h + v*dt + erro*dt, 0 ft, 99999 ft)
VSI = v * 60, em ft/min
```

Os ganhos de posição (1/s) e velocidade (0,25/s²) formam um observador de segunda
ordem com amortecimento crítico no modelo contínuo. A correção da velocidade é
necessária: corrigir apenas a altitude deixaria o bias acumular no VSI.
O erro limitado reduz saltos por variação barométrica; não detecta toda medição
espúria. Ao atingir o limite de altitude, a velocidade volta a zero. Produtos
intermediários têm largura maior e são saturados antes da redução de bits.
O BMP085 continua calculando altitude barométrica com P0=101325 Pa.

A primeira altitude barométrica válida ancora o estado. Antes dela, os 36000 FT
anteriores permanecem como valor demonstrativo de fallback, não como medição.
Sem MPU/atitude válida, durante a calibração ou fora de ±30°, novas altitudes
barométricas corrigem a altitude retida em 1/16 do erro limitado a ±32 ft
(até 2 ft por evento). Sem barômetro válido, a altitude é retida, o VSI é zerado
e invalidado e não se integra aceleração. A recuperação exige referência
barométrica e nova calibração em repouso. O número retido não significa medição
atual: `altitude_disponivel` registra que já houve uma referência;
`valido` indica disponibilidade da fusão dinâmica.

Os drivers indicam perda de comunicação. Entre conversões, a última altitude
barométrica é usada como referência. Não foi adicionado watchdog independente
para detectar um driver barométrico travado com `sensor_ok` permanentemente alto.
O cálculo de altitude pode não emitir novo evento quando a pressão permanece
idêntica; essa condição não deve ser confundida com sensor ausente.

## Limites e testes

`tests/tb_heading_fusao.sv` verifica bias, integração nos dois sentidos, correção,
wrap, perda/recuperação, expiração, dt inválido e retenção.
`tests/tb_projecao_vertical.sv` verifica gravidade plana e inclinada, sinais,
combinações de pitch/roll e bloqueio fora da faixa.
`tests/tb_estado_vertical.sv` verifica repouso, subida/descida, gravidade, bias,
convergência, perdas, recuperação, saturação e cancelamento do pipeline. Os dois
limites de altitude são exercitados com estado inicial próximo das bordas.
`tests/tb_top_fusao_sensores.sv` injeta dados nas interfaces digitais dos sensores
e verifica CORDIC, fusão, CDC, quadro e fallback. Os testes existentes de I²C
continuam cobrindo os drivers sem depender de sensores físicos.

Executar `./scripts/test.sh` e compilar `top_reticula` antes do build Vivado.
Síntese, route, DRC e timing precisam ser aprovados para aceitar o bitstream.
Os resultados desta execução ficam em [validação da fusão](validacao_fusao_sensores.md).

A velocidade inercial estimada permanece demonstrativa e sujeita a drift.
Não é airspeed real. GPS permitiria corrigir ground speed; pitot e pressão
diferencial permitiriam medir airspeed. Nenhum desses sensores foi acrescentado.

A placa permaneceu desligada. Estão pendentes: orientação relativa HMC/MPU,
sinal de Z, hard-iron real, verificação do sentido de giro, calibração imóvel,
resposta vertical a movimentos conhecidos, ruído, drift térmico, ajuste de ganhos
e observação do HUD com sensores conectados. Compensação magnética de inclinação,
correção completa da cinemática de yaw inclinado e VSI visual ficam para outra
etapa. O gyro Z é aproximação de yaw, especialmente adequada à posição plana.
