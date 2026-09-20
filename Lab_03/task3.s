.data
    v_array: .word 11, 22, 33, 44

.text
.globl main
main:
    la x10, v_array
    li x11, 1
    
    jal x1, swap
    
    li x10, 10
    ecall

swap:
    ebreak
    slli x5, x11, 2
    add x5, x10, x5
    
    lw x6, 0(x5)
    lw x7, 4(x5)
    
    sw x7, 0(x5)
    sw x6, 4(x5)
    
    jalr x0, 0(x1)