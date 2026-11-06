# HUD FPGA Stealth V3 — engenharia mecânica preliminar

Data: 15/10/2026. Unidade: milímetro. **Não liberado para impressão nem montagem elétrica final.**

## Entrega

A V3 transforma a fuselagem conceitual em uma carcaça oca, com piso removível por baixo e tampa removível por cima. Mantém o contorno externo XY da V2, asas delta, cockpit facetado, duas derivas e apliques azuis. A tampa agora cobre todo o contorno: substitui a tampa visual central flutuante da V2. A silhueta e o envelope externo foram preservados; a divisão construtiva foi alterada.

- `HUD_FPGA_Stealth_V3.FCStd`: montagem FreeCAD com peças BRep independentes e grupos separados para referência e reservas.
- `Gerar_HUD_FPGA_Stealth_V3.FCMacro`: fonte de geração com parâmetros de projeto. Executar junto da pasta `referencias`. Salva/regenera somente arquivos V3 nesta pasta; use uma cópia da pasta para preservar edições manuais anteriores.
- `exportacoes_PRELIMINARES`: cinco STEP individuais, cinco STL fechados e um STEP do conjunto sem eletrônica.
- `V3_montada.png` e `V3_layout_interno.png`: vistas renderizadas do CAD. Verde = caixa de referência, não a placa; âmbar = volumes estimados, não modelos dos módulos.
- `verificacao_V3.json` e `auditoria_final.json`: resultados geométricos e checagem de preservação.
- `referencias`: cópias dos originais e ZIP; `manifesto_fontes.json` registra caminhos e SHA-256. Nenhum original foi modificado.

O FCStd contém sólidos editáveis por operações do FreeCAD, **não uma árvore completa de sketches cotados nem parâmetros vinculados**. As propriedades em `Notas de projeto` são informativas. Para alterar espessuras e disposições de forma reproduzível, editar a macro e regenerar; para alterações locais, usar ferramentas Part/Part Design em uma cópia do FCStd.

## Medidas confirmadas no CAD

“Confirmado no CAD” descreve o arquivo fornecido; não equivale a medição da placa física.

| Item | Medida / posição | Evidência |
|---|---|---|
| Envelope externo V2/V3 | 275,3578 × 432,458 × 74 | Bounding boxes, sem escala |
| Corpo central XY | X −79,219…196,1388; Y −46,619…155,839 | Contorno externo extraído da V2 |
| Base STEP de referência | 130,3578 × 116,458 × 12,82 | `base.step` do ZIP |
| Referência na V3 | X −4,219…126,1388; Y −3,619…112,839; Z 12…24,82 | Posição idêntica à V2 |
| Transformação ZIP → V2/V3 | Translação (0, 0, +22,82), sem rotação/escala | Diferença simétrica de volume = 0 mm³ |
| Quatro furos na caixa de referência | Ø3,2576; XY (3,81;3,81), (118,11;3,81), (118,11;105,41), (3,81;105,41) | Superfícies cilíndricas 72/78/85/91 de `base.step` |
| Distâncias entre centros | 114,30 × 101,60 | Coordenadas dos furos da caixa; compatibilidade com PCB não comprovada |
| Contato dos apoios com a caixa | 113,0973 mm² por apoio, quatro apoios | Interseção das faces de apoio em Z=12 com referência |

A V1 também contém a mesma referência, em outra altura. Seus volumes conceituais foram inspecionados, mas não usados como cotas de componentes. A tampa `Lids/default.step` foi inspecionada; está em outro referencial espacial. Não foi alinhada por suposição nem usada para localizar interfaces.

## Construção proposta

| Peça | Configuração |
|---|---|
| Base removível | Piso 3 mm; quatro apoios Ø12 com topo em Z=12; batentes com folga nominal de 0,6 mm para o envelope da caixa; duas plataformas de protoboard com topo Z=5 |
| Fuselagem + asas | Parede obtida por offset interno de 3 mm; Z=3…28; asas originais integradas, espessura 9 mm, Z=3…12 |
| Tampa | Z=28…31; cockpit e duas derivas integrados; cockpit escavado por baixo, parede lateral proposta 2,5 mm e teto 3 mm |
| Apliques | Duas peças azuis de 1,4 mm; adesivação proposta, sem encaixes mecânicos |
| Fixação da carcaça | Quatro colunas Ø9 com pontes até a parede; coordenadas XY (10;−39), (105;−39), (10;148), (105;148) |
| Parafusos propostos | Quatro por cima + quatro por baixo; passantes Ø3,4 e pilotos cegos Ø2,5 com 8 mm de profundidade. Proposta para rosca M3 após preparação/ensaio; não há roscas modeladas |

Os pilotos superior e inferior ficam separados por material. Não usar parafusos que ultrapassem os 8 mm de engajamento disponível. Comprimento final, cabeça, material, método de rosca e repetibilidade de abertura devem ser escolhidos e ensaiados. Cabeças externas aumentam o envelope; não estão modeladas. As juntas são planas, sem vedação ou encaixe de centragem.

A caixa interna repousa sobre os quatro apoios; os batentes limitam deslocamento lateral. **Sua retenção vertical ainda não foi projetada.** Os apoios são para a caixa STEP, não espaçadores certificados para a PCB nua. Não apoiar diretamente a Nexys nesses pontos sem medir seu lado inferior.

A montagem deve começar com a carcaça vazia: fixar o piso, colocar a caixa de referência, organizar os módulos e fechar a tampa. Para remover o piso, retirar antes a eletrônica e cabos que ele sustenta. A tampa sai em +Z, a base em −Z. O acesso aos quatro parafusos superiores está fora das reservas de protoboard; o acesso inferior pressupõe virar o conjunto desenergizado e apoiado.

## Layout interno e evidência dos módulos

Consulta somente de leitura ao repositório `santosJuca/Trabalho-display-aviao-v2`, árvore `791339ac312aaa499771c985dd96095a9cddd283`. README, documentos de sensores/pinagem/demonstração e esquema SVG identificam KY-023, MPU-6050/GY-521, BMP085/SEN-09694 e HMC5883L. Não foram encontradas cotas mecânicas das protoboards nos arquivos consultados. O usuário confirmou duas protoboards iguais. O repositório e os arquivos eletrônicos não foram alterados.

| Reserva | Tamanho adotado (estimativa) | Posição mínima XYZ |
|---|---|---|
| Protoboard esquerda | 72 × 28 × 12 | 24,9599; −38,619; 5 |
| Protoboard direita | 72 × 28 × 12 | 24,9599; 119,839; 5 |
| KY-023 | 24 × 24 × 20 | −44; 42,61; 5 |
| MPU-6050/GY-521 | 25 × 18 × 12 | 137; 12; 5 |
| BMP085 | 20 × 18 × 12 | 137; 43; 5 |
| HMC5883L | 20 × 18 × 12 | 137; 76; 5 |
| Buzzer | Ø20 × 12 | Centro XY 173;55, base Z=5 |

As reservas de protoboard mantêm os 72 × 28 mm adotados no conceito V2; **não são dimensões confirmadas das duas unidades reais**. A altura 12 mm é proposta e não cobre necessariamente fios/jumpers. Não há modelo da PCB Nexys, corpo/movimento do manche, conectores montados, chicotes, driver do buzzer ou parafusos de módulos. O joystick, sensores e buzzer possuem espaço reservado, mas suportes e retenção específicos ainda estão pendentes. As plataformas de protoboard admitem uma futura fixação adesiva, também não validada.

## Interfaces: cortes deliberadamente pendentes

Não foram criados recortes para SW0–SW15, VGA, USB ou alimentação. Os arquivos disponíveis identificam circuitos e uma caixa, mas não comprovam as coordenadas XYZ das interfaces da placa montada. Recortes existentes no STEP da caixa não foram identificados automaticamente como conectores. A tampa fechada ainda bloqueia o acionamento do joystick e o acesso aos controles. Portanto esta V3 **não é uma caixa operacional completa**: entrega a primeira engenharia mecânica e o layout para validação.

Para a próxima revisão, registrar origem e orientação da placa; posição dos 16 switches, extremos da fileira, curso e altura das alavancas; caixas envolventes e eixos de inserção de VGA/USB/alimentação; espaço para carcaças dos plugs, parafusos VGA e raio de curvatura dos cabos. Registrar também acesso a BTNU/BTND/BTNC, LEDs e cabeçalhos JD/JC/JXADC usados no repositório. Só então transformar essas medidas em volumes de corte, manter tolerâncias explícitas e verificar a inserção dos cabos no CAD.

## Verificação executada

- Cinco peças: uma região sólida válida por peça, volume positivo e STL fechado.
- Nenhuma interseção volumétrica entre as peças da carcaça montada.
- Nenhuma interseção das sete reservas estimadas com a carcaça, com a caixa de referência ou entre si.
- Nenhuma interseção entre a caixa de referência e a carcaça; contato de apoio em quatro discos confirmado.
- Reabertura do FCStd e reimportação dos cinco STEP: sólidos válidos; maior diferença de volume inferior a 0,000001 mm³.
- Remoção de base/tampa amostrada em 0,1/1/3/8/15/30/60/100 mm: sem interferência com as demais peças da carcaça. Não é análise contínua de movimento e exclui parafusos, hardware e cabos.
- SHA-256 dos quatro arquivos-fonte original/cópia conferido após o trabalho, sem alteração.
- Inspeção visual das vistas renderizadas.

Esses resultados validam a geometria gerada, não o encaixe dos componentes físicos, rigidez, temperatura ou impressão.

## Pendências para fabricação e uso

1. Medir as duas protoboards completas, incluindo abas/trilhos/adesivo, módulos e jumpers; revisar as reservas iguais sem presumir o tamanho.
2. Confirmar revisão/orientação da Nexys e seus furos, componentes inferiores, conectores e altura montada; finalizar retenção da caixa ou substituir por suporte direto validado.
3. Medir e modelar interfaces; criar janela dos switches, acesso aos botões/LEDs, joystick e passagens dos cabos.
4. Desenvolver fixações do KY-023, três sensores e buzzer; prever orientação/calibração dos sensores, afastamento do magnetômetro do buzzer/ferragens, ventilação/equalização do barômetro e saída acústica.
5. Validar folgas com material e impressora escolhidos: cupom para Ø2,5/Ø3,4 e batentes, parafusos, empenamento e juntas.
6. Definir área útil da impressora. A peça fuselagem+asas tem envelope XY de 275,36 × 432,46 mm: ainda não foi segmentada para mesas menores. Conferir orientação real no fatiador; a tampa tem cockpit/derivas e exigirá avaliação de orientação e suportes.
7. Avaliar rigidez das asas, resistência das pontes/colunas, retenção vertical, acesso de ferramenta, chicotes, temperatura e isolamento na montagem real.
8. Revisar e aprovar protótipo físico antes de marcar qualquer STL como pronto para impressão final.

## Como abrir

Abrir o FCStd no FreeCAD. O grupo `Pecas V3` mostra a carcaça. Para ver o interior, ocultar `03 Tampa cockpit duas derivas` e ativar `Referencias NAO FABRICAR` e `Reservas ESTIMADAS NAO FABRICAR`. Nunca incluir esses dois grupos em STL de produção. Os STL fornecidos têm coordenadas de montagem e unidade convencional mm; no fatiador, posicionar cada peça na mesa e conferir escala.
