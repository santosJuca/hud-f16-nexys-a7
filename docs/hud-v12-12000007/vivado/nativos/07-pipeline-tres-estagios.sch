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
load symbol operacao_hud work:operacao_hud:NOFILE HIERBOX pin FSM_onehot_phase_reg[0] output.right pin FSM_onehot_phase_reg[0]_0 output.right pin FSM_onehot_phase_reg[0]_1 output.right pin FSM_onehot_phase_reg[0]_2 output.right pin FSM_onehot_phase_reg[0]_3 output.right pin FSM_onehot_phase_reg[1] output.right pin FSM_onehot_phase_reg[4] output.right pin ack input.left pin altitude_ft_reg[8] output.right pin clk_hud input.left pin estado_reg[1]_0 output.right pin estado_reg[3]_0 input.left pin estado_reg[4]_0 input.left pin estado_reg[7]_2 input.left pin fase_pouso_reg[2] output.right pin frame_index_reg[5] input.left pin frame_index_reg[5]_0 input.left pin frame_index_reg[7] input.left pin frame_index_reg[8] input.left pin g_idade[0].recentes_reg[0]_0 output.right pin g_idade[0].recentes_reg[0]_1 output.right pin g_idade[2].recentes_reg[2]_0 output.right pin in0 input.left pin invalid_video_mode output.right pin modo_atitude_manual output.right pin modo_invalido_reg output.right pin modo_invalido_reg_0 output.right pin p_1_in input.left pin pc_i_12 input.left pin pc_reg input.left pin pc_reg_0 input.left pin pw_reg input.left pin pw_reg_0 input.left pin pw_reg_1 input.left pin pw_reg_2 input.left pin reset_operacao output.right pin sensor_reg input.left pin updated input.left pin usar_mpu input.left pin valid_a input.left pinBus B input.left [12:0] pinBus CO input.left [0:0] pinBus D output.right [51:0] pinBus DI output.right [0:0] pinBus O input.left [0:0] pinBus Q input.left [3:0] pinBus S output.right [0:0] pinBus SD_DIAG_PAGE_IBUF input.left [3:0] pinBus SR input.left [0:0] pinBus SS input.left [0:0] pinBus ar0 input.left [4:0] pinBus dados_reg[8]_0 input.left [8:0] pinBus estado_reg[0]_0 output.right [0:0] pinBus estado_reg[7]_0 input.left [0:0] pinBus estado_reg[7]_1 input.left [1:0] pinBus g_idade[2].idade_reg[0]_0 input.left [0:0] pinBus g_idade[2].idade_reg[25]_0 input.left [0:0] pinBus meta_reg[3] input.left [20:0] pinBus out input.left [1:0] pinBus p_0_out input.left [0:0] pinBus phase_a_reg[2] input.left [2:0] pinBus pitch_fallback_q10_reg[31]_0 output.right [0:0] pinBus pitch_fallback_q10_reg[31]_1 output.right [26:0] pinBus pitch_fallback_q10_reg[31]_2 input.left [26:0] pinBus rc_reg input.left [0:0] pinBus rc_reg_0 input.left [0:0] pinBus requested_video_mode output.right [1:0] pinBus roll_fallback_q10_reg[31]_0 output.right [28:0] pinBus roll_fallback_q10_reg[31]_1 output.right [0:0] pinBus roll_fallback_q10_reg[31]_2 input.left [28:0] pinBus roll_reg[0] output.right [0:0] pinBus roll_reg[0]_0 output.right [0:0] pinBus roll_reg[0]_1 output.right [0:0] pinBus roll_reg[0]_2 output.right [0:0] pinBus roll_reg[0]_3 output.right [0:0] pinBus roll_reg[13] output.right [1:0] pinBus roll_reg[13]_0 output.right [0:0] pinBus rw_reg input.left [0:0] pinBus scroll_offset_reg[0] input.left [2:0] pinBus switches input.left [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol video_flight_profile_pipelined work:video_flight_profile_pipelined:NOFILE HIERBOX pin altitude_ft_reg[8]_0 output.right pin baixo0 output.right pin clk_hud input.left pin estado_reg[7] input.left pin estado_reg[7]_0 input.left pin fase_pouso_reg[2]_0 output.right pin inicio_operacao_reg[3] output.right pin modo_atitude_manual input.left pin p_0_in output.right pin pc input.left pin pc0 output.right pin pc_reg input.left pin pc_reg_0 input.left pin pc_reg_1 input.left pin pc_reg_2 input.left pin phase_aligned_reg[0]_0 output.right pin phase_aligned_reg[0]_1 output.right pin phase_aligned_reg[2]_0 output.right pin pw input.left pin pw0 output.right pin pw_reg input.left pin pw_reg_0 input.left pin pw_reg_1 input.left pin pw_reg_2 input.left pin rc input.left pin rc0 output.right pin rc_reg_i_32_0 input.left pin rw input.left pin rw0 output.right pin sc input.left pin sc0 output.right pin speed_q16_b_reg[25]_0 input.left pin stall0 output.right pin stall_reg input.left pin sw input.left pin sw0 output.right pin valid_a input.left pinBus B input.left [12:0] pinBus CO input.left [0:0] pinBus D output.right [0:0] pinBus DI output.right [0:0] pinBus O input.left [0:0] pinBus Q output.right [16:0] pinBus S output.right [0:0] pinBus ar0 input.left [3:0] pinBus phase_a_reg[2]_0 input.left [2:0] pinBus pitch_operacao_q10 input.left [0:0] pinBus rc_reg input.left [0:0] pinBus rc_reg_0 input.left [0:0] pinBus rc_reg_i_32 input.left [3:0] pinBus roll_reg[13] output.right [1:0] pinBus roll_reg[13]_0 output.right [0:0] pinBus rw_reg input.left [0:0] pinBus rw_reg_i_18 input.left [3:0] pinBus velocidade_kt_reg[9]_0 output.right [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol FDRE hdi_primitives GEN pin Q output.right pin C input.clk.left pin CE input.left pin D input.left pin R input.left fillcolor 1
load inst g_operacao.u_operacao operacao_hud work:operacao_hud:NOFILE -autohide -attr @cell(#1c1f28) operacao_hud -attr @fillcolor #ffffff -pinBusAttr B @name B[12:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[51:0] -pinBusAttr DI @name DI -pinBusAttr O @name O -pinBusAttr Q @name Q[3:0] -pinBusAttr S @name S -pinBusAttr SD_DIAG_PAGE_IBUF @name SD_DIAG_PAGE_IBUF[3:0] -pinBusAttr SR @name SR -pinBusAttr SS @name SS -pinBusAttr ar0 @name ar0[4:0] -pinBusAttr dados_reg[8]_0 @name dados_reg[8]_0[8:0] -pinBusAttr estado_reg[0]_0 @name estado_reg[0]_0 -pinBusAttr estado_reg[7]_0 @name estado_reg[7]_0 -pinBusAttr estado_reg[7]_1 @name estado_reg[7]_1[1:0] -pinBusAttr g_idade[2].idade_reg[0]_0 @name g_idade[2].idade_reg[0]_0 -pinBusAttr g_idade[2].idade_reg[25]_0 @name g_idade[2].idade_reg[25]_0 -pinBusAttr meta_reg[3] @name meta_reg[3][20:0] -pinBusAttr out @name out[1:0] -pinBusAttr p_0_out @name p_0_out -pinBusAttr phase_a_reg[2] @name phase_a_reg[2][2:0] -pinBusAttr pitch_fallback_q10_reg[31]_0 @name pitch_fallback_q10_reg[31]_0 -pinBusAttr pitch_fallback_q10_reg[31]_1 @name pitch_fallback_q10_reg[31]_1[26:0] -pinBusAttr pitch_fallback_q10_reg[31]_2 @name pitch_fallback_q10_reg[31]_2[26:0] -pinBusAttr rc_reg @name rc_reg -pinBusAttr rc_reg_0 @name rc_reg_0 -pinBusAttr requested_video_mode @name requested_video_mode[1:0] -pinBusAttr roll_fallback_q10_reg[31]_0 @name roll_fallback_q10_reg[31]_0[28:0] -pinBusAttr roll_fallback_q10_reg[31]_1 @name roll_fallback_q10_reg[31]_1 -pinBusAttr roll_fallback_q10_reg[31]_2 @name roll_fallback_q10_reg[31]_2[28:0] -pinBusAttr roll_reg[0] @name roll_reg[0] -pinBusAttr roll_reg[0]_0 @name roll_reg[0]_0 -pinBusAttr roll_reg[0]_1 @name roll_reg[0]_1 -pinBusAttr roll_reg[0]_2 @name roll_reg[0]_2 -pinBusAttr roll_reg[0]_3 @name roll_reg[0]_3 -pinBusAttr roll_reg[13] @name roll_reg[13][1:0] -pinBusAttr roll_reg[13]_0 @name roll_reg[13]_0 -pinBusAttr rw_reg @name rw_reg -pinBusAttr scroll_offset_reg[0] @name scroll_offset_reg[0][2:0] -pinBusAttr switches @name switches[1:0] -pg 1 -lvl 1 -x 10 -y 70
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments video_flight_profile_pipelined work:video_flight_profile_pipelined:NOFILE -hier g_operacao.u_operacao -autohide -attr @name g_video_instruments.u_video_instruments -attr @cell(#1c1f28) video_flight_profile_pipelined -attr @fillcolor #ffffff -pinBusAttr B @name B[12:0] -pinBusAttr CO @name CO -pinBusAttr D @name D -pinBusAttr DI @name DI -pinBusAttr O @name O -pinBusAttr Q @name Q[16:0] -pinBusAttr S @name S -pinBusAttr ar0 @name ar0[3:0] -pinBusAttr phase_a_reg[2]_0 @name phase_a_reg[2]_0[2:0] -pinBusAttr pitch_operacao_q10 @name pitch_operacao_q10 -pinBusAttr rc_reg @name rc_reg -pinBusAttr rc_reg_0 @name rc_reg_0 -pinBusAttr rc_reg_i_32 @name rc_reg_i_32[3:0] -pinBusAttr roll_reg[13] @name roll_reg[13][1:0] -pinBusAttr roll_reg[13]_0 @name roll_reg[13]_0 -pinBusAttr rw_reg @name rw_reg -pinBusAttr rw_reg_i_18 @name rw_reg_i_18[3:0] -pinBusAttr velocidade_kt_reg[9]_0 @name velocidade_kt_reg[9]_0[9:0] -pg 1 -lvl 1 -x 160 -y 100
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[0] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_a_reg[0] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 1 -x 280 -y 170
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[1] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_a_reg[1] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 1 -x 280 -y 320
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_a_reg[2] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 1 -x 280 -y 500
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[0] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_aligned_reg[0] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 3 -x 660 -y 150
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[1] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_aligned_reg[1] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 3 -x 660 -y 300
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[2] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_aligned_reg[2] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 3 -x 660 -y 460
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[0] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_b_reg[0] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 2 -x 460 -y 160
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[1] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_b_reg[1] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 2 -x 460 -y 310
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[2] FDRE hdi_primitives -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -attr @name phase_b_reg[2] -attr @cell(#1c1f28) FDRE -pg 1 -lvl 2 -x 460 -y 490
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[0] -attr @style dashed -attr @name phase_a_reg_n_0_[0] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[0] Q -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[0] D
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[0] 1 1 1 N 170
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|clk_hud -attr @style dashed -attr @name clk_hud -hierPin g_operacao.u_operacao|g_video_instruments.u_video_instruments clk_hud -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[0] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[1] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[0] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[1] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[2] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[0] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[1] C -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[2] C
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|clk_hud 1 0 3 210 400 390 390 570
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|inicio_operacao_reg[3] -attr @style dashed -attr @name inicio_operacao_reg[3] -hierPin g_operacao.u_operacao|g_video_instruments.u_video_instruments inicio_operacao_reg[3] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[0] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[1] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[0] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[1] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[2] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[0] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[1] R -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[2] R
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|inicio_operacao_reg[3] 1 0 4 230 420 410 410 590 380 NJ
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[1] -attr @style dashed -attr @name phase_a_reg_n_0_[1] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[1] Q -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[1] D
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[1] 1 1 1 N 320
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[2] -attr @style dashed -attr @name phase_a_reg_n_0_[2] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2] Q -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[2] D
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg_n_0_[2] 1 1 1 N 500
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[0] -attr @name phase_a_reg[2]_0[0] -attr @rip(#1c1f28) phase_a_reg[2]_0[0] -hierPin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase_a_reg[2]_0[0] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[0] D
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[1] -attr @name phase_a_reg[2]_0[1] -attr @rip(#1c1f28) phase_a_reg[2]_0[1] -hierPin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase_a_reg[2]_0[1] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[1] D
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[2] -attr @name phase_a_reg[2]_0[2] -attr @rip(#1c1f28) phase_a_reg[2]_0[2] -hierPin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase_a_reg[2]_0[2] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2] D
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[0] -attr @style dashed -attr @name phase_b[0] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[0] D -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[0] Q
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[0] 1 2 1 N 160
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[1] -attr @style dashed -attr @name phase_b[1] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[1] D -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[1] Q
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[1] 1 2 1 N 310
load net g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[2] -attr @style dashed -attr @name phase_b[2] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_aligned_reg[2] D -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b_reg[2] Q
netloc g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_b[2] 1 2 1 570 470n
load netBundle @g_operacao.u_operacao|g_video_ 3 g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[2] g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[1] g_operacao.u_operacao|g_video_instruments.u_video_instruments|phase_a_reg[2]_0[0] -autobundled
netbloc @g_operacao.u_operacao|g_video_ 1 0 1 190 180n
levelinfo -pg 1 0 10 960
levelinfo -hier g_operacao.u_operacao * 160 *
levelinfo -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments * 280 460 660 *
pagesize -pg 1 -db -bbox -sgen 0 0 960 640
pagesize -hier g_operacao.u_operacao -db -bbox -sgen 10 40 950 610
pagesize -hier g_operacao.u_operacao|g_video_instruments.u_video_instruments -db -bbox -sgen 160 70 800 580
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
