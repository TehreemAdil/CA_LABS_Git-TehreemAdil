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

module RegisterFile_tb;
    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; WriteEnable = 0;
        rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;
        
        #10 rst = 0;

        // Test i: Write to x5
        #10 WriteEnable = 1; rd = 5; WriteData = 32'hFAAAAAAA;
        #10 WriteEnable = 0; rs1 = 5;
        #10;
        if (ReadData1 == 32'hFAAAAAAA) $display("ASSERTION PASSED: Write to x5 successful.");
        else $display("ASSERTION FAILED: Write to x5.");

        // Test ii: Write to x0
        #10 WriteEnable = 1; rd = 0; WriteData = 32'hFFFFFFFF;
        #10 WriteEnable = 0; rs2 = 0;
        #10;
        if (ReadData2 == 32'h00000000) $display("ASSERTION PASSED: x0 remains zero.");
        else $display("ASSERTION FAILED: x0 was overwritten.");

        // Test iii: Simultaneous reads
        #10 rs1 = 5; rs2 = 0;
        #10;
        if (ReadData1 == 32'hFAAAAAAA && ReadData2 == 32'h00000000) $display("ASSERTION PASSED: Simultaneous read successful.");
        else $display("ASSERTION FAILED: Simultaneous read.");

        // Test iv: Overwrite a register
        #10 WriteEnable = 1; rd = 5; WriteData = 32'hBAAAAAAA;
        #10 WriteEnable = 0; rs1 = 5;
        #10;
        if (ReadData1 == 32'hBAAAAAAA) $display("ASSERTION PASSED: Overwrite successful.");
        else $display("ASSERTION FAILED: Overwrite.");

        // Test v: Reset behavior
        #10 rst = 1;
        #10 rst = 0; rs1 = 5;
        #10;
        if (ReadData1 == 32'h00000000) $display("ASSERTION PASSED: Reset cleared registers.");
        else $display("ASSERTION FAILED: Reset behavior.");

        #20 $finish;
    end
endmodule