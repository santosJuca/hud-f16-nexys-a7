# Testes e reprodução

O [runner](../scripts/test.sh) contém **46 bancos**. São 46 execuções, não 46
assertions: cada banco pode verificar muitos casos. O resultado preservado da
fusão é **46 PASS / 0 FAIL**, com top completo compilado em Icarus e retorno 0.
A [validação da fusão](validacao_fusao_sensores.md) registra a execução de 06/10/2026.

## Executar na raiz

```sh
./scripts/test.sh
mkdir -p build/tests
iverilog -g2012 -s top_reticula -o build/tests/top_completo \
  tests/xadc_stub.sv rtl/*.sv
```

O runner usa `set -euo pipefail`: uma compilação ou simulação com retorno diferente
de zero interrompe o processo. A conclusão esperada é:

```text
===== TODOS OS TESTES PASSARAM =====
```

O stub XADC resolve a primitiva apenas em simulação. Não simula a qualidade elétrica
do ADC nem deve entrar na síntese. A compilação estrutural não executa o hardware.

## Cobertura por cadeia

| Grupo | Exemplos de comportamento coberto |
| --- | --- |
| Atitude | Eixos, bias, dt real, integração, correção complementar e conversão para HUD |
| Heading | Driver HMC, CORDIC, quadrantes, gyro positivo/negativo, wrap norte ±2°, perdas/recuperação, expiração e fallback manual |
| Vertical | Projeção plana/inclinada, remoção de gravidade, repouso, subida/descida, correção barométrica, saturação, validade e VSI |
| Velocidade inercial | Integração, pipeline e dt medido |
| BMP085 | Coeficientes, temperatura/pressão, versões sequenciais, continuidade, altitude e monotonicidade |
| Joystick e modos | Direções, centro, manche proporcional, seleção de fonte e modos visuais |
| Display e CDC | Retículo, horizonte, roll, números, modos/estilos, atualização por quadro, transferências e sincronismo VGA |
| Integração | MPU/HMC/BMP → estimadores → entrada_hud → dados_hud; retenção e fallback |

A lista executável completa está no runner, evitando manter outra lista que possa
divergir. Há 49 arquivos rastreados em `tests/`: 46 fontes executadas, `tb_frames_estilos.sv`
auxiliar fora do runner, `xadc_stub.sv` e o modelo `hmc5883l_slave.svh`.
O banco auxiliar não entra no total de 46. O teste integrado de desenho gera
`build/hud.ppm`; inspecionar esse quadro complementa assertions, sem provar saída física.

A [CI](../.github/workflows/ci.yml) executa o runner em push/PR e guarda log/quadro
como artefatos. O workflow não executa Vivado, não mede timing e não programa a FPGA.
O resultado de uma execução futura da CI deve ser consultado, não presumido.

## Alcance da auditoria documental

Nesta revisão, RTL, XDC, testes e scripts foram preservados byte a byte. Foram
conferidos o log final existente, manifesto das fontes, relatórios e hashes dos
bitstreams; a regressão não foi repetida. A compilação estrutural e as verificações
de links/pinagem feitas nesta revisão estão registradas na [auditoria](auditoria_documentacao.md).

Mudanças futuras em RTL/XDC/scripts exigem novamente runner completo, compilação
estrutural e `git diff --check`. Se afetarem implementação, executar Vivado e os
critérios de [timing](timing_recursos.md). Testes de bancada continuam
**PENDENTES DE VALIDAÇÃO FÍSICA**: eixos, calibração, níveis elétricos, ruído, drift,
altitude/VSI e leitura no monitor não podem ser aprovados por simulação digital.
