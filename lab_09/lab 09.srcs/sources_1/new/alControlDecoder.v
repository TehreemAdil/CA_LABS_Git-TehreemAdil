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
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] ALUControl
);

    always @(*) begin
        // Default safe value
        ALUControl = 4'b0000;

        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // addition 
            2'b01: ALUControl = 4'b0110; // subtraction
            2'b10: begin // R/I-type 
                case (funct3)
                    3'b000: begin // add addi sub
                        if (funct7[5] == 1'b1)
                            ALUControl = 4'b0110; // sub
                        else
                            ALUControl = 4'b0010; // add  addi
                    end
                    3'b001: ALUControl = 4'b0111; // sll
                    3'b100: ALUControl = 4'b0011; // xor
                    3'b101: ALUControl = 4'b1000; // srl
                    3'b110: ALUControl = 4'b0001; // or
                    3'b111: ALUControl = 4'b0000; // amd
                    default: ALUControl = 4'b0000;
                endcase
            end
            default ALUControl = 4'b0000;
        endcase
    end
endmodule