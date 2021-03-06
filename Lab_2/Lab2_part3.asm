.data

varZ: .word 2
vari: .word 0 #no value in c but assign 0 in riscv

.text

main:
	lw ra, varZ 
	lw sp, vari
#for loop
for: 	slti s11, sp, 21 #this is the for loop run condition: if i < 21, s11 (treat as boolean for runnning a loop) is 1
	beq s11, zero, outLoop #check if s11 was set to 0. If so, exit loop
	addi sp, sp, 2 #every loop, increase i+2
	addi ra, ra, 1 # increase z by one every loop
	j for #go back to start of loop
	
outLoop: #exiting loop (no need to do anything so no code is here

#set up do while
doWhile:
	addi ra, ra, 1 #increase z every loop by 1
	slti s11, ra, 100 #run while until z == 100
	beq s11, zero, leaveDo #if condition is fulfilled, exit do while
	j doWhile #go back to start of the loop
leaveDo: #again, nothing to do after loop ends

#set up while loop
while:	slt s11, zero, sp #until i=0, run the while
	beq s11, zero, leaveWhile
	addi ra, ra, -1 #z-1
	addi sp, sp, -1 #i-1
	j while #back to start
leaveWhile:
	sw ra, varZ, t6 #store the final val of z
	