
`timescale 1ns / 1ps

module top_fsm_system_tb;

reg clk;
reg pbin;
reg [15:0] physical_sw;
wire [15:0] physical_leds;

top_fsm_system uut (
    .clk(clk),
    .pbin(pbin),
    .physical_sw(physical_sw),
    .physical_leds(physical_leds)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    pbin = 0;
    physical_sw = 16'd0;

    #20;

    pbin = 1;
    #20;
    pbin = 0;

    #20;

    physical_sw = 16'd5;

    #20;
    #20;
    #20;
    #20;
    #20;
    #20;
    #20;

    physical_sw = 16'd0;

    #100;

    
end

endmodule

