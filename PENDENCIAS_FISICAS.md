# Pendências físicas

A confirmação do usuário de boot autônomo e HUD/sensores funcionando pertence ao firmware preservado. O candidato DDR2 desta sprint nunca foi programado.

| Pendência | Evidência indispensável |
|---|---|
| Mapa SD | Concluído por leitura autenticada: LBA absoluto 30028160, 13501 setores de arquivo e cadeia contígua; refazer somente se houver mudança do cartão/arquivo. |
| SPI rápido | Orçamento de setup/hold de saída e entrada com datasheet do cartão/interface, conexões e atrasos reais; só então qualificar a frequência e suas constraints. |
| MIG e clocks | Calibração completa, estabilidade do XADC/temperatura e comportamento após reset/perda de calibração na placa; revisão do REQP-1709 do clocking gerado. |
| Vídeo e DDR2 | Imagens íntegras, sem tearing, congelamento controlado da última imagem após falha e recuperação sem reset geral indevido. |
| Taxa efetiva | Medição de quadros publicados ao longo do tempo e leitura útil do cartão. 30 FPS no arquivo não comprova 30 FPS exibidos. |
| Sensores/controle | Horizonte, bússola com orientação preservada, altitude, joystick, modos e ajuste vertical no monitor VGA. |
| Flash futura | Artefato físico aceito, chip identificado sem ambiguidade, backup verificado, autorização específica e teste de boot após desligar/religar. |

O arquivo físico atual de 90 quadros foi comparado integralmente com a referência local no mapeador autenticado pelo usuário. O vídeo completo de 17.331 quadros permanece no computador. Não há bloqueio administrativo pendente para este mapa. O novo perfil corrige LBA/tamanho e preserva SPI=400 kHz; não deve ser interpretado como configuração de 30 FPS físicos.

Os três CDC-10 foram rastreados no circuito roteado: dois no reset comum do espelho e um no MIG. Os ensaios digitais novos de pulso curto/parada de clock passaram, mas não comprovam largura mínima física de PRE, imunidade a glitches ou resets repetidos durante busy. REQP-1709 corresponde à topologia gerada; justificativa em VALIDACAO_OFFLINE.md, sem waiver específico ou aprovação física. Temporização externa SPI e ensaio do PHY continuam sendo condições de promoção. A missão posterior liberou a geração do bitstream experimental para ensaio JTAG; o artefato ainda não foi programado nem aprovado fisicamente. A qualificação e os limites estão na última seção de VALIDACAO_OFFLINE.md.


Para a pre-release, não há falha elétrica conhecida que impeça um teste controlado por JTAG no perfil de 400 kHz e pinagem preservada. Restam validação do PHY/calibração, integridade real, reset, controles/sensores e publicação efetiva. A `.mcs` depende de confirmar o modelo exato da Flash e, para gravação, do aceite físico anterior. O microSD já está na placa segundo o usuário; seu conteúdo não foi alterado nesta missão.
