`timescale 1ns/1ps
module tb_ddr2_fifo_xpm;
    reg wr_clk=0,rd_clk=0,rst=1,active=0,drain=0;
    always #5 wr_clk=~wr_clk;
    always #6.154 rd_clk=~rd_clk;
    reg wr_en=0,rd_en=0;
    reg [31:0] wr_data=0;
    wire [31:0] rd_data;
    wire full,empty;
    integer written=0,read_count=0,epoch=0;
    reg saw_full=0,saw_empty=0;
    reg [31:0] wr_random=32'h12345678,rd_random=32'hf234a678;
    ddr2_p4b_async_fifo #(.WIDTH(32),.ADDR_BITS(5)) dut (
        .wr_clk(wr_clk),.wr_rst(rst),.wr_en(wr_en),.wr_data(wr_data),.full(full),
        .rd_clk(rd_clk),.rd_rst(rst),.rd_en(rd_en),.rd_data(rd_data),.empty(empty));
    function [31:0] word_value(input integer frame,input integer index);
        word_value=(32'h9e3779b9*index) ^ (32'h6d5a7b91*frame);
    endfunction
    always @(negedge wr_clk) begin
        wr_random={wr_random[30:0],wr_random[31]^wr_random[21]^wr_random[1]^wr_random[0]};
        wr_en=active && !rst && written<1024 && (wr_random[0] || wr_random[4]);
        wr_data=word_value(epoch,written);
    end
    always @(negedge rd_clk) begin
        rd_random={rd_random[30:0],rd_random[31]^rd_random[21]^rd_random[1]^rd_random[0]};
        rd_en=active && drain && !rst && (rd_random[2] || rd_random[7]);
    end
    always @(posedge wr_clk) begin
        if(rst) written=0;
        else begin
            if(full) saw_full=1;
            if(wr_en && !full) written=written+1;
        end
    end
    always @(posedge rd_clk) begin
        if(rst) read_count=0;
        else begin
            if(empty) saw_empty=1;
            if(rd_en && !empty) begin
                if(rd_data !== word_value(epoch,read_count))
                    $fatal(1,"FIFO perdeu/duplicou/trocou dado epoch=%0d index=%0d got=%h",epoch,read_count,rd_data);
                read_count=read_count+1;
            end
        end
    end
    task reset_fifo;
        @(negedge wr_clk); active=0;drain=0;rst=1;
        repeat(8) @(negedge wr_clk);
        rst=0;
        wait(!full);
    endtask
    initial begin
        reset_fifo();
        for(epoch=0;epoch<2;epoch=epoch+1) begin
            active=1;drain=0;
            wait(full);drain=1;
            wait(read_count==1024);
            if(written!=1024) $fatal(1,"Contagem final inconsistente");
            active=0;
            wait(empty);
            if(epoch==0) reset_fifo();
        end
        // Reset com dados pendentes deve eliminar a epoca anterior.
        epoch=2;reset_fifo();active=1;drain=0;
        wait(full);
        reset_fifo();epoch=3;active=1;drain=1;
        wait(read_count==1024);active=0;
        if(!saw_full || !saw_empty) $fatal(1,"Cobertura full/empty insuficiente");
        $display("XPM_FIFO_RANDOM_WRAP_RESET_PASS words=3072 epochs=3");
        $finish;
    end
    initial begin #2000000;$fatal(1,"Timeout de FIFO");end
endmodule
