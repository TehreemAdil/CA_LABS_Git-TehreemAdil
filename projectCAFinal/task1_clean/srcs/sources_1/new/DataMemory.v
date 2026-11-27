`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 05:58:46 PM
// Design Name: 
// Module Name: DataMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DataMemory (
    input         clk,
    input         MemWrite,
    input         MemRead,
    input  [31:0] address,
    input  [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:127];
    integer i;

    initial begin
        for (i = 0; i < 128; i = i + 1) mem[i] = 32'd0;
    end

    wire [6:0] word_addr = address[8:2];
    assign read_data = MemRead ? mem[word_addr] : 32'd0;

    always @(posedge clk) begin
        if (MemWrite) mem[word_addr] <= write_data;
    end
endmodule