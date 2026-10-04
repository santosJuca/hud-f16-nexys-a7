`timescale 1ns/1ps
module tb_top_bmp085_seq;
    logic clk = 0;
    always #5 clk = ~clk;
    tri1 sda, scl, baro_sda, baro_scl;
    integer ciclos;
    top_reticula dut (
        .clk(clk), .btn_heading(2'b00), .sw(4'b0000), .display_mode(1'b0), .style_mode(1'b0),
        .vauxp3(1'b0), .vauxn3(1'b0), .vauxp10(1'b0), .vauxn10(1'b0),
        .i2c_sda(sda), .i2c_scl(scl), .baro_sda(baro_sda), .baro_scl(baro_scl)
    );
    initial begin
        force dut.u_baro.sensor_ok=1;
        force dut.u_baro.calibracao_ok=1;
        force dut.u_baro.ut_valid=1;
        force dut.u_baro.up_valid=0;
        force dut.u_baro.ut_raw=27898;
        force dut.u_baro.up_raw=23843;
        force dut.u_baro.ac1=408;
        force dut.u_baro.ac2=-72;
        force dut.u_baro.ac3=-14383;
        force dut.u_baro.ac4=32741;
        force dut.u_baro.ac5=32757;
        force dut.u_baro.ac6=23153;
        force dut.u_baro.b1=6190;
        force dut.u_baro.b2=4;
        force dut.u_baro.mc=-8711;
        force dut.u_baro.md=2868;
        repeat (5) @(negedge clk);
        if (dut.altitude_hud_entrada!==36000 || dut.BARO_LED!==0)
            $fatal(1,"TOP fallback=%0d esperado=36000 LED=%b esperado=0",dut.altitude_hud_entrada,dut.BARO_LED);
        force dut.u_baro.up_valid=1;
        ciclos=0;
        while (dut.altitude_hud_entrada==36000 && ciclos<1300) begin
            @(negedge clk); ciclos=ciclos+1;
        end
        if (dut.baro_pressao_pa!==69964 || dut.altitude_hud_entrada!==9897 || dut.BARO_LED!==1)
            $fatal(1,"TOP pressao=%0d esperada=69964 altitude=%0d esperada=9897 LED=%b esperado=1",
                dut.baro_pressao_pa,dut.altitude_hud_entrada,dut.BARO_LED);
        force dut.u_baro.up_valid=0;
        repeat (100) @(negedge clk);
        if (dut.altitude_hud_entrada!==9897 || dut.BARO_LED!==0)
            $fatal(1,"TOP intervalo alterou altitude ou LED");
        $display("PASS top BMP085: UT=27898 UP=23843 pressao=69964 altitude=9897, retencao e LED");
        $finish;
    end
endmodule
