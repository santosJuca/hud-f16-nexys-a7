# Calibração HMC5883L na montagem final, 31/10/2026

Coleta física via JTAG/VIO, com frente de 180°, sensores na posição final e giro horizontal guiado por posições de relógio: 12→1→3→6→9→12. O usuário confirmou cada movimento. Foram obtidas **1.245 amostras válidas**, sem perdas, overflow ou rejeições por inclinação. Os 12 setores de 30° foram cobertos. O MPU permaneceu dentro de ±5° durante toda essa coleta: máximo absoluto de roll 2,169° e pitch 3,883°. Os limites são um controle de coleta, não uma medida de precisão angular.

| Eixo nativo | Mínimo | Máximo | Offset calculado | Offset inteiro | Ganho Q12 |
| --- | ---: | ---: | ---: | ---: | ---: |
| X | 578 | 856 | 717 | 717 | 4545 |
| Y | -330 | 9 | -160,5 | -161 | 3727 |

Offsets são o ponto médio dos extremos. A amplitude é metade da faixa; o ganho é a média das amplitudes dividida pela amplitude do eixo, quantizado em Q12, com 4096=1. Empates no arredondamento do offset vão para longe de zero. A correção ocorre nos eixos nativos antes da troca/inversão da montagem. A coleta e a primeira versão calibrada usaram `mpu-left90-mag-right90-front180`. O alinhamento posterior de +90° apenas na bússola está registrado abaixo; os offsets/ganhos nativos não mudaram.

O perfil medido está em `constraints/magnetometer_calibration.tcl`. Este conjunto de offsets/ganhos vale para a posição e os materiais próximos durante a coleta. Deve ser reavaliado se essa montagem mudar. O modelo corrige offsets e escala por eixo no plano; não acrescenta compensação geral soft-iron, inclinação ou declinação geográfica. Não foi fornecida referência independente de norte magnético, portanto a precisão absoluta do rumo não foi medida.

Os raios corrigidos apresentaram média 153,35counts e desvio padrão 2,26counts (CV1,48%). A diferença XY entre começo/fim foi 9,22counts. Esses números descrevem a consistência da coleta, sem transformar as posições manuais aproximadas em ângulos instrumentais.

## Dados e reprodução

- `amostras.csv`: valores físicos decodificados, inclinação e validade por publicação.
- `posicoes_guiadas.json`: leituras nos pontos confirmados pelo usuário.
- `resumo.json`: extremos, cobertura, ruído estático, ganhos e SHA-256 dos dados brutos.
- Brutos e procedimento: `validation/mag-coleta-20261031/capture-05/rotation.csv`, `capture_level.tcl`, `analyze_capture.py`.

A análise rejeita dados inválidos, overflow −4096, repetição de publicação e inclinação >5°. Exige pelo menos 200 amostras únicas válidas, todos os 12 setores e ganhos Q12 representáveis abaixo de 2. Exige também excursão por eixo ≥20counts e ≥10 vezes a faixa de ruído estático, evitando tratar quantização de conjunto parado como giro completo.

As duas coletas anteriores foram mantidas para rastreabilidade e não entram neste ajuste. Após esclarecer que 90° se referia a uma mudança de direção vista de cima, a coleta foi refeita com giros pequenos sobre a mesa. Nenhuma verificação de nível foi desabilitada.

## Implementação

O canal VIO foi acrescentado somente a um snapshot isolado da versão de coleta, autorizado e carregado por JTAG volátil. O RTL principal permaneceu preservado. A primeira versão normal foi reconstruída com os quatro parâmetros medidos e sem VIO; o restante é o mesmo perfil funcional de frente 180. O teste de heading passou em 1.391 vetores e 8 configurações, incluindo os novos parâmetros, pontos físicos, cardeais, limites, wrap e perda de sensor. A implementação passou com WNS +0.514 ns, WHS +0.025 ns, sem erros DRC e sem CDC inseguros/desconhecidos. Os 81 pinos e propriedades coincidem com 7b4b6ec0; parâmetros de montagem e da calibração medida conferidos nos generics efetivos. A versão bcf166ae foi autorizada especificamente e programada via JTAG volátil. SHA-256 e alvo Digilent210292AD34F5A conferidos, DONE/INIT_B/fim de startup em1 e saída de programação zero. A confirmação posterior em bancada está registrada abaixo. Não houve escrita em Flash nem no microSD.

SHA-256 do bitstream normal calibrado: `bcf166ae461d8b64e4fd890a9994b89ad4e01dd967e541b9f534b94de1aa0868`. Evidências em `validation/mag-calibrado-20261031/`.

Programação concluída em 2026-10-31T12:09:00.536791-03:00. Nenhuma gravação de Flash ou microSD; a versão calibrada é volátil.

Após a programação final, o usuário relatou inicialmente ATT BAD. Depois de apoiar o conjunto e selecionar os sensores, informou MPU CAL33 e CAL BLK0 e confirmou explicitamente que ATT BAD desapareceu. A atitude está válida nessa partida; não se modificaram novamente driver, critérios de calibração ou firmware. Depois da recarga, o usuário confirmou resposta do HDG ao giro plano e retorno aproximado (102° → 120° → perto de 102°).

## Alinhamento de frente em +90°

O usuário pediu 75° → 165° sem mover os módulos nem alterar o horizonte. A versão atual é **f485be1f**, perfil `mpu-left90-mag-right90-front180-hdg-plus90`, com os mesmos offsets/ganhos medidos. Foi autorizada especificamente e carregada por JTAG volátil na mesma Nexys. Na tela normal, o usuário confirmou HDG **163°**, ausência de ATT BAD e horizonte respondendo. Isso confirma o funcionamento observado; não mede precisão absoluta de rumo nem compensação de inclinação.

SHA-256 atual: `f485be1fca9389cb8e50586984764f96f74678705d87a4f646d0b354ca679f32`. Detalhes em [alinhamento da bússola](../alinhamento_bussola_mais90_20261031.md) e evidências em `validation/hdg-plus90-20261031/`. A versão bcf166ae permanece preservada para retorno. Sem escrita de Flash ou microSD.
