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

module top_control #(
    parameter DIV_BITS = 26
)(
    input         clk,
    input         rst,
    input  [15:0] switches,
    output [15:0] leds
);

    wire rst_clean;
    debouncer rst_db (.clk(clk), .pbin(rst), .pbout(rst_clean));

    wire [31:0] sw_read;      // switch values read
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

    // FSM 
    wire [3:0]  inst_idx;
    wire [10:0] inst_code;
    control_fsm #(.DIV_BITS(DIV_BITS)) fsm (
        .clk(clk), .rst(rst_clean),
        .inst_idx(inst_idx), .inst_code(inst_code)
    );

    // update FSM
    localparam S_SAMPLE = 1'b0, S_UPDATE = 1'b1;
    reg        state   = S_SAMPLE;
    reg [15:0] sw_reg  = 16'd0;     // latched input value
    reg [3:0]  idx_reg = 4'd0;      // latched instruction index

    wire auto_mode = sw_read[14];   // SW14 = 1 FSM drives the inputs

    always @(posedge clk) begin
        if (rst_clean) begin
            state   <= S_SAMPLE;
            sw_reg  <= 16'd0;
            idx_reg <= 4'd0;
        end else begin
            case (state)
                S_SAMPLE: begin
                    if (auto_mode) sw_reg <= {sw_read[15:11], inst_code};
                    else           sw_reg <= sw_read[15:0];
                    idx_reg <= inst_idx;
                    state   <= S_UPDATE;
                end
                S_UPDATE: state <= S_SAMPLE;
                default:  state <= S_SAMPLE;
            endcase
        end
    end

    // decodes the latched value
    wire [6:0] opcode = sw_reg[6:0];
    wire [2:0] funct3 = sw_reg[9:7];
    wire [6:0] funct7 = {1'b0, sw_reg[10], 5'b0};   // switch 10 = funct7[5]

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
    wire [15:0] auto_leds      = {idx_reg, aluControl, main_ctrl_leds[7:0]};

    // Leds are written  in the update state only
    always @(*) begin
        led_we = (state == S_UPDATE);
        if (sw_reg[14])      led_data = auto_leds;
        else if (sw_reg[15]) led_data = alu_ctrl_leds;
        else                 led_data = main_ctrl_leds;
    end
endmodule