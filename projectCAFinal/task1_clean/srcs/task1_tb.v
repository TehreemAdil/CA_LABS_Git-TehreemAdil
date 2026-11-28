`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 08:07:03 PM
// Design Name: 
// Module Name: task1_tb
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

module Task1_tb;
    reg         clk100;
    reg         btnReset;
    reg  [15:0] sw;
    wire [15:0] led;

    FPGATop #(.PROGRAM_FILE("task1_fsm_sim.mem")) uut (
        .clk100  (clk100),
        .btnReset(btnReset),
        .sw      (sw),
        .led     (led)
    );

    always #5 clk100 = ~clk100;

    always @(led) $display("t = %0.2f us | led = %h (%0d)", $realtime / 1.0e3, led, led);

    initial begin
        clk100   = 1'b0;
        btnReset = 1'b1;
        sw       = 16'h0000;

        #2000;
        btnReset = 1'b0;

        #10000;
        $display("--- sw = 3: expect LEDs 3 -> 2 -> 1 -> 0");
        sw = 16'h0003;

        #40000;
        $display("--- sw = 9 during countdown: must be ignored");
        sw = 16'h0009;

        #20000;
        sw = 16'h0000;

        #100000;
        $display("--- back in input-waiting state: led = %h (Expected 0000)", led);

        $display("--- sw = 5, reset pressed during countdown");
        sw = 16'h0005;
        #45000;
        sw = 16'h0000;
        btnReset = 1'b1;
        #5000;
        btnReset = 1'b0;
        #10000;
        $display("--- after reset: led = %h (Expected 0000)", led);
        $finish;
    end
endmodule