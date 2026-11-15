// Extremos brutos para calibracao externa; nao altera o rumo nem estima offsets.
module magnetometro_extremos(
    input wire clk,reset,sensor_ok,sample,
    input wire signed [15:0] mag_x,mag_y,mag_z,
    output logic [95:0] extremes=0
);
    logic have_sample=0;
    wire usable=sensor_ok && mag_x!=-16'sd4096 && mag_y!=-16'sd4096 && mag_z!=-16'sd4096;
    always_ff @(posedge clk) begin
        if(reset) begin have_sample<=0; extremes<=0; end
        else if(sample && usable) begin
            if(!have_sample) begin
                extremes<={mag_x,mag_x,mag_y,mag_y,mag_z,mag_z};
                have_sample<=1;
            end else begin
                if(mag_x<$signed(extremes[95:80])) extremes[95:80]<=mag_x;
                if(mag_x>$signed(extremes[79:64])) extremes[79:64]<=mag_x;
                if(mag_y<$signed(extremes[63:48])) extremes[63:48]<=mag_y;
                if(mag_y>$signed(extremes[47:32])) extremes[47:32]<=mag_y;
                if(mag_z<$signed(extremes[31:16])) extremes[31:16]<=mag_z;
                if(mag_z>$signed(extremes[15:0])) extremes[15:0]<=mag_z;
            end
        end
    end
endmodule
