.global read_pin

# le bouton est sur le pin GPIO6
# GPIO IN : 0x003C

read_pin :
    li t4, 64

    addi sp, sp, -4
    sw ra, 0(sp)

    # set gpio_mux_gpio6_reg : input enable, pull-up
    li a2, 0x6000901c
    lw t1, 0(a2)
    ori t1, t1, 0x0308
    sw t1, 0(a2)

    # read gpio_in_reg
    li a1, 0x6000403c
    lw t1, 0(a1)
    andi t1, t1, 0x00000040
    div a0, t1, t4

    addi sp, sp, +4
    jalr ra


    