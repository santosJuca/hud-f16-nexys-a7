`timescale 1ns/1ps
// Qualifica o divisor e a transacao digital; nao modela atrasos eletricos do cartao.
module tb_sd_read_400khz;
    reg clk=0, rst=1, start=0;
    always #5 clk=~clk;
    wire sck, mosi, cs_n, miso, busy, done, error, valid, block_valid;
    wire [7:0] data_byte;
    wire [8:0] byte_index;
    integer count=0, reads;
    time last_edge=0;
    sd_spi_read_block #(.HALF_PERIOD_CYCLES(125)) dut (
        .clk(clk),.rst(rst),.start(start),.lba(32'd30028160),.sd_miso(miso),
        .sd_sck(sck),.sd_mosi(mosi),.sd_cs_n(cs_n),.busy(busy),.done(done),
        .error(error),.data_valid(valid),.data_byte(data_byte),
        .byte_index(byte_index),.block_valid(block_valid));
    sd_video_card_model #(.FILE_BYTES(512),.BASE_LBA(30028160)) card (
        .sck(sck),.cs_n(cs_n),.mosi(mosi),.rst(rst),.corrupt_crc(1'b0),
        .timeout_token(1'b0),.bad_header(1'b0),.miso(miso),.reads(reads));
    always @(sck) if (!rst && busy) begin
        if(last_edge!=0 && $time-last_edge!=1250)
            $fatal(1,"Meio periodo SPI incorreto: %0t",$time-last_edge);
        last_edge=$time;
    end
    always @(posedge clk) if(valid) begin
        if(byte_index!==count || data_byte!==card.memory[count])
            $fatal(1,"Byte/cabecalho incorreto index=%0d",count);
        count=count+1;
    end
    initial begin
        repeat(10) @(negedge clk);
        rst=0;
        @(negedge clk);start=1;
        @(negedge clk);start=0;
        wait(done);@(negedge clk);
        if(error || !block_valid || count!=512 || reads!=1)
            $fatal(1,"CMD17/CRC16 falhou count=%0d reads=%0d",count,reads);
        $display("SD_400KHZ_CMD17_CRC16_PASS lba=30028160 bytes=512 half_period_ns=1250");
        $finish;
    end
    initial begin #20000000;$fatal(1,"Timeout SPI 400 kHz");end
endmodule
