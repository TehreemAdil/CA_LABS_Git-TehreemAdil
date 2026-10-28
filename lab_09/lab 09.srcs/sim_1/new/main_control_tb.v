`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 03:47:35 PM
// Design Name: 
// Module Name: top_control_tb
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

module top_control_tb();

    reg clk;
    reg rst;
    reg [15:0] switches;

    wire [15:0] leds;

    top_control uut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .leds(leds)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        switches = 16'b0;
        #10;
        
        rst = 0;
        #10;

        // Main Control (SW[15] = 0)
        // R-type (Opcode: 0110011) 
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0110011};
        #10;

        // ADDI (Opcode: 0010011)
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0010011};
        #10;

        // Load (Opcode: 0000011, Funct3: 010) 
        switches = {1'b0, 4'b0, 1'b0, 3'b010, 7'b0000011};
        #10;

        // Store (Opcode: 0100011, Funct3: 010) 
        switches = {1'b0, 4'b0, 1'b0, 3'b010, 7'b0100011};
        #10;

        // Branch BEQ (Opcode: 1100011)
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b1100011};
        #10;

        // ALU Control (SW[15] = 1)
        // ALU ADD (Mode 1, Opcode: 0110011, Funct3: 000, Funct7[5]: 0)
        switches = {1'b1, 4'b0, 1'b0, 3'b000, 7'b0110011};
        #10;

        // ALU SUB ( Opcode: 0110011, Funct3: 000, Funct7[5]: 1)
        switches = {1'b1, 4'b0, 1'b1, 3'b000, 7'b0110011};
        #10;

        // ALU SLL (Opcode: 0110011, Funct3: 001)
        switches = {1'b1, 4'b0, 1'b0, 3'b001, 7'b0110011};
        #10;

        // ALU XOR (Opcode: 0110011, Funct3: 100)
        switches = {1'b1, 4'b0, 1'b0, 3'b100, 7'b0110011};
        #10;

        // ALU SRL (Opcode: 0110011, Funct3: 101)
        switches = {1'b1, 4'b0, 1'b0, 3'b101, 7'b0110011};
        #10;

        // ALU OR (Opcode: 0110011, Funct3: 110)
        switches = {1'b1, 4'b0, 1'b0, 3'b110, 7'b0110011};
        #10;

        // ALU AND (Opcode: 0110011, Funct3: 111)
        switches = {1'b1, 4'b0, 1'b0, 3'b111, 7'b0110011};
        #10;

        $stop;
    end

    initial begin
        $monitor("Time=%0t | Switches(Hex)=%h | LEDs(Bin)=%b",
                 $time, switches, leds);
    end

endmodule