`timescale 1ns / 1ps

module MemorySystem_tb;

    // Testbench Signals
    reg clk;
    reg rst;
    reg [15:0] switches;
    wire [15:0] leds;

    // Instantiate Top Module
    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .leds(leds)
    );

    // 100MHz Clock Generation (10ns Period)
    always #5 clk = ~clk;

    initial begin
        // 0ps: Initialize inputs to 0 (Removes 'X' states)
        clk = 0;
        switches = 16'h0000;
        
        // Assert Reset to clear registers (Removes 'Z' states from leds)
        rst = 1;
        #20;
        rst = 0;
        #20;

        // --------------------------------------------------------
        // TEST 1: RAM Write & Read (Address 4, Write Data 4)
        // --------------------------------------------------------
        // SW10 (address[2]=1) and SW2 (writeData=4)
        switches = 16'b0000_0100_0000_0100; 
        #20;

        // Pulse writeEnable (SW14)
        switches[14] = 1;
        #20;
        switches[14] = 0;
        #20;

        // Pulse readEnable (SW15) -> LD2 will turn ON
        switches[15] = 1;
        #20;
        switches[15] = 0;
        #20;

        // --------------------------------------------------------
        // TEST 2: LEDs MMIO Write (Address 512, Write Data 3)
        // --------------------------------------------------------
        // SW12 (address[8]=1 -> Address 512) and SW0, SW1 (writeData=3)
        switches = 16'b0001_0000_0000_0011; 
        #20;

        // Pulse writeEnable (SW14) -> LD0 and LD1 will turn ON
        switches[14] = 1;
        #20;
        switches[14] = 0;
        #20;

        // --------------------------------------------------------
        // TEST 3: Switches MMIO Read (Address 768)
        // --------------------------------------------------------
        // SW13 (address[9]=1 -> Address 768) with SW3, SW4 set as input data
        switches = 16'b0010_0000_0001_1000; 
        #20;

        // Set readEnable (SW15) HIGH -> LEDs mirror switches live
        switches[15] = 1;
        #40;

        $finish;
    end

endmodule