set root [file normalize [file join [file dirname [info script]] ..]]
set project_dir [file join $root build vivado]
# Preserva projetos/relatorios anteriores antes de criar uma execucao nova.
set stamp "[clock format [clock seconds] -format %Y%m%d-%H%M%S]-[pid]"
set archive [file join $root build "before-$stamp"]
file mkdir $archive
if {[file exists $project_dir]} { file rename $project_dir [file join $archive vivado] }
foreach name {timing_summary.rpt utilization.rpt drc.rpt check_timing.rpt cdc.rpt} {
    set path [file join $root build $name]
    if {[file exists $path]} { file rename $path [file join $archive $name] }
}
create_project reticula $project_dir -part xc7a100tcsg324-1
add_files [glob [file join $root rtl *.sv]]
add_files -fileset constrs_1 [file join $root constraints nexys_a7_reticula.xdc]
add_files -fileset constrs_1 [file join $root constraints attitude_capture.xdc]
set_property top top_reticula [current_fileset]
# Perfil medido desta montagem; defaults RTL continuam sem calibracao.
source [file join $root constraints magnetometer_calibration.tcl]
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} { error "Sintese nao concluida" }
puts "SYNTHESIS=PASS"
launch_runs impl_1 -to_step route_design -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "Implementacao nao concluida" }
open_run impl_1
report_timing_summary -file [file join $root build timing_summary.rpt]
source [file join $root scripts report_fmax.tcl]
report_utilization -file [file join $root build utilization.rpt]
report_drc -file [file join $root build drc.rpt]
check_timing -verbose -file [file join $root build check_timing.rpt]
report_cdc -file [file join $root build cdc.rpt]
set setup_path [get_timing_paths -delay_type max -max_paths 1]
set hold_path [get_timing_paths -delay_type min -max_paths 1]
if {[llength $setup_path] == 0 || [llength $hold_path] == 0} { error "Timing sem caminhos analisados" }
if {[get_property SLACK $setup_path] < 0 || [get_property SLACK $hold_path] < 0} { error "Timing negativo: bitstream bloqueado" }
if {[llength [get_drc_violations -filter {SEVERITY == Error}]] != 0} { error "DRC com erros: bitstream bloqueado" }
puts "IMPLEMENTATION=PASS"
puts "TIMING=PASS"
close_design
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "Bitstream nao concluido" }
set bitfile [file join $project_dir reticula.runs impl_1 top_reticula.bit]
if {![file exists $bitfile]} { error "Bitstream ausente" }
puts "WRITE_BITSTREAM=PASS"
puts "BUILD_BITSTREAM=$bitfile"
