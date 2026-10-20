`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 05:33:46 PM
// Design Name: 
// Module Name: ClockDivider
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

module ClockDivider (
    input clk_in,
    input rst,
    output clk_out
);
    reg [26:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 27'b0;
        end else begin
            count <= count + 1;
        end
    end

    assign clk_out = count[26];

endmodule