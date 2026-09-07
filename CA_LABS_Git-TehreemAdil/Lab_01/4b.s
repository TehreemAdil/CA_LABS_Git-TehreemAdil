.text
.globl main

main:
    li x1, 0x100 # array a of byte
    li x2, 0x200 # array b of 2 byte
    li x3, 0x300 # array c of unsigned int


    # iterations 
    # 1
    lb x4, 0(x1)
    lh x5, 0(x2)
    add x6, x4, x5
    sw x6, 0(x3)

    #2
    lb x7, 1(x1)
    lh x8, 2(x2)
    add x9, x7, x8
    sw x9, 4(x3)

    #3
    lb x10, 2(x1)
    lh x11, 4(x2)
    add x12, x10, x11
    sw x12, 8(x3)

    #4
    lb x13, 3(x1)
    lh x14, 6(x2)
    add x15, x13, x14
    sw x15, 12(x3)
