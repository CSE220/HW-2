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
encode_plaintext:
    jr $ra
	
	
encrypt:
	jr $ra
	
	
decode_ciphertext:
	jr $ra
	

decrypt:
	jr $ra
	
#################### UTILS ####################
return:
	jr $ra