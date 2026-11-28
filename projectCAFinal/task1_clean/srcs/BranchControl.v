`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2026 01:11:53 PM
// Design Name: 
// Module Name: BranchControl
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

module BranchControl (
    input  wire       branch,
    input  wire [2:0] funct3,
    input  wire       zero,
    input  wire       lt,
    output reg        branch_taken
);
    always @(*) begin
        branch_taken = 1'b0;
        if (branch) begin
            case (funct3)
                3'b000:  branch_taken = zero; // BEQ
                3'b100:  branch_taken = lt;   // 2a: BLT
                default: branch_taken = 1'b0;
            endcase
        end
    end
endmodule
