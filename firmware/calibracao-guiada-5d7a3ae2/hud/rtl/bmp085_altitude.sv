module bmp085_altitude (
    input  logic        clk,
    input  logic [31:0] pressao_pa,
    input  logic        pressao_valid,

    output logic [16:0] altitude_ft = 17'd0,
    output logic        calculo_ok  = 1'b0
);

    typedef enum logic [1:0] {
        ST_IDLE,
        ST_DECODE,
        ST_MULT,
        ST_DIV
    } state_t;

    state_t state = ST_IDLE;

    logic        last_valid = 1'b0;
    logic [31:0] last_pressao = 32'd0;
    logic [31:0] pressao_trabalho = 32'd0;

    logic [16:0] base_alt_reg = 17'd0;
    logic [12:0] delta_p_reg = 13'd0;
    logic [11:0] delta_alt_reg = 12'd0;
    logic [12:0] divisor_reg = 13'd1;

    logic [24:0] dividend_reg = 25'd0;
    logic [24:0] quotient_reg = 25'd0;
    logic [13:0] remainder_reg = 14'd0;
    logic [4:0]  bit_count = 5'd0;

    wire [13:0] remainder_shift;
    wire        quotient_bit;
    wire [13:0] remainder_next;
    wire [24:0] quotient_next;

    assign remainder_shift =
        {remainder_reg[12:0], dividend_reg[24]};

    assign quotient_bit =
        (remainder_shift >= {1'b0, divisor_reg});

    assign remainder_next =
        quotient_bit
        ? (remainder_shift - {1'b0, divisor_reg})
        : remainder_shift;

    assign quotient_next =
        {quotient_reg[23:0], quotient_bit};

    always_ff @(posedge clk) begin

        calculo_ok <= 1'b0;

        case (state)

            ST_IDLE: begin

                if (!pressao_valid) begin
                    last_valid <= 1'b0;
                    altitude_ft <= 17'd0;
                end
                else if (
                    !last_valid ||
                    (pressao_pa != last_pressao)
                ) begin

                    last_valid   <= 1'b1;
                    last_pressao <= pressao_pa;

                    if (
                        (pressao_pa < 32'd30000) ||
                        (pressao_pa > 32'd120000)
                    ) begin
                        altitude_ft <= 17'd0;
                    end
                    else if (pressao_pa >= 32'd101325) begin
                        altitude_ft <= 17'd0;
                        calculo_ok  <= 1'b1;
                    end
                    else begin
                        pressao_trabalho <= pressao_pa;
                        state <= ST_DECODE;
                    end
                end
            end

            ST_DECODE: begin

                if (pressao_trabalho >= 32'd100000) begin
                    base_alt_reg  <= 17'd0;
                    delta_p_reg   <= 32'd101325 - pressao_trabalho;
                    delta_alt_reg <= 12'd364;
                    divisor_reg   <= 13'd1325;
                end
                else if (pressao_trabalho >= 32'd95000) begin
                    base_alt_reg  <= 17'd364;
                    delta_p_reg   <= 32'd100000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1409;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd90000) begin
                    base_alt_reg  <= 17'd1773;
                    delta_p_reg   <= 32'd95000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1471;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd85000) begin
                    base_alt_reg  <= 17'd3244;
                    delta_p_reg   <= 32'd90000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1538;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd80000) begin
                    base_alt_reg  <= 17'd4782;
                    delta_p_reg   <= 32'd85000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1613;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd75000) begin
                    base_alt_reg  <= 17'd6395;
                    delta_p_reg   <= 32'd80000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1697;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd70000) begin
                    base_alt_reg  <= 17'd8092;
                    delta_p_reg   <= 32'd75000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1792;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd65000) begin
                    base_alt_reg  <= 17'd9884;
                    delta_p_reg   <= 32'd70000 - pressao_trabalho;
                    delta_alt_reg <= 12'd1898;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd60000) begin
                    base_alt_reg  <= 17'd11782;
                    delta_p_reg   <= 32'd65000 - pressao_trabalho;
                    delta_alt_reg <= 12'd2021;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd55000) begin
                    base_alt_reg  <= 17'd13803;
                    delta_p_reg   <= 32'd60000 - pressao_trabalho;
                    delta_alt_reg <= 12'd2161;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd50000) begin
                    base_alt_reg  <= 17'd15964;
                    delta_p_reg   <= 32'd55000 - pressao_trabalho;
                    delta_alt_reg <= 12'd2327;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd45000) begin
                    base_alt_reg  <= 17'd18291;
                    delta_p_reg   <= 32'd50000 - pressao_trabalho;
                    delta_alt_reg <= 12'd2524;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd40000) begin
                    base_alt_reg  <= 17'd20815;
                    delta_p_reg   <= 32'd45000 - pressao_trabalho;
                    delta_alt_reg <= 12'd2762;
                    divisor_reg   <= 13'd5000;
                end
                else if (pressao_trabalho >= 32'd35000) begin
                    base_alt_reg  <= 17'd23577;
                    delta_p_reg   <= 32'd40000 - pressao_trabalho;
                    delta_alt_reg <= 12'd3058;
                    divisor_reg   <= 13'd5000;
                end
                else begin
                    base_alt_reg  <= 17'd26635;
                    delta_p_reg   <= 32'd35000 - pressao_trabalho;
                    delta_alt_reg <= 12'd3434;
                    divisor_reg   <= 13'd5000;
                end

                state <= ST_MULT;
            end

            ST_MULT: begin
                dividend_reg  <= delta_p_reg * delta_alt_reg;
                quotient_reg  <= 25'd0;
                remainder_reg <= 14'd0;
                bit_count     <= 5'd0;
                state         <= ST_DIV;
            end

            ST_DIV: begin

                remainder_reg <= remainder_next;
                dividend_reg  <= {dividend_reg[23:0], 1'b0};
                quotient_reg  <= quotient_next;

                if (bit_count == 5'd24) begin
                    altitude_ft <=
                        base_alt_reg + quotient_next[16:0];

                    calculo_ok <= 1'b1;
                    state      <= ST_IDLE;
                end
                else begin
                    bit_count <= bit_count + 5'd1;
                end
            end

            default: begin
                state <= ST_IDLE;
            end

        endcase
    end

endmodule
