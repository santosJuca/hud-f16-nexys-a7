# Alinhamento da bússola em +90°

O usuário pediu que uma indicação de 75° passe a 165°, sem mover os módulos nem alterar o horizonte. O perfil `mpu-left90-mag-right90-front180-hdg-plus90` soma 90° ao rumo, módulo 360, usando os parâmetros de montagem existentes. O vetor magnético corrigido passa de (−Y, X) para (−X, −Y). O sentido de resposta ao giro permanece igual.

Os offsets nativos X=717/Y=−161 e os ganhos Q12 X=4545/Y=3727 permanecem. Todo o RTL, a montagem do MPU, a frente de 180° e os 81 pinos/propriedades coincidem com a versão calibrada anterior. A mudança está no perfil do gerador e no teste do rumo; não há compensação nova de inclinação ou declinação geográfica.

Verificação: 1393 vetores em nove configurações, incluindo o caso exato 75° → 165°, wrap e perda do sensor; 124 verificações da fusão. Vivado terminou com saída zero, DRC sem erros, CDC com 500 caminhos seguros e nenhum inseguro/desconhecido. WNS +0,334 ns, WHS +0,014 ns, WPWS +4,020 ns; TNS/THS/TPWS zero.

Bitstream: `validation/hdg-plus90-20261031/implementation/experimental_attitude_capture.bit`. SHA-256: `f485be1fca9389cb8e50586984764f96f74678705d87a4f646d0b354ca679f32`. Evidências, backup verificado e entradas de build estão em `validation/hdg-plus90-20261031/`. O mapa do microSD é o mesmo registro local da versão operacional anterior; não houve releitura física nesta execução.

Estado: o usuário autorizou especificamente a versão f485be1f. Programação JTAG volátil concluída com saída zero, alvo/arquivo conferidos e DONE, INIT_B e fim de startup em 1. Na tela normal após sair do painel HEX, o usuário confirmou HDG 163°, ausência de ATT BAD e resposta do horizonte. O valor está próximo do exemplo solicitado de 165°; não se inferiu precisão absoluta a partir dessa comparação manual. A versão anterior `bcf166ae` está preservada para retorno. Nenhuma escrita de Flash ou microSD foi executada.
