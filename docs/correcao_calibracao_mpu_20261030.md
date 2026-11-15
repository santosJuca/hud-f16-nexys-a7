# Correção da calibração inicial do MPU, 30/10/2026

O diagnóstico de bancada `MPU CAL HEX=00000020` indicava sensor reconhecido sem calibração nem atitude válida. O usuário informou ACC X=`FFFFFD..`, ACC Y=`FFFFFB..`, ACC Z=`000040..`, GYR X=`FFFFFE..`, GYR Y=`000004..` e GYR Z=`FFFFFF..`, com os dois últimos dígitos variando. Esses bytes não foram inventados nem tratados como leituras exatas.

GYR X está necessariamente entre −512 e −257 counts, e GYR Y entre 1024 e 1279. O critério anterior exigia gyro bruto dentro de ±131 antes de estimar seu bias. Portanto, esses dois eixos necessariamente impediam iniciar a calibração, mesmo na pose imóvel informada. As faixas de aceleração relatadas cabem nos limites de nível; o relato não mede a variação entre amostras consecutivas.

## Correção

`atitude_vetorial.sv` mantém as 64 amostras consecutivas e todos os critérios de aceleração, nível, validade, timeout e zero condicionado. Na calibração inicial, aceita gyro bruto até ±1310 counts e exige faixa máximo−mínimo ≤262 por eixo em toda a janela, incluindo a amostra candidata. Uma recusa reinicia as somas e a janela. Após calibrar, o repouso continua exigindo |gyro−bias| ≤131.

A janela inteira evita aceitar uma rampa lenta apenas por seus incrementos pequenos entre amostras vizinhas. Os offsets são médias das amostras aceitas, não constantes estimadas dos dígitos parciais. O perfil de ±10°/s inicial acomoda o intervalo relatado com um limite finito; a faixa da janela equivale a 2°/s na escala configurada. A [especificação TDK MPU-6000/MPU-6050, PS-MPU-6000A-00 rev. 3.4, seção 6.1](https://product.tdk.com/system/files/dam/doc/product/sensor/mortion-inertial/imu/data_sheet/mpu-6000-datasheet1.pdf) informa 131 counts/(°/s) e tolerância inicial de zero de ±20°/s a 25°C. O limite do firmware é uma política desta aplicação, não uma alteração da faixa do sensor nem prova de conformidade do módulo real.

A calibração exige que o operador mantenha a caixa imóvel: rotação constante ao redor da gravidade pode ser indistinguível de bias com estes seis eixos. Não calibrar em movimento. A correção não garante que outros critérios físicos, como ruído de aceleração, já estejam satisfeitos.

## Evidências

- Backup inicial de 251 arquivos, relido do ZIP e conferido por SHA-256. Alterados quatro arquivos anteriores: estimador, script de aceitação e os dois guias de calibração. Novos testes `tb_atitude_bias` e `tb_top_atitude_bias`; demais RTL e XDC preservados.
- Reprodutor com valores sintéticos dentro dos intervalos relatados: falha no código anterior por falta de calibração; passa após a correção. Não representa uma gravação exata das amostras do usuário.
- Teste dirigido: média dos três offsets, sinal, zero válido; rejeição de excesso de offset, variação, rampa acumulada, aceleração instável, inclinação e inversão. O limite de repouso após calibrar continua recusando movimento acima de 131 counts corrigidos.
- Regressão vetorial: 4713 comparações dinâmicas e 5188 atualizações, roll/pitch, calibração, zero, aceleração e falhas aprovados.
- Integração do top com estimador real: fonte MPU e validade ATT chegam à VGA; SW9 invalida e permite recalibrar. HDG sem magnetômetro permanece inválido.
- Vivado 2026.1: síntese, implementação e bitstream concluídos. WNS +0.185 ns, WHS +0.023 ns, WPWS +4.020 ns; TNS/THS/TPWS zero. DRC: zero erros, 102 avisos DSP. CDC: 478 endpoints seguros, zero unsafe/unknown/sem ASYNC_REG. Bus skew 1,530 e 1,652 ns, limite 10 ns.
- Recursos: 16221 LUT, 11020 FF, 16 RAMB36 + 2 RAMB18, 62 DSP. Todos os 81 pinos externos, direções, padrões elétricos e pull-ups conferem com a versão de diagnóstico anterior.

## Artefato e bancada

Bitstream experimental: `validation/mpu-bias-fix-20261030/implementation/experimental_attitude_capture.bit`.

SHA-256: `9b2c62dd24a227616c997fe8c01023d0ce78c90dad471457d1ad787289300aec`.

Fontes do build arquivadas e relidas em `validation/mpu-bias-fix-20261030/build-inputs.zip`. Resultados, relatórios e logs estão na mesma pasta de validação, ignorada pelo Git. O artefato de diagnóstico anterior foi preservado. Não houve commit ou publicação.

O usuário confirmou que o buzzer apita corretamente; nenhuma alteração nele foi realizada. GND comum e alimentação compartilhada de 3,3 V são compatíveis com o atlas. No HMC, `MAG ID=0` e `MAG IO=05` indicam que não houve leitura completa de identificação e a última transação concluída recebeu NACK; os níveis SDA=1/SCL=0 são apenas do snapshot e não provam linha presa. A etapa exata do NACK não é exposta. O usuário informou que é o mesmo módulo anteriormente funcional. Protocolo e pinagem HMC foram preservados; a causa física continua pendente.

Após autorização específica do usuário (“Autorizar gravação JTAG”), o artefato corrigido foi programado em 30/10/2026 na Nexys `Digilent/210292AD34F5A`, FPGA `xc7a100t`, com SHA-256 conferido. DONE, END_OF_STARTUP e INIT_B foram confirmados em 1. Evidências em `validation/mpu-bias-fix-20261030/program-jtag-authorized/`. Não houve gravação de Flash nem escrita microSD. A próxima ação necessária é observar se ATT BAD desaparece com o MPU imóvel e nivelado. A resolução física de HDG BAD permanece aberta. Mapa do cartão e qualificação externa SPI continuam pendentes, com o mesmo perfil de vídeo arquivado; 28 entradas sem input delay e 38 saídas sem output delay. As margens internas são positivas nesta execução e pequenas; não se generalizam para outros builds.

## Reteste físico informado pelo usuário

Após a programação do artefato corrigido, o usuário informou que ATT BAD e HDG BAD continuam presentes. A correção do critério de gyro foi comprovada em simulação, mas ainda não resolveu o comportamento em bancada. O novo MPU CAL HEX foi solicitado para distinguir calibração incompleta de seleção/validade no HUD. Nenhuma nova alteração foi feita a partir desse relato sem a leitura atual.
