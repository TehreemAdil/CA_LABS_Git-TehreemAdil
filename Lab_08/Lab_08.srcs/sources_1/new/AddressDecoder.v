`timescale 1ns / 1ps

module AddressDecoder (
    input  [31:0] address,
    input         readEnable,
    input         writeEnable,
    input  [31:0] memReadData,
    input  [31:0] switchReadData,
    output reg    dataMemRead,
    output reg    dataMemWrite,
    output reg    ledWrite,
    output reg    switchRead,
    output reg [31:0] readData
);
    wire [1:0] deviceSelect = address[9:8];

    always @(*) begin
        dataMemRead  = 1'b0;
        dataMemWrite = 1'b0;
        ledWrite     = 1'b0;
        switchRead   = 1'b0;
        readData     = 32'b0;

        case (deviceSelect)
            2'b00: begin // Data Memory (0x000 - 0x1FF)
                dataMemRead  = readEnable;
                dataMemWrite = writeEnable;
                readData     = memReadData;
            end
            2'b01: begin // LEDs MMIO (0x200 - 0x2FF)
                ledWrite     = writeEnable;
                readData     = 32'b0;
            end
            2'b10: begin // Switches MMIO (0x300 - 0x3FF)
                switchRead   = readEnable;
                readData     = switchReadData;
            end
            default: readData = 32'b0;
        endcase
    end
endmodule