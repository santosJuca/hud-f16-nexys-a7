`timescale 1ns/1ps
module tb_sd_ddr2_vga #(
    parameter integer WIDTH=320, HEIGHT=240,
    parameter integer FRAMES=3,
    parameter integer SCENARIO=0,
    parameter integer TEST_CLK_HZ=100_000_000,
    parameter integer READ_HALF=2,
    parameter integer FPS=30,
    parameter integer BASE_LBA=1000,
    parameter integer INIT_HALF=2,
    parameter integer NAC_BYTES=0, NAC_JITTER_BYTES=0, R1_WAIT_BYTES=0,
    // Experimental 640x480 2 bpp: BPP=2 com WIDTH=640/HEIGHT=480. USE_DDR2=0 exercita SD->BRAM.
    // SCENARIO 7: paleta do cabecalho diverge da sintetizada; 8: fmt=1 com geometria 2 bpp;
    // 9: medicao de cadencia (como 0, mas sem exigir carga dentro do periodo de 30 FPS).
    parameter integer BPP=8,
    parameter logic [31:0] PALETTE=32'h100C0400,
    parameter integer USE_DDR2=1
);
    localparam integer BYTES=WIDTH*HEIGHT*BPP/8, STRIDE=(BYTES+511)/512*512;
    localparam logic [31:0] LOADER_PALETTE = SCENARIO==7 ? PALETTE^32'h00000100 : PALETTE;
    localparam integer FILE_BYTES=512+FRAMES*STRIDE, AB=$clog2(BYTES);
    reg ui_clk=0;
    always #6.154 ui_clk=~ui_clk;
    reg clk=0, rst=1;
    always #5 clk=~clk;
    wire pixel_clk, hsync,vsync,video_on;
    wire [9:0] x,y;
    vga_controller raster(.clk_100mhz(clk),.pixel_clk(pixel_clk),.hsync(hsync),.vsync(vsync),.pixel_x(x),.pixel_y(y),.video_on(video_on));
    wire request,grant,ready,init_failed,busy,done,error,block_valid,data_valid;
    wire [31:0] lba;
    wire [8:0] byte_index;
    wire [7:0] data_byte;
    wire sck,mosi,cs_n,miso;
    reg inflight=0,seen=0;
    integer preloads=0;
    assign grant=request&&!inflight&&!busy;
    always @(posedge clk) if(rst) begin inflight<=0; seen<=0; end
    else if(grant) begin inflight<=1; seen<=0; end
    else if(busy) seen<=1;
    else if(seen) begin inflight<=0; seen<=0; end
    sd_spi_controller #(.POWERUP_CYCLES(4),.INIT_HALF_PERIOD_CYCLES(INIT_HALF),
        .READ_HALF_PERIOD_CYCLES(READ_HALF),.MAX_READ_WAIT_TOKEN_CLOCKS(8*(NAC_BYTES+NAC_JITTER_BYTES+8))) sd (
        .clk(clk),.rst(rst),.read_start(grant),.read_lba(lba),.sd_miso(miso),
        .sd_sck(sck),.sd_mosi(mosi),.sd_cs_n(cs_n),.init_ready(ready),.init_failed(init_failed),
        .read_busy(busy),.read_done(done),.read_error(error),.block_valid(block_valid),
        .data_valid(data_valid),.data_byte(data_byte),.byte_index(byte_index));
    reg corrupt=0,timeout_token=0,bad_header=0;
    wire [31:0] reads;
    sd_video_card_model #(.FILE_BYTES(FILE_BYTES),.BASE_LBA(BASE_LBA),.NAC_BYTES(NAC_BYTES),.NAC_JITTER_BYTES(NAC_JITTER_BYTES),.R1_WAIT_BYTES(R1_WAIT_BYTES)) card(.sck(sck),.cs_n(cs_n),.mosi(mosi),.rst(rst),
        .corrupt_crc(corrupt),.timeout_token(timeout_token),.bad_header(bad_header),.miso(miso),.reads(reads));
    wire ddr_ready;
    wire frame_start,abort_frame,commit_frame,write_frame,buffer_ready,header_valid,failed;
    always @(posedge clk) if(!rst && frame_start && !buffer_ready) preloads=preloads+1;
    wire [AB-1:0] write_address,read_address;
    wire [31:0] frames_loaded,errors,late_frames,cycles;
    wire [3:0] state;
    sd_video_loader #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.FPS(FPS),.BPP(BPP),.PALETTE(LOADER_PALETTE),
        .BASE_LBA(BASE_LBA),.MAX_FILE_SECTORS(FILE_BYTES/512),
        .CLK_HZ(TEST_CLK_HZ),.RETRY_CYCLES(50)) loader(
        .clk(clk),.rst(rst),.init_ready(ready),.init_failed(init_failed),.request(request),.grant(grant),
        .lba(lba),.read_busy(busy),.read_done(done),.read_error(error),.data_valid(data_valid),
        .block_valid(block_valid),.byte_index(byte_index),.data_byte(data_byte),.buffer_ready(USE_DDR2 ? ddr_ready : buffer_ready),
        .frame_start(frame_start),.frame_abort(abort_frame),.frame_commit(commit_frame),
        .frame_write(write_frame),.frame_address(write_address),.header_valid(header_valid),
        .failed(failed),.frames_loaded(frames_loaded),.errors(errors),.late_frames(late_frames),
        .transfer_cycles(cycles),.state(state));
    wire read_enable,byte_valid,frame_valid,updated,buffer_error;
    wire [7:0] pixel_byte;
    wire out_start,out_abort,out_valid,out_commit;
    wire [AB-1:0] out_address;
    wire [7:0] out_byte;
    wire [26:0] app_addr;
    wire [2:0] app_cmd;
    wire app_en,app_wdf_wren,app_wdf_end;
    wire [127:0] app_wdf_data;
    wire [15:0] app_wdf_mask;
    reg [127:0] app_rd_data=0;
    reg app_rd_data_valid=0,app_rd_data_end=0;
    reg [31:0] random_state=32'h31415926;
    wire app_rdy=random_state[0] || random_state[2];
    wire app_wdf_rdy=random_state[1] || random_state[4];
    wire ddr_done,ddr_pass,ddr_error;
    integer good_readbacks=0;
    reg done_seen=0,saw_ddr_error=0;
    always @(posedge ui_clk) begin
        done_seen<=ddr_done;
        if(ddr_done && ddr_pass && !done_seen) good_readbacks=good_readbacks+1;
        if(ddr_error) saw_ddr_error=1;
    end
    reg [127:0] memory[0:BYTES/16-1];
    integer pending_index=-1,wait_read=0,ddr_writes=0,ddr_reads=0;
    always @(posedge ui_clk) begin
        random_state<={random_state[30:0],random_state[31]^random_state[21]^random_state[1]^random_state[0]};
        app_rd_data_valid<=0;app_rd_data_end<=0;
        if(rst) pending_index=-1;
        else begin
            if(app_en) begin
                if(!app_rdy || app_addr[2:0]!=0 || (app_addr>>3)>=BYTES/16) $fatal(1,"MIG comando invalido");
                if(app_cmd==0) begin
                    if(!app_wdf_wren || !app_wdf_end || !app_wdf_rdy || app_wdf_mask!=0) $fatal(1,"MIG escrita invalida");
                    memory[app_addr>>3]<=app_wdf_data;
                    ddr_writes=ddr_writes+1;
                end else if(app_cmd==1) begin
                    if(pending_index!=-1) $fatal(1,"MIG leitura sobreposta");
                    pending_index=app_addr>>3;wait_read=2+random_state[7:5];
                    ddr_reads=ddr_reads+1;
                end else $fatal(1,"MIG opcode invalido");
            end
            if(pending_index!=-1) begin
                if(wait_read>0) wait_read=wait_read-1;
                else begin
                    app_rd_data<=memory[pending_index];app_rd_data_valid<=1;app_rd_data_end<=1;pending_index=-1;
                end
            end
        end
    end
    ddr2_sd_frame_mirror #(.FRAME_BYTES(BYTES),.OUTPUT_STREAM(1)) mirror(
        .src_clk(clk),.src_rst(rst),.src_frame_start(frame_start),.src_frame_abort(abort_frame),
        .src_frame_commit(commit_frame),.src_frame_write(write_frame),.src_frame_address(write_address),
        .src_data_byte(data_byte),.src_ready(ddr_ready),.out_ready(USE_DDR2 ? buffer_ready : 1'b1),
        .out_start(out_start),.out_abort(out_abort),.out_commit(out_commit),.out_valid(out_valid),
        .out_address(out_address),.out_byte(out_byte),
        .ui_clk(ui_clk),.ui_rst(rst),.init_calib_complete(!rst),
        .app_rdy(app_rdy),.app_wdf_rdy(app_wdf_rdy),.app_rd_data(app_rd_data),
        .app_rd_data_valid(app_rd_data_valid),.app_rd_data_end(app_rd_data_end),
        .app_addr(app_addr),.app_cmd(app_cmd),.app_en(app_en),.app_wdf_data(app_wdf_data),
        .app_wdf_mask(app_wdf_mask),.app_wdf_wren(app_wdf_wren),.app_wdf_end(app_wdf_end),
        .test_done(ddr_done),.test_pass(ddr_pass),.test_error(ddr_error));
    sd_sector_buffer #(.BYTES(BYTES)) buffer(.wr_clk(clk),.rd_clk(pixel_clk),.rst(rst),
        .wr_start(USE_DDR2 ? out_start : frame_start),.wr_abort(USE_DDR2 ? out_abort : abort_frame),
        .wr_valid(USE_DDR2 ? out_valid : write_frame),.wr_commit(USE_DDR2 ? out_commit : commit_frame),
        .wr_byte(USE_DDR2 ? out_byte : data_byte),.wr_index(USE_DDR2 ? out_address : write_address),
        .wr_ready(buffer_ready),.wr_error(buffer_error),
        .rd_frame_start(x==0&&y==480),.rd_enable(read_enable),.rd_address(read_address),
        .rd_byte(pixel_byte),.rd_valid(byte_valid),.rd_sector_valid(frame_valid),.rd_updated(updated));
    reg mode=1;
    wire opaque=(x>=20&&x<25&&y>=10&&y<15)||(x==320&&y==240);
    wire [11:0] hud=(x==320&&y==240)?12'h0f0:12'h000;
    wire [11:0] rgb;
    wire hs,vs,enabled;
    sd_video_background #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.BPP(BPP),.PALETTE(PALETTE)) background(.pixel_clk(pixel_clk),.rst(rst),
        .toggle_button(mode),.pixel_x(x),.pixel_y(y),.video_on(video_on),.hsync(hsync),.vsync(vsync),
        .hud_rgb(hud),.hud_opaque(opaque),.frame_valid(frame_valid),.byte_valid(byte_valid),
        .pixel_byte(pixel_byte),.read_enable(read_enable),.read_address(read_address),
        .rgb(rgb),.hs(hs),.vs(vs),.enabled(enabled));
    always @(posedge clk) if(!rst) begin
        if(state==4) $display("HEADER parsed=%h valid=%b init_failed=%b",loader.header,loader.header_ok,init_failed);
        if(state==12 && SCENARIO!=3 && SCENARIO!=4 && SCENARIO!=7 && SCENARIO!=8)
            $fatal(1,"Player parou: init_failed=%b header_valid=%b header=%h errors=%0d",init_failed,header_valid,loader.header,errors);
    end
    integer shown=-1,checks=0,updates=0,rasters=0;
    realtime previous_update=0;
    reg [7:0] expected;
    reg [11:0] expected_rgb;
    always @(negedge pixel_clk) if(!rst) begin
        if(updated) begin
            if(x!=1||y!=480) $fatal(1,"Troca fora do blanking x=%0d y=%0d",x,y);
            shown=updates%FRAMES; updates=updates+1;
            if(previous_update != 0)
                $display("DISPLAY_CADENCE interval_ms=%0.6f source_frame=%0d",($realtime-previous_update)/1000000.0,frames_loaded);
            previous_update=$realtime;
        end
        if(hs!==hsync||vs!==vsync) $fatal(1,"Sincronismo deslocado");
        if(commit_frame && buffer_error) $fatal(1,"Tentativa de publicar framebuffer com erro");
        if(video_on && shown>=0 && frame_valid) begin
            if(BPP==2) begin
                // Decodificacao independente: byte y*160+x/4, bits 7:6 = pixel x%4==0.
                expected=card.memory[512+shown*STRIDE+y*(WIDTH/4)+x/4];
                expected=PALETTE[8*((expected>>(6-2*(x%4)))&3) +: 8];
            end else
                expected=card.memory[512+shown*STRIDE+(y/(480/HEIGHT))*WIDTH+x/(640/WIDTH)];
            expected_rgb={expected[7:5],expected[7],expected[4:2],expected[4],expected[1:0],expected[1:0]};
            if(!enabled||opaque) expected_rgb=hud;
            if(rgb!==expected_rgb) $fatal(1,"RGB x=%0d y=%0d frame=%0d got=%h expected=%h valid=%b",x,y,shown,rgb,expected_rgb,byte_valid);
            checks=checks+1;
        end else if(!video_on && rgb!==0) $fatal(1,"RGB durante blanking");
        if(x==0&&y==0) rasters=rasters+1;
    end
    // Opcional: grava a primeira varredura completa (rgb444 hex) para comparacao externa.
    integer dump_file=0, dumped=0;
    reg dump_armed=0, dumping=0;
    string dump_path;
    initial dump_armed=$value$plusargs("RGB_DUMP=%s",dump_path);
    always @(negedge pixel_clk) if(!rst && dump_armed) begin
        if(!dumping && dump_file==0 && updates>=1 && shown==0 && x==0 && y==0) begin
            dump_file=$fopen(dump_path,"w"); dumping=1;
        end
        if(dumping && video_on) begin
            $fwrite(dump_file,"%03h\n",rgb); dumped=dumped+1;
            if(dumped==307200) begin $fclose(dump_file); dumping=0; dump_armed=0; end
        end
    end
    initial begin
        repeat(10) @(negedge clk);
        bad_header=SCENARIO==3;
        rst=0;
        if(SCENARIO==3 || SCENARIO==7 || SCENARIO==8) begin
            wait(state==12);
            if(header_valid||frame_valid||frames_loaded!=0||!failed) $fatal(1,"Cabecalho invalido publicado");
            $display("PASS invalid header: fallback, nenhum quadro publicado");
            $finish;
        end
        wait(updates>=1);
        if(SCENARIO==1||SCENARIO==2) begin
            @(negedge clk);
            corrupt=SCENARIO==1; timeout_token=SCENARIO==2;
            wait(errors>=1);
            corrupt=0; timeout_token=0;
            wait(updates>=2);
            if(errors!=1) $fatal(1,"Recuperacao falhou: %0d erros",errors);
        end
        if(SCENARIO==4) begin
            wait(updates>=2); corrupt=1;
            wait(state==12);
            repeat(2000) @(negedge pixel_clk);
            if(errors!=3||!frame_valid||!failed) $fatal(1,"Retries nao limitados/ultimo quadro perdido");
        end else if(SCENARIO==5) begin
            mode=0; wait(!enabled); repeat(2) @(posedge vsync);
            mode=1; wait(enabled); wait(updates>=3);
        end else begin
            wait(updates>=FRAMES+1);
            if(shown!=0) $fatal(1,"Loop nao retornou ao quadro zero");
            repeat(2) @(posedge vsync);
        end
        if(checks<307200) $fatal(1,"Raster insuficiente");
        if(SCENARIO==6 && (late_frames==0 || errors!=0 || preloads==0)) $fatal(1,"Atraso esperado nao foi exercitado corretamente");
        if(SCENARIO==0 && FPS==30 && (errors!=0 || late_frames!=0))
            $fatal(1,"Perfil 30 FPS com erros ou carga atrasada");
        $display("PASS sd_ddr2_vga WIDTH=%0d HEIGHT=%0d BPP=%0d USE_DDR2=%0d FPS=%0d scenario=%0d frames=%0d updates=%0d errors=%0d pixel_checks=%0d load_cycles=%0d late_frames=%0d",WIDTH,HEIGHT,BPP,USE_DDR2,FPS,SCENARIO,frames_loaded,updates,errors,checks,cycles,late_frames);
        if(USE_DDR2 && (good_readbacks<updates || ddr_writes==0 || ddr_reads==0 || ((SCENARIO==0 || SCENARIO==5) && saw_ddr_error))) $fatal(1,"DDR2 nao foi efetivamente usada");
        $display("DDR2_TRAFFIC writes=%0d reads=%0d good_readbacks=%0d preloads=%0d",ddr_writes,ddr_reads,good_readbacks,preloads);
        $finish;
    end
    initial begin #(64'd3000000000 + 64'd1000000000*FRAMES/FPS); $fatal(1,"Timeout global state=%0d frames=%0d",state,frames_loaded); end
endmodule
