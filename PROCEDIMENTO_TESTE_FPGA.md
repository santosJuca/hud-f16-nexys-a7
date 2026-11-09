# Teste físico do perfil SPI 5 MHz

**EXPERIMENTAL.** Este procedimento prepara um ensaio futuro; não autoriza nem executa programação. Há um log histórico de JTAG do build anterior de mesmo código, mas o BIT reproduzido para esta publicação não tem ensaio físico novo. Não confundir integridade da configuração (CRC_ERROR) com integridade de setores, quadros ou pixels.

## Conferir o candidato

Baixar todos os assets de `hud-f16-ddr2-spi5-rc-20261109` numa pasta nova, com autenticação do repositório privado, e conferir:

```bash
gh release download hud-f16-ddr2-spi5-rc-20261109 \
 --repo santosJuca/Trabalho-display-aviao-v2 --dir ./hud-spi5-rc
cd hud-spi5-rc
sha256sum -c SHA256SUMS
```

O nome do candidato é `hud-f16-ddr2-f8b36f8-spi-h010-experimental.bit`. O SHA exato está no manifesto e em SHA256SUMS. Há duas emissões conhecidas desse código e perfil; USERCODE sozinho não distingue seus arquivos. Nunca usar o hash histórico `41503a5f...` para identificar automaticamente o BIT desta publicação.

Após autorização específica, o usuário poderá abrir Hardware Manager, conferir Nexys A7-100T / `xc7a100t_0` (serial histórico Digilent/210292AD34F5A) e carregar somente SRAM com esse BIT. Não selecionar configuração de memória/Flash. Antes de programar, registrar caminho, SHA-256, dispositivo e escopo. A Flash e o cartão devem permanecer preservados.

Para identificar a versão, após a carga e atualização do dispositivo, consultar somente em leitura no console Tcl:

```tcl
refresh_hw_device -update_hw_probes false [current_hw_device]
get_property REGISTER.USERCODE [current_hw_device]
```

Esperado: **5DF8B30A**. Identifica o commit/perfil, não recupera o SHA do BIT da SRAM. Guardar o log de programação junto ao hash do arquivo efetivamente selecionado. Se o código não conferir, não atribuir resultados ao candidato.

## Medir reprodução

1. Com o cartão conhecido já instalado e as conexões habituais preservadas, aguardar 20–30 s sem resets repetidos. LD12 e LD13 devem acender. LD14 deve registrar publicação íntegra de banco; LD15 deve permanecer apagado. Fotografar LD12–15. LD14 não garante fundo habilitado: observar também os controles de vídeo existentes.
2. Confirmar fundo em movimento, proporção, canais e qualidade aprovada. Não confundir VGA ~59,52 Hz com quadros novos de vídeo. O arquivo continua 90 quadros 320×240 RGB332, 30 FPS nominais, LBA absoluto 30028160, 13501 setores.
3. Cronometrar três ciclos completos, de uma transição visual identificável até a repetição da mesma transição. Excluir a espera inicial. Registrar T1, T2, T3, pausas e eventual congelamento. Gravar vídeo contínuo de alguns ciclos ajuda a revisar a sequência.
4. Calcular **estimativa** `90/T` somente sob a hipótese de todos os 90 quadros publicados uma vez por ciclo. Se perdas/duplicações não forem observáveis, marcar essa hipótese como não verificada. Contagem instrumentada de ACKs de publicação por janela de tempo é a medida direta; nenhum acesso físico a contador foi acrescentado nesta consolidação.
5. A SPI de 5 MHz tem teto bruto de ~8,14 quadros/s. O modelo CMD17 sem espera do cartão estima ~7,95 quadros/s de carga; sincronismo VGA/latências reduzem a publicação. ~12 s/ciclo é estimativa, não aprovação nem garantia. Não exigir 30 FPS neste perfil.
6. Rodar 10 minutos: sem falha em LD15, perda da calibração, congelamento ou mistura de quadros. Testar modos, joystick, bússola, atitude e ajuste vertical. O fundo não deve desaparecer ao ajustar o HUD. Ausência de erro indicado só cobre os mecanismos monitorados.
7. Se LD15 acender ou LD14 não acender após a partida, registrar firmware, LEDs, tempo até a falha, estado da imagem e comandos usados. Não aumentar a frequência para diagnosticar. CPU RESET do MIG não limpa o histórico de status; uma sessão limpa exige recarga do BIT autorizado. Não remover cartão energizado para provocar erro.

O próximo perfil só deve ser considerado após a qualificação deste. O timing interno positivo não fecha o orçamento elétrico externo. Antes de aumentar novamente, medir com instrumentação a relação entre SCK, MISO estável e a borda efetiva de amostragem, incluindo margem e documentação do cartão. Não inferir sign-off elétrico de uma simulação com atraso estimado.

## Recuperação e Flash

A Flash não foi alterada. Desligar/religar no modo habitual deve carregar o firmware funcional anterior e apagar a configuração JTAG; depois disso o teste desta candidata exige nova carga JTAG. Se precisar recuperar SRAM manualmente, usar `hud-funcional-anterior-recuperacao.bit`, SHA-256 `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`, no mesmo fluxo Program Device.

A pre-release anterior permanece em `hud-f16-ddr2-rc-20261109`, BIT SHA-256 `12b6781beaa60033be1ced9acc8fac564a28ada25f6019f32575c749e8b33370`. Não há `.mcs` desta correção: modelo exato da Flash ainda não confirmado. QSPI somente depois de aceite físico e identificação do chip; seguir PROCEDIMENTO_FLASH_QSPI.md em sessão específica.
