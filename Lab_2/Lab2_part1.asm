.data
varZ:	.word 0

.text

main:
	addi a0, zero, 15
	addi a1, zero, 10
	addi a2, zero, 5
	addi a3, zero, 2
	addi a4, zero, 18
	addi a5, zero, -3
	
	sub t0, a0, a1
	mul t1, a2, a3
	sub t2, a4, a5
	div t3, a0, a2
	
	add t0, t0, t1
	add t0, t0, t2
	sub t0, t0, t3
	
	sw t0, varZ, t4
	