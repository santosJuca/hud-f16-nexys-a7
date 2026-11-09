# Qualificacao isolada da sonda opcional, nao integrada aos candidatos SPI.
if {$argc != 2} {error "USO: qualificar_video_metrics.tcl raiz saida_nova"}
lassign $argv root out
if {[file exists $out]} {error "Saida preservada: $out"}
file mkdir $out
set_param general.maxThreads 2
create_project -in_memory -part xc7a100tcsg324-1
read_verilog -sv [file join $root hud rtl video_publication_metrics.sv]
synth_design -top video_publication_metrics -mode out_of_context -part xc7a100tcsg324-1
create_clock -name clk -period 10 [get_ports clk]
opt_design
place_design
route_design
report_utilization -file [file join $out utilization.rpt]
report_timing_summary -delay_type min_max -file [file join $out timing.rpt]
report_cdc -file [file join $out cdc.rpt]
set f [open [file join $out resultado.txt] w]
puts $f "WNS=[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] WHS=[get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]"
puts $f "Sonda OOC isolada. Nao qualifica integracao no top nem interfaces externas."
close $f
