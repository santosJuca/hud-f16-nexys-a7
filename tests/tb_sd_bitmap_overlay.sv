`timescale 1ns/1ps
module tb_sd_bitmap_overlay;
    reg clk=0; always #5 clk=~clk;
    reg rst=1, start=0, valid=0, commit=0;
    reg [7:0] data=0;
    reg [8:0] index=0;
    wire pixel_clk,hs,vs,video;
    wire [9:0] x,y;
    wire [11:0] base={x[3:0],y[3:0],x[7:4]^y[7:4]};
    wire ready,pending,published,sector_valid,byte_valid,read_enable;
    wire [7:0] bitmap_byte;
    wire [8:0] address;
    wire [11:0] rgb;
    wire out_hs,out_vs,de,hit;
    reg [7:0] golden[0:511];
    integer i,sx,sy,off,bitno,inside_pixels=0,on_pixels=0;
    reg expected_visible=0,expected_pending=0;
    reg [11:0] expected;
    vga_controller raster(.clk_100mhz(clk),.pixel_clk(pixel_clk),.hsync(hs),.vsync(vs),
        .pixel_x(x),.pixel_y(y),.video_on(video));
    sd_sector_buffer buffer(.wr_clk(clk),.rd_clk(pixel_clk),.rst(rst),
        .wr_start(start),.wr_abort(1'b0),.wr_valid(valid),.wr_commit(commit),
        .wr_byte(data),.wr_index(index),.wr_ready(ready),.wr_active(),.wr_pending(pending),
        .wr_error(),.wr_published(published),.rd_frame_start(x==0 && y==480),
        .rd_enable(read_enable),.rd_address(address),.rd_byte(bitmap_byte),
        .rd_valid(byte_valid),.rd_sector_valid(sector_valid),.rd_updated());
    sd_bitmap_overlay overlay(.pixel_clk(pixel_clk),.rst(rst),.pixel_x(x),.pixel_y(y),
        .video_on(video),.hsync(hs),.vsync(vs),.base_rgb(base),
        .sector_valid(sector_valid),.byte_valid(byte_valid),.bitmap_byte(bitmap_byte),
        .read_enable(read_enable),.read_address(address),.rgb(rgb),.hs(out_hs),.vs(out_vs),.de(de),.overlay_pixel(hit));
    always @(posedge pixel_clk) begin
        if(!rst && x==0 && y==480 && expected_pending) begin
            expected_visible=1; expected_pending=0;
        end
        #1;
        if(!rst) begin
            sx=x; sy=y; expected=base;
            if(expected_visible && sx>=540 && sx<604 && sy>=40 && sy<104) begin
                off=(sy-40)*8+(sx-540)/8; bitno=7-((sx-540)%8);
                inside_pixels=inside_pixels+1;
                if(golden[off][bitno]) begin expected=12'hFF0; on_pixels=on_pixels+1; end
            end
            if(rgb!==expected) $fatal(1,"Bitmap x=%0d y=%0d RGB=%h esperado=%h",sx,sy,rgb,expected);
            if({out_hs,out_vs,de}!=={hs,vs,video}) $fatal(1,"Sincronismo VGA alterado");
        end
    end
    initial begin
        for(i=0;i<512;i=i+1) golden[i]=8'(i*73+19);
        // Cantos acesos tornam erros nas quatro bordas observaveis.
        golden[0]=8'h80; golden[7]=8'h01; golden[504]=8'h80; golden[511]=8'h01;
        repeat(20) @(negedge clk); rst=0; wait(ready);
        @(negedge clk); start=1; @(negedge clk); start=0;
        for(i=0;i<512;i=i+1) begin valid=1; index=9'(i); data=golden[i]; @(negedge clk); end
        valid=0; @(negedge clk); commit=1; expected_pending=1;
        @(negedge clk); commit=0;
        wait(published);
        wait(y==0 && x==0); wait(y==480 && x==1);
        if(inside_pixels!=4096 || on_pixels==0) $fatal(1,"Cobertura incompleta do bitmap");
        $display("PASS bitmap: 4096 pixels, 4 cantos, transparencia, orientacao, prefetch BRAM e sync original");
        $finish;
    end
    initial begin #70000000; $fatal(1,"Watchdog bitmap"); end
endmodule
