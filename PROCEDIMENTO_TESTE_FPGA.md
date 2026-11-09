# Teste JTAG da release candidate experimental

**EXPERIMENTAL — NÃO VALIDADO FISICAMENTE.** Nenhum comando de programação foi executado pelo agente. Usar Nexys A7-100T XC7A100TCSG324-1 com as conexões já funcionais. A Flash atual permanece a recuperação principal.

## 1. Baixar e conferir no Ubuntu

O repositório é privado; `gh` precisa de autenticação com acesso. Criar uma pasta nova, baixar todos os assets e verificar o conjunto:

```bash
mkdir hud-ddr2-rc-20261109
cd hud-ddr2-rc-20261109
gh release download hud-f16-ddr2-rc-20261109 \
 --repo santosJuca/Trabalho-display-aviao-v2 --dir .
sha256sum -c SHA256SUMS
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode gui
```

Candidato: `hud-f16-ddr2-74b3541-experimental.bit`, 3825992 bytes, SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. O manifesto da Release relaciona o commit publicado ao RTL/DCP de `74b3541` e aos assets. Conferir também o hash do BIT de recuperação antes de programar.

## 2. Programar somente SRAM por JTAG

1. Com a Nexys desligada, manter o microSD identificado no slot e conferir conexões/alimentação habituais. Não alterar pinagem, níveis, JP1 ou sensores por inferência. Ligar a placa e conectar a USB-JTAG J6.
2. No Vivado 2026.1: **Open Hardware Manager → Open Target → Auto Connect**. Conferir Nexys A7-100T e `xc7a100t_0`. O serial histórico é Digilent/210292AD34F5A; se o alvo for diferente ou houver mais de uma placa, identificar antes de programar.
3. Selecionar `xc7a100t_0` → **Program Device**. No campo Bitstream File escolher somente `hud-f16-ddr2-74b3541-experimental.bit`, com o hash acima. Não usar Add Configuration Memory Device ou Program Configuration Memory nessa etapa. Programar a SRAM.
4. Guardar log, horário e hash. Verificar DONE e, quando disponíveis no status do dispositivo, INIT_B/EOS e ausência de CRC_ERROR. Isso confirma configuração, não funcionamento do HUD/DDR2.

## 3. Validar a placa

1. Conferir LD12 (lock da referência) e LD13 (calibração MIG). LD14 indica conclusão PASS do espelho; LD15, erro. LED de lock sozinho não comprova calibração ou dados íntegros.
2. Conferir horizonte, bússola, altitude, joystick e modos conhecidos antes de julgar o fundo. Preservar a orientação angular dos sensores; não recalibrar rotações por impressão visual.
3. Habilitar o vídeo pelo controle já existente. O perfil é **320×240 RGB332, 90 quadros, arquivo 30 FPS nominal, SPI físico configurado em 400 kHz**. Esperar quadro completo: mínimo ideal 1,569 s/quadro mais esperas. A VGA permanece a ~59,52 Hz; o fundo atualiza lentamente. Não exigir 30 FPS deste perfil.
4. Observar ausência de mistura/tearing, cores/proporção, sincronismo e manutenção do último quadro entre atualizações. O loop exige pelo menos 141,21 s; esperar o retorno ao início e registrar o tempo real. O arquivo ocupa 13501 setores no LBA absoluto 30028160, contíguo, hash `24f17b8a9bb7ec6b52aeb55a1301f065aadc05df1c03fa34b673222a4d8bdea2`. Se o arquivo/cartão mudou após o mapa, não prosseguir com esse endereço.
5. Alternar os modos existentes, ajustar a posição vertical, verificar bordas da bússola e referência angular. O deslocamento do HUD não deve apagar o vídeo. Testar desligamento/retorno do vídeo sem reset indevido dos sensores.
6. Acionar um reset pelo controle previsto, aguardar nova calibração e recuperação. Evitar resets sucessivos durante busy/recuperação. Não remover cartão energizado nem desconectar a DDR2 para simular falha. Em erro, registrar LEDs/VGA e recuperar a versão anterior.

Os contadores internos existentes são `video_frames`, `video_errors`, `video_late`, `video_cycles` e `sd_publications`. Nem todas as páginas de diagnóstico são acessíveis na configuração normal. `video_frames` conta carga SD, não publicação VGA. Vídeo cronometrado do monitor é observação visual; FPS instrumentado exige contar a troca efetiva de banco (`rd_updated`) em instrumento/artefato de diagnóstico requalificado. Nenhuma ILA foi acrescentada. Underrun/atraso deve manter a última imagem válida; falha de CRC deve descartar a tentativa, sem publicar quadro parcial.

Aceite: calibração estável, quadro íntegro, HUD/sensores preservados, troca no blanking, recuperação e taxa compatível com o perfil lento. Guardar evidência com o hash do BIT. O perfil rápido só poderá ser aceito após orçamento externo e throughput medidos.

## 4. Recuperar o firmware funcional

Como a Flash não foi alterada, desligar/religar no modo de boot habitual restaura o firmware anterior. Confirmar HUD e sensores. Se precisar recarregar SRAM manualmente, repetir a etapa 2 escolhendo `hud-funcional-anterior-recuperacao.bit`, SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`.

Original preservado no PC: `/home/santojuca/Downloads/hud-video-modos-20261106/validation/flash-preparo-20261108-0cez4ytv/hud-aprovado.bit`. O usuário confirmou boot desse firmware; ele não contém esta integração DDR2. Não usar o candidato experimental como arquivo de recuperação. Restauração por regravação da Flash não foi ensaiada nesta missão.

## 5. Flash somente depois do aceite físico

A `.mcs` está pendente de identificação exata da Flash. Após o aceite JTAG, seguir `PROCEDIMENTO_FLASH_QSPI.md`: identificar chip/part/capacidade, gerar MCS correspondente ao BIT aprovado, realizar backup, programar/verificar e comprovar boot por power-cycle. A pre-release não é aprovação para substituir a Flash funcional.
