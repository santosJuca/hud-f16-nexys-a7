# Próximas etapas

O escopo atual é validar a montagem e registrar evidências do bitstream existente. Não há necessidade demonstrada de acrescentar funções ao HUD antes dessas verificações.

1. **Verificar eletricamente o KY-023 e o XADC.** Confirmar alimentação, terra comum, faixa dos eixos, pares diferenciais e correspondência entre movimento físico e direção indicada.
2. **Validar fisicamente o bitstream CAÇA.** Programar manualmente o artefato do [catálogo](../bitstreams/README.md) e conferir vídeo, mira e controles.
3. **Calibrar o HMC5883L.** Medir orientação e offsets na montagem; confirmar o sentido do heading e documentar que é magnético.
4. **Testar MPU-6050 e BMP085.** Registrar identificação, valores em condições conhecidas, invalidação e recuperação.
5. **Validar modos e alertas na FPGA.** Exercitar SOLO/VOO/POUSO, NORMAL/CAÇA, DECLUTTER, ACK lógico e combinações de alertas.
6. **Documentar resultados de bancada.** Registrar montagem, bitstream/hash, procedimento, leituras e critérios de aprovação/falha.
7. **Revisar constraints externas com evidência.** Usar especificações dos módulos e medições para decidir input/output delays; não inserir valores estimados sem fonte.
8. **Preparar apresentação e relatório acadêmico.** Separar resultados de simulação, implementação e teste físico.

O bitstream de 08/10 tem implementação roteada e slack interno positivo, mas a margem é pequena e a placa ainda não foi programada com essa versão. Nenhum resultado físico deve ser registrado como concluído até a execução e anotação dos testes.
