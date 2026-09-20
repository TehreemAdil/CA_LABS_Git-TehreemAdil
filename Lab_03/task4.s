.data
    string_y: .byte 72, 97, 98, 105, 98, 0
    string_x: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
.globl main
main:
    la x10, string_x
    la x11, string_y
    
    jal x1, strcpy
    
    li x10, 10
    ecall

strcpy:
    ebreak
    addi sp, sp, -4       # adjust stack for 1 more item
    sw x19, 0(sp)         # save x19
    
    # Initialize i
    add x19, x0, x0       # i = 0
 
loop:
    # y[i]
    add x5, x19, x11      # get address of y[i]
    lbu x6, 0(x5)         # load byte y[i] into x6 
    
    # Store into x[i]
    add x7, x19, x10      # get address of x[i]
    sb x6, 0(x7)          # store byte from x6 into x[i]
    
    # Check for null terminator
    beq x6, x0, exit      # if y[i] == '\0' 0, exit the loop
    
    # Increment i and loop
    addi x19, x19, 1      # i += 1
    jal x0, loop          # jump back to start of loop
 
exit:
    lw x19, 0(sp)         # restore x19
    addi sp, sp, 4        # restore stack pointer
    jalr x0, 0(x1)        # return