if {$argc != 1} {error "USO: qualificar_clock_reset.tcl raiz"}
set root [file normalize [lindex $argv 0]]
set out [file join $root resultado qualificacao clock_reset_detail.txt]
if {[file exists $out]} {error "Relatorio existente preservado: $out"}
open_checkpoint [file join $root resultado routed.dcp]
set f [open $out w]
foreach cell [get_cells -hier -filter {NAME =~ *u_ddr2_infrastructure/*mmcm_i}] {
 puts $f "MMCM $cell COMPENSATION=[get_property COMPENSATION $cell]"
 foreach pin {CLKIN1 CLKFBIN CLKFBOUT} {
  set p [get_pins $cell/$pin]
  puts $f "$pin nets=[get_nets -of_objects $p] clocks=[get_clocks -of_objects $p]"
 }
}
foreach c [lsort [get_cells -hier -filter {NAME =~ *u_mirror/src_reset_pipe_reg* || NAME =~ *u_mirror/ui_reset_pipe_reg*}]] {
 puts $f "RESET $c ASYNC_REG=[get_property ASYNC_REG $c] LOC=[get_property LOC $c]"
}
close $f
puts "CLOCK_RESET_DETAIL_DONE"
