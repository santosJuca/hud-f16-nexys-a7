# HUD F-16 na Nexys A7-100T

HUD acadêmico em SystemVerilog para a Artix-7 `xc7a100tcsg324-1`. Gera VGA 640×480, combina instrumentos, sensores e vídeo RGB332 lido do microSD por SPI. O raster usa 25 MHz, 800×525 posições e **59,524 Hz**; a taxa de quadros novos do arquivo é independente desse refresh.

## Estado da consolidação de 06/11/2026

A branch de integração reúne o firmware v1.1, as correções locais dos testes, a documentação de bancada, o CAD Stealth V3 e os arquivos recuperados do gabinete F-16 v1.3.2. O [relatório de consolidação](docs/consolidacao_20261106/README.md) contém inventário das 22 branches, decisões por funcionalidade, testes e bloqueios de promoção.

O RTL funcional coincide com `622eacb`, ensaiado por JTAG na v1.1. O [registro físico v1.1](docs/HUD_V1_1_VALIDACAO_FISICA.md) relata oito verificações aprovadas em 01/11. A [v1.0](docs/HUD_V1_0_ESTAVEL.md) permanece a referência de boot QSPI confirmado. Esses relatos pertencem aos bitstreams identificados, não comprovam qualquer novo build desta consolidação.

**O aceite físico da consolidação está pendente.** Os relatos de desaparecimento do vídeo, deslocamento da bússola e inconsistência angular durante ajustes continuam como riscos até ensaio dirigido na placa. Simulação e timing interno não encerram essa pendência. Não há programação automática de JTAG/Flash nem escrita no cartão neste fluxo.

## Funcionalidades presentes

- VGA RGB444; retículos ORIGINAL/CAÇA, NORMAL/DECLUTTER, horizonte completo, ladder de pitch, heading, fitas laterais, números e alertas.
- MPU6050: I²C, calibração, estimador vetorial com giroscópio/acelerômetro, CORDIC, referência de zero automática e manual, validade e recuperação. A cadeia complementar legada continua disponível por parâmetro.
- HMC5883L: calibração específica da montagem, rumo planar e fusão com gyro Z. BMP085: compensação de pressão/temperatura, altitude e estado vertical.
- KY-023 por XADC, movimento fixo de quatro pixels por tick e LOCK independente nos dois estilos; buzzer e ACK por BTNC.
- SDHC/SPI: inicialização, CMD17, CRC16, timeout, diagnóstico de setor e ícone, dois bancos BRAM com troca em blanking, reprodução em loop e retenção do último quadro íntegro em falhas.
- Captura com passo por quadro, quatro vistas, grade/diagnóstico, indicador CAP e ajuste vertical do HUD sem alterar os ângulos estimados.

O perfil fisicamente ensaiado usa arquivo **160×120 a 1 FPS solicitado**, escalado ao raster 640×480, divisor SPI half=125. O RTL também admite 320×240, com evidência histórica de simulação/implementação; não é outra resolução de saída VGA nem aprovação de FPS físico maior. A taxa real depende do cartão e das repetições de quadros.

## Controles e montagem

Consulte o [guia operacional](docs/GUIA_OPERACIONAL_HUD_V1_1.md) e a [pinagem atual](docs/pinagem.md). SW4 seleciona alinhamento; BTNU/BTND então deixam de ajustar rumo. Na captura, os botões têm funções próprias. SW5–SW7 também selecionam páginas do diagnóstico; não são controles independentes em todos os contextos.

O buzzer atual sai em **JD4/G3** via estágio externo; JA1/C17 recebe o botão do joystick. Documentos antigos registram outras ligações. O [atlas elétrico](docs/atlas-eletrico/README.md) descreve a montagem, mas não substitui medição: a faixa unipolar do XADC é nominalmente 0–1 V e houve relato de sobretensão. Não repetir uma conexão ainda não conferida.

## Obter e testar

```sh
git clone https://github.com/santosJuca/Trabalho-display-aviao-v2.git
cd Trabalho-display-aviao-v2
sudo apt-get install iverilog verilator make g++ python3 python3-pil ffmpeg
scripts/test.sh
python3 -m unittest discover -s tests -p 'test_*.py'
scripts/test_attitude_capture.sh build/capture
```

Use diretório novo em cada execução de captura/vídeo; os scripts recusam reutilizá-lo. [Cobertura e limites dos testes](docs/testes.md). O workflow em `.github/workflows/ci.yml` executa as três verificações acima e conserva logs/capturas. O teste isolado de vídeo é `scripts/test_video.sh build/video`.

## Compilar no Vivado

Ferramenta de referência: **AMD Vivado 2026.1**. Carregue `settings64.sh` da instalação para disponibilizar `vivado` no PATH. Simulações usam `tests/xadc_stub.sv`; esse stub não faz parte da síntese.

HUD sem vídeo, com os parâmetros padrão e a calibração magnética versionada:

```sh
vivado -mode batch -source scripts/build_vivado.tcl
```

Saída: `build/vivado/reticula.runs/impl_1/top_reticula.bit`. Esse comando **não habilita o subsistema SD**. Preserva builds anteriores em `build/before-*` e bloqueia bitstream em caso de falha de síntese, implementação, setup/hold ou DRC com erros.

Vídeo em cartão real exige `HUDVIDEO.BIN` contíguo e mapa FAT32 conferido. FFmpeg e necessario tanto para converter videos reais como para gerar as fixtures sinteticas dos testes. Converter gera apenas arquivos locais; copiar para cartão e programar a FPGA são operações separadas. Nunca usar um LBA histórico como mapa de outro cartão.

```sh
python3 tools/convert_video_for_fpga.py --help
python3 tools/map_sd_video.py --help
python3 tools/build_video_bitstream.py build/video-mapeado --map /caminho/mapa.json --read-half 125 --mounting mpu-left90-mag-right90-front180-hdg-plus90
```

O wrapper reconfere o arquivo/dispositivo em modo de leitura antes de compilar; recusa mudanças de LBA, conteúdo ou cabeçalho. O perfil de montagem acima pertence à montagem ensaiada, não é universal. Sua saída é `experimental_attitude_capture.bit`; sem `--mounting` especial, o fluxo original produz `experimental.bit`. Veja o [procedimento de vídeo](docs/reproducao_video_microSD_overlay_HUD.md) para formato, mapeamento e limites elétricos. Um build de simulação não deve ser programado como vídeo real.

## Mecânica, histórico e recuperação

- [Gabinete F-16 v1.3.2](gabinete/HUD_F16_V1_3_2_PUBLICACAO_ATOMICA/README_IMPORTACAO.md): dois STEP com hashes originais, DXF, manual e inventário; fontes auxiliares ainda ausentes. Fabricação bloqueada.
- [Stealth V3](mechanical/HUD_FPGA_Stealth_V3/README.md): projeto FreeCAD editável, macro, STEP/STL e referências, todos preliminares.
- [Recuperação](docs/consolidacao_20261106/recuperacao.md): backup, commits anteriores e artefatos oficiais.
- [Índice técnico](docs/README.md), [arquitetura](docs/arquitetura.md), [sensores](docs/sensores.md) e [catálogo de bitstreams](bitstreams/README.md).

O plano v1.2 é apenas documental. Captura de VGA externa, genlock e chave RGB analógica continuam experimentais no PR #5; não são o vídeo microSD. Velocidade de voo é simulada, heading não tem compensação de inclinação/declinação, LOCK não rastreia alvos e este projeto não é instrumento aeronáutico certificado.
