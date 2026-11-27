`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 05:58:46 PM
// Design Name: 
// Module Name: FPGATop
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

module FPGATop (
    input         clk100,
    input         btnReset,
    input  [15:0] sw,
    output [15:0] led
);
    // 100 MHz / 100 = 1 MHz processor clock
    reg [6:0] cnt     = 7'd0;
    reg       clk_cpu = 1'b0;

    always @(posedge clk100) begin
        if (cnt == 7'd49) begin
            cnt     <= 7'd0;
            clk_cpu <= ~clk_cpu;
        end else begin
            cnt <= cnt + 7'd1;
        end
    end

    // 2-FF reset synchronizer
    reg r1 = 1'b0, r2 = 1'b0;
    always @(posedge clk_cpu) begin
        r1 <= btnReset;
        r2 <= r1;
    end

    TopLevelProcessor #(.PROGRAM_FILE("task1_fsm.mem")) cpu (
        .clk     (clk_cpu),
        .rst     (r2),
        .switches(sw),
        .leds    (led)
    );
endmodule