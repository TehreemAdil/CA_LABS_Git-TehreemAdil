.text
.globl main
main:
    # --- TEST VALUES (Set a = 3, b = 3) ---
    li   x5, 3           # a = 3 (Outer loop runs 3 times)
    li   x6, 2          # b = 3 (Inner loop runs 3 times per outer loop)
    li   x10, 0x200      # Base address of array D = 0x200
    # --------------------------------------

    li   x7, 0           # i = 0

outerloop:
    bge  x7, x5, endouter    # Exit outer loop if i >= 3
    li   x29, 0              # j = 0

innerloop:
    bge  x29, x6, endinner   # Exit inner loop if j >= 3

    add  t0, x7, x29         # t0 = i + j
    slli t1, x29, 4          # t1 = j * 16 (byte offset for index 4*j)
    add  t2, x10, t1         # t2 = &D[4*j]
    sw   t0, 0(t2)           # D[4*j] = i + j

    addi x29, x29, 1         # j++
    j    innerloop

endinner:
    addi x7, x7, 1           # i++
    j    outerloop

endouter:
end:
    j    end                 # Program trap