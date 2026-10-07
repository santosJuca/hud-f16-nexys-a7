// Limiares didaticos. Angulos em graus Q10, altitude em ft, VSI em ft/min.
module alertas_voo #(
    parameter integer ROLL_CAUTION=15, ROLL_WARNING=25, ROLL_HYST=3,
    parameter integer PITCH_CAUTION=10, PITCH_WARNING=15, PITCH_HYST=2
)(
    input logic clk, reset,
    input logic [1:0] modo,
    input logic modo_invalido,
    input logic [2:0] fase_pouso,
    input logic signed [31:0] roll_q10, pitch_q10,
    input logic [9:0] velocidade_kt,
    input logic [16:0] altitude_ft,
    input logic signed [13:0] vertical_fpm,
    input logic att_valid, alt_valid, heading_valid, vertical_valid,
    output logic [1:0] severity,
    output logic [2:0] causa,
    output wire alert_roll, alert_pitch, alert_speed, alert_altitude, alert_sink, alert_sensor
);
    logic rc=0,rw=0,pc=0,pw=0,sc=0,sw=0,kc=0,kw=0;
    logic sensor=0,baixo=0,invalido=0,solo=1;
    logic [1:0] modo_anterior=0;
    wire mesmo_modo = modo==modo_anterior;
    wire signed [32:0] re = {roll_q10[31],roll_q10};
    wire signed [32:0] pe = {pitch_q10[31],pitch_q10};
    wire [32:0] ar = re < 0 ? -re : re;
    wire [32:0] ap = pe < 0 ? -pe : pe;
    wire pouso_baixo = modo==2 && fase_pouso<3 && altitude_ft<200 && alt_valid;
    wire [32:0] rc_in = pouso_baixo ? 33'd8192 : 33'(ROLL_CAUTION*1024);
    wire [32:0] rw_in = pouso_baixo ? 33'd12288 : 33'(ROLL_WARNING*1024);
    wire [32:0] rc_out = pouso_baixo ? 33'd6144 : 33'((ROLL_CAUTION-ROLL_HYST)*1024);
    wire [32:0] rw_out = pouso_baixo ? 33'd10240 : 33'((ROLL_WARNING-ROLL_HYST)*1024);
    wire speed_context = modo==2 && fase_pouso<3 && altitude_ft<200 && altitude_ft>10 && alt_valid;
    wire sink_context = modo==2 && fase_pouso<3 && altitude_ft<500 && altitude_ft>50 && alt_valid && vertical_valid;
    assign alert_roll=rc|rw; assign alert_pitch=pc|pw;
    assign alert_speed=sc|sw; assign alert_sink=kc|kw;
    assign alert_sensor=sensor; assign alert_altitude=baixo;
    always_ff @(posedge clk) begin
        if(reset) begin
            rc<=0;rw<=0;pc<=0;pw<=0;sc<=0;sw<=0;kc<=0;kw<=0;
            sensor<=0;baixo<=0;invalido<=0;solo<=1;modo_anterior<=0;
        end else begin
            modo_anterior<=modo; solo<=modo==0; invalido<=modo_invalido;
            sensor<=!att_valid || !heading_valid || (modo==0 && !alt_valid);
            baixo<=modo==2 && fase_pouso==2 && alt_valid && altitude_ft<=40;
            rc<=modo!=0 && att_valid && (ar>=rc_in || (mesmo_modo && rc && ar>=rc_out));
            rw<=modo!=0 && att_valid && (ar>=rw_in || (mesmo_modo && rw && ar>=rw_out));
            pc<=modo!=0 && att_valid && (ap>=33'(PITCH_CAUTION*1024) ||
                (mesmo_modo && pc && ap>=33'((PITCH_CAUTION-PITCH_HYST)*1024)));
            pw<=modo!=0 && att_valid && (ap>=33'(PITCH_WARNING*1024) ||
                (mesmo_modo && pw && ap>=33'((PITCH_WARNING-PITCH_HYST)*1024)));
            sc<=speed_context && (velocidade_kt>=155 || velocidade_kt<=100 ||
                (mesmo_modo && sc && (velocidade_kt>=150 || velocidade_kt<=105)));
            sw<=speed_context && (velocidade_kt>=175 || velocidade_kt<=85 ||
                (mesmo_modo && sw && (velocidade_kt>=170 || velocidade_kt<=90)));
            kc<=sink_context && (vertical_fpm<=-1500 || (mesmo_modo && kc && vertical_fpm<=-1300));
            kw<=sink_context && (vertical_fpm<=-2000 || (mesmo_modo && kw && vertical_fpm<=-1800));
        end
    end
    always_comb begin
        severity=0; causa=0;
        if(rw || pw || sw || kw || (sensor && solo)) begin
            severity=3;
            if(rw) causa=1; else if(pw) causa=2; else if(sw) causa=3;
            else if(kw) causa=4; else causa=5;
        end else if(rc || pc || sc || kc || sensor) begin
            severity=2;
            if(rc) causa=1; else if(pc) causa=2; else if(sc) causa=3;
            else if(kc) causa=4; else causa=5;
        end else if(invalido || baixo) begin
            severity=1; causa=invalido ? 3'd7 : 3'd6;
        end
    end
endmodule
