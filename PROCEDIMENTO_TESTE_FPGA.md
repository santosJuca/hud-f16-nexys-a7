# Teste físico da correção LD14/LD15

**EXPERIMENTAL — NÃO VALIDADO FISICAMENTE.** A correção muda somente diagnóstico. O agente não programou JTAG, Flash ou cartão nesta execução. A primeira fotografia foi atribuída pelo usuário à candidata anterior; a origem física DDR2 dos pixels não pôde ser comprovada nesta máquina, sem USB-JTAG enumerada.

## Baixar, verificar e identificar

Baixar todos os assets da nova pre-release numa pasta nova (o repositório é privado):

```bash
mkdir hud-ddr2-status-rc
cd hud-ddr2-status-rc
gh release download hud-f16-ddr2-status-rc-20261109 \
 --repo santosJuca/Trabalho-display-aviao-v2 --dir .
sha256sum -c SHA256SUMS
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode gui
```

Usar `hud-f16-ddr2-b38e538-status-experimental.bit`, identificado no manifesto e SHA256SUMS. Não confundir com o BIT anterior `hud-f16-ddr2-74b3541-experimental.bit` ou com o firmware funcional de recuperação.

Com o microSD conhecido já no slot e as conexões habituais, abrir Hardware Manager → Open Target → Auto Connect. Conferir a Nexys A7-100T e `xc7a100t_0`; serial histórico Digilent/210292AD34F5A. Program Device deve receber apenas o BIT corrigido no campo Bitstream File. Não selecionar configuração de memória/Flash. Esta operação é feita pelo usuário, não foi executada pelo agente.

Guardar caminho, hash, log e DONE/INIT_B/EOS/CRC_ERROR disponíveis. Depois atualizar o dispositivo no Hardware Manager e consultar no Tcl Console, somente em leitura:

```tcl
refresh_hw_device -update_hw_probes false [current_hw_device]
get_property REGISTER.USERCODE [current_hw_device]
```

O candidato corrigido deve informar **B38E538B**, correspondente ao commit RTL `b38e538b330805b265fe1b9a7cf45d7c5501acec`. USERCODE é identificador de versão, não SHA-256 recuperado da SRAM. Se o valor não conferir, não atribuir imagem/LEDs a esta candidata. A versão anterior usava USERID padrão FFFFFFFF, insuficiente para diferenciá-la de outros builds com o mesmo padrão.

## Conferir os LEDs e o vídeo

1. Logo após a carga, LD14/LD15 devem começar apagados. LD12 indica lock da referência; LD13, calibração MIG. Se LD12=0 ou LD13=0, registrar esse estado antes de avaliar vídeo.
2. Aguardar 20–30 s após a carga, sem reiniciar repetidamente. Há liberação de vídeo por sensores/timeout de até 10 s e carga de pelo menos 1,569 s/quadro a 400 kHz, além de esperas. Não aumentar SPI para diagnosticar um LED apagado.
3. **LD14 aceso:** houve commit íntegro de retorno DDR2 e ACK da seleção do banco de exibição. Ele permanece aceso durante o quadro seguinte e não prova que o fundo está habilitado ou visível sob o HUD. **LD15 aceso:** houve falha de vídeo/retorno/buffer nesta sessão; permanece aceso mesmo após recuperação. Os dois acesos significam sucesso e também falha no histórico.
4. Com LD14=1, habilitar o fundo pelo controle existente BTNL e registrar a sequência de imagens mudando. Conferir proporção/canais, estabilidade VGA, ausência de mistura/tearing e manutenção da última imagem entre atualizações. Alternar vídeo/HUD ajuda a separar fundo e simbologia procedural; uma imagem estática isolada não comprova tráfego DDR2 contínuo.
5. O cartão continua com 90 quadros RGB332 320×240/30 nominal, LBA absoluto 30028160 e 13501 setores contíguos. O perfil físico permanece 400 kHz: loop >=141,21 s antes de esperas. Registrar o retorno ao início e o tempo real. Não classificar isso como 30 FPS físicos.
6. Exercitar modos, joystick, bússola e ajuste vertical: o fundo não deve desaparecer com o deslocamento do HUD. A orientação dos sensores não foi alterada; não compensar ângulos espontaneamente.
7. Um CPU RESET do MIG não limpa o histórico de LD14/LD15 e pode registrar abort de transferência. Para uma sessão limpa, recarregar o BIT corrigido por JTAG e conferir novamente USERCODE/LEDs. Não remover cartão energizado nem desconectar a DDR2 para injetar falha. Em erro, registrar primeiro o estado e recuperar a versão anterior.

| LD13 | LD14 | LD15 | Interpretação |
|---|---|---|---|
| 0 | qualquer | qualquer | MIG não está calibrado agora; histórico não substitui estado atual. |
| 1 | 0 | 0 | Nenhuma publicação confirmada nesta sessão; aguardar partida/carga e observar atividade SD. |
| 1 | 1 | 0 | Pelo menos um banco íntegro confirmado, sem falha registrada. |
| 1 | 0 | 1 | Falha registrada sem publicação íntegra confirmada. |
| 1 | 1 | 1 | Houve publicação e também falha; possível recuperação ou falha posterior. |

LD7 é SD_READY, LD8 erro SD e LD9 atividade SD na pinagem existente. `sd_publications` é contador do ícone/overlay de setor, não de vídeo. `video_frames` conta conclusão SD, não banco VGA. `video_late` é esperado no perfil lento. As etapas e contadores estão detalhados em VALIDACAO_OFFLINE.md. Nem todas as páginas dos contadores são acessíveis na configuração de switches; não inventar leitura física. Não foi acrescentada ILA.

## Recuperação e Flash

A Flash não foi alterada. Desligar/religar no modo habitual deve carregar o firmware funcional anterior e apagar a configuração JTAG; depois disso o teste desta candidata exige nova carga JTAG. Se precisar recuperar SRAM manualmente, usar `hud-funcional-anterior-recuperacao.bit`, SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`, no mesmo fluxo Program Device.

A pre-release anterior permanece em `hud-f16-ddr2-rc-20261109`, BIT SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. Não há `.mcs` desta correção: modelo exato da Flash ainda não confirmado. QSPI somente depois de aceite físico e identificação do chip; seguir PROCEDIMENTO_FLASH_QSPI.md em sessão específica.
