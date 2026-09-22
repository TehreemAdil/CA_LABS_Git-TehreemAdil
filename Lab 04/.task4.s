.globl main
.text

.data
# A sorted array of 8 integers
my_array: .word 2, 4, 6, 8, 10, 12, 14, 16

main:
    la   x10, my_array      # Base address of the array
    addi x11, x0, 0         # Left index = 0
    addi x12, x0, 7         # Right index = 7
    addi x13, x0, 10        # Target number to find = 10

    
    jal  x1, bin_search

    
end:
    j   end               

bin_search:
    # Base Case 
    # (if (left > right), the number isn't here. Return -1.)
    bgt  x11, x12, not_found

    # Allocate 8 bytes on the stack
    addi sp, sp, -8
    sw   x1, 4(sp)          # Save return address 
    sw   x18, 0(sp)         # Save s2 mid variable

    # Calculate mid = (left + right) / 2
    add  x18, x11, x12
    srli x18, x18, 1

    # Load the value at my_array[mid]
    slli x5, x18, 2         # Multiply mid by 4 (bytes per word)
    add  x5, x10, x5        # Add offset to array base address
    lw   x6, 0(x5)          # x6 = array[mid]

    beq  x6, x13, found         # if (array[mid] == target), found 
    bgt  x6, x13, search_left   # if (array[mid] > target), search the left half

search_right:
    addi x11, x18, 1        # left = mid + 1
    jal  x1, bin_search     
    j    bs_end

search_left:
    addi x12, x18, -1       # right = mid - 1
    jal  x1, bin_search    
    j    bs_end

found:
    add  x10, x0, x18       # Set return value to the mid index
    j    bs_end

not_found:
    addi x10, x0, -1        # Set return value to -1
    jalr x0, 0(x1)          # Immediate return for base case

bs_end:

    # Restore the saved registers
    lw   x18, 0(sp)
    lw   x1, 4(sp)
    addi sp, sp, 8          # Deallocate stack 
    
    jalr x0, 0(x1)         

