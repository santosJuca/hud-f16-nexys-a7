`timescale 1ns/1ps
module tb_simulador_voo;
    logic clk=0; always #5 clk=~clk;
    logic reset=1, enable=1, tick=0, attitude_valid=1;
    logic signed [31:0] pitch_q10=0, roll_q10=0;
    logic [8:0] heading_ref_deg=359;
    logic heading_ref_valid=1;
    wire [9:0] velocidade_kt;
    wire [16:0] altitude_ft;
    wire [8:0] heading_deg;
    simulador_voo dut(.*);

    task automatic um_tick;
        begin
            @(negedge clk); tick=1;
            @(negedge clk); tick=0;
        end
    endtask
    task automatic ticks(input integer quantidade);
        repeat(quantidade) um_tick();
    endtask

    integer altitude_inicio, altitude_subida, velocidade_inicio, velocidade_subida;
    initial begin
        repeat(2) @(negedge clk); reset=0;
        um_tick();
        if (heading_deg!=359) $fatal(1,"Referência inicial: heading=%0d esperado=359",heading_deg);

        altitude_inicio=altitude_ft; velocidade_inicio=velocidade_kt;
        pitch_q10=32'sd10240; // 10 graus nariz para cima
        ticks(400);
        altitude_subida=altitude_ft; velocidade_subida=velocidade_kt;
        if (altitude_subida<=altitude_inicio)
            $fatal(1,"Pitch positivo: altitude=%0d não subiu de %0d",altitude_subida,altitude_inicio);
        if (velocidade_subida>=velocidade_inicio || velocidade_subida<100)
            $fatal(1,"Subida: velocidade=%0d inicial=%0d",velocidade_subida,velocidade_inicio);

        pitch_q10=-32'sd10240;
        ticks(200);
        if (altitude_ft>=altitude_subida)
            $fatal(1,"Pitch negativo: altitude=%0d não desceu de %0d",altitude_ft,altitude_subida);
        if (velocidade_kt<=velocidade_subida)
            $fatal(1,"Descida: velocidade=%0d não aumentou de %0d",velocidade_kt,velocidade_subida);

        pitch_q10=0; roll_q10=32'sd10240;
        ticks(8);
        if (heading_deg>=359) $fatal(1,"Wrap 359->0 não ocorreu: %0d",heading_deg);
        roll_q10=-32'sd10240;
        heading_ref_deg=0; reset=1; @(negedge clk); reset=0;
        um_tick();
        ticks(8);
        if (heading_deg<358) $fatal(1,"Wrap 0->359 não ocorreu: %0d",heading_deg);

        altitude_inicio=altitude_ft; velocidade_inicio=velocidade_kt;
        attitude_valid=0; pitch_q10=32'sd15360; roll_q10=32'sd46080;
        ticks(20);
        if (altitude_ft!=altitude_inicio || velocidade_kt!=velocidade_inicio)
            $fatal(1,"Perda MPU moveu estado: alt %0d->%0d vel %0d->%0d",
                altitude_inicio,altitude_ft,velocidade_inicio,velocidade_kt);
        attitude_valid=1; ticks(2);
        if (altitude_ft<=altitude_inicio) $fatal(1,"Recuperação MPU não retomou dinâmica");
        if (velocidade_kt<100 || velocidade_kt>600 || altitude_ft>60000)
            $fatal(1,"Saturação: velocidade=%0d altitude=%0d",velocidade_kt,altitude_ft);
        $display("PASS voo: pitch, altitude, velocidade suave, heading circular e perda/recuperação MPU");
        $finish;
    end
endmodule
