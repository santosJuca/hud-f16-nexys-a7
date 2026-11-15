# Matriz de reconciliação local

Base: `a6f47b9b373bfd2dd4f6c23288cd0f2561592959`. Todos os worktrees originais foram apenas lidos.

Classes: 1 recurso/teste aproveitável; 2 correção ausente; 3 já incorporado; 4 experimento sem promoção; 5 obsoleto/substituído; 6 conflito de configuração física; 7 gerado/cache. “Não incorporar” não apaga o original.

| Recurso ou arquivo | Origem | Situação na main | Classe / decisão | Evidência |
| --- | --- | --- | --- | --- |
| `README.md` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: DIFF | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `constraints/nexys_a7_reticula.xdc` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: DIFF | 5: Não reaplicar pinagem/documento antigo | JA1/C17 já presente; JC10/E6 substituído por JD4/G3 em ambos os XDC atuais |
| `docs/modos_alertas_buzzer.md` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: ABSENT | 5: Não reaplicar pinagem/documento antigo | JA1/C17 já presente; JC10/E6 substituído por JD4/G3 em ambos os XDC atuais |
| `docs/pinagem.md` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: ABSENT | 5: Não reaplicar pinagem/documento antigo | JA1/C17 já presente; JC10/E6 substituído por JD4/G3 em ambos os XDC atuais |
| `docs/sensores.md` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: ABSENT | 5: Não reaplicar pinagem/documento antigo | JA1/C17 já presente; JC10/E6 substituído por JD4/G3 em ambos os XDC atuais |
| `docs/testes.md` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: ABSENT | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `rtl/mira_joystick.sv` | `Trabalho-display-aviao-v2` | raiz: IDENTICAL; recente: IDENTICAL | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `rtl/top_reticula.sv` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: DIFF | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `scripts/test.sh` | `Trabalho-display-aviao-v2` | raiz: DIFF; recente: ABSENT | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `tests/tb_joystick_start_threshold.sv` | `Trabalho-display-aviao-v2` | raiz: IDENTICAL; recente: ABSENT | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `tests/tb_top_joystick_lock.sv` | `Trabalho-display-aviao-v2` | raiz: IDENTICAL; recente: ABSENT | 3: Manter implementação atual | Passo fixo, LOCK independente e testes já incorporados via PR #6; mira_joystick e dois testes idênticos |
| `tests/__pycache__/test_convert_video_for_fpga.cpython-312.pyc` | `Trabalho-display-aviao-v2-video-sd` | Não é fonte | 7: Não incorporar; preservar na origem | Bytecode gerado, não fonte |
| `tests/__pycache__/test_map_sd_video.cpython-312.pyc` | `Trabalho-display-aviao-v2-video-sd` | Não é fonte | 7: Não incorporar; preservar na origem | Bytecode gerado, não fonte |
| `tests/tb_atitude.sv` | `Trabalho-display-aviao-v2-video-sd` | raiz: IDENTICAL; recente: ABSENT | 3: Manter versão da main | Arquivo idêntico à main |
| `tests/tb_modos.sv` | `Trabalho-display-aviao-v2-video-sd` | raiz: DIFF; recente: ABSENT | 5: Manter versão da main | Única diferença restante: redução artificial de debounce; main testa os 10 ms reais |
| `tests/tb_roll.sv` | `Trabalho-display-aviao-v2-video-sd` | raiz: IDENTICAL; recente: ABSENT | 3: Manter versão da main | Arquivo idêntico à main |
| `tests/tb_top_heading.sv` | `Trabalho-display-aviao-v2-video-sd` | raiz: IDENTICAL; recente: ABSENT | 3: Manter versão da main | Arquivo idêntico à main |
| `tools/__pycache__/convert_video_for_fpga.cpython-312.pyc` | `Trabalho-display-aviao-v2-video-sd` | Não é fonte | 7: Não incorporar; preservar na origem | Bytecode gerado, não fonte |
| `tools/__pycache__/map_sd_video.cpython-312.pyc` | `Trabalho-display-aviao-v2-video-sd` | Não é fonte | 7: Não incorporar; preservar na origem | Bytecode gerado, não fonte |
| `constraints/magnetometer_calibration.tcl` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 6: Preservar calibração mais recente | 892/-274/4546/3727 são específicos da montagem de 08/11; genericos.txt recente usa perfil 3D posterior |
| `constraints/nexys_a7_reticula.xdc` | `hud-video-modos-20261106` | raiz: DIFF; recente: DIFF | 3: Manter evolução recente | Alinhamento, display de modo e recuperação presentes; recente acrescenta rolagem, DDR2, calibração e controles posteriores |
| `docs/GUIA_OPERACIONAL_HUD_V1_1.md` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 3: Manter evolução recente | Alinhamento, display de modo e recuperação presentes; recente acrescenta rolagem, DDR2, calibração e controles posteriores |
| `docs/calibracao_hmc5883l_20261108/README.md` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Arquivar registro, sem ativar coeficientes | Quatro arquivos copiados byte a byte para docs/historico/; dados da montagem de 08/11 |
| `docs/calibracao_hmc5883l_20261108/amostras.csv` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Arquivar registro, sem ativar coeficientes | Quatro arquivos copiados byte a byte para docs/historico/; dados da montagem de 08/11 |
| `docs/calibracao_hmc5883l_20261108/posicoes_guiadas.json` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Arquivar registro, sem ativar coeficientes | Quatro arquivos copiados byte a byte para docs/historico/; dados da montagem de 08/11 |
| `docs/calibracao_hmc5883l_20261108/resumo.json` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Arquivar registro, sem ativar coeficientes | Quatro arquivos copiados byte a byte para docs/historico/; dados da montagem de 08/11 |
| `docs/correcao_orientacao_mpu_20261108.md` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Arquivar contexto e recuperar teste | Registro preservado; parâmetros atuais MPU=0/FRENTE=0 já correspondem ao perfil corrigido |
| `rtl/heading_magnetico.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: IDENTICAL | 3: Manter fonte recente; recuperar execução MPU | Idêntico ao pacote recente, incluindo tests/regressao; MPU agora tem limite de 600 s no runner |
| `rtl/mpu6050_i2c.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: IDENTICAL | 3: Manter fonte recente; recuperar execução MPU | Idêntico ao pacote recente, incluindo tests/regressao; MPU agora tem limite de 600 s no runner |
| `rtl/sd_status_display.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: DIFF | 3: Manter evolução recente | Alinhamento, display de modo e recuperação presentes; recente acrescenta rolagem, DDR2, calibração e controles posteriores |
| `rtl/top_reticula.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: DIFF | 3: Manter evolução recente | Alinhamento, display de modo e recuperação presentes; recente acrescenta rolagem, DDR2, calibração e controles posteriores |
| `scripts/build_attitude_capture.tcl` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 4: Não portar perfis antigos ou ampliar SPI | Perfil de montagem corrigido já está no genericos.txt recente; exceção 25 MHz/simulation não é necessária ao wrapper BRAM preservado |
| `scripts/build_sd_video.tcl` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 4: Não portar perfis antigos ou ampliar SPI | Perfil de montagem corrigido já está no genericos.txt recente; exceção 25 MHz/simulation não é necessária ao wrapper BRAM preservado |
| `scripts/test.sh` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 1: Integrar via runner separado | Teste novo de orientação compila com fontes recentes; não misturar com o RTL v1.1 da raiz |
| `tests/mpu6050_i2c_tb.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: IDENTICAL in tests/regressao | 3: Manter fonte recente; recuperar execução MPU | Idêntico ao pacote recente, incluindo tests/regressao; MPU agora tem limite de 600 s no runner |
| `tests/tb_heading_magnetico.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: IDENTICAL in tests/regressao | 3: Manter fonte recente; recuperar execução MPU | Idêntico ao pacote recente, incluindo tests/regressao; MPU agora tem limite de 600 s no runner |
| `tests/tb_modos_operacao_integrado.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 3: Manter cobertura atual e complementos | Testes de modo/display/heading já existem; novos testes live heading, âncoras e ALIGN recuperados cobrem o contrato recente |
| `tests/tb_sd_status_display.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: IDENTICAL in tests/regressao | 3: Manter fonte recente; recuperar execução MPU | Idêntico ao pacote recente, incluindo tests/regressao; MPU agora tem limite de 600 s no runner |
| `tests/tb_sd_video_pipeline.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 4: Preservar parametrização na origem | Benchmark RGB332 de 320x240; não equivale a vídeo recente 640x480/2bpp/DDR2; seis cenários da base continuam cobertos pelo CI |
| `tests/tb_top_heading.sv` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 3: Manter cobertura atual e complementos | Testes de modo/display/heading já existem; novos testes live heading, âncoras e ALIGN recuperados cobrem o contrato recente |
| `tests/tb_top_mpu_orientacao.sv` | `hud-video-modos-20261106` | raiz: ABSENT; recente: ABSENT | 1: Integrar teste contra fontes recentes | Arquivo original idêntico; CORRIGIDO=0 e 1 executados pelo runner complementar |
| `tests/test_build_video_bitstream.py` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 1: Integrar parte aplicável | Captura do Tcl real até synth_design, preservação dos demais genéricos e rejeição de SPI não qualificado; sem coeficientes antigos ou novos clocks |
| `tests/test_convert_video_for_fpga.py` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 1: Integrar teste original | test_seconds_limits_real_input reproduziu a falha e passou após a correção |
| `tools/build_video_bitstream.py` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 4: Não portar perfis antigos ou ampliar SPI | Perfil de montagem corrigido já está no genericos.txt recente; exceção 25 MHz/simulation não é necessária ao wrapper BRAM preservado |
| `tools/convert_video_for_fpga.py` | `hud-video-modos-20261106` | raiz: DIFF; recente: ABSENT | 2: Integrar correção de duração | Antes: 60 quadros ao pedir 30; depois: 30, teste real FFmpeg PASS |

## Commits locais sem referência remota direta

| Commit local | Equivalente remoto já incorporado | Resultado |
| --- | --- | --- |
| `5eb6c8a` | `0053899` | Patch-id estável idêntico |
| `b7c78cd` | `d096e68` | Patch-id estável idêntico |
| `b2c86e4` | `d00eb57` | Patch-id estável idêntico |

## Testes adicionais encontrados fora dos três worktrees sujos

| Teste local | Decisão | Evidência |
| --- | --- | --- |
| `hud-fechamento-20261112/tests/tb_heading_video_live.sv` | Integrado sem alterar o teste | Rumo ao vivo, wrap e perda/recuperação PASS |
| `hud-fechamento-20261112/tests/tb_video_pipe_equivalence.sv` | Integrado sem alterar o teste | 4.800 quadros em dois perfis PASS |
| `hud-fechamento-20261112/tests/tb_video_operacao_f16_anchors.sv` | Integrado sem alterar o teste | Âncoras e fases PASS |
| `hud-fechamento-20261112/tests/tb_compass_tilt.sv` | Integrado sem alterar o teste | 99 poses por mapeamento, MAP0/1 PASS; não mede precisão física |
| `apresentacao-autonoma-20261112/alinhamento-xy/tb_alignment_routing.sv` | Integrado sem alterar o teste | Prioridade SW4 e BTNL retido PASS |
| `hud-fechamento-20261112/tests/tb_landing_switch_paths.sv` | Não integrar expectativa antiga | Espera término da decolagem antes de POUSO; a versão posterior aceita o pedido na próxima publicação |
| `tb_sem_caixas.sv` e bancos bank90 em output/ | Preservados como estudos | Comparadores de candidatos requerem baseline visual externo; fontes recentes já coincidem com o build final |

Hashes dos arquivos originais, patches completos, staged, ignorados e inventário de todos os worktrees: `build/reconciliacao-local/estado-original.json`, `matriz-reconciliacao.json`, `branches.txt`, `historico.txt` e patches individuais.
