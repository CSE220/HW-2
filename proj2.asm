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
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s2 onto stack
	move $s0, $ra		# Move $ra value to be saved
	# SAFE BODY START
	# Count and find out value of $v1
	jal encode_plaintext.ab
	
	
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s2 value
	addi $sp, $sp, 4	# Allocates space on stack
    	j return		
encode_plaintext.ab:
	li $t5, 5
	lbu $t0, 0($a0)		# Load character into $t0	
	beq $t0, 0, encode_plaintext.writeEnd	# If character is 0, we are done
	
	beq $t0, 32, encode_plaintext.space
	beq $t0, 33, encode_plaintext.exclamation
	beq $t0, 39, encode_plaintext.quotation
	beq $t0, 25, encode_plaintext.quotation	# Same as quotation?
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
#################### ENCODE ####################
#################### ENCODE ####################
encrypt:
	lw $t0, 0($sp)		# Get Bacon Code
	addi $sp, $sp, -24	# Allocates space on stack
	sw $s5, 20($sp)
	sw $s0, 16($sp)		# Saved $s0 onto stack
	sw $s1, 12($sp)		# Saved $s0 onto stack
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a1		# Save cipher text string
	move $s2, $a2		# Save ab_text 
	move $s3, $a3		# Save ab_text length
	move $s4, $a0		# Save plain_text
	move $s5, $t0		# Save bacon code
	# SAFE BODY START
	move $a0, $s4
	jal to_lowercase
	move $a0, $s4
	move $a1, $s2
	move $a2, $s3
	move $a3, $s5
	jal encode_plaintext
	move $s4, $v1		# Save success result
	move $a0, $s1
	jal count_letters
	move $v1, $s4
	move $a0, $s1	# Cipher Text base address
	move $a1, $s2	# AB_text base address
	li $t0, 5	# Iterator over AB_TEXT, Start at 5 since BBBBB doesnt count
	li $v0, 0	# Set running sum to 0
	j encrypt.loop
encrypt.loop:
	lb $t1, 0($a0)	# Character in cipher text
	lb $t2, 0($a1)	# Associated character in AB_text
	
	beq $t1, 0, encrypt.end
	beq $t2, 'A', encrypt.continue
	beq $t2, 'B', encrypt.continue
	j encrypt.end
encrypt.continue:
	ble $t1, 90, encrypt.confirm_letter_uppercase
	bge $t1, 97, encrypt.confirm_letter_lowercase
encrypt.confirm_letter_lowercase:
	bgt $t1, 122, encrypt.not_letter
	j encrypt.is_letter
encrypt.confirm_letter_uppercase:
	blt $t1, 65, encrypt.not_letter
	j encrypt.is_letter
encrypt.not_letter:
	addi $a0, $a0, 1	# Increment read address by 1
	j encrypt.loop
encrypt.is_letter:
	addi $v0, $v0, 1	# Increase letters found by 1
	
	beq $t2, 66, encrypt.to_uppercase_letter
	
	blt $t1, 97, encrypt.upper_to_lower
	addi $a0, $a0, 1	# Increment read addresses by 1
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j encrypt.loop
encrypt.upper_to_lower:
	addi $t1, $t1, 32
	sb $t1, 0($a0)
	
	addi $a0, $a0, 1	# Increment read addresses by 1
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j encrypt.loop
encrypt.to_uppercase_letter:
	bge $t1, 97, encrypt.lower_to_upper
	addi $a0, $a0, 1	# Increment read addresses by 1
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j encrypt.loop
encrypt.lower_to_upper:
	addi $t1, $t1, -32
	sb $t1, 0($a0)
	
	addi $a0, $a0, 1	# Increment read addresses by 1
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j encrypt.loop
encrypt.end:
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)		# Restore value
	lw $s0, 16($sp)		# Restore $s0 value
	lw $s5, 20($sp)
	addi $sp, $sp, 24	# Allocates space on stack
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
