# HMC5883L na montagem final: coleta nivelada de 31/10/2026, 1245 amostras.
# X: 578..856; Y: -330..9. Offset = ponto medio, arredondado ao inteiro mais proximo.
# Ganho Q12 = media das amplitudes / amplitude do eixo * 4096.
# Recalibrar se mudar a posicao do sensor ou materiais proximos.
set_property generic {MAG_OFFSET_X=717 MAG_OFFSET_Y=-161 MAG_GAIN_X_Q12=4545 MAG_GAIN_Y_Q12=3727} [current_fileset]
