# Bancada de sobreposição VGA

Este registro descreve a montagem física em estudo para sobrepor o HUD da Nexys A7 ao sinal de uma fonte VGA externa. A sobreposição ainda não está implementada. Não houve alteração no RTL nem programação da placa para esta montagem.

## Cabos e estado da montagem

Há dois cabos VGA cortados e um cabo VGA íntegro. O cabo íntegro foi usado para validar a Nexys A7 e o HUD em um monitor extra; o HUD apareceu normalmente. O adaptador DP–VGA disponível está rompido e não foi usado como caminho funcional de teste.

Entre os dois cabos cortados, os condutores de sincronismo foram ligados e soldados com a mesma numeração: pino 13 com pino 13 (HSYNC), pino 14 com pino 14 (VSYNC) e pino 10 com pino 10 (GND de sincronismo). As emendas foram isoladas. Foram feitos testes de continuidade. A correspondência de cada fio e blindagem com os pinos deve ser confirmada individualmente com multímetro em cada cabo antes de energizar ou prosseguir com as ligações.

## Mapeamento observado

As cores abaixo registram a identificação informada na bancada. São uma referência provisória, não substituem a confirmação elétrica com multímetro. A associação exata dos retornos 6, 7 e 8 às blindagens/fios de retorno ainda precisa ser verificada em cada cabo.

| Pino VGA | Sinal / identificação informada | Condutor observado | Situação |
| --- | --- | --- | --- |
| 1 | R (vermelho) | Rosa, blindado | Identificação informada; confirmar com multímetro |
| 2 | G (verde) | Branco, blindado | Identificação informada; confirmar com multímetro |
| 3 | B (azul) | Azul, blindado | Identificação informada; confirmar com multímetro |
| 6 | Retorno associado a blindagem/fio de retorno | Correspondência individual não confirmada | Pendente |
| 7 | Retorno associado a blindagem/fio de retorno | Correspondência individual não confirmada | Pendente |
| 8 | Retorno associado a blindagem/fio de retorno | Correspondência individual não confirmada | Pendente |
| 10 | GND de sincronismo | Vermelho | Ligado 10↔10, soldado e isolado; confirmar continuidade/pinagem |
| 13 | HSYNC | Verde, blindado; condutor central | Ligado 13↔13; confirmar continuidade/pinagem |
| 14 | VSYNC | Azul separado | Ligado 14↔14; confirmar continuidade/pinagem |

A cor azul aparece em duas identificações distintas: pino 3 (condutor blindado de B) e pino 14 (condutor separado de VSYNC). Não usar apenas a cor para identificar o pino.

## Medições e limites

Foram observadas medições DC de 0,36 V em HSYNC e 0,40 V em VSYNC quando o monitor era ligado ao cabo 1. Esses valores são leituras médias de multímetro nessa condição; não representam os níveis de pico nem caracterizam, por si só, os pulsos de sincronismo. Não usar essas leituras como prova de compatibilidade elétrica.

O módulo conversor lógico HV/LV baseado em BSS138 não serve para os sinais analógicos RGB e não garante compatibilidade de nível, polaridade ou temporização para HSYNC/VSYNC. RGB ainda não está interligado. A conexão de sincronismo e o mux analógico para selecionar ou combinar os sinais continuam pendentes.

## Próximas verificações de bancada

1. Com os cabos desenergizados e separados, mapear por continuidade cada condutor aos pinos VGA em ambos os cabos cortados, incluindo blindagens e retornos 6, 7 e 8.
2. Registrar os resultados de cada cabo separadamente. Não deduzir pinos pela cor ou por semelhança entre cabos.
3. Antes de conectar a Nexys A7 ou o monitor à montagem, definir e validar uma interface elétrica apropriada para RGB analógico e para os sinais de sincronismo.
4. Só depois avaliar a implementação do mux e realizar novos testes, mantendo o cabo VGA íntegro como referência de funcionamento.
