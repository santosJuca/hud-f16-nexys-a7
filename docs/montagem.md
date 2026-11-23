# Montagem e interfaces do HUD

O responsável pelo projeto confirmou uma caixa de madeira e uma caixa separada para
a FPGA Nexys A7-100T. A posição interna dos módulos, as dimensões e os detalhes
mecânicos das duas caixas estão **indeterminados**.

| Classificação | Evidência |
| --- | --- |
| **Implementado** | Os aceites do 5D7A3AE2 registram saída VGA com HUD e vídeo do microSD, resposta do horizonte com MPU6050, resposta da bússola/calibração com HMC5883L e boot após ciclo de energia. |
| **Documentação válida** | O XDC do perfil escolhido define sinais e pinos na FPGA. As pranchas do atlas são referência para comparar essas interfaces com a bancada. |
| **Indeterminado** | A fiação física completa, o circuito efetivamente montado do buzzer, os módulos auxiliares e o seu posicionamento exigem evidência específica da bancada. |
| **Experimental** | Os modelos de gabinete F-16 e Stealth V3 são projetos preliminares preservados no histórico. |
| **Obsoleto para a montagem atual** | Os esquemáticos de 13/10 descrevem a configuração histórica, inclusive o mapeamento anterior do buzzer. |

Para o firmware de bancada, use as [constraints do 5D7A3AE2](../firmware/calibracao-guiada-5d7a3ae2/hud/constraints/)
e os [aceites](../firmware/calibracao-guiada-5d7a3ae2/aceites/). Para a base, consulte
a [pinagem v1.1](pinagem.md). O [atlas](atlas-eletrico/README.md) inclui sensores,
joystick e buzzer, com o alcance descrito em cada prancha.

Para o candidato documental mais recente, use a [pinagem v1.2 12000007](hud-v12-12000007/pinagem.csv) e as constraints das fontes identificadas na [release da configuração](https://github.com/santosJuca/Trabalho-display-aviao-v2/releases/tag/docs-hud-v12-12000007-vivado-20261123). Essa pinagem é uma extração lógica do XDC; não comprova a fiação ou a validação física da montagem v1.2.
