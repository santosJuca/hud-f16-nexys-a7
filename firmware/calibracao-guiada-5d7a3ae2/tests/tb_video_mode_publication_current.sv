`timescale 1ns/1ps
module tb_video_mode_publication;
reg clk=0;always #5 clk=~clk;
reg rst=1,grant=0,busy=0,done=0,err=0,dv=0,valid=0,pub=0,puberr=0;
reg [8:0] bi=0;reg [7:0] data=0;reg [1:0] mode=0;
wire request;wire [31:0] lba;wire start,abort,commit,hv,failed;wire[3:0] state;wire[2:0] phase;
wire[31:0] errors;
sd_video_loader #(.WIDTH(32),.HEIGHT(16),.BPP(8),.FPS(30),.BASE_LBA(100),.MAX_FILE_SECTORS(9),
 .CLK_HZ(30),.RETRY_CYCLES(2),.MODE_SEQUENCE(1),.GROUND_FRAMES(2),.DEPARTURE_FRAMES(2),.CRUISE_FRAMES(2),.LANDING_FRAMES(2)) dut(
 .clk(clk),.rst(rst),.init_ready(1'b1),.init_failed(1'b0),.request(request),.grant(grant),.read_busy(busy),
 .read_done(done),.read_error(err),.lba(lba),.data_valid(dv),.block_valid(valid),.byte_index(bi),.data_byte(data),
 .buffer_ready(1'b1),.frame_start(start),.frame_abort(abort),.frame_commit(commit),.frame_write(),.frame_address(),
 .header_valid(hv),.failed(failed),.frames_loaded(),.errors(errors),.late_frames(),.transfer_cycles(),.state(state),
 .operation_mode(mode),.frame_published(pub),.frame_publish_error(puberr),.presentation_phase(phase));
reg[7:0] header[0:511];integer i;
task tick;begin @(posedge clk);#1;end endtask
task read_sector(input integer expected,input integer is_header,input integer corrupt);begin
 wait(request);@(negedge clk);if(lba!=expected) $fatal(1,"LBA got %d expected %d",lba,expected);
 grant=1;tick;@(negedge clk);grant=0;busy=1;tick;@(negedge clk);busy=0;
 for(integer b=0;b<512;b=b+1) begin dv=1;bi=b;data=is_header ? header[b] : b;tick;@(negedge clk);end
 dv=0;valid=!corrupt;done=1;tick;@(negedge clk);valid=0;done=0;
end endtask
task publish;begin
 wait(state==13);repeat(4) tick;if(request) $fatal(1,"prefetched before publication");
 @(negedge clk);pub=1;tick;@(negedge clk);pub=0;
end endtask
initial begin
 for(i=0;i<512;i=i+1) header[i]=0;
 {header[7],header[6],header[5],header[4],header[3],header[2],header[1],header[0]}=64'h0031444956445548;
 header[8]=1;header[11]=2;header[12]=32;header[14]=16;header[16]=30;header[18]=1;header[20]=8;
 header[25]=2;header[29]=2;header[33]=18;header[36]=1;header[40]=1;
 tick;@(negedge clk);rst=0;
 read_sector(100,1,0);read_sector(101,0,0);
 mode=1;publish();
 if(phase!=0) $fatal(1,"departure phase before departure frame was visible");
 read_sector(103,0,1);wait(errors==1);
 if(phase!=0) $fatal(1,"CRC failure changed visible phase");
 // CRC failure retries the same frame without advancing the departure.
 read_sector(103,0,0);publish();
 if(phase!=1) $fatal(1,"departure phase not committed with first departure frame");
 read_sector(104,0,0);publish();
 if(phase!=1) $fatal(1,"cruise phase before cruise frame was visible");
 read_sector(105,0,0);mode=2;publish();
 if(phase!=2) $fatal(1,"queued landing changed visible cruise phase");
 // Contrato atual: pedido em CRUZEIRO e atendido no proximo avanco;
 // quadro106 nao deve ser requisitado depois do pedido de POUSO.
 read_sector(107,0,0);
 // Publication failure also retries the same landing frame.
 wait(state==13);@(negedge clk);puberr=1;tick;@(negedge clk);puberr=0;
 if(phase!=2) $fatal(1,"failed publication changed visible phase");
 read_sector(107,0,0);publish();
 if(phase!=3) $fatal(1,"landing phase not committed with first landing frame");
 read_sector(108,0,0);publish();
 if(phase!=4) $fatal(1,"last landing frame did not enter landed");
 read_sector(108,0,0);mode=0;publish();
 if(phase!=4) $fatal(1,"ground phase before ground frame was visible");
 read_sector(101,0,0);publish();
 if(phase!=0 || errors!=2) $fatal(1,"ground phase/errors wrong");
 $display("PASS loader mode LBA, publication barrier, CRC retry, publication retry, landed hold");$finish;
end
initial begin #200000; $fatal(1,"timeout state=%d lba=%d",state,lba);end
endmodule
