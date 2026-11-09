# Relatorios de caminhos externos. Nao adiciona constraints nem abre hardware.
if {$argc != 2} {error "USO: qualificar_spi_io.tcl checkpoint.dcp saida_nova"}
lassign $argv checkpoint out
if {[file exists $out]} {error "Saida preservada: $out"}
file mkdir $out
open_checkpoint $checkpoint
report_datasheet -file [file join $out datasheet.rpt]
report_io -file [file join $out io.rpt]
report_clocks -file [file join $out clocks.rpt]
report_clock_interaction -file [file join $out clock_interaction.rpt]
report_waivers -file [file join $out waivers.rpt]
set launch [get_pins -hier -filter {NAME =~ *read_block/sd_sck_reg/C}]
if {[llength $launch] != 1} {error "Registrador SCK de leitura nao identificado: $launch"}
report_timing -from $launch -to [get_ports SD_SCK] -delay_type min_max -max_paths 4 -file [file join $out sck_read_pin.rpt]
set capture [get_pins -hier -filter {NAME =~ *read_block/rx_shift_reg*/D || NAME =~ *read_block/r1_response_reg*/D || NAME =~ *read_block/data_byte_reg*/D}]
if {[llength $capture] < 8} {error "Capturas MISO nao identificadas"}
report_timing -from [get_ports SD_DAT0] -to $capture -delay_type min_max -max_paths 20 -file [file join $out miso_capture.rpt]
set f [open [file join $out path_properties.txt] w]
foreach mode {max min} {
 foreach p [get_timing_paths -from $launch -to [get_ports SD_SCK] -delay_type $mode -max_paths 1] {
  puts $f "SCK $mode";report_property -all $p -file [file join $out sck_${mode}_properties.rpt]
 }
}
close $f
puts "SPI_IO_REPORTS_DONE; SEM SIGNOFF EXTERNO"
