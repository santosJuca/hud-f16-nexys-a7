if {$argc != 1} {error "USO: requalificar_routed.tcl raiz"}
set root [file normalize [lindex $argv 0]]
set out [file join $root resultado-qualificado]
if {[file exists $out]} {error "Resultado existente; preservado"}
file mkdir $out
set_param general.maxThreads 4
open_checkpoint [file join $root resultado routed.dcp]
source [file join $root scripts p4c_cdc.tcl]
phys_opt_design -directive Explore
route_design
write_checkpoint [file join $out routed.dcp]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out timing.rpt]
report_drc -file [file join $out drc.rpt]
report_cdc -details -file [file join $out cdc.rpt]
report_bus_skew -file [file join $out bus_skew.rpt]
check_timing -verbose -file [file join $out check_timing.rpt]
set wns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set whs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
puts "VIDEO_DDR2_STA WNS=$wns WHS=$whs"
if {$wns < 0 || $whs < 0} {error "Timing negativo; sem bitstream"}
puts "VIDEO_DDR2_INTERNAL_STA_PASS; CDC e IO externo exigem qualificacao independente"
