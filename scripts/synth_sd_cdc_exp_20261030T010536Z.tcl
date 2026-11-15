# Experimento historico anterior; nao usar como criterio de liberacao.
# As restricoes vigentes estao em constraints/nexys_a7_reticula.xdc.
# P2M: somente sintese e relatorios; sem implementacao ou bitstream.
if {[llength $argv] == 1 && [lindex $argv 0] eq "help"} {
    foreach cmd {read_verilog read_xdc synth_design report_utilization report_timing_summary report_drc report_clock_utilization report_clock_interaction check_timing report_methodology report_timing} {
        puts [help $cmd]
    }
    exit
}
if {[llength $argv] != 2} {
    error "Uso: synth_sd_audit.tcl A125|A2|B|C diretorio_novo"
}
lassign $argv config out
if {$config ni {A125 A2 B C}} { error "Configuracao invalida: $config" }
if {[file exists $out]} { error "Diretorio ja existe: $out" }
file mkdir $out
set out [file normalize $out]
set root [file normalize [file join [file dirname [info script]] ..]]
set_param general.maxThreads 4
set meta [open [file join $out run.txt] w]
puts $meta "Vivado: [version -short]\nPart: xc7a100tcsg324-1\nConfiguracao: $config\nRoot: $root"
puts $meta "Analise pos-sintese, sem placement/routing; timing fisico inconclusivo."
close $meta

if {$config in {A125 A2}} {
    foreach name {sd_spi_preamble sd_spi_command sd_spi_init sd_spi_read_block sd_spi_controller} {
        read_verilog -sv [file join $root rtl ${name}.sv]
    }
    set half [expr {$config eq "A125" ? 125 : 2}]
    synth_design -top sd_spi_controller -part xc7a100tcsg324-1 \
        -flatten_hierarchy rebuilt \
        -generic INIT_HALF_PERIOD_CYCLES=125 -generic READ_HALF_PERIOD_CYCLES=$half
    create_clock -name sys_clk_pin -period 10.000 [get_ports clk]
} else {
    read_verilog -sv [lsort [glob [file join $root rtl *.sv]]]
    read_xdc [file join $root validation nexys_a7_reticula_cdc_exp_20261030T010536Z.xdc]
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
}


# Auditoria experimental do CDC bundled-data.
set cdc_src [get_cells -hier -filter {NAME =~ *u_entrada/retido_reg*}]
set cdc_dst [get_cells -hier -filter {NAME =~ *u_entrada/dados_destino_reg*}]

set nsrc [llength $cdc_src]
set ndst [llength $cdc_dst]

puts "CDC_SOURCE_CELLS=$nsrc"
puts "CDC_DEST_CELLS=$ndst"

if {$nsrc < 2 || $ndst < 2 || $nsrc != $ndst} {
    error "CDC: quantidade de registradores inconsistente"
}

# Limite experimental de atraso absoluto.
set_max_delay -datapath_only 60.000 \
    -from $cdc_src -to $cdc_dst

# Tres ciclos de destino para a arquitetura de handshake.
set_bus_skew -from $cdc_src -to $cdc_dst 120.000

report_clocks \
    -file [file join $out clocks_corrected.rpt]

report_exceptions -coverage \
    -file [file join $out exceptions_coverage.rpt]

report_bus_skew -max_paths 20 \
    -file [file join $out bus_skew.rpt]

report_timing -from $cdc_src -to $cdc_dst \
    -delay_type max -max_paths 20 \
    -path_type full_clock_expanded \
    -file [file join $out cdc_data_max.rpt]

if {[catch {
    report_timing -from $cdc_src -to $cdc_dst \
        -delay_type min -max_paths 20 \
        -path_type full_clock_expanded \
        -file [file join $out cdc_data_min.rpt]
} reason]} {
    puts "CDC_MIN_REPORT=$reason"
}

set status [open [file join $out reports-status.txt] w]
foreach {name command} {
    utilization {report_utilization -hierarchical}
    resource_totals {report_utilization}
    timing_summary {report_timing_summary -report_unconstrained -max_paths 10 -check_timing_verbose}
    drc {report_drc}
    clock_utilization {report_clock_utilization}
    clock_interaction {report_clock_interaction}
    check_timing {check_timing -verbose}
    methodology {report_methodology}
    setup_paths {report_timing -delay_type max -max_paths 10 -path_type full_clock_expanded}
    hold_paths {report_timing -delay_type min -max_paths 10 -path_type full_clock_expanded}
} {
    set target [file join $out ${name}.rpt]
    if {[catch {{*}$command -file $target} reason]} {
        puts $status "$name: INCONCLUSIVO: $reason"
    } else {
        puts $status "$name: PASS (relatorio produzido; verificar conteudo)"
    }
}
close $status

set f [open [file join $out netlist-evidence.txt] w]
puts $f "Clocks:"
foreach c [get_clocks] {
    puts $f "[get_property NAME $c] period=[get_property PERIOD $c] waveform=[get_property WAVEFORM $c]"
}
set histogram [dict create]
foreach cell [get_cells -hier -filter {IS_PRIMITIVE == 1}] {
    dict incr histogram [get_property REF_NAME $cell]
}
puts $f "Primitivas:"
foreach ref [lsort [dict keys $histogram]] { puts $f "$ref [dict get $histogram $ref]" }
puts $f "Hierarquia e registradores SD preservados:"
foreach cell [get_cells -hier] {
    set name [get_property NAME $cell]
    if {[string match *read_block* $name] || [string match g_sd.* $name] ||
        ($config in {A125 A2} && [string match init* $name])} {
        puts $f "$name [get_property REF_NAME $cell]"
    }
}
puts $f "Latches: [get_cells -quiet -hier -filter {REF_NAME =~ LD*}]"
puts $f "Black boxes: [get_cells -quiet -hier -filter {IS_BLACKBOX == 1}]"
close $f

set input_name [expr {$config in {A125 A2} ? "sd_miso" : "SD_DAT0"}]
set output_name [expr {$config in {A125 A2} ? "sd_sck sd_mosi sd_cs_n" : "SD_SCK SD_CMD SD_DAT3"}]
report_timing -from [get_ports $input_name] -max_paths 10 \
    -file [file join $out miso_paths.rpt]
report_timing -to [get_ports $output_name] -max_paths 10 \
    -file [file join $out spi_output_paths.rpt]
puts "P2M_SYNTHESIS_COMPLETE=$config REPORTS=$out"
close_design
