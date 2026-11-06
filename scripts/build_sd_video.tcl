# Build local somente. simulation usa LBAs do testbench; mapped exige mapa conferido pelo wrapper Python.
if {[llength $argv] != 8} {error "Uso: out lba setores half width fps reference kind"}
lassign $argv out lba sectors half width fps reference kind
set out [file normalize $out]
if {[file exists $out]} {error "Diretorio ja existe"}
if {$kind ni {simulation mapped}} {error "Origem de mapa invalida"}
foreach value [list $lba $sectors $half $width $fps] {
    if {![string is integer -strict $value] || $value<=0} {error "Parametro invalido"}
}
if {$half < 4 || $width ni {160 320} || $fps>60 || $lba+$sectors>4294967296} {error "Perfil fora do limite"}
set height [expr {$width*3/4}]
if {![file isfile $reference]} {error "Referencia do icone ausente"}
set root [file normalize [file join [file dirname [info script]] ..]]
file mkdir $out
cd $out
set_param general.maxThreads 4
create_project sd_video [file join $out project] -part xc7a100tcsg324-1
read_verilog -sv [lsort [glob [file join $root rtl *.sv]]]
read_xdc [file join $root constraints nexys_a7_reticula.xdc]
read_xdc [file join $root constraints attitude_capture.xdc]
read_xdc [file join $root constraints sd_video.xdc]
set f [open [file join $root constraints magnetometer_calibration.tcl] r]
set calibration [read $f]; close $f
if {![regexp {set_property generic \{([^\}]+)\}} $calibration match generics]} {error "Calibracao ausente"}
set args [list -top top_reticula -part xc7a100tcsg324-1 -flatten_hierarchy rebuilt]
foreach generic [concat $generics [list ENABLE_SD_SUBSYSTEM=1 ENABLE_SD_OVERLAY=1 ENABLE_SD_VIDEO=1 SD_DIAGNOSTIC_LBA=30006080 SD_HALF_PERIOD_CYCLES=125 SD_READ_HALF_PERIOD_CYCLES=$half SD_VIDEO_LBA=$lba SD_VIDEO_SECTORS=$sectors SD_VIDEO_WIDTH=$width SD_VIDEO_HEIGHT=$height SD_VIDEO_FPS=$fps]] {
    lappend args -generic $generic
}
if {$reference ne ""} {lappend args -generic "SD_REFERENCE_FILE=\"$reference\""}
synth_design {*}$args
report_utilization -file [file join $out synthesis_utilization.rpt]
write_checkpoint [file join $out synthesized.dcp]
opt_design
place_design
phys_opt_design
route_design
write_checkpoint [file join $out routed.dcp]
report_utilization -file [file join $out utilization.rpt]
report_timing_summary -report_unconstrained -check_timing_verbose -file [file join $out timing_summary.rpt]
check_timing -verbose -file [file join $out check_timing.rpt]
report_cdc -file [file join $out cdc.rpt]
report_bus_skew -file [file join $out bus_skew.rpt]
set f [open [file join $out bus_skew.rpt] r]
set skew_text [read $f]; close $f
if {[string first "VIOLATED" $skew_text]>=0} {error "Bus skew reprovado"}
report_drc -file [file join $out drc.rpt]
set setup [get_timing_paths -delay_type max -max_paths 1]
set hold [get_timing_paths -delay_type min -max_paths 1]
if {[llength $setup] != 1 || [llength $hold] != 1 ||
    [get_property SLACK $setup] < 0 || [get_property SLACK $hold] < 0} {error "STA interno reprovado"}
if {[llength [get_drc_violations -filter {SEVERITY == Error}]]} {error "DRC com erros"}
set f [open [file join $out drc.rpt] r]
set drc_text [read $f]; close $f
if {[string first "REQP-1840" $drc_text] >= 0} {error "BRAM com controles assincronos"}
set f [open [file join $out check_timing.rpt] r]
set timing_text [read $f]; close $f
if {![regexp {checking unconstrained_internal_endpoints \(0\)} $timing_text] ||
    ![regexp {checking no_clock \(0\)} $timing_text]} {error "Caminhos internos sem restricao"}
# Os pinos SPI continuam sem orcamento externo aprovado. O artefato e experimental.
write_bitstream [file join $out experimental.bit]
set f [open [file join $out classification.txt] w]
puts $f "EXPERIMENTAL; origem_mapa=$kind; LBA=$lba setores=$sectors; read_half=$half."
puts $f "Sem programacao, sem escrita no cartao, sem qualificacao eletrica SPI."
if {$kind eq "simulation"} {puts $f "MAPA APENAS DE SIMULACAO. NAO E UM BITSTREAM PROVISIONADO PARA O CARTAO FISICO."}
close $f
set f [open [file join $out fmax.rpt] w]
foreach clock [get_clocks] {
    set period [get_property PERIOD $clock]
    set paths [get_timing_paths -from $clock -to $clock -delay_type max -max_paths 1]
    if {[llength $paths]} {
        set path [lindex $paths 0]
        puts $f "[get_property NAME $clock]: periodo=$period ns; slack=[get_property SLACK $path] ns; requisito=[get_property REQUIREMENT $path] ns"
        if {abs([get_property REQUIREMENT $path]-$period)<0.001} {puts $f "Fmax estimada=[expr {1000.0/($period-[get_property SLACK $path])}] MHz; nao medida fisicamente"}
    }
}
close $f
puts "VIDEO_EXPERIMENTAL_BUILD_COMPLETE=$out"
