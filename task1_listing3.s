.text
.globl main
main:
    li x19, 0
    li x20, 5
    li x21, 3
    li x22, 10
    li x23, 10

    bne x22, x23, Else
    add x19, x20, x21
    beq x0, x0, Exit
Else: 
    sub x19, x20, x21
Exit:
end:
    j end