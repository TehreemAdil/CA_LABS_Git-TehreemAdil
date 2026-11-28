`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 08:36:27 PM
// Design Name: 
// Module Name: task2a_tb
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

module Task2a_tb;
    reg         clk100;
    reg         btnReset;
    reg  [15:0] sw;
    wire [15:0] led;

    FPGATop #(.PROGRAM_FILE("task2a_sum.mem")) uut (
        .clk100  (clk100),
        .btnReset(btnReset),
        .sw      (sw),
        .led     (led)
    );

    always #5 clk100 = ~clk100;

    initial begin
        clk100   = 1'b0;
        btnReset = 1'b1;
        sw       = 16'h0000;

        #2000;
        btnReset = 1'b0;

        // Wait 2 full 1 MHz clk_cpu cycles (2000 ns) for 2-FF reset synchronizer to clear
        #2000;
        sw = 16'h00F4;

        #200000;
        $display("sw = %h | led = %h (Expected 010A)", sw, led);
        $stop;
    end
endmodule