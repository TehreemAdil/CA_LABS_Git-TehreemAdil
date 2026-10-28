`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 01:20:10 PM
// Design Name: 
// Module Name: tb_alu_control
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

module tb_alu_control();
    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7; 
   
    wire [3:0] ALUControl;
    
    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    initial begin
        // Initialize inputs
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Load/Store ALUOp = 00
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000;
        #10;

        // BEQ (ALUOp = 01
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000;
        #10;

        // R-type ADD ALUOp = 10, funct3 = 000, funct7[5]=0
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000;
        #10;

        // R-type SUB ALUOp = 10, funct3 = 000, funct7[5]=1
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000;
        #10;

        // R-type AND (ALUOp = 10, funct3 = 111
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000;
        #10;

        // R-type OR ALUOp = 10, funct3 = 110
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000;
        #10;

        //  R-type XOR ALUOp = 10, funct3 = 100
        ALUOp = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000;
        #10;

        // R-type SLL ALUOp = 10, funct3 = 001
        ALUOp = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000;
        #10;

        // R-type SRL ALUOp = 10, funct3 = 101, funct7[5]=0
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000;
        
        #10;
        
        $stop;
    end

    initial begin
        $monitor("Time=%0t | ALUOp=%b | funct3=%b | funct7=%b | ALUControl=%b",
                 $time, ALUOp, funct3, funct7, ALUControl);
    end
endmodule