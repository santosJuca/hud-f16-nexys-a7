# Arquitetura de vídeo DDR2

## Caminho implementado

`sd_spi_controller` inicializa o cartão e lê blocos CMD17, incluindo CRC16. `sd_video_loader` valida o cabeçalho, a ordem e a quantidade de setores e só solicita commit após o quadro completo. O espelho `ddr2_sd_frame_mirror` empacota 16 bytes em 128 bits e os transmite pela FIFO XPM de entrada ao domínio MIG (~81,25 MHz).

O MIG recebe endereços alinhados, comando e dados com os respectivos sinais ready. Um quadro DDR2 de 76.800 bytes ocupa 4.800 beats. A FSM conclui a escrita antes da releitura e compara CRC32 do conteúdo lido com o CRC32 acumulado na origem. A saída serializa os bytes por uma segunda FIFO XPM com eventos START, WORD, COMMIT e ABORT.

O `sd_sector_buffer` recebe o retorno em seu banco inativo. A troca para o banco de exibição exige commit completo e fronteira vertical (`y=480`). O compositor lê a BRAM a 25 MHz e preserva a prioridade do HUD e o sincronismo VGA 640×480. Um quadro inválido ou parcial não substitui o banco ativo. A tela mantém a última imagem válida durante atraso ou descarte.

Há **um quadro DDR2 de trabalho e dois bancos BRAM de exibição**, sem ping-pong entre dois framebuffers DDR2 e sem escrita/releitura simultâneas na DDR2. Essa arquitetura já completa o caminho DDR2 → tela; aumentar o número de superfícies não é necessário para a integridade atual. O loader DDR2 pode iniciar o próximo quadro assim que o espelho libera a área DDR2, mesmo enquanto a BRAM aguarda a publicação anterior. O retorno seguinte respeita out_ready antes de START; nenhuma imagem parcial chega à VGA. No caminho sem DDR2, o loader continua esperando frame_ready. A vazão sustentável depende do SD, da serialização e da fronteira de publicação. Se a leitura não sustentar a taxa nominal, o loader conserva a sequência e contabiliza atraso; a imagem anterior permanece na tela e a duração da reprodução aumenta. Não há descarte automático de quadros para recuperar o relógio do arquivo.

## CDC e recuperação

As duas FIFOs usam o modelo e as constraints oficiais `xpm_fifo_async`, FWFT, dois estágios CDC, memória distribuída e bloqueio por `wr_rst_busy`/`rd_rst_busy`. O reset comum reúne reset da origem, reset UI e perda de calibração. Sua liberação ocorre por cinco estágios em cada clock. No checkpoint roteado os cinco registradores de cada cadeia têm ASYNC_REG e estão agrupados na mesma slice.

A perda de calibração invalida a transação, esvazia as FIFOs e produz ABORT no lado BRAM. O banco ativo não é apagado por esse abort. Reset global da origem também reinicializa o buffer de exibição; nesse caso o HUD deve continuar e o fundo só retorna após novo quadro completo. Nenhum teste de reset lógico comprova recalibração elétrica do PHY.

Os status `ui_ready`, conclusão e ocupação usam sincronizadores e handshakes. Temperatura e joystick mantêm o payload estável até reconhecimento sincronizado. Os detalhes dos avisos e constraints estão em `VALIDACAO_OFFLINE.md`.

## Alternativa de recuperação

`ENABLE_DDR2_VIDEO=0` conserva o caminho SD → BRAM → compositor. Nenhum algoritmo de atitude, rotação do magnetômetro, fonte de sensores, pinagem ou desenho do HUD foi alterado na sprint. O perfil aprovado de calibração é aplicado pelo script de build e registrado em `evidencias/perfil-fisico-preservado.json`.

A seleção de recuperação exige outro artefato identificado e autorização para programar. O firmware já funcional na Flash não foi substituído.


## Perfil mapeado para a próxima validação

O fechamento mantém exatamente esse RTL e os genéricos de calibração. A alteração de configuração está em `evidencias/perfil-cartao-fechamento.json`: LBA absoluto 30028160, 13501 setores, 90 quadros RGB332 320×240/30 nominal. O mapa autenticado prova uma extensão FAT contígua de 13504 setores; o loader deve limitar-se aos 13501 setores do arquivo. O build noturno sintético apontava para outro tamanho e não aceitaria esse cabeçalho.

Leitura SPI a 400 kHz preservada. A carga mínima ideal é 1,569 s por quadro; o compositor continua varrendo VGA a ~59,52 Hz e repetindo o último banco entre atualizações do fundo. Os contadores de atraso não indicam por si só corrupção. A meta de 30 FPS exige outra frequência qualificada e vazão física comprovada.


## Diagnóstico persistente de publicação

A correção `b38e538` conecta o `wr_published` existente do buffer de vídeo ao diagnóstico `ddr2_video_status`. Esse ACK já cruza pixel→HUD pelo sincronizador interno e só retorna após a troca de banco e a drenagem de leitura. LD14 exige um `ddr_out_commit` seguido desse ACK; não usa diretamente `smoke_done && smoke_pass`. LD15 mantém falhas do loader/buffer e ABORT após iniciar transferência, ignorando a calibração inicial. Os registros de status não dirigem nenhuma FSM/ready/dado e não introduzem CDC novo. O histórico só limpa na inicialização/reconfiguração do HUD, não no CPU RESET do MIG.

O perfil DDR2 não seleciona SD→BRAM diretamente: com ENABLE_DDR2_VIDEO=1 os bytes e controles do buffer vêm somente da FIFO de retorno MIG. O modo BRAM continua como outra configuração, sem fallback automático. A comparação de pixels dos testbenches comprova essas rotas no modelo; a fotografia sozinha não as comprova fisicamente.

## Sprint de perfis rápidos e medição

Os candidatos locais 10/12,5 MHz sintetizam o commit 8162051 com divisores de leitura 5/4 e inicialização 125. O pipeline CMD17 → CRC16 → XPM → espelho/releitura MIG → CRC32 → buffer de dois bancos → compositor → VGA permanece igual. Não há CMD18, codec ou novo PHY nos BITs. O espelho atual não armazena o filme inteiro para reprodução autônoma.

A sonda opcional video_publication_metrics foi implementada e testada separadamente, sem conexão ao top destes candidatos. Distingue commit de retorno de ACK de publicação e mede intervalo no domínio HUD. O procedimento de futura integração/ILA, sem novo CDC e sujeito a novo fechamento do top, está em PROCEDIMENTO_TESTE_FPGA.md. Os contadores SD existentes são reutilizados; erros de tentativa, descarte de quadro único e retenção visual têm semânticas diferentes.

A análise de 30 FPS e o orçamento externo SCK/MISO estão em SPI_PERFIS_INCREMENTAIS.md. Alterações de IOB/captura ou compressão descritas ali são propostas; a amostra PackBits é somente análise sem perdas no computador. Nenhum vídeo, sensor, algoritmo de atitude ou orientação magnética foi alterado.
