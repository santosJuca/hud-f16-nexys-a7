# HUD F-16 DDR2 — leitura SPI 5 MHz

**CANDIDATA EXPERIMENTAL.** Inicialização SPI a 400 kHz e leitura a 5 MHz. Mantém 320×240 RGB332, os indicadores persistentes, HUD, sensores, controles e alternativa BRAM. Não promete 30 FPS físicos.

[Download da candidata](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-spi5-rc-20261109) · [Teste e recuperação](PROCEDIMENTO_TESTE_FPGA.md) · [Resultado](RESULTADO_FINAL.md) · [Perfis SPI](SPI_PERFIS_INCREMENTAIS.md)

Branch: `perf/hud-spi-leitura-incremental-20261109`. Fonte do build: `f8b36f814b6c530a54e6d597ef7c5c33e3e3dd03`; a tag/manifesto dos assets identifica o commit de consolidação. A main e as releases anteriores permanecem preservadas.

BIT: `hud-f16-ddr2-f8b36f8-spi-h010-experimental.bit`

SHA-256: `2fd3dbc1d0da6fb4d3a8962f811d740fed0b2b23317928c3b591f7c44e1157b2`

USERCODE: **5DF8B30A**. Este BIT foi reproduzido offline nesta consolidação e tem hash diferente da emissão histórica `41503a5f...`. O mesmo USERCODE identifica código/perfil, não distingue os dois arquivos. Não há teste físico novo desta emissão.

## Verificado nesta consolidação

- Vivado 2026.1: WNS +0,391 ns / WHS +0,006 ns, TNS/THS zero, DRC sem erros e oito grupos de bus skew positivos (mínimo +6,810 ns).
- CDC: 46 CDC-3, três CDC-10, um CDC-8 e 176 CDC-15; sem novos alertas ou waivers. Ressalvas de reset/clocking MIG continuam documentadas em VALIDACAO_OFFLINE.md. Hold de apenas 6 ps e IO externo ainda exigem cautela.
- 23 cenários SPI passaram; teste integrado a 5 MHz passou com quatro publicações, quatro releituras DDR2 íntegras, 7.372.800 comparações RGB e zero erros no modelo UI MIG/XPM. Não simula o PHY da placa.
- As 132 atribuições IO conferiram com a candidata anterior. Nenhum RTL de produção, constraint, algoritmo de sensores ou arquivo de vídeo foi alterado nesta consolidação.

## Indicadores

| LED | Significado |
|---|---|
| LD12 | Referência de clock travada agora. |
| LD13 | Calibração MIG concluída agora. |
| LD14 | Commit íntegro DDR2 seguido do ACK sincronizado da publicação de banco; persistente. |
| LD15 | Falha de vídeo/retorno/buffer registrada; persistente. Apagado é o estado esperado sem falha monitorada. |

LD14 não garante fundo habilitado/visível. CPU RESET do MIG não limpa o histórico; recarga do HUD limpa. A qualidade visual foi aprovada pelo usuário em ensaio anterior; FPS e integridade contínua desta emissão ainda precisam ser medidos.

## Reproduzir

Em checkout limpo de `f8b36f8`, com Vivado 2026.1, Icarus e o submódulo Digilent na revisão fixada, executar:

```bash
bash scripts/test_spi_profiles.sh
bash scripts/build_spi_profile.sh 10
bash scripts/emit_spi_profile_bit.sh resultado-spi-h010-f8b36f8
```

Os hashes de novos DCP/BIT podem mudar. Para reproduzir o teste integrado usando o executor desta branch:

```bash
SCENARIOS=6 READ_HALF=10 INIT_HALF=125 BASE_LBA=30028160 bash scripts/test_sd_ddr2_vga.sh
```

Relatórios completos e proveniência em `evidencias/spi-h010-reproducao/`; as pastas anteriores são históricas. O manifesto de fontes cobre esta árvore; SHA256SUMS e manifesto-release.json dos assets vinculam os binários à tag.

O cartão conhecido contém 90 quadros, LBA absoluto 30028160 e 13501 setores. A 5 MHz, a simulação estima carga de ~125,8 ms/quadro; não é FPS físico. A Flash e o cartão não foram modificados, JTAG não foi executado nesta consolidação e nenhum MCS foi gerado.
