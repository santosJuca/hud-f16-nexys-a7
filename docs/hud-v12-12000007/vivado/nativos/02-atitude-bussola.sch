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
load symbol hud_auto_zero work:hud_auto_zero:NOFILE HIERBOX pin auto_zero_request output.right pin clk_hud input.left pin done output.right pin done_reg_0 input.left pin near_neutral0_carry__0_0 input.left pin near_neutral2_carry__0_0 input.left pin stable_updates_reg[2]_0 input.left pin updated input.left pin zero_pulse9_out output.right pinBus CO output.right [0:0] pinBus D input.left [1:0] pinBus DI input.left [1:0] pinBus S input.left [3:0] pinBus done_i_3 input.left [0:0] pinBus done_i_3_0 input.left [0:0] pinBus done_i_5 input.left [2:0] pinBus done_i_5_0 input.left [0:0] pinBus done_i_5_1 input.left [0:0] pinBus done_i_5_2 input.left [2:0] pinBus near_neutral0_carry__0_1 input.left [3:0] pinBus near_neutral0_carry__1_0 input.left [1:0] pinBus near_neutral0_carry__1_1 input.left [3:0] pinBus near_neutral0_carry__2_0 input.left [3:0] pinBus near_neutral1_carry__0_0 input.left [3:0] pinBus near_neutral1_carry__0_1 input.left [3:0] pinBus near_neutral1_carry__1_0 input.left [1:0] pinBus near_neutral1_carry__1_1 input.left [3:0] pinBus near_neutral1_carry__2_0 input.left [3:0] pinBus near_neutral2_carry__1_0 input.left [3:0] pinBus near_neutral2_carry__2_0 input.left [3:0] pinBus near_neutral2_inferred__0/i__carry__0_0 input.left [3:0] pinBus near_neutral2_inferred__0/i__carry__0_1 input.left [3:0] pinBus near_neutral2_inferred__0/i__carry__1_0 input.left [1:0] pinBus near_neutral2_inferred__0/i__carry__1_1 input.left [3:0] pinBus near_neutral2_inferred__0/i__carry__2_0 input.left [3:0] pinBus raw_pitch_reg[25] output.right [0:0] pinBus raw_pitch_reg[25]_0 output.right [0:0] pinBus raw_roll_reg[26] output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol atitude_cordic__parameterized0 work:atitude_cordic__parameterized0:NOFILE HIERBOX pin clk_hud input.left pin done_reg_0 output.right pin render_sine_ready_reg[0] input.left pin reset_operacao input.left pin trig_start input.left pin trig_wait input.left pinBus E output.right [0:0] pinBus Q input.left [25:0] pinBus inicio_operacao_reg[3] output.right [0:0] pinBus x_out output.right [15:0] pinBus y_out output.right [15:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol entrada_hud__parameterized0 work:entrada_hud__parameterized0:NOFILE HIERBOX pin clk_hud input.left pin pixel_clk input.left pin valido_destino__0 output.right pinBus D input.left [188:0] pinBus Q output.right [209:0] pinBus retido_reg[238]_0 input.left [20:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hmc5883l_i2c work:hmc5883l_i2c:NOFILE HIERBOX pin FSM_sequential_state_reg[0]_0 output.right pin MAG_LED_OBUF output.right pin age1 output.right pin age_reg[0] input.left pin age_reg[0]_0 input.left pin age_reg[23] input.left pin amostra_nova_reg_1 output.right pin amostra_nova_reg_10 output.right pin amostra_nova_reg_11 output.right pin amostra_nova_reg_12 output.right pin amostra_nova_reg_13 output.right pin amostra_nova_reg_14 output.right pin amostra_nova_reg_15 output.right pin amostra_nova_reg_16 output.right pin amostra_nova_reg_17 output.right pin amostra_nova_reg_18 output.right pin amostra_nova_reg_2 output.right pin amostra_nova_reg_3 output.right pin amostra_nova_reg_4 output.right pin amostra_nova_reg_5 output.right pin amostra_nova_reg_6 output.right pin amostra_nova_reg_7 output.right pin amostra_nova_reg_8 output.right pin amostra_nova_reg_9 output.right pin cancel_reg output.right pin clk_hud input.left pin have_last input.left pin inicio_operacao_reg[3] output.right pin invalid_now input.left pin invalid_now_reg output.right pin invalid_now_reg_0 output.right pin mag_amostra_nova output.right pin mag_cal_level input.left pin mag_scl_TRI output.right pin mag_sda_TRI output.right pin mag_sensor_ok output.right pin mag_x_reg[11]_0 output.right pin p_14_in output.right pin p_17_in input.left pin p_2_in output.right pin pipe_unique_reg input.left pin published_reg input.left pin reason_reg[0] input.left pin repeats_reg[15] input.left pin sensor_ok_reg_0 output.right pin state4 output.right pin state[2]_i_4 input.left pin state_reg[0] output.right pin state_reg[2] output.right pin state_reg[3] input.left pin state_reg[3]_0 input.left pinBus CO output.right [0:0] pinBus D output.right [15:0] pinBus O input.left [3:0] pinBus Q input.left [0:0] pinBus S input.left [3:0] pinBus SR output.right [0:0] pinBus age_reg[12] input.left [3:0] pinBus age_reg[16] input.left [3:0] pinBus age_reg[20] input.left [3:0] pinBus age_reg[24] input.left [3:0] pinBus age_reg[25] input.left [0:0] pinBus age_reg[25]_0 input.left [11:0] pinBus age_reg[8] input.left [3:0] pinBus amostra_nova_reg_0 output.right [25:0] pinBus mag_diagnostics output.right [30:0] pinBus mag_x output.right [15:0] pinBus mag_x_reg[15]_0 output.right [0:0] pinBus mag_y output.right [15:0] pinBus mag_y_reg[15]_0 output.right [0:0] pinBus mag_y_reg[15]_1 output.right [0:0] pinBus mag_z output.right [15:0] pinBus mag_z_reg[15]_0 output.right [0:0] pinBus mag_z_reg[15]_1 output.right [0:0] pinBus max_x_reg[0] input.left [3:0] pinBus max_x_reg[15]_i_2_0 input.left [15:0] pinBus max_x_reg[15]_i_2_1 input.left [3:0] pinBus max_y_reg[0] input.left [3:0] pinBus max_y_reg[15]_i_2_0 input.left [15:0] pinBus max_y_reg[15]_i_2_1 input.left [3:0] pinBus max_z_reg[0] input.left [3:0] pinBus max_z_reg[15]_i_2_0 input.left [15:0] pinBus max_z_reg[15]_i_2_1 input.left [3:0] pinBus min_x_reg[0] input.left [3:0] pinBus min_x_reg[15]_i_2_0 input.left [15:0] pinBus min_x_reg[15]_i_2_1 input.left [3:0] pinBus min_y_reg[0] input.left [3:0] pinBus min_y_reg[15]_i_2_0 input.left [15:0] pinBus min_y_reg[15]_i_2_1 input.left [3:0] pinBus min_z_reg[0] input.left [3:0] pinBus min_z_reg[15]_i_3_0 input.left [15:0] pinBus out input.left [0:0] pinBus pipe_unique_reg_0 input.left [0:0] pinBus pipe_unique_reg_1 input.left [0:0] pinBus pipe_unique_reg_2 input.left [0:0] pinBus pipe_unique_reg_i_2_0 input.left [14:0] pinBus pipe_unique_reg_i_3_0 input.left [14:0] pinBus pipe_unique_reg_i_4_0 input.left [14:0] pinBus rx_bytes_reg[0][7]_0 output.right [15:0] pinBus rx_bytes_reg[4][7]_0 output.right [15:0] pinBus scl_sync_reg[0]_0 input.left [0:0] pinBus sda_sync_reg[0]_0 input.left [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE HIERBOX pin MAG_LED_OBUF input.left pin age_reg[0]_0 input.left pin angle_out_reg[0] input.left pin busy_reg output.right pin busy_reg_0 output.right pin bz_reg_0 input.left pin clk_hud input.left pin done1 output.right pin g_idade[2].idade_reg[0] input.left pin g_idade[2].idade_reg[0]_0 input.left pin heading_approved_valid output.right pin heading_planar_updated input.left pin mag_amostra_nova input.left pin p_17_in input.left pin p_2_in input.left pin published_reg_0 input.left pin state_reg[1]_0 output.right pin state_reg[2]_0 output.right pin state_reg[2]_rep__0_0 input.left pin state_reg[3]_0 output.right pin y_reg[0] input.left pinBus D input.left [15:0] pinBus E input.left [0:0] pinBus O output.right [3:0] pinBus Q output.right [0:0] pinBus SR input.left [0:0] pinBus age_reg[12]_0 output.right [3:0] pinBus age_reg[16]_0 output.right [3:0] pinBus age_reg[20]_0 output.right [3:0] pinBus age_reg[24]_0 output.right [3:0] pinBus age_reg[25]_0 output.right [0:0] pinBus age_reg[25]_1 input.left [25:0] pinBus age_reg[8]_0 output.right [3:0] pinBus bx_reg_0 input.left [15:0] pinBus by_reg_0 input.left [15:0] pinBus gx_reg[23]_0 input.left [23:0] pinBus gy_reg[24]_0 input.left [23:0] pinBus gz_reg[24]_0 input.left [23:0] pinBus heading_deg_reg[8]_0 output.right [8:0] pinBus out input.left [0:0] pinBus p_0_out output.right [0:0] pinBus y input.left [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol mag_calibration_2d work:mag_calibration_2d:NOFILE HIERBOX pin MAG_LED_OBUF input.left pin age1 input.left pin age_reg[12]_0 input.left pin age_reg[13]_0 input.left pin age_reg[14]_0 input.left pin age_reg[15]_0 input.left pin age_reg[17]_0 input.left pin age_reg[19]_0 input.left pin age_reg[20]_0 input.left pin age_reg[21]_0 input.left pin age_reg[22]_0 input.left pin age_reg[23]_0 input.left pin age_reg[23]_1 input.left pin age_reg[24]_0 output.right pin age_reg[25]_0 output.right pin age_reg[25]_1 output.right pin age_reg[25]_3 input.left pin age_reg[7]_0 input.left pin boot_profile_locked output.right pin boot_profile_locked_reg_0 input.left pin cancel input.left pin clk_hud input.left pin corrected_sample0 output.right pin dados_reg[0]_1 input.left pin fonte_desabilitada_sync_reg[2] output.right pin g_idade[2].idade_reg[25] input.left pin g_idade[2].recentes_reg[2] output.right pin have_last output.right pin have_last_reg_0 input.left pin have_train_reg_0 output.right pin have_train_reg_1 input.left pin heading_approved_valid input.left pin heading_planar_valid input.left pin invalid_now output.right pin invalid_now_reg_0 input.left pin mag_cal_active output.right pin mag_cal_healthy output.right pin mag_cal_level input.left pin mag_cal_next input.left pin mag_cal_owned input.left pin mag_cal_recover input.left pin mag_cal_start input.left pin mag_corrected_sample output.right pin mag_profile_changed output.right pin mag_sd_profile_valid input.left pin mag_sensor_ok input.left pin offset_y_reg[0]_0 input.left pin p_14_in input.left pin p_18_in output.right pin p_1_in output.right pin previous_y_reg[0]_0 input.left pin prod_x_reg_0 input.left pin profile_changed_reg_0 output.right pin reason[0]_i_3_0 input.left pin reason_reg[0]_0 input.left pin reason_reg[1]_0 input.left pin reason_reg[1]_1 input.left pin reason_reg[2]_0 input.left pin reason_reg[3]_0 input.left pin repeats_reg[15]_0 input.left pin reset_operacao input.left pin sensor_ok0 output.right pin state4 input.left pin state[2]_i_2__0_0 input.left pin state_reg[0]_0 output.right pin state_reg[0]_1 input.left pin state_reg[1]_0 input.left pin state_reg[2]_0 input.left pin state_reg[3]_1 output.right pin state_reg[3]_2 input.left pin state_reg[3]_3 input.left pin suspect_reg_0 input.left pin suspect_reg_1 input.left pin timer_reg[0]_0 input.left pin valido0 output.right pin valido_reg output.right pin x_reg[12] input.left pin x_reg[12]_0 input.left pinBus CO input.left [0:0] pinBus E output.right [0:0] pinBus Q output.right [15:0] pinBus S output.right [3:0] pinBus SD_SEG[6] input.left [2:0] pinBus SD_SEG_OBUF output.right [6:0] pinBus SR input.left [0:0] pinBus SS input.left [0:0] pinBus age_reg[25]_2 output.right [11:0] pinBus corrected_sample_reg_0 output.right [0:0] pinBus corrected_x_reg[15]_0 output.right [15:0] pinBus corrected_y_reg[15]_0 output.right [15:0] pinBus coverage_reg[0]_0 input.left [0:0] pinBus dados_reg[0] input.left [0:0] pinBus dados_reg[0]_0 input.left [0:0] pinBus estado input.left [2:0] pinBus heading_deg_reg[0] output.right [0:0] pinBus inicio_operacao_reg[3] output.right [0:0] pinBus inicio_operacao_reg[3]_0 output.right [0:0] pinBus last_x_reg[14]_0 output.right [14:0] pinBus last_x_reg[15]_0 output.right [0:0] pinBus last_y_reg[14]_0 output.right [14:0] pinBus last_y_reg[15]_0 output.right [0:0] pinBus last_z_reg[14]_0 output.right [14:0] pinBus last_z_reg[15]_0 output.right [0:0] pinBus max_x_reg[15]_0 output.right [15:0] pinBus max_x_reg[15]_1 output.right [3:0] pinBus max_x_reg[15]_2 input.left [15:0] pinBus max_x_reg[7]_0 output.right [3:0] pinBus max_y_reg[0]_0 input.left [0:0] pinBus max_y_reg[15]_0 output.right [15:0] pinBus max_y_reg[15]_1 output.right [3:0] pinBus max_y_reg[15]_2 input.left [15:0] pinBus max_y_reg[7]_0 output.right [3:0] pinBus max_z_reg[0]_0 input.left [0:0] pinBus max_z_reg[15]_0 output.right [15:0] pinBus max_z_reg[15]_1 output.right [3:0] pinBus max_z_reg[7]_0 output.right [3:0] pinBus min_x_reg[0]_0 input.left [0:0] pinBus min_x_reg[15]_0 output.right [15:0] pinBus min_x_reg[15]_1 output.right [3:0] pinBus min_x_reg[7]_0 output.right [3:0] pinBus min_y_reg[0]_0 input.left [0:0] pinBus min_y_reg[15]_0 output.right [15:0] pinBus min_y_reg[15]_1 output.right [3:0] pinBus min_y_reg[7]_0 output.right [3:0] pinBus min_z_reg[0]_0 input.left [0:0] pinBus min_z_reg[15]_0 output.right [3:0] pinBus out input.left [0:0] pinBus p_0_out input.left [0:0] pinBus pipe_z_reg[15]_0 input.left [15:0] pinBus prod_x_reg_1 input.left [15:0] pinBus prod_y_reg_0 input.left [15:0] pinBus profile input.left [59:0] pinBus sd_segments_normal input.left [6:0] pinBus state_reg[3]_0 output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol heading_magnetico work:heading_magnetico:NOFILE HIERBOX pin clk_hud input.left pin heading_planar_updated output.right pin heading_planar_valid output.right pin iteracao_reg[0]_0 input.left pin mag_cal_healthy input.left pin mag_corrected_sample input.left pin mag_profile_changed input.left pin sensor_ok0 input.left pin valido0 input.left pin x_reg[12]_0 input.left pin y_reg[31]_0 output.right pinBus E input.left [0:0] pinBus Q input.left [15:0] pinBus corrigido_y_reg[15]_0 input.left [15:0] pinBus estado output.right [2:0] pinBus heading_deg_reg[8]_0 output.right [8:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst u_sensor mpu6050_i2c work:mpu6050_i2c:NOFILE -attr @cell(#1c1f28) mpu6050_i2c -pinBusAttr B @name B[15:0] -pinBusAttr D @name D -pinBusAttr DI @name DI -pinBusAttr S @name S -pinBusAttr SR @name SR -pinBusAttr accel_x_reg[15]_0 @name accel_x_reg[15]_0[95:0] -pinBusAttr age_reg @name age_reg -pinBusAttr age_reg[0] @name age_reg[0] -pinBusAttr age_reg[0]_0 @name age_reg[0]_0 -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr out @name out -pinBusAttr samples_reg[2][7]_0 @name samples_reg[2][7]_0[15:0] -pinBusAttr samples_reg[4][7]_0 @name samples_reg[4][7]_0[15:0] -pinBusAttr scl_sync_reg[0]_0 @name scl_sync_reg[0]_0 -pinBusAttr sda_sync_reg[0]_0 @name sda_sync_reg[0]_0 -pinBusAttr sensor_i_3 @name sensor_i_3[1:0] -pinBusAttr sensor_i_3_0 @name sensor_i_3_0[1:0] -pinBusAttr stale_reg @name stale_reg -pg 1 -lvl 1 -x 710 -y 2980
load inst u_vector atitude_vetorial work:atitude_vetorial:NOFILE -attr @cell(#1c1f28) atitude_vetorial -pinBusAttr B @name B[15:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[112:0] -pinBusAttr DI @name DI -pinBusAttr E @name E -pinBusAttr O @name O -pinBusAttr Q @name Q[23:0] -pinBusAttr S @name S -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr a_reg[0][15]_0 @name a_reg[0][15]_0[95:0] -pinBusAttr age_reg[0]_0 @name age_reg[0]_0 -pinBusAttr age_reg[3]_0 @name age_reg[3]_0 -pinBusAttr age_reg[3]_1 @name age_reg[3]_1 -pinBusAttr angle_out_reg[6] @name angle_out_reg[6] -pinBusAttr done_i_3_0 @name done_i_3_0 -pinBusAttr done_i_3_1 @name done_i_3_1 -pinBusAttr done_reg @name done_reg -pinBusAttr gravity_x_reg[23]_0 @name gravity_x_reg[23]_0[23:0] -pinBusAttr gravity_y_reg[23]_0 @name gravity_y_reg[23]_0[23:0] -pinBusAttr horizonte_sync_reg[0] @name horizonte_sync_reg[0][26:0] -pinBusAttr horizonte_sync_reg[0]_0 @name horizonte_sync_reg[0]_0[10:0] -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr inicio_operacao_reg[3]_1 @name inicio_operacao_reg[3]_1 -pinBusAttr out @name out -pinBusAttr p_1_in_1 @name p_1_in_1[15:0] -pinBusAttr p_1_in__0_0 @name p_1_in__0_0[15:0] -pinBusAttr pc_reg_0 @name pc_reg_0 -pinBusAttr pitch_fallback_q10_reg[14] @name pitch_fallback_q10_reg[14][1:0] -pinBusAttr pw_reg @name pw_reg[26:0] -pinBusAttr raw_pitch_reg[12]_0 @name raw_pitch_reg[12]_0[1:0] -pinBusAttr raw_pitch_reg[12]_1 @name raw_pitch_reg[12]_1[1:0] -pinBusAttr raw_pitch_reg[14]_0 @name raw_pitch_reg[14]_0[3:0] -pinBusAttr raw_pitch_reg[16]_0 @name raw_pitch_reg[16]_0[3:0] -pinBusAttr raw_pitch_reg[22]_0 @name raw_pitch_reg[22]_0[3:0] -pinBusAttr raw_pitch_reg[24]_0 @name raw_pitch_reg[24]_0 -pinBusAttr raw_pitch_reg[24]_1 @name raw_pitch_reg[24]_1[3:0] -pinBusAttr raw_pitch_reg[25]_0 @name raw_pitch_reg[25]_0[2:0] -pinBusAttr raw_pitch_reg[25]_1 @name raw_pitch_reg[25]_1 -pinBusAttr raw_pitch_reg[6]_0 @name raw_pitch_reg[6]_0[3:0] -pinBusAttr raw_pitch_reg[6]_1 @name raw_pitch_reg[6]_1[3:0] -pinBusAttr raw_pitch_reg[8]_0 @name raw_pitch_reg[8]_0[3:0] -pinBusAttr raw_roll_reg[12]_0 @name raw_roll_reg[12]_0[1:0] -pinBusAttr raw_roll_reg[12]_1 @name raw_roll_reg[12]_1[1:0] -pinBusAttr raw_roll_reg[14]_0 @name raw_roll_reg[14]_0[3:0] -pinBusAttr raw_roll_reg[16]_0 @name raw_roll_reg[16]_0[3:0] -pinBusAttr raw_roll_reg[22]_0 @name raw_roll_reg[22]_0[3:0] -pinBusAttr raw_roll_reg[24]_0 @name raw_roll_reg[24]_0 -pinBusAttr raw_roll_reg[24]_1 @name raw_roll_reg[24]_1[3:0] -pinBusAttr raw_roll_reg[26]_0 @name raw_roll_reg[26]_0 -pinBusAttr raw_roll_reg[26]_1 @name raw_roll_reg[26]_1[2:0] -pinBusAttr raw_roll_reg[6]_0 @name raw_roll_reg[6]_0[3:0] -pinBusAttr raw_roll_reg[6]_1 @name raw_roll_reg[6]_1[3:0] -pinBusAttr raw_roll_reg[8]_0 @name raw_roll_reg[8]_0[3:0] -pinBusAttr rc_reg_i_15_0 @name rc_reg_i_15_0 -pinBusAttr rc_reg_i_15_1 @name rc_reg_i_15_1 -pinBusAttr rc_reg_i_20_0 @name rc_reg_i_20_0 -pinBusAttr rc_reg_i_32_0 @name rc_reg_i_32_0 -pinBusAttr rc_reg_i_8_0 @name rc_reg_i_8_0 -pinBusAttr roll_fallback_q10_reg[9] @name roll_fallback_q10_reg[9][1:0] -pinBusAttr roll_reg[16]_0 @name roll_reg[16]_0[4:0] -pinBusAttr roll_reg[31]_0 @name roll_reg[31]_0[19:0] -pinBusAttr roll_reg[31]_1 @name roll_reg[31]_1 -pinBusAttr roll_reg[31]_2 @name roll_reg[31]_2 -pinBusAttr roll_reg[31]_3 @name roll_reg[31]_3 -pinBusAttr roll_reg[31]_4 @name roll_reg[31]_4 -pinBusAttr roll_sync_reg[0] @name roll_sync_reg[0][28:0] -pinBusAttr roll_sync_reg[0]_0 @name roll_sync_reg[0]_0[28:0] -pinBusAttr rw_reg_i_18_0 @name rw_reg_i_18_0 -pinBusAttr rw_reg_i_18_1 @name rw_reg_i_18_1 -pinBusAttr rw_reg_i_23_2 @name rw_reg_i_23_2 -pinBusAttr rw_reg_i_3_0 @name rw_reg_i_3_0[28:0] -pinBusAttr rw_reg_i_6_0 @name rw_reg_i_6_0 -pinBusAttr rw_reg_i_8_0 @name rw_reg_i_8_0[1:0] -pinBusAttr stale_reg[0]_0 @name stale_reg[0]_0 -pinBusAttr video_startup_count @name video_startup_count -pinBusAttr video_startup_count_reg @name video_startup_count_reg[29:0] -pinBusAttr video_startup_ready_reg_1 @name video_startup_ready_reg_1 -pinBusAttr y @name y -pg 1 -lvl 2 -x 1820 -y 2820
load inst u_auto_zero hud_auto_zero work:hud_auto_zero:NOFILE -attr @cell(#1c1f28) hud_auto_zero -pinBusAttr CO @name CO -pinBusAttr D @name D[1:0] -pinBusAttr DI @name DI[1:0] -pinBusAttr S @name S[3:0] -pinBusAttr done_i_3 @name done_i_3 -pinBusAttr done_i_3_0 @name done_i_3_0 -pinBusAttr done_i_5 @name done_i_5[2:0] -pinBusAttr done_i_5_0 @name done_i_5_0 -pinBusAttr done_i_5_1 @name done_i_5_1 -pinBusAttr done_i_5_2 @name done_i_5_2[2:0] -pinBusAttr near_neutral0_carry__0_1 @name near_neutral0_carry__0_1[3:0] -pinBusAttr near_neutral0_carry__1_0 @name near_neutral0_carry__1_0[1:0] -pinBusAttr near_neutral0_carry__1_1 @name near_neutral0_carry__1_1[3:0] -pinBusAttr near_neutral0_carry__2_0 @name near_neutral0_carry__2_0[3:0] -pinBusAttr near_neutral1_carry__0_0 @name near_neutral1_carry__0_0[3:0] -pinBusAttr near_neutral1_carry__0_1 @name near_neutral1_carry__0_1[3:0] -pinBusAttr near_neutral1_carry__1_0 @name near_neutral1_carry__1_0[1:0] -pinBusAttr near_neutral1_carry__1_1 @name near_neutral1_carry__1_1[3:0] -pinBusAttr near_neutral1_carry__2_0 @name near_neutral1_carry__2_0[3:0] -pinBusAttr near_neutral2_carry__1_0 @name near_neutral2_carry__1_0[3:0] -pinBusAttr near_neutral2_carry__2_0 @name near_neutral2_carry__2_0[3:0] -pinBusAttr near_neutral2_inferred__0/i__carry__0_0 @name near_neutral2_inferred__0/i__carry__0_0[3:0] -pinBusAttr near_neutral2_inferred__0/i__carry__0_1 @name near_neutral2_inferred__0/i__carry__0_1[3:0] -pinBusAttr near_neutral2_inferred__0/i__carry__1_0 @name near_neutral2_inferred__0/i__carry__1_0[1:0] -pinBusAttr near_neutral2_inferred__0/i__carry__1_1 @name near_neutral2_inferred__0/i__carry__1_1[3:0] -pinBusAttr near_neutral2_inferred__0/i__carry__2_0 @name near_neutral2_inferred__0/i__carry__2_0[3:0] -pinBusAttr raw_pitch_reg[25] @name raw_pitch_reg[25] -pinBusAttr raw_pitch_reg[25]_0 @name raw_pitch_reg[25]_0 -pinBusAttr raw_roll_reg[26] @name raw_roll_reg[26] -pg 1 -lvl 1 -x 710 -y 3700
load inst u_render_trig atitude_cordic__parameterized0 work:atitude_cordic__parameterized0:NOFILE -attr @cell(#1c1f28) atitude_cordic__parameterized0 -pinBusAttr E @name E -pinBusAttr Q @name Q[25:0] -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr x_out @name x_out[15:0] -pinBusAttr y_out @name y_out[15:0] -pg 1 -lvl 4 -x 4530 -y 2320
load inst u_attitude_cdc entrada_hud__parameterized0 work:entrada_hud__parameterized0:NOFILE -attr @cell(#1c1f28) entrada_hud__parameterized0 -pinBusAttr D @name D[188:0] -pinBusAttr Q @name Q[209:0] -pinBusAttr retido_reg[238]_0 @name retido_reg[238]_0[20:0] -pg 1 -lvl 3 -x 2930 -y 3220
load inst u_magnetometro hmc5883l_i2c work:hmc5883l_i2c:NOFILE -attr @cell(#1c1f28) hmc5883l_i2c -pinBusAttr CO @name CO -pinBusAttr D @name D[15:0] -pinBusAttr O @name O[3:0] -pinBusAttr Q @name Q -pinBusAttr S @name S[3:0] -pinBusAttr SR @name SR -pinBusAttr age_reg[12] @name age_reg[12][3:0] -pinBusAttr age_reg[16] @name age_reg[16][3:0] -pinBusAttr age_reg[20] @name age_reg[20][3:0] -pinBusAttr age_reg[24] @name age_reg[24][3:0] -pinBusAttr age_reg[25] @name age_reg[25] -pinBusAttr age_reg[25]_0 @name age_reg[25]_0[11:0] -pinBusAttr age_reg[8] @name age_reg[8][3:0] -pinBusAttr amostra_nova_reg_0 @name amostra_nova_reg_0[25:0] -pinBusAttr mag_diagnostics @name mag_diagnostics[30:0] -pinBusAttr mag_x @name mag_x[15:0] -pinBusAttr mag_x_reg[15]_0 @name mag_x_reg[15]_0 -pinBusAttr mag_y @name mag_y[15:0] -pinBusAttr mag_y_reg[15]_0 @name mag_y_reg[15]_0 -pinBusAttr mag_y_reg[15]_1 @name mag_y_reg[15]_1 -pinBusAttr mag_z @name mag_z[15:0] -pinBusAttr mag_z_reg[15]_0 @name mag_z_reg[15]_0 -pinBusAttr mag_z_reg[15]_1 @name mag_z_reg[15]_1 -pinBusAttr max_x_reg[0] @name max_x_reg[0][3:0] -pinBusAttr max_x_reg[15]_i_2_0 @name max_x_reg[15]_i_2_0[15:0] -pinBusAttr max_x_reg[15]_i_2_1 @name max_x_reg[15]_i_2_1[3:0] -pinBusAttr max_y_reg[0] @name max_y_reg[0][3:0] -pinBusAttr max_y_reg[15]_i_2_0 @name max_y_reg[15]_i_2_0[15:0] -pinBusAttr max_y_reg[15]_i_2_1 @name max_y_reg[15]_i_2_1[3:0] -pinBusAttr max_z_reg[0] @name max_z_reg[0][3:0] -pinBusAttr max_z_reg[15]_i_2_0 @name max_z_reg[15]_i_2_0[15:0] -pinBusAttr max_z_reg[15]_i_2_1 @name max_z_reg[15]_i_2_1[3:0] -pinBusAttr min_x_reg[0] @name min_x_reg[0][3:0] -pinBusAttr min_x_reg[15]_i_2_0 @name min_x_reg[15]_i_2_0[15:0] -pinBusAttr min_x_reg[15]_i_2_1 @name min_x_reg[15]_i_2_1[3:0] -pinBusAttr min_y_reg[0] @name min_y_reg[0][3:0] -pinBusAttr min_y_reg[15]_i_2_0 @name min_y_reg[15]_i_2_0[15:0] -pinBusAttr min_y_reg[15]_i_2_1 @name min_y_reg[15]_i_2_1[3:0] -pinBusAttr min_z_reg[0] @name min_z_reg[0][3:0] -pinBusAttr min_z_reg[15]_i_3_0 @name min_z_reg[15]_i_3_0[15:0] -pinBusAttr out @name out -pinBusAttr pipe_unique_reg_0 @name pipe_unique_reg_0 -pinBusAttr pipe_unique_reg_1 @name pipe_unique_reg_1 -pinBusAttr pipe_unique_reg_2 @name pipe_unique_reg_2 -pinBusAttr pipe_unique_reg_i_2_0 @name pipe_unique_reg_i_2_0[14:0] -pinBusAttr pipe_unique_reg_i_3_0 @name pipe_unique_reg_i_3_0[14:0] -pinBusAttr pipe_unique_reg_i_4_0 @name pipe_unique_reg_i_4_0[14:0] -pinBusAttr rx_bytes_reg[0][7]_0 @name rx_bytes_reg[0][7]_0[15:0] -pinBusAttr rx_bytes_reg[4][7]_0 @name rx_bytes_reg[4][7]_0[15:0] -pinBusAttr scl_sync_reg[0]_0 @name scl_sync_reg[0]_0 -pinBusAttr sda_sync_reg[0]_0 @name sda_sync_reg[0]_0 -pg 1 -lvl 5 -x 6420 -y 1300
load inst g_mag_tilt.u_heading heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE -attr @cell(#1c1f28) heading_magnetico_inclinado -pinBusAttr D @name D[15:0] -pinBusAttr E @name E -pinBusAttr O @name O[3:0] -pinBusAttr Q @name Q -pinBusAttr SR @name SR -pinBusAttr age_reg[12]_0 @name age_reg[12]_0[3:0] -pinBusAttr age_reg[16]_0 @name age_reg[16]_0[3:0] -pinBusAttr age_reg[20]_0 @name age_reg[20]_0[3:0] -pinBusAttr age_reg[24]_0 @name age_reg[24]_0[3:0] -pinBusAttr age_reg[25]_0 @name age_reg[25]_0 -pinBusAttr age_reg[25]_1 @name age_reg[25]_1[25:0] -pinBusAttr age_reg[8]_0 @name age_reg[8]_0[3:0] -pinBusAttr bx_reg_0 @name bx_reg_0[15:0] -pinBusAttr by_reg_0 @name by_reg_0[15:0] -pinBusAttr gx_reg[23]_0 @name gx_reg[23]_0[23:0] -pinBusAttr gy_reg[24]_0 @name gy_reg[24]_0[23:0] -pinBusAttr gz_reg[24]_0 @name gz_reg[24]_0[23:0] -pinBusAttr heading_deg_reg[8]_0 @name heading_deg_reg[8]_0[8:0] -pinBusAttr out @name out -pinBusAttr p_0_out @name p_0_out -pinBusAttr y @name y -pg 1 -lvl 6 -x 8010 -y 1080
load inst u_mag_calibration mag_calibration_2d work:mag_calibration_2d:NOFILE -attr @cell(#1c1f28) mag_calibration_2d -pinBusAttr CO @name CO -pinBusAttr E @name E -pinBusAttr Q @name Q[15:0] -pinBusAttr S @name S[3:0] -pinBusAttr SD_SEG[6] @name SD_SEG[6][2:0] -pinBusAttr SD_SEG_OBUF @name SD_SEG_OBUF[6:0] -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr age_reg[25]_2 @name age_reg[25]_2[11:0] -pinBusAttr corrected_sample_reg_0 @name corrected_sample_reg_0 -pinBusAttr corrected_x_reg[15]_0 @name corrected_x_reg[15]_0[15:0] -pinBusAttr corrected_y_reg[15]_0 @name corrected_y_reg[15]_0[15:0] -pinBusAttr coverage_reg[0]_0 @name coverage_reg[0]_0 -pinBusAttr dados_reg[0] @name dados_reg[0] -pinBusAttr dados_reg[0]_0 @name dados_reg[0]_0 -pinBusAttr estado @name estado[2:0] -pinBusAttr heading_deg_reg[0] @name heading_deg_reg[0] -pinBusAttr inicio_operacao_reg[3] @name inicio_operacao_reg[3] -pinBusAttr inicio_operacao_reg[3]_0 @name inicio_operacao_reg[3]_0 -pinBusAttr last_x_reg[14]_0 @name last_x_reg[14]_0[14:0] -pinBusAttr last_x_reg[15]_0 @name last_x_reg[15]_0 -pinBusAttr last_y_reg[14]_0 @name last_y_reg[14]_0[14:0] -pinBusAttr last_y_reg[15]_0 @name last_y_reg[15]_0 -pinBusAttr last_z_reg[14]_0 @name last_z_reg[14]_0[14:0] -pinBusAttr last_z_reg[15]_0 @name last_z_reg[15]_0 -pinBusAttr max_x_reg[15]_0 @name max_x_reg[15]_0[15:0] -pinBusAttr max_x_reg[15]_1 @name max_x_reg[15]_1[3:0] -pinBusAttr max_x_reg[15]_2 @name max_x_reg[15]_2[15:0] -pinBusAttr max_x_reg[7]_0 @name max_x_reg[7]_0[3:0] -pinBusAttr max_y_reg[0]_0 @name max_y_reg[0]_0 -pinBusAttr max_y_reg[15]_0 @name max_y_reg[15]_0[15:0] -pinBusAttr max_y_reg[15]_1 @name max_y_reg[15]_1[3:0] -pinBusAttr max_y_reg[15]_2 @name max_y_reg[15]_2[15:0] -pinBusAttr max_y_reg[7]_0 @name max_y_reg[7]_0[3:0] -pinBusAttr max_z_reg[0]_0 @name max_z_reg[0]_0 -pinBusAttr max_z_reg[15]_0 @name max_z_reg[15]_0[15:0] -pinBusAttr max_z_reg[15]_1 @name max_z_reg[15]_1[3:0] -pinBusAttr max_z_reg[7]_0 @name max_z_reg[7]_0[3:0] -pinBusAttr min_x_reg[0]_0 @name min_x_reg[0]_0 -pinBusAttr min_x_reg[15]_0 @name min_x_reg[15]_0[15:0] -pinBusAttr min_x_reg[15]_1 @name min_x_reg[15]_1[3:0] -pinBusAttr min_x_reg[7]_0 @name min_x_reg[7]_0[3:0] -pinBusAttr min_y_reg[0]_0 @name min_y_reg[0]_0 -pinBusAttr min_y_reg[15]_0 @name min_y_reg[15]_0[15:0] -pinBusAttr min_y_reg[15]_1 @name min_y_reg[15]_1[3:0] -pinBusAttr min_y_reg[7]_0 @name min_y_reg[7]_0[3:0] -pinBusAttr min_z_reg[0]_0 @name min_z_reg[0]_0 -pinBusAttr min_z_reg[15]_0 @name min_z_reg[15]_0[3:0] -pinBusAttr out @name out -pinBusAttr p_0_out @name p_0_out -pinBusAttr pipe_z_reg[15]_0 @name pipe_z_reg[15]_0[15:0] -pinBusAttr prod_x_reg_1 @name prod_x_reg_1[15:0] -pinBusAttr prod_y_reg_0 @name prod_y_reg_0[15:0] -pinBusAttr profile @name profile[59:0] -pinBusAttr sd_segments_normal @name sd_segments_normal[6:0] -pinBusAttr state_reg[3]_0 @name state_reg[3]_0 -pg 1 -lvl 4 -x 4530 -y 160
load inst u_mag_cal_planar heading_magnetico work:heading_magnetico:NOFILE -attr @cell(#1c1f28) heading_magnetico -pinBusAttr E @name E -pinBusAttr Q @name Q[15:0] -pinBusAttr corrigido_y_reg[15]_0 @name corrigido_y_reg[15]_0[15:0] -pinBusAttr estado @name estado[2:0] -pinBusAttr heading_deg_reg[8]_0 @name heading_deg_reg[8]_0[8:0] -pg 1 -lvl 3 -x 2930 -y 1620
load net clk_hud -attr @style dashed -pin g_mag_tilt.u_heading clk_hud -pin u_attitude_cdc clk_hud -pin u_auto_zero clk_hud -pin u_mag_cal_planar clk_hud -pin u_mag_calibration clk_hud -pin u_magnetometro clk_hud -pin u_render_trig clk_hud -pin u_sensor clk_hud -pin u_vector clk_hud
netloc clk_hud 1 0 6 100 2670 950 2550 2440 2270 3370 2110 5410 1070 7750J
load net g_mag_tilt.u_heading_n_12 -attr @rip age_reg[12]_0[0] -pin g_mag_tilt.u_heading age_reg[12]_0[0] -pin u_magnetometro age_reg[12][0]
load net u_mag_calibration_n_149 -attr @rip max_x_reg[7]_0[2] -pin u_mag_calibration max_x_reg[7]_0[2] -pin u_magnetometro max_x_reg[15]_i_2_1[2]
load net u_mag_calibration_n_119 -attr @rip max_y_reg[15]_0[0] -pin u_mag_calibration max_y_reg[15]_0[0] -pin u_magnetometro max_y_reg[15]_i_2_0[0]
load net p_2_in_4 -pin g_mag_tilt.u_heading p_2_in -pin u_magnetometro p_2_in
netloc p_2_in_4 1 5 1 7590 1470n
load net state4 -pin u_mag_calibration state4 -pin u_magnetometro state4
netloc state4 1 3 3 4130 2270 5110J 2490 6770
load net u_vector_n_152 -attr @rip raw_roll_reg[22]_0[3] -pin u_auto_zero near_neutral2_inferred__0/i__carry__2_0[3] -pin u_vector raw_roll_reg[22]_0[3]
load net u_vector_n_120 -attr @rip raw_pitch_reg[25]_0[1] -pin u_auto_zero done_i_5_2[1] -pin u_vector raw_pitch_reg[25]_0[1]
load net u_vector_n_233 -attr @rip raw_roll_reg[6]_1[1] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_1[1] -pin u_vector raw_roll_reg[6]_1[1]
load net u_magnetometro_n_147 -attr @rip D[15] -pin g_mag_tilt.u_heading D[15] -pin u_magnetometro D[15]
load net u_mag_calibration_n_88 -attr @rip min_y_reg[15]_0[7] -pin u_mag_calibration min_y_reg[15]_0[7] -pin u_magnetometro min_y_reg[15]_i_2_0[7]
load net u_mag_calibration_n_57 -attr @rip max_z_reg[15]_0[14] -pin u_mag_calibration max_z_reg[15]_0[14] -pin u_magnetometro max_z_reg[15]_i_2_0[14]
load net u_magnetometro_n_21 -attr @rip amostra_nova_reg_0[5] -pin g_mag_tilt.u_heading age_reg[25]_1[5] -pin u_magnetometro amostra_nova_reg_0[5]
load net u_magnetometro_n_99 -pin u_mag_calibration age_reg[12]_0 -pin u_magnetometro amostra_nova_reg_8
netloc u_magnetometro_n_99 1 3 3 3550 2990 NJ 2990 7210
load net compass_gravity_z[17] -attr @rip Q[17] -pin g_mag_tilt.u_heading gz_reg[24]_0[17] -pin u_vector Q[17]
load net compass_gravity_x[1] -attr @rip gravity_x_reg[23]_0[1] -pin g_mag_tilt.u_heading gx_reg[23]_0[1] -pin u_vector gravity_x_reg[23]_0[1]
load net compass_gravity_y[8] -attr @rip gravity_y_reg[23]_0[8] -pin g_mag_tilt.u_heading gy_reg[24]_0[8] -pin u_vector gravity_y_reg[23]_0[8]
load net last_z[6] -attr @rip last_z_reg[14]_0[6] -pin u_mag_calibration last_z_reg[14]_0[6] -pin u_magnetometro pipe_unique_reg_i_2_0[6]
load net last_x[4] -attr @rip last_x_reg[14]_0[4] -pin u_mag_calibration last_x_reg[14]_0[4] -pin u_magnetometro pipe_unique_reg_i_4_0[4]
load net mag_corrected_y[3] -attr @rip corrected_y_reg[15]_0[3] -pin u_mag_cal_planar corrigido_y_reg[15]_0[3] -pin u_mag_calibration corrected_y_reg[15]_0[3]
load net mag_y[6] -attr @rip mag_y[6] -pin u_mag_calibration max_y_reg[15]_2[6] -pin u_magnetometro mag_y[6]
load net mpu_raw_ay[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[72] -pin u_sensor accel_x_reg[15]_0[72] -pin u_vector a_reg[0][15]_0[72]
load net mpu_gyro_z[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[8] -pin u_sensor accel_x_reg[15]_0[8] -pin u_vector a_reg[0][15]_0[8]
load net mpu_raw_gy[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[24] -pin u_sensor accel_x_reg[15]_0[24] -pin u_vector a_reg[0][15]_0[24]
load net vector_calibration_debug[14] -attr @rip D[107] -pin u_attitude_cdc D[180] -pin u_vector D[107]
load net vector_pitch[31] -attr @style dashed -attr @rip roll_reg[31]_0[12] -pin u_attitude_cdc retido_reg[238]_0[12] -pin u_vector roll_reg[31]_0[12]
load net vector_roll[7] -attr @rip D[19] -pin u_attitude_cdc D[91] -pin u_vector D[19]
load net vector_raw_roll[3] -attr @rip D[65] -pin u_attitude_cdc D[137] -pin u_vector D[65]
load net samples_reg[5][6] -attr @rip samples_reg[4][7]_0[6] -pin u_sensor samples_reg[4][7]_0[6] -pin u_vector p_1_in__0_0[6]
load net samples_reg[2][1] -attr @rip samples_reg[2][7]_0[9] -pin u_sensor samples_reg[2][7]_0[9] -pin u_vector p_1_in_1[9]
load net rx_bytes_reg[4]_2[5] -attr @rip rx_bytes_reg[4][7]_0[13] -pin g_mag_tilt.u_heading by_reg_0[13] -pin u_mag_calibration prod_y_reg_0[13] -pin u_magnetometro rx_bytes_reg[4][7]_0[13]
load net u_mag_calibration_n_15 -attr @style dashed -pin u_mag_calibration age_reg[25]_1 -pin u_magnetometro age_reg[23] -pin u_vector reason[0]_i_7
netloc u_mag_calibration_n_15 1 1 4 1510 2090 NJ 2090 NJ 2090 5470
load net g_mag_tilt.u_heading_n_13 -attr @rip age_reg[16]_0[3] -pin g_mag_tilt.u_heading age_reg[16]_0[3] -pin u_magnetometro age_reg[16][3]
load net u_mag_calibration_n_12 -pin u_mag_calibration state_reg[0]_0 -pin u_magnetometro state_reg[3]
netloc u_mag_calibration_n_12 1 4 1 5250 1410n
load net u_vector_n_153 -attr @rip raw_roll_reg[22]_0[2] -pin u_auto_zero near_neutral2_inferred__0/i__carry__2_0[2] -pin u_vector raw_roll_reg[22]_0[2]
load net u_vector_n_121 -attr @rip raw_pitch_reg[25]_0[0] -pin u_auto_zero done_i_5_2[0] -pin u_vector raw_pitch_reg[25]_0[0]
load net u_vector_n_234 -attr @rip raw_roll_reg[6]_1[0] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_1[0] -pin u_vector raw_roll_reg[6]_1[0]
load net u_magnetometro_n_148 -attr @rip D[14] -pin g_mag_tilt.u_heading D[14] -pin u_magnetometro D[14]
load net u_mag_calibration_n_89 -attr @rip min_y_reg[15]_0[6] -pin u_mag_calibration min_y_reg[15]_0[6] -pin u_magnetometro min_y_reg[15]_i_2_0[6]
load net u_mag_calibration_n_58 -attr @rip max_z_reg[15]_0[13] -pin u_mag_calibration max_z_reg[15]_0[13] -pin u_magnetometro max_z_reg[15]_i_2_0[13]
load net u_magnetometro_n_22 -attr @rip amostra_nova_reg_0[4] -pin g_mag_tilt.u_heading age_reg[25]_1[4] -pin u_magnetometro amostra_nova_reg_0[4]
load net compass_gravity_z[18] -attr @rip Q[18] -pin g_mag_tilt.u_heading gz_reg[24]_0[18] -pin u_vector Q[18]
load net compass_gravity_x[2] -attr @rip gravity_x_reg[23]_0[2] -pin g_mag_tilt.u_heading gx_reg[23]_0[2] -pin u_vector gravity_x_reg[23]_0[2]
load net compass_gravity_y[10] -attr @rip gravity_y_reg[23]_0[10] -pin g_mag_tilt.u_heading gy_reg[24]_0[10] -pin u_vector gravity_y_reg[23]_0[10]
load net last_z[9] -attr @rip last_z_reg[14]_0[9] -pin u_mag_calibration last_z_reg[14]_0[9] -pin u_magnetometro pipe_unique_reg_i_2_0[9]
load net last_x[5] -attr @rip last_x_reg[14]_0[5] -pin u_mag_calibration last_x_reg[14]_0[5] -pin u_magnetometro pipe_unique_reg_i_4_0[5]
load net mag_corrected_y[4] -attr @rip corrected_y_reg[15]_0[4] -pin u_mag_cal_planar corrigido_y_reg[15]_0[4] -pin u_mag_calibration corrected_y_reg[15]_0[4]
load net mag_y[9] -attr @rip mag_y[9] -pin u_mag_calibration max_y_reg[15]_2[9] -pin u_magnetometro mag_y[9]
load net mpu_gyro_z[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[10] -pin u_sensor accel_x_reg[15]_0[10] -pin u_vector a_reg[0][15]_0[10]
load net mpu_raw_ay[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[74] -pin u_sensor accel_x_reg[15]_0[74] -pin u_vector a_reg[0][15]_0[74]
load net mpu_raw_gy[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[26] -pin u_sensor accel_x_reg[15]_0[26] -pin u_vector a_reg[0][15]_0[26]
load net samples_reg[2][2] -attr @rip samples_reg[2][7]_0[10] -pin u_sensor samples_reg[2][7]_0[10] -pin u_vector p_1_in_1[10]
load net vector_calibration_debug[15] -attr @rip D[108] -pin u_attitude_cdc D[181] -pin u_vector D[108]
load net vector_raw_roll[4] -attr @rip D[66] -pin u_attitude_cdc D[138] -pin u_vector D[66]
load net vector_roll[8] -attr @rip D[20] -pin u_attitude_cdc D[92] -pin u_vector D[20]
load net rx_bytes_reg[4]_2[6] -attr @rip rx_bytes_reg[4][7]_0[14] -pin g_mag_tilt.u_heading by_reg_0[14] -pin u_mag_calibration prod_y_reg_0[14] -pin u_magnetometro rx_bytes_reg[4][7]_0[14]
load net sensor_ok -attr @style dashed -attr @rip D[0] -pin u_attitude_cdc D[165] -pin u_sensor D[0] -pin u_vector video_startup_ready_reg_1[0]
netloc sensor_ok 1 1 2 1250 2530 2660J
load net g_mag_tilt.u_heading_n_10 -attr @rip age_reg[12]_0[2] -pin g_mag_tilt.u_heading age_reg[12]_0[2] -pin u_magnetometro age_reg[12][2]
load net u_mag_calibration_n_117 -attr @rip max_y_reg[15]_0[2] -pin u_mag_calibration max_y_reg[15]_0[2] -pin u_magnetometro max_y_reg[15]_i_2_0[2]
load net u_mag_calibration_n_147 -attr @rip min_x_reg[15]_1[0] -pin u_mag_calibration min_x_reg[15]_1[0] -pin u_magnetometro min_x_reg[0][0]
load net u_mag_calibration_n_255 -pin g_mag_tilt.u_heading g_idade[2].idade_reg[0]_0 -pin u_mag_calibration valido_reg
netloc u_mag_calibration_n_255 1 4 2 5530 1090 7290J
load net u_vector_n_117 -pin u_sensor stale_reg_0_sp_1 -pin u_vector FSM_sequential_phase_reg[3]_0
netloc u_vector_n_117 1 0 3 60 2630 NJ 2630 2400
load net u_magnetometro_n_97 -pin u_mag_calibration age_reg[23]_0 -pin u_magnetometro amostra_nova_reg_6
netloc u_magnetometro_n_97 1 3 3 3630 2950 NJ 2950 7250
load net u_vector_n_150 -attr @rip raw_roll_reg[14]_0[1] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_1[1] -pin u_vector raw_roll_reg[14]_0[1]
load net u_vector_n_231 -attr @rip raw_roll_reg[6]_1[3] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_1[3] -pin u_vector raw_roll_reg[6]_1[3]
load net u_magnetometro_n_13 -attr @rip amostra_nova_reg_0[13] -pin g_mag_tilt.u_heading age_reg[25]_1[13] -pin u_magnetometro amostra_nova_reg_0[13]
load net u_mag_calibration_n_86 -attr @rip min_y_reg[15]_0[9] -pin u_mag_calibration min_y_reg[15]_0[9] -pin u_magnetometro min_y_reg[15]_i_2_0[9]
load net u_mag_calibration_n_55 -attr @rip max_z_reg[7]_0[0] -pin u_mag_calibration max_z_reg[7]_0[0] -pin u_magnetometro max_z_reg[15]_i_2_1[0]
load net u_magnetometro_n_2 -attr @rip amostra_nova_reg_0[24] -pin g_mag_tilt.u_heading age_reg[25]_1[24] -pin u_magnetometro amostra_nova_reg_0[24]
load net compass_gravity_z[15] -attr @rip Q[15] -pin g_mag_tilt.u_heading gz_reg[24]_0[15] -pin u_vector Q[15]
load net compass_gravity_y[9] -attr @rip gravity_y_reg[23]_0[9] -pin g_mag_tilt.u_heading gy_reg[24]_0[9] -pin u_vector gravity_y_reg[23]_0[9]
load net last_z[4] -attr @rip last_z_reg[14]_0[4] -pin u_mag_calibration last_z_reg[14]_0[4] -pin u_magnetometro pipe_unique_reg_i_2_0[4]
load net last_x[2] -attr @rip last_x_reg[14]_0[2] -pin u_mag_calibration last_x_reg[14]_0[2] -pin u_magnetometro pipe_unique_reg_i_4_0[2]
load net mag_corrected_y[1] -attr @rip corrected_y_reg[15]_0[1] -pin u_mag_cal_planar corrigido_y_reg[15]_0[1] -pin u_mag_calibration corrected_y_reg[15]_0[1]
load net mag_y[4] -attr @rip mag_y[4] -pin u_mag_calibration max_y_reg[15]_2[4] -pin u_magnetometro mag_y[4]
load net mpu_raw_gy[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[25] -pin u_sensor accel_x_reg[15]_0[25] -pin u_vector a_reg[0][15]_0[25]
load net mpu_gyro_z[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[9] -pin u_sensor accel_x_reg[15]_0[9] -pin u_vector a_reg[0][15]_0[9]
load net mpu_raw_ay[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[73] -pin u_sensor accel_x_reg[15]_0[73] -pin u_vector a_reg[0][15]_0[73]
load net samples_reg[5][4] -attr @rip samples_reg[4][7]_0[4] -pin u_sensor samples_reg[4][7]_0[4] -pin u_vector p_1_in__0_0[4]
load net samples_reg[1][7] -attr @rip B[7] -pin u_sensor B[7] -pin u_vector B[7]
load net vector_calibration_debug[12] -attr @rip D[105] -pin u_attitude_cdc D[178] -pin u_vector D[105]
load net vector_raw_roll[1] -attr @rip D[63] -pin u_attitude_cdc D[135] -pin u_vector D[63]
load net vector_pitch[24] -attr @style dashed -attr @rip roll_reg[31]_0[10] -pin u_attitude_cdc retido_reg[238]_0[10] -pin u_vector roll_reg[31]_0[10]
load net vector_roll[6] -attr @rip D[18] -pin u_attitude_cdc D[90] -pin u_vector D[18]
load net rx_bytes_reg[4]_2[3] -attr @rip rx_bytes_reg[4][7]_0[11] -pin g_mag_tilt.u_heading by_reg_0[11] -pin u_mag_calibration prod_y_reg_0[11] -pin u_magnetometro rx_bytes_reg[4][7]_0[11]
load net MAG_LED_OBUF -attr @style dashed -pin g_mag_tilt.u_heading MAG_LED_OBUF -pin u_mag_calibration MAG_LED_OBUF -pin u_magnetometro MAG_LED_OBUF -pin u_vector MAG_LED_OBUF
netloc MAG_LED_OBUF 1 1 5 1610 1510 NJ 1510 3170 10 NJ 10 7350
load net g_mag_tilt.u_heading_n_11 -attr @rip age_reg[12]_0[1] -pin g_mag_tilt.u_heading age_reg[12]_0[1] -pin u_magnetometro age_reg[12][1]
load net u_mag_calibration_n_148 -attr @rip max_x_reg[7]_0[3] -pin u_mag_calibration max_x_reg[7]_0[3] -pin u_magnetometro max_x_reg[15]_i_2_1[3]
load net u_mag_calibration_n_118 -attr @rip max_y_reg[15]_0[1] -pin u_mag_calibration max_y_reg[15]_0[1] -pin u_magnetometro max_y_reg[15]_i_2_0[1]
load net u_mag_calibration_n_258 -attr @rip corrected_sample_reg_0[0] -pin u_mag_cal_planar E[0] -pin u_mag_calibration corrected_sample_reg_0[0]
netloc u_mag_calibration_n_258 1 2 3 2440 1530 3450J 1790 5130
load net sensor_ok0 -pin u_mag_cal_planar sensor_ok0 -pin u_mag_calibration sensor_ok0
netloc sensor_ok0 1 2 3 2700 1970 3470J 1950 4950
load net u_vector_n_151 -attr @rip raw_roll_reg[14]_0[0] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_1[0] -pin u_vector raw_roll_reg[14]_0[0]
load net u_vector_n_119 -attr @rip raw_pitch_reg[25]_0[2] -pin u_auto_zero done_i_5_2[2] -pin u_vector raw_pitch_reg[25]_0[2]
load net u_vector_n_232 -attr @rip raw_roll_reg[6]_1[2] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_1[2] -pin u_vector raw_roll_reg[6]_1[2]
load net u_magnetometro_n_14 -attr @rip amostra_nova_reg_0[12] -pin g_mag_tilt.u_heading age_reg[25]_1[12] -pin u_magnetometro amostra_nova_reg_0[12]
load net u_magnetometro_n_20 -attr @rip amostra_nova_reg_0[6] -pin g_mag_tilt.u_heading age_reg[25]_1[6] -pin u_magnetometro amostra_nova_reg_0[6]
load net u_magnetometro_n_98 -pin u_mag_calibration age_reg[7]_0 -pin u_magnetometro amostra_nova_reg_7
netloc u_magnetometro_n_98 1 3 3 3530 2970 NJ 2970 7230
load net u_mag_calibration_n_87 -attr @rip min_y_reg[15]_0[8] -pin u_mag_calibration min_y_reg[15]_0[8] -pin u_magnetometro min_y_reg[15]_i_2_0[8]
load net u_mag_calibration_n_56 -attr @rip max_z_reg[15]_0[15] -pin u_mag_calibration max_z_reg[15]_0[15] -pin u_magnetometro max_z_reg[15]_i_2_0[15]
load net compass_gravity_z[16] -attr @rip Q[16] -pin g_mag_tilt.u_heading gz_reg[24]_0[16] -pin u_vector Q[16]
load net compass_gravity_x[0] -attr @rip gravity_x_reg[23]_0[0] -pin g_mag_tilt.u_heading gx_reg[23]_0[0] -pin u_vector gravity_x_reg[23]_0[0]
load net compass_gravity_y[7] -attr @rip gravity_y_reg[23]_0[7] -pin g_mag_tilt.u_heading gy_reg[24]_0[7] -pin u_vector gravity_y_reg[23]_0[7]
load net last_z[5] -attr @rip last_z_reg[14]_0[5] -pin u_mag_calibration last_z_reg[14]_0[5] -pin u_magnetometro pipe_unique_reg_i_2_0[5]
load net last_x[3] -attr @rip last_x_reg[14]_0[3] -pin u_mag_calibration last_x_reg[14]_0[3] -pin u_magnetometro pipe_unique_reg_i_4_0[3]
load net heading_approved_deg[0] -attr @rip heading_deg_reg[8]_0[0] -pin g_mag_tilt.u_heading heading_deg_reg[8]_0[0] -pin u_mag_calibration dados_reg[0]_0[0]
netloc heading_approved_deg[0] 1 3 4 4310 50 NJ 50 NJ 50 8500
load net mag_corrected_y[2] -attr @rip corrected_y_reg[15]_0[2] -pin u_mag_cal_planar corrigido_y_reg[15]_0[2] -pin u_mag_calibration corrected_y_reg[15]_0[2]
load net mag_y[5] -attr @rip mag_y[5] -pin u_mag_calibration max_y_reg[15]_2[5] -pin u_magnetometro mag_y[5]
load net mpu_gyro_z[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[7] -pin u_sensor accel_x_reg[15]_0[7] -pin u_vector a_reg[0][15]_0[7]
load net mpu_raw_ay[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[71] -pin u_sensor accel_x_reg[15]_0[71] -pin u_vector a_reg[0][15]_0[71]
load net mpu_raw_gy[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[23] -pin u_sensor accel_x_reg[15]_0[23] -pin u_vector a_reg[0][15]_0[23]
load net samples_reg[5][5] -attr @rip samples_reg[4][7]_0[5] -pin u_sensor samples_reg[4][7]_0[5] -pin u_vector p_1_in__0_0[5]
load net vector_calibration_debug[13] -attr @rip D[106] -pin u_attitude_cdc D[179] -pin u_vector D[106]
load net vector_roll[9] -attr @rip D[21] -pin u_attitude_cdc D[93] -pin u_vector D[21]
load net vector_raw_roll[2] -attr @rip D[64] -pin u_attitude_cdc D[136] -pin u_vector D[64]
load net vector_pitch[25] -attr @style dashed -attr @rip roll_reg[31]_0[11] -pin u_attitude_cdc retido_reg[238]_0[11] -pin u_vector roll_reg[31]_0[11]
load net samples_reg[2][0] -attr @rip samples_reg[2][7]_0[8] -pin u_sensor samples_reg[2][7]_0[8] -pin u_vector p_1_in_1[8]
load net rx_bytes_reg[4]_2[4] -attr @rip rx_bytes_reg[4][7]_0[12] -pin g_mag_tilt.u_heading by_reg_0[12] -pin u_mag_calibration prod_y_reg_0[12] -pin u_magnetometro rx_bytes_reg[4][7]_0[12]
load net u_mag_calibration_n_122 -attr @rip max_y_reg[15]_1[1] -pin u_mag_calibration max_y_reg[15]_1[1] -pin u_magnetometro max_y_reg[0][1]
load net u_mag_calibration_n_29 -attr @rip S[2] -pin u_mag_calibration S[2] -pin u_magnetometro S[2]
load net g_mag_tilt.u_heading_n_16 -attr @rip age_reg[16]_0[0] -pin g_mag_tilt.u_heading age_reg[16]_0[0] -pin u_magnetometro age_reg[16][0]
load net u_mag_calibration_n_152 -attr @rip max_x_reg[15]_0[15] -pin u_mag_calibration max_x_reg[15]_0[15] -pin u_magnetometro max_x_reg[15]_i_2_0[15]
load net u_vector_n_124 -attr @rip raw_roll_reg[26]_1[1] -pin u_auto_zero done_i_5[1] -pin u_vector raw_roll_reg[26]_1[1]
load net u_vector_n_156 -attr @rip raw_roll_reg[24]_0[0] -pin u_auto_zero done_i_3_0[0] -pin u_vector raw_roll_reg[24]_0[0]
netloc u_vector_n_156 1 0 3 160 4470 NJ 4470 2320
load net u_magnetometro_n_150 -attr @rip D[12] -pin g_mag_tilt.u_heading D[12] -pin u_magnetometro D[12]
load net u_magnetometro_n_25 -attr @rip amostra_nova_reg_0[1] -pin g_mag_tilt.u_heading age_reg[25]_1[1] -pin u_magnetometro amostra_nova_reg_0[1]
load net u_mag_calibration_n_61 -attr @rip max_z_reg[15]_0[10] -pin u_mag_calibration max_z_reg[15]_0[10] -pin u_magnetometro max_z_reg[15]_i_2_0[10]
load net u_mag_calibration_n_91 -attr @rip min_y_reg[15]_0[4] -pin u_mag_calibration min_y_reg[15]_0[4] -pin u_magnetometro min_y_reg[15]_i_2_0[4]
load net compass_gravity_z[21] -attr @rip Q[21] -pin g_mag_tilt.u_heading gz_reg[24]_0[21] -pin u_vector Q[21]
load net compass_gravity_x[5] -attr @rip gravity_x_reg[23]_0[5] -pin g_mag_tilt.u_heading gx_reg[23]_0[5] -pin u_vector gravity_x_reg[23]_0[5]
load net compass_gravity_y[13] -attr @rip gravity_y_reg[23]_0[13] -pin g_mag_tilt.u_heading gy_reg[24]_0[13] -pin u_vector gravity_y_reg[23]_0[13]
load net last_z[10] -attr @rip last_z_reg[14]_0[10] -pin u_mag_calibration last_z_reg[14]_0[10] -pin u_magnetometro pipe_unique_reg_i_2_0[10]
load net last_x[7] -attr @rip last_x_reg[14]_0[7] -pin u_mag_calibration last_x_reg[14]_0[7] -pin u_magnetometro pipe_unique_reg_i_4_0[7]
load net mag_corrected_y[9] -attr @rip corrected_y_reg[15]_0[9] -pin u_mag_cal_planar corrigido_y_reg[15]_0[9] -pin u_mag_calibration corrected_y_reg[15]_0[9]
load net mag_y[10] -attr @rip mag_y[10] -pin u_mag_calibration max_y_reg[15]_2[10] -pin u_magnetometro mag_y[10]
load net mpu_gyro_z[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[13] -pin u_sensor accel_x_reg[15]_0[13] -pin u_vector a_reg[0][15]_0[13]
load net mpu_raw_ay[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[77] -pin u_sensor accel_x_reg[15]_0[77] -pin u_vector a_reg[0][15]_0[77]
load net mpu_raw_gy[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[29] -pin u_sensor accel_x_reg[15]_0[29] -pin u_vector a_reg[0][15]_0[29]
load net vector_raw_pitch[2] -attr @rip D[38] -pin u_attitude_cdc D[110] -pin u_vector D[38]
load net samples_reg[2][5] -attr @rip samples_reg[2][7]_0[13] -pin u_sensor samples_reg[2][7]_0[13] -pin u_vector p_1_in_1[13]
load net vector_raw_roll[9] -attr @rip D[71] -pin u_attitude_cdc D[143] -pin u_vector D[71]
load net vector_roll[12] -attr @style dashed -attr @rip roll_reg[31]_0[17] -pin u_attitude_cdc retido_reg[238]_0[17] -pin u_vector roll_reg[31]_0[17]
load net vector_calibration_debug[18] -attr @rip D[111] -pin u_attitude_cdc D[184] -pin u_vector D[111]
load net rx_bytes_reg[5]_1[0] -attr @rip rx_bytes_reg[4][7]_0[0] -pin g_mag_tilt.u_heading by_reg_0[0] -pin u_mag_calibration prod_y_reg_0[0] -pin u_magnetometro rx_bytes_reg[4][7]_0[0]
load net u_mag_calibration_n_123 -attr @rip max_y_reg[15]_1[0] -pin u_mag_calibration max_y_reg[15]_1[0] -pin u_magnetometro max_y_reg[0][0]
load net u_mag_calibration_n_30 -attr @rip S[1] -pin u_mag_calibration S[1] -pin u_magnetometro S[1]
load net g_mag_tilt.u_heading_n_17 -attr @rip age_reg[20]_0[3] -pin g_mag_tilt.u_heading age_reg[20]_0[3] -pin u_magnetometro age_reg[20][3]
load net u_mag_calibration_n_153 -attr @rip max_x_reg[15]_0[14] -pin u_mag_calibration max_x_reg[15]_0[14] -pin u_magnetometro max_x_reg[15]_i_2_0[14]
load net u_vector_n_125 -attr @rip raw_roll_reg[26]_1[0] -pin u_auto_zero done_i_5[0] -pin u_vector raw_roll_reg[26]_1[0]
load net u_vector_n_206 -attr @rip raw_pitch_reg[24]_1[3] -pin u_auto_zero near_neutral0_carry__2_0[3] -pin u_vector raw_pitch_reg[24]_1[3]
load net u_magnetometro_n_151 -attr @rip D[11] -pin g_mag_tilt.u_heading D[11] -pin u_magnetometro D[11]
load net u_magnetometro_n_26 -attr @rip amostra_nova_reg_0[0] -pin g_mag_tilt.u_heading age_reg[25]_1[0] -pin u_magnetometro amostra_nova_reg_0[0]
load net u_mag_calibration_n_62 -attr @rip max_z_reg[15]_0[9] -pin u_mag_calibration max_z_reg[15]_0[9] -pin u_magnetometro max_z_reg[15]_i_2_0[9]
load net u_mag_calibration_n_92 -attr @rip min_y_reg[15]_0[3] -pin u_mag_calibration min_y_reg[15]_0[3] -pin u_magnetometro min_y_reg[15]_i_2_0[3]
load net compass_gravity_z[22] -attr @rip Q[22] -pin g_mag_tilt.u_heading gz_reg[24]_0[22] -pin u_vector Q[22]
load net compass_gravity_x[6] -attr @rip gravity_x_reg[23]_0[6] -pin g_mag_tilt.u_heading gx_reg[23]_0[6] -pin u_vector gravity_x_reg[23]_0[6]
load net compass_gravity_y[14] -attr @rip gravity_y_reg[23]_0[14] -pin g_mag_tilt.u_heading gy_reg[24]_0[14] -pin u_vector gravity_y_reg[23]_0[14]
load net last_z[11] -attr @rip last_z_reg[14]_0[11] -pin u_mag_calibration last_z_reg[14]_0[11] -pin u_magnetometro pipe_unique_reg_i_2_0[11]
load net last_x[8] -attr @rip last_x_reg[14]_0[8] -pin u_mag_calibration last_x_reg[14]_0[8] -pin u_magnetometro pipe_unique_reg_i_4_0[8]
load net mag_corrected_y[7] -attr @rip corrected_y_reg[15]_0[7] -pin u_mag_cal_planar corrigido_y_reg[15]_0[7] -pin u_mag_calibration corrected_y_reg[15]_0[7]
load net mag_y[11] -attr @rip mag_y[11] -pin u_mag_calibration max_y_reg[15]_2[11] -pin u_magnetometro mag_y[11]
load net mpu_accel_z[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[48] -pin u_sensor accel_x_reg[15]_0[48] -pin u_vector a_reg[0][15]_0[48]
load net mpu_gyro_z[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[14] -pin u_sensor accel_x_reg[15]_0[14] -pin u_vector a_reg[0][15]_0[14]
load net mpu_raw_ay[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[78] -pin u_sensor accel_x_reg[15]_0[78] -pin u_vector a_reg[0][15]_0[78]
load net mpu_raw_gy[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[30] -pin u_sensor accel_x_reg[15]_0[30] -pin u_vector a_reg[0][15]_0[30]
load net vector_calibration_debug[19] -attr @rip D[112] -pin u_attitude_cdc D[185] -pin u_vector D[112]
load net samples_reg[2][6] -attr @rip samples_reg[2][7]_0[14] -pin u_sensor samples_reg[2][7]_0[14] -pin u_vector p_1_in_1[14]
load net vector_raw_pitch[3] -attr @rip D[39] -pin u_attitude_cdc D[111] -pin u_vector D[39]
load net vector_roll[13] -attr @style dashed -attr @rip roll_reg[31]_0[18] -pin u_attitude_cdc retido_reg[238]_0[18] -pin u_vector roll_reg[31]_0[18]
load net vector_raw_roll[7] -attr @rip D[69] -pin u_attitude_cdc D[141] -pin u_vector D[69]
load net rx_bytes_reg[5]_1[1] -attr @rip rx_bytes_reg[4][7]_0[1] -pin g_mag_tilt.u_heading by_reg_0[1] -pin u_mag_calibration prod_y_reg_0[1] -pin u_magnetometro rx_bytes_reg[4][7]_0[1]
load net inicio_operacao_reg_n_0_[3] -attr @style dashed -pin g_mag_tilt.u_heading y_reg[0] -pin u_mag_calibration g_idade[2].idade_reg[25] -pin u_magnetometro repeats_reg[15] -pin u_render_trig render_sine_ready_reg[0] -pin u_vector blocked_seen_reg[12]_0
netloc inicio_operacao_reg_n_0_[3] 1 1 5 1590 1890 NJ 1890 3190 2530 5050 2370 7810J
load net g_mag_tilt.u_heading_n_14 -attr @rip age_reg[16]_0[2] -pin g_mag_tilt.u_heading age_reg[16]_0[2] -pin u_magnetometro age_reg[16][2]
load net u_mag_calibration_n_150 -attr @rip max_x_reg[7]_0[1] -pin u_mag_calibration max_x_reg[7]_0[1] -pin u_magnetometro max_x_reg[15]_i_2_1[1]
load net u_mag_calibration_n_120 -attr @rip max_y_reg[15]_1[3] -pin u_mag_calibration max_y_reg[15]_1[3] -pin u_magnetometro max_y_reg[0][3]
load net u_vector_n_235 -pin u_auto_zero near_neutral2_carry__0_0 -pin u_vector raw_roll_reg[0]_0
netloc u_vector_n_235 1 0 3 20 4570 NJ 4570 2620
load net u_vector_n_154 -attr @rip raw_roll_reg[22]_0[1] -pin u_auto_zero near_neutral2_inferred__0/i__carry__2_0[1] -pin u_vector raw_roll_reg[22]_0[1]
load net u_vector_n_122 -attr @rip raw_roll_reg[26]_0[0] -pin u_auto_zero done_i_3[0] -pin u_vector raw_roll_reg[26]_0[0]
netloc u_vector_n_122 1 0 3 100 4410 NJ 4410 2280
load net u_magnetometro_n_149 -attr @rip D[13] -pin g_mag_tilt.u_heading D[13] -pin u_magnetometro D[13]
load net u_magnetometro_n_23 -attr @rip amostra_nova_reg_0[3] -pin g_mag_tilt.u_heading age_reg[25]_1[3] -pin u_magnetometro amostra_nova_reg_0[3]
load net u_mag_calibration_n_59 -attr @rip max_z_reg[15]_0[12] -pin u_mag_calibration max_z_reg[15]_0[12] -pin u_magnetometro max_z_reg[15]_i_2_0[12]
load net u_mag_calibration_n_9 -pin u_mag_calibration state_reg[3]_1 -pin u_magnetometro state[2]_i_4
netloc u_mag_calibration_n_9 1 4 1 5230 1450n
load net compass_gravity_z[19] -attr @rip Q[19] -pin g_mag_tilt.u_heading gz_reg[24]_0[19] -pin u_vector Q[19]
load net compass_gravity_x[3] -attr @rip gravity_x_reg[23]_0[3] -pin g_mag_tilt.u_heading gx_reg[23]_0[3] -pin u_vector gravity_x_reg[23]_0[3]
load net compass_gravity_y[11] -attr @rip gravity_y_reg[23]_0[11] -pin g_mag_tilt.u_heading gy_reg[24]_0[11] -pin u_vector gravity_y_reg[23]_0[11]
load net last_z[7] -attr @rip last_z_reg[14]_0[7] -pin u_mag_calibration last_z_reg[14]_0[7] -pin u_magnetometro pipe_unique_reg_i_2_0[7]
load net last_x[6] -attr @rip last_x_reg[14]_0[6] -pin u_mag_calibration last_x_reg[14]_0[6] -pin u_magnetometro pipe_unique_reg_i_4_0[6]
load net mag_corrected_y[5] -attr @rip corrected_y_reg[15]_0[5] -pin u_mag_cal_planar corrigido_y_reg[15]_0[5] -pin u_mag_calibration corrected_y_reg[15]_0[5]
load net mag_y[7] -attr @rip mag_y[7] -pin u_mag_calibration max_y_reg[15]_2[7] -pin u_magnetometro mag_y[7]
load net mpu_gyro_z[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[11] -pin u_sensor accel_x_reg[15]_0[11] -pin u_vector a_reg[0][15]_0[11]
load net mpu_raw_ay[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[75] -pin u_sensor accel_x_reg[15]_0[75] -pin u_vector a_reg[0][15]_0[75]
load net mpu_raw_gy[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[27] -pin u_sensor accel_x_reg[15]_0[27] -pin u_vector a_reg[0][15]_0[27]
load net vector_calibration_debug[16] -attr @rip D[109] -pin u_attitude_cdc D[182] -pin u_vector D[109]
load net samples_reg[2][3] -attr @rip samples_reg[2][7]_0[11] -pin u_sensor samples_reg[2][7]_0[11] -pin u_vector p_1_in_1[11]
load net samples_reg[5][7] -attr @rip samples_reg[4][7]_0[7] -pin u_sensor samples_reg[4][7]_0[7] -pin u_vector p_1_in__0_0[7]
load net vector_raw_roll[5] -attr @rip D[67] -pin u_attitude_cdc D[139] -pin u_vector D[67]
load net vector_raw_pitch[0] -attr @rip D[36] -pin u_attitude_cdc D[108] -pin u_vector D[36]
load net vector_roll[10] -attr @style dashed -attr @rip roll_reg[31]_0[15] -pin u_attitude_cdc retido_reg[238]_0[15] -pin u_vector roll_reg[31]_0[15]
load net u_mag_calibration_n_121 -attr @rip max_y_reg[15]_1[2] -pin u_mag_calibration max_y_reg[15]_1[2] -pin u_magnetometro max_y_reg[0][2]
load net u_mag_calibration_n_28 -attr @rip S[3] -pin u_mag_calibration S[3] -pin u_magnetometro S[3]
load net g_mag_tilt.u_heading_n_15 -attr @rip age_reg[16]_0[1] -pin g_mag_tilt.u_heading age_reg[16]_0[1] -pin u_magnetometro age_reg[16][1]
load net invalid_now -pin u_mag_calibration invalid_now -pin u_magnetometro invalid_now
netloc invalid_now 1 4 1 5950 790n
load net u_mag_calibration_n_151 -attr @rip max_x_reg[7]_0[0] -pin u_mag_calibration max_x_reg[7]_0[0] -pin u_magnetometro max_x_reg[15]_i_2_1[0]
load net u_vector_n_155 -attr @rip raw_roll_reg[22]_0[0] -pin u_auto_zero near_neutral2_inferred__0/i__carry__2_0[0] -pin u_vector raw_roll_reg[22]_0[0]
load net u_vector_n_123 -attr @rip raw_roll_reg[26]_1[2] -pin u_auto_zero done_i_5[2] -pin u_vector raw_roll_reg[26]_1[2]
load net u_magnetometro_n_15 -attr @rip amostra_nova_reg_0[11] -pin g_mag_tilt.u_heading age_reg[25]_1[11] -pin u_magnetometro amostra_nova_reg_0[11]
load net u_magnetometro_n_24 -attr @rip amostra_nova_reg_0[2] -pin g_mag_tilt.u_heading age_reg[25]_1[2] -pin u_magnetometro amostra_nova_reg_0[2]
load net u_mag_calibration_n_60 -attr @rip max_z_reg[15]_0[11] -pin u_mag_calibration max_z_reg[15]_0[11] -pin u_magnetometro max_z_reg[15]_i_2_0[11]
load net u_mag_calibration_n_90 -attr @rip min_y_reg[15]_0[5] -pin u_mag_calibration min_y_reg[15]_0[5] -pin u_magnetometro min_y_reg[15]_i_2_0[5]
load net compass_gravity_z[20] -attr @rip Q[20] -pin g_mag_tilt.u_heading gz_reg[24]_0[20] -pin u_vector Q[20]
load net compass_gravity_x[4] -attr @rip gravity_x_reg[23]_0[4] -pin g_mag_tilt.u_heading gx_reg[23]_0[4] -pin u_vector gravity_x_reg[23]_0[4]
load net compass_gravity_y[12] -attr @rip gravity_y_reg[23]_0[12] -pin g_mag_tilt.u_heading gy_reg[24]_0[12] -pin u_vector gravity_y_reg[23]_0[12]
load net last_z[8] -attr @rip last_z_reg[14]_0[8] -pin u_mag_calibration last_z_reg[14]_0[8] -pin u_magnetometro pipe_unique_reg_i_2_0[8]
load net last_x[9] -attr @rip last_x_reg[14]_0[9] -pin u_mag_calibration last_x_reg[14]_0[9] -pin u_magnetometro pipe_unique_reg_i_4_0[9]
load net mag_corrected_y[6] -attr @rip corrected_y_reg[15]_0[6] -pin u_mag_cal_planar corrigido_y_reg[15]_0[6] -pin u_mag_calibration corrected_y_reg[15]_0[6]
load net mag_y[8] -attr @rip mag_y[8] -pin u_mag_calibration max_y_reg[15]_2[8] -pin u_magnetometro mag_y[8]
load net mpu_gyro_z[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[12] -pin u_sensor accel_x_reg[15]_0[12] -pin u_vector a_reg[0][15]_0[12]
load net mpu_raw_ay[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[76] -pin u_sensor accel_x_reg[15]_0[76] -pin u_vector a_reg[0][15]_0[76]
load net mpu_raw_gy[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[28] -pin u_sensor accel_x_reg[15]_0[28] -pin u_vector a_reg[0][15]_0[28]
load net vector_raw_pitch[1] -attr @rip D[37] -pin u_attitude_cdc D[109] -pin u_vector D[37]
load net samples_reg[2][4] -attr @rip samples_reg[2][7]_0[12] -pin u_sensor samples_reg[2][7]_0[12] -pin u_vector p_1_in_1[12]
load net vector_raw_roll[6] -attr @rip D[68] -pin u_attitude_cdc D[140] -pin u_vector D[68]
load net vector_roll[11] -attr @style dashed -attr @rip roll_reg[31]_0[16] -pin u_attitude_cdc retido_reg[238]_0[16] -pin u_vector roll_reg[31]_0[16]
load net vector_calibration_debug[17] -attr @rip D[110] -pin u_attitude_cdc D[183] -pin u_vector D[110]
load net rx_bytes_reg[4]_2[7] -attr @rip rx_bytes_reg[4][7]_0[15] -pin g_mag_tilt.u_heading by_reg_0[15] -pin u_mag_calibration prod_y_reg_0[15] -pin u_magnetometro rx_bytes_reg[4][7]_0[15]
load net near_neutral2__23 -attr @rip CO[0] -pin u_auto_zero CO[0] -pin u_vector CO[0]
netloc near_neutral2__23 1 1 1 1370 2990n
load net g_mag_tilt.u_heading_n_7 -attr @rip age_reg[8]_0[1] -pin g_mag_tilt.u_heading age_reg[8]_0[1] -pin u_magnetometro age_reg[8][1]
load net u_mag_calibration_n_111 -attr @rip max_y_reg[15]_0[8] -pin u_mag_calibration max_y_reg[15]_0[8] -pin u_magnetometro max_y_reg[15]_i_2_0[8]
load net u_mag_calibration_n_141 -attr @rip min_x_reg[15]_0[2] -pin u_mag_calibration min_x_reg[15]_0[2] -pin u_magnetometro min_x_reg[15]_i_2_0[2]
load net u_mag_calibration_n_172 -attr @rip last_y_reg[15]_0[0] -pin u_mag_calibration last_y_reg[15]_0[0] -pin u_magnetometro pipe_unique_reg_0[0]
netloc u_mag_calibration_n_172 1 4 1 5490 870n
load net u_magnetometro_n_91 -attr @rip mag_y_reg[15]_0[0] -pin u_mag_calibration min_y_reg[0]_0[0] -pin u_magnetometro mag_y_reg[15]_0[0]
netloc u_magnetometro_n_91 1 3 3 3730 2850 NJ 2850 7130
load net u_vector_n_225 -attr @rip raw_roll_reg[16]_0[3] -pin u_auto_zero near_neutral2_carry__1_0[3] -pin u_vector raw_roll_reg[16]_0[3]
load net u_vector_n_362 -pin g_mag_tilt.u_heading angle_out_reg[0] -pin u_vector inicio_operacao_reg[3]_0
netloc u_vector_n_362 1 2 4 2540J 3170 NJ 3170 NJ 3170 7730
load net u_vector_n_144 -attr @rip raw_roll_reg[6]_0[1] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_0[1] -pin u_vector raw_roll_reg[6]_0[1]
load net u_magnetometro_n_108 -pin u_mag_calibration age_reg[23]_1 -pin u_magnetometro amostra_nova_reg_17
netloc u_magnetometro_n_108 1 3 3 3830 2670 NJ 2670 6970
load net u_magnetometro_n_176 -attr @rip rx_bytes_reg[0][7]_0[2] -pin g_mag_tilt.u_heading bx_reg_0[2] -pin u_mag_calibration prod_x_reg_1[2] -pin u_magnetometro rx_bytes_reg[0][7]_0[2]
load net u_mag_calibration_n_49 -attr @rip min_z_reg[15]_0[2] -pin u_mag_calibration min_z_reg[15]_0[2] -pin u_magnetometro min_z_reg[0][2]
load net u_mag_calibration_n_80 -attr @rip min_y_reg[15]_0[15] -pin u_mag_calibration min_y_reg[15]_0[15] -pin u_magnetometro min_y_reg[15]_i_2_0[15]
load net compass_gravity_z[8] -attr @rip Q[8] -pin g_mag_tilt.u_heading gz_reg[24]_0[8] -pin u_vector Q[8]
load net compass_gravity_y[1] -attr @rip gravity_y_reg[23]_0[1] -pin g_mag_tilt.u_heading gy_reg[24]_0[1] -pin u_vector gravity_y_reg[23]_0[1]
load net last_y[13] -attr @rip last_y_reg[14]_0[13] -pin u_mag_calibration last_y_reg[14]_0[13] -pin u_magnetometro pipe_unique_reg_i_3_0[13]
load net mag_corrected_x[11] -attr @rip corrected_x_reg[15]_0[11] -pin u_mag_cal_planar Q[11] -pin u_mag_calibration corrected_x_reg[15]_0[11]
load net mag_x[14] -attr @rip mag_x[14] -pin u_mag_calibration max_x_reg[15]_2[14] -pin u_magnetometro mag_x[14]
load net mpu_gyro_z[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[1] -pin u_sensor accel_x_reg[15]_0[1] -pin u_vector a_reg[0][15]_0[1]
load net mpu_raw_ay[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[65] -pin u_sensor accel_x_reg[15]_0[65] -pin u_vector a_reg[0][15]_0[65]
load net mpu_raw_gy[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[17] -pin u_sensor accel_x_reg[15]_0[17] -pin u_vector a_reg[0][15]_0[17]
load net mag_z[14] -attr @rip mag_z[14] -pin u_mag_calibration pipe_z_reg[15]_0[14] -pin u_magnetometro mag_z[14]
load net rx_bytes_reg[3]_3[6] -attr @rip D[6] -pin g_mag_tilt.u_heading D[6] -pin u_magnetometro D[6]
load net samples_reg[1][2] -attr @rip B[2] -pin u_sensor B[2] -pin u_vector B[2]
load net p_1_in_0[19] -attr @rip age_reg[25]_2[6] -pin u_mag_calibration age_reg[25]_2[6] -pin u_magnetometro age_reg[25]_0[6]
load net vector_calibration_debug[6] -attr @rip D[99] -pin u_attitude_cdc D[172] -pin u_vector D[99]
load net vector_pitch[18] -attr @style dashed -attr @rip roll_reg[31]_0[5] -pin u_attitude_cdc retido_reg[238]_0[5] -pin u_vector roll_reg[31]_0[5]
load net vector_raw_pitch[22] -attr @rip D[58] -pin u_attitude_cdc D[130] -pin u_vector D[58]
load net vector_roll[0] -attr @style dashed -attr @rip roll_reg[31]_0[13] -pin u_attitude_cdc retido_reg[238]_0[13] -pin u_vector roll_reg[31]_0[13]
load net fusao_valida -attr @style dashed -attr @rip D[92] -pin u_attitude_cdc D[164] -pin u_vector D[92]
load net g_mag_tilt.u_heading_n_8 -attr @rip age_reg[8]_0[0] -pin g_mag_tilt.u_heading age_reg[8]_0[0] -pin u_magnetometro age_reg[8][0]
load net mag_sensor_ok -attr @style dashed -pin u_mag_calibration mag_sensor_ok -pin u_magnetometro mag_sensor_ok
netloc mag_sensor_ok 1 3 3 4210 1750 5310J 830 7170
load net u_mag_calibration_n_112 -attr @rip max_y_reg[15]_0[7] -pin u_mag_calibration max_y_reg[15]_0[7] -pin u_magnetometro max_y_reg[15]_i_2_0[7]
load net u_mag_calibration_n_142 -attr @rip min_x_reg[15]_0[1] -pin u_mag_calibration min_x_reg[15]_0[1] -pin u_magnetometro min_x_reg[15]_i_2_0[1]
load net u_mag_calibration_n_188 -attr @rip last_z_reg[15]_0[0] -pin u_mag_calibration last_z_reg[15]_0[0] -pin u_magnetometro pipe_unique_reg_1[0]
netloc u_mag_calibration_n_188 1 4 1 5650 910n
load net u_vector_n_226 -attr @rip raw_roll_reg[16]_0[2] -pin u_auto_zero near_neutral2_carry__1_0[2] -pin u_vector raw_roll_reg[16]_0[2]
load net u_vector_n_145 -attr @rip raw_roll_reg[6]_0[0] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_0[0] -pin u_vector raw_roll_reg[6]_0[0]
load net u_magnetometro_n_109 -pin u_mag_calibration age_reg[25]_3 -pin u_magnetometro amostra_nova_reg_18
netloc u_magnetometro_n_109 1 3 3 3870 2730 NJ 2730 7150
load net u_mag_calibration_n_50 -attr @rip min_z_reg[15]_0[1] -pin u_mag_calibration min_z_reg[15]_0[1] -pin u_magnetometro min_z_reg[0][1]
load net u_mag_calibration_n_81 -attr @rip min_y_reg[15]_0[14] -pin u_mag_calibration min_y_reg[15]_0[14] -pin u_magnetometro min_y_reg[15]_i_2_0[14]
load net u_magnetometro_n_92 -attr @rip mag_y_reg[15]_1[0] -pin u_mag_calibration max_y_reg[0]_0[0] -pin u_magnetometro mag_y_reg[15]_1[0]
netloc u_magnetometro_n_92 1 3 3 3710 2870 NJ 2870 7050
load net u_magnetometro_n_177 -attr @rip rx_bytes_reg[0][7]_0[1] -pin g_mag_tilt.u_heading bx_reg_0[1] -pin u_mag_calibration prod_x_reg_1[1] -pin u_magnetometro rx_bytes_reg[0][7]_0[1]
load net compass_gravity_z[10] -attr @rip Q[10] -pin g_mag_tilt.u_heading gz_reg[24]_0[10] -pin u_vector Q[10]
load net compass_gravity_y[2] -attr @rip gravity_y_reg[23]_0[2] -pin g_mag_tilt.u_heading gy_reg[24]_0[2] -pin u_vector gravity_y_reg[23]_0[2]
load net fonte_desabilitada_sync[2] -attr @style dashed -attr @rip 0 -pin g_mag_tilt.u_heading out[0] -pin u_mag_calibration out[0] -pin u_magnetometro out[0]
netloc fonte_desabilitada_sync[2] 1 3 3 4230 2130 5590 1110 7470J
load net last_y[14] -attr @rip last_y_reg[14]_0[14] -pin u_mag_calibration last_y_reg[14]_0[14] -pin u_magnetometro pipe_unique_reg_i_3_0[14]
load net mag_corrected_x[12] -attr @rip corrected_x_reg[15]_0[12] -pin u_mag_cal_planar Q[12] -pin u_mag_calibration corrected_x_reg[15]_0[12]
load net mag_x[15] -attr @rip mag_x[15] -pin u_mag_calibration max_x_reg[15]_2[15] -pin u_magnetometro mag_x[15]
load net mpu_gyro_z[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[2] -pin u_sensor accel_x_reg[15]_0[2] -pin u_vector a_reg[0][15]_0[2]
load net mpu_raw_ay[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[66] -pin u_sensor accel_x_reg[15]_0[66] -pin u_vector a_reg[0][15]_0[66]
load net mpu_raw_gy[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[18] -pin u_sensor accel_x_reg[15]_0[18] -pin u_vector a_reg[0][15]_0[18]
load net mag_z[15] -attr @rip mag_z[15] -pin u_mag_calibration pipe_z_reg[15]_0[15] -pin u_magnetometro mag_z[15]
load net samples_reg[1][3] -attr @rip B[3] -pin u_sensor B[3] -pin u_vector B[3]
load net vector_calibration_debug[9] -attr @rip D[102] -pin u_attitude_cdc D[175] -pin u_vector D[102]
load net p_1_in_0[22] -attr @rip age_reg[25]_2[9] -pin u_mag_calibration age_reg[25]_2[9] -pin u_magnetometro age_reg[25]_0[9]
load net samples_reg[4][7] -attr @rip samples_reg[4][7]_0[15] -pin u_sensor samples_reg[4][7]_0[15] -pin u_vector p_1_in__0_0[15]
load net vector_pitch[19] -attr @style dashed -attr @rip roll_reg[31]_0[6] -pin u_attitude_cdc retido_reg[238]_0[6] -pin u_vector roll_reg[31]_0[6]
load net vector_raw_pitch[23] -attr @rip D[59] -pin u_attitude_cdc D[131] -pin u_vector D[59]
load net vector_roll[1] -attr @style dashed -attr @rip roll_reg[31]_0[14] -pin u_attitude_cdc retido_reg[238]_0[14] -pin u_vector roll_reg[31]_0[14]
load net near_neutral1__18 -attr @rip raw_pitch_reg[25][0] -pin u_auto_zero raw_pitch_reg[25][0] -pin u_vector done_i_3_1[0]
netloc near_neutral1__18 1 1 1 1450 3270n
load net g_mag_tilt.u_heading_n_5 -attr @rip age_reg[8]_0[3] -pin g_mag_tilt.u_heading age_reg[8]_0[3] -pin u_magnetometro age_reg[8][3]
load net u_mag_calibration_n_170 -attr @rip max_x_reg[15]_1[1] -pin u_mag_calibration max_x_reg[15]_1[1] -pin u_magnetometro max_x_reg[0][1]
load net u_mag_calibration_n_139 -attr @rip min_x_reg[15]_0[4] -pin u_mag_calibration min_x_reg[15]_0[4] -pin u_magnetometro min_x_reg[15]_i_2_0[4]
load net u_mag_calibration_n_11 -pin u_mag_calibration age_reg[25]_0 -pin u_magnetometro state_reg[3]_0
netloc u_mag_calibration_n_11 1 4 1 5770 490n
load net u_vector_n_349 -attr @rip raw_pitch_reg[6]_1[0] -pin u_auto_zero near_neutral1_carry__0_1[0] -pin u_vector raw_pitch_reg[6]_1[0]
load net u_vector_n_223 -attr @rip raw_roll_reg[24]_1[1] -pin u_auto_zero near_neutral2_carry__2_0[1] -pin u_vector raw_roll_reg[24]_1[1]
load net u_vector_n_142 -attr @rip raw_roll_reg[6]_0[3] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_0[3] -pin u_vector raw_roll_reg[6]_0[3]
load net u_magnetometro_n_9 -attr @rip amostra_nova_reg_0[17] -pin g_mag_tilt.u_heading age_reg[25]_1[17] -pin u_magnetometro amostra_nova_reg_0[17]
load net u_magnetometro_n_106 -pin u_mag_calibration age_reg[21]_0 -pin u_magnetometro amostra_nova_reg_15
netloc u_magnetometro_n_106 1 3 3 3850 2630 NJ 2630 7110
load net u_mag_calibration_n_79 -attr @rip min_y_reg[7]_0[0] -pin u_mag_calibration min_y_reg[7]_0[0] -pin u_magnetometro min_y_reg[15]_i_2_1[0]
load net u_mag_calibration_n_47 -attr @rip Q[0] -pin u_mag_calibration Q[0] -pin u_magnetometro min_z_reg[15]_i_3_0[0]
load net u_magnetometro_n_174 -attr @rip rx_bytes_reg[0][7]_0[4] -pin g_mag_tilt.u_heading bx_reg_0[4] -pin u_mag_calibration prod_x_reg_1[4] -pin u_magnetometro rx_bytes_reg[0][7]_0[4]
load net compass_gravity_z[9] -attr @rip Q[9] -pin g_mag_tilt.u_heading gz_reg[24]_0[9] -pin u_vector Q[9]
load net compass_gravity_x[23] -attr @rip gravity_x_reg[23]_0[23] -pin g_mag_tilt.u_heading gx_reg[23]_0[23] -pin u_vector gravity_x_reg[23]_0[23]
load net last_y[11] -attr @rip last_y_reg[14]_0[11] -pin u_mag_calibration last_y_reg[14]_0[11] -pin u_magnetometro pipe_unique_reg_i_3_0[11]
load net mag_corrected_x[8] -attr @rip corrected_x_reg[15]_0[8] -pin u_mag_cal_planar Q[8] -pin u_mag_calibration corrected_x_reg[15]_0[8]
load net mag_x[12] -attr @rip mag_x[12] -pin u_mag_calibration max_x_reg[15]_2[12] -pin u_magnetometro mag_x[12]
load net mpu_raw_ax[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[95] -pin u_sensor accel_x_reg[15]_0[95] -pin u_vector a_reg[0][15]_0[95]
load net mpu_accel_z[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[63] -pin u_sensor accel_x_reg[15]_0[63] -pin u_vector a_reg[0][15]_0[63]
load net mpu_raw_gx[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[47] -pin u_sensor accel_x_reg[15]_0[47] -pin u_vector a_reg[0][15]_0[47]
load net mag_z[12] -attr @rip mag_z[12] -pin u_mag_calibration pipe_z_reg[15]_0[12] -pin u_magnetometro mag_z[12]
load net rx_bytes_reg[3]_3[4] -attr @rip D[4] -pin g_mag_tilt.u_heading D[4] -pin u_magnetometro D[4]
load net samples_reg[1][0] -attr @rip B[0] -pin u_sensor B[0] -pin u_vector B[0]
load net p_1_in_0[15] -attr @rip age_reg[25]_2[4] -pin u_mag_calibration age_reg[25]_2[4] -pin u_magnetometro age_reg[25]_0[4]
load net vector_pitch[16] -attr @style dashed -attr @rip roll_reg[31]_0[3] -pin u_attitude_cdc retido_reg[238]_0[3] -pin u_vector roll_reg[31]_0[3]
load net vector_calibration_debug[4] -attr @rip D[97] -pin u_attitude_cdc D[170] -pin u_vector D[97]
load net vector_raw_pitch[20] -attr @rip D[56] -pin u_attitude_cdc D[128] -pin u_vector D[56]
load net vector_raw_roll[31] -attr @rip D[87] -pin u_attitude_cdc D[159] -pin u_auto_zero D[1] -pin u_vector D[87]
load net samples_reg[4][5] -attr @rip samples_reg[4][7]_0[13] -pin u_sensor samples_reg[4][7]_0[13] -pin u_vector p_1_in__0_0[13]
load net near_neutral210_in -attr @rip raw_roll_reg[26][0] -pin u_auto_zero raw_roll_reg[26][0] -pin u_vector done_reg[0]
netloc near_neutral210_in 1 1 1 1070 3290n
load net g_mag_tilt.u_heading_n_6 -attr @rip age_reg[8]_0[2] -pin g_mag_tilt.u_heading age_reg[8]_0[2] -pin u_magnetometro age_reg[8][2]
load net u_mag_calibration_n_171 -attr @rip max_x_reg[15]_1[0] -pin u_mag_calibration max_x_reg[15]_1[0] -pin u_magnetometro max_x_reg[0][0]
load net u_mag_calibration_n_110 -attr @rip max_y_reg[15]_0[9] -pin u_mag_calibration max_y_reg[15]_0[9] -pin u_magnetometro max_y_reg[15]_i_2_0[9]
load net u_mag_calibration_n_140 -attr @rip min_x_reg[15]_0[3] -pin u_mag_calibration min_x_reg[15]_0[3] -pin u_magnetometro min_x_reg[15]_i_2_0[3]
load net u_vector_n_361 -attr @rip inicio_operacao_reg[3][0] -pin g_mag_tilt.u_heading SR[0] -pin u_vector inicio_operacao_reg[3][0]
netloc u_vector_n_361 1 2 4 2620J 3150 NJ 3150 NJ 3150 7610
load net u_vector_n_224 -attr @rip raw_roll_reg[24]_1[0] -pin u_auto_zero near_neutral2_carry__2_0[0] -pin u_vector raw_roll_reg[24]_1[0]
load net u_vector_n_143 -attr @rip raw_roll_reg[6]_0[2] -pin u_auto_zero near_neutral2_inferred__0/i__carry__0_0[2] -pin u_vector raw_roll_reg[6]_0[2]
load net u_magnetometro_n_107 -pin u_mag_calibration age_reg[22]_0 -pin u_magnetometro amostra_nova_reg_16
netloc u_magnetometro_n_107 1 3 3 3910 2650 NJ 2650 7030
load net u_magnetometro_n_90 -attr @rip mag_z_reg[15]_1[0] -pin u_mag_calibration max_z_reg[0]_0[0] -pin u_magnetometro mag_z_reg[15]_1[0]
netloc u_magnetometro_n_90 1 3 3 3750 2830 NJ 2830 6990
load net u_mag_calibration_n_48 -attr @rip min_z_reg[15]_0[3] -pin u_mag_calibration min_z_reg[15]_0[3] -pin u_magnetometro min_z_reg[0][3]
load net u_magnetometro_n_175 -attr @rip rx_bytes_reg[0][7]_0[3] -pin g_mag_tilt.u_heading bx_reg_0[3] -pin u_mag_calibration prod_x_reg_1[3] -pin u_magnetometro rx_bytes_reg[0][7]_0[3]
load net compass_gravity_y[0] -attr @rip gravity_y_reg[23]_0[0] -pin g_mag_tilt.u_heading gy_reg[24]_0[0] -pin u_vector gravity_y_reg[23]_0[0]
load net fonte_desabilitada_sync[0] -attr @style dashed -attr @rip 0 -pin u_sensor out[0] -pin u_vector out[0]
netloc fonte_desabilitada_sync[0] 1 0 2 440 2930 1470J
load net compass_gravity_z[7] -attr @rip Q[7] -pin g_mag_tilt.u_heading gz_reg[24]_0[7] -pin u_vector Q[7]
load net last_y[12] -attr @rip last_y_reg[14]_0[12] -pin u_mag_calibration last_y_reg[14]_0[12] -pin u_magnetometro pipe_unique_reg_i_3_0[12]
load net mag_corrected_x[10] -attr @rip corrected_x_reg[15]_0[10] -pin u_mag_cal_planar Q[10] -pin u_mag_calibration corrected_x_reg[15]_0[10]
load net mag_x[13] -attr @rip mag_x[13] -pin u_mag_calibration max_x_reg[15]_2[13] -pin u_magnetometro mag_x[13]
load net mpu_gyro_z[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[0] -pin u_sensor accel_x_reg[15]_0[0] -pin u_vector a_reg[0][15]_0[0]
load net mpu_raw_ay[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[64] -pin u_sensor accel_x_reg[15]_0[64] -pin u_vector a_reg[0][15]_0[64]
load net mpu_raw_gy[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[16] -pin u_sensor accel_x_reg[15]_0[16] -pin u_vector a_reg[0][15]_0[16]
load net mag_z[13] -attr @rip mag_z[13] -pin u_mag_calibration pipe_z_reg[15]_0[13] -pin u_magnetometro mag_z[13]
load net samples_reg[1][1] -attr @rip B[1] -pin u_sensor B[1] -pin u_vector B[1]
load net stale_reg[0] -attr @rip stale_reg[0]_0[0] -pin u_sensor stale_reg[0] -pin u_vector stale_reg[0]_0[0]
netloc stale_reg[0] 1 0 3 460 3410 990J 2690 2420
load net rx_bytes_reg[3]_3[5] -attr @rip D[5] -pin g_mag_tilt.u_heading D[5] -pin u_magnetometro D[5]
load net p_1_in_0[17] -attr @rip age_reg[25]_2[5] -pin u_mag_calibration age_reg[25]_2[5] -pin u_magnetometro age_reg[25]_0[5]
load net samples_reg[4][6] -attr @rip samples_reg[4][7]_0[14] -pin u_sensor samples_reg[4][7]_0[14] -pin u_vector p_1_in__0_0[14]
load net vector_calibration_debug[5] -attr @rip D[98] -pin u_attitude_cdc D[171] -pin u_vector D[98]
load net vector_raw_pitch[21] -attr @rip D[57] -pin u_attitude_cdc D[129] -pin u_vector D[57]
load net vector_pitch[17] -attr @style dashed -attr @rip roll_reg[31]_0[4] -pin u_attitude_cdc retido_reg[238]_0[4] -pin u_vector roll_reg[31]_0[4]
load net p_17_in -pin g_mag_tilt.u_heading p_17_in -pin u_magnetometro p_17_in -pin u_vector p_17_in
netloc p_17_in 1 2 4 2340J 3110 NJ 3110 6070 2350 7690J
load net g_mag_tilt.u_heading_n_0 -attr @rip O[3] -pin g_mag_tilt.u_heading O[3] -pin u_magnetometro O[3]
load net u_mag_calibration_n_115 -attr @rip max_y_reg[15]_0[4] -pin u_mag_calibration max_y_reg[15]_0[4] -pin u_magnetometro max_y_reg[15]_i_2_0[4]
load net u_mag_calibration_n_145 -attr @rip min_x_reg[15]_1[2] -pin u_mag_calibration min_x_reg[15]_1[2] -pin u_magnetometro min_x_reg[0][2]
load net u_mag_calibration_n_221 -pin u_mag_cal_planar x_reg[12]_0 -pin u_mag_calibration profile_changed_reg_0
netloc u_mag_calibration_n_221 1 2 3 2740 1990 3510J 1970 5190
load net u_magnetometro_n_95 -pin u_mag_calibration have_last_reg_0 -pin u_magnetometro amostra_nova_reg_4
netloc u_magnetometro_n_95 1 3 3 3650 2930 NJ 2930 7270
load net u_vector_n_229 -attr @rip raw_roll_reg[12]_1[1] -pin u_auto_zero DI[1] -pin u_vector raw_roll_reg[12]_1[1]
load net vector_stationary -attr @rip D[89] -pin u_attitude_cdc D[161] -pin u_vector D[89]
load net u_vector_n_148 -attr @rip raw_roll_reg[14]_0[3] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_1[3] -pin u_vector raw_roll_reg[14]_0[3]
load net u_magnetometro_n_112 -attr @rip SR[0] -pin u_mag_calibration SR[0] -pin u_magnetometro SR[0]
netloc u_magnetometro_n_112 1 3 3 3790 2770 NJ 2770 7290
load net u_mag_calibration_n_84 -attr @rip min_y_reg[15]_0[11] -pin u_mag_calibration min_y_reg[15]_0[11] -pin u_magnetometro min_y_reg[15]_i_2_0[11]
load net u_mag_calibration_n_53 -attr @rip max_z_reg[7]_0[2] -pin u_mag_calibration max_z_reg[7]_0[2] -pin u_magnetometro max_z_reg[15]_i_2_1[2]
load net u_magnetometro_n_18 -attr @rip amostra_nova_reg_0[8] -pin g_mag_tilt.u_heading age_reg[25]_1[8] -pin u_magnetometro amostra_nova_reg_0[8]
load net horizonte_sync[1] -attr @style dashed -attr @rip 1 -pin u_sensor sensor_i_3[1] -pin u_vector pitch_fallback_q10_reg[14][1]
load net compass_gravity_z[13] -attr @rip Q[13] -pin g_mag_tilt.u_heading gz_reg[24]_0[13] -pin u_vector Q[13]
load net compass_gravity_y[5] -attr @rip gravity_y_reg[23]_0[5] -pin g_mag_tilt.u_heading gy_reg[24]_0[5] -pin u_vector gravity_y_reg[23]_0[5]
load net last_z[2] -attr @rip last_z_reg[14]_0[2] -pin u_mag_calibration last_z_reg[14]_0[2] -pin u_magnetometro pipe_unique_reg_i_2_0[2]
load net last_x[0] -attr @rip last_x_reg[14]_0[0] -pin u_mag_calibration last_x_reg[14]_0[0] -pin u_magnetometro pipe_unique_reg_i_4_0[0]
load net mag_corrected_x[15] -attr @rip corrected_x_reg[15]_0[15] -pin u_mag_cal_planar Q[15] -pin u_mag_calibration corrected_x_reg[15]_0[15]
load net mag_y[2] -attr @rip mag_y[2] -pin u_mag_calibration max_y_reg[15]_2[2] -pin u_magnetometro mag_y[2]
load net mpu_raw_ay[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[69] -pin u_sensor accel_x_reg[15]_0[69] -pin u_vector a_reg[0][15]_0[69]
load net mpu_gyro_z[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[5] -pin u_sensor accel_x_reg[15]_0[5] -pin u_vector a_reg[0][15]_0[5]
load net mpu_raw_gy[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[21] -pin u_sensor accel_x_reg[15]_0[21] -pin u_vector a_reg[0][15]_0[21]
load net vector_calibration_debug[10] -attr @rip D[103] -pin u_attitude_cdc D[176] -pin u_vector D[103]
load net samples_reg[5][2] -attr @rip samples_reg[4][7]_0[2] -pin u_sensor samples_reg[4][7]_0[2] -pin u_vector p_1_in__0_0[2]
load net samples_reg[1][6] -attr @rip B[6] -pin u_sensor B[6] -pin u_vector B[6]
load net p_1_in_0[23] -attr @rip age_reg[25]_2[10] -pin u_mag_calibration age_reg[25]_2[10] -pin u_magnetometro age_reg[25]_0[10]
load net vector_pitch[22] -attr @rip D[13] -pin u_attitude_cdc D[85] -pin u_vector D[13]
load net vector_roll[4] -attr @rip D[16] -pin u_attitude_cdc D[88] -pin u_vector D[16]
load net rx_bytes_reg[4]_2[1] -attr @rip rx_bytes_reg[4][7]_0[9] -pin g_mag_tilt.u_heading by_reg_0[9] -pin u_mag_calibration prod_y_reg_0[9] -pin u_magnetometro rx_bytes_reg[4][7]_0[9]
load net GYRO_LED_OBUF -attr @style dashed -pin u_sensor GYRO_LED_OBUF -pin u_vector GYRO_LED_OBUF
netloc GYRO_LED_OBUF 1 1 1 1330 3030n
load net sensor_fault_cycles0 -pin u_sensor sensor_fault_cycles0 -pin u_vector sensor_fault_cycles0
netloc sensor_fault_cycles0 1 1 1 1390 3310n
load net g_mag_tilt.u_heading_n_1 -attr @rip O[2] -pin g_mag_tilt.u_heading O[2] -pin u_magnetometro O[2]
load net u_mag_calibration_n_116 -attr @rip max_y_reg[15]_0[3] -pin u_mag_calibration max_y_reg[15]_0[3] -pin u_magnetometro max_y_reg[15]_i_2_0[3]
load net u_mag_calibration_n_146 -attr @rip min_x_reg[15]_1[1] -pin u_mag_calibration min_x_reg[15]_1[1] -pin u_magnetometro min_x_reg[0][1]
load net u_magnetometro_n_96 -pin u_mag_calibration invalid_now_reg_0 -pin u_magnetometro amostra_nova_reg_5
netloc u_magnetometro_n_96 1 3 3 3610 3030 NJ 3030 7350
load net u_magnetometro_n_12 -attr @rip amostra_nova_reg_0[14] -pin g_mag_tilt.u_heading age_reg[25]_1[14] -pin u_magnetometro amostra_nova_reg_0[14]
load net u_mag_calibration_n_85 -attr @rip min_y_reg[15]_0[10] -pin u_mag_calibration min_y_reg[15]_0[10] -pin u_magnetometro min_y_reg[15]_i_2_0[10]
load net u_mag_calibration_n_54 -attr @rip max_z_reg[7]_0[1] -pin u_mag_calibration max_z_reg[7]_0[1] -pin u_magnetometro max_z_reg[15]_i_2_1[1]
load net u_magnetometro_n_19 -attr @rip amostra_nova_reg_0[7] -pin g_mag_tilt.u_heading age_reg[25]_1[7] -pin u_magnetometro amostra_nova_reg_0[7]
load net vector_updated -attr @style dashed -pin u_auto_zero updated -pin u_vector updated
netloc vector_updated 1 0 3 420 4730 NJ 4730 2420
load net u_vec/done1 -pin g_mag_tilt.u_heading done1 -pin u_vector done1
netloc u_vec/done1 1 1 6 1570 2710 2600J 3350 NJ 3350 NJ 3350 NJ 3350 8440
load net u_vector_n_230 -attr @rip raw_roll_reg[12]_1[0] -pin u_auto_zero DI[0] -pin u_vector raw_roll_reg[12]_1[0]
load net u_vector_n_149 -attr @rip raw_roll_reg[14]_0[2] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_1[2] -pin u_vector raw_roll_reg[14]_0[2]
load net compass_gravity_z[14] -attr @rip Q[14] -pin g_mag_tilt.u_heading gz_reg[24]_0[14] -pin u_vector Q[14]
load net compass_gravity_y[6] -attr @rip gravity_y_reg[23]_0[6] -pin g_mag_tilt.u_heading gy_reg[24]_0[6] -pin u_vector gravity_y_reg[23]_0[6]
load net last_z[3] -attr @rip last_z_reg[14]_0[3] -pin u_mag_calibration last_z_reg[14]_0[3] -pin u_magnetometro pipe_unique_reg_i_2_0[3]
load net last_x[1] -attr @rip last_x_reg[14]_0[1] -pin u_mag_calibration last_x_reg[14]_0[1] -pin u_magnetometro pipe_unique_reg_i_4_0[1]
load net mag_corrected_y[0] -attr @rip corrected_y_reg[15]_0[0] -pin u_mag_cal_planar corrigido_y_reg[15]_0[0] -pin u_mag_calibration corrected_y_reg[15]_0[0]
load net mag_y[3] -attr @rip mag_y[3] -pin u_mag_calibration max_y_reg[15]_2[3] -pin u_magnetometro mag_y[3]
load net mpu_gyro_z[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[6] -pin u_sensor accel_x_reg[15]_0[6] -pin u_vector a_reg[0][15]_0[6]
load net mpu_raw_ay[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[70] -pin u_sensor accel_x_reg[15]_0[70] -pin u_vector a_reg[0][15]_0[70]
load net mpu_raw_gy[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[22] -pin u_sensor accel_x_reg[15]_0[22] -pin u_vector a_reg[0][15]_0[22]
load net vector_calibration_debug[11] -attr @rip D[104] -pin u_attitude_cdc D[177] -pin u_vector D[104]
load net p_1_in_0[25] -attr @rip age_reg[25]_2[11] -pin u_mag_calibration age_reg[25]_2[11] -pin u_magnetometro age_reg[25]_0[11]
load net samples_reg[5][3] -attr @rip samples_reg[4][7]_0[3] -pin u_sensor samples_reg[4][7]_0[3] -pin u_vector p_1_in__0_0[3]
load net vector_pitch[23] -attr @style dashed -attr @rip roll_reg[31]_0[9] -pin u_attitude_cdc retido_reg[238]_0[9] -pin u_vector roll_reg[31]_0[9]
load net vector_raw_roll[0] -attr @rip D[62] -pin u_attitude_cdc D[134] -pin u_vector D[62]
load net vector_roll[5] -attr @rip D[17] -pin u_attitude_cdc D[89] -pin u_vector D[17]
load net rx_bytes_reg[4]_2[2] -attr @rip rx_bytes_reg[4][7]_0[10] -pin g_mag_tilt.u_heading by_reg_0[10] -pin u_mag_calibration prod_y_reg_0[10] -pin u_magnetometro rx_bytes_reg[4][7]_0[10]
load net g_mag_tilt.u_heading_n_9 -attr @rip age_reg[12]_0[3] -pin g_mag_tilt.u_heading age_reg[12]_0[3] -pin u_magnetometro age_reg[12][3]
load net u_mag_calibration_n_113 -attr @rip max_y_reg[15]_0[6] -pin u_mag_calibration max_y_reg[15]_0[6] -pin u_magnetometro max_y_reg[15]_i_2_0[6]
load net u_mag_calibration_n_143 -attr @rip min_x_reg[15]_0[0] -pin u_mag_calibration min_x_reg[15]_0[0] -pin u_magnetometro min_x_reg[15]_i_2_0[0]
load net u_vector_n_227 -attr @rip raw_roll_reg[16]_0[1] -pin u_auto_zero near_neutral2_carry__1_0[1] -pin u_vector raw_roll_reg[16]_0[1]
load net u_vector_n_367 -pin u_auto_zero done_reg_0 -pin u_vector inicio_operacao_reg[3]_2
netloc u_vector_n_367 1 0 3 80 2650 NJ 2650 2360
load net u_vector_n_146 -attr @rip raw_roll_reg[12]_0[1] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_0[1] -pin u_vector raw_roll_reg[12]_0[1]
load net u_magnetometro_n_11 -attr @rip amostra_nova_reg_0[15] -pin g_mag_tilt.u_heading age_reg[25]_1[15] -pin u_magnetometro amostra_nova_reg_0[15]
load net u_mag_calibration_n_51 -attr @rip min_z_reg[15]_0[0] -pin u_mag_calibration min_z_reg[15]_0[0] -pin u_magnetometro min_z_reg[0][0]
load net u_mag_calibration_n_82 -attr @rip min_y_reg[15]_0[13] -pin u_mag_calibration min_y_reg[15]_0[13] -pin u_magnetometro min_y_reg[15]_i_2_0[13]
load net u_magnetometro_n_93 -attr @rip mag_x_reg[15]_0[0] -pin u_mag_calibration min_x_reg[0]_0[0] -pin u_magnetometro mag_x_reg[15]_0[0]
netloc u_magnetometro_n_93 1 3 3 3690 2890 NJ 2890 7170
load net u_magnetometro_n_178 -attr @rip rx_bytes_reg[0][7]_0[0] -pin g_mag_tilt.u_heading bx_reg_0[0] -pin u_mag_calibration prod_x_reg_1[0] -pin u_magnetometro rx_bytes_reg[0][7]_0[0]
load net compass_gravity_z[11] -attr @rip Q[11] -pin g_mag_tilt.u_heading gz_reg[24]_0[11] -pin u_vector Q[11]
load net compass_gravity_y[3] -attr @rip gravity_y_reg[23]_0[3] -pin g_mag_tilt.u_heading gy_reg[24]_0[3] -pin u_vector gravity_y_reg[23]_0[3]
load net last_z[0] -attr @rip last_z_reg[14]_0[0] -pin u_mag_calibration last_z_reg[14]_0[0] -pin u_magnetometro pipe_unique_reg_i_2_0[0]
load net mag_corrected_x[13] -attr @rip corrected_x_reg[15]_0[13] -pin u_mag_cal_planar Q[13] -pin u_mag_calibration corrected_x_reg[15]_0[13]
load net mag_y[0] -attr @rip mag_y[0] -pin u_mag_calibration max_y_reg[15]_2[0] -pin u_magnetometro mag_y[0]
load net mpu_raw_ay[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[67] -pin u_sensor accel_x_reg[15]_0[67] -pin u_vector a_reg[0][15]_0[67]
load net mpu_gyro_z[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[3] -pin u_sensor accel_x_reg[15]_0[3] -pin u_vector a_reg[0][15]_0[3]
load net mpu_raw_gy[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[19] -pin u_sensor accel_x_reg[15]_0[19] -pin u_vector a_reg[0][15]_0[19]
load net samples_reg[5][0] -attr @rip samples_reg[4][7]_0[0] -pin u_sensor samples_reg[4][7]_0[0] -pin u_vector p_1_in__0_0[0]
load net samples_reg[1][4] -attr @rip B[4] -pin u_sensor B[4] -pin u_vector B[4]
load net rx_bytes_reg[3]_3[7] -attr @rip D[7] -pin g_mag_tilt.u_heading D[7] -pin u_magnetometro D[7]
load net p_1_in_0[20] -attr @rip age_reg[25]_2[7] -pin u_mag_calibration age_reg[25]_2[7] -pin u_magnetometro age_reg[25]_0[7]
load net vector_roll[2] -attr @rip D[14] -pin u_attitude_cdc D[86] -pin u_vector D[14]
load net vector_raw_pitch[24] -attr @rip D[60] -pin u_attitude_cdc D[132] -pin u_vector D[60]
load net vector_pitch[20] -attr @style dashed -attr @rip roll_reg[31]_0[7] -pin u_attitude_cdc retido_reg[238]_0[7] -pin u_vector roll_reg[31]_0[7]
load net vector_calibration_debug[7] -attr @rip D[100] -pin u_attitude_cdc D[173] -pin u_vector D[100]
load net u_mag_calibration_n_114 -attr @rip max_y_reg[15]_0[5] -pin u_mag_calibration max_y_reg[15]_0[5] -pin u_magnetometro max_y_reg[15]_i_2_0[5]
load net u_mag_calibration_n_144 -attr @rip min_x_reg[15]_1[3] -pin u_mag_calibration min_x_reg[15]_1[3] -pin u_magnetometro min_x_reg[0][3]
load net p_14_in -pin u_mag_calibration p_14_in -pin u_magnetometro p_14_in
netloc p_14_in 1 3 3 4350 1770 5370J 850 6910
load net u_mag_calibration_n_204 -attr @rip last_x_reg[15]_0[0] -pin u_mag_calibration last_x_reg[15]_0[0] -pin u_magnetometro pipe_unique_reg_2[0]
netloc u_mag_calibration_n_204 1 4 1 5270 830n
load net u_magnetometro_n_179 -pin g_mag_tilt.u_heading bz_reg_0 -pin u_mag_calibration prod_x_reg_0 -pin u_magnetometro FSM_sequential_state_reg[0]_0
netloc u_magnetometro_n_179 1 3 3 3770 2790 NJ 2790 7630
load net u_magnetometro_n_94 -attr @rip CO[0] -pin u_mag_calibration CO[0] -pin u_magnetometro CO[0]
netloc u_magnetometro_n_94 1 3 3 3670 2910 NJ 2910 7310
load net u_magnetometro_n_111 -pin u_mag_calibration repeats_reg[15]_0 -pin u_magnetometro inicio_operacao_reg[3]
netloc u_magnetometro_n_111 1 3 3 3810 2750 NJ 2750 7090
load net u_mag_calibration_n_83 -attr @rip min_y_reg[15]_0[12] -pin u_mag_calibration min_y_reg[15]_0[12] -pin u_magnetometro min_y_reg[15]_i_2_0[12]
load net u_mag_calibration_n_52 -attr @rip max_z_reg[7]_0[3] -pin u_mag_calibration max_z_reg[7]_0[3] -pin u_magnetometro max_z_reg[15]_i_2_1[3]
load net vector_calibrated -attr @rip D[88] -pin u_attitude_cdc D[160] -pin u_vector D[88]
load net u_vector_n_368 -pin u_auto_zero stable_updates_reg[2]_0 -pin u_vector inicio_operacao_reg[3]_3
netloc u_vector_n_368 1 0 3 120 2690 970J 2670 2260
load net u_vector_n_147 -attr @rip raw_roll_reg[12]_0[0] -pin u_auto_zero near_neutral2_inferred__0/i__carry__1_0[0] -pin u_vector raw_roll_reg[12]_0[0]
load net u_vector_n_228 -attr @rip raw_roll_reg[16]_0[0] -pin u_auto_zero near_neutral2_carry__1_0[0] -pin u_vector raw_roll_reg[16]_0[0]
load net horizonte_sync[0] -attr @style dashed -attr @rip 0 -pin u_sensor sensor_i_3[0] -pin u_vector pitch_fallback_q10_reg[14][0]
load net compass_gravity_z[12] -attr @rip Q[12] -pin g_mag_tilt.u_heading gz_reg[24]_0[12] -pin u_vector Q[12]
load net compass_gravity_y[4] -attr @rip gravity_y_reg[23]_0[4] -pin g_mag_tilt.u_heading gy_reg[24]_0[4] -pin u_vector gravity_y_reg[23]_0[4]
load net last_z[1] -attr @rip last_z_reg[14]_0[1] -pin u_mag_calibration last_z_reg[14]_0[1] -pin u_magnetometro pipe_unique_reg_i_2_0[1]
load net mag_corrected_x[14] -attr @rip corrected_x_reg[15]_0[14] -pin u_mag_cal_planar Q[14] -pin u_mag_calibration corrected_x_reg[15]_0[14]
load net mag_y[1] -attr @rip mag_y[1] -pin u_mag_calibration max_y_reg[15]_2[1] -pin u_magnetometro mag_y[1]
load net mpu_gyro_z[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[4] -pin u_sensor accel_x_reg[15]_0[4] -pin u_vector a_reg[0][15]_0[4]
load net mpu_raw_ay[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[68] -pin u_sensor accel_x_reg[15]_0[68] -pin u_vector a_reg[0][15]_0[68]
load net mpu_raw_gy[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[20] -pin u_sensor accel_x_reg[15]_0[20] -pin u_vector a_reg[0][15]_0[20]
load net samples_reg[1][5] -attr @rip B[5] -pin u_sensor B[5] -pin u_vector B[5]
load net vector_calibration_debug[8] -attr @rip D[101] -pin u_attitude_cdc D[174] -pin u_vector D[101]
load net p_1_in_0[21] -attr @rip age_reg[25]_2[8] -pin u_mag_calibration age_reg[25]_2[8] -pin u_magnetometro age_reg[25]_0[8]
load net rx_bytes_reg[4]_2[0] -attr @rip rx_bytes_reg[4][7]_0[8] -pin g_mag_tilt.u_heading by_reg_0[8] -pin u_mag_calibration prod_y_reg_0[8] -pin u_magnetometro rx_bytes_reg[4][7]_0[8]
load net samples_reg[5][1] -attr @rip samples_reg[4][7]_0[1] -pin u_sensor samples_reg[4][7]_0[1] -pin u_vector p_1_in__0_0[1]
load net vector_pitch[21] -attr @style dashed -attr @rip roll_reg[31]_0[8] -pin u_attitude_cdc retido_reg[238]_0[8] -pin u_vector roll_reg[31]_0[8]
load net vector_raw_pitch[31] -attr @rip D[61] -pin u_attitude_cdc D[133] -pin u_auto_zero D[0] -pin u_vector D[61]
load net vector_roll[3] -attr @rip D[15] -pin u_attitude_cdc D[87] -pin u_vector D[15]
load net g_mag_tilt.u_heading_n_28 -pin g_mag_tilt.u_heading busy_reg_0 -pin u_vector i_reg[0]
netloc g_mag_tilt.u_heading_n_28 1 1 6 1550 110 NJ 110 NJ 110 NJ 110 NJ 110 8440
load net u_mag_calibration_n_164 -attr @rip max_x_reg[15]_0[3] -pin u_mag_calibration max_x_reg[15]_0[3] -pin u_magnetometro max_x_reg[15]_i_2_0[3]
load net u_mag_calibration_n_104 -attr @rip max_y_reg[15]_0[15] -pin u_mag_calibration max_y_reg[15]_0[15] -pin u_magnetometro max_y_reg[15]_i_2_0[15]
load net u_mag_calibration_n_133 -attr @rip min_x_reg[15]_0[10] -pin u_mag_calibration min_x_reg[15]_0[10] -pin u_magnetometro min_x_reg[15]_i_2_0[10]
load net u_mag_calibration_n_41 -attr @rip Q[6] -pin u_mag_calibration Q[6] -pin u_magnetometro min_z_reg[15]_i_3_0[6]
load net mag_corrected_sample -pin u_mag_cal_planar mag_corrected_sample -pin u_mag_calibration mag_corrected_sample
netloc mag_corrected_sample 1 2 3 2660 1930 3390J 1910 5150
load net u_vector_n_136 -attr @rip raw_pitch_reg[14]_0[0] -pin u_auto_zero near_neutral1_carry__1_1[0] -pin u_vector raw_pitch_reg[14]_0[0]
load net u_vector_n_217 -attr @rip raw_pitch_reg[8]_0[2] -pin u_auto_zero near_neutral0_carry__0_1[2] -pin u_vector raw_pitch_reg[8]_0[2]
load net u_vector_n_343 -attr @rip raw_roll_reg[8]_0[2] -pin u_auto_zero S[2] -pin u_vector raw_roll_reg[8]_0[2]
load net u_magnetometro_n_100 -pin u_mag_calibration age_reg[13]_0 -pin u_magnetometro amostra_nova_reg_9
netloc u_magnetometro_n_100 1 3 3 3570 3010 NJ 3010 7190
load net u_mag_calibration_n_73 -attr @rip max_z_reg[15]_1[2] -pin u_mag_calibration max_z_reg[15]_1[2] -pin u_magnetometro max_z_reg[0][2]
load net u_magnetometro_n_83 -pin u_mag_calibration reason_reg[0]_0 -pin u_magnetometro cancel_reg
netloc u_magnetometro_n_83 1 3 3 4070 2570 NJ 2570 6930
load net u_magnetometro_n_169 -attr @rip rx_bytes_reg[0][7]_0[9] -pin g_mag_tilt.u_heading bx_reg_0[9] -pin u_mag_calibration prod_x_reg_1[9] -pin u_magnetometro rx_bytes_reg[0][7]_0[9]
load net valido0 -pin u_mag_cal_planar valido0 -pin u_mag_calibration valido0
netloc valido0 1 2 3 2720 3330 NJ 3330 4970
load net compass_gravity_z[1] -attr @rip Q[1] -pin g_mag_tilt.u_heading gz_reg[24]_0[1] -pin u_vector Q[1]
load net compass_gravity_x[17] -attr @rip gravity_x_reg[23]_0[17] -pin g_mag_tilt.u_heading gx_reg[23]_0[17] -pin u_vector gravity_x_reg[23]_0[17]
load net last_y[5] -attr @rip last_y_reg[14]_0[5] -pin u_mag_calibration last_y_reg[14]_0[5] -pin u_magnetometro pipe_unique_reg_i_3_0[5]
load net mag_corrected_x[3] -attr @rip corrected_x_reg[15]_0[3] -pin u_mag_cal_planar Q[3] -pin u_mag_calibration corrected_x_reg[15]_0[3]
load net heading_planar_deg[0] -attr @rip heading_deg_reg[8]_0[0] -pin u_mag_cal_planar heading_deg_reg[8]_0[0] -pin u_mag_calibration dados_reg[0][0]
netloc heading_planar_deg[0] 1 3 1 3210 630n
load net mag_x[6] -attr @rip mag_x[6] -pin u_mag_calibration max_x_reg[15]_2[6] -pin u_magnetometro mag_x[6]
load net mag_z[6] -attr @rip mag_z[6] -pin u_mag_calibration pipe_z_reg[15]_0[6] -pin u_magnetometro mag_z[6]
load net mpu_accel_z[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[56] -pin u_sensor accel_x_reg[15]_0[56] -pin u_vector a_reg[0][15]_0[56]
load net mpu_raw_gx[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[40] -pin u_sensor accel_x_reg[15]_0[40] -pin u_vector a_reg[0][15]_0[40]
load net mpu_raw_ax[8] -attr @style dashed -attr @rip accel_x_reg[15]_0[88] -pin u_sensor accel_x_reg[15]_0[88] -pin u_vector a_reg[0][15]_0[88]
load net p_0_out[2] -attr @style dashed -attr @rip p_0_out[0] -pin g_mag_tilt.u_heading p_0_out[0] -pin u_mag_calibration p_0_out[0]
netloc p_0_out[2] 1 3 4 4310 2010 5630J 1190 7450J 1670 8280
load net samples_reg[0][3] -attr @rip B[11] -pin u_sensor B[11] -pin u_vector B[11]
load net vector_raw_pitch[14] -attr @rip D[50] -pin u_attitude_cdc D[122] -pin u_vector D[50]
load net roll_sync[0] -attr @style dashed -attr @rip 0 -pin u_sensor sensor_i_3_0[0] -pin u_vector roll_fallback_q10_reg[9][0]
load net u_trig/y[0] -attr @rip y[0] -pin g_mag_tilt.u_heading y[0] -pin u_vector y[0]
netloc u_trig/y[0] 1 2 4 NJ 4230 NJ 4230 NJ 4230 7830
load net vector_pitch[10] -attr @style dashed -attr @rip roll_reg[31]_0[0] -pin u_attitude_cdc retido_reg[238]_0[0] -pin u_vector roll_reg[31]_0[0]
load net vector_raw_roll[19] -attr @rip D[81] -pin u_attitude_cdc D[153] -pin u_vector D[81]
load net vector_roll[24] -attr @rip D[32] -pin u_attitude_cdc D[104] -pin u_vector D[32]
load net samples_reg[3][7] -attr @rip samples_reg[2][7]_0[7] -pin u_sensor samples_reg[2][7]_0[7] -pin u_vector p_1_in_1[7]
load net u_mag_calibration_n_165 -attr @rip max_x_reg[15]_0[2] -pin u_mag_calibration max_x_reg[15]_0[2] -pin u_magnetometro max_x_reg[15]_i_2_0[2]
load net u_mag_calibration_n_105 -attr @rip max_y_reg[15]_0[14] -pin u_mag_calibration max_y_reg[15]_0[14] -pin u_magnetometro max_y_reg[15]_i_2_0[14]
load net u_mag_calibration_n_134 -attr @rip min_x_reg[15]_0[9] -pin u_mag_calibration min_x_reg[15]_0[9] -pin u_magnetometro min_x_reg[15]_i_2_0[9]
load net u_mag_calibration_n_42 -attr @rip Q[5] -pin u_mag_calibration Q[5] -pin u_magnetometro min_z_reg[15]_i_3_0[5]
load net g_mag_tilt.u_heading_n_29 -pin g_mag_tilt.u_heading state_reg[2]_0 -pin u_magnetometro published_reg
netloc g_mag_tilt.u_heading_n_29 1 4 3 6150 1030 NJ 1030 8320
load net mag_profile_changed -pin u_mag_cal_planar mag_profile_changed -pin u_mag_calibration mag_profile_changed
netloc mag_profile_changed 1 2 3 2680 1950 3450J 1930 5030
load net u_vector_n_137 -attr @rip raw_pitch_reg[22]_0[3] -pin u_auto_zero near_neutral1_carry__2_0[3] -pin u_vector raw_pitch_reg[22]_0[3]
load net u_vector_n_218 -attr @rip raw_pitch_reg[8]_0[1] -pin u_auto_zero near_neutral0_carry__0_1[1] -pin u_vector raw_pitch_reg[8]_0[1]
load net u_vector_n_344 -attr @rip raw_roll_reg[8]_0[1] -pin u_auto_zero S[1] -pin u_vector raw_roll_reg[8]_0[1]
load net u_magnetometro_n_101 -pin u_mag_calibration age_reg[14]_0 -pin u_magnetometro amostra_nova_reg_10
netloc u_magnetometro_n_101 1 3 3 3590 3050 NJ 3050 7330
load net u_mag_calibration_n_74 -attr @rip max_z_reg[15]_1[1] -pin u_mag_calibration max_z_reg[15]_1[1] -pin u_magnetometro max_z_reg[0][1]
load net u_magnetometro_n_17 -attr @rip amostra_nova_reg_0[9] -pin g_mag_tilt.u_heading age_reg[25]_1[9] -pin u_magnetometro amostra_nova_reg_0[9]
load net compass_gravity_z[2] -attr @rip Q[2] -pin g_mag_tilt.u_heading gz_reg[24]_0[2] -pin u_vector Q[2]
load net compass_gravity_x[18] -attr @rip gravity_x_reg[23]_0[18] -pin g_mag_tilt.u_heading gx_reg[23]_0[18] -pin u_vector gravity_x_reg[23]_0[18]
load net last_y[6] -attr @rip last_y_reg[14]_0[6] -pin u_mag_calibration last_y_reg[14]_0[6] -pin u_magnetometro pipe_unique_reg_i_3_0[6]
load net mag_corrected_x[4] -attr @rip corrected_x_reg[15]_0[4] -pin u_mag_cal_planar Q[4] -pin u_mag_calibration corrected_x_reg[15]_0[4]
load net estado[0] -attr @rip estado[0] -pin u_mag_cal_planar estado[0] -pin u_mag_calibration estado[0]
load net mag_x[9] -attr @rip mag_x[9] -pin u_mag_calibration max_x_reg[15]_2[9] -pin u_magnetometro mag_x[9]
load net mag_z[9] -attr @rip mag_z[9] -pin u_mag_calibration pipe_z_reg[15]_0[9] -pin u_magnetometro mag_z[9]
load net mpu_accel_z[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[58] -pin u_sensor accel_x_reg[15]_0[58] -pin u_vector a_reg[0][15]_0[58]
load net mpu_raw_gx[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[42] -pin u_sensor accel_x_reg[15]_0[42] -pin u_vector a_reg[0][15]_0[42]
load net mpu_raw_ax[10] -attr @style dashed -attr @rip accel_x_reg[15]_0[90] -pin u_sensor accel_x_reg[15]_0[90] -pin u_vector a_reg[0][15]_0[90]
load net p_1_in_0[7] -attr @rip age_reg[25]_2[0] -pin u_mag_calibration age_reg[25]_2[0] -pin u_magnetometro age_reg[25]_0[0]
load net samples_reg[0][4] -attr @rip B[12] -pin u_sensor B[12] -pin u_vector B[12]
load net u_vec/i[0] -attr @rip E[0] -pin g_mag_tilt.u_heading E[0] -pin u_vector E[0]
netloc u_vec/i[0] 1 2 4 2700J 3130 NJ 3130 NJ 3130 7550
load net roll_sync[1] -attr @style dashed -attr @rip 1 -pin u_sensor sensor_i_3_0[1] -pin u_vector roll_fallback_q10_reg[9][1]
load net vector_pitch[11] -attr @rip D[10] -pin u_attitude_cdc D[82] -pin u_vector D[10]
load net vector_raw_roll[20] -attr @rip D[82] -pin u_attitude_cdc D[154] -pin u_vector D[82]
load net vector_raw_pitch[15] -attr @rip D[51] -pin u_attitude_cdc D[123] -pin u_vector D[51]
load net vector_roll[25] -attr @rip D[33] -pin u_attitude_cdc D[105] -pin u_vector D[33]
load net samples_reg[4][0] -attr @rip samples_reg[4][7]_0[8] -pin u_sensor samples_reg[4][7]_0[8] -pin u_vector p_1_in__0_0[8]
load net g_mag_tilt.u_heading_n_25 -attr @rip age_reg[25]_0[0] -pin g_mag_tilt.u_heading age_reg[25]_0[0] -pin u_magnetometro age_reg[25][0]
netloc g_mag_tilt.u_heading_n_25 1 4 3 6230 1170 7410J 1650 8340
load net u_mag_calibration_n_162 -attr @rip max_x_reg[15]_0[5] -pin u_mag_calibration max_x_reg[15]_0[5] -pin u_magnetometro max_x_reg[15]_i_2_0[5]
load net u_mag_calibration_n_102 -attr @rip max_y_reg[7]_0[1] -pin u_mag_calibration max_y_reg[7]_0[1] -pin u_magnetometro max_y_reg[15]_i_2_1[1]
load net u_mag_calibration_n_131 -attr @rip min_x_reg[15]_0[12] -pin u_mag_calibration min_x_reg[15]_0[12] -pin u_magnetometro min_x_reg[15]_i_2_0[12]
load net u_mag_calibration_n_39 -attr @rip Q[8] -pin u_mag_calibration Q[8] -pin u_magnetometro min_z_reg[15]_i_3_0[8]
load net u_sensor_n_8 -pin u_sensor sensor_ok_reg_0 -pin u_vector stale_reg[0]_1
netloc u_sensor_n_8 1 1 1 1310 3330n
load net u_vector_n_215 -attr @rip raw_pitch_reg[12]_1[0] -pin u_auto_zero near_neutral0_carry__1_0[0] -pin u_vector raw_pitch_reg[12]_1[0]
load net zero_set -attr @rip D[90] -pin u_attitude_cdc D[162] -pin u_vector D[90]
load net u_vector_n_134 -attr @rip raw_pitch_reg[14]_0[2] -pin u_auto_zero near_neutral1_carry__1_1[2] -pin u_vector raw_pitch_reg[14]_0[2]
load net u_magnetometro_n_1 -attr @rip amostra_nova_reg_0[25] -pin g_mag_tilt.u_heading age_reg[25]_1[25] -pin u_magnetometro amostra_nova_reg_0[25]
load net u_mag_calibration_n_71 -attr @rip max_z_reg[15]_0[0] -pin u_mag_calibration max_z_reg[15]_0[0] -pin u_magnetometro max_z_reg[15]_i_2_0[0]
load net u_magnetometro_n_8 -attr @rip amostra_nova_reg_0[18] -pin g_mag_tilt.u_heading age_reg[25]_1[18] -pin u_magnetometro amostra_nova_reg_0[18]
load net u_magnetometro_n_167 -attr @rip rx_bytes_reg[0][7]_0[11] -pin g_mag_tilt.u_heading bx_reg_0[11] -pin u_mag_calibration prod_x_reg_1[11] -pin u_magnetometro rx_bytes_reg[0][7]_0[11]
load net compass_gravity_x[15] -attr @rip gravity_x_reg[23]_0[15] -pin g_mag_tilt.u_heading gx_reg[23]_0[15] -pin u_vector gravity_x_reg[23]_0[15]
load net compass_gravity_y[23] -attr @rip gravity_y_reg[23]_0[23] -pin g_mag_tilt.u_heading gy_reg[24]_0[23] -pin u_vector gravity_y_reg[23]_0[23]
load net last_y[3] -attr @rip last_y_reg[14]_0[3] -pin u_mag_calibration last_y_reg[14]_0[3] -pin u_magnetometro pipe_unique_reg_i_3_0[3]
load net mag_corrected_x[1] -attr @rip corrected_x_reg[15]_0[1] -pin u_mag_cal_planar Q[1] -pin u_mag_calibration corrected_x_reg[15]_0[1]
load net mag_x[4] -attr @rip mag_x[4] -pin u_mag_calibration max_x_reg[15]_2[4] -pin u_magnetometro mag_x[4]
load net mag_z[4] -attr @rip mag_z[4] -pin u_mag_calibration pipe_z_reg[15]_0[4] -pin u_magnetometro mag_z[4]
load net mpu_accel_z[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[57] -pin u_sensor accel_x_reg[15]_0[57] -pin u_vector a_reg[0][15]_0[57]
load net mpu_raw_gx[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[41] -pin u_sensor accel_x_reg[15]_0[41] -pin u_vector a_reg[0][15]_0[41]
load net mpu_raw_ax[9] -attr @style dashed -attr @rip accel_x_reg[15]_0[89] -pin u_sensor accel_x_reg[15]_0[89] -pin u_vector a_reg[0][15]_0[89]
load net samples_reg[3][6] -attr @rip samples_reg[2][7]_0[6] -pin u_sensor samples_reg[2][7]_0[6] -pin u_vector p_1_in_1[6]
load net samples_reg[0][1] -attr @rip B[9] -pin u_sensor B[9] -pin u_vector B[9]
load net vector_pitch[7] -attr @rip D[7] -pin u_attitude_cdc D[79] -pin u_vector D[7]
load net vector_raw_roll[17] -attr @rip D[79] -pin u_attitude_cdc D[151] -pin u_vector D[79]
load net vector_raw_pitch[12] -attr @rip D[48] -pin u_attitude_cdc D[120] -pin u_vector D[48]
load net vector_roll[22] -attr @rip D[30] -pin u_attitude_cdc D[102] -pin u_vector D[30]
load net g_mag_tilt.u_heading_n_27 -pin g_mag_tilt.u_heading busy_reg -pin u_vector y_reg[31]
netloc g_mag_tilt.u_heading_n_27 1 1 6 1490 90 NJ 90 NJ 90 NJ 90 NJ 90 8460
load net u_mag_calibration_n_163 -attr @rip max_x_reg[15]_0[4] -pin u_mag_calibration max_x_reg[15]_0[4] -pin u_magnetometro max_x_reg[15]_i_2_0[4]
load net u_mag_calibration_n_103 -attr @rip max_y_reg[7]_0[0] -pin u_mag_calibration max_y_reg[7]_0[0] -pin u_magnetometro max_y_reg[15]_i_2_1[0]
load net u_mag_calibration_n_132 -attr @rip min_x_reg[15]_0[11] -pin u_mag_calibration min_x_reg[15]_0[11] -pin u_magnetometro min_x_reg[15]_i_2_0[11]
load net u_mag_calibration_n_40 -attr @rip Q[7] -pin u_mag_calibration Q[7] -pin u_magnetometro min_z_reg[15]_i_3_0[7]
load net u_vector_n_135 -attr @rip raw_pitch_reg[14]_0[1] -pin u_auto_zero near_neutral1_carry__1_1[1] -pin u_vector raw_pitch_reg[14]_0[1]
load net age_reg[0] -attr @rip age_reg[0]_0[0] -pin u_sensor age_reg[0] -pin u_vector age_reg[0]_0[0]
netloc age_reg[0] 1 0 3 460 2590 NJ 2590 2480
load net u_sensor_n_9 -attr @rip age_reg[0][0] -pin u_sensor age_reg[0][0] -pin u_vector age_reg[3]_0[0]
netloc u_sensor_n_9 1 1 1 N 3110
load net u_vector_n_216 -attr @rip raw_pitch_reg[8]_0[3] -pin u_auto_zero near_neutral0_carry__0_1[3] -pin u_vector raw_pitch_reg[8]_0[3]
load net u_vector_n_342 -attr @rip raw_roll_reg[8]_0[3] -pin u_auto_zero S[3] -pin u_vector raw_roll_reg[8]_0[3]
load net u_magnetometro_n_81 -pin u_mag_calibration state[2]_i_2__0_0 -pin u_magnetometro mag_x_reg[11]_0
netloc u_magnetometro_n_81 1 3 3 4110 2550 NJ 2550 6830
load net u_magnetometro_n_10 -attr @rip amostra_nova_reg_0[16] -pin g_mag_tilt.u_heading age_reg[25]_1[16] -pin u_magnetometro amostra_nova_reg_0[16]
load net u_magnetometro_n_168 -attr @rip rx_bytes_reg[0][7]_0[10] -pin g_mag_tilt.u_heading bx_reg_0[10] -pin u_mag_calibration prod_x_reg_1[10] -pin u_magnetometro rx_bytes_reg[0][7]_0[10]
load net u_mag_calibration_n_72 -attr @rip max_z_reg[15]_1[3] -pin u_mag_calibration max_z_reg[15]_1[3] -pin u_magnetometro max_z_reg[0][3]
load net compass_gravity_z[0] -attr @rip Q[0] -pin g_mag_tilt.u_heading gz_reg[24]_0[0] -pin u_vector Q[0]
load net compass_gravity_x[16] -attr @rip gravity_x_reg[23]_0[16] -pin g_mag_tilt.u_heading gx_reg[23]_0[16] -pin u_vector gravity_x_reg[23]_0[16]
load net last_y[4] -attr @rip last_y_reg[14]_0[4] -pin u_mag_calibration last_y_reg[14]_0[4] -pin u_magnetometro pipe_unique_reg_i_3_0[4]
load net mag_corrected_x[2] -attr @rip corrected_x_reg[15]_0[2] -pin u_mag_cal_planar Q[2] -pin u_mag_calibration corrected_x_reg[15]_0[2]
load net mag_x[5] -attr @rip mag_x[5] -pin u_mag_calibration max_x_reg[15]_2[5] -pin u_magnetometro mag_x[5]
load net mag_z[5] -attr @rip mag_z[5] -pin u_mag_calibration pipe_z_reg[15]_0[5] -pin u_magnetometro mag_z[5]
load net mpu_accel_z[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[55] -pin u_sensor accel_x_reg[15]_0[55] -pin u_vector a_reg[0][15]_0[55]
load net mpu_raw_gx[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[39] -pin u_sensor accel_x_reg[15]_0[39] -pin u_vector a_reg[0][15]_0[39]
load net mpu_raw_ax[7] -attr @style dashed -attr @rip accel_x_reg[15]_0[87] -pin u_sensor accel_x_reg[15]_0[87] -pin u_vector a_reg[0][15]_0[87]
load net vector_pitch[8] -attr @rip D[8] -pin u_attitude_cdc D[80] -pin u_vector D[8]
load net samples_reg[0][2] -attr @rip B[10] -pin u_sensor B[10] -pin u_vector B[10]
load net vector_raw_roll[18] -attr @rip D[80] -pin u_attitude_cdc D[152] -pin u_vector D[80]
load net vector_raw_pitch[13] -attr @rip D[49] -pin u_attitude_cdc D[121] -pin u_vector D[49]
load net vector_roll[23] -attr @rip D[31] -pin u_attitude_cdc D[103] -pin u_vector D[31]
load net reset_operacao -attr @style dashed -pin u_mag_calibration reset_operacao -pin u_render_trig reset_operacao
netloc reset_operacao 1 3 1 4090 1450n
load net g_mag_tilt.u_heading_n_31 -pin g_mag_tilt.u_heading state_reg[3]_0 -pin u_magnetometro age_reg[0]
netloc g_mag_tilt.u_heading_n_31 1 4 3 6210 990 NJ 990 8400
load net u_mag_calibration_n_168 -attr @rip max_x_reg[15]_1[3] -pin u_mag_calibration max_x_reg[15]_1[3] -pin u_magnetometro max_x_reg[0][3]
load net u_mag_calibration_n_108 -attr @rip max_y_reg[15]_0[11] -pin u_mag_calibration max_y_reg[15]_0[11] -pin u_magnetometro max_y_reg[15]_i_2_0[11]
load net u_mag_calibration_n_137 -attr @rip min_x_reg[15]_0[6] -pin u_mag_calibration min_x_reg[15]_0[6] -pin u_magnetometro min_x_reg[15]_i_2_0[6]
load net u_mag_calibration_n_45 -attr @rip Q[2] -pin u_mag_calibration Q[2] -pin u_magnetometro min_z_reg[15]_i_3_0[2]
load net heading_planar_updated -pin g_mag_tilt.u_heading heading_planar_updated -pin u_mag_cal_planar heading_planar_updated
netloc heading_planar_updated 1 3 3 3270J 1850 5510J 870 7770
load net u_vector_n_140 -attr @rip raw_pitch_reg[22]_0[0] -pin u_auto_zero near_neutral1_carry__2_0[0] -pin u_vector raw_pitch_reg[22]_0[0]
load net u_vector_n_347 -attr @rip raw_pitch_reg[6]_1[2] -pin u_auto_zero near_neutral1_carry__0_1[2] -pin u_vector raw_pitch_reg[6]_1[2]
load net u_vector_n_221 -attr @rip raw_roll_reg[24]_1[3] -pin u_auto_zero near_neutral2_carry__2_0[3] -pin u_vector raw_roll_reg[24]_1[3]
load net u_magnetometro_n_104 -pin u_mag_calibration age_reg[19]_0 -pin u_magnetometro amostra_nova_reg_13
netloc u_magnetometro_n_104 1 3 3 3990 2210 5030J 2430 6890
load net u_mag_calibration_n_77 -attr @rip min_y_reg[7]_0[2] -pin u_mag_calibration min_y_reg[7]_0[2] -pin u_magnetometro min_y_reg[15]_i_2_1[2]
load net u_magnetometro_n_172 -attr @rip rx_bytes_reg[0][7]_0[6] -pin g_mag_tilt.u_heading bx_reg_0[6] -pin u_mag_calibration prod_x_reg_1[6] -pin u_magnetometro rx_bytes_reg[0][7]_0[6]
load net u_magnetometro_n_88 -pin u_mag_calibration previous_y_reg[0]_0 -pin u_magnetometro sensor_ok_reg_0
netloc u_magnetometro_n_88 1 3 3 3970 2690 NJ 2690 6910
load net compass_gravity_z[5] -attr @rip Q[5] -pin g_mag_tilt.u_heading gz_reg[24]_0[5] -pin u_vector Q[5]
load net compass_gravity_x[21] -attr @rip gravity_x_reg[23]_0[21] -pin g_mag_tilt.u_heading gx_reg[23]_0[21] -pin u_vector gravity_x_reg[23]_0[21]
load net last_y[8] -attr @rip last_y_reg[14]_0[8] -pin u_mag_calibration last_y_reg[14]_0[8] -pin u_magnetometro pipe_unique_reg_i_3_0[8]
load net mag_corrected_x[9] -attr @rip corrected_x_reg[15]_0[9] -pin u_mag_cal_planar Q[9] -pin u_mag_calibration corrected_x_reg[15]_0[9]
load net mag_x[10] -attr @rip mag_x[10] -pin u_mag_calibration max_x_reg[15]_2[10] -pin u_magnetometro mag_x[10]
load net mag_z[10] -attr @rip mag_z[10] -pin u_mag_calibration pipe_z_reg[15]_0[10] -pin u_magnetometro mag_z[10]
load net mpu_accel_z[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[61] -pin u_sensor accel_x_reg[15]_0[61] -pin u_vector a_reg[0][15]_0[61]
load net mpu_raw_gx[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[45] -pin u_sensor accel_x_reg[15]_0[45] -pin u_vector a_reg[0][15]_0[45]
load net mpu_raw_ax[13] -attr @style dashed -attr @rip accel_x_reg[15]_0[93] -pin u_sensor accel_x_reg[15]_0[93] -pin u_vector a_reg[0][15]_0[93]
load net p_1_in_0[13] -attr @rip age_reg[25]_2[2] -pin u_mag_calibration age_reg[25]_2[2] -pin u_magnetometro age_reg[25]_0[2]
load net vector_raw_roll[23] -attr @rip D[85] -pin u_attitude_cdc D[157] -pin u_vector D[85]
load net rx_bytes_reg[3]_3[2] -attr @rip D[2] -pin g_mag_tilt.u_heading D[2] -pin u_magnetometro D[2]
load net vector_roll[31] -attr @style dashed -attr @rip roll_reg[31]_0[19] -pin u_attitude_cdc retido_reg[238]_0[19] -pin u_vector roll_reg[31]_0[19]
load net vector_raw_pitch[18] -attr @rip D[54] -pin u_attitude_cdc D[126] -pin u_vector D[54]
load net vector_pitch[14] -attr @style dashed -attr @rip roll_reg[31]_0[1] -pin u_attitude_cdc retido_reg[238]_0[1] -pin u_vector roll_reg[31]_0[1]
load net vector_calibration_debug[2] -attr @rip D[95] -pin u_attitude_cdc D[168] -pin u_vector D[95]
load net samples_reg[4][3] -attr @rip samples_reg[4][7]_0[11] -pin u_sensor samples_reg[4][7]_0[11] -pin u_vector p_1_in__0_0[11]
load net enabled0 -pin u_sensor enabled0 -pin u_vector enabled0
netloc enabled0 1 1 1 1330 3170n
load net near_neutral0__23 -attr @rip raw_pitch_reg[25]_0[0] -pin u_auto_zero raw_pitch_reg[25]_0[0] -pin u_vector done_i_3_0[0]
netloc near_neutral0__23 1 1 1 1050 3250n
load net g_mag_tilt.u_heading_n_4 -attr @rip Q[0] -pin g_mag_tilt.u_heading Q[0] -pin u_magnetometro Q[0]
netloc g_mag_tilt.u_heading_n_4 1 4 3 6130 910 NJ 910 8280
load net u_mag_calibration_n_169 -attr @rip max_x_reg[15]_1[2] -pin u_mag_calibration max_x_reg[15]_1[2] -pin u_magnetometro max_x_reg[0][2]
load net u_mag_calibration_n_138 -attr @rip min_x_reg[15]_0[5] -pin u_mag_calibration min_x_reg[15]_0[5] -pin u_magnetometro min_x_reg[15]_i_2_0[5]
load net u_mag_calibration_n_109 -attr @rip max_y_reg[15]_0[10] -pin u_mag_calibration max_y_reg[15]_0[10] -pin u_magnetometro max_y_reg[15]_i_2_0[10]
load net u_mag_calibration_n_46 -attr @rip Q[1] -pin u_mag_calibration Q[1] -pin u_magnetometro min_z_reg[15]_i_3_0[1]
load net heading_planar_valid -pin u_mag_cal_planar heading_planar_valid -pin u_mag_calibration heading_planar_valid
netloc heading_planar_valid 1 3 1 3250 790n
load net u_vector_n_141 -attr @rip raw_pitch_reg[24]_0[0] -pin u_auto_zero done_i_5_1[0] -pin u_vector raw_pitch_reg[24]_0[0]
netloc u_vector_n_141 1 0 3 360 4450 NJ 4450 2520
load net u_vector_n_348 -attr @rip raw_pitch_reg[6]_1[1] -pin u_auto_zero near_neutral1_carry__0_1[1] -pin u_vector raw_pitch_reg[6]_1[1]
load net u_vector_n_222 -attr @rip raw_roll_reg[24]_1[2] -pin u_auto_zero near_neutral2_carry__2_0[2] -pin u_vector raw_roll_reg[24]_1[2]
load net u_magnetometro_n_105 -pin u_mag_calibration age_reg[20]_0 -pin u_magnetometro amostra_nova_reg_14
netloc u_magnetometro_n_105 1 3 3 4170 2230 5150J 2450 6850
load net u_mag_calibration_n_78 -attr @rip min_y_reg[7]_0[1] -pin u_mag_calibration min_y_reg[7]_0[1] -pin u_magnetometro min_y_reg[15]_i_2_1[1]
load net u_magnetometro_n_89 -attr @rip mag_z_reg[15]_0[0] -pin u_mag_calibration min_z_reg[0]_0[0] -pin u_magnetometro mag_z_reg[15]_0[0]
netloc u_magnetometro_n_89 1 3 3 4050 2590 NJ 2590 6870
load net u_magnetometro_n_173 -attr @rip rx_bytes_reg[0][7]_0[5] -pin g_mag_tilt.u_heading bx_reg_0[5] -pin u_mag_calibration prod_x_reg_1[5] -pin u_magnetometro rx_bytes_reg[0][7]_0[5]
load net compass_gravity_z[6] -attr @rip Q[6] -pin g_mag_tilt.u_heading gz_reg[24]_0[6] -pin u_vector Q[6]
load net compass_gravity_x[22] -attr @rip gravity_x_reg[23]_0[22] -pin g_mag_tilt.u_heading gx_reg[23]_0[22] -pin u_vector gravity_x_reg[23]_0[22]
load net last_y[10] -attr @rip last_y_reg[14]_0[10] -pin u_mag_calibration last_y_reg[14]_0[10] -pin u_magnetometro pipe_unique_reg_i_3_0[10]
load net mag_corrected_x[7] -attr @rip corrected_x_reg[15]_0[7] -pin u_mag_cal_planar Q[7] -pin u_mag_calibration corrected_x_reg[15]_0[7]
load net mag_x[11] -attr @rip mag_x[11] -pin u_mag_calibration max_x_reg[15]_2[11] -pin u_magnetometro mag_x[11]
load net mag_z[11] -attr @rip mag_z[11] -pin u_mag_calibration pipe_z_reg[15]_0[11] -pin u_magnetometro mag_z[11]
load net mpu_accel_z[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[62] -pin u_sensor accel_x_reg[15]_0[62] -pin u_vector a_reg[0][15]_0[62]
load net mpu_raw_gx[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[46] -pin u_sensor accel_x_reg[15]_0[46] -pin u_vector a_reg[0][15]_0[46]
load net mpu_raw_ax[14] -attr @style dashed -attr @rip accel_x_reg[15]_0[94] -pin u_sensor accel_x_reg[15]_0[94] -pin u_vector a_reg[0][15]_0[94]
load net p_1_in_0[14] -attr @rip age_reg[25]_2[3] -pin u_mag_calibration age_reg[25]_2[3] -pin u_magnetometro age_reg[25]_0[3]
load net samples_reg[0][7] -attr @rip B[15] -pin u_sensor B[15] -pin u_vector B[15]
load net rx_bytes_reg[3]_3[3] -attr @rip D[3] -pin g_mag_tilt.u_heading D[3] -pin u_magnetometro D[3]
load net vector_calibration_debug[3] -attr @rip D[96] -pin u_attitude_cdc D[169] -pin u_vector D[96]
load net vector_pitch[15] -attr @style dashed -attr @rip roll_reg[31]_0[2] -pin u_attitude_cdc retido_reg[238]_0[2] -pin u_vector roll_reg[31]_0[2]
load net vector_raw_roll[24] -attr @rip D[86] -pin u_attitude_cdc D[158] -pin u_vector D[86]
load net vector_raw_pitch[19] -attr @rip D[55] -pin u_attitude_cdc D[127] -pin u_vector D[55]
load net samples_reg[4][4] -attr @rip samples_reg[4][7]_0[12] -pin u_sensor samples_reg[4][7]_0[12] -pin u_vector p_1_in__0_0[12]
load net reset0 -attr @rip SR[0] -pin u_sensor SR[0] -pin u_vector SR[0]
netloc reset0 1 0 3 420 2570 NJ 2570 2340
load net g_mag_tilt.u_heading_n_3 -attr @rip O[0] -pin g_mag_tilt.u_heading O[0] -pin u_magnetometro O[0]
load net done -pin u_auto_zero done -pin u_vector done
netloc done 1 1 1 950 3230n
load net have_last -pin u_mag_calibration have_last -pin u_magnetometro have_last
netloc have_last 1 4 1 5970 690n
load net u_mag_calibration_n_166 -attr @rip max_x_reg[15]_0[1] -pin u_mag_calibration max_x_reg[15]_0[1] -pin u_magnetometro max_x_reg[15]_i_2_0[1]
load net u_mag_calibration_n_43 -attr @rip Q[4] -pin u_mag_calibration Q[4] -pin u_magnetometro min_z_reg[15]_i_3_0[4]
load net u_mag_calibration_n_135 -attr @rip min_x_reg[15]_0[8] -pin u_mag_calibration min_x_reg[15]_0[8] -pin u_magnetometro min_x_reg[15]_i_2_0[8]
load net u_mag_calibration_n_106 -attr @rip max_y_reg[15]_0[13] -pin u_mag_calibration max_y_reg[15]_0[13] -pin u_magnetometro max_y_reg[15]_i_2_0[13]
load net u_vector_n_138 -attr @rip raw_pitch_reg[22]_0[2] -pin u_auto_zero near_neutral1_carry__2_0[2] -pin u_vector raw_pitch_reg[22]_0[2]
load net u_vector_n_219 -attr @rip raw_pitch_reg[8]_0[0] -pin u_auto_zero near_neutral0_carry__0_1[0] -pin u_vector raw_pitch_reg[8]_0[0]
load net u_vector_n_345 -attr @rip raw_roll_reg[8]_0[0] -pin u_auto_zero S[0] -pin u_vector raw_roll_reg[8]_0[0]
load net u_magnetometro_n_102 -pin u_mag_calibration age_reg[15]_0 -pin u_magnetometro amostra_nova_reg_11
netloc u_magnetometro_n_102 1 3 3 3890 2170 5190J 2390 7010
load net u_mag_calibration_n_75 -attr @rip max_z_reg[15]_1[0] -pin u_mag_calibration max_z_reg[15]_1[0] -pin u_magnetometro max_z_reg[0][0]
load net u_magnetometro_n_170 -attr @rip rx_bytes_reg[0][7]_0[8] -pin g_mag_tilt.u_heading bx_reg_0[8] -pin u_mag_calibration prod_x_reg_1[8] -pin u_magnetometro rx_bytes_reg[0][7]_0[8]
load net u_magnetometro_n_85 -attr @style dashed -pin u_mag_calibration state_reg[3]_3 -pin u_magnetometro state_reg[0]
netloc u_magnetometro_n_85 1 3 3 3930 2710 NJ 2710 6810
load net compass_gravity_z[3] -attr @rip Q[3] -pin g_mag_tilt.u_heading gz_reg[24]_0[3] -pin u_vector Q[3]
load net compass_gravity_x[19] -attr @rip gravity_x_reg[23]_0[19] -pin g_mag_tilt.u_heading gx_reg[23]_0[19] -pin u_vector gravity_x_reg[23]_0[19]
load net last_y[9] -attr @rip last_y_reg[14]_0[9] -pin u_mag_calibration last_y_reg[14]_0[9] -pin u_magnetometro pipe_unique_reg_i_3_0[9]
load net mag_corrected_x[5] -attr @rip corrected_x_reg[15]_0[5] -pin u_mag_cal_planar Q[5] -pin u_mag_calibration corrected_x_reg[15]_0[5]
load net estado[1] -attr @rip estado[1] -pin u_mag_cal_planar estado[1] -pin u_mag_calibration estado[1]
load net mag_x[7] -attr @rip mag_x[7] -pin u_mag_calibration max_x_reg[15]_2[7] -pin u_magnetometro mag_x[7]
load net mag_z[7] -attr @rip mag_z[7] -pin u_mag_calibration pipe_z_reg[15]_0[7] -pin u_magnetometro mag_z[7]
load net mpu_accel_z[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[59] -pin u_sensor accel_x_reg[15]_0[59] -pin u_vector a_reg[0][15]_0[59]
load net mpu_raw_gx[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[43] -pin u_sensor accel_x_reg[15]_0[43] -pin u_vector a_reg[0][15]_0[43]
load net mpu_raw_ax[11] -attr @style dashed -attr @rip accel_x_reg[15]_0[91] -pin u_sensor accel_x_reg[15]_0[91] -pin u_vector a_reg[0][15]_0[91]
load net p_1_in_0[12] -attr @rip age_reg[25]_2[1] -pin u_mag_calibration age_reg[25]_2[1] -pin u_magnetometro age_reg[25]_0[1]
load net samples_reg[4][1] -attr @rip samples_reg[4][7]_0[9] -pin u_sensor samples_reg[4][7]_0[9] -pin u_vector p_1_in__0_0[9]
load net vector_calibration_debug[0] -attr @rip D[93] -pin u_attitude_cdc D[166] -pin u_vector D[93]
load net samples_reg[0][5] -attr @rip B[13] -pin u_sensor B[13] -pin u_vector B[13]
load net rx_bytes_reg[3]_3[0] -attr @rip D[0] -pin g_mag_tilt.u_heading D[0] -pin u_magnetometro D[0]
load net vector_raw_roll[21] -attr @rip D[83] -pin u_attitude_cdc D[155] -pin u_vector D[83]
load net vector_raw_pitch[16] -attr @rip D[52] -pin u_attitude_cdc D[124] -pin u_vector D[52]
load net vector_roll[26] -attr @rip D[34] -pin u_attitude_cdc D[106] -pin u_vector D[34]
load net vector_pitch[12] -attr @rip D[11] -pin u_attitude_cdc D[83] -pin u_vector D[11]
load net reset0_8 -attr @rip inicio_operacao_reg[3][0] -pin u_sensor inicio_operacao_reg[3][0] -pin u_vector angle_out_reg[6][0]
netloc reset0_8 1 1 1 1350 3170n
load net g_mag_tilt.u_heading_n_30 -pin g_mag_tilt.u_heading state_reg[1]_0 -pin u_magnetometro age_reg[0]_0
netloc g_mag_tilt.u_heading_n_30 1 4 3 6110 1010 NJ 1010 8360
load net u_mag_calibration_n_167 -attr @rip max_x_reg[15]_0[0] -pin u_mag_calibration max_x_reg[15]_0[0] -pin u_magnetometro max_x_reg[15]_i_2_0[0]
load net u_mag_calibration_n_136 -attr @rip min_x_reg[15]_0[7] -pin u_mag_calibration min_x_reg[15]_0[7] -pin u_magnetometro min_x_reg[15]_i_2_0[7]
load net u_mag_calibration_n_107 -attr @rip max_y_reg[15]_0[12] -pin u_mag_calibration max_y_reg[15]_0[12] -pin u_magnetometro max_y_reg[15]_i_2_0[12]
load net u_mag_calibration_n_44 -attr @rip Q[3] -pin u_mag_calibration Q[3] -pin u_magnetometro min_z_reg[15]_i_3_0[3]
load net heading_approved_valid -pin g_mag_tilt.u_heading heading_approved_valid -pin u_mag_calibration heading_approved_valid
netloc heading_approved_valid 1 3 4 4350 70 NJ 70 NJ 70 8480
load net u_vector_n_139 -attr @rip raw_pitch_reg[22]_0[1] -pin u_auto_zero near_neutral1_carry__2_0[1] -pin u_vector raw_pitch_reg[22]_0[1]
load net u_vector_n_220 -pin u_auto_zero near_neutral0_carry__0_0 -pin u_vector raw_pitch_reg[0]_0
netloc u_vector_n_220 1 0 3 220 3430 1210J 2730 2220
load net u_vector_n_346 -attr @rip raw_pitch_reg[6]_1[3] -pin u_auto_zero near_neutral1_carry__0_1[3] -pin u_vector raw_pitch_reg[6]_1[3]
load net u_magnetometro_n_103 -pin u_mag_calibration age_reg[17]_0 -pin u_magnetometro amostra_nova_reg_12
netloc u_magnetometro_n_103 1 3 3 3950 2190 5170J 2410 6950
load net u_mag_calibration_n_76 -attr @rip min_y_reg[7]_0[3] -pin u_mag_calibration min_y_reg[7]_0[3] -pin u_magnetometro min_y_reg[15]_i_2_1[3]
load net u_magnetometro_n_86 -pin u_mag_calibration reason_reg[1]_1 -pin u_magnetometro invalid_now_reg_0
netloc u_magnetometro_n_86 1 3 3 4150 2250 5130J 2470 6790
load net u_magnetometro_n_171 -attr @rip rx_bytes_reg[0][7]_0[7] -pin g_mag_tilt.u_heading bx_reg_0[7] -pin u_mag_calibration prod_x_reg_1[7] -pin u_magnetometro rx_bytes_reg[0][7]_0[7]
load net compass_gravity_z[4] -attr @rip Q[4] -pin g_mag_tilt.u_heading gz_reg[24]_0[4] -pin u_vector Q[4]
load net compass_gravity_x[20] -attr @rip gravity_x_reg[23]_0[20] -pin g_mag_tilt.u_heading gx_reg[23]_0[20] -pin u_vector gravity_x_reg[23]_0[20]
load net last_y[7] -attr @rip last_y_reg[14]_0[7] -pin u_mag_calibration last_y_reg[14]_0[7] -pin u_magnetometro pipe_unique_reg_i_3_0[7]
load net mag_corrected_x[6] -attr @rip corrected_x_reg[15]_0[6] -pin u_mag_cal_planar Q[6] -pin u_mag_calibration corrected_x_reg[15]_0[6]
load net estado[2] -attr @rip estado[2] -pin u_mag_cal_planar estado[2] -pin u_mag_calibration estado[2]
load net mag_x[8] -attr @rip mag_x[8] -pin u_mag_calibration max_x_reg[15]_2[8] -pin u_magnetometro mag_x[8]
load net mag_z[8] -attr @rip mag_z[8] -pin u_mag_calibration pipe_z_reg[15]_0[8] -pin u_magnetometro mag_z[8]
load net mpu_accel_z[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[60] -pin u_sensor accel_x_reg[15]_0[60] -pin u_vector a_reg[0][15]_0[60]
load net mpu_raw_gx[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[44] -pin u_sensor accel_x_reg[15]_0[44] -pin u_vector a_reg[0][15]_0[44]
load net mpu_raw_ax[12] -attr @style dashed -attr @rip accel_x_reg[15]_0[92] -pin u_sensor accel_x_reg[15]_0[92] -pin u_vector a_reg[0][15]_0[92]
load net samples_reg[0][6] -attr @rip B[14] -pin u_sensor B[14] -pin u_vector B[14]
load net rx_bytes_reg[3]_3[1] -attr @rip D[1] -pin g_mag_tilt.u_heading D[1] -pin u_magnetometro D[1]
load net vector_pitch[13] -attr @rip D[12] -pin u_attitude_cdc D[84] -pin u_vector D[12]
load net vector_raw_roll[22] -attr @rip D[84] -pin u_attitude_cdc D[156] -pin u_vector D[84]
load net vector_raw_pitch[17] -attr @rip D[53] -pin u_attitude_cdc D[125] -pin u_vector D[53]
load net vector_roll[27] -attr @rip D[35] -pin u_attitude_cdc D[107] -pin u_vector D[35]
load net vector_calibration_debug[1] -attr @rip D[94] -pin u_attitude_cdc D[167] -pin u_vector D[94]
load net samples_reg[4][2] -attr @rip samples_reg[4][7]_0[10] -pin u_sensor samples_reg[4][7]_0[10] -pin u_vector p_1_in__0_0[10]
load net mag_cal_active -pin u_mag_calibration mag_cal_active -pin u_vector mag_cal_active
netloc mag_cal_active 1 1 4 1530 1870 NJ 1870 NJ 1870 5210
load net g_mag_tilt.u_heading_n_2 -attr @rip O[1] -pin g_mag_tilt.u_heading O[1] -pin u_magnetometro O[1]
load net u_mag_calibration_n_156 -attr @rip max_x_reg[15]_0[11] -pin u_mag_calibration max_x_reg[15]_0[11] -pin u_magnetometro max_x_reg[15]_i_2_0[11]
load net u_mag_calibration_n_126 -attr @rip min_x_reg[7]_0[1] -pin u_mag_calibration min_x_reg[7]_0[1] -pin u_magnetometro min_x_reg[15]_i_2_1[1]
load net u_mag_calibration_n_33 -attr @rip Q[14] -pin u_mag_calibration Q[14] -pin u_magnetometro min_z_reg[15]_i_3_0[14]
load net u_mag_cal_controls_n_7 -attr @style dashed -pin u_mag_calibration reason_reg[1]_0 -pin u_magnetometro reason_reg[0]
netloc u_mag_cal_controls_n_7 1 3 2 4190 2150 5210J
load net u_vector_n_128 -attr @rip raw_pitch_reg[6]_0[2] -pin u_auto_zero near_neutral1_carry__0_0[2] -pin u_vector raw_pitch_reg[6]_0[2]
load net u_sensor_n_10 -pin u_sensor sensor_ok_reg_1 -pin u_vector magnitude_product_reg[15]_0
netloc u_sensor_n_10 1 1 1 1410 3350n
load net u_vector_n_209 -attr @rip raw_pitch_reg[24]_1[0] -pin u_auto_zero near_neutral0_carry__2_0[0] -pin u_vector raw_pitch_reg[24]_1[0]
load net u_magnetometro_n_154 -attr @rip D[8] -pin g_mag_tilt.u_heading D[8] -pin u_magnetometro D[8]
load net u_magnetometro_n_3 -attr @rip amostra_nova_reg_0[23] -pin g_mag_tilt.u_heading age_reg[25]_1[23] -pin u_magnetometro amostra_nova_reg_0[23]
load net u_mag_calibration_n_65 -attr @rip max_z_reg[15]_0[6] -pin u_mag_calibration max_z_reg[15]_0[6] -pin u_magnetometro max_z_reg[15]_i_2_0[6]
load net u_mag_calibration_n_95 -attr @rip min_y_reg[15]_0[0] -pin u_mag_calibration min_y_reg[15]_0[0] -pin u_magnetometro min_y_reg[15]_i_2_0[0]
load net compass_gravity_x[8] -attr @rip gravity_x_reg[23]_0[8] -pin g_mag_tilt.u_heading gx_reg[23]_0[8] -pin u_vector gravity_x_reg[23]_0[8]
load net compass_gravity_y[17] -attr @rip gravity_y_reg[23]_0[17] -pin g_mag_tilt.u_heading gy_reg[24]_0[17] -pin u_vector gravity_y_reg[23]_0[17]
load net last_z[14] -attr @rip last_z_reg[14]_0[14] -pin u_mag_calibration last_z_reg[14]_0[14] -pin u_magnetometro pipe_unique_reg_i_2_0[14]
load net last_x[12] -attr @rip last_x_reg[14]_0[12] -pin u_mag_calibration last_x_reg[14]_0[12] -pin u_magnetometro pipe_unique_reg_i_4_0[12]
load net mag_corrected_y[11] -attr @rip corrected_y_reg[15]_0[11] -pin u_mag_cal_planar corrigido_y_reg[15]_0[11] -pin u_mag_calibration corrected_y_reg[15]_0[11]
load net mag_y[14] -attr @rip mag_y[14] -pin u_mag_calibration max_y_reg[15]_2[14] -pin u_magnetometro mag_y[14]
load net mpu_raw_gx[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[33] -pin u_sensor accel_x_reg[15]_0[33] -pin u_vector a_reg[0][15]_0[33]
load net mpu_accel_z[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[49] -pin u_sensor accel_x_reg[15]_0[49] -pin u_vector a_reg[0][15]_0[49]
load net mpu_raw_ax[1] -attr @style dashed -attr @rip accel_x_reg[15]_0[81] -pin u_sensor accel_x_reg[15]_0[81] -pin u_vector a_reg[0][15]_0[81]
load net vector_pitch[2] -attr @rip D[2] -pin u_attitude_cdc D[74] -pin u_vector D[2]
load net samples_reg[3][0] -attr @rip samples_reg[2][7]_0[0] -pin u_sensor samples_reg[2][7]_0[0] -pin u_vector p_1_in_1[0]
load net vector_raw_pitch[6] -attr @rip D[42] -pin u_attitude_cdc D[114] -pin u_vector D[42]
load net vector_raw_roll[11] -attr @rip D[73] -pin u_attitude_cdc D[145] -pin u_vector D[73]
load net vector_roll[16] -attr @rip D[24] -pin u_attitude_cdc D[96] -pin u_vector D[24]
load net rx_bytes_reg[5]_1[4] -attr @rip rx_bytes_reg[4][7]_0[4] -pin g_mag_tilt.u_heading by_reg_0[4] -pin u_mag_calibration prod_y_reg_0[4] -pin u_magnetometro rx_bytes_reg[4][7]_0[4]
load net g_mag_tilt.u_heading_n_20 -attr @rip age_reg[20]_0[0] -pin g_mag_tilt.u_heading age_reg[20]_0[0] -pin u_magnetometro age_reg[20][0]
load net u_mag_calibration_n_157 -attr @rip max_x_reg[15]_0[10] -pin u_mag_calibration max_x_reg[15]_0[10] -pin u_magnetometro max_x_reg[15]_i_2_0[10]
load net u_mag_calibration_n_127 -attr @rip min_x_reg[7]_0[0] -pin u_mag_calibration min_x_reg[7]_0[0] -pin u_magnetometro min_x_reg[15]_i_2_1[0]
load net u_mag_calibration_n_34 -attr @rip Q[13] -pin u_mag_calibration Q[13] -pin u_magnetometro min_z_reg[15]_i_3_0[13]
load net u_sensor_n_11 -pin u_sensor sensor_ok_reg_2 -pin u_vector zero_set_reg_0
netloc u_sensor_n_11 1 1 1 1230 3370n
load net u_magnetometro_n_4 -attr @rip amostra_nova_reg_0[22] -pin g_mag_tilt.u_heading age_reg[25]_1[22] -pin u_magnetometro amostra_nova_reg_0[22]
load net u_vector_n_129 -attr @rip raw_pitch_reg[6]_0[1] -pin u_auto_zero near_neutral1_carry__0_0[1] -pin u_vector raw_pitch_reg[6]_0[1]
load net u_vector_n_210 -attr @rip raw_pitch_reg[16]_0[3] -pin u_auto_zero near_neutral0_carry__1_1[3] -pin u_vector raw_pitch_reg[16]_0[3]
load net u_magnetometro_n_16 -attr @rip amostra_nova_reg_0[10] -pin g_mag_tilt.u_heading age_reg[25]_1[10] -pin u_magnetometro amostra_nova_reg_0[10]
load net u_mag_calibration_n_66 -attr @rip max_z_reg[15]_0[5] -pin u_mag_calibration max_z_reg[15]_0[5] -pin u_magnetometro max_z_reg[15]_i_2_0[5]
load net u_mag_calibration_n_96 -attr @rip min_y_reg[15]_1[3] -pin u_mag_calibration min_y_reg[15]_1[3] -pin u_magnetometro min_y_reg[0][3]
load net compass_gravity_x[10] -attr @rip gravity_x_reg[23]_0[10] -pin g_mag_tilt.u_heading gx_reg[23]_0[10] -pin u_vector gravity_x_reg[23]_0[10]
load net compass_gravity_y[18] -attr @rip gravity_y_reg[23]_0[18] -pin g_mag_tilt.u_heading gy_reg[24]_0[18] -pin u_vector gravity_y_reg[23]_0[18]
load net last_x[13] -attr @rip last_x_reg[14]_0[13] -pin u_mag_calibration last_x_reg[14]_0[13] -pin u_magnetometro pipe_unique_reg_i_4_0[13]
load net mag_corrected_y[12] -attr @rip corrected_y_reg[15]_0[12] -pin u_mag_cal_planar corrigido_y_reg[15]_0[12] -pin u_mag_calibration corrected_y_reg[15]_0[12]
load net mag_y[15] -attr @rip mag_y[15] -pin u_mag_calibration max_y_reg[15]_2[15] -pin u_magnetometro mag_y[15]
load net mpu_accel_z[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[50] -pin u_sensor accel_x_reg[15]_0[50] -pin u_vector a_reg[0][15]_0[50]
load net mpu_raw_gx[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[34] -pin u_sensor accel_x_reg[15]_0[34] -pin u_vector a_reg[0][15]_0[34]
load net mpu_raw_ax[2] -attr @style dashed -attr @rip accel_x_reg[15]_0[82] -pin u_sensor accel_x_reg[15]_0[82] -pin u_vector a_reg[0][15]_0[82]
load net samples_reg[3][1] -attr @rip samples_reg[2][7]_0[1] -pin u_sensor samples_reg[2][7]_0[1] -pin u_vector p_1_in_1[1]
load net vector_pitch[3] -attr @rip D[3] -pin u_attitude_cdc D[75] -pin u_vector D[3]
load net vector_raw_pitch[9] -attr @rip D[45] -pin u_attitude_cdc D[117] -pin u_vector D[45]
load net vector_raw_roll[12] -attr @rip D[74] -pin u_attitude_cdc D[146] -pin u_vector D[74]
load net vector_roll[17] -attr @rip D[25] -pin u_attitude_cdc D[97] -pin u_vector D[25]
load net rx_bytes_reg[5]_1[5] -attr @rip rx_bytes_reg[4][7]_0[5] -pin g_mag_tilt.u_heading by_reg_0[5] -pin u_mag_calibration prod_y_reg_0[5] -pin u_magnetometro rx_bytes_reg[4][7]_0[5]
load net u_mag_calibration_n_31 -attr @rip S[0] -pin u_mag_calibration S[0] -pin u_magnetometro S[0]
load net g_mag_tilt.u_heading_n_18 -attr @rip age_reg[20]_0[2] -pin g_mag_tilt.u_heading age_reg[20]_0[2] -pin u_magnetometro age_reg[20][2]
load net u_mag_calibration_n_154 -attr @rip max_x_reg[15]_0[13] -pin u_mag_calibration max_x_reg[15]_0[13] -pin u_magnetometro max_x_reg[15]_i_2_0[13]
load net u_mag_calibration_n_124 -attr @rip min_x_reg[7]_0[3] -pin u_mag_calibration min_x_reg[7]_0[3] -pin u_magnetometro min_x_reg[15]_i_2_1[3]
load net u_vector_n_126 -attr @rip raw_pitch_reg[25]_1[0] -pin u_auto_zero done_i_5_0[0] -pin u_vector raw_pitch_reg[25]_1[0]
netloc u_vector_n_126 1 0 3 320 4430 NJ 4430 2380
load net u_vector_n_207 -attr @rip raw_pitch_reg[24]_1[2] -pin u_auto_zero near_neutral0_carry__2_0[2] -pin u_vector raw_pitch_reg[24]_1[2]
load net u_magnetometro_n_152 -attr @rip D[10] -pin g_mag_tilt.u_heading D[10] -pin u_magnetometro D[10]
load net u_magnetometro_n_27 -pin g_mag_tilt.u_heading age_reg[0]_0 -pin u_magnetometro amostra_nova_reg_1
netloc u_magnetometro_n_27 1 5 1 7430 1170n
load net u_mag_calibration_n_63 -attr @rip max_z_reg[15]_0[8] -pin u_mag_calibration max_z_reg[15]_0[8] -pin u_magnetometro max_z_reg[15]_i_2_0[8]
load net u_mag_calibration_n_93 -attr @rip min_y_reg[15]_0[2] -pin u_mag_calibration min_y_reg[15]_0[2] -pin u_magnetometro min_y_reg[15]_i_2_0[2]
load net compass_gravity_z[23] -attr @rip Q[23] -pin g_mag_tilt.u_heading gz_reg[24]_0[23] -pin u_vector Q[23]
load net compass_gravity_x[9] -attr @rip gravity_x_reg[23]_0[9] -pin g_mag_tilt.u_heading gx_reg[23]_0[9] -pin u_vector gravity_x_reg[23]_0[9]
load net compass_gravity_y[15] -attr @rip gravity_y_reg[23]_0[15] -pin g_mag_tilt.u_heading gy_reg[24]_0[15] -pin u_vector gravity_y_reg[23]_0[15]
load net last_z[12] -attr @rip last_z_reg[14]_0[12] -pin u_mag_calibration last_z_reg[14]_0[12] -pin u_magnetometro pipe_unique_reg_i_2_0[12]
load net last_x[10] -attr @rip last_x_reg[14]_0[10] -pin u_mag_calibration last_x_reg[14]_0[10] -pin u_magnetometro pipe_unique_reg_i_4_0[10]
load net mag_corrected_y[8] -attr @rip corrected_y_reg[15]_0[8] -pin u_mag_cal_planar corrigido_y_reg[15]_0[8] -pin u_mag_calibration corrected_y_reg[15]_0[8]
load net mag_y[12] -attr @rip mag_y[12] -pin u_mag_calibration max_y_reg[15]_2[12] -pin u_magnetometro mag_y[12]
load net mpu_gyro_z[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[15] -pin u_sensor accel_x_reg[15]_0[15] -pin u_vector a_reg[0][15]_0[15]
load net mpu_raw_ay[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[79] -pin u_sensor accel_x_reg[15]_0[79] -pin u_vector a_reg[0][15]_0[79]
load net mpu_raw_gy[15] -attr @style dashed -attr @rip accel_x_reg[15]_0[31] -pin u_sensor accel_x_reg[15]_0[31] -pin u_vector a_reg[0][15]_0[31]
load net vector_raw_pitch[4] -attr @rip D[40] -pin u_attitude_cdc D[112] -pin u_vector D[40]
load net vector_pitch[0] -attr @rip D[0] -pin u_attitude_cdc D[72] -pin u_vector D[0]
load net vector_raw_roll[8] -attr @rip D[70] -pin u_attitude_cdc D[142] -pin u_vector D[70]
load net vector_roll[14] -attr @rip D[22] -pin u_attitude_cdc D[94] -pin u_vector D[22]
load net rx_bytes_reg[5]_1[2] -attr @rip rx_bytes_reg[4][7]_0[2] -pin g_mag_tilt.u_heading by_reg_0[2] -pin u_mag_calibration prod_y_reg_0[2] -pin u_magnetometro rx_bytes_reg[4][7]_0[2]
load net mag_amostra_nova -pin g_mag_tilt.u_heading mag_amostra_nova -pin u_magnetometro mag_amostra_nova
netloc mag_amostra_nova 1 5 1 7530 1430n
load net age1 -pin u_mag_calibration age1 -pin u_magnetometro age1
netloc age1 1 3 3 4030 30 NJ 30 6850
load net g_mag_tilt.u_heading_n_19 -attr @rip age_reg[20]_0[1] -pin g_mag_tilt.u_heading age_reg[20]_0[1] -pin u_magnetometro age_reg[20][1]
load net u_mag_calibration_n_155 -attr @rip max_x_reg[15]_0[12] -pin u_mag_calibration max_x_reg[15]_0[12] -pin u_magnetometro max_x_reg[15]_i_2_0[12]
load net u_mag_calibration_n_125 -attr @rip min_x_reg[7]_0[2] -pin u_mag_calibration min_x_reg[7]_0[2] -pin u_magnetometro min_x_reg[15]_i_2_1[2]
load net u_mag_calibration_n_32 -attr @rip Q[15] -pin u_mag_calibration Q[15] -pin u_magnetometro min_z_reg[15]_i_3_0[15]
load net u_vector_n_127 -attr @rip raw_pitch_reg[6]_0[3] -pin u_auto_zero near_neutral1_carry__0_0[3] -pin u_vector raw_pitch_reg[6]_0[3]
load net u_vector_n_208 -attr @rip raw_pitch_reg[24]_1[1] -pin u_auto_zero near_neutral0_carry__2_0[1] -pin u_vector raw_pitch_reg[24]_1[1]
load net u_magnetometro_n_153 -attr @rip D[9] -pin g_mag_tilt.u_heading D[9] -pin u_magnetometro D[9]
load net u_mag_calibration_n_64 -attr @rip max_z_reg[15]_0[7] -pin u_mag_calibration max_z_reg[15]_0[7] -pin u_magnetometro max_z_reg[15]_i_2_0[7]
load net u_mag_calibration_n_94 -attr @rip min_y_reg[15]_0[1] -pin u_mag_calibration min_y_reg[15]_0[1] -pin u_magnetometro min_y_reg[15]_i_2_0[1]
load net u_magnetometro_n_29 -pin g_mag_tilt.u_heading state_reg[2]_rep__0_0 -pin u_magnetometro amostra_nova_reg_2
netloc u_magnetometro_n_29 1 5 1 7490 1470n
load net compass_gravity_x[7] -attr @rip gravity_x_reg[23]_0[7] -pin g_mag_tilt.u_heading gx_reg[23]_0[7] -pin u_vector gravity_x_reg[23]_0[7]
load net compass_gravity_y[16] -attr @rip gravity_y_reg[23]_0[16] -pin g_mag_tilt.u_heading gy_reg[24]_0[16] -pin u_vector gravity_y_reg[23]_0[16]
load net last_z[13] -attr @rip last_z_reg[14]_0[13] -pin u_mag_calibration last_z_reg[14]_0[13] -pin u_magnetometro pipe_unique_reg_i_2_0[13]
load net last_x[11] -attr @rip last_x_reg[14]_0[11] -pin u_mag_calibration last_x_reg[14]_0[11] -pin u_magnetometro pipe_unique_reg_i_4_0[11]
load net mag_corrected_y[10] -attr @rip corrected_y_reg[15]_0[10] -pin u_mag_cal_planar corrigido_y_reg[15]_0[10] -pin u_mag_calibration corrected_y_reg[15]_0[10]
load net mag_y[13] -attr @rip mag_y[13] -pin u_mag_calibration max_y_reg[15]_2[13] -pin u_magnetometro mag_y[13]
load net mpu_raw_ax[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[80] -pin u_sensor accel_x_reg[15]_0[80] -pin u_vector a_reg[0][15]_0[80]
load net mpu_raw_gx[0] -attr @style dashed -attr @rip accel_x_reg[15]_0[32] -pin u_sensor accel_x_reg[15]_0[32] -pin u_vector a_reg[0][15]_0[32]
load net samples_reg[2][7] -attr @rip samples_reg[2][7]_0[15] -pin u_sensor samples_reg[2][7]_0[15] -pin u_vector p_1_in_1[15]
load net vector_pitch[1] -attr @rip D[1] -pin u_attitude_cdc D[73] -pin u_vector D[1]
load net vector_raw_roll[10] -attr @rip D[72] -pin u_attitude_cdc D[144] -pin u_vector D[72]
load net vector_raw_pitch[5] -attr @rip D[41] -pin u_attitude_cdc D[113] -pin u_vector D[41]
load net vector_roll[15] -attr @rip D[23] -pin u_attitude_cdc D[95] -pin u_vector D[23]
load net rx_bytes_reg[5]_1[3] -attr @rip rx_bytes_reg[4][7]_0[3] -pin g_mag_tilt.u_heading by_reg_0[3] -pin u_mag_calibration prod_y_reg_0[3] -pin u_magnetometro rx_bytes_reg[4][7]_0[3]
load net g_mag_tilt.u_heading_n_23 -attr @rip age_reg[24]_0[1] -pin g_mag_tilt.u_heading age_reg[24]_0[1] -pin u_magnetometro age_reg[24][1]
load net u_mag_calibration_n_160 -attr @rip max_x_reg[15]_0[7] -pin u_mag_calibration max_x_reg[15]_0[7] -pin u_magnetometro max_x_reg[15]_i_2_0[7]
load net u_mag_calibration_n_100 -attr @rip max_y_reg[7]_0[3] -pin u_mag_calibration max_y_reg[7]_0[3] -pin u_magnetometro max_y_reg[15]_i_2_1[3]
load net u_mag_calibration_n_37 -attr @rip Q[10] -pin u_mag_calibration Q[10] -pin u_magnetometro min_z_reg[15]_i_3_0[10]
load net u_mag_calibration_n_13 -pin u_mag_calibration have_train_reg_0 -pin u_magnetometro pipe_unique_reg
netloc u_mag_calibration_n_13 1 4 1 5870 710n
load net u_vector_n_132 -attr @rip raw_pitch_reg[12]_0[0] -pin u_auto_zero near_neutral1_carry__1_0[0] -pin u_vector raw_pitch_reg[12]_0[0]
load net u_sensor_n_2 -pin u_sensor operation_reg[2]_0 -pin u_vector p_1_in_0
netloc u_sensor_n_2 1 1 1 1030 3250n
load net zero_rejected -attr @rip D[91] -pin u_attitude_cdc D[163] -pin u_vector D[91]
load net u_vector_n_337 -pin u_mag_calibration suspect_reg_1 -pin u_vector active_reg
netloc u_vector_n_337 1 2 2 2520J 3370 3430
load net u_vector_n_213 -attr @rip raw_pitch_reg[16]_0[0] -pin u_auto_zero near_neutral0_carry__1_1[0] -pin u_vector raw_pitch_reg[16]_0[0]
load net u_mag_calibration_n_69 -attr @rip max_z_reg[15]_0[2] -pin u_mag_calibration max_z_reg[15]_0[2] -pin u_magnetometro max_z_reg[15]_i_2_0[2]
load net u_mag_calibration_n_99 -attr @rip min_y_reg[15]_1[0] -pin u_mag_calibration min_y_reg[15]_1[0] -pin u_magnetometro min_y_reg[0][0]
load net u_magnetometro_n_7 -attr @rip amostra_nova_reg_0[19] -pin g_mag_tilt.u_heading age_reg[25]_1[19] -pin u_magnetometro amostra_nova_reg_0[19]
load net u_magnetometro_n_165 -attr @rip rx_bytes_reg[0][7]_0[13] -pin g_mag_tilt.u_heading bx_reg_0[13] -pin u_mag_calibration prod_x_reg_1[13] -pin u_magnetometro rx_bytes_reg[0][7]_0[13]
load net compass_gravity_x[13] -attr @rip gravity_x_reg[23]_0[13] -pin g_mag_tilt.u_heading gx_reg[23]_0[13] -pin u_vector gravity_x_reg[23]_0[13]
load net compass_gravity_y[21] -attr @rip gravity_y_reg[23]_0[21] -pin g_mag_tilt.u_heading gy_reg[24]_0[21] -pin u_vector gravity_y_reg[23]_0[21]
load net last_y[1] -attr @rip last_y_reg[14]_0[1] -pin u_mag_calibration last_y_reg[14]_0[1] -pin u_magnetometro pipe_unique_reg_i_3_0[1]
load net mag_corrected_y[15] -attr @rip corrected_y_reg[15]_0[15] -pin u_mag_cal_planar corrigido_y_reg[15]_0[15] -pin u_mag_calibration corrected_y_reg[15]_0[15]
load net mag_x[2] -attr @rip mag_x[2] -pin u_mag_calibration max_x_reg[15]_2[2] -pin u_magnetometro mag_x[2]
load net mag_z[2] -attr @rip mag_z[2] -pin u_mag_calibration pipe_z_reg[15]_0[2] -pin u_magnetometro mag_z[2]
load net mpu_raw_ax[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[85] -pin u_sensor accel_x_reg[15]_0[85] -pin u_vector a_reg[0][15]_0[85]
load net mpu_accel_z[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[53] -pin u_sensor accel_x_reg[15]_0[53] -pin u_vector a_reg[0][15]_0[53]
load net mpu_raw_gx[5] -attr @style dashed -attr @rip accel_x_reg[15]_0[37] -pin u_sensor accel_x_reg[15]_0[37] -pin u_vector a_reg[0][15]_0[37]
load net samples_reg[3][4] -attr @rip samples_reg[2][7]_0[4] -pin u_sensor samples_reg[2][7]_0[4] -pin u_vector p_1_in_1[4]
load net vector_pitch[6] -attr @rip D[6] -pin u_attitude_cdc D[78] -pin u_vector D[6]
load net vector_raw_pitch[10] -attr @rip D[46] -pin u_attitude_cdc D[118] -pin u_vector D[46]
load net vector_raw_roll[15] -attr @rip D[77] -pin u_attitude_cdc D[149] -pin u_vector D[77]
load net vector_roll[20] -attr @rip D[28] -pin u_attitude_cdc D[100] -pin u_vector D[28]
load net rx_bytes_reg[5]_1[7] -attr @rip rx_bytes_reg[4][7]_0[7] -pin g_mag_tilt.u_heading by_reg_0[7] -pin u_mag_calibration prod_y_reg_0[7] -pin u_magnetometro rx_bytes_reg[4][7]_0[7]
load net g_mag_tilt.u_heading_n_24 -attr @rip age_reg[24]_0[0] -pin g_mag_tilt.u_heading age_reg[24]_0[0] -pin u_magnetometro age_reg[24][0]
load net u_mag_calibration_n_161 -attr @rip max_x_reg[15]_0[6] -pin u_mag_calibration max_x_reg[15]_0[6] -pin u_magnetometro max_x_reg[15]_i_2_0[6]
load net u_mag_calibration_n_101 -attr @rip max_y_reg[7]_0[2] -pin u_mag_calibration max_y_reg[7]_0[2] -pin u_magnetometro max_y_reg[15]_i_2_1[2]
load net u_mag_calibration_n_130 -attr @rip min_x_reg[15]_0[13] -pin u_mag_calibration min_x_reg[15]_0[13] -pin u_magnetometro min_x_reg[15]_i_2_0[13]
load net u_mag_calibration_n_38 -attr @rip Q[9] -pin u_mag_calibration Q[9] -pin u_magnetometro min_z_reg[15]_i_3_0[9]
load net u_sensor_n_7 -attr @rip DI[0] -pin u_sensor DI[0] -pin u_vector DI[0]
netloc u_sensor_n_7 1 1 1 1270 3010n
load net u_vector_n_214 -attr @rip raw_pitch_reg[12]_1[1] -pin u_auto_zero near_neutral0_carry__1_0[1] -pin u_vector raw_pitch_reg[12]_1[1]
load net u_magnetometro_n_78 -pin u_mag_calibration have_train_reg_1 -pin u_magnetometro amostra_nova_reg_3
netloc u_magnetometro_n_78 1 3 3 4030 2510 5070J 2530 7070
load net u_mag_calibration_n_70 -attr @rip max_z_reg[15]_0[1] -pin u_mag_calibration max_z_reg[15]_0[1] -pin u_magnetometro max_z_reg[15]_i_2_0[1]
load net u_magnetometro_n_0 -pin g_mag_tilt.u_heading published_reg_0 -pin u_magnetometro state_reg[2]
netloc u_magnetometro_n_0 1 5 1 7710 1510n
load net u_magnetometro_n_166 -attr @rip rx_bytes_reg[0][7]_0[12] -pin g_mag_tilt.u_heading bx_reg_0[12] -pin u_mag_calibration prod_x_reg_1[12] -pin u_magnetometro rx_bytes_reg[0][7]_0[12]
load net updated1 -pin u_sensor updated1 -pin u_vector updated1
netloc updated1 1 0 3 60 4490 NJ 4490 2240
load net zero_request0 -attr @style dashed -pin u_sensor zero_request0 -pin u_vector zero_request0
netloc zero_request0 1 0 2 200 4350 1110J
load net u_vector_n_338 -attr @style dashed -pin g_mag_tilt.u_heading g_idade[2].idade_reg[0] -pin u_mag_cal_planar iteracao_reg[0]_0 -pin u_mag_calibration x_reg[12] -pin u_vector active_reg_0
netloc u_vector_n_338 1 2 4 2540 2550 3490 2810 NJ 2810 7650J
load net u_vector_n_133 -attr @rip raw_pitch_reg[14]_0[3] -pin u_auto_zero near_neutral1_carry__1_1[3] -pin u_vector raw_pitch_reg[14]_0[3]
load net compass_gravity_x[14] -attr @rip gravity_x_reg[23]_0[14] -pin g_mag_tilt.u_heading gx_reg[23]_0[14] -pin u_vector gravity_x_reg[23]_0[14]
load net compass_gravity_y[22] -attr @rip gravity_y_reg[23]_0[22] -pin g_mag_tilt.u_heading gy_reg[24]_0[22] -pin u_vector gravity_y_reg[23]_0[22]
load net last_y[2] -attr @rip last_y_reg[14]_0[2] -pin u_mag_calibration last_y_reg[14]_0[2] -pin u_magnetometro pipe_unique_reg_i_3_0[2]
load net mag_corrected_x[0] -attr @rip corrected_x_reg[15]_0[0] -pin u_mag_cal_planar Q[0] -pin u_mag_calibration corrected_x_reg[15]_0[0]
load net mag_x[3] -attr @rip mag_x[3] -pin u_mag_calibration max_x_reg[15]_2[3] -pin u_magnetometro mag_x[3]
load net mag_z[3] -attr @rip mag_z[3] -pin u_mag_calibration pipe_z_reg[15]_0[3] -pin u_magnetometro mag_z[3]
load net mpu_accel_z[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[54] -pin u_sensor accel_x_reg[15]_0[54] -pin u_vector a_reg[0][15]_0[54]
load net mpu_raw_ax[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[86] -pin u_sensor accel_x_reg[15]_0[86] -pin u_vector a_reg[0][15]_0[86]
load net mpu_raw_gx[6] -attr @style dashed -attr @rip accel_x_reg[15]_0[38] -pin u_sensor accel_x_reg[15]_0[38] -pin u_vector a_reg[0][15]_0[38]
load net samples_reg[3][5] -attr @rip samples_reg[2][7]_0[5] -pin u_sensor samples_reg[2][7]_0[5] -pin u_vector p_1_in_1[5]
load net samples_reg[0][0] -attr @rip B[8] -pin u_sensor B[8] -pin u_vector B[8]
load net vector_pitch[9] -attr @rip D[9] -pin u_attitude_cdc D[81] -pin u_vector D[9]
load net vector_raw_pitch[11] -attr @rip D[47] -pin u_attitude_cdc D[119] -pin u_vector D[47]
load net vector_raw_roll[16] -attr @rip D[78] -pin u_attitude_cdc D[150] -pin u_vector D[78]
load net vector_roll[21] -attr @rip D[29] -pin u_attitude_cdc D[101] -pin u_vector D[29]
load net g_mag_tilt.u_heading_n_21 -attr @rip age_reg[24]_0[3] -pin g_mag_tilt.u_heading age_reg[24]_0[3] -pin u_magnetometro age_reg[24][3]
load net u_mag_calibration_n_158 -attr @rip max_x_reg[15]_0[9] -pin u_mag_calibration max_x_reg[15]_0[9] -pin u_magnetometro max_x_reg[15]_i_2_0[9]
load net u_mag_calibration_n_128 -attr @rip min_x_reg[15]_0[15] -pin u_mag_calibration min_x_reg[15]_0[15] -pin u_magnetometro min_x_reg[15]_i_2_0[15]
load net u_mag_calibration_n_35 -attr @rip Q[12] -pin u_mag_calibration Q[12] -pin u_magnetometro min_z_reg[15]_i_3_0[12]
load net mag_cal_healthy -pin u_mag_cal_planar mag_cal_healthy -pin u_mag_calibration mag_cal_healthy
netloc mag_cal_healthy 1 2 3 2560 1910 3350J 1890 5170
load net u_vector_n_130 -attr @rip raw_pitch_reg[6]_0[0] -pin u_auto_zero near_neutral1_carry__0_0[0] -pin u_vector raw_pitch_reg[6]_0[0]
load net u_sensor_n_13 -attr @rip S[0] -pin u_sensor S[0] -pin u_vector S[0]
netloc u_sensor_n_13 1 1 1 N 3070
load net u_vector_n_211 -attr @rip raw_pitch_reg[16]_0[2] -pin u_auto_zero near_neutral0_carry__1_1[2] -pin u_vector raw_pitch_reg[16]_0[2]
load net u_mag_calibration_n_67 -attr @rip max_z_reg[15]_0[4] -pin u_mag_calibration max_z_reg[15]_0[4] -pin u_magnetometro max_z_reg[15]_i_2_0[4]
load net u_mag_calibration_n_97 -attr @rip min_y_reg[15]_1[2] -pin u_mag_calibration min_y_reg[15]_1[2] -pin u_magnetometro min_y_reg[0][2]
load net u_magnetometro_n_5 -attr @rip amostra_nova_reg_0[21] -pin g_mag_tilt.u_heading age_reg[25]_1[21] -pin u_magnetometro amostra_nova_reg_0[21]
load net u_magnetometro_n_163 -attr @rip rx_bytes_reg[0][7]_0[15] -pin g_mag_tilt.u_heading bx_reg_0[15] -pin u_mag_calibration prod_x_reg_1[15] -pin u_magnetometro rx_bytes_reg[0][7]_0[15]
load net compass_gravity_x[11] -attr @rip gravity_x_reg[23]_0[11] -pin g_mag_tilt.u_heading gx_reg[23]_0[11] -pin u_vector gravity_x_reg[23]_0[11]
load net compass_gravity_y[19] -attr @rip gravity_y_reg[23]_0[19] -pin g_mag_tilt.u_heading gy_reg[24]_0[19] -pin u_vector gravity_y_reg[23]_0[19]
load net last_x[14] -attr @rip last_x_reg[14]_0[14] -pin u_mag_calibration last_x_reg[14]_0[14] -pin u_magnetometro pipe_unique_reg_i_4_0[14]
load net mag_corrected_y[13] -attr @rip corrected_y_reg[15]_0[13] -pin u_mag_cal_planar corrigido_y_reg[15]_0[13] -pin u_mag_calibration corrected_y_reg[15]_0[13]
load net mag_x[0] -attr @rip mag_x[0] -pin u_mag_calibration max_x_reg[15]_2[0] -pin u_magnetometro mag_x[0]
load net mag_z[0] -attr @rip mag_z[0] -pin u_mag_calibration pipe_z_reg[15]_0[0] -pin u_magnetometro mag_z[0]
load net mpu_raw_ax[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[83] -pin u_sensor accel_x_reg[15]_0[83] -pin u_vector a_reg[0][15]_0[83]
load net mpu_accel_z[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[51] -pin u_sensor accel_x_reg[15]_0[51] -pin u_vector a_reg[0][15]_0[51]
load net mpu_raw_gx[3] -attr @style dashed -attr @rip accel_x_reg[15]_0[35] -pin u_sensor accel_x_reg[15]_0[35] -pin u_vector a_reg[0][15]_0[35]
load net vector_pitch[4] -attr @rip D[4] -pin u_attitude_cdc D[76] -pin u_vector D[4]
load net samples_reg[3][2] -attr @rip samples_reg[2][7]_0[2] -pin u_sensor samples_reg[2][7]_0[2] -pin u_vector p_1_in_1[2]
load net vector_raw_roll[13] -attr @rip D[75] -pin u_attitude_cdc D[147] -pin u_vector D[75]
load net vector_raw_pitch[7] -attr @rip D[43] -pin u_attitude_cdc D[115] -pin u_vector D[43]
load net vector_roll[18] -attr @rip D[26] -pin u_attitude_cdc D[98] -pin u_vector D[26]
load net rx_bytes_reg[5]_1[6] -attr @rip rx_bytes_reg[4][7]_0[6] -pin g_mag_tilt.u_heading by_reg_0[6] -pin u_mag_calibration prod_y_reg_0[6] -pin u_magnetometro rx_bytes_reg[4][7]_0[6]
load net amostra_nova -pin u_sensor amostra_nova -pin u_vector amostra_nova
netloc amostra_nova 1 1 1 N 3150
load net mag_cal_level -pin u_mag_calibration mag_cal_level -pin u_magnetometro mag_cal_level -pin u_vector mag_cal_level
netloc mag_cal_level 1 2 3 2640J 3090 3330 2490 5070J
load net g_mag_tilt.u_heading_n_22 -attr @rip age_reg[24]_0[2] -pin g_mag_tilt.u_heading age_reg[24]_0[2] -pin u_magnetometro age_reg[24][2]
load net u_mag_calibration_n_159 -attr @rip max_x_reg[15]_0[8] -pin u_mag_calibration max_x_reg[15]_0[8] -pin u_magnetometro max_x_reg[15]_i_2_0[8]
load net u_mag_calibration_n_129 -attr @rip min_x_reg[15]_0[14] -pin u_mag_calibration min_x_reg[15]_0[14] -pin u_magnetometro min_x_reg[15]_i_2_0[14]
load net u_mag_calibration_n_36 -attr @rip Q[11] -pin u_mag_calibration Q[11] -pin u_magnetometro min_z_reg[15]_i_3_0[11]
load net u_mag_cal_planar_n_5 -pin u_mag_cal_planar y_reg[31]_0 -pin u_mag_calibration x_reg[12]_0
netloc u_mag_cal_planar_n_5 1 3 1 3290 1710n
load net u_sensor_n_14 -attr @rip age_reg[0]_0[0] -pin u_sensor age_reg[0]_0[0] -pin u_vector age_reg[3]_1[0]
netloc u_sensor_n_14 1 1 1 N 3130
load net u_vector_n_212 -attr @rip raw_pitch_reg[16]_0[1] -pin u_auto_zero near_neutral0_carry__1_1[1] -pin u_vector raw_pitch_reg[16]_0[1]
load net u_mag_calibration_n_98 -attr @rip min_y_reg[15]_1[1] -pin u_mag_calibration min_y_reg[15]_1[1] -pin u_magnetometro min_y_reg[0][1]
load net u_mag_calibration_n_68 -attr @rip max_z_reg[15]_0[3] -pin u_mag_calibration max_z_reg[15]_0[3] -pin u_magnetometro max_z_reg[15]_i_2_0[3]
load net u_magnetometro_n_6 -attr @rip amostra_nova_reg_0[20] -pin g_mag_tilt.u_heading age_reg[25]_1[20] -pin u_magnetometro amostra_nova_reg_0[20]
load net u_magnetometro_n_164 -attr @rip rx_bytes_reg[0][7]_0[14] -pin g_mag_tilt.u_heading bx_reg_0[14] -pin u_mag_calibration prod_x_reg_1[14] -pin u_magnetometro rx_bytes_reg[0][7]_0[14]
load net u_vector_n_131 -attr @rip raw_pitch_reg[12]_0[1] -pin u_auto_zero near_neutral1_carry__1_0[1] -pin u_vector raw_pitch_reg[12]_0[1]
load net u_vector_n_335 -pin u_mag_calibration reason[0]_i_3_0 -pin u_vector valid_reg_0
netloc u_vector_n_335 1 2 2 NJ 4170 3410
load net zero_pulse9_out -pin u_auto_zero zero_pulse9_out -pin u_vector zero_pulse9_out
netloc zero_pulse9_out 1 1 1 1090 4030n
load net compass_gravity_x[12] -attr @rip gravity_x_reg[23]_0[12] -pin g_mag_tilt.u_heading gx_reg[23]_0[12] -pin u_vector gravity_x_reg[23]_0[12]
load net compass_gravity_y[20] -attr @rip gravity_y_reg[23]_0[20] -pin g_mag_tilt.u_heading gy_reg[24]_0[20] -pin u_vector gravity_y_reg[23]_0[20]
load net last_y[0] -attr @rip last_y_reg[14]_0[0] -pin u_mag_calibration last_y_reg[14]_0[0] -pin u_magnetometro pipe_unique_reg_i_3_0[0]
load net mag_corrected_y[14] -attr @rip corrected_y_reg[15]_0[14] -pin u_mag_cal_planar corrigido_y_reg[15]_0[14] -pin u_mag_calibration corrected_y_reg[15]_0[14]
load net mag_x[1] -attr @rip mag_x[1] -pin u_mag_calibration max_x_reg[15]_2[1] -pin u_magnetometro mag_x[1]
load net mag_z[1] -attr @rip mag_z[1] -pin u_mag_calibration pipe_z_reg[15]_0[1] -pin u_magnetometro mag_z[1]
load net mpu_accel_z[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[52] -pin u_sensor accel_x_reg[15]_0[52] -pin u_vector a_reg[0][15]_0[52]
load net mpu_raw_ax[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[84] -pin u_sensor accel_x_reg[15]_0[84] -pin u_vector a_reg[0][15]_0[84]
load net mpu_raw_gx[4] -attr @style dashed -attr @rip accel_x_reg[15]_0[36] -pin u_sensor accel_x_reg[15]_0[36] -pin u_vector a_reg[0][15]_0[36]
load net samples_reg[3][3] -attr @rip samples_reg[2][7]_0[3] -pin u_sensor samples_reg[2][7]_0[3] -pin u_vector p_1_in_1[3]
load net vector_pitch[5] -attr @rip D[5] -pin u_attitude_cdc D[77] -pin u_vector D[5]
load net vector_raw_pitch[8] -attr @rip D[44] -pin u_attitude_cdc D[116] -pin u_vector D[44]
load net vector_raw_roll[14] -attr @rip D[76] -pin u_attitude_cdc D[148] -pin u_vector D[76]
load net vector_roll[19] -attr @rip D[27] -pin u_attitude_cdc D[99] -pin u_vector D[27]
load netBundle @samples_reg 16 samples_reg[0][7] samples_reg[0][6] samples_reg[0][5] samples_reg[0][4] samples_reg[0][3] samples_reg[0][2] samples_reg[0][1] samples_reg[0][0] samples_reg[1][7] samples_reg[1][6] samples_reg[1][5] samples_reg[1][4] samples_reg[1][3] samples_reg[1][2] samples_reg[1][1] samples_reg[1][0] -autobundled
netbloc @samples_reg 1 1 1 1010 2970n
load netBundle @mpu_raw_ax,mpu_raw_ay 96 mpu_raw_ax[15] mpu_raw_ax[14] mpu_raw_ax[13] mpu_raw_ax[12] mpu_raw_ax[11] mpu_raw_ax[10] mpu_raw_ax[9] mpu_raw_ax[8] mpu_raw_ax[7] mpu_raw_ax[6] mpu_raw_ax[5] mpu_raw_ax[4] mpu_raw_ax[3] mpu_raw_ax[2] mpu_raw_ax[1] mpu_raw_ax[0] mpu_raw_ay[15] mpu_raw_ay[14] mpu_raw_ay[13] mpu_raw_ay[12] mpu_raw_ay[11] mpu_raw_ay[10] mpu_raw_ay[9] mpu_raw_ay[8] mpu_raw_ay[7] mpu_raw_ay[6] mpu_raw_ay[5] mpu_raw_ay[4] mpu_raw_ay[3] mpu_raw_ay[2] mpu_raw_ay[1] mpu_raw_ay[0] mpu_accel_z[15] mpu_accel_z[14] mpu_accel_z[13] mpu_accel_z[12] mpu_accel_z[11] mpu_accel_z[10] mpu_accel_z[9] mpu_accel_z[8] mpu_accel_z[7] mpu_accel_z[6] mpu_accel_z[5] mpu_accel_z[4] mpu_accel_z[3] mpu_accel_z[2] mpu_accel_z[1] mpu_accel_z[0] mpu_raw_gx[15] mpu_raw_gx[14] mpu_raw_gx[13] mpu_raw_gx[12] mpu_raw_gx[11] mpu_raw_gx[10] mpu_raw_gx[9] mpu_raw_gx[8] mpu_raw_gx[7] mpu_raw_gx[6] mpu_raw_gx[5] mpu_raw_gx[4] mpu_raw_gx[3] mpu_raw_gx[2] mpu_raw_gx[1] mpu_raw_gx[0] mpu_raw_gy[15] mpu_raw_gy[14] mpu_raw_gy[13] mpu_raw_gy[12] mpu_raw_gy[11] mpu_raw_gy[10] mpu_raw_gy[9] mpu_raw_gy[8] mpu_raw_gy[7] mpu_raw_gy[6] mpu_raw_gy[5] mpu_raw_gy[4] mpu_raw_gy[3] mpu_raw_gy[2] mpu_raw_gy[1] mpu_raw_gy[0] mpu_gyro_z[15] mpu_gyro_z[14] mpu_gyro_z[13] mpu_gyro_z[12] mpu_gyro_z[11] mpu_gyro_z[10] mpu_gyro_z[9] mpu_gyro_z[8] mpu_gyro_z[7] mpu_gyro_z[6] mpu_gyro_z[5] mpu_gyro_z[4] mpu_gyro_z[3] mpu_gyro_z[2] mpu_gyro_z[1] mpu_gyro_z[0] -autobundled -attr @style dashed
netbloc @mpu_raw_ax,mpu_raw_ay 1 1 1 N 3090
load netBundle @samples_reg_1 16 samples_reg[2][7] samples_reg[2][6] samples_reg[2][5] samples_reg[2][4] samples_reg[2][3] samples_reg[2][2] samples_reg[2][1] samples_reg[2][0] samples_reg[3][7] samples_reg[3][6] samples_reg[3][5] samples_reg[3][4] samples_reg[3][3] samples_reg[3][2] samples_reg[3][1] samples_reg[3][0] -autobundled
netbloc @samples_reg_1 1 1 1 1430 3270n
load netBundle @samples_reg_2 16 samples_reg[4][7] samples_reg[4][6] samples_reg[4][5] samples_reg[4][4] samples_reg[4][3] samples_reg[4][2] samples_reg[4][1] samples_reg[4][0] samples_reg[5][7] samples_reg[5][6] samples_reg[5][5] samples_reg[5][4] samples_reg[5][3] samples_reg[5][2] samples_reg[5][1] samples_reg[5][0] -autobundled
netbloc @samples_reg_2 1 1 1 1010 3290n
load netBundle @vector_raw_roll 113 vector_calibration_debug[19] vector_calibration_debug[18] vector_calibration_debug[17] vector_calibration_debug[16] vector_calibration_debug[15] vector_calibration_debug[14] vector_calibration_debug[13] vector_calibration_debug[12] vector_calibration_debug[11] vector_calibration_debug[10] vector_calibration_debug[9] vector_calibration_debug[8] vector_calibration_debug[7] vector_calibration_debug[6] vector_calibration_debug[5] vector_calibration_debug[4] vector_calibration_debug[3] vector_calibration_debug[2] vector_calibration_debug[1] vector_calibration_debug[0] fusao_valida zero_rejected zero_set vector_stationary vector_calibrated vector_raw_roll[31] vector_raw_roll[24] vector_raw_roll[23] vector_raw_roll[22] vector_raw_roll[21] vector_raw_roll[20] vector_raw_roll[19] vector_raw_roll[18] vector_raw_roll[17] vector_raw_roll[16] vector_raw_roll[15] vector_raw_roll[14] vector_raw_roll[13] vector_raw_roll[12] vector_raw_roll[11] vector_raw_roll[10] vector_raw_roll[9] vector_raw_roll[8] vector_raw_roll[7] vector_raw_roll[6] vector_raw_roll[5] vector_raw_roll[4] vector_raw_roll[3] vector_raw_roll[2] vector_raw_roll[1] vector_raw_roll[0] vector_raw_pitch[31] vector_raw_pitch[24] vector_raw_pitch[23] vector_raw_pitch[22] vector_raw_pitch[21] vector_raw_pitch[20] vector_raw_pitch[19] vector_raw_pitch[18] vector_raw_pitch[17] vector_raw_pitch[16] vector_raw_pitch[15] vector_raw_pitch[14] vector_raw_pitch[13] vector_raw_pitch[12] vector_raw_pitch[11] vector_raw_pitch[10] vector_raw_pitch[9] vector_raw_pitch[8] vector_raw_pitch[7] vector_raw_pitch[6] vector_raw_pitch[5] vector_raw_pitch[4] vector_raw_pitch[3] vector_raw_pitch[2] vector_raw_pitch[1] vector_raw_pitch[0] vector_roll[27] vector_roll[26] vector_roll[25] vector_roll[24] vector_roll[23] vector_roll[22] vector_roll[21] vector_roll[20] vector_roll[19] vector_roll[18] vector_roll[17] vector_roll[16] vector_roll[15] vector_roll[14] vector_roll[9] vector_roll[8] vector_roll[7] vector_roll[6] vector_roll[5] vector_roll[4] vector_roll[3] vector_roll[2] vector_pitch[22] vector_pitch[13] vector_pitch[12] vector_pitch[11] vector_pitch[9] vector_pitch[8] vector_pitch[7] vector_pitch[6] vector_pitch[5] vector_pitch[4] vector_pitch[3] vector_pitch[2] vector_pitch[1] vector_pitch[0] -autobundled -attr @style dashed
netbloc @vector_raw_roll 1 0 3 40 2510 NJ 2510 2680
load netBundle @compass_gravity_z 24 compass_gravity_z[23] compass_gravity_z[22] compass_gravity_z[21] compass_gravity_z[20] compass_gravity_z[19] compass_gravity_z[18] compass_gravity_z[17] compass_gravity_z[16] compass_gravity_z[15] compass_gravity_z[14] compass_gravity_z[13] compass_gravity_z[12] compass_gravity_z[11] compass_gravity_z[10] compass_gravity_z[9] compass_gravity_z[8] compass_gravity_z[7] compass_gravity_z[6] compass_gravity_z[5] compass_gravity_z[4] compass_gravity_z[3] compass_gravity_z[2] compass_gravity_z[1] compass_gravity_z[0] -autobundled
netbloc @compass_gravity_z 1 2 4 2560 2470 NJ 2470 5090J 2510 7670J
load netBundle @compass_gravity_x 24 compass_gravity_x[23] compass_gravity_x[22] compass_gravity_x[21] compass_gravity_x[20] compass_gravity_x[19] compass_gravity_x[18] compass_gravity_x[17] compass_gravity_x[16] compass_gravity_x[15] compass_gravity_x[14] compass_gravity_x[13] compass_gravity_x[12] compass_gravity_x[11] compass_gravity_x[10] compass_gravity_x[9] compass_gravity_x[8] compass_gravity_x[7] compass_gravity_x[6] compass_gravity_x[5] compass_gravity_x[4] compass_gravity_x[3] compass_gravity_x[2] compass_gravity_x[1] compass_gravity_x[0] -autobundled
netbloc @compass_gravity_x 1 2 4 NJ 3050 3370J 3070 NJ 3070 7750
load netBundle @compass_gravity_y 24 compass_gravity_y[23] compass_gravity_y[22] compass_gravity_y[21] compass_gravity_y[20] compass_gravity_y[19] compass_gravity_y[18] compass_gravity_y[17] compass_gravity_y[16] compass_gravity_y[15] compass_gravity_y[14] compass_gravity_y[13] compass_gravity_y[12] compass_gravity_y[11] compass_gravity_y[10] compass_gravity_y[9] compass_gravity_y[8] compass_gravity_y[7] compass_gravity_y[6] compass_gravity_y[5] compass_gravity_y[4] compass_gravity_y[3] compass_gravity_y[2] compass_gravity_y[1] compass_gravity_y[0] -autobundled
netbloc @compass_gravity_y 1 2 4 NJ 3070 3350J 3090 NJ 3090 7790
load netBundle @u_vector_n_ 2 u_vector_n_131 u_vector_n_132 -autobundled
netbloc @u_vector_n_ 1 0 3 440 4550 NJ 4550 2640
load netBundle @u_vector_n__1 2 u_vector_n_214 u_vector_n_215 -autobundled
netbloc @u_vector_n__1 1 0 3 400 3470 970J 2770 2380
load netBundle @u_vector_n__2 4 u_vector_n_133 u_vector_n_134 u_vector_n_135 u_vector_n_136 -autobundled
netbloc @u_vector_n__2 1 0 3 380 3610 1170J 4310 2540
load netBundle @u_vector_n__3 4 u_vector_n_210 u_vector_n_211 u_vector_n_212 u_vector_n_213 -autobundled
netbloc @u_vector_n__3 1 0 3 340 3590 1190J 4290 2480
load netBundle @u_vector_n__4 4 u_vector_n_137 u_vector_n_138 u_vector_n_139 u_vector_n_140 -autobundled
netbloc @u_vector_n__4 1 0 3 420 3630 1150J 4330 2400
load netBundle @u_vector_n__5 4 u_vector_n_206 u_vector_n_207 u_vector_n_208 u_vector_n_209 -autobundled
netbloc @u_vector_n__5 1 0 3 440 3650 1130J 4350 2360
load netBundle @u_vector_n__6 3 u_vector_n_119 u_vector_n_120 u_vector_n_121 -autobundled
netbloc @u_vector_n__6 1 0 3 460 3570 1210J 4270 2340
load netBundle @u_vector_n__7 4 u_vector_n_127 u_vector_n_128 u_vector_n_129 u_vector_n_130 -autobundled
netbloc @u_vector_n__7 1 0 3 40 4510 NJ 4510 2680
load netBundle @u_vector_n__8 4 u_vector_n_346 u_vector_n_347 u_vector_n_348 u_vector_n_349 -autobundled
netbloc @u_vector_n__8 1 0 3 400 4530 NJ 4530 2660
load netBundle @u_vector_n__9 4 u_vector_n_216 u_vector_n_217 u_vector_n_218 u_vector_n_219 -autobundled
netbloc @u_vector_n__9 1 0 3 300 3450 1290J 2750 2300
load netBundle @u_vector_n__10 2 u_vector_n_146 u_vector_n_147 -autobundled
netbloc @u_vector_n__10 1 0 3 280 4670 NJ 4670 2560
load netBundle @u_vector_n__11 2 u_vector_n_229 u_vector_n_230 -autobundled
netbloc @u_vector_n__11 1 0 3 20 2610 NJ 2610 2460
load netBundle @u_vector_n__12 4 u_vector_n_148 u_vector_n_149 u_vector_n_150 u_vector_n_151 -autobundled
netbloc @u_vector_n__12 1 0 3 300 4690 NJ 4690 2500
load netBundle @u_vector_n__13 4 u_vector_n_225 u_vector_n_226 u_vector_n_227 u_vector_n_228 -autobundled
netbloc @u_vector_n__13 1 0 3 80 4590 NJ 4590 2460
load netBundle @u_vector_n__14 4 u_vector_n_152 u_vector_n_153 u_vector_n_154 u_vector_n_155 -autobundled
netbloc @u_vector_n__14 1 0 3 460 4710 NJ 4710 2440
load netBundle @u_vector_n__15 4 u_vector_n_221 u_vector_n_222 u_vector_n_223 u_vector_n_224 -autobundled
netbloc @u_vector_n__15 1 0 3 220 4610 NJ 4610 2300
load netBundle @u_vector_n__16 3 u_vector_n_123 u_vector_n_124 u_vector_n_125 -autobundled
netbloc @u_vector_n__16 1 0 3 180 4370 NJ 4370 2220
load netBundle @u_vector_n__17 4 u_vector_n_142 u_vector_n_143 u_vector_n_144 u_vector_n_145 -autobundled
netbloc @u_vector_n__17 1 0 3 240 4630 NJ 4630 2600
load netBundle @u_vector_n__18 4 u_vector_n_231 u_vector_n_232 u_vector_n_233 u_vector_n_234 -autobundled
netbloc @u_vector_n__18 1 0 3 260 4650 NJ 4650 2580
load netBundle @u_vector_n__19 4 u_vector_n_342 u_vector_n_343 u_vector_n_344 u_vector_n_345 -autobundled
netbloc @u_vector_n__19 1 0 3 140 4390 NJ 4390 2260
load netBundle @vector_pitch,vector_roll 20 vector_roll[31] vector_roll[13] vector_roll[12] vector_roll[11] vector_roll[10] vector_roll[1] vector_roll[0] vector_pitch[31] vector_pitch[25] vector_pitch[24] vector_pitch[23] vector_pitch[21] vector_pitch[20] vector_pitch[19] vector_pitch[18] vector_pitch[17] vector_pitch[16] vector_pitch[15] vector_pitch[14] vector_pitch[10] -autobundled -attr @style dashed
netbloc @vector_pitch,vector_roll 1 2 1 2700 3290n
load netBundle @u_magnetometro_n_ 16 u_magnetometro_n_147 u_magnetometro_n_148 u_magnetometro_n_149 u_magnetometro_n_150 u_magnetometro_n_151 u_magnetometro_n_152 u_magnetometro_n_153 u_magnetometro_n_154 rx_bytes_reg[3]_3[7] rx_bytes_reg[3]_3[6] rx_bytes_reg[3]_3[5] rx_bytes_reg[3]_3[4] rx_bytes_reg[3]_3[3] rx_bytes_reg[3]_3[2] rx_bytes_reg[3]_3[1] rx_bytes_reg[3]_3[0] -autobundled
netbloc @u_magnetometro_n_ 1 5 1 7370 1090n
load netBundle @u_magnetometro_n__1 26 u_magnetometro_n_1 u_magnetometro_n_2 u_magnetometro_n_3 u_magnetometro_n_4 u_magnetometro_n_5 u_magnetometro_n_6 u_magnetometro_n_7 u_magnetometro_n_8 u_magnetometro_n_9 u_magnetometro_n_10 u_magnetometro_n_11 u_magnetometro_n_12 u_magnetometro_n_13 u_magnetometro_n_14 u_magnetometro_n_15 u_magnetometro_n_16 u_magnetometro_n_17 u_magnetometro_n_18 u_magnetometro_n_19 u_magnetometro_n_20 u_magnetometro_n_21 u_magnetometro_n_22 u_magnetometro_n_23 u_magnetometro_n_24 u_magnetometro_n_25 u_magnetometro_n_26 -autobundled
netbloc @u_magnetometro_n__1 1 5 1 7490 1190n
load netBundle @mag_x 16 mag_x[15] mag_x[14] mag_x[13] mag_x[12] mag_x[11] mag_x[10] mag_x[9] mag_x[8] mag_x[7] mag_x[6] mag_x[5] mag_x[4] mag_x[3] mag_x[2] mag_x[1] mag_x[0] -autobundled
netbloc @mag_x 1 3 3 4250 2070 5290J 1250 6830
load netBundle @mag_y 16 mag_y[15] mag_y[14] mag_y[13] mag_y[12] mag_y[11] mag_y[10] mag_y[9] mag_y[8] mag_y[7] mag_y[6] mag_y[5] mag_y[4] mag_y[3] mag_y[2] mag_y[1] mag_y[0] -autobundled
netbloc @mag_y 1 3 3 4290 2030 5690J 1210 6810
load netBundle @mag_z 16 mag_z[15] mag_z[14] mag_z[13] mag_z[12] mag_z[11] mag_z[10] mag_z[9] mag_z[8] mag_z[7] mag_z[6] mag_z[5] mag_z[4] mag_z[3] mag_z[2] mag_z[1] mag_z[0] -autobundled
netbloc @mag_z 1 3 3 4270 2050 5730J 1230 6870
load netBundle @u_magnetometro_n__2 16 u_magnetometro_n_163 u_magnetometro_n_164 u_magnetometro_n_165 u_magnetometro_n_166 u_magnetometro_n_167 u_magnetometro_n_168 u_magnetometro_n_169 u_magnetometro_n_170 u_magnetometro_n_171 u_magnetometro_n_172 u_magnetometro_n_173 u_magnetometro_n_174 u_magnetometro_n_175 u_magnetometro_n_176 u_magnetometro_n_177 u_magnetometro_n_178 -autobundled
netbloc @u_magnetometro_n__2 1 3 3 4010 2610 NJ 2610 7570
load netBundle @rx_bytes_reg 16 rx_bytes_reg[4]_2[7] rx_bytes_reg[4]_2[6] rx_bytes_reg[4]_2[5] rx_bytes_reg[4]_2[4] rx_bytes_reg[4]_2[3] rx_bytes_reg[4]_2[2] rx_bytes_reg[4]_2[1] rx_bytes_reg[4]_2[0] rx_bytes_reg[5]_1[7] rx_bytes_reg[5]_1[6] rx_bytes_reg[5]_1[5] rx_bytes_reg[5]_1[4] rx_bytes_reg[5]_1[3] rx_bytes_reg[5]_1[2] rx_bytes_reg[5]_1[1] rx_bytes_reg[5]_1[0] -autobundled
netbloc @rx_bytes_reg 1 3 3 4330 1990 5550J 1050 7390
load netBundle @g_mag_tilt.u_heading_n_ 4 g_mag_tilt.u_heading_n_0 g_mag_tilt.u_heading_n_1 g_mag_tilt.u_heading_n_2 g_mag_tilt.u_heading_n_3 -autobundled
netbloc @g_mag_tilt.u_heading_n_ 1 4 3 6090 890 NJ 890 8420
load netBundle @g_mag_tilt.u_heading_n__1 4 g_mag_tilt.u_heading_n_9 g_mag_tilt.u_heading_n_10 g_mag_tilt.u_heading_n_11 g_mag_tilt.u_heading_n_12 -autobundled
netbloc @g_mag_tilt.u_heading_n__1 1 4 3 6030 930 NJ 930 8340
load netBundle @g_mag_tilt.u_heading_n__2 4 g_mag_tilt.u_heading_n_13 g_mag_tilt.u_heading_n_14 g_mag_tilt.u_heading_n_15 g_mag_tilt.u_heading_n_16 -autobundled
netbloc @g_mag_tilt.u_heading_n__2 1 4 3 6050 950 NJ 950 8300
load netBundle @g_mag_tilt.u_heading_n__3 4 g_mag_tilt.u_heading_n_17 g_mag_tilt.u_heading_n_18 g_mag_tilt.u_heading_n_19 g_mag_tilt.u_heading_n_20 -autobundled
netbloc @g_mag_tilt.u_heading_n__3 1 4 3 6070 970 NJ 970 8260
load netBundle @g_mag_tilt.u_heading_n__4 4 g_mag_tilt.u_heading_n_21 g_mag_tilt.u_heading_n_22 g_mag_tilt.u_heading_n_23 g_mag_tilt.u_heading_n_24 -autobundled
netbloc @g_mag_tilt.u_heading_n__4 1 4 3 6190 1150 7510J 1630 8380
load netBundle @g_mag_tilt.u_heading_n__5 4 g_mag_tilt.u_heading_n_5 g_mag_tilt.u_heading_n_6 g_mag_tilt.u_heading_n_7 g_mag_tilt.u_heading_n_8 -autobundled
netbloc @g_mag_tilt.u_heading_n__5 1 4 3 6170 1130 7330J 1610 8420
load netBundle @u_mag_calibration_n_ 16 u_mag_calibration_n_32 u_mag_calibration_n_33 u_mag_calibration_n_34 u_mag_calibration_n_35 u_mag_calibration_n_36 u_mag_calibration_n_37 u_mag_calibration_n_38 u_mag_calibration_n_39 u_mag_calibration_n_40 u_mag_calibration_n_41 u_mag_calibration_n_42 u_mag_calibration_n_43 u_mag_calibration_n_44 u_mag_calibration_n_45 u_mag_calibration_n_46 u_mag_calibration_n_47 -autobundled
netbloc @u_mag_calibration_n_ 1 4 1 5930 410n
load netBundle @u_mag_calibration_n__1 4 u_mag_calibration_n_28 u_mag_calibration_n_29 u_mag_calibration_n_30 u_mag_calibration_n_31 -autobundled
netbloc @u_mag_calibration_n__1 1 4 1 6010 430n
load netBundle @p_1_in_0 12 p_1_in_0[25] p_1_in_0[23] p_1_in_0[22] p_1_in_0[21] p_1_in_0[20] p_1_in_0[19] p_1_in_0[17] p_1_in_0[15] p_1_in_0[14] p_1_in_0[13] p_1_in_0[12] p_1_in_0[7] -autobundled
netbloc @p_1_in_0 1 4 1 5990 530n
load netBundle @mag_corrected_x 16 mag_corrected_x[15] mag_corrected_x[14] mag_corrected_x[13] mag_corrected_x[12] mag_corrected_x[11] mag_corrected_x[10] mag_corrected_x[9] mag_corrected_x[8] mag_corrected_x[7] mag_corrected_x[6] mag_corrected_x[5] mag_corrected_x[4] mag_corrected_x[3] mag_corrected_x[2] mag_corrected_x[1] mag_corrected_x[0] -autobundled
netbloc @mag_corrected_x 1 2 3 2720 1550 3350J 1810 5090
load netBundle @mag_corrected_y 16 mag_corrected_y[15] mag_corrected_y[14] mag_corrected_y[13] mag_corrected_y[12] mag_corrected_y[11] mag_corrected_y[10] mag_corrected_y[9] mag_corrected_y[8] mag_corrected_y[7] mag_corrected_y[6] mag_corrected_y[5] mag_corrected_y[4] mag_corrected_y[3] mag_corrected_y[2] mag_corrected_y[1] mag_corrected_y[0] -autobundled
netbloc @mag_corrected_y 1 2 3 2740 1570 3310J 1830 4990
load netBundle @last_x 15 last_x[14] last_x[13] last_x[12] last_x[11] last_x[10] last_x[9] last_x[8] last_x[7] last_x[6] last_x[5] last_x[4] last_x[3] last_x[2] last_x[1] last_x[0] -autobundled
netbloc @last_x 1 4 1 5850 810n
load netBundle @last_y 15 last_y[14] last_y[13] last_y[12] last_y[11] last_y[10] last_y[9] last_y[8] last_y[7] last_y[6] last_y[5] last_y[4] last_y[3] last_y[2] last_y[1] last_y[0] -autobundled
netbloc @last_y 1 4 1 5330 850n
load netBundle @last_z 15 last_z[14] last_z[13] last_z[12] last_z[11] last_z[10] last_z[9] last_z[8] last_z[7] last_z[6] last_z[5] last_z[4] last_z[3] last_z[2] last_z[1] last_z[0] -autobundled
netbloc @last_z 1 4 1 5750 890n
load netBundle @u_mag_calibration_n__2 16 u_mag_calibration_n_152 u_mag_calibration_n_153 u_mag_calibration_n_154 u_mag_calibration_n_155 u_mag_calibration_n_156 u_mag_calibration_n_157 u_mag_calibration_n_158 u_mag_calibration_n_159 u_mag_calibration_n_160 u_mag_calibration_n_161 u_mag_calibration_n_162 u_mag_calibration_n_163 u_mag_calibration_n_164 u_mag_calibration_n_165 u_mag_calibration_n_166 u_mag_calibration_n_167 -autobundled
netbloc @u_mag_calibration_n__2 1 4 1 5890 1030n
load netBundle @u_mag_calibration_n__3 4 u_mag_calibration_n_168 u_mag_calibration_n_169 u_mag_calibration_n_170 u_mag_calibration_n_171 -autobundled
netbloc @u_mag_calibration_n__3 1 4 1 5390 1050n
load netBundle @u_mag_calibration_n__4 4 u_mag_calibration_n_148 u_mag_calibration_n_149 u_mag_calibration_n_150 u_mag_calibration_n_151 -autobundled
netbloc @u_mag_calibration_n__4 1 4 1 5910 1010n
load netBundle @u_mag_calibration_n__5 16 u_mag_calibration_n_104 u_mag_calibration_n_105 u_mag_calibration_n_106 u_mag_calibration_n_107 u_mag_calibration_n_108 u_mag_calibration_n_109 u_mag_calibration_n_110 u_mag_calibration_n_111 u_mag_calibration_n_112 u_mag_calibration_n_113 u_mag_calibration_n_114 u_mag_calibration_n_115 u_mag_calibration_n_116 u_mag_calibration_n_117 u_mag_calibration_n_118 u_mag_calibration_n_119 -autobundled
netbloc @u_mag_calibration_n__5 1 4 1 5050 1090n
load netBundle @u_mag_calibration_n__6 4 u_mag_calibration_n_120 u_mag_calibration_n_121 u_mag_calibration_n_122 u_mag_calibration_n_123 -autobundled
netbloc @u_mag_calibration_n__6 1 4 1 5010 1110n
load netBundle @u_mag_calibration_n__7 4 u_mag_calibration_n_100 u_mag_calibration_n_101 u_mag_calibration_n_102 u_mag_calibration_n_103 -autobundled
netbloc @u_mag_calibration_n__7 1 4 1 5350 1070n
load netBundle @u_mag_calibration_n__8 16 u_mag_calibration_n_56 u_mag_calibration_n_57 u_mag_calibration_n_58 u_mag_calibration_n_59 u_mag_calibration_n_60 u_mag_calibration_n_61 u_mag_calibration_n_62 u_mag_calibration_n_63 u_mag_calibration_n_64 u_mag_calibration_n_65 u_mag_calibration_n_66 u_mag_calibration_n_67 u_mag_calibration_n_68 u_mag_calibration_n_69 u_mag_calibration_n_70 u_mag_calibration_n_71 -autobundled
netbloc @u_mag_calibration_n__8 1 4 1 5810 1150n
load netBundle @u_mag_calibration_n__9 4 u_mag_calibration_n_72 u_mag_calibration_n_73 u_mag_calibration_n_74 u_mag_calibration_n_75 -autobundled
netbloc @u_mag_calibration_n__9 1 4 1 5790 1170n
load netBundle @u_mag_calibration_n__10 4 u_mag_calibration_n_52 u_mag_calibration_n_53 u_mag_calibration_n_54 u_mag_calibration_n_55 -autobundled
netbloc @u_mag_calibration_n__10 1 4 1 5830 1130n
load netBundle @u_mag_calibration_n__11 16 u_mag_calibration_n_128 u_mag_calibration_n_129 u_mag_calibration_n_130 u_mag_calibration_n_131 u_mag_calibration_n_132 u_mag_calibration_n_133 u_mag_calibration_n_134 u_mag_calibration_n_135 u_mag_calibration_n_136 u_mag_calibration_n_137 u_mag_calibration_n_138 u_mag_calibration_n_139 u_mag_calibration_n_140 u_mag_calibration_n_141 u_mag_calibration_n_142 u_mag_calibration_n_143 -autobundled
netbloc @u_mag_calibration_n__11 1 4 1 5670 1210n
load netBundle @u_mag_calibration_n__12 4 u_mag_calibration_n_144 u_mag_calibration_n_145 u_mag_calibration_n_146 u_mag_calibration_n_147 -autobundled
netbloc @u_mag_calibration_n__12 1 4 1 5710 1230n
load netBundle @u_mag_calibration_n__13 4 u_mag_calibration_n_124 u_mag_calibration_n_125 u_mag_calibration_n_126 u_mag_calibration_n_127 -autobundled
netbloc @u_mag_calibration_n__13 1 4 1 5450 1190n
load netBundle @u_mag_calibration_n__14 16 u_mag_calibration_n_80 u_mag_calibration_n_81 u_mag_calibration_n_82 u_mag_calibration_n_83 u_mag_calibration_n_84 u_mag_calibration_n_85 u_mag_calibration_n_86 u_mag_calibration_n_87 u_mag_calibration_n_88 u_mag_calibration_n_89 u_mag_calibration_n_90 u_mag_calibration_n_91 u_mag_calibration_n_92 u_mag_calibration_n_93 u_mag_calibration_n_94 u_mag_calibration_n_95 -autobundled
netbloc @u_mag_calibration_n__14 1 4 1 5610 1270n
load netBundle @u_mag_calibration_n__15 4 u_mag_calibration_n_96 u_mag_calibration_n_97 u_mag_calibration_n_98 u_mag_calibration_n_99 -autobundled
netbloc @u_mag_calibration_n__15 1 4 1 5570 1290n
load netBundle @u_mag_calibration_n__16 4 u_mag_calibration_n_76 u_mag_calibration_n_77 u_mag_calibration_n_78 u_mag_calibration_n_79 -autobundled
netbloc @u_mag_calibration_n__16 1 4 1 5110 1250n
load netBundle @u_mag_calibration_n__17 4 u_mag_calibration_n_48 u_mag_calibration_n_49 u_mag_calibration_n_50 u_mag_calibration_n_51 -autobundled
netbloc @u_mag_calibration_n__17 1 4 1 5430 1310n
load netBundle @estado 3 estado[2] estado[1] estado[0] -autobundled
netbloc @estado 1 3 1 3230 690n
load netBundle @horizonte_sync 2 horizonte_sync[1] horizonte_sync[0] -autobundled -attr @style dashed
netbloc @horizonte_sync 1 0 2 380 3530 1290J
load netBundle @roll_sync 2 roll_sync[1] roll_sync[0] -autobundled -attr @style dashed
netbloc @roll_sync 1 0 2 420 3550 1270J
levelinfo -pg 1 0 710 1820 2930 4530 6420 8010 8520
pagesize -pg 1 -db -bbox -sgen 0 0 8520 4740
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
