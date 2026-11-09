# Somente arquivos locais. Nenhum comando de hardware/JTAG/Flash.
if {$argc != 2} {error "USO: emit_experimental_bit.tcl routed.dcp saida_nova"}
set checkpoint [file normalize [lindex $argv 0]]
set out [file normalize [lindex $argv 1]]
if {[file exists $out]} {error "Saida existente preservada: $out"}
set digest [lindex [exec sha256sum -- $checkpoint] 0]
if {$digest ne "57f162876e9e0f26cac82d4ce7f6770ad5fdc6561740e7d5b009bc129590ba10"} {
    error "Checkpoint diverge da implementacao mapeada b38e538"
}
open_checkpoint $checkpoint
if {[get_property PART [current_design]] ne "xc7a100tcsg324-1"} {error "Part incorreto"}
set setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
if {$setup <= 0 || $hold <= 0} {error "Timing nao positivo"}
foreach port {SD_RESET SD_SCK SD_CMD SD_DAT0 SD_DAT3 SD_CD clk} pin {E2 B1 C1 C2 D2 A1 E3} {
    set p [get_ports $port]
    if {[get_property PACKAGE_PIN $p] ne $pin || [get_property IOSTANDARD $p] ne "LVCMOS33"} {
        error "Pinagem/nivel incompativel: $port"
    }
}
file mkdir $out
report_drc -file [file join $out drc_bitstream.rpt]
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error}]] != 0} {error "DRC impeditivo"}
report_route_status -file [file join $out route_status.rpt]
# Configuracao serial x1 conservadora; nao altera o clock SPI do microSD.
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 3 [current_design]
# USERID legivel por JTAG; identifica a fonte RTL, nao e hash da SRAM.
set_property BITSTREAM.CONFIG.USERID 0xb38e538b [current_design]
set f [open [file join $out config_properties.txt] {WRONLY CREAT EXCL}]
foreach prop {PART CFGBVS CONFIG_VOLTAGE BITSTREAM.CONFIG.SPI_BUSWIDTH BITSTREAM.CONFIG.CONFIGRATE BITSTREAM.CONFIG.USERID} {
    puts $f "$prop=[get_property $prop [current_design]]"
}
puts $f "WNS=$setup WHS=$hold"
puts $f "SOURCE_CHECKPOINT=$checkpoint"
close $f
write_bitstream [file join $out hud-f16-ddr2-b38e538-status-experimental.bit]
puts "EXPERIMENTAL_BIT_WRITTEN; NAO VALIDADO FISICAMENTE; NENHUM HARDWARE ACESSADO"
