.global blink_led
.global init_led 
.global new_term

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




# t1 - adress of the u_n value
# t2 - adress of the u_n-1 value
# t4 - adress of the u_n+1 value

# input : 
# a0 - pointer pointing to tab
# a1 - position of the new element of the array
# output :
# nothing
new_term :

	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)

	# a_0 and a_1 terms
	beq a1, x0, first_term
	li t1, 1
	beq a1, t1, second_term

	# get adresses of u_n+1, u_n, u_n-1
	li t5, 4
	mul t1, a1, t5
	mul t2, a1, t5
	add t4, a0, t2
	addi t1, t1, -4
	add t1, a0, t1
	addi t2, t2, -8
	add t2, a0, t2

	# get and store u_n+1 value
	lw t1, 0(t1)
	lw t2, 0(t2)
	add a0, t1, t2
	sw a0, 0(t4)
	
	# make the led blink a0 times
	j blink_led

	first_term :
		sw x0, 0(a0)
		li a0, 0
		j pause

	second_term :
		li t1, 1
		sw t1, 4(a0)
		li a0, 1
		j blink_led

	blink_led :

		# Loop to make the pin blink a0 times
		loop :

			addi a0, a0, -1

			# Register 5.4. GPIO_OUT_W1TC_REG (0x0008) : SET OUT
			li a2, 0x60004008
			lw a1, 0(a2)
			ori a1, a1, 0x0100
			sw a1, 0(a2)

			# delay loop (approx 1s)
			li t0, 27000000
			delay_loop1:
				addi t0, t0, -1
				bnez t0, delay_loop1

			# Register 5.4. GPIO_OUT_W1TC_REG (0x000c) : RESET OUT
			li a2, 0x6000400c
			lw a1, 0(a2)
			ori a1, a1, 0x0100
			sw a1, 0(a2)

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
		j end

	end :
		lw ra, 0(sp)
		lw a0, 4(sp)
		lw a1, 8(sp)
		addi sp, sp, 8
		jalr ra	