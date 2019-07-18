##########################################################################
# Created by: #Cui, Yongshheng
#              1491148
#              14 March 2019
#
#
# Assignment: #Lab 4: ASCII Conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
#
#
# Description: This program will allow the user to encrypt or decrypt strings using a Caesar Cipher.
#              In order to generate the Caesar Cipher shift value, the user will also enter a key.
#             The program will calculate the checksum of the key, and use that checksum to shift
#             each letter in the string that should encrypted/decrypted. Then, the encrypted and
#             decrypted strings are displayed to the user.
# Notes: ##########################################################################
		.data
prompt0:	.asciiz		"\nDo you want to (E)ncrypt, (D)ecrypt, or e(X)it? "
prompt1: 	.asciiz		"What is the key? "
prompt2:	.asciiz		"What is the string? "
hint1:		.asciiz		"Welcome to the Caesar Cipher program!\n"
hint2:		.asciiz		"\nHere is the encrypted and decrypted string"
hint3:		.asciiz		"\n<Encrypted> "
hint4:		.asciiz		"<Decrypted> "
hint5:		.asciiz		"Invalid input: Please input E, D, or X.\n"
hint6:		.asciiz		"\nGoodbye!"
input_str:	.space	100
key_str:	.space  100
res_str:	.space  100
command:	.space  10
Newline:	.asciiz		"\n"
		.text
__start:	
		li	$v0, 4		# syscall print welcome msg
		la	$a0, hint1
		syscall
oneturn:	la	$a0, prompt0	# prompt 0
		li	$a1, 0
		jal	give_prompt
		lb	$t1, ($v0)	# check if  quit
		beq	$t1, 'X', finish
		la	$a0, prompt1	# prompt 1
		li	$a1, 1
		jal	give_prompt
		la	$a0, prompt2	# prompt 2
		li	$a1, 2
		jal	give_prompt
		la	$a0, command	# perform ciper
		la	$a1, key_str
		la	$a2, input_str
		jal	ciper
		la	$a0, input_str
		la	$a1, res_str
		la	$a2, command
		jal	print_strings	# print strings
		b	oneturn
#--------------------------------------------------------------------
# print_strings
#
# Determines if user input is the encrypted or decrypted string in order
# to print accordingly. Prints encrypted string and decrypted string. See
# example output for more detail.
#
# arguments:  $a0 - address of user input string to be printed
#	      $a1 - address of the result string
#	      $a2 - address of E or D
# return:
#--------------------------------------------------------------------
print_strings:	li	$v0, 4
		move	$s1, $ra	# save info to static 
		move	$s0, $a0
		lb	$s7, ($a2)	# comand
		la	$a0, hint2
		syscall
		la	$a0, hint3
		syscall
		beq	$s7, 'E', print_E
print_D:	move	$a0, $s0
		syscall
		la	$a0, hint4
		syscall
		move	$a0, $a1
		syscall
		b     	print_end
print_E:	move	$a0, $a1
		syscall
		la	$a0, hint4
		syscall
		move	$a0, $s0
		syscall
print_end:	move	$ra, $s1
		jr	$ra
#--------------------------------------------------------------------
# give_prompt
#
# This function should print the string in $a0 to the user, store the user’s input in # an array, and return the address of that array in $v0. Use the prompt number in $a1 # to determine which array to store the user’s input in. ​Include error checking�? for # the first prompt to see if user input E, D, or X if not print error message and ask # again.
#
# arguments:  $a0 - address of string prompt to be printed to user
#		$a1 - prompt number (0, 1, or 2)
#		note:
#		prompt 0: Do you want to (E)ncrypt, (D)ecrypt, or e(X)it?
#		prompt 1: What is the key?
#		prompt 2: What is the string?	
#
# return:	$v0 - address of the corresponding user input data
#--------------------------------------------------------------------
give_prompt:	addi	$sp, $sp, -4
		sw	$ra, ($sp)
		move	$s1, $a1
		li	$v0, 4
		syscall
		beq	$s1, 0, prompt_cmd
		li	$v0, 8
		la	$a0, key_str
		li	$a1, 100
		beq	$s1, 1, prompt_key
		la	$a0, input_str
prompt_key:	syscall
		la	$v0, key_str
		beq	$s1, 1, prompt_end
		la	$v0, input_str
		b       prompt_end
prompt_cmd:	li	$v0, 8
		la	$a0, command
		li	$a1, 10
		syscall
		lb	$s1, command
		la   	$v0, command
		beq	$s1, 'E', prompt_end
		beq 	$s1, 'D', prompt_end
		beq	$s1, 'X', prompt_end
		li	$v0, 4
		la	$a0, hint5
		syscall
		la	$a0, prompt0
		syscall
		b  	prompt_cmd
prompt_end:	lw      $ra, ($sp)
		addi 	$sp, $sp, 4
		jr	$ra
#--------------------------------------------------------------------
# cipher
#
# Calls compute_checksum and encrypt or decrypt depending on if the user input E or
# D. The numerical key from compute_checksum is passed into either encrypt or decrypt
#
# note: this should call compute_checksum and then either encrypt or decrypt
#
# arguments:  $a0 - address of E or D character
#		$a1 - address of key string
#		$a2 - address fo user input string
#
# return:  $v0 - address of resulting encry
#--------------------------------------------------------------------
ciper:		addi	$sp, $sp, -16
		lb	$s7, ($a0)		# command
		sw	$s7, 12($sp)
		sw	$a1, 8($sp)
		sw	$a2, 4($sp)
		sw	$ra, 0($sp)
		move	$a0, $a1
		jal	compute_checksum
		move	$s1, $v0	# key sum
		lw	$s2, 4($sp)	# input string
		la	$s3, res_str	# result string
		lw	$s4, 12($sp)
ciper_do:	lb	$s5, ($s2)
		beq	$s5, $zero, ciper_return
		move	$a0, $s5
		move	$a1, $s1
		addi	$sp, $sp, -16
		sw	$s4, 12($sp)
		sw	$s1, 8($sp)
		sw	$s2, 4($sp)
		sw	$s3, 0($sp)
		beq	$s4, 'D', ciper_d
		jal	encrypt
		b       ciper_one
ciper_d:	jal	decrypt	
ciper_one:	lw	$s4, 12($sp)
		lw	$s1, 8($sp)
		lw	$s2, 4($sp)
		lw	$s3, 0($sp)
		addi	$sp, $sp, 16
		sb	$v0, ($s3)
		addi	$s2, $s2, 1
		addi 	$s3, $s3, 1
		b  	ciper_do
		
ciper_return:	sb	$zero, ($s3)	#add 0 at the end of the string
		la	$v0, res_str
		lw	$ra, 0($sp)
		addi	$sp, $sp, 16
		jr	$ra

#--------------------------------------------------------------------
# compute_checksum
#
# Computes the checksum by xor’ing each character in the key together. Then,
# use mod 26 in order to return a value between 0 and 25.
#
# arguments:  $a0 - address of key string
#
# return:     $v0 - numerical checksum result (value should be between 0 - 25)
#--------------------------------------------------------------------
compute_checksum:	
		lb	$t0, ($a0)
		addi	$a0, $a0, 1
check_loop:	lb	$t1, ($a0)
		beq	$t1, 10, checksum_mod
		xor	$t0, $t0, $t1
		addi	$a0, $a0, 1
		b 	check_loop
checksum_mod:	blt	$t0, 26, checksum_end
		addi	$t0, $t0, -26
		b 	checksum_mod	
checksum_end:	move	$v0, $t0
		jr	$ra
#--------------------------------------------------------------------
# check_ascii
#
# This checks if a character is an uppercase letter, lowercase letter, or
# not a letter at all. Returns 0, 1, or -1 for each case, respectively.
#
# arguments:  $a0 - character to check
#
# return:     $v0 - 0 if uppercase, 1 if lowercase, -1 if not letter
#--------------------------------------------------------------------
check_ascii:	bge	$a0, 'a', lowercase
		ble	$a0, 'Z', uppercase
		b       others
uppercase:	blt	$a0, 'A', others
		li	$v0, 0
		b 	check_ascii_end
lowercase:	bgt	$a0, 'z', others
		li	$v0, 1
		b  	check_ascii_end
others:		li	$v0, -1
check_ascii_end:jr	$ra	

#--------------------------------------------------------------------
# decrypt
#
# Uses a Caesar cipher to decrypt a character using the key returned from
# compute_checksum. This function should call check_ascii.
#
# arguments:  $a0 - character to decrypt
#             $a1 - checksum result
#
# return:     $v0 - decrypted character
#--------------------------------------------------------------------
decrypt:	addi	$sp, $sp, -12
		sw	$ra, 8($sp)
		sw	$a0, 4($sp)
		sw	$a1, 0($sp)
		jal	check_ascii		# check the char
		move	$t1, $v0
		lw	$a1, 0($sp)
		lw	$a0, 4($sp)
		blt	$t1, 0, decrypt_end
		sub	$a0, $a0, $a1
		beq	$t1, 0, decrypt_upper
decrypt_lower:  bge	$a0, 'a', decrypt_end
		addi	$a0, $a0, 26
		b     	decrypt_end
decrypt_upper:  bge	$a0, 'A', decrypt_end
		addi	$a0, $a0, 26
		b     	decrypt_end
decrypt_end:	move	$v0, $a0
		lw	$ra, 8($sp)
		addi	$sp, $sp, 12
		jr	$ra
#--------------------------------------------------------------------
# encrypt
#
# Uses a Caesar cipher to encrypt a character using the key returned from
# compute_checksum. This function should call check_ascii.
#
# arguments:  $a0 - character to encrypt
#             $a1 - checksum result
#
# return:     $v0 - encrypted character
#--------------------------------------------------------------------
encrypt:	addi	$sp, $sp, -12
		sw	$ra, 8($sp)
		sw	$a0, 4($sp)
		sw	$a1, 0($sp)
		jal	check_ascii		# check the char
		move	$t1, $v0
		lw	$a1, 0($sp)
		lw	$a0, 4($sp)
		blt	$t1, 0, encrypt_end
		add	$a0, $a0, $a1
		beq	$t1, 0, encrypt_upper
encrypt_lower:  ble	$a0, 'z', encrypt_end
		addi	$a0, $a0, -26
		b     	encrypt_end
encrypt_upper:  ble	$a0, 'Z', encrypt_end
		addi	$a0, $a0, -26
		b     	encrypt_end
encrypt_end:	lw	$ra, 8($sp)
		addi	$sp, $sp, 12
		move	$v0, $a0
		jr	$ra
		
		
finish:		la	$a0, hint6
		li	$v0, 4
		syscall
