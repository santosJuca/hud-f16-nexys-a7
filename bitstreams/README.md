# Bitstream atual do HUD

> Catálogo histórico de outubro. A versão recente é [5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/README.md), com binários nos assets da [release](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-calibracao-guiada-5d7a3ae2-20261113). A expressão “atual” nos registros abaixo refere-se à data do registro.

A pasta [2026-10-13_hud_flash](2026-10-13_hud_flash/README.md) contém a versão gravada na Flash e validada funcionalmente pelo operador: inicialização, VGA, joystick, sensores e buzzer/ACK. As medições elétricas permanecem pendentes.

- FPGA: Nexys A7-100T, `xc7a100tcsg324-1`; Vivado 2026.1.
- Bitstream: [`top_reticula.bit`](2026-10-13_hud_flash/top_reticula.bit).
- SHA-256: `c0e1b616700b3cd91042c17221559bf0e68215dac8a44f9a677ce0ad79615ab0`.
- Imagens para Flash: `top_reticula_flash.mcs` e `top_reticula_flash.bin`.
- Timing: WNS +0,480 ns e WHS +0,037 ns; DRC com 0 erros e 55 avisos.
- Relatórios, XDC, checkpoint, logs, snapshot das fontes e hashes ficam na mesma pasta.
- [Validação e limitações](../docs/validacao_hardware_20261013.md).
- [Esquemático e pinagem](../docs/esquematico/2026-10-13/).

O build foi gerado com alterações locais sobre `fc2a687`. O snapshot foi coletado depois do build; esse commit-base sozinho não reproduz o bitstream.

As quatro versões antigas foram retiradas da árvore atual e preservadas em cópia local. Continuam disponíveis no [histórico anterior](https://github.com/santosJuca/Trabalho-display-aviao-v2/tree/11343bb/bitstreams). A cópia completa da Flash original está preservada localmente no pacote de entrega e em `build/`.

## Magnetômetro calibrado em 19/10/2026

[Bitstream e relatórios da versão calibrada](2026-10-19_mag_calibrado/README.md), com joystick em JA1, buzzer em JC10 e perfil medido do HMC5883L.
