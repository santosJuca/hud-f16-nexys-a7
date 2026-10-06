// Modelo de escravo: observa apenas SDA/SCL, sem acesso a FSM do master.
`ifndef HMC5883L_SLAVE_SVH
`define HMC5883L_SLAVE_SVH
module hmc5883l_slave(inout wire sda, scl);
    logic sda_low = 0, scl_low = 0;
    assign sda = sda_low ? 1'b0 : 1'bz;
    assign scl = scl_low ? 1'b0 : 1'bz;
    integer stops = 0, starts = 0;
    bit ativo = 0;
    always @(posedge sda) if (scl === 1'b1) begin stops = stops + 1; ativo = 0; end
    always @(negedge sda) if (scl === 1'b1) begin starts = starts + 1; ativo = 1; end

    task automatic start;
        begin : espera
            forever begin
                @(negedge sda);
                if (scl === 1'b1) disable espera;
            end
        end
    endtask

    task automatic receive(input logic [7:0] esperado);
        logic [7:0] valor;
        for (integer i=7; i>=0; i=i-1) begin
            @(posedge scl); #100; valor[i] = sda;
            @(negedge scl);
        end
        if (valor !== esperado)
            $fatal(1,"I2C recebido=%02h esperado=%02h",valor,esperado);
    endtask

    task automatic ack(input bit aceitar);
        #100; sda_low = aceitar;
        @(posedge scl); @(negedge scl);
        #100; sda_low = 0;
    endtask

    task automatic send(input logic [7:0] valor, input bit ultimo);
        for (integer i=7; i>=0; i=i-1) begin
            #100; sda_low = ~valor[i];
            @(posedge scl); @(negedge scl);
        end
        #100; sda_low = 0;
        @(posedge scl); #100;
        if (sda !== ultimo)
            $fatal(1,"I2C resposta ao byte %02h=%b esperado=%b",valor,sda,ultimo);
        @(negedge scl);
    endtask

    task automatic stop;
        begin : espera
            forever begin
                @(posedge sda);
                if (scl === 1'b1) disable espera;
            end
        end
        #100;
    endtask

    task automatic read_begin(input logic [7:0] reg_addr, input bit stretch);
        integer stops_antes;
        start(); stops_antes = stops;
        receive(8'h3c); ack(1);
        receive(reg_addr); ack(1);
        if (stretch) begin
            scl_low = 1;
            #20_000;
            if (sda !== 1'b1) $fatal(1,"SDA mudou durante stretching do repeated START");
            scl_low = 0;
        end
        start();
        if (stops != stops_antes) $fatal(1,"STOP indevido antes do repeated START");
        receive(8'h3d); ack(1);
    endtask

    task automatic identify(input logic [7:0] terceiro);
        read_begin(8'h0a,0);
        send(8'h48,0); send(8'h34,0); send(terceiro,1);
        stop();
    endtask

    task automatic write_reg(input logic [7:0] reg_addr, valor);
        start(); receive(8'h3c); ack(1);
        receive(reg_addr); ack(1);
        receive(valor); ack(1); stop();
    endtask

    task automatic configure;
        identify(8'h33);
        write_reg(8'h00,8'h70);
        write_reg(8'h01,8'h20);
        write_reg(8'h02,8'h00);
    endtask

    task automatic data_bytes(input logic [15:0] x,y,z);
        send(x[15:8],0); send(x[7:0],0);
        send(z[15:8],0); send(z[7:0],0);
        send(y[15:8],0); send(y[7:0],1);
    endtask

    task automatic sample(input logic [15:0] x,y,z, input bit stretch);
        read_begin(8'h03,stretch);
        data_bytes(x,y,z); stop();
    endtask
endmodule
`endif
