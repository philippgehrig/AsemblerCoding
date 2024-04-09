# Argumente: a in s0, b in s1
# Rückgabewert: res in s2
.data
str1: .asciz "Enter a: "
str2: .asciz "Enter b: "
str3: .asciz "Result is "
error_message: .asciz "Division by zero error!\n"
.text
.globl main

main:
    # Prompt for a
    la a0, str1
    li a7, 4
    ecall

    # Read a from console
    li a7, 5
    ecall
    mv s0, a0

    # Prompt for b
    la a0, str2
    li a7, 4
    ecall

    # Read b from console
    li a7, 5
    ecall
    mv s1, a0

    # Funktionsaufruf von calc2
    mv a0, s0		#a0=a
    mv a1, s1		#a1=b
    jal ra, calc2
    mv s0, a0		#save result

    # Ergebnis von calc2 in s2 ausgeben
    la a0, str3
    li a7, 4
    ecall

    mv a0, s0
    li a7, 1    # Systemaufrufcode für Ausgabe eines Integer
    ecall

    # Endprogramm
    li a7, 10   # Systemaufrufcode für Programmende
    ecall
    
calc2:
    # Rahmen aufbauen
    addi sp, sp, -8       # Platz für 2 lokale Variablen reservieren
    sw ra, 4(sp)          # Rückkehradresse speichern
    

    mv t0, a0		#a in t0
    mv t1, a1		#b in t1
    li a0, -1           # res = -1
   
    sw a0, 0(sp)	#res auf dem Stack speichern

    # Berechnung: res = (res + (a + b)^2) / (a - b)
    add t2, t0, t1	# a + b
    mul t2, t2, t2	# (a + b)^2
    add t2, a0, t2	# res + (a + b)^2 in t2
    sub t3, t0, t1	#(a-b)

    # safe division call
    mv a0, t2		#divident
    mv a1, t3		#divisor
    jal ra, safediv
    sw a0, 0(sp)	#res auf dem Stack speichern

    lw ra, 4(sp)          # Rückkehradresse wiederherstellen
    addi sp, sp, 8        # Rahmen vom Stapel entfernen
    jr ra

#a0: dividend, a1: divisor
safediv:
    beqz a1, division_by_zero   # Wenn a1=0, gehe zu division_by_zero

    # Division durchführen
    div a0, a0, a1		#res = dividend/divisor
    jr ra

division_by_zero:
    mv t0, a0	#save dividend
    # Fehlermeldung ausgeben
    la a0, error_message
    li a7, 4       # Systemaufrufcode für Ausgabe von Strings
    ecall
    
    #maxint = 2^31 - 1 = 0x7FFF FFFF
    #minint = -2^31 = 0x8000 0000
    blt t0, zero, max_negative
    li a0, 0x7FFFFFFF	#return maxint
    j cont
	

    
max_negative:
    li a0, 0x80000000	#minint = -2^31 = 0x8000 0000
 
cont:
    jr ra
    
    

