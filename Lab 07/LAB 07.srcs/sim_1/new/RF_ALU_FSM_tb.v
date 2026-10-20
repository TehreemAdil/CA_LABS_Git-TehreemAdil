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

module RF_ALU_FSM_tb();
    reg clk, rst;
    
    // FSM States for deterministic sequence
    parameter INIT_X1 = 3'd0, 
              INIT_X2 = 3'd1, 
              ALU_ADD = 3'd2, 
              ALU_SUB = 3'd3, 
              ALU_AND = 3'd4, 
              DONE    = 3'd5;
              
    reg [2:0] state, next_state;
    
    // Testbench signals mapping
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData_tb; // Data supplied by TB
    reg use_alu_data;        // Mux control: 0 = TB data, 1 = ALU data
    
    wire [31:0] ReadData1, readData2;
    wire [31:0] alu_result;
    wire alu_zero;
    reg [3:0] alu_op;
    
    // Mux to select between Testbench constants and ALU results for Register WriteData
    wire [31:0] final_WriteData = use_alu_data ? alu_result : WriteData_tb;
    
    // Instantiate Register File
    RegisterFile rf (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(final_WriteData),
        .ReadData1(ReadData1), .readData2(readData2)
    );
    
    // Instantiate actual ALU[cite: 4]
    ALU alu_inst(
        .A(ReadData1), 
        .B(readData2), 
        .ALUControl(alu_op), 
        .ALUResult(alu_result), 
        .Zero(alu_zero)
    );

    // Clock generation
    always #5 clk = ~clk;

    // FSM State transitions[cite: 4]
    always @(posedge clk or posedge rst) begin
        if (rst) state <= INIT_X1;
        else state <= next_state;
    end

    // FSM Next State Logic[cite: 4]
    always @(*) begin
        case (state)
            INIT_X1: next_state = INIT_X2;
            INIT_X2: next_state = ALU_ADD;
            ALU_ADD: next_state = ALU_SUB;
            ALU_SUB: next_state = ALU_AND;
            ALU_AND: next_state = DONE;
            DONE:    next_state = DONE;
            default: next_state = INIT_X1;
        endcase
    end
    
    // FSM Output Logic (Datapath Control)[cite: 4]
    always @(*) begin
        // Default assignments to prevent latches
        WriteEnable = 0;
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;
        WriteData_tb = 32'd0;
        use_alu_data = 0;
        alu_op = 4'b0000;

        case (state)
            INIT_X1: begin
                // Write 0x10101010 to x1[cite: 4]
                WriteEnable = 1;
                rd = 5'd1;
                WriteData_tb = 32'h10101010;
                use_alu_data = 0;
            end
            
            INIT_X2: begin
                // Write 0x01010101 to x2[cite: 4]
                WriteEnable = 1;
                rd = 5'd2;
                WriteData_tb = 32'h01010101;
                use_alu_data = 0;
            end
            
            ALU_ADD: begin
                // Read x1, x2 -> Add -> Write to x4[cite: 4]
                rs1 = 5'd1;
                rs2 = 5'd2;
                alu_op = 4'b0000; // ADD control
                
                WriteEnable = 1;
                rd = 5'd4;
                use_alu_data = 1; // Route ALU result to RegFile
            end
            
            ALU_SUB: begin
                // Read x1, x2 -> Sub -> Write to x5[cite: 4]
                rs1 = 5'd1;
                rs2 = 5'd2;
                alu_op = 4'b0001; // SUB control
                
                WriteEnable = 1;
                rd = 5'd5;
                use_alu_data = 1;
            end
            
            ALU_AND: begin
                // Read x1, x2 -> AND -> Write to x6[cite: 4]
                rs1 = 5'd1;
                rs2 = 5'd2;
                alu_op = 4'b0010; // AND control
                
                WriteEnable = 1;
                rd = 5'd6;
                use_alu_data = 1;
            end
            
            DONE: begin
                WriteEnable = 0;
            end
        endcase
    end
    
    // Simulation Execution
    initial begin
        clk = 0; rst = 1; 
        #10 rst = 0;
        
        // Wait enough time for FSM to cycle through sequence
        #150;
        $finish;
    end
endmodule