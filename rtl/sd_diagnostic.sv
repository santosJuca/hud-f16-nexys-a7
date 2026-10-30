// Diagnostico somente leitura: LBA 2048, byte[i] = i[7:0] XOR A5.
module sd_diagnostic #(
    parameter integer DEBOUNCE_CYCLES = 1_000_000
)(
    input wire clk, rst, read_switch, ready, busy, failed,
    input wire data_valid, block_valid, read_error,
    input wire [7:0] data_byte,
    input wire [8:0] byte_index,
    output logic request = 0,
    output logic diagnostic_error = 0
);
    (* ASYNC_REG = "TRUE" *) logic read_meta = 0, read_sync = 0;
    localparam integer CW = DEBOUNCE_CYCLES < 2 ? 1 : $clog2(DEBOUNCE_CYCLES);
    logic [CW-1:0] count = 0;
    logic stable = 0, armed = 0, mismatch = 0;
    always_ff @(posedge clk) begin
        read_meta <= read_switch;
        read_sync <= read_meta;
        request <= 0;
        if (rst) begin
            count <= 0; stable <= 0; armed <= 0;
            mismatch <= 0; diagnostic_error <= 0;
        end else begin
            if (!ready || failed) armed <= 0;
            else if (!read_sync && !stable && !busy) armed <= 1;
            if (read_sync == stable) count <= 0;
            else if (count == DEBOUNCE_CYCLES-1) begin
                count <= 0;
                stable <= read_sync;
                if (read_sync) begin
                    armed <= 0;
                    if (armed && ready && !failed && !busy) begin
                        request <= 1;
                        mismatch <= 0;
                        diagnostic_error <= 0;
                    end
                end
            end else count <= count + 1'b1;
            // O comparador e provisório; somente block_valid publica o resultado.
            if (data_valid && data_byte != (byte_index[7:0] ^ 8'hA5)) mismatch <= 1;
            if (block_valid && !read_error) diagnostic_error <= mismatch;
        end
    end
endmodule
