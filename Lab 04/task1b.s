.globl main
.text

main:
    addi x10, x0, 5
    jal  x1, fact

end:
    j end

fact:
    add  x5, x0, x10
    addi x10, x0, 1

loop:
    ble  x5, x0, end
    mul  x10, x10, x5
    addi x5, x5, -1
    j    loop

end:
    jalr x0, 0(x1)
