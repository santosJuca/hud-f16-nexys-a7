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
load symbol operacao_hud work:operacao_hud:NOFILE HIERBOX pin ack input.left pin attitude_manual_valid input.left pin buzzer_out output.right pin clk input.left pin invalid_video_mode output.right pin reset input.left pin vertical_real_valido input.left pin video_frame_valid input.left pinBus altitude_real_ft input.left [16:0] pinBus dados output.right [56:0] pinBus fontes_validas input.left [2:0] pinBus heading_manual_deg input.left [8:0] pinBus heading_real_deg input.left [8:0] pinBus metadados output.right [31:0] pinBus novas_amostras input.left [2:0] pinBus pitch_fallback_px input.left [10:0] pinBus pitch_manual_q10 input.left [31:0] pinBus pitch_real_px input.left [10:0] pinBus pitch_real_q10 input.left [31:0] pinBus requested_video_mode output.right [1:0] pinBus roll_fallback_q8 input.left [9:0] pinBus roll_manual_q10 input.left [31:0] pinBus roll_real_q10 input.left [31:0] pinBus roll_real_q8 input.left [9:0] pinBus switches input.left [1:0] pinBus vertical_real_fpm input.left [13:0] pinBus video_frame_index input.left [31:0] pinBus video_phase input.left [2:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol video_flight_profile_pipelined work:video_flight_profile_pipelined:NOFILE HIERBOX pin clk input.left pin frame_valid input.left pin reset input.left pinBus altitude_ft output.right [16:0] pinBus fase_pouso output.right [2:0] pinBus frame_index input.left [31:0] pinBus phase input.left [2:0] pinBus phase_aligned output.right [2:0] pinBus velocidade_kt output.right [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst g_operacao.u_operacao operacao_hud work:operacao_hud:NOFILE -autohide -attr @cell(#1c1f28) operacao_hud -attr @fillcolor #ffffff -pinBusAttr altitude_real_ft @name altitude_real_ft[16:0] -pinBusAttr dados @name dados[56:0] -pinBusAttr fontes_validas @name fontes_validas[2:0] -pinBusAttr heading_manual_deg @name heading_manual_deg[8:0] -pinBusAttr heading_real_deg @name heading_real_deg[8:0] -pinBusAttr metadados @name metadados[31:0] -pinBusAttr novas_amostras @name novas_amostras[2:0] -pinBusAttr pitch_fallback_px @name pitch_fallback_px[10:0] -pinBusAttr pitch_manual_q10 @name pitch_manual_q10[31:0] -pinBusAttr pitch_real_px @name pitch_real_px[10:0] -pinBusAttr pitch_real_q10 @name pitch_real_q10[31:0] -pinBusAttr requested_video_mode @name requested_video_mode[1:0] -pinBusAttr roll_fallback_q8 @name roll_fallback_q8[9:0] -pinBusAttr roll_manual_q10 @name roll_manual_q10[31:0] -pinBusAttr roll_real_q10 @name roll_real_q10[31:0] -pinBusAttr roll_real_q8 @name roll_real_q8[9:0] -pinBusAttr switches @name switches[1:0] -pinBusAttr vertical_real_fpm @name vertical_real_fpm[13:0] -pinBusAttr video_frame_index @name video_frame_index[31:0] -pinBusAttr video_phase @name video_phase[2:0] -pg 1 -lvl 1 -x 160 -y 60
load inst g_operacao.u_operacao|g_video_instruments.u_video_instruments video_flight_profile_pipelined work:video_flight_profile_pipelined:NOFILE -hier g_operacao.u_operacao -attr @name g_video_instruments.u_video_instruments -attr @cell(#1c1f28) video_flight_profile_pipelined -pinBusAttr altitude_ft @name altitude_ft[16:0] -pinBusAttr fase_pouso @name fase_pouso[2:0] -pinBusAttr frame_index @name frame_index[31:0] -pinBusAttr phase @name phase[2:0] -pinBusAttr phase_aligned @name phase_aligned[2:0] -pinBusAttr velocidade_kt @name velocidade_kt[9:0] -pg 1 -lvl 1 -x 350 -y 80
load net g_operacao.u_operacao|clk -attr @style dashed -attr @name clk -hierPin g_operacao.u_operacao clk -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments clk
netloc g_operacao.u_operacao|clk 1 0 1 210 70n
load net g_operacao.u_operacao|video_frame_index[0] -attr @name video_frame_index[0] -attr @rip video_frame_index[0] -hierPin g_operacao.u_operacao video_frame_index[0] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[0]
load net g_operacao.u_operacao|video_frame_index[1] -attr @name video_frame_index[1] -attr @rip video_frame_index[1] -hierPin g_operacao.u_operacao video_frame_index[1] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[1]
load net g_operacao.u_operacao|video_frame_valid -attr @name video_frame_valid -hierPin g_operacao.u_operacao video_frame_valid -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_valid
netloc g_operacao.u_operacao|video_frame_valid 1 0 1 N 130
load net g_operacao.u_operacao|reset -attr @style dashed -attr @name reset -hierPin g_operacao.u_operacao reset -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments reset
netloc g_operacao.u_operacao|reset 1 0 1 190 90n
load net g_operacao.u_operacao|video_frame_index[18] -attr @name video_frame_index[18] -attr @rip video_frame_index[18] -hierPin g_operacao.u_operacao video_frame_index[18] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[18]
load net g_operacao.u_operacao|video_frame_index[10] -attr @name video_frame_index[10] -attr @rip video_frame_index[10] -hierPin g_operacao.u_operacao video_frame_index[10] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[10]
load net g_operacao.u_operacao|video_frame_index[11] -attr @name video_frame_index[11] -attr @rip video_frame_index[11] -hierPin g_operacao.u_operacao video_frame_index[11] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[11]
load net g_operacao.u_operacao|video_frame_index[23] -attr @name video_frame_index[23] -attr @rip video_frame_index[23] -hierPin g_operacao.u_operacao video_frame_index[23] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[23]
load net g_operacao.u_operacao|video_frame_index[24] -attr @name video_frame_index[24] -attr @rip video_frame_index[24] -hierPin g_operacao.u_operacao video_frame_index[24] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[24]
load net g_operacao.u_operacao|video_frame_index[4] -attr @name video_frame_index[4] -attr @rip video_frame_index[4] -hierPin g_operacao.u_operacao video_frame_index[4] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[4]
load net g_operacao.u_operacao|video_frame_index[5] -attr @name video_frame_index[5] -attr @rip video_frame_index[5] -hierPin g_operacao.u_operacao video_frame_index[5] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[5]
load net g_operacao.u_operacao|video_frame_index[6] -attr @name video_frame_index[6] -attr @rip video_frame_index[6] -hierPin g_operacao.u_operacao video_frame_index[6] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[6]
load net g_operacao.u_operacao|video_frame_index[12] -attr @name video_frame_index[12] -attr @rip video_frame_index[12] -hierPin g_operacao.u_operacao video_frame_index[12] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[12]
load net g_operacao.u_operacao|video_frame_index[13] -attr @name video_frame_index[13] -attr @rip video_frame_index[13] -hierPin g_operacao.u_operacao video_frame_index[13] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[13]
load net g_operacao.u_operacao|video_frame_index[14] -attr @name video_frame_index[14] -attr @rip video_frame_index[14] -hierPin g_operacao.u_operacao video_frame_index[14] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[14]
load net g_operacao.u_operacao|video_frame_index[2] -attr @name video_frame_index[2] -attr @rip video_frame_index[2] -hierPin g_operacao.u_operacao video_frame_index[2] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[2]
load net g_operacao.u_operacao|video_frame_index[3] -attr @name video_frame_index[3] -attr @rip video_frame_index[3] -hierPin g_operacao.u_operacao video_frame_index[3] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[3]
load net g_operacao.u_operacao|video_frame_index[7] -attr @name video_frame_index[7] -attr @rip video_frame_index[7] -hierPin g_operacao.u_operacao video_frame_index[7] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[7]
load net g_operacao.u_operacao|video_frame_index[8] -attr @name video_frame_index[8] -attr @rip video_frame_index[8] -hierPin g_operacao.u_operacao video_frame_index[8] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[8]
load net g_operacao.u_operacao|video_frame_index[9] -attr @name video_frame_index[9] -attr @rip video_frame_index[9] -hierPin g_operacao.u_operacao video_frame_index[9] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[9]
load net g_operacao.u_operacao|video_frame_index[15] -attr @name video_frame_index[15] -attr @rip video_frame_index[15] -hierPin g_operacao.u_operacao video_frame_index[15] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[15]
load net g_operacao.u_operacao|video_frame_index[16] -attr @name video_frame_index[16] -attr @rip video_frame_index[16] -hierPin g_operacao.u_operacao video_frame_index[16] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[16]
load net g_operacao.u_operacao|video_frame_index[17] -attr @name video_frame_index[17] -attr @rip video_frame_index[17] -hierPin g_operacao.u_operacao video_frame_index[17] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[17]
load net g_operacao.u_operacao|video_frame_index[25] -attr @name video_frame_index[25] -attr @rip video_frame_index[25] -hierPin g_operacao.u_operacao video_frame_index[25] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[25]
load net g_operacao.u_operacao|video_frame_index[28] -attr @name video_frame_index[28] -attr @rip video_frame_index[28] -hierPin g_operacao.u_operacao video_frame_index[28] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[28]
load net g_operacao.u_operacao|video_frame_index[29] -attr @name video_frame_index[29] -attr @rip video_frame_index[29] -hierPin g_operacao.u_operacao video_frame_index[29] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[29]
load net g_operacao.u_operacao|video_frame_index[30] -attr @name video_frame_index[30] -attr @rip video_frame_index[30] -hierPin g_operacao.u_operacao video_frame_index[30] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[30]
load net g_operacao.u_operacao|video_frame_index[31] -attr @name video_frame_index[31] -attr @rip video_frame_index[31] -hierPin g_operacao.u_operacao video_frame_index[31] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[31]
load net g_operacao.u_operacao|video_phase[0] -attr @name video_phase[0] -attr @rip video_phase[0] -hierPin g_operacao.u_operacao video_phase[0] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase[0]
load net g_operacao.u_operacao|video_phase[1] -attr @name video_phase[1] -attr @rip video_phase[1] -hierPin g_operacao.u_operacao video_phase[1] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase[1]
load net g_operacao.u_operacao|video_frame_index[27] -attr @name video_frame_index[27] -attr @rip video_frame_index[27] -hierPin g_operacao.u_operacao video_frame_index[27] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[27]
load net g_operacao.u_operacao|video_frame_index[19] -attr @name video_frame_index[19] -attr @rip video_frame_index[19] -hierPin g_operacao.u_operacao video_frame_index[19] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[19]
load net g_operacao.u_operacao|video_frame_index[20] -attr @name video_frame_index[20] -attr @rip video_frame_index[20] -hierPin g_operacao.u_operacao video_frame_index[20] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[20]
load net g_operacao.u_operacao|video_frame_index[21] -attr @name video_frame_index[21] -attr @rip video_frame_index[21] -hierPin g_operacao.u_operacao video_frame_index[21] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[21]
load net g_operacao.u_operacao|video_frame_index[26] -attr @name video_frame_index[26] -attr @rip video_frame_index[26] -hierPin g_operacao.u_operacao video_frame_index[26] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[26]
load net g_operacao.u_operacao|video_frame_index[22] -attr @name video_frame_index[22] -attr @rip video_frame_index[22] -hierPin g_operacao.u_operacao video_frame_index[22] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments frame_index[22]
load net g_operacao.u_operacao|video_phase[2] -attr @name video_phase[2] -attr @rip video_phase[2] -hierPin g_operacao.u_operacao video_phase[2] -pin g_operacao.u_operacao|g_video_instruments.u_video_instruments phase[2]
load netBundle @g_operacao.u_operacao|video_fr 32 g_operacao.u_operacao|video_frame_index[31] g_operacao.u_operacao|video_frame_index[30] g_operacao.u_operacao|video_frame_index[29] g_operacao.u_operacao|video_frame_index[28] g_operacao.u_operacao|video_frame_index[27] g_operacao.u_operacao|video_frame_index[26] g_operacao.u_operacao|video_frame_index[25] g_operacao.u_operacao|video_frame_index[24] g_operacao.u_operacao|video_frame_index[23] g_operacao.u_operacao|video_frame_index[22] g_operacao.u_operacao|video_frame_index[21] g_operacao.u_operacao|video_frame_index[20] g_operacao.u_operacao|video_frame_index[19] g_operacao.u_operacao|video_frame_index[18] g_operacao.u_operacao|video_frame_index[17] g_operacao.u_operacao|video_frame_index[16] g_operacao.u_operacao|video_frame_index[15] g_operacao.u_operacao|video_frame_index[14] g_operacao.u_operacao|video_frame_index[13] g_operacao.u_operacao|video_frame_index[12] g_operacao.u_operacao|video_frame_index[11] g_operacao.u_operacao|video_frame_index[10] g_operacao.u_operacao|video_frame_index[9] g_operacao.u_operacao|video_frame_index[8] g_operacao.u_operacao|video_frame_index[7] g_operacao.u_operacao|video_frame_index[6] g_operacao.u_operacao|video_frame_index[5] g_operacao.u_operacao|video_frame_index[4] g_operacao.u_operacao|video_frame_index[3] g_operacao.u_operacao|video_frame_index[2] g_operacao.u_operacao|video_frame_index[1] g_operacao.u_operacao|video_frame_index[0] -autobundled
netbloc @g_operacao.u_operacao|video_fr 1 0 1 N 110
load netBundle @g_operacao.u_operacao|video_ph 3 g_operacao.u_operacao|video_phase[2] g_operacao.u_operacao|video_phase[1] g_operacao.u_operacao|video_phase[0] -autobundled
netbloc @g_operacao.u_operacao|video_ph 1 0 1 N 150
levelinfo -pg 1 0 160 550
levelinfo -hier g_operacao.u_operacao * 350 *
pagesize -pg 1 -db -bbox -sgen 0 0 550 240
pagesize -hier g_operacao.u_operacao -db -bbox -sgen 160 30 540 210
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
