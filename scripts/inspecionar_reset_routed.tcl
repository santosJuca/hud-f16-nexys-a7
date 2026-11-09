# Leitura do checkpoint preservado; nao altera constraints nem salva o design.
if {$argc != 2} {error "USO: inspecionar_reset_routed.tcl checkpoint saida_nova"}
set checkpoint [file normalize [lindex $argv 0]]
set out [file normalize [lindex $argv 1]]
if {[file exists $out]} {error "Saida existente preservada: $out"}
open_checkpoint $checkpoint
set f [open $out {WRONLY CREAT EXCL}]
set targets [get_pins -hier -filter {NAME =~ *u_mirror/*reset_pipe_reg[0]/PRE || NAME =~ *u_ddr2_infrastructure/rstdiv0_sync_r_reg[0]/PRE}]
if {[llength $targets] != 3} {error "Esperados tres destinos CDC-10, encontrados [llength $targets]"}
foreach p [lsort $targets] {
    set cell [get_cells -of_objects $p]
    puts $f "DESTINO $p REF=[get_property REF_NAME $cell]"
    puts $f "CLOCK [get_clocks -of_objects [get_pins -of_objects $cell -filter {REF_PIN_NAME == C}]]"
    foreach s [lsort [all_fanin -flat -startpoints_only -to $p]] {
        puts $f "ORIGEM $s CLOCK=[get_clocks -quiet -of_objects $s]"
    }
    foreach c [lsort [all_fanin -flat -only_cells -to $p]] {
        if {[string match LUT* [get_property REF_NAME $c]]} {
            puts $f "LOGICA $c REF=[get_property REF_NAME $c] INIT=[get_property INIT $c]"
            foreach i [get_pins -of_objects $c -filter {DIRECTION == IN}] {
                puts $f "  $i NET=[get_nets -of_objects $i]"
            }
        }
    }
}
close $f
puts "RESET_CONES_DONE"
