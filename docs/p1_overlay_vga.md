# P1: preparacao de mascara do HUD para overlay VGA

## Escopo desta primeira etapa

A branch `feat/p1-hud-overlay-mask-20261019` introduz a mascara logica do HUD e
um controle de selecao de video *sem alterar* os pinos, o XDC, o clock, o
bitstream publicado ou a composicao RGB atual.

Esta etapa **NAO** implementa sobreposicao de video externo funcionando na placa.
Nao ha entrada RGB analogica, interface de sincronismo externa, clock de pixel
recuperado, seletor analogico nem pino de controle no top fisico.

## Implementacao

- `rtl/hud_pixel_mask.sv`: `mask_on=1` somente dentro da area ativa e quando
  uma camada visivel do HUD ocupa o pixel.
- `rtl/top_reticula.sv`: instancia a mascara como **sinal interno**
  `hud_mask`, derivado das mesmas flags usadas pelo compositor RGB; nenhum
  valor RGB nem conexao preexistente foi alterado.
- `rtl/hud_video_switch_ctrl.sv`: bloco independente, ainda **nao instanciado**
  no top, que calcula um futuro `select_hud` somente quando
  `overlay_enable && sync_locked && external_video_active && mask_on`.
  Sua saida nao esta conectada a hardware.
- `tests/tb_hud_pixel_mask.sv`: todas as 1024 combinacoes dos 10 bits de
  condicao, incluindo modos, camadas, DECLUTTER e blanking.
- `tests/tb_hud_video_switch_ctrl.sv`: 16 combinacoes de habilitacao, lock,
  area ativa externa e mascara, garantindo bypass logico sem lock.
- `tests/tb_top_hud_mask.sv`: amostras de pixels do top existente com
  NORMAL/CAÇA, com/sem DECLUTTER, e blanking. Confere que RGB nao preto
  implica mascara ativa. Preserva `tests/tb_vga.sv` e demais regressao.

### Regras de visibilidade

A mascara considera, com prioridades iguais as do compositor original:
alertas, mira CAÇA, reticula visivel, marcador do estilo original, horizonte,
status do MPU e dados complementares. Os extras e o status sao ocultados por
DECLUTTER; o horizonte e a reticula permanecem. O marcador original fica
oculto no estilo CAÇA. O indicador do sensor so e mostrado fora de DECLUTTER.
A mascara representa **ocupacao**, nao `RGB != 0`: futuramente poderemos
renderizar pixels pretos opacos.

O bloco nao adiciona fundo opaco, nem permite que o RGB do HUD substitua
toda a area ativa. Em pixels `mask_on=0`, a futura chave analogica deve
preservar o RGB externo.

## Problema de sincronismo ainda nao resolvido

O controlador atual usa `100 MHz / 4 = 25 MHz` e varredura 800x525,
produzindo cerca de **59,52 Hz**. Uma fonte VGA 640x480 a 60 Hz
convencional frequentemente usa **25,175 MHz**; nem fonte com a
mesma resolucao garante fase e temporizacao identicas.

**Nao** usar HS/VS externo apenas para resetar os contadores enquanto a
renderizacao corre no clock livre interno de 25 MHz. Nao proporciona
alinhamento estavel por pixel: frequencia e fase podem divergir.

Para avancar a P1 com hardware, primeiro especificar e validar:

1. Formato/timing real da fonte (clock nominal, HS/VS, polaridades,
   front/back porch, tolerancias, video ativo).
2. Como obter **clock de pixel coerente com a fonte**. VGA analogico
   transporta HS/VS, mas nao disponibiliza clock de pixel dedicado;
   so HS/VS nao garantem fase subpixel. Avaliar geracao travada em linha
   /PLL externo ou estrategia quantitativamente validada com clock
   de referencia superior, tempo de setup da chave e tolerancia de erro.
3. Contadores de raster sincronizados ao video externo e `sync_locked`
   validado antes de habilitar a mascara.
4. CDC seguro entre aquisicao de sensores a 100 MHz e dominio externo
   do pixel, preservando o pacote atomico e troca apenas em fronteira de
   quadro. Rever `entrada_hud` e `dados_hud` com os novos clocks.
5. Chave RGB analogica adequada para **3 canais RGB de video**, bandas,
   nivel 0-0,7 V sobre 75 ohms conforme fonte e terminacoes,
   ausencia de contencao entre DAC do HUD e fonte externa, tempos de
   comutacao e controle de transitorios.
6. Passar HS/VS externos ao monitor por caminho definido. Nao combinar
   RGB da fonte externa com HS/VS free-running da FPGA.
7. Comportamento na ausencia de sincronismo: selecao da entrada
   externa por padrao e desabilitacao do overlay. Nao alegar fail-safe
   fisico sem analisar alimentacao e comportamento da chave.
8. **Prototipo independente** antes de qualquer conexao a Nexys:
   confirmar eletricamente sinais de entrada/saida e integridade VGA
   com instrumentos apropriados.

## Portoes de liberacao

- P1.1: modulo de mascara implementado e testado na branch; regressao
  CI verde e revisao de codigo antes de merge.
- P1.2: timing externo, interface de sincronismo e circuito analogo
  desenhados a partir de componentes e documentacao verificaveis.
- P1.3: testes de sintetizacao/temporizacao, CDC e verificacao de
  raster com clocks nao identicos e perda/retorno de sync.
- P1.4: validacao eletrica e visual de bancada. So depois gerar
  bitstream dedicado e mapear uma saida `select_hud` fisica.

O **P0** (faixa eletrica do KY-023 nas entradas VAUX3/VAUX10) permanece
pendente de multimetro; este P1 nao modifica nem permite contornar
essa verificacao.
