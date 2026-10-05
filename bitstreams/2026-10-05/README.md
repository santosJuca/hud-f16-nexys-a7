# Bitstream de 05/10/2026

Arquivo: [top_reticula.bit](top_reticula.bit), gerado às 10:51:43 (UTC−03:00).
Fonte: commit `9c25900bf18e9d98687c6274e1829073f96ccbca`, sem alterações de RTL ou constraints.
Vivado 2026.1, FPGA `xc7a100tcsg324-1`, top `top_reticula`.

**Publicado com pendência de temporização VGA. A validação global de timing não está aprovada.**
O caminho de `h_cont_reg[7]` até `VGA_G[0]` tem atraso de 42,597 ns,
superior ao período de pixel de 40 ns. A saída está sem restrição de delay
externo, portanto esse caminho não entra no WNS e não possui slack finito.
Consulte o [relatório do caminho](vga_h_cont_paths.rpt).

Resultados registrados na validação desta geração:

| Verificação | Resultado |
|---|---|
| Testes | 36/36 PASS, exit code 0 |
| Síntese e implementação | PASS, Vivado exit code 0 |
| WNS / TNS nas restrições existentes | +0,289 ns / 0,000 ns |
| WHS / THS nas restrições existentes | +0,035 ns / 0,000 ns |
| DRC | 0 erros, 0 critical warnings, 36 warnings |
| Endpoints internos sem restrição | 0 |
| Entradas / saídas sem delays externos | 4 I²C / 19 saídas |
| Entradas manuais com false paths | 9 |
| Utilização | 8.950 LUTs, 4.880 registradores, 13 DSPs, 0 BRAM |
| Tamanho | 3.825.992 bytes |

Os 73 arquivos fonte e o SHA256 foram conferidos novamente antes da publicação.
Esta publicação não corrige o caminho VGA nem comprova sua temporização completa.

Para conferir a integridade, execute nesta pasta:

```sh
sha256sum -c SHA256SUMS
```
