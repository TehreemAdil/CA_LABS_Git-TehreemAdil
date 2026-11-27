`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 05:58:46 PM
// Design Name: 
// Module Name: ALUControl
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

module ALUControl (
    input      [1:0] ALUOp,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // ADD (lw, sw)
            2'b01: ALUControl = 4'b0110; // SUB (beq)
            2'b10: begin                 // R-type
                case (funct3)
                    3'b000:  ALUControl = funct7[5] ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b001:  ALUControl = 4'b0100; // SLL
                    3'b100:  ALUControl = 4'b0011; // XOR
                    3'b101:  ALUControl = 4'b0101; // SRL
                    3'b110:  ALUControl = 4'b0001; // OR
                    3'b111:  ALUControl = 4'b0000; // AND
                    default: ALUControl = 4'b0010;
                endcase
            end
            2'b11:   ALUControl = 4'b0010; // ADDI -> ADD
            default: ALUControl = 4'b0010;
        endcase
    end
endmodule