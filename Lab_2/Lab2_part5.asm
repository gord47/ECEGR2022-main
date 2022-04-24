.data
A: .word 0
B: .word 0
C: .word 0

.text

main:
	addi t0, zero, 5 #i
	addi t1, zero, 10 #j
	
	addi sp, sp, -8
	#save values of i and j
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	add a0, zero, t0 #set a0 to i(5)
	jal addItUp #call addItUp for i
	sw t1, A, s0 #store return value in A (t1 stores the x value in the addItUp function)
	
	lw t1, 0(sp) #set t1 back to j
	add a0, zero, t1 #set a0 to j
	jal addItUp #call addItUp for j
	sw t1, B, s0 #store return value to B
	
	addi sp, sp, 8
	
	lw t0, A #get value from A
	lw t1, B #get value from B
	add t2, t0, t1 #add a and B and put into t2 register
	sw t2, C, s0 #store val in C
	
	li a7, 10	#exit call
	ecall
	
addItUp:
	add t0, zero, zero #i = 0
	add t1, zero, zero #x = 0
	
for:	slt t6, t0, a0
	beq t6, zero, leaveLoop
	addi t2, t0, 1 #i+1
	add t1, t1, t2 #x+i+1, put in x (t1)
	addi t0, t0, 1 #i++
	j for
	
leaveLoop:
	ret