# Frente oposta e calibração da montagem

A frente escolhida passa a ser o lado oposto, com a mesma face dos módulos para cima e sem alteração dos fios. O perfil `mpu-left90-mag-right90-front180` preserva a montagem anterior de 90° e acrescenta `FRENTE_INVERTIDA_180=1`. No MPU, X/Y do acelerômetro e do giroscópio mudam de sinal no referencial da montagem; Z permanece igual. As operações são compostas antes da saturação para evitar dupla negação incorreta de −32768. No HMC, a troca de eixos e os offsets/ganhos nativos continuam; as duas inversões finais são alternadas, somando 180° ao rumo, módulo 360.

Pinagem, joystick, LOCK, filtro do MPU, limiares de calibração, barômetro, aquisição I²C e parâmetros de vídeo/microSD são preservados. O parâmetro novo tem padrão zero; os perfis anteriores mantêm o comportamento. O perfil magnético medido em 19/10 permanece provisório até nova calibração na montagem final. A mudança de frente não substitui essa medição.

## MPU: primeiro orientação, depois nível

Após programar a versão identificada, mantenha o conjunto nivelado e imóvel, com o joystick centralizado. Use SW9–SW11=0 e SW12–SW15=1. Espere a atitude ficar válida. Levantar a nova frente deve baixar a linha do horizonte; baixar a frente deve subi-la. Baixar a direita deve girar a linha do horizonte para a esquerda. Confira uma direção por vez, retornando ao nível.

Depois de confirmar os sentidos, entre na captura segurando BTNL por cerca de 1 s, com o vídeo habilitado. SW4=1 e SW5=1 abrem o diagnóstico. Para pedir zero temporário, apoie próximo do nível, aguarde repouso e mude SW7 de 0 para 1. O zero exige atitude válida e estável, com roll/pitch brutos dentro de ±5°. MPU CAL bits 0, 1, 2, 4 e 5 indicam calibração, repouso, zero aceito, atitude válida e sensor identificado; sem recusa, o código correspondente é 00000037. Não inferir aceitação apenas pelo acionamento do switch. Esse zero se perde na reconfiguração. Segurar BTNL novamente sai da captura.

## Magnetômetro e barômetro

Depois de aprovar o MPU, reavaliar offsets e ganhos do magnetômetro com o conjunto nivelado, na posição final e com frente definida. Esta versão preserva o cálculo plano, sem compensação de inclinação nem declinação geográfica. O barômetro não define frente; comparar a altitude com uma referência conhecida antes de ajustar a referência de pressão. Não foram inventados offsets, ganhos novos ou altitude de referência.

## Evidências

Backup verificado e entradas de build em `validation/frente-180-20261031/`. Testes concluídos com PASS nas três configurações. Implementação concluída: WNS +0,117 ns, WHS +0,012 ns, WPWS +4,020 ns, TNS/THS/TPWS zero. DRC sem erros, 103 avisos de pipeline DSP preexistentes; CDC 500 seguros, sem inseguros/desconhecidos. Todos os 81 pinos e suas propriedades coincidem com a versão 084ed844, incluindo PULLUP do botão JA1. O usuário autorizou especificamente a programação JTAG volátil da versão 7b4b6ec0. O alvo Digilent 210292AD34F5A e o SHA-256 integral foram conferidos; DONE, INIT_B e fim de startup em 1, saída do Vivado zero. Sem escrita de Flash ou microSD. A validação física dos novos sentidos e o zero temporário permanecem pendentes de observação do usuário. O bitstream anterior 084ed844 permanece preservado para retorno.

Bitstream candidato SHA-256: `7b4b6ec0b638abfc05715ef0e4d33330df3511f6ebb9cf6b7d75f6597eef7c51`.

O usuário confirmou que levantar a nova frente faz a linha do horizonte descer na versão 7b4b6ec0. Sentido de pitch aprovado por observação; roll, zero temporário e precisão angular ainda não confirmados.

O usuário confirmou também o sentido de roll: ao baixar a direita do conjunto, a ponta direita da linha do horizonte sobe e a esquerda desce. Pitch e roll estão aprovados quanto ao sentido na nova frente. Próximo passo: zero temporário em repouso e leitura do código MPU CAL; não há medição de precisão angular.

Após solicitar o zero, o usuário relatou “S perto de 037”. Registrado como leitura aproximada compatível com 00000037, sem inferir o valor hexadecimal completo ou confirmação separada do nivelamento da linha.
