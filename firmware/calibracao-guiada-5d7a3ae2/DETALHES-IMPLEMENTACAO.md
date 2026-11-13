> Registro histórico da implementação offline. O estado atual e os aceites posteriores estão em README.md e aceites/.

# Calibração magnética guiada: versão experimental offline

Implementação isolada da primeira calibração **2D diagonal e volátil**. Não é
calibração 3D automática nem garantia de norte correto em qualquer ambiente.
Resultados físicos: **NÃO VALIDADOS**. Não há BIT novo, JTAG, Flash ou SD nesta
entrega. O resultado final de implementação está em `resultado-final.json`.

## Base preservada e arquivos

Base: USERCODE **5DE9E304**, SHA-256 do BIT aprovado
`4f01b1aa2022a22bd587b0806f3b4a3a02d5696cea10ee1747f0eb6b45de5b3a`.
A Flash foi preservada com a última identidade conhecida **5D6E509A**.
Não houve consulta à placa nesta execução.

O alinhamento atualmente compilado é **81°**. Os 148° (+67°) pertencem a uma
etapa anterior; o ajuste posterior passou de148° para81° (−67°). Não substituímos
a configuração atual por valores históricos. O alinhamento mecânico permanece
independente dos coeficientes calculados pela calibração.

Perfil inicial: offsets X/Y/Z **67/−181/−226**, ganhos Q12 **3923/4004/4390**,
troca XY=0, inversões X/Y=1/1, compensação de inclinação habilitada. O flag de
build `MAG_CALIBRATED_3D=1` é preservado; não é nova comprovação física de cobertura
3D ou precisão. A matemática e a orientação do MPU6050 não foram modificadas.

Arquivos RTL novos:

- `hud/rtl/mag_calibration_2d.sv`: FSM, aquisição, coeficientes, validação, qualidade
  e recuperação. Nenhuma memória não volátil.
- `hud/rtl/mag_calibration_controls.sv`: sincronização, debounce, entrada e comandos.
- `hud/rtl/mag_calibration_display.sv`: oito caracteres em sete segmentos.

Arquivo existente modificado:

- `hud/rtl/top_reticula.sv`: integração opcional, roteamento dos comandos, display,
  seleção 2D/3D e validade do heading. O caminho fusionado não selecionado com tilt
  não pode mascarar um heading magnético inválido.

`genericos.txt` acrescenta somente `ENABLE_MAG_GUIDED_CAL=1`. O default RTL é0.
Todos os demais arquivos HUD, sensores, constraints, modos, vídeo, DDR2, SPI e
calibração inicial permanecem byte a byte iguais à base. Não houve ações Git.

## Interface, sem conflito com os controles atuais

Preparação: SOLO (SW3:SW2=00), MPU selecionado (SW15..12=1111), sensores habilitados
(SW11..9=000), sem captura. SW8=1, SW7:SW6:SW5=101, SW4=0. Isso é a página5
normal de diagnóstico, que conserva sua função até a entrada deliberada.

1. Segure **BTNR por2s** e solte: entra em VERIFICAÇÃO. Nenhuma calibração começa
   sozinha ao ligar. A soltura dessa pressão longa não avança a FSM.
2. Deixe a caixa nivelada; **BTNR curto** inicia COLETA, mostrando `GIrAr 1`.
3. Faça uma volta horizontal completa e suave em cerca de10–20s. BTNR curto encerra
   o treino e calcula o candidato.
4. Aparece `GIrAr 2`: faça outra volta completa. Essas amostras são posteriores ao
   ajuste, não são usadas para calcular os coeficientes. BTNR curto avalia.
5. `APtO 2d`: BTNR curto autoriza a aplicação. Ainda é exigida uma **amostra nova**
   compatível antes da troca atômica. O candidato não é aplicado antecipadamente.
6. **BTND** cancela a sessão e sai. Se já aplicado, conserva o perfil ativo.
7. **BTNU** recupera o perfil anterior sem reset; continua dentro da interface.
   Após duas aplicações, a primeira recuperação volta ao 2D anterior; uma segunda
   recuperação sem backup volta ao perfil inicial. BTND encerra a interface.

Sair da página, desligar SW8, ativar SW4 ou deixar SOLO cancela a sessão e libera
os comandos. A guarda de soltura impede que BTND/BTNU mantidos pressionados se
transformem em ajustes manuais após sair. BTNC continua reconhecendo alertas.
Dentro dessa interface, BTNU/BTND pertencem à calibração; BTNL/captura e ajustes
X/Y ficam inibidos. Fora dela, o roteamento existente é preservado. Nenhuma troca
de cena ou reinicialização do player é provocada pela calibração.

Mensagens: `CAL 2d`, `nIVEL`, `GIrAr 1`, `CALC`, `GIrAr 2`, `APtO 2d`, `APLICA`,
`rECUP`, `I2C Err`, `dAt Err`, `OVEr`, `COB Err`, `rUIdO`, `IGUAL`, `tEMPO`,
`CAL Err`, `CAL 3d`. São no máximo8 posições. G parece6; N/n é minúsculo; V usa
os segmentos inferiores; o M de `tEMPO` é aproximado porH. Não existe um M/K
exato nesse display. Os padrões reais foram testados em7.040 verificações.
`APtO` significa candidato apto matematicamente, não precisão absoluta aprovada.

A indicação numérica de rumo continua normal no HUD. Comunicação perdida,
amostra obsoleta, overflow ou suspeita detectada tornam sua validade falsa;
o pacote de quadro existente mostra **HDG BAD/FALLBK**, usando referência manual
como fallback. Não se apresenta essa referência manual como rumo magnético válido.
Não foram acrescentados novos fundos pretos ou alterações à esteira aprovada.

## Máquina de estados

NORMAL → VERIFICAÇÃO → COLETA → AVALIAÇÃO do ajuste → VALIDAÇÃO independente →
AVALIAÇÃO da melhora → CANDIDATO → CONFIRMAÇÃO com amostra nova → APLICAÇÃO → NORMAL.
Cancelamento descarta a sessão; rejeição conserva os coeficientes ativos.
RECUPERAÇÃO restaura o backup. Parâmetros aprovados, candidato e backup são bancos
separados. O perfil inicial fica nos parâmetros do build, recuperável por reset.

## Matemática e critérios objetivos

Modelo limitado aos eixos originais X/Y:

```
offset_x = floor((min_x + max_x)/2)
offset_y = floor((min_y + max_y)/2)
gain_x_Q12 = floor(2097152/(max_x-min_x))
gain_y_Q12 = floor(2097152/(max_y-min_y))
x_corr = floor((x-offset_x)*gain_x_Q12/4096)
y_corr = floor((y-offset_y)*gain_y_Q12/4096)
E = x_corr² + y_corr²
```

O raio nominal corrigido é256 contagens; sua energia nominal é65536. A escala
comum não altera atan2. Troca/inversão dos eixos e alinhamento de81° são aplicados
pelo módulo de heading existente, depois da correção. Não se corrige alinhamento
angular ou declinação pela estimativa de centro da elipse.

Critérios obrigatórios:

- Sensor reconhecido e comunicação válida; sem amostra recebida por0,5s, invalida.
- −4096 em **qualquer eixo** é overflow; leituras fora de−2048..2047 são rejeitadas.
  Um sample do driver significa transferência XYZ concluída, não prova independente
  de DRDY. O driver lê os seis bytes na ordem X/Z/Y e continua intacto.
- Repetições XYZ exatas não aumentam a contagem de orientação.50 repetições seguidas
  levantam suspeita; uma primeira amostra de treino pode inicializar os extremos.
  Repetição também pode ser quantização de um sensor parado: não prova defeito.
- Nivelamento físico antes da zeragem: gravidade válida, gz>524288 em Q20 e
  |gx|,|gy|≤gz/16 (cerca de3,6° por eixo). Perda de nível durante a sessão rejeita.
- Pelo menos64 amostras não repetidas no treino; spans X/Y entre256 e4095;
  dispersão Z de no máximo64 contagens brutas.
- Ganhos Q12 entre512 e8192, offsets representáveis e limites aritméticos verificados.
  O divisor restaurador reutilizado leva22 ciclos por eixo; não há divisão variável
  combinacional nem ajuste de elipsoide em RTL.
- Validação posterior: pelo menos64 amostras não repetidas e **os oito setores XY**,
  cada um visitado pelo menos duas vezes. O setor usa sinais e |y|>|x| após correção;
  não depende de um heading previamente considerado correto. A cobertura exigida
  para aplicar é medida nesse conjunto independente, após conhecer o centro.
- Cada energia do candidato entre52428 e78643 (aproximadamente0,8E₀ a1,2E₀); nenhum
  outlier é descartado silenciosamente para melhorar o ajuste. Z deve continuar no
  intervalo observado no treino, expandido em32 contagens para cada lado.
- Para o perfil ativo e o candidato, os mesmos dados independentes produzem Emin/Emax.
  Aceita somente se `20*Emax_novo*Emin_ativo <= 19*Emax_ativo*Emin_novo`.
  Isso exige melhora de pelo menos5% na razão Emax/Emin, não5% de precisão angular.
  Quando não há melhora, mostra `IGUAL` e conserva o perfil ativo.
- Há30s por fase para impedir coleta/espera interminável. A confirmação exige outra
  amostra nova dentro dos limites. Overflow simultâneo ao comando nunca aplica.

Os limites são critérios de engenharia desta implementação, testados com vetores
sintéticos; a adequação ao ruído real da montagem é **NÃO VALIDADA**. Não são
percentuais de confiança nem precisão. O uso de extremos é conservador: um outlier
no treino pode inutilizar o candidato, que deve ser rejeitado no segundo giro.

As correções são produtos de18x15 bits. Antes de aceitar energias, os componentes
corrigidos devem caber em±4095, portanto E<2²⁵. A comparação usa produtos de50bits
e pesos de55bits, sem truncamento do resultado válido. Produtos25x25 foram
separados em25x17 e25x8 e registrados; somas, pesos e decisão têm etapas próprias.
128 vetores de fronteira/aleatórios verificam a equivalência matemática exata.

## 2D, 3D e limites da qualidade

O candidato2D é selecionado **somente nivelado**. Inclinado, volta automaticamente
ao caminho 3D inicial, que continua recebendo dados e compensando a inclinação.
Z, orientação do MPU, roll/pitch e todos os coeficientes3D iniciais são preservados.
A passagem entre perfis pode produzir diferença de rumo; não há alegação de
transição angular contínua entre duas calibrações diferentes.

Esta solução trata hard iron XY e escala diagonal; não corrige soft iron girado,
termos cruzados ou erros XYZ completos. A elipse girada foi explicitamente
rejeitada no teste. Uma volta só na mesa não autoriza declaração de calibração3D.

Evolução: o banco de candidatos/backup, offsets16bits e ganhos Q12 são separados
do renderer e do MPU. Uma futura aquisição XYZ com cobertura3D e ajuste offline
poderá fornecer outro perfil, com matriz3x3 e limites próprios, usando a mesma
aprovação/recuperação. Esta etapa não implementa importação de matriz nem gravação.
Os extremos XYZ e contadores já são acumulados; não há captura completa de dados
para elipsoide nem solver3D oculto.

Com perfil2D ativo, a magnitude horizontal é monitorada nos limites acima. Com
perfil3D inicial selecionado, a supervisão nova detecta comunicação, overflow,
repetições e envelhecimento; não conhece um módulo de campo3D certificado.
Interferência uniforme que gire o campo mantendo magnitude pode passar nesses
critérios. Precisão absoluta e detecção de toda interferência não são observáveis
apenas por essa geometria. Não há promessa de “calibrar corretamente sempre”.

Referências: [datasheet Honeywell HMC5883L, registros e overflow](https://cdn-shop.adafruit.com/datasheets/HMC5883L_3-Axis_Digital_Compass_IC.pdf),
[modelo de hard/soft iron e limites da calibração](https://www.vectornav.com/resources/inertial-navigation-primer/specifications--and--error-budgets/specs-hsicalibration).

## Testes e reprodução

Executar, sem hardware:

```
bash "/home/santojuca/.codex/.chatgpt-projects/g-p-6a91af560a788191a5216a1bb50a03a5/output/calibracao-magnetica-guiada-20261113/scripts/reproduzir-testes.sh"
```

Requer Python3 e Icarus. A referência Python usa somente a biblioteca padrão.
Treino e holdout são amostrados em ângulos diferentes; offsets/ganhos, truncamento
Q12 e atan2 são calculados independentemente do RTL. Logs em `evidencias/`.
O comando repete os testes funcionais, não a tentativa inconclusiva do MPU.

Cobertura:13 cenários (diagonal, hard iron, ruído, elipse girada, interferência XY,
interferência Z, outlier no treino, parado, arco insuficiente, ausência de melhora, validação em arco, validação concentrada
e outlier isolado na validação),
sensor ausente, perda de comunicação, stale, overflow XYZ, limites ADC, timeout,
comandos, sete segmentos, confirmação/falhas, duas aplicações e recuperação.

O teste do top usa fontes reais com modelos de BUFG/MMCM/XADC/MIG/FIFO e sinais
de sensor/gravidade injetados. Testa a integração lógica, não o PHY DDR2, clocks
analógicos, o I2C físico ou sensores reais. Só os defaults das portas input foram
removidos na cópia `tests/compat` para o Icarus; os fontes de entrega os preservam.

Regressões: heading, fusão de heading, botões, HMC I2C com modelo do escravo,
fusão de atitude, display original, modos00/01/10/11, alinhamento81° em360rumos e
publicação de vídeo com CRC/retry/POUSO no próximo avanço autorizado.
O teste de publicação foi atualizado para esse contrato existente, preservando
os testes da barreira. O loader não foi alterado.

Limites de regressão registrados:

- Driver MPU6050: Icarus excedeu120s; Verilator não suporta o `disable` daquele
  testbench. Resultado **INCONCLUSIVO**, não foi tratado como aprovado. O fonte
  é idêntico ao aprovado; fusão de atitude e isolamento no top passaram.
- Teste antigo do worktree para dispatcher: exige CAPTURE sobrepor SW4, diferente
  do contrato da base funcional, onde SW4 conserva prioridade. A mesma falha foi
  reproduzida no fonte da base. O dispatcher não foi alterado; os controles novos
  e seu isolamento foram testados separadamente e no top.

## Implementação e limites físicos

Nenhuma constraint foi relaxada. A primeira tentativa reprovou setup em−1,510ns
no cálculo de comparação de métricas. Fontes/checkpoint/relatórios foram mantidos
em `evidencias/fontes-tentativa1/` e `resultado-timing-negativo/`. Foi acrescentado
pipeline ao cálculo novo; a segunda implementação é a de `resultado/`.
Consulte `resultado-final.json` para timing, recursos e DRC/CDC finais.
Os avisos CDC históricos e o timing externo SPI não são automaticamente resolvidos.

Para repetir o build em outra pasta, sem sobrescrever os resultados:

```
bash "/home/santojuca/.codex/.chatgpt-projects/g-p-6a91af560a788191a5216a1bb50a03a5/output/calibracao-magnetica-guiada-20261113/scripts/reproduzir-build.sh"
```

## Validação física posterior

Somente depois de um candidato identificado e uma autorização separada para JTAG:

1. Verificar boot/perfil inicial e `HDG BAD` quando pertinente, sem girar. Não é
   necessário recalibrar a cada ligação. A normalização magnética não é um GPS.
2. Entrar conforme interface e executar dois giros horizontais de10–20s, sem
   medir graus durante a coleta. Aplicar apenas se surgir `APtO 2d`.
3. Comparar em quatro direções de referência e retornar à primeira. Usar a mesma
   referência física para o eixo da caixa e do celular, sem encostar o telefone
   no sensor. Conferir se o celular mostra norte magnético ou verdadeiro; não
   compensar a declinação misturando as duas referências.
4. Inclinar moderadamente: confirmar retorno ao perfil3D e horizonte intacto.
   Essa etapa testa o caminho existente; não valida uma calibração3D nova.
5. Repetir a observação em outro ambiente. Desvio constante sugere alinhamento/
   referência; erro que varia com rumo sugere distorção; erro que aparece ao inclinar
   exige investigar compensação/orientação; alteração ao mudar de posição sem
   girar sugere ambiente. Comunicação/ID inválidos, overflow persistente ou ausência
   de atualizações apontam outro tipo de falha. São hipóteses a distinguir, não
   diagnósticos automáticos de causa raiz.
6. Usar BTNU para restaurar intencionalmente o perfil anterior e verificar a volta.
   Conferir vídeo, roll/pitch e modos no ensaio. Não escrever Flash/SD nesta etapa.

Aceite magnético físico e precisão absoluta continuam **NÃO VALIDADOS**.

## Resultado medido da segunda implementação

Vivado2026.1: **WNS+0,070ns, WHS+0,019ns, TNS/THS zero**. DRC:zero erros e180
avisos. CDC:3 CDC-10,1 CDC-8,176 CDC-15, pendentes. Zero endpoints internos sem
constraint. O timing externo SPI continua não qualificado.

Utilização roteada:22.684LUTs (35,78%),16.800FFs (13,25%),82DSPs (34,17%),64tiles
BRAM (47,41%). Diferença para a base:+1.896LUTs,+1.233FFs,+12DSPs, sem aumento
BRAM. O fechamento interno não comprova comportamento físico nem precisão magnética.
Não foi gerado BIT. As funções novas ainda não estão na placa.
