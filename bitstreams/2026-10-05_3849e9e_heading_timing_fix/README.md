# Correção de timing da fita de heading

Registro reconstruído a partir do [manifesto](MANIFEST.txt) e dos relatórios
arquivados, sem executar novo build ou validar a placa.

| Metadado | Registro |
| --- | --- |
| Commit-fonte | `3849e9e9f6c965dadc8556356dcad295141aa03e` |
| Branch na geração | `main` |
| Data | 05/10/2026 |
| Dispositivo / ferramenta | Nexys A7-100T, xc7a100tcsg324-1 / Vivado 2026.1 |
| Funcionalidade desta versão | HUD com otimização do caminho de desenho da fita de heading; anterior à integração HMC e à fusão heading/vertical |
| WNS / TNS | +0,288 ns / 0,000 ns |
| WHS / THS | +0,024 ns / 0,000 ns |
| Validação física deste artefato | **PENDENTE DE VALIDAÇÃO FÍSICA**; não atestada pelo manifesto |

O manifesto registra caminho `h_cont → VGA_G` de 37,117 ns para orçamento de
40 ns, margem de 2,883 ns. Essa medição de atraso não equivale a output delay
externo nem a comprovação elétrica da VGA. Timing interno está no
[relatório](timing_summary.rpt); [DRC](drc.rpt) e [recursos](utilization.rpt)
permanecem arquivados. Não atribuir os 46 testes da fusão a esta versão.

Arquivo: [top_reticula.bit](top_reticula.bit). SHA256, reconferido nesta auditoria:

```text
296a11e799682ad4b3a75e203813c490d8f96548c963abd839cdca17a2170e86
```

O [SHA256 original](SHA256.txt) foi preservado. Nenhum hardware foi programado.
