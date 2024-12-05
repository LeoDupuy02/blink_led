.global blink_led
.global init_led  

.text

# general properties :
# clock esp32c3 - @80MHz
# base GPIO : 0x60004000
# base IO MUX : 0x60009000


# a2 - register
# t1 - value to load in the register

# configure pin 8 as an output
# no inputs neither ouptus
init_led :

	addi sp, sp, -4
	sw ra, 0(sp)

	# Register : GPIO_FUNCn_OUT_SEL_CFG_REG (n: 0-21) (0x0554+4*n) : valeur sur 128 + 9ème bit sur 1
	li a2, 0x60004574
    lw t1, 0(a2)
    ori t1, t1, 0x0280
    sw t1, 0(a2)

	li t5, 0xffff0084

	# Register : IO_MUX_GPIO8_Reg (0x0004+4*8) : CONFIG MUX
	li a2, 0x60009024
    lw t1, 0(a2)
	ori t1, t1, 0x00000084
	and t1, t1, t5
    sw t1, 0(a2)

	# Register : GPIO_ENABLE_W1TS_REG (0x0024) : SET ENABLE
	li a2, 0x60004024
    lw t1, 0(a2)
    ori t1, t1, 0x0100
    sw t1, 0(a2)

	# Register : GPIO_OUT_W1TC_REG (0x000c) : RESET OUT
	li a2, 0x6000400c
	lw t1, 0(a2)
	ori t1, t1, 0x0100
	sw t1, 0(a2)

	addi sp, sp, 4
	jalr ra




# a2 - adress of the register
# t1 - value to load in the register

# input : 
# a0 - number of times that the pin must turn on and off
# output :
# nothing
blink_led :

	addi sp, sp, -8
	sw ra, 4(sp)
	sw a0, 0(sp)

	# Check if a0 is 0. If yes add 1s delay and return
	beq a0, x0, pause

	# Loop to make the pin blink a0 times
	loop :
		addi a0, a0, -1

		# Register 5.4. GPIO_OUT_W1TC_REG (0x0008) : SET OUT
		li a2, 0x60004008
		lw t1, 0(a2)
		ori t1, t1, 0x0100
		sw t1, 0(a2)

		# delay loop (approx 1s)
		li t0, 27000000
		delay_loop1:
			addi t0, t0, -1
			bnez t0, delay_loop1

		# Register 5.4. GPIO_OUT_W1TC_REG (0x000c) : RESET OUT
		li a2, 0x6000400c
		lw t1, 0(a2)
		ori t1, t1, 0x0100
		sw t1, 0(a2)

		# delay loop (approx 1s)
		li t0, 27000000
		delay_loop2:
			addi t0, t0, -1
			bnez t0, delay_loop2

		beq a0, x0, end
		j loop 

	pause :
	li t0, 27000000
	delay_loop_pause:
		addi t0, t0, -1 
		bnez t0, delay_loop_pause
	
	end :
	lw a0, 0(sp)
	addi sp, sp, 8
	jalr ra

