.text
.globl main

main:
    li x31 , 5 #a 
    
    addi x2, x0, 0 #b variable
    addi x3, x2, 32 #a revaluated

    add x4, x3, x2 #a + b
    addi x5, x4, -5 #d evaluated
    sub x6, x3, x5 # a - d evaluated 
    sub x7, x2, x3 # b - reevaluated a
    add x8, x6, x7 # ((a -d) + (b - a))
    add x9, x8, x5 # e evaluated
    add x10, x3, x2 # a + b
    add x11, x5, x9 # d + e evaluated
    add x9 , x10 , x11 # e revaluated

end:
    j end