if {$argc != 1} {error "USO: qualificar_rc.tcl raiz"}
set root [file normalize [lindex $argv 0]]
set out [file join $root resultado qualificacao]
if {[file exists $out]} {error "Relatorios existentes preservados: $out"}
file mkdir $out
open_checkpoint [file join $root resultado routed.dcp]
report_clocks -file [file join $out clocks.rpt]
report_clock_interaction -file [file join $out clock_interaction.rpt]
report_io -file [file join $out io.rpt]
report_methodology -file [file join $out methodology.rpt]
report_waivers -file [file join $out waivers.rpt]
set f [open [file join $out mig_clocking.txt] w]
set pll [get_cells -hier -filter {NAME =~ *u_ddr2_infrastructure/plle2_i}]
puts $f "PLL: $pll"
foreach i {0 1 2 3} {
 set p [get_pins -of_objects $pll -filter "REF_PIN_NAME == CLKOUT$i"]
 puts $f "OUTPUT $i: $p"
 puts $f "LOADS: [get_pins -leaf -of_objects [get_nets -of_objects $p] -filter {DIRECTION == IN}]"
}
set mmcm [get_cells -hier -filter {NAME =~ *u_ddr2_infrastructure/*mmcm_i}]
puts $f "MMCM: $mmcm"
foreach c $mmcm {puts $f "COMPENSATION: [get_property COMPENSATION $c]"}
close $f
puts "QUALIFICACAO_REPORTS_DONE"
