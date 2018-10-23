.data
	Filename: .asciiz "mipsio.txt"
	Exitfile: .asciiz "assemblerOutput.txt"
	operandfile: .asciiz "opfile.txt"
	Exitcontents: .asciiz "dynamic change?"
	textSpace: .space 1050
	buffer: .asciiz "    "
	newLine: .asciiz "\n"
	space: .asciiz " "
	rL: .space 258
	lineHolder: .asciiz "                    "           #18 space line holder
	segmentHolder5byte: .asciiz "     "
	segmentHolder4byte: .asciiz "    "
	segmentHolder3byte: .asciiz "   "
	segmentHolder2byte: .asciiz "  "
	giver: .asciiz "     "
.text
	li $t3, 0		
	la $s6, textSpace	#read data put into $s6
	la $s4, lineHolder
	la $s5, giver
	
#open a file
OPEN_INPUT:
	li $v0, 13
	li $a1, 0
	la $a0, Filename
	add $a2, $zero, $zero
	syscall
	move $t7, $v0
#read data from file	
READ:
	addi $t3, $t3, 36		# number of bytes read
	move $a0, $v0
	li $v0, 14
	or $a1, $a1, $s6		#all characters get loaded to the s6 buffer think large memory bank
	add $a2, $a2, $t3		#number of bytes read
	syscall
	
	la $t2, segmentHolder2byte
	la $t3, segmentHolder3byte
	la $t4, segmentHolder4byte
	la $t5, segmentHolder5byte
#print string of characters	
PRINT:
	
	#get a by itself into t0
	lb $t0, 0($s6)			#loads the character into t0
	sb $t0, 0($s4)			#stores character into LINE array
	sb $t0, 0($t2)			#stores characters into array of size -- 2
	sb $t0, 0($t3)			#stores characters into array of size -- 3
	sb $t0, 0($t4)			#stores characters into array of size -- 4
	sb $t0, 0($t5)			#stores characters into array of size -- 5
	addi $s4, $s4, 1		#increases address of byte array
	
	
	lb $t6, 0($t3)
	move $a0, $t0			#outputs said character
	li $v0, 11
	syscall
	
	la $a0, newLine			#outputs a new line to show that it gets partitioned
	li $v0, 4
	syscall
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	addi $s6, $s6, 1		#increments s6 so we can address the next character in ther input file
	addi $t8, $t8, 1		#t8 is a LINE counter
	addi $t9, $t9, 1		#t9 is a SEGMENT counter

	beq $t0, 0x20, SIZE_REGULATOR	#output and clear word when a space is reached
	beq $t0, 0x2c, SIZE_REGULATOR	#output and clear word when comma is reached
	beq $t0, 0xa, SIZE_REGULATOR	#output and clear word when new line is reached
	
	beq $t0, 0x00, OPEN_OUTPUT	#if we reach the end of the file we begin opening the output file
	bne $t0, 0x20, PRINT		#while not a space repeat the program
	bne $t0, 0x2c, PRINT		#while not a comma repeat program
SIZE_REGULATOR:
	addi $t9, $t9, -1
	beq $t9, 2, REWIND_2
	beq $t9, 3, REWIND_3
	beq $t9, 4, REWIND_4
	beq $t9, 5, REWIND_5
REWIND_2:
	add $t2, $t2, -3 
	j CLEAR_SEG
REWIND_3:
	add $t3, $t3, -3
	move $a0, $t3
	li $v0 11
	syscall
	j COPY_CONTENTS_3
REWIND_4:
	add $t4, $t4, -5 
	j CLEAR_SEG
REWIND_5:
	add $t5, $t5, -6 
	j CLEAR_SEG
COPY_CONTENTS_2:
	
COPY_CONTENTS_3:
	lb $t1, 0($t3)
	sb $t1, 0 ($s5)
	move $a0, $s5
	li $v0 11
	syscall
	bne $t9, 0, CLEAR_SEG
	addi $t9, $t9, -1
	addi $t3, $t3, 1
	addi $s5, $s5, 1
	j COPY_CONTENTS_3
COPY_CONTENTS_4:
COPY_CONTENTS_5:

CLEAR_SEG:
	la $t2, segmentHolder2byte
	la $t3, segmentHolder3byte
	la $t4, segmentHolder4byte
	la $t5, segmentHolder5byte
	li $t9, 0
	j PRINT
CLEAR_LINE:

#open output file
OPEN_OUTPUT:	
	li $v0, 13
	la $a0, Exitfile
	li $a1, 1
	li $a2, 0
	syscall
	
#write information to file		
WRITE:
	move $a0, $v0
	li $v0, 15
	move $a1, $s6
	li $a2, 1		# number of bytes written
	syscall
	
	
#close file
CLOSE:		
	li $v0, 16
	syscall
	
	
