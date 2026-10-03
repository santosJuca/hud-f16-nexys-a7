`timescale 1ns/1ps

module tb_controle_joystick;

    logic clk = 1'b0;
    always #5 clk = ~clk;

    logic [11:0] x_raw = 12'd1000;
    logic [11:0] y_raw = 12'd1200;
    logic sw_n = 1'b1;

    wire x_menos;
    wire x_mais;
    wire y_menos;
    wire y_mais;
    wire botao;

    controle_joystick #(
        .DEADZONE(100),
        .CALIB_BITS(2)
    ) dut (
        .clk(clk),
        .x_raw(x_raw),
        .y_raw(y_raw),
        .sw_n(sw_n),
        .x_menos(x_menos),
        .x_mais(x_mais),
        .y_menos(y_menos),
        .y_mais(y_mais),
        .botao(botao)
    );

    initial begin
        // Mantem o joystick parado durante a calibracao automatica.
        repeat (5) @(posedge clk);
        #1;
        if ({x_menos,x_mais,y_menos,y_mais,botao} !== 5'b00000)
            $fatal(1, "Falha no centro");

        x_raw = 12'd900; y_raw = 12'd1100; #1;
        if ({x_menos,x_mais,y_menos,y_mais} !== 4'b0000)
            $fatal(1, "Falha no limite inferior da deadzone");

        x_raw = 12'd1100; y_raw = 12'd1300; #1;
        if ({x_menos,x_mais,y_menos,y_mais} !== 4'b0000)
            $fatal(1, "Falha no limite superior da deadzone");

        x_raw = 12'd899; y_raw = 12'd1200; #1;
        if (!x_menos || x_mais) $fatal(1, "Falha em X-");

        x_raw = 12'd1101; #1;
        if (!x_mais || x_menos) $fatal(1, "Falha em X+");

        x_raw = 12'd1000; y_raw = 12'd1099; #1;
        if (!y_menos || y_mais) $fatal(1, "Falha em Y-");

        y_raw = 12'd1301; #1;
        if (!y_mais || y_menos) $fatal(1, "Falha em Y+");

        x_raw = 12'd1000; y_raw = 12'd1200; sw_n = 1'b0; #1;
        if (!botao) $fatal(1, "Falha no botao");

        $display("PASS joystick: centro, deadzone, quatro sentidos e botao");
        $finish;
    end

endmodule
