#this is pretty good but look at the example to see the silly bug


.data 
	rL:	.space	258
	rL_labelLine:	.space 258
	Filename: .asciiz "mipsio.txt"
	singleChar: .ascii "_"
	
.text
#open a file
OPEN_INPUT:
	li $v0, 13
	li $a1, 0
	la $a0, Filename
	add $a2, $zero, $zero
	syscall
	add $s6, $v0, $zero
	
	addi $t2, $zero, 97
	lbu $t2, rL($t2)
main:
	jal readLine
	jal printLine
	beq $v0, -1, exit
	j main
	
	
	
#read data from file	
readLine:
add $s0, $ra, $zero		#store the address to return to
add $t1, $zero, $zero	#t1 will be the location in the char array we are writing to
addi $t4, $zero, 13		#value of the carriage return character in $t4
addi $t5, $zero, 257	#max value of $t1
addi $t6, $zero, 35		#value of '#'

#let's say the rL label contains a 258 character storage space
readLine_loop:
jal READ
lbu $t2, singleChar($zero)
beq $t2, $t4, readLine_exit	#exit if encountering a carriage return
beq $t2, $t6, readLine_clear	#or if encountering a '#' comment signifier
beq $t1, $t5, readLine_exit	#or limit of rL is reached
beq $v0, 0, readLine_null	#if encountered the null terminating character

sb $t2, rL($t1)		#store the character in the rL string
addi $t1, $t1, 1	#increment string array tracer
j readLine_loop

readLine_clear:
jal clearToNextLine
bne $v0, $zero, readLine_exit	#v0 is zero if last read in clearToNextLine was null character

readLine_null:
subi $v0, $zero, 1	#put -1 in the return register

readLine_exit:
addi $t2, $zero, 0	#put null character in rL string
sb $zero, rL($t1)		#end the string with null character
jr $s0				#jump back to where called from

printLine:
add $t0 $zero, $v0
la $a0, rL
li $v0, 4
syscall
add $v0, $zero, $t0
jr $ra




li $v0, 11
la $a0, singleChar
syscall


exit:
li $v0, 10	#exit program
syscall



READ:
	#addi $t3, $t3, 1		# number of bytes read
	move $a0, $s6
	li $v0, 14
	la $a1, singleChar		#all characters get loaded to the s6 buffer think large memory bank
	li $a2, 1		#number of bytes read
	syscall
	jr $ra
	
clearToNextLine:

clearToNextLine_loop:
jal READ
lbu $t2, singleChar($zero)
beq $t2, 13, clearToNextLine_exit
beq $v0, 0, clearToNextLine_exit
j clearToNextLine_loop
clearToNextLine_exit:
jr $s0

	
