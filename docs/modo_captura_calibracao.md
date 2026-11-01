# Captura e calibração visual

## Controles sem novos pinos

| Controle | Reprodução | Captura |
|---|---|---|
| BTNL curto, ação após soltar | Alterna vídeo/fundo preto | Solicita avanço de um quadro |
| BTNL segurado por aproximadamente 1 s | Entra na captura | Sai e retoma reprodução |
| SW5:SW4 | Página microSD, preservada | Página microSD e vista 0..3 |
| SW6 | Página microSD, preservada | Acrescenta grade fixa |
| SW7, borda 0→1 | Página microSD, preservada | Solicita zero temporário, condicionado ao repouso |

SW4..SW7 são `SD_DIAG_PAGE[3:0]`; a seleção dos sete segmentos continua funcionando inclusive durante captura. O uso adicional fica restrito à captura. Para pedir zero, deixe SW7 inicialmente em 0 e eleve explicitamente depois de nivelar e imobilizar a caixa. Entrar com SW7 já alto não gera comando de zero. Os demais controles mantêm suas funções anteriores.

Vistas de SW5:SW4: `00` vídeo puro; `01` vídeo+HUD; `10` vídeo+HUD+grade; `11` vídeo+HUD+diagnóstico. SW6 permite acrescentar a grade em qualquer vista. A vista pura retira também o ícone microSD; se SW6 estiver ligado, mostra a grade solicitada. A grade tem eixos centrais, cruz fixa, marcas de pitch a cada 40 px e referências de bank 0/±30/±60/±90°. A escala móvel de pitch mantém seus números angulares.

Um toque durante captura mantém uma solicitação pendente. Aguarde a identificação de quadro mudar antes de tocar novamente; pedidos feitos enquanto o anterior está pendente podem ser agrupados. O botão tem sincronização e debounce. Segurar BTNL não executa também a ação curta ao soltar.

## Congelamento

`video_captura` sincroniza captura e toggle de passo no domínio VGA. Somente permite `rd_frame_start` no blanking quando há reprodução, um passo pendente ou ainda não há primeiro quadro válido. A primeira imagem íntegra pode ser publicada mesmo se a captura foi solicitada antes dela existir.

A escrita continua apenas no banco traseiro. Uma transação CMD17 em andamento termina normalmente, com CRC e tratamento de erros preservados. O próximo quadro íntegro pode ficar preparado no banco traseiro; o handshake impede sua reutilização enquanto não for publicado. O sensor e a simbologia continuam atualizando.

A identificação `FRAME HEX` é o contador de publicações visíveis, começando em zero; `FFFFFFFF` significa que ainda não houve publicação. Não é o contador de quadros carregados. Para o arquivo atual, o índice no arquivo é esse contador módulo 578, desde uma inicialização sem troca de arquivo. Não há pulos voluntários nem busca aleatória nesta etapa.

Um passo autoriza exatamente uma troca completa de banco. Se o próximo quadro falhar, o atual permanece; as tentativas continuam conforme a política já existente. Erro definitivo não publica dados parciais. Sair da captura libera a próxima troca no blanking.

Não foi acrescentado framebuffer. Cada quadro útil de 160×120×8 ocupa 153600 bits (19200 bytes); dois quadros úteis ocupam 38400 bytes. O buffer existente usa bancos com profundidade potência de dois: 2×32768 bytes, 524288 bits, mapeados em 16 RAMB36 nesta implementação. O ícone e sua referência usam outras duas RAMB18. A Artix-7 do projeto possui 135 blocos RAMB36; a captura reutiliza a memória existente. O perfil 320×240 mantém bancos de 131072 bytes e seu custo anterior de 64 RAMB36.

## Diagnóstico

O painel usa hexadecimal exato de 32 bits para evitar perda de resolução:

| Linha | Conteúdo |
|---|---|
| RAW R/P Q10 | Roll/pitch do estimador antes do zero angular |
| COR R/P Q10 | Roll/pitch após o zero temporário |
| RENDER Q10 | Ângulo efetivamente enviado ao CORDIC de renderização |
| HORIZ X/Y PX | Ponto central do horizonte ao longo de sua normal |
| MPU CAL HEX | Bits 0 calibrado; 1 repouso; 2 zero aceito; 3 zero recusado; 4 atitude válida; 5 sensor identificado |
| VIDEO HEX | Bits 3:0 estado do loader; bit 4 falha |
| FRAME HEX | Contador de quadros publicados, base zero |

Ângulos são complemento de dois, 1024 unidades por grau. Exemplos: +90°=`00016800`, -90°=`FFFE9800`, +10°=`00002800`. Coordenadas são inteiros assinados em pixels. Não são leituras angulares diretamente do acelerômetro sem fusão: “RAW” distingue o estimador antes da referência angular temporária.

A versão de diagnóstico de sensores acrescenta um segundo painel, à direita, na mesma vista `11`. A calibração e a aquisição mantêm seus critérios. Os seis eixos vêm das amostras publicadas pelo driver, transferidos pelo mailbox e apresentados somente após o blanking:

| Linha à direita | Conteúdo |
|---|---|
| ACC X/Y/Z HEX | Aceleração bruta assinada de 16 bits, estendida para 32 bits; escala configurada de 16384 counts/g |
| GYR X/Y/Z HEX | Giroscópio bruto assinado de 16 bits, estendido para 32 bits; escala configurada de 131 counts/(°/s) |
| MAG ID HEX | Últimos três bytes de identificação lidos sem NACK; `00483433` corresponde a H43; zero até a primeira leitura completa |
| MAG IO HEX | Estado de comunicação descrito abaixo |
| CAL CNT HEX | Quantidade atual de amostras consecutivas aceitas, até 64; zero após calibração |
| CAL BLK HEX | Motivos acumulados de rejeição desde o reset; zero após calibração |

Em `MAG IO HEX`, bit 0 é SDA alta e bit 1 é SCL alta, observadas no instante do snapshot, inclusive durante transações. Bits 3:2 registram o resultado da última transação concluída: 0 sem erro de ACK/timeout, 1 NACK, 2 timeout. Bit 4 indica que houve leitura completa de identificação desde a configuração da FPGA; não garante que o sensor continue conectado. Bit 5 indica o estado operacional do driver. Bits 7:6 identificam a etapa do NACK: 0 endereço de escrita; 1 registrador; 2 dado de escrita; 3 endereço de leitura após repeated START. A etapa só tem significado quando bits 3:2 indicam NACK. Um ID incorreto pode ter erro de comunicação zero e estado operacional zero; o driver continua exigindo H43.

`MPU CAL HEX=00000020` significa sensor reconhecido, ainda sem calibração nem atitude válida no snapshot. Para localizar a condição de espera, conferir `CAL BLK HEX` com o sensor imóvel e nivelado. Seus bits são: 0/1/2 variação de ACC X/Y/Z acima de 64; 3/4/5 módulo de GYR X/Y/Z acima de 1310; 6/7/8 faixa máximo−mínimo de GYR X/Y/Z acima de 262; 9/10 ACC X/Y fora do nível; 11 ACC Z fora da faixa; 12 perda de sensor ou amostras após iniciar a aquisição. Os motivos são acumulados até calibrar ou reiniciar: movimento anterior também deixa marca. Os bits usam os eixos compensados da montagem, enquanto ACC/GYR HEX preservam os valores brutos nativos do chip. O contador mostra o progresso atual e volta a zero a cada rejeição. O critério corrigido exige 64 amostras consecutivas, variações de aceleração de até 64 counts por eixo, |ACC X/Y| <1400, 15564 <ACC Z<17204, |GYR X/Y/Z| ≤1310 durante a calibração e faixa máximo−mínimo ≤262 counts por eixo na janela inteira. Depois de medir o bias, o limite de repouso continua ±131 counts corrigidos. Ver a justificativa e as condições em `simulador_manual_atitude.md`. A instrumentação não corrige a causa nem comprova o funcionamento físico.

Interpretação: RAW errado indica montagem, calibração ou estimação; COR divergente de RAW indica zero aplicado; RENDER diferente pode indicar seleção manual ou latência de amostra; ângulos corretos com horizonte incorreto indicam geometria. A falta de coincidência com o vídeo pode ser enquadramento/FOV da câmera. O diagnóstico fica restrito à captura.

## Roteiro

1. Selecione o MPU e espere calibração válida, com caixa nivelada e imóvel.
2. Mantenha o vídeo habilitado, segure BTNL por 1 s e solte. O fundo deve parar.
3. Selecione vista `01` e incline a caixa; somente o HUD deve se mover.
4. Selecione `10` ou ligue SW6. Compare a referência fixa com a escala móvel.
5. Selecione `11`. Confira RAW/COR/RENDER e o ponto central calculado.
6. Nivele, aguarde repouso, coloque SW7 em 0 e depois em 1. O zero só é aceito próximo do nível.
7. Toque BTNL e aguarde exatamente uma mudança de `FRAME HEX`.
8. Segure BTNL novamente para retomar o vídeo. O handshake do sensor permanece independente.

A geometria é matematicamente válida em roll ±180°. Isso não garante que todos os segmentos permaneçam dentro do raster para qualquer pitch, nem fornece atitude confiável sob acelerações arbitrárias. A validação óptica e física permanece separada da simulação.

## Montagem reposicionada em 30/10/2026

O usuário informou MPU 90° à esquerda e magnetômetro 90° à direita, no plano e com a mesma face para cima. O perfil `mpu-left90-mag-right90` interpreta esquerda/direita vistas de cima, em relação à posição anterior: MPU `(X,Y,Z)=(-Y_bruto,X_bruto,Z_bruto)` para aceleração e velocidade angular; HMC `(X,Y)=(Y_corrigido,-X_corrigido)`, após offsets e ganhos nos eixos nativos. O barômetro mantém a configuração. A negação de −32768 no MPU satura em +32767, evitando overflow.

O perfil precisa ser passado explicitamente ao build; o padrão mantém a montagem original. O painel de valores brutos não é girado. O giro no plano não corrige NACK de I²C e não deveria impedir a calibração nivelada. Os offsets e ganhos magnéticos anteriores foram preservados para comparação, mas a mudança de localização exige reavaliar a calibração magnética depois de recuperar a comunicação. O sentido físico do horizonte e do rumo ainda depende de verificação na bancada.

## Filtro interno do MPU

A aquisição passa a escrever CONFIG (`1A`)=`05`, DLPF próximo de 10 Hz. Para WHO_AM_I `70`, também escreve ACCEL_CONFIG2 (`1D`)=`05`, pois esse modelo usa configuração separada para o acelerômetro; para ID `68`, não escreve `1D`. Há espera de 100 ms após a última configuração de filtro antes da primeira leitura. Qualquer NACK mantém o sensor inválido e reinicia identificação/configuração. As faixas ±2g e ±250°/s, os limiares de calibração, os eixos compensados e a publicação atômica após STOP são preservados. O filtro introduz atraso nas amostras; no MPU6050 a tabela oficial informa cerca de 14 ms para DLPF5.

A falta dessa configuração foi confirmada no driver anterior; sua contribuição para a rejeição na bancada é uma hipótese baseada na máscara de variação e nas leituras niveladas. Simulação do protocolo não mede redução de ruído real. Esta alteração ainda precisa de implementação aprovada e validação física.

Referências: [mapa TDK MPU6050](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf), [identificação TDK MPU6500](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6500-Register-Map2.pdf) e implementação original da [Bolder Flight Systems](https://github.com/bolderflight/invensense-imu/blob/main/src/mpu6500.cpp), cujo [cabeçalho](https://github.com/bolderflight/invensense-imu/blob/main/src/mpu6500.h) define CONFIG=1A, ACCEL_CONFIG2=1D e filtro de 10 Hz=05. Essa referência de implementação não identifica o módulo físico do usuário.
