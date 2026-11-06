# Implementacao reproduzivel; sem acesso a hardware e sem bitstream.
if {[llength $argv] != 2} {
    error "Uso: implement_sd_timing.tcl B|C diretorio_novo"
}
lassign $argv config out
if {$config ni {B C}} { error "Configuracao invalida: $config" }
if {[file exists $out]} { error "Diretorio ja existe: $out" }
file mkdir $out
set out [file normalize $out]
set root [file normalize [file join [file dirname [info script]] ..]]
set_param general.maxThreads 4
set meta [open [file join $out run.txt] w]
puts $meta "Vivado: [version -short]\nPart: xc7a100tcsg324-1\nConfiguracao: $config\nRoot: $root"
puts $meta "opt/place/route Default; sem bitstream; interface externa exige aprovacao separada."
close $meta

    read_verilog -sv [lsort [glob [file join $root rtl *.sv]]]
    read_xdc [file join $root constraints nexys_a7_reticula.xdc]
    # Usa a mesma calibracao do build existente, sem modificar seus defaults.
    set f [open [file join $root constraints magnetometer_calibration.tcl] r]
    set calibration [read $f]
    close $f
    if {![regexp {set_property generic \{([^\}]+)\}} $calibration match generics]} {
        error "Lista de calibracao nao encontrada"
    }
    set args [list -top top_reticula -part xc7a100tcsg324-1 -flatten_hierarchy rebuilt]
    foreach generic [concat $generics [list ENABLE_SD_SUBSYSTEM=[expr {$config eq "C" ? 1 : 0}]]] {
        lappend args -generic $generic
    }
    synth_design {*}$args

set cdc_src [get_cells -hier -filter {NAME =~ u_entrada/retido_reg*}]
set cdc_dst [get_cells -hier -filter {NAME =~ u_entrada/dados_destino_reg*}]
# 16 bits constantes/redundantes sao removidos da palavra logica de 128 bits.
if {[llength $cdc_src] != 112 || [llength $cdc_dst] != 112} {
    error "CDC: esperados 112 registradores fisicos para palavra logica de 128 bits, obtido [llength $cdc_src]/[llength $cdc_dst]"
}
write_checkpoint [file join $out post_synth.dcp]
report_utilization -file [file join $out synth_resources.rpt]
report_timing_summary -report_unconstrained -check_timing_verbose -file [file join $out synth_timing.rpt]
opt_design -directive Default
write_checkpoint [file join $out post_opt.dcp]
place_design -directive Default
write_checkpoint [file join $out post_place.dcp]
report_timing_summary -file [file join $out place_timing.rpt]
# Referencia comparavel: sem phys_opt separado, router Default com otimizacoes nativas.
route_design -directive Default
write_checkpoint [file join $out post_route.dcp]
set status [open [file join $out reports-status.txt] w]
foreach {name command} {
    utilization {report_utilization -hierarchical}
    resource_totals {report_utilization}
    timing_summary {report_timing_summary -delay_type min_max -report_unconstrained -max_paths 20 -check_timing_verbose}
    drc {report_drc}
    methodology {report_methodology}
    check_timing {check_timing -verbose}
    route_status {report_route_status}
    clocks {report_clocks}
    clock_utilization {report_clock_utilization}
    clock_interaction {report_clock_interaction}
    cdc {report_cdc -details}
    exceptions {report_exceptions}
    setup_paths {report_timing -delay_type max -max_paths 20 -path_type full_clock_expanded -input_pins}
    hold_paths {report_timing -delay_type min -max_paths 20 -path_type full_clock_expanded -input_pins}
    datasheet {report_datasheet}
    io {report_io}
    bus_skew {report_bus_skew}
    exception_coverage {report_exceptions -coverage}
} {
    if {[catch {{*}$command -file [file join $out ${name}.rpt]} reason]} {
        puts $status "$name: INCONCLUSIVO: $reason"
    } else { puts $status "$name: PRODUZIDO (verificar conteudo)" }
    flush $status
}
close $status
foreach {name ports direction} {
    miso SD_DAT0 from
    spi_output {SD_SCK SD_CMD SD_DAT3 SD_RESET} to
} {
    foreach delay {max min} {
        report_timing -$direction [get_ports $ports] -delay_type $delay -max_paths 20 -path_type full_clock_expanded -input_pins -file [file join $out ${name}_${delay}.rpt]
    }
}
foreach {name from to} {
    sys_to_pixel sys_clk_pin pixel_clk
    pixel_to_sys pixel_clk sys_clk_pin
} {
    foreach delay {max min} {
        report_timing -from [get_clocks $from] -to [get_clocks $to] -delay_type $delay -max_paths 10 -path_type full_clock_expanded -file [file join $out ${name}_${delay}.rpt]
    }
}
set f [open [file join $out netlist-evidence.txt] w]
foreach c [get_clocks] {puts $f "CLOCK [get_property NAME $c] period=[get_property PERIOD $c] waveform=[get_property WAVEFORM $c]"}
foreach cell [get_cells -hier] {
    set name [get_property NAME $cell]
    if {[string match g_sd.* $name] || [string match *read_block* $name] || [string match *crc_calc* $name]} {puts $f "$name [get_property REF_NAME $cell]"}
}
puts $f "Latches: [get_cells -quiet -hier -filter {REF_NAME =~ LD*}]"
puts $f "Black boxes: [get_cells -quiet -hier -filter {IS_BLACKBOX == 1}]"
close $f
puts "P2N_ROUTE_COMPLETE=$config REPORTS=$out"
close_design
