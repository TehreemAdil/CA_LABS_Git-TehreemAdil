`timescale 1ns / 1ps
module ALU_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire        Zero;

    ALU uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        // Display header
        $display("Time\t A\t\t B\t\t Ctrl\t Result\t\t Zero");
        
        // Test 1: ADD (0x0000000A + 0x00000005 = 0x0000000F)
        A = 32'h0000000A; B = 32'h00000005; ALUControl = 4'b0000; #10;
        
        // Test 2: SUB (0x0000000A - 0x00000005 = 0x00000005)
        A = 32'h0000000A; B = 32'h00000005; ALUControl = 4'b0001; #10;
        
        // Test 3: AND (0x10101010 & 0x01010101 = 0x00000000) -> Zero = 1
        A = 32'h10101010; B = 32'h01010101; ALUControl = 4'b0010; #10;
        
        // Test 4: OR  (0x10101010 | 0x01010101 = 0x11111111)
        A = 32'h10101010; B = 32'h01010101; ALUControl = 4'b0011; #10;
        
        // Test 5: XOR (0xFFFFFFFF ^ 0x0000FFFF = 0xFFFF0000)
        A = 32'hFFFFFFFF; B = 32'h0000FFFF; ALUControl = 4'b0100; #10;
        
        // Test 6: SLL (0x00000001 << 4 = 0x00000010)
        A = 32'h00000001; B = 32'h00000004; ALUControl = 4'b0101; #10;
        
        // Test 7: SRL (0x00000010 >> 4 = 0x00000001)
        A = 32'h00000010; B = 32'h00000004; ALUControl = 4'b0110; #10;
        
        // Test 8: BEQ / Equal Check (0x00000008 - 0x00000008 = 0) -> Zero = 1
        A = 32'h00000008; B = 32'h00000008; ALUControl = 4'b0111; #10;


    end

endmodule