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
#################### DECODE ####################		
decode_ciphertext:
	addi $sp, $sp, -20	# Allocates space on stack
	sw $s0, 16($sp)		# Saved $s0 onto stack
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# The ciphertext
	move $s2, $a1		# AB_text
	move $s3, $a2		# AB_text length
	# SAFE BODY START
	move $a0, $s1
	jal count_letters
	bgt $v0, $s3, decode_ciphertext.error
	
	li $v0, 0	# Initialize running sum
	move $a0, $s1	# Ciphertext
	move $a1, $s2	# AB_text
	move $a2, $s3	# AB_text_length
	li $t0, 0	# iterator
	li $t3, 0	# Consecutive B check
	li $t4, 0	# Increment from 0 to 5. At 4 if we are at end of block of 5
	j decode_ciphertext.loop
decode_ciphertext.loop:
	lb $t1, 0($a0)	# Character in cipher text
	
	beq $t0, $a2, decode_ciphertext.exit
	beq $t1, 0, decode_ciphertext.exit
	ble $t1, 90, decode_ciphertext.confirm_uppercase
	bge $t1, 97, decode_ciphertext.confirm_lowercase
	
	addi $a0, $a0, 1
	j decode_ciphertext.loop
decode_ciphertext.confirm_uppercase:
	bge $t1, 65, decode_ciphertext.is_uppercase
	
	addi $a0, $a0, 1
	j decode_ciphertext.loop
decode_ciphertext.confirm_lowercase:
	ble $t1, 122, decode_ciphertext.is_lowercase

	addi $a0, $a0, 1
	j decode_ciphertext.loop
decode_ciphertext.is_uppercase:
	li $t2, 'B'
	addi $t3, $t3, 1	# Increment B count
	j decode_ciphertext.write
decode_ciphertext.is_lowercase:
	li $t2, 'A'
	li $t3, 0	# Reset B count
	j decode_ciphertext.write
decode_ciphertext.write:
	sb $t2, 0($a1)
	
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	addi $v0, $v0, 1
	
	beq $t4, 5, decode_ciphertext.check_exit
	
	j decode_ciphertext.loop
decode_ciphertext.check_exit:
	beq $t3, 5, decode_ciphertext.exit
	
	li $t4, 0	# Reset counter
	j decode_ciphertext.loop
decode_ciphertext.error:
	li $v0, -1
	j decode_ciphertext.exit
decode_ciphertext.exit:
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
    	j return	
	

decrypt:
	addi $sp, $sp, -12	# Allocates space on stack
	sw $s0, 8($sp)		# Saved $s0 onto stack
	sw $s1, 4($sp)		
	sw $s2, 0($sp)	
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a1		# Store plaintext
	move $s2, $a2		# Store AB_text
	# SAFE BODY START
	move $a1, $a2
	move $a2, $a3
	jal decode_ciphertext
	beq $v0, -1, decrypt.exit	

	# Set up for decryption of AB_text
	move $a0, $s2	# Address of AB_text
	move $a1, $s1	# Address of plaintext
	li $v0, 0	# Set running sum to 0
	j decrypt.loop
decrypt.loop:
	j decrypt.getChar
decrypt.getChar:
	lbu $t1, 0($a0)
	beq $t1, 'A', decrypt.A
	beq $t1, 'B', decrypt.B
	
	j decrypt.exit
decrypt.A:
	lbu $t1, 1($a0)
	beq $t1, 'A', decrypt.AA
	beq $t1, 'B', decrypt.AB
	
	j decrypt.exit
decrypt.B:
	lbu $t1, 1($a0)
	beq $t1, 'A', decrypt.BA
	beq $t1, 'B', decrypt.BB
	
	j decrypt.exit
decrypt.AA:
	beq $t1, 'A', decrypt.AAA
	beq $t1, 'B', decrypt.AAB
	
	j decrypt.exit
decrypt.AB:
	lbu $t1, 2($a0)
	beq $t1, 'A', decrypt.ABA
	beq $t1, 'B', decrypt.ABB
	
	j decrypt.exit
decrypt.BA:
	lbu $t1, 2($a0)
	beq $t1, 'A', decrypt.BAA
	beq $t1, 'B', decrypt.BAB
decrypt.BB:
	lbu $t1, 2($a0)
	beq $t1, 'A', decrypt.BBA
	beq $t1, 'B', decrypt.BBB
decrypt.AAA:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.AAAA
	beq $t1, 'B', decrypt.AAAB
	
	j decrypt.exit
decrypt.AAB:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.AABA
	beq $t1, 'B', decrypt.AABB
	
	j decrypt.exit
decrypt.ABA:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.ABAA
	beq $t1, 'B', decrypt.ABAB
	
	j decrypt.exit
decrypt.ABB:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.ABBA
	beq $t1, 'B', decrypt.ABBB
	
	j decrypt.exit
decrypt.BAA:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.BAAA
	beq $t1, 'B', decrypt.BAAB
	
	j decrypt.exit
decrypt.BAB:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.BABA
	beq $t1, 'B', decrypt.BABB
	
	j decrypt.exit
decrypt.BBA:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.BBAA
	beq $t1, 'B', decrypt.BBAB
	
	j decrypt.exit
decrypt.BBB:
	lbu $t1, 3($a0)
	beq $t1, 'A', decrypt.BBBA
	beq $t1, 'B', decrypt.BBBB
	
	j decrypt.exit
decrypt.AAAA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.AAAAA
	beq $t1, 'B', decrypt.AAAAB
	
	j decrypt.exit
decrypt.AAAB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.AAABA
	beq $t1, 'B', decrypt.AAABB
	
	j decrypt.exit
decrypt.AABA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.AABAA
	beq $t1, 'B', decrypt.AABAB
	
	j decrypt.exit
decrypt.AABB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.AABBA
	beq $t1, 'B', decrypt.AABBB
	
	j decrypt.exit
decrypt.ABAA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.ABAAA
	beq $t1, 'B', decrypt.ABAAB
	
	j decrypt.exit
decrypt.ABAB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.ABABA
	beq $t1, 'B', decrypt.ABABB
	
	j decrypt.exit
decrypt.ABBA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.ABBAA
	beq $t1, 'B', decrypt.ABBAB
	
	j decrypt.exit
decrypt.ABBB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.ABBBA
	beq $t1, 'B', decrypt.ABBBB
	
	j decrypt.exit
decrypt.BAAA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BAAAA
	beq $t1, 'B', decrypt.BAAAB
	
	j decrypt.exit
decrypt.BAAB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BAABA
	beq $t1, 'B', decrypt.BAABB
	
	j decrypt.exit
decrypt.BABA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BABAA
	beq $t1, 'B', decrypt.BABAB
	
	j decrypt.exit
decrypt.BABB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BABBA
	beq $t1, 'B', decrypt.BABBB
	
	j decrypt.exit
decrypt.BBAA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BBAAA
	beq $t1, 'B', decrypt.BBAAB
	
	j decrypt.exit
decrypt.BBAB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BBABA
	beq $t1, 'B', decrypt.BBABB
	
	j decrypt.exit
decrypt.BBBA:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BBBAA
	beq $t1, 'B', decrypt.BBBAB
	
	j decrypt.exit
decrypt.BBBB:
	lbu $t1, 4($a0)
	beq $t1, 'A', decrypt.BBBBA
	beq $t1, 'B', decrypt.BBBBB
	
	j decrypt.exit
decrypt.AAAAA:
	li $t2, 'A'
	j decrypt.write
decrypt.AAAAB:
	li $t2, 'B'
	j decrypt.write
decrypt.AAABA:
	li $t2, 'C'
	j decrypt.write
decrypt.AAABB:
	li $t2, 'D'
	j decrypt.write
decrypt.AABAA:
	li $t2, 'E'
	j decrypt.write
decrypt.AABAB:
	li $t2, 'F'
	j decrypt.write
decrypt.AABBA:
	li $t2, 'G'
	j decrypt.write
decrypt.AABBB:
	li $t2, 'H'
	j decrypt.write
decrypt.ABAAA:
	li $t2, 'I'
	j decrypt.write
decrypt.ABAAB:
	li $t2, 'J'
	j decrypt.write
decrypt.ABABA:
	li $t2, 'K'
	j decrypt.write
decrypt.ABABB:
	li $t2, 'L'
	j decrypt.write
decrypt.ABBAA:
	li $t2, 'M'
	j decrypt.write
decrypt.ABBAB:
	li $t2, 'N'
	j decrypt.write
decrypt.ABBBA:
	li $t2, 'O'
	j decrypt.write
decrypt.ABBBB:
	li $t2, 'P'
	j decrypt.write
decrypt.BAAAA:
	li $t2, 'Q'
	j decrypt.write
decrypt.BAAAB:
	li $t2, 'R'
	j decrypt.write
decrypt.BAABA:
	li $t2, 'S'
	j decrypt.write
decrypt.BAABB:
	li $t2, 'T'
	j decrypt.write
decrypt.BABAA:
	li $t2, 'U'
	j decrypt.write
decrypt.BABAB:
	li $t2, 'V'
	j decrypt.write
decrypt.BABBA:
	li $t2, 'W'
	j decrypt.write
decrypt.BABBB:
	li $t2, 'X'
	j decrypt.write
decrypt.BBAAA:
	li $t2, 'Y'
	j decrypt.write
decrypt.BBAAB:
	li $t2, 'Z'
	j decrypt.write
decrypt.BBABA:
	li $t2, ' '
	j decrypt.write
decrypt.BBABB:
	li $t2, '!'
	j decrypt.write
decrypt.BBBAA:
	li $t2, '’'
	j decrypt.write
decrypt.BBBAB:
	li $t2, ','
	j decrypt.write
decrypt.BBBBA:
	li $t2, '.'
	j decrypt.write
decrypt.BBBBB:
	j decrypt.write_end
decrypt.write:
	sb $t2, 0($a1)	#Write decoded char into plaintext

	addi $a0, $a0, 5
	addi $a1, $a1, 1
	addi $v0, $v0, 1
	
	j decrypt.loop
decrypt.write_end:
	li $t2, '\0'
	sb $t2, 0($a1)
	
	j decrypt.exit
decrypt.exit:
	# SAFE BODY END
	move $ra, $s0		# Restore $ra value
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)		# Restore $s0 value
	addi $sp, $sp, 12	# Allocates space on stack
    	j return
#################### UTILS ####################
return:
	jr $ra
