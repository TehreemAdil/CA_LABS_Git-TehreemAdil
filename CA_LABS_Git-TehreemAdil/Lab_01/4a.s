.text
.globl main

main:
    # Store memory address (0x100) into x5
    lui  x5, 0x00000          # Upper 20 bits = 0x00000
    addi x5, x5, 0x100        # Lower 12 bits = 0x100 -> x5 = 0x00000100

    # Initialize x10 with 0x78786464
    lui  x10, 0x78786         # Loads upper 20 bits
    addi x10, x10, 0x464      # Adds lower 12 bits

    # Initialize x11 with 0xA8A81919
    lui  x11, 0xA8A82         # Loads upper 20 bits 
    addi x11, x11, -1767      # Adds 0xFFFFF919    
    # Store x10 as an unsigned integer at address 0x100
    sw   x10, 0(x5)           # Stores 32 bits of x10 at address 0x100


    li x6, 0x1F0
    sw x11 , 0(x6) # Stores 32 bits of x11 at address 0x1F0

    lhu x12, 0(x5)
    
    lh x13, 0(x6)

    lb x14, 0(x6)

