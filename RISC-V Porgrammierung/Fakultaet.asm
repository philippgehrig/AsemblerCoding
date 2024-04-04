Main:	li a0,3
	jal ra, fact
	mv s0, a0
	
fact:	add t1, zero, a0
	mv t0, a0
	addi t4, zero, 1
Loop:	beq, t0, t4, Ende
	mul t1, t1, t0
	addi t0, t0, -1
	j Loop
Ende: 	mv a0, t1
	jr ra
