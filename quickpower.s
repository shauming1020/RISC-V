.data
x: .word 3
y: .word 5				# unsigned
str1: .string " ^ "
str2: .string " = "

.text
main:
	lw s0, x			# Set s0 equal to the parameter x
	lw s1, y			# Set s1 equal to the parameter y
	mv a0, s0			# Set arguments
	mv a1, s1
	jal power			# return the result a0
	mv s2, a0			# Set s2 equal to the result
	j print
power:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	mv s0, a0			# s0 -> parameter x
	mv s1, a1			# s1 -> parameter y
	li s2, 1			# s2 -> res, init = 1
loop:
	bge x0, s1, Ret		# if (0 >= y) break
	andi t0, s1, 0x1	# t0 -> y & 0x1
	li t1, 0x1			# t1 -> 0x1
	li ra, 0x54			# Set ra equal to srli s1, s1, 1
	beq t0, t1, odd		# y is odd
	srli s1, s1, 1		# y_u >> 1, y /= 2
	mul s0, s0, s0		# x = x * x
	j loop				# goto loop
odd:
	mul s2, s2, s0		# res = res * x
	jr ra				# goto srli s1, s1, 1
Ret:
	mv a0, s2			# Set return reg a0 
	lw ra, 0(sp)		# Restore ra
	lw s0, 4(sp)		# Restore s0
	lw s1, 8(sp)		# Restore s1
	addi sp, sp, 12		# Free space on the stack for the 3 words
	jr ra				# Return to the caller
print:
	mv t0, a0			# Set tmp equal to a0
	mv a0, s0			# prepare to print x
	li a7, 1			# print int
	ecall
	la a0, str1			# prepare to print string ^ 
	li a7, 4			# print string
 	ecall
	mv a0, s1			# prepare to print y
	li a7, 1			# print int
	ecall
	la a0, str2			# prepare to print string =
	li a7, 4 			# print string
	ecall
	mv a0, s2			# prepare to print result
	li a7, 1			# print int
	ecall
