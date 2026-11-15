// Calibracao diagonal 2D, volatil. Perfil 3D original permanece fora deste modulo.
module mag_calibration_2d #(
    parameter signed [15:0] BASE_X=67,BASE_Y=-181,
    parameter [13:0] BASE_GX=3923,BASE_GY=4004,
    parameter integer STALE_CYCLES=50_000_000,
    parameter [31:0] PHASE_CYCLES=32'd3_000_000_000,
    parameter integer MIN_SAMPLES=64,
    parameter integer REPEAT_LIMIT=50
)(
    input wire clk,reset,start,next_step,cancel,recover,
    input wire sensor_ok,sample,level,
    input wire signed [15:0] mx,my,mz,
    output logic [3:0] state=0,reason=0,
    output logic active=0,profile_changed=0,
    output logic signed [15:0] offset_x=BASE_X,offset_y=BASE_Y,
    output logic [13:0] gain_x=BASE_GX,gain_y=BASE_GY,
    output wire healthy,
    output logic suspect=0,
    output logic [15:0] samples=0,duplicates=0,invalid_samples=0,
    output logic [7:0] coverage=0,
    output logic signed [15:0] min_x=0,max_x=0,min_y=0,max_y=0,min_z=0,max_z=0,
    output logic signed [15:0] candidate_x=0,candidate_y=0,
    output logic [13:0] candidate_gx=0,candidate_gy=0,
    output logic corrected_sample=0,
    output logic signed [15:0] corrected_x=0,corrected_y=0
);
    localparam NORMAL=0,CHECK=1,COLLECT=2,EVALUATE=3,VALIDATE=4,CANDIDATE=5,APPLY=6,RECOVERY=7,REJECT=8,CONFIRM=9;
    logic [31:0] age=STALE_CYCLES,timer=0;
    logic [15:0] repeats=0;
    logic have_last=0,invalid_now=0,have_train=0;
    logic signed [15:0] last_x=0,last_y=0,last_z=0;
    logic previous_active=0,backup_valid=0;
    logic signed [15:0] previous_x=BASE_X,previous_y=BASE_Y;
    logic [13:0] previous_gx=BASE_GX,previous_gy=BASE_GY;
    wire overflow=mx==-16'sd4096 || my==-16'sd4096 || mz==-16'sd4096;
    wire raw_ok=!overflow && mx>=-2048 && mx<=2047 && my>=-2048 && my<=2047 && mz>=-2048 && mz<=2047;
    wire repeated=have_last && mx==last_x && my==last_y && mz==last_z && !(state==COLLECT && !have_train);
    wire acquisition_ok=sensor_ok && age<STALE_CYCLES && !invalid_now && repeats<REPEAT_LIMIT;
    assign healthy=acquisition_ok && !suspect;
    wire candidate_phase=state==VALIDATE || state==CANDIDATE || state==CONFIRM;
    wire collecting=state==COLLECT || state==VALIDATE;
    logic [3:0] sector_count[0:7];
    logic [24:0] candidate_min=25'h1ffffff,candidate_max=0,base_min=25'h1ffffff,base_max=0;
    logic validation_bad=0;
    logic [41:0] new_lo=0,old_lo=0;
    logic [32:0] new_hi=0,old_hi=0;
    logic [49:0] score_new=0,score_old=0;
    logic [54:0] weighted_new=0,weighted_old=0,old_partial=0;
    logic not_improved=0;
    logic [2:0] eval_step=0;
    logic axis=0;
    logic [4:0] bit_index=21;
    logic [17:0] remainder=0;
    logic [21:0] quotient=0;
    logic [16:0] denominator=0;
    wire [17:0] trial=(remainder<<1) | (18'(22'd2097152 >> bit_index)&18'd1);
    wire [21:0] quotient_next=quotient | (trial>=denominator ? (22'd1<<bit_index) : 22'd0);
    wire signed [16:0] span_x=17'($signed(max_x))-17'($signed(min_x));
    wire signed [16:0] span_y=17'($signed(max_y))-17'($signed(min_y));
    wire signed [16:0] span_z=17'($signed(max_z))-17'($signed(min_z));
    // Pipeline compartilhado: dois pares de multiplicacoes, truncamento Q12,
    // quadrados e soma. Limite explicito antes de aceitar qualquer energia.
    logic [2:0] pipe=0;
    logic signed [32:0] prod_x=0,prod_y=0,old_x=0,old_y=0;
    logic signed [17:0] cx=0,cy=0,bx=0,by=0;
    logic [35:0] sx=0,sy=0,bsx=0,bsy=0;
    logic [36:0] energy=0,old_energy=0;
    logic arithmetic_bad=0,pipe_unique=0;
    logic signed [15:0] pipe_z=0;
    wire [17:0] abs_x=cx<0 ? -cx : cx,abs_y=cy<0 ? -cy : cy;
    wire [2:0] sector={cx<0,cy<0,abs_y>abs_x};
    initial begin
        if(STALE_CYCLES<10 || PHASE_CYCLES<STALE_CYCLES || MIN_SAMPLES<16 || REPEAT_LIMIT<2)
            $fatal(1,"Parametros de calibracao invalidos");
    end
    always_ff @(posedge clk) begin
        corrected_sample<=0;profile_changed<=0;
        if(age<STALE_CYCLES) age<=age+1;
        if(state!=NORMAL && state!=REJECT) begin
            if(timer<PHASE_CYCLES) timer<=timer+1;
            else begin state<=REJECT;reason<=9;end
        end
        if(sample && sensor_ok) begin
            age<=0;last_x<=mx;last_y<=my;last_z<=mz;have_last<=1;
            invalid_now<=!raw_ok;
            if(!raw_ok) begin
                if(invalid_samples!=65535) invalid_samples<=invalid_samples+1;
                if(state!=NORMAL && state!=CHECK && state!=REJECT) begin state<=REJECT;reason<=3;end
            end else if(repeated) begin
                if(repeats!=65535) repeats<=repeats+1;
                if(duplicates!=65535) duplicates<=duplicates+1;
            end else begin
                repeats<=0;
                if(state==COLLECT && level) begin
                    if(samples!=65535) samples<=samples+1;
                    if(!have_train) begin
                        min_x<=mx;max_x<=mx;min_y<=my;max_y<=my;min_z<=mz;max_z<=mz;have_train<=1;
                    end else begin
                        if(mx<min_x)min_x<=mx;if(mx>max_x)max_x<=mx;
                        if(my<min_y)min_y<=my;if(my>max_y)max_y<=my;
                        if(mz<min_z)min_z<=mz;if(mz>max_z)max_z<=mz;
                    end
                end
            end
            if(raw_ok && pipe==0 && (active || candidate_phase)) begin
                prod_x<=(18'($signed(mx))-18'($signed(candidate_phase ? candidate_x : offset_x)))*$signed({1'b0,candidate_phase ? candidate_gx : gain_x});
                prod_y<=(18'($signed(my))-18'($signed(candidate_phase ? candidate_y : offset_y)))*$signed({1'b0,candidate_phase ? candidate_gy : gain_y});
                old_x<=(18'($signed(mx))-18'($signed(offset_x)))*$signed({1'b0,gain_x});
                old_y<=(18'($signed(my))-18'($signed(offset_y)))*$signed({1'b0,gain_y});
                pipe<=1;pipe_unique<=!repeated;pipe_z<=mz;
            end
        end
        case(pipe)
            1: begin
                cx<=18'(prod_x>>>12);cy<=18'(prod_y>>>12);bx<=18'(old_x>>>12);by<=18'(old_y>>>12);
                arithmetic_bad<=(prod_x>>>12)>4095 || (prod_x>>>12)<-4095 ||
                    (prod_y>>>12)>4095 || (prod_y>>>12)<-4095 ||
                    (old_x>>>12)>4095 || (old_x>>>12)<-4095 || (old_y>>>12)>4095 || (old_y>>>12)<-4095;
                pipe<=2;
            end
            2: begin sx<=cx*cx;sy<=cy*cy;bsx<=bx*bx;bsy<=by*by;pipe<=3;end
            3: begin energy<={1'b0,sx}+{1'b0,sy};old_energy<={1'b0,bsx}+{1'b0,bsy};pipe<=4;end
            4: begin
                pipe<=0;
                if(state==VALIDATE) begin
                    // Conservador: qualquer outlier, overflow, variacao Z ou perda
                    // de nivel invalida a sessao, em vez de contaminar os extremos.
                    if(arithmetic_bad || energy<52428 || energy>78643 || old_energy==0 || span_z>64 ||
                       17'($signed(pipe_z))<17'($signed(min_z))-17'sd32 || 17'($signed(pipe_z))>17'($signed(max_z))+17'sd32)
                        validation_bad<=1;
                    if(pipe_unique) begin
                        if(samples!=65535)samples<=samples+1;
                        if(sector_count[sector]<2) sector_count[sector]<=sector_count[sector]+1;
                        if(sector_count[sector]>=1)coverage[sector]<=1;
                        if(energy<candidate_min)candidate_min<=25'(energy);
                        if(energy>candidate_max)candidate_max<=25'(energy);
                        if(old_energy<base_min)base_min<=25'(old_energy);
                        if(old_energy>base_max)base_max<=25'(old_energy);
                    end
                end else if(state==CANDIDATE || state==CONFIRM) begin
                    if(arithmetic_bad || energy<52428 || energy>78643 ||
                       17'($signed(pipe_z))<17'($signed(min_z))-17'sd32 ||
                       17'($signed(pipe_z))>17'($signed(max_z))+17'sd32) begin state<=REJECT;reason<=7;end
                    else if(state==CONFIRM && acquisition_ok && level)state<=APPLY;
                end
                // O rumo aprovado continua atualizado durante treino/validacao.
                // bx/by e old_energy usam sempre o perfil ativo, nunca o candidato.
                if(active && level) begin
                    suspect<=arithmetic_bad || old_energy<52428 || old_energy>78643;
                    if(!arithmetic_bad) begin corrected_x<=16'(bx);corrected_y<=16'(by);corrected_sample<=1;end
                end else suspect<=0;
            end
            default: begin end
        endcase
        if(!level) suspect<=0; // O perfil 2D nao e aplicado inclinado.
        if(state==EVALUATE) begin
            case(eval_step)
                0: begin
                    if(!have_train || samples<MIN_SAMPLES || span_x<256 || span_y<256 || span_x>4095 || span_y>4095 || span_z>64) begin state<=REJECT;reason<=5;end
                    else begin
                        candidate_x<=16'((17'($signed(min_x))+17'($signed(max_x)))>>>1);
                        candidate_y<=16'((17'($signed(min_y))+17'($signed(max_y)))>>>1);
                        axis<=0;denominator<=17'(span_x);bit_index<=21;remainder<=0;quotient<=0;eval_step<=1;
                    end
                end
                1: begin
                    remainder<=trial>=denominator ? trial-denominator : trial;
                    quotient<=quotient_next;
                    if(bit_index!=0)bit_index<=bit_index-1;
                    else if(quotient_next<512 || quotient_next>8192)begin state<=REJECT;reason<=6;end
                    else if(!axis)begin
                        candidate_gx<=14'(quotient_next);axis<=1;denominator<=17'(span_y);bit_index<=21;remainder<=0;quotient<=0;
                    end else begin
                        candidate_gy<=14'(quotient_next);samples<=0;coverage<=0;
                        for(integer i=0;i<8;i++)sector_count[i]<=0;
                        candidate_min<=25'h1ffffff;candidate_max<=0;base_min<=25'h1ffffff;base_max<=0;
                        validation_bad<=0;state<=VALIDATE;timer<=0;
                    end
                end
                // |corrigido|<=4095 garante energia<2^25. Produtos 25x25
                // sao divididos em 25x17 e 25x8, cada um cabe num DSP48.
                2: begin
                    new_lo<=candidate_max*base_min[16:0];new_hi<=candidate_max*base_min[24:17];
                    old_lo<=base_max*candidate_min[16:0];old_hi<=base_max*candidate_min[24:17];eval_step<=3;
                end
                3: begin score_new<={new_hi,17'd0}+{8'd0,new_lo};score_old<={old_hi,17'd0}+{8'd0,old_lo};eval_step<=4;end
                4: begin
                    weighted_new<=({5'd0,score_new}<<4)+({5'd0,score_new}<<2);
                    old_partial<=({5'd0,score_old}<<4)+({5'd0,score_old}<<1);eval_step<=5;
                end
                5: begin weighted_old<=old_partial+{5'd0,score_old};eval_step<=6;end
                6: begin not_improved<=weighted_new>weighted_old;eval_step<=7;end
                7: begin
                    if(validation_bad)begin state<=REJECT;reason<=7;end
                    else if(samples<MIN_SAMPLES || coverage!=8'hff)begin state<=REJECT;reason<=5;end
                    else if(not_improved)begin state<=REJECT;reason<=8;end
                    else begin state<=CANDIDATE;reason<=0;timer<=0;end
                end
                default: begin state<=REJECT;reason<=10;end
            endcase
        end
        if(state==APPLY && acquisition_ok && level) begin
            previous_active<=active;previous_x<=offset_x;previous_y<=offset_y;previous_gx<=gain_x;previous_gy<=gain_y;backup_valid<=1;
            offset_x<=candidate_x;offset_y<=candidate_y;gain_x<=candidate_gx;gain_y<=candidate_gy;
            active<=1;profile_changed<=1;state<=NORMAL;suspect<=0;pipe<=0;
        end
        if(state==RECOVERY)begin state<=NORMAL;reason<=0;end
        // Prioridade de seguranca: nenhum erro/cancelamento pode aplicar candidato.
        if((state==COLLECT || state==EVALUATE || state==VALIDATE || state==CANDIDATE || state==CONFIRM || state==APPLY) &&
           (!level || !sensor_ok || age>=STALE_CYCLES || repeats>=REPEAT_LIMIT)) begin
            state<=REJECT;reason<=!sensor_ok ? 1 : age>=STALE_CYCLES ? 2 : !level ? 4 : 5;pipe<=0;
        end
        if(next_step)begin
            pipe<=0;
            case(state)
                CHECK: if(acquisition_ok && level)begin state<=COLLECT;samples<=0;have_train<=0;timer<=0;end
                       else begin state<=REJECT;reason<=!sensor_ok?1:!level?4:2;end
                COLLECT: begin state<=EVALUATE;eval_step<=0;end
                VALIDATE: begin state<=EVALUATE;eval_step<=2;end
                CANDIDATE: if(acquisition_ok && level)begin state<=CONFIRM;timer<=0;end else begin state<=REJECT;reason<=7;end
                default: begin end
            endcase
        end
        if(start)begin state<=CHECK;reason<=0;timer<=0;samples<=0;duplicates<=0;invalid_samples<=0;coverage<=0;pipe<=0;end
        if(cancel)begin state<=NORMAL;reason<=0;pipe<=0;end
        if(recover)begin
            if(backup_valid)begin active<=previous_active;offset_x<=previous_x;offset_y<=previous_y;gain_x<=previous_gx;gain_y<=previous_gy;backup_valid<=0;end
            else begin active<=0;offset_x<=BASE_X;offset_y<=BASE_Y;gain_x<=BASE_GX;gain_y<=BASE_GY;end
            state<=RECOVERY;reason<=0;suspect<=0;profile_changed<=1;pipe<=0;
        end
        if(!start && !cancel && !recover &&
           (state==COLLECT || state==EVALUATE || state==VALIDATE || state==CANDIDATE || state==CONFIRM || state==APPLY) &&
           (!acquisition_ok || !level || (sample && sensor_ok && !raw_ok))) begin
            state<=REJECT;pipe<=0;
            reason<=!sensor_ok ? 1 : (invalid_now || (sample && !raw_ok)) ? 3 :
                    age>=STALE_CYCLES ? 2 : !level ? 4 : 5;
        end
        if(reset)begin
            state<=NORMAL;reason<=0;active<=0;backup_valid<=0;offset_x<=BASE_X;offset_y<=BASE_Y;gain_x<=BASE_GX;gain_y<=BASE_GY;
            age<=STALE_CYCLES;timer<=0;pipe<=0;have_last<=0;repeats<=0;invalid_now<=0;suspect<=0;profile_changed<=1;
            samples<=0;duplicates<=0;invalid_samples<=0;coverage<=0;
        end
    end
endmodule
