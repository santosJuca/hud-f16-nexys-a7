# Orientação do MPU após o alinhamento da bússola, 08/11/2026

O usuário aprovou visualmente a bússola depois de carregar o bitstream `bc49675cefe1eff956004b3c8cae4372261250176b5da9ac0e59a4d998db9064` e passou a relatar atitude com os eixos trocados. Nos movimentos guiados, baixar a frente fez a ponta direita da linha do horizonte subir; baixar o lado direito fez a linha inteira descer. São observações físicas informadas pelo usuário, sem captura bruta do MPU nesta etapa.

A combinação anterior era `MPU_GIRO_ESQUERDA_90=1` e `FRENTE_INVERTIDA_180=1`, resultando em `(X,Y,Z)=(Y_bruto,−X_bruto,Z_bruto)` para acelerômetro e giroscópio. O candidato usa os eixos nativos `(X,Y,Z)=(X_bruto,Y_bruto,Z_bruto)`, equivalente a aplicar `(X_novo,Y_novo)=(−Y_atual,X_atual)` ao referencial anterior: mais 90° à esquerda nos eixos. A composição é ortogonal e preserva Z; não são adicionados offsets angulares nem alterados o estimador e seus critérios de validade/calibração.

## Perfil reproduzível

`mpu-original-mag-front180-hdg-plus90`, selecionado por `--mounting` no wrapper `tools/build_video_bitstream.py`. Neste nome, `mpu-original` significa usar os eixos nativos do chip; não significa mover fisicamente o módulo nem restaurar calibrações antigas.

| Parâmetro | Antes | Candidato |
| --- | ---: | ---: |
| MPU_GIRO_ESQUERDA_90 | 1 | 0 |
| FRENTE_INVERTIDA_180 | 1 | 0 |
| MAG_TROCAR_XY | 0 | 0 |
| MAG_INVERTER_X | 0 | 1 |
| MAG_INVERTER_Y | 0 | 1 |

A inversão magnética efetiva é `MAG_INVERTER_* XOR FRENTE_INVERTIDA_180`. Antes, `0 XOR 1=1`; depois, `1 XOR 0=1`. Assim a bússola mantém exatamente os mesmos eixos, offsets X892/Y−274, ganhos Q12 4546/3727 e alinhamento +81°. O gyro Z que entra na fusão de rumo também permanece igual. O RTL e as constraints são byte a byte iguais aos do build anterior: só a seleção de parâmetros no script muda.

## Resposta esperada e teste dirigido

| Movimento físico | Relato com o perfil anterior | Resposta esperada no candidato |
| --- | --- | --- |
| Frente para baixo | Ponta direita sobe | Linha inteira sobe |
| Lado direito para baixo | Linha inteira desce | Ponta direita sobe |
| Frente para cima | Não medido nesta etapa | Linha inteira desce |
| Lado esquerdo para baixo | Não medido nesta etapa | Ponta direita desce |

`tests/tb_top_mpu_orientacao.sv` injeta amostras sintéticas no driver e usa o estimador e a geração de seno/pitch reais do top. Os vetores foram escolhidos para reproduzir o relato, não são leituras físicas do sensor. O banco verifica as duas configurações, os quatro movimentos, retorno ao nível, sinais de gyro e rumo magnético325° no mesmo vetor sintético para ambas. O novo perfil também é verificado pelo Tcl real até a síntese, incluindo a compensação dos flags magnéticos e a propagação pelo wrapper Python.

Evidências, snapshot, diff e build: `validation/mpu-orientacao-20261108-0k3nizeb/`. O vídeo permanece no perfil anterior: 160×120, 1 FPS, SPI400 kHz, LBA30006144, mapa previamente conferido. Nenhuma releitura atual do SD, gravação de Flash ou escrita no cartão faz parte desta etapa. A temporização externa SPI continua sem qualificação completa.

A nova orientação é um candidato para teste físico. A simulação não comprova a orientação real dos módulos. O alinhamento da bússola em relação ao celular também continua distinto de uma validação instrumental de norte absoluto.

## Resultado digital do candidato

Os cinco testes Python do build passaram. O teste integrado de movimentos passou com `CORRIGIDO=0` e `CORRIGIDO=1`, reproduzindo o relato no perfil anterior e verificando os sinais esperados no novo. A implementação terminou com WNS +0,376 ns e WHS +0,007 ns, zero erros DRC e 624 CDC seguros, sem inseguros ou desconhecidos. Há 104 avisos de pipeline DSP.

Bitstream: `validation/mpu-orientacao-20261108-0k3nizeb/implementation/experimental_attitude_capture.bit`. SHA-256: `b3e777d72dbdeb7921371346a58c939e7eecabe8d16e7901c59c0c3430f8092f`. O usuário autorizou este arquivo e a programação JTAG terminou com saída zero em08/11/2026. Identidade da Nexys e SHA-256 conferidos; DONE/INIT_B/EOS em1 e CRC_ERROR em0. Não houve gravação de Flash nem escrita no SD. Evidências em `validation/mpu-orientacao-20261108-0k3nizeb/jtag-aprovado-iws_7nyy/`.

## Retorno da bancada após JTAG

O usuário respondeu “Perfeito” após a programação e perguntou pelo próximo passo. Isso registra aprovação qualitativa do resultado, sem novas medidas angulares nem relato individual dos movimentos. Não foi validado boot desta versão pela Flash, pois ela permanece carregada somente por JTAG. A precisão absoluta da bússola e o caminho dos vídeos novos/DDR2 continuam pendentes.
