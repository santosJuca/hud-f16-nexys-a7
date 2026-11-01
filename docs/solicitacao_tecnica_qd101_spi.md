# Solicitação técnica ao fabricante: WD Purple SC QD101 em SPI

Rascunho preparado em 30/10/2026. Não enviado. Destinatário: suporte técnico Western Digital/SanDisk responsável por cartões SC QD101; endereço ainda não confirmado.

Solicitamos o datasheet elétrico/temporal e confirmação de suporte SPI para o WD Purple SC QD101 32 GB, modelo de catálogo WDD032G1P0C. A revisão e o código completo do exemplar serão fornecidos após conferência física; favor informar quais dados de etiqueta/CID permitem identificar a revisão e a especificação aplicável.

O host é uma Digilent Nexys A7-100T, FPGA XC7A100TCSG324-1, sinais LVCMOS33 e slot alimentado nominalmente a 3,3 V. O controlador utiliza SPI modo 0, SCK de 400 kHz tanto na inicialização como nas leituras CMD17. MOSI muda na descida. O host captura MISO no clock interno que comanda a subida de SCK, portanto precisamos fechar o orçamento de ida e volta a partir da descida anterior.

O Product Brief 02-05-WW-04-00176-A03 informa SDA 6.0, mas não apresenta a tabela AC SPI. Precisamos dos limites garantidos, incluindo condições e referência de medição, para:

1. Compatibilidade e revisão normativa SPI; frequência mínima/máxima e duty cycle, durante inicialização e operação.
2. Flanco de lançamento de MISO; tCO mínimo/máximo, output hold/contamination, primeira resposta após comando/CS e tempos de habilitação/liberação de MISO.
3. Setup e hold de MOSI e CS, larguras mínimas de SCK alto/baixo e limites de rise/fall.
4. VDD mínimo/máximo, rampa e espera de power-up, VIH/VIL/VOH/VOL, corrente de drive/leakage, capacitância de entrada e carga máxima permitida em MISO.
5. Condições de carga, temperatura, tensão e thresholds dos parâmetros AC; cobertura de lotes/revisões e modelo IBIS ou equivalente, se disponível.
6. Confirmação de que os limites enviados se aplicam ao SC QD101 indicado, e não a outra família comercial/industrial de nome semelhante.

Aceitamos indicação do documento aplicável ou procedimento para obtenção sob NDA. Não precisamos de taxa de transferência sequencial, UHS-I ou classe de velocidade como substituto das garantias de temporização SPI.
