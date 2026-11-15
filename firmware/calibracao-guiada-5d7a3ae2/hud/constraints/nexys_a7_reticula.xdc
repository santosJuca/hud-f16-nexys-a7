## =========================================================
## nexys_a7_reticula.xdc
## Constraints para o projeto da retícula no Nexys A7
## Pinos conferem com o Master XDC oficial da Digilent
## para o Nexys A7-50T / A7-100T
## =========================================================

# Nexys A7 D.0, esquematico Digilent 500-292, folhas 8 e 10:
# CFGBVS_0/P8 e VCCO_0/R9 ligados a VCC3V3.
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Clock 100 MHz do board
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { clk }]; #Sch=clk100mhz
create_clock -name {u_ui_test/u_mig/sys_clk_i} -period 10.000 -waveform {0 5} [get_ports { clk }];

# Clock de pixel gerado pelo divisor por quatro do controlador.
create_generated_clock -name pixel_clk -source [get_ports clk] -edges {3 7 11} [get_pins u_vga/clk25_reg/Q]

## MicroSD, Nexys A7-100T Master XDC Digilent. SD_DAT[1:2] não usados.
## SD_DAT0 é entrada (MISO); SD_DAT3 é CS ativo baixo em SPI.
set_property -dict { PACKAGE_PIN E2 IOSTANDARD LVCMOS33 } [get_ports { SD_RESET }]
set_property -dict { PACKAGE_PIN B1 IOSTANDARD LVCMOS33 } [get_ports { SD_SCK }]
set_property -dict { PACKAGE_PIN C1 IOSTANDARD LVCMOS33 } [get_ports { SD_CMD }]
set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 } [get_ports { SD_DAT0 }]
set_property -dict { PACKAGE_PIN D2 IOSTANDARD LVCMOS33 } [get_ports { SD_DAT3 }]
set_property -dict { PACKAGE_PIN A1 IOSTANDARD LVCMOS33 } [get_ports { SD_CD }]

## Diagnostico do subsistema microSD.
## LD7: inicializacao concluida.
## LD8: falha de inicializacao, leitura ou comparacao.
## LD9: inicializacao ou leitura em andamento.
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { SD_READY_LED }]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { SD_ERROR_LED }]
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { SD_BUSY_LED }]
## LD10: setor com CRC valido. LD11: 512 bytes identicos a referencia local.
## Pinos livres conferidos no Master XDC; preservam LD0..9.
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { SD_CRC_OK_LED }]
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { SD_DATA_OK_LED }]

## A temporização relativa cartão/FPGA para SPI ainda requer datasheets,
## board delays, análise de skew e margens de setup/hold antes de validação física.

## Conector VGA
set_property -dict { PACKAGE_PIN A3  IOSTANDARD LVCMOS33 } [get_ports { VGA_R[0] }]; #Sch=vga_r[0]
set_property -dict { PACKAGE_PIN B4  IOSTANDARD LVCMOS33 } [get_ports { VGA_R[1] }]; #Sch=vga_r[1]
set_property -dict { PACKAGE_PIN C5  IOSTANDARD LVCMOS33 } [get_ports { VGA_R[2] }]; #Sch=vga_r[2]
set_property -dict { PACKAGE_PIN A4  IOSTANDARD LVCMOS33 } [get_ports { VGA_R[3] }]; #Sch=vga_r[3]

set_property -dict { PACKAGE_PIN C6  IOSTANDARD LVCMOS33 } [get_ports { VGA_G[0] }]; #Sch=vga_g[0]
set_property -dict { PACKAGE_PIN A5  IOSTANDARD LVCMOS33 } [get_ports { VGA_G[1] }]; #Sch=vga_g[1]
set_property -dict { PACKAGE_PIN B6  IOSTANDARD LVCMOS33 } [get_ports { VGA_G[2] }]; #Sch=vga_g[2]
set_property -dict { PACKAGE_PIN A6  IOSTANDARD LVCMOS33 } [get_ports { VGA_G[3] }]; #Sch=vga_g[3]

set_property -dict { PACKAGE_PIN B7  IOSTANDARD LVCMOS33 } [get_ports { VGA_B[0] }]; #Sch=vga_b[0]
set_property -dict { PACKAGE_PIN C7  IOSTANDARD LVCMOS33 } [get_ports { VGA_B[1] }]; #Sch=vga_b[1]
set_property -dict { PACKAGE_PIN D7  IOSTANDARD LVCMOS33 } [get_ports { VGA_B[2] }]; #Sch=vga_b[2]
set_property -dict { PACKAGE_PIN D8  IOSTANDARD LVCMOS33 } [get_ports { VGA_B[3] }]; #Sch=vga_b[3]

set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports { VGA_HS }]; #Sch=vga_hs
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports { VGA_VS }]; #Sch=vga_vs

# VGA analogico sem clock de amostragem encaminhado: limitar o assentamento
# FPGA->pad ao periodo de pixel, sem inventar setup/hold de um monitor.
set_max_delay -datapath_only 40.000 \
    -from [get_cells -hier -filter {IS_SEQUENTIAL == 1 && NAME != u_vga/clk25_reg}] \
    -to [get_ports {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}]
# Estes dados mudam somente em x=0,y=480 (top_reticula/dados_hud).
# Restam (45*800-1) pixels de blanking antes de x=0,y=0: 1.439.960 ns.
# Nao inclui registradores *_pendente*, que podem mudar durante video ativo.
set_max_delay -datapath_only 1439960.000 \
    -from [get_cells -hier -include_replicated_objects -regexp {u_dados/(metadados|heading_deg|mira_x|mira_y|mira_lock|alvo_x|alvo_y|velocidade_kt|altitude_ft|horizonte_y|roll_q8)_reg(\[[0-9]+\])?}] \
    -to [get_ports {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}]

## =========================================================
## GY-521 / MPU-6050 - I2C
## =========================================================

set_property -dict { PACKAGE_PIN G4 IOSTANDARD LVCMOS33 } [get_ports { i2c_sda }]; #JD8 - SDA

set_property -dict { PACKAGE_PIN G3 IOSTANDARD LVCMOS33 } [get_ports { buzzer_out }]; # JD4

# set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { JA[3] }]; #IO_L21P_T3_DQS_15 Sch=ja[3]

# set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { JA[4] }]; #IO_L18N_T2_A23_15 Sch=ja[4]

set_property -dict { PACKAGE_PIN H2 IOSTANDARD LVCMOS33 } [get_ports { i2c_scl }]; #JD7 - SCL

## =========================================================
## BMP085 / SEN-09694 - I2C independente
## =========================================================
## Ligacao fisica:
##   JD1 = H4 = SDA
##   JD2 = H1 = SCL
##
## Nao compartilha o master I2C do MPU-6050.

set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports { baro_sda }]; # JD1 - BMP085 SDA
set_property -dict { PACKAGE_PIN H1 IOSTANDARD LVCMOS33 } [get_ports { baro_scl }]; # JD2 - BMP085 SCL

## LED4: MPU-6050 habilitado e identificado
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { GYRO_LED }]; # LED4 - MPU-6050 OK

## LED5: diagnostico do BMP085
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { BARO_LED }]; # LED5 - BMP085 OK

# set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports { JA[8] }]; #IO_L16P_T2_A28_15 Sch=ja[8]

# set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports { JA[9] }]; #IO_L22N_T3_A16_15 Sch=ja[9]

# set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports { JA[10] }]; #IO_L22P_T3_A17_15 Sch=ja[10]

## Controles: Master XDC oficial Nexys-A7-100T, consultado em 27/09/2026.
# https://github.com/Digilent/digilent-xdc/blob/master/Nexys-A7-100T-Master.xdc

# Entradas manuais assíncronas: exceção somente até o primeiro estágio.

# SW9 desativa a cadeia de atitude MPU (Bank 34 usa LVCMOS18).
set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS18 } [get_ports { sw[9] }]
# SW10 desativa a fonte barométrica.
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { sw[10] }]
# SW11 desativa a fonte magnética.
set_property -dict { PACKAGE_PIN T13 IOSTANDARD LVCMOS33 } [get_ports { sw[11] }]
set_false_path -from [get_ports {sw[9] sw[10] sw[11]}] \
    -to [get_pins -hier -filter {NAME =~ fonte_desabilitada_meta_reg*/D}]

# SW12/SW13: Master XDC Nexys-A7-100T, H6/U12, ambos LVCMOS33.
set_property -dict { PACKAGE_PIN H6 IOSTANDARD LVCMOS33 } [get_ports { sw[12] }]
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { sw[13] }]
set_false_path -from [get_ports {sw[12] sw[13]}] -to [get_pins -hier -filter {NAME =~ horizonte_meta_reg*/D}]
# SW14/SW15: controle simulado de roll.
# SW14/SW15: controle simulado de roll
set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]

set_false_path -from [get_ports {sw[14] sw[15]}] \
    -to [get_pins -hier -filter {NAME =~ roll_meta_reg*/D}]


# BTNU / BTND: comandos roteados pelo dispatcher (heading ou ALIGN)
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { btn_heading[0] }]
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { btn_heading[1] }]

# Entradas assincronas ate o primeiro estagio de sincronizacao.
set_false_path -from [get_ports {btn_heading[*]}] \
    -to [get_pins -hier -filter {NAME =~ *u_hud_commands/buttons_meta_reg*/D}]

# SW0 seleciona NORMAL (0) / DECLUTTER (1).
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { display_mode }]
set_false_path -from [get_ports display_mode] -to [get_pins -hier -filter {NAME =~ u_modo/modo_meta_reg/D}]

# SW1 seleciona o estilo visual.
# Nexys-A7-100T Master XDC:
# SW[1] = PACKAGE_PIN L16.
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 }     [get_ports { style_mode }]

set_false_path -from [get_ports style_mode]     -to [get_pins -hier -filter         {NAME =~ u_estilo/modo_meta_reg/D}]


## =========================================================
## SEN-09694/barometro
## =========================================================

# set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { Bin }]; #IO_L21N_T3_DQS_35 Sch=jd[1]
# set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { Bout }]; #IO_L17P_T2_35 Sch=jd[2]
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { JD[3] }]; #IO_L17N_T2_35 Sch=jd[3]
#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { JD[4] }]; #IO_L20N_T3_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { JD[7] }]; #IO_L15P_T2_DQS_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { JD[8] }]; #IO_L20P_T3_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { JD[9] }]; #IO_L15N_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { JD[10] }]; #IO_L13N_T2_MRCC_35 Sch=jd[10]



## =========================================================
## KY-023 - Joystick analogico via JXADC
## =========================================================

# JXADC1 / JXADC7 = VAUX3
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [get_ports { vauxp3 }]
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports { vauxn3 }]

# JXADC2 / JXADC8 = VAUX10
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports { vauxp10 }]
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports { vauxn10 }]

# LEDs temporarios para validacao dos quatro sentidos.
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { JOY_LED[0] }]
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { JOY_LED[1] }]
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { JOY_LED[2] }]
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { JOY_LED[3] }]

## =========================================================
## KY-023 - Botao LOCK/UNLOCK da mira
## =========================================================
## JA1 = C17
## SW do KY-023 e ativo em nivel baixo: contato entre JA1/SW e GND.
## PULLUP interno mantem nivel alto solto; usar somente logica de 3,3 V.
## Para um KY-023 alimentado, VCC deve ser 3,3 V e GND comum com a FPGA.

set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 PULLUP TRUE } \
    [get_ports { joystick_sw_n }]

set_false_path -from [get_ports { joystick_sw_n }] \
    -to [get_pins -hier -filter {NAME =~ u_mira/button_sync_reg*/D || NAME =~ u_marcador_joystick/button_sync_reg*/D}]


## =========================================================
## Magnetometro HMC5883L
## Barramento I2C independente
##
## JD3 = G1 = SDA
## JD9 = G2 = SCL
## =========================================================

set_property -dict { PACKAGE_PIN G1 IOSTANDARD LVCMOS33 PULLUP TRUE } \
    [get_ports { mag_sda }]

set_property -dict { PACKAGE_PIN G2 IOSTANDARD LVCMOS33 PULLUP TRUE } \
    [get_ports { mag_scl }]

# Open-drain com retorno assincrono; apenas D do primeiro estagio.
# Os segundos estagios ASYNC_REG e o protocolo I2C continuam temporizados.
set_false_path -from [get_ports i2c_sda] -to [get_pins {u_sensor/sda_sync_reg[0]/D}]
set_false_path -from [get_ports i2c_scl] -to [get_pins {u_sensor/scl_sync_reg[0]/D}]
set_false_path -from [get_ports baro_sda] -to [get_pins {u_baro/sda_sync_reg[0]/D}]
set_false_path -from [get_ports baro_scl] -to [get_pins {u_baro/scl_sync_reg[0]/D}]
set_false_path -from [get_ports mag_sda] -to [get_pins {u_magnetometro/sda_sync_reg[0]/D}]
set_false_path -from [get_ports mag_scl] -to [get_pins {u_magnetometro/scl_sync_reg[0]/D}]

## LED6 = magnetometro identificado/configurado
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } \
    [get_ports { MAG_LED }]

## Modos operacionais e ACK: Master XDC Nexys-A7-100T.
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { operacao_sw[0] }]
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { operacao_sw[1] }]
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { ack_btn }]
set_false_path -from [get_ports {operacao_sw[*]}] -to [get_pins -hier -filter {NAME =~ *u_operacao/u_modo/meta_reg*/D}]
set_false_path -from [get_ports ack_btn] -to [get_pins -hier -filter {NAME =~ *u_operacao/u_buzzer/ack_meta_reg/D}]

# Bundled-data: captura apenas depois de pedido_meta/pedido_sync.
# O barramento fica retido ate o ACK retornar (ver docs/finalizacao_sd.md).
set_max_delay -datapath_only 20.000 -from [get_cells -hier -filter {NAME =~ u_entrada/retido_reg*}] -to [get_cells -hier -filter {NAME =~ u_entrada/dados_destino_reg*}]
set_bus_skew 10.000 -from [get_cells -hier -filter {NAME =~ u_entrada/retido_reg*}] -to [get_cells -hier -filter {NAME =~ u_entrada/dados_destino_reg*}]
# Apenas a entrada dos dois sincronizadores, nunca os estagios seguintes.
set_false_path -from [get_cells -hier -filter {NAME == u_entrada/pedido_reg}] -to [get_pins -hier -filter {NAME == u_entrada/pedido_meta_reg/D}]
set_false_path -from [get_cells -hier -filter {NAME == u_entrada/confirmado_reg}] -to [get_pins -hier -filter {NAME == u_entrada/confirmado_meta_reg/D}]

# SW8 solicita um bloco de diagnostico (somente leitura).
set_property -dict { PACKAGE_PIN T8 IOSTANDARD LVCMOS18 } [get_ports SD_READ_SWITCH]
set_false_path -from [get_ports SD_READ_SWITCH] -to [get_pins -hier -filter {NAME =~ *u_diagnostico/read_meta_reg/D || NAME =~ *u_sd_display/diagnostic_meta_reg/D}]

# SW4 dedicado a ALIGN; SW5..7 selecionam a pagina de diagnostico.
# Pinagem do Master XDC Nexys A7-100T; nao muda pinos existentes.
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { SD_DIAG_PAGE[0] }]
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { SD_DIAG_PAGE[1] }]
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { SD_DIAG_PAGE[2] }]
set_property -dict { PACKAGE_PIN R13 IOSTANDARD LVCMOS33 } [get_ports { SD_DIAG_PAGE[3] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[0] }]
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[1] }]
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[2] }]
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[3] }]
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[4] }]
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[5] }]
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { SD_SEG[6] }]
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[0] }]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[1] }]
set_property -dict { PACKAGE_PIN T9 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[2] }]
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[3] }]
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[4] }]
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[5] }]
set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[6] }]
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { SD_AN[7] }]
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports SD_DP]
# Apenas SW4, entrada assincrona do sincronizador de ALIGN.
set_false_path -from [get_ports {SD_DIAG_PAGE[0]}] -to [get_pins -hier -filter {NAME =~ *u_hud_commands/align_meta_reg/D}]
# SW5..7 continuam entrando no sincronizador de diagnostico e captura.
set_false_path -from [get_ports {SD_DIAG_PAGE[1] SD_DIAG_PAGE[2] SD_DIAG_PAGE[3]}] -to [get_pins -hier -filter {NAME =~ *u_capture_control/page_meta_reg*/D}]
set_false_path -from [get_ports {SD_DIAG_PAGE[1] SD_DIAG_PAGE[2] SD_DIAG_PAGE[3]}] -to [get_pins -hier -filter {NAME =~ *u_sd_display/page_meta_reg*/D}]

# BTNL livre: seleciona video/HUD original, sincronizado antes do debounce.
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports VIDEO_TOGGLE_BUTTON]

# P3A: CPU_RESETN independente do reset funcional do HUD.
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {cpu_resetn}]

# LD12..LD15 livres no XDC do HUD (Master XDC Nexys A7-100T Digilent).
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {DDR2_STATUS_LED[0]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {DDR2_STATUS_LED[1]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {DDR2_STATUS_LED[2]}]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {DDR2_STATUS_LED[3]}]

# BTNR conforme Digilent Nexys A7-100T Master XDC; debounce no pixel domain.
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports ALIGN_RIGHT_BUTTON]
set_false_path -from [get_ports ALIGN_RIGHT_BUTTON] -to [get_pins -hier -filter {NAME == u_hud_horizontal_adjust/down_meta_reg/D}]
set_false_path -from [get_ports VIDEO_TOGGLE_BUTTON] -to [get_pins -hier -filter {NAME == u_hud_horizontal_adjust/up_meta_reg/D}]
set_false_path -from [get_ports {SD_DIAG_PAGE[0]}] -to [get_pins -hier -filter {NAME == u_capture_control/inhibit_meta_reg/D}]
