.global turn_on_led   
.global init_led  

.text

# clock @80MHz

init_led :

	addi sp, sp, -4
	sw ra, 0(sp)

	# Register : GPIO_FUNCn_OUT_SEL_CFG_REG (n: 0-21) (0x0554+4*n) : valeur sur 128 + 9ème bit sur 1
	li a2, 0x60004574
    lw t1, 0(a2)
    ori t1, t1, 0x0280
    sw t1, 0(a2)

	li t5, 0xffff0084

	# Register : IO_MUX_GPIO8_Reg (0x0004+4*8)
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

	# turn off pin 8
	li a2, 0x6000400c
	lw t1, 0(a2)
	ori t1, t1, 0x0100
	sw t1, 0(a2)

	addi sp, sp, 4
	jalr ra




turn_on_led :

	addi sp, sp, -4
	sw ra, 0(sp)

	add t4, a0, x0
	beq t4, x0, pause

	boucle :
		addi t4, t4, -1

		# Register 5.4. GPIO_OUT_W1TC_REG (0x0008) : RESET OUT
		li a2, 0x60004008
		lw t1, 0(a2)
		ori t1, t1, 0x0100
		sw t1, 0(a2)

		li t0, 27000000       # Charger une grande valeur dans le registre t0 (le nombre d'itérations)
		delay_loop1:
			addi t0, t0, -1      # Décrémenter t0
			bnez t0, delay_loop1  # Boucler jusqu'à ce que t0 atteigne zéro

		li a2, 0x6000400c
		lw t1, 0(a2)
		ori t1, t1, 0x0100
		sw t1, 0(a2)

		li t0, 27000000       # Charger une grande valeur dans le registre t0 (le nombre d'itérations)
		delay_loop2:
			addi t0, t0, -1      # Décrémenter t0
			bnez t0, delay_loop2  # Boucler jusqu'à ce que t0 atteigne zéro

		beq t4, x0, end
		j boucle 

	pause :
	li t0, 27000000       # Charger une grande valeur dans le registre t0 (le nombre d'itérations)
	delay_loop_pause:
		addi t0, t0, -1      # Décrémenter t0
		bnez t0, delay_loop_pause  # Boucler jusqu'à ce que t0 atteigne zéro
	
	end :
	addi sp, sp, 4
	jalr ra

