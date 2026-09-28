module debouncer #(
    parameter DELAY_COUNTS = 21'd2_000_000 // 20 ms delay at 100 MHz
)(
    input wire clk,
    input wire pbin,
    output reg pbout
);

    reg [20:0] count;
    reg sync_0, sync_1;

    // Two-stage synchronizer to prevent metastability
    always @(posedge clk) begin
        sync_0 <= pbin;
        sync_1 <= sync_0;
    end

    // Counter filter to eliminate contact bouncing
    always @(posedge clk) begin
        if (sync_1 == pbout) begin
            count <= 21'd0;
        end else begin
            count <= count + 21'd1;
            if (count >= DELAY_COUNTS) begin
                pbout <= sync_1;
                count <= 21'd0;
            end
        end
    end

endmodule