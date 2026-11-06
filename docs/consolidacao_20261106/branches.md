# Inventário completo de branches

Fotografia após fetch em 06/11/2026: **18 locais, 19 remotas, 22 nomes distintos, 37 referências**. A branch criada para esta consolidação não entra nessa contagem. Nenhuma `master` foi encontrada. `main` remota inicial: `0081e1dfc0e726c84a37bd41a31e9508d5876b48`; main local inicial: `791339a`.

Foram inventariados 138 commits alcançáveis e um commit adicional de reflog (`59a240f`). As diferenças de cada branch para a base comum foram comparadas, incluindo patch-id estável. Os números +/− abaixo são commits por ancestralidade, não quantidade de funcionalidades faltantes.

| Branch / origem | Último commit | Diferenças para main inicial | Funcionalidades exclusivas ou históricas | Testes/evidência | Decisão |
|---|---|---|---|---|---|
| `case` (remota) | `9d3ff33` | +1/−0 | Gerador/manifesto F-16 v1.3.2 | SHA-256 do par STEP recuperado do kit R2 | Integrada; STEP/DXF/manual recuperados, fontes auxiliares ausentes e fabricação bloqueada |
| `dev/fix-i2c-stop` (local/remota) | `b432d8e` | +0/−60 | STOP I2C, falhas e recuperação | mpu6050_i2c, hmc5883l_i2c | Integrada na main de entrada |
| `dev/fusao-sensores` (local/remota) | `84411c3` | +0/−32 | Heading fusionado e estado vertical | heading_fusao, estado_vertical, top_fusao_sensores | Integrada na main de entrada |
| `dev/imu-gyro-bias-dt` (local/remota) | `f7a6c64` | +0/−53 | Bias/dt e pipeline do gyro | gyro_bias_dt, gyro_integrador, atitude_fusao_complementar | Integrada na main de entrada |
| `docs/bancada-sobreposicao-vga` (local/remota) | `85da5f7` | +5/−12 | Registro e diagrama dos cabos VGA; correção CI anterior | equivalência de conteúdo e testes de alertas/estilos | 4 commits documentais recuperados; correção CI substituída por d00eb57 e b2c86e4 |
| `docs/consolidacao-final-hud` (local) | `d3797b7` | +0/−51 | Documentação MPU/HUD | histórico ancestral | Integrada na main de entrada |
| `docs/organizacao-final` (local/remota) | `7e5a670` | +1/−32 | Organização documental e proposta VGA auxiliar | comparação dos 20 arquivos | Substituída por documentação posterior; estudo VGA existente preservado. Não repor política de sensores antiga |
| `feat/hud-v1.1-polimento` (local/remota) | `1d39826` | +18/−1 | CAP e ladder em alto bank; ensaio JTAG 8/8 | hud_capture_status, hud_high_bank; relato de 01/11 | Integrada por ancestralidade da v1.2; qualificação física vinculada ao bitstream histórico |
| `feat/hud-v1.2-acabamento` (local/remota) | `90e5e78` | +19/−1 | Somente plano documental adicional | diff RTL nulo em relação a 622eacb | Integrada; nenhuma melhoria v1.2 de RTL implementada |
| `feat/manche-analogico` (local) | `2025efd` | +0/−43 | Geometria e controle analógico históricos | mira_joystick, controle_manche, modo_manche | Integrada por ancestralidade; seleção SENSOR/MANCHE substituída na política operacional, módulos legados preservados |
| `feat/modo-manche` (local/remota) | `98f54f7` | +0/−42 | Modo manche proporcional histórico | modo_manche, controle_manche | Integrada por ancestralidade; legado, sem substituir fontes atuais |
| `feat/modos-alertas` (local/remota) | `791339a; local 7fba64a` | +0/−12 | SOLO/VOO/POUSO e STALL; commit local CI extra | alertas_voo, frames_estilos | Funcionalidade integrada; 7fba64a coberto por correção CI posterior mais completa |
| `feat/p1-hud-overlay-mask-20261019` (remota) | `b0bff36` | +9/−0 | Máscara e seletor lógico de futura chave VGA externa | testes próprios existentes na branch; não reexecutados nesta consolidação | Experimental; PR #5 preservado, sem merge no top. Vídeo SD já possui máscara explícita própria |
| `feat/video-sd-overlay` (local/remota) | `33bf42c` | +14/−1 | SDHC, CMD17, CRC, BRAM, vídeo, atitude vetorial, autozero e montagem | testes SD/vídeo/atitude; build de vídeo atual | Integrada pela v1.1; sem experimentar resolução/FPS novos |
| `fix/calibracao-hmc5883l-20261019` (local/remota) | `04e04c3` | +2/−1 | Calibração de 19/10 e documentação posterior | heading_magnetico, fontes/relatórios históricos | Integrada; perfil de 19/10 substituído pelo de 31/10 para a montagem atual, dados históricos preservados |
| `fix/ci-regressao-hud-20261013` (remota) | `d00eb57` | +0/−11 | STALL e cobertura de quadros/artefatos CI | alertas_voo, frames_estilos | Integrada na main de entrada; patch equivalente a b2c86e4 |
| `fix/pitch-grid-geometria` (local/remota) | `02f72e4` | +0/−44 | Grade pitch e opções de sensores | horizonte, roll e testes de raster | Integrada na main de entrada |
| `fix/roll-horizonte-aeronautico` (local/remota) | `f0cbec8` | +0/−48 | Convenção de roll/horizonte | roll, horizonte | Integrada na main de entrada |
| `integration/hud-consolidacao-20261019` (local) | `5eb6c8a` | +3/−11 | Pinagem, joystick fixo/LOCK e limpeza combinacional | top_joystick_lock, joystick_start_threshold | Equivalentes cherry-picked na main via PR #3; nenhuma mudança perdida |
| `integration/hud-consolidacao-pr-20261019` (local/remota) | `6b538f7` | +0/−5 | Correções joystick/pinos integradas via PR #3 | testes joystick/top | Integrada na main de entrada |
| `main` (local/remota) | `0081e1d; local 791339a` | +0/−0 | Base estável remota 0081e1d; branch local atrasada | baseline e histórico PR #1/#3/#4 | Base da integração; não sobrescrever main local atrasada |
| `mechanical/hud-fpga-stealth-v3` (remota) | `28132ff` | +1/−12 | FreeCAD, macro, STEP/STL e referências V1/V2/V3 | CRC de ZIP/FCStd, envelope STEP, arestas STL e hashes das referências | Integrada como CAD preliminar separado; PR #2 não fechado automaticamente |

## Equivalências e reversões

- `5eb6c8a` ≡ `0053899`: remoção de inicializações combinacionais; `b7c78cd` ≡ `d096e68`: mesma correção em cherry-pick; `d00eb57` ≡ `b2c86e4`: CI. Equivalência calculada por patch-id, não por título.
- O commit `7fba64a` não tem patch-id idêntico, mas suas alterações de STALL/estilos já estão cobertas pela revisão CI posterior; não reaplicar patch antigo sobre testes novos.
- `59a240f`, encontrado via reflog/fsck, preserva um bitstream de 05/10 com pendência de timing VGA. Classificado **com defeito identificado**, substituído pelas versões posteriores; protegido no backup, não promovido.
- Não foram encontradas mensagens de revert no histórico alcançável. Isso não prova ausência de desfazimentos manuais; as árvores e funcionalidades, não só mensagens, fundamentam as decisões.

## GitHub, tags e worktrees

Cinco PRs existiam na entrada: #1/#3/#4 integrados; #2 CAD aberto; #5 máscara VGA em draft. Foram consultados os estados e os conteúdos. Quatro releases e cinco tags existiam; nenhuma foi alterada ou apagada. A proteção/rulesets retornou HTTP 403 por limitação de plano do repositório privado; a listagem das branches informa protected=false. Nenhuma proteção foi contornada.

Quatro worktrees originais foram preservados. O worktree principal continha nove arquivos modificados e dois testes novos: as funcionalidades joystick/LOCK já coincidem ou estão incluídas na implementação posterior. O worktree vídeo tinha quatro testes modificados, recuperados integralmente, e caches Python não integrados. Os outros dois estavam limpos. Backup contém patches binários, arquivos não rastreados, estados, refs, reflogs e hashes dos artefatos.

Os logs/diffs completos do inventário estão no backup local; não foram publicados caminhos de usuário de outros projetos, credenciais ou caches.
