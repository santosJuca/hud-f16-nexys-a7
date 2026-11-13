// Perfil didatico de voo calculado a partir do ultimo quadro publicado.
// Tres estagios a 100 MHz: intervalo/offset, interpolacao Q16 e saidas.
// A latencia fixa de tres clocks (< 30 ns) nao altera a cadencia de 30 FPS.
module video_flight_profile_pipelined #(
    parameter integer GROUND_FRAMES=240, DEPARTURE_FRAMES=1260,
        CRUISE_FRAMES=1200, LANDING_FRAMES=900,
    parameter integer TAKEOFF_ROLL_FRAMES=-1, LANDING_AIR_FRAMES=-1,
        CRUISE_SPEED_KT=-1, CRUISE_ALT_FT=-1, TOUCHDOWN_SPEED_KT=-1,
    parameter bit LANDING_HAS_TOUCHDOWN=1'b1,
    parameter integer APPROACH_END_SPEED_KT=-1, APPROACH_END_ALT_FT=-1,
    // Marcos locais da cena DECOLAGEM (contagem desde FIRST_DEP).
    // Valores de legenda; interpolacoes entre marcos sao didaticas.
    parameter integer ANCHOR_400MPH_FRAME=-1, ANCHOR_400MPH_KT=-1,
    parameter integer ANCHOR_5000FT_FRAME=-1, ANCHOR_13000FT_FRAME=-1,
    // Cena POUSO e um corte: inicia em referencia diferente do cruzeiro.
    parameter integer LANDING_ENTRY_SPEED_KT=-1, LANDING_ENTRY_ALT_FT=-1
)(
    input wire clk, reset,
    input wire frame_valid,
    input wire [31:0] frame_index,
    input wire [2:0] phase,
    output logic [9:0] velocidade_kt = 0,
    output logic [16:0] altitude_ft = 0,
    output logic [2:0] fase_pouso = 0,
    output logic [2:0] phase_aligned = 0
);
    localparam integer FIRST_DEP=GROUND_FRAMES;
    localparam integer FIRST_CRUISE=FIRST_DEP+DEPARTURE_FRAMES;
    localparam integer FIRST_LANDING=FIRST_CRUISE+CRUISE_FRAMES;
    localparam integer FINAL_FRAME=FIRST_LANDING+LANDING_FRAMES-1;
    localparam integer DEP_SPEED_SPAN=DEPARTURE_FRAMES-1;
    localparam integer DEP_ALT_SPAN=DEPARTURE_FRAMES-1-TAKEOFF_ROLL_FRAMES;
    localparam integer LAND_ROLLOUT_SPAN=LANDING_FRAMES-1-LANDING_AIR_FRAMES;
    localparam integer FW=FINAL_FRAME>1 ? $clog2(FINAL_FRAME+1) : 1;
    localparam bit ANCHORS_ENABLED=ANCHOR_400MPH_FRAME>=0;
    localparam bit LANDING_CUT_ENABLED=LANDING_ENTRY_SPEED_KT>=0;
    localparam integer LAND_START_SPEED=LANDING_CUT_ENABLED ? LANDING_ENTRY_SPEED_KT : CRUISE_SPEED_KT;
    localparam integer LAND_START_ALT=LANDING_CUT_ENABLED ? LANDING_ENTRY_ALT_FT : CRUISE_ALT_FT;

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
                APPROACH_END_ALT_FT<1 || APPROACH_END_ALT_FT>=CRUISE_ALT_FT)) ||
            (ANCHORS_ENABLED && (ANCHOR_400MPH_FRAME<1 ||
                ANCHOR_400MPH_FRAME>=TAKEOFF_ROLL_FRAMES ||
                ANCHOR_400MPH_KT<1 || ANCHOR_400MPH_KT>CRUISE_SPEED_KT ||
                ANCHOR_5000FT_FRAME<=TAKEOFF_ROLL_FRAMES ||
                ANCHOR_13000FT_FRAME<=ANCHOR_5000FT_FRAME ||
                ANCHOR_13000FT_FRAME>=DEPARTURE_FRAMES-1 ||
                CRUISE_ALT_FT!=13000)) ||
            (LANDING_CUT_ENABLED && (!LANDING_HAS_TOUCHDOWN ||
                LANDING_ENTRY_SPEED_KT<TOUCHDOWN_SPEED_KT ||
                LANDING_ENTRY_SPEED_KT>CRUISE_SPEED_KT ||
                LANDING_ENTRY_ALT_FT<1 || LANDING_ENTRY_ALT_FT>CRUISE_ALT_FT)))
            $fatal(1,"Configure os marcos dos videos antes de ativar VIDEO_INSTRUMENT_SYNC");
    end

    // Mesma interpolacao e arredondamento Q16 da versao combinacional.
    localparam logic [63:0] DEP_SPEED_STEP_Q16 = (64'(CRUISE_SPEED_KT)*65536)/DEP_SPEED_SPAN;
    localparam logic [63:0] DEP_ALT_STEP_Q16 = (64'(CRUISE_ALT_FT)*65536)/DEP_ALT_SPAN;
    // Constantes Q16: nenhum divisor variavel no datapath.
    localparam logic [63:0] SPEED_A_STEP_Q16 = ANCHORS_ENABLED ?
        (64'(ANCHOR_400MPH_KT)*65536)/ANCHOR_400MPH_FRAME : 0;
    localparam logic [63:0] SPEED_B_STEP_Q16 = ANCHORS_ENABLED ?
        (64'(CRUISE_SPEED_KT-ANCHOR_400MPH_KT)*65536)/
        (TAKEOFF_ROLL_FRAMES-ANCHOR_400MPH_FRAME) : 0;
    localparam logic [63:0] ALT_A_STEP_Q16 = ANCHORS_ENABLED ?
        (64'd5000*65536)/(ANCHOR_5000FT_FRAME-TAKEOFF_ROLL_FRAMES) : 0;
    localparam logic [63:0] ALT_B_STEP_Q16 = ANCHORS_ENABLED ?
        (64'(CRUISE_ALT_FT-5000)*65536)/
        (ANCHOR_13000FT_FRAME-ANCHOR_5000FT_FRAME + (ANCHORS_ENABLED ? 0 : 1)) : 0;
    localparam logic [63:0] LAND_SPEED_STEP_Q16 =
        (64'(LAND_START_SPEED-TOUCHDOWN_SPEED_KT)*65536)/LANDING_AIR_FRAMES;
    localparam logic [63:0] LAND_ALT_STEP_Q16 = (64'(LAND_START_ALT)*65536)/LANDING_AIR_FRAMES;
    localparam logic [63:0] ROLLOUT_SPEED_STEP_Q16 =
        (64'(TOUCHDOWN_SPEED_KT)*65536)/LAND_ROLLOUT_SPAN;
    localparam logic [63:0] APPROACH_SPEED_STEP_Q16 =
        (64'(CRUISE_SPEED_KT-APPROACH_END_SPEED_KT)*65536)/(LANDING_FRAMES-1);
    localparam logic [63:0] APPROACH_ALT_STEP_Q16 =
        (64'(CRUISE_ALT_FT-APPROACH_END_ALT_FT)*65536)/(LANDING_FRAMES-1);

    logic [FW-1:0] offset_a=0,offset_b=0;
    logic [2:0] phase_a=0,phase_b=0;
    logic valid_a=0,valid_b=0;
    logic [33:0] speed_q16_b=0,alt_q16_b=0;
    logic [9:0] speed_value;
    logic [16:0] alt_value;
    logic [2:0] landing_value;

    // Estagio 1: a faixa de cada cena limita o offset antes da aritmetica.
    always_ff @(posedge clk) begin
        if (reset) begin
            offset_a<=0;phase_a<=0;valid_a<=0;
        end else begin
            phase_a<=phase;
            valid_a<=frame_valid;
            offset_a<=0;
            case (phase)
                3'd1: begin
                    valid_a<=frame_valid && frame_index>=FIRST_DEP && frame_index<FIRST_CRUISE;
                    if(frame_index>=FIRST_DEP && frame_index<FIRST_CRUISE)
                        offset_a<=FW'(frame_index-FIRST_DEP);
                end
                3'd2: valid_a<=frame_valid && frame_index>=FIRST_CRUISE && frame_index<FIRST_LANDING;
                3'd3: begin
                    valid_a<=frame_valid && frame_index>=FIRST_LANDING && frame_index<=FINAL_FRAME;
                    if(frame_index>=FIRST_LANDING && frame_index<=FINAL_FRAME)
                        offset_a<=FW'(frame_index-FIRST_LANDING);
                end
                3'd0,3'd4: valid_a<=frame_valid;
                default: valid_a<=1'b0;
            endcase
        end
    end

    // Estagio 2: apenas multiplicacoes por constantes em offsets limitados.
    always_ff @(posedge clk) begin
        if (reset) begin
            offset_b<=0;phase_b<=0;valid_b<=0;
            speed_q16_b<=0;alt_q16_b<=0;
        end else begin
            offset_b<=offset_a;
            phase_b<=phase_a;
            valid_b<=valid_a;
            speed_q16_b<=0;
            alt_q16_b<=0;
            if(valid_a) begin
                case(phase_a)
                    3'd1: begin
                        if (ANCHORS_ENABLED) begin
                            if (offset_a<ANCHOR_400MPH_FRAME)
                                speed_q16_b<=34'(offset_a)*34'(SPEED_A_STEP_Q16)+34'd32768;
                            else if (offset_a<TAKEOFF_ROLL_FRAMES)
                                speed_q16_b<=34'(ANCHOR_400MPH_KT*65536) +
                                    34'(offset_a-FW'(ANCHOR_400MPH_FRAME))*
                                    34'(SPEED_B_STEP_Q16)+34'd32768;
                            if (offset_a>TAKEOFF_ROLL_FRAMES && offset_a<ANCHOR_5000FT_FRAME)
                                alt_q16_b<=34'(offset_a-FW'(TAKEOFF_ROLL_FRAMES))*
                                    34'(ALT_A_STEP_Q16)+34'd32768;
                            else if (offset_a>=ANCHOR_5000FT_FRAME &&
                                     offset_a<ANCHOR_13000FT_FRAME)
                                alt_q16_b<=34'd327680000 +
                                    34'(offset_a-FW'(ANCHOR_5000FT_FRAME))*
                                    34'(ALT_B_STEP_Q16)+34'd32768;
                        end else begin
                            speed_q16_b<=34'(offset_a)*34'(DEP_SPEED_STEP_Q16)+34'd32768;
                            if(offset_a>TAKEOFF_ROLL_FRAMES)
                                alt_q16_b<=34'(offset_a-FW'(TAKEOFF_ROLL_FRAMES)) *
                                    34'(DEP_ALT_STEP_Q16)+34'd32768;
                        end
                    end
                    3'd3: begin
                        if(!LANDING_HAS_TOUCHDOWN) begin
                            speed_q16_b<=34'(offset_a)*34'(APPROACH_SPEED_STEP_Q16)+34'd32768;
                            alt_q16_b<=34'(offset_a)*34'(APPROACH_ALT_STEP_Q16)+34'd32768;
                        end else if(offset_a<=LANDING_AIR_FRAMES) begin
                            speed_q16_b<=34'(offset_a)*34'(LAND_SPEED_STEP_Q16)+34'd32768;
                            alt_q16_b<=34'(offset_a)*34'(LAND_ALT_STEP_Q16)+34'd32768;
                        end else begin
                            speed_q16_b<=34'(offset_a-FW'(LANDING_AIR_FRAMES)) *
                                34'(ROLLOUT_SPEED_STEP_Q16)+34'd32768;
                        end
                    end
                    default: begin end
                endcase
            end
        end
    end

    // Estagio 3: selecao e saturacao dos valores da cena.
    always_comb begin
        speed_value=0;alt_value=0;landing_value=0;
        if(valid_b) begin
            case (phase_b)
                3'd1: begin
                    if (ANCHORS_ENABLED) begin
                        if(offset_b>=TAKEOFF_ROLL_FRAMES) speed_value=10'(CRUISE_SPEED_KT);
                        else if(offset_b==ANCHOR_400MPH_FRAME) speed_value=10'(ANCHOR_400MPH_KT);
                        else speed_value=10'(speed_q16_b>>16);
                        if(offset_b<=TAKEOFF_ROLL_FRAMES) alt_value=0;
                        else if(offset_b>=ANCHOR_13000FT_FRAME) alt_value=17'(CRUISE_ALT_FT);
                        else if(offset_b==ANCHOR_5000FT_FRAME) alt_value=17'd5000;
                        else alt_value=17'(alt_q16_b>>16);
                    end else begin
                        speed_value=offset_b>=DEP_SPEED_SPAN ? 10'(CRUISE_SPEED_KT) :
                            10'(speed_q16_b>>16);
                        if(offset_b<=TAKEOFF_ROLL_FRAMES) alt_value=0;
                        else if(offset_b>=DEPARTURE_FRAMES-1) alt_value=17'(CRUISE_ALT_FT);
                        else alt_value=17'(alt_q16_b>>16);
                    end
                end
                3'd2: begin
                    speed_value=10'(CRUISE_SPEED_KT);
                    alt_value=17'(CRUISE_ALT_FT);
                end
                3'd3: begin
                    if(!LANDING_HAS_TOUCHDOWN) begin
                        speed_value=offset_b==LANDING_FRAMES-1 ? 10'(APPROACH_END_SPEED_KT) :
                            10'(CRUISE_SPEED_KT-(speed_q16_b>>16));
                        alt_value=offset_b==LANDING_FRAMES-1 ? 17'(APPROACH_END_ALT_FT) :
                            17'(CRUISE_ALT_FT-(alt_q16_b>>16));
                        landing_value=alt_value<=200 ? 3'd1 : 3'd0;
                    end else if(offset_b<=LANDING_AIR_FRAMES) begin
                        speed_value=offset_b==LANDING_AIR_FRAMES ? 10'(TOUCHDOWN_SPEED_KT) :
                            10'(LAND_START_SPEED-(speed_q16_b>>16));
                        alt_value=offset_b==LANDING_AIR_FRAMES ? 0 :
                            17'(LAND_START_ALT-(alt_q16_b>>16));
                        if(offset_b==LANDING_AIR_FRAMES) landing_value=3'd3;
                        else if(alt_value<=40) landing_value=3'd2;
                        else if(alt_value<=200) landing_value=3'd1;
                    end else begin
                        speed_value=offset_b==LANDING_FRAMES-1 ? 0 :
                            10'(TOUCHDOWN_SPEED_KT-(speed_q16_b>>16));
                        landing_value=3'd4;
                    end
                end
                3'd4: begin
                    if(!LANDING_HAS_TOUCHDOWN) begin
                        speed_value=10'(APPROACH_END_SPEED_KT);
                        alt_value=17'(APPROACH_END_ALT_FT);
                        landing_value=APPROACH_END_ALT_FT<=200 ? 3'd1 : 3'd0;
                    end else landing_value=3'd4;
                end
                default: begin end
            endcase
        end
    end
    always_ff @(posedge clk) begin
        if(reset) begin
            velocidade_kt<=0;altitude_ft<=0;fase_pouso<=0;phase_aligned<=0;
        end else begin
            velocidade_kt<=speed_value;
            altitude_ft<=alt_value;
            fase_pouso<=landing_value;
            phase_aligned<=phase_b;
        end
    end
endmodule
