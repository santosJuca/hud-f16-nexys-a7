`timescale 1ns/1ps
module tb_sd_video_capture #(
    parameter integer WIDTH=320, HEIGHT=240,
    parameter integer FRAMES=10,
    parameter integer SCENARIO=0,
    parameter integer TEST_CLK_HZ=100_000_000,
    parameter integer READ_HALF=2
);
    localparam integer BYTES=WIDTH*HEIGHT, STRIDE=(BYTES+511)/512*512;
    localparam integer FILE_BYTES=512+FRAMES*STRIDE, AB=$clog2(BYTES);
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
    assign grant=request&&!inflight&&!busy;
    always @(posedge clk) if(rst) begin inflight<=0; seen<=0; end
    else if(grant) begin inflight<=1; seen<=0; end
    else if(busy) seen<=1;
    else if(seen) begin inflight<=0; seen<=0; end
    sd_spi_controller #(.POWERUP_CYCLES(4),.INIT_HALF_PERIOD_CYCLES(2),
        .READ_HALF_PERIOD_CYCLES(READ_HALF),.MAX_READ_WAIT_TOKEN_CLOCKS(64)) sd (
        .clk(clk),.rst(rst),.read_start(grant),.read_lba(lba),.sd_miso(miso),
        .sd_sck(sck),.sd_mosi(mosi),.sd_cs_n(cs_n),.init_ready(ready),.init_failed(init_failed),
        .read_busy(busy),.read_done(done),.read_error(error),.block_valid(block_valid),
        .data_valid(data_valid),.data_byte(data_byte),.byte_index(byte_index));
    reg corrupt=0,timeout_token=0,bad_header=0;
    wire [31:0] reads;
    sd_video_card_model #(.FILE_BYTES(FILE_BYTES)) card(.sck(sck),.cs_n(cs_n),.mosi(mosi),.rst(rst),
        .corrupt_crc(corrupt),.timeout_token(timeout_token),.bad_header(bad_header),.miso(miso),.reads(reads));
    wire frame_start,abort_frame,commit_frame,write_frame,buffer_ready,header_valid,failed;
    wire [AB-1:0] write_address,read_address;
    wire [31:0] frames_loaded,errors,late_frames,cycles;
    wire [3:0] state;
    sd_video_loader #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.BASE_LBA(1000),.MAX_FILE_SECTORS(FILE_BYTES/512),
        .CLK_HZ(TEST_CLK_HZ),.RETRY_CYCLES(50)) loader(
        .clk(clk),.rst(rst),.init_ready(ready),.init_failed(init_failed),.request(request),.grant(grant),
        .lba(lba),.read_busy(busy),.read_done(done),.read_error(error),.data_valid(data_valid),
        .block_valid(block_valid),.byte_index(byte_index),.data_byte(data_byte),.buffer_ready(buffer_ready),
        .frame_start(frame_start),.frame_abort(abort_frame),.frame_commit(commit_frame),
        .frame_write(write_frame),.frame_address(write_address),.header_valid(header_valid),
        .failed(failed),.frames_loaded(frames_loaded),.errors(errors),.late_frames(late_frames),
        .transfer_cycles(cycles),.state(state));
    wire read_enable,byte_valid,frame_valid,updated,buffer_error;
    wire [7:0] pixel_byte;
    sd_sector_buffer #(.BYTES(BYTES)) buffer(.wr_clk(clk),.rd_clk(pixel_clk),.rst(rst),
        .wr_start(frame_start),.wr_abort(abort_frame),.wr_valid(write_frame),.wr_commit(commit_frame),
        .wr_byte(data_byte),.wr_index(write_address),.wr_ready(buffer_ready),.wr_error(buffer_error),
        .rd_frame_start(publish_frame),.rd_enable(read_enable),.rd_address(read_address),
        .rd_byte(pixel_byte),.rd_valid(byte_valid),.rd_sector_valid(frame_valid),.rd_updated(updated));
    reg capture=0,step_toggle=0;
    wire publish_frame,frozen;
    wire [31:0] frame_id;
    video_captura capture_control(.pixel_clk(pixel_clk),.reset(rst),.capture(capture),
        .step_toggle(step_toggle),.frame_boundary(x==0 && y==480),
        .frame_valid(frame_valid),.updated(updated),.publish(publish_frame),.frozen(frozen),.frame_id(frame_id));
    reg mode=1;
    wire opaque=(x>=20&&x<25&&y>=10&&y<15)||(x==320&&y==240);
    wire [11:0] hud=(x==320&&y==240)?12'h0f0:12'h000;
    wire [11:0] rgb;
    wire hs,vs,enabled;
    sd_video_background #(.WIDTH(WIDTH),.HEIGHT(HEIGHT)) background(.pixel_clk(pixel_clk),.rst(rst),
        .toggle_button(mode),.pixel_x(x),.pixel_y(y),.video_on(video_on),.hsync(hsync),.vsync(vsync),
        .hud_rgb(hud),.hud_opaque(opaque),.frame_valid(frame_valid),.byte_valid(byte_valid),
        .pixel_byte(pixel_byte),.read_enable(read_enable),.read_address(read_address),
        .rgb(rgb),.hs(hs),.vs(vs),.enabled(enabled));
    always @(posedge clk) if(!rst) begin
        if(state==4) $display("HEADER parsed=%h valid=%b init_failed=%b",loader.header,loader.header_ok,init_failed);
        if(state==12 && SCENARIO!=3 && SCENARIO!=4)
            $fatal(1,"Player parou: init_failed=%b header_valid=%b header=%h errors=%0d",init_failed,header_valid,loader.header,errors);
    end
    integer shown=-1,checks=0,updates=0,rasters=0;
    reg [7:0] expected;
    reg [11:0] expected_rgb;
    always @(negedge pixel_clk) if(!rst) begin
        if(updated) begin
            if(x!=1||y!=480) $fatal(1,"Troca fora do blanking x=%0d y=%0d",x,y);
            shown=(frames_loaded-1)%FRAMES; updates=updates+1;
        end
        if(hs!==hsync||vs!==vsync) $fatal(1,"Sincronismo deslocado");
        if(commit_frame && buffer_error) $fatal(1,"Tentativa de publicar framebuffer com erro");
        if(video_on && shown>=0 && frame_valid) begin
            expected=card.memory[512+shown*STRIDE+(y/(480/HEIGHT))*WIDTH+x/(640/WIDTH)];
            expected_rgb={expected[7:5],expected[7],expected[4:2],expected[4],expected[1:0],expected[1:0]};
            if(!enabled||opaque) expected_rgb=hud;
            if(rgb!==expected_rgb) $fatal(1,"RGB x=%0d y=%0d frame=%0d got=%h expected=%h valid=%b",x,y,shown,rgb,expected_rgb,byte_valid);
            checks=checks+1;
        end else if(!video_on && rgb!==0) $fatal(1,"RGB durante blanking");
        if(x==0&&y==0) rasters=rasters+1;
    end
    initial begin
        repeat(10) @(negedge clk);
        bad_header=SCENARIO==3;
        rst=0;
        if(SCENARIO==3) begin
            wait(state==12);
            if(header_valid||frame_valid||frames_loaded!=0||!failed) $fatal(1,"Cabecalho invalido publicado");
            $display("PASS invalid header: fallback, nenhum quadro publicado");
            $finish;
        end
        wait(updates>=1);
        capture=1;
        wait(frozen); repeat(10) @(negedge pixel_clk);
        begin : capture_checks
            integer before_updates;
            before_updates=updates;
            repeat(3) @(posedge vsync);
            if(updates!=before_updates) $fatal(1,"Quadro mudou durante congelamento");
            for(integer i=0;i<3;i++) begin
                step_toggle=~step_toggle;
                wait(updates==before_updates+1);
                before_updates=updates;
                repeat(2) @(posedge vsync);
                if(updates!=before_updates) $fatal(1,"Passo publicou mais de um quadro");
            end
            capture=0;
            wait(updates>=before_updates+2);
            repeat(8) @(negedge pixel_clk);
            if(frame_id!=updates-1) $fatal(1,"Identificacao nao segue quadros apresentados");
            if(errors!=0) $fatal(1,"Captura causou erro SPI");
        end
        if(checks<307200) $fatal(1,"Raster insuficiente");
        $display("PASS captura video WIDTH=%0d scenario=%0d frames=%0d updates=%0d errors=%0d pixel_checks=%0d load_cycles=%0d",WIDTH,SCENARIO,frames_loaded,updates,errors,checks,cycles);
        $finish;
    end
    initial begin #3000000000; $fatal(1,"Timeout global state=%0d frames=%0d",state,frames_loaded); end
endmodule
