// CMD17 existente fornece bytes provisorios e confirma cada setor por CRC16.
// BPP=8: RGB332 (fmt=1). BPP=2: indexado 640x480 (fmt=2) com a paleta RGB332 do
// cabecalho (bytes 56..59) obrigatoriamente igual a PALETTE = {idx3,idx2,idx1,idx0}.
module sd_video_loader #(
    parameter integer WIDTH = 320, HEIGHT = 240, FPS = 10,
    parameter integer BPP = 8,
    parameter logic [31:0] PALETTE = 32'h100C0400,
    parameter logic [31:0] BASE_LBA = 0,
    parameter integer MAX_FILE_SECTORS = 0,
    parameter integer CLK_HZ = 100_000_000,
    parameter integer RETRY_CYCLES = CLK_HZ / 10,
    parameter integer ADDRESS_BITS = $clog2(WIDTH*HEIGHT*BPP/8),
    parameter bit MODE_SEQUENCE=1'b0,
    parameter integer GROUND_FRAMES=240,DEPARTURE_FRAMES=1260,CRUISE_FRAMES=1200,LANDING_FRAMES=900
)(
    input wire clk, rst, init_ready, init_failed,
    output wire request,
    input wire grant, read_busy, read_done, read_error,
    output wire [31:0] lba,
    input wire data_valid, block_valid,
    input wire [8:0] byte_index,
    input wire [7:0] data_byte,
    input wire buffer_ready,
    output reg frame_start = 0, frame_abort = 0, frame_commit = 0,
    output wire frame_write,
    output wire [ADDRESS_BITS-1:0] frame_address,
    output reg header_valid = 0, failed = 0,
    output reg [31:0] frames_loaded = 0, errors = 0, late_frames = 0,
    output reg [31:0] transfer_cycles = 0,
    output reg [3:0] state = 0,
    input wire [1:0] operation_mode,
    input wire frame_published, frame_publish_error,
    output logic [2:0] presentation_phase = 3'd0,
    // Indice do ultimo quadro efetivamente publicado pela VGA.
    // Nunca representa o quadro ainda em transferencia pelo SD/DDR2.
    output logic [31:0] presented_frame_index = 32'd0,
    output logic presented_frame_valid = 1'b0
);
    localparam integer FRAME_BYTES = WIDTH*HEIGHT*BPP/8;
    localparam logic [15:0] FORMAT = BPP == 2 ? 16'd2 : 16'd1;
    localparam integer SECTORS = (FRAME_BYTES+511)/512;
    localparam integer PERIOD = CLK_HZ/FPS;
    localparam [3:0] INIT=0, HEADER_REQ=1, HEADER_BUSY=2, HEADER_READ=3,
        CHECK=4, BUFFER=5, START=6, SECTOR_REQ=7, SECTOR_BUSY=8,
        SECTOR_READ=9, COMMIT=10, RETRY=11, STOP=12, WAIT_PUBLISH=13;
    localparam integer LAST_LANDING_FRAME = GROUND_FRAMES+DEPARTURE_FRAMES+CRUISE_FRAMES+LANDING_FRAMES-1;
    localparam logic [2:0] LANDING_PHASE = 3'd3, LANDED_PHASE = 3'd4;
    wire [31:0] presentation_index;
    wire [2:0] next_frame_phase;
    reg publication_seen=0,publication_error=0;
    wire advance_presentation=MODE_SEQUENCE && state==WAIT_PUBLISH &&
        (frame_published || publication_seen) && !(frame_publish_error || publication_error);
    generate if(MODE_SEQUENCE) begin : g_sequence
        video_mode_sequence #(.GROUND_FRAMES(GROUND_FRAMES),.DEPARTURE_FRAMES(DEPARTURE_FRAMES),
            .CRUISE_FRAMES(CRUISE_FRAMES),.LANDING_FRAMES(LANDING_FRAMES)) sequence_control(
            .clk(clk),.reset(rst),.advance(advance_presentation),.requested_mode(operation_mode),
            .frame_index(presentation_index),.phase(next_frame_phase),.landing_pending());
    end else begin : g_sequential
        assign presentation_index=0;
        assign next_frame_phase=0;
    end endgenerate
    always @(posedge clk) begin
        if (rst) begin
            presentation_phase <= 3'd0;
            presented_frame_index <= 32'd0;
            presented_frame_valid <= 1'b0;
        end else if (advance_presentation) begin
            // presentation_index ainda e o quadro recebido neste flanco.
            // O sequenciador avancara apenas apos esta confirmacao.
            presented_frame_index <= presentation_index;
            presented_frame_valid <= 1'b1;
            if (next_frame_phase == LANDING_PHASE && presentation_index == LAST_LANDING_FRAME)
                presentation_phase <= LANDED_PHASE;
            else
                presentation_phase <= next_frame_phase;
        end
    end
    always @(posedge clk) begin
        if(rst || frame_start) begin publication_seen<=0;publication_error<=0;end
        else begin
            if(frame_published) publication_seen<=1;
            if(frame_publish_error) publication_error<=1;
        end
    end
    reg [447:0] header = 0;
    reg reserved_bad = 0;
    reg [31:0] frame_count = 0, frame_number = 0, next_lba = 0;
    reg [31:0] sector_number = 0, bytes_seen = 0;
    reg sequence_error = 0;
    reg [1:0] retries = 0;
    reg [31:0] timer = 0, retry_timer = 0, load_cycles = 0;
    wire [31:0] offset = sector_number*512 + {23'd0,byte_index};
    wire reading_frame = state == SECTOR_READ;
    assign request = state == HEADER_REQ || state == SECTOR_REQ;
    assign lba = state == HEADER_REQ ? BASE_LBA : next_lba;
    assign frame_write = reading_frame && data_valid && offset < FRAME_BYTES;
    assign frame_address = offset[ADDRESS_BITS-1:0];
    // O limite vem do mapa FAT32 verificado no PC, nunca do cartao sozinho.
    wire header_ok = header[63:0] == 64'h0031444956445548 &&
        header[79:64] == 1 && header[95:80] == 512 &&
        header[111:96] == WIDTH && header[127:112] == HEIGHT &&
        header[143:128] == FPS && header[159:144] == FORMAT &&
        header[191:160] >= 2 && (!MODE_SEQUENCE ||
            header[191:160]==GROUND_FRAMES+DEPARTURE_FRAMES+CRUISE_FRAMES+LANDING_FRAMES) && header[223:192] == FRAME_BYTES &&
        header[255:224] == SECTORS*512 && header[319:288] == 1 &&
        header[447:320] != 0 && !reserved_bad &&
        header[191:160] == (MAX_FILE_SECTORS-1)/SECTORS &&
        (MAX_FILE_SECTORS-1)%SECTORS == 0 &&
        64'(header[287:256]) == 64'(MAX_FILE_SECTORS)*512 &&
        64'(BASE_LBA)+MAX_FILE_SECTORS <= 64'h100000000;
    initial if (FRAME_BYTES < 512 || FPS < 1 || FPS > 60 || !(BPP == 8 || BPP == 2))
        $error("Perfil de video invalido");
    always @(posedge clk) begin
        frame_start <= 0; frame_abort <= 0; frame_commit <= 0;
        if (rst) begin
            state <= INIT; header <= 0; reserved_bad <= 0; header_valid <= 0; failed <= 0;
            frame_number <= 0; frame_count <= 0; sector_number <= 0;
            next_lba <= BASE_LBA+1; timer <= 0; retry_timer <= 0;
            bytes_seen <= 0; sequence_error <= 0;
            frames_loaded <= 0; errors <= 0; late_frames <= 0; retries <= 0;
            transfer_cycles <= 0; load_cycles <= 0;
        end else begin
            if (timer < PERIOD) timer <= timer + 1'b1;
            if (state >= START && state <= COMMIT) load_cycles <= load_cycles + 1'b1;
            case (state)
                INIT: if (init_failed) begin failed <= 1; state <= STOP; end
                      else if (init_ready && BASE_LBA != 0 && MAX_FILE_SECTORS > 1)
                          state <= HEADER_REQ;
                HEADER_REQ: if (grant) begin
                    header <= 0; reserved_bad <= 0; bytes_seen <= 0; sequence_error <= 0;
                    state <= HEADER_BUSY;
                end
                HEADER_BUSY: if (read_busy) state <= HEADER_READ;
                HEADER_READ, SECTOR_READ: begin
                    if (data_valid) begin
                        if (bytes_seen != {23'd0,byte_index} || bytes_seen >= 512)
                            sequence_error <= 1;
                        bytes_seen <= bytes_seen+1'b1;
                        if (state == HEADER_READ && byte_index < 56)
                            header <= {data_byte,header[447:8]};
                        // fmt=2: bytes 56..59 devem conter exatamente a paleta sintetizada.
                        if (state == HEADER_READ && byte_index >= 56 &&
                            data_byte != (BPP == 2 && byte_index < 60 ?
                                          PALETTE[{byte_index[1:0], 3'b000} +: 8] : 8'd0))
                            reserved_bad <= 1;
                    end
                    if (read_error) begin
                        frame_abort <= reading_frame;
                        failed <= 1; errors <= errors+1'b1;
                        retry_timer <= 0; state <= RETRY;
                    end else if (read_done) begin
                        if (!block_valid || sequence_error || bytes_seen != 512 || data_valid) begin
                            frame_abort <= reading_frame;
                            failed <= 1; errors <= errors+1'b1;
                            retry_timer <= 0; state <= RETRY;
                        end else if (state == HEADER_READ) state <= CHECK;
                        else if (sector_number == SECTORS-1) state <= COMMIT;
                        else begin
                            sector_number <= sector_number+1'b1;
                            next_lba <= next_lba+1'b1;
                            state <= SECTOR_REQ;
                        end
                    end
                end
                CHECK: if (header_ok) begin
                    header_valid <= 1; failed <= 0;
                    frame_count <= header[191:160]; state <= BUFFER;
                end else begin failed <= 1; errors <= errors+1'b1; state <= STOP; end
                BUFFER: if (buffer_ready && timer >= PERIOD) begin
                    frame_start <= 1; sector_number <= 0;
                    next_lba <= BASE_LBA+1+(MODE_SEQUENCE ? presentation_index : frame_number)*SECTORS;
                    load_cycles <= 0; timer <= 0; state <= START;
                end
                START: state <= SECTOR_REQ;
                SECTOR_REQ: if (grant) begin
                    bytes_seen <= 0; sequence_error <= 0; state <= SECTOR_BUSY;
                end
                SECTOR_BUSY: if (read_busy) state <= SECTOR_READ;
                COMMIT: begin
                    frame_commit <= 1; frames_loaded <= frames_loaded+1'b1;
                    transfer_cycles <= load_cycles;
                    if (load_cycles > PERIOD) late_frames <= late_frames+1'b1;
                    failed <= 0; retries <= 0;
                    if(MODE_SEQUENCE) state<=WAIT_PUBLISH;
                    else begin
                        frame_number <= frame_number == frame_count-1 ? 0 : frame_number+1'b1;
                        state <= BUFFER;
                    end
                end
                // A confirmacao vem do banco publicado na VGA, nao do SD/DDR2.
                // Um quadro por vez neste perfil evita trocar de modo com um loop pre-carregado.
                WAIT_PUBLISH: if(frame_publish_error || publication_error) begin
                    frame_abort<=1;failed<=1;errors<=errors+1'b1;retry_timer<=0;state<=RETRY;
                end else if(frame_published || publication_seen) state<=BUFFER;
                RETRY: if (retry_timer >= RETRY_CYCLES-1) begin
                    if (retries == 2) state <= STOP;
                    else begin
                        retries <= retries+1'b1;
                        if (header_valid) state <= BUFFER;
                        else state <= HEADER_REQ;
                    end
                end else retry_timer <= retry_timer+1'b1;
                default: state <= STOP;
            endcase
        end
    end
endmodule
