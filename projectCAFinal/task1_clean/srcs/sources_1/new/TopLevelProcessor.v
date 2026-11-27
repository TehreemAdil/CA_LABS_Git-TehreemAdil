`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 05:58:46 PM
// Design Name: 
// Module Name: TopLevelProcessor
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

module TopLevelProcessor #(
    parameter PROGRAM_FILE = "task1_fsm.mem"
)(
    input         clk,
    input         rst,
    input  [15:0] switches,
    output [15:0] leds
);
    wire [31:0] PC, PCPlus4, PCBranch, PCNext, instr, imm;
    wire [31:0] ReadData1, ReadData2, ALUB, ALUResult, WriteBack;
    wire [31:0] dmReadData, swReadData, busReadData;
    wire [3:0]  ALUCtrl;
    wire [1:0]  ALUOp;
    wire        RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, Zero, PCSrc;
    wire        DataMemRead, DataMemWrite, LEDWrite, SwitchReadEnable;

    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    assign PCSrc  = Branch & Zero;
    assign PCNext = PCSrc ? PCBranch : PCPlus4;

    ProgramCounter u_pc  (.clk(clk), .rst(rst), .PCNext(PCNext), .PC(PC));
    pcAdder        u_pc4 (.PC(PC), .PCPlus4(PCPlus4));
    branchAdder    u_bra (.PC(PC), .imm(imm), .PCBranch(PCBranch));

    instructionMemory #(.PROGRAM_FILE(PROGRAM_FILE)) u_imem (
        .instAddress(PC),
        .instruction(instr)
    );

    MainControl u_ctrl (
        .opcode(opcode), .RegWrite(RegWrite), .ALUSrc(ALUSrc),
        .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
        .Branch(Branch), .ALUOp(ALUOp)
    );

    immGen u_imm (.inst(instr), .imm(imm));

    RegisterFile u_rf (
        .clk(clk), .rst(rst), .WriteEnable(RegWrite),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteBack), .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALUControl u_aluctl (.ALUOp(ALUOp), .funct3(funct3), .funct7(funct7), .ALUControl(ALUCtrl));

    assign ALUB = ALUSrc ? imm : ReadData2;
    ALU u_alu (.A(ReadData1), .B(ALUB), .ALUControl(ALUCtrl), .ALUResult(ALUResult), .Zero(Zero));

    AddressDecoder u_dec (
        .address(ALUResult), .MemRead(MemRead), .MemWrite(MemWrite),
        .DataMemRead(DataMemRead), .DataMemWrite(DataMemWrite),
        .LEDWrite(LEDWrite), .SwitchReadEnable(SwitchReadEnable)
    );

    DataMemory u_dmem (
        .clk(clk), .MemWrite(DataMemWrite), .MemRead(DataMemRead),
        .address(ALUResult), .write_data(ReadData2), .read_data(dmReadData)
    );

    LedPeripheral u_led (
        .clk(clk), .rst(rst), .writeEnable(LEDWrite),
        .writeData(ReadData2), .leds(leds)
    );

    SwitchPeripheral u_sw (
        .readEnable(SwitchReadEnable), .switches(switches), .readData(swReadData)
    );

    assign busReadData = SwitchReadEnable ? swReadData : dmReadData;
    assign WriteBack   = MemtoReg ? busReadData : ALUResult;
endmodule