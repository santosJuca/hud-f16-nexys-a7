// Barramento XADC(100MHz) -> UI MIG(~81.25MHz), handshake por toggle.
// Origem so modifica source_data quando o ACK sincronizado confirma a captura.
// O dado permanece estavel durante toda a travessia do sinal de solicitacao.
module xadc_temperature_cdc (
    input  wire        dst_clk,
    input  wire        dst_reset,
    input  wire [11:0] source_data,
    input  wire        source_toggle,
    output reg         destination_ack = 1'b0,
    output reg  [11:0] destination_data = 12'd0,
    output reg         destination_valid = 1'b0
);
    (* ASYNC_REG = "TRUE" *) reg request_meta = 1'b0;
    (* ASYNC_REG = "TRUE" *) reg request_sync = 1'b0;

    always @(posedge dst_clk) begin
        if (dst_reset) begin
            request_meta <= 1'b0;
            request_sync <= 1'b0;
            destination_ack <= 1'b0;
            destination_valid <= 1'b0;
            destination_data <= 12'd0;
        end else begin
            request_meta <= source_toggle;
            request_sync <= request_meta;
            if (request_sync != destination_ack) begin
                destination_data <= source_data;
                destination_valid <= 1'b1;
                destination_ack <= request_sync;
            end
        end
    end
endmodule
