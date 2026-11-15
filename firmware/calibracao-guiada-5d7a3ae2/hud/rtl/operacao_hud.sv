// Politica de fontes a 100 MHz. Dados e flags de alerta sao registrados juntos.
module operacao_hud #(
    parameter bit VIDEO_MODE_SEQUENCE=1'b0, JET_DEMO_PROFILE=1'b0,
    parameter bit VIDEO_INSTRUMENT_SYNC=1'b0,
    parameter integer VIDEO_GROUND_FRAMES=240,VIDEO_DEPARTURE_FRAMES=1260,
        VIDEO_CRUISE_FRAMES=1200,VIDEO_LANDING_FRAMES=900,
    parameter integer VIDEO_TAKEOFF_ROLL_FRAMES=-1,
        VIDEO_LANDING_AIR_FRAMES=-1,
        VIDEO_CRUISE_SPEED_KT=-1,VIDEO_CRUISE_ALT_FT=-1,
        VIDEO_TOUCHDOWN_SPEED_KT=-1,
    parameter bit VIDEO_LANDING_HAS_TOUCHDOWN=1'b1,
    parameter integer VIDEO_APPROACH_END_SPEED_KT=-1,
        VIDEO_APPROACH_END_ALT_FT=-1,
    parameter integer VIDEO_ANCHOR_400MPH_FRAME=-1,
        VIDEO_ANCHOR_400MPH_KT=-1,
        VIDEO_ANCHOR_5000FT_FRAME=-1,
        VIDEO_ANCHOR_13000FT_FRAME=-1,
        VIDEO_LANDING_ENTRY_SPEED_KT=-1,
        VIDEO_LANDING_ENTRY_ALT_FT=-1,
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
    input logic attitude_manual_valid,
    input logic signed [31:0] pitch_real_q10,roll_real_q10,
    input logic signed [31:0] pitch_manual_q10,roll_manual_q10,
    input logic signed [10:0] pitch_real_px,pitch_fallback_px,
    input logic signed [9:0] roll_real_q8,roll_fallback_q8,
    input logic [16:0] altitude_real_ft,
    input logic [8:0] heading_real_deg,heading_manual_deg,
    input logic signed [13:0] vertical_real_fpm,
    input logic vertical_real_valido,
    output logic [56:0] dados=0,
    output wire [31:0] metadados,
    output wire buzzer_out,
    input wire [2:0] video_phase,
    input wire [31:0] video_frame_index,
    input wire video_frame_valid,
    output wire [1:0] requested_video_mode,
    output wire invalid_video_mode
);
    // phase=4 significa ultimo quadro do clipe publicado, nao prova de toque.
    wire [2:0] video_phase_alinhada;
    wire [1:0] modo=VIDEO_MODE_SEQUENCE ?
        (video_phase_alinhada==0 ? 2'd0 :
         video_phase_alinhada==4 ? ((VIDEO_INSTRUMENT_SYNC && !VIDEO_LANDING_HAS_TOUCHDOWN) ? 2'd2 : 2'd0) :
         video_phase_alinhada==3 ? 2'd2 : 2'd1) : requested_video_mode;
    wire modo_invalido;
    controle_modo_operacao #(.DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)) u_modo (
        .clk(clk),.reset(reset),.switches(switches),.modo(requested_video_mode),.modo_invalido(modo_invalido));
    assign invalid_video_mode=modo_invalido;
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
    wire signed [31:0] pitch_fallback_q10_next = attitude_manual_valid ?
        pitch_manual_q10 : (fontes_validas[0] ? pitch_real_q10 : 32'sd0);
    wire signed [31:0] roll_fallback_q10_next = attitude_manual_valid ?
        roll_manual_q10 : (fontes_validas[0] ? roll_real_q10 : 32'sd0);
    logic signed [31:0] pitch_fallback_q10 = 0;
    logic signed [31:0] roll_fallback_q10 = 0;
    always_ff @(posedge clk) begin
        if (reset) begin
            pitch_fallback_q10 <= 0;
            roll_fallback_q10 <= 0;
        end else begin
            pitch_fallback_q10 <= pitch_fallback_q10_next;
            roll_fallback_q10 <= roll_fallback_q10_next;
        end
    end
    wire signed [31:0] pitch_operacao_q10 = valido[0] ? pitch_real_q10 : pitch_fallback_q10;
    wire signed [31:0] roll_operacao_q10 = valido[0] ? roll_real_q10 : roll_fallback_q10;
    wire [9:0] velocidade_voo,velocidade_pouso;
    wire [16:0] altitude_voo,altitude_pouso;
    wire [8:0] heading_voo;
    wire signed [13:0] vsi_pouso;
    wire [2:0] fase;
    wire [9:0] velocidade_video;
    wire [16:0] altitude_video;
    wire [2:0] fase_pouso_video;
    generate if (VIDEO_INSTRUMENT_SYNC) begin : g_video_instruments
        video_flight_profile_pipelined #(
            .GROUND_FRAMES(VIDEO_GROUND_FRAMES),
            .DEPARTURE_FRAMES(VIDEO_DEPARTURE_FRAMES),
            .CRUISE_FRAMES(VIDEO_CRUISE_FRAMES),
            .LANDING_FRAMES(VIDEO_LANDING_FRAMES),
            .TAKEOFF_ROLL_FRAMES(VIDEO_TAKEOFF_ROLL_FRAMES),
            .LANDING_AIR_FRAMES(VIDEO_LANDING_AIR_FRAMES),
            .CRUISE_SPEED_KT(VIDEO_CRUISE_SPEED_KT),
            .CRUISE_ALT_FT(VIDEO_CRUISE_ALT_FT),
            .TOUCHDOWN_SPEED_KT(VIDEO_TOUCHDOWN_SPEED_KT),
            .LANDING_HAS_TOUCHDOWN(VIDEO_LANDING_HAS_TOUCHDOWN),
            .APPROACH_END_SPEED_KT(VIDEO_APPROACH_END_SPEED_KT),
            .APPROACH_END_ALT_FT(VIDEO_APPROACH_END_ALT_FT),
            .ANCHOR_400MPH_FRAME(VIDEO_ANCHOR_400MPH_FRAME),
            .ANCHOR_400MPH_KT(VIDEO_ANCHOR_400MPH_KT),
            .ANCHOR_5000FT_FRAME(VIDEO_ANCHOR_5000FT_FRAME),
            .ANCHOR_13000FT_FRAME(VIDEO_ANCHOR_13000FT_FRAME),
            .LANDING_ENTRY_SPEED_KT(VIDEO_LANDING_ENTRY_SPEED_KT),
            .LANDING_ENTRY_ALT_FT(VIDEO_LANDING_ENTRY_ALT_FT)
        ) u_video_instruments (
            .clk(clk),.reset(reset),.phase_aligned(video_phase_alinhada),
            .frame_valid(video_frame_valid),.frame_index(video_frame_index),
            .phase(video_phase),.velocidade_kt(velocidade_video),
            .altitude_ft(altitude_video),.fase_pouso(fase_pouso_video));
    end else begin : g_no_video_instruments
        assign velocidade_video=0;
        assign altitude_video=0;
        assign fase_pouso_video=0;
        assign video_phase_alinhada=video_phase;
    end endgenerate
    wire [2:0] fase_pouso_ativa = VIDEO_INSTRUMENT_SYNC ? fase_pouso_video : fase;
    simulador_voo u_voo(.clk(clk),.reset(reset),.enable(modo==1),.tick(tick),
        .attitude_valid(valido[0] || attitude_manual_valid),
        .pitch_q10(pitch_operacao_q10),.roll_q10(roll_operacao_q10),
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
        pitch=attitude_manual_valid ? pitch_fallback_px :
            valido[0] ? pitch_real_px : 11'sd0;
        roll=attitude_manual_valid ? roll_fallback_q8 :
            valido[0] ? roll_real_q8 : 10'sd0;
        vsi=vertical_real_fpm;
        h_valid=valido[1]; vsi_valid=vertical_real_valido && valido[0] && valido[1];
        fallback=attitude_manual_valid;
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
        // No perfil sincronizado, numeros e fase de pouso derivam apenas do
        // ultimo quadro confirmado, nunca do tick dos simuladores.
        if (VIDEO_INSTRUMENT_SYNC) begin
            // O video simula velocidade/altitude; o rumo continua vindo do sensor.
            hdg=valido[2] ? heading_real_deg : heading_manual_deg;
            v=velocidade_video;
            h=altitude_video;
            h_valid=1'b1; // AGL didatica, nao leitura do barometro.
            vsi=14'sd0;  // Sem fonte confiavel de VSI no video.
            vsi_valid=1'b0;
        end
    end
    wire [1:0] severity;
    wire [2:0] causa;
    wire ar,ap,aspeed,astall,ah,ak,asensor;
    alertas_voo #(.JET_DEMO_PROFILE(JET_DEMO_PROFILE),
        .VIDEO_INSTRUMENT_SYNC(VIDEO_INSTRUMENT_SYNC)) u_alertas(.clk(clk),.reset(reset),.modo(modo),.modo_invalido(modo_invalido),
        .fase_pouso(fase_pouso_ativa),.video_cruise(video_phase_alinhada==3'd2),.roll_q10(roll_operacao_q10),.pitch_q10(pitch_operacao_q10),
        .velocidade_kt(v),.altitude_ft(h),.vertical_fpm(vsi),
        .att_valid(valido[0]),.attitude_alert_valid(valido[0] || attitude_manual_valid),
        .alt_valid(h_valid),.heading_valid(valido[2]),.vertical_valid(vsi_valid),
        .severity(severity),.causa(causa),.alert_roll(ar),.alert_pitch(ap),
        .alert_speed(aspeed),.alert_stall(astall),.alert_altitude(ah),
        .alert_sink(ak),.alert_sensor(asensor));
    wire reconhecido;
    buzzer_driver #(.DEBOUNCE_CYCLES(ACK_CYCLES),.QUALIFY_CYCLES(JET_DEMO_PROFILE ? 50_000_000 : 1)) u_buzzer(
        .clk(clk),.reset(reset),.severity(severity),.ack(ack),.enable(1'b1),
        .buzzer_out(buzzer_out),.reconhecido(reconhecido));
    logic [8:0] estado=0;
    logic [2:0] fase_reg=0;
    always_ff @(posedge clk) begin
        if(reset) begin dados<=0; estado<=0; fase_reg<=0; end
        else begin
            dados<={v,h,pitch,roll,hdg};
            estado<={modo!=0,fallback,vsi_valid,valido[2],h_valid,valido[0],modo_invalido,modo};
            fase_reg<=modo==2 ? fase_pouso_ativa : 3'd0;
        end
    end
    // 25 STALL; 24:19 flags SENSOR/SINK/ALT/SPEED/PITCH/ROLL; 18:16 fase; 15 ACK; 14 som.
    // 13:11 causa; 10:9 severity; 8 SIM; 7 fallback; 6:3 VSI/HDG/ALT/ATT validos.
    assign metadados={6'd0,astall,asensor,ak,ah,aspeed,ap,ar,fase_reg,
                       reconhecido,buzzer_out,causa,severity,estado};
endmodule
