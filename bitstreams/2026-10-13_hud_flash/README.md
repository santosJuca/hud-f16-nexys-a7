# HUD na Flash: versão funcional de 13/10/2026

Bitstream preservado: `top_reticula.bit`. SW do joystick em JC1/K1;
controle do buzzer em JC7/E7; eixos em JXADC. O top corrige o sentido vertical
antes da calibração, preservando o horizontal.

O operador confirmou boot pela Flash com JP1 em SPI/QSPI, VGA estável,
joystick, MPU, indicadores BMP/HMC e buzzer/ACK. Veja `validacao_hardware.md`
para o alcance de cada relato e as medições ainda pendentes.

A gravação da Flash foi verificada pelo Vivado e por leitura completa.
O log de gravação registra uma primeira tentativa de boot ainda em JTAG;
o operador depois mudou JP1 para SPI/QSPI e confirmou o boot e os ensaios.

Vivado 2026.1, xc7a100tcsg324-1. WNS +0,480 ns, WHS +0,037 ns,
DRC sem erros e com 55 avisos. Nove testes digitais passaram; seus logs estão
em `testes/`. Os números de timing cobrem os caminhos restritos da implementação,
sem comprovar faixa analógica ou temporização elétrica dos módulos.

As fontes tinham alterações locais sobre fc2a687. O snapshot foi coletado após
o build; o commit-base sozinho não reproduz este bitstream. Os 48 pads do XDC
coincidem com `pinagem_checkpoint.csv`. Todos os arquivos preservados têm hash
em `SHA256SUMS.txt`.

A cópia completa da Flash original e o bitstream da demonstração Digilent estão
no pacote de entrega, em `originais/`. Nenhum bitstream histórico foi substituído.
