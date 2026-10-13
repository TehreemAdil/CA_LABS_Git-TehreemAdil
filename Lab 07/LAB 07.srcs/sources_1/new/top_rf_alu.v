`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:40:18 AM
// Design Name: 
// Module Name: top_rf_alu
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

 
module top_rf_alu (
    input clk,
    input rst,
    input [3:0] sw_alu_op,
    output [3:0] led_result,
    output [1:0] led_state
);
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUResult;
    wire Zero;
    
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    
    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, READ_REGISTERS = 2'b01, ALU_OPERATION = 2'b10, WRITE_REGISTERS = 2'b11;

    assign led_state = state;
    assign led_result = ALUResult[3:0];

    RegisterFile rf (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1), .B(ReadData2), .ALU_Op(sw_alu_op),
        .Result(ALUResult), .Zero(Zero)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: next_state = READ_REGISTERS;
            READ_REGISTERS: next_state = ALU_OPERATION;
            ALU_OPERATION: next_state = WRITE_REGISTERS;
            WRITE_REGISTERS: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        WriteEnable <= 0;
        if (state == IDLE) begin
            // Startup Constants
            WriteEnable <= 1; rd <= 1; WriteData <= 32'h10101010;
        end else if (state == READ_REGISTERS) begin
            rs1 <= 1; rs2 <= 2;
        end else if (state == WRITE_REGISTERS) begin
            WriteEnable <= 1; rd <= 4; WriteData <= ALUResult;
        end
    end
endmodule
