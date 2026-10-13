`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 09:07:59 AM
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
/////////////////////////////////////////////////////////////////////////////////

module RF_ALU_FSM_tb();

    reg clk;
    reg rst;
    
    parameter IDLE           = 3'b000;
    parameter WRITE_REGS     = 3'b001;
    parameter READ_AND_ALU   = 3'b010;
    parameter WRITE_BACK     = 3'b011;
    parameter DONE           = 3'b100;
    
    reg [2:0] state = IDLE;

    reg [4:0] rs1, rs2, rd;
    reg [31:0] writeData;
    reg writeEnable;
    wire [31:0] readData1, readData2;

    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    RegisterFile rf (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readData1(readData1),
        .readData2(readData2),
        .rst(rst),
        .clk(clk)
    );

    ALU alu_inst (
        .A(readData1),
        .B(readData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    always #5 clk = ~clk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            writeEnable <= 0;
            rd <= 0;
            writeData <= 0;
            rs1 <= 0;
            rs2 <= 0;
            ALUControl <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    state <= WRITE_REGS;
                    writeEnable <= 0;
                end
                WRITE_REGS: begin
                    rd <= 5'd1;
                    writeData <= 32'd10;
                    writeEnable <= 1;
                    state <= READ_AND_ALU;
                end
                READ_AND_ALU: begin
                    rd <= 5'd2;
                    writeData <= 32'd20;
                    rs1 <= 5'd1;
                    rs2 <= 5'd2;
                    ALUControl <= 4'b0000;
                    state <= WRITE_BACK;
                end
                WRITE_BACK: begin
                    writeEnable <= 1;
                    rd <= 5'd3;
                    writeData <= ALUResult;
                    state <= DONE;
                end
                DONE: begin
                    writeEnable <= 0;
                end
            endcase
        end
    end

    initial begin
        clk = 0;
        rst = 1;
        #15;
        rst = 0;
        #200;
        $finish;
    end

endmodule
