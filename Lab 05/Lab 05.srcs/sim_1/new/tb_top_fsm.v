`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2026 11:38:25 AM
// Design Name: 
// Module Name: tb_top_fsm
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

module tb_top_fsm;

    // Inputs
    reg clk;
    reg pbin;
    reg [15:0] physical_sw;

    // Outputs
    wire [15:0] physical_leds;

    // Instantiate 
    top_fsm_skeleton uut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );

    // Override hardware delay counters for fast simulation speed
    defparam uut.rst_db.DELAY_COUNTS = 5;
    defparam uut.ticker.TERMINAL_COUNT = 5;

    // 100 MHz clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        pbin = 1;
        physical_sw = 16'h0000;

        #200;
        pbin = 0;
        #200;

        // Test Case 1: Load switch value 5 and watch countdown to 0
        physical_sw = 16'h0005;
        #2000;

        // Clear switches so FSM can transition out of WAIT_RELEASE back to IDLE
        physical_sw = 16'h0000;
        #1000;

        // Test Case 2: Load switch value 3 and trigger reset button mid-way
        physical_sw = 16'h0003;
        #800;
        pbin = 1; // Assert reset
        #200;
        pbin = 0; // Deassert reset
        physical_sw = 16'h0000;
        #1000;

        $finish;
    end

endmodule