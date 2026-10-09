# Estudo de vídeo auxiliar

**Status: não implementado e fora do escopo atual do HUD.** O projeto produz VGA 640×480; não captura vídeo externo nem compõe um fundo de outra fonte. Não existem portas, constraints ou bitstream associados a esta proposta.

A saída VGA da Nexys A7 é uma saída analógica por DAC resistivo. Não conecte sinais RGB de outra VGA diretamente aos GPIOs ou ao conector VGA da placa. Captura requer hardware de entrada apropriado, compatibilidade elétrica e uma arquitetura de clock/memória; o XADC usado pelo joystick não substitui ADCs de vídeo.

Qualquer estudo futuro deve começar por requisito de fonte/resolução, interface elétrica documentada e estratégia de amostragem/CDC. Este documento preserva a observação histórica sem indicar que uma expansão foi aprovada ou implementada.
