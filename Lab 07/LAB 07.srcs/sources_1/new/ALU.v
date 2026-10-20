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
    input  wire [31:0] A,          
    input  wire [31:0] B,          
    input  wire [3:0]  ALUControl, 
    output reg  [31:0] ALUResult,  
    output wire        Zero        
);
    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A + B;                  
            4'b0001: ALUResult = A - B;                  
            4'b0010: ALUResult = A & B;                  
            4'b0011: ALUResult = A | B;                  
            4'b0100: ALUResult = A ^ B;                  
            4'b0101: ALUResult = A << B[4:0];            
            4'b0110: ALUResult = A >> B[4:0];            
            4'b0111: ALUResult = A - B;                  
            default: ALUResult = 32'h00000000;
        endcase
    end
    assign Zero = (ALUResult == 32'h00000000) ? 1'b1 : 1'b0;

endmodule