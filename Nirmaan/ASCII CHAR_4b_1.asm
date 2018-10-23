.data

Code: .asciiz "sh $t2, 15($s1)"

.text

addi $a0, $zero, 219
la $a1, Code
addi $a1, $a1, 3

jal getOpCode

move $t0, $v0
li $v0, 35
move $a0, $t0
syscall

li $a0, 0x20
li $v0, 11
syscall

move $t1, $v1
li $v0, 1
move $a0, $t1
syscall

#Terminate and exit the program to avoid $jr jump to a random location
li $v0, 10
syscall

getOpCode:

addi $t0, $zero, 297   #(code for add)
beq $a0, $t0, getOpCode_add
        
addi $t0, $zero, 402   #(code for addi)
beq $a0, $t0, getOpCode_addi

addi $t0, $zero, 519   #(code for addiu)
beq $a0, $t0, getOpCode_addiu

addi $t0, $zero, 414   #(code for addu)
beq $a0, $t0, getOpCode_addu
        
addi $t0, $zero, 307   #(code for and)
beq $a0, $t0, getOpCode_and

addi $t0, $zero, 412   #(code for andi)
beq $a0, $t0, getOpCode_andi

addi $t0, $zero, 312   #(code for beq)
beq $a0, $t0, getOpCode_beq
        
addi $t0, $zero, 309   #(code for bne)
beq $a0, $t0, getOpCode_bne

addi $t0, $zero, 106   #(code for j)
beq $a0, $t0, getOpCode_j

addi $t0, $zero, 311   #(code for jal)
beq $a0, $t0, getOpCode_jal
        
addi $t0, $zero, 220   #(code for jr)
beq $a0, $t0, getOpCode_jr

addi $t0, $zero, 323   #(code for lbu)
beq $a0, $t0, getOpCode_lbu

addi $t0, $zero, 329   #(code for lhu)
beq $a0, $t0, getOpCode_lhu
        
addi $t0, $zero, 216   #(code for ll)
beq $a0, $t0, getOpCode_ll

addi $t0, $zero, 227   #(code for lw)
beq $a0, $t0, getOpCode_lw
        
addi $t0, $zero, 335   #(code for nor)
beq $a0, $t0, getOpCode_nor

addi $t0, $zero, 225   #(code for or)
beq $a0, $t0, getOpCode_or
        
addi $t0, $zero, 339   #(code for slt)
beq $a0, $t0, getOpCode_slt

addi $t0, $zero, 444   #(code for slti)
beq $a0, $t0, getOpCode_slti

addi $t0, $zero, 561   #(code for sltiu)
beq $a0, $t0, getOpCode_sltiu
        
addi $t0, $zero, 456   #(code for sltu)
beq $a0, $t0, getOpCode_sltu

addi $t0, $zero, 331   #(code for sll)
beq $a0, $t0, getOpCode_sll

addi $t0, $zero, 337   #(code for srl)
beq $a0, $t0, getOpCode_srl
        
addi $t0, $zero, 213   #(code for sb)
beq $a0, $t0, getOpCode_sb

addi $t0, $zero, 214   #(code for sc)
beq $a0, $t0, getOpCode_sc

addi $t0, $zero, 219   #(code for sh)
beq $a0, $t0, getOpCode_sh
        
addi $t0, $zero, 234   #(code for sw)
beq $a0, $t0, getOpCode_sw

addi $t0, $zero, 447   #(code for subu)
beq $a0, $t0, getOpCode_subu

addi $t0, $zero, 330   #(code for lui, sub, ori)
beq $a0, $t0, getOpCode_330

getOpCode_330:
lb $t0, -3($a1)
beq $t0, 0x73, getOpCode_sub
beq $t0, 0x6c, getOpCode_lui
beq $t0, 0x6f, getOpCode_ori


getOpCode_add:
addi $v0, $zero, 0
sll $v0, $v0, 26       #always do this to get the opcode in the correct position
ori $v0, $v0, 0x20     #used ori with 0x20 to get the func code in with the opcode
addi $v1, $zero, 0     #since add is R format
j getOpCode_exit

getOpCode_addi:
addi $v0, $zero, 0x8
sll $v0, $v0, 26
li $t0, 12
li $t1, 0
Loop_addi:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_addi
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_addi
Exit_Loop_addi:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_addiu:
addi $v0, $zero, 0x9
sll $v0, $v0, 26
li $t0, 13
li $t1, 0
Loop_addiu:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_addiu
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_addiu
Exit_Loop_addiu:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_addu:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x21
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_and:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x24
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_andi:
addi $v0, $zero, 0xc
sll $v0, $v0, 26
li $t0, 12
li $t1, 0
Loop_andi:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_andi
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_andi
Exit_Loop_andi:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_beq:
#addi $v0, $zero, 0x4
#sll $v0, $v0, 26
#li $t0, 00000000xxxxxxxx -----------------------------instead of x's manually convert hex addr. of a label into binary -------------------
#li $t1, 1000000000000000
#Loop_beq:
#beq $t1, $zero, Exit_Loop_beq
#and $t2, $t0, $t1
#beq $t2, $t1, Loop_beq_Store1
#li $a0, 0x48
#j Loop_beq_Store
#Loop_beq_Store1:
#li $a0, 0x49
#Loop_beq_Store:
#li $v0, 11
#syscall
#srl $t1, $t1, 1
#j Loop_beq
#Exit_Loop_beq:
#addi $v1, $zero, 1
j getOpCode_exit

getOpCode_bne:
#addi $v0, $zero, 0x5
#sll $v0, $v0, 26
#li $t0, 00000000xxxxxxxx -----------------------------instead of x's manually convert hex addr. of a label into binary -------------------
#li $t1, 1000000000000000
#Loop_beq:
#beq $t1, $zero, Exit_Loop_beq
#and $t2, $t0, $t1
#beq $t2, $t1, Loop_beq_Store1
#li $a0, 0x48
#j Loop_beq_Store
#Loop_beq_Store1:
#li $a0, 0x49
#Loop_beq_Store:
#li $v0, 11
#syscall
#srl $t1, $t1, 1
#j Loop_beq
#Exit_Loop_beq:
#addi $v1, $zero, 1
j getOpCode_exit

getOpCode_j:
addi $v0, $zero, 0x2
sll $v0, $v0, 26
addi $v1, $zero, 2
j getOpCode_exit

getOpCode_jal:
addi $v0, $zero, 0x3
sll $v0, $v0, 26
addi $v1, $zero, 2
j getOpCode_exit

getOpCode_jr:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x08
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_lbu:
addi $v0, $zero, 0x24
sll $v0, $v0, 26
li $t0, 11
li $t1, 0
Loop_lbu:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_lbu
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_lbu
Exit_Loop_lbu:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_lhu:
addi $v0, $zero, 0x25
sll $v0, $v0, 26
li $t0, 11
li $t1, 0
Loop_lhu:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_lhu
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_lhu
Exit_Loop_lhu:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_ll:
addi $v0, $zero, 0x30
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
Loop_ll:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_ll
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_ll
Exit_Loop_ll:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_lui:
addi $v0, $zero, 0xf
sll $v0, $v0, 26
li $t0, 11
li $t1, 0
Loop_lui:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_lui
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_lui
Exit_Loop_lui:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit



getOpCode_lw:
addi $v0, $zero, 0x23
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
Loop_lw:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_lw
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_lw
Exit_Loop_lw:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_nor:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x27
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_or:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x25
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_ori:
addi $v0, $zero, 0xd
sll $v0, $v0, 26
li $t0, 11
li $t1, 0
Loop_ori:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_ori
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_ori
Exit_Loop_ori:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_slt:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x2a
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_slti:
addi $v0, $zero, 0xa
sll $v0, $v0, 26
li $t0, 12
li $t1, 0
Loop_slti:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_slti
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_slti
Exit_Loop_slti:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sltiu:
addi $v0, $zero, 0xb
sll $v0, $v0, 26
li $t0, 13
li $t1, 0
Loop_sltiu:
add $t3, $a1, $t0
lb $t4, ($t3)
beq $zero, $t4, Exit_Loop_addiu
li $t2, 10
mult $t1, $t2
mflo $t1
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_addiu
Exit_Loop_sliu:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sltu:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x2b
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_sll:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x00
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_srl:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x02
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_sb:
addi $v0, $zero, 0x28
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
Loop_sb:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_sb
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_sb
Exit_Loop_sb:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sc:
addi $v0, $zero, 0x38
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
Loop_sc:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_sc
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_sc
Exit_Loop_sc:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sh:
addi $v0, $zero, 0x29
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
Loop_sh:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_sh
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_sh
Exit_Loop_sh:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sw:
addi $v0, $zero, 0x2b
sll $v0, $v0, 26
li $t0, 5
li $t1, 0
GetFirstChar_sw:  #get fisrt operand
la $t3, Code
addi $t4, $t3, 4
addi $t5, $t3, 5
li $a0, 0
li $a1, 0
lb $a0, ($t4)
lb $a1, ($t5)
li $t6, 0x30
jal regToCode
#
move $s1, $v0
sll $s1, $s1, 21
#
Parentheses_sw:
la $t3, Code
addi $t3, $t3, 8
Loop_Parentheses_sw:
lb $a0, ($t3)
li $t5, 0x28
beq $t5, $a0, GetSecondOperand_sw
addi $t3, $t3,1
j Loop_Parentheses_sw
#
GetSecondOperand_sw:
add $t4, $t3,$zero
addi $t4, $t4, 2
lb $a0, ($t4)
jal regToCode
move $s2, $v0 
sll $s2, $s2,16
#
la $t3,Code
loopComma_sw:
lb $a0, ($t3)
li $t5, 0x2c
beq $t5, $a0, getImm_sw
addi $t3, $t3,1
j Loop_Parentheses_sw
#
li $t7,0
getImm_sw:
addi $t3, $t3,1
lb $a0, ($t3)
li $t5, 0x28
beq $t5, $a0, loadImmIntos3_sw
li $t0, 0x30
blt $a0,$t0, Exit_GetImm_sw
li $t0, 0x39
bgt $a0, $t0, Exit_GetImm_sw
j getImm_sw
#
Exit_GetImm_sw:
li $t5, 0x28
beq $t5, $a0, loadImmIntos3_sw
li $t5, 0x20
beq $t5, $a0, loadImmIntos3_sw
move $t1, $a0
subi $t1, $t1, 48
add $t7, $t7,$t1
li $t2, 10
mult  $t7, $t2
mflo $t7
#add $t7, $t7,$t2
addi $t3, $t3, 1
j Exit_GetImm_sw
#
Ignore_Space_sw:
addi $t4, $t4,-1
j getImm_sw
#
loadImmIntos3_sw:
li $t8,10
div $t7,$t8
mflo $s3
or $s1, $s1, $s2
or $s1, $s1, $s3
or $t1, $t1, $s1
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit

getOpCode_sub:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x22
addi $v1, $zero, 0
j getOpCode_exit

getOpCode_subu:
addi $v0, $zero, 0
sll $v0, $v0, 26
ori $v0, $v0, 0x23
addi $v1, $zero, 0
j getOpCode_exit


getOpCode_exit:
jr $ra






#Expectation:
#after reading a $ put next two chars into a0, a1
#using this method $s4fja is just as legitimate as $s4
#$z is just as legitimate as $zero due to checking
#similarly for other uniquely named registers
#this is a feature :)

#returns decimal version of the register through $v0

#if optimization is wanted we can compare directly to the decimal values of characters
#this was decided against originally because I thought loading things into registers
#would make the code more legible
regToCode:
	#move $ra to $s0, jump back to $s0 at end, use ra for jumping w/in procedure
	add $s0, $ra, $zero

	#Load character codes into temp registers for comparison
	#char code loaded	#char
	li $t0, 122		#z
	li $t1, 97		#a
	li $t2, 118		#v
	li $t3, 116		#t
	li $t4, 115		#s
	li $t5, 107		#k
	li $t6, 103		#g
	li $t7, 102		#f
	li $t8, 114		#r
	
	beq $a0, $t0, regToCode_firstZ	#first character is z
	beq $a0, $t1, regToCode_firstA	#first character is a
	beq $a0, $t2, regToCode_firstV	#first character is v
	beq $a0, $t3, regToCode_firstT	#first character is t
	beq $a0, $t4, regToCode_firstS	#first character is s
	beq $a0, $t5, regToCode_firstK	#first character is k
	beq $a0, $t6, regToCode_firstG	#first character is g
	beq $a0, $t7, regToCode_firstF	#first character is f
	beq $a0, $t8, regToCode_firstR	#first character is r
	j regToCode_ERROR		#first character is invalid
	
regToCode_firstZ:	#Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z Z
	#only possible register is $zero
	li $v0, 0
	j regToCode_exit
	
regToCode_firstA:	#A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A A
	beq $a1, $t3, regToCode_firstA_at	#second character is t
	jal regToCode_loadNumCodes
	beq $a1, $t0, regToCode_firstA_a0	#second char is 0
	beq $a1, $t1, regToCode_firstA_a1	#second char is 1
	beq $a1, $t2, regToCode_firstA_a2	#second char is 2
	beq $a1, $t3, regToCode_firstA_a3	#second char is 3
	j regToCode_ERROR			#second char is invalid
	
regToCode_firstA_at:
	li $v0, 1
	j regToCode_exit
	
regToCode_firstA_a0:
	li $v0, 4
	j regToCode_exit
regToCode_firstA_a1:
	li $v0, 5
	j regToCode_exit
regToCode_firstA_a2:
	li $v0, 6
	j regToCode_exit
regToCode_firstA_a3:
	li $v0, 7
	j regToCode_exit
	
	
	
regToCode_firstV:	#V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V V
	jal regToCode_loadNumCodes
	beq $a1, $t0, regToCode_firstV_v0	#second char 0
	beq $a1, $t1, regToCode_firstV_v1	#second char 1
	j regToCode_ERROR
regToCode_firstV_v0:
	li $v0, 2
	j regToCode_exit
regToCode_firstV_v1:
	li $v0, 3
	j regToCode_exit
	
	
regToCode_firstT:	#T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T T
	jal regToCode_loadNumCodes
	beq $a1, $t0, regToCode_firstT_t0	#second char 0
	beq $a1, $t1, regToCode_firstT_t1	#second char 1
	beq $a1, $t2, regToCode_firstT_t2	#second char 2
	beq $a1, $t3, regToCode_firstT_t3	#second char 3
	beq $a1, $t4, regToCode_firstT_t4	#second char 4
	beq $a1, $t5, regToCode_firstT_t5	#second char 5
	beq $a1, $t6, regToCode_firstT_t6	#second char 6
	beq $a1, $t7, regToCode_firstT_t7	#second char 7
	beq $a1, $t8, regToCode_firstT_t8	#second char 8
	beq $a1, $t9, regToCode_firstT_t9	#second char 9
	j regToCode_ERROR			#second char invalid
	
regToCode_firstT_t0:
	li $v0, 8
	j regToCode_exit
regToCode_firstT_t1:
	li $v0, 9
	j regToCode_exit
regToCode_firstT_t2:
	li $v0, 10
	j regToCode_exit
regToCode_firstT_t3:
	li $v0, 11
	j regToCode_exit
regToCode_firstT_t4:
	li $v0, 12
	j regToCode_exit
regToCode_firstT_t5:
	li $v0, 13
	j regToCode_exit
regToCode_firstT_t6:
	li $v0, 14
	j regToCode_exit
regToCode_firstT_t7:
	li $v0, 15
	j regToCode_exit
regToCode_firstT_t8:
	li $v0, 24
	j regToCode_exit
regToCode_firstT_t9:
	li $v0, 25
	j regToCode_exit
			
regToCode_firstS:	#S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S S
	beq $a1, 112, regToCode_firstS_sp	#second char p	112 is the decimal code for 'p'
	jal regToCode_loadNumCodes
	beq $a1, $t0, regToCode_firstS_s0	#second char 0
	beq $a1, $t1, regToCode_firstS_s1	#second char 1
	beq $a1, $t2, regToCode_firstS_s2	#second char 2
	beq $a1, $t3, regToCode_firstS_s3	#second char 3
	beq $a1, $t4, regToCode_firstS_s4	#second char 4
	beq $a1, $t5, regToCode_firstS_s5	#second char 5
	beq $a1, $t6, regToCode_firstS_s6	#second char 6
	beq $a1, $t7, regToCode_firstS_s7	#second char 7
	j regToCode_ERROR
	
regToCode_firstS_sp:
	li $v0, 29
	j regToCode_exit
regToCode_firstS_s0:
	li $v0, 16
	j regToCode_exit
regToCode_firstS_s1:
	li $v0, 17
	j regToCode_exit
regToCode_firstS_s2:
	li $v0, 18
	j regToCode_exit
regToCode_firstS_s3:
	li $v0, 19
	j regToCode_exit
regToCode_firstS_s4:
	li $v0, 20
	j regToCode_exit
regToCode_firstS_s5:
	li $v0, 21
	j regToCode_exit
regToCode_firstS_s6:
	li $v0, 22
	j regToCode_exit
regToCode_firstS_s7:
	li $v0, 23
	j regToCode_exit
	
regToCode_firstK:	#K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K K
	jal regToCode_loadNumCodes
	beq $a1, $t0, regToCode_firstK_k0	#second char 0
	beq $a1, $t1, regToCode_firstK_k1	#second char 1
	j regToCode_ERROR			#second char invalid

regToCode_firstK_k0:
	li $v0, 26
	j regToCode_exit
regToCode_firstK_k1:
	li $v0, 27
	j regToCode_exit
	
regToCode_firstG:	#G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G G
	li $v0, 28	#only $gp starts with g
	j regToCode_exit
	
regToCode_firstF:	#F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F F
	li $v0, 30	#only $fp starts with f
	j regToCode_exit

regToCode_firstR:	#R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R R
	li $v0, 31	#only $ra starts with r
	j regToCode_exit
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
regToCode_loadNumCodes:
	#char code loaded	#char
	li $t0, 48		#0
	li $t1, 49		#1
	li $t2, 50		#2
	li $t3, 51		#3
	li $t4, 52		#4
	li $t5, 53		#5
	li $t6, 54		#6
	li $t7, 55		#7
	li $t8, 56		#8
	li $t9, 57		#9
	#jump back
	jr $ra

regToCode_ERROR:
	li $v0, 0xFFFFFFFF	#ERROR  ERROR  ERROR  ERROR  ERROR

regToCode_exit:
	jr $s0
