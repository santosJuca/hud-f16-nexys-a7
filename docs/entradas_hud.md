# Entradas do HUD

O topo conserva os pinos existentes. O ponto de substituição da simulação é a
instância `u_entrada`, em `rtl/top_reticula.sv`. Não acrescente os barramentos abaixo
ao topo físico: eles são conexões internas entre o processamento e o display.

| Entrada de dados_hud | Formato | Significado |
| --- | --- | --- |
| velocidade_kt_in | unsigned [9:0] | Nós inteiros, limitado a 0..999 |
| altitude_ft_in | unsigned [16:0] | Pés inteiros, limitado a 0..99999 |
| pitch_px_in | signed [10:0] | Deslocamento vertical do horizonte, limitado a -80..80 pixels |
| roll_q8_in | signed [9:0] | Inclinação em pixels por 256 pixels horizontais, limitada a -128..128 |
| dados_validos | 1 bit | Amostra completa disponível na borda de clk |
| clk | 25 MHz | Mesmo clock de pixel do display |

Um pitch positivo desloca o horizonte para baixo (convenção de nariz para cima).
Roll positivo representa banco positivo da aeronave. A referência de horizonte
é desenhada com rotação visual oposta: `roll_q8=64` corresponde à inclinação
1/4 e, com horizonte centralizado, em x=192 a linha fica 32 pixels abaixo do
centro e em x=448 fica 32 pixels acima. Esse sinal não é
um ângulo em graus. O desenho usa inclinação linear, não rotação rígida de todos
os símbolos. As marcas acompanham a linha, e as escalas/números ficam verticais.

A última amostra válida fica em um buffer. O conjunto inteiro passa ao desenho
em x=0, y=480, preservando o quadro. Uma amostra que coincide com essa borda fica
para o quadro seguinte. Sem novas amostras, mantém-se o último conjunto; não há
alarme de dados vencidos nesta versão.

## Caminho atual do sensor

O caminho ativo utiliza `mpu6050_i2c.sv` para obter aceleração e velocidade
angular dos seis eixos a 100 MHz. O antigo `mma8452_i2c.sv` permanece apenas como
arquivo legado e não é o mestre I²C utilizado pelo `top_reticula` atual.

A ligação correta é:

```text
leitor do sensor a 100 MHz
  -> calibração, orientação dos eixos e estimativa de pitch/roll
  -> conversão para deslocamento em pixels e inclinação Q8
  -> entrada_hud: transferência de uma amostra completa para 25 MHz
  -> u_dados -> máscaras e números -> compositor VGA
```

A ponte `entrada_hud.sv` já transfere uma amostra completa de 100 para 25 MHz
com requisição e confirmação. Para trocar a simulação, altere `.dados` e `.valido`
de `u_entrada`. A transferência atual inclui velocidade, altitude, pitch, roll e heading,
totalizando o conjunto atômico utilizado pelo HUD. Consulte `rtl/entrada_hud.sv`
para a concatenação versionada e suas larguras. Esses sinais devem ser síncronos ao clock de
100 MHz. A amostra é aceita quando valido e entrada_pronta estão em 1 na borda.
Se usar um pulso, aguarde entrada_pronta; se mantiver valido em 1, a ponte captura
sucessivamente o conjunto mais recente. Não envie um pulso isolado enquanto
entrada_pronta está em 0. O barramento retido permanece estável até a confirmação.

`dados_hud` é a etapa interna a 25 MHz: recebe a amostra transferida, aplica os
limites e só publica o conjunto no início do blanking. Os clocks atuais são
relacionados pelo divisor e continuam cobertos pelo XDC, sem false path global.
A calibração e a estimativa de atitude estão implementadas na cadeia atual.
Os eixos brutos não são ligados diretamente a pitch e roll: passam por
calibração, correção do giroscópio, integração e fusão antes da conversão para
as unidades usadas pelo HUD.

O giroscópio fornece velocidade angular, não ângulo pronto. Aceleração bruta
inclui gravidade. Velocidade do avião em nós e altitude em pés precisam de uma
fonte própria ou de um estimador apropriado; nesta versão continuam simuladas.

## Números exibidos

Os valores atuais iniciais são 280 KT e 36000 FT, na parte inferior das escalas.
As oito marcas têm passo de 20 KT à esquerda e 200 FT à direita, com referência
no centro vertical y=240. Os rótulos de cima para baixo são 350..210 KT e
36700..35300 FT. O centro está entre duas marcas, como na geometria existente.
A fonte 3x5 é ampliada duas vezes, com supressão de zeros à esquerda. Rótulos
fora da faixa ficam vazios; os valores atuais são saturados por dados_hud.

SW12/SW13 continuam escolhendo horizonte acima/abaixo/centralizado. Na fonte
simulada, SW14/SW15 selecionam roll negativo/positivo; ambos iguais dão roll zero. O retículo é verde fixo e SW0 seleciona o modo de exibição.

## Verificar

Execute `bash scripts/test.sh`. Os testes cobrem dez glifos, composição decimal,
espaçamento, limites numéricos, transferência entre clocks, buffer de amostras, mudança entre quadros,
pitch, roll positivo/negativo e preservação das escalas. O teste integrado gera
`build/hud.ppm`. Gere um novo bitstream e confira leitura dos números no monitor.
