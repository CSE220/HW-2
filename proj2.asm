# Sayan Sivakumaran
# ssivakumaran
# 110261379

.text
#################### TO LOWERCASE ####################
to_lowercase:
	move $t0, $a0		# Set $t0 to be the base address of the string
	li $v0, 0		# Initialize return value to 0
	
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	jal to_lowercase.loop
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
to_lowercase.loop:
	lbu $t1, 0($t0)		# Load character into $t2
	
	beq $t1, 0, return	# If character is 0, we are done
	ble $t1, 90, to_lowercase.uppercase_check
	
	addi $t0, $t0, 1		# Move read address up by 1
	j to_lowercase.loop
to_lowercase.uppercase_check:
	blt $t1, 65, to_lowercase.not_letter
	addi $t1, $t1, 32		# Change from uppercase to lowercase
	sb   $t1, 0($t0)	
	
	addi $v0, $v0, 1		# Increment number of letters we changed
	addi $t0, $t0, 1		# Move read adddress up by 1
	j to_lowercase.loop
to_lowercase.not_letter:
	addi $t0, $t0, 1		# Move read adddress up by 1
	j to_lowercase.loop
#################### STRING LENGTH ####################
strlen:
    	move $t0, $a0		# Set $t0 to be the base address of the string
	li $v0, 0		# Initialize return value to 0
	
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	jal strlen.loop
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
strlen.loop:
	lbu $t1, 0($t0)		# Load character into $t2
	
	beq $t1, 0, return	# If character is 0, we are done
	
	addi $v0, $v0, 1	# Increment return value by 1
	addi $t0, $t0, 1	# Move read address up by 1
	j strlen.loop
	
#################### LETTER COUNT ####################
count_letters:
	move $t0, $a0		# Set $t0 to be the base address of the string
	li $v0, 0		# Initialize return value to 0
	
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	jal count_letters.loop
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
count_letters.loop:
	lbu $t1, 0($t0)		# Load character into $t2
	
	beq $t1, 0, return	# If character is 0, we are done
	
	ble $t1, 90, count_letters.verify_uppercase
	bge $t1, 97, count_letters.verify_lowercase

	addi $t0, $t0, 1	# Move read address up by 1
	j count_letters.loop
count_letters.verify_uppercase:
	bge $t1, 65, count_letters.is_uppercase
	
	addi $t0, $t0, 1 # Move read address up by 1
	j count_letters.loop
count_letters.is_uppercase:
	addi $v0, $v0, 1 # Increment result by 1
	addi $t0, $t0, 1 # Move read address up by 1
	j count_letters.loop
count_letters.verify_lowercase:
	ble $t1, 122, count_letters.is_uppercase
	
	addi $t0, $t0, 1 # Move read address up by 1
	j count_letters.loop
count_letters.is_lowercase:
	addi $v0, $v0, 1 # Increment result by 1
	addi $t0, $t0, 1 # Move read address up by 1
	j count_letters.loop
	
#################### ENCODE ####################
encode_plaintext:
	li $v0, 0
	addi $sp, $sp, -12	# Allocates space on stack
	sw $s0, 8($sp)		# Saved $s2 onto stack
	sw $s1, 4($sp)		# Saved $s3 onto stack
	sw $s2, 0($sp)		# Saved $s4 onto stack
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Save plaintext address so we can count later
	move $s2, $a2		# Save ab_length for length checks later
	# SAFE BODY START
	# Count and find out value of $v1
	jal encode_plaintext.ab
	
	
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s2, 0($sp)		# Restore $s2 value
	lw $s1, 4($sp)		# Restore $s1 value
	lw $s0, 8($sp)		# Restore $s2 value
	addi $sp, $sp, 12	# Allocates space on stack
    	j return		
encode_plaintext.ab:
	li $t5, 5
	lbu $t0, 0($a0)		# Load character into $t0	
	beq $t0, 0, encode_plaintext.writeEnd	# If character is 0, we are done
	
	beq $t0, 32, encode_plaintext.space
	beq $t0, 33, encode_plaintext.exclamation
	beq $t0, 39, encode_plaintext.quotation
	beq $t0, 44, encode_plaintext.comma
	beq $t0, 46, encode_plaintext.period
	
	# Compute letter
	addi $t3, $t0, -97
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB

encode_plaintext.space:
	li $t3, 26
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB
encode_plaintext.exclamation:
	li $t3, 27
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB
encode_plaintext.quotation:
	li $t3, 28
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB
encode_plaintext.comma:
	li $t3, 29
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB
encode_plaintext.period:
	li $t3, 30
	mul $t3, $t3, $t5
	j encode_plaintext.writeAB
encode_plaintext.writeAB:
	add $t4, $a3, $t3	# Base + Character Index
	lbu $t2, 0($t4)		# Code to write "BBBBB" at end of string
	sb  $t2, 0($a1)
	addi $a2, $a2, -1
	li $v1, 0
	ble $a2, 5, encode_plaintext.writeEnd
	lbu $t2, 1($t4)
	sb  $t2, 1($a1)
	addi $a2, $a2, -1
	li $v1, 0
	ble $a2, 5, encode_plaintext.writeEnd
	lbu $t2, 2($t4)
	sb  $t2, 2($a1)
	addi $a2, $a2, -1
	li $v1, 0
	ble $a2, 5, encode_plaintext.writeEnd
	lbu $t2, 3($t4)
	sb  $t2, 3($a1)
	addi $a2, $a2, -1
	li $v1, 0
	ble $a2, 5, encode_plaintext.writeEnd
	lbu $t2, 4($t4)
	sb  $t2, 4($a1)
	addi $a2, $a2, -1
	li $v1, 1
	addi $v0, $v0, 1
	ble $a2, 5, encode_plaintext.writeEnd

	addi $a0, $a0, 1	# Move read address up by 1
	addi $a1, $a1, 5	# Move store address up by 5
	j encode_plaintext.ab
encode_plaintext.writeEnd:
	ble $a2, 4, return	# If we have no room to write BBBBB, end
	
	lbu $t2, 155($a3)	# Code to write "BBBBB" at end of string
	sb  $t2, 0($a1)
	lbu $t2, 156($a3)
	sb  $t2, 1($a1)
	lbu $t2, 157($a3)
	sb  $t2, 2($a1)
	lbu $t2, 158($a3)
	sb  $t2, 3($a1)
	lbu $t2, 159($a3)
	sb  $t2, 4($a1)
	
	j return
encrypt:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	# SAFE BODY START

	
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
    	j return
	
	
	
decode_ciphertext:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	# SAFE BODY START

	
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
    	j return
	
	

decrypt:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	# SAFE BODY START

	
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
    	j return
	
	
#################### UTILS ####################
return:
	jr $ra
