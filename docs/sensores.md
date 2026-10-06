# Sensores, controles e significado das medições

As ligações e tensões estão no [mapa de pinagem](pinagem.md). Os valores abaixo
vêm dos drivers e das instâncias atuais, não de uma calibração feita nesta revisão.
A montagem da fusão está **PENDENTE DE VALIDAÇÃO FÍSICA**.

| Componente | Interface e dados atuais | Uso |
| --- | --- | --- |
| MPU6050 | I²C 0x68, aproximadamente 100 kHz; accel XYZ e gyro XYZ signed de 16 bits | Atitude, heading dinâmico, projeção vertical e velocidade inercial estimada |
| BMP085 | I²C 0x77; ID esperado 0x55; coeficientes de fábrica e conversões de temperatura/pressão | Altitude barométrica de referência |
| HMC5883L | I²C 0x1E; identificação H43; leitura física X,Z,Y reorganizada em XYZ | Rumo magnético estimado por CORDIC e referência da fusão |
| KY-023 | Dois canais XADC e botão ativo baixo | Comando manual proporcional e seleção SENSOR/MANCHE |

## MPU6050

O projeto usa 16384 counts/g e 131 counts/(°/s). `amostra_nova` marca o conjunto;
a integração utiliza intervalo medido em ciclos, não uma frequência presumida
constante. Calibração inicial e falhas impedem usar estimativas ainda inválidas.

A convenção documentada associa pitch a accel Y e roll a −accel X. O estado
vertical adota +Z em repouso e rejeita calibração incompatível. Gyro Z invertido
produz rumo crescente para giro horário na montagem prevista. Confirmar esses
sinais na montagem é obrigatório antes de avaliar precisão. Gyro Z sozinho é
aproximação de yaw quando a placa está inclinada.

Aceleração medida contém gravidade. A projeção vertical usa XYZ, pitch/roll e
subtração da média imóvel; a cadeia de velocidade inercial permanece separada.
Não mede airspeed. Bias, vibração, aceleração sustentada e temperatura introduzem
erro; a atitude acelerométrica também deixa de representar apenas gravidade em
manobras. Equações e limites: [fusão](fusao_sensores.md).

## BMP085

Embora o comentário inicial de `bmp085_i2c.sv` descreva um probe antigo, o top
habilita calibração, temperatura, pressão e leitura contínua. A implementação
ativa usa compensação sequencial. A documentação considera as instâncias reais,
não esse cabeçalho histórico.

`bmp085_altitude` usa P0=101325 Pa. A altitude barométrica depende da referência
de pressão e do ambiente; não é distância ao chão nem altitude geométrica medida
por GPS. O estado vertical suaviza essa referência e limita sua correção. A faixa
visual não representa toda a faixa física do sensor; altitudes negativas são
limitadas a zero pelo caminho atual.

LED4 indica a cadeia válida de identificação/conversão/pressão. Não é garantia
de exatidão ou ausência de drift. Entre conversões, a referência anterior é usada.
Não existe watchdog independente para um driver travado mantendo `sensor_ok=1`.

## HMC5883L

O cálculo atual é plano, equivalente a atan2 dos eixos corrigidos. Parâmetros
X/Y permitem offset hard-iron neutro por padrão, troca de eixos e inversão de
sinais. Não há calibração física inventada, correção soft-iron, declinação ou
compensação magnética de inclinação. O termo correto é **rumo magnético estimado**.

LED5 confirma identificação/configuração; não detecta interferência magnética.
Metais, fontes de corrente e orientação relativa ao MPU devem ser avaliados.
O driver e o CORDIC estão descritos em [HMC5883L](hmc5883l.md). QMC5883L não é
substituto direto deste driver: endereço, registradores e identificação diferem.

## KY-023 e XADC

VAUX3 e VAUX10 fornecem amostras de 12 bits. No top, X/Y são trocados na entrada
dos controles para preservar a orientação observada anteriormente: frente aumenta
X bruto e direita aumenta Y bruto. O manche calibra o centro; inicializar centralizado.
O botão alterna SENSOR/MANCHE, com sincronização e tratamento de rebote.

A tensão dos cursores precisa de condicionamento para a faixa analógica do XADC.
LVCMOS33 no XDC não torna a entrada ADC tolerante a qualquer tensão do módulo.
Conferir divisor/atenuação, alimentação, terra e polaridade dos pares antes de
energizar. LEDs0..3 indicam os quatro sentidos, não qualidade da conversão.

## Roteiro de validação física

1. Registrar revisão da placa, módulo real, alimentação, pull-ups e orientação XYZ.
2. Inicializar imóvel e aproximadamente plano; conferir calibração e sinais de atitude.
3. Girar em ambos os sentidos e cruzar o norte; comparar magnético, fusionado e manual.
4. Medir hard-iron fora de interferência; depois avaliar soft-iron e inclinação.
5. Fazer movimentos verticais conhecidos; medir ruído, retenção, recuperação e VSI.
6. Medir drift e resposta térmica em repouso prolongado; só então ajustar ganhos.

Esses passos não foram executados com a placa desligada. O [roadmap](roadmap.md)
separa esta validação das expansões de hardware.
