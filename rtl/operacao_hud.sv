// Politica de fontes a 100 MHz. Dados e flags de alerta sao registrados juntos.
module operacao_hud #(
    parameter integer TICK_CYCLES=5_000_000,
    parameter integer DEBOUNCE_CYCLES=10_000_000,
    parameter integer ACK_CYCLES=1_000_000,
    parameter integer ATT_TIMEOUT=25_000_000,
    parameter integer ALT_TIMEOUT=100_000_000,
    parameter integer HDG_TIMEOUT=50_000_000
)(
    input logic clk, reset,
    input logic [1:0] switches,
    input logic ack,
    input logic [2:0] fontes_validas, novas_amostras,
    input logic signed [31:0] pitch_real_q10,roll_real_q10,
    input logic signed [10:0] pitch_real_px,pitch_fallback_px,
    input logic signed [9:0] roll_real_q8,roll_fallback_q8,
    input logic [16:0] altitude_real_ft,
    input logic [8:0] heading_real_deg,heading_manual_deg,
    input logic signed [13:0] vertical_real_fpm,
    input logic vertical_real_valido,
    output logic [56:0] dados=0,
    output wire [31:0] metadados,
    output wire buzzer_out
);
    wire [1:0] modo;
    wire modo_invalido;
    controle_modo_operacao #(.DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)) u_modo (
        .clk(clk),.reset(reset),.switches(switches),.modo(modo),.modo_invalido(modo_invalido));
    localparam integer TW=TICK_CYCLES>1 ? $clog2(TICK_CYCLES) : 1;
    logic [TW-1:0] tempo=0;
    wire tick=tempo==TW'(TICK_CYCLES-1);
    always_ff @(posedge clk) begin
        if(reset || tick) tempo<=0; else tempo<=tempo+1'b1;
    end
    logic [2:0] recentes=0;
    for(genvar i=0;i<3;i++) begin : g_idade
        localparam integer LIM=i==0 ? ATT_TIMEOUT : i==1 ? ALT_TIMEOUT : HDG_TIMEOUT;
        localparam integer W=$clog2(LIM+1);
        logic [W-1:0] idade=W'(LIM);
        always_ff @(posedge clk) begin
            if(reset || !fontes_validas[i]) begin idade<=W'(LIM); recentes[i]<=0; end
            else if(novas_amostras[i]) begin idade<=0; recentes[i]<=1; end
            else if(idade<W'(LIM)) begin
                idade<=idade+1'b1;
                if(idade==W'(LIM-1)) recentes[i]<=0;
            end
        end
    end
    wire [2:0] valido=fontes_validas & recentes;
    wire [9:0] velocidade_voo,velocidade_pouso;
    wire [16:0] altitude_voo,altitude_pouso;
    wire [8:0] heading_voo;
    wire signed [13:0] vsi_pouso;
    wire [2:0] fase;
    simulador_voo u_voo(.clk(clk),.reset(reset),.enable(modo==1),.tick(tick),
        .attitude_valid(valido[0]),.pitch_q10(pitch_real_q10),.roll_q10(roll_real_q10),
        .heading_ref_deg(valido[2] ? heading_real_deg : heading_manual_deg),
        .heading_ref_valid(1'b1),.velocidade_kt(velocidade_voo),
        .altitude_ft(altitude_voo),.heading_deg(heading_voo));
    simulador_pouso u_pouso(.clk(clk),.reset(reset),.enable(modo==2),.tick(tick),
        .fase(fase),.velocidade_kt(velocidade_pouso),.altitude_ft(altitude_pouso),.vertical_fpm(vsi_pouso));
    logic [9:0] v;
    logic [16:0] h;
    logic [8:0] hdg;
    logic signed [10:0] pitch;
    logic signed [9:0] roll;
    logic signed [13:0] vsi;
    logic h_valid,vsi_valid,fallback;
    always_comb begin
        v=0; h=valido[1] ? altitude_real_ft : 17'd0;
        hdg=valido[2] ? heading_real_deg : 9'd0;
        pitch=valido[0] ? pitch_real_px : 11'sd0;
        roll=valido[0] ? roll_real_q8 : 10'sd0;
        vsi=vertical_real_fpm;
        h_valid=valido[1]; vsi_valid=vertical_real_valido && valido[0] && valido[1];
        fallback=0;
        if(modo!=0) begin
            v=modo==1 ? velocidade_voo : velocidade_pouso;
            h=modo==1 ? altitude_voo : altitude_pouso;
            h_valid=1;
            vsi=modo==2 ? vsi_pouso : 14'sd0;
            vsi_valid=modo==2;
            if(!valido[0]) begin pitch=pitch_fallback_px; roll=roll_fallback_q8; fallback=1; end
            if(!valido[2]) begin hdg=heading_manual_deg; fallback=1; end
            if(modo==1) begin
                hdg=heading_voo;
                if(!valido[2]) fallback=1;
            end
        end
    end
    wire [1:0] severity;
    wire [2:0] causa;
    wire ar,ap,aspeed,ah,ak,asensor;
    alertas_voo u_alertas(.clk(clk),.reset(reset),.modo(modo),.modo_invalido(modo_invalido),
        .fase_pouso(fase),.roll_q10(roll_real_q10),.pitch_q10(pitch_real_q10),
        .velocidade_kt(v),.altitude_ft(h),.vertical_fpm(vsi),
        .att_valid(valido[0]),.alt_valid(h_valid),.heading_valid(valido[2]),.vertical_valid(vsi_valid),
        .severity(severity),.causa(causa),.alert_roll(ar),.alert_pitch(ap),
        .alert_speed(aspeed),.alert_altitude(ah),.alert_sink(ak),.alert_sensor(asensor));
    wire reconhecido;
    buzzer_driver #(.DEBOUNCE_CYCLES(ACK_CYCLES)) u_buzzer(
        .clk(clk),.reset(reset),.severity(severity),.ack(ack),.enable(1'b1),
        .buzzer_out(buzzer_out),.reconhecido(reconhecido));
    logic [8:0] estado=0;
    logic [2:0] fase_reg=0;
    always_ff @(posedge clk) begin
        if(reset) begin dados<=0; estado<=0; fase_reg<=0; end
        else begin
            dados<={v,h,pitch,roll,hdg};
            estado<={modo!=0,fallback,vsi_valid,valido[2],h_valid,valido[0],modo_invalido,modo};
            fase_reg<=modo==2 ? fase : 3'd0;
        end
    end
    // 24:19 flags SENSOR/SINK/ALT/SPEED/PITCH/ROLL; 18:16 fase; 15 ACK; 14 som.
    // 13:11 causa; 10:9 severity; 8 SIM; 7 fallback; 6:3 VSI/HDG/ALT/ATT validos.
    assign metadados={7'd0,asensor,ak,ah,aspeed,ap,ar,fase_reg,reconhecido,buzzer_out,causa,severity,estado};
endmodule
