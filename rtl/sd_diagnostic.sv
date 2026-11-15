// Referencia local de 512 bytes; nunca solicita escrita no cartao.
module sd_diagnostic #(
    parameter integer DEBOUNCE_CYCLES = 1_000_000,
    parameter REFERENCE_FILE = ""
)(
    input wire clk, rst, read_switch, ready, busy, failed,
    input wire data_valid, block_valid, read_error,
    input wire [2:0] read_error_code,
    input wire [7:0] data_byte,
    input wire [8:0] byte_index,
    output logic request = 0,
    output logic diagnostic_error = 0,
    output logic crc_ok = 0, data_ok = 0,
    output logic [9:0] byte_count = 0,
    output logic [8:0] first_mismatch = 0,
    output logic [7:0] expected_byte = 0, received_byte = 0,
    output logic [31:0] attempts = 0, timeout_count = 0,
    output logic [31:0] good_reads = 0, failed_reads = 0
);
    (* ASYNC_REG = "TRUE" *) logic read_meta = 0, read_sync = 0;
    localparam integer CW = DEBOUNCE_CYCLES < 2 ? 1 : $clog2(DEBOUNCE_CYCLES);
    localparam bit HAS_REFERENCE = REFERENCE_FILE != "";
    (* rom_style = "block" *) reg [7:0] reference_bytes [0:511];
    initial if (HAS_REFERENCE) $readmemh(REFERENCE_FILE, reference_bytes);
    logic [7:0] reference_byte, pending_byte;
    logic [8:0] pending_index;
    // Impede o retiming destes controles para a saida da ROM durante a sintese.
    (* DONT_TOUCH = "TRUE" *) logic [8:0] reference_index;
    logic [7:0] incoming_byte;
    (* DONT_TOUCH = "TRUE" *) logic reference_enable = 0;
    logic compare_valid = 0;
    logic [CW-1:0] count = 0;
    logic stable = 0, armed = 0, mismatch = 0, read_error_d = 0;

    // Isola os controles da BRAM dos resets assincronos do leitor SPI.
    always_ff @(posedge clk) begin
        reference_index <= byte_index;
        incoming_byte <= data_byte;
        reference_enable <= data_valid && HAS_REFERENCE && !rst;
        if (reference_enable) reference_byte <= reference_bytes[reference_index];
        pending_byte <= incoming_byte;
        pending_index <= reference_index;
        compare_valid <= reference_enable && !rst;
    end

    always_ff @(posedge clk) begin
        read_meta <= read_switch;
        read_sync <= read_meta;
        read_error_d <= read_error;
        request <= 0;
        if (rst) begin
            count <= 0; stable <= 0; armed <= 0;
            mismatch <= 0; diagnostic_error <= 0;
            crc_ok <= 0; data_ok <= 0; byte_count <= 0;
            first_mismatch <= 0; expected_byte <= 0; received_byte <= 0;
            attempts <= 0; timeout_count <= 0; read_error_d <= 0;
            good_reads <= 0; failed_reads <= 0;
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
                        mismatch <= 0; diagnostic_error <= 0;
                        crc_ok <= 0; data_ok <= 0; byte_count <= 0;
                        first_mismatch <= 0; expected_byte <= 0; received_byte <= 0;
                        attempts <= attempts + 1'b1;
                    end
                end
            end else count <= count + 1'b1;
            if (data_valid) begin
                byte_count <= byte_count + 1'b1;
                if (byte_count >= 512 || byte_index != byte_count[8:0]) mismatch <= 1;
            end
            if (compare_valid && pending_byte != reference_byte && !mismatch) begin
                mismatch <= 1;
                first_mismatch <= pending_index;
                expected_byte <= reference_byte;
                received_byte <= pending_byte;
            end
            // Bytes provisórios jamais aprovam conteudo ou CRC.
            if (block_valid && !read_error) begin
                crc_ok <= 1;
                diagnostic_error <= mismatch || byte_count != 512;
                data_ok <= HAS_REFERENCE && !mismatch && byte_count == 512;
                if (HAS_REFERENCE && !mismatch && byte_count == 512)
                    good_reads <= good_reads + 1'b1;
                if (mismatch || byte_count != 512) failed_reads <= failed_reads + 1'b1;
            end
            if (read_error && !read_error_d) begin
                failed_reads <= failed_reads + 1'b1;
                crc_ok <= 0; data_ok <= 0;
                if (read_error_code == 2 || read_error_code == 3)
                    timeout_count <= timeout_count + 1'b1;
            end
        end
    end
endmodule
