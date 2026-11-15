// SOMENTE SIMULACAO/LINT COM ICARUS OU VERILATOR, NUNCA SINTESE.
// Modelos minimos de BUFG, MMCME2_BASE e XADC para elaborar top_reticula sem a
// biblioteca unisims da AMD. Nao modelam jitter, fase, calibracao nem conversao
// analogica: o XADC devolve fundo de escala medio (joystick centrado) e
// temperatura constante. Os testes com unisims oficiais continuam em xsim.
`timescale 1ns/1ps
module BUFG(input wire I, output wire O);
    assign O = I;
endmodule

module MMCME2_BASE #(
    parameter BANDWIDTH = "OPTIMIZED",
    parameter real CLKIN1_PERIOD = 10.0,
    parameter integer DIVCLK_DIVIDE = 1,
    parameter real CLKFBOUT_MULT_F = 10.0,
    parameter real CLKFBOUT_PHASE = 0.0,
    parameter real CLKOUT0_DIVIDE_F = 10.0,
    parameter integer CLKOUT1_DIVIDE = 10,
    parameter real CLKOUT0_PHASE = 0.0,
    parameter real CLKOUT0_DUTY_CYCLE = 0.5,
    parameter STARTUP_WAIT = "FALSE"
) (
    input wire CLKIN1, CLKFBIN, RST, PWRDWN,
    output wire CLKFBOUT,
    output reg CLKOUT0 = 0, CLKOUT1 = 0,
    output reg LOCKED = 0
);
    localparam real VCO = CLKIN1_PERIOD*DIVCLK_DIVIDE/CLKFBOUT_MULT_F;
    assign CLKFBOUT = CLKIN1;
    always #(VCO*CLKOUT0_DIVIDE_F/2.0) CLKOUT0 = ~CLKOUT0;
    always #(VCO*CLKOUT1_DIVIDE/2.0) CLKOUT1 = ~CLKOUT1;
    initial begin
        LOCKED = 0;
        #(CLKIN1_PERIOD*50);
        LOCKED = 1;
    end
    always @(posedge RST) LOCKED <= 0;
endmodule

module XADC #(
    parameter [15:0] INIT_40 = 0, INIT_41 = 0, INIT_42 = 0, INIT_43 = 0, INIT_44 = 0,
    INIT_45 = 0, INIT_46 = 0, INIT_47 = 0, INIT_48 = 0, INIT_49 = 0, INIT_4A = 0,
    INIT_4B = 0, INIT_4C = 0, INIT_4D = 0, INIT_4E = 0, INIT_4F = 0,
    parameter SIM_DEVICE = "7SERIES", parameter SIM_MONITOR_FILE = ""
) (
    input wire CONVST, CONVSTCLK,
    input wire [6:0] DADDR,
    input wire DCLK, DEN,
    input wire [15:0] DI,
    input wire DWE, RESET,
    input wire [15:0] VAUXP, VAUXN,
    input wire VP, VN,
    output wire [7:0] ALM,
    output wire BUSY,
    output reg [4:0] CHANNEL = 0,
    output reg [15:0] DO = 0,
    output reg DRDY = 0,
    output reg EOC = 0,
    output wire EOS, JTAGBUSY, JTAGLOCKED, JTAGMODIFIED, OT,
    output wire [4:0] MUXADDR
);
    assign {ALM, BUSY, EOS, JTAGBUSY, JTAGLOCKED, JTAGMODIFIED, OT, MUXADDR} = 0;
    integer count = 0, slot = 0;
    always @(posedge DCLK) begin
        EOC <= 0;
        DRDY <= 0;
        if (DEN) begin
            DRDY <= 1;
            DO <= DADDR[4:0] == 0 ? 16'h9C00 : 16'h8000;
        end
        count <= count + 1;
        if (count == 104) begin  // ~1 us por conversao a 100 MHz
            count <= 0;
            slot <= (slot + 1) % 3;
            CHANNEL <= slot == 0 ? 5'd0 : slot == 1 ? 5'd19 : 5'd26;
            EOC <= 1;
        end
    end
endmodule
