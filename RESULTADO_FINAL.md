# Consolidação da candidata SPI 5 MHz

## CONFIRMADO

Branch `perf/hud-spi-leitura-incremental-20261109`, base de consolidação `12bb27bdf73b1771599016909b59b38ed1f55f2a`, fonte do build `f8b36f814b6c530a54e6d597ef7c5c33e3e3dd03`. A main e as releases anteriores foram preservadas. O commit final da publicação está no manifesto dos assets/tag.

A emissão histórica de hash `41503a5f...` não foi encontrada nos diretórios locais consultados e não estava em release. Os resumos publicados eram insuficientes para conferir integralmente bus skew/CDC. Reproduzimos o build, sem modificar RTL, em `/home/santojuca/Downloads/hud_ddr2_spi5_build_20261109`. A consolidação está em `/home/santojuca/Downloads/hud_ddr2_spi5_publicacao_20261109`.

O perfil efetivo mantém inicialização a 400 kHz, leitura a 5 MHz, 320×240 RGB332, 30 FPS nominais no arquivo, DDR2_VIDEO=1, LBA 30028160 e 13501 setores. Os genéricos completos estão em `evidencias/spi-h010-reproducao/perfil-spi-build.json`. A fonte compilada foi fotografada por hashes antes do build e reconferida sem divergências.

Nova execução: 23 cenários SPI PASS. Teste integrado de quadro completo com init=125, read=10 e LBA real passou: quatro publicações, quatro releituras DDR2 válidas, zero erros, 7.372.800 comparações RGB, escrita/leitura MIG e pré-carga exercitadas. Intervalos de publicação no modelo: 134,4 / 117,6 / 134,4 ms. Os quatro atrasos em relação à meta nominal de 30 FPS são esperados, não erros de CRC. Usa modelo SDHC/UI MIG e XPM real, sem PHY físico.

Nova síntese/implementação Vivado 2026.1: **WNS +0,391 ns / WHS +0,006 ns**, TNS/THS zero. Oito grupos de bus skew passaram, mínimo +6,810 ns. Zero erros DRC, 104 ocorrências de warnings (33 DPIP-1, 27 DPOP-1, 43 DPOP-2, um REQP-1709). CDC mantém 46 CDC-3, três CDC-10, um CDC-8 e 176 CDC-15; sem waivers. Zero no_clock e endpoints internos sem constraints. As 132 atribuições IO/propriedades conferiram com a candidata anterior. Recursos: 20630 LUTs, 15389 FF, 64 BRAM tiles e 62 DSPs.

## CORRIGIDO

Nenhuma falha nova no RTL foi demonstrada; ele permanece intacto. O executor `scripts/test_sd_ddr2_vga.sh` agora aceita READ_HALF/INIT_HALF opcionais, preservando seus padrões, para exercitar o perfil real sem alterar o testbench. Documentação e proveniência foram atualizadas para separar o build histórico da nova emissão. A estimativa `90/T` agora explicita a hipótese de nenhum quadro perdido/duplicado.

## NÃO VALIDADO

Nenhum JTAG, Flash ou microSD foi programado nesta consolidação. O log JTAG anterior de `12bb27b` documenta DONE/INIT_B/EOS=1, CRC_ERROR=0 e USERCODE 5DF8B30A; não qualifica fisicamente o novo hash nem prova CRC do vídeo. FPS, latência Nac do cartão, ausência de tearing/perdas em operação contínua e orçamento elétrico SPI ainda dependem da placa/instrumentação. A qualidade aprovada pelo usuário refere-se ao ensaio anterior. Não há medição nova de sensores ou boot Flash.

Hold de apenas 6 ps permanece uma ressalva importante. MIG/clocking/reset continuam com qualificações documentadas, não com zero críticos. `report_methodology` registra 43 TIMING-18 de IO sem delay; não inventamos atrasos para ocultá-los. Não subir para 10 MHz nesta entrega e não prometer 30 FPS a 5 MHz.

## CANDIDATO

BIT: `hud-f16-ddr2-f8b36f8-spi-h010-experimental.bit` (3825990 bytes).

SHA-256: `2fd3dbc1d0da6fb4d3a8962f811d740fed0b2b23317928c3b591f7c44e1157b2`

DCP: `110d421af4501b52c808f830582edb1f41ea61731e60f704aff6771b7faf4043`

USERCODE **5DF8B30A**. O hash difere do BIT histórico porque esta é outra emissão; o identificador de código/perfil é o mesmo. Cabeçalho, part 7a100tcsg324, tamanho do payload, sync e SHA conferidos. O script de emissão confere hash do DCP, part, pinos, timing e DRC antes do write_bitstream.

[Pre-release experimental](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-spi5-rc-20261109). Relatórios e logs novos em `evidencias/spi-h010-reproducao/`; os assets incluem BIT, DCP, recuperação, procedimentos, relatórios completos, manifestos e SHA256SUMS. A conferência final de upload/download fica registrada localmente em `validation/publicacao-spi5-verificada.json`.

## PRÓXIMO TESTE

Após autorização do arquivo/alvo, seguir PROCEDIMENTO_TESTE_FPGA.md: conferir SHA, carregar somente SRAM, confirmar USERCODE 5DF8B30A, aguardar 20–30 s e observar LD12/13/14 acesos e LD15 apagado. Cronometrar três ciclos dos 90 quadros e registrar pausas; `90/T` é estimativa condicionada à sequência completa. Testar dez minutos, modos, ajuste vertical, bússola e atitude. Em falha, registrar antes de recuperar o BIT funcional incluído ou reiniciar pela Flash preservada. Nenhum MCS foi gerado.
