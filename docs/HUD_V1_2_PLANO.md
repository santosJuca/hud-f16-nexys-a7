# HUD FPGA v1.2 | Plano de acabamento visual e instrumentacao

## Base imutavel e objetivo

- Base de desenvolvimento: tag `hud-v1.1-jtag-validated`, commit `1d398264f311250c25f298cef6be1d2ebc0a958f`.
- Nova branch: `feat/hud-v1.2-acabamento`.
- Referencia fisica v1.1: bitstream SHA-256 `d9750085ce8dc2558372872d80734d13dff390354468241aa3cda972db8cfc07`, ensaio JTAG com oito verificacoes PASS.
- Referencia de recuperacao: v1.0, tag `hud-v1.0-autozero-qspi`, boot autonomo QSPI confirmado apos ciclo de energia.
- Objetivo: melhorar legibilidade da escada de pitch, orientacao dos rotulos e composicao visual em manobras, sem degradar comportamento funcional.

Esta fase NAO pretende certificar simbologia como equivalente a um HUD F-16 real. Convencoes aeronauticas devem ser documentadas e verificadas antes de serem afirmadas.

## Regras de preservacao

1. Nao alterar nem regravar QSPI v1.0; nao substituir releases, tags ou commits da v1.1.
2. Nao alterar inicialmente CORDIC, estimador de atitude, drivers de sensores, video SPI/SD, controle do joystick, buzzer ou pinagem.
3. Conservar horizonte artificial estabilizado e escala de pitch geometricamente coerentes com roll e pitch; conservar busssola e instrumentos fixos independentes do deslocamento da camada de voo.
4. Todo ajuste visual deve ser isolado, ter teste automatizado antes/depois e demonstrar diferencas restritas aos pixels pretendidos.
5. Nao introduzir valores imaginarios de altitude, velocidade ou voo nem confundir imagem F-16 reproduzida com telemetria real.
6. Regressao, Vivado (setup/hold/pulse width, DRC, CDC e utilizacao) e teste fisico JTAG volátil precedem qualquer release v1.2.

## Diagnostico e pontos a revisar

- A v1.1 suprime os numerais dos niveis 10 e 30 graus quando `FULL_ATTITUDE` e `-8192 <= attitude_cosine <= 8192` (Q14), aproximadamente na faixa de bank absoluto 60 a 120 graus. Preserva todos os tracos da escada e o horizonte zero.
- O limiar de 60 graus introduz uma comutacao discreta na quantidade de numeros. Nao inferir oscilacao perceptivel sem teste de giro continuo com sensor e oscilacoes proximas ao limiar.
- Rotulos atualmente acompanham a rotacao da escada, podendo tornar-se verticais perto de 90 graus. Estudar alternativas de orientacao em tela apenas apos verificar geometria e leitura em um preview limpo.
- Atlas anterior foi gerado em testbench com grade diagnostica ativada. Esta grade nao representa necessariamente a apresentacao normal em voo.

## Etapa 1: baseline visual sem modificar RTL

Criar ou adaptar um testbench de preview para gerar duas imagens por estado:
- `GRADE=0`: HUD isolado sem linhas de calibracao;
- `GRADE=1`: mesma atitude com grade de referencia.

Usar pelo menos roll 0, +/-30, +/-45, +/-59, +/-60, +/-61, +/-89, +/-90, +/-119, +/-120, +/-121, +/-150 e 180 graus, e pitch 0, +/-10 e +/-20 graus em amostragem suficiente para inspeção. Controlar seed e parametros para comparacoes deterministicas.

Separar no atlas cores/elementos: horizonte, escada e numeros; marcador central; heading e instrumentos fixos. Testes devem distinguir o desenho do modulo isolado e a composicao real do `top_reticula` com video, sem afirmar que um substitui o outro.

Entregavel: atlas limpo, atlas com grade, casos de fronteira e relatorio de diferencas em diretorio de evidencias fora do Git.

## Etapa 2: projeto da melhoria e aprovacao do criterio

Comparar alternativas de representacao dos numerais em alto bank:
- politica atual v1.1, como referencia;
- manter um subconjunto minimo de numeros;
- renderizar rotulos com orientacao de tela sem modificar as linhas rotacionadas, apenas se a nova rasterizacao for viavel.

Escolher pela legibilidade, ausencia de ambiguidades de sinal, estabilidade visual e custo de sintese. Nao implementar interpolacao de opacidade inexistente no raster VGA binario. Se transicoes de limiar realmente piscarem, considerar histerese por quadro com testes dirigidos para os limiares e para sequencias de roll; nao introduzir estado novo sem necessidade demonstrada.

## Etapa 3: regressao objetiva

Requisitos obrigatorios:
- roll 0, +/-30 e demais casos fora da faixa alterada mantem equivalencia de pixels com a referencia, exceto alteracoes explicitamente aprovadas;
- zero horizonte e todos os tracos principais preservados;
- heading, altitude, velocidade, reticulo e video nao apresentam mudancas inesperadas;
- pitch positivo/negativo preserva sentido e escala em todo o roll;
- nao ha alteracoes de simbologia dentro de um mesmo quadro por atualizacao assincrona de atitude;
- testes de integracao microSD, CRC, captura/CAP, swiches, sensores, joystick e buzzer continuam aprovados.

## Etapa 4: qualificacao e entrega

Antes do primeiro teste fisico v1.2: executar regressao completa, sintetizar e rotear com o MESMO perfil real utilizado na v1.1, conferir hashes de fonte/bitstream e relatorios Vivado, e manter QSPI inalterada. Qualquer programacao JTAG deve ser expressamente autorizada para hash e caminho especificos.

Somente apos teste fisico e confirmacao de retorno da v1.0 pela QSPI: criar tag e pre-release separadas `hud-v1.2-...`, sem alterar `main` nem substituir artefatos v1.0/v1.1.

## Primeiro passo autorizado

Apenas preparar a branch, o plano e o preview de evidencia. **Nenhuma mudanca no RTL funcional da v1.1 e nenhuma programacao de hardware nesta etapa.**
