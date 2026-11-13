// Valores didaticos extraidos de parametros explicitos, NUNCA de sensores reais.
// Indices referem-se ao ultimo quadro confirmado pelo sd_video_loader.
// Esta logica e opt-in: nenhum valor de cena e presumido no build padrao.
module video_flight_profile #(
    parameter integer GROUND_FRAMES=240,DEPARTURE_FRAMES=1260,
        CRUISE_FRAMES=1200,LANDING_FRAMES=900,
    // Parametros a preencher a partir de quadros efetivamente inspecionados.
    parameter integer TAKEOFF_ROLL_FRAMES=-1,LANDING_AIR_FRAMES=-1,
        CRUISE_SPEED_KT=-1,CRUISE_ALT_FT=-1,TOUCHDOWN_SPEED_KT=-1,
    // Sem contato comprovado na cena, aproximacao termina ainda no ar.
    parameter bit LANDING_HAS_TOUCHDOWN=1'b1,
    parameter integer APPROACH_END_SPEED_KT=-1,APPROACH_END_ALT_FT=-1
)(
    input wire frame_valid,
    input wire [31:0] frame_index,
    input wire [2:0] phase,
    output logic [9:0] velocidade_kt,
    output logic [16:0] altitude_ft,
    output logic [2:0] fase_pouso
);
    localparam integer FIRST_DEP=GROUND_FRAMES;
    localparam integer FIRST_CRUISE=FIRST_DEP+DEPARTURE_FRAMES;
    localparam integer FIRST_LANDING=FIRST_CRUISE+CRUISE_FRAMES;
    localparam integer FINAL_FRAME=FIRST_LANDING+LANDING_FRAMES-1;
    localparam integer DEP_SPEED_SPAN=DEPARTURE_FRAMES-1;
    localparam integer DEP_ALT_SPAN=DEPARTURE_FRAMES-1-TAKEOFF_ROLL_FRAMES;
    localparam integer LAND_ROLLOUT_SPAN=LANDING_FRAMES-1-LANDING_AIR_FRAMES;

    initial begin
        if (GROUND_FRAMES<2 || DEPARTURE_FRAMES<3 || CRUISE_FRAMES<2 || LANDING_FRAMES<3 ||
            TAKEOFF_ROLL_FRAMES<1 || TAKEOFF_ROLL_FRAMES>=DEPARTURE_FRAMES-1 ||
            (LANDING_HAS_TOUCHDOWN && (LANDING_AIR_FRAMES<1 ||
                LANDING_AIR_FRAMES>=LANDING_FRAMES-1 ||
                TOUCHDOWN_SPEED_KT<0 || TOUCHDOWN_SPEED_KT>CRUISE_SPEED_KT)) ||
            CRUISE_SPEED_KT<1 || CRUISE_SPEED_KT>1023 ||
            CRUISE_ALT_FT<1 || CRUISE_ALT_FT>131071 ||
            (!LANDING_HAS_TOUCHDOWN && (
                APPROACH_END_SPEED_KT<1 || APPROACH_END_SPEED_KT>CRUISE_SPEED_KT ||
                APPROACH_END_ALT_FT<1 || APPROACH_END_ALT_FT>=CRUISE_ALT_FT)))
            $fatal(1,"Configure os marcos dos videos antes de ativar VIDEO_INSTRUMENT_SYNC");
    end

    // Razoes Q16 calculadas na elaboracao. Em tempo de execucao,
    // apenas somas, comparacoes e multiplicacoes por constantes.
    localparam logic [63:0] DEP_SPEED_STEP_Q16 = (64'(CRUISE_SPEED_KT)*65536)/DEP_SPEED_SPAN;
    localparam logic [63:0] DEP_ALT_STEP_Q16 = (64'(CRUISE_ALT_FT)*65536)/DEP_ALT_SPAN;
    localparam logic [63:0] LAND_SPEED_STEP_Q16 =
        (64'(CRUISE_SPEED_KT-TOUCHDOWN_SPEED_KT)*65536)/LANDING_AIR_FRAMES;
    localparam logic [63:0] LAND_ALT_STEP_Q16 = (64'(CRUISE_ALT_FT)*65536)/LANDING_AIR_FRAMES;
    localparam logic [63:0] ROLLOUT_SPEED_STEP_Q16 =
        (64'(TOUCHDOWN_SPEED_KT)*65536)/LAND_ROLLOUT_SPAN;
    // Aproximacao sem toque: referencial didatico, nao medicao de voo.
    localparam logic [63:0] APPROACH_SPEED_STEP_Q16 =
        (64'(CRUISE_SPEED_KT-APPROACH_END_SPEED_KT)*65536)/(LANDING_FRAMES-1);
    localparam logic [63:0] APPROACH_ALT_STEP_Q16 =
        (64'(CRUISE_ALT_FT-APPROACH_END_ALT_FT)*65536)/(LANDING_FRAMES-1);

    logic [31:0] offset;
    logic [63:0] scaled_speed,scaled_alt;
    always_comb begin
        offset=0;
        scaled_speed=0;
        scaled_alt=0;
        velocidade_kt=0;
        altitude_ft=0;
        fase_pouso=0;
        if (frame_valid) begin
            case (phase)
                3'd0: begin // SOLO: pista como referencia AGL=0.
                    velocidade_kt=0;
                    altitude_ft=0;
                end
                3'd1: if(frame_index>=FIRST_DEP && frame_index<FIRST_CRUISE) begin
                    offset=frame_index-FIRST_DEP;
                    if (offset>=DEP_SPEED_SPAN) velocidade_kt=10'(CRUISE_SPEED_KT);
                    else begin
                        scaled_speed=(64'(offset)*DEP_SPEED_STEP_Q16 + 64'd32768)>>16;
                        velocidade_kt=10'(scaled_speed);
                    end
                    if (offset<=TAKEOFF_ROLL_FRAMES) altitude_ft=0;
                    else if (offset>=DEPARTURE_FRAMES-1) altitude_ft=17'(CRUISE_ALT_FT);
                    else begin
                        scaled_alt=(64'(offset-TAKEOFF_ROLL_FRAMES)*DEP_ALT_STEP_Q16 + 64'd32768)>>16;
                        altitude_ft=17'(scaled_alt);
                    end
                end
                3'd2: if(frame_index>=FIRST_CRUISE && frame_index<FIRST_LANDING) begin
                    velocidade_kt=10'(CRUISE_SPEED_KT);
                    altitude_ft=17'(CRUISE_ALT_FT);
                end
                3'd3: if(frame_index>=FIRST_LANDING && frame_index<=FINAL_FRAME) begin
                    offset=frame_index-FIRST_LANDING;
                    if (!LANDING_HAS_TOUCHDOWN) begin
                        // Quadro final ainda mostra aproximacao; sem rollout ficticio.
                        scaled_speed=(64'(offset)*APPROACH_SPEED_STEP_Q16+64'd32768)>>16;
                        scaled_alt=(64'(offset)*APPROACH_ALT_STEP_Q16+64'd32768)>>16;
                        velocidade_kt=offset==LANDING_FRAMES-1 ? 10'(APPROACH_END_SPEED_KT) :
                            10'(CRUISE_SPEED_KT-scaled_speed);
                        altitude_ft=offset==LANDING_FRAMES-1 ? 17'(APPROACH_END_ALT_FT) :
                            17'(CRUISE_ALT_FT-scaled_alt);
                        // Apenas aproximacao/final; nunca declarar flare ou toque.
                        fase_pouso=altitude_ft<=200 ? 3'd1 : 3'd0;
                    end else if(offset<=LANDING_AIR_FRAMES) begin
                        scaled_speed=(64'(offset)*LAND_SPEED_STEP_Q16+64'd32768)>>16;
                        scaled_alt=(64'(offset)*LAND_ALT_STEP_Q16+64'd32768)>>16;
                        velocidade_kt=offset==LANDING_AIR_FRAMES ? 10'(TOUCHDOWN_SPEED_KT) :
                            10'(CRUISE_SPEED_KT-scaled_speed);
                        altitude_ft=offset==LANDING_AIR_FRAMES ? 17'd0 :
                            17'(CRUISE_ALT_FT-scaled_alt);
                        if(offset==LANDING_AIR_FRAMES) fase_pouso=3;
                        else if(altitude_ft<=40) fase_pouso=2;
                        else if(altitude_ft<=200) fase_pouso=1;
                        else fase_pouso=0;
                    end else begin
                        scaled_speed=(64'(offset-LANDING_AIR_FRAMES)*ROLLOUT_SPEED_STEP_Q16 + 64'd32768)>>16;
                        velocidade_kt=offset==LANDING_FRAMES-1 ? 10'd0 :
                            10'(TOUCHDOWN_SPEED_KT-scaled_speed);
                        altitude_ft=0;
                        fase_pouso=4;
                    end
                end
                3'd4: begin // Ultimo quadro do clipe ja publicado.
                    if (LANDING_HAS_TOUCHDOWN) begin
                        velocidade_kt=0;
                        altitude_ft=0;
                        fase_pouso=4;
                    end else begin
                        // Manter o ultimo valor da aproximacao enquanto a VGA o retiver.
                        velocidade_kt=10'(APPROACH_END_SPEED_KT);
                        altitude_ft=17'(APPROACH_END_ALT_FT);
                        fase_pouso=APPROACH_END_ALT_FT<=200 ? 3'd1 : 3'd0;
                    end
                end
                default: begin
                    velocidade_kt=0;
                    altitude_ft=0;
                end
            endcase
        end
    end
endmodule
