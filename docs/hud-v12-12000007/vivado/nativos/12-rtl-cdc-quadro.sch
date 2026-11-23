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
load symbol entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE HIERBOX pin clk_destino input.left pin clk_origem input.left pin pronto output.right pin valido input.left pin valido_destino output.right pinBus dados input.left [127:0] pinBus dados_destino output.right [127:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol dados_hud work:dados_hud:NOFILE HIERBOX pin atualizar_quadro input.left pin clk input.left pin dados_validos input.left pin mira_lock output.right pin mira_lock_in input.left pinBus altitude_ft output.right [16:0] pinBus altitude_ft_in input.left [16:0] pinBus alvo_x output.right [9:0] pinBus alvo_x_in input.left [9:0] pinBus alvo_y output.right [8:0] pinBus alvo_y_in input.left [8:0] pinBus heading_deg output.right [8:0] pinBus heading_deg_in input.left [8:0] pinBus horizonte_y output.right [9:0] pinBus metadados output.right [31:0] pinBus metadados_in input.left [31:0] pinBus mira_x output.right [9:0] pinBus mira_x_in input.left [9:0] pinBus mira_y output.right [8:0] pinBus mira_y_in input.left [8:0] pinBus pitch_px_in input.left [10:0] pinBus roll_q8 output.right [9:0] pinBus roll_q8_in input.left [9:0] pinBus velocidade_kt output.right [9:0] pinBus velocidade_kt_in input.left [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol entrada_hud__parameterized0 work:entrada_hud__parameterized0:NOFILE HIERBOX pin clk_destino input.left pin clk_origem input.left pin pronto output.right pin valido input.left pin valido_destino output.right pinBus dados input.left [238:0] pinBus dados_destino output.right [238:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol simbologia_vga work:simbologia_vga:NOFILE HIERBOX pin altitude_on output.right pin alvo_on output.right pin direcao_on output.right pin flight_video_on input.left pin horizonte_borda_on output.right pin horizonte_on output.right pin velocidade_on output.right pin video_on input.left pinBus alvo_x input.left [9:0] pinBus alvo_y input.left [8:0] pinBus attitude_cosine input.left [15:0] pinBus attitude_pitch_px input.left [10:0] pinBus attitude_sine input.left [15:0] pinBus flight_pixel_x input.left [9:0] pinBus flight_pixel_y input.left [9:0] pinBus heading_deg input.left [8:0] pinBus horizonte_y input.left [9:0] pinBus pixel_x input.left [9:0] pinBus pixel_y input.left [9:0] pinBus roll_q8 input.left [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol vga_controller work:vga_controller:NOFILE HIERBOX pin clk_100mhz input.left pin hsync output.right pin pixel_clk output.right pin video_on output.right pin vsync output.right pinBus pixel_x output.right [9:0] pinBus pixel_y output.right [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst u_entrada entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE -attr @cell(#1c1f28) entrada_hud__parameterized2 -pinAttr pronto @attr n/c -pinBusAttr dados @name dados[127:0] -pinBusAttr dados_destino @name dados_destino[127:0] -pg 1 -lvl 2 -x 430 -y 110
load inst u_dados dados_hud work:dados_hud:NOFILE -attr @cell(#1c1f28) dados_hud -pinBusAttr altitude_ft @name altitude_ft[16:0] -pinBusAttr altitude_ft_in @name altitude_ft_in[16:0] -pinBusAttr alvo_x @name alvo_x[9:0] -pinBusAttr alvo_x_in @name alvo_x_in[9:0] -pinBusAttr alvo_y @name alvo_y[8:0] -pinBusAttr alvo_y_in @name alvo_y_in[8:0] -pinBusAttr heading_deg @name heading_deg[8:0] -pinBusAttr heading_deg_in @name heading_deg_in[8:0] -pinBusAttr horizonte_y @name horizonte_y[9:0] -pinBusAttr metadados @name metadados[31:0] -pinBusAttr metadados_in @name metadados_in[31:0] -pinBusAttr mira_x @name mira_x[9:0] -pinBusAttr mira_x_in @name mira_x_in[9:0] -pinBusAttr mira_y @name mira_y[8:0] -pinBusAttr mira_y_in @name mira_y_in[8:0] -pinBusAttr pitch_px_in @name pitch_px_in[10:0] -pinBusAttr roll_q8 @name roll_q8[9:0] -pinBusAttr roll_q8_in @name roll_q8_in[9:0] -pinBusAttr velocidade_kt @name velocidade_kt[9:0] -pinBusAttr velocidade_kt_in @name velocidade_kt_in[9:0] -pg 1 -lvl 3 -x 820 -y 50
load inst u_attitude_cdc entrada_hud__parameterized0 work:entrada_hud__parameterized0:NOFILE -attr @cell(#1c1f28) entrada_hud__parameterized0 -pinAttr pronto @attr n/c -pinBusAttr dados @name dados[238:0] -pinBusAttr dados_destino @name dados_destino[238:0] -pg 1 -lvl 2 -x 430 -y 430
load inst u_simbologia simbologia_vga work:simbologia_vga:NOFILE -attr @cell(#1c1f28) simbologia_vga -pinBusAttr alvo_x @name alvo_x[9:0] -pinBusAttr alvo_y @name alvo_y[8:0] -pinBusAttr attitude_cosine @name attitude_cosine[15:0] -pinBusAttr attitude_pitch_px @name attitude_pitch_px[10:0] -pinBusAttr attitude_sine @name attitude_sine[15:0] -pinBusAttr flight_pixel_x @name flight_pixel_x[9:0] -pinBusAttr flight_pixel_y @name flight_pixel_y[9:0] -pinBusAttr heading_deg @name heading_deg[8:0] -pinBusAttr horizonte_y @name horizonte_y[9:0] -pinBusAttr pixel_x @name pixel_x[9:0] -pinBusAttr pixel_y @name pixel_y[9:0] -pinBusAttr roll_q8 @name roll_q8[9:0] -pg 1 -lvl 4 -x 1240 -y 90
load inst u_vga vga_controller work:vga_controller:NOFILE -attr @cell(#1c1f28) vga_controller -pinBusAttr pixel_x @name pixel_x[9:0] -pinBusAttr pixel_y @name pixel_y[9:0] -pg 1 -lvl 1 -x 120 -y 310
load net amostra_completa[12] -attr @rip dados_destino[12] -pin u_dados alvo_y_in[2] -pin u_entrada dados_destino[12]
load net amostra_completa[26] -attr @rip dados_destino[26] -pin u_dados mira_x_in[7] -pin u_entrada dados_destino[26]
load net amostra_completa[20] -attr @rip dados_destino[20] -pin u_dados mira_x_in[1] -pin u_entrada dados_destino[20]
load net amostra_completa[9] -attr @rip dados_destino[9] -pin u_dados alvo_x_in[9] -pin u_entrada dados_destino[9]
load net amostra_completa[60] -attr @rip dados_destino[60] -pin u_dados pitch_px_in[2] -pin u_entrada dados_destino[60]
load net horizonte_y[4] -attr @rip horizonte_y[4] -pin u_dados horizonte_y[4] -pin u_simbologia horizonte_y[4]
load net roll_q8[1] -attr @rip roll_q8[1] -pin u_dados roll_q8[1] -pin u_simbologia roll_q8[1]
load net roll_q8[6] -attr @rip roll_q8[6] -pin u_dados roll_q8[6] -pin u_simbologia roll_q8[6]
load net amostra_completa[117] -attr @rip dados_destino[117] -pin u_dados metadados_in[21] -pin u_entrada dados_destino[117]
load net amostra_completa[110] -attr @rip dados_destino[110] -pin u_dados metadados_in[14] -pin u_entrada dados_destino[110]
load net amostra_completa[103] -attr @rip dados_destino[103] -pin u_dados metadados_in[7] -pin u_entrada dados_destino[103]
load net amostra_completa[95] -attr @rip dados_destino[95] -pin u_dados velocidade_kt_in[9] -pin u_entrada dados_destino[95]
load net amostra_completa[125] -attr @rip dados_destino[125] -pin u_dados metadados_in[29] -pin u_entrada dados_destino[125]
load net amostra_completa[87] -attr @rip dados_destino[87] -pin u_dados velocidade_kt_in[1] -pin u_entrada dados_destino[87]
load net amostra_completa[35] -attr @rip dados_destino[35] -pin u_dados mira_y_in[6] -pin u_entrada dados_destino[35]
load net amostra_completa[36] -attr @rip dados_destino[36] -pin u_dados mira_y_in[7] -pin u_entrada dados_destino[36]
load net amostra_completa[44] -attr @rip dados_destino[44] -pin u_dados heading_deg_in[5] -pin u_entrada dados_destino[44]
load net alvo_x[4] -attr @rip alvo_x[4] -pin u_dados alvo_x[4] -pin u_simbologia alvo_x[4]
load net alvo_x[2] -attr @rip alvo_x[2] -pin u_dados alvo_x[2] -pin u_simbologia alvo_x[2]
load net alvo_x[8] -attr @rip alvo_x[8] -pin u_dados alvo_x[8] -pin u_simbologia alvo_x[8]
load net alvo_y[1] -attr @rip alvo_y[1] -pin u_dados alvo_y[1] -pin u_simbologia alvo_y[1]
load net heading_deg[1] -attr @style dashed -attr @rip heading_deg[1] -pin u_dados heading_deg[1] -pin u_simbologia heading_deg[1]
load net heading_deg[3] -attr @style dashed -attr @rip heading_deg[3] -pin u_dados heading_deg[3] -pin u_simbologia heading_deg[3]
load net pixel_x[4] -attr @style dashed -attr @rip pixel_x[4] -pin u_simbologia pixel_x[4] -pin u_vga pixel_x[4]
load net pixel_y[5] -attr @style dashed -attr @rip pixel_y[5] -pin u_simbologia pixel_y[5] -pin u_vga pixel_y[5]
load net amostra_completa[11] -attr @rip dados_destino[11] -pin u_dados alvo_y_in[1] -pin u_entrada dados_destino[11]
load net amostra_completa[25] -attr @rip dados_destino[25] -pin u_dados mira_x_in[6] -pin u_entrada dados_destino[25]
load net amostra_completa[19] -attr @rip dados_destino[19] -pin u_dados mira_x_in[0] -pin u_entrada dados_destino[19]
load net amostra_completa[32] -attr @rip dados_destino[32] -pin u_dados mira_y_in[3] -pin u_entrada dados_destino[32]
load net amostra_completa[56] -attr @rip dados_destino[56] -pin u_dados roll_q8_in[8] -pin u_entrada dados_destino[56]
load net horizonte_y[2] -attr @rip horizonte_y[2] -pin u_dados horizonte_y[2] -pin u_simbologia horizonte_y[2]
load net roll_q8[3] -attr @rip roll_q8[3] -pin u_dados roll_q8[3] -pin u_simbologia roll_q8[3]
load net amostra_completa[116] -attr @rip dados_destino[116] -pin u_dados metadados_in[20] -pin u_entrada dados_destino[116]
load net amostra_completa[102] -attr @rip dados_destino[102] -pin u_dados metadados_in[6] -pin u_entrada dados_destino[102]
load net amostra_completa[124] -attr @rip dados_destino[124] -pin u_dados metadados_in[28] -pin u_entrada dados_destino[124]
load net amostra_completa[94] -attr @rip dados_destino[94] -pin u_dados velocidade_kt_in[8] -pin u_entrada dados_destino[94]
load net amostra_completa[86] -attr @rip dados_destino[86] -pin u_dados velocidade_kt_in[0] -pin u_entrada dados_destino[86]
load net amostra_completa[43] -attr @rip dados_destino[43] -pin u_dados heading_deg_in[4] -pin u_entrada dados_destino[43]
load net amostra_completa[72] -attr @rip dados_destino[72] -pin u_dados altitude_ft_in[3] -pin u_entrada dados_destino[72]
load net amostra_completa[111] -attr @rip dados_destino[111] -pin u_dados metadados_in[15] -pin u_entrada dados_destino[111]
load net alvo_x[5] -attr @rip alvo_x[5] -pin u_dados alvo_x[5] -pin u_simbologia alvo_x[5]
load net alvo_x[7] -attr @rip alvo_x[7] -pin u_dados alvo_x[7] -pin u_simbologia alvo_x[7]
load net heading_deg[2] -attr @style dashed -attr @rip heading_deg[2] -pin u_dados heading_deg[2] -pin u_simbologia heading_deg[2]
load net horizonte_y[9] -attr @rip horizonte_y[9] -pin u_dados horizonte_y[9] -pin u_simbologia horizonte_y[9]
load net amostra_completa[0] -attr @rip dados_destino[0] -pin u_dados alvo_x_in[0] -pin u_entrada dados_destino[0]
load net pixel_x[5] -attr @style dashed -attr @rip pixel_x[5] -pin u_simbologia pixel_x[5] -pin u_vga pixel_x[5]
load net pixel_y[6] -attr @style dashed -attr @rip pixel_y[6] -pin u_simbologia pixel_y[6] -pin u_vga pixel_y[6]
load net amostra_completa[10] -attr @rip dados_destino[10] -pin u_dados alvo_y_in[0] -pin u_entrada dados_destino[10]
load net amostra_completa[18] -attr @rip dados_destino[18] -pin u_dados alvo_y_in[8] -pin u_entrada dados_destino[18]
load net amostra_completa[51] -attr @rip dados_destino[51] -pin u_dados roll_q8_in[3] -pin u_entrada dados_destino[51]
load net amostra_completa[62] -attr @rip dados_destino[62] -pin u_dados pitch_px_in[4] -pin u_entrada dados_destino[62]
load net amostra_completa[1] -attr @rip dados_destino[1] -pin u_dados alvo_x_in[1] -pin u_entrada dados_destino[1]
load net heading_deg[6] -attr @style dashed -attr @rip heading_deg[6] -pin u_dados heading_deg[6] -pin u_simbologia heading_deg[6]
load net roll_q8[0] -attr @rip roll_q8[0] -pin u_dados roll_q8[0] -pin u_simbologia roll_q8[0]
load net roll_q8[4] -attr @rip roll_q8[4] -pin u_dados roll_q8[4] -pin u_simbologia roll_q8[4]
load net amostra_completa[120] -attr @rip dados_destino[120] -pin u_dados metadados_in[24] -pin u_entrada dados_destino[120]
load net amostra_valida -pin u_dados dados_validos -pin u_entrada valido_destino
netloc amostra_valida 1 2 1 N 160
load net amostra_completa[97] -attr @rip dados_destino[97] -pin u_dados metadados_in[1] -pin u_entrada dados_destino[97]
load net amostra_completa[105] -attr @rip dados_destino[105] -pin u_dados metadados_in[9] -pin u_entrada dados_destino[105]
load net amostra_completa[66] -attr @rip dados_destino[66] -pin u_dados pitch_px_in[8] -pin u_entrada dados_destino[66]
load net amostra_completa[89] -attr @rip dados_destino[89] -pin u_dados velocidade_kt_in[3] -pin u_entrada dados_destino[89]
load net amostra_completa[81] -attr @rip dados_destino[81] -pin u_dados altitude_ft_in[12] -pin u_entrada dados_destino[81]
load net amostra_completa[79] -attr @rip dados_destino[79] -pin u_dados altitude_ft_in[10] -pin u_entrada dados_destino[79]
load net amostra_completa[67] -attr @rip dados_destino[67] -pin u_dados pitch_px_in[9] -pin u_entrada dados_destino[67]
load net amostra_completa[46] -attr @rip dados_destino[46] -pin u_dados heading_deg_in[7] -pin u_entrada dados_destino[46]
load net amostra_completa[38] -attr @rip dados_destino[38] -pin u_dados mira_lock_in -pin u_entrada dados_destino[38]
load net alvo_x[9] -attr @rip alvo_x[9] -pin u_dados alvo_x[9] -pin u_simbologia alvo_x[9]
load net alvo_y[2] -attr @rip alvo_y[2] -pin u_dados alvo_y[2] -pin u_simbologia alvo_y[2]
load net horizonte_y[5] -attr @rip horizonte_y[5] -pin u_dados horizonte_y[5] -pin u_simbologia horizonte_y[5]
load net pixel_x[6] -attr @style dashed -attr @rip pixel_x[6] -pin u_simbologia pixel_x[6] -pin u_vga pixel_x[6]
load net pixel_y[7] -attr @style dashed -attr @rip pixel_y[7] -pin u_simbologia pixel_y[7] -pin u_vga pixel_y[7]
load net video_on -attr @style dashed -pin u_simbologia video_on -pin u_vga video_on
netloc video_on 1 1 3 280J 540 NJ 540 1080
load net amostra_completa[31] -attr @rip dados_destino[31] -pin u_dados mira_y_in[2] -pin u_entrada dados_destino[31]
load net amostra_completa[24] -attr @rip dados_destino[24] -pin u_dados mira_x_in[5] -pin u_entrada dados_destino[24]
load net amostra_completa[17] -attr @rip dados_destino[17] -pin u_dados alvo_y_in[7] -pin u_entrada dados_destino[17]
load net amostra_completa[63] -attr @rip dados_destino[63] -pin u_dados pitch_px_in[5] -pin u_entrada dados_destino[63]
load net roll_q8[2] -attr @rip roll_q8[2] -pin u_dados roll_q8[2] -pin u_simbologia roll_q8[2]
load net amostra_completa[119] -attr @rip dados_destino[119] -pin u_dados metadados_in[23] -pin u_entrada dados_destino[119]
load net amostra_completa[104] -attr @rip dados_destino[104] -pin u_dados metadados_in[8] -pin u_entrada dados_destino[104]
load net amostra_completa[127] -attr @rip dados_destino[127] -pin u_dados metadados_in[31] -pin u_entrada dados_destino[127]
load net amostra_completa[96] -attr @rip dados_destino[96] -pin u_dados metadados_in[0] -pin u_entrada dados_destino[96]
load net amostra_completa[126] -attr @rip dados_destino[126] -pin u_dados metadados_in[30] -pin u_entrada dados_destino[126]
load net amostra_completa[34] -attr @rip dados_destino[34] -pin u_dados mira_y_in[5] -pin u_entrada dados_destino[34]
load net amostra_completa[73] -attr @rip dados_destino[73] -pin u_dados altitude_ft_in[4] -pin u_entrada dados_destino[73]
load net amostra_completa[88] -attr @rip dados_destino[88] -pin u_dados velocidade_kt_in[2] -pin u_entrada dados_destino[88]
load net amostra_completa[37] -attr @rip dados_destino[37] -pin u_dados mira_y_in[8] -pin u_entrada dados_destino[37]
load net amostra_completa[45] -attr @rip dados_destino[45] -pin u_dados heading_deg_in[6] -pin u_entrada dados_destino[45]
load net alvo_x[1] -attr @rip alvo_x[1] -pin u_dados alvo_x[1] -pin u_simbologia alvo_x[1]
load net alvo_y[7] -attr @rip alvo_y[7] -pin u_dados alvo_y[7] -pin u_simbologia alvo_y[7]
load net heading_deg[4] -attr @style dashed -attr @rip heading_deg[4] -pin u_dados heading_deg[4] -pin u_simbologia heading_deg[4]
load net heading_deg[5] -attr @style dashed -attr @rip heading_deg[5] -pin u_dados heading_deg[5] -pin u_simbologia heading_deg[5]
load net pixel_x[3] -attr @style dashed -attr @rip pixel_x[3] -pin u_simbologia pixel_x[3] -pin u_vga pixel_x[3]
load net pixel_x[7] -attr @style dashed -attr @rip pixel_x[7] -pin u_simbologia pixel_x[7] -pin u_vga pixel_x[7]
load net pixel_y[1] -attr @style dashed -attr @rip pixel_y[1] -pin u_simbologia pixel_y[1] -pin u_vga pixel_y[1]
load net pixel_y[8] -attr @style dashed -attr @rip pixel_y[8] -pin u_simbologia pixel_y[8] -pin u_vga pixel_y[8]
load net amostra_completa[30] -attr @rip dados_destino[30] -pin u_dados mira_y_in[1] -pin u_entrada dados_destino[30]
load net amostra_completa[16] -attr @rip dados_destino[16] -pin u_dados alvo_y_in[6] -pin u_entrada dados_destino[16]
load net amostra_completa[8] -attr @rip dados_destino[8] -pin u_dados alvo_x_in[8] -pin u_entrada dados_destino[8]
load net clk_hud -attr @style dashed -pin u_attitude_cdc clk_origem -pin u_entrada clk_origem -pin u_vga clk_100mhz
netloc clk_hud 1 0 2 20 260 320
load net amostra_completa[3] -attr @rip dados_destino[3] -pin u_dados alvo_x_in[3] -pin u_entrada dados_destino[3]
load net amostra_completa[54] -attr @rip dados_destino[54] -pin u_dados roll_q8_in[6] -pin u_entrada dados_destino[54]
load net amostra_completa[59] -attr @rip dados_destino[59] -pin u_dados pitch_px_in[1] -pin u_entrada dados_destino[59]
load net amostra_completa[5] -attr @rip dados_destino[5] -pin u_dados alvo_x_in[5] -pin u_entrada dados_destino[5]
load net heading_deg[8] -attr @style dashed -attr @rip heading_deg[8] -pin u_dados heading_deg[8] -pin u_simbologia heading_deg[8]
load net horizonte_y[3] -attr @rip horizonte_y[3] -pin u_dados horizonte_y[3] -pin u_simbologia horizonte_y[3]
load net roll_q8[8] -attr @rip roll_q8[8] -pin u_dados roll_q8[8] -pin u_simbologia roll_q8[8]
load net amostra_completa[121] -attr @rip dados_destino[121] -pin u_dados metadados_in[25] -pin u_entrada dados_destino[121]
load net amostra_completa[113] -attr @rip dados_destino[113] -pin u_dados metadados_in[17] -pin u_entrada dados_destino[113]
load net amostra_completa[107] -attr @rip dados_destino[107] -pin u_dados metadados_in[11] -pin u_entrada dados_destino[107]
load net amostra_completa[99] -attr @rip dados_destino[99] -pin u_dados metadados_in[3] -pin u_entrada dados_destino[99]
load net amostra_completa[83] -attr @rip dados_destino[83] -pin u_dados altitude_ft_in[14] -pin u_entrada dados_destino[83]
load net amostra_completa[76] -attr @rip dados_destino[76] -pin u_dados altitude_ft_in[7] -pin u_entrada dados_destino[76]
load net amostra_completa[91] -attr @rip dados_destino[91] -pin u_dados velocidade_kt_in[5] -pin u_entrada dados_destino[91]
load net amostra_completa[69] -attr @rip dados_destino[69] -pin u_dados altitude_ft_in[0] -pin u_entrada dados_destino[69]
load net amostra_completa[40] -attr @rip dados_destino[40] -pin u_dados heading_deg_in[1] -pin u_entrada dados_destino[40]
load net amostra_completa[48] -attr @rip dados_destino[48] -pin u_dados roll_q8_in[0] -pin u_entrada dados_destino[48]
load net alvo_y[0] -attr @rip alvo_y[0] -pin u_dados alvo_y[0] -pin u_simbologia alvo_y[0]
load net alvo_y[5] -attr @rip alvo_y[5] -pin u_dados alvo_y[5] -pin u_simbologia alvo_y[5]
load net alvo_y[6] -attr @rip alvo_y[6] -pin u_dados alvo_y[6] -pin u_simbologia alvo_y[6]
load net horizonte_y[7] -attr @rip horizonte_y[7] -pin u_dados horizonte_y[7] -pin u_simbologia horizonte_y[7]
load net pixel_x[8] -attr @style dashed -attr @rip pixel_x[8] -pin u_simbologia pixel_x[8] -pin u_vga pixel_x[8]
load net pixel_y[2] -attr @style dashed -attr @rip pixel_y[2] -pin u_simbologia pixel_y[2] -pin u_vga pixel_y[2]
load net pixel_y[9] -attr @style dashed -attr @rip pixel_y[9] -pin u_simbologia pixel_y[9] -pin u_vga pixel_y[9]
load net amostra_completa[29] -attr @rip dados_destino[29] -pin u_dados mira_y_in[0] -pin u_entrada dados_destino[29]
load net amostra_completa[23] -attr @rip dados_destino[23] -pin u_dados mira_x_in[4] -pin u_entrada dados_destino[23]
load net amostra_completa[15] -attr @rip dados_destino[15] -pin u_dados alvo_y_in[5] -pin u_entrada dados_destino[15]
load net amostra_completa[7] -attr @rip dados_destino[7] -pin u_dados alvo_x_in[7] -pin u_entrada dados_destino[7]
load net amostra_completa[4] -attr @rip dados_destino[4] -pin u_dados alvo_x_in[4] -pin u_entrada dados_destino[4]
load net amostra_completa[50] -attr @rip dados_destino[50] -pin u_dados roll_q8_in[2] -pin u_entrada dados_destino[50]
load net amostra_completa[55] -attr @rip dados_destino[55] -pin u_dados roll_q8_in[7] -pin u_entrada dados_destino[55]
load net amostra_completa[61] -attr @rip dados_destino[61] -pin u_dados pitch_px_in[3] -pin u_entrada dados_destino[61]
load net heading_deg[7] -attr @style dashed -attr @rip heading_deg[7] -pin u_dados heading_deg[7] -pin u_simbologia heading_deg[7]
load net roll_q8[5] -attr @rip roll_q8[5] -pin u_dados roll_q8[5] -pin u_simbologia roll_q8[5]
load net roll_q8[7] -attr @rip roll_q8[7] -pin u_dados roll_q8[7] -pin u_simbologia roll_q8[7]
load net amostra_completa[82] -attr @rip dados_destino[82] -pin u_dados altitude_ft_in[13] -pin u_entrada dados_destino[82]
load net amostra_completa[118] -attr @rip dados_destino[118] -pin u_dados metadados_in[22] -pin u_entrada dados_destino[118]
load net amostra_completa[112] -attr @rip dados_destino[112] -pin u_dados metadados_in[16] -pin u_entrada dados_destino[112]
load net amostra_completa[106] -attr @rip dados_destino[106] -pin u_dados metadados_in[10] -pin u_entrada dados_destino[106]
load net amostra_completa[98] -attr @rip dados_destino[98] -pin u_dados metadados_in[2] -pin u_entrada dados_destino[98]
load net amostra_completa[33] -attr @rip dados_destino[33] -pin u_dados mira_y_in[4] -pin u_entrada dados_destino[33]
load net amostra_completa[80] -attr @rip dados_destino[80] -pin u_dados altitude_ft_in[11] -pin u_entrada dados_destino[80]
load net amostra_completa[90] -attr @rip dados_destino[90] -pin u_dados velocidade_kt_in[4] -pin u_entrada dados_destino[90]
load net amostra_completa[68] -attr @rip dados_destino[68] -pin u_dados pitch_px_in[10] -pin u_entrada dados_destino[68]
load net amostra_completa[47] -attr @rip dados_destino[47] -pin u_dados heading_deg_in[8] -pin u_entrada dados_destino[47]
load net amostra_completa[39] -attr @rip dados_destino[39] -pin u_dados heading_deg_in[0] -pin u_entrada dados_destino[39]
load net heading_deg[0] -attr @style dashed -attr @rip heading_deg[0] -pin u_dados heading_deg[0] -pin u_simbologia heading_deg[0]
load net horizonte_y[6] -attr @rip horizonte_y[6] -pin u_dados horizonte_y[6] -pin u_simbologia horizonte_y[6]
load net pixel_x[1] -attr @style dashed -attr @rip pixel_x[1] -pin u_simbologia pixel_x[1] -pin u_vga pixel_x[1]
load net pixel_y[0] -attr @style dashed -attr @rip pixel_y[0] -pin u_simbologia pixel_y[0] -pin u_vga pixel_y[0]
load net amostra_completa[22] -attr @rip dados_destino[22] -pin u_dados mira_x_in[3] -pin u_entrada dados_destino[22]
load net amostra_completa[28] -attr @rip dados_destino[28] -pin u_dados mira_x_in[9] -pin u_entrada dados_destino[28]
load net amostra_completa[14] -attr @rip dados_destino[14] -pin u_dados alvo_y_in[4] -pin u_entrada dados_destino[14]
load net amostra_completa[6] -attr @rip dados_destino[6] -pin u_dados alvo_x_in[6] -pin u_entrada dados_destino[6]
load net amostra_completa[52] -attr @rip dados_destino[52] -pin u_dados roll_q8_in[4] -pin u_entrada dados_destino[52]
load net amostra_completa[57] -attr @rip dados_destino[57] -pin u_dados roll_q8_in[9] -pin u_entrada dados_destino[57]
load net horizonte_y[0] -attr @rip horizonte_y[0] -pin u_dados horizonte_y[0] -pin u_simbologia horizonte_y[0]
load net horizonte_y[1] -attr @rip horizonte_y[1] -pin u_dados horizonte_y[1] -pin u_simbologia horizonte_y[1]
load net amostra_completa[93] -attr @rip dados_destino[93] -pin u_dados velocidade_kt_in[7] -pin u_entrada dados_destino[93]
load net amostra_completa[123] -attr @rip dados_destino[123] -pin u_dados metadados_in[27] -pin u_entrada dados_destino[123]
load net amostra_completa[101] -attr @rip dados_destino[101] -pin u_dados metadados_in[5] -pin u_entrada dados_destino[101]
load net amostra_completa[115] -attr @rip dados_destino[115] -pin u_dados metadados_in[19] -pin u_entrada dados_destino[115]
load net amostra_completa[109] -attr @rip dados_destino[109] -pin u_dados metadados_in[13] -pin u_entrada dados_destino[109]
load net amostra_completa[74] -attr @rip dados_destino[74] -pin u_dados altitude_ft_in[5] -pin u_entrada dados_destino[74]
load net amostra_completa[85] -attr @rip dados_destino[85] -pin u_dados altitude_ft_in[16] -pin u_entrada dados_destino[85]
load net amostra_completa[78] -attr @rip dados_destino[78] -pin u_dados altitude_ft_in[9] -pin u_entrada dados_destino[78]
load net amostra_completa[71] -attr @rip dados_destino[71] -pin u_dados altitude_ft_in[2] -pin u_entrada dados_destino[71]
load net amostra_completa[42] -attr @rip dados_destino[42] -pin u_dados heading_deg_in[3] -pin u_entrada dados_destino[42]
load net amostra_completa[65] -attr @rip dados_destino[65] -pin u_dados pitch_px_in[7] -pin u_entrada dados_destino[65]
load net alvo_x[3] -attr @rip alvo_x[3] -pin u_dados alvo_x[3] -pin u_simbologia alvo_x[3]
load net alvo_x[6] -attr @rip alvo_x[6] -pin u_dados alvo_x[6] -pin u_simbologia alvo_x[6]
load net alvo_y[3] -attr @rip alvo_y[3] -pin u_dados alvo_y[3] -pin u_simbologia alvo_y[3]
load net alvo_y[8] -attr @rip alvo_y[8] -pin u_dados alvo_y[8] -pin u_simbologia alvo_y[8]
load net pixel_x[2] -attr @style dashed -attr @rip pixel_x[2] -pin u_simbologia pixel_x[2] -pin u_vga pixel_x[2]
load net pixel_x[9] -attr @style dashed -attr @rip pixel_x[9] -pin u_simbologia pixel_x[9] -pin u_vga pixel_x[9]
load net pixel_y[3] -attr @style dashed -attr @rip pixel_y[3] -pin u_simbologia pixel_y[3] -pin u_vga pixel_y[3]
load net amostra_completa[21] -attr @rip dados_destino[21] -pin u_dados mira_x_in[2] -pin u_entrada dados_destino[21]
load net amostra_completa[13] -attr @rip dados_destino[13] -pin u_dados alvo_y_in[3] -pin u_entrada dados_destino[13]
load net amostra_completa[27] -attr @rip dados_destino[27] -pin u_dados mira_x_in[8] -pin u_entrada dados_destino[27]
load net amostra_completa[2] -attr @rip dados_destino[2] -pin u_dados alvo_x_in[2] -pin u_entrada dados_destino[2]
load net amostra_completa[64] -attr @rip dados_destino[64] -pin u_dados pitch_px_in[6] -pin u_entrada dados_destino[64]
load net amostra_completa[53] -attr @rip dados_destino[53] -pin u_dados roll_q8_in[5] -pin u_entrada dados_destino[53]
load net amostra_completa[58] -attr @rip dados_destino[58] -pin u_dados pitch_px_in[0] -pin u_entrada dados_destino[58]
load net roll_q8[9] -attr @rip roll_q8[9] -pin u_dados roll_q8[9] -pin u_simbologia roll_q8[9]
load net amostra_completa[84] -attr @rip dados_destino[84] -pin u_dados altitude_ft_in[15] -pin u_entrada dados_destino[84]
load net amostra_completa[122] -attr @rip dados_destino[122] -pin u_dados metadados_in[26] -pin u_entrada dados_destino[122]
load net amostra_completa[100] -attr @rip dados_destino[100] -pin u_dados metadados_in[4] -pin u_entrada dados_destino[100]
load net amostra_completa[114] -attr @rip dados_destino[114] -pin u_dados metadados_in[18] -pin u_entrada dados_destino[114]
load net amostra_completa[108] -attr @rip dados_destino[108] -pin u_dados metadados_in[12] -pin u_entrada dados_destino[108]
load net amostra_completa[70] -attr @rip dados_destino[70] -pin u_dados altitude_ft_in[1] -pin u_entrada dados_destino[70]
load net amostra_completa[77] -attr @rip dados_destino[77] -pin u_dados altitude_ft_in[8] -pin u_entrada dados_destino[77]
load net amostra_completa[75] -attr @rip dados_destino[75] -pin u_dados altitude_ft_in[6] -pin u_entrada dados_destino[75]
load net amostra_completa[92] -attr @rip dados_destino[92] -pin u_dados velocidade_kt_in[6] -pin u_entrada dados_destino[92]
load net amostra_completa[41] -attr @rip dados_destino[41] -pin u_dados heading_deg_in[2] -pin u_entrada dados_destino[41]
load net amostra_completa[49] -attr @rip dados_destino[49] -pin u_dados roll_q8_in[1] -pin u_entrada dados_destino[49]
load net alvo_x[0] -attr @rip alvo_x[0] -pin u_dados alvo_x[0] -pin u_simbologia alvo_x[0]
load net alvo_y[4] -attr @rip alvo_y[4] -pin u_dados alvo_y[4] -pin u_simbologia alvo_y[4]
load net horizonte_y[8] -attr @rip horizonte_y[8] -pin u_dados horizonte_y[8] -pin u_simbologia horizonte_y[8]
load net pixel_clk -attr @style dashed -pin u_attitude_cdc clk_destino -pin u_dados clk -pin u_entrada clk_destino -pin u_vga pixel_clk
netloc pixel_clk 1 1 2 300 220 650
load net pixel_x[0] -attr @style dashed -attr @rip pixel_x[0] -pin u_simbologia pixel_x[0] -pin u_vga pixel_x[0]
load net pixel_y[4] -attr @style dashed -attr @rip pixel_y[4] -pin u_simbologia pixel_y[4] -pin u_vga pixel_y[4]
load netBundle @amostra_completa 128 amostra_completa[127] amostra_completa[126] amostra_completa[125] amostra_completa[124] amostra_completa[123] amostra_completa[122] amostra_completa[121] amostra_completa[120] amostra_completa[119] amostra_completa[118] amostra_completa[117] amostra_completa[116] amostra_completa[115] amostra_completa[114] amostra_completa[113] amostra_completa[112] amostra_completa[111] amostra_completa[110] amostra_completa[109] amostra_completa[108] amostra_completa[107] amostra_completa[106] amostra_completa[105] amostra_completa[104] amostra_completa[103] amostra_completa[102] amostra_completa[101] amostra_completa[100] amostra_completa[99] amostra_completa[98] amostra_completa[97] amostra_completa[96] amostra_completa[95] amostra_completa[94] amostra_completa[93] amostra_completa[92] amostra_completa[91] amostra_completa[90] amostra_completa[89] amostra_completa[88] amostra_completa[87] amostra_completa[86] amostra_completa[85] amostra_completa[84] amostra_completa[83] amostra_completa[82] amostra_completa[81] amostra_completa[80] amostra_completa[79] amostra_completa[78] amostra_completa[77] amostra_completa[76] amostra_completa[75] amostra_completa[74] amostra_completa[73] amostra_completa[72] amostra_completa[71] amostra_completa[70] amostra_completa[69] amostra_completa[68] amostra_completa[67] amostra_completa[66] amostra_completa[65] amostra_completa[64] amostra_completa[63] amostra_completa[62] amostra_completa[61] amostra_completa[60] amostra_completa[59] amostra_completa[58] amostra_completa[57] amostra_completa[56] amostra_completa[55] amostra_completa[54] amostra_completa[53] amostra_completa[52] amostra_completa[51] amostra_completa[50] amostra_completa[49] amostra_completa[48] amostra_completa[47] amostra_completa[46] amostra_completa[45] amostra_completa[44] amostra_completa[43] amostra_completa[42] amostra_completa[41] amostra_completa[40] amostra_completa[39] amostra_completa[38] amostra_completa[37] amostra_completa[36] amostra_completa[35] amostra_completa[34] amostra_completa[33] amostra_completa[32] amostra_completa[31] amostra_completa[30] amostra_completa[29] amostra_completa[28] amostra_completa[27] amostra_completa[26] amostra_completa[25] amostra_completa[24] amostra_completa[23] amostra_completa[22] amostra_completa[21] amostra_completa[20] amostra_completa[19] amostra_completa[18] amostra_completa[17] amostra_completa[16] amostra_completa[15] amostra_completa[14] amostra_completa[13] amostra_completa[12] amostra_completa[11] amostra_completa[10] amostra_completa[9] amostra_completa[8] amostra_completa[7] amostra_completa[6] amostra_completa[5] amostra_completa[4] amostra_completa[3] amostra_completa[2] amostra_completa[1] amostra_completa[0] -autobundled
netbloc @amostra_completa 1 2 1 670 60n
load netBundle @alvo_x 10 alvo_x[9] alvo_x[8] alvo_x[7] alvo_x[6] alvo_x[5] alvo_x[4] alvo_x[3] alvo_x[2] alvo_x[1] alvo_x[0] -autobundled
netbloc @alvo_x 1 3 1 N 100
load netBundle @alvo_y 9 alvo_y[8] alvo_y[7] alvo_y[6] alvo_y[5] alvo_y[4] alvo_y[3] alvo_y[2] alvo_y[1] alvo_y[0] -autobundled
netbloc @alvo_y 1 3 1 N 120
load netBundle @heading_deg 9 heading_deg[8] heading_deg[7] heading_deg[6] heading_deg[5] heading_deg[4] heading_deg[3] heading_deg[2] heading_deg[1] heading_deg[0] -autobundled -attr @style dashed
netbloc @heading_deg 1 3 1 1060 140n
load netBundle @horizonte_y 10 horizonte_y[9] horizonte_y[8] horizonte_y[7] horizonte_y[6] horizonte_y[5] horizonte_y[4] horizonte_y[3] horizonte_y[2] horizonte_y[1] horizonte_y[0] -autobundled
netbloc @horizonte_y 1 3 1 1040 160n
load netBundle @roll_q8 10 roll_q8[9] roll_q8[8] roll_q8[7] roll_q8[6] roll_q8[5] roll_q8[4] roll_q8[3] roll_q8[2] roll_q8[1] roll_q8[0] -autobundled
netbloc @roll_q8 1 3 1 1020 260n
load netBundle @pixel_x 10 pixel_x[9] pixel_x[8] pixel_x[7] pixel_x[6] pixel_x[5] pixel_x[4] pixel_x[3] pixel_x[2] pixel_x[1] pixel_x[0] -autobundled -attr @style dashed
netbloc @pixel_x 1 1 3 NJ 360 NJ 360 1040
load netBundle @pixel_y 10 pixel_y[9] pixel_y[8] pixel_y[7] pixel_y[6] pixel_y[5] pixel_y[4] pixel_y[3] pixel_y[2] pixel_y[1] pixel_y[0] -autobundled -attr @style dashed
netbloc @pixel_y 1 1 3 NJ 380 NJ 380 1060
levelinfo -pg 1 0 120 430 820 1240 1440
pagesize -pg 1 -db -bbox -sgen 0 0 1440 550
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
