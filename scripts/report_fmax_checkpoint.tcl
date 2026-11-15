# Analise offline de checkpoint existente; nao sintetiza, roteia nem programa hardware.
if {$argc != 3} {error "USO: checkpoint saida_nova sha256_esperado"}
set checkpoint [file normalize [lindex $argv 0]]
set root [file normalize [lindex $argv 1]]
set expected [lindex $argv 2]
set repository [file normalize [file join [file dirname [info script]] ..]]
if {![regexp {^[0-9a-f]{64}$} $expected]} {error "SHA-256 invalido"}
if {[file exists $root]} {error "Saida existente preservada: $root"}
set hash [lindex [exec sha256sum -- $checkpoint] 0]
if {$hash ne $expected} {error "Checkpoint divergente"}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne "xc7a100tcsg324-1"} {error "FPGA incorreta"}
file mkdir [file join $root build]
source [file join $repository scripts report_fmax.tcl]
report_timing_summary -report_unconstrained -file [file join $root build timing.rpt]
report_utilization -file [file join $root build utilization.rpt]
report_cdc -file [file join $root build cdc.rpt]
report_drc -file [file join $root build drc.rpt]
set f [open [file join $root provenance.txt] {WRONLY CREAT EXCL}]
puts $f "SOURCE_DCP=$checkpoint"
puts $f "SOURCE_SHA256=$hash"
puts $f "PART=[get_property PART [current_design]]"
puts $f "READ_ONLY_CHECKPOINT_ANALYSIS; NO_SYNTHESIS_ROUTE_BITSTREAM_OR_HARDWARE_COMMANDS"
close $f
close_design
puts "CHECKPOINT_ANALYSIS_COMPLETE; CONSULTE_AS_VIOLACOES_NOS_RELATORIOS"
