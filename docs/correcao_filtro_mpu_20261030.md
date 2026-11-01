# Configuração do filtro interno do MPU — 30/10/2026

O usuário informou CAL ainda `00000020`, ACC X `FFFFFD..`, ACC Y agora esclarecido como `FFFFFC..`, ACC Z `00004050` e GYR Y `FFFFFE..`, com o módulo apoiado. Esses valores de aceleração cabem nos limites de nivelamento, inclusive após a compensação de montagem. Os bytes ausentes e a variação entre amostras não foram inferidos. CAL BLK histórico `E0F` inclui rejeições de variação; não é uma captura instantânea da causa atual.

Foi confirmada uma lacuna no driver: nenhuma escrita em CONFIG/1A para selecionar filtragem. A alteração configura DLPF5, próximo de 10 Hz, antes de publicar amostras. Para ID 70, configura também ACCEL_CONFIG2/1D; para ID 68, esse registrador é preservado. Mantém as faixas ±2g e ±250°/s e espera 100 ms após a última configuração do filtro. Uma falha de ACK mantém o sensor inválido e exige nova identificação/configuração completa.

A alteração reduz a largura de banda para o demonstrador manual e acrescenta atraso. No MPU6050, a tabela do fabricante informa 13,8 ms no acelerômetro e 13,4 ms no gyro para DLPF5. Não há garantia de movimento rápido sem atraso. Critérios de calibração, detecção de movimento, integração com dt, rotação de montagem, pinagem e todos os outros módulos RTL permanecem idênticos à versão ca562188.

O efeito sobre a rejeição física é hipótese a validar: configurar o filtro não comprova que o ruído era a única causa. O teste de protocolo verifica as escritas, ordem, ACK/NACK, espera antes das leituras, atomicidade e recuperação, sem simular ruído real do silício.

## Magnetômetro e condição elétrica

O usuário mediu alimentação de 3,3 V nos módulos, SDA do HMC em 3,3 V e informou SCL como −0,48 V. O sinal negativo ainda precisa de confirmação. Foi orientado desligar a Nexys e desconectar USB antes de tocar nos fios; confirmar se o SCL vai ao JD9 e testar o jumper isolado nas duas pontas em continuidade. A leitura de multímetro durante comunicação é uma média e não substitui osciloscópio. Alimentação correta não comprova continuidade de SDA/SCL nem ausência de dano no módulo.

Nenhuma nova programação será executada antes de esclarecer a ligação SCL e a segurança da medição. A compilação local não energiza nem altera hardware. O build anterior ca562188 e os demais arquivos de recuperação foram preservados.

## Evidências locais

Pasta `validation/mpu-filter-20261030/`: backup verificado de 252 arquivos, snapshot dos 186 arquivos de entrada, observação da bancada, diff e logs. A primeira tentativa de usar Verilator foi recusada por uma construção preexistente do teste (`disable` de bloco externo); o teste foi relançado no Icarus, simulador usado pelo script do repositório. Não se modificou o caso de recuperação para contornar essa limitação. Teste Icarus concluído com PASS, incluindo as duas identidades aceitas, NACK dos filtros, espera de 100 ms, publicação atômica, clock stretching e recuperação de SDA/SCL presas. Implementação concluída com saída zero: WNS +0,210 ns, WHS +0,052 ns, WPWS +4,020 ns, TNS/THS/TPWS zero; DRC sem erros, 103 avisos de pipeline DSP; CDC 500 seguros e nenhum inseguro/desconhecido. Os 81 pinos são idênticos a ca562188; G3/JD4 permanece exclusivo do buzzer. Nenhuma programação desta candidata.

SHA-256 da candidata: `084ed844e870f404b7c9e51485f0908ce8a2b283b7da440454a879adcf7d9ac9`. Fontes e configuração conferidas contra o snapshot após o build.

## Referências

- [TDK MPU6050: CONFIG/1A e DLPF5](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf).
- [TDK MPU6500: WHO_AM_I=70 e configuração de gyro](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6500-Register-Map2.pdf). O endereço antigo do PDF redirecionou; os trechos indexados foram consultados. A aceitação de ID 70 é compatibilidade existente no projeto, não identificação física nova nesta execução.
- Implementação primária Bolder Flight Systems: [configuração de ambos os filtros](https://github.com/bolderflight/invensense-imu/blob/main/src/mpu6500.cpp) e [endereços 1A/1D, DLPF10Hz=05](https://github.com/bolderflight/invensense-imu/blob/main/src/mpu6500.h). Não foi copiado código da biblioteca para o projeto.

## Correção de montagem informada

O usuário confirmou que o sinal negativo estava no visor e informou: “Agora arrumei, tinha montado errado”. Foi solicitado identificar a ligação corrigida, mantendo a placa desligada até confirmar o destino. A prioridade passa a ser retestar ca562188 com a montagem corrigida. A candidata com filtro continua como alteração local; não será usada para atribuir uma melhora da fiação ao software.

O usuário depois informou que só restava HDG BAD e solicitou recarregar o bitstream após desligar a placa. Não é possível atribuir a melhora de ATT à ca562188 sem confirmar qual configuração voltou após a interrupção de energia. Foi iniciado o recarregamento da mesma ca562188 previamente autorizada, sem usar a candidata com filtro. As leituras após essa recarga são a próxima evidência necessária.

## Programação autorizada

Após a recarga ca562188, o usuário informou ATT BAD e HDG BAD ainda presentes. A candidata 084ed844 recebeu autorização específica condicionada à correção de SCL. O usuário confirmou “Tudo certo 3,31”, satisfazendo a conferência pendente da tensão SCL/GND no módulo.

A versão 084ed844 foi então programada via JTAG volátil. Alvo Digilent 210292AD34F5A e SHA-256 integral conferidos; DONE, INIT_B e fim de startup em 1. Não houve escrita em Flash nem no microSD. Evidências em `validation/mpu-filter-20261030/program-jtag/`.

O funcionamento físico do MPU e do HMC continua aguardando as leituras após essa programação. A medição DC de SCL não qualifica integridade de sinal dinâmica nem comprova que o magnetômetro responde.

## Resultado físico após 084ed844

O usuário confirmou que resta apenas HDG BAD. MPU CAL `00000033` significa calibrado, em repouso, atitude válida e sensor identificado; CAL BLK `00000000`. Isso comprova calibração estacionária e validade de ATT no HUD com esta versão. Não mede redução de ruído, precisão angular ou sentido dos eixos durante movimento; esses pontos não foram qualificados por essa observação.

MAG ID `00000000` e MAG IO `00000007`: SDA e SCL altas no snapshot, NACK na etapa 0 (endereço de escrita 1E, byte 3C), sem qualquer identificação completa. A rotação e a calibração magnética só entram em ação depois que a aquisição responde, portanto não corrigem esse NACK. O MPU deve ser preservado enquanto se verifica o caminho elétrico do HMC.

Foi solicitado teste de continuidade de SDA até JD3 e SCL até JD9, com toda alimentação removida, incluindo USB e fonte, para verificar também cabos e contatos. A tensão em repouso de 3,3 V não comprova continuidade de sinais até o módulo. Depois será recarregada a mesma 084ed844, já autorizada.

## Recarga após a conferência de continuidade

Após as instruções de continuidade, o usuário respondeu “Ok acho que agora foi” e depois “Isso”. Não forneceu valores de resistência nem distinguiu explicitamente os dois caminhos. A mesma 084ed844 foi recarregada conforme a autorização persistente; alvo, SHA-256, DONE, INIT_B e fim de startup foram confirmados novamente. Não houve escrita de Flash nem microSD. Evidências em `validation/mpu-filter-20261030/program-jtag-after-continuity/`. O estado do magnetômetro após essa recarga ainda depende de relato do usuário.

## Relato após a última recarga

O usuário informou: “Fechou, agora deu bom, não está apitando nada”. Foi registrado como relato de funcionamento e cessação dos apitos após a recarga 084ed844. Esse relato não trouxe novos valores MAG ID/IO nem afirmou separadamente que HDG BAD desapareceu; silêncio do buzzer não foi usado como prova isolada de validade do rumo. Não foi iniciada nova compilação, diagnóstico adicional ou programação.

## Confirmação final dos sensores

O usuário confirmou explicitamente que HDG BAD também sumiu e não há mais apitos. ATT BAD já havia desaparecido com MPU CAL33 e CAL BLK0. Considera-se recuperado o funcionamento de bancada da atitude e do rumo no HUD, na 084ed844, após o filtro do MPU e a correção de montagem. Essa confirmação não é medição de precisão angular, nem de calibração magnética no novo local; não foram inventados valores finais de MAG ID/IO. O usuário relatou depois um problema separado no controle que chamou de “switch”; a versão funcional dos sensores será preservada durante essa investigação.

## Recarga após remontagem do joystick

Após o desenho exclusivo do joystick na protoboard de 170 pontos, o usuário informou que a montagem deu certo e sugeriu reiniciar. Foi recarregada a mesma versão 084ed844, com alvo e SHA-256 conferidos e DONE, INIT_B e fim de startup em 1. Sem escrita de Flash ou microSD. Evidências em `validation/mpu-filter-20261030/program-jtag-after-joystick-rewire/`. O usuário foi orientado a manter a alavanca centralizada durante a recarga; a resposta da mira e dos LEDs LD0–LD3 após a recarga ainda aguarda observação. Não foram fornecidas medições numéricas das entradas analógicas.
