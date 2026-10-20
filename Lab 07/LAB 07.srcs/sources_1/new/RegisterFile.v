`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:36:25 AM
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile(
    input clk,
    input rst,
    input WriteEnable,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] readData2
);
    // Use an array of registers
    reg [31:0] regs [31:0];
    integer i;

    // Asynchronous read with x0 hardwired to 0[cite: 1, 2]
    assign ReadData1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign readData2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];

    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (WriteEnable && rd != 5'b0) begin
            // Writes to x0 are ignored
            regs[rd] <= WriteData;
        end
    end
endmodule