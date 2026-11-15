# Preservação e recuperação

## Referências preservadas

- Main remota anterior: `0081e1dfc0e726c84a37bd41a31e9508d5876b48`.
- Diretório vídeo original: HEAD `90e5e78de190aaf0b8f34b38f9bb832142f7d550`; quatro testes modificados foram copiados para a integração e continuam intactos na origem.
- Firmware v1.0: tag `hud-v1.0-autozero-qspi`, commit `33bf42c`; boot por ciclo de energia relatado em 31/10.
- Firmware v1.1: commit funcional `622eacb`, tag `hud-v1.1-jtag-validated` em `1d39826`; oito ensaios JTAG relatados em 01/11.

| Artefato oficial | SHA-256 |
|---|---|
| v1.0 BIT | `58d71e7435640e3675e872dff2723aa263d33da523ed323867e03885b9e3474d` |
| v1.0 QSPI SPIx1 MCS | `cf8714e5c5bf671efb59c6c5e177109ef3aa63aa30af6e98c2a8db8492fb7176` |
| v1.1 JTAG BIT | `d9750085ce8dc2558372872d80734d13dff390354468241aa3cda972db8cfc07` |

Os arquivos das releases foram baixados para o backup e seus hashes conferidos. As releases existentes não foram substituídas. O pacote de relatórios v1.1 tem hash `00a3efa40d3813f55bbbb917ee4b6be0c6316aa591c0c8f3b5f81ff85b97fa23`.

## Backup local

Diretório: `/home/santojuca/Downloads/hud-consolidacao-backup-20261106`, com acesso de diretório restrito ao proprietário. Contém `repository.bundle` verificado, estados/patches binários dos quatro worktrees, tar dos arquivos modificados e novos conferido por releitura, refs/reflogs, inventário e hashes dos artefatos. `git-common-before-integration.tar.gz` preserva também objetos não alcançáveis; foi capturado no início da integração e não deve ser usado para substituir o `.git` ativo.

`SHA256SUMS` cobre a fotografia inicial; o manifesto complementar cobre os arquivos adicionados depois. Revalidar os manifestos antes de recuperar. Caches foram preservados no backup local quando presentes, mas não entraram nos commits.

## Recuperar fontes sem sobrescrever trabalho

```sh
git worktree add --detach ../hud-main-anterior 0081e1dfc0e726c84a37bd41a31e9508d5876b48
git worktree add --detach ../hud-v10-recuperacao hud-v1.0-autozero-qspi
```

Para recuperar o bundle em outro local, primeiro `git bundle verify /caminho/repository.bundle`, depois `git clone /caminho/repository.bundle hud-fontes-recuperadas`. O bundle conserva refs existentes no momento da preservação; o inventário registra os HEADs originais.

Patches e arquivos locais devem ser aplicados em nova branch/worktree correspondente ao HEAD registrado, usando `git apply --check` antes de `git apply`. Extraia os tar em diretório vazio e confira os hashes. Nunca extrair sobre os worktrees originais nem substituir o `.git` ativo.

Para reverter uma integração já publicada, abrir uma nova branch e PR de revert depois de inspecionar o merge; não reescrever a main. Nesta consolidação, a promoção continua condicionada aos bloqueios do relatório.

## Recuperar hardware

Nenhuma programação foi executada nesta consolidação. A QSPI v1.0 existente não foi alterada. Usar a release v1.0 e conferir o hash se for necessário voltar ao firmware conhecido. Programar JTAG ou regravar Flash exige identificação do dispositivo, arquivo exato e autorização própria; não automatizar gravação a partir deste relatório. O bitstream de simulação desta execução não é artefato de recuperação física.
