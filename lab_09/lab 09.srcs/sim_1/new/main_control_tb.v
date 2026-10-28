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

`timescale 1ns / 1ps

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
        #20;
        rst = 0;
        #20;

        // Main Control (SW[15] = 0)
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0110011}; #40; // R-type
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0010011}; #40; // ADDI
        switches = {1'b0, 4'b0, 1'b0, 3'b010, 7'b0000011}; #40; // LW
        switches = {1'b0, 4'b0, 1'b0, 3'b001, 7'b0000011}; #40; // LH
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0000011}; #40; // LB
        switches = {1'b0, 4'b0, 1'b0, 3'b010, 7'b0100011}; #40; // SW
        switches = {1'b0, 4'b0, 1'b0, 3'b001, 7'b0100011}; #40; // SH
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b0100011}; #40; // SB
        switches = {1'b0, 4'b0, 1'b0, 3'b000, 7'b1100011}; #40; // BEQ

        // ALU Control (SW[15] = 1)
        switches = {1'b1, 4'b0, 1'b0, 3'b000, 7'b0110011}; #40; // ADD
        switches = {1'b1, 4'b0, 1'b1, 3'b000, 7'b0110011}; #40; // SUB
        switches = {1'b1, 4'b0, 1'b0, 3'b001, 7'b0110011}; #40; // SLL
        switches = {1'b1, 4'b0, 1'b0, 3'b101, 7'b0110011}; #40; // SRL
        switches = {1'b1, 4'b0, 1'b0, 3'b100, 7'b0110011}; #40; // XOR
        switches = {1'b1, 4'b0, 1'b0, 3'b110, 7'b0110011}; #40; // OR
        switches = {1'b1, 4'b0, 1'b0, 3'b111, 7'b0110011}; #40; // AND
        switches = {1'b1, 4'b0, 1'b0, 3'b000, 7'b0010011}; #40; // ADDI
        switches = {1'b1, 4'b0, 1'b0, 3'b010, 7'b0000011}; #40; // LW
        switches = {1'b1, 4'b0, 1'b0, 3'b010, 7'b0100011}; #40; // SW
        switches = {1'b1, 4'b0, 1'b0, 3'b000, 7'b1100011}; #40; // BEQ

        $stop;
    end

    initial begin
        $monitor("Time=%0t | Switches(Hex)=%h | LEDs(Bin)=%b",
                 $time, switches, leds);
    end
endmodule