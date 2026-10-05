# Display de avião

No estado consolidado atual, SW15..SW12 = `1111` seleciona a atitude proveniente
do MPU-6050 após calibração do acelerômetro, calibração do bias do giroscópio
e inicialização da fusão complementar. Joystick e switches permanecem como
fallback. Veja [integração e validação da atitude MPU](docs/atitude_mpu.md).

Display VGA 640×480 com retículo, horizonte deslocável e inclinado, escada de
pitch, escalas de velocidade/altitude, heading em graus com N/E/S/W e alvo fixo.
A imagem é gerada por coordenadas, sem framebuffer, a 25 MHz (aproximadamente
59,52 Hz). Pitch e roll podem ser fornecidos pelo MPU-6050 através da cadeia de
calibração, integração do giroscópio e fusão complementar. Joystick e switches
permanecem como fallback manual. Heading continua controlado pelos botões;
velocidade e altitude permanecem simuladas em 280 KT e 36000 FT.


## O que aparece na tela

| Elemento | O que significa | Como funciona neste projeto |
| --- | --- | --- |
| Retículo | Cruz de referência no centro da tela, com um vão no meio. Serve como referência de apontamento. | Fica parado e verde, mesmo quando o horizonte muda. O desenho está em `rtl/reticula_vga.sv`. |
| Horizonte artificial | Linha que representa a referência do horizonte. | Sobe, desce e inclina conforme a atitude selecionada: MPU-6050 ou fallback manual. É desenhado em `rtl/simbologia_vga.sv`. |
| Escada de pitch | Marcas que ajudam a visualizar a atitude de nariz para cima ou para baixo. | Acompanha o horizonte, com referências ±10/20/30/40. No modo MPU, a atitude vem da cadeia de estimação do sensor. |
| Escala de velocidade | Indicação à esquerda, em nós (KT). | O valor fornecido pelo projeto é fixo em 280 KT. |
| Escala de altitude | Indicação à direita, em pés (FT). | O valor fornecido pelo projeto é fixo em 36000 FT. |
| Heading (rumo) | Direção em graus, acompanhada das letras N/E/S/W. | Varia pelos botões BTNU e BTND, em passos de 10°. |
| Marcador de alvo | Símbolo que representa um alvo na demonstração. | Tem posição fixa; ainda não rastreia nem trava um alvo. |
| Indicador do sensor | Indica o estado da identificação do IMU conectado ao barramento I²C. | O caminho ativo utiliza o MPU-6050/GY-521 e sua disponibilidade condiciona o uso da atitude medida. |

**Retículo e horizonte são elementos diferentes:** o retículo é a referência
fixa central; o horizonte se desloca e inclina em relação a essa referência.

## O que cada controle da placa faz

| Controle | O que altera |
| --- | --- |
| SW0 | Seleciona NORMAL (desligado) ou DECLUTTER (ligado). |
| SW12 ligado sozinho | Move o horizonte 40 pixels para cima. |
| SW13 ligado sozinho | Move o horizonte 40 pixels para baixo. |
| SW14 ligado sozinho | Inclina o horizonte para a esquerda. |
| SW15 ligado sozinho | Inclina o horizonte para a direita. |
| BTNU | Aumenta o heading em 10°. |
| BTND | Diminui o heading em 10°. |
| SW1 a SW11 e BTNL/BTNC/BTNR | Sem função nesta versão. |

SW12 e SW13 iguais mantêm o horizonte centralizado na vertical. SW14 e SW15
iguais deixam o horizonte sem inclinação. Nenhum desses controles move o retículo.

## Modos NORMAL / DECLUTTER (RF-08)

O **SW0** seleciona o modo: desligado = NORMAL; ligado = DECLUTTER.
A entrada passa por sincronização e filtro de 10 ms; a seleção é aplicada no
início do blanking vertical. A inicialização é NORMAL, seguida da leitura de SW0.

- **NORMAL:** todos os símbolos e o indicador de identificação do sensor.
- **DECLUTTER:** retículo, horizonte com referências de pitch/roll e marcador
  de alvo. Escalas laterais, seus números, heading e indicador do sensor ficam ocultos.

Esta é a definição de itens críticos adotada para a demonstração acadêmica.
SW1..SW11 e BTNL/BTNC/BTNR ficam livres. O retículo é verde fixo;
os controles de cor foram removidos. Pitch, roll e heading funcionam nos dois modos.

## Qual arquivo controla cada parte

### Desenho da tela

| Arquivo | Responsabilidade |
| --- | --- |
| `rtl/reticula_vga.sv` | Define o formato do retículo: espessura, tamanho e vão central. |
| `rtl/simbologia_vga.sv` | Desenha horizonte, escada de pitch, escalas laterais, direção e marcador de alvo. |
| `rtl/numeros_hud.sv` | Desenha números e unidades com uma fonte 3×5 ampliada. |
| `rtl/top_reticula.sv` | Liga os módulos, combina os símbolos, define as saídas de cor e quais elementos aparecem em cada modo. |

### Controles e dados

| Arquivo | Responsabilidade |
| --- | --- |
| `rtl/controle_modo.sv` | Recebe SW0, sincroniza e filtra a entrada, e aplica o modo entre quadros. |
| `rtl/controle_heading.sv` | Recebe BTNU/BTND e calcula o heading em passos de 10°. |
| `rtl/top_reticula.sv` | Integra MPU-6050, fusão de atitude, joystick e fallback por switches; também fornece velocidade e altitude simuladas. |
| `rtl/entrada_hud.sv` | Transfere o conjunto de dados do clock de 100 MHz para o de 25 MHz com confirmação. |
| `rtl/dados_hud.sv` | Recebe os dados processados e aplica o conjunto entre quadros. |
| `rtl/mpu6050_i2c.sv` | Inicializa o MPU-6050/GY-521 e publica acelerômetro e giroscópio dos seis eixos. |
| `rtl/gyro_bias_dt.sv` | Calibra o bias do giroscópio e mede o intervalo entre amostras válidas. |
| `rtl/gyro_integrador.sv` | Integra velocidade angular utilizando o intervalo real entre amostras. |
| `rtl/atitude_fusao_complementar.sv` | Combina referência gravitacional do acelerômetro com a variação angular integrada do giroscópio. |
| `rtl/atitude_gyro_hud.sv` | Converte a atitude estimada para as unidades utilizadas pelo desenho do HUD. |

### Sinal VGA e ligação com a placa

| Arquivo | Responsabilidade |
| --- | --- |
| `rtl/vga_controller.sv` | Gera o clock de pixel, as coordenadas da imagem e os sincronismos VGA. |
| `constraints/nexys_a7_reticula.xdc` | Associa os sinais do projeto aos pinos da Nexys A7 e define as restrições de clock. |
| `scripts/build_vivado.tcl` | Cria o projeto no Vivado, inclui os arquivos RTL e gera o bitstream. |
| `scripts/program_board.tcl` | Programa a FPGA com o bitstream gerado. |

## Atitude e fallback manual

Quando o caminho MPU não está ativo, SW12 ligado sozinho posiciona o
horizonte 40 pixels acima (y=200) e SW13 ligado sozinho posiciona 40 pixels
abaixo (y=280).
No fallback manual por switches, SW12 e SW13 iguais mantêm y=240.
SW14 sozinho seleciona roll negativo e SW15 sozinho seleciona roll positivo;
SW14 e SW15 iguais mantêm roll zero. O retículo permanece fixo.

A combinação SW15..SW12 = `1111` é reservada ao modo MPU e, portanto, não é
interpretada como posição neutra dos switches. Nesse modo, pitch e roll são
obtidos pela cadeia de calibração, integração e fusão complementar.

A escada traz referências ±10/20/30/40 que acompanham pitch e roll. BTNU aumenta heading em 10° e BTND reduz em 10°,
com retorno circular entre 0° e 350°.

## Escalas laterais

A escala de velocidade fica à esquerda (x=80), espelhada em relação à altitude
à direita (x=560). As duas têm oito marcas, espaçadas a cada 40 pixels, entre
y=100 e y=380. As marcas apontam para o centro da tela. São verdes e têm rótulos numéricos, com
passos de 20 KT e 200 FT. Os valores atuais iniciais são 280 KT e 36000 FT,
mostrados abaixo das barras. Esses valores são simulados.

A interface aceita velocidade, altitude, deslocamento de pitch e inclinação de
roll processados. Consulte [formatos e caminho atual do sensor](docs/entradas_hud.md).
A transferência entre clocks, a calibração do acelerômetro, a calibração
do bias do giroscópio, a integração temporal e a fusão complementar já estão
implementadas. A orientação física dos eixos e o movimento visual de pitch e
roll foram conferidos na placa.

## GitHub, Vivado e placa: etapas separadas

| Etapa | O que faz |
| --- | --- |
| GitHub | Armazena os arquivos e o histórico de versões do projeto. |
| `git pull origin main` | Traz as atualizações para a pasta local do repositório. |
| Vivado | Usa os arquivos adicionados ao projeto para executar síntese, implementação e gerar o `.bit`. |
| Program Device | Carrega o `.bit` escolhido na FPGA. Só então a placa passa a executar esse circuito. |

Atualizar pelo Git não adiciona automaticamente um módulo novo a um projeto
Vivado já aberto e não reprograma a placa.

Se a síntese mostrar `module 'controle_modo' not found` após a atualização:

1. Confirme que `rtl/controle_modo.sv` existe na pasta atualizada.
2. No Vivado, use **Add Sources → Add or create design sources → Add Files**
   e inclua esse arquivo em **Design Sources**.
3. Confira se os demais arquivos `rtl/*.sv` atuais estão incluídos e se
   `top_reticula` é o módulo principal.
4. Execute novamente **Run Synthesis** e **Generate Bitstream**.
5. Em **Program Device**, selecione o `.bit` recém-gerado.

O script de geração abaixo inclui todos os `rtl/*.sv` ao criar o projeto.

## Testar e gerar no Vivado

Na raiz do repositório, com Icarus Verilog instalado:

```sh
scripts/test.sh
```

Os testes verificam geometria, controles e um quadro VGA completo. A imagem de
simulação fica em `build/hud.ppm`.

O [CI no GitHub Actions](https://github.com/santosJuca/Trabalho-display-aviao-v2/actions/workflows/ci.yml)
executa `scripts/test.sh` com Icarus Verilog a cada push e pull request, além de
permitir execução manual. O log e o quadro VGA ficam disponíveis como artefatos
por 14 dias. Esse CI verifica a simulação RTL; síntese, implementação e timing
continuam dependendo da validação no Vivado.

Com Vivado no PATH, para **Nexys A7-100T / xc7a100tcsg324-1**:

```sh
vivado -mode batch -source scripts/build_vivado.tcl
```

O projeto fica em `build/vivado/reticula.xpr`; o bitstream fica em
`build/vivado/reticula.runs/impl_1/top_reticula.bit`. Também são gerados
`build/timing_summary.rpt`, `build/utilization.rpt`, `build/drc.rpt` e
`build/fmax.rpt` (estimativa por domínio, sem varredura de frequência).

O [bitstream de 05/10/2026](bitstreams/2026-10-05/README.md) está disponível
com SHA256 e relatório. Sua validação global de timing permanece pendente:
há um caminho VGA sem restrição com atraso de 42,597 ns para um período de 40 ns.

Para projeto manual, adicione todos os `rtl/*.sv`, o XDC e defina `top_reticula`
como módulo principal. Remova apenas fontes antigas duplicadas, não os módulos `.sv` atuais.

Confira o modelo físico antes de programar. O script não atende à A7-50T sem
ajustar o dispositivo. O mapeamento foi conferido no
[Master XDC da Digilent](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc).
Os controles utilizados nesta versão usam LVCMOS33.
O I²C da versão atual usa SDA em JD8/G4 e SCL em JD7/H2, conforme o XDC
versionado. A montagem física com o GY-521 foi validada no hardware.

Com a placa correta ligada por USB:

```sh
vivado -mode batch -source scripts/program_board.tcl
```

A programação é volátil. A versão consolidada foi programada na Nexys A7-100T
e validada fisicamente quanto à estabilidade VGA, pitch, roll, seleção MPU,
fallbacks e modos de exibição.

Os números antigos de utilização e timing não representam esta versão.
Consulte [arquitetura e validação de RF-08](docs/rf08.md) para os resultados
atuais e [a auditoria anterior](docs/auditoria.md) como registro histórico.

## Extensões e escopo

O hardware adicional já utilizado inclui o GY-521/MPU-6050 e o joystick
KY-023. Os eixos analógicos do joystick chegam ao JXADC através do
condicionamento resistivo usado na montagem, mantendo a tensão dentro da faixa
adotada para a entrada analógica. Conversores lógicos digitais não são usados
para os sinais analógicos VRx/VRy.

A integração do MPU-6050 é uma extensão além do MVP exigido pelo trabalho.
O driver ativo realiza identificação, configuração e aquisição de acelerômetro
e giroscópio, e a cadeia de atitude utiliza essas amostras no HUD. O antigo
`mma8452_i2c.sv` permanece apenas como arquivo legado.

Target lock continua como design goal; GPS, longitude, localização,
framebuffer e novos efeitos permanecem fora desta etapa.

## Especificação do trabalho

Obejetivo:
	-Tela VGA com reticulo central
	-Horizonte artificial com deslocamento configuravel
	-Escala de altitude
	-idicador de velocidade/diração e marcador de alvo 
	-todos simultaneos

Controlado por hardware: switches e botões da Nexys A7 variam parâmetros de voo simulados em
tempo real.	


On-the-fly & pure logic: toda simbologia é gerada proceduralmente, pixel a pixel, por lógica
combinacional e sequencial em FPGA.

Dentro do escopo 								Fora do escopo
_____________________________________________________________________________________________________________________
VGA 640x480 ou resolução reduzida compatível com o	|	HDMI, DisplayPort ou frame buffer (memória) externo. |
laboratório. 				
________________________________________________________|____________________________________________________________
Retículo, horizonte, escalas, marcador de alvo e	|	 Renderização 3D, OpenGL ou fontes complexas.	     |
indicadores simples.		
________________________________________________________|____________________________________________________________|		
Entradas por switches/botões para variar parâmetros.	|	Sensores reais					
________________________________________________________|____________________________________________________________|

Requisitos Funcionais — O Que o Sistema Deve Fazer
RF-01 Gerar sinais hsync, vsync e região ativa VGA
RF-02 Gerar coordenadas x/y para cada pixel ativo
RF-03 Renderizar retículo central
RF-04 Renderizar linha de horizonte com deslocamento configurável
RF-05 Renderizar escala vertical de altitude
RF-06 Renderizar escala horizontal ou indicador de direção
RF-07 Renderizar marcador de alvo
RF-08 Selecionar pelo menos dois modos de exibição
RF-09 Atualizar símbolos em tempo real sem travar o frame
RF-10 Manter todos os elementos dentro da área ativa
Requisitos Funcionais — Adicionais (Design Goals)
DG-01 Capacidade de “travar” o alvo
RF-02 Dois modos de exibição: modo normal (todos os símbolos) e modo declutter (somente itens críticos).

Simbologia - Exemplo
• Retículo Central: Referência fixa de apontamento utilizada para
alinhamento da aeronave e visualização da linha de visada do piloto.
• Linha de Horizonte (deslocamento): Representa a atitude longitudinal
da aeronave em relação ao horizonte.
• Escala Vertical de Altitude: Fornece indicação contínua da altitude da
aeronave.
• Escala Horizontal / Indicador de Direção: Apresenta a referência de
rumo ou proa da aeronave.
• Marcador de Alvo / Navegação: Indica a direção de um alvo ou ponto de
navegação, guiando o piloto até sua posição.
*a simbologia pode ser mais simples que o exemplo, desde que compreensível
Examples:
https://www.youtube.com/watch?v=pP7gadhCmWc
https://www.youtube.com/watch?v=W1G06-JCJFk

Sugestão de Como Chegar ao MVP + Req Não Funcionais
1)()
VGA Timing
Implementar e validar em simulação os sinais hsync/vsync com temporização
correta; verificar contadores de linha e coluna
2)()
Coordenadas e Primitivas
Criar gerador x/y; codificar comparadores simples para linha horizontal, linha
vertical, retângulo e marcador
3)()
Compositor e Modos
Integrar todos os symbol generators; definir lógica de prioridade; implementar
seleção de modo via switch
4)()
()Síntese e Demo FPGA
()Sintetizar e implementar no Vivado para Artix-7
()Verificar Fmax e utilização de recursos
()Demonstrar em monitor VGA
()Requisitos não funcionais
()Ponto de atenção técnico: a geração procedural
Sem memória de frame, exige que cada
Símbolo seja avaliado dentro do ciclo de pixel.
Latência combinacional é um risco a monitorar.

● Não usar framebuffer externo; geração procedural por coordenadas
● Modularizar em gerador VGA, gerador de símbolos e compositor
● Apresentar relatório de utilização e Fmax
● Permitir demonstração direta em monitor VGA

clk In Clock do sistema ou derivado para VGA (~25 MHz)
_________________________________________________________________________________________________
rst_n 		| In 	|	Reset
cfg_pitch_up 	| In 	|	Atitude vertical “para cima”, mapeado em switch
cfg_pitch_down 	| In 	|	Atitude vertical “para baixo”, mapeado em switch
cfg_roll_left 	| In 	|	Deslocamento / inclinação para esquerda, switch
cfg_roll_right 	| In 	|	Deslocamento / inclinação para direita, switch
target_lock 	| In 	|	Quando pressionado, fixa a posição do alvo relativo ao horizonte
display_mode 	| In 	|	Seleciona modo normal ou declutter
hsync / vsync 	| Out 	|	Sincronismo horizontal e vertical VGA
rgb 		| Out 	|	Sinal RGB conectado ao conector VGA da Nexys A7
