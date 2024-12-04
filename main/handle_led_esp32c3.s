.global gpio_set_state  
.global gpio_blink_led

.type gpio_set_state, @function
.type gpio_blink_led, @function

.text

# registre set GPIO : 0x0008 (use 1 to set bit)
# registre reset GPIO : 0x000c (use 1 to reset bit)
# pin LED RGB ESP32-C3 : GPIO8


gpio_set_state:

	li a1, 0

	addi sp, sp, -4
	sw ra, 0(sp)
	# write in register
	
	ble a0, a1, turn_on
	
	#turn off
	#on met à 1 le bit led dans le registre reset (s'il est à 1 on le laisse)
	li a2, 0x000C
	lw a1, 0(a2)
	ori a1, a1, 0x100 
	sw a1, 0(a2)
	
	#on met à 0 le bit led dans le registre SET
	li a2, 0x0008
	lw a1, 0(a2)
	andi a1, a1, 0xeff
	sw a1, 0(a2)
	
	j end
	
	#turn on
	turn_on :
	#on met à 1 le bit led dans le registre SET
	li a2, 0x0008
	lw a1, 0(a2)
	ori a1, a1, 0x100
	sw a1, 0(a2)
	
	#on met à 0 le bit led dans le registre reset
	li a2, 0x000C
	lw a1, 0(a2)
	andi a1, a1, 0xeff
	sw a1, 0(a2)
	
	j end
	
	#end
	end:
	addi sp, sp, 4
	jalr ra
	





gpio_blink_led :
	#code avec protection (inutile ?) des valeurs via le stack.

	addi sp, sp, -12
	# dans sp+8 : ra
	sw ra, 8(sp)

	# dans sp+4 : valeur du terme actuel de la suite de Fibonacci 
	sw a0, 4(sp)
	# dans sp+0 : compteur de boucle
	sw 0, 0(sp)

	li a0, 0
	jal ra, gpio_set_state

	boucle :

		lw t1, 0(sp)
		addi t1, t1, 1
		sw t1, 0(sp)

		li a0, 1
		jal ra, gpio_set_state
		li a0, 0
		jal ra, gpio_set_state

		lw t1, 4(sp)
		lw t0, 0(sp)

		ge t0, t1, end
		j boucle

	end :
	lw ra, 8(sp)
	addi sp, sp, 12
	jalr ra

