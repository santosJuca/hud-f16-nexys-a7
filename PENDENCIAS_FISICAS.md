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
