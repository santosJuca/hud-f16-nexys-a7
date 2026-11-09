# HUD F-16 — sprint local de desempenho SPI/DDR2

**Candidatos somente offline. Sem JTAG, Flash, microSD, push ou nova release nesta sprint.** A candidata publicada de 5 MHz foi preservada e ainda exige aprovacao fisica da emissao exata.

| Perfil local | WNS / WHS | Estado |
|---|---|---|
| 10 MHz, init 400 kHz | +0,346 / +0,026 ns | BIT/DCP gerados; ensaio fisico bloqueado ate validar 5 MHz e interface externa. |
| 12,5 MHz, init 400 kHz | +0,251 / +0,020 ns | BIT/DCP gerados; stress 45 ns falhou com deteccao, orcamento externo pendente. |

Branch local `sprint/spi-ddr2-throughput-20261109`. Os candidatos sintetizam o commit 8162051; os novos testes/sonda pertencem aos commits posteriores. Os arquivos e SHA estao em `resultado-candidatos/` e RESULTADO_FINAL.md. Os dois builds mantem 320×240 RGB332, CMD17, DDR2/XPM, sensores, controles, HUD e alternativa BRAM. Nao foram acrescentados codec ou PHY novo aos BITs.

- [Resultado e hashes](RESULTADO_FINAL.md)
- [Orcamento externo e plano para 30 FPS](SPI_PERFIS_INCREMENTAIS.md)
- [Teste fisico, medicao ILA proposta e recuperacao](PROCEDIMENTO_TESTE_FPGA.md)
- [Evidencias novas e comandos](evidencias/sprint-spi-20261109/comandos.txt)
- [Pendencias fisicas](PENDENCIAS_FISICAS.md)
- [Referencia publicada de 5 MHz](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/hud-f16-ddr2-spi5-rc-20261109)

Foram executados 21 cenarios SPI focados, sete cenarios integrados de quadro completo, dois builds e implementacao OOC da sonda de publicacao. Os testes detectam erros injetados; nao sao prova de placa. A sonda ocupa 37 LUTs/162 FF isoladamente, mas nao esta instanciada nos candidatos.

A analise mostra que CMD18 sozinho nao permite 30 FPS a 12,5 MHz; a economia de clocks seria ~1,72% sem mudanca de Nac. PackBits sem perdas em 64 amostras tambem nao atingiu a meta nessa frequencia. O plano mais direto e reorganizar IO/captura para estudar 25 MHz com setup/hold reais, preservando o clock global e CMD17 de recuperacao. Isso ainda e proposta, nao implementacao validada.

Para reproduzir os builds, usar checkout limpo de 8162051 com Vivado 2026.1 e os board files congelados registrados no snapshot:

```bash
bash scripts/build_spi_profile.sh 5
bash scripts/emit_spi_profile_bit.sh resultado-spi-h005-8162051
bash scripts/build_spi_profile.sh 4
bash scripts/emit_spi_profile_bit.sh resultado-spi-h004-8162051
```

Os novos testes e comandos de qualificacao estao na branch da sprint; seus diretorios de saida devem ser novos. Nao confundir o clock VGA com publicacoes de video, `video_frames` com ACK de banco ou CRC de configuracao com CRC do filme. A primeira sessao fisica continua sendo o teste do BIT publicado de 5 MHz, com autorizacao especifica.
