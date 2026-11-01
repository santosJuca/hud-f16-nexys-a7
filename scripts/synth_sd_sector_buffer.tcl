# Preparacao isolada de P1. Nao gera bitstream e nao acessa hardware.
if {[llength $argv] != 1} {error "Uso: synth_sd_sector_buffer.tcl diretorio_novo"}
set out [file normalize [lindex $argv 0]]
if {[file exists $out]} {error "Diretorio ja existe"}
file mkdir $out
set root [file normalize [file join [file dirname [info script]] ..]]
cd $out
read_verilog -sv [file join $root rtl sd_sector_buffer.sv]
synth_design -mode out_of_context -top sd_sector_buffer -part xc7a100tcsg324-1
create_clock -name writer_clk -period 10 [get_ports wr_clk]
create_clock -name reader_clk -period 40 [get_ports rd_clk]
# Apenas o primeiro FF de cada sincronizador recebe a excecao de CDC.
set_false_path -from [get_clocks writer_clk] -to [get_pins request_meta_reg/D]
set_false_path -from [get_clocks reader_clk] -to [get_pins ack_meta_reg/D]
opt_design
report_utilization -file utilization.rpt
report_cdc -file cdc.rpt
report_drc -file drc.rpt
report_timing_summary -report_unconstrained -file timing_synthesis.rpt
check_timing -verbose -file check_timing.rpt
set rams [get_cells -hier -filter {REF_NAME =~ RAMB18* || REF_NAME =~ RAMB36*}]
if {[llength $rams] != 1} {error "Esperada uma unica BRAM inferida"}
if {[llength [get_drc_violations -filter {SEVERITY == Error}]]} {error "DRC com erros"}
set f [open drc.rpt r]; set drc_text [read $f]; close $f
if {[string first REQP-1840 $drc_text] >= 0} {error "BRAM com controle assincrono"}
set f [open ram-evidence.txt w]
puts $f "[get_property NAME $rams] [get_property REF_NAME $rams]"
puts $f "Preparacao isolada, sem place/route, sem bitstream, sem validacao fisica."
close $f
write_checkpoint buffer_synth.dcp
puts P1_BUFFER_SYNTHESIS_COMPLETE
