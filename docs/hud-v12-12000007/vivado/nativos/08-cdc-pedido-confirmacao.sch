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
load symbol entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE HIERBOX pin amostra_valida output.right pin clk_hud input.left pin dados_destino_reg[10]_0 output.right pin dados_destino_reg[11]_0 output.right pin dados_destino_reg[12]_0 output.right pin dados_destino_reg[16]_0 output.right pin dados_destino_reg[17]_0 output.right pin dados_destino_reg[18]_0 output.right pin dados_destino_reg[18]_1 output.right pin dados_destino_reg[4]_0 output.right pin dados_destino_reg[4]_1 output.right pin dados_destino_reg[4]_2 output.right pin dados_destino_reg[4]_3 output.right pin dados_destino_reg[4]_4 output.right pin dados_destino_reg[4]_5 output.right pin dados_destino_reg[4]_6 output.right pin dados_destino_reg[4]_7 output.right pin pixel_clk input.left pinBus D output.right [1:0] pinBus Q output.right [71:0] pinBus SR output.right [0:0] pinBus dados_destino_reg[17]_1 output.right [1:0] pinBus dados_destino_reg[80]_0 output.right [0:0] pinBus retido_reg[121]_0 input.left [90:0] pinBus valido_destino_reg_0 output.right [0:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol FDRE hdi_primitives GEN pin Q output.right pin C input.clk.left pin CE input.left pin D input.left pin R input.left fillcolor 1
load inst u_entrada entrada_hud__parameterized2 work:entrada_hud__parameterized2:NOFILE -autohide -attr @cell(#1c1f28) entrada_hud__parameterized2 -attr @fillcolor #ffffff -pinBusAttr D @name D[1:0] -pinBusAttr Q @name Q[71:0] -pinBusAttr SR @name SR -pinBusAttr dados_destino_reg[17]_1 @name dados_destino_reg[17]_1[1:0] -pinBusAttr dados_destino_reg[80]_0 @name dados_destino_reg[80]_0 -pinBusAttr retido_reg[121]_0 @name retido_reg[121]_0[90:0] -pinBusAttr valido_destino_reg_0 @name valido_destino_reg_0 -pg 1 -lvl 1 -x 70 -y 60
load inst u_entrada|confirmado_meta_reg FDRE hdi_primitives -hier u_entrada -attr @name confirmado_meta_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 5 -x 850 -y 120
load inst u_entrada|confirmado_reg FDRE hdi_primitives -hier u_entrada -attr @name confirmado_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 4 -x 670 -y 130
load inst u_entrada|confirmado_sync_reg FDRE hdi_primitives -hier u_entrada -attr @name confirmado_sync_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 6 -x 1050 -y 110
load inst u_entrada|pedido_meta_reg FDRE hdi_primitives -hier u_entrada -attr @name pedido_meta_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 2 -x 320 -y 150
load inst u_entrada|pedido_reg FDRE hdi_primitives -hier u_entrada -attr @name pedido_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 1 -x 140 -y 120
load inst u_entrada|pedido_sync_reg FDRE hdi_primitives -hier u_entrada -attr @name pedido_sync_reg -attr @cell(#1c1f28) FDRE -pg 1 -lvl 3 -x 500 -y 140
load net u_entrada|confirmado_meta -attr @name confirmado_meta -pin u_entrada|confirmado_meta_reg Q -pin u_entrada|confirmado_sync_reg D
netloc u_entrada|confirmado_meta 1 5 1 N 120
load net u_entrada|clk_hud -attr @style dashed -attr @name clk_hud -hierPin u_entrada clk_hud -pin u_entrada|confirmado_meta_reg C -pin u_entrada|confirmado_sync_reg C -pin u_entrada|pedido_reg C
netloc u_entrada|clk_hud 1 0 6 100 40 NJ 40 NJ 40 NJ 40 780 40 980
load net u_entrada|confirmado -attr @style dashed -attr @name confirmado -pin u_entrada|confirmado_meta_reg D -pin u_entrada|confirmado_reg Q
netloc u_entrada|confirmado 1 4 1 N 130
load net u_entrada|pixel_clk -attr @style dashed -attr @name pixel_clk -hierPin u_entrada pixel_clk -pin u_entrada|confirmado_reg C -pin u_entrada|pedido_meta_reg C -pin u_entrada|pedido_sync_reg C
netloc u_entrada|pixel_clk 1 0 4 NJ 200 260 70 440 60 620
load net u_entrada|pedido_sync -attr @style dashed -attr @name pedido_sync -pin u_entrada|confirmado_reg D -pin u_entrada|pedido_sync_reg Q
netloc u_entrada|pedido_sync 1 3 1 N 140
load net u_entrada|pedido_meta -attr @name pedido_meta -pin u_entrada|pedido_meta_reg Q -pin u_entrada|pedido_sync_reg D
netloc u_entrada|pedido_meta 1 2 1 N 150
load net u_entrada|pedido -attr @style dashed -attr @name pedido -pin u_entrada|pedido_meta_reg D -pin u_entrada|pedido_reg Q
netloc u_entrada|pedido 1 1 1 240 120n
levelinfo -pg 1 0 70 1180
levelinfo -hier u_entrada * 140 320 500 670 850 1050 *
pagesize -pg 1 -db -bbox -sgen 0 0 1180 260
pagesize -hier u_entrada -db -bbox -sgen 70 30 1170 230
show
fullfit
#
# initialize ictrl to current module top_reticula work:top_reticula:NOFILE
ictrl init topinfo |
