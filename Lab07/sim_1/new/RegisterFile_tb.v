`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 02:18:17 PM
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

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] writeData;
    reg writeEnable;
    reg rst;
    reg clk;

    wire [31:0] readData1;
    wire [31:0] readData2;
    
    RegisterFile uut (
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .writeData(writeData), 
        .writeEnable(writeEnable), 
        .readData1(readData1), 
        .readData2(readData2), 
        .rst(rst), 
        .clk(clk)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 1;
        writeEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        writeData = 0;

        #20;
        rst = 0;
        
        // Test x0 protection
        @(posedge clk);
        rd = 5'd0;
        writeData = 32'hDEADBEEF;
        writeEnable = 1;
        
        // Write to x1
        @(posedge clk);
        rd = 5'd1;
        writeData = 32'h10101010;
        
        // Write to x2
        @(posedge clk);
        rd = 5'd2;
        writeData = 32'h01010101;

        // Read checks
        @(posedge clk);
        writeEnable = 0; 
        rs1 = 5'd0;      
        rs2 = 5'd1;      
        
        @(posedge clk);
        rs1 = 5'd2;      
        rs2 = 5'd1;      

        #50;
        $finish;
    end

endmodule
