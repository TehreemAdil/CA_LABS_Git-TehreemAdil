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
// Description: Foolproof testbench with immediate initialization to prevent X states
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_control_tb();

    reg clk = 0;
    reg rst = 0;
    reg [15:0] switches = 16'h0033; // Starts immediately as R-type to avoid X states

    wire [15:0] leds;

    top_control uut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .leds(leds)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // ==========================================
        // 1. MAIN CONTROL TESTS (SW[15] = 0)
        // ==========================================
        
        // R-type (Opcode: 0110011)
        switches = 16'h0033;
        #10;

        // ADDI (Opcode: 0010011) 
        switches = 16'h0013;
        #10;

        // Load LW (Opcode: 0000011, Funct3: 010) 
        switches = 16'h0103;
        #10;

        // Store SW (Opcode: 0100011, Funct3: 010)
        switches = 16'h0123;
        #10;

        // Branch BEQ (Opcode: 1100011) 
        switches = 16'h0063;
        #10;

        // ==========================================
        // 2. ALU CONTROL TESTS (SW[15] = 1, Bit 15 set)
        // ==========================================

        // ALU ADD (Mode 1, Opcode: 0110011, Funct3: 000, Funct7[5]: 0)
        switches = 16'h8033;
        #10;

        // ALU SUB (Mode 1, Opcode: 0110011, Funct3: 000, Funct7[5]: 1)
        switches = 16'h8433;
        #10;

        // ALU SLL (Mode 1, Opcode: 0110011, Funct3: 001)
        switches = 16'h80b3;
        #10;

        // ALU XOR (Mode 1, Opcode: 0110011, Funct3: 100)
        switches = 16'h8233;
        #10;

        // ALU SRL (Mode 1, Opcode: 0110011, Funct3: 101)
        switches = 16'h82b3;
        #10;

        // ALU OR (Mode 1, Opcode: 0110011, Funct3: 110)
        switches = 16'h8333;
        #10;

        // ALU AND (Mode 1, Opcode: 0110011, Funct3: 111)
        switches = 16'h83b3;
        #10;

        $stop;
    end

    initial begin
        $monitor("Time=%0t | Switches(Hex)=%h | LEDs(Bin)=%b",
                 $time, switches, leds);
    end

endmodule