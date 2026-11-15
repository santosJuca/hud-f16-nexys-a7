# Consolidação do HUD F-16 em 15/11/2026

## Critério

Reunir a versão recente ensaiada e os materiais anteriores aproveitáveis,
preservando a identidade de cada conjunto. A integração não altera RTL,
constraints, MIG, genéricos nem relatos de bancada do firmware 5D7A3AE2.
O código da base v1.1 na raiz também permanece igual a `c481ceb`.

## Origens e decisões

| Origem | Decisão | Motivo |
| --- | --- | --- |
| Main `14d1bf0` | Preservada como base | Inclui atlas elétrico; não substituir pelo estado antigo de main citado no PR #6 |
| PR #6, `c481ceb` | Integrado por merge | Reúne HUD v1.1, vídeo BRAM, captura, testes, infraestrutura de build, CAD e registros anteriores |
| Release recente, `057b586` | Integrada por merge | Snapshot 5D7A3AE2 ensaiado, com fontes/constraints/MIG, parâmetros, relatórios e aceites identificados |
| Branches de sensores, fusão, joystick, v1.0/v1.1/v1.2 e mecânica alcançáveis pelo PR #6 | Preservadas pela consolidação | Não é necessário reaplicar mudanças já incorporadas |
| PR #2, Stealth V3 | Material incorporado pelo PR #6 | Mantido como projeto mecânico preliminar, sem liberação de fabricação |
| PR #5, `b0bff36` | Mantido separado | Máscara/chave VGA externa experimental; testes lógicos não comprovam a interface física |
| Vídeo 2 bpp, `f647916` | Comparado, sem merge integral | Árvore experimental HUD/DDR2 anterior ao snapshot recente; não substituir fontes posteriores por esse top |
| DDR2/status `f752a74`, SPI `8162051` e sprint `59f1c7b` | Comparados, preservados nas branches | Candidatos e relatórios explicitamente experimentais; não reaplicar top, pinagem ou perfil antigos |
| Alterações não commitadas dos worktrees | Preservadas no lugar | Não têm identidade de entrega ou aceite suficiente para incorporação automática |

A comparação com a árvore experimental 2 bpp encontrou 63 fontes HUD idênticas
ao pacote recente e 14 diferentes, além de um backup de top não incorporado.
O snapshot recente contém as evoluções posteriores de composição, instrumentos,
modos, calibração e integração. Não se presume equivalência física entre seus
perfis e os candidatos anteriores. O estudo de frequência permanece como referência,
sem habilitação automática de novos clocks.

Os worktrees originais, branches, tags, artefatos e backups permanecem preservados.
O trabalho foi preparado em worktree novo, separado da main e dos experimentos.

## Organização

- README de entrada aponta para 5D7A3AE2, seus comandos e artefatos.
- O pacote recente continua em `firmware/calibracao-guiada-5d7a3ae2/`, com conteúdo preservado de `057b586`.
- `rtl/`, `constraints/`, `scripts/` e `tests/` da raiz continuam como base v1.1 reproduzível.
- O índice separa versão recente, base anterior, evidências e estudos históricos.
- README anterior e entrega de 08/10 foram preservados em `docs/historico/`.
- As páginas de pinagem, sensores, arquitetura e timing identificam o perfil a que pertencem.
- O CI verifica separadamente a base e o pacote recente, com retenção de artefatos de 30 dias.

O atlas mostra o buzzer em JD4; a base v1.1 da raiz usa outro mapeamento.
A navegação explicita essa diferença. Para qualquer montagem, conferir o XDC do
perfil escolhido, sem misturar instruções entre as versões.

## Validação desta integração

Resultados locais da cópia integrada, sem programação de hardware:

| Verificação | Resultado |
| --- | --- |
| Identidade RTL da raiz com `c481ceb` | Confirmada por diff |
| Identidade do pacote recente com `057b586` | Confirmada por diff; inclui fontes, scripts, genéricos e evidências preservadas |
| Ferramentas Python da base | 9 testes PASS |
| Vídeo/captura da base | PASS: seis cenários de vídeo e dez bancos adicionais |
| Calibração recente | PASS: 13 cenários sintéticos, falhas, controles, display e 128 vetores aritméticos |
| Regressões recentes selecionadas | 9 bancos PASS |
| Integração do top recente | PASS com modelos/injeção de sinais |
| Regressão principal da base | 84 bancos PASS, incluindo o teste final MPU6050 |

A suíte recente continua identificando `tb_hud_dispatch` como incompatível com
o baseline e `mpu6050_i2c_tb` como inconclusivo naquela configuração. Eles não
são convertidos em PASS. O teste MPU da base v1.1 é uma execução separada.
Logs desta revisão ficam em `build/organizacao-main/`; os jobs do CI publicam
logs e capturas associados ao SHA da integração. Nenhum CI anterior é atribuído
a esta nova revisão. Não houve síntese, novo BIT nem ensaio físico nesta organização.

## Limites e anexos restantes

O programa 5D7A3AE2 teve boot físico relatado em 13/11. O registro anterior que
aguardava power cycle é complementado por `aceites/flash-aceite-boot-fisico.json`;
não representa uma pendência geral atual. Não houve nova consulta à placa nesta revisão.

Continuam três CDC-10, um CDC-8, timing externo SPI não qualificado e 30 FPS
físicos não medidos. Os coeficientes runtime da calibração são voláteis.
A restauração física da recuperação preservada não foi testada.

O vídeo B++ esperado tem SHA-256
`229261917a3ad34b355656fc455fc8ee1041f36f42d823421b6e529566bf1d4a`.
Ele está preservado localmente fora do Git; a release pública de vídeo contém
`450d2b3d…`, uma mídia anterior. A consolidação não publica nem grava outro vídeo.
O [guia de entrega](entrega_demo.md) mantém a checklist de relatório, apresentação,
Fmax, evidência de pipeline e demo VGA. Integração Git não conclui esses entregáveis.
