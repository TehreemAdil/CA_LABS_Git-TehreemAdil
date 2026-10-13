`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
<<<<<<< HEAD
// Company:
=======
// Company: 
>>>>>>> 1e97a160fc7357c9145019023b56532714c9a859
// Engineer: Muddassir Ali

// Module Name: leds
// Project Name: Counter
// Target Devices: Baasys 3
<<<<<<< HEAD
//
=======
// 
>>>>>>> 1e97a160fc7357c9145019023b56532714c9a859
//////////////////////////////////////////////////////////////////////////////////


module leds(
    input clk,
    input rst,
    input [15:0] btns,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    input [15:0] switches,
    output [31:0] readData
    );
<<<<<<< HEAD
 
    assign readData = {16'd0, switches};
endmodule
=======
  
    assign readData = {16'd0, switches};
endmodule
>>>>>>> 1e97a160fc7357c9145019023b56532714c9a859
