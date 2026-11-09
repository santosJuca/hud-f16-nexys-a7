// Pin-compatible simulation replacement for the generated example_top.
// Uses the same unmodified MIG IP, but our own read/write traffic source.
module ddr2_ui_smoke_top #(
    parameter integer FRAME_TEST_WORDS = 0,
    parameter integer ENABLE_SD_MIRROR = 0,
    parameter integer MIRROR_FRAME_BYTES = 76800
) (
    inout  wire [15:0] ddr2_dq,
    inout  wire [1:0]  ddr2_dqs_n,
    inout  wire [1:0]  ddr2_dqs_p,
    output wire [12:0] ddr2_addr,
    output wire [2:0]  ddr2_ba,
    output wire        ddr2_ras_n,
    output wire        ddr2_cas_n,
    output wire        ddr2_we_n,
    output wire [0:0]  ddr2_ck_p,
    output wire [0:0]  ddr2_ck_n,
    output wire [0:0]  ddr2_cke,
    output wire [0:0]  ddr2_cs_n,
    output wire [1:0]  ddr2_dm,
    output wire [0:0]  ddr2_odt,
    input  wire        src_clk,
    input  wire        src_rst,
    input  wire        src_frame_start,
    input  wire        src_frame_abort,
    input  wire        src_frame_commit,
    input  wire        src_frame_write,
    input  wire [($clog2(MIRROR_FRAME_BYTES))-1:0] src_frame_address,
    input  wire [7:0] src_data_byte,
    input  wire        sys_clk_i,
    input  wire        clk_ref_i,
    input  wire        sys_rst,
    input  wire [11:0] device_temp_raw,
    input  wire        device_temp_req,
    output wire        device_temp_ack,
    output wire        tg_compare_error,
    output wire        init_calib_complete,
    output wire        smoke_done,
    output wire        smoke_pass,
    output wire [12:0] smoke_words_compared
);
    wire ui_clk;
    wire ui_clk_sync_rst;
    wire [26:0] app_addr;
    wire [2:0] app_cmd;
    wire app_en;
    wire app_rdy;
    wire app_wdf_rdy;
    wire [127:0] app_wdf_data;
    wire [15:0] app_wdf_mask;
    wire app_wdf_wren;
    wire app_wdf_end;
    wire [127:0] app_rd_data;
    wire app_rd_data_valid;
    wire app_rd_data_end;
    wire app_sr_active;
    wire app_ref_ack;
    wire app_zq_ack;
    wire smoke_error;
    wire [11:0] device_temp_ui;
    wire device_temp_seen_ui;

    // CDC por handshake: barramento permanece estavel ate ACK sincronizado.
    xadc_temperature_cdc u_temperature_cdc (
        .dst_clk(ui_clk),
        .dst_reset(ui_clk_sync_rst),
        .source_data(device_temp_raw),
        .source_toggle(device_temp_req),
        .destination_ack(device_temp_ack),
        .destination_data(device_temp_ui),
        .destination_valid(device_temp_seen_ui)
    );

    assign tg_compare_error = smoke_error;

    ddr2_p0_mig_nexys u_mig (
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_n(ddr2_dqs_n),
        .ddr2_dqs_p(ddr2_dqs_p),
        .ddr2_addr(ddr2_addr),
        .ddr2_ba(ddr2_ba),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_cke(ddr2_cke),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_odt(ddr2_odt),
        .sys_clk_i(sys_clk_i),
        .clk_ref_i(clk_ref_i),
        .sys_rst(sys_rst),
        .device_temp_i(device_temp_ui),
        .app_addr(app_addr),
        .app_cmd(app_cmd),
        .app_en(app_en),
        .app_rdy(app_rdy),
        .app_wdf_rdy(app_wdf_rdy),
        .app_wdf_data(app_wdf_data),
        .app_wdf_mask(app_wdf_mask),
        .app_wdf_wren(app_wdf_wren),
        .app_wdf_end(app_wdf_end),
        .app_rd_data(app_rd_data),
        .app_rd_data_valid(app_rd_data_valid),
        .app_rd_data_end(app_rd_data_end),
        .app_sr_req(1'b0),
        .app_ref_req(1'b0),
        .app_zq_req(1'b0),
        .app_sr_active(app_sr_active),
        .app_ref_ack(app_ref_ack),
        .app_zq_ack(app_zq_ack),
        .ui_clk(ui_clk),
        .ui_clk_sync_rst(ui_clk_sync_rst),
        .init_calib_complete(init_calib_complete)
    );

    // Modos mutuamente exclusivos: P3D (16 words), P4A (sintetico), P4B (SD).
    generate if (ENABLE_SD_MIRROR != 0) begin : g_sd_mirror
        wire src_mirror_ready;
        ddr2_sd_frame_mirror #(.FRAME_BYTES(MIRROR_FRAME_BYTES)) u_mirror (
            .src_clk(src_clk), .src_rst(src_rst),
            .src_frame_start(src_frame_start),
            .src_frame_abort(src_frame_abort),
            .src_frame_commit(src_frame_commit),
            .src_frame_write(src_frame_write),
            .src_frame_address(src_frame_address),
            .src_data_byte(src_data_byte), .src_ready(src_mirror_ready),
            .ui_clk(ui_clk), .ui_rst(ui_clk_sync_rst),
            .init_calib_complete(init_calib_complete),
            .app_rdy(app_rdy), .app_wdf_rdy(app_wdf_rdy),
            .app_rd_data(app_rd_data),
            .app_rd_data_valid(app_rd_data_valid),
            .app_rd_data_end(app_rd_data_end),
            .app_addr(app_addr), .app_cmd(app_cmd), .app_en(app_en),
            .app_wdf_data(app_wdf_data), .app_wdf_mask(app_wdf_mask),
            .app_wdf_wren(app_wdf_wren), .app_wdf_end(app_wdf_end),
            .test_done(smoke_done), .test_pass(smoke_pass),
            .test_error(smoke_error), .words_compared(smoke_words_compared)
        );
    end else if (FRAME_TEST_WORDS > 0) begin : g_frame_test
        ddr2_ui_frame_test #(.WORDS(FRAME_TEST_WORDS)) u_test (
            .ui_clk(ui_clk),
            .ui_rst(ui_clk_sync_rst),
            .init_calib_complete(init_calib_complete),
            .app_rdy(app_rdy),
            .app_wdf_rdy(app_wdf_rdy),
            .app_rd_data(app_rd_data),
            .app_rd_data_valid(app_rd_data_valid),
            .app_rd_data_end(app_rd_data_end),
            .app_addr(app_addr),
            .app_cmd(app_cmd),
            .app_en(app_en),
            .app_wdf_data(app_wdf_data),
            .app_wdf_mask(app_wdf_mask),
            .app_wdf_wren(app_wdf_wren),
            .app_wdf_end(app_wdf_end),
            .test_done(smoke_done),
            .test_pass(smoke_pass),
            .test_error(smoke_error),
            .words_compared(smoke_words_compared)
        );
    end else begin : g_legacy_smoke
        wire [7:0] compared_legacy;
        assign smoke_words_compared = {5'd0, compared_legacy};
        ddr2_ui_smoke #(.WORDS(16)) u_smoke (
            .ui_clk(ui_clk),
            .ui_rst(ui_clk_sync_rst),
            .init_calib_complete(init_calib_complete),
            .app_rdy(app_rdy),
            .app_wdf_rdy(app_wdf_rdy),
            .app_rd_data(app_rd_data),
            .app_rd_data_valid(app_rd_data_valid),
            .app_rd_data_end(app_rd_data_end),
            .app_addr(app_addr),
            .app_cmd(app_cmd),
            .app_en(app_en),
            .app_wdf_data(app_wdf_data),
            .app_wdf_mask(app_wdf_mask),
            .app_wdf_wren(app_wdf_wren),
            .app_wdf_end(app_wdf_end),
            .test_done(smoke_done),
            .test_pass(smoke_pass),
            .test_error(smoke_error),
            .words_compared(compared_legacy)
        );
    end endgenerate
endmodule
