`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:39:32 AM
// Design Name: 
// Module Name: RF_ALU_FSM_tb
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


module RF_ALU_FSM_tb;
    reg clk;
    reg rst;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUResult;
    wire Zero;
    
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    reg [3:0] ALU_Op;
    
    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, READ_REGISTERS = 2'b01, ALU_OPERATION = 2'b10, WRITE_REGISTERS = 2'b11;

    RegisterFile rf (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1), .B(ReadData2), .ALU_Op(ALU_Op),
        .Result(ALUResult), .Zero(Zero)
    );

    always #5 clk = ~clk;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = READ_REGISTERS;
            READ_REGISTERS: next_state = ALU_OPERATION;
            ALU_OPERATION: next_state = WRITE_REGISTERS;
            WRITE_REGISTERS: next_state = IDLE;
        endcase
    end

    initial begin
        clk = 0; rst = 1;
        #15 rst = 0;
        // Step i: Setup constants manually via TB before FSM takes over logic
        WriteEnable = 1; rd = 1; WriteData = 32'h01010101; #10;
        WriteEnable = 1; rd = 2; WriteData = 32'h01010101; #10;
        WriteEnable = 0;
        
        #100 $finish;
    end

    always @(state) begin
        WriteEnable = 0;
        case (state)
            READ_REGISTERS: begin
                rs1 = 1; rs2 = 2;
            end
            ALU_OPERATION: begin
                ALU_Op = 4'b0000; // ADD
            end
            WRITE_REGISTERS: begin
                WriteEnable = 1; rd = 4; WriteData = ALUResult;
            end
        endcase
    end
endmodule