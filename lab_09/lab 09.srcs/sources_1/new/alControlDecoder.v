`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 01:56:52 PM
// Design Name: 
// Module Name: aluControlDecoder
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

module alu_control (
    input      [1:0] ALUOp,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [3:0] ALUControl
);
    always @(*) begin
        ALUControl = 4'b0000;
        case (ALUOp)
            2'b00: ALUControl = 4'b0010;           // LW/SW add
            2'b01: ALUControl = 4'b0110;           // BEQ subtract
            2'b10: begin                           // Rtype
                case (funct3)
                    3'b000:  ALUControl = funct7[5] ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b001:  ALUControl = 4'b0111; // SLL
                    3'b100:  ALUControl = 4'b0011; // XOR
                    3'b101:  ALUControl = 4'b1000; // SRL
                    3'b110:  ALUControl = 4'b0001; // OR
                    3'b111:  ALUControl = 4'b0000; // AND
                    default: ALUControl = 4'b0000;
                endcase
            end
            2'b11: begin                           // I-type arithmetic funct7 ignored
                case (funct3)
                    3'b000:  ALUControl = 4'b0010; // ADDI
                    default: ALUControl = 4'b0010;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end
endmodule