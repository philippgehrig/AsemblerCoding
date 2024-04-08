# Start with data declarations
#
.data 
str1: .asciz "Enter Component A: "
str2: .asciz "Enter Component B: "
str3: .asciz "Result is "
str4: .asciz " Done [0 = Yes, 1 = No]: "
newline: .asciz "\n"  	# move the cursor to a new line
result: .word  32

.globl main			
.text			
main: 
	la a0, str1	# load string address into a0 and I/O code into a7     
	li a7, 4		      
	ecall  		# execute the syscall to perform input/output via the console        

	li a7, 5	# an I/O sequence to read an integer from the console window
	ecall 
	mv t0, a0	# place the value read into register t0

	la a0, str2	# Load address of string 2 into register $a0
	li a7, 4	# Load I/O code to print string to console
	ecall		# print string

	li a7, 5	# an I/O sequence to read an integer from the console 	
	ecall 
	mv t1, a0	# place the value read into register t1


	# t0 = A
	# t1 = B
	
    	li t2, -1      	# Initialisierung res =-1
    	add t3, t0, t1	# t3 = A + B
	mul t3, t3, t3	# t3 = (a+b)^2
	add t2, t2, t3	# t2 = res + (a+b)^2
	sub t4, t0, t1	# t4 = A - B
	div t2, t2, t4	# t2 = (res + (a+b)^2) / (a-b)
	
	sw t2, result, t3	# store t2 in result

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
    	# Schleife zur Berechnung der Potenz


