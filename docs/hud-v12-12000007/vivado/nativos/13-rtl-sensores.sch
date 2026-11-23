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
load symbol mpu6050_i2c work:mpu6050_i2c:NOFILE HIERBOX pin amostra_nova output.right pin clk input.left pin i2c_scl inout.left pin i2c_sda inout.left pin sensor_ok output.right pinBus accel_x output.right [15:0] pinBus accel_y output.right [15:0] pinBus accel_z output.right [15:0] pinBus gyro_x output.right [15:0] pinBus gyro_y output.right [15:0] pinBus gyro_z output.right [15:0] pinBus who_am_i output.right [7:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol atitude_vetorial work:atitude_vetorial:NOFILE HIERBOX pin calibrated output.right pin clk input.left pin reset input.left pin sample input.left pin sensor_ok input.left pin stationary output.right pin updated output.right pin valid output.right pin zero_rejected output.right pin zero_request input.left pin zero_set output.right pinBus ax input.left [15:0] pinBus ay input.left [15:0] pinBus az input.left [15:0] pinBus calibration_debug output.right [25:0] pinBus gravity_x output.right [23:0] pinBus gravity_y output.right [23:0] pinBus gravity_z output.right [23:0] pinBus gx input.left [15:0] pinBus gy input.left [15:0] pinBus gz input.left [15:0] pinBus pitch output.right [31:0] pinBus raw_pitch output.right [31:0] pinBus raw_roll output.right [31:0] pinBus roll output.right [31:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hud_auto_zero work:hud_auto_zero:NOFILE HIERBOX pin already_zeroed input.left pin calibrated input.left pin clk input.left pin done output.right pin enabled input.left pin reset input.left pin stationary input.left pin updated input.left pin valid input.left pin zero_pulse output.right pinBus raw_pitch input.left [31:0] pinBus raw_roll input.left [31:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hmc5883l_i2c work:hmc5883l_i2c:NOFILE HIERBOX pin amostra_nova output.right pin clk input.left pin mag_scl inout.left pin mag_sda inout.left pin sensor_ok output.right pinBus diagnostico output.right [31:0] pinBus mag_x output.right [15:0] pinBus mag_y output.right [15:0] pinBus mag_z output.right [15:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE HIERBOX pin atualizado output.right pin calibration_ok input.left pin clk input.left pin gravity_valid input.left pin reset input.left pin sample input.left pin sensor_ok input.left pin valido output.right pinBus gravity_x input.left [23:0] pinBus gravity_y input.left [23:0] pinBus gravity_z input.left [23:0] pinBus heading_deg output.right [8:0] pinBus mag_x input.left [15:0] pinBus mag_y input.left [15:0] pinBus mag_z input.left [15:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol mag_calibration_2d work:mag_calibration_2d:NOFILE HIERBOX pin active output.right pin boot_profile_valid input.left pin cancel input.left pin clk input.left pin corrected_sample output.right pin healthy output.right pin level input.left pin next_step input.left pin profile_changed output.right pin recover input.left pin reset input.left pin sample input.left pin sensor_ok input.left pin start input.left pin suspect output.right pinBus boot_profile input.left [63:0] pinBus candidate_gx output.right [13:0] pinBus candidate_gy output.right [13:0] pinBus candidate_x output.right [15:0] pinBus candidate_y output.right [15:0] pinBus corrected_x output.right [15:0] pinBus corrected_y output.right [15:0] pinBus coverage output.right [7:0] pinBus duplicates output.right [15:0] pinBus gain_x output.right [13:0] pinBus gain_y output.right [13:0] pinBus invalid_samples output.right [15:0] pinBus max_x output.right [15:0] pinBus max_y output.right [15:0] pinBus max_z output.right [15:0] pinBus min_x output.right [15:0] pinBus min_y output.right [15:0] pinBus min_z output.right [15:0] pinBus mx input.left [15:0] pinBus my input.left [15:0] pinBus mz input.left [15:0] pinBus offset_x output.right [15:0] pinBus offset_y output.right [15:0] pinBus reason output.right [3:0] pinBus samples output.right [15:0] pinBus state output.right [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol heading_magnetico work:heading_magnetico:NOFILE HIERBOX pin amostra_nova input.left pin atualizado output.right pin clk input.left pin sensor_ok input.left pin valido output.right pinBus heading_deg output.right [8:0] pinBus mag_x input.left [15:0] pinBus mag_y input.left [15:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst u_sensor mpu6050_i2c work:mpu6050_i2c:NOFILE -attr @cell(#1c1f28) mpu6050_i2c -pinBusAttr accel_x @name accel_x[15:0] -pinBusAttr accel_y @name accel_y[15:0] -pinBusAttr accel_z @name accel_z[15:0] -pinBusAttr gyro_x @name gyro_x[15:0] -pinBusAttr gyro_y @name gyro_y[15:0] -pinBusAttr gyro_z @name gyro_z[15:0] -pinBusAttr who_am_i @name who_am_i[7:0] -pinBusAttr who_am_i @attr n/c -pg 1 -lvl 1 -x 100 -y 70
load inst u_vector atitude_vetorial work:atitude_vetorial:NOFILE -attr @cell(#1c1f28) atitude_vetorial -pinBusAttr ax @name ax[15:0] -pinBusAttr ay @name ay[15:0] -pinBusAttr az @name az[15:0] -pinBusAttr calibration_debug @name calibration_debug[25:0] -pinBusAttr gravity_x @name gravity_x[23:0] -pinBusAttr gravity_y @name gravity_y[23:0] -pinBusAttr gravity_z @name gravity_z[23:0] -pinBusAttr gx @name gx[15:0] -pinBusAttr gy @name gy[15:0] -pinBusAttr gz @name gz[15:0] -pinBusAttr pitch @name pitch[31:0] -pinBusAttr raw_pitch @name raw_pitch[31:0] -pinBusAttr raw_roll @name raw_roll[31:0] -pinBusAttr roll @name roll[31:0] -pg 1 -lvl 2 -x 440 -y 50
load inst u_auto_zero hud_auto_zero work:hud_auto_zero:NOFILE -attr @cell(#1c1f28) hud_auto_zero -pinAttr done @attr n/c -pinBusAttr raw_pitch @name raw_pitch[31:0] -pinBusAttr raw_roll @name raw_roll[31:0] -pg 1 -lvl 3 -x 930 -y 90
load inst u_magnetometro hmc5883l_i2c work:hmc5883l_i2c:NOFILE -attr @cell(#1c1f28) hmc5883l_i2c -pinBusAttr diagnostico @name diagnostico[31:0] -pinBusAttr mag_x @name mag_x[15:0] -pinBusAttr mag_y @name mag_y[15:0] -pinBusAttr mag_z @name mag_z[15:0] -pg 1 -lvl 2 -x 440 -y 440
load inst g_mag_tilt.u_heading heading_magnetico_inclinado work:heading_magnetico_inclinado:NOFILE -attr @cell(#1c1f28) heading_magnetico_inclinado -pinBusAttr gravity_x @name gravity_x[23:0] -pinBusAttr gravity_y @name gravity_y[23:0] -pinBusAttr gravity_z @name gravity_z[23:0] -pinBusAttr heading_deg @name heading_deg[8:0] -pinBusAttr mag_x @name mag_x[15:0] -pinBusAttr mag_y @name mag_y[15:0] -pinBusAttr mag_z @name mag_z[15:0] -pg 1 -lvl 3 -x 930 -y 360
load inst u_mag_calibration mag_calibration_2d work:mag_calibration_2d:NOFILE -attr @cell(#1c1f28) mag_calibration_2d -pinAttr suspect @attr n/c -pinBusAttr boot_profile @name boot_profile[63:0] -pinBusAttr candidate_gx @name candidate_gx[13:0] -pinBusAttr candidate_gx @attr n/c -pinBusAttr candidate_gy @name candidate_gy[13:0] -pinBusAttr candidate_gy @attr n/c -pinBusAttr candidate_x @name candidate_x[15:0] -pinBusAttr candidate_x @attr n/c -pinBusAttr candidate_y @name candidate_y[15:0] -pinBusAttr candidate_y @attr n/c -pinBusAttr corrected_x @name corrected_x[15:0] -pinBusAttr corrected_y @name corrected_y[15:0] -pinBusAttr coverage @name coverage[7:0] -pinBusAttr coverage @attr n/c -pinBusAttr duplicates @name duplicates[15:0] -pinBusAttr duplicates @attr n/c -pinBusAttr gain_x @name gain_x[13:0] -pinBusAttr gain_x @attr n/c -pinBusAttr gain_y @name gain_y[13:0] -pinBusAttr gain_y @attr n/c -pinBusAttr invalid_samples @name invalid_samples[15:0] -pinBusAttr invalid_samples @attr n/c -pinBusAttr max_x @name max_x[15:0] -pinBusAttr max_x @attr n/c -pinBusAttr max_y @name max_y[15:0] -pinBusAttr max_y @attr n/c -pinBusAttr max_z @name max_z[15:0] -pinBusAttr max_z @attr n/c -pinBusAttr min_x @name min_x[15:0] -pinBusAttr min_x @attr n/c -pinBusAttr min_y @name min_y[15:0] -pinBusAttr min_y @attr n/c -pinBusAttr min_z @name min_z[15:0] -pinBusAttr min_z @attr n/c -pinBusAttr mx @name mx[15:0] -pinBusAttr my @name my[15:0] -pinBusAttr mz @name mz[15:0] -pinBusAttr offset_x @name offset_x[15:0] -pinBusAttr offset_x @attr n/c -pinBusAttr offset_y @name offset_y[15:0] -pinBusAttr offset_y @attr n/c -pinBusAttr reason @name reason[3:0] -pinBusAttr samples @name samples[15:0] -pinBusAttr samples @attr n/c -pinBusAttr state @name state[3:0] -pg 1 -lvl 3 -x 930 -y 680
load inst u_mag_cal_planar heading_magnetico work:heading_magnetico:NOFILE -attr @cell(#1c1f28) heading_magnetico -pinBusAttr heading_deg @name heading_deg[8:0] -pinBusAttr mag_x @name mag_x[15:0] -pinBusAttr mag_y @name mag_y[15:0] -pg 1 -lvl 4 -x 1340 -y 760
load net mag_x[3] -attr @style dashed -attr @rip mag_x[3] -pin g_mag_tilt.u_heading mag_x[3] -pin u_mag_calibration mx[3] -pin u_magnetometro mag_x[3]
load net compass_gravity_z[10] -attr @style dashed -attr @rip gravity_z[10] -pin g_mag_tilt.u_heading gravity_z[10] -pin u_vector gravity_z[10]
load net mag_corrected_x[5] -attr @rip corrected_x[5] -pin u_mag_cal_planar mag_x[5] -pin u_mag_calibration corrected_x[5]
load net mag_corrected_y[12] -attr @rip corrected_y[12] -pin u_mag_cal_planar mag_y[12] -pin u_mag_calibration corrected_y[12]
load net mag_corrected_y[6] -attr @rip corrected_y[6] -pin u_mag_cal_planar mag_y[6] -pin u_mag_calibration corrected_y[6]
load net mag_corrected_y[9] -attr @rip corrected_y[9] -pin u_mag_cal_planar mag_y[9] -pin u_mag_calibration corrected_y[9]
load net compass_gravity_z[17] -attr @style dashed -attr @rip gravity_z[17] -pin g_mag_tilt.u_heading gravity_z[17] -pin u_vector gravity_z[17]
load net compass_gravity_x[1] -attr @style dashed -attr @rip gravity_x[1] -pin g_mag_tilt.u_heading gravity_x[1] -pin u_vector gravity_x[1]
load net compass_gravity_x[17] -attr @style dashed -attr @rip gravity_x[17] -pin g_mag_tilt.u_heading gravity_x[17] -pin u_vector gravity_x[17]
load net mag_z[10] -attr @style dashed -attr @rip mag_z[10] -pin g_mag_tilt.u_heading mag_z[10] -pin u_mag_calibration mz[10] -pin u_magnetometro mag_z[10]
load net compass_gravity_z[3] -attr @style dashed -attr @rip gravity_z[3] -pin g_mag_tilt.u_heading gravity_z[3] -pin u_vector gravity_z[3]
load net mag_z[1] -attr @style dashed -attr @rip mag_z[1] -pin g_mag_tilt.u_heading mag_z[1] -pin u_mag_calibration mz[1] -pin u_magnetometro mag_z[1]
load net compass_gravity_x[9] -attr @style dashed -attr @rip gravity_x[9] -pin g_mag_tilt.u_heading gravity_x[9] -pin u_vector gravity_x[9]
load net compass_gravity_z[16] -attr @style dashed -attr @rip gravity_z[16] -pin g_mag_tilt.u_heading gravity_z[16] -pin u_vector gravity_z[16]
load net compass_gravity_y[17] -attr @style dashed -attr @rip gravity_y[17] -pin g_mag_tilt.u_heading gravity_y[17] -pin u_vector gravity_y[17]
load net compass_gravity_y[1] -attr @style dashed -attr @rip gravity_y[1] -pin g_mag_tilt.u_heading gravity_y[1] -pin u_vector gravity_y[1]
load net compass_gravity_y[9] -attr @style dashed -attr @rip gravity_y[9] -pin g_mag_tilt.u_heading gravity_y[9] -pin u_vector gravity_y[9]
load net mag_y[0] -attr @style dashed -attr @rip mag_y[0] -pin g_mag_tilt.u_heading mag_y[0] -pin u_mag_calibration my[0] -pin u_magnetometro mag_y[0]
load net vector_raw_roll[10] -attr @style dashed -attr @rip raw_roll[10] -pin u_auto_zero raw_roll[10] -pin u_vector raw_roll[10]
load net mpu_raw_gy[0] -attr @style dashed -attr @rip gyro_y[0] -pin u_sensor gyro_y[0] -pin u_vector gy[0]
load net mpu_raw_gy[9] -attr @style dashed -attr @rip gyro_y[9] -pin u_sensor gyro_y[9] -pin u_vector gy[9]
load net mpu_gyro_z[10] -attr @style dashed -attr @rip gyro_z[10] -pin u_sensor gyro_z[10] -pin u_vector gz[10]
load net mpu_gyro_z[15] -attr @style dashed -attr @rip gyro_z[15] -pin u_sensor gyro_z[15] -pin u_vector gz[15]
load net mpu_raw_ax[15] -attr @style dashed -attr @rip accel_x[15] -pin u_sensor accel_x[15] -pin u_vector ax[15]
load net mpu_accel_z[15] -attr @style dashed -attr @rip accel_z[15] -pin u_sensor accel_z[15] -pin u_vector az[15]
load net mpu_raw_ax[14] -attr @style dashed -attr @rip accel_x[14] -pin u_sensor accel_x[14] -pin u_vector ax[14]
load net mpu_raw_ax[10] -attr @style dashed -attr @rip accel_x[10] -pin u_sensor accel_x[10] -pin u_vector ax[10]
load net mpu_raw_gy[14] -attr @style dashed -attr @rip gyro_y[14] -pin u_sensor gyro_y[14] -pin u_vector gy[14]
load net mpu_raw_ay[7] -attr @style dashed -attr @rip accel_y[7] -pin u_sensor accel_y[7] -pin u_vector ay[7]
load net mpu_raw_ay[4] -attr @style dashed -attr @rip accel_y[4] -pin u_sensor accel_y[4] -pin u_vector ay[4]
load net vector_raw_pitch[17] -attr @style dashed -attr @rip raw_pitch[17] -pin u_auto_zero raw_pitch[17] -pin u_vector raw_pitch[17]
load net vector_raw_pitch[1] -attr @style dashed -attr @rip raw_pitch[1] -pin u_auto_zero raw_pitch[1] -pin u_vector raw_pitch[1]
load net vector_raw_pitch[6] -attr @style dashed -attr @rip raw_pitch[6] -pin u_auto_zero raw_pitch[6] -pin u_vector raw_pitch[6]
load net vector_raw_roll[13] -attr @style dashed -attr @rip raw_roll[13] -pin u_auto_zero raw_roll[13] -pin u_vector raw_roll[13]
load net vector_raw_roll[22] -attr @style dashed -attr @rip raw_roll[22] -pin u_auto_zero raw_roll[22] -pin u_vector raw_roll[22]
load net vector_raw_roll[27] -attr @style dashed -attr @rip raw_roll[27] -pin u_auto_zero raw_roll[27] -pin u_vector raw_roll[27]
load net mpu_accel_z[8] -attr @style dashed -attr @rip accel_z[8] -pin u_sensor accel_z[8] -pin u_vector az[8]
load net mpu_raw_gx[15] -attr @style dashed -attr @rip gyro_x[15] -pin u_sensor gyro_x[15] -pin u_vector gx[15]
load net mpu_raw_gx[8] -attr @style dashed -attr @rip gyro_x[8] -pin u_sensor gyro_x[8] -pin u_vector gx[8]
load net reset_operacao -attr @style dashed -pin g_mag_tilt.u_heading reset -pin u_auto_zero reset -pin u_mag_calibration reset
netloc reset_operacao 1 2 1 770 220n
load net mag_corrected_x[2] -attr @rip corrected_x[2] -pin u_mag_cal_planar mag_x[2] -pin u_mag_calibration corrected_x[2]
load net mag_corrected_x[6] -attr @rip corrected_x[6] -pin u_mag_cal_planar mag_x[6] -pin u_mag_calibration corrected_x[6]
load net mag_corrected_y[0] -attr @rip corrected_y[0] -pin u_mag_cal_planar mag_y[0] -pin u_mag_calibration corrected_y[0]
load net mag_corrected_y[13] -attr @rip corrected_y[13] -pin u_mag_cal_planar mag_y[13] -pin u_mag_calibration corrected_y[13]
load net compass_gravity_z[2] -attr @style dashed -attr @rip gravity_z[2] -pin g_mag_tilt.u_heading gravity_z[2] -pin u_vector gravity_z[2]
load net compass_gravity_x[0] -attr @style dashed -attr @rip gravity_x[0] -pin g_mag_tilt.u_heading gravity_x[0] -pin u_vector gravity_x[0]
load net compass_gravity_x[14] -attr @style dashed -attr @rip gravity_x[14] -pin g_mag_tilt.u_heading gravity_x[14] -pin u_vector gravity_x[14]
load net mag_z[9] -attr @style dashed -attr @rip mag_z[9] -pin g_mag_tilt.u_heading mag_z[9] -pin u_mag_calibration mz[9] -pin u_magnetometro mag_z[9]
load net compass_gravity_x[8] -attr @style dashed -attr @rip gravity_x[8] -pin g_mag_tilt.u_heading gravity_x[8] -pin u_vector gravity_x[8]
load net compass_gravity_y[0] -attr @style dashed -attr @rip gravity_y[0] -pin g_mag_tilt.u_heading gravity_y[0] -pin u_vector gravity_y[0]
load net mag_z[0] -attr @style dashed -attr @rip mag_z[0] -pin g_mag_tilt.u_heading mag_z[0] -pin u_mag_calibration mz[0] -pin u_magnetometro mag_z[0]
load net mag_z[6] -attr @style dashed -attr @rip mag_z[6] -pin g_mag_tilt.u_heading mag_z[6] -pin u_mag_calibration mz[6] -pin u_magnetometro mag_z[6]
load net compass_gravity_y[8] -attr @style dashed -attr @rip gravity_y[8] -pin g_mag_tilt.u_heading gravity_y[8] -pin u_vector gravity_y[8]
load net mag_y[8] -attr @style dashed -attr @rip mag_y[8] -pin g_mag_tilt.u_heading mag_y[8] -pin u_mag_calibration my[8] -pin u_magnetometro mag_y[8]
load net mag_z[15] -attr @style dashed -attr @rip mag_z[15] -pin g_mag_tilt.u_heading mag_z[15] -pin u_mag_calibration mz[15] -pin u_magnetometro mag_z[15]
load net compass_gravity_z[13] -attr @style dashed -attr @rip gravity_z[13] -pin g_mag_tilt.u_heading gravity_z[13] -pin u_vector gravity_z[13]
load net mag_x[2] -attr @style dashed -attr @rip mag_x[2] -pin g_mag_tilt.u_heading mag_x[2] -pin u_mag_calibration mx[2] -pin u_magnetometro mag_x[2]
load net compass_gravity_y[14] -attr @style dashed -attr @rip gravity_y[14] -pin g_mag_tilt.u_heading gravity_y[14] -pin u_vector gravity_y[14]
load net vector_raw_roll[3] -attr @style dashed -attr @rip raw_roll[3] -pin u_auto_zero raw_roll[3] -pin u_vector raw_roll[3]
load net mpu_raw_gy[6] -attr @style dashed -attr @rip gyro_y[6] -pin u_sensor gyro_y[6] -pin u_vector gy[6]
load net mpu_gyro_z[6] -attr @style dashed -attr @rip gyro_z[6] -pin u_sensor gyro_z[6] -pin u_vector gz[6]
load net mpu_raw_gx[5] -attr @style dashed -attr @rip gyro_x[5] -pin u_sensor gyro_x[5] -pin u_vector gx[5]
load net mpu_raw_ay[9] -attr @style dashed -attr @rip accel_y[9] -pin u_sensor accel_y[9] -pin u_vector ay[9]
load net mpu_raw_ax[9] -attr @style dashed -attr @rip accel_x[9] -pin u_sensor accel_x[9] -pin u_vector ax[9]
load net mpu_raw_gy[11] -attr @style dashed -attr @rip gyro_y[11] -pin u_sensor gyro_y[11] -pin u_vector gy[11]
load net mpu_raw_gy[13] -attr @style dashed -attr @rip gyro_y[13] -pin u_sensor gyro_y[13] -pin u_vector gy[13]
load net mpu_raw_ay[8] -attr @style dashed -attr @rip accel_y[8] -pin u_sensor accel_y[8] -pin u_vector ay[8]
load net vector_raw_pitch[10] -attr @style dashed -attr @rip raw_pitch[10] -pin u_auto_zero raw_pitch[10] -pin u_vector raw_pitch[10]
load net vector_raw_pitch[14] -attr @style dashed -attr @rip raw_pitch[14] -pin u_auto_zero raw_pitch[14] -pin u_vector raw_pitch[14]
load net vector_raw_pitch[19] -attr @style dashed -attr @rip raw_pitch[19] -pin u_auto_zero raw_pitch[19] -pin u_vector raw_pitch[19]
load net vector_raw_pitch[23] -attr @style dashed -attr @rip raw_pitch[23] -pin u_auto_zero raw_pitch[23] -pin u_vector raw_pitch[23]
load net vector_raw_roll[24] -attr @style dashed -attr @rip raw_roll[24] -pin u_auto_zero raw_roll[24] -pin u_vector raw_roll[24]
load net vector_raw_roll[26] -attr @style dashed -attr @rip raw_roll[26] -pin u_auto_zero raw_roll[26] -pin u_vector raw_roll[26]
load net mpu_accel_z[7] -attr @style dashed -attr @rip accel_z[7] -pin u_sensor accel_z[7] -pin u_vector az[7]
load net mpu_raw_gx[7] -attr @style dashed -attr @rip gyro_x[7] -pin u_sensor gyro_x[7] -pin u_vector gx[7]
load net mpu_raw_gx[14] -attr @style dashed -attr @rip gyro_x[14] -pin u_sensor gyro_x[14] -pin u_vector gx[14]
load net mag_x[5] -attr @style dashed -attr @rip mag_x[5] -pin g_mag_tilt.u_heading mag_x[5] -pin u_mag_calibration mx[5] -pin u_magnetometro mag_x[5]
load net compass_gravity_z[7] -attr @style dashed -attr @rip gravity_z[7] -pin g_mag_tilt.u_heading gravity_z[7] -pin u_vector gravity_z[7]
load net vector_updated -attr @style dashed -attr @rip 0 -pin u_auto_zero updated -pin u_vector updated
netloc vector_updated 1 2 1 N 260
load net mag_corrected_x[11] -attr @rip corrected_x[11] -pin u_mag_cal_planar mag_x[11] -pin u_mag_calibration corrected_x[11]
load net mag_corrected_x[7] -attr @rip corrected_x[7] -pin u_mag_cal_planar mag_x[7] -pin u_mag_calibration corrected_x[7]
load net mag_corrected_y[10] -attr @rip corrected_y[10] -pin u_mag_cal_planar mag_y[10] -pin u_mag_calibration corrected_y[10]
load net mag_corrected_y[5] -attr @rip corrected_y[5] -pin u_mag_cal_planar mag_y[5] -pin u_mag_calibration corrected_y[5]
load net mag_corrected_y[8] -attr @rip corrected_y[8] -pin u_mag_cal_planar mag_y[8] -pin u_mag_calibration corrected_y[8]
load net compass_gravity_z[23] -attr @style dashed -attr @rip gravity_z[23] -pin g_mag_tilt.u_heading gravity_z[23] -pin u_vector gravity_z[23]
load net compass_gravity_x[16] -attr @style dashed -attr @rip gravity_x[16] -pin g_mag_tilt.u_heading gravity_x[16] -pin u_vector gravity_x[16]
load net mag_y[11] -attr @style dashed -attr @rip mag_y[11] -pin g_mag_tilt.u_heading mag_y[11] -pin u_mag_calibration my[11] -pin u_magnetometro mag_y[11]
load net compass_gravity_x[23] -attr @style dashed -attr @rip gravity_x[23] -pin g_mag_tilt.u_heading gravity_x[23] -pin u_vector gravity_x[23]
load net mag_z[8] -attr @style dashed -attr @rip mag_z[8] -pin g_mag_tilt.u_heading mag_z[8] -pin u_mag_calibration mz[8] -pin u_magnetometro mag_z[8]
load net compass_gravity_x[7] -attr @style dashed -attr @rip gravity_x[7] -pin g_mag_tilt.u_heading gravity_x[7] -pin u_vector gravity_x[7]
load net compass_gravity_y[7] -attr @style dashed -attr @rip gravity_y[7] -pin g_mag_tilt.u_heading gravity_y[7] -pin u_vector gravity_y[7]
load net mag_y[7] -attr @style dashed -attr @rip mag_y[7] -pin g_mag_tilt.u_heading mag_y[7] -pin u_mag_calibration my[7] -pin u_magnetometro mag_y[7]
load net mag_z[14] -attr @style dashed -attr @rip mag_z[14] -pin g_mag_tilt.u_heading mag_z[14] -pin u_mag_calibration mz[14] -pin u_magnetometro mag_z[14]
load net compass_gravity_y[16] -attr @style dashed -attr @rip gravity_y[16] -pin g_mag_tilt.u_heading gravity_y[16] -pin u_vector gravity_y[16]
load net compass_gravity_z[12] -attr @style dashed -attr @rip gravity_z[12] -pin g_mag_tilt.u_heading gravity_z[12] -pin u_vector gravity_z[12]
load net mag_y[13] -attr @style dashed -attr @rip mag_y[13] -pin g_mag_tilt.u_heading mag_y[13] -pin u_mag_calibration my[13] -pin u_magnetometro mag_y[13]
load net compass_gravity_y[23] -attr @style dashed -attr @rip gravity_y[23] -pin g_mag_tilt.u_heading gravity_y[23] -pin u_vector gravity_y[23]
load net compass_gravity_z[1] -attr @style dashed -attr @rip gravity_z[1] -pin g_mag_tilt.u_heading gravity_z[1] -pin u_vector gravity_z[1]
load net vector_raw_roll[11] -attr @style dashed -attr @rip raw_roll[11] -pin u_auto_zero raw_roll[11] -pin u_vector raw_roll[11]
load net vector_raw_roll[8] -attr @style dashed -attr @rip raw_roll[8] -pin u_auto_zero raw_roll[8] -pin u_vector raw_roll[8]
load net mpu_raw_gy[1] -attr @style dashed -attr @rip gyro_y[1] -pin u_sensor gyro_y[1] -pin u_vector gy[1]
load net mpu_raw_gy[3] -attr @style dashed -attr @rip gyro_y[3] -pin u_sensor gyro_y[3] -pin u_vector gy[3]
load net mpu_gyro_z[5] -attr @style dashed -attr @rip gyro_z[5] -pin u_sensor gyro_z[5] -pin u_vector gz[5]
load net mag_corrected_x[15] -attr @rip corrected_x[15] -pin u_mag_cal_planar mag_x[15] -pin u_mag_calibration corrected_x[15]
load net mpu_raw_ax[6] -attr @style dashed -attr @rip accel_x[6] -pin u_sensor accel_x[6] -pin u_vector ax[6]
load net amostra_nova -attr @style dashed -pin u_sensor amostra_nova -pin u_vector sample
netloc amostra_nova 1 1 1 310 140n
load net mpu_accel_z[12] -attr @style dashed -attr @rip accel_z[12] -pin u_sensor accel_z[12] -pin u_vector az[12]
load net mpu_raw_ay[13] -attr @style dashed -attr @rip accel_y[13] -pin u_sensor accel_y[13] -pin u_vector ay[13]
load net mpu_raw_gx[1] -attr @style dashed -attr @rip gyro_x[1] -pin u_sensor gyro_x[1] -pin u_vector gx[1]
load net mpu_raw_ay[5] -attr @style dashed -attr @rip accel_y[5] -pin u_sensor accel_y[5] -pin u_vector ay[5]
load net mpu_raw_ax[4] -attr @style dashed -attr @rip accel_x[4] -pin u_sensor accel_x[4] -pin u_vector ax[4]
load net vector_raw_pitch[13] -attr @style dashed -attr @rip raw_pitch[13] -pin u_auto_zero raw_pitch[13] -pin u_vector raw_pitch[13]
load net vector_raw_pitch[18] -attr @style dashed -attr @rip raw_pitch[18] -pin u_auto_zero raw_pitch[18] -pin u_vector raw_pitch[18]
load net vector_raw_pitch[21] -attr @style dashed -attr @rip raw_pitch[21] -pin u_auto_zero raw_pitch[21] -pin u_vector raw_pitch[21]
load net vector_raw_pitch[8] -attr @style dashed -attr @rip raw_pitch[8] -pin u_auto_zero raw_pitch[8] -pin u_vector raw_pitch[8]
load net vector_raw_roll[23] -attr @style dashed -attr @rip raw_roll[23] -pin u_auto_zero raw_roll[23] -pin u_vector raw_roll[23]
load net mpu_accel_z[1] -attr @style dashed -attr @rip accel_z[1] -pin u_sensor accel_z[1] -pin u_vector az[1]
load net mpu_accel_z[9] -attr @style dashed -attr @rip accel_z[9] -pin u_sensor accel_z[9] -pin u_vector az[9]
load net mpu_raw_gx[9] -attr @style dashed -attr @rip gyro_x[9] -pin u_sensor gyro_x[9] -pin u_vector gx[9]
load net mag_x[4] -attr @style dashed -attr @rip mag_x[4] -pin g_mag_tilt.u_heading mag_x[4] -pin u_mag_calibration mx[4] -pin u_magnetometro mag_x[4]
load net mag_corrected_y[11] -attr @rip corrected_y[11] -pin u_mag_cal_planar mag_y[11] -pin u_mag_calibration corrected_y[11]
load net mag_corrected_y[7] -attr @rip corrected_y[7] -pin u_mag_cal_planar mag_y[7] -pin u_mag_calibration corrected_y[7]
load net compass_gravity_z[22] -attr @style dashed -attr @rip gravity_z[22] -pin g_mag_tilt.u_heading gravity_z[22] -pin u_vector gravity_z[22]
load net compass_gravity_x[15] -attr @style dashed -attr @rip gravity_x[15] -pin g_mag_tilt.u_heading gravity_x[15] -pin u_vector gravity_x[15]
load net mag_y[10] -attr @style dashed -attr @rip mag_y[10] -pin g_mag_tilt.u_heading mag_y[10] -pin u_mag_calibration my[10] -pin u_magnetometro mag_y[10]
load net compass_gravity_x[22] -attr @style dashed -attr @rip gravity_x[22] -pin g_mag_tilt.u_heading gravity_x[22] -pin u_vector gravity_x[22]
load net mag_z[7] -attr @style dashed -attr @rip mag_z[7] -pin g_mag_tilt.u_heading mag_z[7] -pin u_mag_calibration mz[7] -pin u_magnetometro mag_z[7]
load net compass_gravity_x[6] -attr @style dashed -attr @rip gravity_x[6] -pin g_mag_tilt.u_heading gravity_x[6] -pin u_vector gravity_x[6]
load net compass_gravity_y[6] -attr @style dashed -attr @rip gravity_y[6] -pin g_mag_tilt.u_heading gravity_y[6] -pin u_vector gravity_y[6]
load net mag_y[5] -attr @style dashed -attr @rip mag_y[5] -pin g_mag_tilt.u_heading mag_y[5] -pin u_mag_calibration my[5] -pin u_magnetometro mag_y[5]
load net mag_z[13] -attr @style dashed -attr @rip mag_z[13] -pin g_mag_tilt.u_heading mag_z[13] -pin u_mag_calibration mz[13] -pin u_magnetometro mag_z[13]
load net compass_gravity_y[15] -attr @style dashed -attr @rip gravity_y[15] -pin g_mag_tilt.u_heading gravity_y[15] -pin u_vector gravity_y[15]
load net mag_y[12] -attr @style dashed -attr @rip mag_y[12] -pin g_mag_tilt.u_heading mag_y[12] -pin u_mag_calibration my[12] -pin u_magnetometro mag_y[12]
load net compass_gravity_y[22] -attr @style dashed -attr @rip gravity_y[22] -pin g_mag_tilt.u_heading gravity_y[22] -pin u_vector gravity_y[22]
load net compass_gravity_z[0] -attr @style dashed -attr @rip gravity_z[0] -pin g_mag_tilt.u_heading gravity_z[0] -pin u_vector gravity_z[0]
load net vector_raw_roll[1] -attr @style dashed -attr @rip raw_roll[1] -pin u_auto_zero raw_roll[1] -pin u_vector raw_roll[1]
load net mpu_raw_gy[4] -attr @style dashed -attr @rip gyro_y[4] -pin u_sensor gyro_y[4] -pin u_vector gy[4]
load net mpu_gyro_z[4] -attr @style dashed -attr @rip gyro_z[4] -pin u_sensor gyro_z[4] -pin u_vector gz[4]
load net mag_corrected_sample -pin u_mag_cal_planar amostra_nova -pin u_mag_calibration corrected_sample
netloc mag_corrected_sample 1 3 1 1200 770n
load net mag_corrected_x[14] -attr @rip corrected_x[14] -pin u_mag_cal_planar mag_x[14] -pin u_mag_calibration corrected_x[14]
load net mpu_raw_gx[0] -attr @style dashed -attr @rip gyro_x[0] -pin u_sensor gyro_x[0] -pin u_vector gx[0]
load net mpu_raw_ax[8] -attr @style dashed -attr @rip accel_x[8] -pin u_sensor accel_x[8] -pin u_vector ax[8]
load net mpu_raw_gy[15] -attr @style dashed -attr @rip gyro_y[15] -pin u_sensor gyro_y[15] -pin u_vector gy[15]
load net mpu_raw_ay[3] -attr @style dashed -attr @rip accel_y[3] -pin u_sensor accel_y[3] -pin u_vector ay[3]
load net mpu_raw_ay[6] -attr @style dashed -attr @rip accel_y[6] -pin u_sensor accel_y[6] -pin u_vector ay[6]
load net vector_raw_pitch[25] -attr @style dashed -attr @rip raw_pitch[25] -pin u_auto_zero raw_pitch[25] -pin u_vector raw_pitch[25]
load net vector_raw_pitch[20] -attr @style dashed -attr @rip raw_pitch[20] -pin u_auto_zero raw_pitch[20] -pin u_vector raw_pitch[20]
load net vector_raw_pitch[4] -attr @style dashed -attr @rip raw_pitch[4] -pin u_auto_zero raw_pitch[4] -pin u_vector raw_pitch[4]
load net vector_raw_pitch[9] -attr @style dashed -attr @rip raw_pitch[9] -pin u_auto_zero raw_pitch[9] -pin u_vector raw_pitch[9]
load net vector_raw_roll[21] -attr @style dashed -attr @rip raw_roll[21] -pin u_auto_zero raw_roll[21] -pin u_vector raw_roll[21]
load net zero_set -attr @style dashed -attr @rip 205 -pin u_auto_zero already_zeroed -pin u_vector zero_set
netloc zero_set 1 2 1 710 100n
load net mpu_accel_z[0] -attr @style dashed -attr @rip accel_z[0] -pin u_sensor accel_z[0] -pin u_vector az[0]
load net mpu_accel_z[6] -attr @style dashed -attr @rip accel_z[6] -pin u_sensor accel_z[6] -pin u_vector az[6]
load net mpu_raw_gx[6] -attr @style dashed -attr @rip gyro_x[6] -pin u_sensor gyro_x[6] -pin u_vector gx[6]
load net mag_x[12] -attr @style dashed -attr @rip mag_x[12] -pin g_mag_tilt.u_heading mag_x[12] -pin u_mag_calibration mx[12] -pin u_magnetometro mag_x[12]
load net mag_x[15] -attr @style dashed -attr @rip mag_x[15] -pin g_mag_tilt.u_heading mag_x[15] -pin u_mag_calibration mx[15] -pin u_magnetometro mag_x[15]
load net mag_x[8] -attr @style dashed -attr @rip mag_x[8] -pin g_mag_tilt.u_heading mag_x[8] -pin u_mag_calibration mx[8] -pin u_magnetometro mag_x[8]
load net compass_gravity_z[8] -attr @style dashed -attr @rip gravity_z[8] -pin g_mag_tilt.u_heading gravity_z[8] -pin u_vector gravity_z[8]
load net clk_hud -attr @style dashed -pin g_mag_tilt.u_heading clk -pin u_auto_zero clk -pin u_mag_cal_planar clk -pin u_mag_calibration clk -pin u_magnetometro clk -pin u_sensor clk -pin u_vector clk
netloc clk_hud 1 0 4 20 280 330 380 750 630 1220J
load net mag_corrected_x[1] -attr @rip corrected_x[1] -pin u_mag_cal_planar mag_x[1] -pin u_mag_calibration corrected_x[1]
load net mag_corrected_x[4] -attr @rip corrected_x[4] -pin u_mag_cal_planar mag_x[4] -pin u_mag_calibration corrected_x[4]
load net mag_corrected_y[3] -attr @rip corrected_y[3] -pin u_mag_cal_planar mag_y[3] -pin u_mag_calibration corrected_y[3]
load net compass_gravity_x[21] -attr @style dashed -attr @rip gravity_x[21] -pin g_mag_tilt.u_heading gravity_x[21] -pin u_vector gravity_x[21]
load net compass_gravity_x[13] -attr @style dashed -attr @rip gravity_x[13] -pin g_mag_tilt.u_heading gravity_x[13] -pin u_vector gravity_x[13]
load net mag_y[9] -attr @style dashed -attr @rip mag_y[9] -pin g_mag_tilt.u_heading mag_y[9] -pin u_mag_calibration my[9] -pin u_magnetometro mag_y[9]
load net compass_gravity_y[21] -attr @style dashed -attr @rip gravity_y[21] -pin g_mag_tilt.u_heading gravity_y[21] -pin u_vector gravity_y[21]
load net compass_gravity_x[5] -attr @style dashed -attr @rip gravity_x[5] -pin g_mag_tilt.u_heading gravity_x[5] -pin u_vector gravity_x[5]
load net compass_gravity_y[13] -attr @style dashed -attr @rip gravity_y[13] -pin g_mag_tilt.u_heading gravity_y[13] -pin u_vector gravity_y[13]
load net compass_gravity_z[15] -attr @style dashed -attr @rip gravity_z[15] -pin g_mag_tilt.u_heading gravity_z[15] -pin u_vector gravity_z[15]
load net mag_x[1] -attr @style dashed -attr @rip mag_x[1] -pin g_mag_tilt.u_heading mag_x[1] -pin u_mag_calibration mx[1] -pin u_magnetometro mag_x[1]
load net compass_gravity_z[21] -attr @style dashed -attr @rip gravity_z[21] -pin g_mag_tilt.u_heading gravity_z[21] -pin u_vector gravity_z[21]
load net mag_z[5] -attr @style dashed -attr @rip mag_z[5] -pin g_mag_tilt.u_heading mag_z[5] -pin u_mag_calibration mz[5] -pin u_magnetometro mag_z[5]
load net compass_gravity_y[5] -attr @style dashed -attr @rip gravity_y[5] -pin g_mag_tilt.u_heading gravity_y[5] -pin u_vector gravity_y[5]
load net mag_y[4] -attr @style dashed -attr @rip mag_y[4] -pin g_mag_tilt.u_heading mag_y[4] -pin u_mag_calibration my[4] -pin u_magnetometro mag_y[4]
load net mag_z[12] -attr @style dashed -attr @rip mag_z[12] -pin g_mag_tilt.u_heading mag_z[12] -pin u_mag_calibration mz[12] -pin u_magnetometro mag_z[12]
load net vector_raw_roll[6] -attr @style dashed -attr @rip raw_roll[6] -pin u_auto_zero raw_roll[6] -pin u_vector raw_roll[6]
load net vector_raw_roll[9] -attr @style dashed -attr @rip raw_roll[9] -pin u_auto_zero raw_roll[9] -pin u_vector raw_roll[9]
load net vector_stationary -attr @style dashed -attr @rip 204 -pin u_auto_zero stationary -pin u_vector stationary
netloc vector_stationary 1 2 1 N 240
load net mpu_gyro_z[13] -attr @style dashed -attr @rip gyro_z[13] -pin u_sensor gyro_z[13] -pin u_vector gz[13]
load net mpu_raw_gy[7] -attr @style dashed -attr @rip gyro_y[7] -pin u_sensor gyro_y[7] -pin u_vector gy[7]
load net mpu_gyro_z[9] -attr @style dashed -attr @rip gyro_z[9] -pin u_sensor gyro_z[9] -pin u_vector gz[9]
load net mpu_gyro_z[8] -attr @style dashed -attr @rip gyro_z[8] -pin u_sensor gyro_z[8] -pin u_vector gz[8]
load net mpu_accel_z[14] -attr @style dashed -attr @rip accel_z[14] -pin u_sensor accel_z[14] -pin u_vector az[14]
load net mpu_raw_ax[12] -attr @style dashed -attr @rip accel_x[12] -pin u_sensor accel_x[12] -pin u_vector ax[12]
load net mpu_raw_ay[1] -attr @style dashed -attr @rip accel_y[1] -pin u_sensor accel_y[1] -pin u_vector ay[1]
load net mpu_raw_gx[3] -attr @style dashed -attr @rip gyro_x[3] -pin u_sensor gyro_x[3] -pin u_vector gx[3]
load net mpu_raw_ax[2] -attr @style dashed -attr @rip accel_x[2] -pin u_sensor accel_x[2] -pin u_vector ax[2]
load net mpu_raw_ay[14] -attr @style dashed -attr @rip accel_y[14] -pin u_sensor accel_y[14] -pin u_vector ay[14]
load net mpu_raw_ax[7] -attr @style dashed -attr @rip accel_x[7] -pin u_sensor accel_x[7] -pin u_vector ax[7]
load net vector_raw_pitch[26] -attr @style dashed -attr @rip raw_pitch[26] -pin u_auto_zero raw_pitch[26] -pin u_vector raw_pitch[26]
load net vector_raw_roll[0] -attr @style dashed -attr @rip raw_roll[0] -pin u_auto_zero raw_roll[0] -pin u_vector raw_roll[0]
load net vector_raw_pitch[16] -attr @style dashed -attr @rip raw_pitch[16] -pin u_auto_zero raw_pitch[16] -pin u_vector raw_pitch[16]
load net vector_raw_pitch[2] -attr @style dashed -attr @rip raw_pitch[2] -pin u_auto_zero raw_pitch[2] -pin u_vector raw_pitch[2]
load net vector_raw_roll[17] -attr @style dashed -attr @rip raw_roll[17] -pin u_auto_zero raw_roll[17] -pin u_vector raw_roll[17]
load net vector_raw_roll[20] -attr @style dashed -attr @rip raw_roll[20] -pin u_auto_zero raw_roll[20] -pin u_vector raw_roll[20]
load net vector_raw_roll[31] -attr @style dashed -attr @rip raw_roll[31] -pin u_auto_zero raw_roll[31] -pin u_vector raw_roll[31]
load net mpu_accel_z[3] -attr @style dashed -attr @rip accel_z[3] -pin u_sensor accel_z[3] -pin u_vector az[3]
load net mpu_raw_gx[11] -attr @style dashed -attr @rip gyro_x[11] -pin u_sensor gyro_x[11] -pin u_vector gx[11]
load net mpu_gyro_z[1] -attr @style dashed -attr @rip gyro_z[1] -pin u_sensor gyro_z[1] -pin u_vector gz[1]
load net mag_x[11] -attr @style dashed -attr @rip mag_x[11] -pin g_mag_tilt.u_heading mag_x[11] -pin u_mag_calibration mx[11] -pin u_magnetometro mag_x[11]
load net mag_x[14] -attr @style dashed -attr @rip mag_x[14] -pin g_mag_tilt.u_heading mag_x[14] -pin u_mag_calibration mx[14] -pin u_magnetometro mag_x[14]
load net mag_x[7] -attr @style dashed -attr @rip mag_x[7] -pin g_mag_tilt.u_heading mag_x[7] -pin u_mag_calibration mx[7] -pin u_magnetometro mag_x[7]
load net mag_corrected_x[0] -attr @rip corrected_x[0] -pin u_mag_cal_planar mag_x[0] -pin u_mag_calibration corrected_x[0]
load net mag_corrected_x[10] -attr @rip corrected_x[10] -pin u_mag_cal_planar mag_x[10] -pin u_mag_calibration corrected_x[10]
load net mag_corrected_x[3] -attr @rip corrected_x[3] -pin u_mag_cal_planar mag_x[3] -pin u_mag_calibration corrected_x[3]
load net mag_corrected_y[4] -attr @rip corrected_y[4] -pin u_mag_cal_planar mag_y[4] -pin u_mag_calibration corrected_y[4]
load net compass_gravity_y[4] -attr @style dashed -attr @rip gravity_y[4] -pin g_mag_tilt.u_heading gravity_y[4] -pin u_vector gravity_y[4]
load net compass_gravity_x[20] -attr @style dashed -attr @rip gravity_x[20] -pin g_mag_tilt.u_heading gravity_x[20] -pin u_vector gravity_x[20]
load net compass_gravity_x[12] -attr @style dashed -attr @rip gravity_x[12] -pin g_mag_tilt.u_heading gravity_x[12] -pin u_vector gravity_x[12]
load net mag_y[6] -attr @style dashed -attr @rip mag_y[6] -pin g_mag_tilt.u_heading mag_y[6] -pin u_mag_calibration my[6] -pin u_magnetometro mag_y[6]
load net compass_gravity_y[20] -attr @style dashed -attr @rip gravity_y[20] -pin g_mag_tilt.u_heading gravity_y[20] -pin u_vector gravity_y[20]
load net compass_gravity_x[4] -attr @style dashed -attr @rip gravity_x[4] -pin g_mag_tilt.u_heading gravity_x[4] -pin u_vector gravity_x[4]
load net compass_gravity_z[20] -attr @style dashed -attr @rip gravity_z[20] -pin g_mag_tilt.u_heading gravity_z[20] -pin u_vector gravity_z[20]
load net mag_z[4] -attr @style dashed -attr @rip mag_z[4] -pin g_mag_tilt.u_heading mag_z[4] -pin u_mag_calibration mz[4] -pin u_magnetometro mag_z[4]
load net mag_y[3] -attr @style dashed -attr @rip mag_y[3] -pin g_mag_tilt.u_heading mag_y[3] -pin u_mag_calibration my[3] -pin u_magnetometro mag_y[3]
load net mag_z[11] -attr @style dashed -attr @rip mag_z[11] -pin g_mag_tilt.u_heading mag_z[11] -pin u_mag_calibration mz[11] -pin u_magnetometro mag_z[11]
load net compass_gravity_y[12] -attr @style dashed -attr @rip gravity_y[12] -pin g_mag_tilt.u_heading gravity_y[12] -pin u_vector gravity_y[12]
load net mag_x[0] -attr @style dashed -attr @rip mag_x[0] -pin g_mag_tilt.u_heading mag_x[0] -pin u_mag_calibration mx[0] -pin u_magnetometro mag_x[0]
load net vector_raw_roll[7] -attr @style dashed -attr @rip raw_roll[7] -pin u_auto_zero raw_roll[7] -pin u_vector raw_roll[7]
load net fusao_valida -attr @style dashed -pin u_auto_zero valid -pin u_vector valid
netloc fusao_valida 1 2 1 N 280
load net mpu_gyro_z[12] -attr @style dashed -attr @rip gyro_z[12] -pin u_sensor gyro_z[12] -pin u_vector gz[12]
load net mpu_raw_gy[2] -attr @style dashed -attr @rip gyro_y[2] -pin u_sensor gyro_y[2] -pin u_vector gy[2]
load net mpu_raw_gy[5] -attr @style dashed -attr @rip gyro_y[5] -pin u_sensor gyro_y[5] -pin u_vector gy[5]
load net mpu_gyro_z[7] -attr @style dashed -attr @rip gyro_z[7] -pin u_sensor gyro_z[7] -pin u_vector gz[7]
load net mag_corrected_x[12] -attr @rip corrected_x[12] -pin u_mag_cal_planar mag_x[12] -pin u_mag_calibration corrected_x[12]
load net mpu_raw_ay[12] -attr @style dashed -attr @rip accel_y[12] -pin u_sensor accel_y[12] -pin u_vector ay[12]
load net mpu_raw_ay[2] -attr @style dashed -attr @rip accel_y[2] -pin u_sensor accel_y[2] -pin u_vector ay[2]
load net mpu_raw_ax[11] -attr @style dashed -attr @rip accel_x[11] -pin u_sensor accel_x[11] -pin u_vector ax[11]
load net mpu_accel_z[13] -attr @style dashed -attr @rip accel_z[13] -pin u_sensor accel_z[13] -pin u_vector az[13]
load net mpu_raw_gx[2] -attr @style dashed -attr @rip gyro_x[2] -pin u_sensor gyro_x[2] -pin u_vector gx[2]
load net mpu_raw_ax[1] -attr @style dashed -attr @rip accel_x[1] -pin u_sensor accel_x[1] -pin u_vector ax[1]
load net mpu_raw_ax[5] -attr @style dashed -attr @rip accel_x[5] -pin u_sensor accel_x[5] -pin u_vector ax[5]
load net vector_raw_pitch[22] -attr @style dashed -attr @rip raw_pitch[22] -pin u_auto_zero raw_pitch[22] -pin u_vector raw_pitch[22]
load net vector_raw_pitch[28] -attr @style dashed -attr @rip raw_pitch[28] -pin u_auto_zero raw_pitch[28] -pin u_vector raw_pitch[28]
load net vector_raw_pitch[31] -attr @style dashed -attr @rip raw_pitch[31] -pin u_auto_zero raw_pitch[31] -pin u_vector raw_pitch[31]
load net vector_raw_pitch[15] -attr @style dashed -attr @rip raw_pitch[15] -pin u_auto_zero raw_pitch[15] -pin u_vector raw_pitch[15]
load net vector_raw_pitch[3] -attr @style dashed -attr @rip raw_pitch[3] -pin u_auto_zero raw_pitch[3] -pin u_vector raw_pitch[3]
load net vector_raw_roll[16] -attr @style dashed -attr @rip raw_roll[16] -pin u_auto_zero raw_roll[16] -pin u_vector raw_roll[16]
load net vector_raw_roll[19] -attr @style dashed -attr @rip raw_roll[19] -pin u_auto_zero raw_roll[19] -pin u_vector raw_roll[19]
load net vector_raw_roll[30] -attr @style dashed -attr @rip raw_roll[30] -pin u_auto_zero raw_roll[30] -pin u_vector raw_roll[30]
load net mpu_accel_z[10] -attr @style dashed -attr @rip accel_z[10] -pin u_sensor accel_z[10] -pin u_vector az[10]
load net mpu_accel_z[2] -attr @style dashed -attr @rip accel_z[2] -pin u_sensor accel_z[2] -pin u_vector az[2]
load net mpu_raw_gx[10] -attr @style dashed -attr @rip gyro_x[10] -pin u_sensor gyro_x[10] -pin u_vector gx[10]
load net mpu_gyro_z[0] -attr @style dashed -attr @rip gyro_z[0] -pin u_sensor gyro_z[0] -pin u_vector gz[0]
load net vector_calibrated -attr @style dashed -attr @rip 203 -pin u_auto_zero calibrated -pin u_vector calibrated
netloc vector_calibrated 1 2 1 770 60n
load net mag_amostra_nova -attr @style dashed -pin g_mag_tilt.u_heading sample -pin u_mag_calibration sample -pin u_magnetometro amostra_nova
netloc mag_amostra_nova 1 2 1 670 450n
load net mag_x[10] -attr @style dashed -attr @rip mag_x[10] -pin g_mag_tilt.u_heading mag_x[10] -pin u_mag_calibration mx[10] -pin u_magnetometro mag_x[10]
load net mag_x[9] -attr @style dashed -attr @rip mag_x[9] -pin g_mag_tilt.u_heading mag_x[9] -pin u_mag_calibration mx[9] -pin u_magnetometro mag_x[9]
load net compass_gravity_z[9] -attr @style dashed -attr @rip gravity_z[9] -pin g_mag_tilt.u_heading gravity_z[9] -pin u_vector gravity_z[9]
load net mag_corrected_y[14] -attr @rip corrected_y[14] -pin u_mag_cal_planar mag_y[14] -pin u_mag_calibration corrected_y[14]
load net mag_corrected_y[1] -attr @rip corrected_y[1] -pin u_mag_cal_planar mag_y[1] -pin u_mag_calibration corrected_y[1]
load net compass_gravity_y[11] -attr @style dashed -attr @rip gravity_y[11] -pin g_mag_tilt.u_heading gravity_y[11] -pin u_vector gravity_y[11]
load net compass_gravity_x[3] -attr @style dashed -attr @rip gravity_x[3] -pin g_mag_tilt.u_heading gravity_x[3] -pin u_vector gravity_x[3]
load net mag_y[2] -attr @style dashed -attr @rip mag_y[2] -pin g_mag_tilt.u_heading mag_y[2] -pin u_mag_calibration my[2] -pin u_magnetometro mag_y[2]
load net compass_gravity_x[11] -attr @style dashed -attr @rip gravity_x[11] -pin g_mag_tilt.u_heading gravity_x[11] -pin u_vector gravity_x[11]
load net compass_gravity_x[19] -attr @style dashed -attr @rip gravity_x[19] -pin g_mag_tilt.u_heading gravity_x[19] -pin u_vector gravity_x[19]
load net compass_gravity_y[3] -attr @style dashed -attr @rip gravity_y[3] -pin g_mag_tilt.u_heading gravity_y[3] -pin u_vector gravity_y[3]
load net compass_gravity_z[19] -attr @style dashed -attr @rip gravity_z[19] -pin g_mag_tilt.u_heading gravity_z[19] -pin u_vector gravity_z[19]
load net compass_gravity_z[14] -attr @style dashed -attr @rip gravity_z[14] -pin g_mag_tilt.u_heading gravity_z[14] -pin u_vector gravity_z[14]
load net compass_gravity_z[11] -attr @style dashed -attr @rip gravity_z[11] -pin g_mag_tilt.u_heading gravity_z[11] -pin u_vector gravity_z[11]
load net compass_gravity_y[19] -attr @style dashed -attr @rip gravity_y[19] -pin g_mag_tilt.u_heading gravity_y[19] -pin u_vector gravity_y[19]
load net mag_y[15] -attr @style dashed -attr @rip mag_y[15] -pin g_mag_tilt.u_heading mag_y[15] -pin u_mag_calibration my[15] -pin u_magnetometro mag_y[15]
load net compass_gravity_z[5] -attr @style dashed -attr @rip gravity_z[5] -pin g_mag_tilt.u_heading gravity_z[5] -pin u_vector gravity_z[5]
load net mag_z[3] -attr @style dashed -attr @rip mag_z[3] -pin g_mag_tilt.u_heading mag_z[3] -pin u_mag_calibration mz[3] -pin u_magnetometro mag_z[3]
load net MAG_LED -attr @style dashed -pin g_mag_tilt.u_heading sensor_ok -pin u_mag_calibration sensor_ok
netloc MAG_LED 1 2 1 790 590n
load net vector_raw_roll[4] -attr @style dashed -attr @rip raw_roll[4] -pin u_auto_zero raw_roll[4] -pin u_vector raw_roll[4]
load net mpu_raw_gy[8] -attr @style dashed -attr @rip gyro_y[8] -pin u_sensor gyro_y[8] -pin u_vector gy[8]
load net mpu_gyro_z[14] -attr @style dashed -attr @rip gyro_z[14] -pin u_sensor gyro_z[14] -pin u_vector gz[14]
load net mpu_gyro_z[11] -attr @style dashed -attr @rip gyro_z[11] -pin u_sensor gyro_z[11] -pin u_vector gz[11]
load net mag_corrected_x[13] -attr @rip corrected_x[13] -pin u_mag_cal_planar mag_x[13] -pin u_mag_calibration corrected_x[13]
load net mpu_raw_ax[0] -attr @style dashed -attr @rip accel_x[0] -pin u_sensor accel_x[0] -pin u_vector ax[0]
load net mpu_raw_gy[12] -attr @style dashed -attr @rip gyro_y[12] -pin u_sensor gyro_y[12] -pin u_vector gy[12]
load net mpu_accel_z[11] -attr @style dashed -attr @rip accel_z[11] -pin u_sensor accel_z[11] -pin u_vector az[11]
load net mpu_raw_ay[11] -attr @style dashed -attr @rip accel_y[11] -pin u_sensor accel_y[11] -pin u_vector ay[11]
load net mpu_raw_ay[10] -attr @style dashed -attr @rip accel_y[10] -pin u_sensor accel_y[10] -pin u_vector ay[10]
load net vector_raw_pitch[24] -attr @style dashed -attr @rip raw_pitch[24] -pin u_auto_zero raw_pitch[24] -pin u_vector raw_pitch[24]
load net vector_raw_pitch[29] -attr @style dashed -attr @rip raw_pitch[29] -pin u_auto_zero raw_pitch[29] -pin u_vector raw_pitch[29]
load net vector_raw_pitch[30] -attr @style dashed -attr @rip raw_pitch[30] -pin u_auto_zero raw_pitch[30] -pin u_vector raw_pitch[30]
load net vector_raw_pitch[12] -attr @style dashed -attr @rip raw_pitch[12] -pin u_auto_zero raw_pitch[12] -pin u_vector raw_pitch[12]
load net vector_raw_pitch[7] -attr @style dashed -attr @rip raw_pitch[7] -pin u_auto_zero raw_pitch[7] -pin u_vector raw_pitch[7]
load net vector_raw_roll[15] -attr @style dashed -attr @rip raw_roll[15] -pin u_auto_zero raw_roll[15] -pin u_vector raw_roll[15]
load net vector_raw_roll[18] -attr @style dashed -attr @rip raw_roll[18] -pin u_auto_zero raw_roll[18] -pin u_vector raw_roll[18]
load net vector_raw_roll[29] -attr @style dashed -attr @rip raw_roll[29] -pin u_auto_zero raw_roll[29] -pin u_vector raw_roll[29]
load net mpu_accel_z[5] -attr @style dashed -attr @rip accel_z[5] -pin u_sensor accel_z[5] -pin u_vector az[5]
load net mpu_raw_gx[13] -attr @style dashed -attr @rip gyro_x[13] -pin u_sensor gyro_x[13] -pin u_vector gx[13]
load net mpu_gyro_z[3] -attr @style dashed -attr @rip gyro_z[3] -pin u_sensor gyro_z[3] -pin u_vector gz[3]
load net mag_x[13] -attr @style dashed -attr @rip mag_x[13] -pin g_mag_tilt.u_heading mag_x[13] -pin u_mag_calibration mx[13] -pin u_magnetometro mag_x[13]
load net mag_x[6] -attr @style dashed -attr @rip mag_x[6] -pin g_mag_tilt.u_heading mag_x[6] -pin u_mag_calibration mx[6] -pin u_magnetometro mag_x[6]
load net mag_corrected_x[8] -attr @rip corrected_x[8] -pin u_mag_cal_planar mag_x[8] -pin u_mag_calibration corrected_x[8]
load net mag_corrected_x[9] -attr @rip corrected_x[9] -pin u_mag_cal_planar mag_x[9] -pin u_mag_calibration corrected_x[9]
load net mag_corrected_y[15] -attr @rip corrected_y[15] -pin u_mag_cal_planar mag_y[15] -pin u_mag_calibration corrected_y[15]
load net mag_corrected_y[2] -attr @rip corrected_y[2] -pin u_mag_cal_planar mag_y[2] -pin u_mag_calibration corrected_y[2]
load net compass_gravity_y[10] -attr @style dashed -attr @rip gravity_y[10] -pin g_mag_tilt.u_heading gravity_y[10] -pin u_vector gravity_y[10]
load net compass_gravity_x[2] -attr @style dashed -attr @rip gravity_x[2] -pin g_mag_tilt.u_heading gravity_x[2] -pin u_vector gravity_x[2]
load net mag_y[1] -attr @style dashed -attr @rip mag_y[1] -pin g_mag_tilt.u_heading mag_y[1] -pin u_mag_calibration my[1] -pin u_magnetometro mag_y[1]
load net compass_gravity_x[10] -attr @style dashed -attr @rip gravity_x[10] -pin g_mag_tilt.u_heading gravity_x[10] -pin u_vector gravity_x[10]
load net compass_gravity_x[18] -attr @style dashed -attr @rip gravity_x[18] -pin g_mag_tilt.u_heading gravity_x[18] -pin u_vector gravity_x[18]
load net compass_gravity_y[2] -attr @style dashed -attr @rip gravity_y[2] -pin g_mag_tilt.u_heading gravity_y[2] -pin u_vector gravity_y[2]
load net compass_gravity_z[18] -attr @style dashed -attr @rip gravity_z[18] -pin g_mag_tilt.u_heading gravity_z[18] -pin u_vector gravity_z[18]
load net compass_gravity_z[6] -attr @style dashed -attr @rip gravity_z[6] -pin g_mag_tilt.u_heading gravity_z[6] -pin u_vector gravity_z[6]
load net mag_y[14] -attr @style dashed -attr @rip mag_y[14] -pin g_mag_tilt.u_heading mag_y[14] -pin u_mag_calibration my[14] -pin u_magnetometro mag_y[14]
load net compass_gravity_y[18] -attr @style dashed -attr @rip gravity_y[18] -pin g_mag_tilt.u_heading gravity_y[18] -pin u_vector gravity_y[18]
load net compass_gravity_z[4] -attr @style dashed -attr @rip gravity_z[4] -pin g_mag_tilt.u_heading gravity_z[4] -pin u_vector gravity_z[4]
load net mag_z[2] -attr @style dashed -attr @rip mag_z[2] -pin g_mag_tilt.u_heading mag_z[2] -pin u_mag_calibration mz[2] -pin u_magnetometro mag_z[2]
load net vector_raw_roll[12] -attr @style dashed -attr @rip raw_roll[12] -pin u_auto_zero raw_roll[12] -pin u_vector raw_roll[12]
load net vector_raw_roll[2] -attr @style dashed -attr @rip raw_roll[2] -pin u_auto_zero raw_roll[2] -pin u_vector raw_roll[2]
load net vector_raw_roll[5] -attr @style dashed -attr @rip raw_roll[5] -pin u_auto_zero raw_roll[5] -pin u_vector raw_roll[5]
load net mpu_raw_gy[10] -attr @style dashed -attr @rip gyro_y[10] -pin u_sensor gyro_y[10] -pin u_vector gy[10]
load net mpu_raw_ay[0] -attr @style dashed -attr @rip accel_y[0] -pin u_sensor accel_y[0] -pin u_vector ay[0]
load net mpu_raw_ay[15] -attr @style dashed -attr @rip accel_y[15] -pin u_sensor accel_y[15] -pin u_vector ay[15]
load net mpu_raw_ax[13] -attr @style dashed -attr @rip accel_x[13] -pin u_sensor accel_x[13] -pin u_vector ax[13]
load net mpu_raw_gx[4] -attr @style dashed -attr @rip gyro_x[4] -pin u_sensor gyro_x[4] -pin u_vector gx[4]
load net mpu_raw_ax[3] -attr @style dashed -attr @rip accel_x[3] -pin u_sensor accel_x[3] -pin u_vector ax[3]
load net vector_raw_pitch[0] -attr @style dashed -attr @rip raw_pitch[0] -pin u_auto_zero raw_pitch[0] -pin u_vector raw_pitch[0]
load net vector_raw_pitch[27] -attr @style dashed -attr @rip raw_pitch[27] -pin u_auto_zero raw_pitch[27] -pin u_vector raw_pitch[27]
load net vector_raw_pitch[11] -attr @style dashed -attr @rip raw_pitch[11] -pin u_auto_zero raw_pitch[11] -pin u_vector raw_pitch[11]
load net vector_raw_pitch[5] -attr @style dashed -attr @rip raw_pitch[5] -pin u_auto_zero raw_pitch[5] -pin u_vector raw_pitch[5]
load net vector_raw_roll[14] -attr @style dashed -attr @rip raw_roll[14] -pin u_auto_zero raw_roll[14] -pin u_vector raw_roll[14]
load net vector_raw_roll[25] -attr @style dashed -attr @rip raw_roll[25] -pin u_auto_zero raw_roll[25] -pin u_vector raw_roll[25]
load net vector_raw_roll[28] -attr @style dashed -attr @rip raw_roll[28] -pin u_auto_zero raw_roll[28] -pin u_vector raw_roll[28]
load net mpu_accel_z[4] -attr @style dashed -attr @rip accel_z[4] -pin u_sensor accel_z[4] -pin u_vector az[4]
load net mpu_raw_gx[12] -attr @style dashed -attr @rip gyro_x[12] -pin u_sensor gyro_x[12] -pin u_vector gx[12]
load net mpu_gyro_z[2] -attr @style dashed -attr @rip gyro_z[2] -pin u_sensor gyro_z[2] -pin u_vector gz[2]
load netBundle @mpu_raw_ax 16 mpu_raw_ax[15] mpu_raw_ax[14] mpu_raw_ax[13] mpu_raw_ax[12] mpu_raw_ax[11] mpu_raw_ax[10] mpu_raw_ax[9] mpu_raw_ax[8] mpu_raw_ax[7] mpu_raw_ax[6] mpu_raw_ax[5] mpu_raw_ax[4] mpu_raw_ax[3] mpu_raw_ax[2] mpu_raw_ax[1] mpu_raw_ax[0] -autobundled -attr @style dashed
netbloc @mpu_raw_ax 1 1 1 N 80
load netBundle @mpu_raw_ay 16 mpu_raw_ay[15] mpu_raw_ay[14] mpu_raw_ay[13] mpu_raw_ay[12] mpu_raw_ay[11] mpu_raw_ay[10] mpu_raw_ay[9] mpu_raw_ay[8] mpu_raw_ay[7] mpu_raw_ay[6] mpu_raw_ay[5] mpu_raw_ay[4] mpu_raw_ay[3] mpu_raw_ay[2] mpu_raw_ay[1] mpu_raw_ay[0] -autobundled -attr @style dashed
netbloc @mpu_raw_ay 1 1 1 N 100
load netBundle @mpu_accel_z 16 mpu_accel_z[15] mpu_accel_z[14] mpu_accel_z[13] mpu_accel_z[12] mpu_accel_z[11] mpu_accel_z[10] mpu_accel_z[9] mpu_accel_z[8] mpu_accel_z[7] mpu_accel_z[6] mpu_accel_z[5] mpu_accel_z[4] mpu_accel_z[3] mpu_accel_z[2] mpu_accel_z[1] mpu_accel_z[0] -autobundled -attr @style dashed
netbloc @mpu_accel_z 1 1 1 N 120
load netBundle @mpu_raw_gx 16 mpu_raw_gx[15] mpu_raw_gx[14] mpu_raw_gx[13] mpu_raw_gx[12] mpu_raw_gx[11] mpu_raw_gx[10] mpu_raw_gx[9] mpu_raw_gx[8] mpu_raw_gx[7] mpu_raw_gx[6] mpu_raw_gx[5] mpu_raw_gx[4] mpu_raw_gx[3] mpu_raw_gx[2] mpu_raw_gx[1] mpu_raw_gx[0] -autobundled -attr @style dashed
netbloc @mpu_raw_gx 1 1 1 N 160
load netBundle @mpu_raw_gy 16 mpu_raw_gy[15] mpu_raw_gy[14] mpu_raw_gy[13] mpu_raw_gy[12] mpu_raw_gy[11] mpu_raw_gy[10] mpu_raw_gy[9] mpu_raw_gy[8] mpu_raw_gy[7] mpu_raw_gy[6] mpu_raw_gy[5] mpu_raw_gy[4] mpu_raw_gy[3] mpu_raw_gy[2] mpu_raw_gy[1] mpu_raw_gy[0] -autobundled -attr @style dashed
netbloc @mpu_raw_gy 1 1 1 N 180
load netBundle @mpu_gyro_z 16 mpu_gyro_z[15] mpu_gyro_z[14] mpu_gyro_z[13] mpu_gyro_z[12] mpu_gyro_z[11] mpu_gyro_z[10] mpu_gyro_z[9] mpu_gyro_z[8] mpu_gyro_z[7] mpu_gyro_z[6] mpu_gyro_z[5] mpu_gyro_z[4] mpu_gyro_z[3] mpu_gyro_z[2] mpu_gyro_z[1] mpu_gyro_z[0] -autobundled -attr @style dashed
netbloc @mpu_gyro_z 1 1 1 N 200
load netBundle @compass_gravity_x 24 compass_gravity_x[23] compass_gravity_x[22] compass_gravity_x[21] compass_gravity_x[20] compass_gravity_x[19] compass_gravity_x[18] compass_gravity_x[17] compass_gravity_x[16] compass_gravity_x[15] compass_gravity_x[14] compass_gravity_x[13] compass_gravity_x[12] compass_gravity_x[11] compass_gravity_x[10] compass_gravity_x[9] compass_gravity_x[8] compass_gravity_x[7] compass_gravity_x[6] compass_gravity_x[5] compass_gravity_x[4] compass_gravity_x[3] compass_gravity_x[2] compass_gravity_x[1] compass_gravity_x[0] -autobundled -attr @style dashed
netbloc @compass_gravity_x 1 2 1 670 100n
load netBundle @compass_gravity_y 24 compass_gravity_y[23] compass_gravity_y[22] compass_gravity_y[21] compass_gravity_y[20] compass_gravity_y[19] compass_gravity_y[18] compass_gravity_y[17] compass_gravity_y[16] compass_gravity_y[15] compass_gravity_y[14] compass_gravity_y[13] compass_gravity_y[12] compass_gravity_y[11] compass_gravity_y[10] compass_gravity_y[9] compass_gravity_y[8] compass_gravity_y[7] compass_gravity_y[6] compass_gravity_y[5] compass_gravity_y[4] compass_gravity_y[3] compass_gravity_y[2] compass_gravity_y[1] compass_gravity_y[0] -autobundled -attr @style dashed
netbloc @compass_gravity_y 1 2 1 730 120n
load netBundle @compass_gravity_z 24 compass_gravity_z[23] compass_gravity_z[22] compass_gravity_z[21] compass_gravity_z[20] compass_gravity_z[19] compass_gravity_z[18] compass_gravity_z[17] compass_gravity_z[16] compass_gravity_z[15] compass_gravity_z[14] compass_gravity_z[13] compass_gravity_z[12] compass_gravity_z[11] compass_gravity_z[10] compass_gravity_z[9] compass_gravity_z[8] compass_gravity_z[7] compass_gravity_z[6] compass_gravity_z[5] compass_gravity_z[4] compass_gravity_z[3] compass_gravity_z[2] compass_gravity_z[1] compass_gravity_z[0] -autobundled -attr @style dashed
netbloc @compass_gravity_z 1 2 1 690 140n
load netBundle @vector_raw_pitch 32 vector_raw_pitch[31] vector_raw_pitch[30] vector_raw_pitch[29] vector_raw_pitch[28] vector_raw_pitch[27] vector_raw_pitch[26] vector_raw_pitch[25] vector_raw_pitch[24] vector_raw_pitch[23] vector_raw_pitch[22] vector_raw_pitch[21] vector_raw_pitch[20] vector_raw_pitch[19] vector_raw_pitch[18] vector_raw_pitch[17] vector_raw_pitch[16] vector_raw_pitch[15] vector_raw_pitch[14] vector_raw_pitch[13] vector_raw_pitch[12] vector_raw_pitch[11] vector_raw_pitch[10] vector_raw_pitch[9] vector_raw_pitch[8] vector_raw_pitch[7] vector_raw_pitch[6] vector_raw_pitch[5] vector_raw_pitch[4] vector_raw_pitch[3] vector_raw_pitch[2] vector_raw_pitch[1] vector_raw_pitch[0] -autobundled -attr @style dashed
netbloc @vector_raw_pitch 1 2 1 N 180
load netBundle @vector_raw_roll 32 vector_raw_roll[31] vector_raw_roll[30] vector_raw_roll[29] vector_raw_roll[28] vector_raw_roll[27] vector_raw_roll[26] vector_raw_roll[25] vector_raw_roll[24] vector_raw_roll[23] vector_raw_roll[22] vector_raw_roll[21] vector_raw_roll[20] vector_raw_roll[19] vector_raw_roll[18] vector_raw_roll[17] vector_raw_roll[16] vector_raw_roll[15] vector_raw_roll[14] vector_raw_roll[13] vector_raw_roll[12] vector_raw_roll[11] vector_raw_roll[10] vector_raw_roll[9] vector_raw_roll[8] vector_raw_roll[7] vector_raw_roll[6] vector_raw_roll[5] vector_raw_roll[4] vector_raw_roll[3] vector_raw_roll[2] vector_raw_roll[1] vector_raw_roll[0] -autobundled -attr @style dashed
netbloc @vector_raw_roll 1 2 1 N 200
load netBundle @mag_x 16 mag_x[15] mag_x[14] mag_x[13] mag_x[12] mag_x[11] mag_x[10] mag_x[9] mag_x[8] mag_x[7] mag_x[6] mag_x[5] mag_x[4] mag_x[3] mag_x[2] mag_x[1] mag_x[0] -autobundled -attr @style dashed
netbloc @mag_x 1 2 1 730 490n
load netBundle @mag_y 16 mag_y[15] mag_y[14] mag_y[13] mag_y[12] mag_y[11] mag_y[10] mag_y[9] mag_y[8] mag_y[7] mag_y[6] mag_y[5] mag_y[4] mag_y[3] mag_y[2] mag_y[1] mag_y[0] -autobundled -attr @style dashed
netbloc @mag_y 1 2 1 710 510n
load netBundle @mag_z 16 mag_z[15] mag_z[14] mag_z[13] mag_z[12] mag_z[11] mag_z[10] mag_z[9] mag_z[8] mag_z[7] mag_z[6] mag_z[5] mag_z[4] mag_z[3] mag_z[2] mag_z[1] mag_z[0] -autobundled -attr @style dashed
netbloc @mag_z 1 2 1 690 530n
load netBundle @mag_corrected_x 16 mag_corrected_x[15] mag_corrected_x[14] mag_corrected_x[13] mag_corrected_x[12] mag_corrected_x[11] mag_corrected_x[10] mag_corrected_x[9] mag_corrected_x[8] mag_corrected_x[7] mag_corrected_x[6] mag_corrected_x[5] mag_corrected_x[4] mag_corrected_x[3] mag_corrected_x[2] mag_corrected_x[1] mag_corrected_x[0] -autobundled
netbloc @mag_corrected_x 1 3 1 N 810
load netBundle @mag_corrected_y 16 mag_corrected_y[15] mag_corrected_y[14] mag_corrected_y[13] mag_corrected_y[12] mag_corrected_y[11] mag_corrected_y[10] mag_corrected_y[9] mag_corrected_y[8] mag_corrected_y[7] mag_corrected_y[6] mag_corrected_y[5] mag_corrected_y[4] mag_corrected_y[3] mag_corrected_y[2] mag_corrected_y[1] mag_corrected_y[0] -autobundled
netbloc @mag_corrected_y 1 3 1 N 830
levelinfo -pg 1 0 100 440 930 1340 1520
pagesize -pg 1 -db -bbox -sgen 0 0 1520 1250
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
