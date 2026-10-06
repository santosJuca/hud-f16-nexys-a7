# HUD com HMC5883L: validação sem placa

Bitstream para Nexys A7-100T, `xc7a100tcsg324-1`, gerado pelo Vivado 2026.1
com `scripts/build_vivado.tcl`. A placa estava desligada; não foi programada e
não houve acesso ao Hardware Manager.

## Resultado da implementação

| Verificação | Resultado |
| --- | --- |
| Síntese | 0 erros, 0 avisos críticos |
| Implementação | Fully Routed; bitstream gerado |
| DRC | 0 erros; 40 avisos |
| WNS / TNS | +0,138 ns / 0,000 ns |
| WHS / THS | +0,024 ns / 0,000 ns |
| WPWS / TPWS | +4,500 ns / 0,000 ns |
| Slack (VIOLATED) | Nenhuma ocorrência no relatório final |
| Endpoints internos sem restrição | 0 |
| Recursos | 9.284 LUTs, 5.399 registradores, 15 DSPs, 0 BRAM |

O primeiro route apresentou WNS −0,177 ns na velocidade inercial estimada.
Um registro adicional separou a conversão por 13 da soma/saturação. A deadzone
após `accel_s1` e a aquisição por `dt_valid` foram mantidas. O build final acima
foi executado novamente com essa mudança; não foram adicionados false paths
nem multicycle paths.

SHA256 de `top_reticula.bit`:

```text
1a3ca507dfbeb5a832cf933a2f3ccd5c3a151ad4a077852b5262e715595786ef
```

`SHA256SUMS` identifica o bitstream e os relatórios desta pasta.
`FONTES_SHA256.txt` identifica os arquivos RTL, XDC e scripts usados no build,
com caminhos relativos à raiz do repositório. Os relatórios copiados tiveram
apenas espaços no fim das linhas e linhas vazias finais removidos.

## Testes

`./scripts/test.sh` concluiu com **42/42 testes aprovados** e a mensagem
`TODOS OS TESTES PASSARAM`; a lista está em `TESTES.txt`. A compilação isolada do
top completo com Icarus e `git diff --check` também passaram. Os testes novos
cobrem falhas e recuperação I²C, 1.382 vetores em quatro configurações de CORDIC,
seleção magnético/manual, botões, estabilidade por quadro e equivalência do
pipeline da velocidade. Os testes existentes de SENSOR/MANCHE, VGA, BMP085 e
MPU6050 passaram na mesma regressão final.

## Avisos auditados

- Síntese: mesmas categorias de avisos da versão local inicial, sem novos
  avisos críticos. Há remoção de bits sem uso, portas sem carga/constantes e
  aviso de FSM sem reset externo; os estados iniciais seguem a inicialização
  por configuração usada no projeto.
- DRC: `CFGBVS-1` (1), `DPIP-1` (12), `DPOP-1` (12), `DPOP-2` (15).
  São as categorias já presentes; a distribuição dos avisos de pipeline de DSP
  mudou de 11/13/15 para 12/12/15. Timing do projeto final passou.
- `CFGBVS/CONFIG_VOLTAGE` continuam sem declaração explícita no XDC existente.
  O DRC não bloqueou a geração do bitstream.
- O relatório registra 15 entradas sem input delay (9 com exceção assíncrona
  existente) e 22 saídas sem output delay, como na versão local inicial.
  I²C, controles, LEDs e VGA externos não têm validação elétrica ponta a ponta
  por este relatório. Não há endpoints internos sem restrição, clocks ausentes
  ou loops combinacionais.
- Icarus: avisos conhecidos de constant selects em `always_*`; não impedem a
  simulação.

## Arquivos de código e documentação desta versão

- `README.md`, `docs/hmc5883l.md`: funcionamento, limites e validação sem placa.
- `constraints/nexys_a7_reticula.xdc`: preserva a ligação HMC já existente;
  40 associações de pinos/portas sem colisões, SDA G1, SCL G2 e MAG_LED V17.
- `rtl/hmc5883l_i2c.sv`: driver local validado; esperas parametrizadas mantendo
  os valores originais no hardware.
- `rtl/heading_magnetico.sv`: CORDIC, offsets neutros e orientação parametrizável.
- `rtl/top_reticula.sv`: seleção magnético/manual antes da interface do HUD;
  preserva o mapeamento validado do joystick e a integração local da velocidade.
- `rtl/velocidade_inercial.sv`: preserva a implementação local e acrescenta o
  registro necessário ao timing.
- `rtl/reticula_caca_vga.sv`: ajustes locais preservados integralmente.
- `scripts/test.sh`: preserva os testes anteriores e acrescenta quatro testes.
- `tests/hmc5883l_slave.svh`, `tests/tb_hmc5883l_i2c.sv`,
  `tests/tb_heading_magnetico.sv`, `tests/tb_top_heading.sv`: modelo I²C e testes
  do driver, cálculo e integração.
- `tests/tb_velocidade_inercial_pipeline.sv`: equivalência numérica do pipeline,
  saturações e perda com operações pendentes.
- `tests/tb_velocidade_inercial.sv`, `tests/tb_velocidade_inercial_dt_real.sv`,
  `tests/tb_estilos.sv`, `tests/tb_horizonte.sv`: trabalho local preservado
  integralmente.

## Pendências físicas

Conferir os eixos/sinais do breakout, calibrar hard-iron, avaliar distorção
soft-iron e interferência magnética, verificar pull-ups e sinais I²C e testar
movimento real no HUD. Os offsets começam em zero. O resultado é rumo magnético
estimado **plano**, sem compensação de inclinação ou declinação geográfica.
MAG_LED indica identificação/configuração, não calibração ou precisão.
A velocidade permanece descrita como velocidade inercial estimada.

## Identificação no acervo

Data do pacote: 05/10/2026. Fontes e artefatos publicados na `main` em
`de80521704b04bc6029f99fae43a71ad09780658`; `FONTES_SHA256.txt` identifica as fontes
exatas usadas antes da publicação. Esta versão antecede a fusão heading/vertical.
**PENDENTE DE VALIDAÇÃO FÍSICA**. Veja o [catálogo](../README.md) para a versão de fusão.
