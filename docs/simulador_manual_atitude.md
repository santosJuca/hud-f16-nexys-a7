# Simulador manual de atitude na Nexys A7-100T

O MPU6050 já existente controla a atitude por movimentação manual. O vídeo permanece independente do sensor; não há detecção de aeronaves nem telemetria extraída da imagem. A validação física desta evolução ainda depende do usuário.

## Arquitetura

`mpu6050_i2c` continua adquirindo os seis eixos na pinagem original. `atitude_vetorial` acrescenta calibração estacionária, medição do intervalo entre amostras, propagação do vetor de gravidade pelos três giroscópios, correção complementar e conversão CORDIC para roll/pitch. Os ângulos completos alimentam os modos e alertas existentes; a renderização recebe seno/cosseno sem passar pela conversão legada limitada.

O caminho antigo permanece disponível com `FULL_ATTITUDE=0` para reproduzir os contratos históricos. O padrão do top é `FULL_ATTITUDE=1`. Os testes específicos da representação antiga selecionam explicitamente a configuração antiga; os testes novos exercitam o padrão completo. Não houve remoção dos modos SOLO/VOO/POUSO, estilos ORIGINAL/CAÇA, joystick, heading, BMP085, HMC5883L ou diagnóstico microSD.

O modelo vetorial corrige uma necessidade demonstrada pela inspeção: a fusão anterior tinha referência linear limitada e integrava eixos independentemente. Mantém-se o princípio complementar (gyro rápido, gravidade lenta), utilizando o vetor completo em vez de substituir apenas a reta.

Para aceleração em unidades do sensor:

```
g_dot = g × omega_sensor
omega_dt_Q17 = (gyro_corr * dt_cycles * 96003) >> 39   # clock 100 MHz
previsto = g + (g × omega_dt_Q17)/2^17
corrigido = previsto + (accel_corrigido*64 - previsto)/32
roll  = atan2(-g_x, g_z)
pitch = atan2(g_y, sqrt(g_x² + g_z²))
```

O vetor usa 1g=2^20, preservando seis bits fracionários em relação às contagens do sensor. Uma iteração de normalização Newton mantém seu comprimento. A magnitude para pitch vem do primeiro CORDIC, compensada pelo ganho 1/K. A subtração do produto vetorial tem estágio próprio para separar multiplicadores e somador no clock de 100 MHz. O vetor tem 24 bits assinados; os incrementos em radianos Q17 têm 18 bits, adequados aos multiplicadores 25×18 dos DSPs. São limites de representação fundamentados em |gyro corrigido|<32900 e dt≤100 ms. Todos os cálculos sintetizáveis são inteiros de ponto fixo.

O driver mantém as faixas ±2g e ±250°/s, correspondentes a 16384 LSB/g e 131 LSB/(°/s), conforme o [mapa de registradores TDK](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf). Não foi alterada a configuração I2C. Saturação física do gyro acima da faixa invalida a fidelidade do movimento e deve ser evitada na movimentação manual.

## Convenção e calibração

A montagem histórica registra: pitch positivo gera aceleração Y positiva e gyro X positivo; asa direita para baixo gera aceleração X negativa e gyro Y positivo. A transformação de eixos para o referencial aeronáutico de mão direita é:

```
X_aeronave (frente) = +Y_sensor
Y_aeronave (direita) = +X_sensor
Z_aeronave (baixo) = -Z_sensor
```

Isso é uma transformação própria, com determinante +1. Roll positivo: asa direita baixa. Roll negativo: asa esquerda baixa. Pitch positivo: nariz sobe. Pitch negativo: nariz desce. O horizonte se move no sentido oposto ao banco e para baixo, ao longo de sua normal, quando o nariz sobe. O [registro de montagem anterior](https://github.com/santosJuca/Trabalho-display-aviao-v2/blob/28e736db2b0962ae3494660a8b84944ad087d8c5/docs/montagem_caixa_mpu6050.md) descreve a orientação histórica do sensor e não comprova a montagem física atual. Confira as setas do módulo real na bancada; esta execução não observou a montagem física. A [montagem atual informada](montagem.md) tem uma caixa de madeira e uma caixa separada para a FPGA Nexys A7-100T.

Após habilitar a fonte (SW9=0), a calibração exige 64 amostras consecutivas estáveis e aproximadamente niveladas. Limites de aceleração preservados: |X| e |Y| <1400 counts, 15564 <Z<17204 e mudança de cada eixo ≤64 counts entre amostras. Antes de calcular o bias, cada gyro bruto deve ficar em ±1310 counts e a faixa máximo−mínimo de cada eixo, incluindo a amostra candidata, não pode superar 262 counts na janela inteira. Qualquer recusa zera a janela e as somas. Isso evita exigir offset já corrigido antes de medi-lo e rejeita deriva acumulada que uma comparação apenas entre amostras vizinhas não detectaria. Após a calibração, o limite de repouso permanece ±131 counts em relação ao bias medido.

O limite inicial de ±1310 counts equivale a ±10°/s na escala configurada; é uma política conservadora desta montagem, baseada no relato de GYR Y entre 1024 e 1279 counts em repouso. A [especificação MPU-6000/MPU-6050 da TDK, seção 6.1](https://product.tdk.com/system/files/dam/doc/product/sensor/mortion-inertial/imu/data_sheet/mpu-6000-datasheet1.pdf) documenta tolerância inicial de zero de ±20°/s a 25°C e escala de 131 counts/(°/s). Não se trata de alterar a faixa física do gyro nem de garantir a identidade ou conformidade do módulo real. A pose imóvel continua sendo uma condição externa de calibração: uma rotação constante em torno da gravidade pode ser indistinguível de bias com estes seis eixos. Não calibrar movimentando a caixa.

São calculadas médias X/Y/Z, preservando 1g no Z, e bias dos três gyros. São referências de uma posição conhecida, em RAM. Uma única posição não identifica todos os erros de escala, desalinhamento e seis offsets independentes de um IMU; não equivale à calibração de seis faces.

Depois da calibração, o indicador de repouso exige outras 64 amostras quietas com magnitude próxima de 1g. O comando explícito de zero só é aceito com atitude válida, repouso confirmado e roll/pitch dentro de ±5°. Ele armazena offsets angulares temporários. Um pedido recusado fica registrado no diagnóstico. Não há gravação na Flash.

A correção pelo acelerômetro só ocorre entre 0,85g e 1,15g de magnitude bruta. O gyro continua propagando durante rejeição. Acelerações lineares que ainda resultem em magnitude próxima de 1g não podem ser distinguidas da gravidade com garantia; mova a caixa girando devagar, evitando translações e impactos. Nenhum teste sintético elimina essa limitação física.

Amostra com intervalo >100 ms invalida a saída até uma referência temporal nova. Ausência de amostras por 250 ms, perda de `sensor_ok` ou desabilitação por SW9 invalida e exige nova calibração. Em pitch próximo de ±90°, roll Euler fica indeterminado fisicamente; os ensaios e a escala visual desta entrega são de pitch até ±40°, com testes exigidos até ±20°. Isso não introduz singularidade em roll ±90° ou ±180°.

Enquanto inválido, o render retorna à referência neutra e a política existente sinaliza fonte de atitude inválida.

## Operação

Para a caixa controlar o HUD: SW15..SW12=1111 e SW9=0. Os demais estados continuam selecionando os comandos manuais históricos. NORMAL e SIMULADOR MANUAL compartilham a mesma aquisição: o movimento da caixa é o estímulo físico, sem necessidade de outro estimador ou sensor.

BTNL e as visualizações de captura estão em `modo_captura_calibracao.md`. O joystick continua controlando a mira. SW0 continua declutter; SW1 continua estilo; SW3:SW2 continuam o modo operacional. BTNU/BTND continuam heading e BTNC continua ACK.

## Vídeo utilizado e limites do alinhamento

O mapa arquivado `validation/video-real-160x120-1fps/sd-map.json` identifica o arquivo de 578 quadros, 160×120, RGB332, 1 FPS, LBA 30006144, 21965 setores. Esses dados são evidência histórica, não uma nova leitura do cartão. SHA-256 do arquivo convertido: `615729d0740adc978b42fdf0a13dc4f18820109e4dd9e68ac66d137d431012d0`.

O `metadata.json` aponta para `Downloads/videos-hud/E4DvcvNDQoQ.mp4`, “Fly formation in the F-16 with the Red Arrows - Pilot View”. Foram inspecionadas imagens locais em 120 s e 300 s: a vista é do cockpit e acompanha uma grande inclinação da cena. O visual aparenta ser de simulador; isso é uma inferência, não identificação certificada da origem. Não há prova de câmera rigidamente alinhada, ausência de estabilização ou boresight conhecido. A imagem inclui grande parte do painel e seu HUD está acima do centro do quadro.

Consequentemente, alinhe primeiro os referenciais da caixa e da geometria, e depois interprete o vídeo. Não ajuste bias do IMU para compensar posição da câmera, FOV ou enquadramento. O centro `(320,240)` e a escala 4 px/° pertencem ao nosso HUD; o vídeo convertido não fornece calibração óptica para igualá-los. O avanço é por quadro armazenado de 1 s, não por quadro original de 1/60 s.

## Verificação e evidências

Backup inicial verificado de 274 arquivos, incluindo arquivos ainda não versionados: `validation/hud-attitude-20261030-172730/baseline.tar.gz`. O manifesto de hashes, o estado Git e o diff inicial estão no mesmo diretório. Os arquivos preexistentes de evidência foram preservados. A pasta sincronizada `sources/` não foi alterada.

Reprodução dos testes novos e da regressão de vídeo:

```sh
bash scripts/test_attitude_capture.sh /tmp/hud-captura-saida-nova
```

Os testes comparam resultados matemáticos e pixels efetivos, não apenas elaboração. `tb_horizonte_completo` cobre todos os ângulos solicitados, pitch combinado, números/escada pela transformação comum, linhas próximas de 90° e varredura grau a grau. `tb_atitude_vetorial` usa vetores de gravidade e taxas angulares sintéticos, incluindo movimentos combinados, bias conhecido, aceleração linear, zero recusado/aceito, perda de sensor e timeout. A integração de captura injeta a saída do estimador para isolar CDC/renderização; a aquisição física do MPU não é simulada nesse teste.

Resultados, utilização e STA finais estão em `resultado_atitude_captura_20261030.md`. A qualificação temporal externa do SPI permanece pendente. Foi gerado somente um bitstream experimental identificado, sem programação da FPGA. Não houve programação JTAG, escrita de Flash ou microSD, push, merge ou release. O arquivo não é uma liberação definitiva.
