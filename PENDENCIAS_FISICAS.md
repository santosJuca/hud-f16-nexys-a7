# Pendências físicas do perfil SPI 5 MHz

A publicação contém uma reprodução offline do commit f8b36f8. O log JTAG histórico pertence à emissão de hash 41503a5f..., não ao novo BIT. Nenhuma programação foi executada nesta consolidação.

| Pendência | Evidência necessária |
|---|---|
| Identidade da emissão | Hash do arquivo selecionado, log de carga autorizado e USERCODE 5DF8B30A. O código identifica perfil, não SHA recuperado da SRAM. |
| Publicação DDR2/VGA | LD12/13/14, ausência de falha LD15, fundo habilitado e sequência contínua. LD14 indica histórico de banco íntegro publicado. |
| FPS | Três ciclos cronometrados; estimativa 90/T supõe todos os quadros publicados uma vez. Medida direta requer contagem de ACKs por tempo. |
| Operação contínua | Dez minutos sem erro, congelamento ou mistura de quadros; testar modos/joystick/ajuste vertical/atitude/bússola. |
| SPI externo | Latência real do cartão, datasheet/interface e medição de SCK/MISO/amostragem antes de subir a frequência. Timing interno e atraso estimado de modelo não bastam. |
| MIG/reset/clocking | Calibração/PHY, temperatura e recuperação na placa; ressalvas CDC-10/CDC-8 e REQP-1709 permanecem documentadas. |
| Hold | Margem roteada de somente +0,006 ns; reconferir a cada mudança/build. Não é margem elétrica do microSD. |
| Flash | Identificar chip exato, aceitar fisicamente o candidato, preparar recuperação e obter autorização específica antes de gerar/gravar MCS. |

O mapa histórico do cartão permanece LBA absoluto 30028160, 13501 setores contíguos, 90 quadros 320×240 RGB332. Não houve nova leitura nem escrita do cartão; refazer o mapa se seu conteúdo mudar. O vídeo completo de 17.331 quadros permanece fora do cartão de teste conforme evidências anteriores, sem nova validação integral nesta consolidação.

A leitura de 5 MHz não sustenta 30 FPS nesse formato: limite bruto ~8,14 FPS, menor com overhead/esperas. Não reduzir qualidade para ocultar o gargalo. Preservar a Flash funcional e a alternativa BRAM. Procedimento detalhado e recuperação em PROCEDIMENTO_TESTE_FPGA.md.

## Novos candidatos locais 10/12,5 MHz

Existem dois BITs offline adicionais, identificados em RESULTADO_FINAL.md. Nao foram publicados nem programados. A base de 5 MHz permanece como primeiro ensaio. Depois dele, confrontar a interface com o orcamento de 10 MHz antes de pedir autorizacao para novo arquivo/alvo. O candidato de 12,5 MHz tem apenas 17,308 ns de janela calculada para cartao/trilhas; no stress 45 ns falhou nas oito tentativas com deteccao. Nao libera-lo automaticamente.

FPS recebido, validado e publicado ainda nao foram medidos na placa. A sonda opcional OOC e o procedimento ILA estao prontos para uma futura integracao; nao existem probes novos nos BITs atuais. Nenhum contador de underrun ou descarte de quadro unico foi inventado. O filme inteiro exige 2599651 setores; nao substituir o arquivo atual nem conservar automaticamente seu LBA para o filme maior. Se partisse do LBA historico, precisaria terminar antes do LBA exclusivo 32627811, a confrontar com capacidade/alocacao reais.

30 FPS RGB332 bruto continua impossivel nos perfis 10/12,5 MHz por largura de banda. A viabilidade de um PHY/captura a 25 MHz depende de engenharia e instrumento, nao do teto bruto. A proposta de cache curto de 90 quadros nao e streaming sustentado do filme inteiro e ainda nao foi implementada.
