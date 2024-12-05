.global gen_fib_seq

.text

# t0 - u_(n+1) term
# t1 - u_(n) term
# t2 - u_(n-1) term
# t3 - counter
# t4 - intermediate storage

# inputs : a0 and a1
# a0 - pointer to the array declared in C
# a1 - size of the array
# outputs :
# nothing

gen_fib_seq :

	addi sp, sp, -4
	sw ra, 0(sp)

	#on défini les variables de base
	li t0, 1
	li t1, 1
	li t2, 0

	# set the counter
	li t3, 1

	# store x0 as the first element of the array
	sw x0,0(a0)
	addi a0, a0, 4

	boucle : 
		sw t0,0(a0)

		mv t4, t0
		add t0, t1, t2
		mv t2, t1
		mv t1, t4

		addi a0, a0, 4
		addi t3, t3, 1

		beq t3, a1, end
		j boucle
		
	end :
	addi sp, sp, 4
	jalr ra
	
