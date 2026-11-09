# Somente arquivos locais. Nenhum comando de hardware/JTAG/Flash.
# Derivado de emit_experimental_bit.tcl; o DCP e o USERID vem do perfil-spi.json do build.
if {$argc != 5} {error "USO: emit_spi_profile_bit.tcl routed.dcp saida_nova sha256 usercode nome.bit"}
lassign $argv checkpoint out expected usercode name
set checkpoint [file normalize $checkpoint]
set out [file normalize $out]
if {[file exists $out]} {error "Saida existente preservada: $out"}
if {![regexp {^5D[0-9A-F]{6}$} $usercode]} {error "USERCODE fora do padrao de perfil SPI: $usercode"}
set digest [lindex [exec sha256sum -- $checkpoint] 0]
if {$digest ne $expected} {error "Checkpoint diverge do perfil-spi.json"}
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
# Atrasos reais dos pinos SPI para o orcamento eletrico (somente leitura do roteado).
report_datasheet -file [file join $out datasheet.rpt]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 3 [current_design]
set_property BITSTREAM.CONFIG.USERID 0x[string tolower $usercode] [current_design]
set f [open [file join $out config_properties.txt] {WRONLY CREAT EXCL}]
foreach prop {PART CFGBVS CONFIG_VOLTAGE BITSTREAM.CONFIG.SPI_BUSWIDTH BITSTREAM.CONFIG.CONFIGRATE BITSTREAM.CONFIG.USERID} {
    puts $f "$prop=[get_property $prop [current_design]]"
}
puts $f "WNS=$setup WHS=$hold"
puts $f "SOURCE_CHECKPOINT=$checkpoint"
close $f
write_bitstream [file join $out $name]
puts "EXPERIMENTAL_BIT_WRITTEN; NAO VALIDADO FISICAMENTE; NENHUM HARDWARE ACESSADO"
