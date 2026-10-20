`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:37:26 AM
// Design Name: 
// Module Name: RegisterFile_tb
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

module RegisterFile_tb();
    reg clk, rst, WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, readData2;

    RegisterFile uut (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData), .ReadData1(ReadData1), .readData2(readData2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; WriteEnable = 0; rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;
        #10 rst = 0; // Check reset behavior

        // i. Write a value to a register and check on next clock[cite: 2]
        #10 WriteEnable = 1; rd = 5; WriteData = 32'hDEADBEEF;
        #10 WriteEnable = 0; rs1 = 5; rs2 = 5;
        
        // ii. Attempt to write to x0 and verify it remains zero[cite: 2]
        #10 WriteEnable = 1; rd = 0; WriteData = 32'hFFFFFFFF;
        #10 WriteEnable = 0; rs1 = 0;
        
        // iii. Simultaneous two read ports
        #10 WriteEnable = 1; rd = 6; WriteData = 32'h12345678;
        #10 WriteEnable = 0; rs1 = 5; rs2 = 6;
        
        // iv. Overwrite a register and verify old value is replaced[cite: 2]
        #10 WriteEnable = 1; rd = 5; WriteData = 32'hBEEFDEAD;
        #10 WriteEnable = 0; rs1 = 5;
        
        #20 $stop;
    end
endmodule