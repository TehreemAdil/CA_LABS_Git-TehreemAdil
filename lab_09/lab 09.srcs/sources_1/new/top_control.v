`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 01:27:50 PM
// Design Name: 
// Module Name: top_control
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_control
// Description: Lab 9 FPGA verification top. Reads opcode/funct3/funct7[5] from
//              switches through an FSM and shows control signals on LEDs.
//   SW[6:0]=opcode  SW[9:7]=funct3  SW[10]=funct7[5]  SW[15]=mode (0=Main, 1=ALU)
//   Main mode LEDs: [7:6]=ALUOp [5]=Branch [4]=MemtoReg [3]=MemWrite
//                   [2]=MemRead [1]=ALUSrc [0]=RegWrite
//   ALU mode LEDs : [3:0]=ALUControl
//////////////////////////////////////////////////////////////////////////////////
module top_control(
    input         clk,
    input         rst,
    input  [15:0] switches,
    output [15:0] leds
);
    // ---------------- Lab 5 interface modules (reused) ----------------
    wire rst_clean;
    debouncer rst_db (.clk(clk), .pbin(rst), .pbout(rst_clean));
 
    wire [31:0] sw_read;      // switch values read through the provided interface
    leds sw_in (
        .clk(clk), .rst(rst_clean), .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
        .memAddress(30'd0), .switches(switches), .readData(sw_read)
    );
 
    reg         led_we;
    reg  [15:0] led_data;
    switches led_out (
        .clk(clk), .rst(rst_clean),
        .writeData({16'd0, led_data}), .writeEnable(led_we),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(), .leds(leds)
    );
 
    // ---------------- FSM: SAMPLE -> UPDATE -> SAMPLE ----------------
    localparam S_SAMPLE = 1'b0, S_UPDATE = 1'b1;
    reg        state;
    reg [15:0] sw_reg;        // latched switch value
 
    always @(posedge clk) begin
        if (rst_clean) begin
            state  <= S_SAMPLE;
            sw_reg <= 16'd0;
        end else begin
            case (state)
                S_SAMPLE: begin sw_reg <= sw_read[15:0]; state <= S_UPDATE; end
                S_UPDATE: state <= S_SAMPLE;
            endcase
        end
    end
 
    // ---------------- Control path (decodes the latched value) ----------------
    wire [6:0] opcode = sw_reg[6:0];
    wire [2:0] funct3 = sw_reg[9:7];
    wire [6:0] funct7 = {1'b0, sw_reg[10], 5'b0};   // switch 10 -> funct7[5]
 
    wire       regWrite, aluSrc, memRead, memWrite, memtoReg, branch;
    wire [1:0] aluOp;
    wire [3:0] aluControl;
 
    opcodeDecoder main_ctrl (
        .opcode(opcode), .RegWrite(regWrite), .ALUSrc(aluSrc),
        .MemRead(memRead), .MemWrite(memWrite), .MemtoReg(memtoReg),
        .Branch(branch), .ALUOp(aluOp)
    );
 
    alu_control alu_ctrl_unit (
        .ALUOp(aluOp), .funct3(funct3), .funct7(funct7), .ALUControl(aluControl)
    );
 
    wire [15:0] main_ctrl_leds = {8'b0, aluOp, branch, memtoReg, memWrite, memRead, aluSrc, regWrite};
    wire [15:0] alu_ctrl_leds  = {12'b0, aluControl};
 
    // LEDs are written only in the UPDATE state
    always @(*) begin
        led_we   = (state == S_UPDATE);
        led_data = sw_reg[15] ? alu_ctrl_leds : main_ctrl_leds;
    end
endmodule
 