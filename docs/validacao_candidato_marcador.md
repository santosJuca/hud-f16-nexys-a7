# Validação do candidato com marcador móvel

## Identificação e integridade

- Branch: `feat/modos-alertas`.
- HEAD observado antes desta etapa: `fc2a687285777ab7e577a4f5cb95ef7de0582866`.
- Revisão efetiva: HEAD acima mais as alterações locais já existentes no início e as alterações registradas nesta etapa. O diretório já continha modificações em RTL, testes e documentação; elas foram preservadas.
- Fotografia inicial do Git: branch limpa em relação ao upstream, 20 arquivos rastreados modificados (271 inserções e 153 remoções no diff inicial) e três arquivos não rastreados: `docs/entrega_demo.md`, `tests/tb_captura_marcador.sv` e `tests/tb_marcador_joystick.sv`. Os arquivos rastreados modificados eram `README.md`, `bitstreams/2026-10-08_hud_caca_marker/README.md`, `bitstreams/README.md`, `docs/README.md`, `docs/entradas_hud.md`, `docs/roadmap.md`, `docs/testes.md`, `docs/timing_recursos.md`, `docs/validacao_modos_alertas.md`, `rtl/atitude_gyro_hud.sv`, `rtl/dados_hud.sv`, `rtl/mira_joystick.sv`, `rtl/simbologia_vga.sv`, `rtl/top_reticula.sv`, `scripts/test.sh`, `tests/tb_atitude.sv`, `tests/tb_atitude_gyro_hud.sv`, `tests/tb_dados_hud.sv`, `tests/tb_mira_joystick.sv` e `tests/tb_roll.sv`.
- Ferramentas encontradas: `/usr/bin/iverilog`, `/usr/bin/vvp`, `/usr/bin/verilator`, `/usr/bin/sha256sum` e Vivado 2026.1 em `/home/santojuca/AMD/2026.1/Vivado/bin` (licença BASIC ativa). O executável do Vivado não está no PATH.
- Snapshot usado no build isolado: `build/validacao-marcador-20261012/snapshot/`, com RTL, XDC, HEAD, hashes e estado/diff local registrados.
- Bitstream aprovado de referência: `bitstreams/2026-10-08_hud_caca_marker/top_reticula.bit`.
- SHA-256 conferido: `e55d29a48ed0ace7a7a7d94d512f8b05fa465905cf1d78a5317b047a32782c49`, igual ao valor esperado.

## Teste integrado

Foi acrescentado `tests/tb_marcador_integrado.sv` e incluído no runner `scripts/test.sh`. O teste conecta o controlador do marcador à transferência CDC, à captura de `dados_hud` e ao renderizador VGA. Ele cobre movimento e retenção em NORMAL/DECLUTTER, congelamento e ocultação em CAÇA, retomada ao retornar, LOCK/UNLOCK, limites e a aplicação de coordenadas somente na borda de quadro.

O testbench passou isoladamente com Icarus Verilog. Para excitar o caminho, ele força as saídas digitais do wrapper `joystick_xadc`; o modelo XADC genérico do repositório não simula a conversão analógica. Portanto, isso valida a cadeia digital a partir das amostras do XADC, não a amostragem elétrica do KY-023 nem o comportamento do modelo primitivo AMD.

## Regressão

O runner conserva os 55 casos anteriores, adiciona os dois casos do marcador que já estavam no checkout e inclui o novo teste integrado, totalizando 58 entradas. `roll` e `vga` usam Verilator quando disponível; os demais usam Icarus.

A regressão integral refeita com o runner estável concluiu com `TODOS OS TESTES PASSARAM`: 58/58 entradas aprovadas. `roll` e `vga` usaram Verilator; os demais usaram Icarus Verilog. O teste integrado também passou isoladamente após a checagem adicional de DECLUTTER. A primeira execução, durante a edição do runner, não foi contabilizada.

## Vivado, timing e bitstream

Vivado 2026.1 sintetizou e roteou a cópia isolada para `xc7a100tcsg324-1`. A implementação concluiu sem erros nem critical warnings no log. As métricas finais são:

| Verificação | Resultado |
| --- | ---: |
| Clock `sys_clk_pin` | 100 MHz (10 ns) |
| Clock gerado `pixel_clk` | 25 MHz (40 ns) |
| WNS / TNS | +0,474 ns / 0 ns |
| WHS / THS | +0,019 ns / 0 ns |
| Erros DRC / critical warnings | 0 / 0 |
| CDC | 127 endpoints: 0 unsafe, 0 unknown; todos classificados como safe |
| LUT | 12.309 / 63.400 (19,41%) |
| FF | 6.886 / 126.800 (5,43%) |
| DSP | 31 / 240 (12,92%) |
| BRAM | 0 / 135 (0%) |

O pior caminho de setup é interno a `sys_clk_pin`, da lógica de pitch em `u_fusao_atitude` até `g_operacao...velocidade_q8_reg`, com 14 níveis lógicos e slack de +0,474 ns. O pior caminho de hold tem slack de +0,019 ns entre registradores do cálculo de temperatura do BMP085. A margem de hold é positiva, mas pequena.

O relatório DRC contém avisos, sem erros: um `CFGBVS-1` por propriedades de tensão de configuração ausentes no XDC; 11 recomendações `DPIP-1`, 17 `DPOP-1` e 26 `DPOP-2` sobre pipeline de DSP. O `check_timing` não encontrou clocks ausentes, endpoints internos sem restrição, múltiplos clocks ou loops; registra, porém, seis entradas sem input delay e 26 saídas sem output delay. Logo, a aprovação de slack cobre os caminhos internos restritos e não valida temporização elétrica de I/O.

Os relatórios versionados em `bitstreams/2026-10-08_hud_caca_marker/` pertencem à implementação roteada de 8/10/2026. O baseline registra WNS=+0,078 ns, WHS=+0,017 ns, TNS=0 e THS=0. Nesta implementação, WNS melhorou 0,396 ns e WHS 0,002 ns.

Foi gerado um bitstream somente como **CANDIDATO NÃO APROVADO**, em `build/validacao-marcador-20261012/CANDIDATO_NAO_APROVADO/top_reticula.bit`. SHA-256: `11766eb29071427cbebd101ed620cca428156f5b6b71b4cc14a0f72bd1032190`. A geração concluiu sem erros DRC; o bitstream aprovado e seu hash permaneceram intactos. A placa não foi programada.

## Próximas validações

Relatórios completos do build estão em `build/validacao-marcador-20261012/`: `timing_summary.rpt`, `setup_paths.rpt`, `hold_paths.rpt`, `clocks.rpt`, `utilization.rpt`, `drc.rpt`, `cdc.rpt` e `check_timing.rpt`. Hashes de fontes e log do build também foram preservados junto ao snapshot.

A validação física futura deve seguir o procedimento da placa Nexys A7, confirmar VGA e os sentidos do joystick em NORMAL/DECLUTTER, verificar congelamento/ocultação em CAÇA, retomada de posição, LOCK/UNLOCK e os quatro limites. Ainda faltam a validação elétrica/analógica do KY-023 e a observação da placa real; não presumir acesso ou resultados físicos. O candidato não foi programado.

## Geometria de roll

Propor em revisão separada um estudo da geometria de roll, comparando a escala atual e alternativas com vetores de referência e capturas raster. Esta etapa não altera a geometria de roll.
