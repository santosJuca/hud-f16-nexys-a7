# HUD com magnetômetro calibrado — 19/10/2026

Bitstream gerado com Vivado 2026.1, incluindo joystick JA1, buzzer JC10 e calibração medida do HMC5883L. O operador confirmou rumo próximo da referência, ainda com precisão aproximada. Não é uma caracterização instrumental de erro angular.

SHA256 de `top_reticula.bit`: `16bb1d1c4fdee04c6dde4d9b5a1134a9e510beb79be5d75c69df4d359d1a9cf6`.

62 testes de regressão aprovados; WNS +0,326 ns, WHS +0,020 ns e zero erros de DRC. Consulte os relatórios e o manifesto de fontes deste diretório. A programação JTAG foi confirmada antes da publicação.

[Dados e procedimento de calibração](../../docs/calibracao_hmc5883l_20261019/README.md). Gere novamente com `scripts/build_vivado.tcl` para carregar o perfil de `constraints/magnetometer_calibration.tcl`. A calibração é específica desta montagem; mudar a posição do sensor ou os materiais próximos pode exigir nova coleta.
