# Giro de 180° somente na bússola — 06/11/2026

O usuário informou que a frente do conjunto é o lado VGA, apontando para fora da placa. Após reposicionar os sensores, comparou o heading do HUD de 348° com a referência de 168° do celular e solicitou um giro de 180° somente na bússola, antes de tratar os demais eixos. A referência informada não constitui medição de precisão absoluta do rumo.

## Alteração e reprodução

O novo perfil `mpu-left90-mag-right90-front180-hdg-minus90` preserva `MPU_GIRO_ESQUERDA_90=1` e `FRENTE_INVERTIDA_180=1`. Em relação ao perfil `hdg-plus90`, muda apenas `MAG_INVERTER_X` e `MAG_INVERTER_Y` de 0 para 1. O XOR com a frente já invertida faz o vetor magnético passar de `(-X_corrigido,-Y_corrigido)` para `(X_corrigido,Y_corrigido)`, girando o heading em 180°.

Os 73 arquivos de RTL e constraints permanecem byte a byte iguais aos do candidato anterior. Algoritmo de atitude, MPU, barômetro, offsets/ganhos magnéticos, clocks e interface SD não foram alterados. O perfil anterior permanece disponível.

Com Vivado 2026.1 no PATH, mapa real reconferido e diretório de saída novo:

```sh
python3 tools/build_video_bitstream.py build/bussola-180 --map /caminho/mapa.json --read-half 125 --mounting mpu-left90-mag-right90-front180-hdg-minus90
```

O cartão atual foi identificado e relido como `/dev/sdd`, FAT32 UUID `3562-6631`, leitor serial `816820130806`. LBA 30006144, 21965 setores úteis, arquivo contíguo 160×120 a 1 FPS, 578 quadros. Conteúdo, MBR, UUID da sequência e mapa coincidem com a leitura anterior. SHA-256 de HUDVIDEO.BIN: `615729d0740adc978b42fdf0a13dc4f18820109e4dd9e68ac66d137d431012d0`. O nome do dispositivo pode mudar ao reconectar; não reutilizá-lo sem identificar o cartão. O acesso concedido foi somente leitura.

VGA continua 640×480 com pixel clock de 25 MHz; inicialização e leitura SPI half=125.

## Validação digital e implementação

- Nove testes Python aprovados, incluindo aceitação do perfil novo e recusa de mapa alterado.
- Heading: 1394 vetores em dez configurações aprovados, com cardeais, quadrantes, wrap, extremos, perda de sensor e caso sintético dirigido 348° → 168°.
- Fusão de heading: 124 verificações aprovadas.
- A comparação dos comandos efetivos de síntese confirmou somente as duas mudanças de parâmetros magnéticos descritas acima.

Vivado 2026.1 build 6511674 concluiu síntese, implementação e bitstream com saída zero:

| Verificação | Resultado |
|---|---|
| WNS / WHS / WPWS | +0.271 / +0.015 / +4.020 ns |
| TNS / THS | 0 / 0 ns |
| DRC | zero erros; 102 avisos de pipeline DSP |
| CDC | 624 seguros; zero inseguros/desconhecidos/sem ASYNC_REG |
| Bus skew | PASS |
| Endpoints internos sem restrição / sem clock | 0 / 0 |

Os limites externos SPI/I²C anteriormente documentados continuam aplicáveis; STA interno não homologa a interface elétrica. Não houve relaxamento de verificações.

## Artefato e autorização

BIT local: `/home/santojuca/Downloads/hud-bussola-180-20261106T182031Z/vivado/experimental_attitude_capture.bit`

SHA-256: `9e916d6c1e59851f00bc4efa21bd05a31aaa34181c745612430f650652988463`

Alvo reconferido em leitura: `localhost:3121/xilinx_tcf/Digilent/210292AD34F5A`, FPGA `xc7a100t_0`, IDCODE `0x13631093`.

Este novo hash ainda não foi autorizado para programação JTAG nem testado fisicamente. A autorização do BIT anterior não é atribuída automaticamente a este arquivo. Não houve escrita em Flash ou cartão. Relatórios, fontes empacotadas, mapa, logs e manifestos da execução ficam em `/home/santojuca/Downloads/hud-bussola-180-20261106T182031Z`.

## Evidência física e pendências

A foto anterior ao novo candidato mostra `MPU CAL=00000037` e COR R/P próximos de zero: o zero foi aceito. O usuário relata que levantar a lateral direita/esquerda provoca deslocamento vertical do horizonte, enquanto levantar a frente/traseira provoca roll. Esse relato indica eixos de atitude cruzados e permanece pendente; não foi corrigido neste ajuste da bússola, conforme a sequência solicitada.

O vídeo continua sem aceite físico: a foto registra `VIDEO HEX=0000001C` e `FRAME HEX=FFFFFFFF`. A calibração magnética no novo local também precisa de reavaliação. Não se declara o candidato estável com base apenas nos testes digitais.

PR #6 permanece em rascunho e separado da main enquanto houver essas pendências. PR #5 e projetos mecânicos não foram alterados nem liberados.
