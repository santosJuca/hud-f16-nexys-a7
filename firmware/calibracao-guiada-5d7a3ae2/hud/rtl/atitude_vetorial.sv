// Vetor de gravidade no referencial do sensor. a_dot = a x omega.
// +pitch: accel Y positivo; +roll: accel X negativo. Z positivo nivelado.
module atitude_vetorial #(parameter integer CAL_LOG2=6,CLK_HZ=100_000_000,ACCEL_STEP_LIMIT=128,STARTUP_GYRO_MAX_RAW=1572,ALLOW_TILTED_STARTUP=1'b0,SENSOR_FAULT_GRACE_CYCLES=1,STALE_RESET_CYCLES=CLK_HZ/4)(
    input wire clk, reset, sensor_ok, sample, zero_request,
    input wire signed [15:0] ax,ay,az,gx,gy,gz,
    output logic calibrated=0, valid=0, updated=0, stationary=0,
    output logic zero_set=0, zero_rejected=0,
    output logic signed [31:0] raw_roll=0,raw_pitch=0,roll=0,pitch=0,
    output wire [25:0] calibration_debug,
    output logic signed [23:0] gravity_x=0,gravity_y=0,gravity_z=0
);
    localparam integer N=1<<CAL_LOG2;
    localparam logic signed [63:0] RATE_SCALE=64'sd96003*(100_000_000/CLK_HZ);
    typedef enum logic [4:0] {IDLE,SQUARE,NORM,CHECK,CALC_DT,RATE,SCALE,CROSS,CROSS_SUB,
        PREDICT,CORRECT,NSQUARE,NNORM,NFACTOR,NORMALIZE,ROLL_START,ROLL_WAIT,
        MAGNITUDE,PITCH_START,PITCH_WAIT,PUBLISH} phase_t;
    phase_t phase=IDLE;
    logic signed [31:0] a[0:2], w[0:2], offset[0:2], bias[0:2];
    logic signed [23:0] g[0:2];
    logic signed [25:0] predicted[0:2];
    logic signed [47:0] sums_a[0:2],sums_w[0:2];
    logic signed [31:0] previous_a[0:2];
    logic signed [15:0] calibration_min[0:2],calibration_max[0:2];
    wire signed [31:0] window_low[0:2],window_high[0:2];
    logic [CAL_LOG2:0] count=0,still_count=0;
    logic [11:0] last_failures=0;
    logic [12:0] blocked_seen=0;
    assign calibration_debug=calibrated ? 26'd0 : {6'd0,7'(count),blocked_seen};
    logic [31:0] age=0, dt=0, sample_dt=0, stale=0;
    logic [31:0] sensor_fault_cycles=0;

    always_ff @(posedge clk) begin
        if(reset || sensor_ok)
            sensor_fault_cycles<=0;
        else if(sensor_fault_cycles<SENSOR_FAULT_GRACE_CYCLES)
            sensor_fault_cycles<=sensor_fault_cycles+1'b1;
    end
    logic had_time=0,previous_valid=0, gravity_ok=0,quiet=0;
    logic signed [47:0] squares[0:2];
    logic signed [49:0] norm=0;
    logic signed [40:0] products[0:2];
    (* use_dsp="yes" *) logic signed [57:0] scaled[0:2];
    logic signed [42:0] crosses[0:2];
    // |g| proximo de 2^20: 24 bits cobrem +/-8g. dt<=100 ms, |gyro_corr|<32900.
    // Delta em radianos Q17 cabe em 18 bits: um DSP25x18 por produto.
    (* use_dsp="yes" *) logic signed [41:0] cross_positive[0:2],cross_negative[0:2];
    logic signed [17:0] radians[0:2];
    logic signed [22:0] factor=0;
    logic signed [46:0] normalization[0:2];
    logic signed [31:0] zero_r=0,zero_p=0,roll_pending=0;
    logic signed [63:0] magnitude_product=0;
    logic signed [31:0] magnitude=0;
    logic start_cordic=0;
    wire cordic_done;
    logic signed [31:0] cordic_x=0,cordic_y=0;
    wire signed [31:0] cordic_angle,cordic_magnitude;
    atitude_cordic u_angles(.clk(clk),.reset(reset || !sensor_ok),.start(start_cordic),
        .x_in(cordic_x),.y_in(cordic_y),.angle_in(32'sd0),.done(cordic_done),
        .busy(),.x_out(cordic_magnitude),.y_out(),.angle_out(cordic_angle));
    function automatic signed [31:0] wrap(input signed [31:0] v);
        if(v>184320) wrap=v-368640;
        else if(v < -184320) wrap=v+368640;
        else wrap=v;
    endfunction
    function automatic [31:0] absolute(input signed [31:0] v);
        absolute=v<0 ? -v : v;
    endfunction
    for(genvar j=0;j<3;j++) begin : g_cal_window
        assign window_low[j]=(count==0 || w[j]<32'($signed(calibration_min[j]))) ?
            w[j] : 32'($signed(calibration_min[j]));
        assign window_high[j]=(count==0 || w[j]>32'($signed(calibration_max[j]))) ?
            w[j] : 32'($signed(calibration_max[j]));
    end
    // Mede bias antes de exigir zero: limite inicial de 12 graus/s e faixa de 2 graus/s na janela.
    wire initial_gyro_stable=absolute(w[0])<=STARTUP_GYRO_MAX_RAW && absolute(w[1])<=STARTUP_GYRO_MAX_RAW && absolute(w[2])<=STARTUP_GYRO_MAX_RAW &&
        window_high[0]-window_low[0]<=262 && window_high[1]-window_low[1]<=262 &&
        window_high[2]-window_low[2]<=262;
    initial begin
        for(integer j=0;j<3;j=j+1) begin
            a[j]=0; w[j]=0; offset[j]=0; bias[j]=0;
            g[j]=j==2 ? 1048576 : 0; predicted[j]=0;
            sums_a[j]=0; sums_w[j]=0; previous_a[j]=0;
            calibration_min[j]=0; calibration_max[j]=0;
        end
    end
    always_ff @(posedge clk) begin
        updated<=0; start_cordic<=0;
        if(age<(CLK_HZ/10+1)) age<=age+1'b1;
        if(stale<STALE_RESET_CYCLES) stale<=stale+1'b1;
        if(stale>=CLK_HZ/4) valid<=0;
        if(reset ||
           (!sensor_ok &&
            sensor_fault_cycles>=SENSOR_FAULT_GRACE_CYCLES-1) ||
           stale==(STALE_RESET_CYCLES-1)) begin
            phase<=IDLE; calibrated<=0; valid<=0; stationary<=0;
            count<=0; still_count<=0; age<=0; had_time<=0; previous_valid<=0;
            zero_r<=0; zero_p<=0; zero_set<=0; zero_rejected<=0;
            stale<=0;
            if(reset) blocked_seen<=0;
            else if(previous_valid || calibrated) blocked_seen<=blocked_seen | 13'h1000;
            for(integer j=0;j<3;j=j+1) begin
                sums_a[j]<=0; sums_w[j]<=0; offset[j]<=0; bias[j]<=0;
                g[j]<=j==2 ? 1048576 : 0;
                calibration_min[j]<=0; calibration_max[j]<=0;
            end
        end else if(!sensor_ok) begin
            // Aviso imediato, sem descartar o bias por falha breve.
            valid<=0;
            stationary<=0;
            phase<=IDLE;
            had_time<=0;
        end else begin
            if(zero_request) begin
                if(valid && stationary && absolute(raw_roll)<=5120 && absolute(raw_pitch)<=5120) begin zero_r<=raw_roll; zero_p<=raw_pitch; zero_set<=1; zero_rejected<=0; end
                else zero_rejected<=1;
            end
            case(phase)
                IDLE: if(sample) begin
                    a[0]<=ax; a[1]<=ay; a[2]<=az;
                    w[0]<=gx; w[1]<=gy; w[2]<=gz;
                    sample_dt<=age+1'b1; age<=0; stale<=0;
                    phase<=SQUARE;
                end
                SQUARE: begin
                    for(integer j=0;j<3;j=j+1) squares[j]<=$signed(a[j][15:0])*$signed(a[j][15:0]);
                    phase<=NORM;
                end
                NORM: begin
                    norm<=squares[0]+squares[1]+squares[2];
                    last_failures<={
                        (a[2]<=15564 || a[2]>=17204),absolute(a[1])>=1400,absolute(a[0])>=1400,
                        window_high[2]-window_low[2]>262,window_high[1]-window_low[1]>262,window_high[0]-window_low[0]>262,
                        absolute(w[2])>STARTUP_GYRO_MAX_RAW,absolute(w[1])>STARTUP_GYRO_MAX_RAW,absolute(w[0])>STARTUP_GYRO_MAX_RAW,
                        previous_valid && absolute(a[2]-previous_a[2])>ACCEL_STEP_LIMIT,
                        previous_valid && absolute(a[1]-previous_a[1])>ACCEL_STEP_LIMIT,
                        previous_valid && absolute(a[0]-previous_a[0])>ACCEL_STEP_LIMIT};
                    quiet<=previous_valid &&
                        absolute(a[0]-previous_a[0])<=ACCEL_STEP_LIMIT && absolute(a[1]-previous_a[1])<=ACCEL_STEP_LIMIT &&
                        absolute(a[2]-previous_a[2])<=ACCEL_STEP_LIMIT &&
                        (calibrated ?
                            (absolute(w[0]-bias[0])<=131 && absolute(w[1]-bias[1])<=131 && absolute(w[2]-bias[2])<=131) :
                            initial_gyro_stable);
                    for(integer j=0;j<3;j=j+1) previous_a[j]<=a[j];
                    previous_valid<=1; phase<=CHECK;
                end
                CHECK: begin
                    // |a| entre 0,85g e 1,15g: rejeita aceleracoes lineares evidentes.
                    gravity_ok<=norm>=193944617 && norm<=354999173;
                    if(quiet && norm>=242262016 && norm<=295950090) begin
                        if(still_count<N) still_count<=still_count+1'b1;
                        stationary<=still_count>=N-1;
                    end else begin stationary<=0; still_count<=0; end
                    if(!calibrated) begin
                        blocked_seen<=blocked_seen | {1'b0,last_failures};
                        // Somente 64 amostras consecutivas, paradas e aproximadamente niveladas.
                        if(quiet && (ALLOW_TILTED_STARTUP ?
                            (norm>=242262016 && norm<=295950090 &&
                             a[2]>8192) :
                            (absolute(a[0])<1400 &&
                             absolute(a[1])<1400 &&
                             a[2]>15564 && a[2]<17204))) begin
                            for(integer j=0;j<3;j=j+1) begin
                                sums_a[j]<=sums_a[j]+a[j]; sums_w[j]<=sums_w[j]+w[j];
                                calibration_min[j]<=window_low[j][15:0];
                                calibration_max[j]<=window_high[j][15:0];
                            end
                            if(count==N-1) begin
                                for(integer j=0;j<3;j=j+1) begin
                                    offset[j]<=ALLOW_TILTED_STARTUP ? 32'sd0 :
                                        32'((sums_a[j]+a[j])>>>CAL_LOG2)-
                                        (j==2 ? 16384 : 0);
                                    bias[j]<=32'((sums_w[j]+w[j])>>>CAL_LOG2);
                                    if(ALLOW_TILTED_STARTUP)
                                        g[j]<=24'(32'((sums_a[j]+a[j])>>>
                                            CAL_LOG2) <<< 6);
                                end
                                calibrated<=1; had_time<=0; blocked_seen<=0;
                            end else count<=count+1'b1;
                        end else begin
                            count<=0;
                            for(integer j=0;j<3;j=j+1) begin sums_a[j]<=0; sums_w[j]<=0; end
                        end
                        phase<=IDLE;
                    end else if(sample_dt==0 || sample_dt>(CLK_HZ/10)) begin
                        valid<=0; had_time<=0; phase<=IDLE;
                    end else begin
                        dt<=had_time ? sample_dt : 0; had_time<=1; phase<=CALC_DT;
                    end
                end
                CALC_DT: begin
                    for(integer j=0;j<3;j=j+1) products[j]<=17'(w[j]-bias[j])*$signed({1'b0,dt[23:0]});
                    phase<=RATE;
                end
                RATE: begin
                    // 96003 ~= 2^56*pi/(180*131*100MHz); produtos limitados a 41 bits.
                    for(integer j=0;j<3;j=j+1) scaled[j]<=products[j]*32'(RATE_SCALE);
                    phase<=SCALE;
                end
                SCALE: begin
                    for(integer j=0;j<3;j=j+1) radians[j]<=18'(scaled[j]>>>39);
                    phase<=CROSS;
                end
                CROSS: begin
                    cross_positive[0]<=g[1]*radians[2]; cross_negative[0]<=g[2]*radians[1];
                    cross_positive[1]<=g[2]*radians[0]; cross_negative[1]<=g[0]*radians[2];
                    cross_positive[2]<=g[0]*radians[1]; cross_negative[2]<=g[1]*radians[0];
                    phase<=CROSS_SUB;
                end
                CROSS_SUB: begin
                    // Separa os DSPs da subtracao larga para atender 100 MHz.
                    for(integer j=0;j<3;j=j+1) crosses[j]<=$signed({cross_positive[j][41],cross_positive[j]})-$signed({cross_negative[j][41],cross_negative[j]});
                    phase<=PREDICT;
                end
                PREDICT: begin
                    for(integer j=0;j<3;j=j+1) predicted[j]<=26'(g[j])+26'(crosses[j]>>>17);
                    phase<=CORRECT;
                end
                CORRECT: begin
                    for(integer j=0;j<3;j=j+1)
                        g[j]<=gravity_ok ? predicted[j]+((((a[j]-offset[j])<<<6)-predicted[j])>>>5) : predicted[j];
                    phase<=NSQUARE;
                end
                NSQUARE: begin
                    for(integer j=0;j<3;j=j+1) squares[j]<=g[j]*g[j];
                    phase<=NNORM;
                end
                NNORM: begin norm<=squares[0]+squares[1]+squares[2]; phase<=NFACTOR; end
                NFACTOR: begin
                    // Uma iteracao Newton para manter |g|=1 sem raiz/divisor.
                    factor<=32'((64'sd3298534883328-norm)>>>21); phase<=NORMALIZE;
                end
                NORMALIZE: begin
                    for(integer j=0;j<3;j=j+1) normalization[j]<=g[j]*factor;
                    phase<=ROLL_START;
                end
                ROLL_START: begin
                    for(integer j=0;j<3;j=j+1) g[j]<=32'(normalization[j]>>>20);
                    cordic_x<=32'(normalization[2]>>>20);
                    cordic_y<=-32'(normalization[0]>>>20);
                    start_cordic<=1; phase<=ROLL_WAIT;
                end
                ROLL_WAIT: if(cordic_done) begin
                    roll_pending<=cordic_angle>>>6;
                    magnitude_product<=cordic_magnitude*64'sd19898;
                    phase<=MAGNITUDE;
                end
                MAGNITUDE: begin magnitude<=32'(magnitude_product>>>15); phase<=PITCH_START; end
                PITCH_START: begin
                    cordic_x<=magnitude; cordic_y<=g[1]; start_cordic<=1; phase<=PITCH_WAIT;
                end
                PITCH_WAIT: if(cordic_done) begin
                    raw_roll<=roll_pending; raw_pitch<=cordic_angle>>>6; phase<=PUBLISH;
                end
                PUBLISH: begin
                    gravity_x<=g[0];gravity_y<=g[1];gravity_z<=g[2];
                    roll<=wrap(raw_roll-zero_r); pitch<=raw_pitch-zero_p;
                    valid<=1; updated<=1; phase<=IDLE;
                end
                default: phase<=IDLE;
            endcase
        end
    end
endmodule
