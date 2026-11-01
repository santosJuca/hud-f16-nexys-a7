# Partida automática do MPU antes do vídeo

Na versão f485be1f, o usuário observou ATT BAD após mais de um minuto com a base nivelada e imóvel, sem BTNL, enquanto LD4 indicava comunicação com o MPU. Pausar o vídeo por BTNL longo, na página 1 e com SW7=0, fez o aviso desaparecer e o horizonte responder em poucos segundos, sem abrir o painel HEX nem pedir zero. O teste isolou a dependência da atividade de vídeo; o mecanismo elétrico não foi medido.

A correção adia a leitura contínua do vídeo até a primeira atitude válida e calibrada do MPU, com a fonte real selecionada. A inicialização do cartão continua normal. O vídeo é liberado automaticamente após essa condição, sem BTNL; não volta a ser bloqueado por uma perda posterior do sensor.

A espera tem limite de 10 segundos a 100 MHz. Se o MPU estiver ausente ou não conseguir calibrar, o vídeo é liberado ao fim do prazo e ATT BAD continua indicando atitude indisponível. O modo manual e a configuração legada dispensam a espera. Critérios de calibração, validade, alertas, filtros e drivers I²C não foram alterados. A base deve estar apoiada e aproximadamente nivelada na partida.

Foram preservados o alinhamento magnético de +90° (75° → 165°), offsets/ganhos nativos medidos, frente de 180°, pinos, joystick, LOCK, buzzer, barômetro e parâmetros do vídeo. A alteração de lógica fica em `rtl/top_reticula.sv`; a verificação direcionada está em `tests/tb_top_video_startup.sv`.

Os testes confirmaram a partida com o estimador real, prazo para sensor ausente, modo manual e falhas de MPU/SD sem falsa validade. A regressão de vídeo/HUD verificou 4.300.800 pixels em 12 combinações. O rumo passou em 1.393 vetores e nove configurações, incluindo o exemplo exato de +90°.

Estado: implementação concluída com saída zero, DRC sem erros, CDC 500 seguros sem inseguros/desconhecidos e todos os 81 pinos/propriedades idênticos à versão anterior. WNS +0,170 ns, WHS +0,018 ns, WPWS +4,020 ns; TNS/THS/TPWS zero. O usuário autorizou especificamente a versão 64a00ada, carregada via JTAG volátil com saída zero, SHA-256/alvo conferidos e DONE/INIT_B/fim de startup em 1. A partida automática ainda aguarda confirmação física. Evidências e backup em `validation/att-startup-warning-20261031/`. A versão f485be1f permanece preservada para retorno. Nenhuma escrita de Flash ou microSD foi executada.

SHA-256 candidato: `64a00ada4e9ac49db09c9d905a3ff224b20c84ec164b08ab520b5772a95b7b74`.
