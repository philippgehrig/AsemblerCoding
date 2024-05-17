# Deklaration von Daten:
.data 
A:	.float 5.0,2.0,1.0,-1.5,10.0,2.5,-4.5,-3.0,0.0,8.0,-4.0,7.5,0.5,2.0,-8.0,-10.0
str1: 	.asciz "Zahlenfolge: "
blank: 	.asciz " "  		# Leerzeichen auf Konsole

# Code:
.globl main		
.text					    	
main:	la a0, A
		li a1, 16	
		jal ra, bubblesort
		
		la a0, A
		li a1, 16
		jal ra, printarray

		li a7, 10		# Code 10 terminiert das Programm
		ecall
		
# A in a0, n in a1
printarray:
		mv t2, a0		# Retten von &A[0] in t2
		la a0, str1		# Laden Adresse von str1 nach a0     
		li a7, 4		      
		ecall  			# Ausgabe des Strings str1 auf Konsole     		
		
		li t0, 0		# Schleifenvariable i für Ausgabe von A{i]		
loop0:	beq t0,a1,bye	# fertig, wenn i=a1
		li a7, 2		# gebe A[i] auf Konsole aus
		flw fa0,0(t2) 
		ecall		
		la a0, blank	# gebe Leerzeichen auf Konsole aus
		li a7, 4
		ecall
		addi t2, t2, 4	# Zeiger auf A[i+1] setzen
		addi t0, t0, 1	# i=i+1
		j loop0
bye:	jr ra

# A in a0, n in a1, i in t0, j in t1
bubblesort:
		mv t1,a1		# j=n
		li t2,1			# t2=1
loop1:	beq t1,t2,ende1	# if j = 1 goto ende1
		li t0,0			# i=0
		sub t3,t1,t2	# j-1 nach t3
loop2:	beq t0,t3,ende2	# if i = (j-1) goto ende2
		slli t4,t0,2	# 4*i in t4
		add t4,t4,a0	# &A[i] in t4
		flw ft0, 0(t4)	# load A[i]
		flw ft1, 4(t4)	# load A[i+1]
		fle.s t5,ft0,ft1
		bnez t5,cont
		fsw ft0, 4(t4) 	# store A[i+1]
		fsw ft1, 0(t4)	# store A[i]		
cont:	addi t0,t0,1	# i++
		j loop2
ende2:	addi t1,t1,-1	# j--
		j loop1
ende1:	jr ra