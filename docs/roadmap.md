# Roadmap e prioridades

Referência: fusão implementada em `84411c3`, mantida fora da main até validação
física. As propostas abaixo não adicionam sensores, portas ou funcionalidades ao RTL.

## Concluído

- HUD VGA 640×480: retículo, horizonte/pitch ladder, roll, heading, escalas,
  números, altitude, velocidade inercial estimada e alvo gráfico.
- NORMAL/DECLUTTER, ORIGINAL/CAÇA e SENSOR/MANCHE com joystick proporcional.
- Drivers MPU6050, BMP085 e HMC5883L; atitude complementar accel + gyro.
- Fusão inicial de rumo magnético estimado e estado vertical com VSI interno.
- 46 bancos de simulação aprovados, síntese/implementação e timing fechado no
  build registrado em [validação](validacao_fusao_sensores.md).
- Documentação de interfaces, pinagem, recursos, limitações e proposta de vídeo.

“Concluído” nesta seção indica implementação/validação digital. Não equivale a
calibração dos sensores nem aprovação física de toda a fusão.

## Em validação física

**PENDENTE DE VALIDAÇÃO FÍSICA**. A placa ficou desligada nesta revisão.

| Atividade | Evidência necessária para concluir |
| --- | --- |
| Eixos MPU, +Z e gyro Z | Montagem registrada e resposta correta nos dois sentidos |
| Orientação HMC/MPU e hard-iron | Amostras XYZ, offsets medidos e giro completo comparado com referência |
| Atitude inclinada | Sinais e estabilidade em pitch/roll conhecidos |
| Altitude/VSI | Referência barométrica, movimento vertical conhecido, repouso e retorno |
| Velocidade inercial estimada | Drift documentado; não interpretar como airspeed |
| Temperatura, vibração e ruído | Séries temporais em repouso e após aquecimento |
| Perda/recuperação de sensores | Fonte selecionada, retenção e recalibração observadas no HUD |

## Próxima etapa

Priorizar calibração e diagnósticos antes de ampliar o desenho ou integrar vídeo.

| Prioridade | Proposta | Motivo / dependência |
| --- | --- | --- |
| A | Hard-iron real | Principal pré-requisito da referência magnética; conservar dados e montagem |
| A | Tilt compensation do HMC | Implementar XYZ isolado e testado após validar alinhamento MPU/HMC; conferir timing |
| A | Indicação SENSOR/MANCHE e fonte/validade | Evita confundir fallback numérico e valor retido com medição atual |
| A | Status por sensor e fault flags | Separar identificação, calibração, dado recente e estimativa válida |
| A | Detecção de dados vencidos | Auditar cada driver; barômetro pode repetir pressão sem emitir nova altitude |
| A | Monitoramento de drift e ajuste complementar | Medir primeiro, justificar ganhos, conservar testes de dt e wrap |
| A | Documentação automática dos resultados | Gerar manifest com commit/fontes, testes, timing, DRC, recursos e SHA256; não declarar PASS só pela existência de arquivos |
| B | VSI visual | Estimador já existe; validar fisicamente antes de apresentar como instrumento confiável |
| B | Diagnóstico no HUD e qualidade/confiança | Indicadores baseados em critérios medidos; não inventar porcentagem de confiança |
| B | Logger/debug UART e telemetria simples | Usar ponte USB-UART onboard; timestamp, fontes, validade e unidades explícitas |
| B | Fusão vertical melhorada | Avaliar rejeição de outliers, bias térmico e dinâmica após logs; manter saturação e fallback |
| B | Declinação magnética configurável | Parâmetro geográfico com sinal/unidade/data documentados; até lá o rumo permanece magnético |
| B | Self-test funcional | Padrões internos e flags de comunicação; distinguir de autoteste físico do sensor |
| C | Soft-iron | Requer coleta e ajuste matricial confiáveis; implementar após hard-iron e alinhamento |
| C | Versão/build ID no HUD | Ajuda na bancada; opcional e sem comprometer legibilidade/timing |

Classificação: **A recomendada**, **B interessante**, **C opcional**, **D não vale
a pena agora**. B/C não significam ausência de utilidade; refletem dependências e
escopo acadêmico atual. Cada etapa deve ter testes isolados antes de integrar ao top.

## Futuro

| Prioridade | Proposta | Condição para iniciar |
| --- | --- | --- |
| B | Fundo digital controlado e compositor | Contrato simples, resolução reduzida e critérios do [estudo VGA](vga_auxiliar.md) |
| C | Captura VGA analógica real | Front-end ADC/conversor compatível, orçamento de pinos e clock validado |
| C | Framebuffer DDR2 de resolução completa | Necessidade demonstrada, controlador e banda efetiva dimensionados |
| D | Overlay analógico externo nesta etapa | Exige genlock e eletrônica de vídeo; avaliar apenas com meios de medição |
| C | BMP390 em substituição ao BMP085 | Novo driver/compensação e calibração; não necessário enquanto BMP085 atende |
| D | Trocar HMC por QMC apenas por disponibilidade | Não é drop-in; exige driver próprio e nova validação magnética |
| C | GPS/GNSS | Poderia corrigir ground speed; não mede airspeed |
| C | Pitot + pressão diferencial | Caminho para airspeed real; exige sensor, calibração e modelo de conversão apropriados |
| D | EKF amplo, GPS fictício ou airspeed por integração do MPU | EKF amplia escopo sem dados de validação; as duas últimas propostas são conceitualmente incorretas |

As antigas sugestões de módulos GNSS e pressão diferencial eram possibilidades,
não compras aprovadas. Selecionar componentes somente com requisitos definidos e
documentação atual do fabricante.

## Critério para avançar de etapa

Manter mudanças pequenas e a fusão isolada. Exigir testes existentes e novos,
compilação estrutural, documentação coerente e `git diff --check` limpo. Mudanças
que afetem implementação exigem Vivado, DRC e timing positivos. Registrar limitações
e evidência física separadamente; não fazer merge automático na main nem programar
a placa como efeito colateral do build.
