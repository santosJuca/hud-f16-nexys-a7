# Arquitetura RTL

O top atual é [`rtl/top_reticula.sv`](../rtl/top_reticula.sv). A arquitetura mantém aquisição e política de voo no clock de sistema de 100 MHz, com renderização no clock VGA derivado de 25 MHz.

## Fluxo de dados

```text
MPU-6050 ──> atitude/fusão ─┐
BMP085 ────> altitude/VSI ──┼─> operacao_hud ─> pacote CDC ─> dados_hud ─┐
HMC5883L ──> heading/fusão ─┘                                           ├─> VGA RGB
KY-023/XADC ─> mira móvel/LOCK ────────────────────────────────────────┘
SW/BTNs ───> modos, fallbacks, heading manual e ACK
```

## Blocos e responsabilidades

| Bloco/cadeia | Papel no top |
| --- | --- |
| `mpu6050_i2c` | Aquisição I²C de acelerômetro e giroscópio; alimenta a estimação de atitude e gyro Z |
| `atitude_accel_fixa`, `gyro_bias_dt`, `gyro_integrador`, `atitude_fusao_complementar` | Referência acelerométrica, calibração/intervalo do giroscópio, integração e fusão complementar |
| `hmc5883l_i2c`, `heading_magnetico`, `heading_fusao` | Aquisição magnética, rumo plano e combinação com gyro Z |
| `bmp085_i2c`, `bmp085_compensacao_seq`, `bmp085_altitude`, `estado_vertical` | Aquisição, compensação barométrica e estado vertical |
| `joystick_xadc`, `mira_joystick`, `mira_caca_vga` | Amostragem dos eixos pelo XADC, posição móvel e LOCK/UNLOCK; a mira não substitui controle de atitude |
| `operacao_hud`, `controle_modo_operacao`, `simulador_voo`, `simulador_pouso`, `alertas_voo`, `buzzer_driver` | Seleção SOLO/VOO/POUSO, dados simulados, validade, alertas e ACK lógico |
| `entrada_hud`, `dados_hud` | Transferência do pacote entre domínios e atualização dos valores no quadro |
| `vga_controller`, `simbologia_vga`, `simbologia_caca_vga`, retículos, `numeros_hud`, `alertas_vga` | Coordenadas, composição e saída RGB/sincronismos |

Os detalhes de interface, fallback e ordem de composição estão documentados no README principal e nos módulos RTL. O marcador fixo vermelho pertence a NORMAL; a mira móvel funciona em CAÇA e LOCK apenas congela sua posição. DECLUTTER reduz conteúdo exibido, sem selecionar outra fonte de sensor.

## Clocks, reset e limites

O XDC declara clock de entrada de 100 MHz e clock gerado de 25 MHz no registrador do controlador VGA. O relatório de CDC preservado acompanha esse build. Entradas físicas assíncronas usam sincronização/debounce no RTL; isso não equivale a validar eletricamente os periféricos. A transferência dos dados do HUD usa um pacote entre os domínios, com atualização visual coordenada ao quadro.

`controle_manche` e caminhos históricos relacionados continuam no repositório/testes, mas não são instanciados no top de produção. A interface SENSOR/MANCHE não é função ativa. O estimador inercial experimental também não é a fonte operacional de velocidade.
