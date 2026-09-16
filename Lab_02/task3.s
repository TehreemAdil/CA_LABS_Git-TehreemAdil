.text
.globl main
main:
    li   x23, 0          # sum = 0
    li   t0, 0x200       # base address of array a
    li   t1, 10          # loop boundary (10)

    li   x22, 0          # i = 0

loop1:
    bge  x22, t1, endloop1
    slli t2, x22, 2      # t2 = i * 4 (byte offset)
    add  t3, t0, t2      # t3 = address of a[i]
    sw   x22, 0(t3)      # a[i] = i
    addi x22, x22, 1     # i++
    j    loop1

endloop1:
    li   x22, 0          # i = 0

loop2:
    bge  x22, t1, endloop2
    slli t2, x22, 2      # t2 = i * 4
    add  t3, t0, t2      # t3 = address of a[i]
    lw   t4, 0(t3)       # t4 = a[i]
    add  x23, x23, t4    # sum = sum + a[i]
    addi x22, x22, 1     # i++
    j    loop2
endloop2: 
end:
    j    end            