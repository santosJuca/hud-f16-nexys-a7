# Buffer de setores microSD em BRAM

Preparação independente de P1 em 30/10/2026. **Módulo simulado e sintetizado; integração física ao HUD/VGA pendente.** O top e o bitstream P0 carregado na placa não foram alterados nesta etapa.

## Evidência que permitiu avançar

O usuário confirmou três leituras físicas do LBA 0 do QD101. Confirmou LD10/LD11 acesos, LD8 apagado, página de dados `00FE0200` e página CRC `5DC55DC5`. São 512 bytes com CRC recebido/calculado 5DC5 e comparação integral com a referência Linux. A origem da observação é o relato do usuário nesta conversa, separado da simulação. Registros em `validation/p0-read-20261030T155225Z/physical-repeat-20261030T163524Z/`.

A amostra ampliada, partida a frio, recuperação física de erro e margem elétrica não foram aprovadas. A preparação independente do buffer não depende de declarar essas qualificações concluídas.

## Organização

`rtl/sd_sector_buffer.sv` contém dois bancos de 512 bytes em uma memória `1024 × 8`, com escrita a 100 MHz e leitura no clock de pixel de aproximadamente 25 MHz. Não há limpeza da matriz de memória por reset nem cópia de 512 bytes por registradores.

O banco visível permanece imutável enquanto o outro recebe dados. A publicação exige 512 bytes com índices 0..511 em ordem e `wr_commit` fornecido pelo leitor somente após CRC válido. Falha, aborto, índice incorreto, byte a mais ou commit prematuro não publicam o banco e preservam o anterior. Reset invalida a disponibilidade; o consumidor deve respeitar `rd_valid` e `rd_sector_valid`.

O pedido de publicação é um toggle de um bit; esse bit também identifica o banco. Dois FFs ASYNC_REG sincronizam o pedido e outros dois sincronizam o ACK. Não há pulso de 100 MHz aplicado diretamente ao domínio VGA, nem barramento de dados cruzado por sincronizadores individuais.

O destino troca o banco apenas em `rd_frame_start`, que deve ser produzido **no domínio de leitura, dentro do blanking vertical**. Aguarda dois ciclos de leitura para drenar o pipeline antes de devolver o ACK. A origem só reutiliza o banco anterior depois desse ACK. Enquanto uma publicação está pendente, `wr_ready` permanece baixo.

Endereço e enable da BRAM têm registros síncronos preservados por DONT_TOUCH para impedir o retiming que causou REQP-1840 na preparação de P0. Reset tem asserção assíncrona e liberação sincronizada por domínio; os registradores que dirigem a memória não têm reset assíncrono. O reset deve ser comum aos dois domínios e ambos os clocks devem estar presentes. Não há suporte a reset independente de um único domínio.

## Contrato para a integração

| Sinal | Uso |
|---|---|
| `wr_ready` | Permite iniciar uma nova transação; o solicitante deve consultá-lo antes de acionar o leitor SD |
| `wr_start` | Pulso indicando o início efetivo da recepção, por exemplo na subida de `read_busy` |
| `wr_valid`, `wr_byte`, `wr_index` | Ligar aos bytes provisórios do leitor CMD17 |
| `wr_abort` | Aborta a recepção após erro do leitor; não acionar com erro antigo de outra transação |
| `wr_commit` | Ligar a `block_valid`; pulso posterior ao último byte, sem `wr_valid` simultâneo |
| `wr_pending` | Setor válido aguardando troca no destino e ACK |
| `wr_published` | Pulso de confirmação, já no clock de escrita |
| `wr_error` | Erro de recepção/protocolo; limpa no próximo início aceito |
| `rd_frame_start` | Pulso de blanking vertical, produzido no clock de pixel |
| `rd_enable`, `rd_address` | Solicitação de byte no domínio de leitura |
| `rd_valid`, `rd_byte` | Resposta da memória, com a latência descrita abaixo |
| `rd_sector_valid` | Existe um setor confirmado publicado |
| `rd_updated` | Pulso no domínio de leitura quando o banco é trocado |

O erro do controlador existente é retido até começar uma nova leitura. Por isso, não iniciar `wr_start` a partir de um pedido que anteceda a limpeza desse erro e simultaneamente ligar `wr_abort` ao erro antigo. A subida de `read_busy` ocorre com o erro do leitor já limpo e permite esse acoplamento sem abortar a nova recepção.

Latência: uma solicitação estável antes da borda N é registrada nessa borda; `rd_byte` e `rd_valid` correspondentes aparecem após a borda N+1. São duas bordas de amostragem. Coordenadas, região do ícone e demais controles de pixel devem acompanhar esse pipeline quando o overlay for integrado. Uma troca de banco durante blanking permite drenar os pixels do quadro anterior antes do vídeo ativo seguinte.

A confirmação CRC pertence ao leitor; o buffer não recalcula CRC nem interpreta dados como imagem. O LBA 0 não foi declarado recurso gráfico.

## Validação realizada

`tests/tb_sd_sector_buffer.sv` usa clocks de 100/25 MHz com fases distintas e um scoreboard de bytes/latência. Foram verificados:

- Bloqueio de leituras antes do primeiro setor publicado e ausência de publicação antes do commit/blanking.
- Recepção de 512 bytes e leitura de todos os endereços em ordem permutada.
- Bloqueio de novo início enquanto espera ACK.
- Leitura contínua do banco anterior durante escrita simultânea no outro.
- Preservação dos dados após recepção parcial abortada e aborto por erro de CRC externo.
- Rejeição de 511 bytes, índice incorreto e byte excedente.
- Alternância dos bancos, publicação única por pedido e reset durante recepção seguido de nova carga correta.

Simulação concluída com código zero. O bench foi acrescentado ao runner existente `scripts/test.sh`. A regressão P0 anterior não foi reclassificada como uma nova execução; o módulo ainda não é instanciado no top.

Síntese isolada otimizada no Vivado 2026.1: **35 LUTs, 61 FFs e uma RAMB18E1**. Sem latches, sem erro DRC e sem REQP-1840. CDC identificou os dois cruzamentos de controle como seguros, com zero endpoints inseguros/desconhecidos. Zero registros sem clock e zero endpoints internos não restringidos.

O DRC isolado apresenta CFGBVS-1 porque não utiliza constraints de configuração da placa. O top P0 já possui essas propriedades. Esse relatório fora de contexto não substitui o DRC da integração. A estimativa temporal pós-síntese tem WNS +6,226 ns e WHS +0,164 ns, sem roteamento; não é STA final da placa.

Evidências: `validation/p1-buffer-20261030T163524Z/`, com backup verificado de arquivos existentes, logs, checkpoint, manifesto e hashes. Reprodução da síntese sem sobrescrever resultados:

```sh
/home/santojuca/AMD/2026.1/Vivado/bin/vivado -mode batch \
  -source scripts/synth_sd_sector_buffer.tcl -tclargs validation/NOVA_SINTESE_BUFFER
```

Não houve programação JTAG adicional, gravação da Flash, alteração da pinagem, escrita no cartão ou mudança do HUD nesta preparação. Ainda faltam o acoplamento ao controlador/top, o ensaio físico da BRAM e a integração de um recurso gráfico real com o pipeline VGA. Nenhum overlay foi declarado concluído.
