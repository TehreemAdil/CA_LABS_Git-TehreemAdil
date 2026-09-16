.text
.globl main
main:
  
    li   x20, 1          # Set x = 1 
    li   x22, 20         # Set b = 20
    li   x23, 10         # Set c = 10

    #
    li   t0, 1
    beq  x20, t0, case1
    li   t0, 2
    beq  x20, t0, case2
    li   t0, 3
    beq  x20, t0, case3
    li   t0, 4
    beq  x20, t0, case4
    j    defaultcase


case1:
    add  x21, x22, x23   # a = b + c
    j    endswitch

case2:
    sub  x21, x22, x23   # a = b - c
    j    endswitch

case3:
    slli x21, x22, 1     # a = b * 2 
    j    endswitch

case4:
    srai x21, x22, 1     # a = b / 2 

defaultcase:
    li   x21, 0          # a = 0

endswitch:
end:
    j    end           