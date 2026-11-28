`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 07:58:10 PM
// Design Name: 
// Module Name: ProgramCounter
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

module ProgramCounter (
    input             clk,
    input             rst,
    input      [31:0] PCNext,
    output reg [31:0] PC = 32'd0
);
    always @(posedge clk) begin
        if (rst) PC <= 32'd0;
        else     PC <= PCNext;
    end
endmodule