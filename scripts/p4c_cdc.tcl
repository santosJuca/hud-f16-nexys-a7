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
