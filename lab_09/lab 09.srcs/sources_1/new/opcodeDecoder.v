`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 01:56:52 PM
// Design Name: 
// Module Name: opcodeDecoder
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

module opcodeDecoder(
    input      [6:0] opcode,
    output reg       RegWrite,
    output reg [1:0] ALUOp,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       ALUSrc,
    output reg       MemtoReg,
    output reg       Branch
);
    localparam [6:0] OP_R_TYPE  = 7'b0110011; // ADD, SUB, SLL, SRL, AND, OR, XOR
    localparam [6:0] OP_I_ARITH = 7'b0010011; // ADDI
    localparam [6:0] OP_LOAD    = 7'b0000011; // LW, LH, LB
    localparam [6:0] OP_STORE   = 7'b0100011; // SW, SH, SB
    localparam [6:0] OP_BRANCH  = 7'b1100011; // BEQ
 
    always @(*) begin
        // Safe defaults used for unsupported opcodes too
        RegWrite = 1'b0;
        ALUOp    = 2'b00;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;
 
        case (opcode)
            OP_R_TYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            OP_I_ARITH: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b11;
            end
            OP_LOAD: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                ALUOp    = 2'b00;
            end
            OP_STORE: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
            end
            OP_BRANCH: begin
                Branch   = 1'b1;
                ALUOp    = 2'b01;
            end
            default: ;
        endcase
    end
endmodule
 