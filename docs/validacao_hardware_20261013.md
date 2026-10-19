# Validação da montagem e Flash em 13/10/2026

A versão do HUD foi gravada na Flash da Nexys A7-100T. A gravação passou pelo
verify do Vivado e pela comparação com uma leitura completa dos 16 MiB. Após
mover JP1 de JTAG para SPI/QSPI, o operador confirmou a inicialização ao desligar
e ligar a placa. A imagem VGA foi relatada como correta e estável.

## Resultados de bancada relatados pelo operador

| Verificação | Resultado relatado |
| --- | --- |
| Flash e VGA | Inicialização após desligar/ligar; imagem correta e estável |
| Joystick nos estilos NORMAL e CAÇA | Esquerda, direita, cima e baixo corretos |
| Joystick em CAÇA | Repouso, limites da tela e LOCK/UNLOCK funcionando |
| MPU-6050 | LD4 aceso, ATT BAD ausente, inclinações corretas com SW9=0 e SW12–SW15=1111 |
| BMP085 e HMC5883L | LD5/LD6 acesos, ALT BAD/HDG BAD ausentes e rumo respondendo à rotação |
| Buzzer e ACK | Buzzer soa com WARNING de roll manual em VOO; BTNC silencia mantendo o aviso visual |

Esses registros são observações funcionais do operador. Não há medições de
tensão, registros brutos do ADC, referência de altitude ou referência de rumo
anexados. A resposta em altitude/VSI a uma variação física conhecida, a precisão
absoluta dos sensores e o comportamento em condições prolongadas não foram
caracterizados nesta etapa.

## Pinagem auditada

| Circuito | Conector | Pad FPGA |
| --- | --- | --- |
| KY-023 SW | JC1 | K1 |
| Controle do buzzer | JC7 | E7 |
| KY-023 VRx, após divisor | JXADC1 | A13 / VAUXP3 |
| KY-023 referência de VRx | JXADC7, ligado ao GND comum | A14 / VAUXN3 |
| KY-023 VRy, após divisor | JXADC2 | A15 / VAUXP10 |
| KY-023 referência de VRy | JXADC8, ligado ao GND comum | A16 / VAUXN10 |
| MPU-6050 SDA / SCL | JD8 / JD7 | G4 / H2 |
| BMP085 SDA / SCL | JD1 / JD2 | H4 / H1 |
| HMC5883L SDA / SCL | JD3 / JD9 | G1 / G2 |

Os três barramentos I²C são independentes. AD0 do MPU-6050 permanece no GND,
selecionando 0x68. Alimentação de 3,3 V e terra comum foram informados para os
módulos; as tensões efetivas não foram medidas. A VGA adicional no JB não integra
esta versão.

A inspeção encontrou 48 bits de portas no top e 48 atribuições físicas ativas,
sem pads duplicados ou portas sem correspondência. Todos os pads coincidem com
o checkpoint roteado do build preservado. JC1/K1 e JC7/E7 foram conferidos no
[Master XDC da Digilent](https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc).

O top mantém o horizontal em `joystick_y_raw` e corrige o vertical por
`4095 - joystick_x_raw`, antes da calibração. A mesma orientação alimenta a mira,
o marcador e os LEDs. O eixo horizontal anteriormente questionado foi confirmado
funcional pelo operador nesta validação.

## Implementação e pendências elétricas

Nove testes digitais passaram nesta auditoria: controle do joystick, mira,
orientação vertical integrada ao top, I²C do MPU/BMP/HMC, buzzer, validade das
fontes e modos integrados. Os logs estão no pacote preservado. O teste MPU
excedeu o limite inicial de execução de 60 s e passou ao ser repetido com limite
de 300 s. A simulação injeta amostras digitais no lugar do XADC físico; não mede
o joystick nem a interface analógica da placa.

O build preservado foi gerado com Vivado 2026.1 para `xc7a100tcsg324-1`.
O relatório registra WNS +0,480 ns e WHS +0,037 ns, sem violações de setup/hold
nos caminhos analisados. O DRC registra 55 avisos e nenhum erro: propriedades
CFGBVS/CONFIG_VOLTAGE ausentes e recomendações de pipeline dos DSPs. Esses
resultados não comprovam temporização dos periféricos externos nem a faixa do
joystick.

Continuam pendentes:

- Valores de RX1/RX2 e RY1/RY2 e medição das saídas dos divisores nos extremos.
- Confirmação elétrica da faixa de conversão de 0 a 1 V do XADC. `LVCMOS33`
  no XDC não autoriza aplicar 3,3 V nas entradas analógicas.
- Valores/presença dos pull-ups dos breakouts e suas tensões.
- Valor do resistor de base, tensão e corrente do buzzer; pinagem real do
  transistor deve corresponder ao fabricante/encapsulamento usado.
- Definição documentada de CFGBVS/CONFIG_VOLTAGE em uma futura revisão do XDC,
  após conferência da alimentação de configuração no esquema da placa.

Nenhum defeito funcional foi reproduzido nos testes de bancada relatados. Esta
auditoria não alterou a lógica, regravou a FPGA ou regravou a Flash.

## Preservação

O bitstream gravado tem SHA-256
`c0e1b616700b3cd91042c17221559bf0e68215dac8a44f9a677ce0ad79615ab0`.
Sua fonte foi uma árvore de trabalho com alterações locais; o commit-base
`fc2a687285777ab7e577a4f5cb95ef7de0582866` sozinho não reproduz esse arquivo.
O pacote inclui o XDC, relatórios, snapshot atual das fontes e hashes. O snapshot
foi coletado nesta auditoria posterior ao build; a correspondência dos pinos foi
verificada no checkpoint, sem afirmar equivalência retrospectiva de todos os
arquivos fonte.

A Flash original corresponde exatamente à demonstração Digilent
`Nexys4DdrUserDemo`, Vivado 2018.2, build de 01/11/2018. O backup integral tem
SHA-256 `b52dcf59ceb12d79d43e35e973c9db680746b86da4db5fa7b3c4fd7a74463cb2`
e foi preservado junto ao bitstream oficial equivalente.

Entrega local:
`/home/santojuca/Downloads/HUD_FPGA_Entrega_2026-10-13/`.
As fontes SVG e os geradores permitem editar o esquema. Valores externos não
informados estão marcados como NI, sem substituição por valores estimados.

## Atualização posterior — 19/10/2026

Após esta validação, o buzzer foi transferido de JC7/E7 para JC10/E6. O XDC
atual e o top RTL mapeiam `buzzer_out` para JC10/E6; o circuito informado usa
resistor de base de 1,2 kΩ e transistor 2N2222A. A validação física registrada
acima refere-se à montagem e ao bitstream de 13/10, portanto não comprova a nova
pinagem nem a ligação atual.

Também foram relatadas leituras analógicas acima de 1 V nos testes recentes do
KY-023 usando resistores de 27 kΩ. O esquema salvo não identifica os valores e a
topologia final de todos os resistores. Como o XADC está configurado unipolar e
tem faixa nominal de 0–1 V, a rede ainda precisa ser conferida e medida em
JXADC1/JXADC2 antes de novos testes. Não se considera a entrada analógica
validada eletricamente.

O esquema visual e o CSV datados de 13/10 permanecem como registro da montagem
anterior, que indicava JC7/E7. A pinagem atual está em [`pinagem.md`](pinagem.md)
e no XDC ativo; esses artefatos históricos não devem ser usados como mapa da
remontagem de 19/10.
