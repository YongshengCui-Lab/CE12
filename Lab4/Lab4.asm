##########################################################################
# Created by:  Cui, Yongshheng
#              1491148
#              3 March 2019
#
# Assignment:  Lab 4: ASCII Conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
#
# Description: This program prints ¡®sum in base 4 by hex or denary or decimal to the screen.
#
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################
		.data
Msg0:		.asciiz		"You entered the numbers:\n"
Msg1:		.asciiz		"The sum in base 4 is:\n"
Spaces:		.asciiz		"  "
MinusStr:       .asciiz		"-"
Newline:		.asciiz		"\n"
		.text
__start:	
		li	$v0, 4		# syscall print string
		la	$a0, Msg0	# hint message
		syscall			#print the message
		lw  	$t1, ($a1)	# t1 save the first parameter
		move	$a0, $t1	# print first number
		syscall	
		la	$a0, Spaces	# print space
		syscall
		lw  	$t2, 4($a1)	# t2 save the second parameter
		move	$a0, $t2	# print second number
		syscall	
		la	$a0, Newline	# print new line
		syscall
		# get first  parameter
		la	$t6, first	# return address
		b	GetNumber
first:		move	$s1, $t4
		# get second parameter
		move	$t1, $t2
		la	$t6, second
		b       GetNumber
second:		move	$s2, $t4
		# find sum and print 
		add	$s0, $s1, $s2
		j	Output
####################################
# registers for parameter processing
# t1 - the parameter string address
# t0 - proc each char
# t3 - number for each char
# t4 - save the number result
# t5 - loop control
# t6 - return address
# ###################################
GetNumber:	lb	$t0, ($t1)	# save the string address
		li	$t4, 0		# save the number
		beq	$t0, '0', HexOxi
		li	$t5, 1		# sign
		bne	$t0, '-', Decimal
		li	$t5, -1
		add	$t1, $t1, 1
Decimal:	lb	$t0, ($t1)
		beq	$t0, 0, DecimalSign
		sub	$t0, $t0, '0'
		mul	$t4, $t4, 10
		add	$t4, $t4, $t0
		add	$t1, $t1, 1
		b 	Decimal
DecimalSign:    mul	$t4, $t4, $t5
		b	GetPara
HexOxi:		add	$t1, $t1, 1
		lb 	$t0, ($t1)
		beq	$t0, 'x', Hex
Oxi:		li	$t5, 8
OxiLoop:	add	$t1, $t1, 1
		lb 	$t0, ($t1)
		sub	$t0, $t0, '0'
		sll	$t4, $t4, 1
		or 	$t4, $t4, $t0
		sub 	$t5, $t5, 1
		bgt 	$t5, $zero,OxiLoop 
		b	IfMinus
Hex:		li 	$t5, 2		# loop two
HexLoop:	add	$t1, $t1, 1
		lb	$t0, ($t1)
		bgt	$t0, '9', Alpha
		sub	$t0, $t0, '0'
		b       procChar
Alpha:		sub	$t0, $t0, 55
procChar:	sll	$t4, $t4, 4
		or 	$t4, $t4, $t0
		sub	$t5, $t5, 1
		bgt 	$t5, $zero,HexLoop 	
IfMinus:	blt	$t4, 128, GetPara
		sub	$t4, $t4, 256
GetPara:	jr	$t6	

####################################
# registers for output
# t1 - shift contrl
# t2 - first valid output flag
# t3 - output for one digit
# ###################################
Output:		la 	$a0, Msg1		# print out hint msg
		syscall
		bge	$s0,$zero, printSum	#  check is the sum smaller than 0
		mul	$s0,$s0,-1		# change to positive
		la 	$a0, MinusStr		# print '-'
		syscall
printSum:	li	$t1, 32			# for srl 
		li	$v0, 11			# print char
		li	$t2, 0			# no valid digit
printLoop:	sub	$t1, $t1, 2
		srlv	$t3, $s0, $t1		# get one digit for base 4
		and   	$t3, $t3,3
		bne	$t2, $zero, printDigit  # derictly print after the first  digit
		beq	$t3, $zero, checkLoop	# if print
printDigit:	li	$a0, '0'		# print one digit
		li	$t2, 1
		add	$a0, $a0, $t3
		syscall
checkLoop:	bgt	$t1, $zero, printLoop
		beq	$t2, 1, finish
		li 	$a0, '0'
		syscall
finish:		li	$a0, '\n'
		syscall
