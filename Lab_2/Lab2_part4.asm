.data
A: .word 0,0,0,0,0 #5 element array, set no value in each
B: .word 1, 2, 4, 8, 16 #array

.text

main:
	la t0, A #load address of array A into t0
	la t1, B #load address of B into t1
	
	addi s0, zero, 0 # i = 0
	addi gp, zero, 4 #gp holds value of 4 (need this to get bit address of the array
	
#for loop
for:	slti s11, s0, 5 #run until i == 5
	beq s11, zero,leaveLoop
	mul s1, s0, gp #multiply i by 4, store in s1 (for array B)
	mul s2, s0, gp #for array A
	add s1,t1,s1 #address for B[i]
	add s2, t0, s2 #A[i] address
	lw a0, 0(s1) #get val from B[i]
	addi a0, a0 -1 #subtract that value by 1
	sw a0, 0(s2) #store that value into a[i]
	addi, s0, s0, 1 #increase i+1
	j for #back to loop beginning
	
leaveLoop:
	addi s0, s0, -1 #i--
	addi s5, zero, -1
	
while:	beq s0, s5, leaveWhile #run while until i == 0
	mul s1, s0, gp 
	mul s2, s0, gp
	add s1, t1, s1
	add s2, t0, s2
	lw a1, 0(s1)
	lw a2, 0(s2)
	add a3, a1, a2 #A[i] + B[i]
	addi a4, zero, 2
	mul a3, a3, a4 #a3*2
	sw a3, 0(s2)
	addi s0, s0, -1 #i--
	j while
leaveWhile:
	li a7,10
	ecall
	
