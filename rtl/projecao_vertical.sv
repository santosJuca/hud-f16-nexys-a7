// Projecao de accel no eixo vertical; pitch/roll limitados a +/-30 graus.
// g_body = (-sin(roll)*cos(pitch), sin(pitch), cos(roll)*cos(pitch)).
// Convencao: +Z para cima em repouso, pitch positivo com accel_y positivo.
module projecao_vertical (
    input logic clk, sensor_ok, atualizar,
    input logic signed [15:0] accel_x, accel_y, accel_z,
    input logic signed [31:0] pitch_q10, roll_q10,
    output logic signed [18:0] vertical_counts = 0,
    output logic valido = 0
);
    function automatic signed [15:0] seno(input integer a);
        logic signed [15:0] cosseno;
        begin
        case (a)
            0: begin seno=16'sd0; cosseno=16'sd16384; end
            1: begin seno=16'sd286; cosseno=16'sd16382; end
            2: begin seno=16'sd572; cosseno=16'sd16374; end
            3: begin seno=16'sd857; cosseno=16'sd16362; end
            4: begin seno=16'sd1143; cosseno=16'sd16344; end
            5: begin seno=16'sd1428; cosseno=16'sd16322; end
            6: begin seno=16'sd1713; cosseno=16'sd16294; end
            7: begin seno=16'sd1997; cosseno=16'sd16262; end
            8: begin seno=16'sd2280; cosseno=16'sd16225; end
            9: begin seno=16'sd2563; cosseno=16'sd16182; end
            10: begin seno=16'sd2845; cosseno=16'sd16135; end
            11: begin seno=16'sd3126; cosseno=16'sd16083; end
            12: begin seno=16'sd3406; cosseno=16'sd16026; end
            13: begin seno=16'sd3686; cosseno=16'sd15964; end
            14: begin seno=16'sd3964; cosseno=16'sd15897; end
            15: begin seno=16'sd4240; cosseno=16'sd15826; end
            16: begin seno=16'sd4516; cosseno=16'sd15749; end
            17: begin seno=16'sd4790; cosseno=16'sd15668; end
            18: begin seno=16'sd5063; cosseno=16'sd15582; end
            19: begin seno=16'sd5334; cosseno=16'sd15491; end
            20: begin seno=16'sd5604; cosseno=16'sd15396; end
            21: begin seno=16'sd5872; cosseno=16'sd15296; end
            22: begin seno=16'sd6138; cosseno=16'sd15191; end
            23: begin seno=16'sd6402; cosseno=16'sd15082; end
            24: begin seno=16'sd6664; cosseno=16'sd14968; end
            25: begin seno=16'sd6924; cosseno=16'sd14849; end
            26: begin seno=16'sd7182; cosseno=16'sd14726; end
            27: begin seno=16'sd7438; cosseno=16'sd14598; end
            28: begin seno=16'sd7692; cosseno=16'sd14466; end
            29: begin seno=16'sd7943; cosseno=16'sd14330; end
            30: begin seno=16'sd8192; cosseno=16'sd14189; end
            default: begin seno=0; cosseno=0; end
        endcase
        end
    endfunction
    function automatic signed [15:0] cosseno(input integer a);
        logic signed [15:0] seno;
        begin
        case (a)
            0: begin seno=16'sd0; cosseno=16'sd16384; end
            1: begin seno=16'sd286; cosseno=16'sd16382; end
            2: begin seno=16'sd572; cosseno=16'sd16374; end
            3: begin seno=16'sd857; cosseno=16'sd16362; end
            4: begin seno=16'sd1143; cosseno=16'sd16344; end
            5: begin seno=16'sd1428; cosseno=16'sd16322; end
            6: begin seno=16'sd1713; cosseno=16'sd16294; end
            7: begin seno=16'sd1997; cosseno=16'sd16262; end
            8: begin seno=16'sd2280; cosseno=16'sd16225; end
            9: begin seno=16'sd2563; cosseno=16'sd16182; end
            10: begin seno=16'sd2845; cosseno=16'sd16135; end
            11: begin seno=16'sd3126; cosseno=16'sd16083; end
            12: begin seno=16'sd3406; cosseno=16'sd16026; end
            13: begin seno=16'sd3686; cosseno=16'sd15964; end
            14: begin seno=16'sd3964; cosseno=16'sd15897; end
            15: begin seno=16'sd4240; cosseno=16'sd15826; end
            16: begin seno=16'sd4516; cosseno=16'sd15749; end
            17: begin seno=16'sd4790; cosseno=16'sd15668; end
            18: begin seno=16'sd5063; cosseno=16'sd15582; end
            19: begin seno=16'sd5334; cosseno=16'sd15491; end
            20: begin seno=16'sd5604; cosseno=16'sd15396; end
            21: begin seno=16'sd5872; cosseno=16'sd15296; end
            22: begin seno=16'sd6138; cosseno=16'sd15191; end
            23: begin seno=16'sd6402; cosseno=16'sd15082; end
            24: begin seno=16'sd6664; cosseno=16'sd14968; end
            25: begin seno=16'sd6924; cosseno=16'sd14849; end
            26: begin seno=16'sd7182; cosseno=16'sd14726; end
            27: begin seno=16'sd7438; cosseno=16'sd14598; end
            28: begin seno=16'sd7692; cosseno=16'sd14466; end
            29: begin seno=16'sd7943; cosseno=16'sd14330; end
            30: begin seno=16'sd8192; cosseno=16'sd14189; end
            default: begin seno=0; cosseno=0; end
        endcase
        end
    endfunction
    wire faixa = pitch_q10 >= -30720 && pitch_q10 <= 30720 &&
                 roll_q10 >= -30720 && roll_q10 <= 30720;
    wire [31:0] ap = pitch_q10 < 0 ? -pitch_q10 : pitch_q10;
    wire [31:0] ar = roll_q10 < 0 ? -roll_q10 : roll_q10;
    logic signed [15:0] sp=0, cp=0, neg_sr=0, cr=0;
    logic signed [31:0] nx=0, nz=0;
    logic signed [15:0] ny=0;
    logic signed [15:0] ax1=0, ay1=0, az1=0, ax2=0, ay2=0, az2=0;
    logic signed [31:0] px=0, py=0, pz=0;
    logic [3:0] token=0;
    logic [15:0] ap_reg=0, ar_reg=0;
    logic sinal_p=0, sinal_r=0;
    logic signed [15:0] ax0=0, ay0=0, az0=0;
    wire signed [33:0] soma = $signed(px) + $signed(py) + $signed(pz);
    always_ff @(posedge clk) begin
        valido <= 0;
        if (!sensor_ok) token <= 0;
        else begin
            token <= {token[2:0], atualizar && faixa};
            if (atualizar && faixa) begin
                ap_reg <= ap[15:0]; ar_reg <= ar[15:0];
                sinal_p <= pitch_q10[31]; sinal_r <= roll_q10[31];
                ax0 <= accel_x; ay0 <= accel_y; az0 <= accel_z;
            end
            if (token[0]) begin
                sp <= sinal_p ? -seno((ap_reg+16'd512)>>10) : seno((ap_reg+16'd512)>>10);
                cp <= cosseno((ap_reg+16'd512)>>10);
                neg_sr <= sinal_r ? seno((ar_reg+16'd512)>>10) : -seno((ar_reg+16'd512)>>10);
                cr <= cosseno((ar_reg+16'd512)>>10);
                ax1 <= ax0; ay1 <= ay0; az1 <= az0;
            end
            if (token[1]) begin
                nx <= neg_sr * cp; nz <= cr * cp; ny <= sp;
                ax2 <= ax1; ay2 <= ay1; az2 <= az1;
            end
            if (token[2]) begin
                px <= ax2 * $signed(nx[29:14]);
                py <= ay2 * ny;
                pz <= az2 * $signed(nz[29:14]);
            end
            if (token[3]) begin
                vertical_counts <= soma >>> 14;
                valido <= 1;
            end
        end
    end
endmodule
