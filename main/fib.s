.global suite_fibo

.text

suite_fibo :

	addi sp, sp, -4
	sw ra, 0(sp)

	#on défini les variables de base
	li t0, 0
	li t1, 1
	li t2, 0

	#le compteur
	li t3, 0

	boucle : 
		sw t0,0(a0)

		mv t4, t0
		add t0, t1, t2
		mv t2, t1
		mv t1, t4

		# increment tab adress and counter
		addi a0, a0, 4
		addi t3, t3, 1

		beq t3, a1, end
		j boucle

	
	end :
	addi sp, sp, 4
	jalr ra
	
