module leds (
    input wire clk,
    input wire rst,
    input wire [15:0] btns,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    input wire [29:0] memAddress,
    output reg [31:0] readData,
    output reg [15:0] leds
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            leds <= 16'd0;
            readData <= 32'd0;
        end else begin
            if (writeEnable) begin
                // Drive lower 16 bits of write data directly to hardware LEDs
                leds <= writeData[15:0];
            end
            if (readEnable) begin
                readData <= {16'd0, leds};
            end
        end
    end

endmodule