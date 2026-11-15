# Build experimental local com diagnostico nos LEDs e sete segmentos. Nunca abre Hardware Manager nem programa a placa.
if {[llength $argv] < 1 || [llength $argv] > 3} {
    error "Uso: build_sd_p0.tcl diretorio_novo ?referencia.hex? ?LBA?"
}
set out [file normalize [lindex $argv 0]]
if {[file exists $out]} { error "Diretorio ja existe: $out" }
set reference ""
if {[llength $argv] >= 2} {
    set reference [file normalize [lindex $argv 1]]
    if {![file isfile $reference]} { error "Referencia ausente" }
    set f [open $reference r]; set contents [read $f]; close $f
    set values [regexp -all -inline {\S+} $contents]
    if {[llength $values] != 512} { error "Referencia exige 512 bytes" }
    foreach value $values {
        if {![regexp {^[0-9a-fA-F]{2}$} $value]} { error "Byte hexadecimal invalido" }
    }
}
set lba 0
if {[llength $argv] == 3} {set lba [lindex $argv 2]}
if {![string is integer -strict $lba] || $lba < 0 || $lba > 4294967295} {error "LBA invalido"}
set root [file normalize [file join [file dirname [info script]] ..]]
file mkdir $out
cd $out
set_param general.maxThreads 4
create_project p0 [file join $out project] -part xc7a100tcsg324-1
read_verilog -sv [lsort [glob [file join $root rtl *.sv]]]
read_xdc [file join $root constraints nexys_a7_reticula.xdc]
read_xdc [file join $root constraints attitude_capture.xdc]
set f [open [file join $root constraints magnetometer_calibration.tcl] r]
set calibration [read $f]; close $f
if {![regexp {set_property generic \{([^\}]+)\}} $calibration match generics]} {error "Calibracao ausente"}
set args [list -top top_reticula -part xc7a100tcsg324-1 -flatten_hierarchy rebuilt]
foreach generic [concat $generics [list ENABLE_SD_SUBSYSTEM=1 SD_DIAGNOSTIC_LBA=$lba SD_HALF_PERIOD_CYCLES=125]] {
    lappend args -generic $generic
}
if {$reference ne ""} {lappend args -generic "SD_REFERENCE_FILE=\"$reference\""}
synth_design {*}$args
opt_design
place_design
phys_opt_design
route_design
write_checkpoint [file join $out routed.dcp]
report_utilization -file [file join $out utilization.rpt]
report_timing_summary -report_unconstrained -check_timing_verbose -file [file join $out timing_summary.rpt]
check_timing -verbose -file [file join $out check_timing.rpt]
report_cdc -file [file join $out cdc.rpt]
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
puts $f "EXPERIMENTAL. Leitura fisica e aprovacao eletrica pendentes."
puts $f "LBA=$lba referencia=$reference init=400kHz read=400kHz"
close $f
puts "P0_EXPERIMENTAL_BUILD_COMPLETE=$out"
