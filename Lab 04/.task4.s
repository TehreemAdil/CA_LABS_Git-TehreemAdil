.globl main

.text
main:
    la   x10, my_array      # Base address
    addi x11, x0, 0         # Left index = 0
    addi x12, x0, 7         # Right index = 7
    addi x13, x0, 10        # Target = 10

    jal  x1, bin_search

end:
    j    end

bin_search:
    addi sp, sp, -8
    sw   x1, 4(sp)
    sw   x18, 0(sp)

    bgt  x11, x12, not_found

    add  x18, x11, x12
    srli x18, x18, 1

    slli x5, x18, 2
    add  x5, x10, x5
    lw   x6, 0(x5)

    beq  x6, x13, found
    bgt  x6, x13, search_left

search_right:
    addi x11, x18, 1
    jal  x1, bin_search
    j    bs_end

search_left:
    addi x12, x18, -1
    jal  x1, bin_search
    j    bs_end

found:
    add  x10, x0, x18
    j    bs_end

not_found:
    addi x10, x0, -1

bs_end:
    lw   x18, 0(sp)
    lw   x1, 4(sp)
    addi sp, sp, 8
    
    jalr x0, 0(x1)

.data
my_array: .word 1, 2, 3, 4, 5, 10, 15, 20