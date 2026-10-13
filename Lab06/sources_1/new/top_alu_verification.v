`timescale 1ns / 1ps
module top_alu_verification (
    input  wire        clk,
    input  wire        pbin,
    input  wire [3:0]  ALUControl,  // Maps to ALUControl[3:0] in XDC
    input  wire [3:0]  A,           // Maps to A[3:0] in XDC
    input  wire [3:0]  B,           // Maps to B[3:0] in XDC
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] alu_result;
    wire        zero_flag;

    // Debouncer module (reused from Lab 5)
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    // Zero-extend 4-bit switch inputs to 32 bits for the ALU core
    wire [31:0] operand_A = {28'd0, A};
    wire [31:0] operand_B = {28'd0, B};

    // Instantiate ALU
    ALU alu_inst (
        .A(operand_A),
        .B(operand_B),
        .ALUControl(ALUControl),
        .ALUResult(alu_result),
        .Zero(zero_flag)
    );

    // LED Interface Module (reused from Lab 5)
    // LED[14:0] show alu_result[14:0], LED[15] shows Zero flag
    leds led_writer (
        .clk(clk),
        .rst(rst_clean),
        .btns(16'd0),
        .writeData({zero_flag, 15'b0, alu_result[15:0]}),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

endmodule