getOpCode_sw:
addi $v0, $zero, 0x2b
sll $v0, $v0, 26
li $t0, 5
lb $t4, ($a1)
lb $t1, 1($a1)
j Set_Reg_sw
Paran_sw:
bne $t4, 0x28, Paran_sw_exit
jal Set_Reg_sw
Paran_sw_exit:
li $t1, 0
Loop_sw:
add $t3, $a1, $t0
lb $t4, ($t3)
li $t5, 0x28
beq $t5, $t4, Exit_Loop_sw
li $t2, 10
mult  $t1, $t2
mflo $t2
subi $t4, $t4, 48
add $t1, $t1, $t4
addi $t0, $t0, 1
j Loop_sw
Exit_Loop_sw:
or $v0, $v0, $t1
addi $v1, $zero, 1
j getOpCode_exit
Set_Reg_sw:
lb $t4, 1($a1) #get the reg letter
beq $t4, 0x7a, Label_sw_z #if the reg == $zero
beq $t4, 0x30, Label_sw_z #if thereg == $0
beq $t4, 0x61, Label_sw_a
beq $t4, 0x76, Label_sw_v
beq $t4, 0x74, Label_sw_t
beq $t4, 0x73, Label_sw_s
beq $t4, 0x6b, Label_sw_k
beq $t4, 0x76, Label_sw_g
beq $t4, 0x66, Label_sw_f
beq $t4, 0x72, Label_sw_r
Label_sw_z:
li $t3, 0
add $t4, $t4, $t3
jr $ra
Label_sw_at:
li $t3, 1
add $t4, $t4, $t3
jr $ra
Label_sw_v:
addi $t3, $a1, 2
lb $t4, ($t3)
addi $t3, $t4, -48
addi $t3, $t3, 2
add $t4, $t4, $t3
jr $ra 
Label_sw_a:
addi $t3, $a1, 4
lb $t4, ($t3)
beq $t4, 116, Label_sw_at
addi $t3, $t4, -48
addi $t3, $t3, 4
add $t4, $t4, $t3
jr $ra
Label_sw_t:
#li $t5, 8  #t regsiters start at 8
#addi $t3, $a1, 1
#lb $t4, ($t3)     #gets the number off the register
#sub $t6, $t4, 48
#add $t5, $t5, $t6

addi $t3, $a1, 2  #move val in t3 to somewhere else
lb $t4, ($t3)
addi $t3, $t4, -48
addi $t3, $t3, 8
bgt $t3, 15, Label_sw_t2
add $t4, $t4, $t3
jr $ra
Label_sw_s:
addi $t3, $a1, 16
lb $t4, ($t3)
beq $t3, 112, Label_sw_sp
addi $t3, $t4, -48
addi $t3, $t3, 16
add $t4, $t4, $t3
jr $ra
Label_sw_t2:
#addi $t3, $a1, 24
#lb $t4, ($t3)
#addi $t3, $t4, -48
#addi $t3, $t3, 24
#add $t4, $t4, $t3
addi $t3, $t3, 8
add $t4, $t4, $t3
jr $ra
Label_sw_k:
addi $t3, $a1, 26
lb $t4, ($t3)
addi $t3, $t4, -48
addi $t3, $t3, 26
add $t4, $t4, $t3
jr $ra
Label_sw_g:
li $t3, 28
add $t4, $t4, $t3
jr $ra
Label_sw_sp:
li $t3, 29
add $t4, $t4, $t3
jr $ra
Label_sw_f:
li $t3, 30
add $t4, $t4, $t3
jr $ra
Label_sw_r:
li $t3, 31
add $t4, $t4, $t3
jr $ra