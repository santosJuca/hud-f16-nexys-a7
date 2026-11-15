# Calibração HMC5883L em 08/11/2026

Coleta física via JTAG/VIO no worktree experimental, guiada pelo usuário nas posições relativas 12→1→3→6→9→12, sempre no sentido horário visto de cima. São 1.873 publicações únicas válidas em 191,3 segundos, com os 12 setores de 30° cobertos. Nenhuma amostra foi rejeitada por invalidade, overflow ou inclinação. As posições manuais são aproximadas, sem referência angular independente.

A inclinação foi medida antes da zeragem angular do MPU: máximo absoluto de roll 3,2403° e pitch 2,1982°, abaixo do limite de coleta de 5°. O canal VIO somente observa os sinais e foi adicionado em um snapshot isolado. A versão de coleta mantém a recuperação I²C do MPU, vídeo antigo 160×120 a 1 FPS e a montagem `mpu-left90-mag-right90-front180-hdg-plus90`. Não houve escrita em Flash ou SD.

| Eixo nativo | Mínimo | Máximo | Offset | Ganho Q12 |
| --- | ---: | ---: | ---: | ---: |
| X | 760 | 1024 | 892 | 4546 |
| Y | -435 | -113 | -274 | 3727 |

O offset é o ponto médio dos extremos. O ganho é a média das meias amplitudes dividida pela meia amplitude do eixo, multiplicada por 4096 e arredondada. A correção é aplicada nos eixos nativos antes da montagem. Não foram alterados os eixos do MPU nem acrescentada rotação magnética nesta recalibração.

A calibração anterior usava X 717, Y −161, GX 4545 e GY 3727. Nos dados atuais, X mínimo 760 é maior que o offset 717: o X corrigido antigo nunca troca de sinal. Reprocessar esta mesma volta com os parâmetros antigos cobre somente quatro setores de 30°. Os novos parâmetros cobrem os 12 setores. Isso demonstra uma incompatibilidade da calibração antiga com a medição atual; não identifica qual mudança física ou ambiental a causou.

O raio corrigido tem média 143,44 counts e desvio padrão 5,02 counts (CV 3,50%), contra CV 32,76% ao reaplicar a calibração antiga. O retorno XY entre a média das primeiras e das últimas 20 amostras é 14,73 counts. São medidas de consistência do ajuste planar, sem equivalência direta a precisão angular.

## Dados e reprodução

`amostras.csv` preserva cada pacote hexadecimal, valores nativos assinados, contador de publicação, tempo, validade e inclinação. `resumo.json` registra parâmetros, critérios de aceitação, comparações e hashes; `posicoes_guiadas.json` registra as confirmações do operador. A coleta bruta e os scripts de leitura/análise estão em `validation/bussola-coleta-20261108-5y5d40pe/`. O leitor finalizou normalmente após a confirmação de retorno a 12h. O polling JTAG pode saltar publicações do sensor; não é uma captura de todas as publicações internas.

O teste RTL passou com 1.765 vetores em 11 configurações e inclui os novos parâmetros, os pontos medidos, uma volta sintética na amplitude observada, centro sem rumo definido, cardeais, wrap, overflow e perda do sensor. A implementação e a programação da versão normal corrigida devem ser verificadas separadamente nos artefatos de validação.

## Limites

Este perfil corrige offsets e escala por eixo no plano, específico desta montagem e dos materiais próximos. Não acrescenta compensação de inclinação, matriz geral de soft-iron nem declinação geográfica. O celular ainda precisa ser conferido em norte magnético para medir o alinhamento absoluto. A nova calibração foi aplicada por JTAG; o funcionamento físico após aplicação permanece pendente.

## Candidato normal gerado

A versão normal sem VIO foi gerada com WNS +0,105 ns e WHS +0,011 ns, zero erros de DRC e 624 travessias de clock seguras, sem inseguras ou desconhecidas. Há 107 avisos de pipeline DSP. As restrições externas de SPI continuam sem qualificação completa; o vídeo preserva o perfil anterior de 400 kHz. O mapa do SD não foi relido nesta compilação.

SHA-256 do candidato: `953a6416f25e1ff2ee5aa13c9a5b84dd4b59c85c73dbefec4d115154e6cd73a2`. Fontes, relatórios, testes e script JTAG com conferência de identidade estão em `validation/bussola-coleta-20261108-5y5d40pe/calibrado/`. Somente o arquivo de calibração mudou entre as fontes deste build e as do bitstream46568cdd; o caminho da referência do ícone mudou para a cópia idêntica no snapshot. A versão foi autorizada pelo usuário e programada por JTAG em 08/11/2026. Identidade da Nexys e SHA-256 conferidos, DONE/INIT_B/EOS em 1 e CRC_ERROR em 0; saída zero. Flash e SD preservados. A resposta física ao giro e a comparação absoluta com norte magnético permanecem pendentes. Evidências em `calibrado/jtag-aprovado-qqlgx3mq/` dentro do diretório de validação acima.

## Comparação inicial com celular após JTAG

O usuário informou os pares FPGA/celular 72°/154°, 168°/245° e, ao retornar à posição inicial, 71°/150°. A FPGA acompanhou um giro de96°, contra91° no celular, e voltou a1° da leitura inicial. As diferenças entre celular e FPGA foram82°,77° e79°. Isso sugere uma diferença sistemática de alinhamento nesta comparação limitada. As posições são aproximadas e o tipo de norte do aplicativo ainda não foi confirmado. Nenhum ajuste angular adicional foi aplicado e a precisão absoluta permanece não validada.

## Alinhamento relativo ao celular, candidato +81°

Depois de programar a calibração medida, o usuário informou novos pares FPGA/celular 73°/154° e 163°/244°. As duas comparações têm diferença exata de +81° e acompanham o mesmo giro de 90°. Foi preparado o parâmetro separado `MAG_ALINHAMENTO_GRAUS=81`, aplicado após a correção dos eixos e o cálculo angular, antes da fusão de rumo. Os offsets 892/−274, ganhos 4546/3727, perfil de montagem e orientação do MPU permanecem iguais. O valor padrão do RTL é 0. A soma é circular, no intervalo 0..359°, e mantém as regras de validade e perda do sensor.

A referência é a bússola do celular informada pelo usuário. O tipo de norte e o aplicativo não foram confirmados; esta comparação não valida norte magnético/geográfico absoluto. O ajuste não acrescenta compensação de inclinação nem nova calibração magnética. Fontes, testes e compilação do candidato estão em `validation/bussola-alinhamento81-20261108-xzphexol/`. Nenhuma programação deste candidato foi feita nesta etapa.

O alinhamento +81° passou em 1.767 vetores de heading em 13 configurações, incluindo os dois pares informados, wrap, limites, overflow e perda do sensor; parâmetros −1 e 360 são rejeitados. A integração pelo Icarus passou com alinhamento 0 e 81, mantendo fallback manual, recuperação do HMC, atualização do HUD na fronteira do quadro e independência do MPU/joystick. A parametrização 0 preserva o comportamento anterior.

Referência técnica: [NXP AN4248](https://www.nxp.com/docs/en/application-note/AN4248.pdf), seções 2 e 5, distingue alinhamento de eixos e compensação de campo. O cálculo atual do projeto permanece planar. A comparação com o celular não constitui medição de norte absoluto.

O candidato +81° foi gerado com WNS +0,578 ns, WHS +0,009 ns, 624 CDC seguros, zero inseguros/desconhecidos e zero erros DRC. Há 105 avisos de pipeline DSP. SHA-256: `bc49675cefe1eff956004b3c8cae4372261250176b5da9ac0e59a4d998db9064`. O script JTAG confere o arquivo e a identidade `Digilent/210292AD34F5A`, dispositivo `xc7a100t_0`. O candidato +81° foi autorizado pelo usuário e programado por JTAG em 08/11/2026, com identidade e SHA-256 conferidos, saída zero, DONE/INIT_B/EOS em1 e CRC_ERROR em0. Flash e SD permanecem preservados. A comparação física após este ajuste ainda está pendente; evidências em `validation/bussola-alinhamento81-20261108-xzphexol/jtag-aprovado-jinsjden/`. A temporização externa SPI continua sem qualificação completa, com o mesmo perfil de vídeo antigo a 400 kHz.

A gravação do candidato +81° substituiu a versão recalibrada sem ajuste angular somente na configuração volátil da FPGA. A ausência de VIO na versão normal foi confirmada; o aviso de nenhum VIO encontrado é esperado. A confirmação visual do rumo e do MPU nesta nova partida permanece separada da verificação dos registradores de configuração.
