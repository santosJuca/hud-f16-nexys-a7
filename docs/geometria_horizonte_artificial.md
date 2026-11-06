# Geometria do horizonte artificial

## Causa encontrada em 30/10/2026

O baseline é o commit `0271499a8538135abc6291e512b421382337c7c2`, branch `feat/video-sd-overlay`, com alterações locais anteriores preservadas. A regressão `validation/test-video-20261030-160851.log` confirma os seis cenários informados pelo usuário. O aceite físico do vídeo em 30/10 foi informado pelo usuário; a documentação antiga ainda descreve etapas anteriores ao aceite.

O problema atravessava quatro módulos:

- `atitude_accel_fixa`: subtraía uma referência inicial X/Y, filtrava com IIR 1/4, convertia linearmente e saturava pitch em ±80 px e roll em ±128. Z não participava da atitude. Um seno não diferencia inclinações complementares nem identifica o voo invertido.
- `atitude_fusao_complementar`: somava incrementos independentes de gyro X/Y e corrigia 1/32 do erro contra essa referência limitada. Integrar os eixos como ângulos Euler independentes também é incorreto em movimentos combinados.
- `atitude_gyro_hud`: aproximava `roll_q8 = roll_q10*1144/2^18`, limitado a ±128. O coeficiente visual máximo era 0,5, equivalente a uma reta de apenas 26,565°. Não havia divisão por cosseno: a saturação e a aproximação explicam o aparente travamento antes de 90°.
- `simbologia_vga`: usava `u=x-k*y`, `v=y+k*x`, com origem em `(320,horizonte_y)`. A matriz tem ganho `sqrt(1+k²)`, não é uma rotação ortonormal e mantém o deslocamento de pitch vertical na tela mesmo com bank.

`dados_hud` ainda limita a representação legada a roll ±128 e horizonte Y 80..400. O novo caminho de geometria contorna esses campos limitados e transmite os ângulos e coeficientes verdadeiros. Esses campos continuam disponíveis para compatibilidade. A escala existente usa 40 px por 10°, marcas até ±40°, traços positivos contínuos e negativos tracejados. As duas retículas são fixas. `simbologia_caca_vga` desenha informações laterais e heading; a escada de ambos os estilos vem de `simbologia_vga`.

## Equações implementadas

Coordenadas VGA: X cresce à direita e Y cresce para baixo. Roll positivo significa asa direita para baixo; pitch positivo significa nariz para cima. Para `x=X-320`, `y=Y-240`, `s=sin(roll)`, `c=cos(roll)` e `p=4*pitch_graus`:

```
u = c*x - s*y
v = s*x + c*y - p
horizonte: v = 0
marca de +a graus: v = -4*a
```

A forma paramétrica equivalente é:

```
X = 320 + t*c + p*s
Y = 240 - t*s + p*c
```

O vetor direcional é `(c,-s)` na tela. A normal é `(s,c)`. O horizonte gira no sentido oposto ao banco da aeronave. Em +90° fica vertical em `X=320+p`; em -90°, `X=320-p`. Em 180° a normal muda de sentido continuamente e as marcas de pitch acompanham a inversão. O ponto de referência da aeronave permanece em `(320,240)`.

O centro diagnóstico deve, portanto, ser `X=320+p*s`, `Y=240+p*c`. Não confundir esse ponto com a interseção da reta com a coluna central, que pode não existir em 90°.

A escada inteira, inclusive os números, recebe as mesmas coordenadas locais. Barras laterais, heading, retícula, mira e alertas mantêm seus referenciais próprios. O clipping é o raster visível 640×480; o horizonte tem dois segmentos locais de 20 a 220 px, com vão central. Não há clipping angular em 90°. Pitch continua limitado visualmente a ±40° (160 px), preservando a escala anterior; o estimador não usa esse limite para calcular roll.

## Ponto fixo e recursos

`atitude_cordic` compartilha o método CORDIC sequencial já usado pelo heading, com 16 microrrotações. Ângulos: graus Q16 internamente e Q10 nas interfaces de atitude. Seno/cosseno: Q14 assinado, 1=16384. Produtos de coordenadas usam 27 bits, somas 28 bits e coordenadas locais 22 bits assinados. Os extremos do raster e de roll não ultrapassam essas larguras.

CORDIC foi escolhido para cobrir todos os quadrantes sem ROM de grande resolução e reaproveitar a técnica existente. Uma LUT seria viável; divisão por cosseno e ponto flutuante não são necessários. O cálculo trigonométrico ocorre a 100 MHz, fora do caminho por pixel. A rasterização usa quatro multiplicações de coordenadas por coeficientes estáveis durante o quadro.

A escala de 4 px/° é uma projeção angular didática. Não constitui calibração óptica: uma câmera perspectiva possui FOV, posição e possível movimento de cabeça próprios. Sem esses dados não é correto prometer coincidência pixel a pixel com o horizonte gravado.

## Clock e atualização

O VGA preserva 25 MHz, 800×525 totais, 59,524 Hz e sincronismos ativos baixos. `entrada_hud` usa mailbox com pedido/ACK de toggle e barramento retido até confirmação. O novo mailbox de atitude segue esse protocolo; os coeficientes e pitch da renderização são publicados juntos. No domínio VGA, uma amostra pendente só é aplicada em X=0,Y=480.

Os novos limites de CDC estão em `constraints/attitude_capture.xdc`: max delay 20 ns e bus skew 10 ns para o barramento retido, false path apenas ao primeiro estágio dos sincronizadores. A pinagem e o orçamento externo SPI não foram alterados.

O filtro antigo acrescentava o IIR 1/4 e uma correção complementar 1/32, aproximadamente 0,38 s de constante de tempo para 11,745 ms por amostra. O caminho novo propaga o gyro em cada amostra, corrige o vetor gravitacional em 1/32 e aplica a imagem no próximo blanking. O cálculo vetorial leva menos de 1 µs e o trigonométrico leva aproximadamente 0,2 µs, além dos handshakes. A aquisição I2C e até um período VGA dominam a resposta. Esses números não substituem medição de latência na placa.

Consulte `simulador_manual_atitude.md` para testes e qualificação do build.
