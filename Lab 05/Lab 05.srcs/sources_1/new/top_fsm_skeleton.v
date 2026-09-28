`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 10:28:38 AM
// Design Name: 
// Module Name: top_fsm_skeleton
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

module top_fsm_skeleton (
    input wire clk,                  // Onboard 100 MHz clock source
    input wire pbin,                 // Physical pushbutton reset
    input wire [15:0] physical_sw,   // Physical FPGA switches
    output wire [15:0] physical_leds // Physical FPGA LEDs
);

    // Internal interconnect signals
    wire rst_clean;
    wire slow_clk;
    wire [31:0] switch_data;
    reg [31:0] led_write_data;

    // Debouncer module instantiation
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    // Clock divider instantiation
    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    // Peripheral bus interfaces
    switches switch_reader (
        .clk(clk),
        .rst(rst_clean),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    leds led_writer (
        .clk(clk),
        .rst(rst_clean),
        .btns(16'd0),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    // State definitions
    localparam IDLE  = 2'b00;
    localparam INPUT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [15:0] counter;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (switch_data[15:0] != 16'd0)
                    next_state = INPUT;
                else
                    next_state = IDLE;
            end
            
            INPUT: begin
                next_state = COUNT;
            end
            
            COUNT: begin
                if (counter == 16'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            
            DONE: begin
                if (switch_data[15:0] == 16'd0)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Sequential state register and counter update
    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean) begin
            state <= IDLE;
            counter <= 16'd0;
        end else begin
            state <= next_state;
            
            case (next_state)
                IDLE: begin
                    counter <= 16'd0;
                end
                INPUT: begin
                    counter <= switch_data[15:0];
                end
                COUNT: begin
                    if (counter > 16'd0)
                        counter <= counter - 16'd1;
                end
                DONE: begin
                    counter <= 16'd0;
                end
                default: counter <= 16'd0;
            endcase
        end
    end

    // Output bus formatting
    always @(*) begin
        led_write_data = {16'd0, counter};
    end

endmodule
