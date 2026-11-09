# Próxima sessão: validação física incremental

## Perfil identificado

O mapa foi concluído pelo usuário com o mapeador O_RDONLY. Leitor USB serial 816820130806, partição FAT32 UUID 3562-6631, montagem ro, partição iniciando no LBA 8192. `HUDVIDEO.BIN` é contíguo no **LBA absoluto 30028160**, com **13501 setores de conteúdo** (13504 alocados), 90 quadros RGB332 de 320×240/30 nominal e SHA-256 `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2`.

Evidência: `evidencias/mapa-cartao-20261109.json`. O perfil sintetizado está em `evidencias/perfil-cartao-fechamento.json`; preserva sensores e SPI de leitura em 400 kHz. Não usar LBA 1 nem o tamanho do vídeo completo. Se o cartão/arquivo for modificado, movido ou substituído, repetir o mapa somente leitura. Não há necessidade de autenticar novamente apenas para repetir uma prova já concluída.

## Antes de programar

1. Ler `RESULTADO_FINAL.md` e `VALIDACAO_OFFLINE.md`. Fechar as ressalvas de reset/MIG/REQP-1709 e temporização externa; não preencher atrasos de IO por estimativa sem referência da interface. A implementação com timing interno positivo não encerra essas ressalvas.
2. Gerar `.bit` somente após satisfazer os critérios offline, em área preservada, a partir do perfil mapeado. Conferir constraints/pinagem, timing, DRC, CDC e skew dessa configuração. Registrar commit, genéricos, mapa, caminho e SHA-256. Esta entrega não autoriza JTAG, SD ou Flash.
3. Confirmar a recuperação abaixo e a configuração habitual de boot, obter autorização específica para o artefato e conferir o alvo real. Alvo histórico: Digilent/210292AD34F5A, XC7A100TCSG324-1. Nenhuma consulta JTAG foi feita nesta sprint.

## Ensaio após autorização específica

1. Com Nexys desligada, devolver o microSD identificado ao slot, conferir conexões existentes e ligar no modo habitual. Não retirar cartão energizado ou alterar níveis/pinagem. Programar somente SRAM por JTAG com o artefato autorizado; conservar a Flash funcional.
2. Conferir LD12 (lock da referência) e LD13 (calibração MIG). LD14 indica conclusão PASS do espelho, LD15 erro. Registrar os LEDs e o VGA durante a primeira carga; LED de lock sozinho não comprova calibração nem integridade de vídeo.
3. Conferir sensores e HUD antes de julgar o fundo. Horizonte, bússola e referência angular devem manter o comportamento conhecido. Não reaplicar rotações aos sensores. Habilitar vídeo e aguardar quadro completo: a 400 kHz, a carga ideal mínima é 1,569 s/quadro, mais esperas. Atualização lenta é esperada e não prova falha da VGA.
4. Observar reprodução contínua e retorno ao primeiro quadro. O loop dos 90 quadros exige pelo menos 141,21 s nesse perfil, podendo demorar mais. Registrar ausência de mistura/tearing e estabilidade de sincronismo, cores/proporção e preservação da imagem entre atualizações. Um vídeo de tela cronometrado fornece observação visual; não rotular isso como medida instrumentada de 30 FPS.
5. Alternar modos existentes, ajustar a posição vertical e testar limites da bússola/atitude. O vídeo não deve desaparecer por deslocamento do HUD. Desligar/religar o vídeo deve recuperar reprodução sem exigir reset geral dos sensores.
6. Acionar reset pelo controle previsto e observar nova calibração/recuperação. Evitar acionamentos repetidos enquanto o reset/busy anterior não terminar. Em erro ou perda de calibração, registrar LD13/LD15 e o estado do VGA, interromper a promoção e recuperar o firmware preservado pelo boot habitual. Não provocar desconexões elétricas para simular falha.

Os contadores internos existentes são `video_frames`, `video_errors`, `video_late`, `video_cycles` e `sd_publications`. Nem todas as páginas de diagnóstico são acessíveis na configuração normal de switches; não afirmar que esses números foram medidos externamente. `video_frames` conta carga SD, não publicação VGA. Para FPS instrumentado, observar/publicar um contador da troca efetiva do banco (`rd_updated`) com ferramenta apropriada em um artefato de diagnóstico separado e requalificado. Nenhuma ILA ou porta nova foi acrescentada nesta sprint para não perturbar a implementação.

Aceite: DDR2 calibrada estável, HUD/sensores preservados, quadros íntegros, troca no blanking, recuperação e taxa medida compatível com a frequência escolhida. Os 30 FPS nominais só serão critério físico de um perfil rápido com throughput e temporização externa previamente comprovados. Flash futura segue `PROCEDIMENTO_FLASH_QSPI.md`, após aceite e autorização próprios.

## Recuperação preservada

`/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`

SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`. Revalidado na sprint. O usuário confirmou boot pela Flash desse firmware; não foi feito novo power-cycle remoto. O manifesto `evidencias/recuperacao-preservada.json` contém também MCS e backups. Restauração de Flash não foi ensaiada nesta sprint.
