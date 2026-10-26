# Bancada de sobreposição VGA

Este registro descreve a montagem física em estudo para sobrepor o HUD da Nexys A7 ao sinal de uma fonte VGA externa. A sobreposição ainda não está implementada. Não houve alteração no RTL nem programação da placa para esta montagem.

## Cabos e estado da montagem

Há dois cabos VGA cortados e um cabo VGA íntegro. O cabo íntegro foi usado para validar a Nexys A7 e o HUD em um monitor extra; o HUD apareceu normalmente. O adaptador DP–VGA disponível está rompido e não foi usado como caminho funcional de teste.

Entre os dois cabos cortados, os condutores de sincronismo foram ligados e soldados com a mesma numeração: pino 13 com pino 13 (HSYNC), pino 14 com pino 14 (VSYNC) e pino 10 com pino 10 (GND de sincronismo). As emendas foram isoladas e passaram por teste de continuidade. O operador informou que já mapeou os fios dos cabos por pino; o registro abaixo segue esse mapeamento.

## Mapeamento observado

O mapeamento abaixo foi informado pelo operador como já conferido. Nos pinos 6, 7 e 8, os retornos são fios junto ao conjunto dos fios blindados, com um fio extra. O registro não atribui cores individuais a esses retornos.

| Pino VGA | Sinal / identificação informada | Condutor observado | Situação |
| --- | --- | --- | --- |
| 1 | R (vermelho) | Rosa, blindado | Mapeado pelo operador |
| 2 | G (verde) | Branco, blindado | Mapeado pelo operador |
| 3 | B (azul) | Azul, blindado | Mapeado pelo operador |
| 6 | Retorno R | Fio de retorno junto aos fios blindados, com fio extra | Mapeado pelo operador |
| 7 | Retorno G | Fio de retorno junto aos fios blindados, com fio extra | Mapeado pelo operador |
| 8 | Retorno B | Fio de retorno junto aos fios blindados, com fio extra | Mapeado pelo operador |
| 10 | GND de sincronismo | Vermelho | Mapeado; ligado 10↔10, soldado e isolado |
| 13 | HSYNC | Verde, blindado; condutor central | Mapeado; ligado 13↔13 |
| 14 | VSYNC | Azul | Mapeado; ligado 14↔14 |

A cor azul aparece em duas identificações distintas: pino 3 (condutor blindado de B) e pino 14 (condutor separado de VSYNC). Não usar apenas a cor para identificar o pino.

## Medições e limites

Foram observadas medições DC de 0,36 V em HSYNC e 0,40 V em VSYNC quando o monitor era ligado ao cabo 1. Esses valores são leituras médias de multímetro nessa condição; não representam os níveis de pico nem caracterizam, por si só, os pulsos de sincronismo. Não usar essas leituras como prova de compatibilidade elétrica.

O módulo conversor lógico HV/LV baseado em BSS138 não serve para os sinais analógicos RGB e não garante compatibilidade de nível, polaridade ou temporização para HSYNC/VSYNC. RGB ainda não está interligado. A conexão de sincronismo e o mux analógico para selecionar ou combinar os sinais continuam pendentes.

## Próximas verificações de bancada

O mapeamento dos fios foi concluído. Antes de conectar a Nexys A7 ou o monitor à montagem, ainda é necessário definir e validar uma interface elétrica apropriada para RGB analógico e para os sinais de sincronismo. Depois disso, avaliar a implementação do mux e realizar novos testes, mantendo o cabo VGA íntegro como referência de funcionamento.
