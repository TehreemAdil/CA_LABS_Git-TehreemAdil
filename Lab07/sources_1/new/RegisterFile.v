`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 12:54:17 PM
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
    rs1, rs2, rd, writeData, writeEnable, readData1, readData2, rst, clk
    );
    input [4:0] rs1;
    input [4:0] rs2;
    input writeEnable;
    input [4:0] rd;
    input rst;
    input clk;
    input [31:0] writeData;
    output [31:0] readData1;
    output [31:0] readData2;
    
    reg [31:0] Registers [31:0];
    integer i; 
    
    always @(posedge clk) begin
        if (rst) begin 
             for (i = 0; i < 32; i = i + 1) begin
                Registers[i] <= 32'h00000000;
            end
        end 
        else if (writeEnable && (rd != 5'b00000)) begin
                Registers[rd] <= writeData; 
        end
    end

    assign readData1 = (rs1 == 5'b00000) ? 32'h00000000 : Registers[rs1];
    assign readData2 = (rs2 == 5'b00000) ? 32'h00000000 : Registers[rs2];

endmodule
