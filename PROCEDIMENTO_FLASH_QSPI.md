# Gravação futura da Flash QSPI

**Procedimento preparado, sem autorização ou execução de gravação nesta sprint.** Só usar depois do aceite físico do bitstream DDR2 e de autorização específica para o chip e artefato identificados.

1. Identificar alvo JTAG, XC7A100TCSG324-1 e Flash montada. O RDID histórico `01 20 18 00 00` é compatível com a família S25FL128S/S25FL127S, mas não identifica sozinho a revisão exata. Confirmar chip, capacidade, part selecionado no Vivado e datasheet; recusar identificação ambígua. A configuração preservada usou SPIx1, não presumir SPIx4 por se chamar QSPI.
2. Registrar commit, genéricos, mapa do cartão, caminho absoluto e SHA-256 do `.bit` fisicamente aprovado, da imagem de Flash e do algoritmo/part de programação. Conferir a configuração de boot e o jumper JP1 com a documentação da placa, sem alterá-los por inferência.
3. Ler a Flash integralmente duas vezes para arquivos novos, antes de apagar. Conferir tamanhos e hashes iguais e guardar cópia fora da pasta de trabalho. Identificar qual backup restaura a configuração atual; backup criado não equivale a restauração ensaiada. Preservar bitstream SRAM funcional e acesso JTAG para recuperação.
4. Gerar imagem MCS para o part/capacidade confirmados, no endereço de boot correto, com formato e largura SPI compatíveis com o firmware aprovado. Examinar relatórios e hash. Não reaproveitar MCS histórico para um novo `.bit` sem conferir a correspondência.
5. Apresentar os caminhos, hashes, dispositivo/Flash, backup e escopo de erase/program/verify e obter autorização para essa operação concreta. Se o artefato ou chip mudar, a aprovação anterior não abrange automaticamente a mudança.
6. Executar a programação autorizada com verificação completa. Ler novamente a região programada e comparar com os dados esperados, considerando o formato e o preenchimento da imagem. Guardar logs e hashes; mensagem SUCCESS isolada não comprova boot.
7. Desligar e religar a placa com o modo de boot confirmado. Observar DONE, calibração DDR2, HUD, sensores e vídeo sem carga SRAM por JTAG. Registrar o teste físico com o hash da imagem. Só então declarar boot autônomo aprovado.
8. Em falha, preservar logs e recuperar primeiro o HUD pela configuração funcional identificada. Restauração da Flash exige o backup correto, chip confirmado e autorização compatível; não apagar novamente por tentativa.

Os backups históricos estão relacionados em `evidencias/recuperacao-preservada.json`. As duas leituras anteriores à gravação histórica têm SHA-256 `6f0b00c5ef632a64c29b6136a091ce1ca8033116bb0dc0d13fb5354663d12e05`. A MCS SPIx1 funcional tem SHA-256 `2ce2c7a98645656496aa59bc1773e0e09692087c13f95847ab1ef1e2a25201a1`. Esses valores não substituem um backup novo da Flash na futura sessão.
