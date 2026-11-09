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

## Sonda opcional para contagem direta (ainda fora dos BITs)

`hud/rtl/video_publication_metrics.sv` foi validado em teste de eventos/reset/wrap e implementado isoladamente (OOC): 37 LUTs, 162 FF, WNS +6,985 ns / WHS +0,198 ns. **Não está instanciado no top dos candidatos de 5/10/12,5 MHz.** O resultado OOC não qualifica o impacto de sua futura integração nem o custo da ILA. Não há contador novo acessível na placa atual.

Para um futuro build de diagnóstico, em branch própria, inserir este bloco dentro de top_reticula, após as declarações dos sinais relacionados; não alterar ready/dados/FSM:

```systemverilog
(* MARK_DEBUG = "TRUE" *) wire [31:0] perf_validated, perf_published, perf_ticks, perf_interval;
(* MARK_DEBUG = "TRUE" *) wire perf_interval_valid;
(* MARK_DEBUG = "TRUE" *) reg perf_snapshot = 0;
always @(posedge clk_hud)
    if (reset_operacao) perf_snapshot <= 0;
    else perf_snapshot <= video_frame_published;
video_publication_metrics u_video_metrics (
    .clk(clk_hud), .rst(reset_operacao),
    .ddr_commit(ddr_out_commit), .vga_published(video_frame_published),
    .validated_count(perf_validated), .published_count(perf_published),
    .time_cycles(perf_ticks), .last_interval_cycles(perf_interval),
    .interval_valid(perf_interval_valid)
);
```

Todos os eventos pertencem ao clock HUD. `ddr_out_commit` já vem da FIFO de retorno, após CRC32; `video_frame_published` é o ACK já sincronizado no lado de escrita. **Não conectar `rd_updated` do clock pixel diretamente à sonda/ILA HUD.** O pulso perf_snapshot atrasa a qualificação um ciclo para a ILA capturar os contadores já atualizados. Acrescenta um FF além do núcleo OOC.

No Vivado Set Up Debug, marcar também os sinais HUD existentes abaixo, escolher clock `clk_hud`, habilitar storage qualification e profundidade 1024 para uma captura por publicação. Qualificar captura por `perf_snapshot == 1`; exportar CSV para guardar os dados. Implementar e conferir timing/CDC/DRC/recursos de todo o top antes de emitir um BIT diagnóstico. Só depois pedir autorização específica para carregá-lo. Referência: [AMD UG908, ILA](https://docs.amd.com/r/en-US/ug908-vivado-programming-debugging/ILA).

| Medida | Sinal ou cálculo | Limite |
|---|---|---|
| Recebido SD | video_frames, video_cycles | Conta conclusão do loader, não exibição. Transfer_cycles mede carga SD. |
| Validado DDR2 | perf_validated | Incrementa no commit de retorno CRC32 válido. Não contar smoke_done, que é transitório/UI. |
| Publicado VGA | perf_published | ACK da publicação do banco. Fundo pode estar desabilitado mesmo com banco válido. |
| Intervalo publicado | perf_interval / 100000000 s | Só usar com perf_interval_valid=1. Primeiro evento não tem intervalo. |
| FPS publicado | 100000000 / média(perf_interval) | Salvar todos os intervalos consecutivos; não tirar média de FPS individuais. Clock nominal, sem calibração metrológica nova. |
| Erros de carga | video_errors, video_failed | São tentativas/erros; retries podem pertencer ao mesmo quadro. Não chamar isso de quantidade de quadros únicos descartados. |
| CRC16 SD | video_owner, sd_read_error, sd_read_error_code==5 | Em aquisição separada, disparar na subida de sd_read_error com owner vídeo. O nível é retido: não contar cada ciclo alto como erro. Nenhum contador CRC dedicado foi integrado. |
| Abort/preservação | p4b_frame_abort, ddr_out_abort, video_frame_buffer_error, LD15 | Abort inicial de calibração não é quadro perdido. A deduplicação por tentativa exigiria identificar início/commit/abort, não somar ambos cegamente. |
| Atraso/underrun | video_late e intervalos de publicação | video_late compara carga à meta nominal. Repetir último quadro no VGA é política de retenção, não um contador de underrun FIFO. Não existe um contador físico novo de underrun nesta entrega. |

O timestamp de 32 bits em 100 MHz volta a zero a cada ~42,95 s; a subtração modular continua correta para intervalos menores que esse limite. Não calcular uma janela de dez minutos por uma única diferença modular de timestamps. Somar intervalos de publicações consecutivas ou usar janelas menores. Se o fluxo parar, os contadores e o último intervalo ficam retidos; isso não comprova que o FPS atual permaneça positivo. Registrar também ausência de novos eventos e tempo do observador.

As páginas físicas atuais do display continuam limitadas a 0–7 por `{1'b0,SD_DIAG_PAGE[3:1]}`; as páginas RTL 12–15 de vídeo não se tornaram automaticamente acessíveis. `display_frame_id` e `sd_publications` não substituem contador de banco publicado. Não atribuir leituras inexistentes ao Hardware Manager sem ILA/probes configurados.

## Gate para considerar os candidatos de 10 e 12,5 MHz

1. Primeiro validar a emissão publicada de 5 MHz pelo hash 2fd3dbc1...e1157b2 e USERCODE 5DF8B30A, conforme o começo deste documento. Guardar três ciclos e dez minutos de estabilidade com LD14=1/LD15=0 e controles íntegros.
2. Isso aprova somente esse ensaio de 5 MHz; não fecha eletricidade em frequência maior. Conferir datasheet do cartão efetivo e medir SCK/MISO, setup e hold na fase de amostragem, sem presumir ausência de carga/trilhas. Confrontar com os relatórios IO do candidato de 10 MHz.
3. Somente com orçamento coerente e autorização específica, considerar JTAG SRAM do arquivo de 10 MHz identificado no manifesto. Não programar por instrução genérica de continuação. Repetir identidade, medidas, sequência, dez minutos, modos e recuperação.
4. O candidato de 12,5 MHz fica retido até o anterior passar e seu orçamento externo ser confirmado. No stress de 45 ns ele falhou com detecção. Não tratar esse resultado como medição de defeito da placa nem como aprovação genérica de 12,5 MHz.
5. Em qualquer falha, registrar antes de recarregar e voltar ao perfil anterior autorizado/Flash funcional. Não subir frequência, gravar Flash ou modificar cartão para mascarar o problema. Nenhum dos novos BITs foi programado nesta sprint.
