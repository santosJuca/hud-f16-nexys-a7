// CORDIC sequencial, graus Q16. Sem divisao; 16 iteracoes.
module atitude_cordic #(parameter bit VECTORING=1)(
    input wire clk, reset, start,
    input wire signed [31:0] x_in,y_in,
    input wire signed [31:0] angle_in,
    output logic busy=0, done=0,
    output logic signed [31:0] x_out=0,y_out=0,angle_out=0
);
    logic signed [31:0] x=0,y=0,z=0;
    logic [3:0] i=0;
    logic finishing=0;
    function automatic signed [31:0] atan_step(input [3:0] n);
        case(n)
            0: atan_step=32'sd2949120;
            1: atan_step=32'sd1740967;
            2: atan_step=32'sd919879;
            3: atan_step=32'sd466945;
            4: atan_step=32'sd234379;
            5: atan_step=32'sd117304;
            6: atan_step=32'sd58666;
            7: atan_step=32'sd29335;
            8: atan_step=32'sd14668;
            9: atan_step=32'sd7334;
            10: atan_step=32'sd3667;
            11: atan_step=32'sd1833;
            12: atan_step=32'sd917;
            13: atan_step=32'sd458;
            14: atan_step=32'sd229;
            15: atan_step=32'sd115;
        endcase
    endfunction
    always_ff @(posedge clk) begin
        done<=0;
        if(reset) begin busy<=0; finishing<=0; x_out<=0; y_out<=0; angle_out<=0; end
        else if(start && !busy) begin
            busy<=1; i<=0;
            if(VECTORING) begin
                x<=x_in<0 ? -x_in : x_in;
                y<=x_in<0 ? -y_in : y_in;
                z<=x_in<0 ? (y_in<0 ? -32'sd11796480 : 32'sd11796480) : 0;
            end else begin
                // 1/K em Q20; pre-rotacao cobre todos os quadrantes.
                x<=angle_in>5898240 || angle_in < -5898240 ? -32'sd636751 : 32'sd636751;
                y<=0;
                z<=angle_in>5898240 ? angle_in-11796480 :
                   angle_in < -5898240 ? angle_in+11796480 : angle_in;
            end
        end else if(busy) begin
            if(VECTORING ? y>=0 : z>=0) begin
                x<=x+(VECTORING ? (y>>>i) : -(y>>>i));
                y<=y+(VECTORING ? -(x>>>i) : (x>>>i));
                z<=z+(VECTORING ? atan_step(i) : -atan_step(i));
            end else begin
                x<=x+(VECTORING ? -(y>>>i) : (y>>>i));
                y<=y+(VECTORING ? (x>>>i) : -(x>>>i));
                z<=z+(VECTORING ? -atan_step(i) : atan_step(i));
            end
            if(i==15) begin busy<=0; finishing<=1; i<=0; end else i<=i+1'b1;
        end else begin
            x_out<=x; y_out<=y; angle_out<=z;
            // Saidas estabilizadas um ciclo depois da ultima microrrotacao.
            if(finishing) begin done<=1; finishing<=0; end
        end
    end
endmodule
