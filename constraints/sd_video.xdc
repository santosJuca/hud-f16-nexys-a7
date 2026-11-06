# BTNL assincrono: somente D do primeiro estagio do sincronizador.
set_false_path -from [get_ports VIDEO_TOGGLE_BUTTON] -to [get_pins -hier -filter {NAME =~ *button_meta_reg/D}]
