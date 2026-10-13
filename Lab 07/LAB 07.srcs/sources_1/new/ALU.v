`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:38:08 AM
// Design Name: 
// Module Name: ALU
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

module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_Op,
    output reg [31:0] Result,
    output Zero
);
    assign Zero = (Result == 32'b0);

    always @(*) begin
        case (ALU_Op)
            4'b0000: Result = A + B;       // ADD
            4'b0001: Result = A - B;       // SUB
            4'b0010: Result = A & B;       // AND
            4'b0011: Result = A | B;       // OR
            4'b0100: Result = A ^ B;       // XOR
            4'b0101: Result = A << B[4:0]; // SLL
            4'b0110: Result = A >> B[4:0]; // SRL
            default: Result = 32'b0;
        endcase
    end
endmodule
