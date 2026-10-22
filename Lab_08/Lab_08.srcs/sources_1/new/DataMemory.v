`timescale 1ns / 1ps

module DataMemory (
    input         clk,
    input         memWrite,
    input         memRead,
    input  [8:0]  address,
    input  [31:0] writeData,
    output [31:0] readData
);
    reg [31:0] memory [0:511];

    always @(posedge clk) begin
        if (memWrite)
            memory[address] <= writeData;
    end

    assign readData = (memRead) ? memory[address] : 32'b0;
endmodule