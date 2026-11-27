`timescale 1ns / 1ps                                                              
//////////////////////////////////////////////////////////////////////////////////
// Company:                                                                       
// Engineer:                                                                      
//                                                                                
// Create Date: 11/27/2026 05:58:46 PM                                            
// Design Name:                                                                   
// Module Name: instructionMemory                                                      
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
module instructionMemory #(
    parameter PROGRAM_FILE = "task1_fsm.mem"
)(
    input  [31:0] instAddress,
    output [31:0] instruction
);
    reg [31:0] rom [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1) rom[i] = 32'h0000_0013; // NOP
        $readmemh(PROGRAM_FILE, rom);
    end

    assign instruction = rom[instAddress[7:2]];
endmodule