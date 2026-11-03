`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 10:08:04 PM
// Design Name: 
// Module Name: control_fsm
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

module control_fsm #(
    parameter DIV_BITS = 26
)(
    input             clk,
    input             rst,
    output reg [3:0]  inst_idx = 0,    // current state = instruction number (0 to 14)
    output reg [10:0] inst_code        // funct7[5], funct3, opcode
);

    // Slow tick
    reg [DIV_BITS-1:0] counter = 0;
    wire tick = &counter;
    always @(posedge clk) begin
        if (rst) counter <= 0;
        else     counter <= counter + 1'b1;
    end

    // stateregister moves to the next instruction on every tick
    always @(posedge clk) begin
        if (rst)
            inst_idx <= 4'd0;
        else if (tick) begin
            if (inst_idx == 4'd14) inst_idx <= 4'd0;
            else                   inst_idx <= inst_idx + 1'b1;
        end
    end

    // Output instruction fields for the current state
    always @(*) begin
        case (inst_idx)
            4'd0:    inst_code = 11'h033; // ADD
            4'd1:    inst_code = 11'h433; // SUB
            4'd2:    inst_code = 11'h0B3; // SLL
            4'd3:    inst_code = 11'h2B3; // SRL
            4'd4:    inst_code = 11'h233; // XOR
            4'd5:    inst_code = 11'h333; // OR
            4'd6:    inst_code = 11'h3B3; // AND
            4'd7:    inst_code = 11'h013; // ADDI
            4'd8:    inst_code = 11'h103; // LW
            4'd9:    inst_code = 11'h083; // LH
            4'd10:   inst_code = 11'h003; // LB
            4'd11:   inst_code = 11'h123; // SW
            4'd12:   inst_code = 11'h0A3; // SH
            4'd13:   inst_code = 11'h023; // SB
            4'd14:   inst_code = 11'h063; // BEQ
            default: inst_code = 11'h033;
        endcase
    end
endmodule
