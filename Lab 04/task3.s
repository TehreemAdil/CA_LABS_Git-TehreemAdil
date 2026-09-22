.data
# Define an unsorted array of 8 integers in memory
my_array: .word 3, 1, 4, 1, 5, 9, 2, 6 

.text
.globl main

main:
    # Load the base memory address of my_array into x10
    la   x10, my_array
    
    # Load the length of the array 8 into x11
    addi x11, x0, 8
    

    jal  x1, bubble


end:
    j    end

bubble:
    # if (a == NULL || len == 0) return;
    beq  x10, x0, end_bubble  
    beq  x11, x0, end_bubble  

    addi x5, x0, 0            # int i = 0

outer_loop:
    bge  x5, x11, end_bubble  # for (int i = 0; i < len; i++)

    add  x6, x0, x5           # int j = i

inner_loop:
    bge  x6, x11, end_inner   # for (int j = i; j < len; j++)

    # Calculate address of a[i]
    slli x7, x5, 2            # Multiply i by 4 (bytes per int)
    add  x7, x10, x7          # add base address a + (i * 4)
    lw   x28, 0(x7)           # load a[i] into x28

    # Calculate address of a[j]
    slli x29, x6, 2           # Multiply j by 4
    add  x29, x10, x29        # add base address a + (j * 4)
    lw   x30, 0(x29)          # load a[j] into x30

    # (if (a[i] < a[j]))
    bge  x28, x30, skip_swap  # If a[i] >= a[j], skip the swap

    # Swap logic
    sw   x30, 0(x7)           # Store a[j] value into a[i] address
    sw   x28, 0(x29)          # Store old a[i] value into a[j] address

skip_swap:
    addi x6, x6, 1            # j++
    j    inner_loop

end_inner:
    addi x5, x5, 1            # i++
    j    outer_loop

end_bubble:
    jalr x0, 0(x1)            # return