module switches (
    input wire clk,
    input wire rst,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    input wire [29:0] memAddress,
    input wire [15:0] switches,
    output reg [31:0] readData
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            readData <= 32'd0;
        end else if (readEnable) begin
            // Zero-extend 16-bit switch array to 32-bit internal data bus
            readData <= {16'd0, switches};
        end
    end

endmodule