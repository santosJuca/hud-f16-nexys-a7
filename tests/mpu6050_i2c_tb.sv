`timescale 1ns/1ps
module mpu6050_i2c_tb;
    reg clk = 0;
    always #5 clk = ~clk;
    tri1 sda, scl;
    reg slave_sda_low = 0;
    reg slave_scl_low = 0;
    assign sda = slave_sda_low ? 1'b0 : 1'bz;
    assign scl = slave_scl_low ? 1'b0 : 1'bz;
    wire [7:0] who_am_i;
    wire sensor_ok;
    wire amostra_nova;
    wire signed [15:0] ax, ay, az, gx, gy, gz;
    mpu6050_i2c dut (
        .clk(clk), .i2c_sda(sda), .i2c_scl(scl),
        .who_am_i(who_am_i), .sensor_ok(sensor_ok),
        .amostra_nova(amostra_nova),
        .accel_x(ax), .accel_y(ay), .accel_z(az),
        .gyro_x(gx), .gyro_y(gy), .gyro_z(gz)
    );

    reg present = 0;
    reg [7:0] identity = 8'h68;
    reg nack_wake = 0;
    reg nack_gyro_config = 1;
    reg nack_accel_config = 1;
    reg nack_filter_config = 1;
    reg nack_accel_filter = 1;
    reg gyro_configurado = 0;
    reg accel_configurado = 0;
    reg filtro_configurado = 0;
    reg accel_filtrado = 0;
    integer tentativas_gyro = 0;
    integer tentativas_accel = 0;
    integer tentativas_filtro = 0;
    integer tentativas_filtro_accel = 0;
    reg nack_register = 0;
    reg nack_read_address = 0;
    reg stretch = 0;
    reg awake = 0;
    reg [7:0] registers [0:255];
    reg [7:0] addr, pointer, value;
    reg master_ack;
    integer i;
    integer starts = 0;
    integer bursts = 0;
    integer wakes = 0;
    integer identities = 0;
    integer marker;
    integer pulsos_amostra = 0;
    integer pulsos_antes = 0;
    reg amostra_nova_anterior = 0;
    time wake_time;
    time filter_time;

    // Conta cada pulso pela borda real de subida.
    always @(posedge amostra_nova)
        pulsos_amostra = pulsos_amostra + 1;

    // amostra_nova nao pode permanecer alto por mais de um clock.
    always @(posedge clk) begin
        if (amostra_nova && amostra_nova_anterior)
            $fatal(1, "amostra_nova permaneceu alta por mais de um clock");

        amostra_nova_anterior <= amostra_nova;
    end

    time scl_rise = 0;
    time scl_fall = 0;
    time start_time = 0;
    always @(negedge sda) begin
        if (scl === 1'b1) begin
            if (scl_rise != 0 && $time - scl_rise < 4700)
                $fatal(1, "Setup de START=%0t esperado>=4700 ns", $time - scl_rise);
            start_time = $time;
        end
    end
    always @(posedge scl) begin
        if (scl_fall != 0 && $time - scl_fall < 4700)
            $fatal(1, "SCL baixo=%0t esperado>=4700 ns", $time - scl_fall);
        scl_rise = $time;
    end
    always @(negedge scl) begin
        if (start_time != 0 && $time - start_time < 4000)
            $fatal(1, "Hold de START=%0t esperado>=4000 ns", $time - start_time);
        if (scl_rise != 0 && $time - scl_rise < 4000)
            $fatal(1, "SCL alto=%0t esperado>=4000 ns", $time - scl_rise);
        scl_fall = $time;
    end
    always @(posedge sda) begin
        if ($time != 0 && scl === 1'b1 && $time - scl_rise < 4000)
            $fatal(1, "Setup de STOP=%0t esperado>=4000 ns", $time - scl_rise);
    end

    task automatic receive_byte(output reg [7:0] data);
        integer bit_no;
        begin
            for (bit_no = 7; bit_no >= 0; bit_no = bit_no - 1) begin
                @(posedge scl);
                data[bit_no] = sda;
                @(negedge scl);
            end
        end
    endtask

    task automatic reply(input reg ack);
        begin
            #100 slave_sda_low = ack;
            @(posedge scl);
            @(negedge scl);
            #100 slave_sda_low = 0;
        end
    endtask

    task automatic send_byte(input reg [7:0] data, output reg ack);
        integer bit_no;
        begin
            for (bit_no = 7; bit_no >= 0; bit_no = bit_no - 1) begin
                #100 slave_sda_low = ~data[bit_no];
                // Alongamento de SCL no meio de cada byte recebido pela FPGA.
                if (stretch && bit_no == 3) begin
                    slave_scl_low = 1;
                    #17000 slave_scl_low = 0;
                end
                @(posedge scl);
                @(negedge scl);
            end
            #100 slave_sda_low = 0;
            @(posedge scl);
            ack = !sda;
            @(negedge scl);
        end
    endtask

    // Modelo do escravo dirigido somente pelos pinos, sem acessar a FSM.
    initial forever begin : sensor_transaction
        @(negedge sda);
        if (scl === 1'b1) begin
            starts = starts + 1;
            receive_byte(addr);
            if (!present) begin
                reply(0);
            end else begin
                if (addr[7:1] !== 7'h68)
                    $fatal(1, "Endereco obtido=%h esperado=68", addr[7:1]);
                if (!addr[0]) begin
                    reply(1);
                    receive_byte(pointer);
                    if (pointer != 8'h75 && pointer != 8'h6B && pointer != 8'h3B &&
                        pointer != 8'h1B && pointer != 8'h1C && pointer != 8'h1A && pointer != 8'h1D)
                        $fatal(1, "Registrador inesperado=%h", pointer);
                    reply(!nack_register);
                    if (!nack_register && pointer == 8'h6B) begin
                        receive_byte(value);
                        if (value !== 8'h00)
                            $fatal(1, "PWR_MGMT_1 obtido=%h esperado=00", value);
                        reply(!nack_wake);
                        if (!nack_wake) begin
                            awake = 1;
                            gyro_configurado = 0;
                            accel_configurado = 0;
                            filtro_configurado = 0;
                            accel_filtrado = 0;
                            wakes = wakes + 1;
                            wake_time = $time;
                        end
                    end else if (!nack_register && (pointer == 8'h1B || pointer == 8'h1C)) begin
                        receive_byte(value);
                        if (value !== 8'h00)
                            $fatal(1, "Config reg=%h obtido=%h esperado=00", pointer, value);
                        if (!awake)
                            $fatal(1, "Configuracao antes de wake");
                        if (pointer == 8'h1B) begin
                            tentativas_gyro = tentativas_gyro + 1;
                            reply(!nack_gyro_config);
                            if (!nack_gyro_config) gyro_configurado = 1;
                        end else begin
                            if (!gyro_configurado)
                                $fatal(1, "Accel configurado antes do gyro");
                            tentativas_accel = tentativas_accel + 1;
                            reply(!nack_accel_config);
                            if (!nack_accel_config) accel_configurado = 1;
                        end
                    end else if (!nack_register && (pointer == 8'h1A || pointer == 8'h1D)) begin
                        receive_byte(value);
                        if(value !== 8'h05 || !accel_configurado || !gyro_configurado)
                            $fatal(1,"Filtro fora da ordem/faixa: reg=%h valor=%h",pointer,value);
                        if(pointer == 8'h1A) begin
                            tentativas_filtro = tentativas_filtro + 1;
                            reply(!nack_filter_config);
                            if(!nack_filter_config) begin filtro_configurado=1;filter_time=$time;end
                        end else begin
                            if(identity != 8'h70 || !filtro_configurado)
                                $fatal(1,"ACCEL_CONFIG2 escrito no modelo errado ou antes de CONFIG");
                            tentativas_filtro_accel = tentativas_filtro_accel + 1;
                            reply(!nack_accel_filter);
                            if(!nack_accel_filter) begin accel_filtrado=1;filter_time=$time;end
                        end
                    end
                end else begin
                    reply(!nack_read_address);
                    if (!nack_read_address) begin
                        if (pointer == 8'h75) begin
                            send_byte(identity, master_ack);
                            if (master_ack !== 0)
                                $fatal(1, "WHO_AM_I: resposta obtida=ACK esperada=NACK");
                            identities = identities + 1;
                        end else if (pointer == 8'h3B) begin
                            if (!awake || $time - wake_time < 100000000)
                                $fatal(1, "Leitura antes da inicializacao ou espera de 100 ms");
                            if (!gyro_configurado || !accel_configurado)
                                $fatal(1, "Leitura antes da configuracao das faixas");
                            if(!filtro_configurado || (identity==8'h70 && !accel_filtrado) ||
                               $time-filter_time < 100000000)
                                $fatal(1,"Leitura antes da configuracao/assentamento dos filtros");
                            for (i = 0; i < 14; i = i + 1) begin
                                send_byte(registers[8'h3B+i], master_ack);
                                if (master_ack !== (i < 13))
                                    $fatal(1, "Byte=%0d ACK obtido=%b esperado=%b", i, master_ack, (i < 13));
                            end
                            bursts = bursts + 1;
                        end else
                            $fatal(1, "Leitura inesperada em %h", pointer);
                    end
                end
            end
        end
    end

    task automatic check_axes(
        input signed [15:0] ex_ax, ex_ay, ex_az, ex_gx, ex_gy, ex_gz
    );
        begin
            if (ax !== ex_ax || ay !== ex_ay || az !== ex_az ||
                gx !== ex_gx || gy !== ex_gy || gz !== ex_gz)
                $fatal(1, "Eixos obtidos=%0d,%0d,%0d,%0d,%0d,%0d esperados=%0d,%0d,%0d,%0d,%0d,%0d",
                    ax, ay, az, gx, gy, gz, ex_ax, ex_ay, ex_az, ex_gx, ex_gy, ex_gz);
        end
    endtask

    initial begin
        {registers['h3B], registers['h3C]} = 16'h1234;
        {registers['h3D], registers['h3E]} = 16'hFEDC;
        {registers['h3F], registers['h40]} = 16'h8000;
        {registers['h41], registers['h42]} = 16'hA55A; // Temperatura descartada.
        {registers['h43], registers['h44]} = 16'h7FFF;
        {registers['h45], registers['h46]} = 16'hFFFF;
        {registers['h47], registers['h48]} = 16'h0102;

        #125000000;
        if (sensor_ok !== 0 || starts < 2)
            $fatal(1, "Sensor ausente: status=%b tentativas=%0d", sensor_ok, starts);
        check_axes(0, 0, 0, 0, 0, 0);
        $display("PASS sensor ausente: sensor_ok=0, novas tentativas");

        identity = 8'h69;
        present = 1;
        wait (who_am_i == 8'h69);
        #100000;
        if (sensor_ok !== 0 || wakes != 0)
            $fatal(1, "ID incorreto: status=%b inicializacoes=%0d", sensor_ok, wakes);
        $display("PASS WHO_AM_I=69: sensor_ok=0, sem inicializacao");

        identity = 8'h68;
        nack_wake = 1;
        #35000000;
        if (sensor_ok !== 0 || wakes != 0)
            $fatal(1, "NACK em PWR_MGMT_1: status=%b inicializacoes=%0d", sensor_ok, wakes);
        $display("PASS NACK em PWR_MGMT_1: sensor_ok=0");

        nack_wake = 0;
        wait (tentativas_gyro >= 1);
        #1000000;
        if (sensor_ok !== 0 || pulsos_amostra != 0 || tentativas_accel != 0)
            $fatal(1, "NACK gyro: status=%b pulsos=%0d accel=%0d esperado=0/0/0",
                sensor_ok, pulsos_amostra, tentativas_accel);
        $display("PASS NACK GYRO_CONFIG: nao publica dados nem avanca configuracao");
        nack_gyro_config = 0;
        wait (tentativas_accel >= 1);
        #1000000;
        if (sensor_ok !== 0 || pulsos_amostra != 0)
            $fatal(1, "NACK accel: status=%b pulsos=%0d esperado=0/0", sensor_ok, pulsos_amostra);
        $display("PASS NACK ACCEL_CONFIG: nao publica dados");
        nack_accel_config = 0;
        wait(tentativas_filtro >= 1);
        #1000000;
        if(sensor_ok || pulsos_amostra || tentativas_filtro_accel)
            $fatal(1,"NACK CONFIG aceitou dados ou escreveu ACCEL_CONFIG2 no ID 68");
        $display("PASS NACK CONFIG: nao publica dados; ID 68 nao escreve ACCEL_CONFIG2");
        nack_filter_config = 0;
        stretch = 1;
        wait (sensor_ok);
        check_axes(4660, -292, -32768, 32767, -1, 258);
        $display("PASS leitura com clock stretching: eixos=4660,-292,-32768,32767,-1,258");

        marker = bursts;
        pulsos_antes = pulsos_amostra;

        {registers['h3B], registers['h3C]} = 16'hFFFF;
        {registers['h47], registers['h48]} = 16'h8000;

        wait (bursts > marker);

        // O driver só publica os eixos após STOP.
        check_axes(4660, -292, -32768, 32767, -1, 258);

        #50000;

        check_axes(-1, -292, -32768, 32767, -1, -32768);

        if (pulsos_amostra != (pulsos_antes + 1))
            $fatal(
                1,
                "amostra_nova: pulsos=%0d esperado=%0d",
                pulsos_amostra,
                pulsos_antes + 1
            );

        $display("PASS amostra_nova: pulso unico por conjunto completo");
        $display("PASS segunda amostra: eixos publicados juntos apos STOP");

        // -------------------------------------------------
        // SDA presa durante o STOP.
        //
        // Nenhuma nova amostra pode ser publicada antes de
        // SDA realmente subir enquanto SCL permanece alto.
        // -------------------------------------------------

        marker = bursts;
        pulsos_antes = pulsos_amostra;

        // Valores diferentes da ultima amostra publicada.
        {registers['h3B], registers['h3C]} = 16'h1111;
        {registers['h3D], registers['h3E]} = 16'h2222;
        {registers['h3F], registers['h40]} = 16'h3333;
        {registers['h41], registers['h42]} = 16'h4444;
        {registers['h43], registers['h44]} = 16'h5555;
        {registers['h45], registers['h46]} = 16'h6666;
        {registers['h47], registers['h48]} = 16'h7777;

        // O modelo terminou de enviar o ultimo byte.
        // Prende SDA antes de o mestre concluir o STOP.
        wait (bursts > marker);
        slave_sda_low = 1'b1;

        // Maior que o timeout de 10 ms do driver.
        #12000000;

        if (sensor_ok !== 1'b0)
            $fatal(
                1,
                "SDA presa no STOP: sensor_ok=%b esperado=0",
                sensor_ok
            );

        if (pulsos_amostra != pulsos_antes)
            $fatal(
                1,
                "SDA presa no STOP publicou amostra: pulsos=%0d esperado=%0d",
                pulsos_amostra,
                pulsos_antes
            );

        // A ultima amostra valida deve permanecer intacta.
        check_axes(-1, -292, -32768, 32767, -1, -32768);

        $display(
            "PASS SDA presa no STOP: sem publicacao e eixos preservados"
        );

        // Libera o barramento. O driver deve refazer a
        // identificacao/configuracao e voltar a publicar.
        slave_sda_low = 1'b0;

        wait (sensor_ok);

        check_axes(
            16'sh1111,
            16'sh2222,
            16'sh3333,
            16'sh5555,
            16'sh6666,
            16'sh7777
        );

        if (pulsos_amostra != (pulsos_antes + 1))
            $fatal(
                1,
                "Recuperacao do STOP: pulsos=%0d esperado=%0d",
                pulsos_amostra,
                pulsos_antes + 1
            );

        $display(
            "PASS recuperacao apos SDA presa no STOP"
        );

        nack_register = 1;
        wait (!sensor_ok);
        check_axes(
            16'sh1111,
            16'sh2222,
            16'sh3333,
            16'sh5555,
            16'sh6666,
            16'sh7777
        );
        #1000000;
        nack_register = 0;
        wait (sensor_ok);
        $display("PASS NACK de registrador: invalida status, preserva eixos e recupera");

        nack_read_address = 1;
        wait (!sensor_ok);
        #1000000;
        nack_read_address = 0;
        wait (sensor_ok);
        $display("PASS NACK de endereco de leitura: recupera");

        // Prende SCL entre transações: o timeout deve invalidar a amostra.
        @(negedge scl);
        slave_scl_low = 1;
        #12000000;
        if (sensor_ok !== 0)
            $fatal(1, "SCL preso: status obtido=%b esperado=0", sensor_ok);
        disable sensor_transaction;
        slave_sda_low = 0;
        slave_scl_low = 0;
        $display("PASS SCL preso: sensor_ok=0 apos timeout");
        wait (sensor_ok);
        check_axes(
            16'sh1111,
            16'sh2222,
            16'sh3333,
            16'sh5555,
            16'sh6666,
            16'sh7777
        );
        $display("PASS recuperacao apos liberar SCL");

        // Forca nova identificacao e valida o ID 0x70 observado no hardware.
        nack_register = 1;
        wait (!sensor_ok);
        identity = 8'h70;
        nack_register = 0;
        wait (who_am_i == 8'h70);
        pulsos_antes = pulsos_amostra;
        wait(tentativas_filtro_accel >= 1);
        #1000000;
        if(sensor_ok || pulsos_amostra!=pulsos_antes)
            $fatal(1,"NACK ACCEL_CONFIG2 aceitou dados no ID 70");
        $display("PASS NACK ACCEL_CONFIG2: sensor invalido ate configurar filtro do ID 70");
        nack_accel_filter = 0;
        wait (sensor_ok);
        if(!filtro_configurado || !accel_filtrado) $fatal(1,"Filtros do ID 70 ausentes");
        $display("PASS WHO_AM_I=70: identificacao, wake, filtros separados e leitura de dados");

        $display("PASS todos os testes");
        $finish;
    end

    initial begin
        #4000000000;
        $fatal(1, "Timeout global da simulacao");
    end
endmodule
