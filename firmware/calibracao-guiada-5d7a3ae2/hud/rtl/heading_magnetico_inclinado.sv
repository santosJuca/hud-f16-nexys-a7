// Nivela o vetor magnetico no referencial fisico compartilhado com o MPU.
// Frente Y, como o HUD: pitch por +Y, roll por -X. Gravidade Q20 antes da zeragem.
module heading_magnetico_inclinado #(
    parameter logic signed [15:0] OFFSET_X=0,OFFSET_Y=0,OFFSET_Z=0,
    parameter logic [12:0] GAIN_X_Q12=4096,GAIN_Y_Q12=4096,GAIN_Z_Q12=4096,
    parameter bit TROCAR_XY=0,INVERTER_X=0,INVERTER_Y=0,
    parameter integer ALINHAMENTO_GRAUS=0,
    parameter integer STALE_CYCLES=50_000_000
)(
    input wire clk,reset,sensor_ok,sample,gravity_valid,calibration_ok,
    input wire signed [15:0] mag_x,mag_y,mag_z,
    input wire signed [23:0] gravity_x,gravity_y,gravity_z,
    output logic [8:0] heading_deg=0,
    output wire valido,
    output logic atualizado=0
);
    typedef enum logic [4:0] {IDLE,ROLL_REQ,ROLL_WAIT,MAGNITUDE,PITCH_REQ,PITCH_WAIT,
        ROLL_TRIG_REQ,ROLL_TRIG_WAIT,PITCH_TRIG_REQ,PITCH_TRIG_WAIT,
        UNROLL_MUL,UNROLL_ADD,UNPITCH_MUL,UNPITCH_ADD,HEADING_REQ,HEADING_WAIT,
        ANGLE_ADD,WRAP,PUBLISH} state_t;
    state_t state=IDLE;
    logic signed [31:0] bx=0,by=0,bz=0,gx=0,gy=0,gz=0;
    logic signed [31:0] phi=0,theta=0,transverse=0;
    logic signed [31:0] cp=0,sp=0,ct=0,st=0,yh=0,zt=0,xh=0;
    logic signed [63:0] magnitude_product=0,a=0,b=0,c=0,d=0;
    logic signed [31:0] angle=0,aligned=0,wrapped=0;
    logic published=0;
    logic [31:0] age=STALE_CYCLES;
    wire ready=sensor_ok && gravity_valid && calibration_ok && !reset;
    assign valido=ready && published && age<STALE_CYCLES;
    wire overflow=mag_x==-16'sd4096 || mag_y==-16'sd4096 || mag_z==-16'sd4096;
    wire signed [17:0] dx=18'($signed(mag_x))-18'($signed(OFFSET_X));
    wire signed [17:0] dy=18'($signed(mag_y))-18'($signed(OFFSET_Y));
    wire signed [17:0] dz=18'($signed(mag_z))-18'($signed(OFFSET_Z));
    wire signed [31:0] mapped_x=TROCAR_XY ? yh : xh;
    wire signed [31:0] mapped_y=TROCAR_XY ? xh : yh;
    logic vec_start=0,trig_start=0;
    logic signed [31:0] vec_x=0,vec_y=0,trig_angle=0;
    wire vec_done,trig_done;
    wire signed [31:0] vec_magnitude,vec_angle,trig_cos,trig_sin;
    atitude_cordic u_vec(.clk(clk),.reset(!ready),.start(vec_start),
        .x_in(vec_x),.y_in(vec_y),.angle_in(32'sd0),.busy(),.done(vec_done),
        .x_out(vec_magnitude),.y_out(),.angle_out(vec_angle));
    atitude_cordic #(.VECTORING(0)) u_trig(.clk(clk),.reset(!ready),.start(trig_start),
        .x_in(32'sd0),.y_in(32'sd0),.angle_in(trig_angle),.busy(),.done(trig_done),
        .x_out(trig_cos),.y_out(trig_sin),.angle_out());
    initial begin
        if(ALINHAMENTO_GRAUS<0 || ALINHAMENTO_GRAUS>359 || STALE_CYCLES<256)
            $fatal(1,"Perfil de rumo inclinado invalido");
        if(GAIN_X_Q12==0 || GAIN_Y_Q12==0 || GAIN_Z_Q12==0)
            $fatal(1,"Ganhos magneticos devem ser positivos");
    end
    always_ff @(posedge clk) begin
        atualizado<=0;vec_start<=0;trig_start<=0;
        if(!ready) begin state<=IDLE;published<=0;age<=STALE_CYCLES;end
        else begin
            if(age<STALE_CYCLES) age<=age+1'b1;
            case(state)
                IDLE: if(sample) begin
                    if(overflow) published<=0;
                    else begin
                        age<=0;
                        bx<=dx*$signed({1'b0,GAIN_X_Q12});
                        by<=dy*$signed({1'b0,GAIN_Y_Q12});
                        bz<=dz*$signed({1'b0,GAIN_Z_Q12});
                        gx<=32'($signed(gravity_x));gy<=32'($signed(gravity_y));gz<=32'($signed(gravity_z));
                        state<=ROLL_REQ;
                    end
                end
                ROLL_REQ: begin vec_x<=gz;vec_y<=-gx;vec_start<=1;state<=ROLL_WAIT;end
                ROLL_WAIT: if(vec_done) begin
                    phi<=vec_angle;magnitude_product<=vec_magnitude*64'sd19898;state<=MAGNITUDE;
                end
                MAGNITUDE: begin transverse<=32'(magnitude_product>>>15);state<=PITCH_REQ;end
                PITCH_REQ: begin
                    // Perto do eixo de frente Y vertical, sua projecao nao define rumo.
                    if(transverse<65536) begin published<=0;state<=IDLE;end
                    else begin vec_x<=transverse;vec_y<=gy;vec_start<=1;state<=PITCH_WAIT;end
                end
                PITCH_WAIT: if(vec_done) begin theta<=vec_angle;state<=ROLL_TRIG_REQ;end
                ROLL_TRIG_REQ: begin trig_angle<=phi;trig_start<=1;state<=ROLL_TRIG_WAIT;end
                ROLL_TRIG_WAIT: if(trig_done) begin cp<=trig_cos;sp<=trig_sin;state<=PITCH_TRIG_REQ;end
                PITCH_TRIG_REQ: begin trig_angle<=theta;trig_start<=1;state<=PITCH_TRIG_WAIT;end
                PITCH_TRIG_WAIT: if(trig_done) begin ct<=trig_cos;st<=trig_sin;state<=UNROLL_MUL;end
                UNROLL_MUL: begin a<=bx*cp;b<=bz*sp;c<=-bx*sp;d<=bz*cp;state<=UNROLL_ADD;end
                UNROLL_ADD: begin xh<=32'((a+b)>>>20);zt<=32'((c+d)>>>20);state<=UNPITCH_MUL;end
                UNPITCH_MUL: begin a<=by*ct;b<=zt*st;state<=UNPITCH_ADD;end
                UNPITCH_ADD: begin yh<=32'((a-b)>>>20);state<=HEADING_REQ;end
                HEADING_REQ: begin
                    if(xh==0 && yh==0) begin published<=0;state<=IDLE;end
                    else begin
                        vec_x<=INVERTER_X ? -mapped_x : mapped_x;
                        vec_y<=INVERTER_Y ? -mapped_y : mapped_y;
                        vec_start<=1;state<=HEADING_WAIT;
                    end
                end
                HEADING_WAIT: if(vec_done) begin angle<=vec_angle;state<=ANGLE_ADD;end
                ANGLE_ADD: begin aligned<=angle+ALINHAMENTO_GRAUS*65536+32768;state<=WRAP;end
                WRAP: begin wrapped<=aligned<0 ? aligned+23592960 : aligned>=23592960 ? aligned-23592960 : aligned;state<=PUBLISH;end
                PUBLISH: begin heading_deg<=9'(wrapped>>>16);published<=1;atualizado<=1;state<=IDLE;end
                default: begin state<=IDLE;published<=0;end
            endcase
        end
    end
endmodule
