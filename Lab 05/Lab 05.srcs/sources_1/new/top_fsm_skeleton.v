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

`timescale 1ns / 1ps

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

    // Added WAIT_RELEASE state to wait for user to clear switches before starting next cycle
    localparam IDLE         = 2'b00;
    localparam INPUT        = 2'b01;
    localparam COUNT        = 2'b10;
    localparam WAIT_RELEASE = 2'b11;

    reg [1:0] state, next_state;
    reg [15:0] counter;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Transition to INPUT when switches are non-zero
                if (switch_data[15:0] != 16'd0)
                    next_state = INPUT;
                else
                    next_state = IDLE;
            end
            
            INPUT: begin
                // Automatically move to counting state after capturing value
                next_state = COUNT;
            end
            
            COUNT: begin
                // Once counter reaches zero, move to wait for switch release
                if (counter == 16'd0)
                    next_state = WAIT_RELEASE;
                else
                    next_state = COUNT;
            end
            
            WAIT_RELEASE: begin
                // Return to IDLE once user turns off all physical switches
                if (switch_data[15:0] == 16'd0)
                    next_state = IDLE;
                else
                    next_state = WAIT_RELEASE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Sequential state register and counter update
    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean) begin
            // Asynchronous reset forces FSM back to IDLE and clears counter
            state <= IDLE;
            counter <= 16'd0;
        end else begin
            state <= next_state;
            
            case (next_state)
                IDLE: begin
                    // Keep counter cleared while waiting for input
                    counter <= 16'd0;
                end
                INPUT: begin
                    // Capture current switch value into counter
                    counter <= switch_data[15:0];
                end
                COUNT: begin
                    // Decrement counter down to zero while ignoring new switch inputs
                    if (counter > 16'd0)
                        counter <= counter - 16'd1;
                end
                WAIT_RELEASE: begin
                    // Keep counter at zero while waiting for switches to clear
                    counter <= 16'd0;
                end
                default: counter <= 16'd0;
            endcase
        end
    end

    // Output bus formatting: LED display continuously shows counter value
    always @(*) begin
        led_write_data = {16'd0, counter};
    end

endmodule