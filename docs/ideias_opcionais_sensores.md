# Ideias opcionais de expansão

Estas funcionalidades NÃO fazem parte do escopo atual obrigatório.
Implementar somente se houver tempo depois da versão principal estar estável.

## Sensores opcionais

- BMP390
  - Barômetro próprio para substituir o BMP085 emprestado.
  - Altitude barométrica real.

- QMC5883L / GY-271
  - Magnetômetro.
  - Heading absoluto 0–359 graus.
  - N/E/S/W relacionados ao norte magnético real.

- u-blox NEO-M8N
  - GNSS/GPS.
  - Posição geográfica real.
  - Ground speed real.

- Tubo de Pitot + Sensirion SDP31
  - Pressão diferencial.
  - Airspeed real.
  - Considerado expansão máxima / overkill para o trabalho.

## Prioridade

1. Manter projeto atual estável.
2. Finalizar documentação e validação em FPGA.
3. Se houver tempo, adicionar BMP390 e/ou QMC5883L.
4. GPS e Pitot ficam como expansão avançada.
