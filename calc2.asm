# Start with data declarations
#
.data 
str1: .asciz "Enter Component A: "
str2: .asciz "Enter Component B: "
str3: .asciz "Result is "
str4: .asciz "Division by Zero is not allowed"
str5: .asciz " Done [0 = Yes, 1 = No]: "
newline: .asciz "\n"  	# move the cursor to a new line

.globl main			
.text			
main: 
	la a0, str1	# load string address into a0 and I/O code into a7     
	li a7, 4		      
	ecall  		# execute the syscall to perform input/output via the console        

	li a7, 5	# an I/O sequence to read an integer from the console window
	ecall 
	mv s0, a0	# place the value read into register t0

	la a0, str2	# Load address of string 2 into register $a0
	li a7, 4	# Load I/O code to print string to console
	ecall		# print string

	li a7, 5	# an I/O sequence to read an integer from the console 	
	ecall 
	mv s1, a0	# place the value read into register t1


	mv t0, s0
	mv t1, s1
	
	jal ra, calc2	# initalize loop
	mv s0, a0	# save result

	la a0, str3	# Load address of string 3 into register $a0
	li a7, 4	# Load I/O code to print string to console
	ecall		# print string

	li a7, 1	# an I/O sequence to print an integer to the console window
	mv a0, t2	
	ecall 

	la a0, newline	# print the new line character to force a carriage return 
	li a7, 4	# on the console
	ecall 

	la a0, str4	# Load address of string 5 into register a0
	li a7, 4	# Load I/O code to print string to console
	ecall		# print string

	li a7, 5	# an I/O sequence to read an integer from the console
	ecall 

	bne a0,zero,main	# if not complete (i.e., you provided 0) then start at 
				# the beginning

	li a7, 10	# syscall code 10 for terminating the program
	ecall

calc2:
	# t0 = A
	# t1 = B
	addi sp, sp, -8
	sw ra, 0(sp)		# save ra
	sw a0, 4(sp)		
	
	mv t0, a0		# a nach t0
	mv t1, a1		# b nach t1
	li a0, -1		# res = -1
	sw, a0, 4(sp)		# stores res on stack
	
	li a0, -1
	
	add t2, t0, t1		# t2 = a + b
	mul t2, t2, t2,		#
	add t2, a0, t2		# t2 = res + (a+b)^2 i
	
	sub t3, t0, t1		# t3 = a-b
	
	mv a0, t2		# Dividend
	mv a1, t3		# Divisor
	
	jal ra, saveDiv		# jump to div
	
	lw ra, 4(sp)		# restore ra
	addi sp, sp , 8		# free space from stack
	jr ra

	
# a0 = Dividend, a1 = Divisor		
				
saveDiv:
	beqz a1, error		# Trhow error when Divisor is = 0
	div a0, a0, a1		# Divide Dividend / Divisot with Result in a0
	jr ra

error:
	mv t0, a0		# Save Dividend
	la a0, str4
	li a7, 4
	ecall
	# in case of division by zero return +- inf (in our case maxint or minint)
	
	blt t0, zero, neg
	li a0, 0x7FFFFFFF 	# return max int
	j end
neg:
	li a0, 0x80000000	# return min int	
	
end:
	jr ra
		

