.data
	lol: .asciiz "1023"
	newline: .asciiz "\n"
	prompt: "Input any decimal number:  "
.text
main:
	li $t7, 1
	
	la $a0, prompt
	li $v0, 4
	syscall
	
	move $t0, $a0		#t0 holds temp value of a0
	li $a1, 5		# temporarily using this to input from console
	li $v0, 8		#
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	move $a0, $t0
	#la $a0, lol
	jal decToBin
	add $a0, $v0, $zero
	add $s0, $v0, $zero
	#li $v0, 1
	#syscall
	jal to_binary
	
	li $s2, 16		# These two find the remaining amount of 0's in the immediate
	sub $t5, $s2, $t5	
	
	jal bin_fill
	jal recall_binary
	
	li $v0, 10
	syscall

to_binary:
	rem $t1, $s0, 2		#binary remainder
	div $s0, $s0, 2		#divides int number by 2
	mul $t6, $t1, $t7
	addi $t5, $t5, 1
	mul $t7, $t7, 10
	add $t2, $t2, $t6
	bne $s0, 0, to_binary
	jr $ra
	
recall_binary:			#outputs the binary value of an immediate under 10
		
	move $a0, $t2
	li $v0, 1
	syscall 
	
	jr $ra
bin_fill:
	li $a0, 0
	li $v0, 1
	syscall
	add $t5, $t5, -1
	bne $t5, 0, bin_fill
	jr $ra
#recieve the address of a text format of a value in a0
decToBin:
#store the return address in s0
	add $s0, $zero, $ra
	add $v0, $zero, $zero
	#use s1 to find the last spot in the text array
	add $s1, $zero, $a0
	
#find the last spot in the array
decToBin_findLastLoop:
	lbu $t0, 0($s1)
	jal charToVal
	beq $t0, -1, decToBin_findVal
	addi $s1, $s1, 1
	j decToBin_findLastLoop
#find the value of the char array
decToBin_findVal:
	addi $t1, $zero, 1	#t1 is the power of ten (the position of current char)
	addi $t4, $zero, 10	#constant value of 10 for mult reasons
	sub $s1, $s1, 1		#trim the non-digit off the tracer s1
decToBin_findVal_Loop:
	slt $s3, $s1, $a0	#s3 is 1 when s1 is less than the address value of a0
	beq $s3, 1, decToBin_done
	lbu $t0, 0($s1)	#get the ascii char of the digit
	sub $s1, $s1, 1
	jal charToVal	#get the value corresponding to ascii char (will be in t0)
	beq $t0, -2, decToBin_minus
	#multiply the value in t0 by the power of 10
	multu $t0, $t1
	mflo $t3
	#add this to the ongoing sum in v0
	add $v0, $v0, $t3
	#multiply the power of ten in t1 by 10
	multu $t1, $t4
	mflo $t1	#put the result back in t1
	j decToBin_findVal_Loop

decToBin_minus:
	sub $v0, $zero, $v0
decToBin_done:
	jr $s0

#RECIEVES INPUT THROUGH T0, OUTPUTS THROUGH T0
#find value of ascii digit, -1 if not a number digit,-2 if a '-'
charToVal:
	beq $t0, 48, charToVal_ZERO
	beq $t0, 49, charToVal_ONE
	beq $t0, 50, charToVal_TWO
	beq $t0, 51, charToVal_THREE
	beq $t0, 52, charToVal_FOUR
	beq $t0, 53, charToVal_FIVE
	beq $t0, 54, charToVal_SIX
	beq $t0, 55, charToVal_SEVEN
	beq $t0, 56, charToVal_EIGHT
	beq $t0, 57, charToVal_NINE
	beq $t0, 45, charToVal_MINUS
	#uninteresting character
	subi $t0, $zero, 1
	jr $ra
charToVal_MINUS:
	sub $t0, $zero, 2
	jr $ra
charToVal_ZERO:
	addi $t0, $zero, 0
	jr $ra
charToVal_ONE:
	addi $t0, $zero, 1
	jr $ra
charToVal_TWO:
	addi $t0, $zero, 2
	jr $ra
charToVal_THREE:
	addi $t0, $zero, 3
	jr $ra
charToVal_FOUR:
	addi $t0, $zero, 4
	jr $ra
charToVal_FIVE:
	addi $t0, $zero, 5
	jr $ra
charToVal_SIX:
	addi $t0, $zero, 6
	jr $ra
charToVal_SEVEN:
	addi $t0, $zero, 7
	jr $ra
charToVal_EIGHT:
	addi $t0, $zero, 8
	jr $ra
charToVal_NINE:
	addi $t0, $zero, 9
	jr $ra
