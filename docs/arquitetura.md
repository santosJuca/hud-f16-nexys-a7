# Arquitetura do HUD

O [top_reticula](../rtl/top_reticula.sv) conecta aquisição, estimadores e desenho.
O diagrama geral está no [README](../README.md#arquitetura). Esta página descreve
as interfaces atuais; não propõe uma reorganização do RTL.

## Aquisição e estimadores a 100 MHz

| Cadeia | Módulos e responsabilidade |
| --- | --- |
| Atitude | `mpu6050_i2c` publica XYZ de accel/gyro; `atitude_accel_fixa` trata a referência acelerométrica; `gyro_bias_dt` calibra bias e mede intervalo; `gyro_integrador`, `atitude_fusao_complementar` e `atitude_gyro_hud` integram, corrigem e convertem para o desenho |
| Heading | `hmc5883l_i2c` → `heading_magnetico` (CORDIC plano); `heading_fusao` combina a referência com gyro Z corrigido e o intervalo medido |
| Vertical | `projecao_vertical` usa accel XYZ e atitude; `estado_vertical` remove gravidade/bias, integra e corrige com altitude barométrica |
| Barômetro | `bmp085_i2c` lê identificação, coeficientes e amostras; compensação sequencial calcula temperatura/pressão; `bmp085_altitude` fornece altitude barométrica |
| Velocidade | `velocidade_inercial` integra aceleração longitudinal; saída estimada e sujeita a drift |
| Manche | `joystick_xadc` lê VAUX3/10; `controle_manche` calibra centro e gera pitch/roll; `controle_modo_manche` alterna a fonte pelo botão |
| Controles | `controle_heading` mantém rumo manual; switches fornecem atitude de fallback e modos visuais |

As instâncias reais e seus parâmetros ficam no top. `mma8452_i2c` é legado e
não é a fonte de atitude instanciada. Os três sensores I²C usam barramentos
separados; não há arbitragem de um barramento compartilhado.

Aritmética, convenções de eixos e limites estão em [fusão](fusao_sensores.md).
SENSOR/MANCHE altera apenas a atitude **exibida**. A projeção vertical usa a
atitude do MPU, nunca comandos do manche.

## Seleção e falhas

| Estado | Seleção atual | Limite de interpretação |
| --- | --- | --- |
| Pitch/roll | MANCHE: joystick; SENSOR: fusão MPU utilizável; senão switches | Sensor identificado sozinho não basta: calibração e fusão precisam estar válidas |
| Heading | Fusionado válido → magnético válido → manual | Só a fusão exige referência magnética recente por watchdog de 0,5 s; fallback magnético conserva a validade anterior do driver/CORDIC |
| Altitude | Estado vertical após primeira referência; senão barômetro disponível; senão 36000 FT | A altitude do estado pode ser retida após perda do sensor; retenção não significa medição atual |
| Velocidade | Inercial válida → 280 KT demonstrativos | Não é airspeed nem estimativa corrigida por GPS |
| VSI | Saída interna `vel_vertical_fpm` com `vertical_valido` | Ainda sem consumidor visual; pode ser otimizada na síntese |

Sem barômetro válido, o estado vertical retém altitude, zera/invalida VSI e
interrompe integração. Sem MPU válido, mantém correção barométrica suave.
Recuperação e recalibração estão detalhadas no documento da fusão. Os fallbacks
numéricos ainda não possuem identificação completa de fonte/idade na tela.

## Transferência e desenho a 25 MHz

`entrada_hud` transporta 57 bits atomicamente com requisição/confirmação. Não é
uma FIFO de todas as amostras: o top mantém `valido=1` e envia o conjunto mais
recente quando a ponte está pronta. `dados_hud` satura os campos e publica o
buffer em x=0, y=480, fora da região ativa. Consulte o [contrato de dados](entradas_hud.md).

`vga_controller` divide o clock de 100 MHz por quatro e conta 800×525 posições por quadro,
das quais 640×480 são ativas. Assim, o modo atual usa 25 MHz e cerca de 59,52 Hz.
Os clocks são relacionados e declarados no XDC. Não foi criado false path global
entre aquisição e pixel. As exceções existentes para controles assíncronos não
justificam exceções em um futuro barramento de pixels.

Retículo, horizonte/escada, escalas, heading, números e alvo geram máscaras.
O top escolhe as máscaras ORIGINAL/CAÇA e oculta extras em DECLUTTER. O RGB atual
é combinado por canal: retículo tem prioridade, há elementos verdes, alvo vermelho
e um quadrado de status MPU verde/vermelho em NORMAL. Azul fica zero. Sobreposições
podem combinar canais; um compositor futuro deverá preservar a intenção das cores.
Esse quadrado reflete `sensor_ok` do MPU, não a confiança de toda a fusão.

Não há framebuffer, entrada externa ou `video_compositor` separado no design
atual. A [proposta de vídeo auxiliar](vga_auxiliar.md) define essas interfaces como
trabalho futuro. Nenhum módulo, porta ou constraint foi alterado nesta revisão.
