# UG903: 8 ns < menor periodo (10 ns); sem false paths entre os dominios.
proc p4c_required {label objects} {
    if {[llength $objects] == 0} {error "P4C: objeto ausente: $label"}
    puts "P4C_OBJECT $label [llength $objects]"
    return $objects
}
foreach pointer {wgray rgray} {
    set s [p4c_required $pointer [get_cells -hier -filter "NAME =~ *u_fifo/${pointer}_reg*"]]
    set d [p4c_required ${pointer}_meta [get_pins -hier -filter "NAME =~ *u_fifo/${pointer}_meta_reg*/D"]]
    set_max_delay 8.000 -datapath_only -from $s -to $d
    set_bus_skew 8.000 -from $s -to $d
}
foreach signal {ui_ready ui_done_toggle} meta {ui_ready_meta ui_done_meta} {
    set s [p4c_required $signal [get_cells -hier -filter "NAME =~ *u_mirror/${signal}_reg"]]
    set d [p4c_required $meta [get_pins -hier -filter "NAME =~ *u_mirror/${meta}_reg/D"]]
    set_max_delay 8.000 -datapath_only -from $s -to $d
}
# O payload permanece retido ate o ponteiro Gray atravessar dois estagios.
# Limita os caminhos de dados da LUTRAM ao dominio de leitura, sem corta-los.
set mem [p4c_required fifo_memory [get_cells -hier -filter {NAME =~ *u_fifo/mem_reg*}]]
set ui [p4c_required ui_clock [get_clocks clk_pll_i]]
set_max_delay 8.000 -datapath_only -from $mem -to $ui

set output_fifo [get_cells -hier -filter {NAME =~ *u_output_fifo/wgray_reg*}]
if {[llength $output_fifo] != 0} {
    foreach pointer {wgray rgray} {
        set s [p4c_required output_$pointer [get_cells -hier -filter "NAME =~ *u_output_fifo/${pointer}_reg*"]]
        set d [p4c_required output_${pointer}_meta [get_pins -hier -filter "NAME =~ *u_output_fifo/${pointer}_meta_reg*/D"]]
        set_max_delay 8.000 -datapath_only -from $s -to $d
        set_bus_skew 8.000 -from $s -to $d
    }
    set mem [p4c_required output_memory [get_cells -hier -filter {NAME =~ *u_output_fifo/mem_reg*}]]
    set hudclk [p4c_required hud_clock [get_clocks u_ui_test/u_mig/sys_clk_i]]
    set_max_delay 8.000 -datapath_only -from $mem -to $hudclk
    set s [p4c_required source_busy [get_cells -hier -filter {NAME =~ *u_mirror/src_busy_reg}]]
    set d [p4c_required source_busy_meta [get_pins -hier -filter {NAME =~ *u_mirror/src_busy_meta_reg/D}]]
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
# assincrona; dois estagios locais fazem a liberacao sincronizada.
# Os caminhos dos reset_pipe/Q para os registradores funcionais ficam temporizados.
set reset_regs [p4c_required mirror_reset_sync [get_cells -hier -filter {NAME =~ *u_mirror/src_reset_pipe_reg* || NAME =~ *u_mirror/ui_reset_pipe_reg*}]]
if {[llength $reset_regs] != 4} {error "Esperados quatro estagios de reset"}
foreach cell $reset_regs {
    if {![get_property ASYNC_REG $cell]} {error "Reset sem ASYNC_REG: $cell"}
}
set reset_pre [p4c_required mirror_reset_pre [get_pins -of_objects $reset_regs -filter {REF_PIN_NAME == PRE}]]
if {[llength $reset_pre] != 4} {error "PRE dos resets nao identificado"}
set_false_path -to $reset_pre

# Flag de validade XADC: somente o primeiro estagio do sincronizador.
set vs [get_cells -hier -filter {NAME == u_joystick_xadc/temperature_valid_reg}]
set vd [get_pins -hier -filter {NAME == g_xadc_fast.temperature_valid_meta_reg/D}]
if {[llength $vd] != 0} {
    p4c_required temperature_valid_source $vs
    set_max_delay 8.000 -datapath_only -from $vs -to $vd
}
