.text
.globl main
main:
    li x10, 10
    li x11, 5
    li x12, 4
    li x13, 2
    
    jal x1, leaf_example
    
    # Print the result 
    addi x11, x10, 0    # Move result (9) from x10 to x11
    li x10, 1           # Print Integer
    ecall
    
    # Safely exit the program
    li x10, 10          #  Exit
    ecall

leaf_example:
    ebreak
    # allocate 16 bytes on stack
    addi sp, sp, -12
    sw x20, 8(sp)       # Save reg x20 (f) 
    sw x19, 4(sp)       # Save temp reg x19 
    sw x18, 0(sp)       # Save temp reg x18 

    add x18, x10, x11   # x18 = g + h
    add x19, x12, x13   # x19 = i + j
    sub x20, x18, x19   # (x20) = (g + h) - (i + j)
    add x10, x20, x0    # x20 into x10

    lw x18, 0(sp)       # Restore temp reg x18
    lw x19, 4(sp)       # Restore temp reg x19
    lw x20, 8(sp)       # Restore reg x20
    addi sp, sp, 12    

    jalr x0, 0(x1)