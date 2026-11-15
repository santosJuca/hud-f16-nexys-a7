# Bitstream experimental com buzzer em JD4, 30/10/2026

Novo bitstream gerado pelo Vivado 2026.1 para `xc7a100tcsg324-1`, a partir da branch `feat/video-sd-overlay`, HEAD `2005efc97251ebafc9fede68a248b47bbb000607` e das alterações locais existentes. Houve nova síntese, posicionamento, otimização física e roteamento. O build terminou com código 0.

O projeto roteado confirma `buzzer_out=G3/JD4`, `LVCMOS33`, com proprietário exclusivo. E6, usado anteriormente em JC10, ficou sem porta atribuida. Não houve mudança no RTL nesta execução.

## Perfil e preservacao

Video RGB332 de 160x120 a 1 FPS, leitura SPI half=125, LBA=30006144 e 21965 setores. Sistema em 100 MHz e pixel em 25 MHz. Video, overlay, atitude completa e captura permanecem habilitados; calibração magnética existente preservada.

Os 250 arquivos anteriores de RTL, constraints, scripts, testes, ferramentas, documentação, assets e arquivos de raiz incluídos no backup foram relidos do ZIP e conferidos por SHA-256. Todos permaneceram idênticos ao fim do build. O estado Git tambem permaneceu identico antes deste novo relatório. O bitstream anterior foi conferido pelo hash registrado e preservado.

Comparação com o manifesto final de atitude/captura: todos os demais RTL e constraints coincidem. Desfazer somente a troca JC10/E6 para JD4/G3 e seu comentário em memória reproduz os hashes anteriores do top e do XDC. A regressão ampla anterior não foi repetida; o testbench existente do buzzer foi executado novamente e passou para cadencias, debounce, ACK, escalada, fim, enable e reset.

## Verificação desta geração

| Verificação | Resultado |
| --- | --- |
| Setup WNS / TNS | +0.491 ns / 0 |
| Hold WHS / THS | +0.015 ns / 0 |
| Pulse width WPWS / TPWS | +4.020 ns / 0 |
| Endpoints internos sem restrição / sem clock | 0 / 0 |
| DRC | 0 erros; 106 avisos DSP: DPIP-1=36, DPOP-1=27, DPOP-2=43 |
| CDC | 352 endpoints seguros; 0 unsafe, unknown ou sem ASYNC_REG |
| Bus skew | 1,361 ns e 1,472 ns, limite 10 ns |
| Recursos após route | 15691 LUT; 10461 FF; 16 RAMB36 + 2 RAMB18; 62 DSP |

Os avisos DSP não foram ocultados: são 106 nesta implementação, contra 102 no relatório anterior. A margem de hold de 0,015 ns atende nesta execução, mas continua pequena. Permanecem 28 entradas sem input delay e 38 saídas sem output delay; o fechamento das restricoes internas não qualifica a interface externa SPI.

## Artefatos

- [Bitstream experimental](../validation/hud-jd4-20261030-rebuild/implementation/experimental_attitude_capture.bit)
- [Resultado e hashes](../validation/hud-jd4-20261030-rebuild/result.json)
- [Log do Vivado](../validation/hud-jd4-20261030-rebuild/vivado.log)
- [Relatorios e checkpoint roteado](../validation/hud-jd4-20261030-rebuild/implementation/)
- [Backup verificado](../validation/hud-jd4-20261030-rebuild/sources-before.zip)

SHA-256 do bitstream: `310ebe925a16ca53a22a64368de4f765a1e9a444caaf39a0db26e721e155736a`.

SHA-256 do checkpoint roteado: `0c73307f8770028c767ba263d853f146e861cf2a054ddc05de7918ce49c77ecd`.

## Limites e próxima ação

Artefato experimental. O mapa FAT32 e histórico: o SHA-256 e o cabeçalho da referência local `HUDVIDEO.BIN` conferem com o mapa arquivado, mas `/dev/sdc` aparece com capacidade 0 e não permitiu revalidação física nesta execução. Isso não informa se o cartão está atualmente no slot da Nexys. Revalidar o mapa antes de usar o artefato na placa.

O usuário confirmou que a montagem segue o atlas atualizado, incluindo o controle em JD4 e a identificação B/C/E do transistor real, e informou que o cartão está no slot da Nexys A7. Em seguida autorizou explicitamente: “ok lIGUEI O fpGA PODE GRAVAR”.

A programação volátil JTAG foi concluída em 30/10/2026, na Nexys identificada como `Digilent/210292AD34F5A`, FPGA `xc7a100t`. O script conferiu o SHA-256 do bitstream e a identidade do alvo antes da programação. Após a gravação, confirmou `PROGRAM_DONE=1`, `END_OF_STARTUP=1`, `INIT_B=1` e `DONE_PIN=1`. A autorização, o log e o resultado estão em `validation/hud-jd4-20261030-rebuild/program-jtag-authorized/`.

Não houve gravação de Flash nem escrita no microSD. A autorização foi executada com o mapa arquivado; não houve releitura física do cartão. Continuam pendentes a observação da imagem VGA, o teste físico do acionamento do buzzer em JD4 e a qualificação elétrica e temporal externa do SPI, conforme `orcamento_temporal_spi_20261030.md`. A confirmação JTAG comprova a configuração da FPGA, sem comprovar essas funções em bancada.

Evidências em `validation/` são locais e ignoradas pelo Git. Este relatório não publica nem incorpora as alterações locais anteriores.
