# Diagnóstico de sensores, 30/10/2026

Na bancada, o usuário informou ATT BAD e HDG BAD, LD4/LD5/LD7 acesos, LD9 piscando e LD6 apagado, após configurar SW9–SW11=0 e SW12–SW15=1. O painel exibiu `MPU CAL HEX=00000020`: MPU reconhecido, calibração e atitude ainda inválidas nesse snapshot. A causa específica não foi determinada. LD6 apagado indica que o HMC não chegou ao estado operacional; não prova defeito do módulo.

## Alteração entregue

Na vista de captura `SW5:SW4=11`, um painel à direita mostra ACC X/Y/Z, GYR X/Y/Z, MAG ID e MAG IO em hexadecimal. Os dados atravessam o mailbox existente, ampliado de 32 para 160 bits, e são publicados na VGA no blanking. A interpretação está em `modo_captura_calibracao.md`.

O driver HMC passa a expor a última identificação lida, sucesso operacional, resultado da transação e níveis SDA/SCL. O teste cobre ID incorreto, H43, NACK, linhas presas, timeout e recuperação. O protocolo, endereço e exigência de H43 foram preservados.

O estimador vetorial, driver MPU, critérios de calibração, XDC, vídeo e pinos externos não foram alterados. Não foi estimado bias nem aceito nível fictício para remover ATT BAD.

## Verificação executada

- Backup inicial de 249 arquivos relido do ZIP e verificado por SHA-256. Alterados somente os oito arquivos listados em `changes-from-start.json`; os demais anteriores permanecem idênticos. Novo teste: `tests/tb_calibracao_diagnostico.sv`.
- Diagnóstico VGA: 4032 pixels verificados, seis eixos, extensão de sinal, ID/IO e ocultação. Preview visual com valores sintéticos em `panel.png`.
- Testes existentes dos drivers HMC e MPU: aprovados.
- Integração top: 5222400 pixels; transferência íntegra dos 128 bits extras, captura, quatro vistas, passo, retomada, ícone e vídeo aprovados.
- Vivado 2026.1: síntese, posicionamento, otimização física, route e bitstream concluídos. WNS +0.488 ns, WHS +0.016 ns, WPWS +4.020 ns; TNS/THS/TPWS zero. DRC: zero erros, 102 avisos DSP. CDC: 478 endpoints seguros, zero unsafe/unknown/sem ASYNC_REG. Bus skew 1,241 e 1,650 ns, limite 10 ns.
- Recursos: 15752 LUT, 10930 FF, 16 RAMB36 + 2 RAMB18, 62 DSP. Todos os 81 pinos de portas externas, direções, padrões elétricos e pull-ups coincidem com o build JD4 anterior.

## Artefato e pendências

Bitstream experimental: `validation/sensor-diagnostics-20261030/implementation/experimental_attitude_capture.bit`.

SHA-256: `8db8f5259ba2bf14554cb256f28d5ee13dd137ebbca0a65ca06f5cf42ce738f6`.

Fontes de build arquivadas e relidas em `validation/sensor-diagnostics-20261030/build-inputs.zip`. Resultados, logs, relatórios e hashes ficam na mesma pasta de validação, ignorada pelo Git. Não houve commit ou publicação.

Perfil preservado: vídeo 160×120, RGB332, 1 FPS, SPI half=125, LBA 30006144 e 21965 setores do mapa arquivado. Permanecem 28 entradas sem input delay e 38 saídas sem output delay. A releitura física do mapa e a qualificação externa SPI continuam pendentes. A margem de hold é positiva e pequena; não se generaliza para outros builds.

O usuário autorizou especificamente “Autorizar JTAG volátil” para este artefato. A programação foi concluída em 30/10/2026 na Nexys `Digilent/210292AD34F5A`, FPGA `xc7a100t`, após conferir o SHA-256 autorizado. DONE, END_OF_STARTUP e INIT_B foram confirmados em 1. Evidências em `validation/sensor-diagnostics-20261030/program-jtag-authorized/`. Não houve gravação de Flash nem escrita no cartão. O arquivo do bitstream anterior foi preservado. A próxima ação necessária é ler os valores reais do painel com o MPU imóvel e nivelado. A confirmação JTAG não comprova correção física de ATT BAD ou HDG BAD.
