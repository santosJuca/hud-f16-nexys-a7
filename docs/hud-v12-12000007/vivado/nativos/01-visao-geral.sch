# File saved with Nlview 7.8.0 2024-04-26 e1825d835c VDI=44 GEI=38 GUI=JA:24.0 TLS
# 
# non-default properties - (restore without -noprops)
property -colorscheme classic
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #575d6c
property boxcolor1 #575d6c
property boxcolor2 #000000
property boxinstcolor #1c1f28
property boxpincolor #1c1f28
property buscolor #009633
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #e5c7ff
property fillcolor2 #cde5ff
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 12
property maxzoom 5
property netcolor #8bc34a
property objecthighlight0 #fe00f6
property objecthighlight1 #ffea00
property objecthighlight2 #84e413
property objecthighlight3 #1661ff
property objecthighlight4 #d9b7ff
property objecthighlight5 #ffa358
property objecthighlight6 #ff2b2b
property objecthighlight7 #00e0ff
property objecthighlight8 #c0ca33
property objecthighlight9 #b16eff
property objecthighlight10 #46a466
property objecthighlight11 #caff78
property objecthighlight12 #ab47bc
property objecthighlight13 #b4602c
property objecthighlight14 #c20f8c
property objecthighlight15 #00ffaa
property objecthighlight16 #ff9fe4
property objecthighlight17 #ff8019
property objecthighlight18 #26b3ff
property objecthighlight19 #e5551c
property overlaycolor #8bc34a
property pbuscolor #000000
property pbusnamecolor #1c1f28
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #1c1f28
property ripindexfontsize 4
property rippercolor #000000
property rubberbandcolor #1c1f28
property rubberbandfontsize 13
property selectattr 0
property selectionappearance 2
property selectioncolor #396cef
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 1
property timelimit 1
#
module new top_reticula work:top_reticula:NOFILE -nosplit
load symbol mpu6050_i2c work:mpu6050_i2c:NOFILE HIERBOX pin GYRO_LED_OBUF output.right pin amostra_nova output.right pin clk_hud input.left pin enabled0 output.right pin i2c_scl_TRI output.right pin i2c_sda_TRI output.right pin operation_reg[2]_0 output.right pin sensor_fault_cycles0 output.right pin sensor_ok_reg_0 output.right pin sensor_ok_reg_1 output.right pin sensor_ok_reg_2 output.right pin stale_reg_0_sp_1 input.left pin updated1 input.left pin zero_request0 input.left pinBus B output.right [15:0] pinBus D output.right [0:0] pinBus DI output.right [0:0] pinBus S output.right [0:0] pinBus SR input.left [0:0] pinBus accel_x_reg[15]_0 output.right [95:0] pinBus age_reg input.left [0:0] pinBus age_reg[0] output.right [0:0] pinBus age_reg[0]_0 output.right [0:0] pinBus inicio_operacao_reg[3] output.right [0:0] pinBus out input.left [0:0] pinBus samples_reg[2][7]_0 output.right [15:0] pinBus samples_reg[4][7]_0 output.right [15:0] pinBus scl_sync_reg[0]_0 input.left [0:0] pinBus sda_sync_reg[0]_0 input.left [0:0] pinBus sensor_i_3 input.left [1:0] pinBus sensor_i_3_0 input.left [1:0] pinBus stale_reg input.left [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol atitude_vetorial work:atitude_vetorial:NOFILE HIERBOX pin FSM_sequential_phase_reg[3]_0 output.right pin GYRO_LED_OBUF input.left pin MAG_LED_OBUF input.left pin active_reg output.right pin active_reg_0 output.right pin amostra_nova input.left pin blocked_seen_reg[12]_0 input.left pin clk_hud input.left pin done input.left pin done1 input.left pin enabled0 input.left pin estado_reg[3] input.left pin g_idade[0].recentes_reg[0] output.right pin i_reg[0] input.left pin inicio_operacao_reg[3]_0 output.right pin inicio_operacao_reg[3]_2 output.right pin inicio_operacao_reg[3]_3 output.right pin mag_cal_active input.left pin mag_cal_level output.right pin magnitude_product_reg[15]_0 input.left pin modo_atitude_manual input.left pin p_17_in output.right pin p_1_in_0 input.left pin pc_reg input.left pin pitch_fallback_q10_reg[31] output.right pin pitch_fallback_q10_reg[31]_0 output.right pin pitch_fallback_q10_reg[31]_1 output.right pin pitch_fallback_q10_reg[31]_2 output.right pin pitch_fallback_q10_reg[31]_3 output.right pin pitch_reg[11]_0 output.right pin pitch_reg[22]_0 output.right pin raw_pitch_reg[0]_0 output.right pin raw_roll_reg[0]_0 output.right pin reason[0]_i_7 input.left pin rw_reg_i_23_0 input.left pin rw_reg_i_23_1 input.left pin sensor_fault_cycles0 input.left pin stale_reg[0]_1 input.left pin updated output.right pin updated1 output.right pin usar_mpu output.right pin valid_reg_0 output.right pin video_startup_ready_reg output.right pin video_startup_ready_reg_0 input.left pin y_reg[31] input.left pin zero_pulse9_out input.left pin zero_request0 input.left pin zero_set_reg_0 input.left pinBus B input.left [15:0] pinBus CO input.left [0:0] pinBus D output.right [112:0] pinBus DI input.left [0:0] pinBus E output.right [0:0] pinBus O output.right [0:0] pinBus Q output.right [23:0] pinBus S input.left [0:0] pinBus SR output.right [0:0] pinBus SS output.right [0:0] pinBus a_reg[0][15]_0 input.left [95:0] pinBus age_reg[0]_0 output.right [0:0] pinBus age_reg[3]_0 input.left [0:0] pinBus age_reg[3]_1 input.left [0:0] pinBus angle_out_reg[6] input.left [0:0] pinBus done_i_3_0 input.left [0:0] pinBus done_i_3_1 input.left [0:0] pinBus done_reg input.left [0:0] pinBus gravity_x_reg[23]_0 output.right [23:0] pinBus gravity_y_reg[23]_0 output.right [23:0] pinBus horizonte_sync_reg[0] output.right [26:0] pinBus horizonte_sync_reg[0]_0 output.right [10:0] pinBus inicio_operacao_reg[3] output.right [0:0] pinBus inicio_operacao_reg[3]_1 output.right [0:0] pinBus out input.left [0:0] pinBus p_1_in_1 input.left [15:0] pinBus p_1_in__0_0 input.left [15:0] pinBus pc_reg_0 input.left [0:0] pinBus pitch_fallback_q10_reg[14] input.left [1:0] pinBus pw_reg input.left [26:0] pinBus raw_pitch_reg[12]_0 output.right [1:0] pinBus raw_pitch_reg[12]_1 output.right [1:0] pinBus raw_pitch_reg[14]_0 output.right [3:0] pinBus raw_pitch_reg[16]_0 output.right [3:0] pinBus raw_pitch_reg[22]_0 output.right [3:0] pinBus raw_pitch_reg[24]_0 output.right [0:0] pinBus raw_pitch_reg[24]_1 output.right [3:0] pinBus raw_pitch_reg[25]_0 output.right [2:0] pinBus raw_pitch_reg[25]_1 output.right [0:0] pinBus raw_pitch_reg[6]_0 output.right [3:0] pinBus raw_pitch_reg[6]_1 output.right [3:0] pinBus raw_pitch_reg[8]_0 output.right [3:0] pinBus raw_roll_reg[12]_0 output.right [1:0] pinBus raw_roll_reg[12]_1 output.right [1:0] pinBus raw_roll_reg[14]_0 output.right [3:0] pinBus raw_roll_reg[16]_0 output.right [3:0] pinBus raw_roll_reg[22]_0 output.right [3:0] pinBus raw_roll_reg[24]_0 output.right [0:0] pinBus raw_roll_reg[24]_1 output.right [3:0] pinBus raw_roll_reg[26]_0 output.right [0:0] pinBus raw_roll_reg[26]_1 output.right [2:0] pinBus raw_roll_reg[6]_0 output.right [3:0] pinBus raw_roll_reg[6]_1 output.right [3:0] pinBus raw_roll_reg[8]_0 output.right [3:0] pinBus rc_reg_i_15_0 input.left [0:0] pinBus rc_reg_i_15_1 input.left [0:0] pinBus rc_reg_i_20_0 input.left [0:0] pinBus rc_reg_i_32_0 input.left [0:0] pinBus rc_reg_i_8_0 input.left [0:0] pinBus roll_fallback_q10_reg[9] input.left [1:0] pinBus roll_reg[16]_0 output.right [4:0] pinBus roll_reg[31]_0 output.right [19:0] pinBus roll_reg[31]_1 output.right [0:0] pinBus roll_reg[31]_2 output.right [0:0] pinBus roll_reg[31]_3 output.right [0:0] pinBus roll_reg[31]_4 output.right [0:0] pinBus roll_sync_reg[0] output.right [28:0] pinBus roll_sync_reg[0]_0 output.right [28:0] pinBus rw_reg_i_18_0 input.left [0:0] pinBus rw_reg_i_18_1 input.left [0:0] pinBus rw_reg_i_23_2 input.left [0:0] pinBus rw_reg_i_3_0 input.left [28:0] pinBus rw_reg_i_6_0 input.left [0:0] pinBus rw_reg_i_8_0 input.left [1:0] pinBus stale_reg[0]_0 output.right [0:0] pinBus video_startup_count output.right [0:0] pinBus video_startup_count_reg input.left [29:0] pinBus video_startup_ready_reg_1 input.left [0:0] pinBus y output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE HIERBOX pin MAG_LED_OBUF input.left pin age_reg[0]_0 input.left pin angle_out_reg[0] input.left pin busy_reg output.right pin busy_reg_0 output.right pin bz_reg_0 input.left pin clk_hud input.left pin done1 output.right pin g_idade[2].idade_reg[0] input.left pin g_idade[2].idade_reg[0]_0 input.left pin heading_approved_valid output.right pin heading_planar_updated input.left pin mag_amostra_nova input.left pin p_17_in input.left pin p_2_in input.left pin published_reg_0 input.left pin state_reg[1]_0 output.right pin state_reg[2]_0 output.right pin state_reg[2]_rep__0_0 input.left pin state_reg[3]_0 output.right pin y_reg[0] input.left pinBus D input.left [15:0] pinBus E input.left [0:0] pinBus O output.right [3:0] pinBus Q output.right [0:0] pinBus SR input.left [0:0] pinBus age_reg[12]_0 output.right [3:0] pinBus age_reg[16]_0 output.right [3:0] pinBus age_reg[20]_0 output.right [3:0] pinBus age_reg[24]_0 output.right [3:0] pinBus age_reg[25]_0 output.right [0:0] pinBus age_reg[25]_1 input.left [25:0] pinBus age_reg[8]_0 output.right [3:0] pinBus bx_reg_0 input.left [15:0] pinBus by_reg_0 input.left [15:0] pinBus gx_reg[23]_0 input.left [23:0] pinBus gy_reg[24]_0 input.left [23:0] pinBus gz_reg[24]_0 input.left [23:0] pinBus heading_deg_reg[8]_0 output.right [8:0] pinBus out input.left [0:0] pinBus p_0_out output.right [0:0] pinBus y input.left [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol operacao_hud work:operacao_hud:NOFILE HIERBOX pin FSM_onehot_phase_reg[0] output.right pin FSM_onehot_phase_reg[0]_0 output.right pin FSM_onehot_phase_reg[0]_1 output.right pin FSM_onehot_phase_reg[0]_2 output.right pin FSM_onehot_phase_reg[0]_3 output.right pin FSM_onehot_phase_reg[1] output.right pin FSM_onehot_phase_reg[4] output.right pin ack input.left pin altitude_ft_reg[8] output.right pin clk_hud input.left pin estado_reg[1]_0 output.right pin estado_reg[3]_0 input.left pin estado_reg[4]_0 input.left pin estado_reg[7]_2 input.left pin fase_pouso_reg[2] output.right pin frame_index_reg[5] input.left pin frame_index_reg[5]_0 input.left pin frame_index_reg[7] input.left pin frame_index_reg[8] input.left pin g_idade[0].recentes_reg[0]_0 output.right pin g_idade[0].recentes_reg[0]_1 output.right pin g_idade[2].recentes_reg[2]_0 output.right pin in0 input.left pin invalid_video_mode output.right pin modo_atitude_manual output.right pin modo_invalido_reg output.right pin modo_invalido_reg_0 output.right pin p_1_in input.left pin pc_i_12 input.left pin pc_reg input.left pin pc_reg_0 input.left pin pw_reg input.left pin pw_reg_0 input.left pin pw_reg_1 input.left pin pw_reg_2 input.left pin reset_operacao output.right pin sensor_reg input.left pin updated input.left pin usar_mpu input.left pin valid_a input.left pinBus B input.left [12:0] pinBus CO input.left [0:0] pinBus D output.right [51:0] pinBus DI output.right [0:0] pinBus O input.left [0:0] pinBus Q input.left [3:0] pinBus S output.right [0:0] pinBus SD_DIAG_PAGE_IBUF input.left [3:0] pinBus SR input.left [0:0] pinBus SS input.left [0:0] pinBus ar0 input.left [4:0] pinBus dados_reg[8]_0 input.left [8:0] pinBus estado_reg[0]_0 output.right [0:0] pinBus estado_reg[7]_0 input.left [0:0] pinBus estado_reg[7]_1 input.left [1:0] pinBus g_idade[2].idade_reg[0]_0 input.left [0:0] pinBus g_idade[2].idade_reg[25]_0 input.left [0:0] pinBus meta_reg[3] input.left [20:0] pinBus out input.left [1:0] pinBus p_0_out input.left [0:0] pinBus phase_a_reg[2] input.left [2:0] pinBus pitch_fallback_q10_reg[31]_0 output.right [0:0] pinBus pitch_fallback_q10_reg[31]_1 output.right [26:0] pinBus pitch_fallback_q10_reg[31]_2 input.left [26:0] pinBus rc_reg input.left [0:0] pinBus rc_reg_0 input.left [0:0] pinBus requested_video_mode output.right [1:0] pinBus roll_fallback_q10_reg[31]_0 output.right [28:0] pinBus roll_fallback_q10_reg[31]_1 output.right [0:0] pinBus roll_fallback_q10_reg[31]_2 input.left [28:0] pinBus roll_reg[0] output.right [0:0] pinBus roll_reg[0]_0 output.right [0:0] pinBus roll_reg[0]_1 output.right [0:0] pinBus roll_reg[0]_2 output.right [0:0] pinBus roll_reg[0]_3 output.right [0:0] pinBus roll_reg[13] output.right [1:0] pinBus roll_reg[13]_0 output.right [0:0] pinBus rw_reg input.left [0:0] pinBus scroll_offset_reg[0] input.left [2:0] pinBus switches input.left [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE HIERBOX pin amostra_valida output.right pin clk_hud input.left pin dados_destino_reg[10]_0 output.right pin dados_destino_reg[11]_0 output.right pin dados_destino_reg[12]_0 output.right pin dados_destino_reg[16]_0 output.right pin dados_destino_reg[17]_0 output.right pin dados_destino_reg[18]_0 output.right pin dados_destino_reg[18]_1 output.right pin dados_destino_reg[4]_0 output.right pin dados_destino_reg[4]_1 output.right pin dados_destino_reg[4]_2 output.right pin dados_destino_reg[4]_3 output.right pin dados_destino_reg[4]_4 output.right pin dados_destino_reg[4]_5 output.right pin dados_destino_reg[4]_6 output.right pin dados_destino_reg[4]_7 output.right pin pixel_clk input.left pinBus D output.right [1:0] pinBus Q output.right [71:0] pinBus SR output.right [0:0] pinBus dados_destino_reg[17]_1 output.right [1:0] pinBus dados_destino_reg[80]_0 output.right [0:0] pinBus retido_reg[121]_0 input.left [90:0] pinBus valido_destino_reg_0 output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol dados_hud work:dados_hud:NOFILE HIERBOX pin VGA_R_OBUF[3]_inst_i_1085_0 output.right pin VGA_R_OBUF[3]_inst_i_1109_0 input.left pin VGA_R_OBUF[3]_inst_i_1164_0 output.right pin VGA_R_OBUF[3]_inst_i_1167_0 input.left pin VGA_R_OBUF[3]_inst_i_1167_1 input.left pin VGA_R_OBUF[3]_inst_i_1168_0 input.left pin VGA_R_OBUF[3]_inst_i_1168_1 input.left pin VGA_R_OBUF[3]_inst_i_1202_0 input.left pin VGA_R_OBUF[3]_inst_i_1204_0 input.left pin VGA_R_OBUF[3]_inst_i_1204_1 input.left pin VGA_R_OBUF[3]_inst_i_1204_2 input.left pin VGA_R_OBUF[3]_inst_i_1425_0 output.right pin VGA_R_OBUF[3]_inst_i_1450 input.left pin VGA_R_OBUF[3]_inst_i_1451 output.right pin VGA_R_OBUF[3]_inst_i_1472_0 output.right pin VGA_R_OBUF[3]_inst_i_1489_0 output.right pin VGA_R_OBUF[3]_inst_i_156 input.left pin VGA_R_OBUF[3]_inst_i_1562 output.right pin VGA_R_OBUF[3]_inst_i_1562_0 output.right pin VGA_R_OBUF[3]_inst_i_1574 output.right pin VGA_R_OBUF[3]_inst_i_159 input.left pin VGA_R_OBUF[3]_inst_i_159_0 input.left pin VGA_R_OBUF[3]_inst_i_159_1 input.left pin VGA_R_OBUF[3]_inst_i_1605 input.left pin VGA_R_OBUF[3]_inst_i_1605_0 input.left pin VGA_R_OBUF[3]_inst_i_1608 input.left pin VGA_R_OBUF[3]_inst_i_1608_0 input.left pin VGA_R_OBUF[3]_inst_i_1631 input.left pin VGA_R_OBUF[3]_inst_i_1631_0 input.left pin VGA_R_OBUF[3]_inst_i_1631_1 input.left pin VGA_R_OBUF[3]_inst_i_1664_0 output.right pin VGA_R_OBUF[3]_inst_i_1674 input.left pin VGA_R_OBUF[3]_inst_i_1674_0 input.left pin VGA_R_OBUF[3]_inst_i_180_0 output.right pin VGA_R_OBUF[3]_inst_i_2001_0 output.right pin VGA_R_OBUF[3]_inst_i_2003_0 output.right pin VGA_R_OBUF[3]_inst_i_2005_0 output.right pin VGA_R_OBUF[3]_inst_i_2017 output.right pin VGA_R_OBUF[3]_inst_i_2021_0 output.right pin VGA_R_OBUF[3]_inst_i_2061_0 output.right pin VGA_R_OBUF[3]_inst_i_2092_0 output.right pin VGA_R_OBUF[3]_inst_i_2094_0 output.right pin VGA_R_OBUF[3]_inst_i_209_0 output.right pin VGA_R_OBUF[3]_inst_i_2129 output.right pin VGA_R_OBUF[3]_inst_i_2139_0 input.left pin VGA_R_OBUF[3]_inst_i_2145 input.left pin VGA_R_OBUF[3]_inst_i_2146_0 input.left pin VGA_R_OBUF[3]_inst_i_2269_0 output.right pin VGA_R_OBUF[3]_inst_i_2275 input.left pin VGA_R_OBUF[3]_inst_i_2275_0 input.left pin VGA_R_OBUF[3]_inst_i_2545_0 output.right pin VGA_R_OBUF[3]_inst_i_2547_0 output.right pin VGA_R_OBUF[3]_inst_i_2781 input.left pin VGA_R_OBUF[3]_inst_i_2781_0 input.left pin VGA_R_OBUF[3]_inst_i_2781_1 input.left pin VGA_R_OBUF[3]_inst_i_2782_0 output.right pin VGA_R_OBUF[3]_inst_i_2783_0 output.right pin VGA_R_OBUF[3]_inst_i_2783_1 output.right pin VGA_R_OBUF[3]_inst_i_2783_2 output.right pin VGA_R_OBUF[3]_inst_i_2783_3 input.left pin VGA_R_OBUF[3]_inst_i_2783_4 input.left pin VGA_R_OBUF[3]_inst_i_2783_5 input.left pin VGA_R_OBUF[3]_inst_i_2809 input.left pin VGA_R_OBUF[3]_inst_i_2809_0 input.left pin VGA_R_OBUF[3]_inst_i_30_0 input.left pin VGA_R_OBUF[3]_inst_i_3346 input.left pin VGA_R_OBUF[3]_inst_i_3346_0 input.left pin VGA_R_OBUF[3]_inst_i_3346_1 input.left pin VGA_R_OBUF[3]_inst_i_3349 input.left pin VGA_R_OBUF[3]_inst_i_3349_0 input.left pin VGA_R_OBUF[3]_inst_i_3369 output.right pin VGA_R_OBUF[3]_inst_i_3385_0 output.right pin VGA_R_OBUF[3]_inst_i_3446 input.left pin VGA_R_OBUF[3]_inst_i_3446_0 input.left pin VGA_R_OBUF[3]_inst_i_3446_1 input.left pin VGA_R_OBUF[3]_inst_i_3466 input.left pin VGA_R_OBUF[3]_inst_i_3546 input.left pin VGA_R_OBUF[3]_inst_i_369_0 input.left pin VGA_R_OBUF[3]_inst_i_369_1 input.left pin VGA_R_OBUF[3]_inst_i_393_0 input.left pin VGA_R_OBUF[3]_inst_i_394_0 input.left pin VGA_R_OBUF[3]_inst_i_3957 input.left pin VGA_R_OBUF[3]_inst_i_3957_0 input.left pin VGA_R_OBUF[3]_inst_i_395_1 input.left pin VGA_R_OBUF[3]_inst_i_3964 input.left pin VGA_R_OBUF[3]_inst_i_4007 input.left pin VGA_R_OBUF[3]_inst_i_4008 input.left pin VGA_R_OBUF[3]_inst_i_408_0 input.left pin VGA_R_OBUF[3]_inst_i_408_1 input.left pin VGA_R_OBUF[3]_inst_i_4356 input.left pin VGA_R_OBUF[3]_inst_i_516_0 input.left pin VGA_R_OBUF[3]_inst_i_820_0 input.left pin VGA_R_OBUF[3]_inst_i_820_1 input.left pin VGA_R_OBUF[3]_inst_i_820_2 input.left pin VGA_R_OBUF[3]_inst_i_832_0 input.left pin VGA_R_OBUF[3]_inst_i_839_1 input.left pin altitude_ft_reg[16]_1 output.right pin altitude_ft_reg[16]_2 output.right pin altitude_ft_reg[16]_3 output.right pin altitude_ft_reg[16]_4 output.right pin altitude_ft_reg[16]_5 output.right pin altitude_ft_reg[3]_0 output.right pin altitude_ft_reg[3]_1 output.right pin altitude_ft_reg[3]_10 output.right pin altitude_ft_reg[3]_11 output.right pin altitude_ft_reg[3]_2 output.right pin altitude_ft_reg[3]_3 output.right pin altitude_ft_reg[3]_4 output.right pin altitude_ft_reg[3]_5 output.right pin altitude_ft_reg[3]_6 output.right pin altitude_ft_reg[3]_7 output.right pin altitude_ft_reg[3]_8 output.right pin altitude_ft_reg[3]_9 output.right pin altitude_ft_reg[4]_0 output.right pin altitude_ft_reg[5]_0 output.right pin altitude_ft_reg[6]_0 output.right pin altitude_ft_reg[7]_0 output.right pin alvo output.right pin alvo_x_pendente_reg[0]_0 input.left pin alvo_x_pendente_reg[1]_0 input.left pin alvo_x_pendente_reg[2]_0 input.left pin alvo_x_pendente_reg[5]_0 input.left pin alvo_x_pendente_reg[6]_0 input.left pin alvo_x_pendente_reg[7]_0 input.left pin alvo_x_pendente_reg[8]_0 input.left pin alvo_x_pendente_reg[9]_0 input.left pin alvo_x_reg[6]_0 output.right pin alvo_x_reg[7]_0 output.right pin alvo_y_pendente_reg[0]_0 input.left pin alvo_y_pendente_reg[1]_0 input.left pin alvo_y_pendente_reg[2]_0 input.left pin alvo_y_pendente_reg[5]_0 input.left pin alvo_y_pendente_reg[6]_0 input.left pin alvo_y_pendente_reg[7]_0 input.left pin alvo_y_pendente_reg[8]_0 input.left pin alvo_y_reg[6]_0 output.right pin alvo_y_reg[7]_0 output.right pin alvo_y_reg[7]_1 output.right pin alvo_y_reg[7]_2 output.right pin alvo_y_reg[8]_1 output.right pin amostra_valida input.left pin g_native_video.frame_boundary input.left pin h_cont_reg[1]_rep__0 output.right pin h_cont_reg[1]_rep__0_0 output.right pin h_cont_reg[1]_rep__1 output.right pin h_cont_reg[6] output.right pin h_cont_reg[7] output.right pin h_cont_reg[9]_3 output.right pin h_cont_reg[9]_4 output.right pin heading_deg_reg[0]_15 output.right pin heading_deg_reg[3]_0 output.right pin heading_deg_reg[3]_1 output.right pin heading_deg_reg[3]_2 output.right pin heading_deg_reg[3]_3 output.right pin heading_deg_reg[3]_4 output.right pin heading_deg_reg[7]_2 output.right pin heading_deg_reg[7]_3 output.right pin heading_deg_reg[7]_5 output.right pin heading_deg_reg[7]_6 output.right pin heading_deg_reg[8]_rep_0 output.right pin heading_deg_reg[8]_rep_1 output.right pin heading_deg_reg[8]_rep_2 output.right pin heading_deg_reg[8]_rep_3 output.right pin heading_deg_reg[8]_rep_4 output.right pin heading_deg_reg[8]_rep_6 output.right pin heading_deg_reg[8]_rep_7 output.right pin heading_deg_reg[8]_rep_8 output.right pin hud_video_on input.left pin metadados_reg[0]_0 output.right pin metadados_reg[10]_0 output.right pin metadados_reg[10]_1 output.right pin metadados_reg[11]_0 output.right pin metadados_reg[12]_0 output.right pin metadados_reg[12]_1 output.right pin metadados_reg[12]_2 output.right pin metadados_reg[12]_3 output.right pin metadados_reg[12]_4 output.right pin metadados_reg[12]_5 output.right pin metadados_reg[12]_6 output.right pin metadados_reg[25]_0 output.right pin metadados_reg[25]_1 output.right pin metadados_reg[25]_2 output.right pin metadados_reg[25]_3 output.right pin metadados_reg[25]_4 output.right pin metadados_reg[9]_0 output.right pin metadados_reg[9]_1 output.right pin mira_lock output.right pin on2264_in output.right pin pixel_clk input.left pin texto90 output.right pin texto9131_in output.right pin v_cont_reg[0] output.right pin v_cont_reg[5] output.right pin v_cont_reg[5]_rep__0 output.right pin v_cont_reg[6]_rep__0 output.right pin v_cont_reg[7]_rep output.right pin v_cont_reg[7]_rep_0 output.right pin v_cont_reg[7]_rep_1 output.right pin v_cont_reg[8] output.right pin v_cont_reg[8]_0 output.right pin v_cont_reg[8]_1 output.right pin v_cont_reg[8]_2 output.right pin velocidade_kt_reg[0]_0 output.right pin velocidade_kt_reg[0]_1 output.right pin velocidade_kt_reg[0]_2 output.right pin velocidade_kt_reg[0]_3 output.right pin velocidade_kt_reg[0]_4 output.right pin velocidade_kt_reg[1]_1 output.right pin velocidade_kt_reg[1]_2 output.right pin velocidade_kt_reg[1]_3 output.right pin velocidade_kt_reg[2]_0 output.right pin velocidade_kt_reg[3]_0 output.right pin velocidade_kt_reg[9]_0 output.right pin velocidade_kt_reg[9]_1 output.right pin velocidade_kt_reg[9]_10 output.right pin velocidade_kt_reg[9]_11 output.right pin velocidade_kt_reg[9]_12 output.right pin velocidade_kt_reg[9]_2 output.right pin velocidade_kt_reg[9]_3 output.right pin velocidade_kt_reg[9]_4 output.right pin velocidade_kt_reg[9]_5 output.right pin velocidade_kt_reg[9]_6 output.right pin velocidade_kt_reg[9]_7 output.right pin velocidade_kt_reg[9]_8 output.right pin velocidade_kt_reg[9]_9 output.right pinBus A output.right [11:0] pinBus CO input.left [0:0] pinBus D input.left [1:0] pinBus DI input.left [1:0] pinBus O output.right [2:0] pinBus Q input.left [71:0] pinBus S output.right [2:0] pinBus SR input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_100 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_101 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_102 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_98 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1072 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_1072_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1093 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1105 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1109 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1118 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1122 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_2 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1174_3 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1182_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_1182_1 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_139_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_140_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_145_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_146_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_148_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_150_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1561 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1567_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1578 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1670_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1670_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1679_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2150 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2218_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2228_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2238_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2248_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_1 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_2 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_3 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_4 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_5 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_2869_6 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_7 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_2961_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_30 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_31 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_32 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_32_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_33 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_3420_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3420_1 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_3431_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3431_1 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_3436_0 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_3436_1 output.right [3:0] pinBus VGA_R_OBUF[3]_inst_i_3436_2 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_3436_3 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3440_0 output.right [3:0] pinBus VGA_R_OBUF[3]_inst_i_3466_0 input.left [7:0] pinBus VGA_R_OBUF[3]_inst_i_3480_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3507_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3533_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_353_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_353_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3560_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3611_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_393 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_394 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_394_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_395_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_3980_0 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_4003_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_4029_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4060_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4091_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4122_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4155_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4166_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4175_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4633_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4648_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4664_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4691_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_55 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_60_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_674_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_674_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_680_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_705_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_722_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_73_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_76 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_766 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_767_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_77 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_771_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_776_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_786 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_822_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_822_1 input.left [4:0] pinBus VGA_R_OBUF[3]_inst_i_839_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_840_0 input.left [2:0] pinBus altitude_ft_reg[16]_0 output.right [16:0] pinBus altitude_ft_reg[4]_1 output.right [0:0] pinBus altitude_ft_reg[6]_1 output.right [2:0] pinBus altitude_pendente_reg[16]_0 input.left [0:0] pinBus alvo_x_reg[3]_0 output.right [3:0] pinBus alvo_y_pendente_reg[4]_0 input.left [1:0] pinBus alvo_y_reg[8]_0 output.right [4:0] pinBus h_cont_reg[5]_rep output.right [2:0] pinBus h_cont_reg[5]_rep_0 output.right [2:0] pinBus h_cont_reg[5]_rep_1 output.right [2:0] pinBus h_cont_reg[9] output.right [3:0] pinBus h_cont_reg[9]_0 output.right [3:0] pinBus h_cont_reg[9]_1 output.right [3:0] pinBus h_cont_reg[9]_2 output.right [3:0] pinBus heading_deg_reg[0]_0 output.right [6:0] pinBus heading_deg_reg[0]_1 output.right [2:0] pinBus heading_deg_reg[0]_10 output.right [3:0] pinBus heading_deg_reg[0]_11 output.right [2:0] pinBus heading_deg_reg[0]_12 output.right [3:0] pinBus heading_deg_reg[0]_13 output.right [2:0] pinBus heading_deg_reg[0]_14 output.right [3:0] pinBus heading_deg_reg[0]_2 output.right [2:0] pinBus heading_deg_reg[0]_3 output.right [3:0] pinBus heading_deg_reg[0]_4 output.right [3:0] pinBus heading_deg_reg[0]_5 output.right [0:0] pinBus heading_deg_reg[0]_6 output.right [3:0] pinBus heading_deg_reg[0]_7 output.right [2:0] pinBus heading_deg_reg[0]_8 output.right [3:0] pinBus heading_deg_reg[0]_9 output.right [2:0] pinBus heading_deg_reg[7]_0 output.right [3:0] pinBus heading_deg_reg[7]_1 output.right [1:0] pinBus heading_deg_reg[7]_4 output.right [0:0] pinBus heading_deg_reg[7]_rep_0 output.right [0:0] pinBus heading_deg_reg[7]_rep_1 output.right [0:0] pinBus heading_deg_reg[8]_0 output.right [0:0] pinBus heading_deg_reg[8]_1 output.right [0:0] pinBus heading_deg_reg[8]_rep_5 output.right [0:0] pinBus heading_pendente_reg[8]_0 input.left [0:0] pinBus hud_pixel_x input.left [7:0] pinBus hud_pixel_y input.left [9:0] pinBus metadados_reg[15]_0 output.right [11:0] pinBus mira_x_reg[9]_0 output.right [9:0] pinBus mira_y_reg[8]_0 output.right [8:0] pinBus velocidade_kt_reg[1]_0 output.right [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol simbologia_vga work:simbologia_vga:NOFILE HIERBOX pin alvo input.left pin declutter_reg output.right pin g_native_video.frame_boundary input.left pin horizonte output.right pin hud_video_on input.left pin out input.left pin pixel_clk input.left pin retic_caca_clearance input.left pin valido_destino__0 input.left pinBus B input.left [10:0] pinBus Q input.left [26:0] pinBus sine input.left [15:0] pinBus u input.left [10:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol ddr2_ui_smoke_top work:ddr2_ui_smoke_top:NOFILE HIERBOX pin FSM_onehot_state_reg[1] output.right pin FSM_onehot_state_reg[1]_1 input.left pin FSM_onehot_state_reg[1]_2 input.left pin FSM_onehot_state_reg[1]_3 input.left pin app_en input.left pin app_rd_data_valid output.right pin app_rdy output.right pin clk input.left pin clk_ref_i input.left pin ddr2_cas_n output.right pin ddr2_ras_n output.right pin ddr2_we_n output.right pin in0 output.right pin init_calib_complete output.right pin last_word_reg[15] input.left pin rd_en output.right pin sys_rst input.left pin temperature_xadc_toggle input.left pin ui_clk output.right pinBus CO input.left [0:0] pinBus D input.left [11:0] pinBus FSM_onehot_state_reg[1]_0 output.right [0:0] pinBus S output.right [3:0] pinBus SR output.right [0:0] pinBus app_addr input.left [15:0] pinBus app_cmd input.left [0:0] pinBus ddr2_addr output.right [12:0] pinBus ddr2_ba output.right [2:0] pinBus ddr2_ck_n output.right [0:0] pinBus ddr2_ck_p output.right [0:0] pinBus ddr2_cke output.right [0:0] pinBus ddr2_cs_n output.right [0:0] pinBus ddr2_dm output.right [1:0] pinBus ddr2_dq inout.left [15:0] pinBus ddr2_dqs_n inout.left [1:0] pinBus ddr2_dqs_p inout.left [1:0] pinBus ddr2_odt output.right [0:0] pinBus din output.right [128:0] pinBus dout input.left [128:0] pinBus gen_rd_b.gen_doutb_pipe.gen_stage.doutb_pipe_reg[0][144] output.right [0:0] pinBus last_data_reg[105] output.right [3:0] pinBus last_data_reg[117] output.right [3:0] pinBus last_data_reg[125] output.right [1:0] pinBus last_data_reg[21] output.right [3:0] pinBus last_data_reg[34] output.right [3:0] pinBus last_data_reg[45] output.right [3:0] pinBus last_data_reg[57] output.right [3:0] pinBus last_data_reg[69] output.right [3:0] pinBus last_data_reg[81] output.right [3:0] pinBus last_data_reg[95] output.right [3:0] pinBus out input.left [0:0] pinBus wr_data2_carry__9 input.left [125:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hud_sd_ddr2_video work:hud_sd_ddr2_video:NOFILE HIERBOX pin CLK input.left pin DDR2_STATUS_LED[3] input.left pin FSM_onehot_state_reg[0] output.right pin FSM_onehot_state_reg[0]_0 output.right pin FSM_onehot_state_reg[1] output.right pin FSM_onehot_state_reg[1]_0 input.left pin SD_BUSY_LED input.left pin SD_BUSY_LED_OBUF output.right pin SD_DAT0_IBUF input.left pin SD_DAT1_IBUF input.left pin SD_DAT2_IBUF input.left pin SD_DAT3_IBUF input.left pin SD_READY_LED_OBUF output.right pin SD_SCK_OBUF output.right pin VGA_G_OBUF[1]_inst_i_2 input.left pin app_en output.right pin app_rd_data_valid input.left pin app_rdy input.left pin bad_request0 input.left pin blank_toggle_reg input.left pin calibrated_reg_0 output.right pin capture_hud_opaque input.left pin clk_hud input.left pin current_rgb332 output.right pin current_rgb332_reg output.right pin current_rgb332_reg_0 output.right pin current_rgb332_reg_1 output.right pin diag_reason_reg[4] output.right pin diag_reason_reg[5] output.right pin diag_reason_reg[6]_0 output.right pin fetching output.right pin frame_latch input.left pin frame_lba0__0 input.left pin g_native_video.card_reset_reg output.right pin g_native_video.displayed_valid output.right pin g_native_video.frame_error output.right pin g_native_video.frame_shown output.right pin g_native_video.power_stable input.left pin g_native_video.raw_cmd output.right pin g_native_video.request_ready output.right pin g_native_video.video_visible input.left pin init_calib_complete input.left pin line_valid output.right pin line_valid_i_4 input.left pin line_valid_i_4_0 input.left pin mag_sd_profile_valid output.right pin missing_lines_reg[0]_i_3 input.left pin missing_lines_reg[12] output.right pin missing_lines_reg[31] input.left pin native_loading input.left pin new_line input.left pin page_sync_reg[0] output.right pin page_sync_reg[0]_0 output.right pin page_sync_reg[0]_1 output.right pin page_sync_reg[0]_2 output.right pin page_sync_reg[0]_3 output.right pin page_sync_reg[0]_4 output.right pin page_sync_reg[0]_5 output.right pin page_sync_reg[0]_6 output.right pin page_sync_reg[0]_7 output.right pin page_sync_reg[0]_8 output.right pin page_sync_reg[0]_9 output.right pin pending_rgb332_reg_0 input.left pin pixel_clk_BUFG input.left pin pixel_word1__3 input.left pin pixel_word_reg[0] input.left pin prefetch_line input.left pin prefetch_line27_in input.left pin rd_en input.left pin rst0 input.left pin sd_init_ready output.right pin tx_reg[16] input.left pin tx_reg[21] input.left pin video_failed input.left pin video_on input.left pin wrote_word_reg output.right pinBus ADDRA input.left [4:0] pinBus AS input.left [0:0] pinBus CO output.right [0:0] pinBus D input.left [12:0] pinBus DDR2_STATUS_LED_OBUF output.right [0:0] pinBus E input.left [0:0] pinBus Q input.left [0:0] pinBus S input.left [3:0] pinBus SD_SEG_OBUF[6]_inst_i_114 input.left [1:0] pinBus SR input.left [0:0] pinBus SS input.left [0:0] pinBus VGA_B_OBUF output.right [1:0] pinBus VGA_R_OBUF output.right [2:0] pinBus app_addr output.right [15:0] pinBus app_cmd output.right [0:0] pinBus capture_hud_rgb input.left [3:0] pinBus diag_reason_reg[6] output.right [0:0] pinBus diag_status_reg[31] output.right [17:0] pinBus din input.left [128:0] pinBus dout output.right [128:0] pinBus even_tag_reg[7] output.right [0:0] pinBus even_tag_reg[7]_0 output.right [0:0] pinBus even_tag_reg[9] output.right [6:0] pinBus fetch_line_reg[9] input.left [0:0] pinBus fetch_line_reg[9]_0 input.left [9:0] pinBus future_x input.left [0:0] pinBus g_native_video.pixel_reset_pipe_reg[1] output.right [0:0] pinBus gen_rd_b.gen_rd_b_synth_template.gen_rf_narrow_pipe.doutb_reg_reg[0] input.left [0:0] pinBus last_data_reg[125] output.right [125:0] pinBus last_sector_reg[7] input.left [1:0] pinBus last_word_reg[15] input.left [0:0] pinBus line_valid_reg input.left [0:0] pinBus odd_tag_reg[9] output.right [6:0] pinBus odd_tag_reg[9]_0 input.left [0:0] pinBus out input.left [0:0] pinBus p_0_in__1 input.left [3:0] pinBus pending_index_reg[12] input.left [12:0] pinBus pending_rgb332_reg input.left [0:0] pinBus pixel_word_reg[127] input.left [0:0] pinBus profile output.right [59:0] pinBus rd_word0 input.left [0:0] pinBus rx_reg[0] input.left [0:0] pinBus u_xpm_i_2__2 input.left [1:0] pinBus wr_data2_carry__1 input.left [3:0] pinBus wr_data2_carry__2 input.left [3:0] pinBus wr_data2_carry__3 input.left [3:0] pinBus wr_data2_carry__4 input.left [3:0] pinBus wr_data2_carry__5 input.left [3:0] pinBus wr_data2_carry__6 input.left [3:0] pinBus wr_data2_carry__7 input.left [3:0] pinBus wr_data2_carry__8 input.left [3:0] pinBus wr_data2_carry__9 input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol vga_controller work:vga_controller:NOFILE HIERBOX pin VGA_B_OBUF[3]_inst_i_47_0 input.left pin VGA_G[0] input.left pin VGA_G[1] input.left pin VGA_G[2] input.left pin VGA_G_OBUF[0]_inst_i_2_0 input.left pin VGA_G_OBUF[3]_inst_i_15_0 input.left pin VGA_G_OBUF[3]_inst_i_20_0 input.left pin VGA_G_OBUF[3]_inst_i_20_1 input.left pin VGA_G_OBUF[3]_inst_i_20_2 input.left pin VGA_G_OBUF[3]_inst_i_20_3 input.left pin VGA_G_OBUF[3]_inst_i_44_0 input.left pin VGA_G_OBUF[3]_inst_i_44_1 input.left pin VGA_G_OBUF[3]_inst_i_44_2 input.left pin VGA_G_OBUF[3]_inst_i_44_3 input.left pin VGA_G_OBUF[3]_inst_i_44_4 input.left pin VGA_G_OBUF[3]_inst_i_44_5 input.left pin VGA_G_OBUF[3]_inst_i_6_0 input.left pin VGA_HS_OBUF output.right pin VGA_R_OBUF[3]_inst_i_1054_0 input.left pin VGA_R_OBUF[3]_inst_i_1054_1 input.left pin VGA_R_OBUF[3]_inst_i_1072_0 input.left pin VGA_R_OBUF[3]_inst_i_1072_1 input.left pin VGA_R_OBUF[3]_inst_i_1072_2 input.left pin VGA_R_OBUF[3]_inst_i_1072_3 input.left pin VGA_R_OBUF[3]_inst_i_1072_4 input.left pin VGA_R_OBUF[3]_inst_i_1072_5 input.left pin VGA_R_OBUF[3]_inst_i_1088_0 input.left pin VGA_R_OBUF[3]_inst_i_1088_1 input.left pin VGA_R_OBUF[3]_inst_i_1088_2 input.left pin VGA_R_OBUF[3]_inst_i_1118_0 input.left pin VGA_R_OBUF[3]_inst_i_1118_1 input.left pin VGA_R_OBUF[3]_inst_i_1118_2 input.left pin VGA_R_OBUF[3]_inst_i_1118_3 input.left pin VGA_R_OBUF[3]_inst_i_1118_4 input.left pin VGA_R_OBUF[3]_inst_i_1118_5 input.left pin VGA_R_OBUF[3]_inst_i_1122_0 input.left pin VGA_R_OBUF[3]_inst_i_1122_1 input.left pin VGA_R_OBUF[3]_inst_i_1140_0 input.left pin VGA_R_OBUF[3]_inst_i_1140_1 input.left pin VGA_R_OBUF[3]_inst_i_1140_2 input.left pin VGA_R_OBUF[3]_inst_i_1141_0 input.left pin VGA_R_OBUF[3]_inst_i_1141_1 input.left pin VGA_R_OBUF[3]_inst_i_1141_2 input.left pin VGA_R_OBUF[3]_inst_i_1211 input.left pin VGA_R_OBUF[3]_inst_i_133_0 input.left pin VGA_R_OBUF[3]_inst_i_133_1 input.left pin VGA_R_OBUF[3]_inst_i_1416_0 input.left pin VGA_R_OBUF[3]_inst_i_1416_1 input.left pin VGA_R_OBUF[3]_inst_i_1416_2 input.left pin VGA_R_OBUF[3]_inst_i_1450_0 input.left pin VGA_R_OBUF[3]_inst_i_1450_1 input.left pin VGA_R_OBUF[3]_inst_i_1450_2 input.left pin VGA_R_OBUF[3]_inst_i_1453_0 input.left pin VGA_R_OBUF[3]_inst_i_1453_1 input.left pin VGA_R_OBUF[3]_inst_i_1546 input.left pin VGA_R_OBUF[3]_inst_i_1546_0 input.left pin VGA_R_OBUF[3]_inst_i_1546_1 input.left pin VGA_R_OBUF[3]_inst_i_154_0 input.left pin VGA_R_OBUF[3]_inst_i_156_0 input.left pin VGA_R_OBUF[3]_inst_i_156_1 input.left pin VGA_R_OBUF[3]_inst_i_156_2 input.left pin VGA_R_OBUF[3]_inst_i_1596_0 output.right pin VGA_R_OBUF[3]_inst_i_159_0 input.left pin VGA_R_OBUF[3]_inst_i_1604_0 input.left pin VGA_R_OBUF[3]_inst_i_1604_1 input.left pin VGA_R_OBUF[3]_inst_i_1611_0 input.left pin VGA_R_OBUF[3]_inst_i_1634_0 input.left pin VGA_R_OBUF[3]_inst_i_1634_1 input.left pin VGA_R_OBUF[3]_inst_i_1634_2 input.left pin VGA_R_OBUF[3]_inst_i_1634_3 input.left pin VGA_R_OBUF[3]_inst_i_1687 input.left pin VGA_R_OBUF[3]_inst_i_1687_0 input.left pin VGA_R_OBUF[3]_inst_i_1691 input.left pin VGA_R_OBUF[3]_inst_i_1691_1 input.left pin VGA_R_OBUF[3]_inst_i_189_0 input.left pin VGA_R_OBUF[3]_inst_i_189_1 input.left pin VGA_R_OBUF[3]_inst_i_1907 input.left pin VGA_R_OBUF[3]_inst_i_1907_0 input.left pin VGA_R_OBUF[3]_inst_i_2123_0 output.right pin VGA_R_OBUF[3]_inst_i_2125 input.left pin VGA_R_OBUF[3]_inst_i_2125_0 input.left pin VGA_R_OBUF[3]_inst_i_2138_0 input.left pin VGA_R_OBUF[3]_inst_i_2155 input.left pin VGA_R_OBUF[3]_inst_i_2204_0 input.left pin VGA_R_OBUF[3]_inst_i_2204_1 input.left pin VGA_R_OBUF[3]_inst_i_2204_2 input.left pin VGA_R_OBUF[3]_inst_i_2204_3 input.left pin VGA_R_OBUF[3]_inst_i_2204_4 input.left pin VGA_R_OBUF[3]_inst_i_2204_5 input.left pin VGA_R_OBUF[3]_inst_i_2204_6 input.left pin VGA_R_OBUF[3]_inst_i_2204_7 input.left pin VGA_R_OBUF[3]_inst_i_23_0 input.left pin VGA_R_OBUF[3]_inst_i_2769_0 input.left pin VGA_R_OBUF[3]_inst_i_2769_1 input.left pin VGA_R_OBUF[3]_inst_i_2769_2 input.left pin VGA_R_OBUF[3]_inst_i_2769_3 input.left pin VGA_R_OBUF[3]_inst_i_2769_4 input.left pin VGA_R_OBUF[3]_inst_i_2782 input.left pin VGA_R_OBUF[3]_inst_i_2783 output.right pin VGA_R_OBUF[3]_inst_i_2797 output.right pin VGA_R_OBUF[3]_inst_i_31_0 input.left pin VGA_R_OBUF[3]_inst_i_31_1 input.left pin VGA_R_OBUF[3]_inst_i_31_2 input.left pin VGA_R_OBUF[3]_inst_i_32_0 input.left pin VGA_R_OBUF[3]_inst_i_32_1 input.left pin VGA_R_OBUF[3]_inst_i_3346_2 input.left pin VGA_R_OBUF[3]_inst_i_3347_0 input.left pin VGA_R_OBUF[3]_inst_i_3359_0 output.right pin VGA_R_OBUF[3]_inst_i_3367 output.right pin VGA_R_OBUF[3]_inst_i_3383_0 output.right pin VGA_R_OBUF[3]_inst_i_3407_0 input.left pin VGA_R_OBUF[3]_inst_i_3446_0 input.left pin VGA_R_OBUF[3]_inst_i_3446_1 input.left pin VGA_R_OBUF[3]_inst_i_3446_2 input.left pin VGA_R_OBUF[3]_inst_i_3447_0 input.left pin VGA_R_OBUF[3]_inst_i_3897_0 input.left pin VGA_R_OBUF[3]_inst_i_3906_0 input.left pin VGA_R_OBUF[3]_inst_i_393_0 input.left pin VGA_R_OBUF[3]_inst_i_393_1 input.left pin VGA_R_OBUF[3]_inst_i_393_2 input.left pin VGA_R_OBUF[3]_inst_i_394_0 input.left pin VGA_R_OBUF[3]_inst_i_394_1 input.left pin VGA_R_OBUF[3]_inst_i_3957_0 input.left pin VGA_R_OBUF[3]_inst_i_3957_1 input.left pin VGA_R_OBUF[3]_inst_i_396_0 input.left pin VGA_R_OBUF[3]_inst_i_4 input.left pin VGA_R_OBUF[3]_inst_i_408 input.left pin VGA_R_OBUF[3]_inst_i_408_0 input.left pin VGA_R_OBUF[3]_inst_i_408_1 input.left pin VGA_R_OBUF[3]_inst_i_408_2 input.left pin VGA_R_OBUF[3]_inst_i_412 input.left pin VGA_R_OBUF[3]_inst_i_412_0 input.left pin VGA_R_OBUF[3]_inst_i_63_0 input.left pin VGA_R_OBUF[3]_inst_i_63_1 input.left pin VGA_R_OBUF[3]_inst_i_63_2 input.left pin VGA_R_OBUF[3]_inst_i_65_0 input.left pin VGA_R_OBUF[3]_inst_i_65_1 input.left pin VGA_R_OBUF[3]_inst_i_65_2 input.left pin VGA_R_OBUF[3]_inst_i_65_3 input.left pin VGA_R_OBUF[3]_inst_i_70 input.left pin VGA_R_OBUF[3]_inst_i_766_0 input.left pin VGA_R_OBUF[3]_inst_i_766_1 input.left pin VGA_R_OBUF[3]_inst_i_766_2 input.left pin VGA_R_OBUF[3]_inst_i_770_0 input.left pin VGA_R_OBUF[3]_inst_i_773_0 input.left pin VGA_R_OBUF[3]_inst_i_773_1 input.left pin VGA_R_OBUF[3]_inst_i_775_0 input.left pin VGA_R_OBUF[3]_inst_i_775_1 input.left pin VGA_R_OBUF[3]_inst_i_77_0 input.left pin VGA_R_OBUF[3]_inst_i_77_1 input.left pin VGA_R_OBUF[3]_inst_i_780_0 input.left pin VGA_R_OBUF[3]_inst_i_780_1 input.left pin VGA_R_OBUF[3]_inst_i_780_2 input.left pin VGA_R_OBUF[3]_inst_i_780_3 input.left pin VGA_R_OBUF[3]_inst_i_780_4 input.left pin VGA_R_OBUF[3]_inst_i_780_5 input.left pin VGA_R_OBUF[3]_inst_i_780_6 input.left pin VGA_R_OBUF[3]_inst_i_786_0 input.left pin VGA_R_OBUF[3]_inst_i_786_1 input.left pin VGA_R_OBUF[3]_inst_i_786_2 input.left pin VGA_R_OBUF[3]_inst_i_786_3 input.left pin VGA_R_OBUF[3]_inst_i_786_4 input.left pin VGA_R_OBUF[3]_inst_i_823_0 input.left pin VGA_R_OBUF[3]_inst_i_823_1 input.left pin VGA_VS_OBUF output.right pin altitude_ft_reg[10] output.right pin altitude_ft_reg[16] output.right pin altitude_ft_reg[1] output.right pin altitude_ft_reg[2] output.right pin altitude_ft_reg[3] output.right pin altitude_ft_reg[4] output.right pin altitude_ft_reg[5] output.right pin altitude_ft_reg[6] output.right pin altitude_ft_reg[7] output.right pin altitude_ft_reg[8] output.right pin altitude_ft_reg[8]_0 output.right pin altitude_ft_reg[8]_1 output.right pin altitude_ft_reg[8]_2 output.right pin altitude_ft_reg[8]_3 output.right pin altitude_ft_reg[9] output.right pin alvo input.left pin capture_hud_opaque output.right pin clk_hud input.left pin current_rgb332 input.left pin declutter input.left pin declutter_reg output.right pin displayed_valid_reg output.right pin fetching input.left pin frame_latch output.right pin g0_b0__2_i_1_0 input.left pin g0_b0__2_i_1_1 input.left pin g0_b0__2_i_3_0 input.left pin g0_b0__2_i_3_1 input.left pin g0_b0__2_i_3_2 input.left pin g0_b0__2_i_43 input.left pin g0_b0__2_i_4_0 input.left pin g0_b0__2_i_4_1 input.left pin g0_b0__2_i_4_2 input.left pin g0_b26_0 input.left pin g0_b26_1 input.left pin g0_b26_2 input.left pin g1_b34_i_102_0 input.left pin g1_b34_i_36_0 input.left pin g1_b34_i_39_0 input.left pin g_native_video.displayed_valid input.left pin g_native_video.frame_boundary output.right pin g_native_video.publish_enable input.left pin g_native_video.video_visible input.left pin g_native_video.video_visible_reg output.right pin g_native_video.video_visible_reg_0 input.left pin h_cont_reg[0]_rep__0_0 output.right pin h_cont_reg[1]_rep_0 output.right pin h_cont_reg[1]_rep__0_0 output.right pin h_cont_reg[1]_rep__0_1 output.right pin h_cont_reg[1]_rep__0_2 output.right pin h_cont_reg[1]_rep__0_7 output.right pin h_cont_reg[1]_rep__1_0 output.right pin h_cont_reg[1]_rep__1_3 output.right pin h_cont_reg[1]_rep__1_6 output.right pin h_cont_reg[2]_rep__0_0 output.right pin h_cont_reg[2]_rep__2_0 output.right pin h_cont_reg[3]_rep_0 output.right pin h_cont_reg[3]_rep_1 output.right pin h_cont_reg[3]_rep_2 output.right pin h_cont_reg[3]_rep_3 output.right pin h_cont_reg[3]_rep__1_0 output.right pin h_cont_reg[4]_rep_0 output.right pin h_cont_reg[4]_rep__1_0 output.right pin h_cont_reg[5]_rep_0 output.right pin h_cont_reg[5]_rep_1 output.right pin h_cont_reg[6]_0 output.right pin h_cont_reg[6]_1 output.right pin h_cont_reg[6]_2 output.right pin h_cont_reg[6]_4 output.right pin h_cont_reg[9]_10 output.right pin h_cont_reg[9]_9 output.right pin heading_deg_reg[8]_rep_0 output.right pin heading_deg_reg[8]_rep_1 output.right pin heading_deg_reg[8]_rep_2 output.right pin heading_deg_reg[8]_rep_3 output.right pin heading_deg_reg[8]_rep_4 output.right pin horizonte input.left pin hud_video_on input.left pin i__i_12_0 input.left pin i__i_14_0 input.left pin i__i_32_0 input.left pin i__i_34_0 input.left pin i__i_53_0 input.left pin i__i_59_0 input.left pin i__i_60_0 input.left pin i__i_61_0 input.left pin i__i_62_0 input.left pin i__i_8_1 input.left pin i__i_8_2 input.left pin line_valid input.left pin mira_lock input.left pin mira_on input.left pin new_line output.right pin offset_y_reg[0] output.right pin offset_y_reg[4] output.right pin on2264_in input.left pin out input.left pin pixel_clk output.right pin pixel_word1__3 output.right pin prefetch_line output.right pin prefetch_line27_in output.right pin retic_caca_clearance output.right pin texto90 input.left pin texto9131_in input.left pin v_cont_reg[0]_rep__0_0 output.right pin v_cont_reg[0]_rep__0_1 output.right pin v_cont_reg[0]_rep__0_2 output.right pin v_cont_reg[0]_rep__0_3 output.right pin v_cont_reg[0]_rep__0_4 output.right pin v_cont_reg[1]_0 input.left pin v_cont_reg[2]_0 output.right pin v_cont_reg[2]_1 output.right pin v_cont_reg[2]_rep_0 output.right pin v_cont_reg[3]_1 output.right pin v_cont_reg[4]_rep_0 output.right pin v_cont_reg[4]_rep_1 output.right pin v_cont_reg[4]_rep__0_0 output.right pin v_cont_reg[4]_rep__1_0 output.right pin v_cont_reg[5]_0 output.right pin v_cont_reg[5]_1 output.right pin v_cont_reg[5]_rep_0 output.right pin v_cont_reg[5]_rep__0_0 output.right pin v_cont_reg[5]_rep__0_1 output.right pin v_cont_reg[5]_rep__0_2 output.right pin v_cont_reg[5]_rep__0_3 output.right pin v_cont_reg[5]_rep__1_0 output.right pin v_cont_reg[6]_rep_0 output.right pin v_cont_reg[6]_rep__0_0 output.right pin v_cont_reg[7]_rep_1 output.right pin v_cont_reg[7]_rep_2 output.right pin v_cont_reg[7]_rep_3 output.right pin v_cont_reg[7]_rep_4 output.right pin v_cont_reg[7]_rep_5 output.right pin v_cont_reg[7]_rep_6 output.right pin v_cont_reg[7]_rep__0_1 output.right pin v_cont_reg[8]_0 output.right pin v_cont_reg[8]_1 output.right pin v_cont_reg[9]_2 output.right pin v_cont_reg[9]_3 output.right pin velocidade_kt_reg[9] output.right pin video_on output.right pinBus ADDRA output.right [4:0] pinBus CO output.right [0:0] pinBus D input.left [0:0] pinBus DI input.left [0:0] pinBus O input.left [2:0] pinBus P input.left [17:0] pinBus Q output.right [8:0] pinBus S input.left [2:0] pinBus SS output.right [0:0] pinBus VGA_B_OBUF[3]_inst_i_18_0 input.left [146:0] pinBus VGA_G_OBUF output.right [3:0] pinBus VGA_R_OBUF[3]_inst_i_1102_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_1158_0 input.left [17:0] pinBus VGA_R_OBUF[3]_inst_i_1158_1 input.left [17:0] pinBus VGA_R_OBUF[3]_inst_i_1158_2 input.left [19:0] pinBus VGA_R_OBUF[3]_inst_i_1158_3 input.left [19:0] pinBus VGA_R_OBUF[3]_inst_i_1158_4 input.left [19:0] pinBus VGA_R_OBUF[3]_inst_i_1205 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1435_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_1631_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1631_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1631_2 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1631_3 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1661 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1691_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_2146 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_2260_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2268 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2271 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2272 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2274_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2873_0 input.left [16:0] pinBus VGA_R_OBUF[3]_inst_i_2873_1 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2873_2 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2888 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_2903 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_2918 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_2933 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_2986_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_321_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_321_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3346_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3346_1 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_3347_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3347_2 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_3347_3 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_3347_4 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3348_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_3348_1 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_3348_2 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_3349_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_3349_1 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_3349_2 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3349_3 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_3407_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3447_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4013_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4041 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4072 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4103 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4140 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4192 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_41_0 input.left [11:0] pinBus VGA_R_OBUF[3]_inst_i_4401_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4401_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4424_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4424_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4447_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4447_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4479_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4479_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4489 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4494 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4499 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_4515_0 input.left [6:0] pinBus VGA_R_OBUF[3]_inst_i_4628_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_4643_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_4659_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_4686_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_4696_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4701_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_4706_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_63_3 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_835 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_835_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_954 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_954_0 input.left [0:0] pinBus even_tag_reg[9] output.right [0:0] pinBus frame_id input.left [31:0] pinBus future_x output.right [0:0] pinBus g1_b34_i_75_0 input.left [1:0] pinBus g1_b34_i_75_1 input.left [1:0] pinBus g_native_video.pixel_reset_pipe_reg[1] output.right [0:0] pinBus g_native_video.pixel_reset_pipe_reg[1]_0 output.right [0:0] pinBus g_native_video.pixel_reset_pipe_reg[1]_1 output.right [0:0] pinBus g_native_video.video_visible_reg_1 input.left [0:0] pinBus h_cont_reg[0]_rep_0 output.right [0:0] pinBus h_cont_reg[0]_rep_1 output.right [0:0] pinBus h_cont_reg[0]_rep_2 output.right [0:0] pinBus h_cont_reg[0]_rep_3 output.right [0:0] pinBus h_cont_reg[0]_rep_4 output.right [2:0] pinBus h_cont_reg[0]_rep__0_1 output.right [3:0] pinBus h_cont_reg[0]_rep__0_2 output.right [3:0] pinBus h_cont_reg[1]_rep__0_3 output.right [3:0] pinBus h_cont_reg[1]_rep__0_4 output.right [3:0] pinBus h_cont_reg[1]_rep__0_5 output.right [3:0] pinBus h_cont_reg[1]_rep__0_6 output.right [3:0] pinBus h_cont_reg[1]_rep__0_8 output.right [3:0] pinBus h_cont_reg[1]_rep__0_9 output.right [3:0] pinBus h_cont_reg[1]_rep__1_1 output.right [0:0] pinBus h_cont_reg[1]_rep__1_2 output.right [0:0] pinBus h_cont_reg[1]_rep__1_4 output.right [2:0] pinBus h_cont_reg[1]_rep__1_5 output.right [3:0] pinBus h_cont_reg[2]_rep_0 output.right [0:0] pinBus h_cont_reg[2]_rep_1 output.right [1:0] pinBus h_cont_reg[2]_rep_2 output.right [0:0] pinBus h_cont_reg[2]_rep_3 output.right [0:0] pinBus h_cont_reg[2]_rep_4 output.right [2:0] pinBus h_cont_reg[2]_rep_5 output.right [2:0] pinBus h_cont_reg[2]_rep_6 output.right [0:0] pinBus h_cont_reg[2]_rep__0_1 output.right [3:0] pinBus h_cont_reg[2]_rep__1_0 output.right [3:0] pinBus h_cont_reg[2]_rep__2_1 output.right [3:0] pinBus h_cont_reg[2]_rep__2_2 output.right [3:0] pinBus h_cont_reg[3]_rep_4 output.right [3:0] pinBus h_cont_reg[3]_rep__1_1 output.right [2:0] pinBus h_cont_reg[3]_rep__1_2 output.right [2:0] pinBus h_cont_reg[3]_rep__1_3 output.right [2:0] pinBus h_cont_reg[3]_rep__1_4 output.right [3:0] pinBus h_cont_reg[5]_rep_2 output.right [0:0] pinBus h_cont_reg[5]_rep__0_0 output.right [1:0] pinBus h_cont_reg[6]_3 output.right [1:0] pinBus h_cont_reg[6]_5 output.right [0:0] pinBus h_cont_reg[6]_6 output.right [0:0] pinBus h_cont_reg[6]_7 output.right [1:0] pinBus h_cont_reg[7]_0 output.right [4:0] pinBus h_cont_reg[7]_1 output.right [1:0] pinBus h_cont_reg[7]_2 output.right [1:0] pinBus h_cont_reg[7]_3 output.right [1:0] pinBus h_cont_reg[7]_4 output.right [3:0] pinBus h_cont_reg[7]_5 output.right [0:0] pinBus h_cont_reg[7]_6 output.right [0:0] pinBus h_cont_reg[7]_7 output.right [0:0] pinBus h_cont_reg[8]_0 output.right [0:0] pinBus h_cont_reg[9]_0 output.right [0:0] pinBus h_cont_reg[9]_1 output.right [0:0] pinBus h_cont_reg[9]_2 output.right [0:0] pinBus h_cont_reg[9]_3 output.right [0:0] pinBus h_cont_reg[9]_4 output.right [0:0] pinBus h_cont_reg[9]_5 output.right [0:0] pinBus h_cont_reg[9]_6 output.right [0:0] pinBus h_cont_reg[9]_7 output.right [0:0] pinBus h_cont_reg[9]_8 output.right [0:0] pinBus heading_deg_reg[7] output.right [2:0] pinBus heading_deg_reg[8]_rep output.right [1:0] pinBus hud_pixel_x input.left [3:0] pinBus hud_pixel_y input.left [1:0] pinBus i__i_43_0 input.left [0:0] pinBus i__i_43_1 input.left [0:0] pinBus i__i_8_0 input.left [131:0] pinBus line_valid_reg input.left [0:0] pinBus mira_lock_reg output.right [3:0] pinBus missing_lines_reg[0]_i_3_0 input.left [6:0] pinBus missing_lines_reg[0]_i_3_1 input.left [6:0] pinBus missing_lines_reg[31] input.left [0:0] pinBus offset_y input.left [7:0] pinBus p_0_in__1 output.right [3:0] pinBus u_i_21 input.left [1:0] pinBus u_i_47_0 output.right [0:0] pinBus v_cont_reg[0]_0 output.right [0:0] pinBus v_cont_reg[0]_1 output.right [3:0] pinBus v_cont_reg[0]_2 output.right [0:0] pinBus v_cont_reg[3]_0 output.right [3:0] pinBus v_cont_reg[7]_rep_0 output.right [9:0] pinBus v_cont_reg[7]_rep__0_0 output.right [3:0] pinBus v_cont_reg[7]_rep__0_2 output.right [0:0] pinBus v_cont_reg[9]_0 output.right [1:0] pinBus v_cont_reg[9]_1 output.right [0:0] pinBus xc_i_18_0 input.left [7:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst u_sensor mpu6050_i2c work:mpu6050_i2c:NOFILE -attr @cell(#1c1f28) mpu6050_i2c -pinBusAttr B @name B[15:0] -pinBusAttr D @name D -pinBusAttr DI @name DI -pinBusAttr S @name S -pinBusAttr SR @name SR -pinBusAttr accel_x_reg[15]_0 @name accel_x_reg[15]_0[95:0] -pinBusAttr age_reg @name age_reg -pinBusAttr age_reg[0] @name age_reg[0] -pinBusAttr age_reg[0]_0 @name age_reg[0]_0 -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr out @name out -pinBusAttr samples_reg[2][7]_0 @name samples_reg[2][7]_0[15:0] -pinBusAttr samples_reg[4][7]_0 @name samples_reg[4][7]_0[15:0] -pinBusAttr scl_sync_reg[0]_0 @name scl_sync_reg[0]_0 -pinBusAttr sda_sync_reg[0]_0 @name sda_sync_reg[0]_0 -pinBusAttr sensor_i_3 @name sensor_i_3[1:0] -pinBusAttr sensor_i_3_0 @name sensor_i_3_0[1:0] -pinBusAttr stale_reg @name stale_reg -pg 1 -lvl 1 -x 750 -y 4110
load inst u_vector atitude_vetorial work:atitude_vetorial:NOFILE -attr @cell(#1c1f28) atitude_vetorial -pinBusAttr B @name B[15:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[112:0] -pinBusAttr DI @name DI -pinBusAttr E @name E -pinBusAttr O @name O -pinBusAttr Q @name Q[23:0] -pinBusAttr S @name S -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr a_reg[0][15]_0 @name a_reg[0][15]_0[95:0] -pinBusAttr age_reg[0]_0 @name age_reg[0]_0 -pinBusAttr age_reg[3]_0 @name age_reg[3]_0 -pinBusAttr age_reg[3]_1 @name age_reg[3]_1 -pinBusAttr angle_out_reg[6] @name angle_out_reg[6] -pinBusAttr done_i_3_0 @name done_i_3_0 -pinBusAttr done_i_3_1 @name done_i_3_1 -pinBusAttr done_reg @name done_reg -pinBusAttr gravity_x_reg[23]_0 @name gravity_x_reg[23]_0[23:0] -pinBusAttr gravity_y_reg[23]_0 @name gravity_y_reg[23]_0[23:0] -pinBusAttr horizonte_sync_reg[0] @name horizonte_sync_reg[0][26:0] -pinBusAttr horizonte_sync_reg[0]_0 @name horizonte_sync_reg[0]_0[10:0] -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr inicio_operacao_reg[3]_1 @name inicio_operacao_reg[3]_1 -pinBusAttr out @name out -pinBusAttr p_1_in_1 @name p_1_in_1[15:0] -pinBusAttr p_1_in__0_0 @name p_1_in__0_0[15:0] -pinBusAttr pc_reg_0 @name pc_reg_0 -pinBusAttr pitch_fallback_q10_reg[14] @name pitch_fallback_q10_reg[14][1:0] -pinBusAttr pw_reg @name pw_reg[26:0] -pinBusAttr raw_pitch_reg[12]_0 @name raw_pitch_reg[12]_0[1:0] -pinBusAttr raw_pitch_reg[12]_1 @name raw_pitch_reg[12]_1[1:0] -pinBusAttr raw_pitch_reg[14]_0 @name raw_pitch_reg[14]_0[3:0] -pinBusAttr raw_pitch_reg[16]_0 @name raw_pitch_reg[16]_0[3:0] -pinBusAttr raw_pitch_reg[22]_0 @name raw_pitch_reg[22]_0[3:0] -pinBusAttr raw_pitch_reg[24]_0 @name raw_pitch_reg[24]_0 -pinBusAttr raw_pitch_reg[24]_1 @name raw_pitch_reg[24]_1[3:0] -pinBusAttr raw_pitch_reg[25]_0 @name raw_pitch_reg[25]_0[2:0] -pinBusAttr raw_pitch_reg[25]_1 @name raw_pitch_reg[25]_1 -pinBusAttr raw_pitch_reg[6]_0 @name raw_pitch_reg[6]_0[3:0] -pinBusAttr raw_pitch_reg[6]_1 @name raw_pitch_reg[6]_1[3:0] -pinBusAttr raw_pitch_reg[8]_0 @name raw_pitch_reg[8]_0[3:0] -pinBusAttr raw_roll_reg[12]_0 @name raw_roll_reg[12]_0[1:0] -pinBusAttr raw_roll_reg[12]_1 @name raw_roll_reg[12]_1[1:0] -pinBusAttr raw_roll_reg[14]_0 @name raw_roll_reg[14]_0[3:0] -pinBusAttr raw_roll_reg[16]_0 @name raw_roll_reg[16]_0[3:0] -pinBusAttr raw_roll_reg[22]_0 @name raw_roll_reg[22]_0[3:0] -pinBusAttr raw_roll_reg[24]_0 @name raw_roll_reg[24]_0 -pinBusAttr raw_roll_reg[24]_1 @name raw_roll_reg[24]_1[3:0] -pinBusAttr raw_roll_reg[26]_0 @name raw_roll_reg[26]_0 -pinBusAttr raw_roll_reg[26]_1 @name raw_roll_reg[26]_1[2:0] -pinBusAttr raw_roll_reg[6]_0 @name raw_roll_reg[6]_0[3:0] -pinBusAttr raw_roll_reg[6]_1 @name raw_roll_reg[6]_1[3:0] -pinBusAttr raw_roll_reg[8]_0 @name raw_roll_reg[8]_0[3:0] -pinBusAttr rc_reg_i_15_0 @name rc_reg_i_15_0 -pinBusAttr rc_reg_i_15_1 @name rc_reg_i_15_1 -pinBusAttr rc_reg_i_20_0 @name rc_reg_i_20_0 -pinBusAttr rc_reg_i_32_0 @name rc_reg_i_32_0 -pinBusAttr rc_reg_i_8_0 @name rc_reg_i_8_0 -pinBusAttr roll_fallback_q10_reg[9] @name roll_fallback_q10_reg[9][1:0] -pinBusAttr roll_reg[16]_0 @name roll_reg[16]_0[4:0] -pinBusAttr roll_reg[31]_0 @name roll_reg[31]_0[19:0] -pinBusAttr roll_reg[31]_1 @name roll_reg[31]_1 -pinBusAttr roll_reg[31]_2 @name roll_reg[31]_2 -pinBusAttr roll_reg[31]_3 @name roll_reg[31]_3 -pinBusAttr roll_reg[31]_4 @name roll_reg[31]_4 -pinBusAttr roll_sync_reg[0] @name roll_sync_reg[0][28:0] -pinBusAttr roll_sync_reg[0]_0 @name roll_sync_reg[0]_0[28:0] -pinBusAttr rw_reg_i_18_0 @name rw_reg_i_18_0 -pinBusAttr rw_reg_i_18_1 @name rw_reg_i_18_1 -pinBusAttr rw_reg_i_23_2 @name rw_reg_i_23_2 -pinBusAttr rw_reg_i_3_0 @name rw_reg_i_3_0[28:0] -pinBusAttr rw_reg_i_6_0 @name rw_reg_i_6_0 -pinBusAttr rw_reg_i_8_0 @name rw_reg_i_8_0[1:0] -pinBusAttr stale_reg[0]_0 @name stale_reg[0]_0 -pinBusAttr video_startup_count @name video_startup_count -pinBusAttr video_startup_count_reg @name video_startup_count_reg[29:0] -pinBusAttr video_startup_ready_reg_1 @name video_startup_ready_reg_1 -pinBusAttr y @name y -pg 1 -lvl 2 -x 1980 -y 4130
load inst g_mag_tilt.u_heading heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE -attr @cell(#1c1f28) heading_magnetico_inclinado -pinBusAttr D @name D[15:0] -pinBusAttr E @name E -pinBusAttr O @name O[3:0] -pinBusAttr Q @name Q -pinBusAttr SR @name SR -pinBusAttr age_reg[12]_0 @name age_reg[12]_0[3:0] -pinBusAttr age_reg[16]_0 @name age_reg[16]_0[3:0] -pinBusAttr age_reg[20]_0 @name age_reg[20]_0[3:0] -pinBusAttr age_reg[24]_0 @name age_reg[24]_0[3:0] -pinBusAttr age_reg[25]_0 @name age_reg[25]_0 -pinBusAttr age_reg[25]_1 @name age_reg[25]_1[25:0] -pinBusAttr age_reg[8]_0 @name age_reg[8]_0[3:0] -pinBusAttr bx_reg_0 @name bx_reg_0[15:0] -pinBusAttr by_reg_0 @name by_reg_0[15:0] -pinBusAttr gx_reg[23]_0 @name gx_reg[23]_0[23:0] -pinBusAttr gy_reg[24]_0 @name gy_reg[24]_0[23:0] -pinBusAttr gz_reg[24]_0 @name gz_reg[24]_0[23:0] -pinBusAttr heading_deg_reg[8]_0 @name heading_deg_reg[8]_0[8:0] -pinBusAttr out @name out -pinBusAttr p_0_out @name p_0_out -pinBusAttr y @name y -pg 1 -lvl 3 -x 6290 -y 4910
load inst g_operacao.u_operacao operacao_hud work:operacao_hud:NOFILE -attr @cell(#1c1f28) operacao_hud -pinBusAttr B @name B[12:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[51:0] -pinBusAttr DI @name DI -pinBusAttr O @name O -pinBusAttr Q @name Q[3:0] -pinBusAttr S @name S -pinBusAttr SD_DIAG_PAGE_IBUF @name SD_DIAG_PAGE_IBUF[3:0] -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr ar0 @name ar0[4:0] -pinBusAttr dados_reg[8]_0 @name dados_reg[8]_0[8:0] -pinBusAttr estado_reg[0]_0 @name estado_reg[0]_0 -pinBusAttr estado_reg[7]_0 @name estado_reg[7]_0 -pinBusAttr estado_reg[7]_1 @name estado_reg[7]_1[1:0] -pinBusAttr g_idade[2].idade_reg[0]_0 @name g_idade[2].idade_reg[0]_0 -pinBusAttr g_idade[2].idade_reg[25]_0 @name g_idade[2].idade_reg[25]_0 -pinBusAttr meta_reg[3] @name meta_reg[3][20:0] -pinBusAttr out @name out[1:0] -pinBusAttr p_0_out @name p_0_out -pinBusAttr phase_a_reg[2] @name phase_a_reg[2][2:0] -pinBusAttr pitch_fallback_q10_reg[31]_0 @name pitch_fallback_q10_reg[31]_0 -pinBusAttr pitch_fallback_q10_reg[31]_1 @name pitch_fallback_q10_reg[31]_1[26:0] -pinBusAttr pitch_fallback_q10_reg[31]_2 @name pitch_fallback_q10_reg[31]_2[26:0] -pinBusAttr rc_reg @name rc_reg -pinBusAttr rc_reg_0 @name rc_reg_0 -pinBusAttr requested_video_mode @name requested_video_mode[1:0] -pinBusAttr roll_fallback_q10_reg[31]_0 @name roll_fallback_q10_reg[31]_0[28:0] -pinBusAttr roll_fallback_q10_reg[31]_1 @name roll_fallback_q10_reg[31]_1 -pinBusAttr roll_fallback_q10_reg[31]_2 @name roll_fallback_q10_reg[31]_2[28:0] -pinBusAttr roll_reg[0] @name roll_reg[0] -pinBusAttr roll_reg[0]_0 @name roll_reg[0]_0 -pinBusAttr roll_reg[0]_1 @name roll_reg[0]_1 -pinBusAttr roll_reg[0]_2 @name roll_reg[0]_2 -pinBusAttr roll_reg[0]_3 @name roll_reg[0]_3 -pinBusAttr roll_reg[13] @name roll_reg[13][1:0] -pinBusAttr roll_reg[13]_0 @name roll_reg[13]_0 -pinBusAttr rw_reg @name rw_reg -pinBusAttr scroll_offset_reg[0] @name scroll_offset_reg[0][2:0] -pinBusAttr switches @name switches[1:0] -pg 1 -lvl 1 -x 750 -y 4670
load inst u_entrada entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE -attr @cell(#1c1f28) entrada_hud__parameterized2 -pinBusAttr D @name D[1:0] -pinBusAttr Q @name Q[71:0] -pinBusAttr SR @name SR -pinBusAttr dados_destino_reg[17]_1 @name dados_destino_reg[17]_1[1:0] -pinBusAttr dados_destino_reg[80]_0 @name dados_destino_reg[80]_0 -pinBusAttr retido_reg[121]_0 @name retido_reg[121]_0[90:0] -pinBusAttr valido_destino_reg_0 @name valido_destino_reg_0 -pg 1 -lvl 2 -x 1980 -y 5810
load inst u_dados dados_hud work:dados_hud:NOFILE -attr @cell(#1c1f28) dados_hud -pinBusAttr A @name A[11:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[1:0] -pinBusAttr DI @name DI[1:0] -pinBusAttr O @name O[2:0] -pinBusAttr Q @name Q[71:0] -pinBusAttr S @name S[2:0] -pinBusAttr SR @name SR -pinBusAttr VGA_G_OBUF[3]_inst_i_100 @name VGA_G_OBUF[3]_inst_i_100 -pinBusAttr VGA_G_OBUF[3]_inst_i_101 @name VGA_G_OBUF[3]_inst_i_101 -pinBusAttr VGA_G_OBUF[3]_inst_i_102 @name VGA_G_OBUF[3]_inst_i_102 -pinBusAttr VGA_G_OBUF[3]_inst_i_98 @name VGA_G_OBUF[3]_inst_i_98 -pinBusAttr VGA_R_OBUF[3]_inst_i_1072 @name VGA_R_OBUF[3]_inst_i_1072[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1072_0 @name VGA_R_OBUF[3]_inst_i_1072_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_1093 @name VGA_R_OBUF[3]_inst_i_1093[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1105 @name VGA_R_OBUF[3]_inst_i_1105[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1109 @name VGA_R_OBUF[3]_inst_i_1109[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1118 @name VGA_R_OBUF[3]_inst_i_1118 -pinBusAttr VGA_R_OBUF[3]_inst_i_1122 @name VGA_R_OBUF[3]_inst_i_1122[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_0 @name VGA_R_OBUF[3]_inst_i_1174_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_1 @name VGA_R_OBUF[3]_inst_i_1174_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_2 @name VGA_R_OBUF[3]_inst_i_1174_2[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_3 @name VGA_R_OBUF[3]_inst_i_1174_3[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1182_0 @name VGA_R_OBUF[3]_inst_i_1182_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1182_1 @name VGA_R_OBUF[3]_inst_i_1182_1[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_139_0 @name VGA_R_OBUF[3]_inst_i_139_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_140_0 @name VGA_R_OBUF[3]_inst_i_140_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_145_0 @name VGA_R_OBUF[3]_inst_i_145_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_146_0 @name VGA_R_OBUF[3]_inst_i_146_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_148_0 @name VGA_R_OBUF[3]_inst_i_148_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_150_0 @name VGA_R_OBUF[3]_inst_i_150_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_1561 @name VGA_R_OBUF[3]_inst_i_1561[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1567_0 @name VGA_R_OBUF[3]_inst_i_1567_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1578 @name VGA_R_OBUF[3]_inst_i_1578 -pinBusAttr VGA_R_OBUF[3]_inst_i_1670_0 @name VGA_R_OBUF[3]_inst_i_1670_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1670_1 @name VGA_R_OBUF[3]_inst_i_1670_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1679_0 @name VGA_R_OBUF[3]_inst_i_1679_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2150 @name VGA_R_OBUF[3]_inst_i_2150 -pinBusAttr VGA_R_OBUF[3]_inst_i_2218_0 @name VGA_R_OBUF[3]_inst_i_2218_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2228_0 @name VGA_R_OBUF[3]_inst_i_2228_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2238_0 @name VGA_R_OBUF[3]_inst_i_2238_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2248_0 @name VGA_R_OBUF[3]_inst_i_2248_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_0 @name VGA_R_OBUF[3]_inst_i_2869_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_1 @name VGA_R_OBUF[3]_inst_i_2869_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_2 @name VGA_R_OBUF[3]_inst_i_2869_2 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_3 @name VGA_R_OBUF[3]_inst_i_2869_3 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_4 @name VGA_R_OBUF[3]_inst_i_2869_4 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_5 @name VGA_R_OBUF[3]_inst_i_2869_5[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_6 @name VGA_R_OBUF[3]_inst_i_2869_6 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_7 @name VGA_R_OBUF[3]_inst_i_2869_7[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2961_0 @name VGA_R_OBUF[3]_inst_i_2961_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_30 @name VGA_R_OBUF[3]_inst_i_30 -pinBusAttr VGA_R_OBUF[3]_inst_i_31 @name VGA_R_OBUF[3]_inst_i_31 -pinBusAttr VGA_R_OBUF[3]_inst_i_32 @name VGA_R_OBUF[3]_inst_i_32 -pinBusAttr VGA_R_OBUF[3]_inst_i_32_0 @name VGA_R_OBUF[3]_inst_i_32_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_33 @name VGA_R_OBUF[3]_inst_i_33[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3420_0 @name VGA_R_OBUF[3]_inst_i_3420_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3420_1 @name VGA_R_OBUF[3]_inst_i_3420_1[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3431_0 @name VGA_R_OBUF[3]_inst_i_3431_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3431_1 @name VGA_R_OBUF[3]_inst_i_3431_1[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_0 @name VGA_R_OBUF[3]_inst_i_3436_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_1 @name VGA_R_OBUF[3]_inst_i_3436_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_2 @name VGA_R_OBUF[3]_inst_i_3436_2[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_3 @name VGA_R_OBUF[3]_inst_i_3436_3 -pinBusAttr VGA_R_OBUF[3]_inst_i_3440_0 @name VGA_R_OBUF[3]_inst_i_3440_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3466_0 @name VGA_R_OBUF[3]_inst_i_3466_0[7:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3480_0 @name VGA_R_OBUF[3]_inst_i_3480_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3507_0 @name VGA_R_OBUF[3]_inst_i_3507_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3533_0 @name VGA_R_OBUF[3]_inst_i_3533_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_353_0 @name VGA_R_OBUF[3]_inst_i_353_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_353_1 @name VGA_R_OBUF[3]_inst_i_353_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_3560_0 @name VGA_R_OBUF[3]_inst_i_3560_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3611_0 @name VGA_R_OBUF[3]_inst_i_3611_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_393 @name VGA_R_OBUF[3]_inst_i_393[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_394 @name VGA_R_OBUF[3]_inst_i_394[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_394_1 @name VGA_R_OBUF[3]_inst_i_394_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_395_0 @name VGA_R_OBUF[3]_inst_i_395_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3980_0 @name VGA_R_OBUF[3]_inst_i_3980_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4003_0 @name VGA_R_OBUF[3]_inst_i_4003_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4029_0 @name VGA_R_OBUF[3]_inst_i_4029_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4060_0 @name VGA_R_OBUF[3]_inst_i_4060_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4091_0 @name VGA_R_OBUF[3]_inst_i_4091_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4122_0 @name VGA_R_OBUF[3]_inst_i_4122_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4155_0 @name VGA_R_OBUF[3]_inst_i_4155_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4166_0 @name VGA_R_OBUF[3]_inst_i_4166_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4175_0 @name VGA_R_OBUF[3]_inst_i_4175_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4633_0 @name VGA_R_OBUF[3]_inst_i_4633_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4648_0 @name VGA_R_OBUF[3]_inst_i_4648_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4664_0 @name VGA_R_OBUF[3]_inst_i_4664_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4691_0 @name VGA_R_OBUF[3]_inst_i_4691_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_55 @name VGA_R_OBUF[3]_inst_i_55 -pinBusAttr VGA_R_OBUF[3]_inst_i_60_0 @name VGA_R_OBUF[3]_inst_i_60_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_674_0 @name VGA_R_OBUF[3]_inst_i_674_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_674_1 @name VGA_R_OBUF[3]_inst_i_674_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_680_0 @name VGA_R_OBUF[3]_inst_i_680_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_705_0 @name VGA_R_OBUF[3]_inst_i_705_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_722_0 @name VGA_R_OBUF[3]_inst_i_722_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_73_0 @name VGA_R_OBUF[3]_inst_i_73_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_76 @name VGA_R_OBUF[3]_inst_i_76[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_766 @name VGA_R_OBUF[3]_inst_i_766[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_767_0 @name VGA_R_OBUF[3]_inst_i_767_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_77 @name VGA_R_OBUF[3]_inst_i_77[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_771_0 @name VGA_R_OBUF[3]_inst_i_771_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_776_0 @name VGA_R_OBUF[3]_inst_i_776_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_786 @name VGA_R_OBUF[3]_inst_i_786[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_822_0 @name VGA_R_OBUF[3]_inst_i_822_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_822_1 @name VGA_R_OBUF[3]_inst_i_822_1[4:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_839_0 @name VGA_R_OBUF[3]_inst_i_839_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_840_0 @name VGA_R_OBUF[3]_inst_i_840_0[2:0] -pinBusAttr altitude_ft_reg[16]_0 @name altitude_ft_reg[16]_0[16:0] -pinBusAttr altitude_ft_reg[4]_1 @name altitude_ft_reg[4]_1 -pinBusAttr altitude_ft_reg[6]_1 @name altitude_ft_reg[6]_1[2:0] -pinBusAttr altitude_pendente_reg[16]_0 @name altitude_pendente_reg[16]_0 -pinBusAttr alvo_x_reg[3]_0 @name alvo_x_reg[3]_0[3:0] -pinBusAttr alvo_y_pendente_reg[4]_0 @name alvo_y_pendente_reg[4]_0[1:0] -pinBusAttr alvo_y_reg[8]_0 @name alvo_y_reg[8]_0[4:0] -pinBusAttr h_cont_reg[5]_rep @name h_cont_reg[5]_rep[2:0] -pinBusAttr h_cont_reg[5]_rep_0 @name h_cont_reg[5]_rep_0[2:0] -pinBusAttr h_cont_reg[5]_rep_1 @name h_cont_reg[5]_rep_1[2:0] -pinBusAttr h_cont_reg[9] @name h_cont_reg[9][3:0] -pinBusAttr h_cont_reg[9]_0 @name h_cont_reg[9]_0[3:0] -pinBusAttr h_cont_reg[9]_1 @name h_cont_reg[9]_1[3:0] -pinBusAttr h_cont_reg[9]_2 @name h_cont_reg[9]_2[3:0] -pinBusAttr heading_deg_reg[0]_0 @name heading_deg_reg[0]_0[6:0] -pinBusAttr heading_deg_reg[0]_1 @name heading_deg_reg[0]_1[2:0] -pinBusAttr heading_deg_reg[0]_10 @name heading_deg_reg[0]_10[3:0] -pinBusAttr heading_deg_reg[0]_11 @name heading_deg_reg[0]_11[2:0] -pinBusAttr heading_deg_reg[0]_12 @name heading_deg_reg[0]_12[3:0] -pinBusAttr heading_deg_reg[0]_13 @name heading_deg_reg[0]_13[2:0] -pinBusAttr heading_deg_reg[0]_14 @name heading_deg_reg[0]_14[3:0] -pinBusAttr heading_deg_reg[0]_2 @name heading_deg_reg[0]_2[2:0] -pinBusAttr heading_deg_reg[0]_3 @name heading_deg_reg[0]_3[3:0] -pinBusAttr heading_deg_reg[0]_4 @name heading_deg_reg[0]_4[3:0] -pinBusAttr heading_deg_reg[0]_5 @name heading_deg_reg[0]_5 -pinBusAttr heading_deg_reg[0]_6 @name heading_deg_reg[0]_6[3:0] -pinBusAttr heading_deg_reg[0]_7 @name heading_deg_reg[0]_7[2:0] -pinBusAttr heading_deg_reg[0]_8 @name heading_deg_reg[0]_8[3:0] -pinBusAttr heading_deg_reg[0]_9 @name heading_deg_reg[0]_9[2:0] -pinBusAttr heading_deg_reg[7]_0 @name heading_deg_reg[7]_0[3:0] -pinBusAttr heading_deg_reg[7]_1 @name heading_deg_reg[7]_1[1:0] -pinBusAttr heading_deg_reg[7]_4 @name heading_deg_reg[7]_4 -pinBusAttr heading_deg_reg[7]_rep_0 @name heading_deg_reg[7]_rep_0 -pinBusAttr heading_deg_reg[7]_rep_1 @name heading_deg_reg[7]_rep_1 -pinBusAttr heading_deg_reg[8]_0 @name heading_deg_reg[8]_0 -pinBusAttr heading_deg_reg[8]_1 @name heading_deg_reg[8]_1 -pinBusAttr heading_deg_reg[8]_rep_5 @name heading_deg_reg[8]_rep_5 -pinBusAttr heading_pendente_reg[8]_0 @name heading_pendente_reg[8]_0 -pinBusAttr hud_pixel_x @name hud_pixel_x[7:0] -pinBusAttr hud_pixel_y @name hud_pixel_y[9:0] -pinBusAttr metadados_reg[15]_0 @name metadados_reg[15]_0[11:0] -pinBusAttr mira_x_reg[9]_0 @name mira_x_reg[9]_0[9:0] -pinBusAttr mira_y_reg[8]_0 @name mira_y_reg[8]_0[8:0] -pinBusAttr velocidade_kt_reg[1]_0 @name velocidade_kt_reg[1]_0[1:0] -pg 1 -lvl 3 -x 6290 -y 50
load inst u_simbologia simbologia_vga work:simbologia_vga:NOFILE -attr @cell(#1c1f28) simbologia_vga -pinBusAttr B @name B[10:0] -pinBusAttr Q @name Q[26:0] -pinBusAttr sine @name sine[15:0] -pinBusAttr u @name u[10:0] -pg 1 -lvl 5 -x 16670 -y 9250
load inst u_ui_test ddr2_ui_smoke_top work:ddr2_ui_smoke_top:NOFILE -attr @cell(#1c1f28) ddr2_ui_smoke_top -pinBusAttr CO @name CO -pinBusAttr D @name D[11:0] -pinBusAttr FSM_onehot_state_reg[1]_0 @name FSM_onehot_state_reg[1]_0 -pinBusAttr S @name S[3:0] -pinBusAttr SR @name SR -pinBusAttr app_addr @name app_addr[15:0] -pinBusAttr app_cmd @name app_cmd -pinBusAttr ddr2_addr @name ddr2_addr[12:0] -pinBusAttr ddr2_ba @name ddr2_ba[2:0] -pinBusAttr ddr2_ck_n @name ddr2_ck_n -pinBusAttr ddr2_ck_p @name ddr2_ck_p -pinBusAttr ddr2_cke @name ddr2_cke -pinBusAttr ddr2_cs_n @name ddr2_cs_n -pinBusAttr ddr2_dm @name ddr2_dm[1:0] -pinBusAttr ddr2_dq @name ddr2_dq[15:0] -pinBusAttr ddr2_dqs_n @name ddr2_dqs_n[1:0] -pinBusAttr ddr2_dqs_p @name ddr2_dqs_p[1:0] -pinBusAttr ddr2_odt @name ddr2_odt -pinBusAttr din @name din[128:0] -pinBusAttr dout @name dout[128:0] -pinBusAttr gen_rd_b.gen_doutb_pipe.gen_stage.doutb_pipe_reg[0][144] @name gen_rd_b.gen_doutb_pipe.gen_stage.doutb_pipe_reg[0][144] -pinBusAttr last_data_reg[105] @name last_data_reg[105][3:0] -pinBusAttr last_data_reg[117] @name last_data_reg[117][3:0] -pinBusAttr last_data_reg[125] @name last_data_reg[125][1:0] -pinBusAttr last_data_reg[21] @name last_data_reg[21][3:0] -pinBusAttr last_data_reg[34] @name last_data_reg[34][3:0] -pinBusAttr last_data_reg[45] @name last_data_reg[45][3:0] -pinBusAttr last_data_reg[57] @name last_data_reg[57][3:0] -pinBusAttr last_data_reg[69] @name last_data_reg[69][3:0] -pinBusAttr last_data_reg[81] @name last_data_reg[81][3:0] -pinBusAttr last_data_reg[95] @name last_data_reg[95][3:0] -pinBusAttr out @name out -pinBusAttr wr_data2_carry__9 @name wr_data2_carry__9[125:0] -pg 1 -lvl 6 -x 17670 -y 170
load inst g_native_video.u_native hud_sd_ddr2_video work:hud_sd_ddr2_video:NOFILE -attr @cell(#1c1f28) hud_sd_ddr2_video -pinBusAttr ADDRA @name ADDRA[4:0] -pinBusAttr AS @name AS -pinBusAttr AS @marks img:DontTouch -pinBusAttr CO @name CO -pinBusAttr D @name D[12:0] -pinBusAttr DDR2_STATUS_LED_OBUF @name DDR2_STATUS_LED_OBUF -pinBusAttr E @name E -pinBusAttr Q @name Q -pinBusAttr S @name S[3:0] -pinBusAttr SD_SEG_OBUF[6]_inst_i_114 @name SD_SEG_OBUF[6]_inst_i_114[1:0] -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr VGA_B_OBUF @name VGA_B_OBUF[1:0] -pinBusAttr VGA_R_OBUF @name VGA_R_OBUF[2:0] -pinBusAttr app_addr @name app_addr[15:0] -pinBusAttr app_cmd @name app_cmd -pinBusAttr capture_hud_rgb @name capture_hud_rgb[3:0] -pinBusAttr diag_reason_reg[6] @name diag_reason_reg[6] -pinBusAttr diag_status_reg[31] @name diag_status_reg[31][17:0] -pinBusAttr din @name din[128:0] -pinBusAttr dout @name dout[128:0] -pinBusAttr even_tag_reg[7] @name even_tag_reg[7] -pinBusAttr even_tag_reg[7]_0 @name even_tag_reg[7]_0 -pinBusAttr even_tag_reg[9] @name even_tag_reg[9][6:0] -pinBusAttr fetch_line_reg[9] @name fetch_line_reg[9] -pinBusAttr fetch_line_reg[9]_0 @name fetch_line_reg[9]_0[9:0] -pinBusAttr future_x @name future_x -pinBusAttr g_native_video.pixel_reset_pipe_reg[1] @name g_native_video.pixel_reset_pipe_reg[1] -pinBusAttr gen_rd_b.gen_rd_b_synth_template.gen_rf_narrow_pipe.doutb_reg_reg[0] @name gen_rd_b.gen_rd_b_synth_template.gen_rf_narrow_pipe.doutb_reg_reg[0] -pinBusAttr last_data_reg[125] @name last_data_reg[125][125:0] -pinBusAttr last_sector_reg[7] @name last_sector_reg[7][1:0] -pinBusAttr last_word_reg[15] @name last_word_reg[15] -pinBusAttr line_valid_reg @name line_valid_reg -pinBusAttr odd_tag_reg[9] @name odd_tag_reg[9][6:0] -pinBusAttr odd_tag_reg[9]_0 @name odd_tag_reg[9]_0 -pinBusAttr out @name out -pinBusAttr p_0_in__1 @name p_0_in__1[3:0] -pinBusAttr pending_index_reg[12] @name pending_index_reg[12][12:0] -pinBusAttr pending_rgb332_reg @name pending_rgb332_reg -pinBusAttr pixel_word_reg[127] @name pixel_word_reg[127] -pinBusAttr profile @name profile[59:0] -pinBusAttr rd_word0 @name rd_word0 -pinBusAttr rx_reg[0] @name rx_reg[0] -pinBusAttr u_xpm_i_2__2 @name u_xpm_i_2__2[1:0] -pinBusAttr wr_data2_carry__1 @name wr_data2_carry__1[3:0] -pinBusAttr wr_data2_carry__2 @name wr_data2_carry__2[3:0] -pinBusAttr wr_data2_carry__3 @name wr_data2_carry__3[3:0] -pinBusAttr wr_data2_carry__4 @name wr_data2_carry__4[3:0] -pinBusAttr wr_data2_carry__5 @name wr_data2_carry__5[3:0] -pinBusAttr wr_data2_carry__6 @name wr_data2_carry__6[3:0] -pinBusAttr wr_data2_carry__7 @name wr_data2_carry__7[3:0] -pinBusAttr wr_data2_carry__8 @name wr_data2_carry__8[3:0] -pinBusAttr wr_data2_carry__9 @name wr_data2_carry__9[3:0] -pg 1 -lvl 5 -x 16670 -y 1350
load inst u_vga vga_controller work:vga_controller:NOFILE -attr @cell(#1c1f28) vga_controller -pinBusAttr ADDRA @name ADDRA[4:0] -pinBusAttr CO @name CO -pinBusAttr D @name D -pinBusAttr DI @name DI -pinBusAttr O @name O[2:0] -pinBusAttr P @name P[17:0] -pinBusAttr Q @name Q[8:0] -pinBusAttr S @name S[2:0] -pinBusAttr SS @name SS -pinBusAttr VGA_B_OBUF[3]_inst_i_18_0 @name VGA_B_OBUF[3]_inst_i_18_0[146:0] -pinBusAttr VGA_G_OBUF @name VGA_G_OBUF[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1102_0 @name VGA_R_OBUF[3]_inst_i_1102_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1158_0 @name VGA_R_OBUF[3]_inst_i_1158_0[17:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1158_1 @name VGA_R_OBUF[3]_inst_i_1158_1[17:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1158_2 @name VGA_R_OBUF[3]_inst_i_1158_2[19:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1158_3 @name VGA_R_OBUF[3]_inst_i_1158_3[19:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1158_4 @name VGA_R_OBUF[3]_inst_i_1158_4[19:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1205 @name VGA_R_OBUF[3]_inst_i_1205[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1435_0 @name VGA_R_OBUF[3]_inst_i_1435_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1631_0 @name VGA_R_OBUF[3]_inst_i_1631_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_1631_1 @name VGA_R_OBUF[3]_inst_i_1631_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_1631_2 @name VGA_R_OBUF[3]_inst_i_1631_2 -pinBusAttr VGA_R_OBUF[3]_inst_i_1631_3 @name VGA_R_OBUF[3]_inst_i_1631_3 -pinBusAttr VGA_R_OBUF[3]_inst_i_1661 @name VGA_R_OBUF[3]_inst_i_1661 -pinBusAttr VGA_R_OBUF[3]_inst_i_1691_0 @name VGA_R_OBUF[3]_inst_i_1691_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2146 @name VGA_R_OBUF[3]_inst_i_2146[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2260_0 @name VGA_R_OBUF[3]_inst_i_2260_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2268 @name VGA_R_OBUF[3]_inst_i_2268[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2271 @name VGA_R_OBUF[3]_inst_i_2271[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2272 @name VGA_R_OBUF[3]_inst_i_2272[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2274_0 @name VGA_R_OBUF[3]_inst_i_2274_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2873_0 @name VGA_R_OBUF[3]_inst_i_2873_0[16:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2873_1 @name VGA_R_OBUF[3]_inst_i_2873_1[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2873_2 @name VGA_R_OBUF[3]_inst_i_2873_2 -pinBusAttr VGA_R_OBUF[3]_inst_i_2888 @name VGA_R_OBUF[3]_inst_i_2888[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2903 @name VGA_R_OBUF[3]_inst_i_2903[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2918 @name VGA_R_OBUF[3]_inst_i_2918[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2933 @name VGA_R_OBUF[3]_inst_i_2933[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2986_0 @name VGA_R_OBUF[3]_inst_i_2986_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_321_0 @name VGA_R_OBUF[3]_inst_i_321_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_321_1 @name VGA_R_OBUF[3]_inst_i_321_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_3346_0 @name VGA_R_OBUF[3]_inst_i_3346_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3346_1 @name VGA_R_OBUF[3]_inst_i_3346_1[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3347_1 @name VGA_R_OBUF[3]_inst_i_3347_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_3347_2 @name VGA_R_OBUF[3]_inst_i_3347_2[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3347_3 @name VGA_R_OBUF[3]_inst_i_3347_3[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3347_4 @name VGA_R_OBUF[3]_inst_i_3347_4 -pinBusAttr VGA_R_OBUF[3]_inst_i_3348_0 @name VGA_R_OBUF[3]_inst_i_3348_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3348_1 @name VGA_R_OBUF[3]_inst_i_3348_1[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3348_2 @name VGA_R_OBUF[3]_inst_i_3348_2[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3349_0 @name VGA_R_OBUF[3]_inst_i_3349_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3349_1 @name VGA_R_OBUF[3]_inst_i_3349_1[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3349_2 @name VGA_R_OBUF[3]_inst_i_3349_2 -pinBusAttr VGA_R_OBUF[3]_inst_i_3349_3 @name VGA_R_OBUF[3]_inst_i_3349_3[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3407_1 @name VGA_R_OBUF[3]_inst_i_3407_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_3447_1 @name VGA_R_OBUF[3]_inst_i_3447_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_4013_0 @name VGA_R_OBUF[3]_inst_i_4013_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4041 @name VGA_R_OBUF[3]_inst_i_4041[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4072 @name VGA_R_OBUF[3]_inst_i_4072[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4103 @name VGA_R_OBUF[3]_inst_i_4103[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4140 @name VGA_R_OBUF[3]_inst_i_4140[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4192 @name VGA_R_OBUF[3]_inst_i_4192[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_41_0 @name VGA_R_OBUF[3]_inst_i_41_0[11:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4401_0 @name VGA_R_OBUF[3]_inst_i_4401_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4401_1 @name VGA_R_OBUF[3]_inst_i_4401_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4424_0 @name VGA_R_OBUF[3]_inst_i_4424_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4424_1 @name VGA_R_OBUF[3]_inst_i_4424_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4447_0 @name VGA_R_OBUF[3]_inst_i_4447_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4447_1 @name VGA_R_OBUF[3]_inst_i_4447_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4479_0 @name VGA_R_OBUF[3]_inst_i_4479_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4479_1 @name VGA_R_OBUF[3]_inst_i_4479_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4489 @name VGA_R_OBUF[3]_inst_i_4489[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4494 @name VGA_R_OBUF[3]_inst_i_4494[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4499 @name VGA_R_OBUF[3]_inst_i_4499[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4515_0 @name VGA_R_OBUF[3]_inst_i_4515_0[6:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4628_0 @name VGA_R_OBUF[3]_inst_i_4628_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4643_0 @name VGA_R_OBUF[3]_inst_i_4643_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4659_0 @name VGA_R_OBUF[3]_inst_i_4659_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4686_0 @name VGA_R_OBUF[3]_inst_i_4686_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4696_0 @name VGA_R_OBUF[3]_inst_i_4696_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4701_0 @name VGA_R_OBUF[3]_inst_i_4701_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4706_0 @name VGA_R_OBUF[3]_inst_i_4706_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_63_3 @name VGA_R_OBUF[3]_inst_i_63_3[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_835 @name VGA_R_OBUF[3]_inst_i_835 -pinBusAttr VGA_R_OBUF[3]_inst_i_835_0 @name VGA_R_OBUF[3]_inst_i_835_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_954 @name VGA_R_OBUF[3]_inst_i_954 -pinBusAttr VGA_R_OBUF[3]_inst_i_954_0 @name VGA_R_OBUF[3]_inst_i_954_0 -pinBusAttr even_tag_reg[9] @name even_tag_reg[9] -pinBusAttr frame_id @name frame_id[31:0] -pinBusAttr future_x @name future_x -pinBusAttr g1_b34_i_75_0 @name g1_b34_i_75_0[1:0] -pinBusAttr g1_b34_i_75_1 @name g1_b34_i_75_1[1:0] -pinBusAttr g_native_video.pixel_reset_pipe_reg[1] @name g_native_video.pixel_reset_pipe_reg[1] -pinBusAttr g_native_video.pixel_reset_pipe_reg[1]_0 @name g_native_video.pixel_reset_pipe_reg[1]_0 -pinBusAttr g_native_video.pixel_reset_pipe_reg[1]_1 @name g_native_video.pixel_reset_pipe_reg[1]_1 -pinBusAttr g_native_video.video_visible_reg_1 @name g_native_video.video_visible_reg_1 -pinBusAttr h_cont_reg[0]_rep_0 @name h_cont_reg[0]_rep_0 -pinBusAttr h_cont_reg[0]_rep_1 @name h_cont_reg[0]_rep_1 -pinBusAttr h_cont_reg[0]_rep_2 @name h_cont_reg[0]_rep_2 -pinBusAttr h_cont_reg[0]_rep_3 @name h_cont_reg[0]_rep_3 -pinBusAttr h_cont_reg[0]_rep_4 @name h_cont_reg[0]_rep_4[2:0] -pinBusAttr h_cont_reg[0]_rep__0_1 @name h_cont_reg[0]_rep__0_1[3:0] -pinBusAttr h_cont_reg[0]_rep__0_2 @name h_cont_reg[0]_rep__0_2[3:0] -pinBusAttr h_cont_reg[1]_rep__0_3 @name h_cont_reg[1]_rep__0_3[3:0] -pinBusAttr h_cont_reg[1]_rep__0_4 @name h_cont_reg[1]_rep__0_4[3:0] -pinBusAttr h_cont_reg[1]_rep__0_5 @name h_cont_reg[1]_rep__0_5[3:0] -pinBusAttr h_cont_reg[1]_rep__0_6 @name h_cont_reg[1]_rep__0_6[3:0] -pinBusAttr h_cont_reg[1]_rep__0_8 @name h_cont_reg[1]_rep__0_8[3:0] -pinBusAttr h_cont_reg[1]_rep__0_9 @name h_cont_reg[1]_rep__0_9[3:0] -pinBusAttr h_cont_reg[1]_rep__1_1 @name h_cont_reg[1]_rep__1_1 -pinBusAttr h_cont_reg[1]_rep__1_2 @name h_cont_reg[1]_rep__1_2 -pinBusAttr h_cont_reg[1]_rep__1_4 @name h_cont_reg[1]_rep__1_4[2:0] -pinBusAttr h_cont_reg[1]_rep__1_5 @name h_cont_reg[1]_rep__1_5[3:0] -pinBusAttr h_cont_reg[2]_rep_0 @name h_cont_reg[2]_rep_0 -pinBusAttr h_cont_reg[2]_rep_1 @name h_cont_reg[2]_rep_1[1:0] -pinBusAttr h_cont_reg[2]_rep_2 @name h_cont_reg[2]_rep_2 -pinBusAttr h_cont_reg[2]_rep_3 @name h_cont_reg[2]_rep_3 -pinBusAttr h_cont_reg[2]_rep_4 @name h_cont_reg[2]_rep_4[2:0] -pinBusAttr h_cont_reg[2]_rep_5 @name h_cont_reg[2]_rep_5[2:0] -pinBusAttr h_cont_reg[2]_rep_6 @name h_cont_reg[2]_rep_6 -pinBusAttr h_cont_reg[2]_rep__0_1 @name h_cont_reg[2]_rep__0_1[3:0] -pinBusAttr h_cont_reg[2]_rep__1_0 @name h_cont_reg[2]_rep__1_0[3:0] -pinBusAttr h_cont_reg[2]_rep__2_1 @name h_cont_reg[2]_rep__2_1[3:0] -pinBusAttr h_cont_reg[2]_rep__2_2 @name h_cont_reg[2]_rep__2_2[3:0] -pinBusAttr h_cont_reg[3]_rep_4 @name h_cont_reg[3]_rep_4[3:0] -pinBusAttr h_cont_reg[3]_rep__1_1 @name h_cont_reg[3]_rep__1_1[2:0] -pinBusAttr h_cont_reg[3]_rep__1_2 @name h_cont_reg[3]_rep__1_2[2:0] -pinBusAttr h_cont_reg[3]_rep__1_3 @name h_cont_reg[3]_rep__1_3[2:0] -pinBusAttr h_cont_reg[3]_rep__1_4 @name h_cont_reg[3]_rep__1_4[3:0] -pinBusAttr h_cont_reg[5]_rep_2 @name h_cont_reg[5]_rep_2 -pinBusAttr h_cont_reg[5]_rep__0_0 @name h_cont_reg[5]_rep__0_0[1:0] -pinBusAttr h_cont_reg[6]_3 @name h_cont_reg[6]_3[1:0] -pinBusAttr h_cont_reg[6]_5 @name h_cont_reg[6]_5 -pinBusAttr h_cont_reg[6]_6 @name h_cont_reg[6]_6 -pinBusAttr h_cont_reg[6]_7 @name h_cont_reg[6]_7[1:0] -pinBusAttr h_cont_reg[7]_0 @name h_cont_reg[7]_0[4:0] -pinBusAttr h_cont_reg[7]_1 @name h_cont_reg[7]_1[1:0] -pinBusAttr h_cont_reg[7]_2 @name h_cont_reg[7]_2[1:0] -pinBusAttr h_cont_reg[7]_3 @name h_cont_reg[7]_3[1:0] -pinBusAttr h_cont_reg[7]_4 @name h_cont_reg[7]_4[3:0] -pinBusAttr h_cont_reg[7]_5 @name h_cont_reg[7]_5 -pinBusAttr h_cont_reg[7]_6 @name h_cont_reg[7]_6 -pinBusAttr h_cont_reg[7]_7 @name h_cont_reg[7]_7 -pinBusAttr h_cont_reg[8]_0 @name h_cont_reg[8]_0 -pinBusAttr h_cont_reg[9]_0 @name h_cont_reg[9]_0 -pinBusAttr h_cont_reg[9]_1 @name h_cont_reg[9]_1 -pinBusAttr h_cont_reg[9]_2 @name h_cont_reg[9]_2 -pinBusAttr h_cont_reg[9]_3 @name h_cont_reg[9]_3 -pinBusAttr h_cont_reg[9]_4 @name h_cont_reg[9]_4 -pinBusAttr h_cont_reg[9]_5 @name h_cont_reg[9]_5 -pinBusAttr h_cont_reg[9]_6 @name h_cont_reg[9]_6 -pinBusAttr h_cont_reg[9]_7 @name h_cont_reg[9]_7 -pinBusAttr h_cont_reg[9]_8 @name h_cont_reg[9]_8 -pinBusAttr heading_deg_reg[7] @name heading_deg_reg[7][2:0] -pinBusAttr heading_deg_reg[8]_rep @name heading_deg_reg[8]_rep[1:0] -pinBusAttr hud_pixel_x @name hud_pixel_x[3:0] -pinBusAttr hud_pixel_y @name hud_pixel_y[1:0] -pinBusAttr i__i_43_0 @name i__i_43_0 -pinBusAttr i__i_43_1 @name i__i_43_1 -pinBusAttr i__i_8_0 @name i__i_8_0[131:0] -pinBusAttr line_valid_reg @name line_valid_reg -pinBusAttr mira_lock_reg @name mira_lock_reg[3:0] -pinBusAttr missing_lines_reg[0]_i_3_0 @name missing_lines_reg[0]_i_3_0[6:0] -pinBusAttr missing_lines_reg[0]_i_3_1 @name missing_lines_reg[0]_i_3_1[6:0] -pinBusAttr missing_lines_reg[31] @name missing_lines_reg[31] -pinBusAttr offset_y @name offset_y[7:0] -pinBusAttr p_0_in__1 @name p_0_in__1[3:0] -pinBusAttr u_i_21 @name u_i_21[1:0] -pinBusAttr u_i_47_0 @name u_i_47_0 -pinBusAttr v_cont_reg[0]_0 @name v_cont_reg[0]_0 -pinBusAttr v_cont_reg[0]_1 @name v_cont_reg[0]_1[3:0] -pinBusAttr v_cont_reg[0]_2 @name v_cont_reg[0]_2 -pinBusAttr v_cont_reg[3]_0 @name v_cont_reg[3]_0[3:0] -pinBusAttr v_cont_reg[7]_rep_0 @name v_cont_reg[7]_rep_0[9:0] -pinBusAttr v_cont_reg[7]_rep__0_0 @name v_cont_reg[7]_rep__0_0[3:0] -pinBusAttr v_cont_reg[7]_rep__0_2 @name v_cont_reg[7]_rep__0_2 -pinBusAttr v_cont_reg[9]_0 @name v_cont_reg[9]_0[1:0] -pinBusAttr v_cont_reg[9]_1 @name v_cont_reg[9]_1 -pinBusAttr xc_i_18_0 @name xc_i_18_0[7:0] -pg 1 -lvl 4 -x 12680 -y 2270
load net u_dados_n_25 -attr @rip heading_deg_reg[0]_1[1] -pin u_dados heading_deg_reg[0]_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2986_0[1]
load net u_dados_n_308 -pin u_dados VGA_R_OBUF[3]_inst_i_1472_0 -pin u_vga VGA_R_OBUF[3]_inst_i_394_1
netloc u_dados_n_308 1 3 1 12040 240n
load net u_dados_n_55 -attr @rip heading_deg_reg[0]_4[3] -pin u_dados heading_deg_reg[0]_4[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4706_0[3]
load net u_dados_n_172 -pin u_dados metadados_reg[12]_2 -pin u_vga VGA_G_OBUF[3]_inst_i_20_3
netloc u_dados_n_172 1 3 1 11140 2600n
load net u_vga_n_88 -attr @rip h_cont_reg[0]_rep_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2248_0[0] -pin u_vga h_cont_reg[0]_rep_3[0]
netloc u_vga_n_88 1 2 3 6020 4760 7380J 940 14700
load net u_vga_n_287 -attr @rip h_cont_reg[1]_rep__0_9[2] -pin u_dados VGA_R_OBUF[3]_inst_i_771_0[2] -pin u_vga h_cont_reg[1]_rep__0_9[2]
load net capture_hud_rgb[6] -attr @rip mira_lock_reg[1] -pin g_native_video.u_native capture_hud_rgb[1] -pin u_vga mira_lock_reg[1]
load net compass_gravity_y[8] -attr @rip gravity_y_reg[23]_0[8] -pin g_mag_tilt.u_heading gy_reg[24]_0[8] -pin u_vector gravity_y_reg[23]_0[8]
load net hud_pixel_x[4] -attr @style dashed -attr @rip hud_pixel_x[4] -pin u_dados hud_pixel_x[4] -pin u_simbologia B[4]
load net mpu_gyro_z[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[8] -pin u_sensor accel_x_reg[15]_0[8] -pin u_vector a_reg[0][15]_0[8]
load net mpu_raw_gy[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[24] -pin u_sensor accel_x_reg[15]_0[24] -pin u_vector a_reg[0][15]_0[24]
load net mira_x_in[7] -attr @rip Q[7] -pin u_dados Q[7] -pin u_entrada Q[7]
load net memory_and_vga/bridge/last_data[6] -attr @rip last_data_reg[125][6] -pin g_native_video.u_native last_data_reg[125][6] -pin u_ui_test wr_data2_carry__9[6]
load net memory_and_vga/bridge/last_data[70] -attr @rip last_data_reg[125][70] -pin g_native_video.u_native last_data_reg[125][70] -pin u_ui_test wr_data2_carry__9[70]
load net native_app_rd_data[104] -attr @rip din[104] -pin g_native_video.u_native din[104] -pin u_ui_test din[104]
load net native_app_wdf_data[104] -attr @rip dout[104] -pin g_native_video.u_native dout[104] -pin u_ui_test dout[104]
load net native_app_wdf_data[40] -attr @rip dout[40] -pin g_native_video.u_native dout[40] -pin u_ui_test dout[40]
load net native_app_rd_data[40] -attr @rip din[40] -pin g_native_video.u_native din[40] -pin u_ui_test din[40]
load net roll_fallback_q10_next[17] -attr @rip roll_sync_reg[0]_0[17] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[17] -pin u_vector roll_sync_reg[0]_0[17]
load net pixel_x[6] -attr @rip Q[5] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[4] -pin u_vga Q[5]
load net pitch_fallback_q10[0] -attr @rip pitch_fallback_q10_reg[31]_1[0] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[0] -pin u_vector pw_reg[0]
load net vector_pitch[31] -attr @style dashed -attr @rip roll_reg[31]_0[12] -pin g_operacao.u_operacao meta_reg[3][12] -pin u_vector roll_reg[31]_0[12]
load net samples_reg[2][1] -attr @rip samples_reg[2][7]_0[9] -pin u_sensor samples_reg[2][7]_0[9] -pin u_vector p_1_in_1[9]
load net u_dados_n_309 -pin u_dados altitude_ft_reg[3]_10 -pin u_vga VGA_R_OBUF[3]_inst_i_773_0
netloc u_dados_n_309 1 3 1 8620 1500n
load net u_dados_n_250 -attr @rip VGA_R_OBUF[3]_inst_i_3440_0[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3440_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_3[2]
load net u_dados_n_56 -attr @rip heading_deg_reg[0]_4[2] -pin u_dados heading_deg_reg[0]_4[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4706_0[2]
load net u_dados_n_173 -pin u_dados metadados_reg[25]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_32_0
netloc u_dados_n_173 1 3 1 11400 2840n
load net g_native_video.u_native_n_396 -attr @rip even_tag_reg[9][6] -pin g_native_video.u_native even_tag_reg[9][6] -pin u_vga missing_lines_reg[0]_i_3_1[6]
load net u_vga_n_15 -pin u_dados VGA_R_OBUF[3]_inst_i_1167_0 -pin u_vga h_cont_reg[1]_rep__0_0
netloc u_vga_n_15 1 2 3 5480 4360 9580J 540 14860
load net u_vga_n_89 -attr @rip h_cont_reg[9]_7[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3560_0[0] -pin u_vga h_cont_reg[9]_7[0]
netloc u_vga_n_89 1 2 3 4800 8620 NJ 8620 14980
load net u_vga_n_23 -pin u_dados VGA_R_OBUF[3]_inst_i_408_1 -pin u_vga v_cont_reg[2]_0
netloc u_vga_n_23 1 2 3 4160 8980 NJ 8980 14540
load net u_vga_n_288 -attr @rip h_cont_reg[1]_rep__0_9[1] -pin u_dados VGA_R_OBUF[3]_inst_i_771_0[1] -pin u_vga h_cont_reg[1]_rep__0_9[1]
load net compass_gravity_y[10] -attr @rip gravity_y_reg[23]_0[10] -pin g_mag_tilt.u_heading gy_reg[24]_0[10] -pin u_vector gravity_y_reg[23]_0[10]
load net hud_pixel_x[6] -attr @style dashed -attr @rip hud_pixel_x[5] -pin u_dados hud_pixel_x[5] -pin u_vga hud_pixel_x[1]
load net mpu_raw_gy[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[26] -pin u_sensor accel_x_reg[15]_0[26] -pin u_vector a_reg[0][15]_0[26]
load net native_app_rd_data[41] -attr @rip din[41] -pin g_native_video.u_native din[41] -pin u_ui_test din[41]
load net mpu_gyro_z[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[10] -pin u_sensor accel_x_reg[15]_0[10] -pin u_vector a_reg[0][15]_0[10]
load net mira_x_in[8] -attr @rip Q[8] -pin u_dados Q[8] -pin u_entrada Q[8]
load net memory_and_vga/bridge/last_data[71] -attr @rip last_data_reg[125][71] -pin g_native_video.u_native last_data_reg[125][71] -pin u_ui_test wr_data2_carry__9[71]
load net memory_and_vga/vga/A[9] -attr @rip v_cont_reg[7]_rep_0[9] -pin g_native_video.u_native fetch_line_reg[9]_0[9] -pin u_vga v_cont_reg[7]_rep_0[9]
load net memory_and_vga/bridge/last_data[9] -attr @rip last_data_reg[125][9] -pin g_native_video.u_native last_data_reg[125][9] -pin u_ui_test wr_data2_carry__9[9]
load net native_app_rd_data[105] -attr @rip din[105] -pin g_native_video.u_native din[105] -pin u_ui_test din[105]
load net native_app_wdf_data[105] -attr @rip dout[105] -pin g_native_video.u_native dout[105] -pin u_ui_test dout[105]
load net native_app_wdf_data[41] -attr @rip dout[41] -pin g_native_video.u_native dout[41] -pin u_ui_test dout[41]
load net roll_fallback_q10_next[18] -attr @rip roll_sync_reg[0]_0[18] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[18] -pin u_vector roll_sync_reg[0]_0[18]
load net samples_reg[2][2] -attr @rip samples_reg[2][7]_0[10] -pin u_sensor samples_reg[2][7]_0[10] -pin u_vector p_1_in_1[10]
load net pixel_x[7] -attr @rip Q[6] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[5] -pin u_vga Q[6]
load net pitch_fallback_q10[1] -attr @rip pitch_fallback_q10_reg[31]_1[1] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[1] -pin u_vector pw_reg[1]
load net sensor_ok -attr @style dashed -attr @rip D[0] -pin u_sensor D[0] -pin u_vector video_startup_ready_reg_1[0] -pin u_vga D[0]
netloc sensor_ok 1 1 3 1490 3920 3440J 4820 9740
load net u_entrada_n_93 -attr @rip dados_destino_reg[17]_1[1] -pin u_dados alvo_y_pendente_reg[4]_0[1] -pin u_entrada dados_destino_reg[17]_1[1]
load net u_dados_n_248 -attr @rip VGA_R_OBUF[3]_inst_i_3420_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3420_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3346_1[0]
load net u_dados_n_53 -attr @rip VGA_R_OBUF[3]_inst_i_4091_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4091_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4499[1]
load net u_dados_n_306 -pin u_dados altitude_ft_reg[3]_8 -pin u_vga VGA_R_OBUF[3]_inst_i_773_1
netloc u_dados_n_306 1 3 1 9120 1460n
load net u_dados_n_170 -pin u_dados metadados_reg[12]_1 -pin u_vga VGA_G_OBUF[3]_inst_i_20_1
netloc u_dados_n_170 1 3 1 10780 2560n
load net u_vga_n_227 -attr @style dashed -pin u_dados VGA_R_OBUF[3]_inst_i_3349 -pin u_vga v_cont_reg[5]_rep__0_1
netloc u_vga_n_227 1 2 3 4080 9040 NJ 9040 14480
load net u_vector_n_117 -pin u_sensor stale_reg_0_sp_1 -pin u_vector FSM_sequential_phase_reg[3]_0
netloc u_vector_n_117 1 0 3 60 6360 NJ 6360 2800
load net u_vga_n_86 -attr @rip h_cont_reg[0]_rep_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2238_0[0] -pin u_vga h_cont_reg[0]_rep_2[0]
netloc u_vga_n_86 1 2 3 6000 4740 7240J 920 14720
load net u_vga_n_285 -attr @rip VGA_R_OBUF[3]_inst_i_1102_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_776_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1102_0[0]
load net compass_gravity_y[9] -attr @rip gravity_y_reg[23]_0[9] -pin g_mag_tilt.u_heading gy_reg[24]_0[9] -pin u_vector gravity_y_reg[23]_0[9]
load net hud_pixel_x[2] -attr @style dashed -attr @rip hud_pixel_x[2] -pin u_dados hud_pixel_x[2] -pin u_simbologia B[2] -pin u_vga hud_pixel_x[0]
load net mpu_gyro_z[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[9] -pin u_sensor accel_x_reg[15]_0[9] -pin u_vector a_reg[0][15]_0[9]
load net mpu_raw_gy[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[25] -pin u_sensor accel_x_reg[15]_0[25] -pin u_vector a_reg[0][15]_0[25]
load net memory_and_vga/bridge/last_data[4] -attr @rip last_data_reg[125][4] -pin g_native_video.u_native last_data_reg[125][4] -pin u_ui_test wr_data2_carry__9[4]
load net mira_x_in[6] -attr @rip Q[6] -pin u_dados Q[6] -pin u_entrada Q[6]
load net memory_and_vga/vga/A[7] -attr @rip v_cont_reg[7]_rep_0[7] -pin g_native_video.u_native fetch_line_reg[9]_0[7] -pin u_vga v_cont_reg[7]_rep_0[7]
load net memory_and_vga/bridge/last_data[68] -attr @rip last_data_reg[125][68] -pin g_native_video.u_native last_data_reg[125][68] -pin u_ui_test wr_data2_carry__9[68]
load net native_app_rd_data[102] -attr @rip din[102] -pin g_native_video.u_native din[102] -pin u_ui_test din[102]
load net native_app_wdf_data[102] -attr @rip dout[102] -pin g_native_video.u_native dout[102] -pin u_ui_test dout[102]
load net native_app_wdf_data[38] -attr @rip dout[38] -pin g_native_video.u_native dout[38] -pin u_ui_test dout[38]
load net native_app_rd_data[38] -attr @rip din[38] -pin g_native_video.u_native din[38] -pin u_ui_test din[38]
load net samples_reg[1][7] -attr @rip B[7] -pin u_sensor B[7] -pin u_vector B[7]
load net roll_fallback_q10_next[15] -attr @rip roll_sync_reg[0]_0[15] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[15] -pin u_vector roll_sync_reg[0]_0[15]
load net vector_pitch[24] -attr @style dashed -attr @rip roll_reg[31]_0[10] -pin g_operacao.u_operacao meta_reg[3][10] -pin u_vector roll_reg[31]_0[10]
load net pixel_x[4] -attr @rip Q[3] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[2] -pin u_vga Q[3]
load net u_entrada_n_94 -attr @rip dados_destino_reg[17]_1[0] -pin u_dados alvo_y_pendente_reg[4]_0[0] -pin u_entrada dados_destino_reg[17]_1[0]
load net u_dados_n_249 -attr @rip VGA_R_OBUF[3]_inst_i_3440_0[3] -pin u_dados VGA_R_OBUF[3]_inst_i_3440_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_3[3]
load net u_dados_n_54 -attr @rip VGA_R_OBUF[3]_inst_i_4091_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4091_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4499[0]
load net u_dados_n_307 -pin u_dados altitude_ft_reg[3]_9 -pin u_vga VGA_R_OBUF[3]_inst_i_775_1
netloc u_dados_n_307 1 3 1 8880 1480n
load net u_dados_n_171 -pin u_dados v_cont_reg[0] -pin u_vga VGA_G_OBUF[3]_inst_i_20_2
netloc u_dados_n_171 1 3 1 11260 2580n
load net u_vga_n_228 -attr @style dashed -pin u_dados VGA_R_OBUF[3]_inst_i_1631_1 -pin u_vga v_cont_reg[7]_rep_2
netloc u_vga_n_228 1 2 3 3760 9140 NJ 9140 14280
load net u_vga_n_87 -attr @rip h_cont_reg[9]_6[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3533_0[0] -pin u_vga h_cont_reg[9]_6[0]
netloc u_vga_n_87 1 2 3 4840 8600 NJ 8600 15000
load net u_vga_n_286 -attr @rip h_cont_reg[1]_rep__0_9[3] -pin u_dados VGA_R_OBUF[3]_inst_i_771_0[3] -pin u_vga h_cont_reg[1]_rep__0_9[3]
load net capture_hud_rgb[3] -attr @rip mira_lock_reg[0] -pin g_native_video.u_native capture_hud_rgb[0] -pin u_vga mira_lock_reg[0]
load net compass_gravity_y[7] -attr @rip gravity_y_reg[23]_0[7] -pin g_mag_tilt.u_heading gy_reg[24]_0[7] -pin u_vector gravity_y_reg[23]_0[7]
load net hud_pixel_x[3] -attr @style dashed -attr @rip hud_pixel_x[3] -pin u_dados hud_pixel_x[3] -pin u_simbologia B[3]
load net mpu_raw_gy[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[23] -pin u_sensor accel_x_reg[15]_0[23] -pin u_vector a_reg[0][15]_0[23]
load net native_app_rd_data[39] -attr @rip din[39] -pin g_native_video.u_native din[39] -pin u_ui_test din[39]
load net mpu_gyro_z[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[7] -pin u_sensor accel_x_reg[15]_0[7] -pin u_vector a_reg[0][15]_0[7]
load net memory_and_vga/bridge/last_data[5] -attr @rip last_data_reg[125][5] -pin g_native_video.u_native last_data_reg[125][5] -pin u_ui_test wr_data2_carry__9[5]
load net memory_and_vga/bridge/last_data[69] -attr @rip last_data_reg[125][69] -pin g_native_video.u_native last_data_reg[125][69] -pin u_ui_test wr_data2_carry__9[69]
load net memory_and_vga/vga/A[8] -attr @rip v_cont_reg[7]_rep_0[8] -pin g_native_video.u_native fetch_line_reg[9]_0[8] -pin u_vga v_cont_reg[7]_rep_0[8]
load net mira_x_in[9] -attr @rip Q[9] -pin u_dados Q[9] -pin u_entrada Q[9]
load net native_app_rd_data[103] -attr @rip din[103] -pin g_native_video.u_native din[103] -pin u_ui_test din[103]
load net native_app_wdf_data[103] -attr @rip dout[103] -pin g_native_video.u_native dout[103] -pin u_ui_test dout[103]
load net native_app_wdf_data[39] -attr @rip dout[39] -pin g_native_video.u_native dout[39] -pin u_ui_test dout[39]
load net roll_fallback_q10_next[16] -attr @rip roll_sync_reg[0]_0[16] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[16] -pin u_vector roll_sync_reg[0]_0[16]
load net pixel_x[5] -attr @rip Q[4] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[3] -pin u_vga Q[4]
load net vector_pitch[25] -attr @style dashed -attr @rip roll_reg[31]_0[11] -pin g_operacao.u_operacao meta_reg[3][11] -pin u_vector roll_reg[31]_0[11]
load net samples_reg[2][0] -attr @rip samples_reg[2][7]_0[8] -pin u_sensor samples_reg[2][7]_0[8] -pin u_vector p_1_in_1[8]
load net u_dados_n_311 -pin u_dados VGA_R_OBUF[3]_inst_i_2021_0 -pin u_vga VGA_R_OBUF[3]_inst_i_780_2
netloc u_dados_n_311 1 3 1 11860 440n
load net u_dados_n_253 -attr @rip VGA_R_OBUF[3]_inst_i_2869_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_2[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3447_1[0]
netloc u_dados_n_253 1 3 1 9040 740n
load net u_dados_n_59 -attr @rip h_cont_reg[9]_2[3] -pin u_dados h_cont_reg[9]_2[3] -pin u_vga VGA_R_OBUF[3]_inst_i_2933[3]
load net u_dados_n_176 -pin u_dados metadados_reg[25]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_32_1
netloc u_dados_n_176 1 3 1 11440 2860n
load net g_native_video.u_native_n_399 -attr @rip even_tag_reg[9][3] -pin g_native_video.u_native even_tag_reg[9][3] -pin u_vga missing_lines_reg[0]_i_3_1[3]
load net u_vector_n_244 -pin g_operacao.u_operacao pw_reg -pin u_vector pitch_fallback_q10_reg[31]
netloc u_vector_n_244 1 0 3 240 6400 NJ 6400 2680
load net u_vga_n_232 -pin u_dados VGA_R_OBUF[3]_inst_i_3346_0 -pin u_vga v_cont_reg[5]_rep__0_3
netloc u_vga_n_232 1 2 3 4000 9060 NJ 9060 14460
load net u_vga_n_290 -attr @rip h_cont_reg[6]_7[1] -pin u_dados VGA_R_OBUF[3]_inst_i_394[1] -pin u_vga h_cont_reg[6]_7[1]
load net u_vga_n_92 -attr @rip heading_deg_reg[7][0] -pin u_dados VGA_R_OBUF[3]_inst_i_840_0[0] -pin u_vga heading_deg_reg[7][0]
load net compass_gravity_y[13] -attr @rip gravity_y_reg[23]_0[13] -pin g_mag_tilt.u_heading gy_reg[24]_0[13] -pin u_vector gravity_y_reg[23]_0[13]
load net hud_pixel_x[8] -attr @style dashed -attr @rip hud_pixel_x[6] -pin u_dados hud_pixel_x[6] -pin u_vga hud_pixel_x[2]
load net mpu_gyro_z[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[13] -pin u_sensor accel_x_reg[15]_0[13] -pin u_vector a_reg[0][15]_0[13]
load net mpu_raw_gy[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[29] -pin u_sensor accel_x_reg[15]_0[29] -pin u_vector a_reg[0][15]_0[29]
load net memory_and_vga/bridge/last_data[10] -attr @rip last_data_reg[125][10] -pin g_native_video.u_native last_data_reg[125][10] -pin u_ui_test wr_data2_carry__9[10]
load net memory_and_vga/bridge/last_data[74] -attr @rip last_data_reg[125][74] -pin g_native_video.u_native last_data_reg[125][74] -pin u_ui_test wr_data2_carry__9[74]
load net memory_and_vga/vga/future_word[2] -attr @rip ADDRA[2] -pin g_native_video.u_native ADDRA[2] -pin u_vga ADDRA[2]
load net native_app_rd_data[108] -attr @rip din[108] -pin g_native_video.u_native din[108] -pin u_ui_test din[108]
load net native_app_rd_data[44] -attr @rip din[44] -pin g_native_video.u_native din[44] -pin u_ui_test din[44]
load net native_app_wdf_data[108] -attr @rip dout[108] -pin g_native_video.u_native dout[108] -pin u_ui_test dout[108]
load net native_app_wdf_data[44] -attr @rip dout[44] -pin g_native_video.u_native dout[44] -pin u_ui_test dout[44]
load net roll_fallback_q10_next[21] -attr @rip roll_sync_reg[0]_0[21] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[21] -pin u_vector roll_sync_reg[0]_0[21]
load net samples_reg[2][5] -attr @rip samples_reg[2][7]_0[13] -pin u_sensor samples_reg[2][7]_0[13] -pin u_vector p_1_in_1[13]
load net vector_roll[12] -attr @style dashed -attr @rip roll_reg[31]_0[17] -pin g_operacao.u_operacao meta_reg[3][17] -pin u_vector roll_reg[31]_0[17]
load net pitch_fallback_q10[4] -attr @rip pitch_fallback_q10_reg[31]_1[4] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[4] -pin u_vector pw_reg[4]
load net pixel_x[9] -attr @style dashed -attr @rip Q[8] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[7] -pin u_vga Q[8]
load net u_dados_n_6 -attr @rip S[1] -pin u_dados S[1] -pin u_vga S[1]
load net u_dados_n_254 -attr @rip VGA_R_OBUF[3]_inst_i_2869_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_3[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_4[0]
netloc u_dados_n_254 1 3 1 9340 760n
load net u_dados_n_312 -pin u_dados altitude_ft_reg[16]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_780_3
netloc u_dados_n_312 1 3 1 9540 1700n
load net u_dados_n_177 -pin u_dados metadados_reg[12]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_77_1
netloc u_dados_n_177 1 3 1 7540 3100n
load net g_native_video.u_native_n_400 -attr @rip even_tag_reg[9][2] -pin g_native_video.u_native even_tag_reg[9][2] -pin u_vga missing_lines_reg[0]_i_3_1[2]
load net u_vector_n_245 -pin g_operacao.u_operacao pw_reg_0 -pin u_vector pitch_fallback_q10_reg[31]_0
netloc u_vector_n_245 1 0 3 260 6420 NJ 6420 2660
load net u_vga_n_233 -pin u_dados VGA_R_OBUF[3]_inst_i_3349_0 -pin u_vga v_cont_reg[8]_1
netloc u_vga_n_233 1 2 3 3600 9220 NJ 9220 14000
load net u_vga_n_93 -pin u_dados VGA_R_OBUF[3]_inst_i_1204_1 -pin u_vga heading_deg_reg[8]_rep_3
netloc u_vga_n_93 1 2 3 4740 8780 NJ 8780 14800
load net u_vga_n_291 -attr @rip h_cont_reg[6]_7[0] -pin u_dados VGA_R_OBUF[3]_inst_i_394[0] -pin u_vga h_cont_reg[6]_7[0]
load net compass_gravity_y[14] -attr @rip gravity_y_reg[23]_0[14] -pin g_mag_tilt.u_heading gy_reg[24]_0[14] -pin u_vector gravity_y_reg[23]_0[14]
load net mpu_gyro_z[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[14] -pin u_sensor accel_x_reg[15]_0[14] -pin u_vector a_reg[0][15]_0[14]
load net memory_and_vga/bridge/last_data[11] -attr @rip last_data_reg[125][11] -pin g_native_video.u_native last_data_reg[125][11] -pin u_ui_test wr_data2_carry__9[11]
load net memory_and_vga/bridge/last_data[75] -attr @rip last_data_reg[125][75] -pin g_native_video.u_native last_data_reg[125][75] -pin u_ui_test wr_data2_carry__9[75]
load net memory_and_vga/vga/future_word[3] -attr @rip ADDRA[3] -pin g_native_video.u_native ADDRA[3] -pin u_vga ADDRA[3]
load net mpu_raw_gy[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[30] -pin u_sensor accel_x_reg[15]_0[30] -pin u_vector a_reg[0][15]_0[30]
load net native_app_rd_data[109] -attr @rip din[109] -pin g_native_video.u_native din[109] -pin u_ui_test din[109]
load net native_app_wdf_data[109] -attr @rip dout[109] -pin g_native_video.u_native dout[109] -pin u_ui_test dout[109]
load net native_app_wdf_data[45] -attr @rip dout[45] -pin g_native_video.u_native dout[45] -pin u_ui_test dout[45]
load net native_app_rd_data[45] -attr @rip din[45] -pin g_native_video.u_native din[45] -pin u_ui_test din[45]
load net roll_fallback_q10_next[22] -attr @rip roll_sync_reg[0]_0[22] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[22] -pin u_vector roll_sync_reg[0]_0[22]
load net pitch_fallback_q10[5] -attr @rip pitch_fallback_q10_reg[31]_1[5] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[5] -pin u_vector pw_reg[5]
load net samples_reg[2][6] -attr @rip samples_reg[2][7]_0[14] -pin u_sensor samples_reg[2][7]_0[14] -pin u_vector p_1_in_1[14]
load net u_alertas/ap0[10] -attr @rip O[0] -pin g_operacao.u_operacao O[0] -pin u_vector O[0]
netloc u_alertas/ap0[10] 1 0 3 160 6320 NJ 6320 2780
load net vector_roll[13] -attr @style dashed -attr @rip roll_reg[31]_0[18] -pin g_operacao.u_operacao meta_reg[3][18] -pin u_vector roll_reg[31]_0[18]
load net u_dados_n_251 -attr @rip VGA_R_OBUF[3]_inst_i_3440_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3440_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_3[1]
load net inicio_operacao_reg_n_0_[3] -attr @style dashed -pin g_mag_tilt.u_heading y_reg[0] -pin g_native_video.u_native SD_BUSY_LED -pin g_operacao.u_operacao estado_reg[4]_0 -pin u_vector blocked_seen_reg[12]_0
netloc inicio_operacao_reg_n_0_[3] 1 0 5 500 4560 1270 3960 3160 5580 11240J 1140 16020
load net u_dados_n_31 -attr @rip heading_deg_reg[0]_2[1] -pin u_dados heading_deg_reg[0]_2[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2274_0[1]
load net u_dados_n_57 -attr @rip heading_deg_reg[0]_4[1] -pin u_dados heading_deg_reg[0]_4[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4706_0[1]
load net u_dados_n_174 -pin u_dados metadados_reg[12]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_189_0
netloc u_dados_n_174 1 3 1 N 3260
load net g_native_video.u_native_n_397 -attr @rip even_tag_reg[9][5] -pin g_native_video.u_native even_tag_reg[9][5] -pin u_vga missing_lines_reg[0]_i_3_1[5]
load net u_vga_n_289 -attr @rip h_cont_reg[1]_rep__0_9[0] -pin u_dados VGA_R_OBUF[3]_inst_i_771_0[0] -pin u_vga h_cont_reg[1]_rep__0_9[0]
load net u_vga_n_90 -attr @rip heading_deg_reg[7][2] -pin u_dados VGA_R_OBUF[3]_inst_i_840_0[2] -pin u_vga heading_deg_reg[7][2]
load net capture_hud_rgb[7] -attr @rip mira_lock_reg[2] -pin g_native_video.u_native capture_hud_rgb[2] -pin u_vga mira_lock_reg[2]
load net compass_gravity_y[11] -attr @rip gravity_y_reg[23]_0[11] -pin g_mag_tilt.u_heading gy_reg[24]_0[11] -pin u_vector gravity_y_reg[23]_0[11]
load net mpu_raw_gy[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[27] -pin u_sensor accel_x_reg[15]_0[27] -pin u_vector a_reg[0][15]_0[27]
load net mpu_gyro_z[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[11] -pin u_sensor accel_x_reg[15]_0[11] -pin u_vector a_reg[0][15]_0[11]
load net native_app_rd_data[106] -attr @rip din[106] -pin g_native_video.u_native din[106] -pin u_ui_test din[106]
load net native_app_rd_data[42] -attr @rip din[42] -pin g_native_video.u_native din[42] -pin u_ui_test din[42]
load net native_app_wdf_data[106] -attr @rip dout[106] -pin g_native_video.u_native dout[106] -pin u_ui_test dout[106]
load net native_app_wdf_data[42] -attr @rip dout[42] -pin g_native_video.u_native dout[42] -pin u_ui_test dout[42]
load net memory_and_vga/bridge/last_data[72] -attr @rip last_data_reg[125][72] -pin g_native_video.u_native last_data_reg[125][72] -pin u_ui_test wr_data2_carry__9[72]
load net memory_and_vga/bridge/last_data[7] -attr @rip last_data_reg[125][7] -pin g_native_video.u_native last_data_reg[125][7] -pin u_ui_test wr_data2_carry__9[7]
load net memory_and_vga/vga/future_word[0] -attr @rip ADDRA[0] -pin g_native_video.u_native ADDRA[0] -pin u_vga ADDRA[0]
load net roll_fallback_q10_next[19] -attr @rip roll_sync_reg[0]_0[19] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[19] -pin u_vector roll_sync_reg[0]_0[19]
load net samples_reg[2][3] -attr @rip samples_reg[2][7]_0[11] -pin u_sensor samples_reg[2][7]_0[11] -pin u_vector p_1_in_1[11]
load net pitch_fallback_q10[2] -attr @rip pitch_fallback_q10_reg[31]_1[2] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[2] -pin u_vector pw_reg[2]
load net vector_roll[10] -attr @style dashed -attr @rip roll_reg[31]_0[15] -pin g_operacao.u_operacao meta_reg[3][15] -pin u_vector roll_reg[31]_0[15]
load net u_dados_n_252 -attr @rip VGA_R_OBUF[3]_inst_i_3440_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3440_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_3[0]
load net pixel_clk_BUFG -attr @style dashed -pin g_native_video.u_native pixel_clk_BUFG -pin u_dados pixel_clk -pin u_entrada pixel_clk -pin u_simbologia pixel_clk -pin u_vga v_cont_reg[1]_0
netloc pixel_clk_BUFG 1 1 4 1770 6300 3520 6500 7080 9380 16000
load net u_dados_n_310 -pin u_dados VGA_R_OBUF[3]_inst_i_2017 -pin u_vga VGA_R_OBUF[3]_inst_i_780_1
netloc u_dados_n_310 1 3 1 11900 420n
load net u_dados_n_58 -attr @rip heading_deg_reg[0]_4[0] -pin u_dados heading_deg_reg[0]_4[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4706_0[0]
load net u_dados_n_175 -pin u_dados metadados_reg[11]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_189_1
netloc u_dados_n_175 1 3 1 7580 3180n
load net g_native_video.u_native_n_398 -attr @rip even_tag_reg[9][4] -pin g_native_video.u_native even_tag_reg[9][4] -pin u_vga missing_lines_reg[0]_i_3_1[4]
load net u_vector_n_242 -pin g_operacao.u_operacao pc_reg_0 -pin u_vector pitch_reg[11]_0
netloc u_vector_n_242 1 0 3 280 6380 NJ 6380 2580
load net u_vga_n_231 -pin u_dados VGA_R_OBUF[3]_inst_i_3346 -pin u_vga v_cont_reg[7]_rep_4
netloc u_vga_n_231 1 2 3 3720 9160 NJ 9160 14240
load net u_vga_n_91 -attr @rip heading_deg_reg[7][1] -pin u_dados VGA_R_OBUF[3]_inst_i_840_0[1] -pin u_vga heading_deg_reg[7][1]
load net capture_hud_rgb[11] -attr @rip mira_lock_reg[3] -pin g_native_video.u_native capture_hud_rgb[3] -pin u_vga mira_lock_reg[3]
load net compass_gravity_y[12] -attr @rip gravity_y_reg[23]_0[12] -pin g_mag_tilt.u_heading gy_reg[24]_0[12] -pin u_vector gravity_y_reg[23]_0[12]
load net hud_pixel_y[0] -attr @style dashed -attr @rip B[0] -pin u_dados hud_pixel_y[0] -pin u_simbologia u[0]
load net mpu_raw_gy[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[28] -pin u_sensor accel_x_reg[15]_0[28] -pin u_vector a_reg[0][15]_0[28]
load net mpu_gyro_z[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[12] -pin u_sensor accel_x_reg[15]_0[12] -pin u_vector a_reg[0][15]_0[12]
load net native_app_rd_data[107] -attr @rip din[107] -pin g_native_video.u_native din[107] -pin u_ui_test din[107]
load net native_app_rd_data[43] -attr @rip din[43] -pin g_native_video.u_native din[43] -pin u_ui_test din[43]
load net native_app_wdf_data[107] -attr @rip dout[107] -pin g_native_video.u_native dout[107] -pin u_ui_test dout[107]
load net native_app_wdf_data[43] -attr @rip dout[43] -pin g_native_video.u_native dout[43] -pin u_ui_test dout[43]
load net memory_and_vga/bridge/last_data[73] -attr @rip last_data_reg[125][73] -pin g_native_video.u_native last_data_reg[125][73] -pin u_ui_test wr_data2_carry__9[73]
load net memory_and_vga/bridge/last_data[8] -attr @rip last_data_reg[125][8] -pin g_native_video.u_native last_data_reg[125][8] -pin u_ui_test wr_data2_carry__9[8]
load net memory_and_vga/vga/future_word[1] -attr @rip ADDRA[1] -pin g_native_video.u_native ADDRA[1] -pin u_vga ADDRA[1]
load net samples_reg[2][4] -attr @rip samples_reg[2][7]_0[12] -pin u_sensor samples_reg[2][7]_0[12] -pin u_vector p_1_in_1[12]
load net roll_fallback_q10_next[20] -attr @rip roll_sync_reg[0]_0[20] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[20] -pin u_vector roll_sync_reg[0]_0[20]
load net vector_roll[11] -attr @style dashed -attr @rip roll_reg[31]_0[16] -pin g_operacao.u_operacao meta_reg[3][16] -pin u_vector roll_reg[31]_0[16]
load net pixel_x[8] -attr @style dashed -attr @rip Q[7] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[6] -pin u_vga Q[7]
load net pitch_fallback_q10[3] -attr @rip pitch_fallback_q10_reg[31]_1[3] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[3] -pin u_vector pw_reg[3]
load net g_operacao.u_operacao_n_134 -attr @rip roll_reg[0]_0[0] -pin g_operacao.u_operacao roll_reg[0]_0[0] -pin u_vector rw_reg_i_18_0[0]
netloc g_operacao.u_operacao_n_134 1 1 1 1510 5120n
load net u_entrada_n_4 -pin u_dados alvo_x_pendente_reg[8]_0 -pin u_entrada dados_destino_reg[4]_1
netloc u_entrada_n_4 1 2 1 3020 3500n
load net u_dados_n_48 -attr @rip VGA_R_OBUF[3]_inst_i_4060_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4060_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4489[0]
load net u_dados_n_300 -pin u_dados altitude_ft_reg[16]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_780_0
netloc u_dados_n_300 1 3 1 7880 1680n
load net u_dados_n_164 -pin u_dados metadados_reg[9]_0 -pin u_vga VGA_G_OBUF[3]_inst_i_44_4
netloc u_dados_n_164 1 3 1 7460 2700n
load net g_native_video.u_native_n_175 -pin g_native_video.u_native current_rgb332_reg_1 -pin u_vga VGA_G[0]
netloc g_native_video.u_native_n_175 1 3 3 12300 1200 NJ 1200 17120
load net u_vga_n_134 -attr @rip v_cont_reg[0]_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_32_0[0] -pin u_vga v_cont_reg[0]_1[0]
load net u_vga_n_221 -pin u_dados VGA_R_OBUF[3]_inst_i_2145 -pin u_vga v_cont_reg[4]_rep_1
netloc u_vga_n_221 1 2 3 4100 9020 NJ 9020 14500
load net u_vga_n_80 -attr @rip h_cont_reg[7]_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_3[0] -pin u_vga h_cont_reg[7]_3[0]
load net u_ui_test_n_203 -attr @rip last_data_reg[117][1] -pin g_native_video.u_native wr_data2_carry__9[1] -pin u_ui_test last_data_reg[117][1]
load net compass_gravity_y[1] -attr @rip gravity_y_reg[23]_0[1] -pin g_mag_tilt.u_heading gy_reg[24]_0[1] -pin u_vector gravity_y_reg[23]_0[1]
load net dados_operacao[53] -attr @rip D[32] -pin g_operacao.u_operacao D[32] -pin u_entrada retido_reg[121]_0[71]
load net mpu_gyro_z[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[1] -pin u_sensor accel_x_reg[15]_0[1] -pin u_vector a_reg[0][15]_0[1]
load net mpu_raw_gy[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[17] -pin u_sensor accel_x_reg[15]_0[17] -pin u_vector a_reg[0][15]_0[17]
load net memory_and_vga/bridge/wr_front[144] -attr @rip dout[128] -pin g_native_video.u_native dout[128] -pin u_ui_test dout[128]
load net memory_and_vga/bridge/last_data[62] -attr @rip last_data_reg[125][62] -pin g_native_video.u_native last_data_reg[125][62] -pin u_ui_test wr_data2_carry__9[62]
load net mira_x_in[0] -attr @rip Q[0] -pin u_dados Q[0] -pin u_entrada Q[0]
load net native_app_rd_data[32] -attr @rip din[32] -pin g_native_video.u_native din[32] -pin u_ui_test din[32]
load net native_app_rd_data[96] -attr @rip din[96] -pin g_native_video.u_native din[96] -pin u_ui_test din[96]
load net native_app_wdf_data[32] -attr @rip dout[32] -pin g_native_video.u_native dout[32] -pin u_ui_test dout[32]
load net native_app_wdf_data[96] -attr @rip dout[96] -pin g_native_video.u_native dout[96] -pin u_ui_test dout[96]
load net roll_fallback_q10_next[8] -attr @rip roll_sync_reg[0]_0[8] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[8] -pin u_vector roll_sync_reg[0]_0[8]
load net samples_reg[1][2] -attr @rip B[2] -pin u_sensor B[2] -pin u_vector B[2]
load net pitch_operacao_q10[31] -attr @rip pitch_fallback_q10_reg[31]_0[0] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_0[0] -pin u_vector pc_reg_0[0]
netloc pitch_operacao_q10[31] 1 1 1 1310 4860n
load net vector_roll[0] -attr @style dashed -attr @rip roll_reg[31]_0[13] -pin g_operacao.u_operacao meta_reg[3][13] -pin u_vector roll_reg[31]_0[13]
load net vector_pitch[18] -attr @style dashed -attr @rip roll_reg[31]_0[5] -pin g_operacao.u_operacao meta_reg[3][5] -pin u_vector roll_reg[31]_0[5]
load net hud_video_on -attr @style dashed -pin u_dados hud_video_on -pin u_simbologia hud_video_on -pin u_vga hud_video_on
netloc hud_video_on 1 2 3 5300 6480 7220 9340 NJ
load net u_dados_n_301 -pin u_dados VGA_R_OBUF[3]_inst_i_1085_0 -pin u_vga VGA_R_OBUF[3]_inst_i_156_2
netloc u_dados_n_301 1 3 1 12080 160n
load net g_operacao.u_operacao_n_138 -attr @rip roll_reg[0]_1[0] -pin g_operacao.u_operacao roll_reg[0]_1[0] -pin u_vector rc_reg_i_32_0[0]
netloc g_operacao.u_operacao_n_138 1 1 1 1230 5000n
load net g_native_video.u_native_n_176 -attr @rip even_tag_reg[7][0] -pin g_native_video.u_native even_tag_reg[7][0] -pin u_vga line_valid_reg[0]
netloc g_native_video.u_native_n_176 1 3 3 12360 1340 15680J 2900 17240
load net u_entrada_n_5 -pin u_dados alvo_x_pendente_reg[7]_0 -pin u_entrada dados_destino_reg[4]_2
netloc u_entrada_n_5 1 2 1 3000 3480n
load net u_dados_n_243 -attr @rip VGA_R_OBUF[3]_inst_i_4003_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4003_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_1[0]
netloc u_dados_n_243 1 3 1 11060 1120n
load net u_dados_n_165 -pin u_dados metadados_reg[9]_1 -pin u_vga VGA_G_OBUF[3]_inst_i_44_5
netloc u_dados_n_165 1 3 1 11160 2720n
load net u_dados_n_49 -attr @rip heading_deg_reg[0]_3[3] -pin u_dados heading_deg_reg[0]_3[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4696_0[3]
load net u_vga_n_135 -attr @rip v_cont_reg[0]_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_32[0] -pin u_vga v_cont_reg[0]_2[0]
netloc u_vga_n_135 1 2 3 3740 8940 NJ 8940 14600
load net u_vga_n_222 -pin u_dados VGA_R_OBUF[3]_inst_i_3957_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1596_0
netloc u_vga_n_222 1 2 3 5940 5640 9160J 1460 13900
load net u_vga_n_280 -attr @rip h_cont_reg[2]_rep__2_2[3] -pin u_dados VGA_R_OBUF[3]_inst_i_395_0[3] -pin u_vga h_cont_reg[2]_rep__2_2[3]
load net u_vga_n_81 -attr @rip h_cont_reg[9]_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4166_0[0] -pin u_vga h_cont_reg[9]_3[0]
netloc u_vga_n_81 1 2 3 4880 8540 NJ 8540 15100
load net u_ui_test_n_204 -attr @rip last_data_reg[117][0] -pin g_native_video.u_native wr_data2_carry__9[0] -pin u_ui_test last_data_reg[117][0]
load net compass_gravity_y[2] -attr @rip gravity_y_reg[23]_0[2] -pin g_mag_tilt.u_heading gy_reg[24]_0[2] -pin u_vector gravity_y_reg[23]_0[2]
load net dados_operacao[54] -attr @rip D[33] -pin g_operacao.u_operacao D[33] -pin u_entrada retido_reg[121]_0[72]
load net mpu_gyro_z[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[2] -pin u_sensor accel_x_reg[15]_0[2] -pin u_vector a_reg[0][15]_0[2]
load net mpu_raw_gy[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[18] -pin u_sensor accel_x_reg[15]_0[18] -pin u_vector a_reg[0][15]_0[18]
load net memory_and_vga/bridge/last_data[63] -attr @rip last_data_reg[125][63] -pin g_native_video.u_native last_data_reg[125][63] -pin u_ui_test wr_data2_carry__9[63]
load net mira_x_in[1] -attr @rip Q[1] -pin u_dados Q[1] -pin u_entrada Q[1]
load net memory_and_vga/vga/A[2] -attr @rip v_cont_reg[7]_rep_0[2] -pin g_native_video.u_native fetch_line_reg[9]_0[2] -pin u_vga v_cont_reg[7]_rep_0[2]
load net native_app_rd_data[33] -attr @rip din[33] -pin g_native_video.u_native din[33] -pin u_ui_test din[33]
load net native_app_rd_data[97] -attr @rip din[97] -pin g_native_video.u_native din[97] -pin u_ui_test din[97]
load net native_app_wdf_data[33] -attr @rip dout[33] -pin g_native_video.u_native dout[33] -pin u_ui_test dout[33]
load net native_app_wdf_data[97] -attr @rip dout[97] -pin g_native_video.u_native dout[97] -pin u_ui_test dout[97]
load net roll_fallback_q10_next[10] -attr @rip roll_sync_reg[0]_0[10] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[10] -pin u_vector roll_sync_reg[0]_0[10]
load net samples_reg[1][3] -attr @rip B[3] -pin u_sensor B[3] -pin u_vector B[3]
load net vector_roll[1] -attr @style dashed -attr @rip roll_reg[31]_0[14] -pin g_operacao.u_operacao meta_reg[3][14] -pin u_vector roll_reg[31]_0[14]
load net vector_pitch[19] -attr @style dashed -attr @rip roll_reg[31]_0[6] -pin g_operacao.u_operacao meta_reg[3][6] -pin u_vector roll_reg[31]_0[6]
load net u_dados_n_299 -pin u_dados VGA_R_OBUF[3]_inst_i_2001_0 -pin u_vga VGA_R_OBUF[3]_inst_i_780_4
netloc u_dados_n_299 1 3 1 11920 360n
load net u_entrada_n_2 -attr @rip D[0] -pin u_dados D[0] -pin u_entrada D[0]
load net u_dados_n_46 -attr @rip h_cont_reg[9]_1[0] -pin u_dados h_cont_reg[9]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2918[0]
load net horizonte -pin u_simbologia horizonte -pin u_vga horizonte
netloc horizonte 1 3 3 12300 9500 NJ 9500 17120
load net estilo_caca -attr @style dashed -pin u_simbologia out -pin u_vga out
netloc estilo_caca 1 3 2 12340 9360 NJ
load net u_dados_n_162 -pin u_dados metadados_reg[10]_0 -pin u_vga VGA_G_OBUF[3]_inst_i_44_0
netloc u_dados_n_162 1 3 1 10800 2620n
load net g_native_video.u_native_n_173 -pin g_native_video.u_native current_rgb332_reg -pin u_vga VGA_G[1]
netloc g_native_video.u_native_n_173 1 3 3 12220 1160 NJ 1160 17160
load net u_vga_n_22 -pin u_dados VGA_R_OBUF[3]_inst_i_159_0 -pin u_vga v_cont_reg[0]_rep__0_0
netloc u_vga_n_22 1 2 3 4020 8820 NJ 8820 14740
load net u_vga_n_132 -attr @rip v_cont_reg[0]_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_32_0[2] -pin u_vga v_cont_reg[0]_1[2]
load net u_vga_n_78 -attr @rip h_cont_reg[1]_rep__0_6[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_1[0] -pin u_vga h_cont_reg[1]_rep__0_6[0]
load net u_vga_n_278 -attr @rip VGA_R_OBUF[3]_inst_i_1435_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_393[1] -pin u_vga VGA_R_OBUF[3]_inst_i_1435_0[1]
load net u_ui_test_n_201 -attr @rip last_data_reg[117][3] -pin g_native_video.u_native wr_data2_carry__9[3] -pin u_ui_test last_data_reg[117][3]
load net compass_gravity_x[23] -attr @rip gravity_x_reg[23]_0[23] -pin g_mag_tilt.u_heading gx_reg[23]_0[23] -pin u_vector gravity_x_reg[23]_0[23]
load net dados_operacao[51] -attr @rip D[30] -pin g_operacao.u_operacao D[30] -pin u_entrada retido_reg[121]_0[69]
load net mpu_accel_z[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[63] -pin u_sensor accel_x_reg[15]_0[63] -pin u_vector a_reg[0][15]_0[63]
load net mpu_raw_gx[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[47] -pin u_sensor accel_x_reg[15]_0[47] -pin u_vector a_reg[0][15]_0[47]
load net memory_and_vga/bridge/last_data[124] -attr @rip last_data_reg[125][124] -pin g_native_video.u_native last_data_reg[125][124] -pin u_ui_test wr_data2_carry__9[124]
load net memory_and_vga/bridge/last_data[60] -attr @rip last_data_reg[125][60] -pin g_native_video.u_native last_data_reg[125][60] -pin u_ui_test wr_data2_carry__9[60]
load net native_app_wdf_data[94] -attr @rip dout[94] -pin g_native_video.u_native dout[94] -pin u_ui_test dout[94]
load net native_app_wdf_data[30] -attr @rip dout[30] -pin g_native_video.u_native dout[30] -pin u_ui_test dout[30]
load net native_app_rd_data[94] -attr @rip din[94] -pin g_native_video.u_native din[94] -pin u_ui_test din[94]
load net native_app_rd_data[30] -attr @rip din[30] -pin g_native_video.u_native din[30] -pin u_ui_test din[30]
load net samples_reg[1][0] -attr @rip B[0] -pin u_sensor B[0] -pin u_vector B[0]
load net roll_fallback_q10_next[9] -attr @rip roll_sync_reg[0]_0[9] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[9] -pin u_vector roll_sync_reg[0]_0[9]
load net vector_pitch[16] -attr @style dashed -attr @rip roll_reg[31]_0[3] -pin g_operacao.u_operacao meta_reg[3][3] -pin u_vector roll_reg[31]_0[3]
load net pitch_fallback_q10_next[31] -attr @rip horizonte_sync_reg[0][26] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[26] -pin u_vector horizonte_sync_reg[0][26]
load net g_operacao.u_operacao_n_133 -attr @rip roll_reg[0][0] -pin g_operacao.u_operacao roll_reg[0][0] -pin u_vector rw_reg_i_18_1[0]
netloc g_operacao.u_operacao_n_133 1 1 1 1530 5140n
load net u_entrada_n_3 -pin u_dados alvo_x_pendente_reg[9]_0 -pin u_entrada dados_destino_reg[4]_0
netloc u_entrada_n_3 1 2 1 3040 3520n
load net u_dados_n_47 -attr @rip VGA_R_OBUF[3]_inst_i_4060_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4060_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4489[1]
load net u_dados_n_30 -attr @rip heading_deg_reg[0]_2[2] -pin u_dados heading_deg_reg[0]_2[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2274_0[2]
load net u_dados_n_163 -pin u_dados metadados_reg[10]_1 -pin u_vga VGA_G_OBUF[3]_inst_i_44_1
netloc u_dados_n_163 1 3 1 11000 2640n
load net g_native_video.u_native_n_174 -pin g_native_video.u_native current_rgb332_reg_0 -pin u_vga VGA_G[2]
netloc g_native_video.u_native_n_174 1 3 3 12260 1180 NJ 1180 17140
load net u_vga_n_220 -pin u_dados VGA_R_OBUF[3]_inst_i_3446 -pin u_vga altitude_ft_reg[6]
netloc u_vga_n_220 1 2 3 5640 5860 7960J 1680 14480
load net u_vga_n_79 -attr @rip h_cont_reg[7]_3[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_3[1] -pin u_vga h_cont_reg[7]_3[1]
load net u_ui_test_n_202 -attr @rip last_data_reg[117][2] -pin g_native_video.u_native wr_data2_carry__9[2] -pin u_ui_test last_data_reg[117][2]
load net u_vga_n_279 -attr @rip VGA_R_OBUF[3]_inst_i_1435_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_393[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1435_0[0]
load net u_vga_n_133 -attr @rip v_cont_reg[0]_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_32_0[1] -pin u_vga v_cont_reg[0]_1[1]
load net compass_gravity_y[0] -attr @rip gravity_y_reg[23]_0[0] -pin g_mag_tilt.u_heading gy_reg[24]_0[0] -pin u_vector gravity_y_reg[23]_0[0]
load net fonte_desabilitada_sync[0] -attr @style dashed -attr @rip 0 -pin g_operacao.u_operacao estado_reg[7]_0[0] -pin u_sensor out[0] -pin u_vector out[0]
netloc fonte_desabilitada_sync[0] 1 0 2 440 4600 1390J
load net dados_operacao[52] -attr @rip D[31] -pin g_operacao.u_operacao D[31] -pin u_entrada retido_reg[121]_0[70]
load net mpu_gyro_z[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[0] -pin u_sensor accel_x_reg[15]_0[0] -pin u_vector a_reg[0][15]_0[0]
load net mpu_raw_gy[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[16] -pin u_sensor accel_x_reg[15]_0[16] -pin u_vector a_reg[0][15]_0[16]
load net memory_and_vga/bridge/last_data[125] -attr @rip last_data_reg[125][125] -pin g_native_video.u_native last_data_reg[125][125] -pin u_ui_test wr_data2_carry__9[125]
load net memory_and_vga/bridge/last_data[61] -attr @rip last_data_reg[125][61] -pin g_native_video.u_native last_data_reg[125][61] -pin u_ui_test wr_data2_carry__9[61]
load net native_app_wdf_data[95] -attr @rip dout[95] -pin g_native_video.u_native dout[95] -pin u_ui_test dout[95]
load net native_app_wdf_data[31] -attr @rip dout[31] -pin g_native_video.u_native dout[31] -pin u_ui_test dout[31]
load net native_app_rd_data[95] -attr @rip din[95] -pin g_native_video.u_native din[95] -pin u_ui_test din[95]
load net native_app_rd_data[31] -attr @rip din[31] -pin g_native_video.u_native din[31] -pin u_ui_test din[31]
load net roll_fallback_q10_next[7] -attr @rip roll_sync_reg[0]_0[7] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[7] -pin u_vector roll_sync_reg[0]_0[7]
load net samples_reg[1][1] -attr @rip B[1] -pin u_sensor B[1] -pin u_vector B[1]
load net stale_reg[0] -attr @rip stale_reg[0]_0[0] -pin u_sensor stale_reg[0] -pin u_vector stale_reg[0]_0[0]
netloc stale_reg[0] 1 0 3 20 6280 NJ 6280 2380
load net vector_pitch[17] -attr @style dashed -attr @rip roll_reg[31]_0[4] -pin g_operacao.u_operacao meta_reg[3][4] -pin u_vector roll_reg[31]_0[4]
load net g_operacao.u_operacao_n_54 -pin g_operacao.u_operacao g_idade[0].recentes_reg[0]_0 -pin u_vector estado_reg[3]
netloc g_operacao.u_operacao_n_54 1 1 1 1170 4660n
load net u_dados_n_246 -attr @rip VGA_R_OBUF[3]_inst_i_3420_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3420_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1631_1[0]
netloc u_dados_n_246 1 3 1 7180 920n
load net g_native_video.u_native_n_201 -pin g_native_video.u_native FSM_onehot_state_reg[0]_0 -pin u_ui_test last_word_reg[15]
netloc g_native_video.u_native_n_201 1 5 1 17420 600n
load net p_17_in -attr @style dashed -pin g_mag_tilt.u_heading p_17_in -pin u_vector p_17_in
netloc p_17_in 1 2 1 2880 4560n
load net u_entrada_n_8 -pin u_dados alvo_x_pendente_reg[2]_0 -pin u_entrada dados_destino_reg[4]_5
netloc u_entrada_n_8 1 2 1 2940 3420n
load net u_dados_n_304 -pin u_dados altitude_ft_reg[3]_7 -pin u_vga VGA_R_OBUF[3]_inst_i_1088_1
netloc u_dados_n_304 1 3 1 11700 1440n
load net u_dados_n_169 -pin u_dados metadados_reg[25]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_31_1
netloc u_dados_n_169 1 3 1 11360 2800n
load net u_dados_n_51 -attr @rip heading_deg_reg[0]_3[1] -pin u_dados heading_deg_reg[0]_3[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4696_0[1]
load net u_vga_n_84 -attr @rip h_cont_reg[0]_rep_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2228_0[0] -pin u_vga h_cont_reg[0]_rep_1[0]
netloc u_vga_n_84 1 2 3 5960 4720 10540J 900 14740
load net u_vga_n_283 -attr @rip h_cont_reg[2]_rep__2_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_395_0[0] -pin u_vga h_cont_reg[2]_rep__2_2[0]
load net u_vga_n_225 -pin u_dados VGA_R_OBUF[3]_inst_i_4008 -pin u_vga altitude_ft_reg[7]
netloc u_vga_n_225 1 2 3 5600 5880 9560J 1700 14460
load net u_ui_test_n_26 -attr @rip din[128] -pin g_native_video.u_native din[128] -pin u_ui_test din[128]
load net compass_gravity_y[5] -attr @rip gravity_y_reg[23]_0[5] -pin g_mag_tilt.u_heading gy_reg[24]_0[5] -pin u_vector gravity_y_reg[23]_0[5]
load net data0[1] -attr @rip v_cont_reg[7]_rep_0[1] -pin g_native_video.u_native fetch_line_reg[9]_0[1] -pin u_vga v_cont_reg[7]_rep_0[1]
load net mpu_raw_gy[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[21] -pin u_sensor accel_x_reg[15]_0[21] -pin u_vector a_reg[0][15]_0[21]
load net native_app_rd_data[36] -attr @rip din[36] -pin g_native_video.u_native din[36] -pin u_ui_test din[36]
load net mpu_gyro_z[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[5] -pin u_sensor accel_x_reg[15]_0[5] -pin u_vector a_reg[0][15]_0[5]
load net mira_x_in[4] -attr @rip Q[4] -pin u_dados Q[4] -pin u_entrada Q[4]
load net memory_and_vga/bridge/last_data[2] -attr @rip last_data_reg[125][2] -pin g_native_video.u_native last_data_reg[125][2] -pin u_ui_test wr_data2_carry__9[2]
load net memory_and_vga/bridge/last_data[66] -attr @rip last_data_reg[125][66] -pin g_native_video.u_native last_data_reg[125][66] -pin u_ui_test wr_data2_carry__9[66]
load net memory_and_vga/vga/A[5] -attr @rip v_cont_reg[7]_rep_0[5] -pin g_native_video.u_native fetch_line_reg[9]_0[5] -pin u_vga v_cont_reg[7]_rep_0[5]
load net native_app_rd_data[100] -attr @rip din[100] -pin g_native_video.u_native din[100] -pin u_ui_test din[100]
load net native_app_wdf_data[100] -attr @rip dout[100] -pin g_native_video.u_native dout[100] -pin u_ui_test dout[100]
load net native_app_wdf_data[36] -attr @rip dout[36] -pin g_native_video.u_native dout[36] -pin u_ui_test dout[36]
load net roll_fallback_q10_next[13] -attr @rip roll_sync_reg[0]_0[13] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[13] -pin u_vector roll_sync_reg[0]_0[13]
load net pixel_x[2] -attr @rip Q[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[0] -pin u_vga Q[1]
load net samples_reg[1][6] -attr @rip B[6] -pin u_sensor B[6] -pin u_vector B[6]
load net u_dados_n_305 -pin u_dados VGA_R_OBUF[3]_inst_i_1489_0 -pin u_vga VGA_R_OBUF[3]_inst_i_394_0
netloc u_dados_n_305 1 3 1 12020 260n
load net sensor_fault_cycles0 -pin u_sensor sensor_fault_cycles0 -pin u_vector sensor_fault_cycles0
netloc sensor_fault_cycles0 1 1 1 1370 4440n
load net u_entrada_n_9 -pin u_dados alvo_x_pendente_reg[1]_0 -pin u_entrada dados_destino_reg[4]_6
netloc u_entrada_n_9 1 2 1 2920 3400n
load net u_dados_n_247 -attr @rip VGA_R_OBUF[3]_inst_i_3420_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3420_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3346_1[1]
load net u_dados_n_17 -attr @rip h_cont_reg[5]_rep[0] -pin u_dados h_cont_reg[5]_rep[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2272[0]
load net u_dados_n_52 -attr @rip heading_deg_reg[0]_3[0] -pin u_dados heading_deg_reg[0]_3[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4696_0[0]
load net u_vec/done1 -pin g_mag_tilt.u_heading done1 -pin u_vector done1
netloc u_vec/done1 1 1 3 1750 3980 3200J 5540 7180
load net u_vga_n_85 -attr @rip h_cont_reg[9]_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3507_0[0] -pin u_vga h_cont_reg[9]_5[0]
netloc u_vga_n_85 1 2 3 4820 8580 NJ 8580 15020
load net u_vga_n_226 -pin u_dados VGA_R_OBUF[3]_inst_i_3964 -pin u_vga altitude_ft_reg[9]
netloc u_vga_n_226 1 2 3 5320 6000 7120J 1820 14120
load net u_vga_n_284 -attr @rip VGA_R_OBUF[3]_inst_i_1102_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_776_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_1102_0[1]
load net compass_gravity_y[6] -attr @rip gravity_y_reg[23]_0[6] -pin g_mag_tilt.u_heading gy_reg[24]_0[6] -pin u_vector gravity_y_reg[23]_0[6]
load net hud_pixel_x[1] -attr @style dashed -attr @rip hud_pixel_x[1] -pin u_dados hud_pixel_x[1] -pin u_simbologia B[1]
load net mpu_gyro_z[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[6] -pin u_sensor accel_x_reg[15]_0[6] -pin u_vector a_reg[0][15]_0[6]
load net mpu_raw_gy[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[22] -pin u_sensor accel_x_reg[15]_0[22] -pin u_vector a_reg[0][15]_0[22]
load net mira_x_in[5] -attr @rip Q[5] -pin u_dados Q[5] -pin u_entrada Q[5]
load net memory_and_vga/vga/A[6] -attr @rip v_cont_reg[7]_rep_0[6] -pin g_native_video.u_native fetch_line_reg[9]_0[6] -pin u_vga v_cont_reg[7]_rep_0[6]
load net memory_and_vga/bridge/last_data[3] -attr @rip last_data_reg[125][3] -pin g_native_video.u_native last_data_reg[125][3] -pin u_ui_test wr_data2_carry__9[3]
load net memory_and_vga/bridge/last_data[67] -attr @rip last_data_reg[125][67] -pin g_native_video.u_native last_data_reg[125][67] -pin u_ui_test wr_data2_carry__9[67]
load net native_app_rd_data[101] -attr @rip din[101] -pin g_native_video.u_native din[101] -pin u_ui_test din[101]
load net native_app_wdf_data[101] -attr @rip dout[101] -pin g_native_video.u_native dout[101] -pin u_ui_test dout[101]
load net native_app_wdf_data[37] -attr @rip dout[37] -pin g_native_video.u_native dout[37] -pin u_ui_test dout[37]
load net native_app_rd_data[37] -attr @rip din[37] -pin g_native_video.u_native din[37] -pin u_ui_test din[37]
load net roll_fallback_q10_next[14] -attr @rip roll_sync_reg[0]_0[14] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[14] -pin u_vector roll_sync_reg[0]_0[14]
load net pixel_x[3] -attr @rip Q[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[1] -pin u_vga Q[2]
load net vector_pitch[23] -attr @style dashed -attr @rip roll_reg[31]_0[9] -pin g_operacao.u_operacao meta_reg[3][9] -pin u_vector roll_reg[31]_0[9]
load net g_operacao.u_operacao_n_139 -attr @rip roll_reg[0]_2[0] -pin g_operacao.u_operacao roll_reg[0]_2[0] -pin u_vector rc_reg_i_20_0[0]
netloc g_operacao.u_operacao_n_139 1 1 1 1410 4980n
load net g_idade[0].idade1 -attr @rip SS[0] -pin g_operacao.u_operacao SS[0] -pin u_vector SS[0]
netloc g_idade[0].idade1 1 0 3 140 4020 NJ 4020 2420
load net g_native_video.u_native_n_182 -attr @rip even_tag_reg[7]_0[0] -pin g_native_video.u_native even_tag_reg[7]_0[0] -pin u_vga missing_lines_reg[31][0]
netloc g_native_video.u_native_n_182 1 3 3 12180 1360 15220J 2920 17220
load net u_entrada_n_6 -pin u_dados alvo_x_pendente_reg[6]_0 -pin u_entrada dados_destino_reg[4]_3
netloc u_entrada_n_6 1 2 1 2980 3460n
load net u_dados_n_5 -attr @rip S[2] -pin u_dados S[2] -pin u_vga S[2]
load net u_dados_n_244 -attr @rip VGA_R_OBUF[3]_inst_i_2869_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1631_0[0]
netloc u_dados_n_244 1 3 1 7740 700n
load net u_dados_n_167 -pin u_dados metadados_reg[12]_0 -pin u_vga VGA_G_OBUF[3]_inst_i_44_2
netloc u_dados_n_167 1 3 1 8020 2660n
load net u_dados_n_302 -pin u_dados altitude_ft_reg[3]_5 -pin u_vga VGA_R_OBUF[3]_inst_i_1088_2
netloc u_dados_n_302 1 3 1 11720 1400n
load net u_vga_n_82 -attr @rip h_cont_reg[0]_rep_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2218_0[0] -pin u_vga h_cont_reg[0]_rep_0[0]
netloc u_vga_n_82 1 2 3 5900 4700 10500J 880 14780
load net u_vga_n_223 -pin u_dados VGA_R_OBUF[3]_inst_i_3446_0 -pin u_vga altitude_ft_reg[4]
netloc u_vga_n_223 1 2 3 5680 5820 10300J 1640 14520
load net u_vga_n_281 -attr @rip h_cont_reg[2]_rep__2_2[2] -pin u_dados VGA_R_OBUF[3]_inst_i_395_0[2] -pin u_vga h_cont_reg[2]_rep__2_2[2]
load net u_ui_test_n_205 -attr @rip last_data_reg[125][1] -pin g_native_video.u_native u_xpm_i_2__2[1] -pin u_ui_test last_data_reg[125][1]
load net compass_gravity_y[3] -attr @rip gravity_y_reg[23]_0[3] -pin g_mag_tilt.u_heading gy_reg[24]_0[3] -pin u_vector gravity_y_reg[23]_0[3]
load net dados_operacao[55] -attr @rip D[34] -pin g_operacao.u_operacao D[34] -pin u_entrada retido_reg[121]_0[73]
load net hud_pixel_x[0] -attr @style dashed -attr @rip hud_pixel_x[0] -pin u_dados hud_pixel_x[0] -pin u_simbologia B[0]
load net mpu_gyro_z[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[3] -pin u_sensor accel_x_reg[15]_0[3] -pin u_vector a_reg[0][15]_0[3]
load net mpu_raw_gy[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[19] -pin u_sensor accel_x_reg[15]_0[19] -pin u_vector a_reg[0][15]_0[19]
load net memory_and_vga/bridge/last_data[0] -attr @rip last_data_reg[125][0] -pin g_native_video.u_native last_data_reg[125][0] -pin u_ui_test wr_data2_carry__9[0]
load net memory_and_vga/bridge/last_data[64] -attr @rip last_data_reg[125][64] -pin g_native_video.u_native last_data_reg[125][64] -pin u_ui_test wr_data2_carry__9[64]
load net mira_x_in[2] -attr @rip Q[2] -pin u_dados Q[2] -pin u_entrada Q[2]
load net memory_and_vga/vga/A[3] -attr @rip v_cont_reg[7]_rep_0[3] -pin g_native_video.u_native fetch_line_reg[9]_0[3] -pin u_vga v_cont_reg[7]_rep_0[3]
load net native_app_rd_data[34] -attr @rip din[34] -pin g_native_video.u_native din[34] -pin u_ui_test din[34]
load net native_app_rd_data[98] -attr @rip din[98] -pin g_native_video.u_native din[98] -pin u_ui_test din[98]
load net native_app_wdf_data[34] -attr @rip dout[34] -pin g_native_video.u_native dout[34] -pin u_ui_test dout[34]
load net native_app_wdf_data[98] -attr @rip dout[98] -pin g_native_video.u_native dout[98] -pin u_ui_test dout[98]
load net samples_reg[1][4] -attr @rip B[4] -pin u_sensor B[4] -pin u_vector B[4]
load net roll_fallback_q10_next[11] -attr @rip roll_sync_reg[0]_0[11] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[11] -pin u_vector roll_sync_reg[0]_0[11]
load net vector_pitch[20] -attr @style dashed -attr @rip roll_reg[31]_0[7] -pin g_operacao.u_operacao meta_reg[3][7] -pin u_vector roll_reg[31]_0[7]
load net g_operacao.u_operacao_n_140 -attr @rip roll_reg[0]_3[0] -pin g_operacao.u_operacao roll_reg[0]_3[0] -pin u_vector rw_reg_i_23_2[0]
netloc g_operacao.u_operacao_n_140 1 1 1 1610 5200n
load net u_dados_n_245 -attr @rip VGA_R_OBUF[3]_inst_i_2869_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3346_0[0]
netloc u_dados_n_245 1 3 1 9600 720n
load net g_native_video.u_native_n_184 -pin g_native_video.u_native FSM_onehot_state_reg[0] -pin u_ui_test FSM_onehot_state_reg[1]_3
netloc g_native_video.u_native_n_184 1 5 1 17320 400n
load net retic_caca_clearance -pin u_simbologia retic_caca_clearance -pin u_vga retic_caca_clearance
netloc retic_caca_clearance 1 4 1 15600 6180n
load net u_entrada_n_7 -pin u_dados alvo_x_pendente_reg[5]_0 -pin u_entrada dados_destino_reg[4]_4
netloc u_entrada_n_7 1 2 1 2960 3440n
load net u_dados_n_50 -attr @rip heading_deg_reg[0]_3[2] -pin u_dados heading_deg_reg[0]_3[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4696_0[2]
load net u_dados_n_168 -pin u_dados VGA_R_OBUF[3]_inst_i_209_0 -pin u_vga VGA_G_OBUF[3]_inst_i_44_3
netloc u_dados_n_168 1 3 1 12100 140n
load net u_dados_n_303 -pin u_dados altitude_ft_reg[3]_6 -pin u_vga VGA_R_OBUF[3]_inst_i_1088_0
netloc u_dados_n_303 1 3 1 11740 1420n
load net u_vga_n_83 -attr @rip h_cont_reg[9]_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3480_0[0] -pin u_vga h_cont_reg[9]_4[0]
netloc u_vga_n_83 1 2 3 4780 8560 NJ 8560 15080
load net u_vga_n_282 -attr @rip h_cont_reg[2]_rep__2_2[1] -pin u_dados VGA_R_OBUF[3]_inst_i_395_0[1] -pin u_vga h_cont_reg[2]_rep__2_2[1]
load net u_vga_n_224 -pin u_dados VGA_R_OBUF[3]_inst_i_4356 -pin u_vga altitude_ft_reg[5]
netloc u_vga_n_224 1 2 3 5660 5840 10340J 1660 14500
load net u_ui_test_n_206 -attr @rip last_data_reg[125][0] -pin g_native_video.u_native u_xpm_i_2__2[0] -pin u_ui_test last_data_reg[125][0]
load net compass_gravity_y[4] -attr @rip gravity_y_reg[23]_0[4] -pin g_mag_tilt.u_heading gy_reg[24]_0[4] -pin u_vector gravity_y_reg[23]_0[4]
load net dados_operacao[56] -attr @rip D[35] -pin g_operacao.u_operacao D[35] -pin u_entrada retido_reg[121]_0[74]
load net mpu_gyro_z[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[4] -pin u_sensor accel_x_reg[15]_0[4] -pin u_vector a_reg[0][15]_0[4]
load net mpu_raw_gy[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[20] -pin u_sensor accel_x_reg[15]_0[20] -pin u_vector a_reg[0][15]_0[20]
load net memory_and_vga/bridge/last_data[1] -attr @rip last_data_reg[125][1] -pin g_native_video.u_native last_data_reg[125][1] -pin u_ui_test wr_data2_carry__9[1]
load net mira_x_in[3] -attr @rip Q[3] -pin u_dados Q[3] -pin u_entrada Q[3]
load net memory_and_vga/vga/A[4] -attr @rip v_cont_reg[7]_rep_0[4] -pin g_native_video.u_native fetch_line_reg[9]_0[4] -pin u_vga v_cont_reg[7]_rep_0[4]
load net memory_and_vga/bridge/last_data[65] -attr @rip last_data_reg[125][65] -pin g_native_video.u_native last_data_reg[125][65] -pin u_ui_test wr_data2_carry__9[65]
load net native_app_rd_data[35] -attr @rip din[35] -pin g_native_video.u_native din[35] -pin u_ui_test din[35]
load net native_app_rd_data[99] -attr @rip din[99] -pin g_native_video.u_native din[99] -pin u_ui_test din[99]
load net native_app_wdf_data[35] -attr @rip dout[35] -pin g_native_video.u_native dout[35] -pin u_ui_test dout[35]
load net native_app_wdf_data[99] -attr @rip dout[99] -pin g_native_video.u_native dout[99] -pin u_ui_test dout[99]
load net roll_fallback_q10_next[12] -attr @rip roll_sync_reg[0]_0[12] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[12] -pin u_vector roll_sync_reg[0]_0[12]
load net samples_reg[1][5] -attr @rip B[5] -pin u_sensor B[5] -pin u_vector B[5]
load net vector_pitch[21] -attr @style dashed -attr @rip roll_reg[31]_0[8] -pin g_operacao.u_operacao meta_reg[3][8] -pin u_vector roll_reg[31]_0[8]
load net pixel_x[1] -attr @rip Q[0] -pin g_native_video.u_native Q[0] -pin u_vga Q[0]
load net u_dados_n_322 -pin u_dados velocidade_kt_reg[3]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1416_0
netloc u_dados_n_322 1 3 1 8800 4000n
load net g_mag_tilt.u_heading_n_28 -pin g_mag_tilt.u_heading busy_reg_0 -pin u_vector i_reg[0]
netloc g_mag_tilt.u_heading_n_28 1 1 3 1770 5600 NJ 5600 7240
load net u_dados_n_7 -attr @rip S[0] -pin u_dados S[0] -pin u_vga S[0]
load net u_dados_n_264 -attr @rip VGA_R_OBUF[3]_inst_i_2869_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_4[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1631_3[0]
netloc u_dados_n_264 1 3 1 9640 780n
load net u_dados_n_189 -pin u_dados altitude_ft_reg[3]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_1141_2
netloc u_dados_n_189 1 3 1 11660 1340n
load net u_dados_n_104 -attr @rip heading_deg_reg[0]_9[2] -pin u_dados heading_deg_reg[0]_9[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4643_0[2]
load net u_vga_n_243 -attr @rip h_cont_reg[2]_rep__2_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1561[1] -pin u_vga h_cont_reg[2]_rep__2_1[1]
load net u_simbologia_n_1 -pin u_simbologia declutter_reg -pin u_vga VGA_R_OBUF[3]_inst_i_4
netloc u_simbologia_n_1 1 3 3 12340 1220 16000J 1300 17280
load net u_vga_n_301 -attr @rip g_native_video.pixel_reset_pipe_reg[1]_0[0] -pin g_native_video.u_native odd_tag_reg[9]_0[0] -pin u_vga g_native_video.pixel_reset_pipe_reg[1]_0[0]
netloc u_vga_n_301 1 4 1 15660 2240n
load net card_coluna2_B_dspDelayedAccum[4] -attr @rip h_cont_reg[1]_rep__0_4[2] -pin u_dados VGA_R_OBUF[3]_inst_i_822_0[2] -pin u_vga h_cont_reg[1]_rep__0_4[2]
load net compass_gravity_z[1] -attr @rip Q[1] -pin g_mag_tilt.u_heading gz_reg[24]_0[1] -pin u_vector Q[1]
load net native_app_addr[11] -attr @rip app_addr[8] -pin g_native_video.u_native app_addr[8] -pin u_ui_test app_addr[8]
load net mpu_raw_ax[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[88] -pin u_sensor accel_x_reg[15]_0[88] -pin u_vector a_reg[0][15]_0[88]
load net native_app_wdf_data[120] -attr @rip dout[120] -pin g_native_video.u_native dout[120] -pin u_ui_test dout[120]
load net native_app_wdf_data[56] -attr @rip dout[56] -pin g_native_video.u_native dout[56] -pin u_ui_test dout[56]
load net metadados_in[3] -attr @rip Q[59] -pin u_dados Q[59] -pin u_entrada Q[59]
load net memory_and_vga/bridge/last_data[22] -attr @rip last_data_reg[125][22] -pin g_native_video.u_native last_data_reg[125][22] -pin u_ui_test wr_data2_carry__9[22]
load net memory_and_vga/bridge/last_data[86] -attr @rip last_data_reg[125][86] -pin g_native_video.u_native last_data_reg[125][86] -pin u_ui_test wr_data2_carry__9[86]
load net native_app_rd_data[120] -attr @rip din[120] -pin g_native_video.u_native din[120] -pin u_ui_test din[120]
load net native_app_rd_data[56] -attr @rip din[56] -pin g_native_video.u_native din[56] -pin u_ui_test din[56]
load net roll_sync[0] -attr @style dashed -attr @rip 0 -pin g_operacao.u_operacao estado_reg[7]_1[0] -pin u_sensor sensor_i_3_0[0] -pin u_vector roll_fallback_q10_reg[9][0]
load net pitch_fallback_q10[16] -attr @rip pitch_fallback_q10_reg[31]_1[16] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[16] -pin u_vector pw_reg[16]
load net u_trig/y[0] -attr @rip y[0] -pin g_mag_tilt.u_heading y[0] -pin u_vector y[0]
netloc u_trig/y[0] 1 2 1 2880 5380n
load net samples_reg[3][7] -attr @rip samples_reg[2][7]_0[7] -pin u_sensor samples_reg[2][7]_0[7] -pin u_vector p_1_in_1[7]
load net u_dados_n_265 -attr @rip VGA_R_OBUF[3]_inst_i_2869_5[1] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_5[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_2[1]
load net u_dados_n_19 -attr @rip O[1] -pin u_dados O[1] -pin u_vga O[1]
load net u_dados_n_105 -attr @rip heading_deg_reg[0]_9[1] -pin u_dados heading_deg_reg[0]_9[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4643_0[1]
load net u_dados_n_70 -pin u_dados v_cont_reg[5] -pin u_vga VGA_R_OBUF[3]_inst_i_65_0
netloc u_dados_n_70 1 3 1 9500 2980n
load net u_dados_n_323 -pin u_dados velocidade_kt_reg[1]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_1054_0
netloc u_dados_n_323 1 3 1 8620 3920n
load net u_vga_n_244 -attr @rip h_cont_reg[2]_rep__2_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1561[0] -pin u_vga h_cont_reg[2]_rep__2_1[0]
load net amostra_completa[40] -attr @rip Q[21] -pin u_dados Q[21] -pin u_entrada Q[21]
load net u_ui_test_n_162 -pin g_native_video.u_native FSM_onehot_state_reg[1]_0 -pin u_ui_test FSM_onehot_state_reg[1]
netloc u_ui_test_n_162 1 4 3 16300 900 NJ 900 18340
load net u_vga_n_302 -attr @rip SS[0] -pin g_native_video.u_native SS[0] -pin u_vga SS[0]
netloc u_vga_n_302 1 4 1 15400 1680n
load net card_coluna2_B_dspDelayedAccum[5] -attr @rip h_cont_reg[1]_rep__0_4[3] -pin u_dados VGA_R_OBUF[3]_inst_i_822_0[3] -pin u_vga h_cont_reg[1]_rep__0_4[3]
load net compass_gravity_z[2] -attr @rip Q[2] -pin g_mag_tilt.u_heading gz_reg[24]_0[2] -pin u_vector Q[2]
load net mpu_raw_ax[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[90] -pin u_sensor accel_x_reg[15]_0[90] -pin u_vector a_reg[0][15]_0[90]
load net native_app_addr[13] -attr @rip app_addr[10] -pin g_native_video.u_native app_addr[10] -pin u_ui_test app_addr[10]
load net metadados_in[4] -attr @rip Q[60] -pin u_dados Q[60] -pin u_entrada Q[60]
load net memory_and_vga/bridge/last_data[23] -attr @rip last_data_reg[125][23] -pin g_native_video.u_native last_data_reg[125][23] -pin u_ui_test wr_data2_carry__9[23]
load net memory_and_vga/bridge/last_data[87] -attr @rip last_data_reg[125][87] -pin g_native_video.u_native last_data_reg[125][87] -pin u_ui_test wr_data2_carry__9[87]
load net native_app_rd_data[121] -attr @rip din[121] -pin g_native_video.u_native din[121] -pin u_ui_test din[121]
load net native_app_wdf_data[121] -attr @rip dout[121] -pin g_native_video.u_native dout[121] -pin u_ui_test dout[121]
load net native_app_wdf_data[57] -attr @rip dout[57] -pin g_native_video.u_native dout[57] -pin u_ui_test dout[57]
load net native_app_rd_data[57] -attr @rip din[57] -pin g_native_video.u_native din[57] -pin u_ui_test din[57]
load net roll_sync[1] -attr @style dashed -attr @rip 1 -pin g_operacao.u_operacao estado_reg[7]_1[1] -pin u_sensor sensor_i_3_0[1] -pin u_vector roll_fallback_q10_reg[9][1]
load net roll_fallback_q10[0] -attr @rip roll_fallback_q10_reg[31]_0[0] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[0] -pin u_vector rw_reg_i_3_0[0]
load net pitch_fallback_q10[17] -attr @rip pitch_fallback_q10_reg[31]_1[17] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[17] -pin u_vector pw_reg[17]
load net u_vec/i[0] -attr @rip E[0] -pin g_mag_tilt.u_heading E[0] -pin u_vector E[0]
netloc u_vec/i[0] 1 2 1 3340 4160n
load net samples_reg[4][0] -attr @rip samples_reg[4][7]_0[8] -pin u_sensor samples_reg[4][7]_0[8] -pin u_vector p_1_in__0_0[8]
load net u_dados_n_187 -pin u_dados VGA_R_OBUF[3]_inst_i_3369 -pin u_vga VGA_R_OBUF[3]_inst_i_2155
netloc u_dados_n_187 1 3 1 10420 880n
load net u_dados_n_262 -attr @rip VGA_R_OBUF[3]_inst_i_3436_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_2[1]
load net u_dados_n_68 -attr @rip heading_deg_reg[0]_6[1] -pin u_dados heading_deg_reg[0]_6[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4701_0[1]
load net u_dados_n_102 -attr @rip heading_deg_reg[0]_8[0] -pin u_dados heading_deg_reg[0]_8[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4401_1[0]
load net u_dados_n_320 -pin u_dados heading_deg_reg[8]_rep_6 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_1
netloc u_dados_n_320 1 3 1 9480 2980n
load net g_overlay.u_alertas_vga/texto9131_in -pin u_dados texto9131_in -pin u_vga texto9131_in
netloc g_overlay.u_alertas_vga/texto9131_in 1 3 1 7460 3560n
load net g_native_video.u_native_n_409 -attr @rip odd_tag_reg[9][0] -pin g_native_video.u_native odd_tag_reg[9][0] -pin u_vga missing_lines_reg[0]_i_3_0[0]
load net u_sensor_n_8 -pin u_sensor sensor_ok_reg_0 -pin u_vector stale_reg[0]_1
netloc u_sensor_n_8 1 1 1 1330 4460n
load net usar_mpu -pin g_operacao.u_operacao usar_mpu -pin u_vector usar_mpu
netloc usar_mpu 1 0 3 80 6560 NJ 6560 2400
load net amostra_completa[39] -attr @rip Q[20] -pin u_dados Q[20] -pin u_entrada Q[20]
load net u_vga_n_241 -attr @rip h_cont_reg[2]_rep__2_1[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1561[3] -pin u_vga h_cont_reg[2]_rep__2_1[3]
load net card_coluna2_B_dspDelayedAccum[2] -attr @rip h_cont_reg[1]_rep__0_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_822_0[0] -pin u_vga h_cont_reg[1]_rep__0_4[0]
load net compass_gravity_y[23] -attr @rip gravity_y_reg[23]_0[23] -pin g_mag_tilt.u_heading gy_reg[24]_0[23] -pin u_vector gravity_y_reg[23]_0[23]
load net heading_deg[7] -attr @rip heading_deg_reg[7]_0[3] -pin u_dados heading_deg_reg[7]_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_1205[3]
load net mpu_raw_ax[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[89] -pin u_sensor accel_x_reg[15]_0[89] -pin u_vector a_reg[0][15]_0[89]
load net native_app_addr[12] -attr @rip app_addr[9] -pin g_native_video.u_native app_addr[9] -pin u_ui_test app_addr[9]
load net metadados_in[1] -attr @rip Q[57] -pin u_dados Q[57] -pin u_entrada Q[57]
load net memory_and_vga/bridge/last_data[20] -attr @rip last_data_reg[125][20] -pin g_native_video.u_native last_data_reg[125][20] -pin u_ui_test wr_data2_carry__9[20]
load net memory_and_vga/bridge/last_data[84] -attr @rip last_data_reg[125][84] -pin g_native_video.u_native last_data_reg[125][84] -pin u_ui_test wr_data2_carry__9[84]
load net native_app_rd_data[118] -attr @rip din[118] -pin g_native_video.u_native din[118] -pin u_ui_test din[118]
load net native_app_wdf_data[118] -attr @rip dout[118] -pin g_native_video.u_native dout[118] -pin u_ui_test dout[118]
load net native_app_wdf_data[54] -attr @rip dout[54] -pin g_native_video.u_native dout[54] -pin u_ui_test dout[54]
load net native_app_rd_data[54] -attr @rip din[54] -pin g_native_video.u_native din[54] -pin u_ui_test din[54]
load net samples_reg[3][6] -attr @rip samples_reg[2][7]_0[6] -pin u_sensor samples_reg[2][7]_0[6] -pin u_vector p_1_in_1[6]
load net pitch_fallback_q10[14] -attr @rip pitch_fallback_q10_reg[31]_1[14] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[14] -pin u_vector pw_reg[14]
load net u_dados_n_188 -pin u_dados VGA_R_OBUF[3]_inst_i_3385_0 -pin u_vga VGA_R_OBUF[3]_inst_i_2782
netloc u_dados_n_188 1 3 1 10400 900n
load net u_dados_n_321 -pin u_dados VGA_R_OBUF[3]_inst_i_1425_0 -pin u_vga VGA_R_OBUF[3]_inst_i_393_1
netloc u_dados_n_321 1 3 1 12060 200n
load net g_mag_tilt.u_heading_n_27 -pin g_mag_tilt.u_heading busy_reg -pin u_vector y_reg[31]
netloc g_mag_tilt.u_heading_n_27 1 1 3 1730 5620 NJ 5620 7380
load net u_dados_n_263 -attr @rip VGA_R_OBUF[3]_inst_i_3436_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_2[0]
load net u_hud_horizontal_adjust_n_21 -attr @style dashed -attr @rip B[0] -pin u_dados VGA_R_OBUF[3]_inst_i_369_0 -pin u_simbologia B[5]
netloc u_hud_horizontal_adjust_n_21 1 2 3 3560 9280 NJ 9280 16400J
load net u_dados_n_69 -attr @rip heading_deg_reg[0]_6[0] -pin u_dados heading_deg_reg[0]_6[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4701_0[0]
load net u_dados_n_103 -attr @rip heading_deg_reg[8]_0[0] -pin u_dados heading_deg_reg[8]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4401_0[0]
netloc u_dados_n_103 1 3 1 7920 3040n
load net u_vga_n_242 -attr @rip h_cont_reg[2]_rep__2_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1561[2] -pin u_vga h_cont_reg[2]_rep__2_1[2]
load net age_reg[0] -attr @rip age_reg[0]_0[0] -pin u_sensor age_reg[0] -pin u_vector age_reg[0]_0[0]
netloc age_reg[0] 1 0 3 360 5680 1650J 5660 2740
load net u_sensor_n_9 -attr @rip age_reg[0][0] -pin u_sensor age_reg[0][0] -pin u_vector age_reg[3]_0[0]
netloc u_sensor_n_9 1 1 1 1630 4240n
load net u_vga_n_300 -pin u_dados VGA_R_OBUF[3]_inst_i_394_0 -pin u_vga h_cont_reg[1]_rep__1_6
netloc u_vga_n_300 1 2 3 4320 6200 8600J 2020 14060
load net card_coluna2_B_dspDelayedAccum[3] -attr @rip h_cont_reg[1]_rep__0_4[1] -pin u_dados VGA_R_OBUF[3]_inst_i_822_0[1] -pin u_vga h_cont_reg[1]_rep__0_4[1]
load net compass_gravity_z[0] -attr @rip Q[0] -pin g_mag_tilt.u_heading gz_reg[24]_0[0] -pin u_vector Q[0]
load net heading_pendente[0] -attr @rip valido_destino_reg_0[0] -pin u_dados heading_pendente_reg[8]_0[0] -pin u_entrada valido_destino_reg_0[0]
netloc heading_pendente[0] 1 2 1 3500 3740n
load net mpu_raw_ax[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[87] -pin u_sensor accel_x_reg[15]_0[87] -pin u_vector a_reg[0][15]_0[87]
load net native_app_addr[10] -attr @rip app_addr[7] -pin g_native_video.u_native app_addr[7] -pin u_ui_test app_addr[7]
load net metadados_in[2] -attr @rip Q[58] -pin u_dados Q[58] -pin u_entrada Q[58]
load net memory_and_vga/bridge/last_data[21] -attr @rip last_data_reg[125][21] -pin g_native_video.u_native last_data_reg[125][21] -pin u_ui_test wr_data2_carry__9[21]
load net memory_and_vga/bridge/last_data[85] -attr @rip last_data_reg[125][85] -pin g_native_video.u_native last_data_reg[125][85] -pin u_ui_test wr_data2_carry__9[85]
load net native_app_rd_data[119] -attr @rip din[119] -pin g_native_video.u_native din[119] -pin u_ui_test din[119]
load net native_app_wdf_data[119] -attr @rip dout[119] -pin g_native_video.u_native dout[119] -pin u_ui_test dout[119]
load net native_app_wdf_data[55] -attr @rip dout[55] -pin g_native_video.u_native dout[55] -pin u_ui_test dout[55]
load net native_app_rd_data[55] -attr @rip din[55] -pin g_native_video.u_native din[55] -pin u_ui_test din[55]
load net roll_operacao_q10[31] -attr @rip roll_fallback_q10_reg[31]_1[0] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_1[0] -pin u_vector rw_reg_i_6_0[0]
netloc roll_operacao_q10[31] 1 1 1 1430 5080n
load net pitch_fallback_q10[15] -attr @rip pitch_fallback_q10_reg[31]_1[15] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[15] -pin u_vector pw_reg[15]
load net u_dados_n_268 -attr @rip VGA_R_OBUF[3]_inst_i_3436_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_1[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_0[2]
load net u_dados_n_192 -pin u_dados altitude_ft_reg[5]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3957_1
netloc u_dados_n_192 1 3 1 7280 1580n
load net u_dados_n_73 -pin u_dados h_cont_reg[1]_rep__0 -pin u_vga VGA_R_OBUF[3]_inst_i_408_0
netloc u_dados_n_73 1 3 1 10880 1980n
load net u_dados_n_326 -pin u_dados velocidade_kt_reg[0]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_766_0
netloc u_dados_n_326 1 3 1 11520 3580n
load net u_dados_n_108 -attr @rip heading_deg_reg[0]_10[2] -pin u_dados heading_deg_reg[0]_10[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4424_1[2]
load net u_vga_n_247 -attr @rip h_cont_reg[6]_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1578[0] -pin u_vga h_cont_reg[6]_5[0]
netloc u_vga_n_247 1 2 3 4980 8340 NJ 8340 15300
load net amostra_completa[43] -attr @rip Q[24] -pin u_dados Q[24] -pin u_entrada Q[24]
load net u_ui_test_n_167 -attr @rip S[1] -pin g_native_video.u_native S[1] -pin u_ui_test S[1]
load net DDR2_STATUS_LED_OBUF[1] -attr @style dashed -pin g_native_video.u_native init_calib_complete -pin u_ui_test init_calib_complete
netloc DDR2_STATUS_LED_OBUF[1] 1 4 3 15860 980 NJ 980 18220
load net card_coluna4[3] -attr @rip h_cont_reg[7]_0[2] -pin u_dados VGA_R_OBUF[3]_inst_i_822_1[2] -pin u_vga h_cont_reg[7]_0[2]
load net compass_gravity_z[5] -attr @rip Q[5] -pin g_mag_tilt.u_heading gz_reg[24]_0[5] -pin u_vector Q[5]
load net mpu_raw_ax[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[93] -pin u_sensor accel_x_reg[15]_0[93] -pin u_vector a_reg[0][15]_0[93]
load net native_app_addr[16] -attr @rip app_addr[13] -pin g_native_video.u_native app_addr[13] -pin u_ui_test app_addr[13]
load net metadados_in[10] -attr @rip Q[65] -pin u_dados Q[65] -pin u_entrada Q[65]
load net memory_and_vga/bridge/last_data[26] -attr @rip last_data_reg[125][26] -pin g_native_video.u_native last_data_reg[125][26] -pin u_ui_test wr_data2_carry__9[26]
load net memory_and_vga/bridge/last_data[90] -attr @rip last_data_reg[125][90] -pin g_native_video.u_native last_data_reg[125][90] -pin u_ui_test wr_data2_carry__9[90]
load net native_app_rd_data[124] -attr @rip din[124] -pin g_native_video.u_native din[124] -pin u_ui_test din[124]
load net native_app_wdf_data[124] -attr @rip dout[124] -pin g_native_video.u_native dout[124] -pin u_ui_test dout[124]
load net native_app_wdf_data[60] -attr @rip dout[60] -pin g_native_video.u_native dout[60] -pin u_ui_test dout[60]
load net native_app_rd_data[60] -attr @rip din[60] -pin g_native_video.u_native din[60] -pin u_ui_test din[60]
load net roll_fallback_q10[3] -attr @rip roll_fallback_q10_reg[31]_0[3] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[3] -pin u_vector rw_reg_i_3_0[3]
load net vector_roll[31] -attr @style dashed -attr @rip roll_reg[31]_0[19] -pin g_operacao.u_operacao meta_reg[3][19] -pin u_vector roll_reg[31]_0[19]
load net samples_reg[4][3] -attr @rip samples_reg[4][7]_0[11] -pin u_sensor samples_reg[4][7]_0[11] -pin u_vector p_1_in__0_0[11]
load net pitch_fallback_q10[20] -attr @rip pitch_fallback_q10_reg[31]_1[20] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[20] -pin u_vector pw_reg[20]
load net u_dados_n_269 -attr @rip VGA_R_OBUF[3]_inst_i_3436_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_0[1]
load net u_dados_n_74 -pin u_dados VGA_R_OBUF[3]_inst_i_2269_0 -pin u_vga VGA_R_OBUF[3]_inst_i_823_0
netloc u_dados_n_74 1 3 1 8800 560n
load net u_dados_n_193 -pin u_dados altitude_ft_reg[4]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3957_0
netloc u_dados_n_193 1 3 1 8500 1540n
load net u_dados_n_327 -pin u_dados velocidade_kt_reg[1]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_1054_1
netloc u_dados_n_327 1 3 1 8880 3940n
load net u_dados_n_109 -attr @rip heading_deg_reg[0]_10[1] -pin u_dados heading_deg_reg[0]_10[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4424_1[1]
load net amostra_completa[44] -attr @rip Q[25] -pin u_dados Q[25] -pin u_entrada Q[25]
load net u_vga_n_248 -attr @rip h_cont_reg[3]_rep__1_4[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1122[3] -pin u_vga h_cont_reg[3]_rep__1_4[3]
load net u_vga_n_36 -pin u_dados VGA_R_OBUF[3]_inst_i_408_0 -pin u_vga v_cont_reg[5]_1
netloc u_vga_n_36 1 2 3 3660 9100 NJ 9100 14360
load net u_ui_test_n_168 -attr @rip S[0] -pin g_native_video.u_native S[0] -pin u_ui_test S[0]
load net card_coluna4[4] -attr @rip h_cont_reg[7]_0[3] -pin u_dados VGA_R_OBUF[3]_inst_i_822_1[3] -pin u_vga h_cont_reg[7]_0[3]
load net compass_gravity_z[6] -attr @rip Q[6] -pin g_mag_tilt.u_heading gz_reg[24]_0[6] -pin u_vector Q[6]
load net mpu_raw_ax[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[94] -pin u_sensor accel_x_reg[15]_0[94] -pin u_vector a_reg[0][15]_0[94]
load net native_app_addr[17] -attr @rip app_addr[14] -pin g_native_video.u_native app_addr[14] -pin u_ui_test app_addr[14]
load net memory_and_vga/bridge/last_data[27] -attr @rip last_data_reg[125][27] -pin g_native_video.u_native last_data_reg[125][27] -pin u_ui_test wr_data2_carry__9[27]
load net memory_and_vga/bridge/last_data[91] -attr @rip last_data_reg[125][91] -pin g_native_video.u_native last_data_reg[125][91] -pin u_ui_test wr_data2_carry__9[91]
load net native_app_rd_data[125] -attr @rip din[125] -pin g_native_video.u_native din[125] -pin u_ui_test din[125]
load net native_app_rd_data[61] -attr @rip din[61] -pin g_native_video.u_native din[61] -pin u_ui_test din[61]
load net native_app_wdf_data[125] -attr @rip dout[125] -pin g_native_video.u_native dout[125] -pin u_ui_test dout[125]
load net native_app_wdf_data[61] -attr @rip dout[61] -pin g_native_video.u_native dout[61] -pin u_ui_test dout[61]
load net pitch_fallback_q10[21] -attr @rip pitch_fallback_q10_reg[31]_1[21] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[21] -pin u_vector pw_reg[21]
load net roll_fallback_q10[4] -attr @rip roll_fallback_q10_reg[31]_0[4] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[4] -pin u_vector rw_reg_i_3_0[4]
load net samples_reg[4][4] -attr @rip samples_reg[4][7]_0[12] -pin u_sensor samples_reg[4][7]_0[12] -pin u_vector p_1_in__0_0[12]
load net u_dados_n_266 -attr @rip VGA_R_OBUF[3]_inst_i_2869_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_5[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_2[0]
load net u_dados_n_71 -pin u_dados VGA_R_OBUF[3]_inst_i_1164_0 -pin u_vga VGA_R_OBUF[3]_inst_i_408_2
netloc u_dados_n_71 1 3 1 12000 180n
load net u_dados_n_190 -pin u_dados altitude_ft_reg[3]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1604_1
netloc u_dados_n_190 1 3 1 11580 1360n
load net u_dados_n_106 -attr @rip heading_deg_reg[0]_9[0] -pin u_dados heading_deg_reg[0]_9[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4643_0[0]
load net u_dados_n_324 -pin u_dados velocidade_kt_reg[0]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_766_1
netloc u_dados_n_324 1 3 1 9520 3600n
load net u_vga_n_31 -pin u_dados VGA_R_OBUF[3]_inst_i_159 -pin u_vga v_cont_reg[5]_0
netloc u_vga_n_31 1 2 3 3940 9080 NJ 9080 14420
load net amostra_completa[41] -attr @rip Q[22] -pin u_dados Q[22] -pin u_entrada Q[22]
load net u_vga_n_245 -attr @rip h_cont_reg[5]_rep_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1118[0] -pin u_vga h_cont_reg[5]_rep_2[0]
netloc u_vga_n_245 1 2 3 5020 8260 NJ 8260 15380
load net u_ui_test_n_165 -attr @rip S[3] -pin g_native_video.u_native S[3] -pin u_ui_test S[3]
load net card_coluna4[1] -attr @rip h_cont_reg[7]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_822_1[0] -pin u_vga h_cont_reg[7]_0[0]
load net compass_gravity_z[3] -attr @rip Q[3] -pin g_mag_tilt.u_heading gz_reg[24]_0[3] -pin u_vector Q[3]
load net mpu_raw_ax[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[91] -pin u_sensor accel_x_reg[15]_0[91] -pin u_vector a_reg[0][15]_0[91]
load net native_app_addr[14] -attr @rip app_addr[11] -pin g_native_video.u_native app_addr[11] -pin u_ui_test app_addr[11]
load net metadados_in[5] -attr @rip Q[61] -pin u_dados Q[61] -pin u_entrada Q[61]
load net memory_and_vga/bridge/last_data[24] -attr @rip last_data_reg[125][24] -pin g_native_video.u_native last_data_reg[125][24] -pin u_ui_test wr_data2_carry__9[24]
load net memory_and_vga/bridge/last_data[88] -attr @rip last_data_reg[125][88] -pin g_native_video.u_native last_data_reg[125][88] -pin u_ui_test wr_data2_carry__9[88]
load net native_app_rd_data[122] -attr @rip din[122] -pin g_native_video.u_native din[122] -pin u_ui_test din[122]
load net native_app_wdf_data[122] -attr @rip dout[122] -pin g_native_video.u_native dout[122] -pin u_ui_test dout[122]
load net native_app_wdf_data[58] -attr @rip dout[58] -pin g_native_video.u_native dout[58] -pin u_ui_test dout[58]
load net native_app_rd_data[58] -attr @rip din[58] -pin g_native_video.u_native din[58] -pin u_ui_test din[58]
load net roll_fallback_q10[1] -attr @rip roll_fallback_q10_reg[31]_0[1] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[1] -pin u_vector rw_reg_i_3_0[1]
load net pitch_fallback_q10[18] -attr @rip pitch_fallback_q10_reg[31]_1[18] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[18] -pin u_vector pw_reg[18]
load net samples_reg[4][1] -attr @rip samples_reg[4][7]_0[9] -pin u_sensor samples_reg[4][7]_0[9] -pin u_vector p_1_in__0_0[9]
load net u_dados_n_267 -attr @rip VGA_R_OBUF[3]_inst_i_3436_1[3] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_1[3] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_0[3]
load net u_dados_n_191 -pin u_dados altitude_ft_reg[3]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1604_0
netloc u_dados_n_191 1 3 1 11560 1380n
load net u_dados_n_72 -pin u_dados h_cont_reg[7] -pin u_vga VGA_R_OBUF[3]_inst_i_408_1
netloc u_dados_n_72 1 3 1 8740 2120n
load net u_dados_n_325 -pin u_dados velocidade_kt_reg[0]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_766_2
netloc u_dados_n_325 1 3 1 11540 3620n
load net u_dados_n_107 -attr @rip heading_deg_reg[0]_10[3] -pin u_dados heading_deg_reg[0]_10[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4424_1[3]
load net u_vga_n_32 -attr @rip CO[0] -pin u_dados CO[0] -pin u_vga CO[0]
netloc u_vga_n_32 1 2 3 4040 4340 9420J 520 15040
load net amostra_completa[42] -attr @rip Q[23] -pin u_dados Q[23] -pin u_entrada Q[23]
load net u_vga_n_246 -pin u_dados VGA_R_OBUF[3]_inst_i_393_0 -pin u_vga h_cont_reg[6]_4
netloc u_vga_n_246 1 2 3 4180 8320 NJ 8320 15320
load net u_ui_test_n_166 -attr @rip S[2] -pin g_native_video.u_native S[2] -pin u_ui_test S[2]
load net card_coluna4[2] -attr @rip h_cont_reg[7]_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_822_1[1] -pin u_vga h_cont_reg[7]_0[1]
load net compass_gravity_z[4] -attr @rip Q[4] -pin g_mag_tilt.u_heading gz_reg[24]_0[4] -pin u_vector Q[4]
load net mpu_raw_ax[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[92] -pin u_sensor accel_x_reg[15]_0[92] -pin u_vector a_reg[0][15]_0[92]
load net native_app_addr[15] -attr @rip app_addr[12] -pin g_native_video.u_native app_addr[12] -pin u_ui_test app_addr[12]
load net mira_y_in[0] -attr @rip Q[10] -pin u_dados Q[10] -pin u_entrada Q[10]
load net metadados_in[7] -attr @rip Q[62] -pin u_dados Q[62] -pin u_entrada Q[62]
load net memory_and_vga/bridge/last_data[25] -attr @rip last_data_reg[125][25] -pin g_native_video.u_native last_data_reg[125][25] -pin u_ui_test wr_data2_carry__9[25]
load net memory_and_vga/bridge/last_data[89] -attr @rip last_data_reg[125][89] -pin g_native_video.u_native last_data_reg[125][89] -pin u_ui_test wr_data2_carry__9[89]
load net native_app_rd_data[123] -attr @rip din[123] -pin g_native_video.u_native din[123] -pin u_ui_test din[123]
load net native_app_wdf_data[123] -attr @rip dout[123] -pin g_native_video.u_native dout[123] -pin u_ui_test dout[123]
load net native_app_wdf_data[59] -attr @rip dout[59] -pin g_native_video.u_native dout[59] -pin u_ui_test dout[59]
load net native_app_rd_data[59] -attr @rip din[59] -pin g_native_video.u_native din[59] -pin u_ui_test din[59]
load net samples_reg[4][2] -attr @rip samples_reg[4][7]_0[10] -pin u_sensor samples_reg[4][7]_0[10] -pin u_vector p_1_in__0_0[10]
load net roll_fallback_q10[2] -attr @rip roll_fallback_q10_reg[31]_0[2] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[2] -pin u_vector rw_reg_i_3_0[2]
load net pitch_fallback_q10[19] -attr @rip pitch_fallback_q10_reg[31]_1[19] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[19] -pin u_vector pw_reg[19]
load net g_operacao.u_operacao_n_66 -attr @rip S[0] -pin g_operacao.u_operacao S[0] -pin u_vector rc_reg_i_15_1[0]
netloc g_operacao.u_operacao_n_66 1 1 1 1290 4960n
load net u_dados_n_315 -pin u_dados VGA_R_OBUF[3]_inst_i_2061_0 -pin u_vga VGA_R_OBUF[3]_inst_i_786_0
netloc u_dados_n_315 1 3 1 11800 460n
load net u_dados_n_257 -attr @rip VGA_R_OBUF[3]_inst_i_3980_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3980_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_1[0]
load net u_dados_n_62 -attr @rip h_cont_reg[9]_2[0] -pin u_dados h_cont_reg[9]_2[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2933[0]
load net u_dados_n_181 -pin u_dados metadados_reg[12]_5 -pin u_vga VGA_R_OBUF[3]_inst_i_31_2
netloc u_dados_n_181 1 3 1 11280 2820n
load net g_native_video.u_native_n_403 -attr @rip odd_tag_reg[9][6] -pin g_native_video.u_native odd_tag_reg[9][6] -pin u_vga missing_lines_reg[0]_i_3_0[6]
load net u_vga_n_236 -pin u_dados VGA_R_OBUF[3]_inst_i_1631_0 -pin u_vga v_cont_reg[7]_rep_5
netloc u_vga_n_236 1 2 3 3680 9180 NJ 9180 14160
load net u_sensor_n_10 -pin u_sensor sensor_ok_reg_1 -pin u_vector magnitude_product_reg[15]_0
netloc u_sensor_n_10 1 1 1 1410 4480n
load net u_vector_n_248 -pin g_operacao.u_operacao pw_reg_1 -pin u_vector pitch_fallback_q10_reg[31]_3
netloc u_vector_n_248 1 0 3 300 6480 NJ 6480 2600
load net u_vga_n_294 -attr @rip h_cont_reg[0]_rep__0_2[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1567_0[1] -pin u_vga h_cont_reg[0]_rep__0_2[1]
load net u_vga_n_96 -pin u_dados VGA_R_OBUF[3]_inst_i_1167_1 -pin u_vga h_cont_reg[1]_rep__1_0
netloc u_vga_n_96 1 2 3 5540 4420 9900J 600 15000
load net card_codigo3[5] -attr @rip heading_deg_reg[0]_0[2] -pin u_dados heading_deg_reg[0]_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[2]
load net compass_gravity_y[17] -attr @rip gravity_y_reg[23]_0[17] -pin g_mag_tilt.u_heading gy_reg[24]_0[17] -pin u_vector gravity_y_reg[23]_0[17]
load net hud_pixel_y[2] -attr @style dashed -attr @rip B[2] -pin u_dados hud_pixel_y[2] -pin u_simbologia u[2]
load net mpu_raw_ax[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[81] -pin u_sensor accel_x_reg[15]_0[81] -pin u_vector a_reg[0][15]_0[81]
load net native_app_addr[4] -attr @rip app_addr[1] -pin g_native_video.u_native app_addr[1] -pin u_ui_test app_addr[1]
load net memory_and_vga/bridge/last_data[14] -attr @rip last_data_reg[125][14] -pin g_native_video.u_native last_data_reg[125][14] -pin u_ui_test wr_data2_carry__9[14]
load net memory_and_vga/bridge/last_data[78] -attr @rip last_data_reg[125][78] -pin g_native_video.u_native last_data_reg[125][78] -pin u_ui_test wr_data2_carry__9[78]
load net memory_and_vga/vga/next_y[0] -attr @rip v_cont_reg[7]_rep_0[0] -pin g_native_video.u_native fetch_line_reg[9]_0[0] -pin u_vga v_cont_reg[7]_rep_0[0]
load net native_app_rd_data[112] -attr @rip din[112] -pin g_native_video.u_native din[112] -pin u_ui_test din[112]
load net native_app_wdf_data[112] -attr @rip dout[112] -pin g_native_video.u_native dout[112] -pin u_ui_test dout[112]
load net native_app_wdf_data[48] -attr @rip dout[48] -pin g_native_video.u_native dout[48] -pin u_ui_test dout[48]
load net native_app_rd_data[48] -attr @rip din[48] -pin g_native_video.u_native din[48] -pin u_ui_test din[48]
load net roll_fallback_q10_next[25] -attr @rip roll_sync_reg[0]_0[25] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[25] -pin u_vector roll_sync_reg[0]_0[25]
load net pitch_fallback_q10[7] -attr @rip pitch_fallback_q10_reg[31]_1[7] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[7] -pin u_vector pw_reg[7]
load net samples_reg[3][0] -attr @rip samples_reg[2][7]_0[0] -pin u_sensor samples_reg[2][7]_0[0] -pin u_vector p_1_in_1[0]
load net g_operacao.u_operacao_n_67 -pin g_operacao.u_operacao g_idade[0].recentes_reg[0]_1 -pin u_vector pc_reg
netloc g_operacao.u_operacao_n_67 1 1 1 1270 4840n
load net u_dados_n_316 -pin u_dados VGA_R_OBUF[3]_inst_i_1562 -pin u_vga VGA_R_OBUF[3]_inst_i_786_1
netloc u_dados_n_316 1 3 1 11940 280n
load net u_dados_n_258 -attr @rip VGA_R_OBUF[3]_inst_i_3431_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3431_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1631_2[0]
netloc u_dados_n_258 1 3 1 7660 960n
load net u_dados_n_182 -pin u_dados metadados_reg[25]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_77_0
netloc u_dados_n_182 1 3 1 9520 3080n
load net alvo -pin u_dados alvo -pin u_simbologia alvo -pin u_vga alvo
netloc alvo 1 3 2 8420 9300 NJ
load net u_dados_n_63 -attr @rip heading_deg_reg[0]_5[0] -pin u_dados heading_deg_reg[0]_5[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2260_0[0]
netloc u_dados_n_63 1 3 1 10600 2360n
load net g_native_video.u_native_n_404 -attr @rip odd_tag_reg[9][5] -pin g_native_video.u_native odd_tag_reg[9][5] -pin u_vga missing_lines_reg[0]_i_3_0[5]
load net u_sensor_n_11 -pin u_sensor sensor_ok_reg_2 -pin u_vector zero_set_reg_0
netloc u_sensor_n_11 1 1 1 1250 4500n
load net u_vga_n_237 -pin u_dados VGA_R_OBUF[3]_inst_i_3346_1 -pin u_vga v_cont_reg[7]_rep_6
netloc u_vga_n_237 1 2 3 3640 9200 NJ 9200 14080
load net u_vector_n_249 -pin g_operacao.u_operacao pc_i_12 -pin u_vector pitch_reg[22]_0
netloc u_vector_n_249 1 0 3 180 6500 NJ 6500 2420
load net u_vga_n_295 -attr @rip h_cont_reg[0]_rep__0_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1567_0[0] -pin u_vga h_cont_reg[0]_rep__0_2[0]
load net card_codigo3[6] -attr @rip heading_deg_reg[0]_0[3] -pin u_dados heading_deg_reg[0]_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[3]
load net compass_gravity_y[18] -attr @rip gravity_y_reg[23]_0[18] -pin g_mag_tilt.u_heading gy_reg[24]_0[18] -pin u_vector gravity_y_reg[23]_0[18]
load net hud_pixel_y[3] -attr @style dashed -attr @rip B[3] -pin u_dados hud_pixel_y[3] -pin u_simbologia u[3]
load net mpu_raw_ax[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[82] -pin u_sensor accel_x_reg[15]_0[82] -pin u_vector a_reg[0][15]_0[82]
load net native_app_addr[5] -attr @rip app_addr[2] -pin g_native_video.u_native app_addr[2] -pin u_ui_test app_addr[2]
load net memory_and_vga/bridge/last_data[15] -attr @rip last_data_reg[125][15] -pin g_native_video.u_native last_data_reg[125][15] -pin u_ui_test wr_data2_carry__9[15]
load net memory_and_vga/bridge/last_data[79] -attr @rip last_data_reg[125][79] -pin g_native_video.u_native last_data_reg[125][79] -pin u_ui_test wr_data2_carry__9[79]
load net memory_and_vga/vga/p_0_in__1[3] -attr @rip p_0_in__1[0] -pin g_native_video.u_native p_0_in__1[0] -pin u_vga p_0_in__1[0]
load net native_app_rd_data[113] -attr @rip din[113] -pin g_native_video.u_native din[113] -pin u_ui_test din[113]
load net native_app_wdf_data[113] -attr @rip dout[113] -pin g_native_video.u_native dout[113] -pin u_ui_test dout[113]
load net native_app_wdf_data[49] -attr @rip dout[49] -pin g_native_video.u_native dout[49] -pin u_ui_test dout[49]
load net native_app_rd_data[49] -attr @rip din[49] -pin g_native_video.u_native din[49] -pin u_ui_test din[49]
load net roll_fallback_q10_next[26] -attr @rip roll_sync_reg[0]_0[26] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[26] -pin u_vector roll_sync_reg[0]_0[26]
load net pitch_fallback_q10[8] -attr @rip pitch_fallback_q10_reg[31]_1[8] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[8] -pin u_vector pw_reg[8]
load net samples_reg[3][1] -attr @rip samples_reg[2][7]_0[1] -pin u_sensor samples_reg[2][7]_0[1] -pin u_vector p_1_in_1[1]
load net u_alertas/ar0[11] -attr @rip roll_reg[16]_0[2] -pin g_operacao.u_operacao ar0[2] -pin u_vector roll_reg[16]_0[2]
load net u_dados_n_313 -pin u_dados altitude_ft_reg[16]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1546_1
netloc u_dados_n_313 1 3 1 7080 1720n
load net u_dados_n_255 -attr @rip VGA_R_OBUF[3]_inst_i_3980_0[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3980_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_1[2]
load net u_dados_n_60 -attr @rip h_cont_reg[9]_2[2] -pin u_dados h_cont_reg[9]_2[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2933[2]
load net u_dados_n_178 -pin u_dados metadados_reg[0]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_23_0
netloc u_dados_n_178 1 3 1 9460 2760n
load net g_native_video.u_native_n_401 -attr @rip even_tag_reg[9][1] -pin g_native_video.u_native even_tag_reg[9][1] -pin u_vga missing_lines_reg[0]_i_3_1[1]
load net u_vga_n_292 -attr @rip h_cont_reg[0]_rep__0_2[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1567_0[3] -pin u_vga h_cont_reg[0]_rep__0_2[3]
load net u_vector_n_246 -pin g_operacao.u_operacao pc_reg -pin u_vector pitch_fallback_q10_reg[31]_1
netloc u_vector_n_246 1 0 3 220 6440 NJ 6440 2640
load net u_vga_n_94 -pin u_dados VGA_R_OBUF[3]_inst_i_839_1 -pin u_vga heading_deg_reg[8]_rep_4
netloc u_vga_n_94 1 2 3 4420 8800 NJ 8800 14780
load net card_codigo3[3] -attr @rip heading_deg_reg[0]_0[0] -pin u_dados heading_deg_reg[0]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[0]
load net compass_gravity_y[15] -attr @rip gravity_y_reg[23]_0[15] -pin g_mag_tilt.u_heading gy_reg[24]_0[15] -pin u_vector gravity_y_reg[23]_0[15]
load net hud_pixel_x[9] -attr @style dashed -attr @rip hud_pixel_x[7] -pin u_dados hud_pixel_x[7] -pin u_vga hud_pixel_x[3]
load net mpu_gyro_z[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[15] -pin u_sensor accel_x_reg[15]_0[15] -pin u_vector a_reg[0][15]_0[15]
load net memory_and_vga/bridge/last_data[12] -attr @rip last_data_reg[125][12] -pin g_native_video.u_native last_data_reg[125][12] -pin u_ui_test wr_data2_carry__9[12]
load net memory_and_vga/bridge/last_data[76] -attr @rip last_data_reg[125][76] -pin g_native_video.u_native last_data_reg[125][76] -pin u_ui_test wr_data2_carry__9[76]
load net memory_and_vga/vga/future_word[4] -attr @rip ADDRA[4] -pin g_native_video.u_native ADDRA[4] -pin u_vga ADDRA[4]
load net mpu_raw_gy[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[31] -pin u_sensor accel_x_reg[15]_0[31] -pin u_vector a_reg[0][15]_0[31]
load net native_app_rd_data[110] -attr @rip din[110] -pin g_native_video.u_native din[110] -pin u_ui_test din[110]
load net native_app_rd_data[46] -attr @rip din[46] -pin g_native_video.u_native din[46] -pin u_ui_test din[46]
load net native_app_wdf_data[110] -attr @rip dout[110] -pin g_native_video.u_native dout[110] -pin u_ui_test dout[110]
load net native_app_wdf_data[46] -attr @rip dout[46] -pin g_native_video.u_native dout[46] -pin u_ui_test dout[46]
load net roll_fallback_q10_next[23] -attr @rip roll_sync_reg[0]_0[23] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[23] -pin u_vector roll_sync_reg[0]_0[23]
load net u_alertas/ar0[1] -attr @rip roll_reg[16]_0[0] -pin g_operacao.u_operacao ar0[0] -pin u_vector roll_reg[16]_0[0]
load net pitch_fallback_q10[6] -attr @rip pitch_fallback_q10_reg[31]_1[6] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[6] -pin u_vector pw_reg[6]
load net u_dados_n_256 -attr @rip VGA_R_OBUF[3]_inst_i_3980_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3980_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_1[1]
load net u_dados_n_18 -attr @rip O[2] -pin u_dados O[2] -pin u_vga O[2]
load net g_operacao.u_operacao_n_65 -pin g_operacao.u_operacao fase_pouso_reg[2] -pin u_vector rw_reg_i_23_1
netloc g_operacao.u_operacao_n_65 1 1 1 1190 5060n
load net u_dados_n_314 -pin u_dados altitude_ft_reg[16]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1546_0
netloc u_dados_n_314 1 3 1 7400 1740n
load net u_dados_n_61 -attr @rip h_cont_reg[9]_2[1] -pin u_dados h_cont_reg[9]_2[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2933[1]
load net g_native_video.u_native_n_402 -attr @rip even_tag_reg[9][0] -pin g_native_video.u_native even_tag_reg[9][0] -pin u_vga missing_lines_reg[0]_i_3_1[0]
load net u_vga_n_235 -pin u_dados VGA_R_OBUF[3]_inst_i_1631 -pin u_vga v_cont_reg[6]_rep__0_0
netloc u_vga_n_235 1 2 3 3620 9120 NJ 9120 14320
load net u_vector_n_247 -pin g_operacao.u_operacao pw_reg_2 -pin u_vector pitch_fallback_q10_reg[31]_2
netloc u_vector_n_247 1 0 3 200 6460 NJ 6460 2620
load net u_vga_n_293 -attr @rip h_cont_reg[0]_rep__0_2[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1567_0[2] -pin u_vga h_cont_reg[0]_rep__0_2[2]
load net card_codigo3[4] -attr @rip heading_deg_reg[0]_0[1] -pin u_dados heading_deg_reg[0]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[1]
load net compass_gravity_y[16] -attr @rip gravity_y_reg[23]_0[16] -pin g_mag_tilt.u_heading gy_reg[24]_0[16] -pin u_vector gravity_y_reg[23]_0[16]
load net hud_pixel_y[1] -attr @style dashed -attr @rip B[1] -pin u_dados hud_pixel_y[1] -pin u_simbologia u[1]
load net mpu_raw_ax[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[80] -pin u_sensor accel_x_reg[15]_0[80] -pin u_vector a_reg[0][15]_0[80]
load net native_app_addr[3] -attr @rip app_addr[0] -pin g_native_video.u_native app_addr[0] -pin u_ui_test app_addr[0]
load net memory_and_vga/bridge/last_data[13] -attr @rip last_data_reg[125][13] -pin g_native_video.u_native last_data_reg[125][13] -pin u_ui_test wr_data2_carry__9[13]
load net memory_and_vga/bridge/last_data[77] -attr @rip last_data_reg[125][77] -pin g_native_video.u_native last_data_reg[125][77] -pin u_ui_test wr_data2_carry__9[77]
load net memory_and_vga/vga/future_x[9] -attr @rip future_x[0] -pin g_native_video.u_native future_x[0] -pin u_vga future_x[0]
netloc memory_and_vga/vga/future_x[9] 1 4 1 15520 1960n
load net native_app_rd_data[111] -attr @rip din[111] -pin g_native_video.u_native din[111] -pin u_ui_test din[111]
load net native_app_rd_data[47] -attr @rip din[47] -pin g_native_video.u_native din[47] -pin u_ui_test din[47]
load net native_app_wdf_data[111] -attr @rip dout[111] -pin g_native_video.u_native dout[111] -pin u_ui_test dout[111]
load net native_app_wdf_data[47] -attr @rip dout[47] -pin g_native_video.u_native dout[47] -pin u_ui_test dout[47]
load net roll_fallback_q10_next[24] -attr @rip roll_sync_reg[0]_0[24] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[24] -pin u_vector roll_sync_reg[0]_0[24]
load net pitch_fallback_q10[9] -attr @rip pitch_fallback_q10_reg[31]_1[9] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[9] -pin u_vector pw_reg[9]
load net samples_reg[2][7] -attr @rip samples_reg[2][7]_0[15] -pin u_sensor samples_reg[2][7]_0[15] -pin u_vector p_1_in_1[15]
load net u_alertas/ar0[10] -attr @rip roll_reg[16]_0[1] -pin g_operacao.u_operacao ar0[1] -pin u_vector roll_reg[16]_0[1]
load net u_dados_n_260 -attr @rip VGA_R_OBUF[3]_inst_i_3431_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3431_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_3[0]
load net g_overlay.u_alertas_vga/on2264_in -pin u_dados on2264_in -pin u_vga on2264_in
netloc g_overlay.u_alertas_vga/on2264_in 1 3 1 7580 3520n
load net u_dados_n_185 -pin u_dados altitude_ft_reg[3]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1141_0
netloc u_dados_n_185 1 3 1 11680 1300n
load net u_dados_n_319 -attr @rip heading_deg_reg[8]_rep_5[0] -pin u_dados heading_deg_reg[8]_rep_5[0] -pin u_vga VGA_R_OBUF[3]_inst_i_835_0[0]
netloc u_dados_n_319 1 3 1 11320 2960n
load net u_dados_n_66 -attr @rip heading_deg_reg[0]_6[3] -pin u_dados heading_deg_reg[0]_6[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4701_0[3]
load net u_dados_n_100 -attr @rip heading_deg_reg[0]_8[2] -pin u_dados heading_deg_reg[0]_8[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4401_1[2]
load net g_native_video.u_native_n_407 -attr @rip odd_tag_reg[9][2] -pin g_native_video.u_native odd_tag_reg[9][2] -pin u_vga missing_lines_reg[0]_i_3_0[2]
load net u_sensor_n_2 -pin u_sensor operation_reg[2]_0 -pin u_vector p_1_in_0
netloc u_sensor_n_2 1 1 1 1470 4380n
load net u_vga_n_298 -pin u_dados VGA_R_OBUF[3]_inst_i_2781_0 -pin u_vga altitude_ft_reg[8]_3
netloc u_vga_n_298 1 2 3 5380 5980 9440J 1800 14180
load net u_vga_n_24 -pin u_dados VGA_R_OBUF[3]_inst_i_1168_0 -pin u_vga h_cont_reg[1]_rep__0_1
netloc u_vga_n_24 1 2 3 5580 4380 9860J 560 14820
load net u_vga_n_16 -pin g_native_video.u_native VGA_G_OBUF[1]_inst_i_2 -pin u_vga h_cont_reg[0]_rep__0_0
netloc u_vga_n_16 1 4 1 15440 1700n
load net card_codigo3[9] -attr @rip heading_deg_reg[0]_0[6] -pin u_dados heading_deg_reg[0]_0[6] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[6]
load net compass_gravity_y[21] -attr @rip gravity_y_reg[23]_0[21] -pin g_mag_tilt.u_heading gy_reg[24]_0[21] -pin u_vector gravity_y_reg[23]_0[21]
load net mpu_raw_ax[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[85] -pin u_sensor accel_x_reg[15]_0[85] -pin u_vector a_reg[0][15]_0[85]
load net native_app_addr[8] -attr @rip app_addr[5] -pin g_native_video.u_native app_addr[5] -pin u_ui_test app_addr[5]
load net memory_and_vga/bridge/last_data[18] -attr @rip last_data_reg[125][18] -pin g_native_video.u_native last_data_reg[125][18] -pin u_ui_test wr_data2_carry__9[18]
load net memory_and_vga/bridge/last_data[82] -attr @rip last_data_reg[125][82] -pin g_native_video.u_native last_data_reg[125][82] -pin u_ui_test wr_data2_carry__9[82]
load net memory_and_vga/vga/p_0_in__1[6] -attr @rip p_0_in__1[3] -pin g_native_video.u_native p_0_in__1[3] -pin u_vga p_0_in__1[3]
load net native_app_rd_data[116] -attr @rip din[116] -pin g_native_video.u_native din[116] -pin u_ui_test din[116]
load net native_app_wdf_data[116] -attr @rip dout[116] -pin g_native_video.u_native dout[116] -pin u_ui_test dout[116]
load net native_app_wdf_data[52] -attr @rip dout[52] -pin g_native_video.u_native dout[52] -pin u_ui_test dout[52]
load net native_app_rd_data[52] -attr @rip din[52] -pin g_native_video.u_native din[52] -pin u_ui_test din[52]
load net samples_reg[3][4] -attr @rip samples_reg[2][7]_0[4] -pin u_sensor samples_reg[2][7]_0[4] -pin u_vector p_1_in_1[4]
load net pitch_fallback_q10[12] -attr @rip pitch_fallback_q10_reg[31]_1[12] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[12] -pin u_vector pw_reg[12]
load net u_dados_n_186 -pin u_dados altitude_ft_reg[3]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_2138_0
netloc u_dados_n_186 1 3 1 11460 1320n
load net u_dados_n_261 -attr @rip VGA_R_OBUF[3]_inst_i_3436_0[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_2[2]
load net amostra_valida -pin u_dados amostra_valida -pin u_entrada amostra_valida
netloc amostra_valida 1 2 1 3260 3700n
load net g_native_video.u_native_n_408 -attr @rip odd_tag_reg[9][1] -pin g_native_video.u_native odd_tag_reg[9][1] -pin u_vga missing_lines_reg[0]_i_3_0[1]
load net u_dados_n_32 -attr @rip heading_deg_reg[0]_2[0] -pin u_dados heading_deg_reg[0]_2[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2274_0[0]
load net u_dados_n_67 -attr @rip heading_deg_reg[0]_6[2] -pin u_dados heading_deg_reg[0]_6[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4701_0[2]
load net u_dados_n_101 -attr @rip heading_deg_reg[0]_8[1] -pin u_dados heading_deg_reg[0]_8[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4401_1[1]
load net g_overlay.u_alertas_vga/texto90 -pin u_dados texto90 -pin u_vga texto90
netloc g_overlay.u_alertas_vga/texto90 1 3 1 7540 3540n
load net updated1 -pin u_sensor updated1 -pin u_vector updated1
netloc updated1 1 0 3 100 6540 NJ 6540 2480
load net u_sensor_n_7 -attr @rip DI[0] -pin u_sensor DI[0] -pin u_vector DI[0]
netloc u_sensor_n_7 1 1 1 1710 4160n
load net zero_request0 -attr @style dashed -pin u_sensor zero_request0 -pin u_vector zero_request0
netloc zero_request0 1 0 2 380 5660 1630J
load net u_vector_n_338 -attr @style dashed -pin g_mag_tilt.u_heading g_idade[2].idade_reg[0] -pin u_vector active_reg_0
netloc u_vector_n_338 1 2 1 3220 4300n
load net u_vga_n_299 -pin u_dados VGA_R_OBUF[3]_inst_i_395_1 -pin u_vga h_cont_reg[1]_rep_0
netloc u_vga_n_299 1 2 3 4560 6220 9240J 2040 13940
load net u_vga_n_240 -attr @rip h_cont_reg[6]_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1093[0] -pin u_vga h_cont_reg[6]_3[0]
load net compass_gravity_y[22] -attr @rip gravity_y_reg[23]_0[22] -pin g_mag_tilt.u_heading gy_reg[24]_0[22] -pin u_vector gravity_y_reg[23]_0[22]
load net heading_deg[6] -attr @rip heading_deg_reg[7]_0[2] -pin u_dados heading_deg_reg[7]_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_1205[2]
load net mpu_raw_ax[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[86] -pin u_sensor accel_x_reg[15]_0[86] -pin u_vector a_reg[0][15]_0[86]
load net native_app_addr[9] -attr @rip app_addr[6] -pin g_native_video.u_native app_addr[6] -pin u_ui_test app_addr[6]
load net metadados_in[0] -attr @rip Q[56] -pin u_dados Q[56] -pin u_entrada Q[56]
load net memory_and_vga/bridge/last_data[19] -attr @rip last_data_reg[125][19] -pin g_native_video.u_native last_data_reg[125][19] -pin u_ui_test wr_data2_carry__9[19]
load net memory_and_vga/bridge/last_data[83] -attr @rip last_data_reg[125][83] -pin g_native_video.u_native last_data_reg[125][83] -pin u_ui_test wr_data2_carry__9[83]
load net native_app_rd_data[117] -attr @rip din[117] -pin g_native_video.u_native din[117] -pin u_ui_test din[117]
load net native_app_wdf_data[117] -attr @rip dout[117] -pin g_native_video.u_native dout[117] -pin u_ui_test dout[117]
load net native_app_wdf_data[53] -attr @rip dout[53] -pin g_native_video.u_native dout[53] -pin u_ui_test dout[53]
load net native_app_rd_data[53] -attr @rip din[53] -pin g_native_video.u_native din[53] -pin u_ui_test din[53]
load net pitch_fallback_q10[13] -attr @rip pitch_fallback_q10_reg[31]_1[13] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[13] -pin u_vector pw_reg[13]
load net samples_reg[3][5] -attr @rip samples_reg[2][7]_0[5] -pin u_sensor samples_reg[2][7]_0[5] -pin u_vector p_1_in_1[5]
load net g_operacao.u_operacao_n_98 -attr @rip roll_reg[13][1] -pin g_operacao.u_operacao roll_reg[13][1] -pin u_vector rw_reg_i_8_0[1]
load net u_dados_n_259 -attr @rip VGA_R_OBUF[3]_inst_i_3431_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3431_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3347_3[1]
load net u_dados_n_317 -pin u_dados heading_deg_reg[8]_rep_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_5
netloc u_dados_n_317 1 3 1 10920 2920n
load net u_dados_n_64 -attr @rip VGA_R_OBUF[3]_inst_i_4122_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4122_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4494[1]
load net u_dados_n_183 -pin u_dados metadados_reg[12]_6 -pin u_vga VGA_R_OBUF[3]_inst_i_70
netloc u_dados_n_183 1 3 1 11420 3060n
load net g_native_video.u_native_n_405 -attr @rip odd_tag_reg[9][4] -pin g_native_video.u_native odd_tag_reg[9][4] -pin u_vga missing_lines_reg[0]_i_3_0[4]
load net u_vga_n_238 -pin u_dados VGA_R_OBUF[3]_inst_i_156 -pin u_vga h_cont_reg[9]_10
netloc u_vga_n_238 1 2 3 3860 8660 NJ 8660 14940
load net u_vector_n_254 -pin g_operacao.u_operacao estado_reg[3]_0 -pin u_vector g_idade[0].recentes_reg[0]
netloc u_vector_n_254 1 0 3 140 6520 NJ 6520 2720
load net u_vga_n_296 -attr @rip h_cont_reg[5]_rep__0_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_786[1] -pin u_vga h_cont_reg[5]_rep__0_0[1]
load net u_sensor_n_13 -attr @rip S[0] -pin u_sensor S[0] -pin u_vector S[0]
netloc u_sensor_n_13 1 1 1 1670 4200n
load net card_codigo3[7] -attr @rip heading_deg_reg[0]_0[4] -pin u_dados heading_deg_reg[0]_0[4] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[4]
load net compass_gravity_y[19] -attr @rip gravity_y_reg[23]_0[19] -pin g_mag_tilt.u_heading gy_reg[24]_0[19] -pin u_vector gravity_y_reg[23]_0[19]
load net heading_deg[0] -attr @rip heading_deg_reg[7]_0[0] -pin u_dados heading_deg_reg[7]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1205[0]
load net hud_pixel_y[4] -attr @style dashed -attr @rip hud_pixel_y[0] -pin u_dados hud_pixel_y[4] -pin u_vga hud_pixel_y[0]
load net mpu_raw_ax[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[83] -pin u_sensor accel_x_reg[15]_0[83] -pin u_vector a_reg[0][15]_0[83]
load net native_app_addr[6] -attr @rip app_addr[3] -pin g_native_video.u_native app_addr[3] -pin u_ui_test app_addr[3]
load net memory_and_vga/bridge/last_data[16] -attr @rip last_data_reg[125][16] -pin g_native_video.u_native last_data_reg[125][16] -pin u_ui_test wr_data2_carry__9[16]
load net memory_and_vga/bridge/last_data[80] -attr @rip last_data_reg[125][80] -pin g_native_video.u_native last_data_reg[125][80] -pin u_ui_test wr_data2_carry__9[80]
load net memory_and_vga/vga/p_0_in__1[4] -attr @rip p_0_in__1[1] -pin g_native_video.u_native p_0_in__1[1] -pin u_vga p_0_in__1[1]
load net native_app_rd_data[114] -attr @rip din[114] -pin g_native_video.u_native din[114] -pin u_ui_test din[114]
load net native_app_wdf_data[114] -attr @rip dout[114] -pin g_native_video.u_native dout[114] -pin u_ui_test dout[114]
load net native_app_wdf_data[50] -attr @rip dout[50] -pin g_native_video.u_native dout[50] -pin u_ui_test dout[50]
load net native_app_rd_data[50] -attr @rip din[50] -pin g_native_video.u_native din[50] -pin u_ui_test din[50]
load net roll_fallback_q10_next[27] -attr @rip roll_sync_reg[0]_0[27] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[27] -pin u_vector roll_sync_reg[0]_0[27]
load net pitch_fallback_q10[10] -attr @rip pitch_fallback_q10_reg[31]_1[10] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[10] -pin u_vector pw_reg[10]
load net samples_reg[3][2] -attr @rip samples_reg[2][7]_0[2] -pin u_sensor samples_reg[2][7]_0[2] -pin u_vector p_1_in_1[2]
load net u_alertas/ar0[12] -attr @rip roll_reg[16]_0[3] -pin g_operacao.u_operacao ar0[3] -pin u_vector roll_reg[16]_0[3]
load net u_dados_n_184 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1140_2
netloc u_dados_n_184 1 3 1 9720 640n
load net amostra_nova -pin u_sensor amostra_nova -pin u_vector amostra_nova
netloc amostra_nova 1 1 1 1590 4280n
load net g_operacao.u_operacao_n_99 -attr @rip roll_reg[13][0] -pin g_operacao.u_operacao roll_reg[13][0] -pin u_vector rw_reg_i_8_0[0]
load net u_dados_n_65 -attr @rip VGA_R_OBUF[3]_inst_i_4122_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4122_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4494[0]
load net u_dados_n_26 -attr @rip heading_deg_reg[0]_1[0] -pin u_dados heading_deg_reg[0]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2986_0[0]
load net u_dados_n_318 -pin u_dados heading_deg_reg[8]_rep_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_4
netloc u_dados_n_318 1 3 1 10860 2940n
load net g_native_video.u_native_n_406 -attr @rip odd_tag_reg[9][3] -pin g_native_video.u_native odd_tag_reg[9][3] -pin u_vga missing_lines_reg[0]_i_3_0[3]
load net u_sensor_n_14 -attr @rip age_reg[0]_0[0] -pin u_sensor age_reg[0]_0[0] -pin u_vector age_reg[3]_1[0]
netloc u_sensor_n_14 1 1 1 1610 4260n
load net u_vga_n_239 -attr @rip h_cont_reg[6]_3[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1093[1] -pin u_vga h_cont_reg[6]_3[1]
load net u_vga_n_297 -attr @rip h_cont_reg[5]_rep__0_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_786[0] -pin u_vga h_cont_reg[5]_rep__0_0[0]
load net card_codigo3[8] -attr @rip heading_deg_reg[0]_0[5] -pin u_dados heading_deg_reg[0]_0[5] -pin u_vga VGA_R_OBUF[3]_inst_i_4515_0[5]
load net compass_gravity_y[20] -attr @rip gravity_y_reg[23]_0[20] -pin g_mag_tilt.u_heading gy_reg[24]_0[20] -pin u_vector gravity_y_reg[23]_0[20]
load net heading_deg[5] -attr @rip heading_deg_reg[7]_0[1] -pin u_dados heading_deg_reg[7]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_1205[1]
load net hud_pixel_y[5] -attr @style dashed -attr @rip hud_pixel_y[1] -pin u_dados hud_pixel_y[5] -pin u_vga hud_pixel_y[1]
load net mpu_raw_ax[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[84] -pin u_sensor accel_x_reg[15]_0[84] -pin u_vector a_reg[0][15]_0[84]
load net native_app_addr[7] -attr @rip app_addr[4] -pin g_native_video.u_native app_addr[4] -pin u_ui_test app_addr[4]
load net memory_and_vga/bridge/last_data[17] -attr @rip last_data_reg[125][17] -pin g_native_video.u_native last_data_reg[125][17] -pin u_ui_test wr_data2_carry__9[17]
load net memory_and_vga/bridge/last_data[81] -attr @rip last_data_reg[125][81] -pin g_native_video.u_native last_data_reg[125][81] -pin u_ui_test wr_data2_carry__9[81]
load net memory_and_vga/vga/p_0_in__1[5] -attr @rip p_0_in__1[2] -pin g_native_video.u_native p_0_in__1[2] -pin u_vga p_0_in__1[2]
load net native_app_rd_data[115] -attr @rip din[115] -pin g_native_video.u_native din[115] -pin u_ui_test din[115]
load net native_app_wdf_data[115] -attr @rip dout[115] -pin g_native_video.u_native dout[115] -pin u_ui_test dout[115]
load net native_app_wdf_data[51] -attr @rip dout[51] -pin g_native_video.u_native dout[51] -pin u_ui_test dout[51]
load net native_app_rd_data[51] -attr @rip din[51] -pin g_native_video.u_native din[51] -pin u_ui_test din[51]
load net roll_fallback_q10_next[31] -attr @rip roll_sync_reg[0]_0[28] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[28] -pin u_vector roll_sync_reg[0]_0[28]
load net samples_reg[3][3] -attr @rip samples_reg[2][7]_0[3] -pin u_sensor samples_reg[2][7]_0[3] -pin u_vector p_1_in_1[3]
load net u_alertas/ar0[13] -attr @rip roll_reg[16]_0[4] -pin g_operacao.u_operacao ar0[4] -pin u_vector roll_reg[16]_0[4]
load net pitch_fallback_q10[11] -attr @rip pitch_fallback_q10_reg[31]_1[11] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[11] -pin u_vector pw_reg[11]
load net clk_hud -attr @style dashed -pin g_mag_tilt.u_heading clk_hud -pin g_native_video.u_native clk_hud -pin g_operacao.u_operacao clk_hud -pin u_entrada clk_hud -pin u_sensor clk_hud -pin u_vector clk_hud -pin u_vga clk_hud
netloc clk_hud 1 0 5 420 4580 1550 5580 3080 6420 7500 1240 15980J
load net u_dados_n_337 -pin u_dados VGA_R_OBUF[3]_inst_i_1562_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_3
netloc u_dados_n_337 1 3 1 11780 300n
load net u_dados_n_279 -pin u_dados h_cont_reg[9]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_65_3
netloc u_dados_n_279 1 3 1 11760 2240n
load net u_dados_n_120 -attr @rip heading_deg_reg[0]_13[2] -pin u_dados heading_deg_reg[0]_13[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4686_0[2]
load net u_dados_n_87 -pin u_dados heading_deg_reg[8]_rep_2 -pin u_vga VGA_R_OBUF[3]_inst_i_159_0
netloc u_dados_n_87 1 3 1 11600 2900n
load net u_dados_n_205 -pin u_dados v_cont_reg[8] -pin u_vga VGA_R_OBUF[3]_inst_i_3897_0
netloc u_dados_n_205 1 3 1 7860 3720n
load net memory_and_vga/vga/current_rgb332 -pin g_native_video.u_native current_rgb332 -pin u_vga current_rgb332
netloc memory_and_vga/vga/current_rgb332 1 3 3 12320 1320 15720J 2880 17260
load net amostra_completa[75] -attr @rip Q[35] -pin u_dados Q[35] -pin u_entrada Q[35]
load net u_vga_n_258 -attr @rip h_cont_reg[1]_rep__1_5[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1105[2] -pin u_vga h_cont_reg[1]_rep__1_5[2]
load net u_vga_n_47 -pin u_dados VGA_R_OBUF[3]_inst_i_1202_0 -pin u_vga heading_deg_reg[8]_rep_1
netloc u_vga_n_47 1 2 3 4700 8740 NJ 8740 14860
load net u_vga_n_103 -attr @rip h_cont_reg[2]_rep_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_55[0] -pin u_vga h_cont_reg[2]_rep_0[0]
netloc u_vga_n_103 1 2 3 5080 4440 7980J 620 13860
load net u_ui_test_n_179 -attr @rip last_data_reg[45][1] -pin g_native_video.u_native wr_data2_carry__3[1] -pin u_ui_test last_data_reg[45][1]
load net u_vga_n_188 -pin g_native_video.u_native line_valid_i_4 -pin u_vga v_cont_reg[8]_0
netloc u_vga_n_188 1 4 1 15860 2100n
load net compass_gravity_z[17] -attr @rip Q[17] -pin g_mag_tilt.u_heading gz_reg[24]_0[17] -pin u_vector Q[17]
load net compass_gravity_x[1] -attr @rip gravity_x_reg[23]_0[1] -pin g_mag_tilt.u_heading gx_reg[23]_0[1] -pin u_vector gravity_x_reg[23]_0[1]
load net dados_operacao[8] -attr @rip D[8] -pin g_operacao.u_operacao D[8] -pin u_entrada retido_reg[121]_0[47]
load net hud_metadados[3] -attr @rip metadados_reg[15]_0[3] -pin u_dados metadados_reg[15]_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[3]
load net metadados_operacao[2] -attr @style dashed -attr @rip D[38] -pin g_operacao.u_operacao D[38] -pin u_entrada retido_reg[121]_0[77]
load net mpu_raw_ay[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[72] -pin u_sensor accel_x_reg[15]_0[72] -pin u_vector a_reg[0][15]_0[72]
load net memory_and_vga/bridge/last_data[102] -attr @rip last_data_reg[125][102] -pin g_native_video.u_native last_data_reg[125][102] -pin u_ui_test wr_data2_carry__9[102]
load net memory_and_vga/bridge/last_data[38] -attr @rip last_data_reg[125][38] -pin g_native_video.u_native last_data_reg[125][38] -pin u_ui_test wr_data2_carry__9[38]
load net native_app_wdf_data[7] -attr @rip dout[7] -pin g_native_video.u_native dout[7] -pin u_ui_test dout[7]
load net native_app_wdf_data[72] -attr @rip dout[72] -pin g_native_video.u_native dout[72] -pin u_ui_test dout[72]
load net native_app_rd_data[72] -attr @rip din[72] -pin g_native_video.u_native din[72] -pin u_ui_test din[72]
load net native_app_rd_data[7] -attr @rip din[7] -pin g_native_video.u_native din[7] -pin u_ui_test din[7]
load net roll_fallback_q10[15] -attr @rip roll_fallback_q10_reg[31]_0[15] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[15] -pin u_vector rw_reg_i_3_0[15]
load net pitch_fallback_q10_next[4] -attr @rip horizonte_sync_reg[0][4] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[4] -pin u_vector horizonte_sync_reg[0][4]
load net samples_reg[5][6] -attr @rip samples_reg[4][7]_0[6] -pin u_sensor samples_reg[4][7]_0[6] -pin u_vector p_1_in__0_0[6]
load net u_dados_n_88 -attr @rip VGA_R_OBUF[3]_inst_i_4633_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4633_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4041[1]
load net u_dados_n_28 -attr @rip h_cont_reg[5]_rep_1[1] -pin u_dados h_cont_reg[5]_rep_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2271[1]
load net u_dados_n_121 -attr @rip heading_deg_reg[0]_13[1] -pin u_dados heading_deg_reg[0]_13[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4686_0[1]
load net u_dados_n_338 -pin u_dados heading_deg_reg[8]_rep_8 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_2
netloc u_dados_n_338 1 3 1 10700 3020n
load net u_dados_n_206 -pin u_dados v_cont_reg[8]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3906_0
netloc u_dados_n_206 1 3 1 7800 3740n
load net memory_and_vga/vga/fetching -pin g_native_video.u_native fetching -pin u_vga fetching
netloc memory_and_vga/vga/fetching 1 3 3 12380 1380 15640J 2940 17180
load net u_vga_n_259 -attr @rip h_cont_reg[1]_rep__1_5[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1105[1] -pin u_vga h_cont_reg[1]_rep__1_5[1]
load net amostra_completa[76] -attr @rip Q[36] -pin u_dados Q[36] -pin u_entrada Q[36]
load net u_vga_n_104 -attr @rip h_cont_reg[2]_rep_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_33[1] -pin u_vga h_cont_reg[2]_rep_1[1]
load net u_ui_test_n_180 -attr @rip last_data_reg[45][0] -pin g_native_video.u_native wr_data2_carry__3[0] -pin u_ui_test last_data_reg[45][0]
load net u_vga_n_48 -pin u_dados VGA_R_OBUF[3]_inst_i_1204_2 -pin u_vga heading_deg_reg[8]_rep_2
netloc u_vga_n_48 1 2 3 4440 8760 NJ 8760 14820
load net altitude_ft[0] -attr @rip altitude_ft_reg[16]_0[0] -pin u_dados altitude_ft_reg[16]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[0]
load net u_vga_n_189 -pin g_native_video.u_native line_valid_i_4_0 -pin u_vga v_cont_reg[6]_rep_0
netloc u_vga_n_189 1 4 1 15800 2120n
load net video_on -attr @style dashed -pin g_native_video.u_native video_on -pin u_vga video_on
netloc video_on 1 4 1 16020 2640n
load net compass_gravity_z[18] -attr @rip Q[18] -pin g_mag_tilt.u_heading gz_reg[24]_0[18] -pin u_vector Q[18]
load net compass_gravity_x[2] -attr @rip gravity_x_reg[23]_0[2] -pin g_mag_tilt.u_heading gx_reg[23]_0[2] -pin u_vector gravity_x_reg[23]_0[2]
load net hud_metadados[4] -attr @rip metadados_reg[15]_0[4] -pin u_dados metadados_reg[15]_0[4] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[4]
load net metadados_operacao[3] -attr @rip D[39] -pin g_operacao.u_operacao D[39] -pin u_entrada retido_reg[121]_0[78]
load net mpu_raw_ay[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[74] -pin u_sensor accel_x_reg[15]_0[74] -pin u_vector a_reg[0][15]_0[74]
load net memory_and_vga/bridge/last_data[103] -attr @rip last_data_reg[125][103] -pin g_native_video.u_native last_data_reg[125][103] -pin u_ui_test wr_data2_carry__9[103]
load net memory_and_vga/bridge/last_data[39] -attr @rip last_data_reg[125][39] -pin g_native_video.u_native last_data_reg[125][39] -pin u_ui_test wr_data2_carry__9[39]
load net native_app_wdf_data[8] -attr @rip dout[8] -pin g_native_video.u_native dout[8] -pin u_ui_test dout[8]
load net native_app_wdf_data[73] -attr @rip dout[73] -pin g_native_video.u_native dout[73] -pin u_ui_test dout[73]
load net native_app_rd_data[73] -attr @rip din[73] -pin g_native_video.u_native din[73] -pin u_ui_test din[73]
load net native_app_rd_data[8] -attr @rip din[8] -pin g_native_video.u_native din[8] -pin u_ui_test din[8]
load net roll_fallback_q10[16] -attr @rip roll_fallback_q10_reg[31]_0[16] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[16] -pin u_vector rw_reg_i_3_0[16]
load net pitch_fallback_q10_next[5] -attr @rip horizonte_sync_reg[0][5] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[5] -pin u_vector horizonte_sync_reg[0][5]
load net u_dados_n_277 -attr @rip VGA_R_OBUF[3]_inst_i_2869_7[1] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_7[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_1[1]
load net u_dados_n_85 -pin u_dados heading_deg_reg[7]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1691_1
netloc u_dados_n_85 1 3 1 10100 2780n
load net u_dados_n_335 -pin u_dados altitude_ft_reg[3]_11 -pin u_vga VGA_R_OBUF[3]_inst_i_775_0
netloc u_dados_n_335 1 3 1 8380 1520n
load net g_native_video.frame_boundary -attr @style dashed -pin u_dados g_native_video.frame_boundary -pin u_simbologia g_native_video.frame_boundary -pin u_vga g_native_video.frame_boundary
netloc g_native_video.frame_boundary 1 2 3 3540 9320 NJ 9320 15420
load net u_dados_n_201 -pin u_dados h_cont_reg[9]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_3446_2
netloc u_dados_n_201 1 3 1 8780 2220n
load net u_dados_n_118 -attr @rip heading_deg_reg[0]_12[0] -pin u_dados heading_deg_reg[0]_12[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4447_1[0]
load net memory_and_vga/vga/RSTM -attr @rip g_native_video.pixel_reset_pipe_reg[1][0] -pin g_native_video.u_native fetch_line_reg[9][0] -pin u_vga g_native_video.pixel_reset_pipe_reg[1][0]
netloc memory_and_vga/vga/RSTM 1 4 1 15460 1880n
load net u_vga_n_45 -attr @rip h_cont_reg[1]_rep__0_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_0[0] -pin u_vga h_cont_reg[1]_rep__0_3[0]
load net u_ui_test_n_177 -attr @rip last_data_reg[45][3] -pin g_native_video.u_native wr_data2_carry__3[3] -pin u_ui_test last_data_reg[45][3]
load net amostra_completa[73] -attr @rip Q[33] -pin u_dados Q[33] -pin u_entrada Q[33]
load net u_vga_n_101 -attr @rip v_cont_reg[0]_0[0] -pin u_dados VGA_G_OBUF[3]_inst_i_100[0] -pin u_vga v_cont_reg[0]_0[0]
netloc u_vga_n_101 1 2 3 3800 8900 NJ 8900 14660
load net u_vga_n_18 -pin u_dados VGA_R_OBUF[3]_inst_i_1674 -pin u_vga h_cont_reg[5]_rep_0
netloc u_vga_n_18 1 2 3 5120 8240 NJ 8240 15400
load net u_vga_n_256 -pin u_dados VGA_R_OBUF[3]_inst_i_1450 -pin u_vga velocidade_kt_reg[9]
netloc u_vga_n_256 1 2 3 3580 9240 NJ 9240 13800
load net compass_gravity_z[15] -attr @rip Q[15] -pin g_mag_tilt.u_heading gz_reg[24]_0[15] -pin u_vector Q[15]
load net dados_operacao[30] -attr @rip D[9] -pin g_operacao.u_operacao D[9] -pin u_entrada retido_reg[121]_0[48]
load net hud_metadados[1] -attr @rip metadados_reg[15]_0[1] -pin u_dados metadados_reg[15]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[1]
load net mpu_raw_ay[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[73] -pin u_sensor accel_x_reg[15]_0[73] -pin u_vector a_reg[0][15]_0[73]
load net metadados_operacao[0] -attr @style dashed -attr @rip D[36] -pin g_operacao.u_operacao D[36] -pin u_entrada retido_reg[121]_0[75]
load net memory_and_vga/bridge/last_data[100] -attr @rip last_data_reg[125][100] -pin g_native_video.u_native last_data_reg[125][100] -pin u_ui_test wr_data2_carry__9[100]
load net memory_and_vga/bridge/last_data[36] -attr @rip last_data_reg[125][36] -pin g_native_video.u_native last_data_reg[125][36] -pin u_ui_test wr_data2_carry__9[36]
load net mira_y_in[8] -attr @rip Q[18] -pin u_dados Q[18] -pin u_entrada Q[18]
load net native_app_wdf_data[70] -attr @rip dout[70] -pin g_native_video.u_native dout[70] -pin u_ui_test dout[70]
load net native_app_wdf_data[6] -attr @rip dout[6] -pin g_native_video.u_native dout[6] -pin u_ui_test dout[6]
load net native_app_rd_data[70] -attr @rip din[70] -pin g_native_video.u_native din[70] -pin u_ui_test din[70]
load net native_app_rd_data[6] -attr @rip din[6] -pin g_native_video.u_native din[6] -pin u_ui_test din[6]
load net samples_reg[5][4] -attr @rip samples_reg[4][7]_0[4] -pin u_sensor samples_reg[4][7]_0[4] -pin u_vector p_1_in__0_0[4]
load net pitch_fallback_q10_next[2] -attr @rip horizonte_sync_reg[0][2] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[2] -pin u_vector horizonte_sync_reg[0][2]
load net roll_fallback_q10[13] -attr @rip roll_fallback_q10_reg[31]_0[13] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[13] -pin u_vector rw_reg_i_3_0[13]
load net MAG_LED_OBUF -attr @style dashed -pin g_mag_tilt.u_heading MAG_LED_OBUF -pin u_vector MAG_LED_OBUF
netloc MAG_LED_OBUF 1 1 2 1770 3940 3360J
load net u_dados_n_278 -attr @rip VGA_R_OBUF[3]_inst_i_2869_7[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_7[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_1[0]
load net u_dados_n_204 -pin u_dados velocidade_kt_reg[2]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_2125_0
netloc u_dados_n_204 1 3 1 8520 3980n
load net u_dados_n_336 -pin u_dados altitude_ft_reg[16]_5 -pin u_vga VGA_R_OBUF[3]_inst_i_1546
netloc u_dados_n_336 1 3 1 7360 1760n
load net u_dados_n_119 -attr @rip heading_deg_reg[7]_rep_1[0] -pin u_dados heading_deg_reg[7]_rep_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4447_0[0]
netloc u_dados_n_119 1 3 1 7100 2700n
load net u_dados_n_86 -pin u_dados heading_deg_reg[8]_rep_1 -pin u_vga VGA_R_OBUF[3]_inst_i_1687_0
netloc u_dados_n_86 1 3 1 10040 2880n
load net memory_and_vga/vga/clear -attr @rip g_native_video.pixel_reset_pipe_reg[1]_1[0] -pin g_native_video.u_native rd_word0[0] -pin u_vga g_native_video.pixel_reset_pipe_reg[1]_1[0]
netloc memory_and_vga/vga/clear 1 4 1 15880 2500n
load net u_vga_n_257 -attr @rip h_cont_reg[1]_rep__1_5[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1105[3] -pin u_vga h_cont_reg[1]_rep__1_5[3]
load net amostra_completa[74] -attr @rip Q[34] -pin u_dados Q[34] -pin u_entrada Q[34]
load net u_vga_n_46 -pin u_dados VGA_R_OBUF[3]_inst_i_1204_0 -pin u_vga heading_deg_reg[8]_rep_0
netloc u_vga_n_46 1 2 3 4720 8720 NJ 8720 14880
load net u_vga_n_102 -pin u_dados VGA_R_OBUF[3]_inst_i_516_0 -pin u_vga v_cont_reg[0]_rep__0_3
netloc u_vga_n_102 1 2 3 4200 8880 NJ 8880 14680
load net u_ui_test_n_178 -attr @rip last_data_reg[45][2] -pin g_native_video.u_native wr_data2_carry__3[2] -pin u_ui_test last_data_reg[45][2]
load net u_vga_n_187 -pin g_native_video.u_native missing_lines_reg[31] -pin u_vga displayed_valid_reg
netloc u_vga_n_187 1 4 1 15600 2180n
load net compass_gravity_z[16] -attr @rip Q[16] -pin g_mag_tilt.u_heading gz_reg[24]_0[16] -pin u_vector Q[16]
load net compass_gravity_x[0] -attr @rip gravity_x_reg[23]_0[0] -pin g_mag_tilt.u_heading gx_reg[23]_0[0] -pin u_vector gravity_x_reg[23]_0[0]
load net dados_operacao[7] -attr @rip D[7] -pin g_operacao.u_operacao D[7] -pin u_entrada retido_reg[121]_0[46]
load net hud_metadados[2] -attr @rip metadados_reg[15]_0[2] -pin u_dados metadados_reg[15]_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[2]
load net metadados_operacao[1] -attr @style dashed -attr @rip D[37] -pin g_operacao.u_operacao D[37] -pin u_entrada retido_reg[121]_0[76]
load net mpu_raw_ay[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[71] -pin u_sensor accel_x_reg[15]_0[71] -pin u_vector a_reg[0][15]_0[71]
load net memory_and_vga/bridge/last_data[101] -attr @rip last_data_reg[125][101] -pin g_native_video.u_native last_data_reg[125][101] -pin u_ui_test wr_data2_carry__9[101]
load net memory_and_vga/bridge/last_data[37] -attr @rip last_data_reg[125][37] -pin g_native_video.u_native last_data_reg[125][37] -pin u_ui_test wr_data2_carry__9[37]
load net native_app_wdf_data[9] -attr @rip dout[9] -pin g_native_video.u_native dout[9] -pin u_ui_test dout[9]
load net native_app_wdf_data[71] -attr @rip dout[71] -pin g_native_video.u_native dout[71] -pin u_ui_test dout[71]
load net native_app_rd_data[71] -attr @rip din[71] -pin g_native_video.u_native din[71] -pin u_ui_test din[71]
load net native_app_rd_data[9] -attr @rip din[9] -pin g_native_video.u_native din[9] -pin u_ui_test din[9]
load net roll_fallback_q10[14] -attr @rip roll_fallback_q10_reg[31]_0[14] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[14] -pin u_vector rw_reg_i_3_0[14]
load net pitch_fallback_q10_next[3] -attr @rip horizonte_sync_reg[0][3] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[3] -pin u_vector horizonte_sync_reg[0][3]
load net samples_reg[5][5] -attr @rip samples_reg[4][7]_0[5] -pin u_sensor samples_reg[4][7]_0[5] -pin u_vector p_1_in__0_0[5]
load net u_dados_n_91 -attr @rip VGA_R_OBUF[3]_inst_i_4648_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4648_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4072[0]
load net u_dados_n_340 -attr @rip altitude_ft_reg[4]_1[0] -pin u_dados altitude_ft_reg[4]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_2[0]
netloc u_dados_n_340 1 3 1 8040 1560n
load net u_dados_n_124 -attr @rip heading_deg_reg[0]_14[2] -pin u_dados heading_deg_reg[0]_14[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4479_1[2]
load net u_dados_n_209 -pin u_dados v_cont_reg[6]_rep__0 -pin u_vga VGA_R_OBUF[3]_inst_i_2125
netloc u_dados_n_209 1 3 1 9820 3640n
load net u_dados_n_282 -pin u_dados velocidade_kt_reg[9]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_0
netloc u_dados_n_282 1 3 1 10520 4040n
load net memory_and_vga/vga/new_line -pin g_native_video.u_native new_line -pin u_vga new_line
netloc memory_and_vga/vga/new_line 1 4 1 15760 2220n
load net u_vga_n_60 -attr @rip h_cont_reg[3]_rep__1_2[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_1[1] -pin u_vga h_cont_reg[3]_rep__1_2[1]
load net u_ui_test_n_183 -attr @rip last_data_reg[57][1] -pin g_native_video.u_native wr_data2_carry__4[1] -pin u_ui_test last_data_reg[57][1]
load net amostra_completa[79] -attr @rip Q[39] -pin u_dados Q[39] -pin u_entrada Q[39]
load net u_vga_n_107 -attr @rip h_cont_reg[1]_rep__1_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_30[0] -pin u_vga h_cont_reg[1]_rep__1_2[0]
netloc u_vga_n_107 1 2 3 4060 4480 7840J 660 14880
load net u_vga_n_261 -attr @rip h_cont_reg[2]_rep__1_0[3] -pin u_dados VGA_R_OBUF[3]_inst_i_394_1[3] -pin u_vga h_cont_reg[2]_rep__1_0[3]
load net altitude_ft[3] -attr @rip altitude_ft_reg[16]_0[3] -pin u_dados altitude_ft_reg[16]_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[3]
load net u_vga_n_191 -pin g_native_video.u_native pixel_word_reg[0] -pin u_vga v_cont_reg[0]_rep__0_4
netloc u_vga_n_191 1 4 1 15940 2380n
load net compass_gravity_z[21] -attr @rip Q[21] -pin g_mag_tilt.u_heading gz_reg[24]_0[21] -pin u_vector Q[21]
load net compass_gravity_x[5] -attr @rip gravity_x_reg[23]_0[5] -pin g_mag_tilt.u_heading gx_reg[23]_0[5] -pin u_vector gravity_x_reg[23]_0[5]
load net dados_operacao[33] -attr @rip D[12] -pin g_operacao.u_operacao D[12] -pin u_entrada retido_reg[121]_0[51]
load net hud_metadados[10] -attr @rip metadados_reg[15]_0[9] -pin u_dados metadados_reg[15]_0[9] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[9]
load net mpu_raw_ay[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[77] -pin u_sensor accel_x_reg[15]_0[77] -pin u_vector a_reg[0][15]_0[77]
load net native_app_rd_data[12] -attr @rip din[12] -pin g_native_video.u_native din[12] -pin u_ui_test din[12]
load net metadados_operacao[7] -attr @rip D[42] -pin g_operacao.u_operacao D[42] -pin u_entrada retido_reg[121]_0[81]
load net memory_and_vga/bridge/last_data[106] -attr @rip last_data_reg[125][106] -pin g_native_video.u_native last_data_reg[125][106] -pin u_ui_test wr_data2_carry__9[106]
load net memory_and_vga/bridge/last_data[42] -attr @rip last_data_reg[125][42] -pin g_native_video.u_native last_data_reg[125][42] -pin u_ui_test wr_data2_carry__9[42]
load net native_app_rd_data[76] -attr @rip din[76] -pin g_native_video.u_native din[76] -pin u_ui_test din[76]
load net native_app_wdf_data[76] -attr @rip dout[76] -pin g_native_video.u_native dout[76] -pin u_ui_test dout[76]
load net native_app_wdf_data[12] -attr @rip dout[12] -pin g_native_video.u_native dout[12] -pin u_ui_test dout[12]
load net roll_fallback_q10[19] -attr @rip roll_fallback_q10_reg[31]_0[19] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[19] -pin u_vector rw_reg_i_3_0[19]
load net pitch_fallback_q10_next[7] -attr @rip horizonte_sync_reg[0][7] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[7] -pin u_vector horizonte_sync_reg[0][7]
load net u_dados_n_92 -attr @rip VGA_R_OBUF[3]_inst_i_4664_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4664_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4103[1]
load net u_dados_n_21 -attr @rip h_cont_reg[5]_rep_0[2] -pin u_dados h_cont_reg[5]_rep_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2268[2]
load net u_dados_n_125 -attr @rip heading_deg_reg[0]_14[1] -pin u_dados heading_deg_reg[0]_14[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4479_1[1]
load net u_dados_n_341 -pin u_dados heading_deg_reg[3]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1122_1
netloc u_dados_n_341 1 3 1 10900 2640n
load net u_dados_n_283 -pin u_dados velocidade_kt_reg[9]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_3
netloc u_dados_n_283 1 3 1 10260 4060n
load net memory_and_vga/vga/pixel_word0 -attr @rip h_cont_reg[8]_0[0] -pin g_native_video.u_native pixel_word_reg[127][0] -pin u_vga h_cont_reg[8]_0[0]
netloc memory_and_vga/vga/pixel_word0 1 4 1 15840 2400n
load net u_vga_n_61 -attr @rip h_cont_reg[3]_rep__1_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_1[0] -pin u_vga h_cont_reg[3]_rep__1_2[0]
load net u_ui_test_n_184 -attr @rip last_data_reg[57][0] -pin g_native_video.u_native wr_data2_carry__4[0] -pin u_ui_test last_data_reg[57][0]
load net amostra_completa[80] -attr @rip Q[40] -pin u_dados Q[40] -pin u_entrada Q[40]
load net u_vga_n_108 -attr @rip h_cont_reg[2]_rep_2[0] -pin u_dados VGA_G_OBUF[3]_inst_i_98[0] -pin u_vga h_cont_reg[2]_rep_2[0]
netloc u_vga_n_108 1 2 3 2880 4500 9140J 680 15100
load net u_vga_n_262 -attr @rip h_cont_reg[2]_rep__1_0[2] -pin u_dados VGA_R_OBUF[3]_inst_i_394_1[2] -pin u_vga h_cont_reg[2]_rep__1_0[2]
load net altitude_ft[4] -attr @rip altitude_ft_reg[16]_0[4] -pin u_dados altitude_ft_reg[16]_0[4] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[4]
load net u_vga_n_198 -pin g_native_video.u_native blank_toggle_reg -pin u_vga v_cont_reg[9]_2
netloc u_vga_n_198 1 4 1 15700 1780n
load net compass_gravity_z[22] -attr @rip Q[22] -pin g_mag_tilt.u_heading gz_reg[24]_0[22] -pin u_vector Q[22]
load net compass_gravity_x[6] -attr @rip gravity_x_reg[23]_0[6] -pin g_mag_tilt.u_heading gx_reg[23]_0[6] -pin u_vector gravity_x_reg[23]_0[6]
load net dados_operacao[34] -attr @rip D[13] -pin g_operacao.u_operacao D[13] -pin u_entrada retido_reg[121]_0[52]
load net mpu_accel_z[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[48] -pin u_sensor accel_x_reg[15]_0[48] -pin u_vector a_reg[0][15]_0[48]
load net mpu_raw_ay[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[78] -pin u_sensor accel_x_reg[15]_0[78] -pin u_vector a_reg[0][15]_0[78]
load net metadados_operacao[10] -attr @rip D[45] -pin g_operacao.u_operacao D[45] -pin u_entrada retido_reg[121]_0[84]
load net memory_and_vga/bridge/last_data[107] -attr @rip last_data_reg[125][107] -pin g_native_video.u_native last_data_reg[125][107] -pin u_ui_test wr_data2_carry__9[107]
load net memory_and_vga/bridge/last_data[43] -attr @rip last_data_reg[125][43] -pin g_native_video.u_native last_data_reg[125][43] -pin u_ui_test wr_data2_carry__9[43]
load net native_app_wdf_data[77] -attr @rip dout[77] -pin g_native_video.u_native dout[77] -pin u_ui_test dout[77]
load net native_app_wdf_data[13] -attr @rip dout[13] -pin g_native_video.u_native dout[13] -pin u_ui_test dout[13]
load net native_app_rd_data[13] -attr @rip din[13] -pin g_native_video.u_native din[13] -pin u_ui_test din[13]
load net native_app_rd_data[77] -attr @rip din[77] -pin g_native_video.u_native din[77] -pin u_ui_test din[77]
load net pitch_fallback_q10_next[8] -attr @rip horizonte_sync_reg[0][8] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[8] -pin u_vector horizonte_sync_reg[0][8]
load net roll_fallback_q10[20] -attr @rip roll_fallback_q10_reg[31]_0[20] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[20] -pin u_vector rw_reg_i_3_0[20]
load net u_dados_n_89 -attr @rip VGA_R_OBUF[3]_inst_i_4633_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4633_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4041[0]
load net u_dados_n_280 -pin u_dados h_cont_reg[1]_rep__1 -pin u_vga VGA_R_OBUF[3]_inst_i_156_1
netloc u_dados_n_280 1 3 1 8580 2020n
load net u_dados_n_122 -attr @rip heading_deg_reg[0]_13[0] -pin u_dados heading_deg_reg[0]_13[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4686_0[0]
load net u_dados_n_339 -pin u_dados velocidade_kt_reg[1]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1416_2
netloc u_dados_n_339 1 3 1 9940 3960n
load net u_dados_n_207 -pin u_dados v_cont_reg[8]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_2769_2
netloc u_dados_n_207 1 3 1 8380 3760n
load net memory_and_vga/vga/line_valid -pin g_native_video.u_native line_valid -pin u_vga line_valid
netloc memory_and_vga/vga/line_valid 1 3 3 12420 1420 15560J 2980 17140
load net u_vga_n_26 -attr @rip h_cont_reg[3]_rep__1_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_0[1] -pin u_vga h_cont_reg[3]_rep__1_1[1]
load net amostra_completa[77] -attr @rip Q[37] -pin u_dados Q[37] -pin u_entrada Q[37]
load net u_vga_n_105 -attr @rip h_cont_reg[2]_rep_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_33[0] -pin u_vga h_cont_reg[2]_rep_1[0]
load net u_vga_n_54 -attr @rip h_cont_reg[9]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3611_0[0] -pin u_vga h_cont_reg[9]_0[0]
netloc u_vga_n_54 1 2 3 4900 8480 NJ 8480 15160
load net u_vga_n_19 -pin u_dados VGA_R_OBUF[3]_inst_i_832_0 -pin u_vga h_cont_reg[4]_rep_0
netloc u_vga_n_19 1 2 3 4380 4840 9000J 1000 14920
load net altitude_ft[1] -attr @rip altitude_ft_reg[16]_0[1] -pin u_dados altitude_ft_reg[16]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[1]
load net u_ui_test_n_181 -attr @rip last_data_reg[57][3] -pin g_native_video.u_native wr_data2_carry__4[3] -pin u_ui_test last_data_reg[57][3]
load net compass_gravity_z[19] -attr @rip Q[19] -pin g_mag_tilt.u_heading gz_reg[24]_0[19] -pin u_vector Q[19]
load net compass_gravity_x[3] -attr @rip gravity_x_reg[23]_0[3] -pin g_mag_tilt.u_heading gx_reg[23]_0[3] -pin u_vector gravity_x_reg[23]_0[3]
load net dados_operacao[31] -attr @rip D[10] -pin g_operacao.u_operacao D[10] -pin u_entrada retido_reg[121]_0[49]
load net hud_metadados[5] -attr @rip metadados_reg[15]_0[5] -pin u_dados metadados_reg[15]_0[5] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[5]
load net mpu_raw_ay[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[75] -pin u_sensor accel_x_reg[15]_0[75] -pin u_vector a_reg[0][15]_0[75]
load net native_app_rd_data[10] -attr @rip din[10] -pin g_native_video.u_native din[10] -pin u_ui_test din[10]
load net metadados_operacao[4] -attr @rip D[40] -pin g_operacao.u_operacao D[40] -pin u_entrada retido_reg[121]_0[79]
load net memory_and_vga/bridge/last_data[104] -attr @rip last_data_reg[125][104] -pin g_native_video.u_native last_data_reg[125][104] -pin u_ui_test wr_data2_carry__9[104]
load net memory_and_vga/bridge/last_data[40] -attr @rip last_data_reg[125][40] -pin g_native_video.u_native last_data_reg[125][40] -pin u_ui_test wr_data2_carry__9[40]
load net native_app_rd_data[74] -attr @rip din[74] -pin g_native_video.u_native din[74] -pin u_ui_test din[74]
load net native_app_wdf_data[74] -attr @rip dout[74] -pin g_native_video.u_native dout[74] -pin u_ui_test dout[74]
load net native_app_wdf_data[10] -attr @rip dout[10] -pin g_native_video.u_native dout[10] -pin u_ui_test dout[10]
load net roll_fallback_q10[17] -attr @rip roll_fallback_q10_reg[31]_0[17] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[17] -pin u_vector rw_reg_i_3_0[17]
load net pitch_fallback_q10_next[6] -attr @rip horizonte_sync_reg[0][6] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[6] -pin u_vector horizonte_sync_reg[0][6]
load net samples_reg[5][7] -attr @rip samples_reg[4][7]_0[7] -pin u_sensor samples_reg[4][7]_0[7] -pin u_vector p_1_in__0_0[7]
load net u_dados_n_90 -attr @rip VGA_R_OBUF[3]_inst_i_4648_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4648_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4072[1]
load net u_dados_n_281 -pin u_dados h_cont_reg[6] -pin u_vga VGA_R_OBUF[3]_inst_i_156_0
netloc u_dados_n_281 1 3 1 7640 2100n
load net u_dados_n_34 -attr @rip h_cont_reg[9][2] -pin u_dados h_cont_reg[9][2] -pin u_vga VGA_R_OBUF[3]_inst_i_2888[2]
load net u_dados_n_123 -attr @rip heading_deg_reg[0]_14[3] -pin u_dados heading_deg_reg[0]_14[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4479_1[3]
load net u_dados_n_208 -pin u_dados v_cont_reg[8]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_2769_3
netloc u_dados_n_208 1 3 1 8320 3780n
load net memory_and_vga/vga/line_valid1 -attr @rip even_tag_reg[9][0] -pin g_native_video.u_native line_valid_reg[0] -pin u_vga even_tag_reg[9][0]
netloc memory_and_vga/vga/line_valid1 1 4 1 15540 2140n
load net u_vga_n_260 -attr @rip h_cont_reg[1]_rep__1_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1105[0] -pin u_vga h_cont_reg[1]_rep__1_5[0]
load net amostra_completa[78] -attr @rip Q[38] -pin u_dados Q[38] -pin u_entrada Q[38]
load net u_vga_n_106 -attr @rip h_cont_reg[1]_rep__1_1[0] -pin u_dados VGA_G_OBUF[3]_inst_i_102[0] -pin u_vga h_cont_reg[1]_rep__1_1[0]
netloc u_vga_n_106 1 2 3 3960 4460 9920J 640 14900
load net u_vga_n_59 -attr @rip h_cont_reg[3]_rep__1_2[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_1[2] -pin u_vga h_cont_reg[3]_rep__1_2[2]
load net altitude_ft[2] -attr @rip altitude_ft_reg[16]_0[2] -pin u_dados altitude_ft_reg[16]_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[2]
load net u_ui_test_n_182 -attr @rip last_data_reg[57][2] -pin g_native_video.u_native wr_data2_carry__4[2] -pin u_ui_test last_data_reg[57][2]
load net u_vga_n_190 -pin g_native_video.u_native missing_lines_reg[0]_i_3 -pin u_vga v_cont_reg[7]_rep_1
netloc u_vga_n_190 1 4 1 15900 2160n
load net compass_gravity_z[20] -attr @rip Q[20] -pin g_mag_tilt.u_heading gz_reg[24]_0[20] -pin u_vector Q[20]
load net compass_gravity_x[4] -attr @rip gravity_x_reg[23]_0[4] -pin g_mag_tilt.u_heading gx_reg[23]_0[4] -pin u_vector gravity_x_reg[23]_0[4]
load net dados_operacao[32] -attr @rip D[11] -pin g_operacao.u_operacao D[11] -pin u_entrada retido_reg[121]_0[50]
load net hud_metadados[7] -attr @rip metadados_reg[15]_0[6] -pin u_dados metadados_reg[15]_0[6] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[6]
load net mpu_raw_ay[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[76] -pin u_sensor accel_x_reg[15]_0[76] -pin u_vector a_reg[0][15]_0[76]
load net native_app_rd_data[11] -attr @rip din[11] -pin g_native_video.u_native din[11] -pin u_ui_test din[11]
load net metadados_operacao[5] -attr @rip D[41] -pin g_operacao.u_operacao D[41] -pin u_entrada retido_reg[121]_0[80]
load net memory_and_vga/bridge/last_data[105] -attr @rip last_data_reg[125][105] -pin g_native_video.u_native last_data_reg[125][105] -pin u_ui_test wr_data2_carry__9[105]
load net memory_and_vga/bridge/last_data[41] -attr @rip last_data_reg[125][41] -pin g_native_video.u_native last_data_reg[125][41] -pin u_ui_test wr_data2_carry__9[41]
load net native_app_rd_data[75] -attr @rip din[75] -pin g_native_video.u_native din[75] -pin u_ui_test din[75]
load net native_app_wdf_data[75] -attr @rip dout[75] -pin g_native_video.u_native dout[75] -pin u_ui_test dout[75]
load net native_app_wdf_data[11] -attr @rip dout[11] -pin g_native_video.u_native dout[11] -pin u_ui_test dout[11]
load net roll_fallback_q10[18] -attr @rip roll_fallback_q10_reg[31]_0[18] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[18] -pin u_vector rw_reg_i_3_0[18]
load net pitch_fallback_q10_next[9] -attr @rip horizonte_sync_reg[0][9] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[9] -pin u_vector horizonte_sync_reg[0][9]
load net u_dados_n_271 -attr @rip VGA_R_OBUF[3]_inst_i_3436_2[2] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_2[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_0[2]
load net u_dados_n_77 -attr @rip VGA_R_OBUF[3]_inst_i_2961_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2961_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1661[0]
netloc u_dados_n_77 1 3 1 10440 860n
load net u_dados_n_196 -attr @rip altitude_ft_reg[6]_1[2] -pin u_dados altitude_ft_reg[6]_1[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_1[2]
load net u_dados_n_33 -attr @rip h_cont_reg[9][3] -pin u_dados h_cont_reg[9][3] -pin u_vga VGA_R_OBUF[3]_inst_i_2888[3]
load net u_dados_n_112 -attr @rip heading_deg_reg[0]_11[2] -pin u_dados heading_deg_reg[0]_11[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4659_0[2]
load net u_vga_n_250 -attr @rip h_cont_reg[3]_rep__1_4[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1122[1] -pin u_vga h_cont_reg[3]_rep__1_4[1]
load net u_vector_n_362 -pin g_mag_tilt.u_heading angle_out_reg[0] -pin u_vector inicio_operacao_reg[3]_0
netloc u_vector_n_362 1 2 1 3080 4460n
load net amostra_completa[46] -attr @rip Q[27] -pin u_dados Q[27] -pin u_entrada Q[27]
load net u_vga_n_39 -pin u_dados VGA_R_OBUF[3]_inst_i_820_1 -pin u_vga v_cont_reg[2]_rep_0
netloc u_vga_n_39 1 2 3 3700 8960 NJ 8960 14560
load net u_ui_test_n_171 -attr @rip last_data_reg[21][1] -pin g_native_video.u_native wr_data2_carry__1[1] -pin u_ui_test last_data_reg[21][1]
load net compass_gravity_z[8] -attr @rip Q[8] -pin g_mag_tilt.u_heading gz_reg[24]_0[8] -pin u_vector Q[8]
load net dados_operacao[1] -attr @rip D[1] -pin g_operacao.u_operacao D[1] -pin u_entrada retido_reg[121]_0[40]
load net mpu_raw_ay[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[65] -pin u_sensor accel_x_reg[15]_0[65] -pin u_vector a_reg[0][15]_0[65]
load net metadados_in[11] -attr @rip Q[66] -pin u_dados Q[66] -pin u_entrada Q[66]
load net memory_and_vga/bridge/last_data[30] -attr @rip last_data_reg[125][30] -pin g_native_video.u_native last_data_reg[125][30] -pin u_ui_test wr_data2_carry__9[30]
load net memory_and_vga/bridge/last_data[94] -attr @rip last_data_reg[125][94] -pin g_native_video.u_native last_data_reg[125][94] -pin u_ui_test wr_data2_carry__9[94]
load net mira_y_in[3] -attr @rip Q[13] -pin u_dados Q[13] -pin u_entrada Q[13]
load net native_app_rd_data[0] -attr @rip din[0] -pin g_native_video.u_native din[0] -pin u_ui_test din[0]
load net native_app_rd_data[64] -attr @rip din[64] -pin g_native_video.u_native din[64] -pin u_ui_test din[64]
load net native_app_wdf_data[0] -attr @rip dout[0] -pin g_native_video.u_native dout[0] -pin u_ui_test dout[0]
load net native_app_wdf_data[64] -attr @rip dout[64] -pin g_native_video.u_native dout[64] -pin u_ui_test dout[64]
load net roll_fallback_q10[9] -attr @rip roll_fallback_q10_reg[31]_0[9] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[9] -pin u_vector rw_reg_i_3_0[9]
load net pitch_fallback_q10[24] -attr @rip pitch_fallback_q10_reg[31]_1[24] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[24] -pin u_vector pw_reg[24]
load net velocidade_pendente[0] -attr @rip SR[0] -pin u_dados SR[0] -pin u_entrada SR[0]
netloc velocidade_pendente[0] 1 2 1 2860 580n
load net u_dados_n_78 -pin u_dados heading_deg_reg[3]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_65_2
netloc u_dados_n_78 1 3 1 11120 2580n
load net u_dados_n_330 -pin u_dados VGA_R_OBUF[3]_inst_i_2092_0 -pin u_vga VGA_R_OBUF[3]_inst_i_786_2
netloc u_dados_n_330 1 3 1 8980 480n
load net u_dados_n_272 -attr @rip VGA_R_OBUF[3]_inst_i_3436_2[1] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_2[1] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_0[1]
load net u_dados_n_197 -attr @rip altitude_ft_reg[6]_1[1] -pin u_dados altitude_ft_reg[6]_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_1[1]
load net u_dados_n_113 -attr @rip heading_deg_reg[0]_11[1] -pin u_dados heading_deg_reg[0]_11[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4659_0[1]
load net u_vga_n_251 -attr @rip h_cont_reg[3]_rep__1_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1122[0] -pin u_vga h_cont_reg[3]_rep__1_4[0]
load net u_vector_n_365 -attr @rip inicio_operacao_reg[3]_1[0] -pin g_operacao.u_operacao SR[0] -pin u_vector inicio_operacao_reg[3]_1[0]
netloc u_vector_n_365 1 0 3 520 4060 NJ 4060 2680
load net amostra_completa[47] -attr @rip Q[28] -pin u_dados Q[28] -pin u_entrada Q[28]
load net u_vga_n_40 -pin u_dados VGA_R_OBUF[3]_inst_i_159_1 -pin u_vga v_cont_reg[2]_1
netloc u_vga_n_40 1 2 3 4120 9000 NJ 9000 14520
load net u_ui_test_n_172 -attr @rip last_data_reg[21][0] -pin g_native_video.u_native wr_data2_carry__1[0] -pin u_ui_test last_data_reg[21][0]
load net compass_gravity_z[10] -attr @rip Q[10] -pin g_mag_tilt.u_heading gz_reg[24]_0[10] -pin u_vector Q[10]
load net dados_operacao[2] -attr @rip D[2] -pin g_operacao.u_operacao D[2] -pin u_entrada retido_reg[121]_0[41]
load net mpu_raw_ay[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[66] -pin u_sensor accel_x_reg[15]_0[66] -pin u_vector a_reg[0][15]_0[66]
load net metadados_in[12] -attr @rip Q[67] -pin u_dados Q[67] -pin u_entrada Q[67]
load net memory_and_vga/bridge/last_data[31] -attr @rip last_data_reg[125][31] -pin g_native_video.u_native last_data_reg[125][31] -pin u_ui_test wr_data2_carry__9[31]
load net memory_and_vga/bridge/last_data[95] -attr @rip last_data_reg[125][95] -pin g_native_video.u_native last_data_reg[125][95] -pin u_ui_test wr_data2_carry__9[95]
load net mira_y_in[4] -attr @rip Q[14] -pin u_dados Q[14] -pin u_entrada Q[14]
load net native_app_rd_data[1] -attr @rip din[1] -pin g_native_video.u_native din[1] -pin u_ui_test din[1]
load net native_app_rd_data[65] -attr @rip din[65] -pin g_native_video.u_native din[65] -pin u_ui_test din[65]
load net native_app_wdf_data[1] -attr @rip dout[1] -pin g_native_video.u_native dout[1] -pin u_ui_test dout[1]
load net native_app_wdf_data[65] -attr @rip dout[65] -pin g_native_video.u_native dout[65] -pin u_ui_test dout[65]
load net roll_fallback_q10[7] -attr @rip roll_fallback_q10_reg[31]_0[7] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[7] -pin u_vector rw_reg_i_3_0[7]
load net pitch_fallback_q10[25] -attr @rip pitch_fallback_q10_reg[31]_1[25] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[25] -pin u_vector pw_reg[25]
load net samples_reg[4][7] -attr @rip samples_reg[4][7]_0[15] -pin u_sensor samples_reg[4][7]_0[15] -pin u_vector p_1_in__0_0[15]
load net u_dados_n_194 -pin u_dados altitude_ft_reg[6]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3446_1
netloc u_dados_n_194 1 3 1 7300 1600n
load net u_dados_n_75 -pin u_dados h_cont_reg[1]_rep__0_0 -pin u_vga VGA_R_OBUF[3]_inst_i_823_1
netloc u_dados_n_75 1 3 1 8840 2000n
load net u_dados_n_27 -attr @rip h_cont_reg[5]_rep_1[2] -pin u_dados h_cont_reg[5]_rep_1[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2271[2]
load net u_dados_n_110 -attr @rip heading_deg_reg[0]_10[0] -pin u_dados heading_deg_reg[0]_10[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4424_1[0]
load net u_dados_n_328 -pin u_dados velocidade_kt_reg[0]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_393_2
netloc u_dados_n_328 1 3 1 11500 3380n
load net u_vga_n_249 -attr @rip h_cont_reg[3]_rep__1_4[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1122[2] -pin u_vga h_cont_reg[3]_rep__1_4[2]
load net amostra_completa[45] -attr @rip Q[26] -pin u_dados Q[26] -pin u_entrada Q[26]
load net u_vga_n_37 -pin u_dados VGA_R_OBUF[3]_inst_i_820_2 -pin u_vga v_cont_reg[0]_rep__0_1
netloc u_vga_n_37 1 2 3 4260 8840 NJ 8840 14720
load net u_ui_test_n_169 -attr @rip last_data_reg[21][3] -pin g_native_video.u_native wr_data2_carry__1[3] -pin u_ui_test last_data_reg[21][3]
load net card_coluna4[5] -attr @rip h_cont_reg[7]_0[4] -pin u_dados VGA_R_OBUF[3]_inst_i_822_1[4] -pin u_vga h_cont_reg[7]_0[4]
load net compass_gravity_z[9] -attr @rip Q[9] -pin g_mag_tilt.u_heading gz_reg[24]_0[9] -pin u_vector Q[9]
load net mpu_raw_ax[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[95] -pin u_sensor accel_x_reg[15]_0[95] -pin u_vector a_reg[0][15]_0[95]
load net native_app_addr[18] -attr @rip app_addr[15] -pin g_native_video.u_native app_addr[15] -pin u_ui_test app_addr[15]
load net mira_y_in[1] -attr @rip Q[11] -pin u_dados Q[11] -pin u_entrada Q[11]
load net metadados_in[9] -attr @rip Q[64] -pin u_dados Q[64] -pin u_entrada Q[64]
load net memory_and_vga/bridge/last_data[28] -attr @rip last_data_reg[125][28] -pin g_native_video.u_native last_data_reg[125][28] -pin u_ui_test wr_data2_carry__9[28]
load net memory_and_vga/bridge/last_data[92] -attr @rip last_data_reg[125][92] -pin g_native_video.u_native last_data_reg[125][92] -pin u_ui_test wr_data2_carry__9[92]
load net native_app_rd_data[126] -attr @rip din[126] -pin g_native_video.u_native din[126] -pin u_ui_test din[126]
load net native_app_wdf_data[126] -attr @rip dout[126] -pin g_native_video.u_native dout[126] -pin u_ui_test dout[126]
load net native_app_wdf_data[62] -attr @rip dout[62] -pin g_native_video.u_native dout[62] -pin u_ui_test dout[62]
load net native_app_rd_data[62] -attr @rip din[62] -pin g_native_video.u_native din[62] -pin u_ui_test din[62]
load net samples_reg[4][5] -attr @rip samples_reg[4][7]_0[13] -pin u_sensor samples_reg[4][7]_0[13] -pin u_vector p_1_in__0_0[13]
load net velocidade_kt[0] -attr @rip velocidade_kt_reg[1]_0[0] -pin u_dados velocidade_kt_reg[1]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2146[0]
load net pitch_fallback_q10[22] -attr @rip pitch_fallback_q10_reg[31]_1[22] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[22] -pin u_vector pw_reg[22]
load net roll_fallback_q10[5] -attr @rip roll_fallback_q10_reg[31]_0[5] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[5] -pin u_vector rw_reg_i_3_0[5]
load net u_dados_n_270 -attr @rip VGA_R_OBUF[3]_inst_i_3436_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_0[0]
load net buzzer_out_OBUF -attr @style dashed -attr @rip D[49] -pin g_operacao.u_operacao D[49] -pin u_entrada retido_reg[121]_0[88]
load net u_dados_n_76 -pin u_dados VGA_R_OBUF[3]_inst_i_1664_0 -pin u_vga VGA_R_OBUF[3]_inst_i_408
netloc u_dados_n_76 1 3 1 11960 340n
load net u_dados_n_195 -pin u_dados altitude_ft_reg[7]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3446_0
netloc u_dados_n_195 1 3 1 10280 1640n
load net u_dados_n_329 -pin u_dados velocidade_kt_reg[0]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1416_1
netloc u_dados_n_329 1 3 1 9980 3880n
load net u_dados_n_111 -attr @rip heading_deg_reg[7]_rep_0[0] -pin u_dados heading_deg_reg[7]_rep_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4424_0[0]
netloc u_dados_n_111 1 3 1 8140 2680n
load net u_vector_n_361 -attr @rip inicio_operacao_reg[3][0] -pin g_mag_tilt.u_heading SR[0] -pin u_vector inicio_operacao_reg[3][0]
netloc u_vector_n_361 1 2 1 3180 4440n
load net u_ui_test_n_170 -attr @rip last_data_reg[21][2] -pin g_native_video.u_native wr_data2_carry__1[2] -pin u_ui_test last_data_reg[21][2]
load net amostra_completa[69] -attr @rip Q[29] -pin u_dados Q[29] -pin u_entrada Q[29]
load net u_vga_n_25 -attr @rip h_cont_reg[3]_rep__1_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_0[2] -pin u_vga h_cont_reg[3]_rep__1_1[2]
load net u_vga_n_38 -pin u_dados VGA_R_OBUF[3]_inst_i_820_0 -pin u_vga v_cont_reg[0]_rep__0_2
netloc u_vga_n_38 1 2 3 4240 8860 NJ 8860 14700
load net u_vga_n_17 -pin u_dados VGA_R_OBUF[3]_inst_i_2275 -pin u_vga h_cont_reg[4]_rep__1_0
netloc u_vga_n_17 1 2 3 6040 4780 8920J 960 14960
load net compass_gravity_z[7] -attr @rip Q[7] -pin g_mag_tilt.u_heading gz_reg[24]_0[7] -pin u_vector Q[7]
load net dados_operacao[0] -attr @rip D[0] -pin g_operacao.u_operacao D[0] -pin u_entrada retido_reg[121]_0[39]
load net mpu_raw_ay[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[64] -pin u_sensor accel_x_reg[15]_0[64] -pin u_vector a_reg[0][15]_0[64]
load net native_app_cmd[0] -attr @rip app_cmd[0] -pin g_native_video.u_native app_cmd[0] -pin u_ui_test app_cmd[0]
netloc native_app_cmd[0] 1 5 1 17400 440n
load net mira_y_in[2] -attr @rip Q[12] -pin u_dados Q[12] -pin u_entrada Q[12]
load net metadados_in[8] -attr @rip Q[63] -pin u_dados Q[63] -pin u_entrada Q[63]
load net memory_and_vga/bridge/last_data[29] -attr @rip last_data_reg[125][29] -pin g_native_video.u_native last_data_reg[125][29] -pin u_ui_test wr_data2_carry__9[29]
load net memory_and_vga/bridge/last_data[93] -attr @rip last_data_reg[125][93] -pin g_native_video.u_native last_data_reg[125][93] -pin u_ui_test wr_data2_carry__9[93]
load net native_app_rd_data[127] -attr @rip din[127] -pin g_native_video.u_native din[127] -pin u_ui_test din[127]
load net native_app_wdf_data[127] -attr @rip dout[127] -pin g_native_video.u_native dout[127] -pin u_ui_test dout[127]
load net native_app_wdf_data[63] -attr @rip dout[63] -pin g_native_video.u_native dout[63] -pin u_ui_test dout[63]
load net native_app_rd_data[63] -attr @rip din[63] -pin g_native_video.u_native din[63] -pin u_ui_test din[63]
load net roll_fallback_q10[6] -attr @rip roll_fallback_q10_reg[31]_0[6] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[6] -pin u_vector rw_reg_i_3_0[6]
load net pitch_fallback_q10[23] -attr @rip pitch_fallback_q10_reg[31]_1[23] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[23] -pin u_vector pw_reg[23]
load net samples_reg[4][6] -attr @rip samples_reg[4][7]_0[14] -pin u_sensor samples_reg[4][7]_0[14] -pin u_vector p_1_in__0_0[14]
load net velocidade_kt[1] -attr @rip velocidade_kt_reg[1]_0[1] -pin u_dados velocidade_kt_reg[1]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2146[1]
load net u_dados_n_20 -attr @rip O[0] -pin u_dados O[0] -pin u_vga O[0]
load net memory_and_vga/bridge/wr_data2__42 -attr @rip CO[0] -pin g_native_video.u_native CO[0] -pin u_ui_test CO[0]
netloc memory_and_vga/bridge/wr_data2__42 1 5 1 17300 320n
load net u_dados_n_83 -pin u_dados heading_deg_reg[8]_rep_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1211
netloc u_dados_n_83 1 3 1 10680 2860n
load net u_dados_n_275 -attr @rip VGA_R_OBUF[3]_inst_i_3436_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_3[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4013_0[0]
netloc u_dados_n_275 1 3 1 10820 1060n
load net u_dados_n_116 -attr @rip heading_deg_reg[0]_12[2] -pin u_dados heading_deg_reg[0]_12[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4447_1[2]
load net u_dados_n_333 -pin u_dados heading_deg_reg[0]_15 -pin u_vga VGA_R_OBUF[3]_inst_i_396_0
netloc u_dados_n_333 1 3 1 9820 2560n
load net u_vga_n_254 -attr @rip h_cont_reg[0]_rep_4[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1072[1] -pin u_vga h_cont_reg[0]_rep_4[1]
load net u_vga_n_43 -attr @rip h_cont_reg[1]_rep__0_3[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_0[2] -pin u_vga h_cont_reg[1]_rep__0_3[2]
load net amostra_completa[71] -attr @rip Q[31] -pin u_dados Q[31] -pin u_entrada Q[31]
load net u_vga_n_10 -pin u_dados VGA_R_OBUF[3]_inst_i_3466 -pin u_vga h_cont_reg[3]_rep_0
netloc u_vga_n_10 1 2 3 5180 6400 8820J 2220 14660
load net u_ui_test_n_175 -attr @rip last_data_reg[34][1] -pin g_native_video.u_native wr_data2_carry__2[1] -pin u_ui_test last_data_reg[34][1]
load net horizonte_sync[1] -attr @style dashed -attr @rip 1 -pin g_operacao.u_operacao out[1] -pin u_sensor sensor_i_3[1] -pin u_vector pitch_fallback_q10_reg[14][1]
load net compass_gravity_z[13] -attr @rip Q[13] -pin g_mag_tilt.u_heading gz_reg[24]_0[13] -pin u_vector Q[13]
load net dados_operacao[5] -attr @rip D[5] -pin g_operacao.u_operacao D[5] -pin u_entrada retido_reg[121]_0[44]
load net metadados_in[15] -attr @rip Q[70] -pin u_dados Q[70] -pin u_entrada Q[70]
load net mpu_raw_ay[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[69] -pin u_sensor accel_x_reg[15]_0[69] -pin u_vector a_reg[0][15]_0[69]
load net memory_and_vga/bridge/last_data[34] -attr @rip last_data_reg[125][34] -pin g_native_video.u_native last_data_reg[125][34] -pin u_ui_test wr_data2_carry__9[34]
load net memory_and_vga/bridge/last_data[98] -attr @rip last_data_reg[125][98] -pin g_native_video.u_native last_data_reg[125][98] -pin u_ui_test wr_data2_carry__9[98]
load net native_app_wdf_data[68] -attr @rip dout[68] -pin g_native_video.u_native dout[68] -pin u_ui_test dout[68]
load net native_app_wdf_data[4] -attr @rip dout[4] -pin g_native_video.u_native dout[4] -pin u_ui_test dout[4]
load net native_app_rd_data[4] -attr @rip din[4] -pin g_native_video.u_native din[4] -pin u_ui_test din[4]
load net native_app_rd_data[68] -attr @rip din[68] -pin g_native_video.u_native din[68] -pin u_ui_test din[68]
load net roll_fallback_q10[11] -attr @rip roll_fallback_q10_reg[31]_0[11] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[11] -pin u_vector rw_reg_i_3_0[11]
load net samples_reg[5][2] -attr @rip samples_reg[4][7]_0[2] -pin u_sensor samples_reg[4][7]_0[2] -pin u_vector p_1_in__0_0[2]
load net pitch_fallback_q10_next[0] -attr @rip horizonte_sync_reg[0][0] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[0] -pin u_vector horizonte_sync_reg[0][0]
load net GYRO_LED_OBUF -attr @style dashed -pin u_sensor GYRO_LED_OBUF -pin u_vector GYRO_LED_OBUF
netloc GYRO_LED_OBUF 1 1 1 1690 4180n
load net u_dados_n_276 -attr @rip VGA_R_OBUF[3]_inst_i_2869_7[2] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_7[2] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_1[2]
load net u_dados_n_200 -pin u_dados velocidade_kt_reg[9]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3407_0
netloc u_dados_n_200 1 3 1 7760 4020n
load net u_dados_n_117 -attr @rip heading_deg_reg[0]_12[1] -pin u_dados heading_deg_reg[0]_12[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4447_1[1]
load net u_dados_n_334 -pin u_dados heading_deg_reg[8]_rep_7 -pin u_vga VGA_R_OBUF[3]_inst_i_1118_0
netloc u_dados_n_334 1 3 1 11040 3000n
load net u_dados_n_84 -pin u_dados heading_deg_reg[3]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_412
netloc u_dados_n_84 1 3 1 10520 2620n
load net memory_and_vga/frame_latch -pin g_native_video.u_native frame_latch -pin u_vga frame_latch
netloc memory_and_vga/frame_latch 1 4 1 15480 1920n
load net g_native_video.displayed_valid -attr @style dashed -pin g_native_video.u_native g_native_video.displayed_valid -pin u_vga g_native_video.displayed_valid
netloc g_native_video.displayed_valid 1 3 3 12400 1400 15620J 2960 17160
load net vector_updated -attr @style dashed -pin g_operacao.u_operacao updated -pin u_vector updated
netloc vector_updated 1 0 3 40 6580 NJ 6580 2520
load net amostra_completa[72] -attr @rip Q[32] -pin u_dados Q[32] -pin u_entrada Q[32]
load net u_vga_n_255 -attr @rip h_cont_reg[0]_rep_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1072[0] -pin u_vga h_cont_reg[0]_rep_4[0]
load net u_vga_n_44 -attr @rip h_cont_reg[1]_rep__0_3[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_0[1] -pin u_vga h_cont_reg[1]_rep__0_3[1]
load net u_ui_test_n_176 -attr @rip last_data_reg[34][0] -pin g_native_video.u_native wr_data2_carry__2[0] -pin u_ui_test last_data_reg[34][0]
load net compass_gravity_z[14] -attr @rip Q[14] -pin g_mag_tilt.u_heading gz_reg[24]_0[14] -pin u_vector Q[14]
load net dados_operacao[6] -attr @rip D[6] -pin g_operacao.u_operacao D[6] -pin u_entrada retido_reg[121]_0[45]
load net hud_metadados[0] -attr @rip metadados_reg[15]_0[0] -pin u_dados metadados_reg[15]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[0]
load net mira_y_in[7] -attr @rip Q[17] -pin u_dados Q[17] -pin u_entrada Q[17]
load net mpu_raw_ay[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[70] -pin u_sensor accel_x_reg[15]_0[70] -pin u_vector a_reg[0][15]_0[70]
load net metadados_in[25] -attr @rip Q[71] -pin u_dados Q[71] -pin u_entrada Q[71]
load net memory_and_vga/bridge/last_data[35] -attr @rip last_data_reg[125][35] -pin g_native_video.u_native last_data_reg[125][35] -pin u_ui_test wr_data2_carry__9[35]
load net memory_and_vga/bridge/last_data[99] -attr @rip last_data_reg[125][99] -pin g_native_video.u_native last_data_reg[125][99] -pin u_ui_test wr_data2_carry__9[99]
load net native_app_wdf_data[69] -attr @rip dout[69] -pin g_native_video.u_native dout[69] -pin u_ui_test dout[69]
load net native_app_wdf_data[5] -attr @rip dout[5] -pin g_native_video.u_native dout[5] -pin u_ui_test dout[5]
load net native_app_rd_data[69] -attr @rip din[69] -pin g_native_video.u_native din[69] -pin u_ui_test din[69]
load net native_app_rd_data[5] -attr @rip din[5] -pin g_native_video.u_native din[5] -pin u_ui_test din[5]
load net roll_fallback_q10[12] -attr @rip roll_fallback_q10_reg[31]_0[12] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[12] -pin u_vector rw_reg_i_3_0[12]
load net pitch_fallback_q10_next[1] -attr @rip horizonte_sync_reg[0][1] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[1] -pin u_vector horizonte_sync_reg[0][1]
load net samples_reg[5][3] -attr @rip samples_reg[4][7]_0[3] -pin u_sensor samples_reg[4][7]_0[3] -pin u_vector p_1_in__0_0[3]
load net u_dados_n_273 -attr @rip VGA_R_OBUF[3]_inst_i_3436_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_3436_2[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3348_0[0]
load net u_dados_n_81 -pin u_dados heading_deg_reg[7]_2 -pin u_vga VGA_R_OBUF[3]_inst_i_412_0
netloc u_dados_n_81 1 3 1 9400 2760n
load net u_dados_n_198 -attr @rip altitude_ft_reg[6]_1[0] -pin u_dados altitude_ft_reg[6]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_1[0]
load net u_dados_n_114 -attr @rip heading_deg_reg[0]_11[0] -pin u_dados heading_deg_reg[0]_11[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4659_0[0]
load net memory_and_vga/bridge/read_requests/rd_en0 -pin g_native_video.u_native rd_en -pin u_ui_test rd_en
netloc memory_and_vga/bridge/read_requests/rd_en0 1 4 3 16280 1100 NJ 1100 18080
load net u_dados_n_331 -pin u_dados VGA_R_OBUF[3]_inst_i_2094_0 -pin u_vga VGA_R_OBUF[3]_inst_i_786_3
netloc u_dados_n_331 1 3 1 8940 500n
load net capture_hud_opaque -pin g_native_video.u_native capture_hud_opaque -pin u_vga capture_hud_opaque
netloc capture_hud_opaque 1 4 1 15420 1800n
load net u_vga_n_252 -attr @rip h_cont_reg[6]_6[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1072_0[0] -pin u_vga h_cont_reg[6]_6[0]
netloc u_vga_n_252 1 2 3 4500 8360 NJ 8360 15280
load net u_vga_n_41 -pin u_dados VGA_R_OBUF[3]_inst_i_1168_1 -pin u_vga h_cont_reg[1]_rep__0_2
netloc u_vga_n_41 1 2 3 5620 4400 9880J 580 14800
load net u_ui_test_n_173 -attr @rip last_data_reg[34][3] -pin g_native_video.u_native wr_data2_carry__2[3] -pin u_ui_test last_data_reg[34][3]
load net compass_gravity_z[11] -attr @rip Q[11] -pin g_mag_tilt.u_heading gz_reg[24]_0[11] -pin u_vector Q[11]
load net dados_operacao[3] -attr @rip D[3] -pin g_operacao.u_operacao D[3] -pin u_entrada retido_reg[121]_0[42]
load net mpu_raw_ay[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[67] -pin u_sensor accel_x_reg[15]_0[67] -pin u_vector a_reg[0][15]_0[67]
load net metadados_in[13] -attr @rip Q[68] -pin u_dados Q[68] -pin u_entrada Q[68]
load net memory_and_vga/bridge/last_data[32] -attr @rip last_data_reg[125][32] -pin g_native_video.u_native last_data_reg[125][32] -pin u_ui_test wr_data2_carry__9[32]
load net memory_and_vga/bridge/last_data[96] -attr @rip last_data_reg[125][96] -pin g_native_video.u_native last_data_reg[125][96] -pin u_ui_test wr_data2_carry__9[96]
load net mira_y_in[5] -attr @rip Q[15] -pin u_dados Q[15] -pin u_entrada Q[15]
load net native_app_rd_data[2] -attr @rip din[2] -pin g_native_video.u_native din[2] -pin u_ui_test din[2]
load net native_app_rd_data[66] -attr @rip din[66] -pin g_native_video.u_native din[66] -pin u_ui_test din[66]
load net native_app_wdf_data[2] -attr @rip dout[2] -pin g_native_video.u_native dout[2] -pin u_ui_test dout[2]
load net native_app_wdf_data[66] -attr @rip dout[66] -pin g_native_video.u_native dout[66] -pin u_ui_test dout[66]
load net roll_fallback_q10[8] -attr @rip roll_fallback_q10_reg[31]_0[8] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[8] -pin u_vector rw_reg_i_3_0[8]
load net pitch_fallback_q10[31] -attr @rip pitch_fallback_q10_reg[31]_1[26] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_1[26] -pin u_vector pw_reg[26]
load net samples_reg[5][0] -attr @rip samples_reg[4][7]_0[0] -pin u_sensor samples_reg[4][7]_0[0] -pin u_vector p_1_in__0_0[0]
load net u_dados_n_332 -pin u_dados VGA_R_OBUF[3]_inst_i_1574 -pin u_vga VGA_R_OBUF[3]_inst_i_786_4
netloc u_dados_n_332 1 3 1 11820 320n
load net memory_and_vga/bridge/wr_data0 -attr @rip FSM_onehot_state_reg[1]_0[0] -pin g_native_video.u_native gen_rd_b.gen_rd_b_synth_template.gen_rf_narrow_pipe.doutb_reg_reg[0][0] -pin u_ui_test FSM_onehot_state_reg[1]_0[0]
netloc memory_and_vga/bridge/wr_data0 1 4 3 16040 860 NJ 860 18100
load net u_dados_n_115 -attr @rip heading_deg_reg[0]_12[3] -pin u_dados heading_deg_reg[0]_12[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4447_1[3]
load net u_dados_n_82 -pin u_dados heading_deg_reg[3]_1 -pin u_vga VGA_R_OBUF[3]_inst_i_65_1
netloc u_dados_n_82 1 3 1 11100 2600n
load net u_dados_n_199 -attr @rip VGA_R_OBUF[3]_inst_i_2150[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2150[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3407_1[0]
netloc u_dados_n_199 1 3 1 9360 540n
load net u_dados_n_274 -attr @rip VGA_R_OBUF[3]_inst_i_2869_6[0] -pin u_dados VGA_R_OBUF[3]_inst_i_2869_6[0] -pin u_vga VGA_R_OBUF[3]_inst_i_3349_2[0]
netloc u_dados_n_274 1 3 1 9300 820n
load net amostra_completa[70] -attr @rip Q[30] -pin u_dados Q[30] -pin u_entrada Q[30]
load net u_vga_n_253 -attr @rip h_cont_reg[0]_rep_4[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1072[2] -pin u_vga h_cont_reg[0]_rep_4[2]
load net u_vga_n_42 -attr @rip h_cont_reg[1]_rep__0_3[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_0[3] -pin u_vga h_cont_reg[1]_rep__0_3[3]
load net u_ui_test_n_174 -attr @rip last_data_reg[34][2] -pin g_native_video.u_native wr_data2_carry__2[2] -pin u_ui_test last_data_reg[34][2]
load net horizonte_sync[0] -attr @style dashed -attr @rip 0 -pin g_operacao.u_operacao out[0] -pin u_sensor sensor_i_3[0] -pin u_vector pitch_fallback_q10_reg[14][0]
load net compass_gravity_z[12] -attr @rip Q[12] -pin g_mag_tilt.u_heading gz_reg[24]_0[12] -pin u_vector Q[12]
load net dados_operacao[4] -attr @rip D[4] -pin g_operacao.u_operacao D[4] -pin u_entrada retido_reg[121]_0[43]
load net mpu_raw_ay[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[68] -pin u_sensor accel_x_reg[15]_0[68] -pin u_vector a_reg[0][15]_0[68]
load net metadados_in[14] -attr @rip Q[69] -pin u_dados Q[69] -pin u_entrada Q[69]
load net memory_and_vga/bridge/last_data[33] -attr @rip last_data_reg[125][33] -pin g_native_video.u_native last_data_reg[125][33] -pin u_ui_test wr_data2_carry__9[33]
load net memory_and_vga/bridge/last_data[97] -attr @rip last_data_reg[125][97] -pin g_native_video.u_native last_data_reg[125][97] -pin u_ui_test wr_data2_carry__9[97]
load net mira_y_in[6] -attr @rip Q[16] -pin u_dados Q[16] -pin u_entrada Q[16]
load net native_app_rd_data[3] -attr @rip din[3] -pin g_native_video.u_native din[3] -pin u_ui_test din[3]
load net native_app_rd_data[67] -attr @rip din[67] -pin g_native_video.u_native din[67] -pin u_ui_test din[67]
load net native_app_wdf_data[67] -attr @rip dout[67] -pin g_native_video.u_native dout[67] -pin u_ui_test dout[67]
load net native_app_wdf_data[3] -attr @rip dout[3] -pin g_native_video.u_native dout[3] -pin u_ui_test dout[3]
load net roll_fallback_q10[10] -attr @rip roll_fallback_q10_reg[31]_0[10] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[10] -pin u_vector rw_reg_i_3_0[10]
load net samples_reg[5][1] -attr @rip samples_reg[4][7]_0[1] -pin u_sensor samples_reg[4][7]_0[1] -pin u_vector p_1_in__0_0[1]
load net u_entrada_n_12 -pin u_dados alvo_y_pendente_reg[7]_0 -pin u_entrada dados_destino_reg[17]_0
netloc u_entrada_n_12 1 2 1 3420 3660n
load net u_dados_n_40 -attr @rip h_cont_reg[9]_0[2] -pin u_dados h_cont_reg[9]_0[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2903[2]
load net native_app_rd_data_valid -pin g_native_video.u_native app_rd_data_valid -pin u_ui_test app_rd_data_valid
netloc native_app_rd_data_valid 1 4 3 16320 920 NJ 920 18300
load net u_dados_n_293 -pin u_dados velocidade_kt_reg[9]_9 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_5
netloc u_dados_n_293 1 3 1 10020 4200n
load net u_vga_n_72 -attr @rip h_cont_reg[7]_2[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_0[1] -pin u_vga h_cont_reg[7]_2[1]
load net amostra_completa[91] -attr @rip Q[51] -pin u_dados Q[51] -pin u_entrada Q[51]
load net u_vga_n_214 -pin u_dados VGA_R_OBUF[3]_inst_i_2809_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3367
netloc u_vga_n_214 1 2 3 5800 5720 8540J 1540 13920
load net u_vga_n_127 -attr @rip h_cont_reg[2]_rep_5[2] -pin u_dados VGA_R_OBUF[3]_inst_i_73_0[2] -pin u_vga h_cont_reg[2]_rep_5[2]
load net u_vga_n_272 -attr @rip h_cont_reg[1]_rep__0_8[1] -pin u_dados VGA_R_OBUF[3]_inst_i_766[1] -pin u_vga h_cont_reg[1]_rep__0_8[1]
load net altitude_ft[15] -attr @rip altitude_ft_reg[16]_0[15] -pin u_dados altitude_ft_reg[16]_0[15] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[15]
load net u_ui_test_n_195 -attr @rip last_data_reg[95][1] -pin g_native_video.u_native wr_data2_carry__7[1] -pin u_ui_test last_data_reg[95][1]
load net compass_gravity_x[17] -attr @rip gravity_x_reg[23]_0[17] -pin g_mag_tilt.u_heading gx_reg[23]_0[17] -pin u_vector gravity_x_reg[23]_0[17]
load net dados_operacao[45] -attr @rip D[24] -pin g_operacao.u_operacao D[24] -pin u_entrada retido_reg[121]_0[63]
load net mpu_raw_gx[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[40] -pin u_sensor accel_x_reg[15]_0[40] -pin u_vector a_reg[0][15]_0[40]
load net mpu_accel_z[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[56] -pin u_sensor accel_x_reg[15]_0[56] -pin u_vector a_reg[0][15]_0[56]
load net p_0_out[2] -attr @style dashed -attr @rip p_0_out[0] -pin g_mag_tilt.u_heading p_0_out[0] -pin g_operacao.u_operacao p_0_out[0]
netloc p_0_out[2] 1 0 4 40 4000 NJ 4000 3100J 5560 7080
load net native_app_wdf_data[24] -attr @rip dout[24] -pin g_native_video.u_native dout[24] -pin u_ui_test dout[24]
load net native_app_wdf_data[88] -attr @rip dout[88] -pin g_native_video.u_native dout[88] -pin u_ui_test dout[88]
load net memory_and_vga/bridge/last_data[118] -attr @rip last_data_reg[125][118] -pin g_native_video.u_native last_data_reg[125][118] -pin u_ui_test wr_data2_carry__9[118]
load net memory_and_vga/bridge/last_data[54] -attr @rip last_data_reg[125][54] -pin g_native_video.u_native last_data_reg[125][54] -pin u_ui_test wr_data2_carry__9[54]
load net native_app_rd_data[24] -attr @rip din[24] -pin g_native_video.u_native din[24] -pin u_ui_test din[24]
load net native_app_rd_data[88] -attr @rip din[88] -pin g_native_video.u_native din[88] -pin u_ui_test din[88]
load net roll_fallback_q10_next[1] -attr @rip roll_sync_reg[0]_0[1] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[1] -pin u_vector roll_sync_reg[0]_0[1]
load net samples_reg[0][3] -attr @rip B[11] -pin u_sensor B[11] -pin u_vector B[11]
load net pitch_fallback_q10_next[20] -attr @rip horizonte_sync_reg[0][20] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[20] -pin u_vector horizonte_sync_reg[0][20]
load net vector_pitch[10] -attr @style dashed -attr @rip roll_reg[31]_0[0] -pin g_operacao.u_operacao meta_reg[3][0] -pin u_vector roll_reg[31]_0[0]
load net u_entrada_n_13 -pin u_dados alvo_y_pendente_reg[6]_0 -pin u_entrada dados_destino_reg[16]_0
netloc u_entrada_n_13 1 2 1 3400 3640n
load net u_dados_n_41 -attr @rip h_cont_reg[9]_0[1] -pin u_dados h_cont_reg[9]_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2903[1]
load net u_dados_n_294 -pin u_dados velocidade_kt_reg[9]_10 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_4
netloc u_dados_n_294 1 3 1 N 4220
load net native_app_rdy -pin g_native_video.u_native app_rdy -pin u_ui_test app_rdy
netloc native_app_rdy 1 4 3 16400 1140 NJ 1140 18060
load net u_vga_n_73 -attr @rip h_cont_reg[7]_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_0[0] -pin u_vga h_cont_reg[7]_2[0]
load net amostra_completa[92] -attr @rip Q[52] -pin u_dados Q[52] -pin u_entrada Q[52]
load net u_vga_n_215 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_5 -pin u_vga altitude_ft_reg[8]
netloc u_vga_n_215 1 2 3 5560 5900 7160J 1720 14420
load net u_vga_n_128 -attr @rip h_cont_reg[2]_rep_5[1] -pin u_dados VGA_R_OBUF[3]_inst_i_73_0[1] -pin u_vga h_cont_reg[2]_rep_5[1]
load net u_vga_n_273 -attr @rip h_cont_reg[1]_rep__0_8[0] -pin u_dados VGA_R_OBUF[3]_inst_i_766[0] -pin u_vga h_cont_reg[1]_rep__0_8[0]
load net altitude_ft[16] -attr @rip altitude_ft_reg[16]_0[16] -pin u_dados altitude_ft_reg[16]_0[16] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[16]
load net u_ui_test_n_196 -attr @rip last_data_reg[95][0] -pin g_native_video.u_native wr_data2_carry__7[0] -pin u_ui_test last_data_reg[95][0]
load net compass_gravity_x[18] -attr @rip gravity_x_reg[23]_0[18] -pin g_mag_tilt.u_heading gx_reg[23]_0[18] -pin u_vector gravity_x_reg[23]_0[18]
load net dados_operacao[46] -attr @rip D[25] -pin g_operacao.u_operacao D[25] -pin u_entrada retido_reg[121]_0[64]
load net direcao_grau2[8] -attr @rip heading_deg_reg[8]_rep[0] -pin u_dados VGA_R_OBUF[3]_inst_i_839_0[0] -pin u_vga heading_deg_reg[8]_rep[0]
load net mpu_accel_z[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[58] -pin u_sensor accel_x_reg[15]_0[58] -pin u_vector a_reg[0][15]_0[58]
load net mpu_raw_gx[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[42] -pin u_sensor accel_x_reg[15]_0[42] -pin u_vector a_reg[0][15]_0[42]
load net memory_and_vga/bridge/last_data[119] -attr @rip last_data_reg[125][119] -pin g_native_video.u_native last_data_reg[125][119] -pin u_ui_test wr_data2_carry__9[119]
load net memory_and_vga/bridge/last_data[55] -attr @rip last_data_reg[125][55] -pin g_native_video.u_native last_data_reg[125][55] -pin u_ui_test wr_data2_carry__9[55]
load net native_app_wdf_data[89] -attr @rip dout[89] -pin g_native_video.u_native dout[89] -pin u_ui_test dout[89]
load net native_app_wdf_data[25] -attr @rip dout[25] -pin g_native_video.u_native dout[25] -pin u_ui_test dout[25]
load net native_app_rd_data[25] -attr @rip din[25] -pin g_native_video.u_native din[25] -pin u_ui_test din[25]
load net native_app_rd_data[89] -attr @rip din[89] -pin g_native_video.u_native din[89] -pin u_ui_test din[89]
load net samples_reg[0][4] -attr @rip B[12] -pin u_sensor B[12] -pin u_vector B[12]
load net roll_fallback_q10_next[2] -attr @rip roll_sync_reg[0]_0[2] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[2] -pin u_vector roll_sync_reg[0]_0[2]
load net pitch_fallback_q10_next[21] -attr @rip horizonte_sync_reg[0][21] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[21] -pin u_vector horizonte_sync_reg[0][21]
load net modo_atitude_manual -pin g_operacao.u_operacao modo_atitude_manual -pin u_vector modo_atitude_manual
netloc modo_atitude_manual 1 1 1 1130 4740n
load net u_entrada_n_10 -pin u_dados alvo_x_pendente_reg[0]_0 -pin u_entrada dados_destino_reg[4]_7
netloc u_entrada_n_10 1 2 1 2900 3380n
load net u_dados_n_38 -attr @rip VGA_R_OBUF[3]_inst_i_4029_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4029_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4192[0]
load net u_dados_n_291 -pin u_dados velocidade_kt_reg[9]_7 -pin u_vga VGA_R_OBUF[3]_inst_i_1453_1
netloc u_dados_n_291 1 3 1 9520 4160n
load net u_vga_n_116 -attr @rip h_cont_reg[2]_rep_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_77[0] -pin u_vga h_cont_reg[2]_rep_4[0]
load net u_vga_n_70 -attr @rip h_cont_reg[3]_rep__1_3[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1679_0[1] -pin u_vga h_cont_reg[3]_rep__1_3[1]
load net u_ui_test_n_193 -attr @rip last_data_reg[95][3] -pin g_native_video.u_native wr_data2_carry__7[3] -pin u_ui_test last_data_reg[95][3]
load net altitude_ft[13] -attr @rip altitude_ft_reg[16]_0[13] -pin u_dados altitude_ft_reg[16]_0[13] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[13]
load net amostra_completa[89] -attr @rip Q[49] -pin u_dados Q[49] -pin u_entrada Q[49]
load net u_vga_n_212 -pin u_dados VGA_R_OBUF[3]_inst_i_1605 -pin u_vga altitude_ft_reg[2]
netloc u_vga_n_212 1 2 3 5720 5780 7320J 1600 14560
load net u_vga_n_270 -attr @rip h_cont_reg[1]_rep__0_8[3] -pin u_dados VGA_R_OBUF[3]_inst_i_766[3] -pin u_vga h_cont_reg[1]_rep__0_8[3]
load net compass_gravity_x[15] -attr @rip gravity_x_reg[23]_0[15] -pin g_mag_tilt.u_heading gx_reg[23]_0[15] -pin u_vector gravity_x_reg[23]_0[15]
load net dados_operacao[43] -attr @rip D[22] -pin g_operacao.u_operacao D[22] -pin u_entrada retido_reg[121]_0[61]
load net direcao_grau2[0] -attr @rip heading_deg_reg[7]_1[0] -pin u_dados heading_deg_reg[7]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_1691_0[0]
load net mpu_accel_z[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[57] -pin u_sensor accel_x_reg[15]_0[57] -pin u_vector a_reg[0][15]_0[57]
load net mpu_raw_gx[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[41] -pin u_sensor accel_x_reg[15]_0[41] -pin u_vector a_reg[0][15]_0[41]
load net memory_and_vga/bridge/last_data[116] -attr @rip last_data_reg[125][116] -pin g_native_video.u_native last_data_reg[125][116] -pin u_ui_test wr_data2_carry__9[116]
load net memory_and_vga/bridge/last_data[52] -attr @rip last_data_reg[125][52] -pin g_native_video.u_native last_data_reg[125][52] -pin u_ui_test wr_data2_carry__9[52]
load net native_app_wdf_data[86] -attr @rip dout[86] -pin g_native_video.u_native dout[86] -pin u_ui_test dout[86]
load net native_app_wdf_data[22] -attr @rip dout[22] -pin g_native_video.u_native dout[22] -pin u_ui_test dout[22]
load net native_app_rd_data[22] -attr @rip din[22] -pin g_native_video.u_native din[22] -pin u_ui_test din[22]
load net native_app_rd_data[86] -attr @rip din[86] -pin g_native_video.u_native din[86] -pin u_ui_test din[86]
load net samples_reg[0][1] -attr @rip B[9] -pin u_sensor B[9] -pin u_vector B[9]
load net pitch_fallback_q10_next[18] -attr @rip horizonte_sync_reg[0][18] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[18] -pin u_vector horizonte_sync_reg[0][18]
load net u_entrada_n_11 -pin u_dados alvo_y_pendente_reg[8]_0 -pin u_entrada dados_destino_reg[18]_0
netloc u_entrada_n_11 1 2 1 3480 3680n
load net u_dados_n_292 -pin u_dados velocidade_kt_reg[9]_8 -pin u_vga VGA_R_OBUF[3]_inst_i_1450_1
netloc u_dados_n_292 1 3 1 9760 4180n
load net u_dados_n_39 -attr @rip h_cont_reg[9]_0[3] -pin u_dados h_cont_reg[9]_0[3] -pin u_vga VGA_R_OBUF[3]_inst_i_2903[3]
load net native_app_en -pin g_native_video.u_native app_en -pin u_ui_test app_en
netloc native_app_en 1 5 1 17440 460n
load net altitude_ft[14] -attr @rip altitude_ft_reg[16]_0[14] -pin u_dados altitude_ft_reg[16]_0[14] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[14]
load net u_ui_test_n_194 -attr @rip last_data_reg[95][2] -pin g_native_video.u_native wr_data2_carry__7[2] -pin u_ui_test last_data_reg[95][2]
load net amostra_completa[90] -attr @rip Q[50] -pin u_dados Q[50] -pin u_entrada Q[50]
load net u_vga_n_71 -attr @rip h_cont_reg[3]_rep__1_3[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1679_0[0] -pin u_vga h_cont_reg[3]_rep__1_3[0]
load net u_vga_n_271 -attr @rip h_cont_reg[1]_rep__0_8[2] -pin u_dados VGA_R_OBUF[3]_inst_i_766[2] -pin u_vga h_cont_reg[1]_rep__0_8[2]
load net u_vga_n_12 -pin u_dados VGA_R_OBUF[3]_inst_i_1674_0 -pin u_vga h_cont_reg[3]_rep__1_0
netloc u_vga_n_12 1 2 3 5920 4660 10240J 840 14020
load net u_vga_n_213 -pin u_dados VGA_R_OBUF[3]_inst_i_2809 -pin u_vga altitude_ft_reg[3]
netloc u_vga_n_213 1 2 3 5700 5800 10380J 1620 14540
load net compass_gravity_x[16] -attr @rip gravity_x_reg[23]_0[16] -pin g_mag_tilt.u_heading gx_reg[23]_0[16] -pin u_vector gravity_x_reg[23]_0[16]
load net dados_operacao[44] -attr @rip D[23] -pin g_operacao.u_operacao D[23] -pin u_entrada retido_reg[121]_0[62]
load net direcao_grau2[7] -attr @rip heading_deg_reg[7]_1[1] -pin u_dados heading_deg_reg[7]_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_1691_0[1]
load net mpu_accel_z[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[55] -pin u_sensor accel_x_reg[15]_0[55] -pin u_vector a_reg[0][15]_0[55]
load net mpu_raw_gx[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[39] -pin u_sensor accel_x_reg[15]_0[39] -pin u_vector a_reg[0][15]_0[39]
load net memory_and_vga/bridge/last_data[117] -attr @rip last_data_reg[125][117] -pin g_native_video.u_native last_data_reg[125][117] -pin u_ui_test wr_data2_carry__9[117]
load net memory_and_vga/bridge/last_data[53] -attr @rip last_data_reg[125][53] -pin g_native_video.u_native last_data_reg[125][53] -pin u_ui_test wr_data2_carry__9[53]
load net native_app_wdf_data[87] -attr @rip dout[87] -pin g_native_video.u_native dout[87] -pin u_ui_test dout[87]
load net native_app_wdf_data[23] -attr @rip dout[23] -pin g_native_video.u_native dout[23] -pin u_ui_test dout[23]
load net native_app_rd_data[23] -attr @rip din[23] -pin g_native_video.u_native din[23] -pin u_ui_test din[23]
load net native_app_rd_data[87] -attr @rip din[87] -pin g_native_video.u_native din[87] -pin u_ui_test din[87]
load net samples_reg[0][2] -attr @rip B[10] -pin u_sensor B[10] -pin u_vector B[10]
load net roll_fallback_q10_next[0] -attr @rip roll_sync_reg[0]_0[0] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[0] -pin u_vector roll_sync_reg[0]_0[0]
load net pitch_fallback_q10_next[19] -attr @rip horizonte_sync_reg[0][19] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[19] -pin u_vector horizonte_sync_reg[0][19]
load net u_dados_n_297 -pin u_dados VGA_R_OBUF[3]_inst_i_2003_0 -pin u_vga VGA_R_OBUF[3]_inst_i_780_5
netloc u_dados_n_297 1 3 1 11880 380n
load net g_operacao.u_operacao_n_101 -attr @rip roll_reg[13]_0[0] -pin g_operacao.u_operacao roll_reg[13]_0[0] -pin u_vector rc_reg_i_8_0[0]
netloc g_operacao.u_operacao_n_101 1 1 1 1450 4920n
load net native_ui_clk -attr @style dashed -pin g_native_video.u_native CLK -pin u_ui_test ui_clk
netloc native_ui_clk 1 4 3 16380 1120 NJ 1120 18020
load net u_entrada_n_16 -pin u_dados alvo_y_pendente_reg[1]_0 -pin u_entrada dados_destino_reg[11]_0
netloc u_entrada_n_16 1 2 1 3300 3560n
load net u_dados_n_16 -attr @rip h_cont_reg[5]_rep[1] -pin u_dados h_cont_reg[5]_rep[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2272[1]
load net u_dados_n_44 -attr @rip h_cont_reg[9]_1[2] -pin u_dados h_cont_reg[9]_1[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2918[2]
load net amostra_completa[95] -attr @rip Q[55] -pin u_dados Q[55] -pin u_entrada Q[55]
load net u_vga_n_76 -attr @rip h_cont_reg[1]_rep__0_6[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_1[2] -pin u_vga h_cont_reg[1]_rep__0_6[2]
load net u_vga_n_218 -pin u_dados VGA_R_OBUF[3]_inst_i_2781 -pin u_vga altitude_ft_reg[8]_1
netloc u_vga_n_218 1 2 3 5200 5940 7420J 1760 14300
load net u_vga_n_130 -attr @rip h_cont_reg[2]_rep_6[0] -pin u_dados VGA_R_OBUF[3]_inst_i_31[0] -pin u_vga h_cont_reg[2]_rep_6[0]
netloc u_vga_n_130 1 2 3 3900 4860 8720J 1020 14440
load net u_vga_n_276 -attr @rip h_cont_reg[0]_rep__0_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_767_0[1] -pin u_vga h_cont_reg[0]_rep__0_1[1]
load net u_ui_test_n_199 -attr @rip last_data_reg[105][1] -pin g_native_video.u_native wr_data2_carry__8[1] -pin u_ui_test last_data_reg[105][1]
load net compass_gravity_x[21] -attr @rip gravity_x_reg[23]_0[21] -pin g_mag_tilt.u_heading gx_reg[23]_0[21] -pin u_vector gravity_x_reg[23]_0[21]
load net dados_operacao[49] -attr @rip D[28] -pin g_operacao.u_operacao D[28] -pin u_entrada retido_reg[121]_0[67]
load net mpu_accel_z[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[61] -pin u_sensor accel_x_reg[15]_0[61] -pin u_vector a_reg[0][15]_0[61]
load net mpu_raw_gx[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[45] -pin u_sensor accel_x_reg[15]_0[45] -pin u_vector a_reg[0][15]_0[45]
load net memory_and_vga/bridge/last_data[122] -attr @rip last_data_reg[125][122] -pin g_native_video.u_native last_data_reg[125][122] -pin u_ui_test wr_data2_carry__9[122]
load net memory_and_vga/bridge/last_data[58] -attr @rip last_data_reg[125][58] -pin g_native_video.u_native last_data_reg[125][58] -pin u_ui_test wr_data2_carry__9[58]
load net native_app_wdf_data[92] -attr @rip dout[92] -pin g_native_video.u_native dout[92] -pin u_ui_test dout[92]
load net native_app_wdf_data[28] -attr @rip dout[28] -pin g_native_video.u_native dout[28] -pin u_ui_test dout[28]
load net native_app_rd_data[28] -attr @rip din[28] -pin g_native_video.u_native din[28] -pin u_ui_test din[28]
load net native_app_rd_data[92] -attr @rip din[92] -pin g_native_video.u_native din[92] -pin u_ui_test din[92]
load net roll_fallback_q10_next[5] -attr @rip roll_sync_reg[0]_0[5] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[5] -pin u_vector roll_sync_reg[0]_0[5]
load net vector_pitch[14] -attr @style dashed -attr @rip roll_reg[31]_0[1] -pin g_operacao.u_operacao meta_reg[3][1] -pin u_vector roll_reg[31]_0[1]
load net pitch_fallback_q10_next[24] -attr @rip horizonte_sync_reg[0][24] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[24] -pin u_vector horizonte_sync_reg[0][24]
load net g_native_video.u_native_n_172 -pin g_native_video.u_native wrote_word_reg -pin u_ui_test FSM_onehot_state_reg[1]_1
netloc g_native_video.u_native_n_172 1 5 1 17380 360n
load net enabled0 -pin u_sensor enabled0 -pin u_vector enabled0
netloc enabled0 1 1 1 1570 4300n
load net g_operacao.u_operacao_n_102 -attr @rip DI[0] -pin g_operacao.u_operacao DI[0] -pin u_vector rc_reg_i_15_0[0]
netloc g_operacao.u_operacao_n_102 1 1 1 1290 4820n
load net u_entrada_n_17 -pin u_dados alvo_y_pendente_reg[0]_0 -pin u_entrada dados_destino_reg[10]_0
netloc u_entrada_n_17 1 2 1 3280 3540n
load net u_dados_n_298 -pin u_dados VGA_R_OBUF[3]_inst_i_2005_0 -pin u_vga VGA_R_OBUF[3]_inst_i_780_6
netloc u_dados_n_298 1 3 1 11840 400n
load net u_dados_n_24 -attr @rip heading_deg_reg[0]_1[2] -pin u_dados heading_deg_reg[0]_1[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2986_0[2]
load net u_dados_n_45 -attr @rip h_cont_reg[9]_1[1] -pin u_dados h_cont_reg[9]_1[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2918[1]
load net u_dados_n_161 -pin u_dados metadados_reg[25]_0 -pin u_vga VGA_R_OBUF[3]_inst_i_31_0
netloc u_dados_n_161 1 3 1 11300 2780n
load net u_vga_n_77 -attr @rip h_cont_reg[1]_rep__0_6[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_1[1] -pin u_vga h_cont_reg[1]_rep__0_6[1]
load net u_vga_n_219 -pin u_dados VGA_R_OBUF[3]_inst_i_2781_1 -pin u_vga altitude_ft_reg[8]_2
netloc u_vga_n_219 1 2 3 5420 5960 9660J 1780 14260
load net u_vga_n_131 -attr @rip v_cont_reg[0]_1[3] -pin u_dados VGA_R_OBUF[3]_inst_i_32_0[3] -pin u_vga v_cont_reg[0]_1[3]
load net u_vga_n_277 -attr @rip h_cont_reg[0]_rep__0_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_767_0[0] -pin u_vga h_cont_reg[0]_rep__0_1[0]
load net u_ui_test_n_200 -attr @rip last_data_reg[105][0] -pin g_native_video.u_native wr_data2_carry__8[0] -pin u_ui_test last_data_reg[105][0]
load net compass_gravity_x[22] -attr @rip gravity_x_reg[23]_0[22] -pin g_mag_tilt.u_heading gx_reg[23]_0[22] -pin u_vector gravity_x_reg[23]_0[22]
load net dados_operacao[50] -attr @rip D[29] -pin g_operacao.u_operacao D[29] -pin u_entrada retido_reg[121]_0[68]
load net mpu_raw_gx[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[46] -pin u_sensor accel_x_reg[15]_0[46] -pin u_vector a_reg[0][15]_0[46]
load net mpu_accel_z[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[62] -pin u_sensor accel_x_reg[15]_0[62] -pin u_vector a_reg[0][15]_0[62]
load net memory_and_vga/bridge/last_data[123] -attr @rip last_data_reg[125][123] -pin g_native_video.u_native last_data_reg[125][123] -pin u_ui_test wr_data2_carry__9[123]
load net memory_and_vga/bridge/last_data[59] -attr @rip last_data_reg[125][59] -pin g_native_video.u_native last_data_reg[125][59] -pin u_ui_test wr_data2_carry__9[59]
load net native_app_rd_data[29] -attr @rip din[29] -pin g_native_video.u_native din[29] -pin u_ui_test din[29]
load net native_app_rd_data[93] -attr @rip din[93] -pin g_native_video.u_native din[93] -pin u_ui_test din[93]
load net native_app_wdf_data[93] -attr @rip dout[93] -pin g_native_video.u_native dout[93] -pin u_ui_test dout[93]
load net native_app_wdf_data[29] -attr @rip dout[29] -pin g_native_video.u_native dout[29] -pin u_ui_test dout[29]
load net roll_fallback_q10_next[6] -attr @rip roll_sync_reg[0]_0[6] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[6] -pin u_vector roll_sync_reg[0]_0[6]
load net samples_reg[0][7] -attr @rip B[15] -pin u_sensor B[15] -pin u_vector B[15]
load net pitch_fallback_q10_next[25] -attr @rip horizonte_sync_reg[0][25] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[25] -pin u_vector horizonte_sync_reg[0][25]
load net vector_pitch[15] -attr @style dashed -attr @rip roll_reg[31]_0[2] -pin g_operacao.u_operacao meta_reg[3][2] -pin u_vector roll_reg[31]_0[2]
load net reset0 -attr @rip SR[0] -pin u_sensor SR[0] -pin u_vector SR[0]
netloc reset0 1 0 3 340 5700 1670J 5680 2760
load net native_app_wdf_end -attr @rip gen_rd_b.gen_doutb_pipe.gen_stage.doutb_pipe_reg[0][144][0] -pin g_native_video.u_native last_word_reg[15][0] -pin u_ui_test gen_rd_b.gen_doutb_pipe.gen_stage.doutb_pipe_reg[0][144][0]
netloc native_app_wdf_end 1 4 3 16360 960 NJ 960 18240
load net u_entrada_n_14 -pin u_dados alvo_y_pendente_reg[5]_0 -pin u_entrada dados_destino_reg[18]_1
netloc u_entrada_n_14 1 2 1 3460 3620n
load net u_dados_n_148 -pin u_dados VGA_R_OBUF[3]_inst_i_180_0 -pin u_vga VGA_G_OBUF[3]_inst_i_20_0
netloc u_dados_n_148 1 3 1 12120 120n
load net u_dados_n_42 -attr @rip h_cont_reg[9]_0[0] -pin u_dados h_cont_reg[9]_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2903[0]
load net u_dados_n_295 -pin u_dados velocidade_kt_reg[9]_11 -pin u_vga VGA_R_OBUF[3]_inst_i_1450_0
netloc u_dados_n_295 1 3 1 9540 4240n
load net g_native_video.video_visible -attr @style dashed -pin g_native_video.u_native g_native_video.video_visible -pin u_vga g_native_video.video_visible
netloc g_native_video.video_visible 1 3 2 12200 1260 15900J
load net altitude_pendente[0] -attr @rip dados_destino_reg[80]_0[0] -pin u_dados altitude_pendente_reg[16]_0[0] -pin u_entrada dados_destino_reg[80]_0[0]
netloc altitude_pendente[0] 1 2 1 3240 3360n
load net amostra_completa[93] -attr @rip Q[53] -pin u_dados Q[53] -pin u_entrada Q[53]
load net u_vga_n_216 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_4 -pin u_vga altitude_ft_reg[10]
netloc u_vga_n_216 1 2 3 5520 6020 11620J 1840 14040
load net u_vga_n_74 -attr @rip h_cont_reg[9]_2[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4175_0[0] -pin u_vga h_cont_reg[9]_2[0]
netloc u_vga_n_74 1 2 3 4920 8520 NJ 8520 15120
load net u_vga_n_129 -attr @rip h_cont_reg[2]_rep_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_73_0[0] -pin u_vga h_cont_reg[2]_rep_5[0]
load net u_ui_test_n_197 -attr @rip last_data_reg[105][3] -pin g_native_video.u_native wr_data2_carry__8[3] -pin u_ui_test last_data_reg[105][3]
load net u_vga_n_274 -attr @rip h_cont_reg[0]_rep__0_1[3] -pin u_dados VGA_R_OBUF[3]_inst_i_767_0[3] -pin u_vga h_cont_reg[0]_rep__0_1[3]
load net compass_gravity_x[19] -attr @rip gravity_x_reg[23]_0[19] -pin g_mag_tilt.u_heading gx_reg[23]_0[19] -pin u_vector gravity_x_reg[23]_0[19]
load net dados_operacao[47] -attr @rip D[26] -pin g_operacao.u_operacao D[26] -pin u_entrada retido_reg[121]_0[65]
load net direcao_grau2[9] -attr @rip heading_deg_reg[8]_rep[1] -pin u_dados VGA_R_OBUF[3]_inst_i_839_0[1] -pin u_vga heading_deg_reg[8]_rep[1]
load net mpu_accel_z[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[59] -pin u_sensor accel_x_reg[15]_0[59] -pin u_vector a_reg[0][15]_0[59]
load net mpu_raw_gx[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[43] -pin u_sensor accel_x_reg[15]_0[43] -pin u_vector a_reg[0][15]_0[43]
load net memory_and_vga/bridge/last_data[120] -attr @rip last_data_reg[125][120] -pin g_native_video.u_native last_data_reg[125][120] -pin u_ui_test wr_data2_carry__9[120]
load net memory_and_vga/bridge/last_data[56] -attr @rip last_data_reg[125][56] -pin g_native_video.u_native last_data_reg[125][56] -pin u_ui_test wr_data2_carry__9[56]
load net native_app_wdf_data[90] -attr @rip dout[90] -pin g_native_video.u_native dout[90] -pin u_ui_test dout[90]
load net native_app_wdf_data[26] -attr @rip dout[26] -pin g_native_video.u_native dout[26] -pin u_ui_test dout[26]
load net native_app_rd_data[26] -attr @rip din[26] -pin g_native_video.u_native din[26] -pin u_ui_test din[26]
load net native_app_rd_data[90] -attr @rip din[90] -pin g_native_video.u_native din[90] -pin u_ui_test din[90]
load net roll_fallback_q10_next[3] -attr @rip roll_sync_reg[0]_0[3] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[3] -pin u_vector roll_sync_reg[0]_0[3]
load net samples_reg[0][5] -attr @rip B[13] -pin u_sensor B[13] -pin u_vector B[13]
load net pitch_fallback_q10_next[22] -attr @rip horizonte_sync_reg[0][22] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[22] -pin u_vector horizonte_sync_reg[0][22]
load net reset0_8 -attr @rip inicio_operacao_reg[3][0] -pin u_sensor inicio_operacao_reg[3][0] -pin u_vector angle_out_reg[6][0]
netloc reset0_8 1 1 1 1550 4320n
load net g_operacao.u_operacao_n_100 -pin g_operacao.u_operacao altitude_ft_reg[8] -pin u_vector rw_reg_i_23_0
netloc g_operacao.u_operacao_n_100 1 1 1 1210 5000n
load net u_entrada_n_15 -pin u_dados alvo_y_pendente_reg[2]_0 -pin u_entrada dados_destino_reg[12]_0
netloc u_entrada_n_15 1 2 1 3320 3580n
load net u_dados_n_15 -attr @rip h_cont_reg[5]_rep[2] -pin u_dados h_cont_reg[5]_rep[2] -pin u_vga VGA_R_OBUF[3]_inst_i_2272[2]
load net u_dados_n_43 -attr @rip h_cont_reg[9]_1[3] -pin u_dados h_cont_reg[9]_1[3] -pin u_vga VGA_R_OBUF[3]_inst_i_2918[3]
load net u_dados_n_296 -pin u_dados velocidade_kt_reg[9]_12 -pin u_vga VGA_R_OBUF[3]_inst_i_393_0
netloc u_dados_n_296 1 3 1 11480 3340n
load net amostra_completa[94] -attr @rip Q[54] -pin u_dados Q[54] -pin u_entrada Q[54]
load net u_vga_n_13 -pin u_dados VGA_R_OBUF[3]_inst_i_2275_0 -pin u_vga h_cont_reg[2]_rep__0_0
netloc u_vga_n_13 1 2 3 6060 4800 8960J 980 14940
load net u_vga_n_217 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_3 -pin u_vga altitude_ft_reg[8]_0
netloc u_vga_n_217 1 2 3 5460 5920 7620J 1740 14360
load net u_vga_n_75 -attr @rip h_cont_reg[1]_rep__0_6[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1670_1[3] -pin u_vga h_cont_reg[1]_rep__0_6[3]
load net u_vga_n_275 -attr @rip h_cont_reg[0]_rep__0_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_767_0[2] -pin u_vga h_cont_reg[0]_rep__0_1[2]
load net u_ui_test_n_198 -attr @rip last_data_reg[105][2] -pin g_native_video.u_native wr_data2_carry__8[2] -pin u_ui_test last_data_reg[105][2]
load net compass_gravity_x[20] -attr @rip gravity_x_reg[23]_0[20] -pin g_mag_tilt.u_heading gx_reg[23]_0[20] -pin u_vector gravity_x_reg[23]_0[20]
load net dados_operacao[48] -attr @rip D[27] -pin g_operacao.u_operacao D[27] -pin u_entrada retido_reg[121]_0[66]
load net mpu_accel_z[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[60] -pin u_sensor accel_x_reg[15]_0[60] -pin u_vector a_reg[0][15]_0[60]
load net mpu_raw_gx[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[44] -pin u_sensor accel_x_reg[15]_0[44] -pin u_vector a_reg[0][15]_0[44]
load net memory_and_vga/bridge/last_data[121] -attr @rip last_data_reg[125][121] -pin g_native_video.u_native last_data_reg[125][121] -pin u_ui_test wr_data2_carry__9[121]
load net memory_and_vga/bridge/last_data[57] -attr @rip last_data_reg[125][57] -pin g_native_video.u_native last_data_reg[125][57] -pin u_ui_test wr_data2_carry__9[57]
load net native_app_wdf_data[91] -attr @rip dout[91] -pin g_native_video.u_native dout[91] -pin u_ui_test dout[91]
load net native_app_wdf_data[27] -attr @rip dout[27] -pin g_native_video.u_native dout[27] -pin u_ui_test dout[27]
load net native_app_rd_data[91] -attr @rip din[91] -pin g_native_video.u_native din[91] -pin u_ui_test din[91]
load net native_app_rd_data[27] -attr @rip din[27] -pin g_native_video.u_native din[27] -pin u_ui_test din[27]
load net roll_fallback_q10_next[4] -attr @rip roll_sync_reg[0]_0[4] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_2[4] -pin u_vector roll_sync_reg[0]_0[4]
load net samples_reg[0][6] -attr @rip B[14] -pin u_sensor B[14] -pin u_vector B[14]
load net pitch_fallback_q10_next[23] -attr @rip horizonte_sync_reg[0][23] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[23] -pin u_vector horizonte_sync_reg[0][23]
load net u_dados_n_286 -pin u_dados VGA_R_OBUF[3]_inst_i_2547_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_2
netloc u_dados_n_286 1 3 1 9800 600n
load net g_native_video.u_native_n_131 -pin g_native_video.u_native FSM_onehot_state_reg[1] -pin u_ui_test FSM_onehot_state_reg[1]_2
netloc g_native_video.u_native_n_131 1 5 1 17340 380n
load net u_dados_n_344 -pin u_dados VGA_R_OBUF[3]_inst_i_2782_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1140_0
netloc u_dados_n_344 1 3 1 7900 620n
load net u_dados_n_95 -attr @rip VGA_R_OBUF[3]_inst_i_4691_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4691_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4140[0]
load net u_dados_n_128 -attr @rip heading_deg_reg[7]_4[0] -pin u_dados heading_deg_reg[7]_4[0] -pin u_vga VGA_R_OBUF[3]_inst_i_835[0]
netloc u_dados_n_128 1 3 1 11340 2800n
load net u_dados_n_212 -pin u_dados v_cont_reg[7]_rep_1 -pin u_vga VGA_R_OBUF[3]_inst_i_3447_0
netloc u_dados_n_212 1 3 1 8020 3700n
load net memory_and_vga/vga/prefetch_line27_in -pin g_native_video.u_native prefetch_line27_in -pin u_vga prefetch_line27_in
netloc memory_and_vga/vga/prefetch_line27_in 1 4 1 15980 2460n
load net u_vga_n_110 -pin u_dados VGA_R_OBUF[3]_inst_i_30_0 -pin u_vga h_cont_reg[1]_rep__1_3
netloc u_vga_n_110 1 2 3 3820 4540 9960J 720 14840
load net u_vga_n_206 -pin u_dados VGA_R_OBUF[3]_inst_i_1608 -pin u_vga VGA_R_OBUF[3]_inst_i_2783
netloc u_vga_n_206 1 2 3 5760 4640 10160J 820 14240
load net u_ui_test_n_187 -attr @rip last_data_reg[69][1] -pin g_native_video.u_native wr_data2_carry__5[1] -pin u_ui_test last_data_reg[69][1]
load net amostra_completa[83] -attr @rip Q[43] -pin u_dados Q[43] -pin u_entrada Q[43]
load net altitude_ft[9] -attr @rip altitude_ft_reg[16]_0[9] -pin u_dados altitude_ft_reg[16]_0[9] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[9]
load net u_vga_n_265 -pin u_dados VGA_R_OBUF[3]_inst_i_1109_0 -pin u_vga altitude_ft_reg[16]
netloc u_vga_n_265 1 2 3 4660 6040 11640J 1860 13880
load net u_vga_n_64 -attr @rip h_cont_reg[9]_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4155_0[0] -pin u_vga h_cont_reg[9]_1[0]
netloc u_vga_n_64 1 2 3 4860 8500 NJ 8500 15140
load net compass_gravity_x[8] -attr @rip gravity_x_reg[23]_0[8] -pin g_mag_tilt.u_heading gx_reg[23]_0[8] -pin u_vector gravity_x_reg[23]_0[8]
load net dados_operacao[37] -attr @rip D[16] -pin g_operacao.u_operacao D[16] -pin u_entrada retido_reg[121]_0[55]
load net hud_metadados[14] -attr @rip metadados_reg[15]_0[10] -pin u_dados metadados_reg[15]_0[10] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[10]
load net mpu_accel_z[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[49] -pin u_sensor accel_x_reg[15]_0[49] -pin u_vector a_reg[0][15]_0[49]
load net mpu_raw_gx[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[33] -pin u_sensor accel_x_reg[15]_0[33] -pin u_vector a_reg[0][15]_0[33]
load net metadados_operacao[8] -attr @rip D[43] -pin g_operacao.u_operacao D[43] -pin u_entrada retido_reg[121]_0[82]
load net memory_and_vga/bridge/last_data[110] -attr @rip last_data_reg[125][110] -pin g_native_video.u_native last_data_reg[125][110] -pin u_ui_test wr_data2_carry__9[110]
load net memory_and_vga/bridge/last_data[46] -attr @rip last_data_reg[125][46] -pin g_native_video.u_native last_data_reg[125][46] -pin u_ui_test wr_data2_carry__9[46]
load net native_app_wdf_data[80] -attr @rip dout[80] -pin g_native_video.u_native dout[80] -pin u_ui_test dout[80]
load net native_app_wdf_data[16] -attr @rip dout[16] -pin g_native_video.u_native dout[16] -pin u_ui_test dout[16]
load net native_app_rd_data[16] -attr @rip din[16] -pin g_native_video.u_native din[16] -pin u_ui_test din[16]
load net native_app_rd_data[80] -attr @rip din[80] -pin g_native_video.u_native din[80] -pin u_ui_test din[80]
load net roll_fallback_q10[23] -attr @rip roll_fallback_q10_reg[31]_0[23] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[23] -pin u_vector rw_reg_i_3_0[23]
load net pitch_fallback_q10_next[12] -attr @rip horizonte_sync_reg[0][12] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[12] -pin u_vector horizonte_sync_reg[0][12]
load net u_dados_n_287 -pin u_dados VGA_R_OBUF[3]_inst_i_2545_0 -pin u_vga VGA_R_OBUF[3]_inst_i_1072_1
netloc u_dados_n_287 1 3 1 9840 580n
load net u_alertas/rc212_in -attr @rip roll_reg[31]_2[0] -pin g_operacao.u_operacao rc_reg[0] -pin u_vector roll_reg[31]_2[0]
netloc u_alertas/rc212_in 1 0 3 320 5720 1690J 5700 2540
load net u_dados_n_213 -pin u_dados v_cont_reg[5]_rep__0 -pin u_vga VGA_R_OBUF[3]_inst_i_2769_0
netloc u_dados_n_213 1 3 1 8740 3620n
load net u_dados_n_129 -pin u_dados heading_deg_reg[7]_5 -pin u_vga VGA_R_OBUF[3]_inst_i_1687
netloc u_dados_n_129 1 3 1 10140 2820n
load net u_dados_n_345 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_1 -pin u_vga VGA_R_OBUF[3]_inst_i_1611_0
netloc u_dados_n_345 1 3 1 7780 660n
load net u_dados_n_96 -attr @rip heading_deg_reg[0]_7[2] -pin u_dados heading_deg_reg[0]_7[2] -pin u_vga VGA_R_OBUF[3]_inst_i_4628_0[2]
load net u_vga_n_207 -pin u_dados VGA_R_OBUF[3]_inst_i_1608_0 -pin u_vga VGA_R_OBUF[3]_inst_i_2797
netloc u_vga_n_207 1 2 3 5840 5680 8640J 1500 14160
load net u_vga_n_266 -attr @rip h_cont_reg[2]_rep__0_1[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1109[3] -pin u_vga h_cont_reg[2]_rep__0_1[3]
load net u_ui_test_n_188 -attr @rip last_data_reg[69][0] -pin g_native_video.u_native wr_data2_carry__5[0] -pin u_ui_test last_data_reg[69][0]
load net u_vga_n_111 -attr @rip h_cont_reg[1]_rep__1_4[2] -pin u_dados VGA_R_OBUF[3]_inst_i_76[2] -pin u_vga h_cont_reg[1]_rep__1_4[2]
load net amostra_completa[84] -attr @rip Q[44] -pin u_dados Q[44] -pin u_entrada Q[44]
load net altitude_ft[7] -attr @rip altitude_ft_reg[16]_0[7] -pin u_dados altitude_ft_reg[16]_0[7] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[7]
load net u_vga_n_65 -attr @rip h_cont_reg[1]_rep__0_5[3] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_1[3] -pin u_vga h_cont_reg[1]_rep__0_5[3]
load net compass_gravity_x[10] -attr @rip gravity_x_reg[23]_0[10] -pin g_mag_tilt.u_heading gx_reg[23]_0[10] -pin u_vector gravity_x_reg[23]_0[10]
load net dados_operacao[38] -attr @rip D[17] -pin g_operacao.u_operacao D[17] -pin u_entrada retido_reg[121]_0[56]
load net hud_metadados[15] -attr @rip metadados_reg[15]_0[11] -pin u_dados metadados_reg[15]_0[11] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[11]
load net mpu_accel_z[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[50] -pin u_sensor accel_x_reg[15]_0[50] -pin u_vector a_reg[0][15]_0[50]
load net mpu_raw_gx[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[34] -pin u_sensor accel_x_reg[15]_0[34] -pin u_vector a_reg[0][15]_0[34]
load net metadados_operacao[11] -attr @rip D[46] -pin g_operacao.u_operacao D[46] -pin u_entrada retido_reg[121]_0[85]
load net memory_and_vga/bridge/last_data[111] -attr @rip last_data_reg[125][111] -pin g_native_video.u_native last_data_reg[125][111] -pin u_ui_test wr_data2_carry__9[111]
load net memory_and_vga/bridge/last_data[47] -attr @rip last_data_reg[125][47] -pin g_native_video.u_native last_data_reg[125][47] -pin u_ui_test wr_data2_carry__9[47]
load net native_app_wdf_data[81] -attr @rip dout[81] -pin g_native_video.u_native dout[81] -pin u_ui_test dout[81]
load net native_app_wdf_data[17] -attr @rip dout[17] -pin g_native_video.u_native dout[17] -pin u_ui_test dout[17]
load net native_app_rd_data[17] -attr @rip din[17] -pin g_native_video.u_native din[17] -pin u_ui_test din[17]
load net native_app_rd_data[81] -attr @rip din[81] -pin g_native_video.u_native din[81] -pin u_ui_test din[81]
load net roll_fallback_q10[24] -attr @rip roll_fallback_q10_reg[31]_0[24] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[24] -pin u_vector rw_reg_i_3_0[24]
load net pitch_fallback_q10_next[13] -attr @rip horizonte_sync_reg[0][13] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[13] -pin u_vector horizonte_sync_reg[0][13]
load net u_dados_n_93 -attr @rip VGA_R_OBUF[3]_inst_i_4664_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_4664_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4103[0]
load net u_dados_n_126 -attr @rip heading_deg_reg[0]_14[0] -pin u_dados heading_deg_reg[0]_14[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4479_1[0]
load net u_dados_n_342 -pin u_dados heading_deg_reg[3]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1122_0
netloc u_dados_n_342 1 3 1 8000 2660n
load net u_dados_n_210 -pin u_dados v_cont_reg[7]_rep -pin u_vga VGA_R_OBUF[3]_inst_i_2769_1
netloc u_dados_n_210 1 3 1 8580 3660n
load net u_dados_n_284 -pin u_dados velocidade_kt_reg[9]_3 -pin u_vga VGA_R_OBUF[3]_inst_i_1907
netloc u_dados_n_284 1 3 1 8440 4080n
load net memory_and_vga/vga/pixel_word1__3 -pin g_native_video.u_native pixel_word1__3 -pin u_vga pixel_word1__3
netloc memory_and_vga/vga/pixel_word1__3 1 4 1 15920 2420n
load net u_vga_n_109 -attr @rip h_cont_reg[2]_rep_3[0] -pin u_dados VGA_G_OBUF[3]_inst_i_101[0] -pin u_vga h_cont_reg[2]_rep_3[0]
netloc u_vga_n_109 1 2 3 3880 4520 9180J 700 13840
load net u_ui_test_n_185 -attr @rip last_data_reg[69][3] -pin g_native_video.u_native wr_data2_carry__5[3] -pin u_ui_test last_data_reg[69][3]
load net amostra_completa[81] -attr @rip Q[41] -pin u_dados Q[41] -pin u_entrada Q[41]
load net u_vga_n_62 -attr @rip h_cont_reg[7]_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_2[1] -pin u_vga h_cont_reg[7]_1[1]
load net u_vga_n_263 -attr @rip h_cont_reg[2]_rep__1_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_394_1[1] -pin u_vga h_cont_reg[2]_rep__1_0[1]
load net u_vga_n_204 -pin u_dados VGA_R_OBUF[3]_inst_i_4007 -pin u_vga h_cont_reg[9]_9
netloc u_vga_n_204 1 2 3 4760 8640 NJ 8640 14960
load net altitude_ft[5] -attr @rip altitude_ft_reg[16]_0[5] -pin u_dados altitude_ft_reg[16]_0[5] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[5]
load net compass_gravity_z[23] -attr @rip Q[23] -pin g_mag_tilt.u_heading gz_reg[24]_0[23] -pin u_vector Q[23]
load net compass_gravity_x[9] -attr @rip gravity_x_reg[23]_0[9] -pin g_mag_tilt.u_heading gx_reg[23]_0[9] -pin u_vector gravity_x_reg[23]_0[9]
load net dados_operacao[35] -attr @rip D[14] -pin g_operacao.u_operacao D[14] -pin u_entrada retido_reg[121]_0[53]
load net hud_metadados[9] -attr @rip metadados_reg[15]_0[8] -pin u_dados metadados_reg[15]_0[8] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[8]
load net g_native_video.pixel_reset_pipe[1] -attr @style dashed -attr @rip 0 -pin g_native_video.u_native out[0] -pin u_vga g_native_video.video_visible_reg_1[0]
netloc g_native_video.pixel_reset_pipe[1] 1 3 2 12240 1280 15840J
load net memory_and_vga/bridge/last_data[108] -attr @rip last_data_reg[125][108] -pin g_native_video.u_native last_data_reg[125][108] -pin u_ui_test wr_data2_carry__9[108]
load net native_app_rd_data[14] -attr @rip din[14] -pin g_native_video.u_native din[14] -pin u_ui_test din[14]
load net memory_and_vga/bridge/last_data[44] -attr @rip last_data_reg[125][44] -pin g_native_video.u_native last_data_reg[125][44] -pin u_ui_test wr_data2_carry__9[44]
load net mpu_raw_ay[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[79] -pin u_sensor accel_x_reg[15]_0[79] -pin u_vector a_reg[0][15]_0[79]
load net native_app_rd_data[78] -attr @rip din[78] -pin g_native_video.u_native din[78] -pin u_ui_test din[78]
load net native_app_wdf_data[78] -attr @rip dout[78] -pin g_native_video.u_native dout[78] -pin u_ui_test dout[78]
load net native_app_wdf_data[14] -attr @rip dout[14] -pin g_native_video.u_native dout[14] -pin u_ui_test dout[14]
load net pitch_fallback_q10_next[10] -attr @rip horizonte_sync_reg[0][10] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[10] -pin u_vector horizonte_sync_reg[0][10]
load net roll_fallback_q10[21] -attr @rip roll_fallback_q10_reg[31]_0[21] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[21] -pin u_vector rw_reg_i_3_0[21]
load net u_dados_n_343 -pin u_dados VGA_R_OBUF[3]_inst_i_2129 -pin u_vga VGA_R_OBUF[3]_inst_i_1140_1
netloc u_dados_n_343 1 3 1 9380 520n
load net u_dados_n_94 -attr @rip VGA_R_OBUF[3]_inst_i_4691_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4691_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4140[1]
load net u_dados_n_285 -pin u_dados velocidade_kt_reg[9]_4 -pin u_vga VGA_R_OBUF[3]_inst_i_1907_0
netloc u_dados_n_285 1 3 1 8360 4100n
load net u_dados_n_127 -attr @rip heading_deg_reg[8]_1[0] -pin u_dados heading_deg_reg[8]_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4479_0[0]
netloc u_dados_n_127 1 3 1 7720 3060n
load net u_dados_n_211 -pin u_dados v_cont_reg[7]_rep_0 -pin u_vga VGA_R_OBUF[3]_inst_i_2769_4
netloc u_dados_n_211 1 3 1 8460 3680n
load net memory_and_vga/vga/prefetch_line -pin g_native_video.u_native prefetch_line -pin u_vga prefetch_line
netloc memory_and_vga/vga/prefetch_line 1 4 1 15960 2440n
load net u_vga_n_63 -attr @rip h_cont_reg[7]_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_2[0] -pin u_vga h_cont_reg[7]_1[0]
load net u_ui_test_n_186 -attr @rip last_data_reg[69][2] -pin g_native_video.u_native wr_data2_carry__5[2] -pin u_ui_test last_data_reg[69][2]
load net amostra_completa[82] -attr @rip Q[42] -pin u_dados Q[42] -pin u_entrada Q[42]
load net u_vga_n_205 -pin u_dados VGA_R_OBUF[3]_inst_i_3446_1 -pin u_vga h_cont_reg[6]_2
netloc u_vga_n_205 1 2 3 5000 8280 NJ 8280 15360
load net u_vga_n_11 -pin u_dados VGA_R_OBUF[3]_inst_i_3546 -pin u_vga h_cont_reg[2]_rep__2_0
netloc u_vga_n_11 1 2 3 5260 6280 7700J 2100 14320
load net u_vga_n_264 -attr @rip h_cont_reg[2]_rep__1_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_394_1[0] -pin u_vga h_cont_reg[2]_rep__1_0[0]
load net altitude_ft[6] -attr @rip altitude_ft_reg[16]_0[6] -pin u_dados altitude_ft_reg[16]_0[6] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[6]
load net compass_gravity_x[7] -attr @rip gravity_x_reg[23]_0[7] -pin g_mag_tilt.u_heading gx_reg[23]_0[7] -pin u_vector gravity_x_reg[23]_0[7]
load net dados_operacao[36] -attr @rip D[15] -pin g_operacao.u_operacao D[15] -pin u_entrada retido_reg[121]_0[54]
load net hud_metadados[8] -attr @rip metadados_reg[15]_0[7] -pin u_dados metadados_reg[15]_0[7] -pin u_vga VGA_R_OBUF[3]_inst_i_41_0[7]
load net metadados_operacao[9] -attr @rip D[44] -pin g_operacao.u_operacao D[44] -pin u_entrada retido_reg[121]_0[83]
load net mpu_raw_gx[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[32] -pin u_sensor accel_x_reg[15]_0[32] -pin u_vector a_reg[0][15]_0[32]
load net memory_and_vga/bridge/last_data[109] -attr @rip last_data_reg[125][109] -pin g_native_video.u_native last_data_reg[125][109] -pin u_ui_test wr_data2_carry__9[109]
load net memory_and_vga/bridge/last_data[45] -attr @rip last_data_reg[125][45] -pin g_native_video.u_native last_data_reg[125][45] -pin u_ui_test wr_data2_carry__9[45]
load net native_app_rd_data[15] -attr @rip din[15] -pin g_native_video.u_native din[15] -pin u_ui_test din[15]
load net native_app_rd_data[79] -attr @rip din[79] -pin g_native_video.u_native din[79] -pin u_ui_test din[79]
load net native_app_wdf_data[79] -attr @rip dout[79] -pin g_native_video.u_native dout[79] -pin u_ui_test dout[79]
load net native_app_wdf_data[15] -attr @rip dout[15] -pin g_native_video.u_native dout[15] -pin u_ui_test dout[15]
load net pitch_fallback_q10_next[11] -attr @rip horizonte_sync_reg[0][11] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[11] -pin u_vector horizonte_sync_reg[0][11]
load net roll_fallback_q10[22] -attr @rip roll_fallback_q10_reg[31]_0[22] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[22] -pin u_vector rw_reg_i_3_0[22]
load net u_alertas/rw3 -attr @rip roll_reg[31]_3[0] -pin g_operacao.u_operacao rw_reg[0] -pin u_vector roll_reg[31]_3[0]
netloc u_alertas/rw3 1 0 3 520 5780 1750J 5760 2500
load net mira_lock_in -attr @rip Q[19] -pin u_dados Q[19] -pin u_entrada Q[19]
load net u_dados_n_29 -attr @rip h_cont_reg[5]_rep_1[0] -pin u_dados h_cont_reg[5]_rep_1[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2271[0]
load net u_dados_n_36 -attr @rip h_cont_reg[9][0] -pin u_dados h_cont_reg[9][0] -pin u_vga VGA_R_OBUF[3]_inst_i_2888[0]
load net u_dados_n_99 -attr @rip heading_deg_reg[0]_8[3] -pin u_dados heading_deg_reg[0]_8[3] -pin u_vga VGA_R_OBUF[3]_inst_i_4401_1[3]
load net u_vga_n_68 -attr @rip h_cont_reg[1]_rep__0_5[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_1[0] -pin u_vga h_cont_reg[1]_rep__0_5[0]
load net u_vga_n_269 -attr @rip h_cont_reg[2]_rep__0_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1109[0] -pin u_vga h_cont_reg[2]_rep__0_1[0]
load net amostra_completa[87] -attr @rip Q[47] -pin u_dados Q[47] -pin u_entrada Q[47]
load net u_vga_n_210 -pin u_dados VGA_R_OBUF[3]_inst_i_3957 -pin u_vga VGA_R_OBUF[3]_inst_i_2123_0
netloc u_vga_n_210 1 2 3 5860 5660 9200J 1480 13720
load net u_vga_n_114 -attr @rip h_cont_reg[2]_rep_4[2] -pin u_dados VGA_R_OBUF[3]_inst_i_77[2] -pin u_vga h_cont_reg[2]_rep_4[2]
load net u_ui_test_n_191 -attr @rip last_data_reg[81][1] -pin g_native_video.u_native wr_data2_carry__6[1] -pin u_ui_test last_data_reg[81][1]
load net altitude_ft[11] -attr @rip altitude_ft_reg[16]_0[11] -pin u_dados altitude_ft_reg[16]_0[11] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[11]
load net compass_gravity_x[13] -attr @rip gravity_x_reg[23]_0[13] -pin g_mag_tilt.u_heading gx_reg[23]_0[13] -pin u_vector gravity_x_reg[23]_0[13]
load net dados_operacao[41] -attr @rip D[20] -pin g_operacao.u_operacao D[20] -pin u_entrada retido_reg[121]_0[59]
load net mpu_accel_z[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[53] -pin u_sensor accel_x_reg[15]_0[53] -pin u_vector a_reg[0][15]_0[53]
load net mpu_raw_gx[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[37] -pin u_sensor accel_x_reg[15]_0[37] -pin u_vector a_reg[0][15]_0[37]
load net metadados_operacao[15] -attr @rip D[50] -pin g_operacao.u_operacao D[50] -pin u_entrada retido_reg[121]_0[89]
load net memory_and_vga/bridge/last_data[114] -attr @rip last_data_reg[125][114] -pin g_native_video.u_native last_data_reg[125][114] -pin u_ui_test wr_data2_carry__9[114]
load net memory_and_vga/bridge/last_data[50] -attr @rip last_data_reg[125][50] -pin g_native_video.u_native last_data_reg[125][50] -pin u_ui_test wr_data2_carry__9[50]
load net native_app_wdf_data[84] -attr @rip dout[84] -pin g_native_video.u_native dout[84] -pin u_ui_test dout[84]
load net native_app_wdf_data[20] -attr @rip dout[20] -pin g_native_video.u_native dout[20] -pin u_ui_test dout[20]
load net native_app_rd_data[20] -attr @rip din[20] -pin g_native_video.u_native din[20] -pin u_ui_test din[20]
load net native_app_rd_data[84] -attr @rip din[84] -pin g_native_video.u_native din[84] -pin u_ui_test din[84]
load net pitch_fallback_q10_next[16] -attr @rip horizonte_sync_reg[0][16] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[16] -pin u_vector horizonte_sync_reg[0][16]
load net roll_fallback_q10[27] -attr @rip roll_fallback_q10_reg[31]_0[27] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[27] -pin u_vector rw_reg_i_3_0[27]
load net u_entrada_n_1 -attr @rip D[1] -pin u_dados D[1] -pin u_entrada D[1]
load net u_dados_n_37 -attr @rip VGA_R_OBUF[3]_inst_i_4029_0[1] -pin u_dados VGA_R_OBUF[3]_inst_i_4029_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4192[1]
load net u_dados_n_290 -pin u_dados velocidade_kt_reg[9]_6 -pin u_vga VGA_R_OBUF[3]_inst_i_1450_2
netloc u_dados_n_290 1 3 1 9780 4140n
load net g_native_video.ui_reset -attr @rip SR[0] -pin g_native_video.u_native SR[0] -pin u_ui_test SR[0]
netloc g_native_video.ui_reset 1 4 3 16200 120 NJ 120 18020
load net u_vga_n_211 -pin u_dados VGA_R_OBUF[3]_inst_i_1605_0 -pin u_vga altitude_ft_reg[1]
netloc u_vga_n_211 1 2 3 5740 5760 8160J 1580 14600
load net u_vga_n_27 -attr @rip h_cont_reg[3]_rep__1_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_1182_0[0] -pin u_vga h_cont_reg[3]_rep__1_1[0]
load net u_ui_test_n_192 -attr @rip last_data_reg[81][0] -pin g_native_video.u_native wr_data2_carry__6[0] -pin u_ui_test last_data_reg[81][0]
load net u_vga_n_115 -attr @rip h_cont_reg[2]_rep_4[1] -pin u_dados VGA_R_OBUF[3]_inst_i_77[1] -pin u_vga h_cont_reg[2]_rep_4[1]
load net amostra_completa[88] -attr @rip Q[48] -pin u_dados Q[48] -pin u_entrada Q[48]
load net altitude_ft[12] -attr @rip altitude_ft_reg[16]_0[12] -pin u_dados altitude_ft_reg[16]_0[12] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[12]
load net u_vga_n_69 -attr @rip h_cont_reg[3]_rep__1_3[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1679_0[2] -pin u_vga h_cont_reg[3]_rep__1_3[2]
load net compass_gravity_x[14] -attr @rip gravity_x_reg[23]_0[14] -pin g_mag_tilt.u_heading gx_reg[23]_0[14] -pin u_vector gravity_x_reg[23]_0[14]
load net dados_operacao[42] -attr @rip D[21] -pin g_operacao.u_operacao D[21] -pin u_entrada retido_reg[121]_0[60]
load net mpu_accel_z[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[54] -pin u_sensor accel_x_reg[15]_0[54] -pin u_vector a_reg[0][15]_0[54]
load net mpu_raw_gx[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[38] -pin u_sensor accel_x_reg[15]_0[38] -pin u_vector a_reg[0][15]_0[38]
load net metadados_operacao[25] -attr @rip D[51] -pin g_operacao.u_operacao D[51] -pin u_entrada retido_reg[121]_0[90]
load net memory_and_vga/bridge/last_data[115] -attr @rip last_data_reg[125][115] -pin g_native_video.u_native last_data_reg[125][115] -pin u_ui_test wr_data2_carry__9[115]
load net memory_and_vga/bridge/last_data[51] -attr @rip last_data_reg[125][51] -pin g_native_video.u_native last_data_reg[125][51] -pin u_ui_test wr_data2_carry__9[51]
load net native_app_wdf_data[85] -attr @rip dout[85] -pin g_native_video.u_native dout[85] -pin u_ui_test dout[85]
load net native_app_wdf_data[21] -attr @rip dout[21] -pin g_native_video.u_native dout[21] -pin u_ui_test dout[21]
load net native_app_rd_data[85] -attr @rip din[85] -pin g_native_video.u_native din[85] -pin u_ui_test din[85]
load net native_app_rd_data[21] -attr @rip din[21] -pin g_native_video.u_native din[21] -pin u_ui_test din[21]
load net samples_reg[0][0] -attr @rip B[8] -pin u_sensor B[8] -pin u_vector B[8]
load net pitch_fallback_q10_next[17] -attr @rip horizonte_sync_reg[0][17] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[17] -pin u_vector horizonte_sync_reg[0][17]
load net roll_fallback_q10[31] -attr @rip roll_fallback_q10_reg[31]_0[28] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[28] -pin u_vector rw_reg_i_3_0[28]
load net u_dados_n_288 -pin u_dados VGA_R_OBUF[3]_inst_i_1451 -pin u_vga VGA_R_OBUF[3]_inst_i_770_0
netloc u_dados_n_288 1 3 1 11980 220n
load net u_alertas/rc329_in -attr @rip roll_reg[31]_1[0] -pin g_operacao.u_operacao rc_reg_0[0] -pin u_vector roll_reg[31]_1[0]
netloc u_alertas/rc329_in 1 0 3 440 5740 1710J 5720 2560
load net u_dados_n_346 -pin u_dados VGA_R_OBUF[3]_inst_i_2783_2 -pin u_vga VGA_R_OBUF[3]_inst_i_1141_1
netloc u_dados_n_346 1 3 1 9100 680n
load net u_dados_n_22 -attr @rip h_cont_reg[5]_rep_0[1] -pin u_dados h_cont_reg[5]_rep_0[1] -pin u_vga VGA_R_OBUF[3]_inst_i_2268[1]
load net u_dados_n_97 -attr @rip heading_deg_reg[0]_7[1] -pin u_dados heading_deg_reg[0]_7[1] -pin u_vga VGA_R_OBUF[3]_inst_i_4628_0[1]
load net u_dados_n_130 -pin u_dados heading_deg_reg[7]_6 -pin u_vga VGA_R_OBUF[3]_inst_i_1691
netloc u_dados_n_130 1 3 1 10080 2840n
load net u_vga_n_267 -attr @rip h_cont_reg[2]_rep__0_1[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1109[2] -pin u_vga h_cont_reg[2]_rep__0_1[2]
load net u_ui_test_n_189 -attr @rip last_data_reg[81][3] -pin g_native_video.u_native wr_data2_carry__6[3] -pin u_ui_test last_data_reg[81][3]
load net amostra_completa[85] -attr @rip Q[45] -pin u_dados Q[45] -pin u_entrada Q[45]
load net altitude_ft[8] -attr @rip altitude_ft_reg[16]_0[8] -pin u_dados altitude_ft_reg[16]_0[8] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[8]
load net u_vga_n_66 -attr @rip h_cont_reg[1]_rep__0_5[2] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_1[2] -pin u_vga h_cont_reg[1]_rep__0_5[2]
load net u_vga_n_208 -pin u_dados VGA_R_OBUF[3]_inst_i_2139_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3359_0
netloc u_vga_n_208 1 2 3 5820 5700 8700J 1520 14080
load net u_vga_n_112 -attr @rip h_cont_reg[1]_rep__1_4[1] -pin u_dados VGA_R_OBUF[3]_inst_i_76[1] -pin u_vga h_cont_reg[1]_rep__1_4[1]
load net compass_gravity_x[11] -attr @rip gravity_x_reg[23]_0[11] -pin g_mag_tilt.u_heading gx_reg[23]_0[11] -pin u_vector gravity_x_reg[23]_0[11]
load net dados_operacao[39] -attr @rip D[18] -pin g_operacao.u_operacao D[18] -pin u_entrada retido_reg[121]_0[57]
load net mpu_accel_z[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[51] -pin u_sensor accel_x_reg[15]_0[51] -pin u_vector a_reg[0][15]_0[51]
load net mpu_raw_gx[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[35] -pin u_sensor accel_x_reg[15]_0[35] -pin u_vector a_reg[0][15]_0[35]
load net metadados_operacao[12] -attr @rip D[47] -pin g_operacao.u_operacao D[47] -pin u_entrada retido_reg[121]_0[86]
load net memory_and_vga/bridge/last_data[112] -attr @rip last_data_reg[125][112] -pin g_native_video.u_native last_data_reg[125][112] -pin u_ui_test wr_data2_carry__9[112]
load net memory_and_vga/bridge/last_data[48] -attr @rip last_data_reg[125][48] -pin g_native_video.u_native last_data_reg[125][48] -pin u_ui_test wr_data2_carry__9[48]
load net native_app_wdf_data[82] -attr @rip dout[82] -pin g_native_video.u_native dout[82] -pin u_ui_test dout[82]
load net native_app_wdf_data[18] -attr @rip dout[18] -pin g_native_video.u_native dout[18] -pin u_ui_test dout[18]
load net native_app_rd_data[18] -attr @rip din[18] -pin g_native_video.u_native din[18] -pin u_ui_test din[18]
load net native_app_rd_data[82] -attr @rip din[82] -pin g_native_video.u_native din[82] -pin u_ui_test din[82]
load net pitch_fallback_q10_next[14] -attr @rip horizonte_sync_reg[0][14] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[14] -pin u_vector horizonte_sync_reg[0][14]
load net roll_fallback_q10[25] -attr @rip roll_fallback_q10_reg[31]_0[25] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[25] -pin u_vector rw_reg_i_3_0[25]
load net u_alertas/rw211_in -attr @rip roll_reg[31]_4[0] -pin g_operacao.u_operacao CO[0] -pin u_vector roll_reg[31]_4[0]
netloc u_alertas/rw211_in 1 0 3 120 6340 NJ 6340 2440
load net mira_lock -pin u_dados mira_lock -pin u_vga mira_lock
netloc mira_lock 1 3 1 7640 3460n
load net u_dados_n_23 -attr @rip h_cont_reg[5]_rep_0[0] -pin u_dados h_cont_reg[5]_rep_0[0] -pin u_vga VGA_R_OBUF[3]_inst_i_2268[0]
load net u_dados_n_35 -attr @rip h_cont_reg[9][1] -pin u_dados h_cont_reg[9][1] -pin u_vga VGA_R_OBUF[3]_inst_i_2888[1]
load net u_dados_n_289 -pin u_dados velocidade_kt_reg[9]_5 -pin u_vga VGA_R_OBUF[3]_inst_i_1453_0
netloc u_dados_n_289 1 3 1 8840 4120n
load net u_dados_n_98 -attr @rip heading_deg_reg[0]_7[0] -pin u_dados heading_deg_reg[0]_7[0] -pin u_vga VGA_R_OBUF[3]_inst_i_4628_0[0]
load net u_vga_n_67 -attr @rip h_cont_reg[1]_rep__0_5[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1174_1[1] -pin u_vga h_cont_reg[1]_rep__0_5[1]
load net u_vga_n_268 -attr @rip h_cont_reg[2]_rep__0_1[1] -pin u_dados VGA_R_OBUF[3]_inst_i_1109[1] -pin u_vga h_cont_reg[2]_rep__0_1[1]
load net amostra_completa[86] -attr @rip Q[46] -pin u_dados Q[46] -pin u_entrada Q[46]
load net u_vga_n_209 -pin u_dados VGA_R_OBUF[3]_inst_i_2146_0 -pin u_vga VGA_R_OBUF[3]_inst_i_3383_0
netloc u_vga_n_209 1 2 3 5780 5740 8080J 1560 13740
load net u_vga_n_113 -attr @rip h_cont_reg[1]_rep__1_4[0] -pin u_dados VGA_R_OBUF[3]_inst_i_76[0] -pin u_vga h_cont_reg[1]_rep__1_4[0]
load net u_ui_test_n_190 -attr @rip last_data_reg[81][2] -pin g_native_video.u_native wr_data2_carry__6[2] -pin u_ui_test last_data_reg[81][2]
load net altitude_ft[10] -attr @rip altitude_ft_reg[16]_0[10] -pin u_dados altitude_ft_reg[16]_0[10] -pin u_vga VGA_R_OBUF[3]_inst_i_2873_0[10]
load net compass_gravity_x[12] -attr @rip gravity_x_reg[23]_0[12] -pin g_mag_tilt.u_heading gx_reg[23]_0[12] -pin u_vector gravity_x_reg[23]_0[12]
load net dados_operacao[40] -attr @rip D[19] -pin g_operacao.u_operacao D[19] -pin u_entrada retido_reg[121]_0[58]
load net mpu_accel_z[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[52] -pin u_sensor accel_x_reg[15]_0[52] -pin u_vector a_reg[0][15]_0[52]
load net mpu_raw_gx[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[36] -pin u_sensor accel_x_reg[15]_0[36] -pin u_vector a_reg[0][15]_0[36]
load net metadados_operacao[13] -attr @rip D[48] -pin g_operacao.u_operacao D[48] -pin u_entrada retido_reg[121]_0[87]
load net memory_and_vga/bridge/last_data[113] -attr @rip last_data_reg[125][113] -pin g_native_video.u_native last_data_reg[125][113] -pin u_ui_test wr_data2_carry__9[113]
load net memory_and_vga/bridge/last_data[49] -attr @rip last_data_reg[125][49] -pin g_native_video.u_native last_data_reg[125][49] -pin u_ui_test wr_data2_carry__9[49]
load net native_app_wdf_data[83] -attr @rip dout[83] -pin g_native_video.u_native dout[83] -pin u_ui_test dout[83]
load net native_app_wdf_data[19] -attr @rip dout[19] -pin g_native_video.u_native dout[19] -pin u_ui_test dout[19]
load net native_app_rd_data[19] -attr @rip din[19] -pin g_native_video.u_native din[19] -pin u_ui_test din[19]
load net native_app_rd_data[83] -attr @rip din[83] -pin g_native_video.u_native din[83] -pin u_ui_test din[83]
load net roll_fallback_q10[26] -attr @rip roll_fallback_q10_reg[31]_0[26] -pin g_operacao.u_operacao roll_fallback_q10_reg[31]_0[26] -pin u_vector rw_reg_i_3_0[26]
load net pitch_fallback_q10_next[15] -attr @rip horizonte_sync_reg[0][15] -pin g_operacao.u_operacao pitch_fallback_q10_reg[31]_2[15] -pin u_vector horizonte_sync_reg[0][15]
load netBundle @samples_reg 16 samples_reg[0][7] samples_reg[0][6] samples_reg[0][5] samples_reg[0][4] samples_reg[0][3] samples_reg[0][2] samples_reg[0][1] samples_reg[0][0] samples_reg[1][7] samples_reg[1][6] samples_reg[1][5] samples_reg[1][4] samples_reg[1][3] samples_reg[1][2] samples_reg[1][1] samples_reg[1][0] -autobundled
netbloc @samples_reg 1 1 1 1730 4120n
load netBundle @mpu_raw_ax,mpu_raw_ay 96 mpu_raw_ax[15] mpu_raw_ax[14] mpu_raw_ax[13] mpu_raw_ax[12] mpu_raw_ax[11] mpu_raw_ax[10] mpu_raw_ax[9] mpu_raw_ax[8] mpu_raw_ax[7] mpu_raw_ax[6] mpu_raw_ax[5] mpu_raw_ax[4] mpu_raw_ax[3] mpu_raw_ax[2] mpu_raw_ax[1] mpu_raw_ax[0] mpu_raw_ay[15] mpu_raw_ay[14] mpu_raw_ay[13] mpu_raw_ay[12] mpu_raw_ay[11] mpu_raw_ay[10] mpu_raw_ay[9] mpu_raw_ay[8] mpu_raw_ay[7] mpu_raw_ay[6] mpu_raw_ay[5] mpu_raw_ay[4] mpu_raw_ay[3] mpu_raw_ay[2] mpu_raw_ay[1] mpu_raw_ay[0] mpu_accel_z[15] mpu_accel_z[14] mpu_accel_z[13] mpu_accel_z[12] mpu_accel_z[11] mpu_accel_z[10] mpu_accel_z[9] mpu_accel_z[8] mpu_accel_z[7] mpu_accel_z[6] mpu_accel_z[5] mpu_accel_z[4] mpu_accel_z[3] mpu_accel_z[2] mpu_accel_z[1] mpu_accel_z[0] mpu_raw_gx[15] mpu_raw_gx[14] mpu_raw_gx[13] mpu_raw_gx[12] mpu_raw_gx[11] mpu_raw_gx[10] mpu_raw_gx[9] mpu_raw_gx[8] mpu_raw_gx[7] mpu_raw_gx[6] mpu_raw_gx[5] mpu_raw_gx[4] mpu_raw_gx[3] mpu_raw_gx[2] mpu_raw_gx[1] mpu_raw_gx[0] mpu_raw_gy[15] mpu_raw_gy[14] mpu_raw_gy[13] mpu_raw_gy[12] mpu_raw_gy[11] mpu_raw_gy[10] mpu_raw_gy[9] mpu_raw_gy[8] mpu_raw_gy[7] mpu_raw_gy[6] mpu_raw_gy[5] mpu_raw_gy[4] mpu_raw_gy[3] mpu_raw_gy[2] mpu_raw_gy[1] mpu_raw_gy[0] mpu_gyro_z[15] mpu_gyro_z[14] mpu_gyro_z[13] mpu_gyro_z[12] mpu_gyro_z[11] mpu_gyro_z[10] mpu_gyro_z[9] mpu_gyro_z[8] mpu_gyro_z[7] mpu_gyro_z[6] mpu_gyro_z[5] mpu_gyro_z[4] mpu_gyro_z[3] mpu_gyro_z[2] mpu_gyro_z[1] mpu_gyro_z[0] -autobundled -attr @style dashed
netbloc @mpu_raw_ax,mpu_raw_ay 1 1 1 1650 4220n
load netBundle @samples_reg_1 16 samples_reg[2][7] samples_reg[2][6] samples_reg[2][5] samples_reg[2][4] samples_reg[2][3] samples_reg[2][2] samples_reg[2][1] samples_reg[2][0] samples_reg[3][7] samples_reg[3][6] samples_reg[3][5] samples_reg[3][4] samples_reg[3][3] samples_reg[3][2] samples_reg[3][1] samples_reg[3][0] -autobundled
netbloc @samples_reg_1 1 1 1 1430 4400n
load netBundle @samples_reg_2 16 samples_reg[4][7] samples_reg[4][6] samples_reg[4][5] samples_reg[4][4] samples_reg[4][3] samples_reg[4][2] samples_reg[4][1] samples_reg[4][0] samples_reg[5][7] samples_reg[5][6] samples_reg[5][5] samples_reg[5][4] samples_reg[5][3] samples_reg[5][2] samples_reg[5][1] samples_reg[5][0] -autobundled
netbloc @samples_reg_2 1 1 1 1450 4420n
load netBundle @compass_gravity_z 24 compass_gravity_z[23] compass_gravity_z[22] compass_gravity_z[21] compass_gravity_z[20] compass_gravity_z[19] compass_gravity_z[18] compass_gravity_z[17] compass_gravity_z[16] compass_gravity_z[15] compass_gravity_z[14] compass_gravity_z[13] compass_gravity_z[12] compass_gravity_z[11] compass_gravity_z[10] compass_gravity_z[9] compass_gravity_z[8] compass_gravity_z[7] compass_gravity_z[6] compass_gravity_z[5] compass_gravity_z[4] compass_gravity_z[3] compass_gravity_z[2] compass_gravity_z[1] compass_gravity_z[0] -autobundled
netbloc @compass_gravity_z 1 2 1 3140 4220n
load netBundle @compass_gravity_x 24 compass_gravity_x[23] compass_gravity_x[22] compass_gravity_x[21] compass_gravity_x[20] compass_gravity_x[19] compass_gravity_x[18] compass_gravity_x[17] compass_gravity_x[16] compass_gravity_x[15] compass_gravity_x[14] compass_gravity_x[13] compass_gravity_x[12] compass_gravity_x[11] compass_gravity_x[10] compass_gravity_x[9] compass_gravity_x[8] compass_gravity_x[7] compass_gravity_x[6] compass_gravity_x[5] compass_gravity_x[4] compass_gravity_x[3] compass_gravity_x[2] compass_gravity_x[1] compass_gravity_x[0] -autobundled
netbloc @compass_gravity_x 1 2 1 3120 4360n
load netBundle @compass_gravity_y 24 compass_gravity_y[23] compass_gravity_y[22] compass_gravity_y[21] compass_gravity_y[20] compass_gravity_y[19] compass_gravity_y[18] compass_gravity_y[17] compass_gravity_y[16] compass_gravity_y[15] compass_gravity_y[14] compass_gravity_y[13] compass_gravity_y[12] compass_gravity_y[11] compass_gravity_y[10] compass_gravity_y[9] compass_gravity_y[8] compass_gravity_y[7] compass_gravity_y[6] compass_gravity_y[5] compass_gravity_y[4] compass_gravity_y[3] compass_gravity_y[2] compass_gravity_y[1] compass_gravity_y[0] -autobundled
netbloc @compass_gravity_y 1 2 1 3060 4380n
load netBundle @pitch_fallback_q10_next 27 pitch_fallback_q10_next[31] pitch_fallback_q10_next[25] pitch_fallback_q10_next[24] pitch_fallback_q10_next[23] pitch_fallback_q10_next[22] pitch_fallback_q10_next[21] pitch_fallback_q10_next[20] pitch_fallback_q10_next[19] pitch_fallback_q10_next[18] pitch_fallback_q10_next[17] pitch_fallback_q10_next[16] pitch_fallback_q10_next[15] pitch_fallback_q10_next[14] pitch_fallback_q10_next[13] pitch_fallback_q10_next[12] pitch_fallback_q10_next[11] pitch_fallback_q10_next[10] pitch_fallback_q10_next[9] pitch_fallback_q10_next[8] pitch_fallback_q10_next[7] pitch_fallback_q10_next[6] pitch_fallback_q10_next[5] pitch_fallback_q10_next[4] pitch_fallback_q10_next[3] pitch_fallback_q10_next[2] pitch_fallback_q10_next[1] pitch_fallback_q10_next[0] -autobundled
netbloc @pitch_fallback_q10_next 1 0 3 200 4040 NJ 4040 2660
load netBundle @u_alertas/ar0 5 u_alertas/ar0[13] u_alertas/ar0[12] u_alertas/ar0[11] u_alertas/ar0[10] u_alertas/ar0[1] -autobundled
netbloc @u_alertas/ar0 1 0 3 480 4540 1290J 4080 2700
load netBundle @vector_pitch,vector_roll 20 vector_roll[31] vector_roll[13] vector_roll[12] vector_roll[11] vector_roll[10] vector_roll[1] vector_roll[0] vector_pitch[31] vector_pitch[25] vector_pitch[24] vector_pitch[23] vector_pitch[21] vector_pitch[20] vector_pitch[19] vector_pitch[18] vector_pitch[17] vector_pitch[16] vector_pitch[15] vector_pitch[14] vector_pitch[10] -autobundled -attr @style dashed
netbloc @vector_pitch,vector_roll 1 0 3 420 5640 NJ 5640 2700
load netBundle @roll_fallback_q10_next 29 roll_fallback_q10_next[31] roll_fallback_q10_next[27] roll_fallback_q10_next[26] roll_fallback_q10_next[25] roll_fallback_q10_next[24] roll_fallback_q10_next[23] roll_fallback_q10_next[22] roll_fallback_q10_next[21] roll_fallback_q10_next[20] roll_fallback_q10_next[19] roll_fallback_q10_next[18] roll_fallback_q10_next[17] roll_fallback_q10_next[16] roll_fallback_q10_next[15] roll_fallback_q10_next[14] roll_fallback_q10_next[13] roll_fallback_q10_next[12] roll_fallback_q10_next[11] roll_fallback_q10_next[10] roll_fallback_q10_next[9] roll_fallback_q10_next[8] roll_fallback_q10_next[7] roll_fallback_q10_next[6] roll_fallback_q10_next[5] roll_fallback_q10_next[4] roll_fallback_q10_next[3] roll_fallback_q10_next[2] roll_fallback_q10_next[1] roll_fallback_q10_next[0] -autobundled
netbloc @roll_fallback_q10_next 1 0 3 480 5760 1730J 5740 2460
load netBundle @dados_operacao 52 metadados_operacao[25] metadados_operacao[15] buzzer_out_OBUF metadados_operacao[13] metadados_operacao[12] metadados_operacao[11] metadados_operacao[10] metadados_operacao[9] metadados_operacao[8] metadados_operacao[7] metadados_operacao[5] metadados_operacao[4] metadados_operacao[3] metadados_operacao[2] metadados_operacao[1] metadados_operacao[0] dados_operacao[56] dados_operacao[55] dados_operacao[54] dados_operacao[53] dados_operacao[52] dados_operacao[51] dados_operacao[50] dados_operacao[49] dados_operacao[48] dados_operacao[47] dados_operacao[46] dados_operacao[45] dados_operacao[44] dados_operacao[43] dados_operacao[42] dados_operacao[41] dados_operacao[40] dados_operacao[39] dados_operacao[38] dados_operacao[37] dados_operacao[36] dados_operacao[35] dados_operacao[34] dados_operacao[33] dados_operacao[32] dados_operacao[31] dados_operacao[30] dados_operacao[8] dados_operacao[7] dados_operacao[6] dados_operacao[5] dados_operacao[4] dados_operacao[3] dados_operacao[2] dados_operacao[1] dados_operacao[0] -autobundled -attr @style dashed
netbloc @dados_operacao 1 1 1 1110 4800n
load netBundle @pitch_fallback_q10 27 pitch_fallback_q10[31] pitch_fallback_q10[25] pitch_fallback_q10[24] pitch_fallback_q10[23] pitch_fallback_q10[22] pitch_fallback_q10[21] pitch_fallback_q10[20] pitch_fallback_q10[19] pitch_fallback_q10[18] pitch_fallback_q10[17] pitch_fallback_q10[16] pitch_fallback_q10[15] pitch_fallback_q10[14] pitch_fallback_q10[13] pitch_fallback_q10[12] pitch_fallback_q10[11] pitch_fallback_q10[10] pitch_fallback_q10[9] pitch_fallback_q10[8] pitch_fallback_q10[7] pitch_fallback_q10[6] pitch_fallback_q10[5] pitch_fallback_q10[4] pitch_fallback_q10[3] pitch_fallback_q10[2] pitch_fallback_q10[1] pitch_fallback_q10[0] -autobundled
netbloc @pitch_fallback_q10 1 1 1 1150 4900n
load netBundle @roll_fallback_q10 29 roll_fallback_q10[31] roll_fallback_q10[27] roll_fallback_q10[26] roll_fallback_q10[25] roll_fallback_q10[24] roll_fallback_q10[23] roll_fallback_q10[22] roll_fallback_q10[21] roll_fallback_q10[20] roll_fallback_q10[19] roll_fallback_q10[18] roll_fallback_q10[17] roll_fallback_q10[16] roll_fallback_q10[15] roll_fallback_q10[14] roll_fallback_q10[13] roll_fallback_q10[12] roll_fallback_q10[11] roll_fallback_q10[10] roll_fallback_q10[9] roll_fallback_q10[8] roll_fallback_q10[7] roll_fallback_q10[6] roll_fallback_q10[5] roll_fallback_q10[4] roll_fallback_q10[3] roll_fallback_q10[2] roll_fallback_q10[1] roll_fallback_q10[0] -autobundled
netbloc @roll_fallback_q10 1 1 1 1390 5060n
load netBundle @g_operacao.u_operacao_n_ 2 g_operacao.u_operacao_n_98 g_operacao.u_operacao_n_99 -autobundled
netbloc @g_operacao.u_operacao_n_ 1 1 1 1590 5100n
load netBundle @u_entrada_n_ 2 u_entrada_n_1 u_entrada_n_2 -autobundled
netbloc @u_entrada_n_ 1 2 1 2820 520n
load netBundle @amostra_completa,metadados_in 72 metadados_in[25] metadados_in[15] metadados_in[14] metadados_in[13] metadados_in[12] metadados_in[11] metadados_in[10] metadados_in[9] metadados_in[8] metadados_in[7] metadados_in[5] metadados_in[4] metadados_in[3] metadados_in[2] metadados_in[1] metadados_in[0] amostra_completa[95] amostra_completa[94] amostra_completa[93] amostra_completa[92] amostra_completa[91] amostra_completa[90] amostra_completa[89] amostra_completa[88] amostra_completa[87] amostra_completa[86] amostra_completa[85] amostra_completa[84] amostra_completa[83] amostra_completa[82] amostra_completa[81] amostra_completa[80] amostra_completa[79] amostra_completa[78] amostra_completa[77] amostra_completa[76] amostra_completa[75] amostra_completa[74] amostra_completa[73] amostra_completa[72] amostra_completa[71] amostra_completa[70] amostra_completa[69] amostra_completa[47] amostra_completa[46] amostra_completa[45] amostra_completa[44] amostra_completa[43] amostra_completa[42] amostra_completa[41] amostra_completa[40] amostra_completa[39] mira_lock_in mira_y_in[8] mira_y_in[7] mira_y_in[6] mira_y_in[5] mira_y_in[4] mira_y_in[3] mira_y_in[2] mira_y_in[1] mira_y_in[0] mira_x_in[9] mira_x_in[8] mira_x_in[7] mira_x_in[6] mira_x_in[5] mira_x_in[4] mira_x_in[3] mira_x_in[2] mira_x_in[1] mira_x_in[0] -autobundled
netbloc @amostra_completa,metadados_in 1 2 1 2840 560n
load netBundle @u_entrada_n__1 2 u_entrada_n_93 u_entrada_n_94 -autobundled
netbloc @u_entrada_n__1 1 2 1 3380 3600n
load netBundle @u_dados_n_ 3 u_dados_n_18 u_dados_n_19 u_dados_n_20 -autobundled
netbloc @u_dados_n_ 1 3 1 12160 80n
load netBundle @u_dados_n__1 3 u_dados_n_5 u_dados_n_6 u_dados_n_7 -autobundled
netbloc @u_dados_n__1 1 3 1 12140 100n
load netBundle @u_dados_n__2 2 u_dados_n_265 u_dados_n_266 -autobundled
netbloc @u_dados_n__2 1 3 1 9320 800n
load netBundle @u_dados_n__3 3 u_dados_n_276 u_dados_n_277 u_dados_n_278 -autobundled
netbloc @u_dados_n__3 1 3 1 9280 840n
load netBundle @u_dados_n__4 2 u_dados_n_247 u_dados_n_248 -autobundled
netbloc @u_dados_n__4 1 3 1 7340 940n
load netBundle @u_dados_n__5 2 u_dados_n_259 u_dados_n_260 -autobundled
netbloc @u_dados_n__5 1 3 1 8120 980n
load netBundle @u_dados_n__6 3 u_dados_n_261 u_dados_n_262 u_dados_n_263 -autobundled
netbloc @u_dados_n__6 1 3 1 8900 1000n
load netBundle @u_dados_n__7 4 u_dados_n_267 u_dados_n_268 u_dados_n_269 u_dados_n_270 -autobundled
netbloc @u_dados_n__7 1 3 1 8660 1020n
load netBundle @u_dados_n__8 3 u_dados_n_271 u_dados_n_272 u_dados_n_273 -autobundled
netbloc @u_dados_n__8 1 3 1 8680 1040n
load netBundle @u_dados_n__9 4 u_dados_n_249 u_dados_n_250 u_dados_n_251 u_dados_n_252 -autobundled
netbloc @u_dados_n__9 1 3 1 10840 1080n
load netBundle @u_dados_n__10 3 u_dados_n_255 u_dados_n_256 u_dados_n_257 -autobundled
netbloc @u_dados_n__10 1 3 1 10980 1100n
load netBundle @u_dados_n__11 2 u_dados_n_37 u_dados_n_38 -autobundled
netbloc @u_dados_n__11 1 3 1 10660 1140n
load netBundle @u_dados_n__12 2 u_dados_n_47 u_dados_n_48 -autobundled
netbloc @u_dados_n__12 1 3 1 10480 1160n
load netBundle @u_dados_n__13 2 u_dados_n_53 u_dados_n_54 -autobundled
netbloc @u_dados_n__13 1 3 1 10220 1180n
load netBundle @u_dados_n__14 2 u_dados_n_64 u_dados_n_65 -autobundled
netbloc @u_dados_n__14 1 3 1 10200 1200n
load netBundle @u_dados_n__15 2 u_dados_n_88 u_dados_n_89 -autobundled
netbloc @u_dados_n__15 1 3 1 10640 1220n
load netBundle @u_dados_n__16 2 u_dados_n_90 u_dados_n_91 -autobundled
netbloc @u_dados_n__16 1 3 1 7440 1240n
load netBundle @u_dados_n__17 2 u_dados_n_92 u_dados_n_93 -autobundled
netbloc @u_dados_n__17 1 3 1 10620 1260n
load netBundle @u_dados_n__18 2 u_dados_n_94 u_dados_n_95 -autobundled
netbloc @u_dados_n__18 1 3 1 10560 1280n
load netBundle @altitude_ft 17 altitude_ft[16] altitude_ft[15] altitude_ft[14] altitude_ft[13] altitude_ft[12] altitude_ft[11] altitude_ft[10] altitude_ft[9] altitude_ft[8] altitude_ft[7] altitude_ft[6] altitude_ft[5] altitude_ft[4] altitude_ft[3] altitude_ft[2] altitude_ft[1] altitude_ft[0] -autobundled
netbloc @altitude_ft 1 3 1 10320 1660n
load netBundle @u_dados_n__19 3 u_dados_n_196 u_dados_n_197 u_dados_n_198 -autobundled
netbloc @u_dados_n__19 1 3 1 10360 1620n
load netBundle @u_dados_n__20 3 u_dados_n_15 u_dados_n_16 u_dados_n_17 -autobundled
netbloc @u_dados_n__20 1 3 1 9220 2040n
load netBundle @u_dados_n__21 3 u_dados_n_21 u_dados_n_22 u_dados_n_23 -autobundled
netbloc @u_dados_n__21 1 3 1 7520 2060n
load netBundle @u_dados_n__22 3 u_dados_n_27 u_dados_n_28 u_dados_n_29 -autobundled
netbloc @u_dados_n__22 1 3 1 10720 2080n
load netBundle @u_dados_n__23 4 u_dados_n_33 u_dados_n_34 u_dados_n_35 u_dados_n_36 -autobundled
netbloc @u_dados_n__23 1 3 1 9620 2140n
load netBundle @u_dados_n__24 4 u_dados_n_39 u_dados_n_40 u_dados_n_41 u_dados_n_42 -autobundled
netbloc @u_dados_n__24 1 3 1 7220 2160n
load netBundle @u_dados_n__25 4 u_dados_n_43 u_dados_n_44 u_dados_n_45 u_dados_n_46 -autobundled
netbloc @u_dados_n__25 1 3 1 7680 2180n
load netBundle @u_dados_n__26 4 u_dados_n_59 u_dados_n_60 u_dados_n_61 u_dados_n_62 -autobundled
netbloc @u_dados_n__26 1 3 1 7480 2200n
load netBundle @card_codigo3 7 card_codigo3[9] card_codigo3[8] card_codigo3[7] card_codigo3[6] card_codigo3[5] card_codigo3[4] card_codigo3[3] -autobundled
netbloc @card_codigo3 1 3 1 8400 2260n
load netBundle @u_dados_n__27 3 u_dados_n_24 u_dados_n_25 u_dados_n_26 -autobundled
netbloc @u_dados_n__27 1 3 1 9700 2280n
load netBundle @u_dados_n__28 4 u_dados_n_107 u_dados_n_108 u_dados_n_109 u_dados_n_110 -autobundled
netbloc @u_dados_n__28 1 3 1 8340 2460n
load netBundle @u_dados_n__29 3 u_dados_n_112 u_dados_n_113 u_dados_n_114 -autobundled
netbloc @u_dados_n__29 1 3 1 8100 2480n
load netBundle @u_dados_n__30 4 u_dados_n_115 u_dados_n_116 u_dados_n_117 u_dados_n_118 -autobundled
netbloc @u_dados_n__30 1 3 1 8300 2500n
load netBundle @u_dados_n__31 3 u_dados_n_120 u_dados_n_121 u_dados_n_122 -autobundled
netbloc @u_dados_n__31 1 3 1 8060 2520n
load netBundle @u_dados_n__32 4 u_dados_n_123 u_dados_n_124 u_dados_n_125 u_dados_n_126 -autobundled
netbloc @u_dados_n__32 1 3 1 8240 2540n
load netBundle @u_dados_n__33 3 u_dados_n_30 u_dados_n_31 u_dados_n_32 -autobundled
netbloc @u_dados_n__33 1 3 1 10580 2300n
load netBundle @u_dados_n__34 4 u_dados_n_49 u_dados_n_50 u_dados_n_51 u_dados_n_52 -autobundled
netbloc @u_dados_n__34 1 3 1 8280 2320n
load netBundle @u_dados_n__35 4 u_dados_n_55 u_dados_n_56 u_dados_n_57 u_dados_n_58 -autobundled
netbloc @u_dados_n__35 1 3 1 8220 2340n
load netBundle @u_dados_n__36 4 u_dados_n_66 u_dados_n_67 u_dados_n_68 u_dados_n_69 -autobundled
netbloc @u_dados_n__36 1 3 1 8180 2380n
load netBundle @u_dados_n__37 3 u_dados_n_96 u_dados_n_97 u_dados_n_98 -autobundled
netbloc @u_dados_n__37 1 3 1 8260 2400n
load netBundle @u_dados_n__38 4 u_dados_n_99 u_dados_n_100 u_dados_n_101 u_dados_n_102 -autobundled
netbloc @u_dados_n__38 1 3 1 8480 2420n
load netBundle @u_dados_n__39 3 u_dados_n_104 u_dados_n_105 u_dados_n_106 -autobundled
netbloc @u_dados_n__39 1 3 1 8200 2440n
load netBundle @heading_deg 4 heading_deg[7] heading_deg[6] heading_deg[5] heading_deg[0] -autobundled
netbloc @heading_deg 1 3 1 11080 2720n
load netBundle @direcao_grau2 2 direcao_grau2[7] direcao_grau2[0] -autobundled
netbloc @direcao_grau2 1 3 1 10180 2740n
load netBundle @hud_metadados 12 hud_metadados[15] hud_metadados[14] hud_metadados[10] hud_metadados[9] hud_metadados[8] hud_metadados[7] hud_metadados[5] hud_metadados[4] hud_metadados[3] hud_metadados[2] hud_metadados[1] hud_metadados[0] -autobundled
netbloc @hud_metadados 1 3 1 11380 2880n
load netBundle @velocidade_kt 2 velocidade_kt[1] velocidade_kt[0] -autobundled
netbloc @velocidade_kt 1 3 1 8560 3900n
load netBundle @u_ui_test_n_ 4 u_ui_test_n_165 u_ui_test_n_166 u_ui_test_n_167 u_ui_test_n_168 -autobundled
netbloc @u_ui_test_n_ 1 4 3 16240 880 NJ 880 18040
load netBundle @native_app_rd_data 129 u_ui_test_n_26 native_app_rd_data[127] native_app_rd_data[126] native_app_rd_data[125] native_app_rd_data[124] native_app_rd_data[123] native_app_rd_data[122] native_app_rd_data[121] native_app_rd_data[120] native_app_rd_data[119] native_app_rd_data[118] native_app_rd_data[117] native_app_rd_data[116] native_app_rd_data[115] native_app_rd_data[114] native_app_rd_data[113] native_app_rd_data[112] native_app_rd_data[111] native_app_rd_data[110] native_app_rd_data[109] native_app_rd_data[108] native_app_rd_data[107] native_app_rd_data[106] native_app_rd_data[105] native_app_rd_data[104] native_app_rd_data[103] native_app_rd_data[102] native_app_rd_data[101] native_app_rd_data[100] native_app_rd_data[99] native_app_rd_data[98] native_app_rd_data[97] native_app_rd_data[96] native_app_rd_data[95] native_app_rd_data[94] native_app_rd_data[93] native_app_rd_data[92] native_app_rd_data[91] native_app_rd_data[90] native_app_rd_data[89] native_app_rd_data[88] native_app_rd_data[87] native_app_rd_data[86] native_app_rd_data[85] native_app_rd_data[84] native_app_rd_data[83] native_app_rd_data[82] native_app_rd_data[81] native_app_rd_data[80] native_app_rd_data[79] native_app_rd_data[78] native_app_rd_data[77] native_app_rd_data[76] native_app_rd_data[75] native_app_rd_data[74] native_app_rd_data[73] native_app_rd_data[72] native_app_rd_data[71] native_app_rd_data[70] native_app_rd_data[69] native_app_rd_data[68] native_app_rd_data[67] native_app_rd_data[66] native_app_rd_data[65] native_app_rd_data[64] native_app_rd_data[63] native_app_rd_data[62] native_app_rd_data[61] native_app_rd_data[60] native_app_rd_data[59] native_app_rd_data[58] native_app_rd_data[57] native_app_rd_data[56] native_app_rd_data[55] native_app_rd_data[54] native_app_rd_data[53] native_app_rd_data[52] native_app_rd_data[51] native_app_rd_data[50] native_app_rd_data[49] native_app_rd_data[48] native_app_rd_data[47] native_app_rd_data[46] native_app_rd_data[45] native_app_rd_data[44] native_app_rd_data[43] native_app_rd_data[42] native_app_rd_data[41] native_app_rd_data[40] native_app_rd_data[39] native_app_rd_data[38] native_app_rd_data[37] native_app_rd_data[36] native_app_rd_data[35] native_app_rd_data[34] native_app_rd_data[33] native_app_rd_data[32] native_app_rd_data[31] native_app_rd_data[30] native_app_rd_data[29] native_app_rd_data[28] native_app_rd_data[27] native_app_rd_data[26] native_app_rd_data[25] native_app_rd_data[24] native_app_rd_data[23] native_app_rd_data[22] native_app_rd_data[21] native_app_rd_data[20] native_app_rd_data[19] native_app_rd_data[18] native_app_rd_data[17] native_app_rd_data[16] native_app_rd_data[15] native_app_rd_data[14] native_app_rd_data[13] native_app_rd_data[12] native_app_rd_data[11] native_app_rd_data[10] native_app_rd_data[9] native_app_rd_data[8] native_app_rd_data[7] native_app_rd_data[6] native_app_rd_data[5] native_app_rd_data[4] native_app_rd_data[3] native_app_rd_data[2] native_app_rd_data[1] native_app_rd_data[0] -autobundled
netbloc @native_app_rd_data 1 4 3 16340 940 NJ 940 18260
load netBundle @u_ui_test_n__1 4 u_ui_test_n_197 u_ui_test_n_198 u_ui_test_n_199 u_ui_test_n_200 -autobundled
netbloc @u_ui_test_n__1 1 4 3 16100 1220 NJ 1220 18360
load netBundle @u_ui_test_n__2 4 u_ui_test_n_201 u_ui_test_n_202 u_ui_test_n_203 u_ui_test_n_204 -autobundled
netbloc @u_ui_test_n__2 1 4 3 16060 1260 NJ 1260 18320
load netBundle @u_ui_test_n__3 2 u_ui_test_n_205 u_ui_test_n_206 -autobundled
netbloc @u_ui_test_n__3 1 4 3 16260 1280 NJ 1280 18280
load netBundle @u_ui_test_n__4 4 u_ui_test_n_169 u_ui_test_n_170 u_ui_test_n_171 u_ui_test_n_172 -autobundled
netbloc @u_ui_test_n__4 1 4 3 16080 1000 NJ 1000 18200
load netBundle @u_ui_test_n__5 4 u_ui_test_n_173 u_ui_test_n_174 u_ui_test_n_175 u_ui_test_n_176 -autobundled
netbloc @u_ui_test_n__5 1 4 3 16120 1020 NJ 1020 18180
load netBundle @u_ui_test_n__6 4 u_ui_test_n_177 u_ui_test_n_178 u_ui_test_n_179 u_ui_test_n_180 -autobundled
netbloc @u_ui_test_n__6 1 4 3 16160 1040 NJ 1040 18160
load netBundle @u_ui_test_n__7 4 u_ui_test_n_181 u_ui_test_n_182 u_ui_test_n_183 u_ui_test_n_184 -autobundled
netbloc @u_ui_test_n__7 1 4 3 16180 1060 NJ 1060 18140
load netBundle @u_ui_test_n__8 4 u_ui_test_n_185 u_ui_test_n_186 u_ui_test_n_187 u_ui_test_n_188 -autobundled
netbloc @u_ui_test_n__8 1 4 3 16220 1080 NJ 1080 18120
load netBundle @u_ui_test_n__9 4 u_ui_test_n_189 u_ui_test_n_190 u_ui_test_n_191 u_ui_test_n_192 -autobundled
netbloc @u_ui_test_n__9 1 4 3 16260 3020 NJ 3020 18400
load netBundle @u_ui_test_n__10 4 u_ui_test_n_193 u_ui_test_n_194 u_ui_test_n_195 u_ui_test_n_196 -autobundled
netbloc @u_ui_test_n__10 1 4 3 16140 1240 NJ 1240 18380
load netBundle @native_app_addr 16 native_app_addr[18] native_app_addr[17] native_app_addr[16] native_app_addr[15] native_app_addr[14] native_app_addr[13] native_app_addr[12] native_app_addr[11] native_app_addr[10] native_app_addr[9] native_app_addr[8] native_app_addr[7] native_app_addr[6] native_app_addr[5] native_app_addr[4] native_app_addr[3] -autobundled
netbloc @native_app_addr 1 5 1 17360 420n
load netBundle @native_app_wdf_data 129 memory_and_vga/bridge/wr_front[144] native_app_wdf_data[127] native_app_wdf_data[126] native_app_wdf_data[125] native_app_wdf_data[124] native_app_wdf_data[123] native_app_wdf_data[122] native_app_wdf_data[121] native_app_wdf_data[120] native_app_wdf_data[119] native_app_wdf_data[118] native_app_wdf_data[117] native_app_wdf_data[116] native_app_wdf_data[115] native_app_wdf_data[114] native_app_wdf_data[113] native_app_wdf_data[112] native_app_wdf_data[111] native_app_wdf_data[110] native_app_wdf_data[109] native_app_wdf_data[108] native_app_wdf_data[107] native_app_wdf_data[106] native_app_wdf_data[105] native_app_wdf_data[104] native_app_wdf_data[103] native_app_wdf_data[102] native_app_wdf_data[101] native_app_wdf_data[100] native_app_wdf_data[99] native_app_wdf_data[98] native_app_wdf_data[97] native_app_wdf_data[96] native_app_wdf_data[95] native_app_wdf_data[94] native_app_wdf_data[93] native_app_wdf_data[92] native_app_wdf_data[91] native_app_wdf_data[90] native_app_wdf_data[89] native_app_wdf_data[88] native_app_wdf_data[87] native_app_wdf_data[86] native_app_wdf_data[85] native_app_wdf_data[84] native_app_wdf_data[83] native_app_wdf_data[82] native_app_wdf_data[81] native_app_wdf_data[80] native_app_wdf_data[79] native_app_wdf_data[78] native_app_wdf_data[77] native_app_wdf_data[76] native_app_wdf_data[75] native_app_wdf_data[74] native_app_wdf_data[73] native_app_wdf_data[72] native_app_wdf_data[71] native_app_wdf_data[70] native_app_wdf_data[69] native_app_wdf_data[68] native_app_wdf_data[67] native_app_wdf_data[66] native_app_wdf_data[65] native_app_wdf_data[64] native_app_wdf_data[63] native_app_wdf_data[62] native_app_wdf_data[61] native_app_wdf_data[60] native_app_wdf_data[59] native_app_wdf_data[58] native_app_wdf_data[57] native_app_wdf_data[56] native_app_wdf_data[55] native_app_wdf_data[54] native_app_wdf_data[53] native_app_wdf_data[52] native_app_wdf_data[51] native_app_wdf_data[50] native_app_wdf_data[49] native_app_wdf_data[48] native_app_wdf_data[47] native_app_wdf_data[46] native_app_wdf_data[45] native_app_wdf_data[44] native_app_wdf_data[43] native_app_wdf_data[42] native_app_wdf_data[41] native_app_wdf_data[40] native_app_wdf_data[39] native_app_wdf_data[38] native_app_wdf_data[37] native_app_wdf_data[36] native_app_wdf_data[35] native_app_wdf_data[34] native_app_wdf_data[33] native_app_wdf_data[32] native_app_wdf_data[31] native_app_wdf_data[30] native_app_wdf_data[29] native_app_wdf_data[28] native_app_wdf_data[27] native_app_wdf_data[26] native_app_wdf_data[25] native_app_wdf_data[24] native_app_wdf_data[23] native_app_wdf_data[22] native_app_wdf_data[21] native_app_wdf_data[20] native_app_wdf_data[19] native_app_wdf_data[18] native_app_wdf_data[17] native_app_wdf_data[16] native_app_wdf_data[15] native_app_wdf_data[14] native_app_wdf_data[13] native_app_wdf_data[12] native_app_wdf_data[11] native_app_wdf_data[10] native_app_wdf_data[9] native_app_wdf_data[8] native_app_wdf_data[7] native_app_wdf_data[6] native_app_wdf_data[5] native_app_wdf_data[4] native_app_wdf_data[3] native_app_wdf_data[2] native_app_wdf_data[1] native_app_wdf_data[0] -autobundled
netbloc @native_app_wdf_data 1 5 1 17460 580n
load netBundle @g_native_video.u_native_n_ 7 g_native_video.u_native_n_396 g_native_video.u_native_n_397 g_native_video.u_native_n_398 g_native_video.u_native_n_399 g_native_video.u_native_n_400 g_native_video.u_native_n_401 g_native_video.u_native_n_402 -autobundled
netbloc @g_native_video.u_native_n_ 1 3 3 12280 1300 15780J 2860 17200
load netBundle @memory_and_vga/bridge/last_dat 126 memory_and_vga/bridge/last_data[125] memory_and_vga/bridge/last_data[124] memory_and_vga/bridge/last_data[123] memory_and_vga/bridge/last_data[122] memory_and_vga/bridge/last_data[121] memory_and_vga/bridge/last_data[120] memory_and_vga/bridge/last_data[119] memory_and_vga/bridge/last_data[118] memory_and_vga/bridge/last_data[117] memory_and_vga/bridge/last_data[116] memory_and_vga/bridge/last_data[115] memory_and_vga/bridge/last_data[114] memory_and_vga/bridge/last_data[113] memory_and_vga/bridge/last_data[112] memory_and_vga/bridge/last_data[111] memory_and_vga/bridge/last_data[110] memory_and_vga/bridge/last_data[109] memory_and_vga/bridge/last_data[108] memory_and_vga/bridge/last_data[107] memory_and_vga/bridge/last_data[106] memory_and_vga/bridge/last_data[105] memory_and_vga/bridge/last_data[104] memory_and_vga/bridge/last_data[103] memory_and_vga/bridge/last_data[102] memory_and_vga/bridge/last_data[101] memory_and_vga/bridge/last_data[100] memory_and_vga/bridge/last_data[99] memory_and_vga/bridge/last_data[98] memory_and_vga/bridge/last_data[97] memory_and_vga/bridge/last_data[96] memory_and_vga/bridge/last_data[95] memory_and_vga/bridge/last_data[94] memory_and_vga/bridge/last_data[93] memory_and_vga/bridge/last_data[92] memory_and_vga/bridge/last_data[91] memory_and_vga/bridge/last_data[90] memory_and_vga/bridge/last_data[89] memory_and_vga/bridge/last_data[88] memory_and_vga/bridge/last_data[87] memory_and_vga/bridge/last_data[86] memory_and_vga/bridge/last_data[85] memory_and_vga/bridge/last_data[84] memory_and_vga/bridge/last_data[83] memory_and_vga/bridge/last_data[82] memory_and_vga/bridge/last_data[81] memory_and_vga/bridge/last_data[80] memory_and_vga/bridge/last_data[79] memory_and_vga/bridge/last_data[78] memory_and_vga/bridge/last_data[77] memory_and_vga/bridge/last_data[76] memory_and_vga/bridge/last_data[75] memory_and_vga/bridge/last_data[74] memory_and_vga/bridge/last_data[73] memory_and_vga/bridge/last_data[72] memory_and_vga/bridge/last_data[71] memory_and_vga/bridge/last_data[70] memory_and_vga/bridge/last_data[69] memory_and_vga/bridge/last_data[68] memory_and_vga/bridge/last_data[67] memory_and_vga/bridge/last_data[66] memory_and_vga/bridge/last_data[65] memory_and_vga/bridge/last_data[64] memory_and_vga/bridge/last_data[63] memory_and_vga/bridge/last_data[62] memory_and_vga/bridge/last_data[61] memory_and_vga/bridge/last_data[60] memory_and_vga/bridge/last_data[59] memory_and_vga/bridge/last_data[58] memory_and_vga/bridge/last_data[57] memory_and_vga/bridge/last_data[56] memory_and_vga/bridge/last_data[55] memory_and_vga/bridge/last_data[54] memory_and_vga/bridge/last_data[53] memory_and_vga/bridge/last_data[52] memory_and_vga/bridge/last_data[51] memory_and_vga/bridge/last_data[50] memory_and_vga/bridge/last_data[49] memory_and_vga/bridge/last_data[48] memory_and_vga/bridge/last_data[47] memory_and_vga/bridge/last_data[46] memory_and_vga/bridge/last_data[45] memory_and_vga/bridge/last_data[44] memory_and_vga/bridge/last_data[43] memory_and_vga/bridge/last_data[42] memory_and_vga/bridge/last_data[41] memory_and_vga/bridge/last_data[40] memory_and_vga/bridge/last_data[39] memory_and_vga/bridge/last_data[38] memory_and_vga/bridge/last_data[37] memory_and_vga/bridge/last_data[36] memory_and_vga/bridge/last_data[35] memory_and_vga/bridge/last_data[34] memory_and_vga/bridge/last_data[33] memory_and_vga/bridge/last_data[32] memory_and_vga/bridge/last_data[31] memory_and_vga/bridge/last_data[30] memory_and_vga/bridge/last_data[29] memory_and_vga/bridge/last_data[28] memory_and_vga/bridge/last_data[27] memory_and_vga/bridge/last_data[26] memory_and_vga/bridge/last_data[25] memory_and_vga/bridge/last_data[24] memory_and_vga/bridge/last_data[23] memory_and_vga/bridge/last_data[22] memory_and_vga/bridge/last_data[21] memory_and_vga/bridge/last_data[20] memory_and_vga/bridge/last_data[19] memory_and_vga/bridge/last_data[18] memory_and_vga/bridge/last_data[17] memory_and_vga/bridge/last_data[16] memory_and_vga/bridge/last_data[15] memory_and_vga/bridge/last_data[14] memory_and_vga/bridge/last_data[13] memory_and_vga/bridge/last_data[12] memory_and_vga/bridge/last_data[11] memory_and_vga/bridge/last_data[10] memory_and_vga/bridge/last_data[9] memory_and_vga/bridge/last_data[8] memory_and_vga/bridge/last_data[7] memory_and_vga/bridge/last_data[6] memory_and_vga/bridge/last_data[5] memory_and_vga/bridge/last_data[4] memory_and_vga/bridge/last_data[3] memory_and_vga/bridge/last_data[2] memory_and_vga/bridge/last_data[1] memory_and_vga/bridge/last_data[0] -autobundled
netbloc @memory_and_vga/bridge/last_dat 1 5 1 17480 680n
load netBundle @g_native_video.u_native_n__1 7 g_native_video.u_native_n_403 g_native_video.u_native_n_404 g_native_video.u_native_n_405 g_native_video.u_native_n_406 g_native_video.u_native_n_407 g_native_video.u_native_n_408 g_native_video.u_native_n_409 -autobundled
netbloc @g_native_video.u_native_n__1 1 3 3 12440 1440 15500J 3000 17120
load netBundle @memory_and_vga/vga/future_word 5 memory_and_vga/vga/future_word[4] memory_and_vga/vga/future_word[3] memory_and_vga/vga/future_word[2] memory_and_vga/vga/future_word[1] memory_and_vga/vga/future_word[0] -autobundled
netbloc @memory_and_vga/vga/future_word 1 4 1 15240 1360n
load netBundle @pixel_x 9 pixel_x[9] pixel_x[8] pixel_x[7] pixel_x[6] pixel_x[5] pixel_x[4] pixel_x[3] pixel_x[2] pixel_x[1] -autobundled -attr @style dashed
netbloc @pixel_x 1 2 3 5880 5440 10740J 1040 15200
load netBundle @u_vga_n_ 2 u_vga_n_284 u_vga_n_285 -autobundled
netbloc @u_vga_n_ 1 2 3 5340 4320 9060J 500 15060
load netBundle @u_vga_n__1 2 u_vga_n_278 u_vga_n_279 -autobundled
netbloc @u_vga_n__1 1 2 3 4140 4300 9020J 480 15080
load netBundle @u_vga_n__2 3 u_vga_n_253 u_vga_n_254 u_vga_n_255 -autobundled
netbloc @u_vga_n__2 1 2 3 5360 5480 11180J 1080 14680
load netBundle @u_vga_n__3 4 u_vga_n_274 u_vga_n_275 u_vga_n_276 u_vga_n_277 -autobundled
netbloc @u_vga_n__3 1 2 3 5280 5500 11200J 1100 14640
load netBundle @u_vga_n__4 4 u_vga_n_292 u_vga_n_293 u_vga_n_294 u_vga_n_295 -autobundled
netbloc @u_vga_n__4 1 2 3 5220 5520 11220J 1120 14620
load netBundle @u_vga_n__5 4 u_vga_n_42 u_vga_n_43 u_vga_n_44 u_vga_n_45 -autobundled
netbloc @u_vga_n__5 1 2 3 5040 6060 11020J 1880 14580
load netBundle @card_coluna2_B_dspDelayedAccum 4 card_coluna2_B_dspDelayedAccum[5] card_coluna2_B_dspDelayedAccum[4] card_coluna2_B_dspDelayedAccum[3] card_coluna2_B_dspDelayedAccum[2] -autobundled
netbloc @card_coluna2_B_dspDelayedAccum 1 2 3 5400 5460 10960J 1060 14760
load netBundle @u_vga_n__6 4 u_vga_n_65 u_vga_n_66 u_vga_n_67 u_vga_n_68 -autobundled
netbloc @u_vga_n__6 1 2 3 5140 6080 7140J 1900 13960
load netBundle @u_vga_n__7 4 u_vga_n_75 u_vga_n_76 u_vga_n_77 u_vga_n_78 -autobundled
netbloc @u_vga_n__7 1 2 3 5100 6100 7200J 1920 13780
load netBundle @u_vga_n__8 4 u_vga_n_270 u_vga_n_271 u_vga_n_272 u_vga_n_273 -autobundled
netbloc @u_vga_n__8 1 2 3 4640 6120 7560J 1940 13980
load netBundle @u_vga_n__9 4 u_vga_n_286 u_vga_n_287 u_vga_n_288 u_vga_n_289 -autobundled
netbloc @u_vga_n__9 1 2 3 4620 6140 7600J 1960 13760
load netBundle @u_vga_n__10 3 u_vga_n_111 u_vga_n_112 u_vga_n_113 -autobundled
netbloc @u_vga_n__10 1 2 3 4600 6160 10940J 1980 14220
load netBundle @u_vga_n__11 4 u_vga_n_257 u_vga_n_258 u_vga_n_259 u_vga_n_260 -autobundled
netbloc @u_vga_n__11 1 2 3 4580 6180 8860J 2000 14140
load netBundle @u_vga_n__12 2 u_vga_n_104 u_vga_n_105 -autobundled
netbloc @u_vga_n__12 1 2 3 3980 6340 7260J 2160 14380
load netBundle @u_vga_n__13 3 u_vga_n_114 u_vga_n_115 u_vga_n_116 -autobundled
netbloc @u_vga_n__13 1 2 3 3920 6360 7820J 2180 14000
load netBundle @u_vga_n__14 3 u_vga_n_127 u_vga_n_128 u_vga_n_129 -autobundled
netbloc @u_vga_n__14 1 2 3 3840 6380 7940J 2200 13800
load netBundle @u_vga_n__15 4 u_vga_n_266 u_vga_n_267 u_vga_n_268 u_vga_n_269 -autobundled
netbloc @u_vga_n__15 1 2 3 4540 6240 9260J 2060 14400
load netBundle @u_vga_n__16 4 u_vga_n_261 u_vga_n_262 u_vga_n_263 u_vga_n_264 -autobundled
netbloc @u_vga_n__16 1 2 3 4340 6260 10760J 2080 14340
load netBundle @u_vga_n__17 4 u_vga_n_241 u_vga_n_242 u_vga_n_243 u_vga_n_244 -autobundled
netbloc @u_vga_n__17 1 2 3 5060 6300 8760J 2120 14280
load netBundle @u_vga_n__18 4 u_vga_n_280 u_vga_n_281 u_vga_n_282 u_vga_n_283 -autobundled
netbloc @u_vga_n__18 1 2 3 4360 6320 9680J 2140 14200
load netBundle @u_vga_n__19 3 u_vga_n_25 u_vga_n_26 u_vga_n_27 -autobundled
netbloc @u_vga_n__19 1 2 3 5500 4560 9080J 740 15020
load netBundle @u_vga_n__20 3 u_vga_n_59 u_vga_n_60 u_vga_n_61 -autobundled
netbloc @u_vga_n__20 1 2 3 4680 4580 10000J 760 14100
load netBundle @u_vga_n__21 3 u_vga_n_69 u_vga_n_70 u_vga_n_71 -autobundled
netbloc @u_vga_n__21 1 2 3 5980 4680 10460J 860 13820
load netBundle @u_vga_n__22 4 u_vga_n_248 u_vga_n_249 u_vga_n_250 u_vga_n_251 -autobundled
netbloc @u_vga_n__22 1 2 3 5440 4600 10060J 780 15180
load netBundle @u_vga_n__23 2 u_vga_n_296 u_vga_n_297 -autobundled
netbloc @u_vga_n__23 1 2 3 4220 4620 10120J 800 14980
load netBundle @u_vga_n__24 2 u_vga_n_239 u_vga_n_240 -autobundled
netbloc @u_vga_n__24 1 2 3 4520 8300 NJ 8300 15340
load netBundle @u_vga_n__25 2 u_vga_n_290 u_vga_n_291 -autobundled
netbloc @u_vga_n__25 1 2 3 4300 8380 NJ 8380 15260
load netBundle @card_coluna4 5 card_coluna4[5] card_coluna4[4] card_coluna4[3] card_coluna4[2] card_coluna4[1] -autobundled
netbloc @card_coluna4 1 2 3 4280 8400 NJ 8400 15240
load netBundle @u_vga_n__26 2 u_vga_n_62 u_vga_n_63 -autobundled
netbloc @u_vga_n__26 1 2 3 4480 8420 NJ 8420 15220
load netBundle @u_vga_n__27 2 u_vga_n_72 u_vga_n_73 -autobundled
netbloc @u_vga_n__27 1 2 3 4960 8440 NJ 8440 15200
load netBundle @u_vga_n__28 2 u_vga_n_79 u_vga_n_80 -autobundled
netbloc @u_vga_n__28 1 2 3 4940 8460 NJ 8460 15180
load netBundle @u_vga_n__29 3 u_vga_n_90 u_vga_n_91 u_vga_n_92 -autobundled
netbloc @u_vga_n__29 1 2 3 4460 8680 NJ 8680 14920
load netBundle @direcao_grau2_1 2 direcao_grau2[9] direcao_grau2[8] -autobundled
netbloc @direcao_grau2_1 1 2 3 4400 8700 NJ 8700 14900
load netBundle @capture_hud_rgb 4 capture_hud_rgb[11] capture_hud_rgb[7] capture_hud_rgb[6] capture_hud_rgb[3] -autobundled
netbloc @capture_hud_rgb 1 4 1 15580 1820n
load netBundle @memory_and_vga/vga/p_0_in__1 4 memory_and_vga/vga/p_0_in__1[6] memory_and_vga/vga/p_0_in__1[5] memory_and_vga/vga/p_0_in__1[4] memory_and_vga/vga/p_0_in__1[3] -autobundled
netbloc @memory_and_vga/vga/p_0_in__1 1 4 1 15820 2280n
load netBundle @u_vga_n__30 4 u_vga_n_131 u_vga_n_132 u_vga_n_133 u_vga_n_134 -autobundled
netbloc @u_vga_n__30 1 2 3 3780 8920 NJ 8920 14620
load netBundle @memory_and_vga/vga/A,data0 10 memory_and_vga/vga/A[9] memory_and_vga/vga/A[8] memory_and_vga/vga/A[7] memory_and_vga/vga/A[6] memory_and_vga/vga/A[5] memory_and_vga/vga/A[4] memory_and_vga/vga/A[3] memory_and_vga/vga/A[2] data0[1] memory_and_vga/vga/next_y[0] -autobundled
netbloc @memory_and_vga/vga/A,data0 1 4 1 15740 1900n
load netBundle @horizonte_sync 2 horizonte_sync[1] horizonte_sync[0] -autobundled -attr @style dashed
netbloc @horizonte_sync 1 0 2 400 4620 1350J
load netBundle @roll_sync 2 roll_sync[1] roll_sync[0] -autobundled -attr @style dashed
netbloc @roll_sync 1 0 2 460 5620 1570J
load netBundle @hud_pixel_x 8 hud_pixel_x[9] hud_pixel_x[8] hud_pixel_x[6] hud_pixel_x[4] hud_pixel_x[3] hud_pixel_x[2] hud_pixel_x[1] hud_pixel_x[0] -autobundled -attr @style dashed
netbloc @hud_pixel_x 1 2 3 5160 6440 7260 9260 15040J
load netBundle @hud_pixel_y 6 hud_pixel_y[5] hud_pixel_y[4] hud_pixel_y[3] hud_pixel_y[2] hud_pixel_y[1] hud_pixel_y[0] -autobundled -attr @style dashed
netbloc @hud_pixel_y 1 2 3 5240 6460 7160 9440 16260J
levelinfo -pg 1 0 750 1980 6290 12680 16670 17670 18420
pagesize -pg 1 -db -bbox -sgen 0 0 18420 9510
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
