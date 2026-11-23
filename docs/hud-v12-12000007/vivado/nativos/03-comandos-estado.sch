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
load symbol entrada_hud work:entrada_hud:NOFILE HIERBOX pin clk_hud input.left pin clk_xadc input.left pin dir_x_q input.left pin dir_x_q_0 input.left pin dir_x_q_reg input.left pin dir_y_q input.left pin inicio_operacao_reg[3] output.right pin inicio_operacao_reg[3]_0 output.right pin inicio_operacao_reg[3]_1 output.right pin p_2_in input.left pin step_x_q[2]_i_2 output.right pin step_x_q[2]_i_4_0 output.right pin step_x_q_reg[2] input.left pin step_y_q[2]_i_4_0 output.right pinBus CO output.right [0:0] pinBus D output.right [11:0] pinBus DI output.right [0:0] pinBus JOY_LED_OBUF output.right [0:0] pinBus JOY_LED_OBUF[1]_inst_i_1 input.left [0:0] pinBus JOY_LED_OBUF[1]_inst_i_3_0 input.left [11:0] pinBus JOY_LED_OBUF[1]_inst_i_3_1 input.left [3:0] pinBus JOY_LED_OBUF[1]_inst_i_7_0 input.left [3:0] pinBus JOY_LED_OBUF[3]_inst_i_10_0 input.left [1:0] pinBus JOY_LED_OBUF[3]_inst_i_10_1 input.left [0:0] pinBus JOY_LED_OBUF[3]_inst_i_3_0 input.left [10:0] pinBus Q output.right [23:0] pinBus S input.left [1:0] pinBus _inferred__1/i__carry__1 input.left [11:0] pinBus _inferred__8/i__carry__1 input.left [11:0] pinBus centro_x_reg[11] output.right [0:0] pinBus dados_destino_reg[10]_0 output.right [3:0] pinBus dados_destino_reg[10]_1 output.right [1:0] pinBus dados_destino_reg[10]_2 output.right [1:0] pinBus dados_destino_reg[10]_3 output.right [2:0] pinBus dados_destino_reg[11]_0 output.right [3:0] pinBus dados_destino_reg[15]_0 output.right [3:0] pinBus dados_destino_reg[18]_0 output.right [3:0] pinBus dados_destino_reg[19]_0 output.right [3:0] pinBus dados_destino_reg[1]_0 output.right [1:0] pinBus dados_destino_reg[22]_0 output.right [1:0] pinBus dados_destino_reg[23]_0 output.right [3:0] pinBus dados_destino_reg[3]_0 output.right [3:0] pinBus dados_destino_reg[3]_1 output.right [3:0] pinBus dados_destino_reg[5]_0 output.right [1:0] pinBus dados_destino_reg[6]_0 output.right [3:0] pinBus dados_destino_reg[6]_1 output.right [3:0] pinBus dados_destino_reg[7]_0 output.right [1:0] pinBus dados_destino_reg[7]_1 output.right [3:0] pinBus dados_destino_reg[7]_2 output.right [3:0] pinBus dir_x_q_reg_0 input.left [0:0] pinBus retido_reg[23]_0 input.left [23:0] pinBus step_x_q3 input.left [4:0] pinBus step_x_q_reg[2]_i_2_0 input.left [11:0] pinBus step_y_q_reg[2]_i_2_0 input.left [11:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol mira_joystick work:mira_joystick:NOFILE HIERBOX pin _inferred__1/i__carry__0_0 output.right pin alvo_lock_origem input.left pin clk_hud input.left pin debounce_count_reg[0]_0 input.left pin dir_x_q output.right pin dir_x_q_reg_2 input.left pin out input.left pin reset_operacao input.left pin step_x_q_reg[2]_0 input.left pinBus D input.left [0:0] pinBus Q output.right [11:0] pinBus center_x_reg[11]_0 output.right [11:0] pinBus center_y_reg[11]_0 input.left [11:0] pinBus dados_destino_reg[10] output.right [0:0] pinBus dados_destino_reg[10]_0 output.right [4:0] pinBus dir_x_q_reg_0 input.left [1:0] pinBus dir_x_q_reg_1 input.left [1:0] pinBus dir_y_q_reg_0 input.left [1:0] pinBus locked_reg_0 output.right [19:0] pinBus step_x_q5_carry__0_0 input.left [3:0] pinBus step_x_q5_carry__0_1 input.left [3:0] pinBus step_x_q[2]_i_2_0 input.left [3:0] pinBus step_x_q[2]_i_2_1 input.left [3:0] pinBus step_x_q_reg[2]_1 input.left [3:0] pinBus step_x_q_reg[2]_2 input.left [3:0] pinBus step_x_q_reg[2]_3 input.left [2:0] pinBus step_x_q_reg[2]_4 input.left [3:0] pinBus step_y_q5_carry__0_0 input.left [3:0] pinBus step_y_q5_carry__0_1 input.left [23:0] pinBus step_y_q[2]_i_2_0 input.left [3:0] pinBus step_y_q_reg[2]_0 input.left [3:0] pinBus step_y_q_reg[2]_1 input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol mira_joystick__parameterized0 work:mira_joystick__parameterized0:NOFILE HIERBOX pin alvo_lock_origem output.right pin clk_hud input.left pin dir_x_q output.right pin dir_x_q_reg_0 input.left pin dir_y_q output.right pin dir_y_q_reg_0 input.left pin out input.left pin reset_operacao input.left pin step_x_q_reg[2]_0 input.left pin step_y_q_reg[2]_0 input.left pin x_reg[8]_0 input.left pinBus D input.left [0:0] pinBus Q output.right [11:0] pinBus center_x_reg[11]_0 input.left [11:0] pinBus center_y_reg[11]_0 output.right [11:0] pinBus center_y_reg[11]_1 input.left [11:0] pinBus y_reg[8]_0 output.right [18:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE HIERBOX pin amostra_valida output.right pin clk_hud input.left pin dados_destino_reg[10]_0 output.right pin dados_destino_reg[11]_0 output.right pin dados_destino_reg[12]_0 output.right pin dados_destino_reg[16]_0 output.right pin dados_destino_reg[17]_0 output.right pin dados_destino_reg[18]_0 output.right pin dados_destino_reg[18]_1 output.right pin dados_destino_reg[4]_0 output.right pin dados_destino_reg[4]_1 output.right pin dados_destino_reg[4]_2 output.right pin dados_destino_reg[4]_3 output.right pin dados_destino_reg[4]_4 output.right pin dados_destino_reg[4]_5 output.right pin dados_destino_reg[4]_6 output.right pin dados_destino_reg[4]_7 output.right pin pixel_clk input.left pinBus D output.right [1:0] pinBus Q output.right [71:0] pinBus SR output.right [0:0] pinBus dados_destino_reg[17]_1 output.right [1:0] pinBus dados_destino_reg[80]_0 output.right [0:0] pinBus retido_reg[121]_0 input.left [90:0] pinBus valido_destino_reg_0 output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol dados_hud work:dados_hud:NOFILE HIERBOX pin VGA_R_OBUF[3]_inst_i_1085_0 output.right pin VGA_R_OBUF[3]_inst_i_1109_0 input.left pin VGA_R_OBUF[3]_inst_i_1164_0 output.right pin VGA_R_OBUF[3]_inst_i_1167_0 input.left pin VGA_R_OBUF[3]_inst_i_1167_1 input.left pin VGA_R_OBUF[3]_inst_i_1168_0 input.left pin VGA_R_OBUF[3]_inst_i_1168_1 input.left pin VGA_R_OBUF[3]_inst_i_1202_0 input.left pin VGA_R_OBUF[3]_inst_i_1204_0 input.left pin VGA_R_OBUF[3]_inst_i_1204_1 input.left pin VGA_R_OBUF[3]_inst_i_1204_2 input.left pin VGA_R_OBUF[3]_inst_i_1425_0 output.right pin VGA_R_OBUF[3]_inst_i_1450 input.left pin VGA_R_OBUF[3]_inst_i_1451 output.right pin VGA_R_OBUF[3]_inst_i_1472_0 output.right pin VGA_R_OBUF[3]_inst_i_1489_0 output.right pin VGA_R_OBUF[3]_inst_i_156 input.left pin VGA_R_OBUF[3]_inst_i_1562 output.right pin VGA_R_OBUF[3]_inst_i_1562_0 output.right pin VGA_R_OBUF[3]_inst_i_1574 output.right pin VGA_R_OBUF[3]_inst_i_159 input.left pin VGA_R_OBUF[3]_inst_i_159_0 input.left pin VGA_R_OBUF[3]_inst_i_159_1 input.left pin VGA_R_OBUF[3]_inst_i_1605 input.left pin VGA_R_OBUF[3]_inst_i_1605_0 input.left pin VGA_R_OBUF[3]_inst_i_1608 input.left pin VGA_R_OBUF[3]_inst_i_1608_0 input.left pin VGA_R_OBUF[3]_inst_i_1631 input.left pin VGA_R_OBUF[3]_inst_i_1631_0 input.left pin VGA_R_OBUF[3]_inst_i_1631_1 input.left pin VGA_R_OBUF[3]_inst_i_1664_0 output.right pin VGA_R_OBUF[3]_inst_i_1674 input.left pin VGA_R_OBUF[3]_inst_i_1674_0 input.left pin VGA_R_OBUF[3]_inst_i_180_0 output.right pin VGA_R_OBUF[3]_inst_i_2001_0 output.right pin VGA_R_OBUF[3]_inst_i_2003_0 output.right pin VGA_R_OBUF[3]_inst_i_2005_0 output.right pin VGA_R_OBUF[3]_inst_i_2017 output.right pin VGA_R_OBUF[3]_inst_i_2021_0 output.right pin VGA_R_OBUF[3]_inst_i_2061_0 output.right pin VGA_R_OBUF[3]_inst_i_2092_0 output.right pin VGA_R_OBUF[3]_inst_i_2094_0 output.right pin VGA_R_OBUF[3]_inst_i_209_0 output.right pin VGA_R_OBUF[3]_inst_i_2129 output.right pin VGA_R_OBUF[3]_inst_i_2139_0 input.left pin VGA_R_OBUF[3]_inst_i_2145 input.left pin VGA_R_OBUF[3]_inst_i_2146_0 input.left pin VGA_R_OBUF[3]_inst_i_2269_0 output.right pin VGA_R_OBUF[3]_inst_i_2275 input.left pin VGA_R_OBUF[3]_inst_i_2275_0 input.left pin VGA_R_OBUF[3]_inst_i_2545_0 output.right pin VGA_R_OBUF[3]_inst_i_2547_0 output.right pin VGA_R_OBUF[3]_inst_i_2781 input.left pin VGA_R_OBUF[3]_inst_i_2781_0 input.left pin VGA_R_OBUF[3]_inst_i_2781_1 input.left pin VGA_R_OBUF[3]_inst_i_2782_0 output.right pin VGA_R_OBUF[3]_inst_i_2783_0 output.right pin VGA_R_OBUF[3]_inst_i_2783_1 output.right pin VGA_R_OBUF[3]_inst_i_2783_2 output.right pin VGA_R_OBUF[3]_inst_i_2783_3 input.left pin VGA_R_OBUF[3]_inst_i_2783_4 input.left pin VGA_R_OBUF[3]_inst_i_2783_5 input.left pin VGA_R_OBUF[3]_inst_i_2809 input.left pin VGA_R_OBUF[3]_inst_i_2809_0 input.left pin VGA_R_OBUF[3]_inst_i_30_0 input.left pin VGA_R_OBUF[3]_inst_i_3346 input.left pin VGA_R_OBUF[3]_inst_i_3346_0 input.left pin VGA_R_OBUF[3]_inst_i_3346_1 input.left pin VGA_R_OBUF[3]_inst_i_3349 input.left pin VGA_R_OBUF[3]_inst_i_3349_0 input.left pin VGA_R_OBUF[3]_inst_i_3369 output.right pin VGA_R_OBUF[3]_inst_i_3385_0 output.right pin VGA_R_OBUF[3]_inst_i_3446 input.left pin VGA_R_OBUF[3]_inst_i_3446_0 input.left pin VGA_R_OBUF[3]_inst_i_3446_1 input.left pin VGA_R_OBUF[3]_inst_i_3466 input.left pin VGA_R_OBUF[3]_inst_i_3546 input.left pin VGA_R_OBUF[3]_inst_i_369_0 input.left pin VGA_R_OBUF[3]_inst_i_369_1 input.left pin VGA_R_OBUF[3]_inst_i_393_0 input.left pin VGA_R_OBUF[3]_inst_i_394_0 input.left pin VGA_R_OBUF[3]_inst_i_3957 input.left pin VGA_R_OBUF[3]_inst_i_3957_0 input.left pin VGA_R_OBUF[3]_inst_i_395_1 input.left pin VGA_R_OBUF[3]_inst_i_3964 input.left pin VGA_R_OBUF[3]_inst_i_4007 input.left pin VGA_R_OBUF[3]_inst_i_4008 input.left pin VGA_R_OBUF[3]_inst_i_408_0 input.left pin VGA_R_OBUF[3]_inst_i_408_1 input.left pin VGA_R_OBUF[3]_inst_i_4356 input.left pin VGA_R_OBUF[3]_inst_i_516_0 input.left pin VGA_R_OBUF[3]_inst_i_820_0 input.left pin VGA_R_OBUF[3]_inst_i_820_1 input.left pin VGA_R_OBUF[3]_inst_i_820_2 input.left pin VGA_R_OBUF[3]_inst_i_832_0 input.left pin VGA_R_OBUF[3]_inst_i_839_1 input.left pin altitude_ft_reg[16]_1 output.right pin altitude_ft_reg[16]_2 output.right pin altitude_ft_reg[16]_3 output.right pin altitude_ft_reg[16]_4 output.right pin altitude_ft_reg[16]_5 output.right pin altitude_ft_reg[3]_0 output.right pin altitude_ft_reg[3]_1 output.right pin altitude_ft_reg[3]_10 output.right pin altitude_ft_reg[3]_11 output.right pin altitude_ft_reg[3]_2 output.right pin altitude_ft_reg[3]_3 output.right pin altitude_ft_reg[3]_4 output.right pin altitude_ft_reg[3]_5 output.right pin altitude_ft_reg[3]_6 output.right pin altitude_ft_reg[3]_7 output.right pin altitude_ft_reg[3]_8 output.right pin altitude_ft_reg[3]_9 output.right pin altitude_ft_reg[4]_0 output.right pin altitude_ft_reg[5]_0 output.right pin altitude_ft_reg[6]_0 output.right pin altitude_ft_reg[7]_0 output.right pin alvo output.right pin alvo_x_pendente_reg[0]_0 input.left pin alvo_x_pendente_reg[1]_0 input.left pin alvo_x_pendente_reg[2]_0 input.left pin alvo_x_pendente_reg[5]_0 input.left pin alvo_x_pendente_reg[6]_0 input.left pin alvo_x_pendente_reg[7]_0 input.left pin alvo_x_pendente_reg[8]_0 input.left pin alvo_x_pendente_reg[9]_0 input.left pin alvo_x_reg[6]_0 output.right pin alvo_x_reg[7]_0 output.right pin alvo_y_pendente_reg[0]_0 input.left pin alvo_y_pendente_reg[1]_0 input.left pin alvo_y_pendente_reg[2]_0 input.left pin alvo_y_pendente_reg[5]_0 input.left pin alvo_y_pendente_reg[6]_0 input.left pin alvo_y_pendente_reg[7]_0 input.left pin alvo_y_pendente_reg[8]_0 input.left pin alvo_y_reg[6]_0 output.right pin alvo_y_reg[7]_0 output.right pin alvo_y_reg[7]_1 output.right pin alvo_y_reg[7]_2 output.right pin alvo_y_reg[8]_1 output.right pin amostra_valida input.left pin g_native_video.frame_boundary input.left pin h_cont_reg[1]_rep__0 output.right pin h_cont_reg[1]_rep__0_0 output.right pin h_cont_reg[1]_rep__1 output.right pin h_cont_reg[6] output.right pin h_cont_reg[7] output.right pin h_cont_reg[9]_3 output.right pin h_cont_reg[9]_4 output.right pin heading_deg_reg[0]_15 output.right pin heading_deg_reg[3]_0 output.right pin heading_deg_reg[3]_1 output.right pin heading_deg_reg[3]_2 output.right pin heading_deg_reg[3]_3 output.right pin heading_deg_reg[3]_4 output.right pin heading_deg_reg[7]_2 output.right pin heading_deg_reg[7]_3 output.right pin heading_deg_reg[7]_5 output.right pin heading_deg_reg[7]_6 output.right pin heading_deg_reg[8]_rep_0 output.right pin heading_deg_reg[8]_rep_1 output.right pin heading_deg_reg[8]_rep_2 output.right pin heading_deg_reg[8]_rep_3 output.right pin heading_deg_reg[8]_rep_4 output.right pin heading_deg_reg[8]_rep_6 output.right pin heading_deg_reg[8]_rep_7 output.right pin heading_deg_reg[8]_rep_8 output.right pin hud_video_on input.left pin metadados_reg[0]_0 output.right pin metadados_reg[10]_0 output.right pin metadados_reg[10]_1 output.right pin metadados_reg[11]_0 output.right pin metadados_reg[12]_0 output.right pin metadados_reg[12]_1 output.right pin metadados_reg[12]_2 output.right pin metadados_reg[12]_3 output.right pin metadados_reg[12]_4 output.right pin metadados_reg[12]_5 output.right pin metadados_reg[12]_6 output.right pin metadados_reg[25]_0 output.right pin metadados_reg[25]_1 output.right pin metadados_reg[25]_2 output.right pin metadados_reg[25]_3 output.right pin metadados_reg[25]_4 output.right pin metadados_reg[9]_0 output.right pin metadados_reg[9]_1 output.right pin mira_lock output.right pin on2264_in output.right pin pixel_clk input.left pin texto90 output.right pin texto9131_in output.right pin v_cont_reg[0] output.right pin v_cont_reg[5] output.right pin v_cont_reg[5]_rep__0 output.right pin v_cont_reg[6]_rep__0 output.right pin v_cont_reg[7]_rep output.right pin v_cont_reg[7]_rep_0 output.right pin v_cont_reg[7]_rep_1 output.right pin v_cont_reg[8] output.right pin v_cont_reg[8]_0 output.right pin v_cont_reg[8]_1 output.right pin v_cont_reg[8]_2 output.right pin velocidade_kt_reg[0]_0 output.right pin velocidade_kt_reg[0]_1 output.right pin velocidade_kt_reg[0]_2 output.right pin velocidade_kt_reg[0]_3 output.right pin velocidade_kt_reg[0]_4 output.right pin velocidade_kt_reg[1]_1 output.right pin velocidade_kt_reg[1]_2 output.right pin velocidade_kt_reg[1]_3 output.right pin velocidade_kt_reg[2]_0 output.right pin velocidade_kt_reg[3]_0 output.right pin velocidade_kt_reg[9]_0 output.right pin velocidade_kt_reg[9]_1 output.right pin velocidade_kt_reg[9]_10 output.right pin velocidade_kt_reg[9]_11 output.right pin velocidade_kt_reg[9]_12 output.right pin velocidade_kt_reg[9]_2 output.right pin velocidade_kt_reg[9]_3 output.right pin velocidade_kt_reg[9]_4 output.right pin velocidade_kt_reg[9]_5 output.right pin velocidade_kt_reg[9]_6 output.right pin velocidade_kt_reg[9]_7 output.right pin velocidade_kt_reg[9]_8 output.right pin velocidade_kt_reg[9]_9 output.right pinBus A output.right [11:0] pinBus CO input.left [0:0] pinBus D input.left [1:0] pinBus DI input.left [1:0] pinBus O output.right [2:0] pinBus Q input.left [71:0] pinBus S output.right [2:0] pinBus SR input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_100 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_101 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_102 input.left [0:0] pinBus VGA_G_OBUF[3]_inst_i_98 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1072 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_1072_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1093 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1105 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1109 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1118 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1122 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1174_2 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1174_3 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1182_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_1182_1 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_139_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_140_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_145_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_146_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_148_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_150_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1561 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1567_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1578 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_1670_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_1670_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_1679_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_2150 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2218_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2228_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2238_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2248_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_1 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_2 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_3 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_4 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_5 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_2869_6 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_2869_7 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_2961_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_30 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_31 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_32 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_32_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_33 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_3420_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3420_1 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_3431_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3431_1 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_3436_0 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_3436_1 output.right [3:0] pinBus VGA_R_OBUF[3]_inst_i_3436_2 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_3436_3 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_3440_0 output.right [3:0] pinBus VGA_R_OBUF[3]_inst_i_3466_0 input.left [7:0] pinBus VGA_R_OBUF[3]_inst_i_3480_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3507_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3533_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_353_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_353_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3560_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_3611_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_393 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_394 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_394_1 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_395_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_3980_0 output.right [2:0] pinBus VGA_R_OBUF[3]_inst_i_4003_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_4029_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4060_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4091_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4122_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4155_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4166_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4175_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_4633_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4648_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4664_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_4691_0 output.right [1:0] pinBus VGA_R_OBUF[3]_inst_i_55 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_60_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_674_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_674_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_680_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_705_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_722_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_73_0 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_76 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_766 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_767_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_77 input.left [2:0] pinBus VGA_R_OBUF[3]_inst_i_771_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_776_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_786 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_822_0 input.left [3:0] pinBus VGA_R_OBUF[3]_inst_i_822_1 input.left [4:0] pinBus VGA_R_OBUF[3]_inst_i_839_0 input.left [1:0] pinBus VGA_R_OBUF[3]_inst_i_840_0 input.left [2:0] pinBus altitude_ft_reg[16]_0 output.right [16:0] pinBus altitude_ft_reg[4]_1 output.right [0:0] pinBus altitude_ft_reg[6]_1 output.right [2:0] pinBus altitude_pendente_reg[16]_0 input.left [0:0] pinBus alvo_x_reg[3]_0 output.right [3:0] pinBus alvo_y_pendente_reg[4]_0 input.left [1:0] pinBus alvo_y_reg[8]_0 output.right [4:0] pinBus h_cont_reg[5]_rep output.right [2:0] pinBus h_cont_reg[5]_rep_0 output.right [2:0] pinBus h_cont_reg[5]_rep_1 output.right [2:0] pinBus h_cont_reg[9] output.right [3:0] pinBus h_cont_reg[9]_0 output.right [3:0] pinBus h_cont_reg[9]_1 output.right [3:0] pinBus h_cont_reg[9]_2 output.right [3:0] pinBus heading_deg_reg[0]_0 output.right [6:0] pinBus heading_deg_reg[0]_1 output.right [2:0] pinBus heading_deg_reg[0]_10 output.right [3:0] pinBus heading_deg_reg[0]_11 output.right [2:0] pinBus heading_deg_reg[0]_12 output.right [3:0] pinBus heading_deg_reg[0]_13 output.right [2:0] pinBus heading_deg_reg[0]_14 output.right [3:0] pinBus heading_deg_reg[0]_2 output.right [2:0] pinBus heading_deg_reg[0]_3 output.right [3:0] pinBus heading_deg_reg[0]_4 output.right [3:0] pinBus heading_deg_reg[0]_5 output.right [0:0] pinBus heading_deg_reg[0]_6 output.right [3:0] pinBus heading_deg_reg[0]_7 output.right [2:0] pinBus heading_deg_reg[0]_8 output.right [3:0] pinBus heading_deg_reg[0]_9 output.right [2:0] pinBus heading_deg_reg[7]_0 output.right [3:0] pinBus heading_deg_reg[7]_1 output.right [1:0] pinBus heading_deg_reg[7]_4 output.right [0:0] pinBus heading_deg_reg[7]_rep_0 output.right [0:0] pinBus heading_deg_reg[7]_rep_1 output.right [0:0] pinBus heading_deg_reg[8]_0 output.right [0:0] pinBus heading_deg_reg[8]_1 output.right [0:0] pinBus heading_deg_reg[8]_rep_5 output.right [0:0] pinBus heading_pendente_reg[8]_0 input.left [0:0] pinBus hud_pixel_x input.left [7:0] pinBus hud_pixel_y input.left [9:0] pinBus metadados_reg[15]_0 output.right [11:0] pinBus mira_x_reg[9]_0 output.right [9:0] pinBus mira_y_reg[8]_0 output.right [8:0] pinBus velocidade_kt_reg[1]_0 output.right [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hud_command_dispatch work:hud_command_dispatch:NOFILE HIERBOX pin align_mode output.right pin clk_hud input.left pin inicio_operacao_reg[3] output.right pin reset_operacao input.left pin route_previous_reg[0]_0 input.left pin switch_count_reg[0]_0 input.left pinBus SD_DIAG_PAGE_IBUF input.left [0:0] pinBus align_command_buttons output.right [1:0] pinBus btn output.right [1:0] pinBus capture_grid_pulse_reg_0 input.left [0:0] pinBus in0 input.left [1:0] pinBus page input.left [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol captura_controle work:captura_controle:NOFILE HIERBOX pin align_mode input.left pin auto_zero_request input.left pin button input.left pin capture_reg_1 output.right pin clk_hud input.left pin filtered_reg_0 input.left pin in0 output.right pin inhibit input.left pin reset_operacao input.left pin video_mode output.right pin zero_request0 output.right pinBus D output.right [2:0] pinBus capture_reg_0 output.right [0:0] pinBus page input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hud_vertical_adjust_0 work:hud_vertical_adjust_0:NOFILE HIERBOX pin VGA_R_OBUF[3]_inst_i_146 input.left pin VGA_R_OBUF[3]_inst_i_146_0 input.left pin VGA_R_OBUF[3]_inst_i_154 input.left pin VGA_R_OBUF[3]_inst_i_21 input.left pin VGA_R_OBUF[3]_inst_i_361 input.left pin VGA_R_OBUF[3]_inst_i_361_0 input.left pin VGA_R_OBUF[3]_inst_i_680_0 input.left pin align_mode input.left pin declutter_reg output.right pin down_debounce_reg[0]_0 input.left pin g_native_video.frame_boundary input.left pin hud_video_on output.right pin out input.left pin pixel_clk input.left pin reset_operacao input.left pin v_cont_reg[9]_0 output.right pin v_cont_reg[9]_1 output.right pin v_cont_reg[9]_2 output.right pin video_on input.left pin video_on0 output.right pinBus B output.right [10:0] pinBus CO output.right [0:0] pinBus DI output.right [0:0] pinBus O output.right [1:0] pinBus S input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_125_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_125_1 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_21_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_25 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_25_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_296_0 input.left [8:0] pinBus VGA_R_OBUF[3]_inst_i_297_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_299_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_680 input.left [4:0] pinBus align_command_buttons input.left [1:0] pinBus alvo_y_reg[0] output.right [0:0] pinBus alvo_y_reg[0]_0 output.right [0:0] pinBus alvo_y_reg[0]_1 output.right [0:0] pinBus alvo_y_reg[1] output.right [0:0] pinBus alvo_y_reg[1]_0 output.right [0:0] pinBus alvo_y_reg[2] output.right [1:0] pinBus alvo_y_reg[7] output.right [0:0] pinBus alvo_y_reg[7]_0 output.right [0:0] pinBus alvo_y_reg[8] output.right [0:0] pinBus alvo_y_reg[8]_0 output.right [0:0] pinBus hud_pixel_y output.right [5:0] pinBus offset_y output.right [8:0] pinBus pixel_y input.left [1:0] pinBus u input.left [3:0] pinBus u_0 input.left [0:0] pinBus u_1 input.left [0:0] pinBus v input.left [3:0] pinBus v_cont_reg[9] output.right [0:0] pinBus v_cont_reg[9]_3 output.right [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol hud_vertical_adjust work:hud_vertical_adjust:NOFILE HIERBOX pin VGA_G_OBUF[0]_inst_i_3 input.left pin VGA_R_OBUF[3]_inst_i_307_0 output.right pin VGA_R_OBUF[3]_inst_i_334 input.left pin VGA_R_OBUF[3]_inst_i_334_0 input.left pin align_enable input.left pin down_button input.left pin down_debounce_reg[0]_0 input.left pin g0_b0__2_i_18_0 input.left pin g0_b0__2_i_2 input.left pin g0_b0__2_i_24_0 input.left pin g0_b0__2_i_37_0 output.right pin g0_b0__2_i_55 input.left pin g0_b0__2_i_55_0 input.left pin g0_b0__2_i_7 input.left pin g_native_video.frame_boundary input.left pin h_cont_reg[7] output.right pin h_cont_reg[9] output.right pin h_cont_reg[9]_2 output.right pin h_cont_reg[9]_3 output.right pin mira_on output.right pin offset_y_reg[0]_0 output.right pin offset_y_reg[0]_1 output.right pin offset_y_reg[0]_2 output.right pin offset_y_reg[0]_3 output.right pin offset_y_reg[1]_0 output.right pin offset_y_reg[2]_0 output.right pin offset_y_reg[3]_0 output.right pin offset_y_reg[3]_1 output.right pin offset_y_reg[5]_0 output.right pin offset_y_reg[6]_0 output.right pin offset_y_reg[8]_0 output.right pin pixel_clk input.left pin reset_operacao input.left pin up_button input.left pin video_on0 input.left pinBus B output.right [5:0] pinBus CO input.left [0:0] pinBus DI output.right [1:0] pinBus O output.right [0:0] pinBus Q input.left [8:0] pinBus S input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_124_0 input.left [9:0] pinBus VGA_R_OBUF[3]_inst_i_21_0 input.left [0:0] pinBus VGA_R_OBUF[3]_inst_i_950_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_952_0 output.right [0:0] pinBus VGA_R_OBUF[3]_inst_i_966 input.left [3:0] pinBus alvo_x_reg[0] output.right [0:0] pinBus alvo_x_reg[1] output.right [0:0] pinBus alvo_x_reg[1]_0 output.right [0:0] pinBus alvo_x_reg[7] output.right [1:0] pinBus h_cont_reg[9]_0 output.right [0:0] pinBus h_cont_reg[9]_1 output.right [0:0] pinBus hud_pixel_x output.right [7:0] pinBus offset_y output.right [7:0] pinBus xc input.left [3:0] pinBus xc_0 input.left [0:0] pinBus xc_1 input.left [1:0] pinBus xc_2 input.left [0:0] pinBus xc_3 input.left [0:0] pinBus xc_4 input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst g_xadc_fast.u_joystick_cdc entrada_hud work:entrada_hud:NOFILE -attr @cell(#1c1f28) entrada_hud -pinBusAttr CO @name CO -pinBusAttr D @name D[11:0] -pinBusAttr DI @name DI -pinBusAttr JOY_LED_OBUF @name JOY_LED_OBUF -pinBusAttr JOY_LED_OBUF[1]_inst_i_1 @name JOY_LED_OBUF[1]_inst_i_1 -pinBusAttr JOY_LED_OBUF[1]_inst_i_3_0 @name JOY_LED_OBUF[1]_inst_i_3_0[11:0] -pinBusAttr JOY_LED_OBUF[1]_inst_i_3_1 @name JOY_LED_OBUF[1]_inst_i_3_1[3:0] -pinBusAttr JOY_LED_OBUF[1]_inst_i_7_0 @name JOY_LED_OBUF[1]_inst_i_7_0[3:0] -pinBusAttr JOY_LED_OBUF[3]_inst_i_10_0 @name JOY_LED_OBUF[3]_inst_i_10_0[1:0] -pinBusAttr JOY_LED_OBUF[3]_inst_i_10_1 @name JOY_LED_OBUF[3]_inst_i_10_1 -pinBusAttr JOY_LED_OBUF[3]_inst_i_3_0 @name JOY_LED_OBUF[3]_inst_i_3_0[10:0] -pinBusAttr Q @name Q[23:0] -pinBusAttr S @name S[1:0] -pinBusAttr _inferred__1/i__carry__1 @name _inferred__1/i__carry__1[11:0] -pinBusAttr _inferred__8/i__carry__1 @name _inferred__8/i__carry__1[11:0] -pinBusAttr centro_x_reg[11] @name centro_x_reg[11] -pinBusAttr dados_destino_reg[10]_0 @name dados_destino_reg[10]_0[3:0] -pinBusAttr dados_destino_reg[10]_1 @name dados_destino_reg[10]_1[1:0] -pinBusAttr dados_destino_reg[10]_2 @name dados_destino_reg[10]_2[1:0] -pinBusAttr dados_destino_reg[10]_3 @name dados_destino_reg[10]_3[2:0] -pinBusAttr dados_destino_reg[11]_0 @name dados_destino_reg[11]_0[3:0] -pinBusAttr dados_destino_reg[15]_0 @name dados_destino_reg[15]_0[3:0] -pinBusAttr dados_destino_reg[18]_0 @name dados_destino_reg[18]_0[3:0] -pinBusAttr dados_destino_reg[19]_0 @name dados_destino_reg[19]_0[3:0] -pinBusAttr dados_destino_reg[1]_0 @name dados_destino_reg[1]_0[1:0] -pinBusAttr dados_destino_reg[22]_0 @name dados_destino_reg[22]_0[1:0] -pinBusAttr dados_destino_reg[23]_0 @name dados_destino_reg[23]_0[3:0] -pinBusAttr dados_destino_reg[3]_0 @name dados_destino_reg[3]_0[3:0] -pinBusAttr dados_destino_reg[3]_1 @name dados_destino_reg[3]_1[3:0] -pinBusAttr dados_destino_reg[5]_0 @name dados_destino_reg[5]_0[1:0] -pinBusAttr dados_destino_reg[6]_0 @name dados_destino_reg[6]_0[3:0] -pinBusAttr dados_destino_reg[6]_1 @name dados_destino_reg[6]_1[3:0] -pinBusAttr dados_destino_reg[7]_0 @name dados_destino_reg[7]_0[1:0] -pinBusAttr dados_destino_reg[7]_1 @name dados_destino_reg[7]_1[3:0] -pinBusAttr dados_destino_reg[7]_2 @name dados_destino_reg[7]_2[3:0] -pinBusAttr dir_x_q_reg_0 @name dir_x_q_reg_0 -pinBusAttr retido_reg[23]_0 @name retido_reg[23]_0[23:0] -pinBusAttr step_x_q3 @name step_x_q3[4:0] -pinBusAttr step_x_q_reg[2]_i_2_0 @name step_x_q_reg[2]_i_2_0[11:0] -pinBusAttr step_y_q_reg[2]_i_2_0 @name step_y_q_reg[2]_i_2_0[11:0] -pg 1 -lvl 3 -x 2110 -y 100
load inst u_mira mira_joystick work:mira_joystick:NOFILE -attr @cell(#1c1f28) mira_joystick -pinBusAttr D @name D -pinBusAttr Q @name Q[11:0] -pinBusAttr center_x_reg[11]_0 @name center_x_reg[11]_0[11:0] -pinBusAttr center_y_reg[11]_0 @name center_y_reg[11]_0[11:0] -pinBusAttr dados_destino_reg[10] @name dados_destino_reg[10] -pinBusAttr dados_destino_reg[10]_0 @name dados_destino_reg[10]_0[4:0] -pinBusAttr dir_x_q_reg_0 @name dir_x_q_reg_0[1:0] -pinBusAttr dir_x_q_reg_1 @name dir_x_q_reg_1[1:0] -pinBusAttr dir_y_q_reg_0 @name dir_y_q_reg_0[1:0] -pinBusAttr locked_reg_0 @name locked_reg_0[19:0] -pinBusAttr step_x_q5_carry__0_0 @name step_x_q5_carry__0_0[3:0] -pinBusAttr step_x_q5_carry__0_1 @name step_x_q5_carry__0_1[3:0] -pinBusAttr step_x_q[2]_i_2_0 @name step_x_q[2]_i_2_0[3:0] -pinBusAttr step_x_q[2]_i_2_1 @name step_x_q[2]_i_2_1[3:0] -pinBusAttr step_x_q_reg[2]_1 @name step_x_q_reg[2]_1[3:0] -pinBusAttr step_x_q_reg[2]_2 @name step_x_q_reg[2]_2[3:0] -pinBusAttr step_x_q_reg[2]_3 @name step_x_q_reg[2]_3[2:0] -pinBusAttr step_x_q_reg[2]_4 @name step_x_q_reg[2]_4[3:0] -pinBusAttr step_y_q5_carry__0_0 @name step_y_q5_carry__0_0[3:0] -pinBusAttr step_y_q5_carry__0_1 @name step_y_q5_carry__0_1[23:0] -pinBusAttr step_y_q[2]_i_2_0 @name step_y_q[2]_i_2_0[3:0] -pinBusAttr step_y_q_reg[2]_0 @name step_y_q_reg[2]_0[3:0] -pinBusAttr step_y_q_reg[2]_1 @name step_y_q_reg[2]_1[3:0] -pg 1 -lvl 2 -x 1370 -y 60
load inst u_marcador_joystick mira_joystick__parameterized0 work:mira_joystick__parameterized0:NOFILE -attr @cell(#1c1f28) mira_joystick__parameterized0 -pinBusAttr D @name D -pinBusAttr Q @name Q[11:0] -pinBusAttr center_x_reg[11]_0 @name center_x_reg[11]_0[11:0] -pinBusAttr center_y_reg[11]_0 @name center_y_reg[11]_0[11:0] -pinBusAttr center_y_reg[11]_1 @name center_y_reg[11]_1[11:0] -pinBusAttr y_reg[8]_0 @name y_reg[8]_0[18:0] -pg 1 -lvl 1 -x 350 -y 780
load inst u_entrada entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE -attr @cell(#1c1f28) entrada_hud__parameterized2 -pinBusAttr D @name D[1:0] -pinBusAttr Q @name Q[71:0] -pinBusAttr SR @name SR -pinBusAttr dados_destino_reg[17]_1 @name dados_destino_reg[17]_1[1:0] -pinBusAttr dados_destino_reg[80]_0 @name dados_destino_reg[80]_0 -pinBusAttr retido_reg[121]_0 @name retido_reg[121]_0[90:0] -pinBusAttr valido_destino_reg_0 @name valido_destino_reg_0 -pg 1 -lvl 3 -x 2110 -y 5280
load inst u_dados dados_hud work:dados_hud:NOFILE -attr @cell(#1c1f28) dados_hud -pinBusAttr A @name A[11:0] -pinBusAttr CO @name CO -pinBusAttr D @name D[1:0] -pinBusAttr DI @name DI[1:0] -pinBusAttr O @name O[2:0] -pinBusAttr Q @name Q[71:0] -pinBusAttr S @name S[2:0] -pinBusAttr SR @name SR -pinBusAttr VGA_G_OBUF[3]_inst_i_100 @name VGA_G_OBUF[3]_inst_i_100 -pinBusAttr VGA_G_OBUF[3]_inst_i_101 @name VGA_G_OBUF[3]_inst_i_101 -pinBusAttr VGA_G_OBUF[3]_inst_i_102 @name VGA_G_OBUF[3]_inst_i_102 -pinBusAttr VGA_G_OBUF[3]_inst_i_98 @name VGA_G_OBUF[3]_inst_i_98 -pinBusAttr VGA_R_OBUF[3]_inst_i_1072 @name VGA_R_OBUF[3]_inst_i_1072[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1072_0 @name VGA_R_OBUF[3]_inst_i_1072_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_1093 @name VGA_R_OBUF[3]_inst_i_1093[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1105 @name VGA_R_OBUF[3]_inst_i_1105[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1109 @name VGA_R_OBUF[3]_inst_i_1109[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1118 @name VGA_R_OBUF[3]_inst_i_1118 -pinBusAttr VGA_R_OBUF[3]_inst_i_1122 @name VGA_R_OBUF[3]_inst_i_1122[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_0 @name VGA_R_OBUF[3]_inst_i_1174_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_1 @name VGA_R_OBUF[3]_inst_i_1174_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_2 @name VGA_R_OBUF[3]_inst_i_1174_2[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1174_3 @name VGA_R_OBUF[3]_inst_i_1174_3[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1182_0 @name VGA_R_OBUF[3]_inst_i_1182_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1182_1 @name VGA_R_OBUF[3]_inst_i_1182_1[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_139_0 @name VGA_R_OBUF[3]_inst_i_139_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_140_0 @name VGA_R_OBUF[3]_inst_i_140_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_145_0 @name VGA_R_OBUF[3]_inst_i_145_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_146_0 @name VGA_R_OBUF[3]_inst_i_146_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_148_0 @name VGA_R_OBUF[3]_inst_i_148_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_150_0 @name VGA_R_OBUF[3]_inst_i_150_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_1561 @name VGA_R_OBUF[3]_inst_i_1561[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1567_0 @name VGA_R_OBUF[3]_inst_i_1567_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1578 @name VGA_R_OBUF[3]_inst_i_1578 -pinBusAttr VGA_R_OBUF[3]_inst_i_1670_0 @name VGA_R_OBUF[3]_inst_i_1670_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1670_1 @name VGA_R_OBUF[3]_inst_i_1670_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_1679_0 @name VGA_R_OBUF[3]_inst_i_1679_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2150 @name VGA_R_OBUF[3]_inst_i_2150 -pinBusAttr VGA_R_OBUF[3]_inst_i_2218_0 @name VGA_R_OBUF[3]_inst_i_2218_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2228_0 @name VGA_R_OBUF[3]_inst_i_2228_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2238_0 @name VGA_R_OBUF[3]_inst_i_2238_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2248_0 @name VGA_R_OBUF[3]_inst_i_2248_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_0 @name VGA_R_OBUF[3]_inst_i_2869_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_1 @name VGA_R_OBUF[3]_inst_i_2869_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_2 @name VGA_R_OBUF[3]_inst_i_2869_2 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_3 @name VGA_R_OBUF[3]_inst_i_2869_3 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_4 @name VGA_R_OBUF[3]_inst_i_2869_4 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_5 @name VGA_R_OBUF[3]_inst_i_2869_5[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_6 @name VGA_R_OBUF[3]_inst_i_2869_6 -pinBusAttr VGA_R_OBUF[3]_inst_i_2869_7 @name VGA_R_OBUF[3]_inst_i_2869_7[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_2961_0 @name VGA_R_OBUF[3]_inst_i_2961_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_30 @name VGA_R_OBUF[3]_inst_i_30 -pinBusAttr VGA_R_OBUF[3]_inst_i_31 @name VGA_R_OBUF[3]_inst_i_31 -pinBusAttr VGA_R_OBUF[3]_inst_i_32 @name VGA_R_OBUF[3]_inst_i_32 -pinBusAttr VGA_R_OBUF[3]_inst_i_32_0 @name VGA_R_OBUF[3]_inst_i_32_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_33 @name VGA_R_OBUF[3]_inst_i_33[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3420_0 @name VGA_R_OBUF[3]_inst_i_3420_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3420_1 @name VGA_R_OBUF[3]_inst_i_3420_1[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3431_0 @name VGA_R_OBUF[3]_inst_i_3431_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3431_1 @name VGA_R_OBUF[3]_inst_i_3431_1[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_0 @name VGA_R_OBUF[3]_inst_i_3436_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_1 @name VGA_R_OBUF[3]_inst_i_3436_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_2 @name VGA_R_OBUF[3]_inst_i_3436_2[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3436_3 @name VGA_R_OBUF[3]_inst_i_3436_3 -pinBusAttr VGA_R_OBUF[3]_inst_i_3440_0 @name VGA_R_OBUF[3]_inst_i_3440_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3466_0 @name VGA_R_OBUF[3]_inst_i_3466_0[7:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3480_0 @name VGA_R_OBUF[3]_inst_i_3480_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3507_0 @name VGA_R_OBUF[3]_inst_i_3507_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3533_0 @name VGA_R_OBUF[3]_inst_i_3533_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_353_0 @name VGA_R_OBUF[3]_inst_i_353_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_353_1 @name VGA_R_OBUF[3]_inst_i_353_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_3560_0 @name VGA_R_OBUF[3]_inst_i_3560_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_3611_0 @name VGA_R_OBUF[3]_inst_i_3611_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_393 @name VGA_R_OBUF[3]_inst_i_393[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_394 @name VGA_R_OBUF[3]_inst_i_394[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_394_1 @name VGA_R_OBUF[3]_inst_i_394_1[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_395_0 @name VGA_R_OBUF[3]_inst_i_395_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_3980_0 @name VGA_R_OBUF[3]_inst_i_3980_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4003_0 @name VGA_R_OBUF[3]_inst_i_4003_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4029_0 @name VGA_R_OBUF[3]_inst_i_4029_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4060_0 @name VGA_R_OBUF[3]_inst_i_4060_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4091_0 @name VGA_R_OBUF[3]_inst_i_4091_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4122_0 @name VGA_R_OBUF[3]_inst_i_4122_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4155_0 @name VGA_R_OBUF[3]_inst_i_4155_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4166_0 @name VGA_R_OBUF[3]_inst_i_4166_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4175_0 @name VGA_R_OBUF[3]_inst_i_4175_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_4633_0 @name VGA_R_OBUF[3]_inst_i_4633_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4648_0 @name VGA_R_OBUF[3]_inst_i_4648_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4664_0 @name VGA_R_OBUF[3]_inst_i_4664_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_4691_0 @name VGA_R_OBUF[3]_inst_i_4691_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_55 @name VGA_R_OBUF[3]_inst_i_55 -pinBusAttr VGA_R_OBUF[3]_inst_i_60_0 @name VGA_R_OBUF[3]_inst_i_60_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_674_0 @name VGA_R_OBUF[3]_inst_i_674_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_674_1 @name VGA_R_OBUF[3]_inst_i_674_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_680_0 @name VGA_R_OBUF[3]_inst_i_680_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_705_0 @name VGA_R_OBUF[3]_inst_i_705_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_722_0 @name VGA_R_OBUF[3]_inst_i_722_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_73_0 @name VGA_R_OBUF[3]_inst_i_73_0[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_76 @name VGA_R_OBUF[3]_inst_i_76[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_766 @name VGA_R_OBUF[3]_inst_i_766[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_767_0 @name VGA_R_OBUF[3]_inst_i_767_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_77 @name VGA_R_OBUF[3]_inst_i_77[2:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_771_0 @name VGA_R_OBUF[3]_inst_i_771_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_776_0 @name VGA_R_OBUF[3]_inst_i_776_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_786 @name VGA_R_OBUF[3]_inst_i_786[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_822_0 @name VGA_R_OBUF[3]_inst_i_822_0[3:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_822_1 @name VGA_R_OBUF[3]_inst_i_822_1[4:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_839_0 @name VGA_R_OBUF[3]_inst_i_839_0[1:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_840_0 @name VGA_R_OBUF[3]_inst_i_840_0[2:0] -pinBusAttr altitude_ft_reg[16]_0 @name altitude_ft_reg[16]_0[16:0] -pinBusAttr altitude_ft_reg[4]_1 @name altitude_ft_reg[4]_1 -pinBusAttr altitude_ft_reg[6]_1 @name altitude_ft_reg[6]_1[2:0] -pinBusAttr altitude_pendente_reg[16]_0 @name altitude_pendente_reg[16]_0 -pinBusAttr alvo_x_reg[3]_0 @name alvo_x_reg[3]_0[3:0] -pinBusAttr alvo_y_pendente_reg[4]_0 @name alvo_y_pendente_reg[4]_0[1:0] -pinBusAttr alvo_y_reg[8]_0 @name alvo_y_reg[8]_0[4:0] -pinBusAttr h_cont_reg[5]_rep @name h_cont_reg[5]_rep[2:0] -pinBusAttr h_cont_reg[5]_rep_0 @name h_cont_reg[5]_rep_0[2:0] -pinBusAttr h_cont_reg[5]_rep_1 @name h_cont_reg[5]_rep_1[2:0] -pinBusAttr h_cont_reg[9] @name h_cont_reg[9][3:0] -pinBusAttr h_cont_reg[9]_0 @name h_cont_reg[9]_0[3:0] -pinBusAttr h_cont_reg[9]_1 @name h_cont_reg[9]_1[3:0] -pinBusAttr h_cont_reg[9]_2 @name h_cont_reg[9]_2[3:0] -pinBusAttr heading_deg_reg[0]_0 @name heading_deg_reg[0]_0[6:0] -pinBusAttr heading_deg_reg[0]_1 @name heading_deg_reg[0]_1[2:0] -pinBusAttr heading_deg_reg[0]_10 @name heading_deg_reg[0]_10[3:0] -pinBusAttr heading_deg_reg[0]_11 @name heading_deg_reg[0]_11[2:0] -pinBusAttr heading_deg_reg[0]_12 @name heading_deg_reg[0]_12[3:0] -pinBusAttr heading_deg_reg[0]_13 @name heading_deg_reg[0]_13[2:0] -pinBusAttr heading_deg_reg[0]_14 @name heading_deg_reg[0]_14[3:0] -pinBusAttr heading_deg_reg[0]_2 @name heading_deg_reg[0]_2[2:0] -pinBusAttr heading_deg_reg[0]_3 @name heading_deg_reg[0]_3[3:0] -pinBusAttr heading_deg_reg[0]_4 @name heading_deg_reg[0]_4[3:0] -pinBusAttr heading_deg_reg[0]_5 @name heading_deg_reg[0]_5 -pinBusAttr heading_deg_reg[0]_6 @name heading_deg_reg[0]_6[3:0] -pinBusAttr heading_deg_reg[0]_7 @name heading_deg_reg[0]_7[2:0] -pinBusAttr heading_deg_reg[0]_8 @name heading_deg_reg[0]_8[3:0] -pinBusAttr heading_deg_reg[0]_9 @name heading_deg_reg[0]_9[2:0] -pinBusAttr heading_deg_reg[7]_0 @name heading_deg_reg[7]_0[3:0] -pinBusAttr heading_deg_reg[7]_1 @name heading_deg_reg[7]_1[1:0] -pinBusAttr heading_deg_reg[7]_4 @name heading_deg_reg[7]_4 -pinBusAttr heading_deg_reg[7]_rep_0 @name heading_deg_reg[7]_rep_0 -pinBusAttr heading_deg_reg[7]_rep_1 @name heading_deg_reg[7]_rep_1 -pinBusAttr heading_deg_reg[8]_0 @name heading_deg_reg[8]_0 -pinBusAttr heading_deg_reg[8]_1 @name heading_deg_reg[8]_1 -pinBusAttr heading_deg_reg[8]_rep_5 @name heading_deg_reg[8]_rep_5 -pinBusAttr heading_pendente_reg[8]_0 @name heading_pendente_reg[8]_0 -pinBusAttr hud_pixel_x @name hud_pixel_x[7:0] -pinBusAttr hud_pixel_y @name hud_pixel_y[9:0] -pinBusAttr metadados_reg[15]_0 @name metadados_reg[15]_0[11:0] -pinBusAttr mira_x_reg[9]_0 @name mira_x_reg[9]_0[9:0] -pinBusAttr mira_y_reg[8]_0 @name mira_y_reg[8]_0[8:0] -pinBusAttr velocidade_kt_reg[1]_0 @name velocidade_kt_reg[1]_0[1:0] -pg 1 -lvl 4 -x 3450 -y 2060
load inst u_hud_commands hud_command_dispatch work:hud_command_dispatch:NOFILE -attr @cell(#1c1f28) hud_command_dispatch -pinBusAttr SD_DIAG_PAGE_IBUF @name SD_DIAG_PAGE_IBUF -pinBusAttr align_command_buttons @name align_command_buttons[1:0] -pinBusAttr btn @name btn[1:0] -pinBusAttr capture_grid_pulse_reg_0 @name capture_grid_pulse_reg_0 -pinBusAttr in0 @name in0[1:0] -pinBusAttr page @name page -pg 1 -lvl 2 -x 1370 -y 1180
load inst u_capture_control captura_controle work:captura_controle:NOFILE -attr @cell(#1c1f28) captura_controle -pinBusAttr D @name D[2:0] -pinBusAttr capture_reg_0 @name capture_reg_0 -pinBusAttr page @name page[3:0] -pg 1 -lvl 1 -x 350 -y 1080
load inst u_hud_vertical_adjust hud_vertical_adjust_0 work:hud_vertical_adjust_0:NOFILE -attr @cell(#1c1f28) hud_vertical_adjust_0 -pinBusAttr B @name B[10:0] -pinBusAttr CO @name CO -pinBusAttr DI @name DI -pinBusAttr O @name O[1:0] -pinBusAttr S @name S -pinBusAttr VGA_R_OBUF[3]_inst_i_125_0 @name VGA_R_OBUF[3]_inst_i_125_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_125_1 @name VGA_R_OBUF[3]_inst_i_125_1 -pinBusAttr VGA_R_OBUF[3]_inst_i_21_0 @name VGA_R_OBUF[3]_inst_i_21_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_25 @name VGA_R_OBUF[3]_inst_i_25 -pinBusAttr VGA_R_OBUF[3]_inst_i_25_0 @name VGA_R_OBUF[3]_inst_i_25_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_296_0 @name VGA_R_OBUF[3]_inst_i_296_0[8:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_297_0 @name VGA_R_OBUF[3]_inst_i_297_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_299_0 @name VGA_R_OBUF[3]_inst_i_299_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_680 @name VGA_R_OBUF[3]_inst_i_680[4:0] -pinBusAttr align_command_buttons @name align_command_buttons[1:0] -pinBusAttr alvo_y_reg[0] @name alvo_y_reg[0] -pinBusAttr alvo_y_reg[0]_0 @name alvo_y_reg[0]_0 -pinBusAttr alvo_y_reg[0]_1 @name alvo_y_reg[0]_1 -pinBusAttr alvo_y_reg[1] @name alvo_y_reg[1] -pinBusAttr alvo_y_reg[1]_0 @name alvo_y_reg[1]_0 -pinBusAttr alvo_y_reg[2] @name alvo_y_reg[2][1:0] -pinBusAttr alvo_y_reg[7] @name alvo_y_reg[7] -pinBusAttr alvo_y_reg[7]_0 @name alvo_y_reg[7]_0 -pinBusAttr alvo_y_reg[8] @name alvo_y_reg[8] -pinBusAttr alvo_y_reg[8]_0 @name alvo_y_reg[8]_0 -pinBusAttr hud_pixel_y @name hud_pixel_y[5:0] -pinBusAttr offset_y @name offset_y[8:0] -pinBusAttr pixel_y @name pixel_y[1:0] -pinBusAttr u @name u[3:0] -pinBusAttr u_0 @name u_0 -pinBusAttr u_1 @name u_1 -pinBusAttr v @name v[3:0] -pinBusAttr v_cont_reg[9] @name v_cont_reg[9] -pinBusAttr v_cont_reg[9]_3 @name v_cont_reg[9]_3[1:0] -pg 1 -lvl 6 -x 5910 -y 1140
load inst u_hud_horizontal_adjust hud_vertical_adjust work:hud_vertical_adjust:NOFILE -attr @cell(#1c1f28) hud_vertical_adjust -pinBusAttr B @name B[5:0] -pinBusAttr CO @name CO -pinBusAttr DI @name DI[1:0] -pinBusAttr O @name O -pinBusAttr Q @name Q[8:0] -pinBusAttr S @name S -pinBusAttr VGA_R_OBUF[3]_inst_i_124_0 @name VGA_R_OBUF[3]_inst_i_124_0[9:0] -pinBusAttr VGA_R_OBUF[3]_inst_i_21_0 @name VGA_R_OBUF[3]_inst_i_21_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_950_0 @name VGA_R_OBUF[3]_inst_i_950_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_952_0 @name VGA_R_OBUF[3]_inst_i_952_0 -pinBusAttr VGA_R_OBUF[3]_inst_i_966 @name VGA_R_OBUF[3]_inst_i_966[3:0] -pinBusAttr alvo_x_reg[0] @name alvo_x_reg[0] -pinBusAttr alvo_x_reg[1] @name alvo_x_reg[1] -pinBusAttr alvo_x_reg[1]_0 @name alvo_x_reg[1]_0 -pinBusAttr alvo_x_reg[7] @name alvo_x_reg[7][1:0] -pinBusAttr h_cont_reg[9]_0 @name h_cont_reg[9]_0 -pinBusAttr h_cont_reg[9]_1 @name h_cont_reg[9]_1 -pinBusAttr hud_pixel_x @name hud_pixel_x[7:0] -pinBusAttr offset_y @name offset_y[7:0] -pinBusAttr xc @name xc[3:0] -pinBusAttr xc_0 @name xc_0 -pinBusAttr xc_1 @name xc_1[1:0] -pinBusAttr xc_2 @name xc_2 -pinBusAttr xc_3 @name xc_3 -pinBusAttr xc_4 @name xc_4[3:0] -pg 1 -lvl 5 -x 5060 -y 440
load net g_xadc_fast.u_joystick_cdc_n_43 -attr @rip dados_destino_reg[6]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_0[2] -pin u_mira step_x_q5_carry__0_1[2]
load net g_xadc_fast.u_joystick_cdc_n_58 -attr @rip dados_destino_reg[7]_1[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_1[3] -pin u_mira step_x_q_reg[2]_2[3]
load net g_xadc_fast.u_joystick_cdc_n_13 -attr @rip Q[13] -pin g_xadc_fast.u_joystick_cdc Q[13] -pin u_mira step_y_q5_carry__0_1[13]
load net clk_hud -attr @style dashed -pin g_xadc_fast.u_joystick_cdc clk_hud -pin u_capture_control clk_hud -pin u_entrada clk_hud -pin u_hud_commands clk_hud -pin u_marcador_joystick clk_hud -pin u_mira clk_hud
netloc clk_hud 1 0 3 160 1290 740 1430 1800
load net g_xadc_fast.u_joystick_cdc_n_8 -attr @rip Q[18] -pin g_xadc_fast.u_joystick_cdc Q[18] -pin u_mira step_y_q5_carry__0_1[18]
load net g_xadc_fast.u_joystick_cdc_n_98 -attr @rip dados_destino_reg[3]_1[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_1[2] -pin u_mira step_x_q[2]_i_2_0[2]
load net u_dados_n_145 -pin u_dados alvo_y_reg[8]_1 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_146_0
netloc u_dados_n_145 1 4 2 4600 1330 5690J
load net u_entrada_n_12 -pin u_dados alvo_y_pendente_reg[7]_0 -pin u_entrada dados_destino_reg[17]_0
netloc u_entrada_n_12 1 3 1 2440 5610n
load net alvo_y_origem[8] -attr @rip y_reg[8]_0[18] -pin u_entrada retido_reg[121]_0[18] -pin u_marcador_joystick y_reg[8]_0[18]
load net alvo_x_origem[8] -attr @rip y_reg[8]_0[8] -pin u_entrada retido_reg[121]_0[8] -pin u_marcador_joystick y_reg[8]_0[8]
load net amostra_completa[75] -attr @rip Q[35] -pin u_dados Q[35] -pin u_entrada Q[35]
load net amostra_completa[91] -attr @rip Q[51] -pin u_dados Q[51] -pin u_entrada Q[51]
load net align_command_buttons[1] -attr @rip align_command_buttons[1] -pin u_hud_commands align_command_buttons[1] -pin u_hud_vertical_adjust align_command_buttons[1]
load net center_x[8] -attr @rip center_x_reg[11]_0[8] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[8] -pin u_mira center_x_reg[11]_0[8]
load net center_y[1] -attr @rip Q[1] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[1] -pin u_mira Q[1]
load net joystick_vertical_raw[0] -attr @style dashed -attr @rip D[0] -pin g_xadc_fast.u_joystick_cdc D[0] -pin u_marcador_joystick center_y_reg[11]_1[0] -pin u_mira center_y_reg[11]_0[0]
load net center_y_5[5] -attr @rip center_y_reg[11]_0[5] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[5] -pin u_marcador_joystick center_y_reg[11]_0[5]
load net hud_pixel_x[4] -attr @style dashed -attr @rip hud_pixel_x[4] -pin u_dados hud_pixel_x[4] -pin u_hud_horizontal_adjust hud_pixel_x[4]
load net mira_x_in[7] -attr @rip Q[7] -pin u_dados Q[7] -pin u_entrada Q[7]
load net mira_y_origem[2] -attr @rip locked_reg_0[12] -pin u_entrada retido_reg[121]_0[31] -pin u_mira locked_reg_0[12]
load net metadados_in[3] -attr @rip Q[59] -pin u_dados Q[59] -pin u_entrada Q[59]
load net mira_x[2] -attr @rip mira_x_reg[9]_0[2] -pin u_dados mira_x_reg[9]_0[2] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[2]
load net mira_y[4] -attr @rip mira_y_reg[8]_0[4] -pin u_dados mira_y_reg[8]_0[4] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[4]
load net g_xadc_fast.u_joystick_cdc_n_44 -attr @rip dados_destino_reg[6]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_0[1] -pin u_mira step_x_q5_carry__0_1[1]
load net g_xadc_fast.u_joystick_cdc_n_3 -attr @rip Q[23] -pin g_xadc_fast.u_joystick_cdc Q[23] -pin u_mira step_y_q5_carry__0_1[23]
load net g_xadc_fast.u_joystick_cdc_n_59 -attr @rip dados_destino_reg[7]_1[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_1[2] -pin u_mira step_x_q_reg[2]_2[2]
load net g_xadc_fast.u_joystick_cdc_n_14 -attr @rip Q[12] -pin g_xadc_fast.u_joystick_cdc Q[12] -pin u_mira step_y_q5_carry__0_1[12]
load net g_xadc_fast.u_joystick_cdc_n_99 -attr @rip dados_destino_reg[3]_1[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_1[1] -pin u_mira step_x_q[2]_i_2_0[1]
load net u_dados_n_147 -pin u_dados alvo_y_reg[7]_2 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680_0
netloc u_dados_n_147 1 4 2 4680 1430 NJ
load net u_entrada_n_13 -pin u_dados alvo_y_pendente_reg[6]_0 -pin u_entrada dados_destino_reg[16]_0
netloc u_entrada_n_13 1 3 1 2460 5590n
load net u_flight_coords/within_bounds_x0 -attr @style dashed -attr @rip h_cont_reg[9]_0[0] -pin u_hud_horizontal_adjust h_cont_reg[9]_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_25_0[0]
netloc u_flight_coords/within_bounds_x0 1 5 1 5630 710n
load net g_xadc_fast.u_joystick_cdc_n_84 -attr @rip dados_destino_reg[23]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[23]_0[3] -pin u_mira step_y_q_reg[2]_1[3]
load net amostra_completa[40] -attr @rip Q[21] -pin u_dados Q[21] -pin u_entrada Q[21]
load net amostra_completa[76] -attr @rip Q[36] -pin u_dados Q[36] -pin u_entrada Q[36]
load net amostra_completa[92] -attr @rip Q[52] -pin u_dados Q[52] -pin u_entrada Q[52]
load net alvo_y[0] -attr @rip alvo_y_reg[8]_0[0] -pin u_dados alvo_y_reg[8]_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680[0]
load net u_mira_caca/on43_in -attr @rip VGA_R_OBUF[3]_inst_i_950_0[0] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_950_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_125_0[0]
netloc u_mira_caca/on43_in 1 5 1 5650 530n
load net center_x[10] -attr @rip center_x_reg[11]_0[10] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[10] -pin u_mira center_x_reg[11]_0[10]
load net center_y[2] -attr @rip Q[2] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[2] -pin u_mira Q[2]
load net joystick_vertical_raw[1] -attr @style dashed -attr @rip D[1] -pin g_xadc_fast.u_joystick_cdc D[1] -pin u_marcador_joystick center_y_reg[11]_1[1] -pin u_mira center_y_reg[11]_0[1]
load net center_y_5[6] -attr @rip center_y_reg[11]_0[6] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[6] -pin u_marcador_joystick center_y_reg[11]_0[6]
load net hud_pixel_x[6] -attr @style dashed -attr @rip hud_pixel_x[5] -pin u_dados hud_pixel_x[5] -pin u_hud_horizontal_adjust hud_pixel_x[5]
load net mira_y_origem[3] -attr @rip locked_reg_0[13] -pin u_entrada retido_reg[121]_0[32] -pin u_mira locked_reg_0[13]
load net metadados_in[4] -attr @rip Q[60] -pin u_dados Q[60] -pin u_entrada Q[60]
load net mira_x_in[8] -attr @rip Q[8] -pin u_dados Q[8] -pin u_entrada Q[8]
load net mira_x[3] -attr @rip mira_x_reg[9]_0[3] -pin u_dados mira_x_reg[9]_0[3] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[3]
load net mira_y[5] -attr @rip mira_y_reg[8]_0[5] -pin u_dados mira_y_reg[8]_0[5] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[5]
load net g_xadc_fast.u_joystick_cdc_n_70 -attr @rip dados_destino_reg[22]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[22]_0[1] -pin u_mira dir_y_q_reg_0[1]
load net g_xadc_fast.u_joystick_cdc_n_26 -attr @style dashed -attr @rip Q[0] -pin g_xadc_fast.u_joystick_cdc Q[0] -pin u_marcador_joystick center_x_reg[11]_0[0] -pin u_mira step_y_q5_carry__0_1[0]
load net g_xadc_fast.u_joystick_cdc_n_56 -attr @rip dados_destino_reg[11]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[11]_0[1] -pin u_mira step_x_q_reg[2]_4[1]
load net g_xadc_fast.u_joystick_cdc_n_11 -attr @style dashed -attr @rip Q[15] -pin g_xadc_fast.u_joystick_cdc Q[15] -pin u_mira step_y_q5_carry__0_1[15]
load net dir_x_q_7 -pin g_xadc_fast.u_joystick_cdc dir_x_q_0 -pin u_marcador_joystick dir_x_q
netloc dir_x_q_7 1 1 2 700 670 1720J
load net g_native_video.frame_boundary -attr @style dashed -pin u_dados g_native_video.frame_boundary -pin u_hud_horizontal_adjust g_native_video.frame_boundary -pin u_hud_vertical_adjust g_native_video.frame_boundary
netloc g_native_video.frame_boundary 1 3 3 2820 1090 4740 1510 NJ
load net g_xadc_fast.u_joystick_cdc_n_96 -pin g_xadc_fast.u_joystick_cdc step_x_q[2]_i_2 -pin u_mira step_x_q_reg[2]_0
netloc g_xadc_fast.u_joystick_cdc_n_96 1 1 3 860 1050 NJ 1050 2400
load net u_hud_vertical_adjust_n_26 -attr @rip alvo_y_reg[8]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_353_0[0] -pin u_hud_vertical_adjust alvo_y_reg[8]_0[0]
netloc u_hud_vertical_adjust_n_26 1 3 4 3140 1790 4480J 1810 5570J 1830 6250
load net u_hud_horizontal_adjust_n_48 -attr @style dashed -attr @rip h_cont_reg[9]_1[0] -pin u_hud_horizontal_adjust h_cont_reg[9]_1[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_25[0]
netloc u_hud_horizontal_adjust_n_48 1 5 1 5610 730n
load net u_entrada_n_93 -attr @rip dados_destino_reg[17]_1[1] -pin u_dados alvo_y_pendente_reg[4]_0[1] -pin u_entrada dados_destino_reg[17]_1[1]
load net u_entrada_n_10 -pin u_dados alvo_x_pendente_reg[0]_0 -pin u_entrada dados_destino_reg[4]_7
netloc u_entrada_n_10 1 3 1 2640 5390n
load net u_dados_n_143 -pin u_dados alvo_y_reg[6]_0 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_361_0
netloc u_dados_n_143 1 4 2 4580 1390 NJ
load net u_capture_control_n_5 -pin u_capture_control capture_reg_1 -pin u_hud_commands route_previous_reg[0]_0
netloc u_capture_control_n_5 1 1 1 660 1150n
load net alvo_x_origem[9] -attr @rip y_reg[8]_0[9] -pin u_entrada retido_reg[121]_0[9] -pin u_marcador_joystick y_reg[8]_0[9]
load net amostra_completa[39] -attr @rip Q[20] -pin u_dados Q[20] -pin u_entrada Q[20]
load net amostra_completa[73] -attr @rip Q[33] -pin u_dados Q[33] -pin u_entrada Q[33]
load net amostra_completa[89] -attr @rip Q[49] -pin u_dados Q[49] -pin u_entrada Q[49]
load net center_x[9] -attr @rip center_x_reg[11]_0[9] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[9] -pin u_mira center_x_reg[11]_0[9]
load net center_x_6[11] -attr @rip Q[11] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[11] -pin u_marcador_joystick Q[11]
load net center_y_5[3] -attr @rip center_y_reg[11]_0[3] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[3] -pin u_marcador_joystick center_y_reg[11]_0[3]
load net hud_pixel_x[2] -attr @style dashed -attr @rip hud_pixel_x[2] -pin u_dados hud_pixel_x[2] -pin u_hud_horizontal_adjust hud_pixel_x[2]
load net hud_pixel_y[7] -attr @style dashed -attr @rip hud_pixel_y[3] -pin u_dados hud_pixel_y[7] -pin u_hud_vertical_adjust hud_pixel_y[3]
load net mira_y_in[8] -attr @rip Q[18] -pin u_dados Q[18] -pin u_entrada Q[18]
load net metadados_in[1] -attr @rip Q[57] -pin u_dados Q[57] -pin u_entrada Q[57]
load net mira_x_in[6] -attr @rip Q[6] -pin u_dados Q[6] -pin u_entrada Q[6]
load net mira_x[0] -attr @rip mira_x_reg[9]_0[0] -pin u_dados mira_x_reg[9]_0[0] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[0]
load net mira_y[2] -attr @rip mira_y_reg[8]_0[2] -pin u_dados mira_y_reg[8]_0[2] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[2]
load net pacote_hud[38] -attr @rip locked_reg_0[19] -pin u_entrada retido_reg[121]_0[38] -pin u_mira locked_reg_0[19]
load net u_dados_n_144 -pin u_dados alvo_y_reg[7]_1 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_146
netloc u_dados_n_144 1 4 2 4540 1310 5650J
load net g_xadc_fast.u_joystick_cdc_n_57 -attr @rip dados_destino_reg[11]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[11]_0[0] -pin u_mira step_x_q_reg[2]_4[0]
load net g_xadc_fast.u_joystick_cdc_n_42 -attr @rip dados_destino_reg[6]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_0[3] -pin u_mira step_x_q5_carry__0_1[3]
load net g_xadc_fast.u_joystick_cdc_n_12 -attr @rip Q[14] -pin g_xadc_fast.u_joystick_cdc Q[14] -pin u_mira step_y_q5_carry__0_1[14]
load net dir_y_q -pin g_xadc_fast.u_joystick_cdc dir_y_q -pin u_marcador_joystick dir_y_q
netloc dir_y_q 1 1 2 820 690 1740J
load net u_entrada_n_94 -attr @rip dados_destino_reg[17]_1[0] -pin u_dados alvo_y_pendente_reg[4]_0[0] -pin u_entrada dados_destino_reg[17]_1[0]
load net u_hud_vertical_adjust_n_27 -attr @rip alvo_y_reg[7]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_60_0[0] -pin u_hud_vertical_adjust alvo_y_reg[7]_0[0]
netloc u_hud_vertical_adjust_n_27 1 3 4 3220 1750 4520J 1770 5610J 1790 6290
load net u_hud_horizontal_adjust_n_21 -attr @style dashed -attr @rip B[0] -pin u_dados VGA_R_OBUF[3]_inst_i_369_0 -pin u_hud_horizontal_adjust B[0]
netloc u_hud_horizontal_adjust_n_21 1 3 3 2960 1230 NJ 1230 5490
load net u_entrada_n_11 -pin u_dados alvo_y_pendente_reg[8]_0 -pin u_entrada dados_destino_reg[18]_0
netloc u_entrada_n_11 1 3 1 2420 5650n
load net g_xadc_fast.u_joystick_cdc_n_97 -attr @rip dados_destino_reg[3]_1[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_1[3] -pin u_mira step_x_q[2]_i_2_0[3]
load net g_xadc_fast.u_joystick_cdc_n_71 -attr @rip dados_destino_reg[22]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[22]_0[0] -pin u_mira dir_y_q_reg_0[0]
load net alvo_y_origem[7] -attr @rip y_reg[8]_0[17] -pin u_entrada retido_reg[121]_0[17] -pin u_marcador_joystick y_reg[8]_0[17]
load net alvo_x_origem[7] -attr @rip y_reg[8]_0[7] -pin u_entrada retido_reg[121]_0[7] -pin u_marcador_joystick y_reg[8]_0[7]
load net amostra_completa[74] -attr @rip Q[34] -pin u_dados Q[34] -pin u_entrada Q[34]
load net amostra_completa[90] -attr @rip Q[50] -pin u_dados Q[50] -pin u_entrada Q[50]
load net align_command_buttons[0] -attr @rip align_command_buttons[0] -pin u_hud_commands align_command_buttons[0] -pin u_hud_vertical_adjust align_command_buttons[0]
load net center_x[7] -attr @rip center_x_reg[11]_0[7] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[7] -pin u_mira center_x_reg[11]_0[7]
load net center_y[0] -attr @rip Q[0] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[0] -pin u_mira Q[0]
load net center_y_5[4] -attr @rip center_y_reg[11]_0[4] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[4] -pin u_marcador_joystick center_y_reg[11]_0[4]
load net heading_pendente[0] -attr @rip valido_destino_reg_0[0] -pin u_dados heading_pendente_reg[8]_0[0] -pin u_entrada valido_destino_reg_0[0]
netloc heading_pendente[0] 1 3 1 2400 5710n
load net hud_pixel_x[3] -attr @style dashed -attr @rip hud_pixel_x[3] -pin u_dados hud_pixel_x[3] -pin u_hud_horizontal_adjust hud_pixel_x[3]
load net hud_pixel_y[8] -attr @style dashed -attr @rip hud_pixel_y[4] -pin u_dados hud_pixel_y[8] -pin u_hud_vertical_adjust hud_pixel_y[4]
load net mira_x_in[9] -attr @rip Q[9] -pin u_dados Q[9] -pin u_entrada Q[9]
load net mira_y_origem[1] -attr @rip locked_reg_0[11] -pin u_entrada retido_reg[121]_0[30] -pin u_mira locked_reg_0[11]
load net metadados_in[2] -attr @rip Q[58] -pin u_dados Q[58] -pin u_entrada Q[58]
load net mira_x[1] -attr @rip mira_x_reg[9]_0[1] -pin u_dados mira_x_reg[9]_0[1] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[1]
load net mira_y[3] -attr @rip mira_y_reg[8]_0[3] -pin u_dados mira_y_reg[8]_0[3] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[3]
load net g_xadc_fast.u_joystick_cdc_n_87 -attr @rip dados_destino_reg[23]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[23]_0[0] -pin u_mira step_y_q_reg[2]_1[0]
load net g_xadc_fast.u_joystick_cdc_n_47 -attr @rip dados_destino_reg[6]_1[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_1[2] -pin u_mira step_x_q5_carry__0_0[2]
load net g_xadc_fast.u_joystick_cdc_n_32 -pin g_xadc_fast.u_joystick_cdc step_x_q[2]_i_4_0 -pin u_marcador_joystick step_x_q_reg[2]_0
netloc g_xadc_fast.u_joystick_cdc_n_32 1 0 4 40 1370 NJ 1370 NJ 1370 2640
load net g_xadc_fast.u_joystick_cdc_n_61 -attr @rip dados_destino_reg[7]_1[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_1[0] -pin u_mira step_x_q_reg[2]_2[0]
load net g_xadc_fast.u_joystick_cdc_n_17 -attr @style dashed -attr @rip Q[9] -pin g_xadc_fast.u_joystick_cdc Q[9] -pin u_marcador_joystick center_x_reg[11]_0[9] -pin u_mira step_y_q5_carry__0_1[9]
load net g_xadc_fast.u_joystick_cdc_n_10 -attr @rip Q[16] -pin g_xadc_fast.u_joystick_cdc Q[16] -pin u_mira step_y_q5_carry__0_1[16]
load net reset_operacao -attr @style dashed -pin u_capture_control reset_operacao -pin u_hud_commands reset_operacao -pin u_hud_horizontal_adjust reset_operacao -pin u_hud_vertical_adjust reset_operacao -pin u_marcador_joystick reset_operacao -pin u_mira reset_operacao
netloc reset_operacao 1 0 6 20 1330 760 1070 1720J 1110 NJ 1110 4360 1590 NJ
load net u_entrada_n_16 -pin u_dados alvo_y_pendente_reg[1]_0 -pin u_entrada dados_destino_reg[11]_0
netloc u_entrada_n_16 1 3 1 2500 5550n
load net u_hud_horizontal_adjust_n_10 -attr @rip alvo_x_reg[7][1] -pin u_dados VGA_R_OBUF[3]_inst_i_140_0[1] -pin u_hud_horizontal_adjust alvo_x_reg[7][1]
load net u_hud_vertical_adjust_n_32 -pin u_hud_horizontal_adjust VGA_G_OBUF[0]_inst_i_3 -pin u_hud_vertical_adjust declutter_reg
netloc u_hud_vertical_adjust_n_32 1 4 3 4820 1150 5530J 1050 6430
load net u_mira_n_27 -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2] -pin u_mira _inferred__1/i__carry__0_0
netloc u_mira_n_27 1 2 1 1840 270n
load net amostra_completa[43] -attr @rip Q[24] -pin u_dados Q[24] -pin u_entrada Q[24]
load net amostra_completa[79] -attr @rip Q[39] -pin u_dados Q[39] -pin u_entrada Q[39]
load net amostra_completa[95] -attr @rip Q[55] -pin u_dados Q[55] -pin u_entrada Q[55]
load net alvo_x[1] -attr @rip alvo_x_reg[3]_0[1] -pin u_dados alvo_x_reg[3]_0[1] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_966[1]
load net alvo_y[3] -attr @rip alvo_y_reg[8]_0[3] -pin u_dados alvo_y_reg[8]_0[3] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680[3]
load net center_y[5] -attr @rip Q[5] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[5] -pin u_mira Q[5]
load net center_x_6[1] -attr @rip Q[1] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[1] -pin u_marcador_joystick Q[1]
load net joystick_vertical_raw[4] -attr @style dashed -attr @rip D[4] -pin g_xadc_fast.u_joystick_cdc D[4] -pin u_marcador_joystick center_y_reg[11]_1[4] -pin u_mira center_y_reg[11]_0[4]
load net center_y_5[8] -attr @rip center_y_reg[11]_0[8] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[8] -pin u_marcador_joystick center_y_reg[11]_0[8]
load net hud_pixel_x[8] -attr @style dashed -attr @rip hud_pixel_x[6] -pin u_dados hud_pixel_x[6] -pin u_hud_horizontal_adjust hud_pixel_x[6]
load net hud_offset_y[1] -attr @style dashed -attr @rip offset_y[1] -pin u_hud_horizontal_adjust Q[1] -pin u_hud_vertical_adjust offset_y[1]
load net mira_y_origem[6] -attr @rip locked_reg_0[16] -pin u_entrada retido_reg[121]_0[35] -pin u_mira locked_reg_0[16]
load net mira_x_origem[2] -attr @rip locked_reg_0[2] -pin u_entrada retido_reg[121]_0[21] -pin u_mira locked_reg_0[2]
load net metadados_in[10] -attr @rip Q[65] -pin u_dados Q[65] -pin u_entrada Q[65]
load net mira_x[6] -attr @rip mira_x_reg[9]_0[6] -pin u_dados mira_x_reg[9]_0[6] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[6]
load net mira_y[7] -attr @rip mira_y_reg[8]_0[7] -pin u_dados mira_y_reg[8]_0[7] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[7]
load net pixel_x[9] -attr @style dashed -attr @rip Q[8] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[7] -pin u_hud_horizontal_adjust xc_1[1]
load net u_entrada_n_17 -pin u_dados alvo_y_pendente_reg[0]_0 -pin u_entrada dados_destino_reg[10]_0
netloc u_entrada_n_17 1 3 1 2540 5530n
load net g_xadc_fast.u_joystick_cdc_n_33 -pin g_xadc_fast.u_joystick_cdc step_y_q[2]_i_4_0 -pin u_marcador_joystick step_y_q_reg[2]_0
netloc g_xadc_fast.u_joystick_cdc_n_33 1 0 4 60 1390 NJ 1390 NJ 1390 2580
load net g_xadc_fast.u_joystick_cdc_n_48 -attr @rip dados_destino_reg[6]_1[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_1[1] -pin u_mira step_x_q5_carry__0_0[1]
load net g_xadc_fast.u_joystick_cdc_n_62 -attr @rip dados_destino_reg[3]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_0[3] -pin u_mira step_x_q[2]_i_2_1[3]
load net g_xadc_fast.u_joystick_cdc_n_18 -attr @style dashed -attr @rip Q[8] -pin g_xadc_fast.u_joystick_cdc Q[8] -pin u_marcador_joystick center_x_reg[11]_0[8] -pin u_mira step_y_q5_carry__0_1[8]
load net g_xadc_fast.u_joystick_cdc_n_100 -attr @rip dados_destino_reg[3]_1[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_1[0] -pin u_mira step_x_q[2]_i_2_0[0]
load net u_hud_vertical_adjust_n_35 -attr @rip VGA_R_OBUF[3]_inst_i_297_0[0] -pin u_hud_horizontal_adjust CO[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_297_0[0]
netloc u_hud_vertical_adjust_n_35 1 4 3 4800 1270 5550J 1070 6410
load net u_hud_vertical_adjust_n_12 -attr @rip alvo_y_reg[0]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_150_0[0] -pin u_hud_vertical_adjust alvo_y_reg[0]_0[0]
netloc u_hud_vertical_adjust_n_12 1 3 4 3040 1710 NJ 1710 5690J 1730 6390
load net u_hud_horizontal_adjust_n_11 -attr @rip alvo_x_reg[7][0] -pin u_dados VGA_R_OBUF[3]_inst_i_140_0[0] -pin u_hud_horizontal_adjust alvo_x_reg[7][0]
load net g_xadc_fast.u_joystick_cdc_n_88 -attr @rip dados_destino_reg[19]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[19]_0[3] -pin u_mira step_y_q_reg[2]_0[3]
load net amostra_completa[44] -attr @rip Q[25] -pin u_dados Q[25] -pin u_entrada Q[25]
load net amostra_completa[80] -attr @rip Q[40] -pin u_dados Q[40] -pin u_entrada Q[40]
load net alvo_x[2] -attr @rip alvo_x_reg[3]_0[2] -pin u_dados alvo_x_reg[3]_0[2] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_966[2]
load net alvo_y[8] -attr @rip alvo_y_reg[8]_0[4] -pin u_dados alvo_y_reg[8]_0[4] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680[4]
load net center_y[6] -attr @rip Q[6] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[6] -pin u_mira Q[6]
load net center_x_6[2] -attr @rip Q[2] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[2] -pin u_marcador_joystick Q[2]
load net joystick_vertical_raw[5] -attr @style dashed -attr @rip D[5] -pin g_xadc_fast.u_joystick_cdc D[5] -pin u_marcador_joystick center_y_reg[11]_1[5] -pin u_mira center_y_reg[11]_0[5]
load net center_y_5[10] -attr @rip center_y_reg[11]_0[10] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[10] -pin u_marcador_joystick center_y_reg[11]_0[10]
load net hud_offset_y[2] -attr @style dashed -attr @rip offset_y[2] -pin u_hud_horizontal_adjust Q[2] -pin u_hud_vertical_adjust offset_y[2]
load net mira_x_origem[3] -attr @rip locked_reg_0[3] -pin u_entrada retido_reg[121]_0[22] -pin u_mira locked_reg_0[3]
load net mira_x[9] -attr @rip mira_x_reg[9]_0[9] -pin u_dados mira_x_reg[9]_0[9] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[9]
load net mira_y[8] -attr @rip mira_y_reg[8]_0[8] -pin u_dados mira_y_reg[8]_0[8] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[8]
load net g_xadc_fast.u_joystick_cdc_n_85 -attr @rip dados_destino_reg[23]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[23]_0[2] -pin u_mira step_y_q_reg[2]_1[2]
load net g_xadc_fast.u_joystick_cdc_n_45 -attr @rip dados_destino_reg[6]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_0[0] -pin u_mira step_x_q5_carry__0_1[0]
load net g_xadc_fast.u_joystick_cdc_n_6 -attr @rip Q[20] -pin g_xadc_fast.u_joystick_cdc Q[20] -pin u_mira step_y_q5_carry__0_1[20]
load net g_xadc_fast.u_joystick_cdc_n_15 -attr @style dashed -attr @rip Q[11] -pin g_xadc_fast.u_joystick_cdc Q[11] -pin u_marcador_joystick center_x_reg[11]_0[11] -pin u_mira step_y_q5_carry__0_1[11]
load net g_xadc_fast.u_joystick_cdc_n_0 -pin g_xadc_fast.u_joystick_cdc inicio_operacao_reg[3] -pin u_marcador_joystick dir_x_q_reg_0
netloc g_xadc_fast.u_joystick_cdc_n_0 1 0 4 60 710 600J 1090 1780J 1130 2700
load net inicio_operacao_reg_n_0_[3] -attr @style dashed -pin g_xadc_fast.u_joystick_cdc dir_x_q_reg -pin u_capture_control filtered_reg_0 -pin u_hud_commands switch_count_reg[0]_0 -pin u_hud_horizontal_adjust down_debounce_reg[0]_0 -pin u_hud_vertical_adjust down_debounce_reg[0]_0 -pin u_marcador_joystick x_reg[8]_0 -pin u_mira debounce_count_reg[0]_0
netloc inicio_operacao_reg_n_0_[3] 1 0 6 100 1350 780 650 1880 1090 2760J 1070 4720 1490 NJ
load net step_x_q5 -attr @rip dados_destino_reg[10][0] -pin g_xadc_fast.u_joystick_cdc dir_x_q_reg_0[0] -pin u_mira dados_destino_reg[10][0]
netloc step_x_q5 1 2 1 1820 310n
load net u_entrada_n_14 -pin u_dados alvo_y_pendente_reg[5]_0 -pin u_entrada dados_destino_reg[18]_1
netloc u_entrada_n_14 1 3 1 2800 5630n
load net u_hud_horizontal_adjust_n_9 -attr @rip alvo_x_reg[0][0] -pin u_dados VGA_R_OBUF[3]_inst_i_148_0[0] -pin u_hud_horizontal_adjust alvo_x_reg[0][0]
netloc u_hud_horizontal_adjust_n_9 1 3 3 2920 1190 NJ 1190 5470
load net amostra_completa[41] -attr @rip Q[22] -pin u_dados Q[22] -pin u_entrada Q[22]
load net amostra_completa[77] -attr @rip Q[37] -pin u_dados Q[37] -pin u_entrada Q[37]
load net amostra_completa[93] -attr @rip Q[53] -pin u_dados Q[53] -pin u_entrada Q[53]
load net altitude_pendente[0] -attr @rip dados_destino_reg[80]_0[0] -pin u_dados altitude_pendente_reg[16]_0[0] -pin u_entrada dados_destino_reg[80]_0[0]
netloc altitude_pendente[0] 1 3 1 2740 5370n
load net alvo_y[1] -attr @rip alvo_y_reg[8]_0[1] -pin u_dados alvo_y_reg[8]_0[1] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680[1]
load net u_mira_caca/on5 -attr @rip VGA_R_OBUF[3]_inst_i_299_0[0] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_21_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_299_0[0]
netloc u_mira_caca/on5 1 4 3 4780 1290 5570J 1090 6210
load net video_on0 -pin u_hud_horizontal_adjust video_on0 -pin u_hud_vertical_adjust video_on0
netloc video_on0 1 4 3 4760 1750 5650J 1770 6190
load net center_x[11] -attr @rip center_x_reg[11]_0[11] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[11] -pin u_mira center_x_reg[11]_0[11]
load net center_y[3] -attr @rip Q[3] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[3] -pin u_mira Q[3]
load net joystick_vertical_raw[2] -attr @style dashed -attr @rip D[2] -pin g_xadc_fast.u_joystick_cdc D[2] -pin u_marcador_joystick center_y_reg[11]_1[2] -pin u_mira center_y_reg[11]_0[2]
load net center_y_5[9] -attr @rip center_y_reg[11]_0[9] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[9] -pin u_marcador_joystick center_y_reg[11]_0[9]
load net mira_x_origem[0] -attr @rip locked_reg_0[0] -pin u_entrada retido_reg[121]_0[19] -pin u_mira locked_reg_0[0]
load net mira_y_origem[4] -attr @rip locked_reg_0[14] -pin u_entrada retido_reg[121]_0[33] -pin u_mira locked_reg_0[14]
load net metadados_in[5] -attr @rip Q[61] -pin u_dados Q[61] -pin u_entrada Q[61]
load net mira_x[4] -attr @rip mira_x_reg[9]_0[4] -pin u_dados mira_x_reg[9]_0[4] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[4]
load net mira_y[6] -attr @rip mira_y_reg[8]_0[6] -pin u_dados mira_y_reg[8]_0[6] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[6]
load net g_xadc_fast.u_joystick_cdc_n_46 -attr @rip dados_destino_reg[6]_1[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_1[3] -pin u_mira step_x_q5_carry__0_0[3]
load net g_xadc_fast.u_joystick_cdc_n_60 -attr @rip dados_destino_reg[7]_1[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_1[1] -pin u_mira step_x_q_reg[2]_2[1]
load net g_xadc_fast.u_joystick_cdc_n_16 -attr @style dashed -attr @rip Q[10] -pin g_xadc_fast.u_joystick_cdc Q[10] -pin u_marcador_joystick center_x_reg[11]_0[10] -pin u_mira step_y_q5_carry__0_1[10]
load net g_xadc_fast.u_joystick_cdc_n_1 -pin g_xadc_fast.u_joystick_cdc inicio_operacao_reg[3]_0 -pin u_marcador_joystick dir_y_q_reg_0
netloc g_xadc_fast.u_joystick_cdc_n_1 1 0 4 120 730 800J 1110 1680J 1150 2680
load net pixel_clk_BUFG -attr @style dashed -pin u_dados pixel_clk -pin u_entrada pixel_clk -pin u_hud_horizontal_adjust pixel_clk -pin u_hud_vertical_adjust pixel_clk
netloc pixel_clk_BUFG 1 2 4 1880 5230 2560 1930 4240 1550 NJ
load net u_entrada_n_15 -pin u_dados alvo_y_pendente_reg[2]_0 -pin u_entrada dados_destino_reg[12]_0
netloc u_entrada_n_15 1 3 1 2480 5570n
load net u_hud_vertical_adjust_n_0 -attr @rip alvo_y_reg[0][0] -pin u_dados VGA_R_OBUF[3]_inst_i_722_0[0] -pin u_hud_vertical_adjust alvo_y_reg[0][0]
netloc u_hud_vertical_adjust_n_0 1 3 4 3160 1910 4260J 1930 NJ 1930 6410
load net u_hud_horizontal_adjust_n_0 -attr @rip alvo_x_reg[1][0] -pin u_dados VGA_R_OBUF[3]_inst_i_139_0[0] -pin u_hud_horizontal_adjust alvo_x_reg[1][0]
netloc u_hud_horizontal_adjust_n_0 1 3 3 2900 1170 NJ 1170 5430
load net g_xadc_fast.u_joystick_cdc_n_86 -attr @rip dados_destino_reg[23]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[23]_0[1] -pin u_mira step_y_q_reg[2]_1[1]
load net amostra_completa[42] -attr @rip Q[23] -pin u_dados Q[23] -pin u_entrada Q[23]
load net amostra_completa[78] -attr @rip Q[38] -pin u_dados Q[38] -pin u_entrada Q[38]
load net amostra_completa[94] -attr @rip Q[54] -pin u_dados Q[54] -pin u_entrada Q[54]
load net alvo_x[0] -attr @rip alvo_x_reg[3]_0[0] -pin u_dados alvo_x_reg[3]_0[0] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_966[0]
load net u_mira_caca/on52_in -attr @rip VGA_R_OBUF[3]_inst_i_952_0[0] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_952_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_125_1[0]
netloc u_mira_caca/on52_in 1 5 1 5590 550n
load net alvo_y[2] -attr @rip alvo_y_reg[8]_0[2] -pin u_dados alvo_y_reg[8]_0[2] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_680[2]
load net center_y[4] -attr @rip Q[4] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[4] -pin u_mira Q[4]
load net center_x_6[0] -attr @rip Q[0] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[0] -pin u_marcador_joystick Q[0]
load net joystick_vertical_raw[3] -attr @style dashed -attr @rip D[3] -pin g_xadc_fast.u_joystick_cdc D[3] -pin u_marcador_joystick center_y_reg[11]_1[3] -pin u_mira center_y_reg[11]_0[3]
load net center_y_5[7] -attr @rip center_y_reg[11]_0[7] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[7] -pin u_marcador_joystick center_y_reg[11]_0[7]
load net hud_pixel_y[0] -attr @style dashed -attr @rip B[0] -pin u_dados hud_pixel_y[0] -pin u_hud_vertical_adjust B[0]
load net hud_offset_y[0] -attr @style dashed -attr @rip offset_y[0] -pin u_hud_horizontal_adjust Q[0] -pin u_hud_vertical_adjust offset_y[0]
load net mira_y_origem[5] -attr @rip locked_reg_0[15] -pin u_entrada retido_reg[121]_0[34] -pin u_mira locked_reg_0[15]
load net mira_x_origem[1] -attr @rip locked_reg_0[1] -pin u_entrada retido_reg[121]_0[20] -pin u_mira locked_reg_0[1]
load net mira_y_in[0] -attr @rip Q[10] -pin u_dados Q[10] -pin u_entrada Q[10]
load net metadados_in[7] -attr @rip Q[62] -pin u_dados Q[62] -pin u_entrada Q[62]
load net mira_x[5] -attr @rip mira_x_reg[9]_0[5] -pin u_dados mira_x_reg[9]_0[5] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[5]
load net pixel_x[8] -attr @style dashed -attr @rip Q[7] -pin u_dados VGA_R_OBUF[3]_inst_i_3466_0[6] -pin u_hud_horizontal_adjust xc_1[0]
load net g_xadc_fast.u_joystick_cdc_n_65 -attr @rip dados_destino_reg[3]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_0[0] -pin u_mira step_x_q[2]_i_2_1[0]
load net g_xadc_fast.u_joystick_cdc_n_20 -attr @style dashed -attr @rip Q[6] -pin g_xadc_fast.u_joystick_cdc Q[6] -pin u_marcador_joystick center_x_reg[11]_0[6] -pin u_mira step_y_q5_carry__0_1[6]
load net g_xadc_fast.u_joystick_cdc_n_50 -attr @rip dados_destino_reg[10]_1[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_1[1] -pin u_mira dir_x_q_reg_1[1]
load net g_xadc_fast.u_joystick_cdc_n_103 -attr @rip dados_destino_reg[7]_2[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_2[1] -pin u_mira step_x_q_reg[2]_1[1]
load net align_mode -attr @style dashed -pin u_capture_control align_mode -pin u_hud_commands align_mode -pin u_hud_horizontal_adjust align_enable -pin u_hud_vertical_adjust align_mode
netloc align_mode 1 0 6 180 1030 720J 1130 1760 1070 2720J 1050 4700 1470 NJ
load net estilo_caca_sync -attr @style dashed -pin u_marcador_joystick out -pin u_mira out
netloc estilo_caca_sync 1 0 2 40 690 600
load net g_xadc_fast.u_joystick_cdc_n_90 -attr @rip dados_destino_reg[19]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[19]_0[1] -pin u_mira step_y_q_reg[2]_0[1]
load net u_entrada_n_4 -pin u_dados alvo_x_pendente_reg[8]_0 -pin u_entrada dados_destino_reg[4]_1
netloc u_entrada_n_4 1 3 1 2620 5390n
load net u_hud_vertical_adjust_n_15 -attr @rip alvo_y_reg[8][0] -pin u_dados VGA_R_OBUF[3]_inst_i_353_1[0] -pin u_hud_vertical_adjust alvo_y_reg[8][0]
netloc u_hud_vertical_adjust_n_15 1 3 4 3200 1810 4460J 1830 5530J 1850 6270
load net u_hud_horizontal_adjust_n_14 -attr @rip alvo_x_reg[1]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_705_0[0] -pin u_hud_horizontal_adjust alvo_x_reg[1]_0[0]
netloc u_hud_horizontal_adjust_n_14 1 3 3 3120 1890 4280J 1910 5450
load net alvo_y_origem[1] -attr @rip y_reg[8]_0[11] -pin u_entrada retido_reg[121]_0[11] -pin u_marcador_joystick y_reg[8]_0[11]
load net alvo_x_origem[1] -attr @rip y_reg[8]_0[1] -pin u_entrada retido_reg[121]_0[1] -pin u_marcador_joystick y_reg[8]_0[1]
load net amostra_completa[46] -attr @rip Q[27] -pin u_dados Q[27] -pin u_entrada Q[27]
load net amostra_completa[83] -attr @rip Q[43] -pin u_dados Q[43] -pin u_entrada Q[43]
load net center_x[1] -attr @rip center_x_reg[11]_0[1] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[1] -pin u_mira center_x_reg[11]_0[1]
load net center_x_6[5] -attr @rip Q[5] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[5] -pin u_marcador_joystick Q[5]
load net joystick_vertical_raw[7] -attr @style dashed -attr @rip D[7] -pin g_xadc_fast.u_joystick_cdc D[7] -pin u_marcador_joystick center_y_reg[11]_1[7] -pin u_mira center_y_reg[11]_0[7]
load net center_y[8] -attr @rip Q[8] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[8] -pin u_mira Q[8]
load net hud_pixel_y[2] -attr @style dashed -attr @rip B[2] -pin u_dados hud_pixel_y[2] -pin u_hud_vertical_adjust B[2]
load net hud_offset_y[5] -attr @style dashed -attr @rip offset_y[5] -pin u_hud_horizontal_adjust Q[5] -pin u_hud_vertical_adjust offset_y[5]
load net mira_x_origem[6] -attr @rip locked_reg_0[6] -pin u_entrada retido_reg[121]_0[25] -pin u_mira locked_reg_0[6]
load net mira_x_in[0] -attr @rip Q[0] -pin u_dados Q[0] -pin u_entrada Q[0]
load net mira_y_in[3] -attr @rip Q[13] -pin u_dados Q[13] -pin u_entrada Q[13]
load net metadados_in[11] -attr @rip Q[66] -pin u_dados Q[66] -pin u_entrada Q[66]
load net step_x_q3[7] -attr @rip dados_destino_reg[10]_0[0] -pin g_xadc_fast.u_joystick_cdc step_x_q3[0] -pin u_mira dados_destino_reg[10]_0[0]
load net velocidade_pendente[0] -attr @rip SR[0] -pin u_dados SR[0] -pin u_entrada SR[0]
netloc velocidade_pendente[0] 1 3 1 2480 2590n
load net g_xadc_fast.u_joystick_cdc_n_21 -attr @style dashed -attr @rip Q[5] -pin g_xadc_fast.u_joystick_cdc Q[5] -pin u_marcador_joystick center_x_reg[11]_0[5] -pin u_mira step_y_q5_carry__0_1[5]
load net g_xadc_fast.u_joystick_cdc_n_104 -attr @rip dados_destino_reg[7]_2[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_2[0] -pin u_mira step_x_q_reg[2]_1[0]
load net g_xadc_fast.u_joystick_cdc_n_51 -attr @rip dados_destino_reg[10]_1[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_1[0] -pin u_mira dir_x_q_reg_1[0]
load net capture_grid_enabled -attr @style dashed -pin u_capture_control page[2] -pin u_hud_commands page[0]
netloc capture_grid_enabled 1 0 2 140 1310 640J
load net g_xadc_fast.u_joystick_cdc_n_91 -attr @rip dados_destino_reg[19]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[19]_0[0] -pin u_mira step_y_q_reg[2]_0[0]
load net hud_video_on -attr @style dashed -pin u_dados hud_video_on -pin u_hud_vertical_adjust hud_video_on
netloc hud_video_on 1 3 4 2860 2010 NJ 2010 NJ 2010 6230
load net u_entrada_n_5 -pin u_dados alvo_x_pendente_reg[7]_0 -pin u_entrada dados_destino_reg[4]_2
netloc u_entrada_n_5 1 3 1 2600 5410n
load net u_hud_horizontal_adjust_n_15 -pin u_dados VGA_R_OBUF[3]_inst_i_369_1 -pin u_hud_horizontal_adjust h_cont_reg[9]
netloc u_hud_horizontal_adjust_n_15 1 3 3 2940 1210 NJ 1210 5370
load net g_xadc_fast.u_joystick_cdc_n_66 -attr @rip dados_destino_reg[18]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[18]_0[3] -pin u_mira step_y_q5_carry__0_0[3]
load net alvo_y_origem[2] -attr @rip y_reg[8]_0[12] -pin u_entrada retido_reg[121]_0[12] -pin u_marcador_joystick y_reg[8]_0[12]
load net alvo_x_origem[2] -attr @rip y_reg[8]_0[2] -pin u_entrada retido_reg[121]_0[2] -pin u_marcador_joystick y_reg[8]_0[2]
load net amostra_completa[47] -attr @rip Q[28] -pin u_dados Q[28] -pin u_entrada Q[28]
load net amostra_completa[84] -attr @rip Q[44] -pin u_dados Q[44] -pin u_entrada Q[44]
load net center_x[2] -attr @rip center_x_reg[11]_0[2] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[2] -pin u_mira center_x_reg[11]_0[2]
load net center_x_6[6] -attr @rip Q[6] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[6] -pin u_marcador_joystick Q[6]
load net joystick_vertical_raw[8] -attr @style dashed -attr @rip D[8] -pin g_xadc_fast.u_joystick_cdc D[8] -pin u_marcador_joystick center_y_reg[11]_1[8] -pin u_mira center_y_reg[11]_0[8]
load net center_y[10] -attr @rip Q[10] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[10] -pin u_mira Q[10]
load net hud_pixel_y[3] -attr @style dashed -attr @rip B[3] -pin u_dados hud_pixel_y[3] -pin u_hud_vertical_adjust B[3]
load net hud_offset_y[6] -attr @style dashed -attr @rip offset_y[6] -pin u_hud_horizontal_adjust Q[6] -pin u_hud_vertical_adjust offset_y[6]
load net mira_x_in[1] -attr @rip Q[1] -pin u_dados Q[1] -pin u_entrada Q[1]
load net mira_x_origem[9] -attr @rip locked_reg_0[9] -pin u_entrada retido_reg[121]_0[28] -pin u_mira locked_reg_0[9]
load net mira_y_in[4] -attr @rip Q[14] -pin u_dados Q[14] -pin u_entrada Q[14]
load net metadados_in[12] -attr @rip Q[67] -pin u_dados Q[67] -pin u_entrada Q[67]
load net step_x_q3[8] -attr @rip dados_destino_reg[10]_0[1] -pin g_xadc_fast.u_joystick_cdc step_x_q3[1] -pin u_mira dados_destino_reg[10]_0[1]
load net g_xadc_fast.u_joystick_cdc_n_89 -attr @rip dados_destino_reg[19]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[19]_0[2] -pin u_mira step_y_q_reg[2]_0[2]
load net g_xadc_fast.u_joystick_cdc_n_19 -attr @style dashed -attr @rip Q[7] -pin g_xadc_fast.u_joystick_cdc Q[7] -pin u_marcador_joystick center_x_reg[11]_0[7] -pin u_mira step_y_q5_carry__0_1[7]
load net g_xadc_fast.u_joystick_cdc_n_101 -attr @rip dados_destino_reg[7]_2[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_2[3] -pin u_mira step_x_q_reg[2]_1[3]
load net g_xadc_fast.u_joystick_cdc_n_63 -attr @rip dados_destino_reg[3]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_0[2] -pin u_mira step_x_q[2]_i_2_1[2]
load net joystick_sw_n_IBUF -attr @style dashed -attr @rip 0 -pin u_marcador_joystick D[0] -pin u_mira D[0]
netloc joystick_sw_n_IBUF 1 0 2 180 70 N
load net u_entrada_n_2 -attr @rip D[0] -pin u_dados D[0] -pin u_entrada D[0]
load net u_hud_horizontal_adjust_n_12 -attr @rip DI[1] -pin u_dados DI[1] -pin u_hud_horizontal_adjust DI[1]
load net u_hud_vertical_adjust_n_13 -attr @rip alvo_y_reg[1][0] -pin u_dados VGA_R_OBUF[3]_inst_i_145_0[0] -pin u_hud_vertical_adjust alvo_y_reg[1][0]
netloc u_hud_vertical_adjust_n_13 1 3 4 3180 1730 NJ 1730 5670J 1750 6210
load net g_xadc_fast.u_joystick_cdc_n_49 -attr @rip dados_destino_reg[6]_1[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[6]_1[0] -pin u_mira step_x_q5_carry__0_0[0]
load net amostra_completa[45] -attr @rip Q[26] -pin u_dados Q[26] -pin u_entrada Q[26]
load net amostra_completa[81] -attr @rip Q[41] -pin u_dados Q[41] -pin u_entrada Q[41]
load net alvo_x[3] -attr @rip alvo_x_reg[3]_0[3] -pin u_dados alvo_x_reg[3]_0[3] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_966[3]
load net center_x_6[3] -attr @rip Q[3] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[3] -pin u_marcador_joystick Q[3]
load net joystick_vertical_raw[6] -attr @style dashed -attr @rip D[6] -pin g_xadc_fast.u_joystick_cdc D[6] -pin u_marcador_joystick center_y_reg[11]_1[6] -pin u_mira center_y_reg[11]_0[6]
load net center_y[9] -attr @rip Q[9] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[9] -pin u_mira Q[9]
load net center_y_5[11] -attr @rip center_y_reg[11]_0[11] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[11] -pin u_marcador_joystick center_y_reg[11]_0[11]
load net hud_pixel_x[9] -attr @style dashed -attr @rip hud_pixel_x[7] -pin u_dados hud_pixel_x[7] -pin u_hud_horizontal_adjust hud_pixel_x[7]
load net hud_offset_y[3] -attr @style dashed -attr @rip offset_y[3] -pin u_hud_horizontal_adjust Q[3] -pin u_hud_vertical_adjust offset_y[3]
load net mira_x_origem[4] -attr @rip locked_reg_0[4] -pin u_entrada retido_reg[121]_0[23] -pin u_mira locked_reg_0[4]
load net mira_y_origem[7] -attr @rip locked_reg_0[17] -pin u_entrada retido_reg[121]_0[36] -pin u_mira locked_reg_0[17]
load net mira_y_in[1] -attr @rip Q[11] -pin u_dados Q[11] -pin u_entrada Q[11]
load net metadados_in[9] -attr @rip Q[64] -pin u_dados Q[64] -pin u_entrada Q[64]
load net mira_x[7] -attr @rip mira_x_reg[9]_0[7] -pin u_dados mira_x_reg[9]_0[7] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[7]
load net g_xadc_fast.u_joystick_cdc_n_5 -attr @rip Q[21] -pin g_xadc_fast.u_joystick_cdc Q[21] -pin u_mira step_y_q5_carry__0_1[21]
load net g_xadc_fast.u_joystick_cdc_n_102 -attr @rip dados_destino_reg[7]_2[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[7]_2[2] -pin u_mira step_x_q_reg[2]_1[2]
load net g_xadc_fast.u_joystick_cdc_n_9 -attr @rip Q[17] -pin g_xadc_fast.u_joystick_cdc Q[17] -pin u_mira step_y_q5_carry__0_1[17]
load net u_entrada_n_3 -pin u_dados alvo_x_pendente_reg[9]_0 -pin u_entrada dados_destino_reg[4]_0
netloc u_entrada_n_3 1 3 1 2680 5370n
load net u_hud_horizontal_adjust_n_13 -attr @rip DI[0] -pin u_dados DI[0] -pin u_hud_horizontal_adjust DI[0]
load net u_hud_vertical_adjust_n_14 -attr @rip alvo_y_reg[1]_0[0] -pin u_dados VGA_R_OBUF[3]_inst_i_674_1[0] -pin u_hud_vertical_adjust alvo_y_reg[1]_0[0]
netloc u_hud_vertical_adjust_n_14 1 3 4 3060 1850 4380J 1870 5490J 1890 6350
load net g_xadc_fast.u_joystick_cdc_n_64 -attr @rip dados_destino_reg[3]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[3]_0[1] -pin u_mira step_x_q[2]_i_2_1[1]
load net alvo_x_origem[0] -attr @rip y_reg[8]_0[0] -pin u_entrada retido_reg[121]_0[0] -pin u_marcador_joystick y_reg[8]_0[0]
load net alvo_y_origem[0] -attr @rip y_reg[8]_0[10] -pin u_entrada retido_reg[121]_0[10] -pin u_marcador_joystick y_reg[8]_0[10]
load net amostra_completa[69] -attr @rip Q[29] -pin u_dados Q[29] -pin u_entrada Q[29]
load net amostra_completa[82] -attr @rip Q[42] -pin u_dados Q[42] -pin u_entrada Q[42]
load net center_x[0] -attr @rip center_x_reg[11]_0[0] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[0] -pin u_mira center_x_reg[11]_0[0]
load net center_x_6[4] -attr @rip Q[4] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[4] -pin u_marcador_joystick Q[4]
load net joystick_vertical_raw[9] -attr @style dashed -attr @rip D[9] -pin g_xadc_fast.u_joystick_cdc D[9] -pin u_marcador_joystick center_y_reg[11]_1[9] -pin u_mira center_y_reg[11]_0[9]
load net center_y[7] -attr @rip Q[7] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[7] -pin u_mira Q[7]
load net hud_pixel_y[1] -attr @style dashed -attr @rip B[1] -pin u_dados hud_pixel_y[1] -pin u_hud_vertical_adjust B[1]
load net hud_offset_y[4] -attr @style dashed -attr @rip offset_y[4] -pin u_hud_horizontal_adjust Q[4] -pin u_hud_vertical_adjust offset_y[4]
load net mira_y_origem[8] -attr @rip locked_reg_0[18] -pin u_entrada retido_reg[121]_0[37] -pin u_mira locked_reg_0[18]
load net mira_x_origem[5] -attr @rip locked_reg_0[5] -pin u_entrada retido_reg[121]_0[24] -pin u_mira locked_reg_0[5]
load net mira_y_in[2] -attr @rip Q[12] -pin u_dados Q[12] -pin u_entrada Q[12]
load net metadados_in[8] -attr @rip Q[63] -pin u_dados Q[63] -pin u_entrada Q[63]
load net mira_x[8] -attr @rip mira_x_reg[9]_0[8] -pin u_dados mira_x_reg[9]_0[8] -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_124_0[8]
load net g_xadc_fast.u_joystick_cdc_n_69 -attr @rip dados_destino_reg[18]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[18]_0[0] -pin u_mira step_y_q5_carry__0_0[0]
load net g_xadc_fast.u_joystick_cdc_n_4 -attr @rip Q[22] -pin g_xadc_fast.u_joystick_cdc Q[22] -pin u_mira step_y_q5_carry__0_1[22]
load net g_xadc_fast.u_joystick_cdc_n_107 -attr @rip dados_destino_reg[10]_3[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_3[0] -pin u_mira step_x_q_reg[2]_3[0]
load net g_xadc_fast.u_joystick_cdc_n_24 -attr @style dashed -attr @rip Q[2] -pin g_xadc_fast.u_joystick_cdc Q[2] -pin u_marcador_joystick center_x_reg[11]_0[2] -pin u_mira step_y_q5_carry__0_1[2]
load net g_xadc_fast.u_joystick_cdc_n_94 -attr @rip dados_destino_reg[15]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[15]_0[1] -pin u_mira step_y_q[2]_i_2_0[1]
load net u_dados_n_141 -pin u_dados alvo_x_reg[7]_0 -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_334
netloc u_dados_n_141 1 4 1 4300 590n
load net u_entrada_n_8 -pin u_dados alvo_x_pendente_reg[2]_0 -pin u_entrada dados_destino_reg[4]_5
netloc u_entrada_n_8 1 3 1 2700 5430n
load net u_hud_vertical_adjust_n_24 -attr @rip alvo_y_reg[2][0] -pin u_dados VGA_R_OBUF[3]_inst_i_680_0[0] -pin u_hud_vertical_adjust alvo_y_reg[2][0]
load net u_hud_horizontal_adjust_n_43 -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_307_0 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_21
netloc u_hud_horizontal_adjust_n_43 1 5 1 5670 510n
load net mira_lock_in -attr @rip Q[19] -pin u_dados Q[19] -pin u_entrada Q[19]
load net g_xadc_fast.u_joystick_cdc_n_54 -attr @rip dados_destino_reg[11]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[11]_0[3] -pin u_mira step_x_q_reg[2]_4[3]
load net alvo_y_origem[5] -attr @rip y_reg[8]_0[15] -pin u_entrada retido_reg[121]_0[15] -pin u_marcador_joystick y_reg[8]_0[15]
load net alvo_x_origem[5] -attr @rip y_reg[8]_0[5] -pin u_entrada retido_reg[121]_0[5] -pin u_marcador_joystick y_reg[8]_0[5]
load net amostra_completa[71] -attr @rip Q[31] -pin u_dados Q[31] -pin u_entrada Q[31]
load net amostra_completa[87] -attr @rip Q[47] -pin u_dados Q[47] -pin u_entrada Q[47]
load net center_x[5] -attr @rip center_x_reg[11]_0[5] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[5] -pin u_mira center_x_reg[11]_0[5]
load net center_x_6[8] -attr @rip Q[8] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[8] -pin u_marcador_joystick Q[8]
load net center_y_5[1] -attr @rip center_y_reg[11]_0[1] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[1] -pin u_marcador_joystick center_y_reg[11]_0[1]
load net hud_pixel_y[6] -attr @style dashed -attr @rip hud_pixel_y[2] -pin u_dados hud_pixel_y[6] -pin u_hud_vertical_adjust hud_pixel_y[2]
load net hud_offset_y[8] -attr @rip offset_y[8] -pin u_hud_horizontal_adjust Q[8] -pin u_hud_vertical_adjust offset_y[8]
load net mira_y_origem[0] -attr @rip locked_reg_0[10] -pin u_entrada retido_reg[121]_0[29] -pin u_mira locked_reg_0[10]
load net mira_x_in[4] -attr @rip Q[4] -pin u_dados Q[4] -pin u_entrada Q[4]
load net metadados_in[15] -attr @rip Q[70] -pin u_dados Q[70] -pin u_entrada Q[70]
load net mira_y[0] -attr @rip mira_y_reg[8]_0[0] -pin u_dados mira_y_reg[8]_0[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[0]
load net step_x_q3[11] -attr @rip dados_destino_reg[10]_0[4] -pin g_xadc_fast.u_joystick_cdc step_x_q3[4] -pin u_mira dados_destino_reg[10]_0[4]
load net g_xadc_fast.u_joystick_cdc_n_95 -attr @rip dados_destino_reg[15]_0[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[15]_0[0] -pin u_mira step_y_q[2]_i_2_0[0]
load net g_xadc_fast.u_joystick_cdc_n_108 -pin g_xadc_fast.u_joystick_cdc inicio_operacao_reg[3]_1 -pin u_mira dir_x_q_reg_2
netloc g_xadc_fast.u_joystick_cdc_n_108 1 1 3 920 1030 NJ 1030 2440
load net g_xadc_fast.u_joystick_cdc_n_25 -attr @style dashed -attr @rip Q[1] -pin g_xadc_fast.u_joystick_cdc Q[1] -pin u_marcador_joystick center_x_reg[11]_0[1] -pin u_mira step_y_q5_carry__0_1[1]
load net dir_x_q -pin g_xadc_fast.u_joystick_cdc dir_x_q -pin u_mira dir_x_q
netloc dir_x_q 1 2 1 1780 350n
load net amostra_valida -pin u_dados amostra_valida -pin u_entrada amostra_valida
netloc amostra_valida 1 3 1 2520 5350n
load net u_dados_n_142 -pin u_dados alvo_y_reg[7]_0 -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_361
netloc u_dados_n_142 1 4 2 4560 1370 NJ
load net u_entrada_n_1 -attr @rip D[1] -pin u_dados D[1] -pin u_entrada D[1]
load net u_entrada_n_9 -pin u_dados alvo_x_pendente_reg[1]_0 -pin u_entrada dados_destino_reg[4]_6
netloc u_entrada_n_9 1 3 1 2660 5410n
load net u_hud_vertical_adjust_n_25 -attr @rip alvo_y_reg[7][0] -pin u_dados VGA_R_OBUF[3]_inst_i_146_0[0] -pin u_hud_vertical_adjust alvo_y_reg[7][0]
netloc u_hud_vertical_adjust_n_25 1 3 4 3080 1770 4500J 1790 5590J 1810 6310
load net g_xadc_fast.u_joystick_cdc_n_7 -attr @rip Q[19] -pin g_xadc_fast.u_joystick_cdc Q[19] -pin u_mira step_y_q5_carry__0_1[19]
load net g_xadc_fast.u_joystick_cdc_n_55 -attr @rip dados_destino_reg[11]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[11]_0[2] -pin u_mira step_x_q_reg[2]_4[2]
load net alvo_y_origem[6] -attr @rip y_reg[8]_0[16] -pin u_entrada retido_reg[121]_0[16] -pin u_marcador_joystick y_reg[8]_0[16]
load net alvo_x_origem[6] -attr @rip y_reg[8]_0[6] -pin u_entrada retido_reg[121]_0[6] -pin u_marcador_joystick y_reg[8]_0[6]
load net amostra_completa[72] -attr @rip Q[32] -pin u_dados Q[32] -pin u_entrada Q[32]
load net amostra_completa[88] -attr @rip Q[48] -pin u_dados Q[48] -pin u_entrada Q[48]
load net center_x[6] -attr @rip center_x_reg[11]_0[6] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[6] -pin u_mira center_x_reg[11]_0[6]
load net center_x_6[10] -attr @rip Q[10] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[10] -pin u_marcador_joystick Q[10]
load net center_y_5[2] -attr @rip center_y_reg[11]_0[2] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[2] -pin u_marcador_joystick center_y_reg[11]_0[2]
load net hud_pixel_x[1] -attr @style dashed -attr @rip hud_pixel_x[1] -pin u_dados hud_pixel_x[1] -pin u_hud_horizontal_adjust hud_pixel_x[1]
load net hud_pixel_y[9] -attr @style dashed -attr @rip hud_pixel_y[5] -pin u_dados hud_pixel_y[9] -pin u_hud_vertical_adjust hud_pixel_y[5]
load net mira_y_in[7] -attr @rip Q[17] -pin u_dados Q[17] -pin u_entrada Q[17]
load net metadados_in[0] -attr @rip Q[56] -pin u_dados Q[56] -pin u_entrada Q[56]
load net mira_x_in[5] -attr @rip Q[5] -pin u_dados Q[5] -pin u_entrada Q[5]
load net metadados_in[25] -attr @rip Q[71] -pin u_dados Q[71] -pin u_entrada Q[71]
load net mira_y[1] -attr @rip mira_y_reg[8]_0[1] -pin u_dados mira_y_reg[8]_0[1] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_296_0[1]
load net g_xadc_fast.u_joystick_cdc_n_105 -attr @rip dados_destino_reg[10]_3[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_3[2] -pin u_mira step_x_q_reg[2]_3[2]
load net g_xadc_fast.u_joystick_cdc_n_22 -attr @style dashed -attr @rip Q[4] -pin g_xadc_fast.u_joystick_cdc Q[4] -pin u_marcador_joystick center_x_reg[11]_0[4] -pin u_mira step_y_q5_carry__0_1[4]
load net alvo_lock_origem -pin u_marcador_joystick alvo_lock_origem -pin u_mira alvo_lock_origem
netloc alvo_lock_origem 1 1 1 580 90n
load net g_xadc_fast.u_joystick_cdc_n_67 -attr @rip dados_destino_reg[18]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[18]_0[2] -pin u_mira step_y_q5_carry__0_0[2]
load net g_xadc_fast.u_joystick_cdc_n_92 -attr @rip dados_destino_reg[15]_0[3] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[15]_0[3] -pin u_mira step_y_q[2]_i_2_0[3]
load net u_entrada_n_6 -pin u_dados alvo_x_pendente_reg[6]_0 -pin u_entrada dados_destino_reg[4]_3
netloc u_entrada_n_6 1 3 1 2580 5430n
load net u_hud_vertical_adjust_n_22 -attr @rip alvo_y_reg[0]_1[0] -pin u_dados VGA_R_OBUF[3]_inst_i_674_0[0] -pin u_hud_vertical_adjust alvo_y_reg[0]_1[0]
netloc u_hud_vertical_adjust_n_22 1 3 4 3020 1830 4420J 1850 5510J 1870 6370
load net g_xadc_fast.u_joystick_cdc_n_52 -attr @rip dados_destino_reg[10]_2[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_2[1] -pin u_mira dir_x_q_reg_0[1]
load net alvo_y_origem[3] -attr @rip y_reg[8]_0[13] -pin u_entrada retido_reg[121]_0[13] -pin u_marcador_joystick y_reg[8]_0[13]
load net alvo_x_origem[3] -attr @rip y_reg[8]_0[3] -pin u_entrada retido_reg[121]_0[3] -pin u_marcador_joystick y_reg[8]_0[3]
load net amostra_completa[85] -attr @rip Q[45] -pin u_dados Q[45] -pin u_entrada Q[45]
load net center_x[3] -attr @rip center_x_reg[11]_0[3] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[3] -pin u_mira center_x_reg[11]_0[3]
load net center_x_6[9] -attr @rip Q[9] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[9] -pin u_marcador_joystick Q[9]
load net joystick_vertical_raw[10] -attr @style dashed -attr @rip D[10] -pin g_xadc_fast.u_joystick_cdc D[10] -pin u_marcador_joystick center_y_reg[11]_1[10] -pin u_mira center_y_reg[11]_0[10]
load net center_y[11] -attr @rip Q[11] -pin g_xadc_fast.u_joystick_cdc _inferred__8/i__carry__1[11] -pin u_mira Q[11]
load net hud_pixel_x[0] -attr @style dashed -attr @rip hud_pixel_x[0] -pin u_dados hud_pixel_x[0] -pin u_hud_horizontal_adjust hud_pixel_x[0]
load net hud_pixel_y[4] -attr @style dashed -attr @rip hud_pixel_y[0] -pin u_dados hud_pixel_y[4] -pin u_hud_vertical_adjust hud_pixel_y[0]
load net mira_x_origem[7] -attr @rip locked_reg_0[7] -pin u_entrada retido_reg[121]_0[26] -pin u_mira locked_reg_0[7]
load net mira_y_in[5] -attr @rip Q[15] -pin u_dados Q[15] -pin u_entrada Q[15]
load net mira_x_in[2] -attr @rip Q[2] -pin u_dados Q[2] -pin u_entrada Q[2]
load net metadados_in[13] -attr @rip Q[68] -pin u_dados Q[68] -pin u_entrada Q[68]
load net step_x_q3[9] -attr @rip dados_destino_reg[10]_0[2] -pin g_xadc_fast.u_joystick_cdc step_x_q3[2] -pin u_mira dados_destino_reg[10]_0[2]
load net g_xadc_fast.u_joystick_cdc_n_68 -attr @rip dados_destino_reg[18]_0[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[18]_0[1] -pin u_mira step_y_q5_carry__0_0[1]
load net g_xadc_fast.u_joystick_cdc_n_106 -attr @rip dados_destino_reg[10]_3[1] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_3[1] -pin u_mira step_x_q_reg[2]_3[1]
load net g_xadc_fast.u_joystick_cdc_n_23 -attr @style dashed -attr @rip Q[3] -pin g_xadc_fast.u_joystick_cdc Q[3] -pin u_marcador_joystick center_x_reg[11]_0[3] -pin u_mira step_y_q5_carry__0_1[3]
load net capture_mode -attr @style dashed -attr @rip capture_reg_0[0] -pin u_capture_control capture_reg_0[0] -pin u_hud_commands capture_grid_pulse_reg_0[0]
netloc capture_mode 1 1 1 680 1130n
load net g_xadc_fast.u_joystick_cdc_n_93 -attr @rip dados_destino_reg[15]_0[2] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[15]_0[2] -pin u_mira step_y_q[2]_i_2_0[2]
load net u_dados_n_140 -pin u_dados alvo_x_reg[6]_0 -pin u_hud_horizontal_adjust VGA_R_OBUF[3]_inst_i_334_0
netloc u_dados_n_140 1 4 1 4320 610n
load net u_entrada_n_7 -pin u_dados alvo_x_pendente_reg[5]_0 -pin u_entrada dados_destino_reg[4]_4
netloc u_entrada_n_7 1 3 1 N 5450
load net u_hud_vertical_adjust_n_23 -attr @rip alvo_y_reg[2][1] -pin u_dados VGA_R_OBUF[3]_inst_i_680_0[1] -pin u_hud_vertical_adjust alvo_y_reg[2][1]
load net u_hud_horizontal_adjust_n_41 -attr @rip O[0] -pin u_hud_horizontal_adjust O[0] -pin u_hud_vertical_adjust VGA_R_OBUF[3]_inst_i_21_0[0]
netloc u_hud_horizontal_adjust_n_41 1 5 1 5690 490n
load net g_xadc_fast.u_joystick_cdc_n_53 -attr @rip dados_destino_reg[10]_2[0] -pin g_xadc_fast.u_joystick_cdc dados_destino_reg[10]_2[0] -pin u_mira dir_x_q_reg_0[0]
load net alvo_y_origem[4] -attr @rip y_reg[8]_0[14] -pin u_entrada retido_reg[121]_0[14] -pin u_marcador_joystick y_reg[8]_0[14]
load net alvo_x_origem[4] -attr @rip y_reg[8]_0[4] -pin u_entrada retido_reg[121]_0[4] -pin u_marcador_joystick y_reg[8]_0[4]
load net amostra_completa[70] -attr @rip Q[30] -pin u_dados Q[30] -pin u_entrada Q[30]
load net amostra_completa[86] -attr @rip Q[46] -pin u_dados Q[46] -pin u_entrada Q[46]
load net center_x[4] -attr @rip center_x_reg[11]_0[4] -pin g_xadc_fast.u_joystick_cdc _inferred__1/i__carry__1[4] -pin u_mira center_x_reg[11]_0[4]
load net center_x_6[7] -attr @rip Q[7] -pin g_xadc_fast.u_joystick_cdc step_x_q_reg[2]_i_2_0[7] -pin u_marcador_joystick Q[7]
load net joystick_vertical_raw[11] -attr @style dashed -attr @rip D[11] -pin g_xadc_fast.u_joystick_cdc D[11] -pin u_marcador_joystick center_y_reg[11]_1[11] -pin u_mira center_y_reg[11]_0[11]
load net center_y_5[0] -attr @rip center_y_reg[11]_0[0] -pin g_xadc_fast.u_joystick_cdc step_y_q_reg[2]_i_2_0[0] -pin u_marcador_joystick center_y_reg[11]_0[0]
load net hud_pixel_y[5] -attr @style dashed -attr @rip hud_pixel_y[1] -pin u_dados hud_pixel_y[5] -pin u_hud_vertical_adjust hud_pixel_y[1]
load net hud_offset_y[7] -attr @style dashed -attr @rip offset_y[7] -pin u_hud_horizontal_adjust Q[7] -pin u_hud_vertical_adjust offset_y[7]
load net mira_x_in[3] -attr @rip Q[3] -pin u_dados Q[3] -pin u_entrada Q[3]
load net mira_x_origem[8] -attr @rip locked_reg_0[8] -pin u_entrada retido_reg[121]_0[27] -pin u_mira locked_reg_0[8]
load net mira_y_in[6] -attr @rip Q[16] -pin u_dados Q[16] -pin u_entrada Q[16]
load net metadados_in[14] -attr @rip Q[69] -pin u_dados Q[69] -pin u_entrada Q[69]
load net step_x_q3[10] -attr @rip dados_destino_reg[10]_0[3] -pin g_xadc_fast.u_joystick_cdc step_x_q3[3] -pin u_mira dados_destino_reg[10]_0[3]
load netBundle @joystick_vertical_raw 12 joystick_vertical_raw[11] joystick_vertical_raw[10] joystick_vertical_raw[9] joystick_vertical_raw[8] joystick_vertical_raw[7] joystick_vertical_raw[6] joystick_vertical_raw[5] joystick_vertical_raw[4] joystick_vertical_raw[3] joystick_vertical_raw[2] joystick_vertical_raw[1] joystick_vertical_raw[0] -autobundled -attr @style dashed
netbloc @joystick_vertical_raw 1 0 4 80 1270 620 850 NJ 850 2840
load netBundle @g_xadc_fast.u_joystick_cdc_n_ 24 g_xadc_fast.u_joystick_cdc_n_3 g_xadc_fast.u_joystick_cdc_n_4 g_xadc_fast.u_joystick_cdc_n_5 g_xadc_fast.u_joystick_cdc_n_6 g_xadc_fast.u_joystick_cdc_n_7 g_xadc_fast.u_joystick_cdc_n_8 g_xadc_fast.u_joystick_cdc_n_9 g_xadc_fast.u_joystick_cdc_n_10 g_xadc_fast.u_joystick_cdc_n_11 g_xadc_fast.u_joystick_cdc_n_12 g_xadc_fast.u_joystick_cdc_n_13 g_xadc_fast.u_joystick_cdc_n_14 g_xadc_fast.u_joystick_cdc_n_15 g_xadc_fast.u_joystick_cdc_n_16 g_xadc_fast.u_joystick_cdc_n_17 g_xadc_fast.u_joystick_cdc_n_18 g_xadc_fast.u_joystick_cdc_n_19 g_xadc_fast.u_joystick_cdc_n_20 g_xadc_fast.u_joystick_cdc_n_21 g_xadc_fast.u_joystick_cdc_n_22 g_xadc_fast.u_joystick_cdc_n_23 g_xadc_fast.u_joystick_cdc_n_24 g_xadc_fast.u_joystick_cdc_n_25 g_xadc_fast.u_joystick_cdc_n_26 -autobundled -attr @style dashed
netbloc @g_xadc_fast.u_joystick_cdc_n_ 1 0 4 20 670 680 830 NJ 830 2820
load netBundle @g_xadc_fast.u_joystick_cdc_n__1 2 g_xadc_fast.u_joystick_cdc_n_50 g_xadc_fast.u_joystick_cdc_n_51 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__1 1 1 3 900 750 NJ 750 2420
load netBundle @g_xadc_fast.u_joystick_cdc_n__2 2 g_xadc_fast.u_joystick_cdc_n_52 g_xadc_fast.u_joystick_cdc_n_53 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__2 1 1 3 880 870 NJ 870 2760
load netBundle @g_xadc_fast.u_joystick_cdc_n__3 3 g_xadc_fast.u_joystick_cdc_n_105 g_xadc_fast.u_joystick_cdc_n_106 g_xadc_fast.u_joystick_cdc_n_107 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__3 1 1 3 1000 890 NJ 890 2660
load netBundle @g_xadc_fast.u_joystick_cdc_n__4 4 g_xadc_fast.u_joystick_cdc_n_54 g_xadc_fast.u_joystick_cdc_n_55 g_xadc_fast.u_joystick_cdc_n_56 g_xadc_fast.u_joystick_cdc_n_57 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__4 1 1 3 1060 910 NJ 910 2620
load netBundle @g_xadc_fast.u_joystick_cdc_n__5 4 g_xadc_fast.u_joystick_cdc_n_92 g_xadc_fast.u_joystick_cdc_n_93 g_xadc_fast.u_joystick_cdc_n_94 g_xadc_fast.u_joystick_cdc_n_95 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__5 1 1 3 980 930 NJ 930 2600
load netBundle @g_xadc_fast.u_joystick_cdc_n__6 4 g_xadc_fast.u_joystick_cdc_n_66 g_xadc_fast.u_joystick_cdc_n_67 g_xadc_fast.u_joystick_cdc_n_68 g_xadc_fast.u_joystick_cdc_n_69 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__6 1 1 3 1100 950 NJ 950 2560
load netBundle @g_xadc_fast.u_joystick_cdc_n__7 4 g_xadc_fast.u_joystick_cdc_n_88 g_xadc_fast.u_joystick_cdc_n_89 g_xadc_fast.u_joystick_cdc_n_90 g_xadc_fast.u_joystick_cdc_n_91 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__7 1 1 3 1040 970 NJ 970 2540
load netBundle @g_xadc_fast.u_joystick_cdc_n__8 2 g_xadc_fast.u_joystick_cdc_n_70 g_xadc_fast.u_joystick_cdc_n_71 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__8 1 1 3 960 990 NJ 990 2500
load netBundle @g_xadc_fast.u_joystick_cdc_n__9 4 g_xadc_fast.u_joystick_cdc_n_84 g_xadc_fast.u_joystick_cdc_n_85 g_xadc_fast.u_joystick_cdc_n_86 g_xadc_fast.u_joystick_cdc_n_87 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__9 1 1 3 940 1010 NJ 1010 2460
load netBundle @g_xadc_fast.u_joystick_cdc_n__10 4 g_xadc_fast.u_joystick_cdc_n_62 g_xadc_fast.u_joystick_cdc_n_63 g_xadc_fast.u_joystick_cdc_n_64 g_xadc_fast.u_joystick_cdc_n_65 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__10 1 1 3 1180 590 1640J 10 2440
load netBundle @g_xadc_fast.u_joystick_cdc_n__11 4 g_xadc_fast.u_joystick_cdc_n_97 g_xadc_fast.u_joystick_cdc_n_98 g_xadc_fast.u_joystick_cdc_n_99 g_xadc_fast.u_joystick_cdc_n_100 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__11 1 1 3 1160 610 1680J 30 2400
load netBundle @g_xadc_fast.u_joystick_cdc_n__12 4 g_xadc_fast.u_joystick_cdc_n_42 g_xadc_fast.u_joystick_cdc_n_43 g_xadc_fast.u_joystick_cdc_n_44 g_xadc_fast.u_joystick_cdc_n_45 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__12 1 1 3 1140 630 1700J 50 2460
load netBundle @g_xadc_fast.u_joystick_cdc_n__13 4 g_xadc_fast.u_joystick_cdc_n_46 g_xadc_fast.u_joystick_cdc_n_47 g_xadc_fast.u_joystick_cdc_n_48 g_xadc_fast.u_joystick_cdc_n_49 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__13 1 1 3 1120 770 NJ 770 2720
load netBundle @g_xadc_fast.u_joystick_cdc_n__14 4 g_xadc_fast.u_joystick_cdc_n_58 g_xadc_fast.u_joystick_cdc_n_59 g_xadc_fast.u_joystick_cdc_n_60 g_xadc_fast.u_joystick_cdc_n_61 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__14 1 1 3 1080 790 NJ 790 2520
load netBundle @g_xadc_fast.u_joystick_cdc_n__15 4 g_xadc_fast.u_joystick_cdc_n_101 g_xadc_fast.u_joystick_cdc_n_102 g_xadc_fast.u_joystick_cdc_n_103 g_xadc_fast.u_joystick_cdc_n_104 -autobundled
netbloc @g_xadc_fast.u_joystick_cdc_n__15 1 1 3 1020 810 NJ 810 2480
load netBundle @center_y 12 center_y[11] center_y[10] center_y[9] center_y[8] center_y[7] center_y[6] center_y[5] center_y[4] center_y[3] center_y[2] center_y[1] center_y[0] -autobundled
netbloc @center_y 1 2 1 1880 250n
load netBundle @center_x 12 center_x[11] center_x[10] center_x[9] center_x[8] center_x[7] center_x[6] center_x[5] center_x[4] center_x[3] center_x[2] center_x[1] center_x[0] -autobundled
netbloc @center_x 1 2 1 1860 290n
load netBundle @step_x_q3 5 step_x_q3[11] step_x_q3[10] step_x_q3[9] step_x_q3[8] step_x_q3[7] -autobundled
netbloc @step_x_q3 1 2 1 1760 330n
load netBundle @mira_x_origem,mira_y_origem 20 pacote_hud[38] mira_y_origem[8] mira_y_origem[7] mira_y_origem[6] mira_y_origem[5] mira_y_origem[4] mira_y_origem[3] mira_y_origem[2] mira_y_origem[1] mira_y_origem[0] mira_x_origem[9] mira_x_origem[8] mira_x_origem[7] mira_x_origem[6] mira_x_origem[5] mira_x_origem[4] mira_x_origem[3] mira_x_origem[2] mira_x_origem[1] mira_x_origem[0] -autobundled
netbloc @mira_x_origem,mira_y_origem 1 2 1 1660 370n
load netBundle @center_x_6 12 center_x_6[11] center_x_6[10] center_x_6[9] center_x_6[8] center_x_6[7] center_x_6[6] center_x_6[5] center_x_6[4] center_x_6[3] center_x_6[2] center_x_6[1] center_x_6[0] -autobundled
netbloc @center_x_6 1 1 2 660 710 1780J
load netBundle @center_y_5 12 center_y_5[11] center_y_5[10] center_y_5[9] center_y_5[8] center_y_5[7] center_y_5[6] center_y_5[5] center_y_5[4] center_y_5[3] center_y_5[2] center_y_5[1] center_y_5[0] -autobundled
netbloc @center_y_5 1 1 2 840 730 1860J
load netBundle @alvo_x_origem,alvo_y_origem 19 alvo_y_origem[8] alvo_y_origem[7] alvo_y_origem[6] alvo_y_origem[5] alvo_y_origem[4] alvo_y_origem[3] alvo_y_origem[2] alvo_y_origem[1] alvo_y_origem[0] alvo_x_origem[9] alvo_x_origem[8] alvo_x_origem[7] alvo_x_origem[6] alvo_x_origem[5] alvo_x_origem[4] alvo_x_origem[3] alvo_x_origem[2] alvo_x_origem[1] alvo_x_origem[0] -autobundled
netbloc @alvo_x_origem,alvo_y_origem 1 1 2 700J 1410 1640
load netBundle @u_entrada_n_ 2 u_entrada_n_1 u_entrada_n_2 -autobundled
netbloc @u_entrada_n_ 1 3 1 2400 2530n
load netBundle @amostra_completa,metadados_in 72 metadados_in[25] metadados_in[15] metadados_in[14] metadados_in[13] metadados_in[12] metadados_in[11] metadados_in[10] metadados_in[9] metadados_in[8] metadados_in[7] metadados_in[5] metadados_in[4] metadados_in[3] metadados_in[2] metadados_in[1] metadados_in[0] amostra_completa[95] amostra_completa[94] amostra_completa[93] amostra_completa[92] amostra_completa[91] amostra_completa[90] amostra_completa[89] amostra_completa[88] amostra_completa[87] amostra_completa[86] amostra_completa[85] amostra_completa[84] amostra_completa[83] amostra_completa[82] amostra_completa[81] amostra_completa[80] amostra_completa[79] amostra_completa[78] amostra_completa[77] amostra_completa[76] amostra_completa[75] amostra_completa[74] amostra_completa[73] amostra_completa[72] amostra_completa[71] amostra_completa[70] amostra_completa[69] amostra_completa[47] amostra_completa[46] amostra_completa[45] amostra_completa[44] amostra_completa[43] amostra_completa[42] amostra_completa[41] amostra_completa[40] amostra_completa[39] mira_lock_in mira_y_in[8] mira_y_in[7] mira_y_in[6] mira_y_in[5] mira_y_in[4] mira_y_in[3] mira_y_in[2] mira_y_in[1] mira_y_in[0] mira_x_in[9] mira_x_in[8] mira_x_in[7] mira_x_in[6] mira_x_in[5] mira_x_in[4] mira_x_in[3] mira_x_in[2] mira_x_in[1] mira_x_in[0] -autobundled
netbloc @amostra_completa,metadados_in 1 3 1 2440 2570n
load netBundle @u_entrada_n__1 2 u_entrada_n_93 u_entrada_n_94 -autobundled
netbloc @u_entrada_n__1 1 3 1 2780 5610n
load netBundle @alvo_x 4 alvo_x[3] alvo_x[2] alvo_x[1] alvo_x[0] -autobundled
netbloc @alvo_x 1 4 1 4340 630n
load netBundle @alvo_y 5 alvo_y[8] alvo_y[3] alvo_y[2] alvo_y[1] alvo_y[0] -autobundled
netbloc @alvo_y 1 4 2 4660 1410 NJ
load netBundle @mira_x 10 mira_x[9] mira_x[8] mira_x[7] mira_x[6] mira_x[5] mira_x[4] mira_x[3] mira_x[2] mira_x[1] mira_x[0] -autobundled
netbloc @mira_x 1 4 1 4440 570n
load netBundle @mira_y 9 mira_y[8] mira_y[7] mira_y[6] mira_y[5] mira_y[4] mira_y[3] mira_y[2] mira_y[1] mira_y[0] -autobundled
netbloc @mira_y 1 4 2 4640 1350 NJ
load netBundle @align_command_buttons 2 align_command_buttons[1] align_command_buttons[0] -autobundled
netbloc @align_command_buttons 1 2 4 1640 1350 NJ 1350 4620J 1450 NJ
load netBundle @hud_pixel_y 4 hud_pixel_y[3] hud_pixel_y[2] hud_pixel_y[1] hud_pixel_y[0] -autobundled -attr @style dashed
netbloc @hud_pixel_y 1 3 4 2760 1990 NJ 1990 NJ 1990 6470
load netBundle @u_hud_vertical_adjust_n_ 2 u_hud_vertical_adjust_n_23 u_hud_vertical_adjust_n_24 -autobundled
netbloc @u_hud_vertical_adjust_n_ 1 3 4 3100 1870 4360J 1890 5470J 1910 6330
load netBundle @hud_pixel_y_1 6 hud_pixel_y[9] hud_pixel_y[8] hud_pixel_y[7] hud_pixel_y[6] hud_pixel_y[5] hud_pixel_y[4] -autobundled -attr @style dashed
netbloc @hud_pixel_y_1 1 3 4 2720 1970 NJ 1970 NJ 1970 6430
load netBundle @hud_offset_y 9 hud_offset_y[8] hud_offset_y[7] hud_offset_y[6] hud_offset_y[5] hud_offset_y[4] hud_offset_y[3] hud_offset_y[2] hud_offset_y[1] hud_offset_y[0] -autobundled -attr @style dashed
netbloc @hud_offset_y 1 4 3 4840 1090 5510J 1030 6450
load netBundle @u_hud_horizontal_adjust_n_ 2 u_hud_horizontal_adjust_n_12 u_hud_horizontal_adjust_n_13 -autobundled
netbloc @u_hud_horizontal_adjust_n_ 1 3 3 2840 1130 4380J 1110 5410
load netBundle @u_hud_horizontal_adjust_n__1 2 u_hud_horizontal_adjust_n_10 u_hud_horizontal_adjust_n_11 -autobundled
netbloc @u_hud_horizontal_adjust_n__1 1 3 3 2880 1150 4420J 1130 5350
load netBundle @hud_pixel_x 8 hud_pixel_x[9] hud_pixel_x[8] hud_pixel_x[6] hud_pixel_x[4] hud_pixel_x[3] hud_pixel_x[2] hud_pixel_x[1] hud_pixel_x[0] -autobundled -attr @style dashed
netbloc @hud_pixel_x 1 3 3 2980 1250 NJ 1250 5390
load netBundle @pixel_x 2 pixel_x[9] pixel_x[8] -autobundled -attr @style dashed
netbloc @pixel_x 1 3 2 3000 1950 4400
levelinfo -pg 1 0 350 1370 2110 3450 5060 5910 6490
pagesize -pg 1 -db -bbox -sgen 0 0 6490 6310
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
