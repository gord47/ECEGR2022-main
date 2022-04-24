.data

varA: .word 15
varB: .word 15
varC: .word 10
varZ: .word 0

.text

main:
	lw a0, varA
	lw a1, varB
	lw a2, varC
	lw a3, varZ
	
	addi ra, zero, 5 #setting constant comparison
	
	#compare statements
	slt t0, a0, a1 #varA < varB
	slt t1, ra, a2 #5 < varC
	and s0, t0, t1 #and-ing the two comparison statements
	
	#if statement
	beq s0, zero, ElseIf #if both statements are true
	addi a3, zero, 1 #setting varZ to 1
	j Exit #exit out of if statement
	
	#if condition not fulfilled, check if c+1 == 7
ElseIf: slt s1, a1, a0 #conditional varB < varA stored in s1
	addi t5, a2, 1 #varC + 1
	addi t5, t5, -7 #t5 = t5-7 (shift the eq c+1 == 7 to (c+1)-7 == 0
	#Run TrueCheck if either of the statements are true
	beq a2, zero, TrueCheck #check if (c+1)-7 == 0
	bne s1, zero, TrueCheck #verifies if s1 comparator is true
	
	#else
	addi a3, zero, 3 #varZ = 3
	j Exit #leave this else if/else 
	
TrueCheck: addi a3, zero, 2 #sets varZ to 2
	j Exit
	
Exit: 	#set up case value for Z
	addi sp, zero, 1
	addi gp, zero, 2
	addi tp, zero, 3
	#case statements
	beq a3, sp, case1 #varZ == 1
	beq a3, gp, case2 #varZ == 2
	beq a3, tp, case3 #varZ == 3
	addi a3, zero, 0 #default case
	j allDone

case1:	addi a3, zero, -1
	j allDone
case2:	addi a3, zero, -2
	j allDone
case3:	addi a3, zero, -3
	j allDone
allDone:sw a3, varZ, t6 #store the final value into the word varZ

#End
	