# HMC5883L desta montagem: coleta nivelada de 19/10/2026, 882 amostras.
# X: -186..171; Y: -312..17. Offset = ponto medio.
# Ganho Q12 = media das amplitudes / amplitude do eixo * 4096.
# Recalibrar se mudar a posicao do sensor ou materiais proximos.
set_property generic {MAG_OFFSET_X=-8 MAG_OFFSET_Y=-148 MAG_GAIN_X_Q12=3935 MAG_GAIN_Y_Q12=4270} [current_fileset]
