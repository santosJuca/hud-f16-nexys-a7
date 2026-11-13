`timescale 1ns/1ps

// Stub exclusivo para simulacao com Icarus.
// Nao faz parte do RTL sintetizado pelo Vivado.
module XADC #(
    parameter [15:0] INIT_40 = 16'h0000,
    parameter [15:0] INIT_41 = 16'h0000,
    parameter [15:0] INIT_42 = 16'h0000,
    parameter [15:0] INIT_48 = 16'h0000,
    parameter [15:0] INIT_49 = 16'h0000,
    parameter [15:0] INIT_4A = 16'h0000,
    parameter [15:0] INIT_4B = 16'h0000,
    parameter [15:0] INIT_4C = 16'h0000,
    parameter [15:0] INIT_4D = 16'h0000,
    parameter [15:0] INIT_4E = 16'h0000,
    parameter [15:0] INIT_4F = 16'h0000,
    parameter SIM_DEVICE = "7SERIES"
)(
    input  wire        CONVST,
    input  wire        CONVSTCLK,
    input  wire [6:0]  DADDR,
    input  wire        DCLK,
    input  wire        DEN,
    input  wire [15:0] DI,
    input  wire        DWE,
    input  wire        RESET,
    input  wire [15:0] VAUXP,
    input  wire [15:0] VAUXN,
    input  wire        VP,
    input  wire        VN,

    output wire [7:0]  ALM,
    output wire        BUSY,
    output wire [4:0]  CHANNEL,
    output wire [15:0] DO,
    output wire        DRDY,
    output wire        EOC,
    output wire        EOS,
    output wire        JTAGBUSY,
    output wire        JTAGLOCKED,
    output wire        JTAGMODIFIED,
    output wire        OT,
    output wire [4:0]  MUXADDR
);

    assign ALM          = 8'h00;
    assign BUSY         = 1'b0;
    assign CHANNEL      = 5'd0;
    assign DO           = 16'h0000;
    assign DRDY         = 1'b0;
    assign EOC          = 1'b0;
    assign EOS          = 1'b0;
    assign JTAGBUSY     = 1'b0;
    assign JTAGLOCKED   = 1'b0;
    assign JTAGMODIFIED = 1'b0;
    assign OT           = 1'b0;
    assign MUXADDR      = 5'd0;

endmodule
