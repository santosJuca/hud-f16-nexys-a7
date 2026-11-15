# HUD F-16: calibração magnética guiada, versão 5D7A3AE2

Versão ensaiada na Nexys A7-100T, com calibração guiada 2D em dois giros,
esteira híbrida sem caixas pretas nos números, vídeo e modos preservados.
O operador confirmou calibração aplicada, resposta ao giro/retorno, vídeo,
horizonte e chegada ao POUSO. A Flash passou gravação, verificação integral e
boot por registradores. Depois, o operador desligou e religou e informou início normal.

O aceite vale para os testes relatados nesta montagem. Não comprova precisão em
qualquer orientação ou ambiente. **O programa é persistente na Flash; os novos
coeficientes calculados na calibração são voláteis.** Ao ligar, usa o perfil inicial
compilado. A calibração guiada pode ser repetida no local de uso.

## Downloads e identidade

Os binários estão nos anexos da [release](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-calibracao-guiada-5d7a3ae2-20261113).
O ZIP completo contém fontes, testes, relatórios, BIT, checkpoint roteado, imagem
QSPI e recuperação anterior. O vídeo do microSD não está incluído nesta publicação.

| Artefato | SHA-256 |
|---|---|
| BIT `hud-f16-calibracao-magnetica-guiada-experimental.bit` | `ad8d6d7902bd50ed2924de9eb6b159d1d5b3ca8614247476aae44e0f79ee027a` |
| MCS `flash-nova-completa.mcs` | `c7a16ae94504167fa432fc04d2accf8c6a0595c30f2ba68745008ae187dc11fd` |
| Conteúdo integral da Flash após gravar | `a1d99f09e991c7b53b52a6f2ad144304189eccdda2ec038f3e5e77ae5e7a6b0f` |
| `routed.dcp` | `4f451a9d247de0b9cc79f640bd94840b25ac14ca425d6b5738a5400f8aad2bd3` |

FPGA `xc7a100tcsg324-1`, Vivado 2026.1, USERCODE `5D7A3AE2`.
Placa de bancada: Digilent `210292AD34F5A`. A publicação não programa hardware.

## Calibrar na placa

Use os números impressos nas chaves: **1 = ligada; 0 = desligada**.

| Chaves | Posição | Função |
|---|---|---|
| SW15, SW14, SW13, SW12 | todas em 1 | Selecionar MPU |
| SW11, SW10, SW9 | todas em 0 | Manter fontes habilitadas |
| SW8 | 1 | Diagnóstico |
| SW7, SW6, SW5 | 1, 0, 1 | Página reservada |
| SW4 | 0 | Sair de alinhamento X/Y |
| SW3, SW2 | 0, 0 | SOLO |
| SW1, SW0 | 0, 0 | HUD original, apresentação normal |

Deixe a caixa inteira nivelada, sem captura ativa e com folga nos cabos. Afaste
celular e objetos que possam interferir no magnetômetro durante as coletas.
Gire horizontalmente a montagem inteira; não precisa levantá-la ou invertê-la.
As mensagens aparecem no display vermelho da placa, não no VGA.

1. Segure **BTNR (direita) por 2 segundos** e solte. Nivelado, aparece `CAL 2d`.
   Se aparecer `nIVEL`, ajuste o apoio antes de avançar.
2. Toque BTNR e solte. Em `GIrAr 1`, faça uma volta horizontal completa de 360°
   em aproximadamente 10–20 segundos. Toque BTNR ao concluir.
3. Em `GIrAr 2`, a segunda coleta já começou. Faça outra volta completa em
   10–20 segundos e toque BTNR. São dados posteriores ao cálculo do candidato.
4. Se aparecer `APtO 2d`, toque BTNR. A aplicação ainda exige uma amostra nova
   válida. `APLICA` pode ser breve; depois, nivelado, aparece `CAL 2d`.
5. Pressione **BTND (baixo)** para sair e coloque **SW8 em 0**. Confira rumo
   inicial, giro e retorno com referências apontadas na mesma direção.

`CAL 2d` aparece tanto na entrada quanto após aplicação. Para confirmar aplicação,
é necessário passar por `APtO 2d` e confirmar com BTNR. Cada coleta tem limite de
30 segundos. O M de `tEMPO` parece H no display; pode parecer `tEHPO`.

BTND cancela/sai e conserva o perfil ativo. Dentro da interface, **BTNU (cima)**
recupera o perfil anterior. Fora dela, botões mantêm as funções existentes.

| Mensagem | Significado |
|---|---|
| `tEMPO` | Tempo excedido; saia com BTND e prepare o giro antes de reiniciar |
| `nIVEL` | Montagem fora da faixa de nivelamento |
| `COB Err` | Cobertura insuficiente na validação |
| `IGUAL` | Não demonstrou melhora suficiente; perfil ativo conservado |
| `rUIdO` | Amostras/candidato não atenderam aos critérios de qualidade |
| `I2C Err`, `dAt Err`, `OVEr` | Comunicação/sensor, amostra obsoleta ou overflow; interrompa e diagnostique |

## Implementação e evidências

Estima offsets X/Y e ganhos diagonais por extremos da primeira volta. Valida em
uma segunda volta, exigindo cobertura de oito setores e limites de energia.
Só aplica após confirmação e amostra nova válida. Perfil ativo, candidato e backup
ficam separados. Rejeitar um candidato não substitui o perfil ativo.

O perfil novo é selecionado somente aproximadamente nivelado. Inclinado, usa o
caminho 3D inicial. A troca entre perfis pode produzir diferença de rumo. Não é
ajuste completo de elipsoide, não corrige soft iron girado nem garante rejeição
de interferência uniforme. O perfil inicial mantém alinhamento **81°**, offsets
**67/−181/−226**, ganhos Q12 **3923/4004/4390** e o MPU6050 preservado.

[Detalhes da implementação](DETALHES-IMPLEMENTACAO.md) são o registro histórico
offline; [aceites/](aceites/) contém as confirmações posteriores na placa.

| Verificação | Resultado |
|---|---|
| Treino/holdout sintéticos separados | 13 cenários com aceitação e rejeição |
| Falhas, controles e display | PASS; 7.040 verificações do display |
| Aritmética da comparação | 128 vetores de fronteira/aleatórios |
| Integração top e regressões selecionadas | PASS em simulação, com modelos/injeção de sinais |
| Timing roteado | WNS +0,070 ns; WHS +0,019 ns; TNS/THS zero |
| DRC | Zero erros, 180 avisos |
| CDC | CDC-10: 3 pendentes; CDC-8: 1 pendente; CDC-15: 176 |
| Timing externo SPI | Não qualificado |
| Flash | Duas leituras prévias idênticas, uma gravação e readback integral exato |
| Boot por registradores | USERCODE correto, DONE/INIT_B/EOS=1, CRC_ERROR=0, sem fallback |
| Ciclo físico de energia | Início normal confirmado pelo operador; sem nova consulta JTAG após o ciclo |

Medições físicas HUD/celular: inicial **150°/151°**, após giro **253°/245°**,
retorno **152°/155°**. Diferenças −1°, +8° e −3°. O retorno do HUD ficou 2° acima
da própria leitura inicial. Celular não é referência metrológica; isso não comprova
exatidão em toda a volta ou em outros ambientes.

O teste legado `mpu6050_i2c_tb` ficou inconclusivo por limitações dos simuladores;
o RTL do MPU não mudou. `tb_hud_dispatch` tem expectativa incompatível também
com o baseline, registrada separadamente. Esses dois testes não são PASS.

## Reproduzir sem programar hardware

Dependências: Python 3 e Icarus Verilog (`iverilog`/`vvp`). Nesta pasta:

```bash
bash scripts/reproduzir-testes.sh
```

A reprodução completa passou também nesta cópia isolada de publicação.
São gerados vetores, executáveis e logs locais. Para implementar em nova pasta
temporária usando o Vivado 2026.1 instalado:

```bash
VIVADO="/caminho/do/Vivado/2026.1/bin/vivado" bash scripts/reproduzir-build.sh
```

Não executa JTAG, gravação Flash ou escrita no SD. Os fontes RTL, constraints,
MIG e genéricos são os usados na implementação. No executor Python de regressão,
foi removida apenas uma variável absoluta não utilizada para o empacotamento.
[MANIFESTO.json](MANIFESTO.json) registra identidades e resultados.

## Vídeo, programação e recuperação

Este BIT espera vídeo B++ **640×480, 2 bpp, 4.800 quadros, 30 FPS configurados**,
SHA-256 `229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`,
no **LBA 31837888**, com **720001 setores**. A taxa física não foi medida. O vídeo
não está incluído nesta publicação e o BIT não descobre automaticamente a posição
do arquivo em outro cartão. Não grave esse LBA em outro cartão sem conferir seu
layout. O vídeo gravado é independente da atitude dos sensores.

O ZIP contém `bitstream/`, `resultado/routed.dcp` e `flash/` com MCS SPIx1 de16MiB
e recuperação anterior5D6E509A. Essas imagens são específicas da montagem ensaiada.
Antes de substituir outra Flash, preserve um backup atual completo e confira placa,
capacidade, seleção de configuração e hashes. O leitor temporário AMD deve ser
obtido do Vivado instalado; não é redistribuído. O pacote não inclui comandos de
apagamento/programação automática. A recuperação foi preservada e conferida, mas
sua restauração física não foi testada. Gravar a MCS não salva os coeficientes runtime.
