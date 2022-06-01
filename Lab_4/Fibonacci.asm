.data
intA: .word 3
intB: .word 10
intC: .word 20

.text
main:
	lw t0, intA
	lw t1, intB
	lw t2, intC
	addi s1, zero, 1
	
	add a2, zero, t0
	jal Fibonacci
	add t0, zero, a0
	
	add a2, zero, t1
	jal Fibonacci
	add t1, zero, a0
	
	add a2, zero, t2
	jal Fibonacci
	add t2, zero, a0
	
	li, a7, 10
	ecall
Fibonacci:
	bge zero, a2, ifless
	beq s1, a2, ifone
	

	addi sp, sp, -8
	sw ra, 0(sp) #return val
	sw a2, 4(sp) #input val (n)
	
	addi a2, a2, -1 #Fibonacci(n-1)
	
	jal Fibonacci

	add a4, zero, a0
	
	
	lw ra, 0(sp)
	lw a2, 4(sp)
	addi sp, sp, 8
	
	
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a2, 4(sp)
	sw a4, 8(sp)
	
	addi a2, a2, -2 #Fibonacci(n-2)
	jal Fibonacci
	
	add a5, zero, a0
	
	lw ra, 0(sp)
	lw a2, 4(sp)
	lw a4, 8(sp)
	addi sp, sp, 12
	
	add a0, a4, a5
	
	jr ra
ifless:
	add a0, zero, zero
	jr ra
ifone:
	addi a0, zero, 1
	jr ra