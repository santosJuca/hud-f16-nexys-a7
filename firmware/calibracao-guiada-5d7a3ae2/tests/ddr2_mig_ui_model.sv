`timescale 1ns/1ps
// Modelo de interface para o teste do top. Nao representa PHY nem temporizacao DDR2.
module ddr2_p0_mig_nexys(
    inout wire [15:0] ddr2_dq,
    inout wire [1:0] ddr2_dqs_n,ddr2_dqs_p,
    output wire [12:0] ddr2_addr,
    output wire [2:0] ddr2_ba,
    output wire ddr2_ras_n,ddr2_cas_n,ddr2_we_n,
    output wire [0:0] ddr2_ck_p,ddr2_ck_n,ddr2_cke,ddr2_cs_n,ddr2_odt,
    output wire [1:0] ddr2_dm,
    input wire sys_clk_i,clk_ref_i,sys_rst,
    input wire [11:0] device_temp_i,
    input wire [26:0] app_addr,
    input wire [2:0] app_cmd,
    input wire app_en,
    output wire app_rdy,app_wdf_rdy,
    input wire [127:0] app_wdf_data,
    input wire [15:0] app_wdf_mask,
    input wire app_wdf_wren,app_wdf_end,
    output reg [127:0] app_rd_data=0,
    output reg app_rd_data_valid=0,app_rd_data_end=0,
    input wire app_sr_req,app_ref_req,app_zq_req,
    output wire app_sr_active,app_ref_ack,app_zq_ack,
    output reg ui_clk=0,ui_clk_sync_rst=1,init_calib_complete=0
);
    always #6.154 ui_clk=~ui_clk;
    integer cycles=0,pending=-1,delay_read=0,writes=0,reads=0;
    reg [127:0] memory[0:8191];
    assign {ddr2_addr,ddr2_ba,ddr2_ras_n,ddr2_cas_n,ddr2_we_n,ddr2_ck_p,ddr2_ck_n,ddr2_cke,ddr2_cs_n,ddr2_odt,ddr2_dm}=0;
    assign {app_sr_active,app_ref_ack,app_zq_ack}=0;
    assign app_rdy=init_calib_complete && cycles%7>=2;
    assign app_wdf_rdy=init_calib_complete && cycles%5!=0;
    always @(posedge ui_clk) begin
        app_rd_data_valid<=0;app_rd_data_end<=0;
        if(!sys_rst) begin cycles=0;pending=-1;init_calib_complete<=0;ui_clk_sync_rst<=1;end
        else begin
            cycles=cycles+1;
            if(cycles>32) ui_clk_sync_rst<=0;
            if(cycles>64) init_calib_complete<=1;
            if(app_en) begin
                if(!app_rdy || app_addr[2:0]!=0 || (app_addr>>3)>8191) $fatal(1,"Comando MIG invalido no top");
                if(app_cmd==0) begin
                    if(!app_wdf_wren || !app_wdf_end || !app_wdf_rdy || app_wdf_mask!=0) $fatal(1,"Escrita MIG invalida no top");
                    memory[app_addr>>3]<=app_wdf_data;writes=writes+1;
                end else if(app_cmd==1) begin
                    if(pending!=-1) $fatal(1,"Leitura MIG sobreposta no top");
                    pending=app_addr>>3;delay_read=3;reads=reads+1;
                end else $fatal(1,"Opcode MIG invalido no top");
            end
            if(pending!=-1) begin
                if(delay_read>0) delay_read=delay_read-1;
                else begin app_rd_data<=memory[pending];app_rd_data_valid<=1;app_rd_data_end<=1;pending=-1;end
            end
        end
    end
endmodule
