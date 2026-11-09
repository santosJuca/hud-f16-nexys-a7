# Pendências físicas

A confirmação do usuário de boot autônomo e HUD/sensores funcionando pertence ao firmware preservado. O candidato DDR2 desta sprint nunca foi programado.

| Pendência | Evidência indispensável |
|---|---|
| Mapa SD | Arquivo e FAT32 identificados após a sprint; falta acesso administrativo somente leitura aos setores para provar cadeia contígua e LBA atual. |
| SPI rápido | Orçamento de setup/hold de saída e entrada com datasheet do cartão/interface, conexões e atrasos reais; só então qualificar a frequência e suas constraints. |
| MIG e clocks | Calibração completa, estabilidade do XADC/temperatura e comportamento após reset/perda de calibração na placa; revisão do REQP-1709 do clocking gerado. |
| Vídeo e DDR2 | Imagens íntegras, sem tearing, congelamento controlado da última imagem após falha e recuperação sem reset geral indevido. |
| Taxa efetiva | Medição de quadros publicados ao longo do tempo e leitura útil do cartão. 30 FPS no arquivo não comprova 30 FPS exibidos. |
| Sensores/controle | Horizonte, bússola com orientação preservada, altitude, joystick, modos e ajuste vertical no monitor VGA. |
| Flash futura | Artefato físico aceito, chip identificado sem ambiguidade, backup verificado, autorização específica e teste de boot após desligar/religar. |

Durante a sprint o cartão estava na Nexys. Após a mensagem do usuário de que o colocou no PC, o leitor USB 816820130806 e a partição FAT32 UUID 3562-6631 foram identificados. O arquivo atual, lido com montagem ro, tem 90 quadros 320×240/30 e conferiu integralmente com a amostra local; 90 hashes e 13.500 CRC16 passaram. O vídeo completo de 17.331 quadros continua apenas na cópia local conhecida. Fragmentação e LBA físico seguem INDETERMINADOS porque o sistema exige autenticação administrativa para ler o dispositivo bruto. O comando somente leitura foi enviado ao usuário; não há senha administrativa disponível à sessão.

A inspeção offline do arquivo local e dos modelos não resolve essas pendências. O build atual usa LBA sintético e SPI conservador de 400 kHz; não deve ser levado à placa como configuração de 30 FPS. Nenhum novo bitstream foi liberado para programação.
