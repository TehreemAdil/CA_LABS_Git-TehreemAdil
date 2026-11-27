`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 05:58:46 PM
// Design Name: 
// Module Name: LedPeripherial
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

module LedPeripheral (
    input             clk,
    input             rst,
    input             writeEnable,
    input      [31:0] writeData,
    output reg [15:0] leds = 16'd0
);
    always @(posedge clk) begin
        if (rst)              leds <= 16'd0;
        else if (writeEnable) leds <= writeData[15:0];
    end
endmodule