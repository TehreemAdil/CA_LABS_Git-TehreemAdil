`timescale 1ns / 1ps

module addressDecoderTop (
    input         clk, 
    input         rst,
    input  [15:0] switches, // Board Switches SW15-SW0
    output [15:0] leds      // Board LEDs LD15-LD0
);

    // Physical Switch Mapping:
    // SW15: readEnable
    // SW14: writeEnable
    // SW13-SW12: address[9:8] (Device Select: 00=RAM, 01=LEDs, 10=Switches)
    // SW11-SW8 : address[3:0] (Local RAM offset)
    // SW7-SW0  : writeData[7:0]
    
    wire readEnable  = switches[15];
    wire writeEnable = switches[14];
    
    // Drive address[9:8] with SW13-SW12 and local address bits with SW11-SW8
    wire [31:0] address   = {22'b0, switches[13:12], 4'b0000, switches[11:8]}; 
    wire [31:0] writeData = {24'b0, switches[7:0]};  
    wire [31:0] readData;

    wire dataMemRead, dataMemWrite, ledWrite, switchRead;
    wire [31:0] memReadData;
    wire [31:0] switchReadData = {16'b0, switches};

    // Instantiate Address Decoder
    AddressDecoder decoder (
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .memReadData(memReadData),
        .switchReadData(switchReadData),
        .dataMemRead(dataMemRead),
        .dataMemWrite(dataMemWrite),
        .ledWrite(ledWrite),
        .switchRead(switchRead),
        .readData(readData)
    );

    // Instantiate Data Memory
    DataMemory data_mem (
        .clk(clk),
        .memWrite(dataMemWrite),
        .memRead(dataMemRead),
        .address(address[8:0]),
        .writeData(writeData),
        .readData(memReadData)
    );

    // Synchronous Output Register for LEDs (MMIO Write)
    reg [15:0] led_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_reg <= 16'b0;
        end else if (ledWrite) begin
            led_reg <= writeData[15:0];
        end
    end

    // Route MMIO Read or Memory Read to LEDs, or maintain stored LED register value
    assign leds = (switchRead || dataMemRead) ? readData[15:0] : led_reg;

endmodule