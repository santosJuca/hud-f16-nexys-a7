# Diagnóstico da calibração e montagem reposicionada — 30/10/2026

A correção anterior de bias (`9b2c62dd…`) passou na simulação, mas não resolveu a bancada: o usuário confirmou ATT BAD, HDG BAD e MPU CAL `00000020`. Após mover os sensores, confirmou giros no plano, mesma face para cima: MPU e BMP 90° à esquerda; HMC 90° à direita. ACC Z informado apenas como `00004...`; os dígitos ausentes não foram inferidos. LD6 permanece apagado.

Esta alteração muda a estratégia: preserva todos os critérios da calibração anterior e mostra as condições que estão impedindo seu término, além de compensar a nova orientação. Não marca um sensor inválido como válido.

- MPU: retorna ao referencial anterior por `(X,Y,Z)=(-Y,X,Z)`, para acelerômetro e giroscópio. A negação de −32768 satura em +32767. Todos os consumidores do top recebem o mesmo referencial; o painel bruto conserva os eixos nativos.
- HMC: usa os parâmetros existentes para `(X,Y)=(Y_corrigido,-X_corrigido)`. Offsets e ganhos continuam aplicados aos eixos nativos antes da rotação. A calibração magnética anterior precisa ser reavaliada porque o módulo mudou de localização.
- BMP: sem compensação de eixos. Pinagem, drivers de aquisição e vídeo preservados; no HMC apenas a telemetria de NACK foi ampliada.
- `CAL CNT HEX`: progresso atual das amostras aceitas. `CAL BLK HEX`: causas acumuladas da rejeição, limpas ao calibrar ou reiniciar. Bits e critérios em `modo_captura_calibracao.md`. Usa 26 bits antes reservados do mailbox existente, sem aumentar sua largura.
- `MAG IO HEX[7:6]`: etapa do NACK, com 0 endereço W, 1 registrador, 2 dado W e 3 endereço R. A rotação física não explica uma falha de ACK.

O build usa explicitamente o perfil `mpu-left90-mag-right90`, considerando esquerda/direita vistas de cima em relação à posição anterior. O perfil padrão conserva a montagem original.

## Evidências

Pasta: `validation/calibration-reasons-20261030/`. Backup anterior de 254 arquivos; snapshot verificado dos 186 arquivos de entrada em RTL, constraints, scripts, testes e assets. O teste de captura foi adaptado depois desse snapshot para injetar dados na saída nativa do driver; sua versão final está arquivada separadamente em `test-fixture-final.zip`. Nenhuma alteração posterior no RTL foi necessária.

Validações já concluídas: estimador com bias e rejeições direcionadas; 4713 comparações dinâmicas; top com estimador real nas montagens original e girada, incluindo causa da rejeição até a VGA, calibração válida, SW9 e overflow; 4928 pixels do painel; protocolo HMC com NACK em endereço W, registrador e endereço R, timeout e recuperação; 1382 vetores magnéticos em sete configurações, incluindo a nova montagem.

A primeira chamada do teste de captura usou um caminho de fixture inexistente e foi interrompida; o teste foi relançado com o arquivo sintético existente. Esse erro de caminho não modificou hardware nem fontes.

Teste de composição VGA aprovado: 5222400 pixels, quatro vistas, captura, avanço, retomada, ícone e seis eixos nativos chegando intactos à VGA mesmo com a compensação de montagem habilitada. Implementação concluída com saída zero: WNS +0,442 ns; WHS +0,016 ns; WPWS +4,020 ns; TNS/THS/TPWS zero; DRC sem erros e 103 avisos de pipeline DSP; CDC com 500 caminhos seguros e nenhum inseguro/desconhecido; skew 1,471/1,594 ns abaixo de 10 ns. Os 81 pinos externos, sentidos, padrões elétricos e pull-ups são idênticos ao build anterior; buzzer permanece exclusivo em G3/JD4.

Bitstream: `validation/calibration-reasons-20261030/implementation/experimental_attitude_capture.bit`

SHA-256: `ca56218815f952bcd1e8093e03c11f9842c22afc372be3d17ef312b93299b792`.

Fontes RTL e configuração do build continuam idênticas ao snapshot verificado. A versão `ca562188…` foi programada por JTAG volátil após o usuário responder “sIM”. O alvo Digilent 210292AD34F5A e o SHA-256 integral foram conferidos; DONE, INIT_B e fim de startup foram confirmados em 1. Logs e autorização em `validation/calibration-reasons-20261030/program-jtag/`. O funcionamento físico dos sensores ainda aguarda observação do usuário. Flash e microSD não foram escritos. O mapa do cartão permanece arquivado, sem releitura física; a qualificação externa SPI continua pendente.

## Verificação indispensável na bancada

Após programação volátil especificamente autorizada, iniciar com o MPU nivelado e imóvel, SW9–SW11=0 e SW12–SW15=1. Se ATT BAD persistir, abrir a captura com BTNL por cerca de um segundo, depois SW4=SW5=1, e ler `CAL BLK HEX`, `CAL CNT HEX` e `MAG IO HEX`. Não mover a caixa antes dessa leitura, pois os bloqueios acumulam movimento anterior. Depois que a atitude e a comunicação forem recuperadas, conferir os sentidos físicos de roll/pitch e reavaliar a calibração magnética no novo local.

## Reteste informado pelo usuário após ca562188

MPU CAL `00000020`; CAL CNT `0000000.` (último dígito variável/indeterminado); CAL BLK `00000E0F`; MAG IO `00000005`. A correção física ainda não está comprovada.

E0F ativa bits 0, 1, 2, 3, 9, 10 e 11: variações dos três acelerômetros, módulo do gyro X compensado acima de 1310 e nivelamento dos três eixos recusado em algum momento. Após a rotação, gyro X compensado corresponde ao gyro Y nativo com sinal invertido. A máscara acumula desde o reset; não prova que todos esses critérios continuam falhando com o sensor parado agora. Não foram modificados limites com base nesse histórico.

MAG IO 05 registra NACK na etapa 0, endereço de escrita: endereço I²C 1E, byte transmitido 3C. Nenhuma identificação completa foi lida desde a configuração. SDA alta/SCL baixa é apenas snapshot durante a atividade, sem comprovação de linha presa. A próxima verificação do HMC deve ser física, na alimentação e no caminho de SDA/SCL até o módulo.

Foi solicitado um conjunto atual de ACC X/Y/Z e GYR Y, com MPU apoiado e nivelado por 20 segundos, além da disponibilidade de multímetro. O driver não configura explicitamente o filtro interno CONFIG/1A; a documentação oficial prevê DLPF_CFG=3 (44 Hz accel, 42 Hz gyro, atrasos próximos de 5 ms). Isso é uma opção fundamentada de filtragem, ainda não implementada: os dados atuais precisam distinguir ruído, movimento, inclinação e offset persistente antes de outra programação. Referência: https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf

## Leituras posteriores com MPU apoiado

O usuário confirmou CAL ainda 20, ACC X `FFFFFD..`, ACC Y `FFFFF...`, ACC Z `00004050`, GYR Y `FFFFFE..`, e disponibilidade de multímetro. ACC Z é exatamente 16464 counts; ACC X está entre −768 e −513, e GYR Y entre −512 e −257. Na montagem compensada, esses três valores cabem nos critérios iniciais. O prefixo de apenas cinco Fs em ACC Y não resolve seu nível: se literal, inclui valores de −4096 a −1, atravessando o limite de módulo 1400. Foi solicitado o sexto dígito, sem inventar os ausentes. Leituras isoladas não medem a variação entre amostras.

A próxima medição solicitada é VCC contra o GND local no próprio HMC, em tensão contínua, pontas nas entradas COM e V/Ω, sem usar entrada/escala de corrente e sem fechar curto entre pinos adjacentes. Nenhuma alteração de fiação, RTL, limite ou nova programação foi feita nesta etapa.

## Recarga após a correção da montagem

O usuário confirmou −0,48 V no visor e relatou que havia montado errado e corrigiu. Depois informou que só restava HDG BAD e pediu nova execução do bitstream. Como a alimentação pode ter sido interrompida e a carga JTAG é volátil, essa melhora não foi atribuída automaticamente a uma versão específica.

A mesma ca562188 previamente autorizada foi recarregada, com SHA-256 integral e alvo Digilent 210292AD34F5A conferidos; DONE, INIT_B e fim de startup confirmados. Não houve Flash nem escrita no cartão. Autorização, log e resultado em `validation/calibration-reasons-20261030/program-jtag-after-wiring-fix/`. As leituras depois dessa recarga e a tensão atual de SCL ainda são necessárias.

Foi preparada separadamente uma candidata com filtro interno do MPU, SHA iniciado em 084ed844, validada em simulação e implementação. Ela não foi programada; o teste físico corrente usa ca562188. Os detalhes estão em `correcao_filtro_mpu_20261030.md`.
