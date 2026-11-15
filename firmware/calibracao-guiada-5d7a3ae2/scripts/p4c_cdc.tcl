# UG903: 8 ns < menor periodo (10 ns); sem false paths entre os dominios.
proc p4c_required {label objects} {
    if {[llength $objects] == 0} {error "P4C: objeto ausente: $label"}
    puts "P4C_OBJECT $label [llength $objects]"
    return $objects
}
# As FIFOs XPM carregam as constraints CDC oficiais da macro.
foreach signal {ui_ready ui_done_toggle src_busy} meta {ui_ready_meta ui_done_meta src_busy_meta} {
    set s [p4c_required $signal [get_cells -hier -filter "NAME =~ *u_mirror/${signal}_reg"]]
    set d [p4c_required $meta [get_pins -hier -filter "NAME =~ *u_mirror/${meta}_reg/D"]]
    set_max_delay 8.000 -datapath_only -from $s -to $d
}

set joystick [get_cells -hier -filter {NAME =~ *u_joystick_cdc/retido_reg*}]
if {[llength $joystick] != 0} {
    set dest [p4c_required joystick_data_dest [get_pins -hier -filter {NAME =~ *u_joystick_cdc/dados_destino_reg*/D}]]
    set_max_delay 8.000 -datapath_only -from $joystick -to $dest
    set_bus_skew 8.000 -from $joystick -to $dest
    foreach source {pedido confirmado} meta {pedido_meta confirmado_meta} {
        set s [p4c_required joystick_$source [get_cells -hier -filter "NAME =~ *u_joystick_cdc/${source}_reg"]]
        set d [p4c_required joystick_$meta [get_pins -hier -filter "NAME =~ *u_joystick_cdc/${meta}_reg/D"]]
        set_max_delay 8.000 -datapath_only -from $s -to $d
    }
}

# Somente os PRE dos sincronizadores de reset: a desativacao chega
# assincrona; cinco estagios locais fazem a liberacao sincronizada.
# Os caminhos dos reset_pipe/Q para os registradores funcionais ficam temporizados.
set reset_regs [p4c_required mirror_reset_sync [get_cells -hier -filter {NAME =~ *u_mirror/src_reset_pipe_reg* || NAME =~ *u_mirror/ui_reset_pipe_reg*}]]
if {[llength $reset_regs] != 10} {error "Esperados dez estagios de reset"}
foreach cell $reset_regs {
    if {![get_property ASYNC_REG $cell]} {error "Reset sem ASYNC_REG: $cell"}
}
set reset_pre [p4c_required mirror_reset_pre [get_pins -of_objects $reset_regs -filter {REF_PIN_NAME == PRE}]]
if {[llength $reset_pre] != 10} {error "PRE dos resets nao identificado"}
set_false_path -to $reset_pre

# Flag de validade XADC: somente o primeiro estagio do sincronizador.
set vs [get_cells -hier -filter {NAME == u_joystick_xadc/temperature_valid_reg}]
set vd [get_pins -hier -filter {NAME == g_xadc_fast.temperature_valid_meta_reg/D}]
if {[llength $vd] != 0} {
    p4c_required temperature_valid_source $vs
    set_max_delay 8.000 -datapath_only -from $vs -to $vd
}
