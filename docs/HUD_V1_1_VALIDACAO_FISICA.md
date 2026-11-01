# HUD FPGA v1.1 | Validacao fisica JTAG

Data da confirmacao: 2026-11-01.

## Identidade

- Placa: Nexys A7-100T.
- FPGA: XC7A100T.
- Commit funcional ensaiado: `622eacb`.
- Branch: `feat/hud-v1.1-polimento`.
- Bitstream v1.1 SHA-256:
  `d9750085ce8dc2558372872d80734d13dff390354468241aa3cda972db8cfc07`.
- Bitstream estavel v1.0 SHA-256:
  `58d71e7435640e3675e872dff2723aa263d33da523ed323867e03885b9e3474d`.

## Resultados fisicos informados pelo usuario

| Ensaio | Resultado |
|---|---|
| Video F-16 inicia automaticamente | PASS |
| ATT BAD desaparece apos calibracao normal | PASS |
| Horizonte acompanha o MPU6050 | PASS |
| Bussola permanece visivel e fixa | PASS |
| Ladder mais limpa em roll proximo de 90 graus | PASS |
| CAP aparece na captura com HUD | PASS |
| Video retorna ao sair da captura | PASS |
| Joystick e buzzer funcionam | PASS |

Total: 8 de 8 verificacoes aprovadas.

## Rastreabilidade JTAG

Log JTAG localizado e coerente com o candidato.
- SHA-256 do log: `87ee3348b9c4fc1219b4fb09285f1d83f82c385871e6a7d8e9139520be62c40f`
- `PROGRAM_DONE=1`
- `JTAG_VOLATIL_PASS`

## Qualificacao Vivado

- WNS: +0,412 ns.
- WHS: +0,019 ns.
- WPWS: +4,020 ns.
- TNS/THS/TPWS: zero.
- CDC: 624 endpoints classificados como seguros;
  zero inseguros ou desconhecidos.
- Implementacao e verificacoes internas: PASS.

## Limites desta validacao

- Validacao funcional por JTAG, nao homologacao eletrica integral.
- Temporizacao externa SPI ainda nao formalmente qualificada.
- Mapeamento fisico do arquivo no microSD nao revalidado neste ensaio.
- Este teste nao demonstra boot QSPI da v1.1.
- A v1.0 permanece como versao estavel de recuperacao.
- Nao autoriza gravacao permanente da QSPI.

## Decisao

HUD v1.1 validado funcionalmente em ensaio fisico JTAG,
com oito verificacoes aprovadas conforme relato do usuario.
A promocao a firmware de boot permanente exige procedimento
e autorizacao separados.
