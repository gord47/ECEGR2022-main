.data
Kconst: .float 273.15
getval: .asciz "Enter the temp (in F): "
Cres: .asciz "The temp in C is: "
Kres: .asciz "The temp in K is: "
newl: .asciz "\r\n"

.text

main: 	li a7, 4
	la a0, getval
	ecall
	
	li a7, 6
	ecall
	
	fmv.x.s a0, fa0
	jal FtoC
	
	fmv.s.x fs0, a1
	
	mv a0, a1
	jal CtoK
	
	fmv.s.x fs1, a1
	li a7, 10
	ecall
FtoC:
	addi t0, zero, 32
	fcvt.s.w ft0, t0
	addi t0, zero,9
	fcvt.s.w ft1, t0
	addi t0, zero, 5
	fcvt.s.w ft2, t0
	
	fmv.s.x fa0, a0	#Store the input into a float val
	fsub.s fa0, fa0, ft0
	fmul.s fa0, fa0, ft1
	fdiv.s fa0, fa0, ft2
	
	li a7, 4
	la a0, Cres
	ecall
	
	li a7, 2
	ecall
	
	li a7, 4
	la a0, newl
	ecall
	
	fmv.x.s a1, fa0
	ret
	
	
CtoK:
	flw ft0, Kconst, t0
	fmv.s.x fa0, a0
	fadd.s fa0, fa0, ft0
	
	li a7, 4
	la a0, Kres
	ecall
	
	li a7, 2
	ecall
	
	li a7, 4
	la a0, newl
	ecall
	
	fmv.x.s a1, fa0
	ret
	