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
// Description: Fixed top module with a clock divider for visible FSM state transitions.
// 
//////////////////////////////////////////////////////////////////////////////////


module top_rf_alu(
    input clk,                   
    input rst,                   
    input [3:0] switches_alu_op, // Select ALU operation
    input switch_we,             // Enable register writing
    input [4:0] switch_rd,       // Switches rd add
    output [7:0] leds_result     // LEDs displaying lower 8 bits of ALU output
);
    
    // Hardcoded test values 
    wire [31:0] const_A = 32'h10101010; 
    wire [31:0] const_B = 32'h01010101;
    
    // connections 
    wire [31:0] read_d1, read_d2, alu_out;
    wire alu_zero; 
    reg [1:0] current_state;
    
    // Clock divider 
    reg [26:0] clk_div;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            clk_div <= 27'b0;
        else 
            clk_div <= clk_div + 1;
    end
    
    // 26th bit for a visible pulse
    wire slow_clk = clk_div[26]; 
    
    // lower 8 bits of ALU result to physical LEDs
    assign leds_result = alu_out[7:0]; 

    // Multiplexer to control Register File inputs
    reg rf_we; // write signal
    reg [4:0] rf_rd; // select lines
    reg [31:0] rf_data; // data

    // Constants
    always @(*) begin
        case (current_state)
            2'b00: begin 
                // State 0 Write first constant to register x1
                rf_we = 1'b1;
                rf_rd = 5'd1;
                rf_data = const_A;
            end
            2'b01: begin 
                // State 1 Write second constant to register x2
                rf_we = 1'b1;
                rf_rd = 5'd2;
                rf_data = const_B;
            end
            default: begin 
                // States 2 and 3 physical board switches
                rf_we = switch_we;
                rf_rd = switch_rd;
                rf_data = alu_out;
            end
        endcase
    end

    // Register File module
    RegisterFile rf (
        .clk(clk), 
        .rst(rst), 
        .WriteEnable(rf_we),
        .rs1(5'd1), 
        .rs2(5'd2), 
        .rd(rf_rd), 
        .WriteData(rf_data), 
        .ReadData1(read_d1), 
        .readData2(read_d2)
    );
    
    // ALU module
    ALU alu_inst (
        .A(read_d1),
        .B(read_d2),
        .ALUControl(switches_alu_op),
        .ALUResult(alu_out),
        .Zero(alu_zero)
    );
    
    // state 3 
    always @(posedge slow_clk or posedge rst) begin
        if (rst)
            current_state <= 2'b00; 
        else 
            if (current_state != 2'b11)
                current_state <= current_state + 1; 
    end
endmodule