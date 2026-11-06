# Cobertura das funcionalidades

Destino dos recursos integrados: `integration/consolidacao-geral-20261106`. Os testes citados são verificações digitais; o resultado final da execução está em [testes e implementação](testes.md). Relatos físicos são identificados por versão e hash nos documentos v1.0/v1.1.

| Funcionalidade | Origem | Destino | Evidência de teste | Situação |
|---|---|---|---|---|
| I²C STOP atômico, timeout e recuperação MPU/HMC | dev/fix-i2c-stop e correções posteriores | Drivers atuais | mpu6050_i2c_tb, tb_hmc5883l_i2c | Integrada |
| Bias/dt e integração gyro legados | dev/imu-gyro-bias-dt | Cadeia complementar e heading | tb_gyro_bias_dt, tb_gyro_integrador, tb_atitude_gyro_hud | Integrada; caminho legado preservado |
| Estimador vetorial de gravidade e CORDIC | feat/video-sd-overlay, v1.0 | FULL_ATTITUDE=1 | tb_atitude_vetorial, tb_horizonte_completo; relato v1.1 | Integrada; algoritmo preservado |
| Rejeição de movimento/pose inválida na calibração | v1.0 | atitude_vetorial | tb_atitude_bias, tb_top_atitude_bias | Integrada |
| Autozero MPU seguro e único | v1.0 | hud_auto_zero | tb_hud_auto_zero, tb_top_video_startup; boot relatado v1.0 | Integrada |
| Zero manual SW7 na captura | v1.0 | captura_controle/top | tb_captura_controle, tb_top_capture | Integrada; ação exige sensor estável |
| ATT BAD, sensor ausente, perda e recuperação | main + v1.0 | Validadores e alertas | testes MPU, atitude e top | Integrada; novo build sem ensaio físico |
| Horizonte artificial, roll/pitch e referência | fix/roll, fix/pitch e v1.0 | Raster e estimador | tb_roll, tb_horizonte, tb_horizonte_completo | Integrada |
| Ladder em alto bank | feat/hud-v1.1-polimento | simbologia_vga | tb_hud_high_bank; ensaio JTAG v1.1 | Integrada; limiar visual atual preservado |
| Retículo e simbologia ORIGINAL/CAÇA | main | Compositor | tb_reticula, tb_estilos, tb_frames_estilos | Integrada |
| Heading, cardeais e bússola fixa | main + v1.0 | heading_magnetico/fusao/raster | 1393 vetores/9 configurações, 124 verificações de fusão; top | Integrada; planar, precisão absoluta não homologada |
| Calibração HMC de 19/10 | fix/calibracao-hmc5883l-20261019 | Dados históricos | CSV, resumo e bitstream preservados | Substituída no build pelo perfil medido de 31/10 |
| Calibração HMC de 31/10 e orientação da montagem | v1.0 | constraints/magnetometer_calibration.tcl e perfil Tcl | hashes, vetores de heading e relato de +90° | Integrada; específica desta montagem |
| BMP085, compensações e altitude/VSI | dev/fusao-sensores/main | Driver e aritmética sequencial | testes bmp085_* e tb_estado_vertical | Integrada; precisão física não caracterizada |
| Velocidade inercial | histórico/main | Módulo/testes preservados | tb_velocidade_inercial e variantes | Experimental; não é airspeed nem fonte operacional |
| Modo manche como fonte de atitude | feat/modo-manche e feat/manche-analogico | Módulos legados preservados | tb_controle_manche, tb_modo_manche | Substituída pela política atual de sensores/manual; não reativada |
| Joystick, quatro sentidos, passo fixo e LOCK independente | PR #3 e mudanças locais equivalentes | mira_joystick/top | tb_top_joystick_lock, tb_joystick_start_threshold, tb_hud_joystick_vertical | Integrada; tensão do XADC requer conferência |
| SOLO/VOO/POUSO, simulação e entrada inválida | feat/modos-alertas/main | operacao_hud | tb_modo_operacao, simuladores e testes integrados | Integrada |
| Alertas, STALL, histerese e ACK | feat/modos-alertas, correções CI | alertas_voo/vga/buzzer | tb_alertas_voo, tb_alertas_vga, tb_buzzer_driver | Integrada; indicadores didáticos |
| Buzzer JD4/G3 | feat/video-sd-overlay | XDC/estágio externo | XDC e relato físico v1.1 | Integrada; pinagem antiga JC7/JC10 é histórica |
| SW0, SW1 e publicação entre quadros | main | NORMAL/DECLUTTER e ORIGINAL/CAÇA | tb_modo, tb_modos, tb_estilos e frames | Integrada |
| SW2/SW3 | main | Seleção operacional | tb_modo_operacao, tb_modos_operacao_integrado | Integrada |
| SW4, BTNU/BTND e alinhamento vertical | v1.0 | Dispatch/offset/flight_coords | tb_hud_dispatch, tb_hud_offset, tb_hud_layers | Integrada; necessita validação física dirigida dos riscos relatados |
| SW5/SW6: quatro vistas; SW5–SW7: páginas compartilhadas | v1.0 | captura e diagnóstico | tb_captura_controle, tb_top_capture | Integrada; funções dependem do contexto |
| BTNL curto/longo e passo por quadro | v1.0 | captura_controle e video_captura | captura/top/vídeo | Integrada; retestar retorno físico do vídeo |
| SW8 e diagnóstico CMD17/ícone | feat/video-sd-overlay | SD diagnóstico/top | tb_sd_diagnostic, tb_top_sd_integration, tb_top_sd_overlay | Integrada |
| SW9–SW11, SW12–SW15 e fallback manual | main/v1.0 | Seleção de fontes e atitude | tb_entrada_hud, tb_top_heading, testes operacionais | Integrada; não confundir manual com medida física |
| BTNC e botão KY-023; BTNR | main | ACK e LOCK; BTNR sem uso | buzzer, joystick e top | Integrada; nenhum pino novo inventado |
| Inicialização SDHC, SPI, comandos e timeouts | feat/video-sd-overlay | sd_spi_* | testes preamble/CMD0/ACMD/init/controller/token | Integrada |
| CMD17, retenção de LBA, CRC16 e falhas | feat/video-sd-overlay/v1.0 | sd_spi_read_block/controller | read_block/controller/throughput e cenários de vídeo | Integrada |
| Buffer BRAM de setor, dois bancos e handshake | feat/video-sd-overlay/v1.0 | sd_sector_buffer | tb_sd_sector_buffer, tb_sd_bitmap_overlay | Integrada |
| Reprodução RGB332, loop e quadros íntegros | v1.0 | sd_video_loader/background | seis cenários pipeline, top vídeo/captura e Vivado | Integrada; perfil físico histórico 160×120/1 FPS solicitado |
| Perfil 320×240 e taxas maiores | v1.0 | Capacidade parametrizada preservada | evidências históricas documentadas; sem novo ensaio 320 nesta execução | Necessita validação adicional; não promovido como perfil físico estável |
| Máscara explícita, RGB, prioridade e clipping | v1.0/v1.1 | Compositor SD/HUD | testes de pixels, quadro, overlay e high_bank | Integrada; RGB preto pode ser opaco |
| VGA 640×480/25 MHz, HS/VS e blanking | main/v1.0 | vga_controller/top | tb_vga e top vídeo | Integrada; refresh 59,524 Hz, sem mudança de raster |
| CAP em captura com HUD | feat/hud-v1.1-polimento | hud_capture_status_vga | tb_hud_capture_status e relato físico v1.1 | Integrada |
| Plano de acabamento v1.2 | feat/hud-v1.2-acabamento | Documento preservado | diff RTL nulo após v1.1 | Experimental/planejado; sem implementar desenho novo |
| Captura VGA externa, genlock e seletor analógico | docs/bancada, PR #5 | Documentação de bancada; código permanece no PR #5 | testes próprios não reexecutados; nenhum hardware externo validado | Experimental, pendente de integração; sem selecionar sobre o vídeo SD funcional |
| Gabinete Stealth V3 | mechanical/hud-fpga-stealth-v3 | mechanical/HUD_FPGA_Stealth_V3 | CRC, SHA-256, envelope STEP e arestas fechadas STL | Integrada como preliminar; não liberada para fabricar |
| Gabinete F-16 v1.3.2: STEP/DXF/manual | case + kit R2 local | gabinete/HUD_F16_V1_3_2_PUBLICACAO_ATOMICA | par STEP corresponde aos SHA-256 originais, ZIP íntegro | Integrada como preliminar; fabricação bloqueada |
| Regeneração CAD integral v1.3.2 | case | Gerador preservado com pendências | sintaxe Python; dependências/fontes geométricas ausentes | Necessita validação adicional; não executável integralmente neste checkout |
| Boot QSPI e recuperação | tag/release v1.0 | Artefatos oficiais mantidos fora do novo build | hashes conferidos e relato histórico de power cycle | Integrada como referência de recuperação; nenhuma Flash gravada |

## Riscos físicos ainda abertos

1. Desaparecimento de vídeo ao ajustar controles, deslocamento da bússola e inconsistência angular foram relatados pelo usuário. Os testes digitais de isolamento passaram, mas não encerram o risco físico. Reproduzir em JTAG com o hash exato do candidato e comparar com a recuperação v1.0, sem alterar a Flash.
2. O mapa/LBA físico do cartão e os atrasos externos SPI não foram requalificados. O bitstream gerado nesta execução é classificado como simulação, não provisionado para o cartão atual.
3. O XADC teve relato de tensão acima da faixa nominal. Conferir a rede existente antes de ligar; não adicionar pinos/divisores presumidos.
4. A calibração magnética depende da montagem e de metais/correntes do gabinete. Não confundir integridade de CAD com compatibilidade elétrica ou precisão dos sensores.

Essas pendências impedem declarar um novo firmware fisicamente estável. A classificação está completa; isso não exige incorporar código experimental ou arquivos inexistentes.
