# Bundled-data dos novos mailboxes: retido ate ACK, dois estagios no pedido.
set_max_delay -datapath_only 20.000 -from [get_cells -hier -filter {NAME =~ u_attitude_cdc/retido_reg* || NAME =~ u_video_diag_cdc/retido_reg*}] -to [get_cells -hier -filter {NAME =~ u_attitude_cdc/dados_destino_reg* || NAME =~ u_video_diag_cdc/dados_destino_reg*}]
set_bus_skew 10.000 -from [get_cells -hier -filter {NAME =~ u_attitude_cdc/retido_reg* || NAME =~ u_video_diag_cdc/retido_reg*}] -to [get_cells -hier -filter {NAME =~ u_attitude_cdc/dados_destino_reg* || NAME =~ u_video_diag_cdc/dados_destino_reg*}]
set_false_path -from [get_cells -hier -filter {NAME == u_attitude_cdc/pedido_reg || NAME == u_video_diag_cdc/pedido_reg}] -to [get_pins -hier -filter {NAME == u_attitude_cdc/pedido_meta_reg/D || NAME == u_video_diag_cdc/pedido_meta_reg/D}]
set_false_path -from [get_cells -hier -filter {NAME == u_attitude_cdc/confirmado_reg || NAME == u_video_diag_cdc/confirmado_reg}] -to [get_pins -hier -filter {NAME == u_attitude_cdc/confirmado_meta_reg/D || NAME == u_video_diag_cdc/confirmado_meta_reg/D}]
# Entradas fisicas: somente primeiro estagio, sem excluir logica funcional.
set_false_path -from [get_ports VIDEO_TOGGLE_BUTTON] -to [get_pins -hier -filter {NAME == u_capture_control/button_meta_reg/D}]
set_false_path -from [get_ports {SD_DIAG_PAGE[*]}] -to [get_pins -hier -filter {NAME =~ u_capture_control/page_meta_reg*/D}]
