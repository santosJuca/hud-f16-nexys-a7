# Próxima sessão: teste físico da integração

## Estado atual da leitura do cartão

O cartão já está no PC, em /dev/sdc pelo leitor USB 816820130806; partição FAT32 UUID 3562-6631, montada ro. A amostra atual tem 90 quadros 320×240/30, 6.912.512 bytes e SHA-256 24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2. Sua cópia conferida é validation/cartao-20261109/HUDVIDEO.BIN. Há 13.501 setores lógicos no arquivo, mas o LBA inicial e a contiguidade ainda não foram lidos por falta de autenticação administrativa. Não confundir número de setores do arquivo com endereço inicial. O comando enviado no chat usa o alias estável do leitor e o mapeador O_RDONLY; deve ser executado no Terminal com autenticação do Ubuntu.

## 1. Identificar o vídeo sem escrever no cartão

Desligar a Nexys e colocar o cartão no leitor do computador. Identificar modelo, capacidade, serial e partições com `lsblk -o NAME,PATH,SIZE,MODEL,SERIAL,FSTYPE,UUID,MOUNTPOINTS`. Não adivinhar `/dev/sdX`, não montar para escrita e não usar um disco interno como entrada. Se o Ubuntu o montar automaticamente em escrita, interromper a inspeção e desmontar antes de continuar; não formatar ou reparar a FAT.

Depois de estabelecer a identidade, executar o verificador com o **dispositivo inteiro**, a cópia local que se acredita estar no cartão e uma saída nova:

```text
python3 tools/map_sd_video.py DISPOSITIVO_INTEIRO_IDENTIFICADO REFERENCIA_LOCAL_HUDVIDEO.BIN evidencias/mapa-cartao-verificado.json
```

O código abre a entrada com O_RDONLY. Confere MBR, FAT32, cópias da FAT, tamanho e cadeia do arquivo raiz `HUDVIDEO.BIN`, exige contiguidade e compara todo o conteúdo com a referência local. Não desloca nem desfragmenta arquivos. Se rejeitar o cartão, conservar a evidência e investigar; não substituir pelo LBA histórico. O resultado vale para o conteúdo inspecionado, até qualquer alteração posterior no cartão. Os cinco testes de imagem FAT32 da sprint não constituem inspeção do cartão físico.

A cópia 320×240/30 está em `/home/santojuca/Downloads/hud_ddr2_video_integracao/validation/video-completo-320-30/HUDVIDEO.BIN`. A cópia histórica 160×120/1 não pode ser confundida com ela. A referência histórica foi reconferida localmente em `/home/santojuca/Downloads/hud-video-modos-20261106/validation/video-bussola-20261106-GkXqhu/recovery-files/HUDVIDEO.BIN`, 11.246.080 bytes, 578 quadros, SHA-256 `615729d0740adc978b42fdf0a13dc4f18820109e4dd9e68ac66d137d431012d0`. Esse hash não comprova o conteúdo atual do cartão. Selecionar a referência conforme o tamanho/cabeçalho efetivamente lidos, sem supor qual delas está gravada. Se nenhuma referência conferir, identificar e extrair o arquivo somente leitura em uma nova pasta antes de preparar outro build.

## 2. Preparar o artefato destinado à placa

Criar outra área de build a partir da branch noturna, preservando esta entrega. Usar o cabeçalho e o mapa físico verificados para `SD_VIDEO_LBA`, `SD_VIDEO_SECTORS`, largura, altura e FPS; manter o perfil completo de `evidencias/perfil-fisico-preservado.json`. Não copiar LBA=1 do script offline. Repetir os testes afetados e implementar essa configuração.

Iniciar com SPI conservador e aceitar atualização lenta. 400 kHz não sustenta 320×240/30; aumentar a frequência só após fechar o orçamento externo. Para o perfil rápido, manter inicialização a 400 kHz e escolher explicitamente `SD_READ_HALF_PERIOD_CYCLES`, sem alterar defaults silenciosamente. A 100 MHz, divisor 2 corresponde a 25 MHz; divisor 125 a 400 kHz.

Antes de gerar/programar um `.bit`, avaliar CDC/reset/REQP-1709, setup/hold e constraints externas dessa configuração, DRC, clocks e bus skew. Registrar caminho absoluto, SHA-256, commit, mapa, genéricos e alvo/dispositivo. Obter autorização específica de JTAG para esse artefato. A sprint noturna não concedeu essa autorização.

## 3. Ensaio incremental após autorização

1. Conferir a placa Nexys A7-100T, dispositivo XC7A100TCSG324-1 e alvo conectado; o identificador histórico é `Digilent/210292AD34F5A`, sem consulta nova nesta sprint. Conferir a integridade do bitstream de recuperação abaixo e o acesso à configuração funcional na Flash.
2. Programar apenas SRAM por JTAG com o novo artefato autorizado, mantendo a Flash. Confirmar clocks/calibração MIG e HUD básico antes de habilitar vídeo.
3. Conferir horizonte, bússola, altitude e joystick. Não reaplicar rotações aos sensores por impressão visual. Validar modos existentes, retículo, escalas, bordas e ajuste vertical.
4. Habilitar vídeo. Conferir proporção, canais RGB, ausência de tearing e contadores/estado de erro e calibração. Medir quadros efetivamente publicados; não usar apenas o FPS do cabeçalho.
5. Exercitar desligamento/retorno do vídeo, mudança de modo, quadros atrasados e recuperação prevista. Testes de remoção/reset físico exigem sequência elétrica segura; não retirar cartão energizado por improviso.
6. Se houver corrupção, perda de calibração, regressão de sensores ou travamento, interromper a promoção, registrar o estado e restaurar o firmware conhecido por power-cycle na configuração de boot habitual. Qualquer recarga por JTAG também exige autorização compatível.

Aceite físico: HUD e sensores preservados, DDR2 calibrada estável, dados íntegros, troca apenas no blanking, recuperação após falhas e taxa medida compatível com o perfil escolhido. Guardar observação do monitor e medições com o hash do artefato.

## Recuperação preservada

`/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`

SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`. Revalidado na sprint. O usuário confirmou boot pela Flash desse firmware; não foi feito novo power-cycle remoto. O manifesto `evidencias/recuperacao-preservada.json` contém também MCS e backups. Restauração de Flash não foi ensaiada nesta sprint.
